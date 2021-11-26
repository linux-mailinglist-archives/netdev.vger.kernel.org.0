Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEA445E6E0
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 05:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358656AbhKZEff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 23:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346082AbhKZEde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 23:33:34 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246BFC061D63
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 20:14:23 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id r8so15743099wra.7
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 20:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=On8Irc3ZfroCCtSKiuzz/C7WH9ybdA/Lw5tdvj6j1zo=;
        b=btIZurEONRDL1X8WLL4KH2v1sWw/gblky5MBO7H8VHtGvH4PwEcse/jk8uAFNlSJV9
         +abx1190XP6jitCZGw1dA32JWZpuG6kfDA5SxtX+wEoVMYuIl3hVRSMR9/seH+ERdCRM
         m1NKenBdBcjaowNaBqNFfwpHaXX9sUooH1Vd0HdRguI0DyamiKP6cu48ngSf+fdQJIec
         cM1tswnIFi0hfx2qju2aIchpDVLEgsFuQM2FdIsDIp+NgErfYROPY43yJj8V/vBH9XVT
         Gfc+ItmAalq+yVCAyM1tamZ6P4xrOx6joBdTS2pmbd9uzmxeX86kCVTMoS9IFITUVj+N
         URCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=On8Irc3ZfroCCtSKiuzz/C7WH9ybdA/Lw5tdvj6j1zo=;
        b=WFlFDNmrsg+XM7uFqoVc1ZCEFwXzmziGfTskfzRY2nwDuoM70ERrQF2puWPWZ07Lrd
         hsrfSivWnQsKlGbuT5jTUyR/V1TONhcSVIGmt2g67c20KEgVsefKDTlpV1rttsoaByio
         zAWmKATmc5NVbr4IkE45O2UmDNVjeLYd2bfOm0UFwse5RvT1NluZYVHzx/Z21G2yaLO9
         By3omRYkfPk0d2X+/GTpTj6IZXnBz5etWy5yrj1a5O8qgvsjr/N6ToGq6SCVKIXS2tD4
         JnSkZ2PG79eUgDpyzrwiCdVeerYyM/J4JrAIkvRXj0tqzvHL9nyYNLpF670M65gec8rG
         vJPQ==
X-Gm-Message-State: AOAM533dbL+Ymq77/UCeybhPzqpgq3nuC3vWO1skI5Z2KUINIC5BDIOb
        DNF8QWtquyA/rA1yZNENvha+8MZ8jnfrw+BRwsWjyeNGKtw=
X-Google-Smtp-Source: ABdhPJwk7zx4JpS/rLMXAe0AyNGoiBDJaek3lvXXgv4DcX9rM0+FNJ97tRODvPjaxpNa04JztMXnnFDSm4rjGFcjJdw=
X-Received: by 2002:a5d:6785:: with SMTP id v5mr11565282wru.380.1637900061613;
 Thu, 25 Nov 2021 20:14:21 -0800 (PST)
MIME-Version: 1.0
References: <20211125021822.6236-1-radhac@marvell.com> <CAC8NTUX1-p24ZBGvwa7YcYQ_G+A_kn3f_GeTofKhO7ELB2bn8g@mail.gmail.com>
 <20211124192710.438657ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAC8NTUUdZSuNtjczBvEZPaAbzaP4rWyR9fDOWC9mdMHEqiEVNw@mail.gmail.com>
 <20211125070812.1432d2ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <BY3PR18MB47374C791CA6CA0E3CB4C528C6639@BY3PR18MB4737.namprd18.prod.outlook.com>
In-Reply-To: <BY3PR18MB47374C791CA6CA0E3CB4C528C6639@BY3PR18MB4737.namprd18.prod.outlook.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Fri, 26 Nov 2021 09:44:10 +0530
Message-ID: <CA+sq2CdrO-Zsf5zAj9UbAqVpKdbxeP+QoDAJ6dK2hwDmmuQQ8A@mail.gmail.com>
Subject: Re: Fw: [EXT] Re: [PATCH] octeontx2-nicvf: Add netdev interface
 support for SDP VF devices
To:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> ________________________________
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, November 25, 2021 8:38 PM
> To: Radha Mohan <mohun106@gmail.com>
> Cc: netdev@vger.kernel.org <netdev@vger.kernel.org>; David S. Miller <davem@davemloft.net>; Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Subject: [EXT] Re: [PATCH] octeontx2-nicvf: Add netdev interface support for SDP VF devices
>
> External Email
>
> ----------------------------------------------------------------------
> On Wed, 24 Nov 2021 22:00:49 -0800 Radha Mohan wrote:
> > On Wed, Nov 24, 2021 at 7:27 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Wed, 24 Nov 2021 18:21:04 -0800 Radha Mohan wrote:
> > > > This patch adds netdev interface for SDP VFs. This interface can be used
> > > > to communicate with a host over PCIe when OcteonTx is in PCIe Endpoint
> > > > mode.
> > >
> > > All your SDP/SDK/management interfaces do not fit into our netdev
> > > model of the world and should be removed upstream.
> >
> > SDP is our System DMA Packet Interface which sends/receives network
> > packets to NIX block. It is similar to CGX, LBK blocks but only
> > difference is the medium being PCIe. So if you have accepted that I
> > believe you can accept this as well.
>
> Nope, I have not accepted that. I was just too lazy to send a revert
> after it was merged.

What is the objection here ?
Is kernel netdev not supposed to be used with-in end-point ?
If customers want to use upstream kernel with-in endpoint and not
proprietary SDK, why to impose restrictions.

Thanks,
Sunil.
