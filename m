Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B392846D122
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 11:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbhLHKkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 05:40:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:8903 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231713AbhLHKkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 05:40:11 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="237746057"
X-IronPort-AV: E=Sophos;i="5.87,297,1631602800"; 
   d="scan'208";a="237746057"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 02:36:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,297,1631602800"; 
   d="scan'208";a="658146776"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga001.fm.intel.com with ESMTP; 08 Dec 2021 02:36:39 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 02:36:39 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 8 Dec 2021 02:36:39 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 8 Dec 2021 02:36:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yy3UGzga5c52JzyvFEALh9WzQNGx9l9IJBa8iX5SXJ2zzUYn0CyZacV52a9GMtK8CCfhKCou9Pycxm6HYvBKMLOmY6UuFFykjw3dkq10W8+tJr+Jn+bkxA58BgxtEpfP167k3pXP/BWweyOFQLNjUSFLzfHEMJVMBQ5dApocCN3+WXDcM3UyaqOo0Pw4wRVYQs1RBI+Pdm1gyzSc0VqTnZo+cUfh2zs/BUu1miEfYrxu3NAJSuLazcFzuqePsipYBms8twjkjoqsxcTNtmX0I5v+RtgTmEIEbwTPG677yP4K8Mx41bTjKtUKvlB18WbaQcyOxQBAesCWNa77TIB6xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=go/evqgObbXUU8Q/RhNOeGBoxlw2MplFkgrbTGDJRzA=;
 b=KYb7Bbm0aaYoeWd5qhwNWPEocja9E07S619XY9CWdPg0HZ/ctf9nxrVTl2CekPEoXandv5ORZCFTUoqlywPe51DNBn3h5vdLsONDBGw8xam+k3A7/m/+2fR+NbXAS7WyMsCnnvQt/gyHAQ8qimPTdWHTqx86dBhAv13BkgCiPiANcG9V8fvFasuFnLaaQ/IBdns3E8/8zzW2CuN09d4RCNXkJnXeLptPbJ8JzHAvNPJYknltTgYsKI5ptKvFFJyLx67pnC7IEtNkTD0vT+neFGzNpKCj1pif6EzawuDo+r+L0FFCfW24ix538lgin5sJpcy1BGVqgCuySHQMkDcPWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=go/evqgObbXUU8Q/RhNOeGBoxlw2MplFkgrbTGDJRzA=;
 b=e51rqqyta4p3qmQ2xMsQaCqF4Luz7bHNd8mmccLN6ccTaSSDTBhoZTFD3fR7bIPXAXWbo7hZ0werb5fOTiecoM75swHqOzZ175FAz8Mbjutkm4Sl3b3m5V7iCy6TIuuLcJQb0HiZ9qrOZD+dbMXB93a/dnbkNW1z2kKH4tVE9bM=
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by BYAPR11MB3816.namprd11.prod.outlook.com (2603:10b6:a03:f8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Wed, 8 Dec
 2021 10:36:37 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::9d49:ab80:11ed:29d6]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::9d49:ab80:11ed:29d6%4]) with mapi id 15.20.4755.021; Wed, 8 Dec 2021
 10:36:37 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        linuxwwan <linuxwwan@intel.com>
Subject: RE: [PATCH V2 net-next 0/7] net: wwan: iosm: Bug fixes
Thread-Topic: [PATCH V2 net-next 0/7] net: wwan: iosm: Bug fixes
Thread-Index: AQHX6ehfjU2wqBE9JUS4WZ8wpR93OqwoEzwAgABVHDA=
Date:   Wed, 8 Dec 2021 10:36:37 +0000
Message-ID: <SJ0PR11MB5008DF57644F95D5FA606BE8D76F9@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20211205150455.1829929-1-m.chetan.kumar@linux.intel.com>
 <20211207212200.507260b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207212200.507260b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 852b5b61-89b4-4dbf-7628-08d9ba369d0c
