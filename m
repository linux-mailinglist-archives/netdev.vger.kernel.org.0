Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB61E31DD2B
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 17:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbhBQQUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 11:20:08 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:20384 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbhBQQUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 11:20:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613578805; x=1645114805;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Cs4BA7FTmjYzHJsFq1qDXA+grIoaOTs9jb/eR7cncrc=;
  b=mA9bPT5qHd8dZ6jHmN+aBX50uFyJchn4M5fQuCLoKoHooB9YgCjxueZq
   mTGUwW1BQaTUj3RbpNmGLw35/H9gsk7gqZc8GniZEEX2Sre5DkvBs+OQn
   lZApdHKgVA9y6NNrpIv2BdFELpOi0uQ0+WEhSqiOfWLeyPEPwvqpHRdKg
   de5v8VfbwuoumpelF0wddT+nxupkLCO/2xYfRJHmNimlcg/aEIxTXphVL
   WdEnhCBKAHhmA8xuFM46j77VF+3i/iFu61wYT53pXKfxTEIaAYI9dn0tZ
   H+eeeQdMuo3fAqimuneFt1Gd6t4UvAOnIma5XW6ukbw1BS6+DWfGtArUf
   w==;
IronPort-SDR: KIECLvx6Y04Xxp7Nx/aNJRKTcHeDcZNBNyXo5IgQYH4Hn4tWRG4cbKD37H0G+Yp8jLBJSZaqhR
 2Q6KC24saFrgKMR029tvuX+MX3AGPUg0d30jI5sZywy71oHRdtljd6qBeHB4qOJbHPXMa99JGX
 VqjrorV51nLn5t8Tw8fU3DT/cmCx24i2IXHuGZz5bVgEs9qOVaViqeOjisWffPcr/ekeLmofFN
 MUN8iGwJPTpzWbSpz/JnujVrw/guujmRrg11TZZSE70YtWUmontJMRs0ALp/MXvV14X83+Ohug
 WEo=
X-IronPort-AV: E=Sophos;i="5.81,184,1610434800"; 
   d="scan'208";a="106969729"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Feb 2021 09:18:48 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 17 Feb 2021 09:18:48 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 17 Feb 2021 09:18:48 -0700
Date:   Wed, 17 Feb 2021 17:18:47 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "rasmus.villemoes@prevas.dk" <rasmus.villemoes@prevas.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next v4 5/8] bridge: mrp: Update br_mrp to use new
 return values of br_mrp_switchdev
Message-ID: <20210217161847.6ntm52kqk7ygata7@soft-dev3.localdomain>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
 <20210216214205.32385-6-horatiu.vultur@microchip.com>
 <20210217105951.5nyfclvf6e2p2nkf@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210217105951.5nyfclvf6e2p2nkf@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/17/2021 10:59, Vladimir Oltean wrote:
> 
> On Tue, Feb 16, 2021 at 10:42:02PM +0100, Horatiu Vultur wrote:
> > diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
> > index 01c67ed727a9..12487f6fe9b4 100644
> > --- a/net/bridge/br_mrp.c
> > +++ b/net/bridge/br_mrp.c
> > @@ -639,7 +639,7 @@ int br_mrp_set_ring_role(struct net_bridge *br,
> >                        struct br_mrp_ring_role *role)
> >  {
> >       struct br_mrp *mrp = br_mrp_find_id(br, role->ring_id);
> > -     int err;
> > +     enum br_mrp_hw_support support;
> >
> >       if (!mrp)
> >               return -EINVAL;
> > @@ -647,9 +647,9 @@ int br_mrp_set_ring_role(struct net_bridge *br,
> >       mrp->ring_role = role->ring_role;
> >
> >       /* If there is an error just bailed out */
> > -     err = br_mrp_switchdev_set_ring_role(br, mrp, role->ring_role);
> > -     if (err && err != -EOPNOTSUPP)
> > -             return err;
> > +     support = br_mrp_switchdev_set_ring_role(br, mrp, role->ring_role);
> > +     if (support == BR_MRP_NONE)
> > +             return -EOPNOTSUPP;
> 
> It is broken to update the return type and value of a function in one
> patch, and check for the updated return value in another patch.
> 

Yes, I will be more careful next time. I have tried to compile between
the patches and I have not see any issues here so I though that
everything is good.

> >
> >       /* Now detect if the HW actually applied the role or not. If the HW
> >        * applied the role it means that the SW will not to do those operations
> > @@ -657,7 +657,7 @@ int br_mrp_set_ring_role(struct net_bridge *br,
> >        * SW when ring is open, but if the is not pushed to the HW the SW will
> >        * need to detect when the ring is open
> >        */
> > -     mrp->ring_role_offloaded = err == -EOPNOTSUPP ? 0 : 1;
> > +     mrp->ring_role_offloaded = support == BR_MRP_SW ? 0 : 1;
> >
> >       return 0;
> >  }

-- 
/Horatiu
