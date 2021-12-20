Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E6647A868
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 12:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhLTLLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 06:11:36 -0500
Received: from mga04.intel.com ([192.55.52.120]:38499 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230300AbhLTLLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 06:11:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639998695; x=1671534695;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T3rWkgDH5bfIf/c18hH+dXpM44Qa+2wBY6ves2POqL8=;
  b=LM5I2DpLF9FaRAGhXhaQBSIJ33oCZVBRm/kAuHvpk028fK4ClvqbJI+N
   /NATR/SKltCC5VY6WOhIUkGaiXJjfqAjBjwrO4Uno1faM0+OP8L/NfPuR
   gELwO0jUlrPN8cD4zIMacRReU4+YrSPeK0o1PKf0aJwDxQpFi8YS8bC4b
   f9aXnxpvt6F09zAtXPAR8SjP4bwhpPDyRKGLj0eqv+oSMFwKbmR+af9uH
   Hv5EyZOhFP1KI/yhffCMg/IAb5an3apc8NfNQ+cgkveaIMPWWv1Ili0Jg
   ZNNHo/zUrPyvuXP8lpAvMOyY4WcS4oQOo2/YD71l5YwZeFIXlhPQA/nSO
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10203"; a="238887951"
X-IronPort-AV: E=Sophos;i="5.88,220,1635231600"; 
   d="scan'208";a="238887951"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 03:11:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,220,1635231600"; 
   d="scan'208";a="507646416"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 20 Dec 2021 03:11:34 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 03:11:34 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 20 Dec 2021 03:11:34 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 20 Dec 2021 03:11:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfnuFV2xn+eSqgJDvGf76LAsLgn6b9+aOsdi1WdQxk9bNduwAsUNh65nAOaT4SIjD89UyyxpWBGljdAx6CRcTUIz8Fo5shp1UveGu+v3fTp6eq4yfpCREffCFMF3ijIEeIbg82g3oiAQOWpXEY4Rysq4FvyTNf2VmPjLiiVhCBJJMyQFqlOR1aLWMa3sJC+70pDaSEJbKOaXl5kdgCdNRSZbYTxyR3hVWXJ770J//igJBGkArW3tSI57zokehPZPadGySfRhBw17C3DVm6Eju7r//Dxk5+2KxmvNyGfzgDg3rNeHwxrIXgcu7kffOUBAM2z1By3iSC7aMav7Uf3bgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3WXOCW3EUzVvk7UhXGN3Q9r45m34olQUGdBcxbMJvcU=;
 b=deWmiOvyWMw87HyZnFTX88gPVWpxAj4tGcwrIhe+HPyGz3hihVKkWWZr/S2v1AHXM7kohp37IP2G2U+Vuu6YocSmIXhOe9d7Imepc2rPI8H9yT+tret++ub4OJr7JZjqhuVmyOYrSaNGTvqRwZ44TkWkj00eO3i80tRvPsp4lQ6chK46nnb+HprBHDbUTs40ApokI3XMu12bFoK26OT1i6cP3u3GKSYpppyegM/PiuLJCOLlyh0YNB50pSobTIjEdC86LQs20AgufG752O0/T2Fm6vWDj97pWqj6mxLyYrSMIEOZ4oICaQaqBMCUNwE/FYv45qGa0jQHz4oyHJuwCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by CO1PR11MB5172.namprd11.prod.outlook.com (2603:10b6:303:95::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Mon, 20 Dec
 2021 11:11:32 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::116:4172:f06e:e2b]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::116:4172:f06e:e2b%8]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 11:11:32 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>
