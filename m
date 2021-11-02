Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B05443479
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 18:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhKBRWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 13:22:38 -0400
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:19591
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229684AbhKBRWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 13:22:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f6GEDCn+eP6lD1CtYU0p1SbQ8P03pnVYTmuryX8dMNtb+OOcBZasPfw/qP7lkLptYmX+g9fhVzcSZpkJQs4oE/YLYHF6C616HWuYtUEqufLuRo2WiAo9dIjZEU6n/mFXkEz16xrc/v/wFVMAxU3Gry/pgHVNXSygJeyw8vw9NhXacWKZVRHynoqBGKvzwkI4eH0a4r7SKQk4Fmi6HJsjyaQPqqDNq70JOsUG4Wen3m+EDDnxUZFRmZXKLNG3CGVnvuhA5By8L9Okfy9kUJBOzCdksC0fLsNs4estBVLjlz+pjdtFadwi+3lNxkn9ON2QSrsdK9g7H0oGNKWUeqFDmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WaIjLofn0Oj3u0aeT5ttMmZL2s1HsVzu0O2I91T567c=;
 b=nU2sKDSTgAh3461WOZkfOHroZkKZ3thTZ6eApIIryzCurvE13RT79Zg6tMmTrcxgH5Cm28nNJguO85p2g4c7gq9vZQ1vuG/m9UWQRjo/WamhIlyoXATrZrBs1pk3qHaBwJ4/AkXATij7hKhr+yWotE8EZmUYcHFH2RDGbnc/ATfCPfP70NVrC7W4Suc2B9D2CVB71gaj2dRwObJb1OCrZxD9a+9FhRgdscqr94rArrSnXGw9eAxthZocSCbQD10L8RKwQW4MjxbGcp7Is0BPGTueWkIxQbVl+ZKMeKTG547dNGLPjbT1WJ2FAMV2gJ86wLe+XYCgX5fm+xypaRFKQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WaIjLofn0Oj3u0aeT5ttMmZL2s1HsVzu0O2I91T567c=;
 b=qfjqWVwZKRyTDOuRKSuFahjMKk6RbORch2Hmr0cCg+RnRGT4/8wQBFI0to5jliTG65oUvPQqelVWrS5shP/bzABOGPDpJvb7YlDsg2U7Vw9ME0/uvUXp/nnjU93tgrtH/WkIL2p6Ztpl7pQZh0b693HLwG6MGD7+MGvip5ITeyY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6269.eurprd04.prod.outlook.com (2603:10a6:803:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18; Tue, 2 Nov
 2021 17:20:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 17:20:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 0/5] Code movement to br_switchdev.c
Thread-Topic: [PATCH net-next 0/5] Code movement to br_switchdev.c
Thread-Index: AQHXy06ynOa6d3fRmEa0KFrEH+B4EKvuzUaAgAFRBYCAAAqWgIAAA2oAgABUOoCAAASYAA==
Date:   Tue, 2 Nov 2021 17:20:00 +0000
Message-ID: <20211102172000.byrxnde5fg3p4wqg@skbuf>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
 <YYACSc+qv2jMzg/B@nanopsycho> <20211102111159.f5rxiqxnramrnerh@skbuf>
 <YYEl4QS6iYSJtzJP@nanopsycho> <20211102120206.ak2j7dnhx6clvd46@skbuf>
 <YYFvZRCo4Ac4/Zll@lunn.ch>
