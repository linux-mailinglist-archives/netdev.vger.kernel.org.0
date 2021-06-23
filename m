Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C213B17CA
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 12:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhFWKJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 06:09:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:57177 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230495AbhFWKJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 06:09:05 -0400
IronPort-SDR: dRZ3i9yPCPKlUIA5Mot0eXmQylmgiLS2hVU6fjZ02c5iCNLsX1aisq/liSpv43d+CTiZ4J6nKA
 CFTOvmal/juw==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="204225022"
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="204225022"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 03:06:47 -0700
IronPort-SDR: 3SM/1HtmnKjGEbL6xQWfrCcdERiBjAS3tQkv4R3rwpXJ6poechIgJbIZ9F/2KxyJeo2FVSgq7e
 zVcbD6FMxbcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="406261612"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga006.jf.intel.com with ESMTP; 23 Jun 2021 03:06:47 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 23 Jun 2021 03:06:46 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 23 Jun 2021 03:06:46 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 23 Jun 2021 03:06:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 23 Jun 2021 03:06:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7huja8QLk+23fi0KMZwrmtci4LmUzYEdGimKZVKZK2OQLJTzAvR1GywMDJMB5CYlUcPoY2wXm2jpw3z9wPWOav5QyXBVsEIzFIDSVCHjXhCmRSMD45nnnnRk+rt+YBkyfXzR6mQwzychn7y8h5568YljeFkerLZa/C8wny58JXMXL9KjpRLlg9CBJCi62bopAh6VKGKoXGtJWyAUrCCHugt9fp6aNoxWPgfvkacWDC8rq5lBrL7/Tu1VuCAcF2hCUgFoi3Bu9X/tEwDdBnkjTDZc9c5X2jQGc4UFKngg7/lVav2vdJJZJgXby79TGnohOGE8qrBbJGJnmdjsrJeCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBzV56jRWqR52c7h69Nvb7WApLWbKOhaHovtjxT7hR4=;
 b=X3t2JKAQTkc3QhQpSeQaBrgDUXSk0qIpzNoZdWqnbjy7CuSLoGBYjJr1r2NH3Jf/nkTurDSQwwDF1CrAomGlkcj6hzXajlaxEBVKqhkyN9RuTnbEzHk4fxQ+gm+Ohnei89jAbV2gTQ2XdF38+4UVTm2mda908OIkQfh2LO9hbvnWnLGRoZKu32mVL6Q6Pk6bgLYPjPB3FiiOJGY8ciTc/2pv4Gtq6Jjn4VE76KVzmZcoNB5I89KurZlvQPOsMyNX1owDr2LW7NxW05ziPIiUcRQoJwWRmQ7+pC2/MAgKJD34OLx2EgR9Wu8dZ3HsF4um2ktrD4XaCEQyotlieQV05A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBzV56jRWqR52c7h69Nvb7WApLWbKOhaHovtjxT7hR4=;
 b=sUXup2m46uFKElqAjeUqEeOsICWSnVpD8N791tQVqsilnaEvml2uPQAPEAzvwA8JLBhZbdCHu0AnhDGzwoidueZSAhUJakE0rxnkETuPcXW5V20NkNv7qE4V3m5o6Kb9AC4ERj//Jaq2OZNCGJl5WHXb9kD3ABGhV0ZDI01/QFs=
