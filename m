Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7604858EB
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243364AbiAETKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:10:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:36693 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243347AbiAETK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 14:10:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641409827; x=1672945827;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LdvhVFVYqvrhGgThAKZG7sz7+CE/9g4/mtt5kFnWwg4=;
  b=PnNKbAI5+qGWt6DHw37AAqzTGP9L05sQ8/BHQRvGhpe8ksDtPJaUwLy6
   yRFsPJxGZp3WFETLKL+8k+WhYGG2wYaKtl1t7VFlmImCG8DxyKYjXrIJg
   CKszMeJv7/48pb8NKWzBAiD0Lpefdo5xjwIFRBrpQ1/2/EC9GymMPMoA1
   UIBKnuiSGgdQ3MqEe1Ym9yyH8tULJwFt3/yqDGNdbJsC+9lRgKJnt9gBs
   gQez1EFSciHo558XNVjQ8TfqUGupBIqN1Olbl/NuJxqCAfRwL6mtA9MbF
   pfNSpX8VZW+KD+a8BB5t2DdoulZpgK3K+zzUePXXB9zCukJ5LHSM4h/1l
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="229841367"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="229841367"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 11:10:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="513102049"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga007.jf.intel.com with ESMTP; 05 Jan 2022 11:10:26 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 11:10:26 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 5 Jan 2022 11:10:26 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 5 Jan 2022 11:10:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vr68CuLktanweltjYRqopjb8HzpA8+XHTgrjwyvKvi0rMAARxwjTVkB6/TtVwsZ4NdyggsPtrDThR/7ezKnOm+YqIA56fUpzsmKarV8Hep7oFcVIdF41F687RlqgMzsXBgUqqI+XATG+VEZgMVy21GWTUwJtWdayn+uEt4eXUG8ONNkq0hBWLC3zFisI9VfQrRx0tHK4ny0st+TuPYh9DpagThKGGygaCdl35UVC7bfo2mYrUNkG7x8cUDZJYxOa0TIobpdZdOGQqvZnP004ijO69odcjkfWW7pkcyrc4f3p7cXRrXtEEJE2lBSmvWZmG/hJT3FwnnGJ6/70M96D6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eeXqJ7UakHvjvACwYZaHUAGqDe2qcvKIMigUq02KX3o=;
 b=M2o8eM/w+mvquo62NpLMNxxPtqQl2v3ksHc9mbkbsj0wGkvwboRvw7ziYUjLNqFJkYxbi+HYxDqsunGUSKTeMkLesSvU0rcSDba3ugftt3i19eELkSZAJTOrbqgJVbbCuU+VEbZYuH9tNp9t1h09pLIXmrs7BfoL6/xMKyX+ZGsQM6nTjktFapBodnlLcgfGzvriA3npcCdwBPQHpeq5j5q1JG3s+55F2I12UAId9riT1TZS8h1GINmKgnqE7fm5SrYKB/fves2MlJ6juy42iUilOc7QC3oWz7sUHWEM6MwSiU/aZdrBuAa+4sucCDB4QbmSLCkmbbFx21ZHxer+wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by MWHPR11MB1389.namprd11.prod.outlook.com (2603:10b6:300:26::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 19:10:24 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::c5f6:6b60:a872:36c1]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::c5f6:6b60:a872:36c1%9]) with mapi id 15.20.4844.015; Wed, 5 Jan 2022
 19:10:24 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Kaliszczuk, Leszek" <leszek.kaliszczuk@intel.com>
Subject: RE: [PATCH net-next 1/1] ice: Simplify tracking status of RDMA
 support
Thread-Topic: [PATCH net-next 1/1] ice: Simplify tracking status of RDMA
 support
Thread-Index: AQHYAcgA6R7X46j270iXj+ZhjypmpqxUBXkAgAC2F5A=
Date:   Wed, 5 Jan 2022 19:10:24 +0000
Message-ID: <MW5PR11MB5811D45DEC5BEC61CD2411B6DD4B9@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20220105000456.2510590-1-anthony.l.nguyen@intel.com>
 <YdVGaK1uMUv7frZ1@unreal>
