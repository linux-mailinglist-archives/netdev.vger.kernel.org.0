Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A27D3F234F
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 00:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbhHSWjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 18:39:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:51200 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236495AbhHSWjV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 18:39:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="203862260"
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="203862260"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 15:38:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="442411292"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga002.jf.intel.com with ESMTP; 19 Aug 2021 15:38:43 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 19 Aug 2021 15:38:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 19 Aug 2021 15:38:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 19 Aug 2021 15:38:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTH1tAA1NBW1risseQYXroCnGjIkqVs/1iCh6qssqbRFSohw0bXr3vg16wJbMgWA4R6yD2swUtEtqw2Pi+p2Pbqu/OVs0mf2syE/0ZaRWNV14f5Sio62y/v9Mz5RLQnTTG+wkk4uRm4T41BVwnA9LjAu6SQ2DXlHZHYQ+6cMBrxpWC6GtPXHh6Pf02xQsa4Yb5lETjwu1vCpjb7FINQa50wTiiwnxwZY2IVdU08zcSKLzQbCBoWUh1Q67SOfcFWuVQA8ugO4VkeRwUQiP8QQc3sRsaua5YMpxTC2DvCkoUYY7htke1LYm330ScmOn8GfcnnHuPKhy3S3WXuyJ2/hVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=419qom3VLW0i8QuqigTS2shu3uu6L9XBf92Jh4sr1A0=;
 b=EMfvLDUqmxt0fq6w6hrqRoVH+lVggbyXPlIaDdqs4Yy9YUXBfmT1b/eryc+Na3qe4zQjy+MTXbf1BzjediG6PzlcFu/IfrjlUQ6iUM+aV+k6n/s+CvHDMgr15u1Cggewsbfr0gg9EMJraQSZlGont+RyCNgkZ1gGeGzh/ZVK48XUNb0OeG7/mEA5k4x2S0lqV+RNv3zGXllYdrfs+/i5976UnAlzyuypUW84o3JPLePatdYIRpm2Uh5QfzPCJYfU8y2ryyGjE84Yyig2pPwUFdR4p0u8/2aPGX8XxL+4tNq7Vr4yfCWJ0JDX62n7qZ0Wqclh5VQygutggS8bhLWUXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=419qom3VLW0i8QuqigTS2shu3uu6L9XBf92Jh4sr1A0=;
 b=ABgALKNlTwsSzvsrfDGBJayZKlAglLZwF1Z+THsa1bVj0y/qf4pet/RlO3nd4CJX2iKc7L+e5tr7T9enk3inmMke+zRuH4yLXcJHBdi4wmjM+Lqf80J/KcCR17/SKNe/VlOuI0pANUBvDglDxmu01ifrKyDrC992ObuzFrwGc4M=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR1101MB2303.namprd11.prod.outlook.com (2603:10b6:301:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Thu, 19 Aug
 2021 22:38:42 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960%4]) with mapi id 15.20.4415.025; Thu, 19 Aug 2021
 22:38:42 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "pali@kernel.org" <pali@kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "vadimp@nvidia.com" <vadimp@nvidia.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: RE: [RFC PATCH net-next v2 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Thread-Topic: [RFC PATCH net-next v2 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Thread-Index: AQHXlEkaFzjh0eZH2k2IJ4djHCVmZqt52VaAgAAGcICAAJV1gIAAWhwAgAAWzQCAAAI3AIAAg6ew
Date:   Thu, 19 Aug 2021 22:38:41 +0000
Message-ID: <CO1PR11MB5089D735601C260783142DD5D6C09@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210818155202.1278177-1-idosch@idosch.org>
        <20210818155202.1278177-2-idosch@idosch.org>
        <20210818153241.7438e611@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YR2P7+1ZGiEBDtAq@lunn.ch>      <YR4NTylFy2ejODV6@shredder>
        <YR5Y5hCavFaWZCFH@lunn.ch>      <YR5sBqnf7RZqVKl4@shredder>
 <20210819074242.250ab9cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210819074242.250ab9cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33e35391-b5e7-4a2b-f3c3-08d9636218ae
x-ms-traffictypediagnostic: MWHPR1101MB2303:
x-microsoft-antispam-prvs: <MWHPR1101MB2303E0C90C8AA76A54522E6ED6C09@MWHPR1101MB2303.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: frBpZVzCrFU6/NX3/bAlmYgj1kHkA5STFa3qdSQuC/KTTuXl/t2miHAwekY3blcbNgZ9D6ApfreEo5xycoW3r83FzJbsIVTlsp4JLqheKivaZtMRVZq9sBZGFj60EBAX5JL4EFKSJYaStTrqDM6U4SunhuIdTHt+5pbtZKobOPCPWyN7lun20ReSyMjpxOvoKiYDrYrrJr0AVe4U5ca8jGIhdfUMertlshioG8cFfArEhUrPK9cFSwkYcIuERiptn0yvTOp/JyHEo0jqrEWqBPJKuGDR4x0qDlALe2dif7PV7ldon376HHNmQGE3WksG3ca5bsz94MArwJo6XIr/Ar1UfssVlUbnc27grkEbipo2H5jAR99KROOmO51zu931N4X/22k58eLhSaMvCj2EK0qgEbKrvro3HlRtWT+DOGbuAUz3HsxnHI3qA41CCkRMIoH3GxTpQs5T8FTUj/5b6VRKqA9hoTjPsBo8Jt0g5zEXlJDU6jZVVHqWexkaBnzZfds/9QVSwkYQV9gzPG1KDPjLpwOUQ0z5lQbpILoRnvUS2b8m3LY8OL/2bEHipo28EkNwC/8IVrio4KygJjWNbuU8b4Y1vkcUZ/IgVKXOxyFN31yE94fUzZ29lbp8RALIsSgs5IiQ+uBAdGsNGwEOr/O4ncKhtM2fhPDAjydxbLxyey4x/BeP959V8RWA6Hev9sboJZV/LlNsLTlXCf3bfGlITECDEvdWUY3WC940qrMdUWAdRM0bT7LX96Zbjp2AwyXM/FfZJ1iC5fdJ68i9p6HoYNKbveMQhFET2LeBCDM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(66476007)(5660300002)(966005)(64756008)(19627235002)(76116006)(186003)(38100700002)(55016002)(86362001)(9686003)(7696005)(478600001)(8936002)(53546011)(122000001)(71200400001)(33656002)(66556008)(66446008)(2906002)(7416002)(6506007)(66946007)(4326008)(54906003)(83380400001)(8676002)(26005)(52536014)(316002)(38070700005)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IxdX0Kay5vaEZ/kWpoVDLAuUtZaiB1xnfzEte6AXXGqfztTb8/P3LkXMd2YF?=
 =?us-ascii?Q?2hcwd/UBGdT4FA1IZg9MZFIFZqCrNQcQzB7JYBqlOmsZ4kWuoSyWvpArTnpT?=
 =?us-ascii?Q?cJeS5Zf5hujXPfWlx4u/F/naPtZ0y3p/yHw7PPAZG05vMg7DeaLhU3Rvi+V7?=
 =?us-ascii?Q?Y1Dx6A8/cPCKDb+XmOHLugt8xddf1FH5D/wOOdufgNEghnKx/NLp3WA536J+?=
 =?us-ascii?Q?yVsGo0PyTLHFWD6+Z1O76s+gCCf+KP36ApamtH9rzzzFD6pFUSyI9hL7j+t9?=
 =?us-ascii?Q?GRVoOFuMy/N5KD4KO+CC2ZpzHLLkzqjAw/7iNRy090AqTJ7j+E/Xmv7Z8qsU?=
 =?us-ascii?Q?e/bp4rf4p6kxE/+2pw5vWtSJPLWY/7bLVBzyPiVqB5K+7PD52WS/chD3VBqw?=
 =?us-ascii?Q?Z+i/6guAgqS3Vq5YNqo19NSXXs1ppSR7I+CZgZ13cKJBB9x2Z7S9QC0TX2Ux?=
 =?us-ascii?Q?vg0VqCAy3VTk5CHx7Ro7LbCiOGe/WnEEMcPCJDzR+i1T2INXJDqwz7U59SWf?=
 =?us-ascii?Q?cxGBuVGxd6ZO9F0vIqhcD2RFIrEAgtELtqK8QiHfWeysiixknN/VK60SBg/6?=
 =?us-ascii?Q?hXLQTnEUxJT5SHXB2WZRfq2ulg+Yr9ukNdlVioV3sO++0IcedP5tYiJwj5bl?=
 =?us-ascii?Q?zxINpe30TcyT5dsj0xfOUPkqGy8YW8Ab7jMj9XPrhkoa1wnJFuXuvrqoXTBJ?=
 =?us-ascii?Q?ne8cC4Hr+mwUFiiZk/4F8Yrz3ghO1CXgKSUHkOabG6opbikv8N6rhfci593k?=
 =?us-ascii?Q?/6rHh/+AtE+pYgSyZEXGxWwv/JKgFHowexkSlVj2D8dxe1205E1wLGBrI7vG?=
 =?us-ascii?Q?c6Pcq9WnER70K+j0sCc5ACnQu6mqhWWcsvdcI4ZBGtMKzj3nZmruu/dPBIgf?=
 =?us-ascii?Q?nIsVjAi+4KzqBEULEZOjL2rWDQp7R6GJg23Ss6khlqnZmSLEOQCZ3N8WVFm2?=
 =?us-ascii?Q?woxHkSKq9Ihb3ss/4sz+H7ORuBNuh+uUKNcfnW8IZ5h0z+t6V91GtM3XIFoE?=
 =?us-ascii?Q?MwsAGAVE7hz7ANblmx8PWcV2Nyl9ATPpTHL0o0VjZWIpej4U29wyBWPuuV2P?=
 =?us-ascii?Q?8GLye5BOVfCON4/FtGJ9T/f1hDwsZzEDTHRsab8Z7WAKlS3dUrg1GL78YUJG?=
 =?us-ascii?Q?X9p9OgFKzjD3RFnPTUS6IZ6xj57hv6itjzDBY+HmeN7wzOJVdVXEjQdpsENF?=
 =?us-ascii?Q?ewOsTABXfhjaDLpyHonxcBDoMFMTz0lgUdx6TNFNSnjSlbbGdf5zUK/ARiSq?=
 =?us-ascii?Q?Q7TWqSHnDMwl2SnZDPBbUPXlDzzCluun/kGKiVvKlNB25qm2mmebFp4sxwJ2?=
 =?us-ascii?Q?Vmg=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e35391-b5e7-4a2b-f3c3-08d9636218ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 22:38:41.9588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YSwr1a1ohAne82i+/RVYLmKKnlMCE/65+fUIbejmTVlvvSBvMSwS1bMZwHxNn03i9It1ouQ0KpzNlF1cltleLrCAb8EsGBE0bxL/KgQeP/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2303
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, August 19, 2021 7:43 AM
> To: Ido Schimmel <idosch@idosch.org>
> Cc: Andrew Lunn <andrew@lunn.ch>; netdev@vger.kernel.org;
> davem@davemloft.net; mkubecek@suse.cz; pali@kernel.org; Keller, Jacob E
> <jacob.e.keller@intel.com>; jiri@nvidia.com; vadimp@nvidia.com;
> mlxsw@nvidia.com; Ido Schimmel <idosch@nvidia.com>
> Subject: Re: [RFC PATCH net-next v2 1/6] ethtool: Add ability to control
> transceiver modules' power mode
>=20
> On Thu, 19 Aug 2021 17:34:46 +0300 Ido Schimmel wrote:
> > > That is kind of my question. Do you want the default driver defined,
> > > and varying between implementations, or do we want a clearly defined
> > > default?
> > >
> > > The stack has a mixture of both. An interface is admin down by
> > > default, but it is anybody guess how pause will be configured?
> > >
> > > By making it driver undefined, you cannot assume anything, and you
> > > require user space to always configure it.
> > >
> > > I don't have too strong an opinion, i'm more interested in what other=
s
> > > say, those who have to live with this.
> >
> > I evaluated the link up times using a QSFP module [1] connected to my
> > system. There is a 36% increase in link up times when using the 'auto'
> > policy compared to the 'high' policy (default on all Mellanox systems).
> > Very noticeable and very measurable.
> >
> > Couple the above with the fact that despite shipping millions of ports
> > over the years, we are only now getting requests to control the power
> > mode of transceivers and from a small number of users.
> >
> > In addition, any user space that is interested in changing the behavior=
,
> > has the ability to query the default policy and override it in a
> > vendor-agnostic way.
> >
> > Therefore, I'm strictly against changing the existing behavior.
> >
> > [1] https://www.mellanox.com/related-docs/prod_cables/PB_MFS1S00-
> VxxxE_200GbE_QSFP56_AOC.pdf
>=20
> Fine by me FWIW. Obviously in an ideal world we'd have uniform presets
> as part of 'what it means to be upstream Linux' but from practical
> standpoint where most features start out of tree having the requirement
> of uniformity will be an impediment preventing vendors from switching to
> upstream APIs. That's my personal opinion or should I say 'gut feeling',
> I could well be wrong.

I think it makes sense to push for uniform presets where we can. But in som=
e cases where we already have a variety of differing behaviors this becomes=
 difficult.

I would agree in pushing for uniform defaults in cases where we're clearly =
adding new functionality. However in cases like this where there exists a w=
ide spectrum of behaviors, it makes more sense to allow individual drivers =
to maintain the same behavior while reporting that up with the option to co=
nfigure or change it. It's not ideal if we did everything from scratch, but=
 it's the current reality.

Thanks,
Jake=20