Received: from CH0PR11MB5380.namprd11.prod.outlook.com (2603:10b6:610:bb::5)
 by CH0PR11MB5315.namprd11.prod.outlook.com (2603:10b6:610:be::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Wed, 23 Jun
 2021 10:06:45 +0000
Received: from CH0PR11MB5380.namprd11.prod.outlook.com
 ([fe80::d52:3043:fef4:ebcd]) by CH0PR11MB5380.namprd11.prod.outlook.com
 ([fe80::d52:3043:fef4:ebcd%4]) with mapi id 15.20.4264.018; Wed, 23 Jun 2021
 10:06:45 +0000
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Ling, Pei Lee" <pei.lee.ling@intel.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next V1 3/4] net: stmmac: Reconfigure the PHY WOL
 settings in stmmac_resume()
Thread-Topic: [PATCH net-next V1 3/4] net: stmmac: Reconfigure the PHY WOL
 settings in stmmac_resume()
Thread-Index: AQHXZoJFBtZ0uXgSn0S7qboFjm+Joqseb0UAgALh+bA=
Date:   Wed, 23 Jun 2021 10:06:44 +0000
Message-ID: <CH0PR11MB53806E2DC74B2B9BE8F84D7088089@CH0PR11MB5380.namprd11.prod.outlook.com>
References: <20210621094536.387442-1-pei.lee.ling@intel.com>
 <20210621094536.387442-4-pei.lee.ling@intel.com> <YNCOqGCDgSOy/yTP@lunn.ch>
In-Reply-To: <YNCOqGCDgSOy/yTP@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-originating-ip: [2001:f40:907:b986:5c2c:5137:7a92:b652]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 038a88e1-dd07-4d24-d8b4-08d9362e9b48
x-ms-traffictypediagnostic: CH0PR11MB5315:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH0PR11MB531541ADA0AAF2F403C2539F88089@CH0PR11MB5315.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f2hPlU69o4iQKQWG2mhfcj97wceWfoeCJv2dT2mN3MEB9htMmxVw5tLqwK17Ivex9O5/PEf+hWpi+deD5b5PRLeETEPGYjR7ryJRQs6uAP2vOoq20ggi7QUnqXvkSK/v4ThkeTR2jkgyz3Bo1WCxEivn3YUoO6eDy8zSZw6GzzSWW00ipDnnR9CXvvZspMIACa2AT5wAPsz4+n+O0jfXnKAexC5r9RmbGP4zURKgVtaYPz7RbGjv58WFsUtD2Ax5ZC6heu1NkX3GE7Umt6f8jPaDvGYnhuv0zvVnahItBapZRj7b4C9RcKMXR+Xj4phfZK4RBQu4kZQk1UG66VPyBoPRx2QnMWq8r1iDdoHLoN8UPV6/U/R/fj9MzQz4WIRz5cCKXy2JJLfHOzAOyLU1EVz362/3oHN+QK/NYIPysUFeUOrb73J7I8Jw6L0sVVRoyXAhQaZkvSfAxF+CtoeN363q1OmheLJq07WjSB2YF968D5FGs3i1hzti2k1Oa2mMkTTc9OtSUAQeOZctdNT3Mw2uYXg0H+GJFcr3kuSNYIqdwpDqCKnpXCJ4P+b2KFvSKYjMmvqPL14pYMejzla0yo4zA+EKNr+9BwtH3Jip6fY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5380.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(376002)(346002)(136003)(86362001)(316002)(8676002)(33656002)(8936002)(6636002)(122000001)(7416002)(38100700002)(4326008)(2906002)(5660300002)(54906003)(110136005)(71200400001)(55016002)(7696005)(186003)(52536014)(83380400001)(64756008)(66446008)(66556008)(66476007)(76116006)(6506007)(66946007)(478600001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DK+nx7/H13CbYTeNW8Aw4v59kmCustKb6HPd3HCLrETo5j7fK37e8YKbyTq1?=
 =?us-ascii?Q?tNZir77d6uPwpgZXol4UxjV9qrtyQ4rNulVRKzeNMOJPSFfW0BPgYx0tqCJ6?=
 =?us-ascii?Q?x+pI31nRLmbHEnlAqHx/y86qIZeons83OYEc2cYb2ABfqy/rbyfIiN5oMWf1?=
 =?us-ascii?Q?8RLqXVeQ0MGWhvOoyU8+Nu641zRF4KtN8NzOYzK0hD3j0QjLKGggvPiZWxM8?=
 =?us-ascii?Q?e+QXmNKBD0nrb0Bv8Zi7dEh9XgmOmngWFefWaxa/3A6Qf0Ugp3l4lUim6/CD?=
 =?us-ascii?Q?IssuKDtyz9cWqMX4De24Hzr0aIZaIi0ldSZo3S+7V0NFA9HltQWSBc2XlR3Y?=
 =?us-ascii?Q?YZDeUdi2OeOkONqUbv2fHpPJLIAH5xzQ0eEMEY8zIlWeIw3vA4EMMP+isodg?=
 =?us-ascii?Q?Fx2VVuVw67q+XQpNoTachArFMBj6IAWo1Yu4TyU6FMfS/ykB046pEVqKrAvo?=
 =?us-ascii?Q?o1qGdNVMS2B4OiwA4JApDCzGayNy2VjC8PuB8nJht43RT9YNrW0DWBCqUnVC?=
 =?us-ascii?Q?Xire1xCxftma6kRkPsyXc2IFieDLzLqSSsC89hHRiFb/VfYw5x6yNausE2lx?=
 =?us-ascii?Q?m8s8ZprAN2bWBlkY9YNqBLewdxNmSCntwKtApiA5ZcgtkZTrYU0ZnZFqBj2D?=
 =?us-ascii?Q?HG1gDrAzXG7xdLHsnDJs1JGyN40jSMwm1Z3OZQE+H/4esq4OkY2Byz2aOWGx?=
 =?us-ascii?Q?T2fSRbEO2LqqVpMXCvLPSwgX3zxuco6Xu0C0uOFahrOvn8xJK7FRJAST/ItT?=
 =?us-ascii?Q?qnE6LA28/pBKZDN7xeP2zSsTnbqV8ouNMyF9X6/z0k25/6tChwpRwCZgR3i1?=
 =?us-ascii?Q?b3azAO+mjx5xghCWbUIeGcs76YwUqboSOZOBfNZ04iYh33er8kKhPyP4zy48?=
 =?us-ascii?Q?GluVr64GO4wpIfJhix1TakOxoiQDedJUmyNSasYRl7wR8oRt5QRCyNK62dEV?=
 =?us-ascii?Q?qB93UJNP6XbISxoll0pyUhXlcgHpbGSCKFwKtV2RE9ltJlj+9qBjjtoWf1YP?=
 =?us-ascii?Q?mTlCgCy1dGTk81R+718YsMa/g9Hn3jTnkdoKKTOj+Olnmk1XBfTiAkb/Lnpc?=
 =?us-ascii?Q?lpSoR9vBzfgec4pXx192l8A0/0X/NIiRZdrd2O8n/s8153kCLZCgFe+a47NS?=
 =?us-ascii?Q?DbZxThJ0kFAkRhHrUa/dzCrb9Oe7yEHHdJeU5NprXkFsd5IcRyNq66Npe8sc?=
 =?us-ascii?Q?GoPjVpujK6HIJSkmhpjqhS7OzFnGPNQy+osYD9n1qE1gEehAn6l+AdZ1Ft5+?=
 =?us-ascii?Q?fWhsOP6OwfeD9a4QGCLKFGqN2BcqEnytTX+erghTmKFI2Njnl2cLbxD4xqtm?=
 =?us-ascii?Q?UfCmZHXFL+MS86e1QVzkCQqEYhOovtZpkJhuiKbg9mFD62638GTvwplqfjcI?=
 =?us-ascii?Q?ZDOFrlccHidXipiU4Ik/d2vJ+lUM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5380.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 038a88e1-dd07-4d24-d8b4-08d9362e9b48
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2021 10:06:44.5578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FXvAdfbUqxg5jYf8z6OpRInGXzeEJ9+CqMJJPc8K88erjSsMGppQtt2X0GU5N6qBYS44GLF1sKiQgAZo0/3Gvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5315
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> >
> > After PHY received a magic packet, the PHY WOL event will be triggered
> > then PHY WOL event interrupt will be disarmed.
> > Ethtool settings will remain with WOL enabled after a S3/S4 suspend
> > resume cycle as expected. Hence,the driver should reconfigure the PHY
> > settings to reenable/disable WOL depending on the ethtool WOL settings
> > in the resume flow.
>=20
> Please could you explain this a bit more? I'm wondering if you have a
> PHY driver bug. PHY WOL should remain enabled until it is explicitly
> disabled.
>=20
> 	Andrew

Let's take Marvell 1510 as example.=20

As explained in driver/net/phy/marvell.c
1773 >------->-------/* If WOL event happened once, the LED[2] interrupt pi=
n
1774 >------->------- * will not be cleared unless we reading the interrupt=
 status
1775 >------->------- * register.=20

The WOL event will not able trigger again if the driver does not clear
the interrupt status.
Are we expecting PHY driver will automatically clears the interrupt
status rather than trigger from the MAC driver?

After scanning through all the PHY drivers, the drivers only touches=20
the WOL settings in the get|set_wol() callbacks. Hence, I think that=20
currently there are no PHY drivers that clear the WOL status.
Unless the PHY able to self-clear the WOL event status, the PHY WOL
would not able to remain enabled after resume from S3/S4.
Therefore, we implemented it in the MAC driver to reconfigure the PHY
WOL during the MAC resume() flow.     =20

Weifeng
=20
