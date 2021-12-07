Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C1946BF65
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbhLGPhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhLGPhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:37:32 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEC3C061574;
        Tue,  7 Dec 2021 07:34:01 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id x6so58391630edr.5;
        Tue, 07 Dec 2021 07:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=77FvMUeT/QXm1MM7jzidpCG1GqvPRk7vjmcCy3A7YMg=;
        b=o/34asWcopDwR1Xwxbt9pgrwwDd6RevowQ6RMRjsBqY0UN7OnGpVcDi05AxQSsdDUX
         3SUzXm9n0nOZ2fCdU67tSJixvpDa9iXA1mAs/gfH4iASxU4mDhRnthPhRjSx0IYuqA56
         2lfo+xujN/aU3vtoKKwHwYSNH+pXBTDPCeJXxUPVEMVg+B7VGUIp5tZQC9hkXgC4kpCo
         vXMokbvNQ2GDOvuUGnrrK2H9FrUB70Hqj/hxthyUIJz8ByXDTx3Qna7zU91IClQW3uil
         MLXUTVMLN1l1L5JfTSCNZA3R6yQ0RPwRQllrkDlQ6jGvs1iAQr3nb1Nev6p5ES4YEaED
         Bjng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=77FvMUeT/QXm1MM7jzidpCG1GqvPRk7vjmcCy3A7YMg=;
        b=Mur+aYnl3JoJVi+kf9XKjyvJhpRql709pZ+HgA0eeJp7+sHKLsls2BHv7ewhq+uvIN
         7myQaTbQO8D7JO3kihSmdKKzkfx4gFBbInHWjBqTVgmp5xLEgybc622z/KNiNYMupOp6
         +vCM5ar3NhpsoLIRFDCLhVbHY9DeUmX61aZFnmIbktKvCxnGaEQrAyiEx1qmgMLenfTc
         2ku/Fz1OBcXLWQa45DVLsb/BMibROejKLVyb4bFAMGT2bQOjp3u522Dk/Pv+W383RTCU
         Pxk110aQBQgHb+LjMX18nhftqnjizsUTWVMEEnyknq08bh6m+15vgbS/uG73BY8tQOgv
         Q3/w==
X-Gm-Message-State: AOAM530s6Mfo5lawMh8GaBKPby7QtAvBIwLJ2h06UJrOsKt7yUVTdhEt
        GYhHOCgSZmlI+mO0NOdNQeM=
X-Google-Smtp-Source: ABdhPJxCa2V5Le7pncAArCi+CYBaA/Ap02r+c6AuuFP0eyy38pty4gzgj/BXQhdZuRqFaR69oZWLTA==
X-Received: by 2002:a17:906:8256:: with SMTP id f22mr104522ejx.207.1638891239986;
        Tue, 07 Dec 2021 07:33:59 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id ho17sm8884053ejc.111.2021.12.07.07.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 07:33:59 -0800 (PST)
Message-ID: <61af7ee7.1c69fb81.2b3ba.d48b@mx.google.com>
X-Google-Original-Message-ID: <Ya9+5TXcyqkf+M1g@Ansuel-xps.>
Date:   Tue, 7 Dec 2021 16:33:57 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya96pwC1KKZDO9et@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya96pwC1KKZDO9et@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 04:15:51PM +0100, Andrew Lunn wrote:
> On Tue, Dec 07, 2021 at 03:59:36PM +0100, Ansuel Smith wrote:
> > Hi, this is still WIP and currently has some problem but I would love if
> > someone can give this a superficial review and answer to some problem
> > with this.
> > 
> > The main reason for this is that we notice some routing problem in the
> > switch and it seems assisted learning is needed. Considering mdio is
> > quite slow due to the indirect write using this Ethernet alternative way
> > seems to be quicker.
> > 
> > The qca8k switch supports a special way to pass mdio read/write request
> > using specially crafted Ethernet packet.
> 
> Oh! Cool! Marvell has this as well, and i suspect a few others. It is
> something i've wanted to work on for a long long time, but never had
> the opportunity.
>

Really? I tought this was very specific to qca8k.

> This also means that, even if you are focusing on qca8k, please try to
> think what could be generic, and what should specific to the
> qca8k. The idea of sending an Ethernet frame and sometime later
> receiving a reply should be generic and usable for other DSA
> drivers. The contents of those frames needs to be driver specific.
> How we hook this into MDIO might also be generic, maybe.

A generic implementation of this would be add an ops to the dsa generic
struct that driver can implement and find a clean way to use this
alternative way instead of normal mdio. (Implement something like
eth_mdio_read/write ops and the driver will decide when to use them?
The dsa then will correctly understand when the driver is ready to
accept packet and send the skb, in all the other case just send an error
and the driver will use normal mdio?)

I think the tagger require some modification anyway as it's the one that
receive packet and parse them. (I assume also other switch will use the
tagger to understand that the packet is used for mdio)
(A bool to declare that the tagger can correctly parse this kind of
stuff and complete the completion?)

> 
> I will look at your questions later, but soon.
> 

Thanks a lot for the quick response. I'm more than happy to generalize
this and find the a correct way.

>   Andrew

-- 
	Ansuel