x-ms-traffictypediagnostic: BYAPR11MB3816:EE_
x-microsoft-antispam-prvs: <BYAPR11MB38162A32DCF79C61AC8B0BC2D76F9@BYAPR11MB3816.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LTVclUh9HPgixJnTd7igLmlI0ygadkivFb/7BnGnPS40o3PQ8U0KOS4aCY7wVEGqqUXDW5/O7EgMByVFpNTUpeAU1nyCc/QsIvtSiZ0zKU4LwaWBI8++mL9Rt1lkg1LvsR7zFNYor1yJk3nU/Oqyd7JIz9zqfnGSCMY/UwPdiy9+v+kpsK751BEfZwQ/PUh8Fv/UCqkIF4t7sbRHZ583vpFULUVpxgvWgF2ybLpRn+hllrDBrzrr8+a1NDuMkefuedHjSuypiovgOrk8dFMndbKlsvLfbiJI351yOBQYHRVktAbufd8hyO5DbcEQ9RBU+nZUTKUA+IP4OewKw1LNJPz4jJhEnaDE816Y+52gwNc4iRnzP5eRlz5G3x1pQJenhc3lNEkQxOQcAFeix0lZsvn3IeCHIceJHfoKLcfLBBo2Iwc0jiZujC/aqOAnFpbkfocWoy9g8/F+VhWfB3CNFFSelXCNagr1cSgU+FnO8jdCvPsnQJpFrdOHGyq2M6MNAtFRwxWYcpo3njCaN+Sp38kj/vQHjP1i0vq3GNYaO7wNduKcRgAg3SXSWb5joSuTPmv80P3m7TjsFNOQtJhjmDWpYO8WACObGdMVypinfZqncpO1na+31TecuYL/cM4AnhnvSTXSmFEJfYcpHUsfkkLW9DQK4EBEEJrntq68jrfacBRzisvVSlP86+q0QsCYChO5eYMQZUvl0jixsNaUGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(86362001)(38100700002)(76116006)(66556008)(122000001)(66946007)(9686003)(66476007)(71200400001)(5660300002)(64756008)(66446008)(508600001)(26005)(82960400001)(7696005)(186003)(38070700005)(52536014)(55016003)(83380400001)(8676002)(2906002)(8936002)(6506007)(53546011)(316002)(54906003)(4326008)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jxoMCFLXZ07oyk4ypdRsOtOxq0eA9/XXErPBeQ+2m/XCoeGvtBmDk4lkER3e?=
 =?us-ascii?Q?XkVg30br7LPDPQqiCiPlC1EZLjortrtuWoUjJT7M50+P8Uk5dGQzeiDF3BBh?=
 =?us-ascii?Q?Vlhkq5dQ0LbGfXJY7hyEpt7437buZ0PlBI9fuEa9CTZgapCES33QBMg02Saa?=
 =?us-ascii?Q?TRn970FhJhbcyc7JEERWDzbjmSPOGdFpsUYh4D/1/PHWgrBApSS5NsILlc8A?=
 =?us-ascii?Q?KQZszUOrjLZcww29cKhO6QBk1GkTDnM0QnNUZ1ifW0TqLRY365mORaa4+bn0?=
 =?us-ascii?Q?/LMXS0CDzJjJ5E1kar8Ia+f7BFR7Y2qilgD08rFDpvYRKa/As7+sX6o6QRTr?=
 =?us-ascii?Q?eQbXDV27WrxsK8shBiMPkvjHyQJdwnMy9ucaHggnFLKRQHT0jGJMY2p08+jU?=
 =?us-ascii?Q?hoQi0LozECTQqS2jAFWr8a5+GODHQ317exGGJ9p7XIF0VjWSpgKjIt4UbJZC?=
 =?us-ascii?Q?kXISkbvO8lDnwZwO8dE6seLLDWRuUZ0ySCPXuQIbscPJk4q1I7RI2r5BdsiG?=
 =?us-ascii?Q?eBYlfUL/U9MbeT7oM0iHZ4TuFLTfIzAzhlbYAogM0295tOYaDj+7bu9ltub3?=
 =?us-ascii?Q?RYyzFS7eU/0Q5KZguxZnA2uU5iSvIrXsZ3QV3q6M3Kcrl4HqS1U5ZeBXNvgs?=
 =?us-ascii?Q?XQFYUEK5THn8YHs+R28btUjrY8EzADfH6G7n6pSdU+YDwXRmRL/6uWnjkAZd?=
 =?us-ascii?Q?lCDo4fgEdUELzwabHmSlZgnbtW8Cy3G2NFAlQUPck4botZ0OfFt/NRhQHrg+?=
 =?us-ascii?Q?o6axFDDFdsXjqhQfAsz040SS5Uy7rzNCTfXsG0ORU1l4id4NdDBK0CRF+4Pa?=
 =?us-ascii?Q?ypSnCQ+cgD67O/W+7UkjmaZyD57Rd75yrujmw/y3+k2wuIn0/JTMKxg7lWsx?=
 =?us-ascii?Q?EXMlym9QK01Y69f5tCPFvuOShBA0Rxd01E5ck6TNJ3F6MkdG0FYWeKyBozZv?=
 =?us-ascii?Q?614UsCLgcSnqL3zKxjBguXLWsfaltoeQctEGB3k4swPN8PWnWYxtvEQ6E/gl?=
 =?us-ascii?Q?+si0Q++DLUD7aB7U+8oh0CvEZs26lLzGAVPxmCd4d3rIqInpCVbA8K1XbVTN?=
 =?us-ascii?Q?lLCGkeJ+Tk4h7xW7V9RixNZ7ZKfSAMApHbD3stLHT107v5zb+8E35X0NWPsP?=
 =?us-ascii?Q?K8N84MFJA+pd7DXY+3Jx4aQgUb4ukDkDktNR9gKrcc1s6k2c2mCc7OVLU+BD?=
 =?us-ascii?Q?Grl12CnqzO2pVimVdQqfYFj9E0Q4inIfiZsW6vgzBVvOPgzEhab2FZnZcLHQ?=
 =?us-ascii?Q?54o5kZeJHFImj2SM7nuJGJuf6aT97wWuD0EMU0RFQJ2/xGXPfWvq9pIHbgKZ?=
 =?us-ascii?Q?IZLMZb0HZ56xLo9SXlDoQHvuLwmduzwHD2UR/gnGzR2zH00an9Spl70JpxsM?=
 =?us-ascii?Q?o1n6qubfb8q+Z9YKBanGbiXBUxAK/IdQLtKd6O1o2Kj/KpDzGwM2XThbuRaQ?=
 =?us-ascii?Q?KYDhLrpqNUbPnmi25hXRvXZi2iRq6C3iK+AhxOia2DvdGlDh+05c5v5VoVh7?=
 =?us-ascii?Q?+QZ7YYQin7euqLd2AOyeLq6LLQiVNgmHIf2fwvENWIe7akVVlinJ6QdvyAkx?=
 =?us-ascii?Q?OHVxbXeS0UwCDocH+5ooDv/xjJ2TAypwHZNpi8Dt9ACxkP1d9Ly51bg1s18i?=
 =?us-ascii?Q?2U6vogXcpyG3d+kW0u04DWARP1bmwcuH9l/M552n4bw8qZXxS1XPjIbwb3Zx?=
 =?us-ascii?Q?nb7ydg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 852b5b61-89b4-4dbf-7628-08d9ba369d0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2021 10:36:37.4609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dm8Y76ZruHJwa1dTFAp/T+5AZcxFEz33lxf4sdfmWQ5Do6IsCgCnz6At2r8QPyI2bDjUlznDuWQJQUvSlydRoBVfzWWBz4nvImcNSrXpwtk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3816
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, December 8, 2021 10:52 AM
> To: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net;
> johannes@sipsolutions.net; ryazanov.s.a@gmail.com;
> loic.poulain@linaro.org; Sudi, Krishna C <krishna.c.sudi@intel.com>; Kuma=
r,
> M Chetan <m.chetan.kumar@intel.com>; linuxwwan
> <linuxwwan@intel.com>
> Subject: Re: [PATCH V2 net-next 0/7] net: wwan: iosm: Bug fixes
>=20
> On Sun,  5 Dec 2021 20:34:48 +0530 M Chetan Kumar wrote:
> > This patch series brings in IOSM driver bug fixes. Patch details are
> > explained below.
> >
> > PATCH1:
> >  * stop sending unnecessary doorbell in IP tx flow.
> > PATCH2:
> >  * set tx queue len.
> > PATCH3:
> >  * Restore the IP channel configuration after fw flash.
> > PATCH4:
> >  * Release data channel if there is no active IP session.
> > PATCH5:
> >  * Removes dead code.
> > PATCH6:
> >  * Removed the unnecessary check around control port TX transfer.
> > PATCH7:
> >  * Correct open parenthesis alignment to fix checkpatch warning.
>=20
> Are any of these fixing functional bugs which users may encounter?
>=20
> Looks like at least patches 1, 3, and 6 may be?

Right 1, 3, & 6 are fixes.=20
2, 4 are improvement and 5 & 7 are cleanup.

>=20
> All the fixes for bugs should have Fixes tags and be posted against the
> netdev/net tree with [PATCH net] in the subject (meaning a separate serie=
s).
> If there are dependencies between cleanups and fixes - you'll need to def=
er
> the cleanups for a few days, until net is merged into net-next. It usuall=
y
> happens every Thursday.

There is no dependency b/w batches.
I will break into 2 patch series and submit fixes to netdev/net tree & impr=
ovement/cleanups into netdev/net-next tree.
