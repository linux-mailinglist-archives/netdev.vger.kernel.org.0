Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944913DBD05
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 18:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhG3QYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 12:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhG3QYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 12:24:13 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48325C06175F;
        Fri, 30 Jul 2021 09:24:07 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id x90so13935943ede.8;
        Fri, 30 Jul 2021 09:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v5PtflUOMFCz8VFrpVreqK0QkFZ0DCmbVl+BetEIMLA=;
        b=cx88dZsM/gESTquoQdw282H1eLFTucH+6Tjr9ymA9x5y/o/3+r15SBQpKO+zilfmmP
         9dz9Bo2yeYbD+3gsxy8toxmJMuuD7qn43TiQ3r+xOk1IIdSoSByqPaoidcvoXhaeXT1F
         jUpSk7XB6yMSGVvefwl7HyDsRhl3FukxyR9ksZz7NEXyHW4FueOjd+SzGOEXpz/LxO8f
         NqE66HK4Ghkwlai7pVgn1Y+1Z758a1pj5+ee6M31K2Oo61DodXaUFKd4AjUuE3SQGd8I
         OObBXhXHluZbgtRyoek1h6MBnehYhKbnj9GeCAL9iDGHPLC3mkL++4juKnNGn5ORgIpX
         A5OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v5PtflUOMFCz8VFrpVreqK0QkFZ0DCmbVl+BetEIMLA=;
        b=WHQ2NPEkuPETRMFQnGZIx6CTETAXLLOuedTwT6GfteubHlS3tN2rEgPlz8+ZJqt2KA
         YMzmFxudq312h/NCkems1ck8gJosuxVbGL7RIzp76eH0wJbZypsuk6ynCQW3nrEvcHlH
         HhKkFISqi7UeA5qG3piwTGz4vr58cpYOqn1uL9gbvVCLtqAxlelUNHWzfhNFp1w69sB6
         ydQwqvTXnEwHdO+6AtlZewrTKOqXIJ61FFqGOPzzFyU0Z+LThmpcpDXIZYo88/5Y1i5m
         x+ofhcW5aLxzYURRx+yjoPWpzk4/F5ENb5EBblYIR56y+d1DZW2RtBQsJY5jJPV890o9
         7i7g==
X-Gm-Message-State: AOAM5327uC65NKRpAmaqyAWCMU4/DcTwhXDera4kqVAERiN+r8cSzohq
        B3aEKzMmZZKov5iDe0ENQ3k=
X-Google-Smtp-Source: ABdhPJweLORroV9hhMblkUOnSMbOxS8yH/JDLiFxs2LDuTbNnKpwpXAHnRkrTXKkthWxAW+5/EAUkw==
X-Received: by 2002:aa7:c98f:: with SMTP id c15mr19553edt.286.1627662245837;
        Fri, 30 Jul 2021 09:24:05 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id gu2sm715595ejb.96.2021.07.30.09.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 09:24:05 -0700 (PDT)
Date:   Fri, 30 Jul 2021 19:24:03 +0300
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
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 1/2] net: dsa: tag_mtk: skip address learning on
 transmit to standalone ports
Message-ID: <20210730162403.p2dnwvwwgsxttomg@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com>
 <20210728175327.1150120-2-dqfext@gmail.com>
 <20210728183705.4gea64qlbe64kkpl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728183705.4gea64qlbe64kkpl@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 09:37:05PM +0300, Vladimir Oltean wrote:
> Otherwise this is as correct as can be without implementing TX
> forwarding offload for the bridge (which you've explained why it doesn't
> map 1:1 with what your hw can do). But just because a port is under a bridge
> doesn't mean that the only packets it sends belong to that bridge. Think
> AF_PACKET sockets, PTP etc. The bridge also has a no_linklocal_learn
> option that maybe should be taken into consideration for drivers that
> can do something meaningful about it. Anyway, food for thought.

Considering that you also have the option of setting
ds->assisted_learning_on_cpu_port = true and this will have less false
positives, what are the reasons why you did not choose that approach?