Subject: RE: [BUG] net: phy: genphy_loopback: add link speed configuration
Thread-Topic: [BUG] net: phy: genphy_loopback: add link speed configuration
Thread-Index: AdfwtmkvCyrAW5M4S3mERBKDxICdHAAGBHqAADANSQAAAa06AAAAYHXgAAC+sIAACnbKwADzleqg
Date:   Mon, 20 Dec 2021 11:11:32 +0000
Message-ID: <CO1PR11MB477197B3DACAF00CCF94631ED57B9@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <CO1PR11MB4771251E6D2E59B1B413211FD5759@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YbhmTcFITSD1dOts@lunn.ch>
 <CO1PR11MB477111F4B2AF4EFA61D9B7F4D5769@CO1PR11MB4771.namprd11.prod.outlook.com>
 <Ybm0Bgclc0FP/Q3f@lunn.ch>
 <CO1PR11MB47715A9B7ADB8AF36066DCE6D5769@CO1PR11MB4771.namprd11.prod.outlook.com>
 <Ybm7jVwNfj01b7S4@lunn.ch>
 <CO1PR11MB47710EE8587C6F4A4D40851ED5769@CO1PR11MB4771.namprd11.prod.outlook.com>
In-Reply-To: <CO1PR11MB47710EE8587C6F4A4D40851ED5769@CO1PR11MB4771.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c68126c-c8d8-4118-14d0-08d9c3a97ab2
x-ms-traffictypediagnostic: CO1PR11MB5172:EE_
x-microsoft-antispam-prvs: <CO1PR11MB517236BF0BD7723DC3ABC877D57B9@CO1PR11MB5172.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5uvz4fRXTBUK9jzUCGiyETWVxzifrAHI/xuXB+IH4ZJKJ7wTVuaFwBnvICpAn6Il8KdNdD1v9++47QV8OzG09xnvWjSfeKPGPA0LCFJbkRPZNLDzpt9i1IJ9VyFkFwPt2NH/7E1u3+320PFj28C3yxtEqqJJmEUch9Z0bBSywDQE3s9yCCrlT6zuten+iIffPkxIYUfhnM+UKjetzk3ZaQzo6obSD9j+4vUF8TXkZupRFaf0LsKiSDcJF5m6CTG446cJDhcXNNKcxeCWQle1zfinke1QEWXkWhOVGQCxmYZaog60bc1Tj38aiAt9TmYuK4aVtvafX7ufEyUf20pEB2buMQlFzhFJvk/XbisQMv3SdxaPuGWMaOc60oBUJe3NuRzz6vbe4G5F2bOIwx5xVLf7OXYD0I1KbBoTxqk7zCbNULrDM1QXmhnOLOqs4vqiFIQCrUWmaKyQs2Orjws9l1nO1Vx+TjqGxAng29RkQT8Jumw44yDFj0xZ7w8984eaMzybrmcZOcTGbTSvZCyRXU/h87EVywIY68AKsq/y000AvDUDJ6Nyy6aSPSS6wZBCEkIVmuYA8XKbsq72plddvEMWkz7aeKK1zB0/3iJ/1UpTcpSuhwS3JYNHw2dxFSeSBQfjshgavd4FvjV3mLFE6P4mgA3unvsdJIotx+sFCyEOL6py0njiuONwzLk0ew/FJgXI7ApD2rReVwQL+O3YSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(64756008)(33656002)(4326008)(76116006)(66556008)(66946007)(316002)(54906003)(186003)(26005)(66476007)(71200400001)(110136005)(66446008)(83380400001)(8676002)(86362001)(55236004)(8936002)(52536014)(122000001)(5660300002)(107886003)(38100700002)(508600001)(7696005)(6506007)(53546011)(38070700005)(2906002)(55016003)(9686003)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/1F8OltmH2xy56jIC+URqVybRJhX/JEi0lz4wbojN2HCCEQXvAH0ftjmUR9c?=
 =?us-ascii?Q?wZpzaEomsBBl6nigLFdd1hDYeLqvHPn3wr/or529EMVd8LixTQSFDgJOKKFY?=
 =?us-ascii?Q?mOOx+vEV5AyidBJCY22qUZoRKgonFyyYh6XRMNz4bpoPCLmUc3CB5eOlY5G4?=
 =?us-ascii?Q?GyjMdOaolSXdhDJciYM/qHwlcgcKZNZ0JJgNUTZSkmlPRRbHAC4G9aPOloVq?=
 =?us-ascii?Q?/iE5Y1lPQx7nBBRIMgolVdNQcn+FlWSEG1dtYbYFPUNV3coOk2wpuqGFd3cJ?=
 =?us-ascii?Q?QL64vCINH7R3dE5Y5D780G/3e5HnCtq1w+GjsNDoSrj999AXjV2FdK2dnXb3?=
 =?us-ascii?Q?GsPEQ+EPuf6mveoX9MJ3DuYaNHc9klS07NUdYpGd5yJ3c7LdYykj84m1FjdW?=
 =?us-ascii?Q?wqA153Btrf/5BkL7SeVuVddus2zU0bhNRBTdbmZu5et33cZI+gCtpV4f7wAK?=
 =?us-ascii?Q?1LKBtyPd8qz1DvcDl3eEZllouGjtIQSBnUIFnRZMctiOT6OugAl60vEwqmef?=
 =?us-ascii?Q?9eMZS6RVgB66ctA40llbKBhy/ffA9DhKHVtEuAQaaVebntdI5V1v+tE1uGL5?=
 =?us-ascii?Q?/U/YQh3uNUO9mHTDZVspm+wp/UVV+ME1JdR3hgNpdHf32PqBv+wkCVgpgnSc?=
 =?us-ascii?Q?Y11AT9MperKmo06AJ0Xx2CPYjo0nxAUSZU+6lUQJvlRCITvhWeXNj8eYquQs?=
 =?us-ascii?Q?0s3zgWuR8aNeBqnrKpSwdi76FdylrsdvVoNG1a7eI2TXH7+OBP0++lQpwuSv?=
 =?us-ascii?Q?KpwvWWnyebXdN7Ifixo1UfsOqMyumgmuM/AvxaSQPnVAiQRryto4u9jPDtVh?=
 =?us-ascii?Q?tuMPl/dC6kflAqJlYZ2PekgIbCG6kk8pOAFB/aNOOeHochkWWEmvCFTDuj0f?=
 =?us-ascii?Q?juHKC27wXNNQv9JJf0GM6vqkheUzVwMU2HIAzVWklMqTmH/yY8ohTQfdatqg?=
 =?us-ascii?Q?+HwJQ/dEOE5aPNE7qVe6XgbhtaZQuOBnY+soSKtTRAPWoNJ/6pvqoECSTOtV?=
 =?us-ascii?Q?91Slm3RSy2qiPN7MtWNexOTOmq+pjLizHsCyWmO9Yv1q0oyMv+Bz4Ez83+I3?=
 =?us-ascii?Q?VJeyNl3hoJmyVD/0XZuH+4WqHplHC9tVDaeUMcGhzUtWumX10INtqjvxyNpw?=
 =?us-ascii?Q?XTmpr1QCu7Wdldv6BLSJq7x0m1E6nC8LdQQ121iAYEd+xPvSyMT3SiGybz0z?=
 =?us-ascii?Q?6S+9GzPwKnMXZX/yoLdcoxtREmtgwFsg43bLAGqdIPF4CYEymya+L3EqlX48?=
 =?us-ascii?Q?n96I/EgsWup5W54ktX2dniOiayu8Pl98PNe3c7MQL070+PPR0Z39ZCb6fWXB?=
 =?us-ascii?Q?wgeSXVLTgnbjDyGV2Y9ARu1XKHUhByCisvv8gMvZJNE5kSdoYqP/YIaalqcc?=
 =?us-ascii?Q?yF2DtFO43ObGTW6UqRYXlb9PzJEHQX5GbM/KqyoRVAl7CnJ8oy0Wf0TsypJv?=
 =?us-ascii?Q?3oxoA7gW49SZ2oZWl7HcvZ6nQeyE13ipYPiBimOKxTL2HUJOSq3X6axrOMWM?=
 =?us-ascii?Q?gJRydJG5K/3GorH6Fw63pauhAzP0C968ipsvkQ7K1Ri1su7JMGh6U0AlZK26?=
 =?us-ascii?Q?9ZXBv4aE4oyUAn0FC7qgK4yuOCNalyHAxErfocw/qSSUypJJPNtDjM1fafBm?=
 =?us-ascii?Q?69qUvy5K+8/g0L4PSgzKqF2mGIYN/CoRvQQIPyQQFmtAZF+XcgXD+SkbaV9x?=
 =?us-ascii?Q?smL2mYSudMfw/ypIX1R64HqUkhzCbptx3e87tV2xuzY28CCI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c68126c-c8d8-4118-14d0-08d9c3a97ab2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2021 11:11:32.4398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VcarzqFQv49ul8bYYa3ys3byZ1wK9NhY0pDec1LGMV3S2j5cWPZIL192w5+s6DY1dZpz52UN/cXtdebLo+1XL4HBeSGeu0nm6NIRAXqyHdk10ziNUAxMn1BJ6OUFrygU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5172
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