In-Reply-To: <YdVGaK1uMUv7frZ1@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3437a48-f9b8-4501-8247-08d9d07f0712
x-ms-traffictypediagnostic: MWHPR11MB1389:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MWHPR11MB13898B0E8876536F850A39E3DD4B9@MWHPR11MB1389.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fL9ta+Xa2n3BeD+H0kgS/pl+YIHYkDsaXXL4rbXLobelzzSQgfSnI+qICedSsdj9BfC30albIXxHQ2K99FMzA+Dg0e1hTdNW7RKkKXy8wnaywn6jhWS1qD/IDrfHg96NHiTxzc4ZWa3jiotuG83mgwo9b/j+0/FX2+IQYqGnZmcYfSdbTyMxipjs8PjQIZaUOZ64Y8kPPxRqOhKRwAbBL7XJKsB5uGyhAisALOZrbWnG1xoxL7MJqLnUTTo5qzKinNCkJX9Rg6ZwqpEnyUGWYYU7kAEoOLAmWhj+uh0sFSm5iPlK/mYjYswO2+3gYtgNS06L9tv4hJCjmuKFbMxuiQy0omki3EFHuGwmRvDfHQll97wpphbrPiWQHMYICgSoNFk1jC9aL702WdIKgh1KjrnVSeiBN0mfPyBnLrCEkIdO+yWWqd4UCTDhe51MpHIsVMjlHbXemyTVbdFIQ98rXHeng3KhDPLpB/nYvgErFd0g7mAJdRdYXYbxEW5yhqd+VEUlruHu9nEsr7LJb7fB9HYNcvhIzd5bHfuQ7nJn2d8RWulLnJ76AXNMr6ggLThDn8Ts3V6U4BmZ/zZhnmf9FF72YH5jgDoQVU+BSeG6yJR0PvKZSxw5zMN3Nbw4Z1HEzN2TYiKljmHNU9eoGCJCV4SiIruCrpfytTOmb5wPZfBfm5+jTsk2v5n24GQi/2VC2yPlhJDJlie31+tNF4BOLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(6506007)(5660300002)(86362001)(122000001)(2906002)(4326008)(33656002)(186003)(316002)(55016003)(52536014)(8676002)(53546011)(508600001)(8936002)(38070700005)(71200400001)(9686003)(6636002)(26005)(110136005)(54906003)(82960400001)(83380400001)(107886003)(76116006)(7696005)(64756008)(66476007)(66946007)(66556008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xb+Q1RORTsBoW5kf6l8+mBT+5MUox/wTugdaBOdtcZ3ACF9oFnt7dNoBWTuN?=
 =?us-ascii?Q?NnGBwe24FWdndl+eEPZESRHcPz5yxINQF/AqKyt/TTYMAGLXxAhjAnTL+R9R?=
 =?us-ascii?Q?OVGdRJsR9RWIe5qcKSmmFeemMgu0+6iBDVCAqX+UGvsk/LvNzg+3x1zKnbYo?=
 =?us-ascii?Q?b2PjsnuGrGZDhFTj0kIfy9AcNaQAUkEmPq6/qY6/rE/Ybn9gyhHFnn6g9QLF?=
 =?us-ascii?Q?6kLuEzVCWwZGtdKbx/B5F7UZ4FPw6Nv01Q0+3uQCiLyyEQdleQc+aJ0ZLtRa?=
 =?us-ascii?Q?ne4UUFR9JfUQh1v4zVp7BPHzQZyc33PH+PSwsmrA3YJmDmj6OGJwpwdWXhPQ?=
 =?us-ascii?Q?fQsEliyHPNF+CmdprHhfar0+0zGaalYDNBHo6QgHDHQY6zqCvCJvOoxB/R/a?=
 =?us-ascii?Q?HFdth1ZCFCs0NKbj3sXH+b0HnEvofeRDPHedSMn99cQpMrFHq2FXPeD4lifO?=
 =?us-ascii?Q?Bb8Lrn7MjHtE/sx5pe4YrKB2Wbrf8cXg2tRxVEW1Bu4anF0rbYLpEuXkS+Mo?=
 =?us-ascii?Q?ysWd8MQ8P87RhZjfkoT/0JqdOdZON6H/9I3vKEckVpFVErKK+R0OyWoGvMSp?=
 =?us-ascii?Q?nlbrl5+B5DxXTyC2nfi7t4Z9BV/z+XiHa7MjRmi3DCdds0yBjRpfCLpaspD9?=
 =?us-ascii?Q?etk34IGgax1RiHzK2VU6FFbP+uIDrrCF+/KLFGDAe67l/urS4SXfXA6c5+ZT?=
 =?us-ascii?Q?PU1nQCpR2dPghxE+FaB18uBiTmWM2dxWxkrtwHG6vLSGPoOTcAeb9dRow0p+?=
 =?us-ascii?Q?BMKVqh6XbAgi2UKp6gF5gfsavN1xh2SUe6jw82rOwl65+S/hAIKVByBEfY+Y?=
 =?us-ascii?Q?VTjSxuxahCWLlVcQkTW2D3BdQE59aKz2Zi5QMMXUvkv7AQ1mduPegwzwdcPW?=
 =?us-ascii?Q?Mw+augarP7WO1SF0oyMD+64l6tJyJdFF4srMmPcFGowBN1m/vG85zqSdgwcn?=
 =?us-ascii?Q?OHoE/l49TYbMHb2imgs7UWaZyuz9q18kTltWkTAFd9Ix2J+y4WPNRKUZscZ0?=
 =?us-ascii?Q?D3NzlDZhvZclEeUiPlOOxZuwhuc1pGwx6WlJLGgTylw4W9iXAkQbKfhZqj5b?=
 =?us-ascii?Q?JMYMk3HVZ7dekWZpi+FcOpxba4TJIy4h0JJrEKB4JgA1pPiYAprFyJJOeTyS?=
 =?us-ascii?Q?YCWT3rue4bQKFvJ6YPDq/U1f+kL92mEW51wQXmvR4pE+GEr7JoB8MZV9jvEk?=
 =?us-ascii?Q?c4P5WjPzJQO6Bt2ubQhia3RbWcVUBkgqzrzMyiiaZJdtP84OuFXpUcnHf0z4?=
 =?us-ascii?Q?wNeYd5+GPX8IE/EXq3lK7xqh2Vr2KrOn2BIZTlO1bbsNPSEjeSHBiH/t+Rig?=
 =?us-ascii?Q?w18WEwynRmo+0skO7WijrbfuRV4U9wq6R7Y2iywnXLr9yZG2az/ftdIV+8OB?=
 =?us-ascii?Q?d6hol2OCe1Mm7ndJ9zUbRC8IISS91xllLMuwue5o4xuYdH3V+mcaOaJxha4j?=
 =?us-ascii?Q?iAceCgLcMmCizZQesp2jRZ5x9aEG6bYGLSOPCW8XEeaECWDXzVgjFbR4ztue?=
 =?us-ascii?Q?PR44SmvHHKOnt7CKbHG0TzKuyGx8oniHAQNlASXIdhn5b2dH8M3RV1725G/2?=
 =?us-ascii?Q?7iNvhWsXz8Y0tEQBiOKdGp98i8UYeDtQ9y3+O5emG8LF4Cr6/S7nLCUnaNm3?=
 =?us-ascii?Q?RVW361+z66L5HVSqjVrartiXi5yJpbEsgHNemRTPyIivazoWjH9pzxPby0CV?=
 =?us-ascii?Q?MTqcWw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3437a48-f9b8-4501-8247-08d9d07f0712
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 19:10:24.6281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: detAA3g1vdwMLs+4aM9Gcf8iL0MmpDYpIm8jK9wlWYd60as4LO7NEDlaavVxjjb8ymyVv89Lg2OR419DixBEh62IrC2A5I9KF2wojQWCXr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1389
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Tuesday, January 4, 2022 11:19 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; kuba@kernel.org; Ertman, David M
> <david.m.ertman@intel.com>; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; Saleem, Shiraz <shiraz.saleem@intel.com>; Ismail,
> Mustafa <mustafa.ismail@intel.com>; Kaliszczuk, Leszek
> <leszek.kaliszczuk@intel.com>
> Subject: Re: [PATCH net-next 1/1] ice: Simplify tracking status of RDMA
> support
>=20
> On Tue, Jan 04, 2022 at 04:04:56PM -0800, Tony Nguyen wrote:
> > From: Dave Ertman <david.m.ertman@intel.com>
> >
> > The status of support for RDMA is currently being tracked with two
> > separate status flags.  This is unnecessary with the current state of
> > the driver.
> >
> > Simplify status tracking down to a single flag.
> >
> > Rename the helper function to denote the RDMA specific status and
> > universally use the helper function to test the status bit.
> >
> > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > Tested-by: Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice.h      |  3 ---
> >  drivers/net/ethernet/intel/ice/ice_idc.c  |  6 +++---
> >  drivers/net/ethernet/intel/ice/ice_lib.c  |  8 ++++----
> >  drivers/net/ethernet/intel/ice/ice_lib.h  |  2 +-
> >  drivers/net/ethernet/intel/ice/ice_main.c | 13 +++++--------
> >  5 files changed, 13 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/ice/ice.h
> b/drivers/net/ethernet/intel/ice/ice.h
> > index 4e16d185077d..6f445cc3390f 100644
> > --- a/drivers/net/ethernet/intel/ice/ice.h
> > +++ b/drivers/net/ethernet/intel/ice/ice.h
> > @@ -468,7 +468,6 @@ enum ice_pf_flags {
> >  	ICE_FLAG_FD_ENA,
> >  	ICE_FLAG_PTP_SUPPORTED,		/* PTP is supported by NVM
> */
> >  	ICE_FLAG_PTP,			/* PTP is enabled by software */
> > -	ICE_FLAG_AUX_ENA,
> >  	ICE_FLAG_ADV_FEATURES,
> >  	ICE_FLAG_TC_MQPRIO,		/* support for Multi queue TC
> */
> >  	ICE_FLAG_CLS_FLOWER,
> > @@ -886,7 +885,6 @@ static inline void ice_set_rdma_cap(struct ice_pf
> *pf)
> >  {
> >  	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix) {
> >  		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> > -		set_bit(ICE_FLAG_AUX_ENA, pf->flags);
> >  		ice_plug_aux_dev(pf);
> >  	}
> >  }
> > @@ -899,6 +897,5 @@ static inline void ice_clear_rdma_cap(struct ice_pf
> *pf)
> >  {
> >  	ice_unplug_aux_dev(pf);
> >  	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> > -	clear_bit(ICE_FLAG_AUX_ENA, pf->flags);
> >  }
> >  #endif /* _ICE_H_ */
> > diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c
> b/drivers/net/ethernet/intel/ice/ice_idc.c
> > index fc3580167e7b..9493a38182f5 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_idc.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_idc.c
> > @@ -79,7 +79,7 @@ int ice_add_rdma_qset(struct ice_pf *pf, struct
> iidc_rdma_qset_params *qset)
> >
> >  	dev =3D ice_pf_to_dev(pf);
> >
> > -	if (!test_bit(ICE_FLAG_RDMA_ENA, pf->flags))
> > +	if (!ice_is_rdma_ena(pf))
> >  		return -EINVAL;
> >
> >  	vsi =3D ice_get_main_vsi(pf);
> > @@ -236,7 +236,7 @@ EXPORT_SYMBOL_GPL(ice_get_qos_params);
> >   */
> >  static int ice_reserve_rdma_qvector(struct ice_pf *pf)
> >  {
> > -	if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
> > +	if (ice_is_rdma_ena(pf)) {
> >  		int index;
> >
> >  		index =3D ice_get_res(pf, pf->irq_tracker, pf-
> >num_rdma_msix,
> > @@ -274,7 +274,7 @@ int ice_plug_aux_dev(struct ice_pf *pf)
> >  	/* if this PF doesn't support a technology that requires auxiliary
> >  	 * devices, then gracefully exit
> >  	 */
> > -	if (!ice_is_aux_ena(pf))
> > +	if (!ice_is_rdma_ena(pf))
> >  		return 0;
>=20
> This check is redundant, you already checked it in ice_probe.
>=20

This function is called from other places besides ice_probe (after a reset =
for instance).

This central check stops the creation of the auxiliary device if it has bee=
n determined if
RDMA functionality should not be allowed whenever ice_plug_aux_dev is calle=
d.  The first
check in ice_probe stops even allocating the memory for the device if RDMA =
is not supported
at all.

> >
> >  	iadev =3D kzalloc(sizeof(*iadev), GFP_KERNEL);
> > diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c
> b/drivers/net/ethernet/intel/ice/ice_lib.c
> > index 0c187cf04fcf..b1c164b8066c 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> > @@ -732,14 +732,14 @@ bool ice_is_safe_mode(struct ice_pf *pf)
> >  }
> >
> >  /**
> > - * ice_is_aux_ena
> > + * ice_is_rdma_ena
> >   * @pf: pointer to the PF struct
> >   *
> > - * returns true if AUX devices/drivers are supported, false otherwise
> > + * returns true if RDMA is currently supported, false otherwise
> >   */
> > -bool ice_is_aux_ena(struct ice_pf *pf)
> > +bool ice_is_rdma_ena(struct ice_pf *pf)
> >  {
> > -	return test_bit(ICE_FLAG_AUX_ENA, pf->flags);
> > +	return test_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> >  }
> >
> >  /**
> > diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h
> b/drivers/net/ethernet/intel/ice/ice_lib.h
> > index b2ed189527d6..a2f54fbdc170 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_lib.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_lib.h
> > @@ -110,7 +110,7 @@ void ice_set_q_vector_intrl(struct ice_q_vector
> *q_vector);
> >  int ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool =
set);
> >
> >  bool ice_is_safe_mode(struct ice_pf *pf);
> > -bool ice_is_aux_ena(struct ice_pf *pf);
> > +bool ice_is_rdma_ena(struct ice_pf *pf);
> >  bool ice_is_dflt_vsi_in_use(struct ice_sw *sw);
> >
> >  bool ice_is_vsi_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi);
> > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> b/drivers/net/ethernet/intel/ice/ice_main.c
> > index e29176889c23..078eb588f41e 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > @@ -3653,11 +3653,8 @@ static void ice_set_pf_caps(struct ice_pf *pf)
> >  	struct ice_hw_func_caps *func_caps =3D &pf->hw.func_caps;
> >
> >  	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> > -	clear_bit(ICE_FLAG_AUX_ENA, pf->flags);
> > -	if (func_caps->common_cap.rdma) {
> > +	if (func_caps->common_cap.rdma)
> >  		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> > -		set_bit(ICE_FLAG_AUX_ENA, pf->flags);
> > -	}
> >  	clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
> >  	if (func_caps->common_cap.dcb)
> >  		set_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
> > @@ -3785,7 +3782,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
> >  	v_left -=3D needed;
> >
> >  	/* reserve vectors for RDMA auxiliary driver */
> > -	if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
> > +	if (ice_is_rdma_ena(pf)) {
> >  		needed =3D num_cpus + ICE_RDMA_NUM_AEQ_MSIX;
> >  		if (v_left < needed)
> >  			goto no_hw_vecs_left_err;
> > @@ -3826,7 +3823,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
> >  			int v_remain =3D v_actual - v_other;
> >  			int v_rdma =3D 0, v_min_rdma =3D 0;
> >
> > -			if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
> > +			if (ice_is_rdma_ena(pf)) {
> >  				/* Need at least 1 interrupt in addition to
> >  				 * AEQ MSIX
> >  				 */
> > @@ -3860,7 +3857,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
> >  			dev_notice(dev, "Enabled %d MSI-X vectors for LAN
> traffic.\n",
> >  				   pf->num_lan_msix);
> >
> > -			if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags))
> > +			if (ice_is_rdma_ena(pf))
> >  				dev_notice(dev, "Enabled %d MSI-X vectors
> for RDMA.\n",
> >  					   pf->num_rdma_msix);
> >  		}
> > @@ -4688,7 +4685,7 @@ ice_probe(struct pci_dev *pdev, const struct
> pci_device_id __always_unused *ent)
> >
> >  	/* ready to go, so clear down state bit */
> >  	clear_bit(ICE_DOWN, pf->state);
>=20
> Why don't you clear this bit after RDMA initialization?

We want the interface to be completely ready before we initialize RDMA
communication.  Also, this bit is not relevant to the RDMA queues, so befor=
e
or after RDMA initialization doesn't matter since RDMA traffic doesn't go t=
hrough
the LAN netdev anyway.

>=20
> > -	if (ice_is_aux_ena(pf)) {
> > +	if (ice_is_rdma_ena(pf)) {
> >  		pf->aux_idx =3D ida_alloc(&ice_aux_ida, GFP_KERNEL);
> >  		if (pf->aux_idx < 0) {
> >  			dev_err(dev, "Failed to allocate device ID for AUX
> driver\n");
> > --
> > 2.31.1
> >
