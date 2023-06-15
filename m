Return-Path: <netdev+bounces-11165-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF797731D36
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:58:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EACC12814B2
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1887217FEE;
	Thu, 15 Jun 2023 15:58:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BFE14A80
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 15:58:42 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47C2E4
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686844720; x=1718380720;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gnBEXcSv8f1ursvjXCeZj2zn4VrVW31i8QE9sICXtIY=;
  b=Xoh6rvPbk9mslNgvDXUCltNzYA0wfGhnuSGoy412hNj36ShMv3kwW+ap
   /8gXOijkUKf9DnbTK0nJcAHXdg+tTxjALxj1ONsv/sQQeCTZ3NXvNiFDY
   Jf8BrvIxSTKCWa4WE/A0FFDQkEND8ieXtkal+AzOJ/SZ6tDumcloksUfu
   IgB8hzI7t6o8yEELkihJUKZZkGtgLzsFhjUCHvXr4Pip6v8PeYiKujiRO
   gu3zCcX+kAh7ubWy9wRbiWhLESVRHDyUAMJt1UQXDII75IqhjYFF9wI0b
   er+0VZxvYuK2s1otpShvAhNvGOTVxPvSHU9goKIrArZsPgfVX+W+BS7MM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="343685240"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="343685240"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 08:57:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="706707386"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="706707386"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 15 Jun 2023 08:57:40 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 08:57:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 08:57:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 08:57:39 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 08:57:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihBK3AqhQUGvqli4ymIO/CvqFrb3whPOlm9uUo9xNt1o5DPFNsZ8GBoLIibpe8CkmgDPjbls6jsM5+2COtjP2K+aOf1FJuQ7rUhh9/uk1t46bzNPmzn7qAO57cnWgSUx/9Fe4ouO9kffUKOfcWKPPw/83lAFDXx3dSM762+TX7wcEqXTDEopklYy4LLxUw2+0hzGpbOfkFK+qA6TbOhw9+mtFt8VSuKRYJKtRPfrwcW2vibN0EAUPx62lbsbwU0oxoJAEOoJx3atNp7Y/z86Rwoi2J5Jr8c8mUNlzO3KTqM4xl0enYce0/DJs26DzUO3x7FiHl5/xiQelivIVy2FEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uU004fdubldw3vBS2u2+FQfEtWzuq74KBevhnkLOy3o=;
 b=aemTz+CbhX1KCY6QU658EIWsaWAx68WbX3Rf3zEJ388zaA/5KJ/PetV+x7ED8h2pUIbCePNB1+LKNrPbdzojFl4Df1varmZFZUbfKqabFfVHIuqRZOhrqX7ySMaHtUPxu08dkZ6clB/LxbMZ2FyE5489WunaQLfI7i7Y8gW4/0bxcRf2ZI5VPtLMlNOZYW8BIoOW3wF7TnTd2bZIiBBXBm0uzaxwYqljdTHgnHX2zVOxaZR0cRgyMluCyuN6yjwc5pBs/EA3uKX8e8FeesLlrutz0KzAwm/05JbPuM6LGf5pLKRjVPuBkX6/M+ZPCD1YoFZLDdtMl6SbVb+3KT8wZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ0PR11MB4861.namprd11.prod.outlook.com (2603:10b6:a03:2ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 15:57:37 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab%5]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 15:57:37 +0000
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Kitszel, Przemyslaw"
	<przemyslaw.kitszel@intel.com>
Subject: RE: [PATCH iwl-next v1 4/4] ice: manage VFs MSI-X using resource
 tracking
Thread-Topic: [PATCH iwl-next v1 4/4] ice: manage VFs MSI-X using resource
 tracking
Thread-Index: AQHZn4k/55og50Iaa0aKa6neF989Za+MBLUA
Date: Thu, 15 Jun 2023 15:57:37 +0000
Message-ID: <CO1PR11MB5089B50AB69E2EA953E07FEFD65BA@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20230615123830.155927-1-michal.swiatkowski@linux.intel.com>
 <20230615123830.155927-5-michal.swiatkowski@linux.intel.com>
