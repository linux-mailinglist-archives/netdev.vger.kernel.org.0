Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6757638936D
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 18:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347312AbhESQQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 12:16:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:20818 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240333AbhESQQS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 12:16:18 -0400
IronPort-SDR: YKvGnj4SKpPNa53o9IGPH6b73JfMeSvLzy/Dx0gzlPEdQpAVczRUw2SQcCE4foLv3n1K+cT+RT
 yK3TnEZ0EJfg==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="188140951"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="188140951"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2021 09:14:06 -0700
IronPort-SDR: XoyYvUHfzBlFgK1RDP9sjUotvtBzefhUTUnRkeSn8ADA6qsKhvexJnpMUNmVANs8x+Y3u0sXyj
 +tWN00hjphAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="439790784"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 19 May 2021 09:14:05 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 19 May 2021 09:14:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 19 May 2021 09:14:05 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 19 May 2021 09:14:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlVn7uNKD/wmrhQHT+rCW0OAdKCZWTKDnzIDxN6cCS+KBR2J2DbpSS57Cx1i8sCwRQxcm9F4Ls0cDhQxiHptaR+Qg0txEA67TJeoSz6zoMB/Pbf2/jFAh4Stv9nMGyYs1NUIMObu4nAUbSDyiaUSxO/Ki73fGxcN43rppgX4V52d5nZcnYl5lsMCDSC7axXeOoYn4yud87c5BFxzGQbU84t+zHrAcahmN5xZ6k5yziVQhnSubQGfu47rYaRbh6zDCTQDf56kYHGhGq8OCske06SqMc/XIuO4oHNEpNvXVLEbCjYldn+bgSb+wcGLgKd9v17cS/OHEyk6aoVFEu9tyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N17Kh1emlf7AeSdAvmCi5pr7gGxVs8C1IT5icVPavww=;
 b=KNe/iRT2Nq8lQUFDn/XaaaJl79JykgUoa3h+Orju3oAaIAQ53V8vVd0hi7nkPwHi8uHpUa3jxiPuZoXnwLlIIwL2XY0BPXsr4uXO2d+LyiBMb/w8iiAbvaMvajuZakCZQKUFop6SyzUHz1akuE+bLb2Yv/HMzO0br8car19hIwPYUwlPekm1E6tzGQlOjASnbzvsipXw8qp87zu0Xa6vQzf40QNjdMsTD0RA1Z0TPnM8obCrm8/SfyHkdDSb4mpGLU1/OzPhw7RyeNGIQYS96JG0QmMwUdyFw0qWE6OpOvYA276M6Y/IXP/NvN1mjNLms1AhM6xVctV5bWsM5toxGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N17Kh1emlf7AeSdAvmCi5pr7gGxVs8C1IT5icVPavww=;
 b=Ea95oTOLAXkXSOHTqdP4Qx0AEUxxP1vY6/9HpEAFFwR/lTfLlFzm+eG3XhdMFsFhbE7nfK0uw6Dcyw4bxBdaVMWETxb/+Q9e6N+/3Q7WTTAyttle23r+pq9gia9G8fdOSwc4iId/y9SXAmumh/r2rU64A96mMci+9vqsOPbSH8Y=
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM6PR11MB4580.namprd11.prod.outlook.com (2603:10b6:5:2af::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.25; Wed, 19 May 2021 16:14:00 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::ac71:f532:33f7:a9d7]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::ac71:f532:33f7:a9d7%3]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 16:14:00 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-net v2 2/6] ice: add correct
 exception tracing for XDP
Thread-Topic: [Intel-wired-lan] [PATCH intel-net v2 2/6] ice: add correct
 exception tracing for XDP
Thread-Index: AQHXRYB7dRFFWVvqCUGH1lEZuLFoM6rrCLtg
Date:   Wed, 19 May 2021 16:14:00 +0000
Message-ID: <DM6PR11MB3292937F02F29A6C81176918F12B9@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20210510093854.31652-1-magnus.karlsson@gmail.com>
 <20210510093854.31652-3-magnus.karlsson@gmail.com>