In-Reply-To: <YYFvZRCo4Ac4/Zll@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9519dcb6-6a1b-424d-261a-08d99e250078
x-ms-traffictypediagnostic: VI1PR04MB6269:
x-microsoft-antispam-prvs: <VI1PR04MB6269E0EB4FE316ACB37BC467E08B9@VI1PR04MB6269.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uy9sdJQe8z0Ycgpz/qtWjp12oV9VyJoRikPWhvZw68eleRjftnwl+PekmPaaUdSd52FDfVRPlGxaMtD7XZJ0Sy7n3B9bpbZ70uOJjb6OGV+MVLOVAOlXeHp+kDUMYnLHUzinpEV7c8R1WljQAYjWj2ooUxRawtpLpmeccg+vaKsHgIFlmToXTNrmLauxHYyvqNyibSb9CdE1GXlZoIxfWbl/FfaWPBldcY+2o7PJTi9WswTMxaP3y9nDSZIyGUIywQmhRtE3gnjtRSL+5dnvsLbbax+YqOHbQPhaPHd9QXjf1dDzmATEJa8U/OK4FReBJ+GDvMXx2OOyQr6MUslDHeUN1+pyl9HoASGEAYqdv4ncK9j//v8B0tQUTDkwRpx0Sg8zyfhVs2dOVr3YiFGGS6hzySiwhnzvBzVQCXWHBtKMiXvmmXrvzAM/y0XJi79rlctHRGK4DmMNro+bL/ytT+cXQpJylLZY5MSoZBs7KJDc/qzB47GBEjZupklHbUpnnR/WyT+6go1VN3LZKJGf3hP3Yd8MO8XcXsdps2JvnL+3ikxPShtDa8qHt0RErpHMzlAKPF0ZcvRpjJbfbosUjoPR7BybAFeFJmdq27Gn6ja4saq43YHgPT3cyqAqwgNLqzzEqSG2kQcrIFN4zZyZdkorZySMMNTG/ZpGGuo4vu15XLxb5+y6d/ZxB9oFrKl9XnCPwzhIZBXofM810QeItg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(5660300002)(8936002)(2906002)(66476007)(64756008)(66446008)(66556008)(26005)(44832011)(186003)(508600001)(91956017)(76116006)(8676002)(6506007)(6486002)(1076003)(6916009)(66946007)(54906003)(122000001)(83380400001)(33716001)(71200400001)(4326008)(6512007)(9686003)(316002)(38100700002)(86362001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mHuMi3jKcnuKy80Zhsn2i93ZtysNU878k26JawcW+8kCymBXrWVhIjhtfnE4?=
 =?us-ascii?Q?x3rGE50pMgdlJeZSRnolSUDDSO/YVYTG8OC3aiR8RRqaiIDqLQQrkCjN4L1m?=
 =?us-ascii?Q?T//ILdTZLNxR+rpjnphmn5ra4IVBxUChi54stSBIrT+1sIl0ACmdxfs9vEmg?=
 =?us-ascii?Q?4ehiwRxJhIXvb2SGPgwyNixmGHZ0dl7xUHW7TN50khtWS9yv6eNk6jWLQFeR?=
 =?us-ascii?Q?VpW1r9oEBarv2oskrxdkp7jyD9aYgg0OqWVbBCvsmRcUW0p8Ma/GI+InqJG0?=
 =?us-ascii?Q?C6vvbGypbwyWzhS0ltxOl+FZAnGeuYzBX2gyPhQQn2ICZypesfTPphMpyjKP?=
 =?us-ascii?Q?dFBPkT+rzioZO7P1nczKDcESQD7XSO+D6Zj7qsCNacwMrVZVr2tkbRDVOvMy?=
 =?us-ascii?Q?JfK9pXSpqT6kS2XVIZGOp8y2pvaarVQxO+G84Iba4j7sifj/8hoY6BdXImDN?=
 =?us-ascii?Q?lULuDtv8qjNj+LsuOt62zTJXhxFiUP463sf11LNyExWV+WNc4SMzyxiK4vwg?=
 =?us-ascii?Q?IV4wxOpyhqJOH9LZCurA7ro1tPGS0hFkNrVMziHZrt1ExMv1rJDVGA16RJnN?=
 =?us-ascii?Q?mHSg/W9T4AJxd/IylZ4c4f8F2EfgICxWn9pGAPE2IxpbZvB2hTYvhjuu0rEr?=
 =?us-ascii?Q?WUnYVGWu8btJTAiE7Nfe7qlgDtg2DWnVUde7bfGwdozSggT0q934GAj3mISA?=
 =?us-ascii?Q?9sYdQTNshfExXo3FQu4JLrqhblyJl+dCsKSHCcX4+rp8mMfH1WE3nyIwDihO?=
 =?us-ascii?Q?nTOwJq7DCJ0luwTFchFW0EmTiW+Y6SfOTBr1CXPX+Mv6LODqFevXDRbH3WN4?=
 =?us-ascii?Q?Pu0IIlfCTsg/f3iWwQsuSwI3Gzn4TWO6Opwa2zrXSrBCHi60bQWhWODDoRsI?=
 =?us-ascii?Q?0wHEGROzxuFyoTOZDnTDmm6UlU8Fm1kDd+QtJUZGGdweFeIXGhNidx1FM2Z1?=
 =?us-ascii?Q?LwfezDT0tOXFCdIoXGw9KT/KWz5mBMR9yQAdLDFxi3bZ/bKHU1MCTVQb1Qwg?=
 =?us-ascii?Q?df00CY6cv+8uiegirJKGnpeS72luGPMoAwvLMiitagKOqhTdDHnCc5CqjB7R?=
 =?us-ascii?Q?2XRl9im3cr9JKfDB7Zeyv95IXOgB2rbIqiIfA1nwm5b+Fw7W4mu4iS9HIAOZ?=
 =?us-ascii?Q?mtEAxVSQ55chPYtDBxm7lN96Ii+0YJdoN5ZVEd0seeVzTDBWV6H9Fk0k7l/D?=
 =?us-ascii?Q?9fv1gQjL8XgjGWrBGqxe8GcVdF/+8WsSp+emK8c286skXD3IfjuYDu50FSde?=
 =?us-ascii?Q?dmFi/wf0LizmL34qopZy+PyeA32KVPDcyvfSXRzHaT+SZR2FXivQDhtoF3cv?=
 =?us-ascii?Q?nYsc/L9t6EilFiD4hkwpG9hDDvDNM/HcbG9sA4uIsYRvxNGHAt99RxSwr3Iu?=
 =?us-ascii?Q?Gg5u0FP34k6zu0VXl4ivFMvuuCXjZ0R4O2Zi3alN8b7OSSCfnOHVNZrIXzxS?=
 =?us-ascii?Q?9e8Ebsyv3vFT/sv5NTCjr/ZJMDZqyqXbuN/uio9uOCusEov5kfK0Y0cdl2Zc?=
 =?us-ascii?Q?VC+Xc4R/tzmKvc8LuvRXxzXgVZGv8eRjpdDa6XyYJhkwdRD4RqldvhLeCHzd?=
 =?us-ascii?Q?gKIjEBgAaxRT4RurNs5qaWxeTvxZMjKkaBnD+oEBHnWsuI+Iwij8fnARCAe0?=
 =?us-ascii?Q?whPA2CklxEQtpXl16nEyY2E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3647A4C94BFA3D4F9992C32926256434@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9519dcb6-6a1b-424d-261a-08d99e250078
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 17:20:00.7868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YqTFApV5TiYZoT3YBGA68Y76G/tYyhakCPcBHHNpT1jXKO/7N1cJCLFdQeaGLAp5OtlMBG3oZ8XPIW5abIAQog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 06:03:33PM +0100, Andrew Lunn wrote:
> On Tue, Nov 02, 2021 at 12:02:06PM +0000, Vladimir Oltean wrote:
> > On Tue, Nov 02, 2021 at 12:49:53PM +0100, Jiri Pirko wrote:
> > > Tue, Nov 02, 2021 at 12:11:59PM CET, vladimir.oltean@nxp.com wrote:
> > > >On Mon, Nov 01, 2021 at 04:05:45PM +0100, Jiri Pirko wrote:
> > > >> Wed, Oct 27, 2021 at 06:21:14PM CEST, vladimir.oltean@nxp.com wrot=
e:
> > > >> >This is one more refactoring patch set for the Linux bridge, wher=
e more
> > > >> >logic that is specific to switchdev is moved into br_switchdev.c,=
 which
> > > >> >is compiled out when CONFIG_NET_SWITCHDEV is disabled.
> > > >>=20
> > > >> Looks good.
> > > >>=20
> > > >> While you are at it, don't you plan to also move switchdev.c into
> > > >> br_switchdev.c and eventually rename to br_offload.c ?
> > > >>=20
> > > >> Switchdev is about bridge offloading only anyway.
> > > >
> > > >You mean I should effectively make switchdev part of the bridge?
> > >=20
> > > Yes.
> >=20
> > Ok, have you actually seen the commit message linked below? Basically i=
t
> > says that there are drivers that depend on switchdev.c being this
> > neutral third party, forwarding events on notifier chains back and fort=
h
> > between the bridge and the drivers. If we make switchdev.c part of the
> > bridge, then drivers can no longer be compiled without bridge support.
>=20
> This is something i test every so often, building without the
> bridge. The simplest DSA drivers just provide a 'port multiplexor', no
> offload at all. You can put IP addresses on the interfaces and
> software route between them etc.
>=20
> So i would prefer this use case does not break.

I should have formulated it more carefully. That use case is not broken.
What would break would be the ability to compile drivers (in this case DSA)
as built-in if the bridge is a module.=
