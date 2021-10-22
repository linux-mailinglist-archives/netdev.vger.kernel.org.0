Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9EA437C65
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhJVSDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbhJVSDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 14:03:14 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13986C061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 11:00:57 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id ec8so4684262edb.6
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 11:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5pkW5lcLZcXID6UT1fXQnxupeGqAGQ+6dUXEtzTlTB4=;
        b=l89j0FJBpv04W7NAzlvw0hjg0Cl7jgScz7XzT5S9TVBdgd8HAWlwYoiVdzhy28iy5U
         9MjXiFbAyWMLRmaPoOf+clakSpQH/DRnGtPJkdApEIJ8oPVI6esyuHfkVzbfnIL1El3Q
         t88dD/jA0Hpq9gb6b1mJpLdyEJ+CENlBGGqUej5FGsLC430O6fiZqnGXfxyh4pm0tVc1
         vdNIjoGjocU4Lo1KQCNrYkoq2QGyePwxZAYzL7YeslfSsDvb3omXbLk/Q1DQyDVT++ik
         GAUjrVuFOdSn3tqN5QnaVHnqIWtWNtq3+xAPaJ8Bd2gNAKWvPfbZzIsiogJyFGCw8ZJ3
         xz/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5pkW5lcLZcXID6UT1fXQnxupeGqAGQ+6dUXEtzTlTB4=;
        b=gF/amjFqPFGn2+ZgOazclzmZAGAaXZtkYEtzMp+u6ViD4ZvXdPKOqYxM5XZaRMrmsP
         iN/tfZQ300eQbZEf/qoWc7Wcna+lrInCr7bIH3EMTIMKWMESlTLjR5HNUV2ns0Ahyb24
         U+Faz5jeofQIBp3GxvaVZR9abxWFtY1roj1GtzQpPpCK0qzy1xbiZwInV7sSN+vvn4yN
         YZhbRV14GywdUUzqYiL3FIcF1DolvHeMDZpBK7vA36f6iCpLbsouaxKdn+iVb9XImLpA
         twc0o65vNdeq/vu/VejbQMpmI62wCjUDSE9PPH3qxaHA4btivmFK9aIaCnDPg4WOB+Ei
         ZCOQ==
X-Gm-Message-State: AOAM533BECEactFlB7Kvr4JOvqjPU1AnhCb393peZ1pz3fcqfOAJiKeV
        uFHz0qyURFTOuDmNwRKVqX8=
X-Google-Smtp-Source: ABdhPJy2zyevuNGYJvTN0H0mLX7D6WhxATw3l58i54eO2vCnxotLyO4Rd9/cEi8tvEaXSoEzwQMOtQ==
X-Received: by 2002:aa7:cd99:: with SMTP id x25mr1968715edv.266.1634925655568;
        Fri, 22 Oct 2021 11:00:55 -0700 (PDT)
Received: from skbuf ([188.25.174.251])
        by smtp.gmail.com with ESMTPSA id h10sm4890656edk.41.2021.10.22.11.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 11:00:55 -0700 (PDT)
Date:   Fri, 22 Oct 2021 21:00:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH v3 net-next 3/9] net: mscc: ocelot: serialize access to
 the MAC table
Message-ID: <20211022180052.5dqafsdv7sa2bckw@skbuf>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
 <20211022172728.2379321-4-vladimir.oltean@nxp.com>
 <9628072d-612a-ec6f-ce18-03c7f95ad5dd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9628072d-612a-ec6f-ce18-03c7f95ad5dd@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 10:34:04AM -0700, Florian Fainelli wrote:
> On 10/22/21 10:27 AM, Vladimir Oltean wrote:
> > DSA would like to remove the rtnl_lock from its
> > SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handlers, and the felix driver uses
> > the same MAC table functions as ocelot.
> > 
> > This means that the MAC table functions will no longer be implicitly
> > serialized with respect to each other by the rtnl_mutex, we need to add
> > a dedicated lock in ocelot for the non-atomic operations of selecting a
> > MAC table row, reading/writing what we want and polling for completion.
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/net/ethernet/mscc/ocelot.c | 53 +++++++++++++++++++++++-------
> >  include/soc/mscc/ocelot.h          |  3 ++
> >  2 files changed, 44 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> > index 4e5ae687d2e2..72925529b27c 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.c
> > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > @@ -20,11 +20,13 @@ struct ocelot_mact_entry {
> >  	enum macaccess_entry_type type;
> >  };
> >  
> > +/* Must be called with &ocelot->mact_lock held */
> 
> I don't know if the sparse annotations: __must_hold() would work here,
> but if they do, they serve as both comment and static verification,
> might as well use them?

I've never come across that annotation before, thanks.
I'll fix this and the other issue and resend once the build tests for
this series finish.
