Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9616239A26A
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 15:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhFCNpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 09:45:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:11123 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229957AbhFCNpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 09:45:00 -0400
IronPort-SDR: CJKfGLjNiNBg0PoRLbh2hfMG2VCBsDcDA3wBkl8nx1/Oc0hr7H+OvpTXM+ac7vOu+VhiOkOza4
 PlQThSBq179w==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="225344319"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="225344319"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 06:43:15 -0700
IronPort-SDR: ciNHowyrH1cCTOMqmH8C41WOOEcyCeTUBCHW6PSdCWjb9n6STFPm8N4BERRVlF9XmhN2UP1bv5
 e7m/ORqODykg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="467963124"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 03 Jun 2021 06:43:15 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 06:43:14 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 06:43:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 3 Jun 2021 06:43:14 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 3 Jun 2021 06:43:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IFXoE5lhgnEHoWPReSzFrdWlpTyb9gNOuLzrFINpHMfqRmYUDFRtHuzxFdgASrq5j5w9ZAzw2/6HcTK7a9d1y1hRuGZP1n0Eusu8RauKxpOURrMn/yb4bHjWTMoIuwAGk4Bpqd/bqwkiHYzapSSz+gWr3vRKK4FEaIY7JcpsJLA0y86TRbUDEvYOCjTcGOUZkfP7v7XBF3wrxV9qPtHeVU9OQg/vA2oB/J1nJ17X8fIz4HguDd7PS5UpNsv631pYFzYF04lF6ewHAWxgpGknW7VmZIzF1VOPiIE0QewrtQhKDdlNJNRzJqh/FfWcjLIe9KaK4WSdsa2uPPVoKxmC0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LC8YW+/hhrSyp/45wGe87jso56B6/3ewEXHg9fqVnbI=;
 b=G8q+SMXmXXJrQ8kUmyoEKmUiiR3YRG4cytUxYdn7G/3EbmzCeey1cnUxnky4Z/BFUZqjdv4oFGrjhCeHuZXw1VIWnljTkQYKMPxJY4TYrAJ5OZIqapX2Blo+r0SOKFTRAcszAvgZ4JKXy0zf6vodOoBPrBwksYpf3FD5AZVkjPxPAg0wnx0SK7unCzRWc5EGc/40Uz47hDR53PEeLQPYDW9cNT0O1CZt/Zqj4ZafzllQZLz+6Caj1Jnes4ryqdeAAXVlnlG3lFCOQuLnTHbi+ddT+Q7N/bzJ3IoQaF/jWE9Oy7HibNfEy5zwSWG6w7Il0AggKP/34QbYUL9ZxS0YAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LC8YW+/hhrSyp/45wGe87jso56B6/3ewEXHg9fqVnbI=;
 b=evMSfQyxN4OwjKL/GYTbHF+roWuT7b1ezz22PQrM01uhptnlkXViR7ZapbQrCmLXshTIvbzY2FoM8sFMAC3KrtV3fVSQHhDW4pjSy+uNpvtE8RksBqTgLmGal8UYvrmoJBV2DQYV+5KNSzkE7tFnVGjN0AZhLcmiuvxQMVy56y8=
