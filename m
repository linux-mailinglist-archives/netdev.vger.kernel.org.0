Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE78966D516
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 04:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbjAQDjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 22:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235130AbjAQDi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 22:38:58 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BC2233F9;
        Mon, 16 Jan 2023 19:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673926736; x=1705462736;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BiK8YdWwF7AcMHXjZUMEuSDOFxsXkHG8GIdDW0EY3yo=;
  b=hYHF/f55vfzA883k+vqGgDJ1Co3zEcj0cPqzXiv+DtH1Kap33Oo+SPCX
   5dvV8UyXS/ZxpFM3ZjyM8Fy4U2c8l17c1uTxmpJ5mWWTBEFIXA/mN6nLN
   mUM5TIMV9Pb8siFRb8qpJCuVmyEaBDRD/+YA+rRJYb3mTVP1wAOVHwkVb
   C27TJjuMb1io3EWPzKZygCUs6RGb5I1tD4OZGZTYqKtSQFMkQoc/He4UF
   B7VnD8p8WncwSdKKu5ui1bWBmiE1r1RdvC2+djqD1ohw/lK435sTYhr9b
   HfTbwQbQq/3SGTqhCFSnMDMHdfkooW0ExIVhdNymMH6Ma1boSK37ujX41
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="322292053"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="322292053"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 19:38:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="691451974"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="691451974"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 16 Jan 2023 19:38:55 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 19:38:54 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 19:38:54 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 19:38:54 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 16 Jan 2023 19:38:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0jE+tw1rcZLc0Iu2b2jNlYHzIF7e1uLs8cxkOa/+bs5hWzn33AxiqSTMuDZNTb1vPvHkSpxzjtQHsyspIphgkqA3GUkXWbnIk2hPIrPQLOvJXdwvYjn/uI1br7eEHCULdwokPPj9ZNg2Yq5KHgqZIie/OKWByQI6BnlNZGTE/7Lr7Mdy1Y9ETAAPk8eYyQ+ty2exineQPy1/nASbJTf+WiWvUd07ojqB6xYdXzRTpFFRR4gREqc5kr1eKpziO1QcW/D6SWSdeDgMHxkwKuMsfdewMD5jdVQ2I1x2LcuYzsuRna2JjP/gadAAm6OMdHtjUmwPoB1JMLY6xzTkmZWEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=woUXwpPKNw/jd4o61sXa+h5+uy+kD+yYGda+Veo0EBs=;
 b=Gq7vBEERe6PK594qA0qo7R3ZzJmadWV+xLeO7lnIp9T+VtMbiYlq48r9gRsCkqwHlzQKaPgr2DHj3tvjkinF2ZVzqURUV/sdaTdQRNTYV5jOB4v1OJn+Ujjo5yog4skDbGeNP4c14o3AI+I7joPmGi4XfYXeKbafB9irsjWC2pQs3zoHoyTDUu2Buhu9st/FJ+vyXb3VUOeGhuO/fGy0mIyTlnCh6jAyX7ICbekz9iBdQnpqoh8ToDeZ6gihTm+ogR989FIE/TwKHgiHrF3VrUKeiGeWoGBrHZ1TukrhQQRLu8ISY61tSrKHGWqNQO1n24FsoWscYyDdi7AQjf4stQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB4850.namprd11.prod.outlook.com (2603:10b6:303:9c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 03:38:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 03:38:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "ath11k@lists.infradead.org" <ath11k@lists.infradead.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH 7/8] iommu/intel: Support the gfp argument to the
 map_pages op
Thread-Topic: [PATCH 7/8] iommu/intel: Support the gfp argument to the
 map_pages op
Thread-Index: AQHZIe3xxYKfQcB18EGoezp52F9yLa6iBZGw
Date:   Tue, 17 Jan 2023 03:38:51 +0000
Message-ID: <BN9PR11MB52765EE38CA21BA27EEA06548CC69@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
 <7-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <7-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB4850:EE_
