Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822DB3DF3A8
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237766AbhHCRNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237557AbhHCRNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 13:13:42 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFFDC061757;
        Tue,  3 Aug 2021 10:13:31 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id z3so23195065plg.8;
        Tue, 03 Aug 2021 10:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=I2bXUkEd46pGN/p5HEpGGRY38cwwH6dqSDlTkP0Mz2M=;
        b=BFDaeMPkkK0eR0sqJZXh0E4uRJBT44zfNMC7MCxZMHhM/7hx6jZF5uellllfEdV8dA
         /b380csIpzQpsxS+euUgDDvqoUXOguS4+exPBwbdRagcrl7o69V20/fwk56s7lveAb7j
         Qfp+KeH0c8L8TSmm0sHwNNmGLSNBu7jSSvdQXecR+fFbrGOa4LJUKt4Zs5W/jBKMXLZJ
         ktUMHvLC9Z+xveQvvUPVyy4Pt9oS++/FBN1Y4YlXCl+jGXfXb7ZzLo4ePxCYkHQBWJrq
         X/Yy/df/X3GbMgeWCb7mes5S+5/6gVGMN/UZRyCMw64i5IUrgBPLsD9urmVW1gt/nT9A
         4Tnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=I2bXUkEd46pGN/p5HEpGGRY38cwwH6dqSDlTkP0Mz2M=;
        b=WgKz8qqoMcscuSB+P39ifNjqWRSyN++aV7OpzkRbXwf6WkGD4q5MZ23jSuxjIJbZ18
         LDZz9QsxpkV4JHjH9SY2KG8MUuH29CuVGroIs/cMYhaym8ytMim/Enb1ap0Zys0ePXw3
         gh26twwy1nSywYRz3kbdXD4pb3e6S7ulwMuy+pqm/ZPLlLs6rJMMONI9h8LD4gEvbTCj
         nakHpb/bXrd3vFDhqXWy29/08WiGifveMWeYLvDT4J9ZygauWO1YKluoP0xJXl4Xh9p/
         Tj8B/i+fD3hInGqPYXa11DXCu96NRgMmheL8gsSi+SaOMTMv4xoWrCQemwQPHgRxNBB9
         poXQ==
X-Gm-Message-State: AOAM533EoSfCamMrheHnW3BS76UQb7Z9nefqZhiKqxSHy7lS3LZVBRqY
        lIZEk6Aw29f0qAzFM+RIL9Y=
X-Google-Smtp-Source: ABdhPJwszazw7EW7d5bx/e6FqZLMf1EUKjtsldaoh66ru2HcCmV6kqtSiDkeqgSct6YLp8CN2vgnbA==
X-Received: by 2002:a17:90a:73c6:: with SMTP id n6mr1822080pjk.128.1628010811229;
        Tue, 03 Aug 2021 10:13:31 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id c136sm15983532pfc.53.2021.08.03.10.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 10:13:30 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
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
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: Re: [PATCH net-next v2 2/4] net: dsa: mt7530: use independent VLAN learning on VLAN-unaware bridges
Date:   Wed,  4 Aug 2021 01:13:21 +0800
Message-Id: <20210803171321.3026041-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803164853.gxw4zfxmmgs2kgry@skbuf>
References: <20210803160405.3025624-1-dqfext@gmail.com> <20210803160405.3025624-3-dqfext@gmail.com> <20210803164853.gxw4zfxmmgs2kgry@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 07:48:53PM +0300, Vladimir Oltean wrote:
> After this patch set gets merged, can you also please take a look at the
> following:
> 
> Documentation/networking/switchdev.rst says:
> 
> When the bridge has VLAN filtering enabled and a PVID is not configured on the
> ingress port, untagged and 802.1p tagged packets must be dropped. When the bridge
> has VLAN filtering enabled and a PVID exists on the ingress port, untagged and
> priority-tagged packets must be accepted and forwarded according to the
> bridge's port membership of the PVID VLAN. When the bridge has VLAN filtering
> disabled, the presence/lack of a PVID should not influence the packet
> forwarding decision.
> 
> I'm not sure if this happens or not with mt7530, since the driver
> attempts to change the pvid back to 0. You are not changing this
> behavior in this series, so no reason to deal with it as part of it.
> 

There is PVC.ACC_FRM which controls the acceptable frame type.
Currently the driver does not use it, so untagged and priority-tagged frames
can get into a VLAN-aware port without a PVID.