Received: from SA2PR11MB5051.namprd11.prod.outlook.com (2603:10b6:806:11f::9)
 by SA2PR11MB4873.namprd11.prod.outlook.com (2603:10b6:806:113::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 3 Jun
 2021 13:43:10 +0000
Received: from SA2PR11MB5051.namprd11.prod.outlook.com
 ([fe80::c9d1:585:b56b:b3ce]) by SA2PR11MB5051.namprd11.prod.outlook.com
 ([fe80::c9d1:585:b56b:b3ce%3]) with mapi id 15.20.4195.024; Thu, 3 Jun 2021
 13:43:10 +0000
From:   "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RESEND PATCH net-next v4 0/3] Enable 2.5Gbps speed for stmmac
Thread-Topic: [RESEND PATCH net-next v4 0/3] Enable 2.5Gbps speed for stmmac
Thread-Index: AQHXWG9UaFWJyzfltkek6P73xpVnVasCQlOAgAAFZICAAAPLcA==
Date:   Thu, 3 Jun 2021 13:43:09 +0000
Message-ID: <SA2PR11MB505112FA44105D2F3DDB113E9D3C9@SA2PR11MB5051.namprd11.prod.outlook.com>
References: <20210603115032.2470-1-michael.wei.hong.sit@intel.com>
 <20210603130851.GS30436@shell.armlinux.org.uk>
 <20210603132809.2z3jhpuxaryaql6v@skbuf>
In-Reply-To: <20210603132809.2z3jhpuxaryaql6v@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [58.71.211.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c399cdb6-1afa-46b0-47ec-08d9269586dd
x-ms-traffictypediagnostic: SA2PR11MB4873:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB48739C8E12242440249D3AB89D3C9@SA2PR11MB4873.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VrZTUSXxD1wneqVXwtKyoQTxA8wuJhosS/AhhUgZqBn9Ki13O1LwHNpN52JfcZVaqbRM7CIQotvJ94dmI44spW4AJRkClcE/Td4JOkBODgsPk/oW24UZewl08OedoM4neaEQPJ+pzbj3KRQ+LTDfv7Pi1zz5g0S7MC4nR416AaUn1Y3Y97NrRLXbtIDL0/q7tJqmTqJ/XO4GWzncb0dSsTKE2qdYoqD0Pr+tHYeycA102YS36QvYWpDllIpnh04jZuIlFt5d/oMYIYPgVgJP2mAxsTba2fWkcb1XiLmyeBneGgyNd1iKdnf1icGe2zM5mByHsJ7KW3tcFC4y5sxXDILxmmdH4QSNtlo3xcsQ7s9j3FnWxqlMQZEfnLZHTRYSPR5l4+X2I24be6tdxxsm2lnosN4lKudetsLdVJwpnSEY8ahUbrCJ26UOzXfL1Be3e51uyGCXHvfbowzaoqeHVENgbn/U+GRHWABAqDRGqyoq+LVkiYjMmqORWjbT202NoJVtvfG6P1jk8ZJ9DmZ/cICmWyRdAHtidRP9yysSm9hUGIQzYsKUaHmuWqxMlCjJsOZS4MLWl73LdZKDr1zbUd0aOcfMjEn3qwOeGANEwDE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5051.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(346002)(136003)(396003)(83380400001)(7416002)(86362001)(71200400001)(186003)(66476007)(66946007)(76116006)(64756008)(66446008)(66556008)(7696005)(33656002)(478600001)(38100700002)(122000001)(8676002)(110136005)(54906003)(9686003)(55016002)(2906002)(5660300002)(8936002)(53546011)(6506007)(4326008)(52536014)(26005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?I9HnCQ8P4gfvCUgwlnIHixB/M4aBNn5FEJ48GkKV06saAzyRj+FbtkR/s2Ac?=
 =?us-ascii?Q?t/0IMeAS24Zqf1GmuRPVS1c74DGF6r0BtV79BjCJ2bxc98jdN2wSvw2pWF3U?=
 =?us-ascii?Q?MEiNjcmVICx0AM47IfS/xDs6PJ9tQg7MvbJdTLrIjrwCuG43b/Xh5w49DElm?=
 =?us-ascii?Q?llpdHwVH0yisx8TYRGqSmz9YZ3RfK/l+vO2tUTAalRAB+0Qs1vlPAVx0Gw33?=
 =?us-ascii?Q?TV/I35HMT9dHl/kYyCqiBkqOC65BVscXH2mmx1BjBpnUQD7MKWgnWMT9qa6d?=
 =?us-ascii?Q?6PggB6hZZFTwWZ++HwlbVPIDmA2maJJw6yMgEVp13oE/JgZl8LR6TRPpEkDS?=
 =?us-ascii?Q?nu1g5LDYiVundUyWOIsywfLhlEjlPW+wiRnYWlxp6R/kgdHz5b0FMEYLTFl7?=
 =?us-ascii?Q?9mui7xLsVn84auCCDsu2Mubr567cWR+ZLLdLQ1+znCHA4TnT7ZfMN+H0YX1g?=
 =?us-ascii?Q?GvpXVvuUonltBgF1V+JnZHNPeUFmr4z8ofO3wPf7J8WTyFXO/Yj/pPt6cFa/?=
 =?us-ascii?Q?McHKkhCWWO/TUCQqhqruWHVj3aqATK+v93trZiidlkGybJoC4lqSGOlCs2gI?=
 =?us-ascii?Q?gCjm1I7zmIs1C8bUOU08xO/nkSeEhA9BXJ0QJCSEG1xgew37E4yAOWCaqkKR?=
 =?us-ascii?Q?9n/9ZwVS/KGsoAS6iSPGbmnzx7ELAYuaFPSRksTds/X0dipLCsUmrBOk8FPL?=
 =?us-ascii?Q?Cje4ysvvJsV5LiHtu+FzFWD0gU4wgv+Ky6NOQpX76h/BQHeGlWfpjuO7tSw0?=
 =?us-ascii?Q?FHDkhMogSRY4yW/gE1Uzxl1hall1l3Hxsk3mJ5gwwPJPnc6lHFPoRK/5uslN?=
 =?us-ascii?Q?PiLsZFFVFzcVcAYraz0+6WBu1RkpBq5Xc4bmGT2348GLIGL9nt2fNZYQS5BB?=
 =?us-ascii?Q?jaiRS8tFYQsZPk1a+rO6MKpfkB1ygnWt6Wgn4Y0PXYw6lhE0MHVAkM0uC+Qv?=
 =?us-ascii?Q?XKdkbafuhifKUB1b61FUnoOpR3cmtTZAviahg94oowYnrLwyIZH+0fOVtm0o?=
 =?us-ascii?Q?ZjCfXEPXbnhoc4E1yZ5RD9KoKxNd0Lk8vHS0ChfksD2Mf9+NxiKpqn7rEC1p?=
 =?us-ascii?Q?1xg93ESJT5cvv8stFrZsI2zRVhL6we9I5wRqJZBnDGV7Vg9sU/7YztEqwGly?=
 =?us-ascii?Q?+4/1QKgMzoxzJ4e2LvJmFc1zMoIM3jo1+rbwZVxPmn7bDOAj7ufetG0xFJNT?=
 =?us-ascii?Q?NfP0WweSWNCtgzHkyZ2HLReiIdbIfIIzZ0Huz8b70dd4SU7fn9arba9Sahu6?=
 =?us-ascii?Q?0KDbl+K7e9s8uY2sKlNgUs3FgGk4eUYqtuP7rjSd5DVRrvnJz0Dw5g3Mtj4M?=
 =?us-ascii?Q?oj8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5051.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c399cdb6-1afa-46b0-47ec-08d9269586dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 13:43:10.2027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dp3F5+u+XL2HI7E95EyvLg4uxbh9gHXjZx2aar6zZDWA5e7YsDz+Fq8w8zXIWwDK5yKIi9zRt1Dc7QLzkHrG5MeLKu9wuzPh5DykIToICQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4873
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir,

> -----Original Message-----
> From: Vladimir Oltean <olteanv@gmail.com>
> Sent: Thursday, June 3, 2021 9:28 PM
> To: Russell King (Oracle) <linux@armlinux.org.uk>
> Cc: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>;
> Jose.Abreu@synopsys.com; andrew@lunn.ch;
> hkallweit1@gmail.com; kuba@kernel.org;
> netdev@vger.kernel.org; peppe.cavallaro@st.com;
> alexandre.torgue@foss.st.com; davem@davemloft.net;
> mcoquelin.stm32@gmail.com; Voon, Weifeng
> <weifeng.voon@intel.com>; Ong, Boon Leong
> <boon.leong.ong@intel.com>; Tan, Tee Min
> <tee.min.tan@intel.com>; vee.khee.wong@linux.intel.com;
> Wong, Vee Khee <vee.khee.wong@intel.com>; linux-stm32@st-
> md-mailman.stormreply.com; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [RESEND PATCH net-next v4 0/3] Enable 2.5Gbps
> speed for stmmac
>=20
> Michael,
>=20
> On Thu, Jun 03, 2021 at 02:08:51PM +0100, Russell King (Oracle)
> wrote:
> > Hi,
> >
> > On Thu, Jun 03, 2021 at 07:50:29PM +0800, Michael Sit Wei Hong
> wrote:
> > > Intel mGbE supports 2.5Gbps link speed by overclocking the
> clock
> > > rate by 2.5 times to support 2.5Gbps link speed. In this mode,
> the
> > > serdes/PHY operates at a serial baud rate of 3.125 Gbps and
> the PCS
> > > data path and GMII interface of the MAC operate at 312.5
> MHz instead of 125 MHz.
> > > This is configured in the BIOS during boot up. The kernel
> driver is
> > > not able access to modify the clock rate for 1Gbps/2.5G mode
> on the
> > > fly. The way to determine the current 1G/2.5G mode is by
> reading a
> > > dedicated adhoc register through mdio bus.
> >
> > How does this interact with Vladimir's "Convert xpcs to
> phylink_pcs_ops"
> > series? Is there an inter-dependency between these, or a
> preferred
> > order that they should be applied?
> >
> > Thanks.
>=20
> My preferred order would be for my series to go in first, if
> possible, because I don't have hardware readily available to test,
> and VK already has tested my patches a few times until they
> reached a stable state.
>=20
> I went through your patches and I think rebasing on top of my
> phylink_pcs_ops conversion should be easy.
>=20
> Thanks.
Sure! I am okay to let you merge your codes and rebase my changes later on
Do let me know when I can start rebasing and send in the next revision

