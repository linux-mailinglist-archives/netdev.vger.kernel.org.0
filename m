Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3254A6727
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 22:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbiBAVjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 16:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbiBAVjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 16:39:42 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83158C061714;
        Tue,  1 Feb 2022 13:39:42 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id j2so57661957ejk.6;
        Tue, 01 Feb 2022 13:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M0IuJCUW9ulwEp1rcd39XLnhCaz0ycJXjHX1717expM=;
        b=dH7zbxa8meA6sokbEmvRdqpOz0IHCg3HApCJszDPuEClpRfbpIPiO+cu3W0uavcJCf
         rPV6Ah0OIiPFUHl1dT5Cgw5s68xrLPECX6zvv9QqLH+BHaRIBBzSocTEcpT2Ik3l69YH
         1CKCB5t2AYRbEvzEnAJGUZ7D3uKC6svrpOpUEoNCG6o3NA4RdqiKR6EPnjBKypUc3Cg2
         4s+36QTZjw32PEIiiun1hHN8DPdiIZh8AMZruom/0Z3thL82q8a2T4uZ+YhKzjdevEp2
         7a1RIt96812P+YdE/D/zE5olf/M7vbsHYNdsjvZFaouqb6AlkA+mKODkDnns25d3DEtC
         oLiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M0IuJCUW9ulwEp1rcd39XLnhCaz0ycJXjHX1717expM=;
        b=mFUpljkgUghDnz2/hKjZYNtTwIsBCMhJcmpJM857y2b4zuTp18KxDsdIPOozH62T/g
         6N3LDgHfAxFUEigXvNa48UpuWrnH06NelQb9VKw5xg3HgF9aoL2L0HhjbAXJHTSCWEEJ
         EVGuC3OX55n35B1ea6L5vPKD9gG1Vmgw+SrZftDPEpw1bVQNrL/Lxsbfg1Z02Q9mB6M7
         kfY6vn1pN0MSbkuxxH2IwlhwhVm8Crsj/peKXhHoHCw+eNq0ygQXA9iX8J+cpNTZYUon
         zCxu8W1rfv8X86tOtN1ri740n4txdF/7f2M8BH/e6SusSJHtWFZHlyudT/r3NRF8RO6m
         tmBQ==
X-Gm-Message-State: AOAM530I1I5bcYtPUJokjlQRJW0XmDGjYGxGvtwnphne9c7ldFEZovDn
        lqMpdIa6qLylY+pt+KDaSIw=
X-Google-Smtp-Source: ABdhPJwilTMnhzEnE0dcIKwAd0ymp+SjxK6pa7ir9/DQyZJzK0BLIJamkxy30AcRaKVMLIaKuz6wzg==
X-Received: by 2002:a17:906:eb8a:: with SMTP id mh10mr19729357ejb.492.1643751580701;
        Tue, 01 Feb 2022 13:39:40 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id w27sm15178139ejb.90.2022.02.01.13.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 13:39:40 -0800 (PST)
Date:   Tue, 1 Feb 2022 22:39:39 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 13/16] net: dsa: qca8k: move page cache to driver
 priv
Message-ID: <YfmomwMfRLe5t0nf@Ansuel-xps.localdomain>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-14-ansuelsmth@gmail.com>
 <5571e217-b850-6c50-468b-a226c328f41a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5571e217-b850-6c50-468b-a226c328f41a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 07:50:47PM -0800, Florian Fainelli wrote:
> 
> 
> On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> > There can be multiple qca8k switch on the same system. Move the static
> > qca8k_current_page to qca8k_priv and make it specific for each switch.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >   drivers/net/dsa/qca8k.c | 47 +++++++++++++++++++++++------------------
> >   drivers/net/dsa/qca8k.h |  9 ++++++++
> >   2 files changed, 36 insertions(+), 20 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index e7bc0770bae9..c2f5414033d8 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -75,12 +75,6 @@ static const struct qca8k_mib_desc ar8327_mib[] = {
> >   	MIB_DESC(1, 0xac, "TXUnicast"),
> >   };
> > -/* The 32bit switch registers are accessed indirectly. To achieve this we need
> > - * to set the page of the register. Track the last page that was set to reduce
> > - * mdio writes
> > - */
> > -static u16 qca8k_current_page = 0xffff;
> > -
> >   static void
> >   qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
> >   {
> > @@ -134,11 +128,11 @@ qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
> >   }
> >   static int
> > -qca8k_set_page(struct mii_bus *bus, u16 page)
> > +qca8k_set_page(struct mii_bus *bus, u16 page, u16 *cached_page)
> >   {
>
> bus->priv is assigned a qca8k_priv pointer, so we can just de-reference it

I just checked this and no. The priv bus we have in qca8k_set_page,
points to the mdio ipq8064 priv struct. (or the gpio-bitbang driver I
assume)

> here from bus->priv and avoid changing a whole bunch of function signatures
> that are now getting both a qca8k_priv *and* a qca8k_mdio_cache set of
> pointers when you can just use back pointers to those.

Should we change the function to provide qca8k_priv directly? Or I just
didn't understand your suggestion on how we can reduce the changes in
this patch.

> -- 
> Florian

-- 
	Ansuel