In-Reply-To: <20210510093854.31652-3-magnus.karlsson@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [106.210.166.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 942898d7-f25f-4e83-de2f-08d91ae11ccf
x-ms-traffictypediagnostic: DM6PR11MB4580:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB45806BEA82B868BF02773917F12B9@DM6PR11MB4580.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CEzdsc9LOTbf6zth07cIBt70bDlqDXdnNFhU4XL9JDdjxfU856dYFvVy5r23I9td4x3iWTMcYbnw8ZJSlYPKl6NJqBbYjWXZY8D1FW3DEdzFn6aq7msJx2ARwgng3m8Vm8WdwqJcLhZihpieVE6pQym5v1y8qiXlAKGL1Ks9e1BRgzgaK6+1LPypsXDiLMzSXCxZQuh/Bh17kDxEEYhrAo82CNAd3eBVca+XzcWEuVJmVnVXL2ydXJ3i3cVBYP9OgABTohFN1t7p0e5NwsJkK5rYEMxvZpM5GMx2TFpRB8ZSuX/35KrH8kF4X5GnAjquxxt6EqhbxPlukvUZYXo54UZjnZ8YHI30UljcjVL8HWpcle3AtZp+wY4iaxPsb77EnsrHbPzAqAu9thZLgIViTOHN+orMPnr4oSob1B+WWJNKDGLc3kWCTC+SdXz1QLGTY+VP8zqGaNneOCjjHYGrI1XA64PXh7UK9LO2wAalo0qP2BA9z6nxDOY2JyTlkgyGbpKWpB30mJGBMPbCdz8AkNituoiQP4OF/Gu0WQjdmfV7MvsBgfzqRpT0I0Wi3qSo22K6l2haDZvvqZTlgQ07jq9S4V+CRj2MpcIWDY3iMLU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(136003)(396003)(83380400001)(5660300002)(316002)(26005)(8936002)(53546011)(54906003)(186003)(8676002)(71200400001)(478600001)(6506007)(110136005)(55236004)(7696005)(122000001)(6636002)(4326008)(33656002)(76116006)(2906002)(52536014)(66946007)(38100700002)(64756008)(66556008)(66476007)(66446008)(86362001)(9686003)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?apZNSX23eZHTfF3Rrf/kZsZ+l3h1IV+jT8G3u4u85zLDiFq1ki7GOV9jRnH7?=
 =?us-ascii?Q?lIxtWHbA/2y8+Tas/4Odz873r+/eWCcZovnqy5l/2vSPCa6rS1m8+50iCn+V?=
 =?us-ascii?Q?iDrH76koZuAg6b2vFerca61O/jnu93kWx413JyaSX6nV5BQ1IqIRO5HuuZmN?=
 =?us-ascii?Q?OLYpixs78USJM1wFelv0AHzapgFB0bGC/cf8zBJXbiXT5XIujLJCX09jm9Ut?=
 =?us-ascii?Q?//izhp51eO5dBTRvFQz42GX8bXx7ffxEyTqWVG2JcdnWkLG0fwDuommFwSs3?=
 =?us-ascii?Q?ExOAal5+3N+DlOhh/O1cOET1KtdX02ETVa8Ede6Bh/c2l5zjzmUOjib3bRJb?=
 =?us-ascii?Q?ZxAvcItRmALsyvcQnwaC5ivRgbk5llCkjerNXv1DtZE4pUqQYhZWRVlX42gj?=
 =?us-ascii?Q?QPgSunkVzCiPaTnHMiZ8YlyHvEj82vEb+Ahh1Fsc84UxV2APdUNo2iOJ6WiZ?=
 =?us-ascii?Q?x+WrnGWZtiezcdnu7a/TU3O5NkGHxUK1Ku/jFZ/KBbC1qXBtD/fpIEjlH06T?=
 =?us-ascii?Q?8WT8gQSa2WkpTg7j7d4jkosKZRu7MQAE1eHP9BLENyKj7oMeETZCjeV+OtQz?=
 =?us-ascii?Q?YxtELtAXGBwpDErZxlvw1R0SGpIMoYQ9AL2ZabvU6mjIGhRVPcxgVbRAycuO?=
 =?us-ascii?Q?kZFT4o7fPI/i8UKAiUWqk4j7x+VNzIKCR+LyRhJuDHZJ57vYd0BBvuIL9X/F?=
 =?us-ascii?Q?XRltPOKK7iCsDK1yjq+Tw/RB9VIijqolRL2Hv8UeGq8Ew+fotdG2mIxSU2vC?=
 =?us-ascii?Q?Qc0e4yLHFvS+77m7Dg4SdAPI/y6W+ZoWjPGODwj1uN+vDXWOd30A5BrOW9Hg?=
 =?us-ascii?Q?MGg2pjPQtvCLU4J1ic1fsFNjGR0jGpW4bJlTxaeEahNiLW1WUySuJB31bTyJ?=
 =?us-ascii?Q?o0QFtwRl3FIEXxG9HryRkBxq8aszah8l0vQ8hLg8Uo5hXeVm2gKTy7b+DSBl?=
 =?us-ascii?Q?x/6wi0j82TpTYSiJxaTYN8rUrRfD2OU5xXVJGYkIljO+3PkiNZfPrTZt/8k9?=
 =?us-ascii?Q?Vc1rUuDudFJKIaTxR+hIu42Ji5JY6jli+raQJ3eGw0rV/oLqZtKWzEtPbQ3z?=
 =?us-ascii?Q?7DN5HsIt0o8tcz1OCRTUukMPWy3Flzm404OyIbmG8TjX6GSGJ5+huxHm+AqA?=
 =?us-ascii?Q?PIa280zSCn+vUkB2wcrFiTUnE8LtJp6TeeEKyJdLAl0ByDJPA/mtInr2O/1P?=
 =?us-ascii?Q?xWtaTJyn0mwpxK8uVfZbikI7XYEJt2jgMZtUQhog3ueXGss+TkIvbbS+SDZ+?=
 =?us-ascii?Q?aw+GBfWsJiZBz5A6p2yH8b0B0xHREg+TeyB1h0EUWlC3CMcwnaL0JS04Obqk?=
 =?us-ascii?Q?YTrQfXEqVWephpFKR2iQzW86?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 942898d7-f25f-4e83-de2f-08d91ae11ccf
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2021 16:14:00.2116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SD0mvPGQTpAfvqi7N0Hx6fX+cT6ifirFx2URdRe/Wx/VPNkPkvOxUtPPm2MnNH7cUdTEYmghs2aRYaC+sR4t6YW12Ahs5ISPKYr3zLeBNJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4580
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Magnus Karlsson
> Sent: Monday, May 10, 2021 3:09 PM
> To: Karlsson, Magnus <magnus.karlsson@intel.com>; intel-wired-
> lan@lists.osuosl.org; Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> Cc: netdev@vger.kernel.org; brouer@redhat.com
> Subject: [Intel-wired-lan] [PATCH intel-net v2 2/6] ice: add correct exce=
ption
> tracing for XDP
>=20
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>=20
> Add missing exception tracing to XDP when a number of different errors ca=
n
> occur. The support was only partial. Several errors where not logged whic=
h
> would confuse the user quite a lot not knowing where and why the packets
> disappeared.
>=20
> Fixes: efc2214b6047 ("ice: Add support for XDP")
> Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
> Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c | 12 +++++++++---
> drivers/net/ethernet/intel/ice/ice_xsk.c  |  8 ++++++--
>  2 files changed, 15 insertions(+), 5 deletions(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