x-ms-office365-filtering-correlation-id: f3ca98a3-32d7-458b-685a-08daf83c5a04
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ddXIrX23S6IYUJ95VRMtW8X3H9o4JLrTFnVjWo2Cj+6at0NVH+YzpwuZn3JdyQ3jb20dC+PGiiYC9X/5iqTDvdrjnFI09FPkNctQhrPdBMbBC6nE7JoFAoVfpfz8P6Dn9VOZOll7zzMwNvdr7zfCq12hNM9aDWj8rggzwq1oBYARgC9fX7CWOCyA11PyTNwLQftYiY5R++7NIwqsMseiJ31yvSfCgYc6x5kRKGkFse+noSQ9Ax7mAq/rIOE0T52IAC8lZDrSDgHxtPzd/2eb7RqPCvKKZmeFA3FCH2O4WdBO4d943jueWaqyBSMvZkftkmzqk8F7Tgd3bOCVDTYy8vca8pXU5ZZBwzJAiayCU7tVpW0dabnxkAyRUSigPYHs7fPiqZKt//81UzN+vWGgFfkxjt3062S+ZOdyLMAU+LnClD4DnnyN3IbNWb2VWMd5y3glQsZG4vf/YojcPUrdbKsHupJ4tRnmVclQ+dgVSvz4SyvSVrBiTN4pR7+FHFpwIUYCcEE3qd6CEUcX/NlcX81a6/Ho/6Q3CNvyWpaBcARIjmFaupwNz8RqhD/UA9PF214TCYe1l8Aa77u6TOss8OnrqMf4AweiswzdSnjjwKIABQ7z/4u6PuHt66UT5shOrzoeaJzcaJLUr0+zUqPRUfq0mE9DeVUdDYvZ9KvzeeHiaEd9rTFLm8+XxX9aisQN4p7XSAWCw9vgxyujm5yEUQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(136003)(376002)(39860400002)(84040400005)(451199015)(86362001)(33656002)(83380400001)(186003)(9686003)(26005)(41300700001)(4326008)(64756008)(8676002)(66946007)(66556008)(66476007)(76116006)(66446008)(55016003)(71200400001)(316002)(7696005)(2906002)(6506007)(110136005)(54906003)(478600001)(122000001)(7416002)(38070700005)(38100700002)(52536014)(5660300002)(82960400001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?axMmZGetffPayJhQI4BEu0rBCeXVAGXhaqDMSJQTaMxkZ61q8f4BzsYPPmAz?=
 =?us-ascii?Q?CcEJIqpWohKW1U7agt+mxx0xuDN1IXJLHBc4IJdpBgoWInsmFEbFuUqNGWBT?=
 =?us-ascii?Q?TXCT3UR0f+5+C1gs7VHdTI+5fY+bb1TrvcEDmXdhrAM3BVdbxMcdSgKvIzjE?=
 =?us-ascii?Q?sqytLQyri93do+4cNBRqvzL1qqxgx9xVopFO2Rhi80TeJ8D9JcWTEgijNMuU?=
 =?us-ascii?Q?eM33C3jgOSHyl4PMIhznsqeffrSmblUHGGJsPftRQsK7Dp+vfWeKntOVGxeY?=
 =?us-ascii?Q?Qui54QjhKG4qEuQ782Dgj6a3Rql+/1EW85SDyLvAPOSPclNYgyTg9N0Zg+D6?=
 =?us-ascii?Q?ovZG3x+1ZhLFCi4t6DiMMPCJzcY1r47C6lyKC7jDItB5RqsIq7+fpBYeWTyK?=
 =?us-ascii?Q?hmJysCd5BUHaQPEgwhEOF7UTTBE9Qm7DieysbGWJg7CyWeDvhhww+I6ynMGy?=
 =?us-ascii?Q?kQQKEHbh+kqRj0BTh7fESLvbqOR2P84L5AimGbg1L/aspaTS5myHT0jAdgb3?=
 =?us-ascii?Q?wlommvwnE3/F9cMLg0nS58DSFy5TySP0fA9tgRqBfAymOOhhz6RR5dSDc0lF?=
 =?us-ascii?Q?JGOdSQ8wir/hWa40fpQGPp3qWNdY8EbEiz2vh4U1i/YbzeqbYvqFHXzThsoh?=
 =?us-ascii?Q?DzOorFiYbgB5ZfArY8krMNZ6L0OQObcxyQMgnXgvJ+c1PkC2C7ZWwsB9MWDo?=
 =?us-ascii?Q?OmdGtayM/5HpRKGPgW6DFU5M9tirce2y4v0xwzIEOg9U+3Er58a7KarOoCsI?=
 =?us-ascii?Q?78D0485PQjZiH4FCRX2+q37a/fAb+550XpL7Y+6UYR7pbYBQVWCl4s59hQQ6?=
 =?us-ascii?Q?67rnP2DsXJa6MUxERpN0TOh4Im/TLRvU3FOBFDPxzVhnng2W09Qw2aoCZ9tn?=
 =?us-ascii?Q?YBp8BVJ/PuKTM+svLejDtFADZYIyfSssDvwYQY77eqUlrcDEdb/Qx5Vzz+N2?=
 =?us-ascii?Q?FpUnqE4/s+InYETgcDz85sXk8Y3hmgheBszFQxIVdtIQD4gNge6z3VCMCitV?=
 =?us-ascii?Q?78AaemKZ6uCOEatNqH390KM5Qs8sngN3VT5wf7ej8BtGumegF7PGF51J4KXa?=
 =?us-ascii?Q?2WuL4oq+7nPFIF655TWoGROthN5NVh7bzGfmnruDiKbxvi/Tee05uarhI/M4?=
 =?us-ascii?Q?lgjcuy7Dd1bl8x+KCGiqGuvPYFGwJqKzJLzppX40JhKibaae2sEGBq30IoNj?=
 =?us-ascii?Q?K+6le41p7xRolCpETY+2vElH3391wTA/IVWcBgwIogHfqq32/EzRYN61eN76?=
 =?us-ascii?Q?acgUBxOr/hsPavRlfccy+Ne5aITJd8PugREhQCtQexAYlV+o22WqYtdmpOu1?=
 =?us-ascii?Q?HHDIUvoous9Y4kN1U7aCQoi+hwBcjZKapNs9u/jzqII19JKCrDcZeWNHdY4x?=
 =?us-ascii?Q?mbAadvpIhJGNJY095TViMOzKDYZIEmByJb1bFghA3wvHzV1EIwwAXvv6c7QY?=
 =?us-ascii?Q?Y8Bkd3HqrIBcnRGSDqkqeMVRbcdgcN7xeDjth0l2m85hy63KElH+uN9h9d8v?=
 =?us-ascii?Q?NP8QXb0QYitu0IdMxhk/E4fqo7egp+a0zzh9M8/oG7Ilj0vNhzeIG6p3gvEW?=
 =?us-ascii?Q?h0sfMkZLtXG7yF8xAJzMBOXzu1JBR4CFhZQKOzjb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ca98a3-32d7-458b-685a-08daf83c5a04
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 03:38:51.7841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WU6JqyvwcWvWut0Q3CyZGbszHiGLzUaoISj2vk8niVKT89+LU7GtH0zndz5Ol6qVc6jVVyDMJ/s1cc7QTmwMgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4850
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, January 7, 2023 12:43 AM
>=20
> @@ -2368,7 +2372,7 @@ static int iommu_domain_identity_map(struct
> dmar_domain *domain,
>=20
>  	return __domain_mapping(domain, first_vpfn,
>  				first_vpfn, last_vpfn - first_vpfn + 1,
> -				DMA_PTE_READ|DMA_PTE_WRITE);
> +				DMA_PTE_READ|DMA_PTE_WRITE,
> GFP_KERNEL);
>  }

Baolu, can you help confirm whether switching from GFP_ATOMIC to
GFP_KERNEL is OK in this path? it looks fine to me in a quick glance
but want to be conservative here.

> @@ -4333,7 +4337,8 @@ static size_t intel_iommu_unmap(struct
> iommu_domain *domain,
>=20
>  	/* Cope with horrid API which requires us to unmap more than the
>  	   size argument if it happens to be a large-page mapping. */
> -	BUG_ON(!pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT,
> &level));
> +	BUG_ON(!pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT,
> &level,
> +			       GFP_ATOMIC));

with level=3D=3D0 it implies it's only lookup w/o pgtable allocation. From =
this
angle it reads better to use a more relaxed gfp e.g. GFP_KERNEL here.

> @@ -4392,7 +4397,8 @@ static phys_addr_t
> intel_iommu_iova_to_phys(struct iommu_domain *domain,
>  	int level =3D 0;
>  	u64 phys =3D 0;
>=20
> -	pte =3D pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT,
> &level);
> +	pte =3D pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT,
> &level,
> +			     GFP_ATOMIC);

ditto