As the current genphy_loopback() is not applicable for Marvell 88E1510 PHY,=
 should we implement Marvell specific PHY loopback function as below?

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 4fcfca4e1702..2a73a959b48b 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1932,6 +1932,12 @@ static void marvell_get_stats(struct phy_device *phy=
dev,
                data[i] =3D marvell_get_stat(phydev, i);
 }
=20
+static int marvell_loopback(struct phy_device *phydev, bool enable)
+{
+       return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
+                         enable ? BMCR_LOOPBACK : 0);
+}
+
 static int marvell_vct5_wait_complete(struct phy_device *phydev)
 {
        int i;
@@ -3078,7 +3084,7 @@ static struct phy_driver marvell_drivers[] =3D {
                .get_sset_count =3D marvell_get_sset_count,
                .get_strings =3D marvell_get_strings,
                .get_stats =3D marvell_get_stats,
-               .set_loopback =3D genphy_loopback,
+               .set_loopback =3D marvell_loopback,
                .get_tunable =3D m88e1011_get_tunable,
                .set_tunable =3D m88e1011_set_tunable,
                .cable_test_start =3D marvell_vct7_cable_test_start,

-Athari-

> -----Original Message-----
> From: Ismail, Mohammad Athari
> Sent: Wednesday, December 15, 2021 11:04 PM
> To: Andrew Lunn <andrew@lunn.ch>
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Voon, Weifeng <weifeng.voon@intel.com>;
> Wong, Vee Khee <Vee.Khee.Wong@intel.com>
> Subject: RE: [BUG] net: phy: genphy_loopback: add link speed configuratio=
n
>=20
>=20
>=20
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Wednesday, December 15, 2021 5:55 PM
> > To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> > Cc: Oleksij Rempel <o.rempel@pengutronix.de>; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; Voon, Weifeng <weifeng.voon@intel.com>;
> > Wong, Vee Khee <vee.khee.wong@intel.com>
> > Subject: Re: [BUG] net: phy: genphy_loopback: add link speed
> > configuration
> >
> > > > -----Original Message-----
> > > > From: Andrew Lunn <andrew@lunn.ch>
> > > > Sent: Wednesday, December 15, 2021 5:23 PM
> > > > To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> > > > Cc: Oleksij Rempel <o.rempel@pengutronix.de>;
> > > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Voon,
> > > > Weifeng <weifeng.voon@intel.com>; Wong, Vee Khee
> > <vee.khee.wong@intel.com>
> > > > Subject: Re: [BUG] net: phy: genphy_loopback: add link speed
> > > > configuration
> > > >
> > > > > Thanks for the suggestion. The proposed solution also doesn't
> > > > > work. Still
> > > > get -110 error.
> > > >
> > > > Please can you trace where this -110 comes from. Am i looking at
> > > > the wrong poll call?
> > >
> > > I did read the ret value from genphy_soft_reset() and
> > phy_read_poll_timeout().
> > > The -110 came from phy_read_poll_timeout().
> >
> > O.K.
> >
> > Does the PHY actually do loopback, despite the -110?
>=20
> As Intel Elkhart Lake is using stmmac driver, in stmmac_selftest, return =
value
> of phy_loopback() is checked as well. If it return -110, the selftest tha=
t using
> PHY loopback will be recorded as -110 (fail).
>=20
> >
> > I'm wondering if we should ignore the return value from
> > phy_read_poll_timeout().
>=20
> Removing/ignoring the return value from phy_read_poll_timeout() can work.
> But, the -110 error message will be displayed in dmesg. It is because the=
re is
> phydev_err() as part of phy_read_poll_timeout() definition.
>=20
> -Athari-
>=20
> >
> > 	Andrew
