Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803AC345C49
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 11:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhCWKxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 06:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhCWKww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 06:52:52 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4E7C061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 03:52:52 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id h10so22855301edt.13
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 03:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vW/3Yo9KT7QQGbQfitG18K2PUralxTpWNJZ06XiIrII=;
        b=Bv25xEgWhoCxjDheQnCOSm9lRRK4zFu8/m6pylfvW9lX97HIHPTmf4zimJrjFSANVc
         ytONSaHz3qV1zWwT0yBuDev23+V4k1OjHHbrGS/lcRqjGPlw5C5vy4ORa3sMv6IK5Vmo
         YR1X5dL3tPY2YpkwANLX40YXolhVDUZ+3aBKlgXLn6DX1+Ozg5kEPCePQ9RYJ71atlid
         xmStCTiHiG+T0rRT05lD3yx5luNYPP05mTZvawxPHWnN9/LKeHeNmUZoAy5tpOV7AWGi
         zf2VnBzbIBkqjsf3XnH+8Ilr4JBfosDLbY6E8qmz9u8259QI91AQhtjGxNDxlWR9KuUr
         2jHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vW/3Yo9KT7QQGbQfitG18K2PUralxTpWNJZ06XiIrII=;
        b=I8Hx2lrnDEv4z1T74pdJ2i1NGuaSwQ++AqYZsEUCxnDm9gm+O3s7Fz6QD5SLOo9ci2
         D/ifTV8vOO2I/asOnvDhI8jMs+SlhNA45dkI2zjnOlTKZhCT4x5JoZT4PefIi71D7mRZ
         KG46TANngBViQFekmzQ/ABw+Sx6IsjKH0fxO/vrlsOTOHMbF9ybL2eqDS2i9WWpORwZe
         +ERJ0XFL1A05z9Made8BJj4VOtVX/qFIIZFIU5X7MyodZf+gA8PEJLQ4tmpatGimfNnM
         Yx7CNjYqwslHQIgntZ3tL+9d73zAzWGPXUvgJ1A327H4e4qtUEd2nPXrkVt2Mjf3GHFL
         EP5Q==
X-Gm-Message-State: AOAM533OiQaF2puswu1N8Gf/UpIwgEPJjzV3kfQGACH5Fhu26EYBjevM
        iEqFxcEokurat8TRLQ4ojjZrTcvLgGw=
X-Google-Smtp-Source: ABdhPJxYn2FUWx2511+0Zw8Evdl628nriWALr3gwBdcn5qUOAVIKQr5msneNbQi49ZM5jSUWZIrp9Q==
X-Received: by 2002:aa7:d1cd:: with SMTP id g13mr3909511edp.369.1616496770811;
        Tue, 23 Mar 2021 03:52:50 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id l18sm11003850ejk.86.2021.03.23.03.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 03:52:50 -0700 (PDT)
Date:   Tue, 23 Mar 2021 12:52:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 0/8] net: dsa: mv88e6xxx: Offload bridge port
 flags
Message-ID: <20210323105249.vf5nmagufqnfpyh7@skbuf>
References: <20210318192540.895062-1-tobias@waldekranz.com>
 <87im5im9n4.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87im5im9n4.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 11:45:03AM +0100, Tobias Waldekranz wrote:
> On Thu, Mar 18, 2021 at 20:25, Tobias Waldekranz <tobias@waldekranz.com> wrote:
> > Add support for offloading learning and broadcast flooding flags. With
> > this in place, mv88e6xx supports offloading of all bridge port flags
> > that are currently supported by the bridge.
> >
> > Broadcast flooding is somewhat awkward to control as there is no
> > per-port bit for this like there is for unknown unicast and unknown
> > multicast. Instead we have to update the ATU entry for the broadcast
> > address for all currently used FIDs.
> >
> > v2 -> v3:
> >   - Only return a netdev from dsa_port_to_bridge_port if the port is
> >     currently bridged (Vladimir & Florian)
> >
> > v1 -> v2:
> >   - Ensure that mv88e6xxx_vtu_get handles VID 0 (Vladimir)
> >   - Fixed off-by-one in mv88e6xxx_port_set_assoc_vector (Vladimir)
> >   - Fast age all entries on port when disabling learning (Vladimir)
> >   - Correctly detect bridge flags on LAG ports (Vladimir)
> >
> > Tobias Waldekranz (8):
> >   net: dsa: Add helper to resolve bridge port from DSA port
> >   net: dsa: mv88e6xxx: Avoid useless attempts to fast-age LAGs
> >   net: dsa: mv88e6xxx: Provide generic VTU iterator
> >   net: dsa: mv88e6xxx: Remove some bureaucracy around querying the VTU
> >   net: dsa: mv88e6xxx: Use standard helper for broadcast address
> >   net: dsa: mv88e6xxx: Flood all traffic classes on standalone ports
> >   net: dsa: mv88e6xxx: Offload bridge learning flag
> >   net: dsa: mv88e6xxx: Offload bridge broadcast flooding flag
> >
> >  drivers/net/dsa/mv88e6xxx/chip.c | 270 ++++++++++++++++++++++---------
> >  drivers/net/dsa/mv88e6xxx/port.c |  21 +++
> >  drivers/net/dsa/mv88e6xxx/port.h |   2 +
> >  include/net/dsa.h                |  14 ++
> >  net/dsa/dsa_priv.h               |  14 +-
> >  5 files changed, 232 insertions(+), 89 deletions(-)
> >
> > -- 
> > 2.25.1
> 
> Jakub/Dave, is anything blocking this series from going in? I am unable
> to find the series on patchwork, is that why?

Tobias, the series went in:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=d7417ee918582504076ec1a74dfcd5fe1f55696c

I'm not sure why the patchwork bot didn't go "deet-doot-dot, I am a bot"
on us.