In-Reply-To: <20230615123830.155927-5-michal.swiatkowski@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|SJ0PR11MB4861:EE_
x-ms-office365-filtering-correlation-id: ad390320-bf8d-42bd-f134-08db6db93d8c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zyXEhyhX14JCCwNMmukBSGAaNDm6+oYjKZWzLyUfP+ig8jSeqA/BBWmLRk1MW8oV1PI9RoStSlMkqomrWW74Vyl48BnhfQw6iljygI7czG329912bizlzKzrCDs4/3c9lmS5E6lGAnH8dv6bGIfG3j4Rf7ty+WtyVwfQF0huRN6LdwSOQSjDyMHar5fMhR///Yy3cVqnEhyP8WDLd05SBsQWXoaPnzV8oQX6Np7UdhbAZKWxvq7+MbNFvUJWiOcl2Cm3f5hKgQ8VWovdx+1XZU6DMTiJpVTxnrK6NxgNxAlujy2UWeBUEN41mqQrqb/f5IaiPeqPzHjZH0/9EjML3jLkzh5PncMW2lOJV1s8ySUNP/euAdJvi57ASH0OzcIyYHOtXV+8CWsVy/a367xe9Dy9mPMkDtwsNxcww0u6hzyKh7HviKAwGRHEBsaw5fHCzx5KclD21pXTlpaSdoMvz0C8/ulE9OZDa7i/u3X1Xmt5RrNEVXU10Wv+1UESTMHiGAmrgodEH4csZWXmGRY+MLMcrBVzEtKnxCP1GD4ftbLhpEPCOzdJXaAFEFZVqvBfGzB2pHSYn711aCpqH+Xv8oIMD2VfgYF5mr8nJS59KqvEyl4LC2EDYUjXsmaZVerz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199021)(7696005)(8936002)(9686003)(26005)(8676002)(41300700001)(82960400001)(478600001)(4326008)(71200400001)(66446008)(64756008)(66556008)(38100700002)(86362001)(76116006)(66476007)(66946007)(122000001)(316002)(38070700005)(33656002)(110136005)(54906003)(53546011)(55016003)(6506007)(5660300002)(83380400001)(52536014)(186003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BQkUqOh0GumsPicjP9pwXulgU6F88KQye1OmwtUCa4j+QT0Cyn7Wqy6eq6dH?=
 =?us-ascii?Q?RS05FE4gNxk0+ZJ70Ro8jSa2pQVVVhARVZKYKdm4vXvO632wG/gUDBZ+TlBA?=
 =?us-ascii?Q?0imbf960J1t+SHGY1BHk/2oWfTtrOfhOVcyDpcyAnW14F6Q3gDxZpfiwVrkp?=
 =?us-ascii?Q?hcEKTqfSQOAsUrDSGfugmau6bEK1bMk2CHI6bLKVeNTU2II8a5h2BLQHvlt7?=
 =?us-ascii?Q?6ImuySw2Lizp6k07Axb5Ko7uTRp388Shd8AC344WBl4+tZqgjivg0NfpxIoZ?=
 =?us-ascii?Q?KyNS8p0/dH3Y/9T4XqBH8TbTkUZAqF/buxTcUKQdZPvMUWNfB6DxbypAum5q?=
 =?us-ascii?Q?mIAmE7X3m+Nkc1sqRwW3c4BoG1u+EfF1d/WsmClyER2Z6abiAOWBrgbrrhiV?=
 =?us-ascii?Q?oNDDDPbbOmjFVffn7NRlpY+1pwaFU6IYW+UznPFfKr0t+sEsfGYkAR+tzT0A?=
 =?us-ascii?Q?5W0h4+wbM+H0/YmL5Yly8FknNQI0I9Fetuj74BUvK6HBNEDLV2OvftD+8Ry0?=
 =?us-ascii?Q?vooituwa5pD5Au1HjoVi1yYk2X4Y3ebWHJhnWddaDGhKwp/6CIyn6A6UOHsm?=
 =?us-ascii?Q?2fZo40FeiknY2q/vFuViclWXN13I4fIw1O8bnuYA6XLcFQCaFPTlsMO2phOb?=
 =?us-ascii?Q?niNuUh7Kn9vr4WIu1tNsNCKV4bshQ+rZNwIL8/r0ztypz0DfOpdBheWHxM0u?=
 =?us-ascii?Q?Y6OAD2shsndxcQ+nEDFBE/6u3BN9iA+cnT2nCHzVWgKDD7wSgvZB7vhOn/Pf?=
 =?us-ascii?Q?RhnG257zSDicIaSQ86NU2zaHkjvtdraSZT7Hitb6eO//XH0jB5aBdzgawoPA?=
 =?us-ascii?Q?1GT5uvGaFhGQzMAQvQikfkd8+ywa1dUD8XtfxLseWtNjNSC3/nu4JHEwfOdb?=
 =?us-ascii?Q?9xJyDAW4xsDY/GBI111/K7mSoAKC+TWmlSNljWVW/RSRei6XDoQv/1KxvTtd?=
 =?us-ascii?Q?mQBCOmXJPUSVK7IHNvIv1LCrtEWRiSa7RVEJTEeKJZ7kJW7hqSo5Dye5WIAw?=
 =?us-ascii?Q?+PF/tUBp/M0OLotZbOhrQh3tJyL5fRswTvqcZNfYOg8UzQ1s0nbQB0+12KFf?=
 =?us-ascii?Q?vqGfGYt+QcbE5/8om9ewyte/PXxoWkIpwc8yaxhM4P236ZVmWuI2wazwtIz4?=
 =?us-ascii?Q?dSmPuVhzgWYQZVVdqepRZtR0XPCqfhDREUbNyXaeNly7wEsnl8sYzqi/S3dY?=
 =?us-ascii?Q?q1Ma+p/Qi3a8VesyAri6asfwtqqRoTP+RfQbvWwy/hAslI52vqpTHAS7tvgj?=
 =?us-ascii?Q?dM5f7D0oLct8SefBUU6B4VGgfPKINi3D8+HxaWcSnEq3BOxuPcM7yJ6g5fye?=
 =?us-ascii?Q?E5U0rK7odZNDV5iWmMTQi30h6xR90OcdgAbNzWC+JbTOn33zBzejNObSPEKj?=
 =?us-ascii?Q?tOIAcsIQMgFRMXzZcroMNboqJGawqWNeTmEJL3Id/f0x3IE45Qcm95O9ak77?=
 =?us-ascii?Q?uzsnICjso9g8Wb9WiATXjFYcJHea2GazlAC2opUJCwtezo8ug2JZwJH9XGxh?=
 =?us-ascii?Q?aExn/39IBCsvhYOD2/bpb6pu+bWycEQVywphIC/FpQJo2YaRHmsVYIfqBU+z?=
 =?us-ascii?Q?Wr/xyGAuf6OgQ8df2BD9qEj4MAz2m9nvdnBDT+Vf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad390320-bf8d-42bd-f134-08db6db93d8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 15:57:37.1539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qGCQ4bz93dluyxmoMGUcu1HgjL3i7k8RW1CqbvW/fJC9OWGTRTX+Q/4fgGxe6QiM2LFB3GRya1A5shSdwxojjiCrALuVsmOiBxd2sz/pTpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4861
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Sent: Thursday, June 15, 2023 5:39 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; Keller, Jacob E <jacob.e.keller@intel.com>; K=
itszel,
> Przemyslaw <przemyslaw.kitszel@intel.com>; Michal Swiatkowski
> <michal.swiatkowski@linux.intel.com>
> Subject: [PATCH iwl-next v1 4/4] ice: manage VFs MSI-X using resource tra=
cking
>=20
> Track MSI-X for VFs using bitmap, by setting and clearing bitmap during
> allocation and freeing.
>=20
> Try to linearize irqs usage for VFs, by freeing them and allocating once
> again. Do it only for VFs that aren't currently running.
>=20
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_sriov.c | 170 ++++++++++++++++++---
>  1 file changed, 151 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c
> b/drivers/net/ethernet/intel/ice/ice_sriov.c
> index e20ef1924fae..78a41163755b 100644
> --- a/drivers/net/ethernet/intel/ice/ice_sriov.c
> +++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
> @@ -246,22 +246,6 @@ static struct ice_vsi *ice_vf_vsi_setup(struct ice_v=
f *vf)
>  	return vsi;
>  }
>=20
> -/**
> - * ice_calc_vf_first_vector_idx - Calculate MSIX vector index in the PF =
space
> - * @pf: pointer to PF structure
> - * @vf: pointer to VF that the first MSIX vector index is being calculat=
ed for
> - *
> - * This returns the first MSIX vector index in PF space that is used by =
this VF.
> - * This index is used when accessing PF relative registers such as
> - * GLINT_VECT2FUNC and GLINT_DYN_CTL.
> - * This will always be the OICR index in the AVF driver so any functiona=
lity
> - * using vf->first_vector_idx for queue configuration will have to incre=
ment by
> - * 1 to avoid meddling with the OICR index.
> - */
> -static int ice_calc_vf_first_vector_idx(struct ice_pf *pf, struct ice_vf=
 *vf)
