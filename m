Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA433DD670
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhHBNHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbhHBNHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:07:37 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF49C06175F;
        Mon,  2 Aug 2021 06:07:26 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x14so24363386edr.12;
        Mon, 02 Aug 2021 06:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+SZbqu2OmCriIcHluisGz9iJ+oJzkAqrwEFMwLWTqRc=;
        b=E48DER1OVUNlNN3AbK4cr/kyuJ+wfrZG9rqkLywltAeZxLroU/5TeEUkLEu96fsr1m
         oVGOmUS/SyZ18O20SPsgHEmuAxgyiHgAZuHEYbYwLNvSkjctNp7iqBk5VYhOxw7iDMtc
         OLh3jYO6kwmAd3gKoOVx1ORY5YPWE/23AtjHWFn1H+7dW6vntL2CIy2osXyKZW5f8QUF
         uc/gD3kx+rS0jAWqGRYV6EGlM/es/kB19OSorwE9E2JtyXs1OKV4U332y2EnsU2ryq1v
         I2fe512h1Sf6SVpXZ+T042Ae7py3SHuCdN9CBpj5KDWnOHjMuarnQy1O0EbtC4knR07P
         BVoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+SZbqu2OmCriIcHluisGz9iJ+oJzkAqrwEFMwLWTqRc=;
        b=CydckpFJJDXqDES5BiRxylXGKzbcCFRnBdgv3uahgnXOZJ+iU+MaPna+5Zn3F15c0I
         KN2qnTte6Yd/nCC+9jm+E8C5bzmCHI/6WPyeZO9Onsiz1dtUv2sfK+8mdgjfSWU8VHZK
         UZ/7W1Ypym+ClxaadeWoHpMkDz7gIK1XqURZPkKrqhTNjoAp/qXOABdgpz3+ewEvjWvy
         e9nHiyIibFP1U9LiPXoQ82uyhNTe7g5CNJFWssMHXmqD5iHCWNPkMpHc8Plrm6ejzpN+
         fxXreodf1Ho5P4wrlMO4zqp+/hKq/96vkRPlHE1TWSd2KBRip6e2LwJymqt5IVwqKS6i
         EzrQ==
X-Gm-Message-State: AOAM533aPiOYYRnCIFQtVonMosEEcH0bmTV7KzIcNelNTGYccv/I8yqq
        TqmXB1ev0EForSRkpXOWuzk=
X-Google-Smtp-Source: ABdhPJwDkLl+kIN1bl2f4Yw908yzO51fxWKV8HGdwOTC8AgxomlATrgugCeUjm/XBi03A5mFYLG+eA==
X-Received: by 2002:aa7:d296:: with SMTP id w22mr19096988edq.170.1627909645224;
        Mon, 02 Aug 2021 06:07:25 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id o3sm5969539edt.61.2021.08.02.06.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 06:07:24 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:07:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Woudstra <ericwouds@gmail.com>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [RFC net-next v2 1/4] net: dsa: mt7530: enable assisted learning
 on CPU port
Message-ID: <20210802130723.6tieexl5zcxu44xr@skbuf>
References: <20210731191023.1329446-1-dqfext@gmail.com>
 <20210731191023.1329446-2-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210731191023.1329446-2-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 01, 2021 at 03:10:19AM +0800, DENG Qingfang wrote:
> Consider the following bridge configuration, where bond0 is not
> offloaded:
> 
>          +-- br0 --+
>         / /   |     \
>        / /    |      \
>       /  |    |     bond0
>      /   |    |     /   \
>    swp0 swp1 swp2 swp3 swp4
>      .        .       .
>      .        .       .
>      A        B       C
> 
> Address learning is enabled on offloaded ports (swp0~2) and the CPU
> port, so when client A sends a packet to C, the following will happen:
> 
> 1. The switch learns that client A can be reached at swp0.
> 2. The switch probably already knows that client C can be reached at the
>    CPU port, so it forwards the packet to the CPU.
> 3. The bridge core knows client C can be reached at bond0, so it
>    forwards the packet back to the switch.
> 4. The switch learns that client A can be reached at the CPU port.
> 5. The switch forwards the packet to either swp3 or swp4, according to
>    the packet's tag.
> 
> That makes client A's MAC address flap between swp0 and the CPU port. If
> client B sends a packet to A, it is possible that the packet is
> forwarded to the CPU. With offload_fwd_mark = 1, the bridge core won't
> forward it back to the switch, resulting in packet loss.
> 
> As we have the assisted_learning_on_cpu_port in DSA core now, enable
> that and disable hardware learning on the CPU port.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <oltean@gmail.com>
