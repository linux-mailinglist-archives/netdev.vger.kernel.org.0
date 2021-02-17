Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9033A31DCDF
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 17:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbhBQQE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 11:04:27 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:49423 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbhBQQEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 11:04:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613577853; x=1645113853;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qJK73leWzrkDzeBC+OYmyCx8uVJIE42XDAZUX9Da8BA=;
  b=CPbIGLP32py8SPbCp/gQlxp913YTWwUT97eQSKq7G8sYFujsHnzRkg7w
   YaxC+CA8PFYXLTvjnCdOPZFlT7D3z5+Gb37I+TYPEmlKw5CamiTjjseft
   hqdrtjUrivpMxyZeuuRNby9L2TQe2O2rN078Ys8Oq/H9n+/UAIGKqIUK5
   CfKNk3ddpzDWFJxiiRm0ZkAvaWGsKOfSCysNgMuRononcRQJsE8BfJsco
   kZhWekHnhlwSqprqP2+yoafXxzgILUV9bGMk9RjbRNM67ao9+A9Xgelo1
   slY8SAwFEGN1Q9wqJJ28An6wQ9RuX20DZI53PgoiL75SjXVzgUh+MRNed
   A==;
IronPort-SDR: Hu/+IvePcSQwKNP0tOMJPBiW+a6Afmyi2efURNVPMT6eb2YmarbDFgiJBk1VrLvjKJaBwoHdkB
 VWX8n9+f9rsnLBsoJlEvKqhGTJxupkxc0TodaUX/FLEUqZACLaAmdQuqDYmmVVaILnH5sC+IcK
 5mQaxt8Xu1Ah1OqKCdSSnD2BVKaaryELGVG8kDxe1cl9N2sCua/2u//P1YH1Z/0x4Yy17pkPUO
 EOYFQ01j5ntyVupMJ/wRV5e5hRF9oP50oAdS3Gpd7tj6iN4BRJZknMMsCQ9tp7eBRh1aBlsQEc
 w3Q=
X-IronPort-AV: E=Sophos;i="5.81,184,1610434800"; 
   d="scan'208";a="109576978"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Feb 2021 09:02:58 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 17 Feb 2021 09:02:57 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 17 Feb 2021 09:02:57 -0700
Date:   Wed, 17 Feb 2021 17:02:56 +0100
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
Subject: Re: [PATCH net-next v4 4/8] bridge: mrp: Extend br_mrp_switchdev to
 detect better the errors
Message-ID: <20210217160256.jr33sgi73s7wsaaa@soft-dev3.localdomain>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
 <20210216214205.32385-5-horatiu.vultur@microchip.com>
 <20210217105624.aehyxw3tfs5uycdl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210217105624.aehyxw3tfs5uycdl@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/17/2021 10:56, Vladimir Oltean wrote:
> 
> On Tue, Feb 16, 2021 at 10:42:01PM +0100, Horatiu Vultur wrote:
> > This patch extends the br_mrp_switchdev functions to be able to have a
> > better understanding what cause the issue and if the SW needs to be used
> > as a backup.
> >
> > There are the following cases:
> > - when the code is compiled without CONFIG_NET_SWITCHDEV. In this case
> >   return success so the SW can continue with the protocol. Depending
> >   on the function, it returns 0 or BR_MRP_SW.
> > - when code is compiled with CONFIG_NET_SWITCHDEV and the driver doesn't
> >   implement any MRP callbacks. In this case the HW can't run MRP so it
> >   just returns -EOPNOTSUPP. So the SW will stop further to configure the
> >   node.
> > - when code is compiled with CONFIG_NET_SWITCHDEV and the driver fully
> >   supports any MRP functionality. In this case the SW doesn't need to do
> >   anything. The functions will return 0 or BR_MRP_HW.
> > - when code is compiled with CONFIG_NET_SWITCHDEV and the HW can't run
> >   completely the protocol but it can help the SW to run it. For
> >   example, the HW can't support completely MRM role(can't detect when it
> >   stops receiving MRP Test frames) but it can redirect these frames to
> >   CPU. In this case it is possible to have a SW fallback. The SW will
> >   try initially to call the driver with sw_backup set to false, meaning
> >   that the HW should implement completely the role. If the driver returns
> >   -EOPNOTSUPP, the SW will try again with sw_backup set to false,
> >   meaning that the SW will detect when it stops receiving the frames but
> >   it needs HW support to redirect the frames to CPU. In case the driver
> >   returns 0 then the SW will continue to configure the node accordingly.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  net/bridge/br_mrp_switchdev.c | 171 +++++++++++++++++++++-------------
> >  net/bridge/br_private_mrp.h   |  24 +++--
> >  2 files changed, 118 insertions(+), 77 deletions(-)
> >
> > diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
> > index 3c9a4abcf4ee..cb54b324fa8c 100644
> > --- a/net/bridge/br_mrp_switchdev.c
> > +++ b/net/bridge/br_mrp_switchdev.c
> > @@ -4,6 +4,30 @@
> >
> >  #include "br_private_mrp.h"
> >
> > +static enum br_mrp_hw_support
> > +br_mrp_switchdev_port_obj(struct net_bridge *br,
> > +                       const struct switchdev_obj *obj, bool add)
> > +{
> > +     int err;
> > +
> 
> Looks like you could have added this check here and simplified all the
> callers:
> 
>         if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
>                 return BR_MRP_SW;

Yes, good catch!

> 
> > +     if (add)
> > +             err = switchdev_port_obj_add(br->dev, obj, NULL);
> > +     else
> > +             err = switchdev_port_obj_del(br->dev, obj);
> > +
> > +     /* In case of success just return and notify the SW that doesn't need
> > +      * to do anything
> > +      */
> > +     if (!err)
> > +             return BR_MRP_HW;
> > +
> > +     if (err != -EOPNOTSUPP)
> > +             return BR_MRP_NONE;
> > +
> > +     /* Continue with SW backup */
> > +     return BR_MRP_SW;
> > +}
> > +

-- 
/Horatiu