> -{
> -	return pf->sriov_base_vector + vf->vf_id * pf->vfs.num_msix_per;
> -}
>=20
>  /**
>   * ice_ena_vf_msix_mappings - enable VF MSIX mappings in hardware
> @@ -528,6 +512,52 @@ static int ice_set_per_vf_res(struct ice_pf *pf, u16
> num_vfs)
>  	return 0;
>  }
>=20
> +/**
> + * ice_sriov_get_irqs - get irqs for SR-IOV usacase
> + * @pf: pointer to PF structure
> + * @needed: number of irqs to get
> + *
> + * This returns the first MSI-X vector index in PF space that is used by=
 this
> + * VF. This index is used when accessing PF relative registers such as
> + * GLINT_VECT2FUNC and GLINT_DYN_CTL.
> + * This will always be the OICR index in the AVF driver so any functiona=
lity
> + * using vf->first_vector_idx for queue configuration_id: id of VF which=
 will
> + * use this irqs
> + *
> + * Only SRIOV specific vectors are tracked in sriov_irq_bm. SRIOV vector=
s are
> + * allocated from the end of global irq index. First bit in sriov_irq_bm=
 means
> + * last irq index etc. It simplifies extension of SRIOV vectors.
> + * They will be always located from sriov_base_vector to the last irq
> + * index. While increasing/decreasing sriov_base_vector can be moved.
> + */
> +static int ice_sriov_get_irqs(struct ice_pf *pf, u16 needed)
> +{
> +	int res =3D bitmap_find_next_zero_area(pf->sriov_irq_bm,
> +					     pf->sriov_irq_size, 0, needed, 0);
> +	/* conversion from number in bitmap to global irq index */
> +	int index =3D pf->sriov_irq_size - res - needed;
> +
> +	if (res >=3D pf->sriov_irq_size || index < pf->sriov_base_vector)
> +		return -ENOENT;
> +
> +	bitmap_set(pf->sriov_irq_bm, res, needed);
> +	return index;

Shouldn't it be possible to use the xarray that was recently done for dynam=
ic IRQ allocation for this now? It might take a little more refactor work t=
hough, hmm. It feels weird to introduce yet another data structure for a ne=
arly identical purpose...

> +}
> +
> +/**
> + * ice_sriov_free_irqs - free irqs used by the VF
> + * @pf: pointer to PF structure
> + * @vf: pointer to VF structure
> + */
> +static void ice_sriov_free_irqs(struct ice_pf *pf, struct ice_vf *vf)
> +{
> +	/* Move back from first vector index to first index in bitmap */
> +	int bm_i =3D pf->sriov_irq_size - vf->first_vector_idx - vf->num_msix;
> +
> +	bitmap_clear(pf->sriov_irq_bm, bm_i, vf->num_msix);
> +	vf->first_vector_idx =3D 0;
> +}
> +
>  /**
>   * ice_init_vf_vsi_res - initialize/setup VF VSI resources
>   * @vf: VF to initialize/setup the VSI for
> @@ -541,7 +571,9 @@ static int ice_init_vf_vsi_res(struct ice_vf *vf)
>  	struct ice_vsi *vsi;
>  	int err;
>=20
> -	vf->first_vector_idx =3D ice_calc_vf_first_vector_idx(pf, vf);
> +	vf->first_vector_idx =3D ice_sriov_get_irqs(pf, vf->num_msix);
> +	if (vf->first_vector_idx < 0)
> +		return -ENOMEM;
>=20
>  	vsi =3D ice_vf_vsi_setup(vf);
>  	if (!vsi)
> @@ -984,6 +1016,52 @@ u32 ice_sriov_get_vf_total_msix(struct pci_dev *pde=
v)
>  	return pf->sriov_irq_size - ice_get_max_used_msix_vector(pf);
>  }
>=20
> +static int ice_sriov_move_base_vector(struct ice_pf *pf, int move)
> +{
> +	if (pf->sriov_base_vector - move < ice_get_max_used_msix_vector(pf))
> +		return -ENOMEM;
> +
> +	pf->sriov_base_vector -=3D move;
> +	return 0;
> +}
> +
> +static void ice_sriov_remap_vectors(struct ice_pf *pf, u16 restricted_id=
)
> +{
> +	u16 vf_ids[ICE_MAX_SRIOV_VFS];
> +	struct ice_vf *tmp_vf;
> +	int to_remap =3D 0, bkt;
> +
> +	/* For better irqs usage try to remap irqs of VFs
> +	 * that aren't running yet
> +	 */
> +	ice_for_each_vf(pf, bkt, tmp_vf) {
> +		/* skip VF which is changing the number of MSI-X */
> +		if (restricted_id =3D=3D tmp_vf->vf_id ||
> +		    test_bit(ICE_VF_STATE_ACTIVE, tmp_vf->vf_states))
> +			continue;
> +
> +		ice_dis_vf_mappings(tmp_vf);
> +		ice_sriov_free_irqs(pf, tmp_vf);
> +
> +		vf_ids[to_remap] =3D tmp_vf->vf_id;
> +		to_remap +=3D 1;
> +	}
> +
> +	for (int i =3D 0; i < to_remap; i++) {
> +		tmp_vf =3D ice_get_vf_by_id(pf, vf_ids[i]);
> +		if (!tmp_vf)
> +			continue;
> +
> +		tmp_vf->first_vector_idx =3D
> +			ice_sriov_get_irqs(pf, tmp_vf->num_msix);
> +		/* there is no need to rebuild VSI as we are only changing the
> +		 * vector indexes not amount of MSI-X or queues
> +		 */
> +		ice_ena_vf_mappings(tmp_vf);
> +		ice_put_vf(tmp_vf);
> +	}
> +}
> +
>  /**
>   * ice_sriov_set_msix_vec_count
>   * @vf_dev: pointer to pci_dev struct of VF device
> @@ -1002,8 +1080,9 @@ int ice_sriov_set_msix_vec_count(struct pci_dev
> *vf_dev, int msix_vec_count)
>  {
>  	struct pci_dev *pdev =3D pci_physfn(vf_dev);
>  	struct ice_pf *pf =3D pci_get_drvdata(pdev);
> +	u16 prev_msix, prev_queues, queues;
> +	bool needs_rebuild =3D false;
>  	struct ice_vf *vf;
> -	u16 queues;
>  	int id;
>=20
>  	if (!ice_get_num_vfs(pf))
> @@ -1016,6 +1095,13 @@ int ice_sriov_set_msix_vec_count(struct pci_dev
> *vf_dev, int msix_vec_count)
>  	/* add 1 MSI-X for OICR */
>  	msix_vec_count +=3D 1;
>=20
> +	if (queues > min(ice_get_avail_txq_count(pf),
> +			 ice_get_avail_rxq_count(pf)))
> +		return -EINVAL;
> +
> +	if (msix_vec_count < ICE_MIN_INTR_PER_VF)
> +		return -EINVAL;
> +
>  	/* Transition of PCI VF function number to function_id */
>  	for (id =3D 0; id < pci_num_vf(pdev); id++) {
>  		if (vf_dev->devfn =3D=3D pci_iov_virtfn_devfn(pdev, id))
> @@ -1030,14 +1116,60 @@ int ice_sriov_set_msix_vec_count(struct pci_dev
> *vf_dev, int msix_vec_count)
>  	if (!vf)
>  		return -ENOENT;
>=20
> +	prev_msix =3D vf->num_msix;
> +	prev_queues =3D vf->num_vf_qs;
> +
> +	if (ice_sriov_move_base_vector(pf, msix_vec_count - prev_msix)) {
> +		ice_put_vf(vf);
> +		return -ENOSPC;
> +	}
> +
>  	ice_dis_vf_mappings(vf);
> +	ice_sriov_free_irqs(pf, vf);
> +
> +	/* Remap all VFs beside the one is now configured */
> +	ice_sriov_remap_vectors(pf, vf->vf_id);
> +
>  	vf->num_msix =3D msix_vec_count;
>  	vf->num_vf_qs =3D queues;
> -	ice_vsi_rebuild(ice_get_vf_vsi(vf), ICE_VSI_FLAG_NO_INIT);
> +	vf->first_vector_idx =3D ice_sriov_get_irqs(pf, vf->num_msix);
> +	if (vf->first_vector_idx < 0)
> +		goto unroll;
> +
> +	ice_vf_vsi_release(vf);
> +	if (vf->vf_ops->create_vsi(vf)) {
> +		/* Try to rebuild with previous values */
> +		needs_rebuild =3D true;
> +		goto unroll;
> +	}
> +
> +	dev_info(ice_pf_to_dev(pf),
> +		 "Changing VF %d resources to %d vectors and %d queues\n",
> +		 vf->vf_id, vf->num_msix, vf->num_vf_qs);
> +
>  	ice_ena_vf_mappings(vf);
>  	ice_put_vf(vf);
>=20
>  	return 0;
> +
> +unroll:
> +	dev_info(ice_pf_to_dev(pf),
> +		 "Can't set %d vectors on VF %d, falling back to %d\n",
> +		 vf->num_msix, vf->vf_id, prev_msix);
> +
> +	vf->num_msix =3D prev_msix;
> +	vf->num_vf_qs =3D prev_queues;
> +	vf->first_vector_idx =3D ice_sriov_get_irqs(pf, vf->num_msix);
> +	if (vf->first_vector_idx < 0)
> +		return -EINVAL;
> +
> +	if (needs_rebuild)
> +		vf->vf_ops->create_vsi(vf);
> +
> +	ice_ena_vf_mappings(vf);
> +	ice_put_vf(vf);
> +
> +	return -EINVAL;
>  }
>=20
>  /**
> --
> 2.40.1


