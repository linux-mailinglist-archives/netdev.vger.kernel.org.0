Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13D431DCD4
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 17:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbhBQQAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 11:00:05 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:32544 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbhBQQAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 11:00:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613577602; x=1645113602;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TrSgV4ppZBB1E4H994V5PZn9jNxoOv0E4rNOorIzQXM=;
  b=IXbp7xo8PgFNdAAn4/TtbtsNuuk6r7gxz5vA+U/Uzj6WNGbr7UBC/abh
   GALwsnjPTC7vM7jGOBoKbo+pforIRkRDyKsOuZU7/MOf7nRWmvAlpqlCw
   qwBfwbJIlUOMAGhg6wDhchaJ7XZR56hRBNlKbh2aoSIumJ8DMUZZ62qBC
   4jmNFnmcxlpsbkkStim7nMXivLYQws1YkYRK2Uqrwjs6n1hHvvdf10VkG
   beG2xEI2npeb5IxS03giSZoZQuSy28y7MOhecTjWNeHaa+6tpMT+jvT/q
   2X1SkCmSfFwatB9KtwnC3wOLxGzyAqjELxybVa8MssSsHieMS6mCHlqeZ
   A==;
IronPort-SDR: liuIKZbScHZBumPKPyFyxIEpz+9DDmVCmrm1/ICmVxn4g16h9v5w1fSiJx9QfK5voSHPPf5foA
 jo0ypmmrtTF7fNspqcVRQeyC527x2aIiaL3OJsJjAlvlEyj6XJy+4w1TQksAJDhBRAArDQoqeu
 QfxoSiIobdHp4ZOlIDoafIMEsgpF9CLiGiwem6K6+H1pgdrU/gixXS859KTuIrHfghKjHXEwde
 2ck/cVxSqRB5ytiXlbEA6x7Ii/21htGvLpk12yVNLayX/UWUCKFKMgtLGiRYFlHNVpM7DcplL0
 lLU=
X-IronPort-AV: E=Sophos;i="5.81,184,1610434800"; 
   d="scan'208";a="106963267"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Feb 2021 08:58:46 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 17 Feb 2021 08:58:45 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 17 Feb 2021 08:58:45 -0700
Date:   Wed, 17 Feb 2021 16:58:45 +0100
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
Subject: Re: [PATCH net-next v4 2/8] switchdev: mrp: Extend ring_role_mrp and
 in_role_mrp
Message-ID: <20210217155845.oegbmsnxykkqc6um@soft-dev3.localdomain>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
 <20210216214205.32385-3-horatiu.vultur@microchip.com>
 <20210217103433.bilnuo2tfvgvjmxy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210217103433.bilnuo2tfvgvjmxy@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/17/2021 10:34, Vladimir Oltean wrote:

Hi Vladimir,

> 
> On Tue, Feb 16, 2021 at 10:41:59PM +0100, Horatiu Vultur wrote:
> > Add the member sw_backup to the structures switchdev_obj_ring_role_mrp
> > and switchdev_obj_in_role_mrp. In this way the SW can call the driver in
> > 2 ways, once when sw_backup is set to false, meaning that the driver
> > should implement this completely in HW. And if that is not supported the
> > SW will call again but with sw_backup set to true, meaning that the
> > HW should help or allow the SW to run the protocol.
> >
> > For example when role is MRM, if the HW can't detect when it stops
> > receiving MRP Test frames but it can trap these frames to CPU, then it
> > needs to return -EOPNOTSUPP when sw_backup is false and return 0 when
> > sw_backup is true.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  include/net/switchdev.h | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> > index 465362d9d063..b7fc7d0f54e2 100644
> > --- a/include/net/switchdev.h
> > +++ b/include/net/switchdev.h
> > @@ -127,6 +127,7 @@ struct switchdev_obj_ring_role_mrp {
> >       struct switchdev_obj obj;
> >       u8 ring_role;
> >       u32 ring_id;
> > +     u8 sw_backup;
> >  };
> >
> >  #define SWITCHDEV_OBJ_RING_ROLE_MRP(OBJ) \
> > @@ -161,6 +162,7 @@ struct switchdev_obj_in_role_mrp {
> >       u32 ring_id;
> >       u16 in_id;
> >       u8 in_role;
> > +     u8 sw_backup;
> 
> What was wrong with 'bool'?
Yeah, that would be a better match.
> 
> >  };
> >
> >  #define SWITCHDEV_OBJ_IN_ROLE_MRP(OBJ) \
> > --
> > 2.27.0
> >
> 
> If a driver implements full MRP offload for a ring/interconnect
> manager/automanager, should it return -EOPNOTSUPP when sw_backup=false?

In that case it should return 0.
So if the driver can:
- fully support MRP, when sw_backup = false, return 0. Then end of story.
- partially support MRP, when sw_backup = false, return -EOPNOTSUPP,
                         when sw_backup = true, return 0.
- no support at all, return -EOPNOTSUPP.

-- 
/Horatiu
