Return-Path: <netdev+bounces-11305-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D339732808
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:56:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3810B280EFF
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 06:56:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D85EBD;
	Fri, 16 Jun 2023 06:56:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C99EBC
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 06:56:38 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44312D7E;
	Thu, 15 Jun 2023 23:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686898595; x=1718434595;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oYD8OXc/tvkuxmy+/whsQwd2JfK5m1Bx9nMpnVHVvFY=;
  b=WCPDRpwcrgtG1fC1jzfYi1R/Uzn16gFLWjBGDtKyfjFUk4BDDUXlfbvI
   kq80jBz6uThKYbMEBMpPmShrtRa14P2C3WvV9/5aI6iDSQ3V7wHg9COzx
   QTJRGERS2JKGc/1XrNIMvbbIlry3soFdshKRmiERffTTUjxZqe9lMiW1d
   zakrVRK26tn/Zv9SMSL9WwoftvHmtEfILur2mpZ0QbjKYjf5OuS5e9Sj3
   aEA/TIVX5/aWTBnyPC2uUr17slbv0M1bJ8zl3SlD++voQ4cwpsRaCDzVU
   aoKWv5dKdjjCJIuFhUI60iASLxWdMoUK4D5hh+pTL+1t3FcBU3hP4iCHP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="343884086"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="343884086"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 23:56:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="706976682"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="706976682"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 15 Jun 2023 23:56:33 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 23:56:33 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 23:56:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 23:56:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8/t3rMdT23W3XCWIsnIH59FtEjkovmk/fkamT6mYp7r7lNMhQswEm8OSNk5q50F/NSfUUip+Zewg+5j6Jmll+f46nK7bhTb3S+KKv1cYnmgVCEJ3+GhQw4S7Ocyd4nBys1Gem5aSL0a/vy8il33B10/4yzWBqMR7RQZiQmkxizcBq/nSVftrPwgviTTVslymfa8vRLZVg1ig+WFXJI5frhzIv5xnwg9MbX/usm+R4c6k8yTxRumF77Uhxxb1qu+wIJUPDDz86uT7dX/V/+/OXRYU1CXdxFpyY97CddU4/HXjy1C22/EVmfbqdn8cawR4S9Fo5XfYj5KY1RWW5+KLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0EguskF5JN2K1fqflOaMNuNZMQk7v78mgFcgCjQIP4=;
 b=hZAmhVQnWLFCaoE/zt7iAz8lksuQ53lsBu+PMu51P7RHMYBwszHhy60RhY21vMFjjD2w8Yba0zOS0/t00b+5TKbpI++wTOVK2aZ1QBYdTya0qeCo3YOcUZkRcYNyc929oIjBy85vL42f4xOKUhvu25+eJEwJpvwe5DclmbjRWN3GVB1CaPROZqneWKMYo4MfZc6zUkjHdcNMc+mFUrYfuhgiDeWoPXvxELm6y6N2DLfGdpuI6JHVbEeSUwjwttqXmUHkdrZ2Q0qlDHJPrnynfnX/fgx7DGLOYN/p5MShatevTOS7RebMsnHiDLB9UJc+Q/Wfoqj2vXeAC4LrcYd9zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB8192.namprd11.prod.outlook.com (2603:10b6:610:191::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29; Fri, 16 Jun
 2023 06:56:32 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6500.026; Fri, 16 Jun 2023
 06:56:32 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Brett Creeley <brett.creeley@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v10 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
Thread-Topic: [PATCH v10 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
Thread-Index: AQHZlZ4cVPxm7TG7W0u/nIzM1ahNNK+NEuoQ
Date: Fri, 16 Jun 2023 06:56:32 +0000
Message-ID: <BN9PR11MB5276B2C8E96E080CC828B32D8C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-3-brett.creeley@amd.com>
In-Reply-To: <20230602220318.15323-3-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH0PR11MB8192:EE_
x-ms-office365-filtering-correlation-id: 8cc11a8a-0811-4d4c-ffdd-08db6e36d149
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r/dAY1YMgUC2HoVZPomdIjWQmo7NE9DSlQP/Eq69wKIHJ0BHw74wGjp/BIm8GJX3iNhbjsnNjMHVqY3w3ZSMI65TLO61babIItU4RdOSgflDlIHYkz5EpmK0e+lG16dcKar3HE13VeFnXj88Xzsz3l5yfnADk7aJP3Bh024du7fm8FveFC13+Pifgxjjci8qc1smNmBFdrWLfcos4BmzrcmxozMwXlb4sBuNd5SoOMLAZjtDmrKvhVqhA1CdrOSVjEq42M7qpbN2rxtjFAVk3Z02Gm5eAE5xc8EJ9seWlJBlMp5fDB9pgwaYCsrcZwdXxmyIX7ztuk/ix6mgIvB5YV3YbBBlH9AGJOaEPWVQfCDKmY0eApkqThXQyw3Ia1lPCVyKbsjDRHTSIxZvoVNjZ7hxT0tHqNtIXQLfRxIogQzDfyhfX8rQjL5wN2miAd23uWV3wQCHSceM4qCFY8lJoeRb4pLBCWhHRenK2XzFqjGkOIzUIpHOssWFsuiabxQEMUrM6erMX10WoLrCa+WZOVkZ3+vlhnBzQ9XhH8u2hw7gRDj1aDYf1c6B9nF+fqRmEM0D9PL3hdSjnFgzvG/ildDC7wKyFNgLRHTKZCMrF6QfBXmL5krZWz+3BPmOksbi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199021)(71200400001)(6506007)(9686003)(26005)(66946007)(4326008)(316002)(64756008)(66446008)(66476007)(66556008)(76116006)(186003)(7696005)(122000001)(55016003)(110136005)(478600001)(38100700002)(8676002)(52536014)(82960400001)(8936002)(5660300002)(41300700001)(86362001)(38070700005)(33656002)(2906002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z2iNarVq+ww+U6dSr6AhhL9cOr5eCL09Lwkg+WjVh7Eo+gog3p4+Z2lV2s5g?=
 =?us-ascii?Q?mb4yQg5zA4jo5XyMKng1+CQlh/nrrrlJAyFWHJY0Z1B1dzfrqLsgO8IL4mhi?=
 =?us-ascii?Q?Y12qudQFXR+y6zMpcDt0mp+gsRqdk602XIMjUWFvXWKP++z54Fv14Z5dLXR6?=
 =?us-ascii?Q?ZDMklVXbv2wg2QFY4Fp7vpxshvjgN5AGI5ROMjnEzAIlG+ZhZr4j9OnLDWQJ?=
 =?us-ascii?Q?HiFp4F4NQACA4AGgewZPOLhdRjLJdAAtipG6/0R3Y0un+np2S4vJwAmoms+r?=
 =?us-ascii?Q?7FmRLKszn3NAdIa0HYlx+rgyRdugElklv955KYN1CfAxf2AOU9HXRCtqbhqM?=
 =?us-ascii?Q?1al5AqwlDdbeuDvhIgNplYRLBLvUzBhbZxrHZiMoebPviU0VbTrlJXpOKlti?=
 =?us-ascii?Q?o7LoDchhdbQuhghHLxVEI/mGteTCN/eCn9Gow3yPOf+QElxjBdHzkwuwXpWC?=
 =?us-ascii?Q?8XkwlJ6LdDNhDYcQhanFPyEmalANsKOMjaV1q0p6wYFSRI0k4dhkZPa1YrWO?=
 =?us-ascii?Q?7cUw+jvtummb4Mzw/Q7WC0Vc5e/Tmu+fhx+aG/uJAHVLFlWc2GQaen7EqqkA?=
 =?us-ascii?Q?F1hKkJHXENM1wXgUedIYgXUOBehE+0Og/76DX+caBTSQtMi8xW5HEVdZ2fVt?=
 =?us-ascii?Q?pzmekynN0ZIh9eagFbpgbbzEIUB67NqK6ZOi0W7miHrAwaRkpDRr1tAcpTRi?=
 =?us-ascii?Q?9WoHZlmEptSGODhpZP74a1cDdr0nBsJ2Cr7XnnzgfEp/7533aThP2sZ7Zcah?=
 =?us-ascii?Q?+bwci9c2khrFOPryL730GmgOjxRbXyQjOsmWdIqo98tao7aGc34vqJ3piV1w?=
 =?us-ascii?Q?ocMrv0fQPbPKmFDoqe5d5GZgZef3GBMuFUgQJ/jTzthJhyGtKnLmcLPVJUz9?=
 =?us-ascii?Q?wxrJ6xk13EJv5jmmtsYTfdDcn/dhPsIaMAsa0ozw3+pZNifoDKyw3hASORY0?=
 =?us-ascii?Q?pVAhRPbiUJnV9ewa8CcZttRlF5qiS4bvLh8iQswOaMY3RmTU2Eb9ds7lobK7?=
 =?us-ascii?Q?p6W3rXea9u+JiD6ePQZwAuWGwuG1KwaUFhuOjMBj4SlFOnVl/9WbmsUkGEzE?=
 =?us-ascii?Q?IS62IrNyb8x7+N5abvP9CuW/h4tU0GzWgFImZQ5sm9RrUyc9123WFo/6+FaN?=
 =?us-ascii?Q?R+y0R4hwbj/Vp+W+a+yeB5nkYEth4/pgRuD+bOZFpC4eCDVJjAuj/db8XhOi?=
 =?us-ascii?Q?DhIpSe2yJrrvutEDslGY4UN1R2vj1O0Qxr3S49lGtj4vV8kg/imxeqB0VP1D?=
 =?us-ascii?Q?8h3gdFaCp6ON1gIpXHIy103Obr5hZXdDTQ+xYKQrd4FRHNAfYXsBFWqpCtf6?=
 =?us-ascii?Q?Qc32HQsa4wJtpEQcAQ5t4h2SxXSa+ilLhS8vRbKRPouYH45QEK3dcvyy1y5B?=
 =?us-ascii?Q?4MNmzU8D3v/IBZYvbGaWbz3lXRsqcysYVrh5uvbfSkOajeNGmkB0LyTNPUsM?=
 =?us-ascii?Q?FPbDZYghwR34Z08q6yHy9OgRq5tg4zNe4CFKR7Mu/pRSDlRAwoMD8+gPCmhZ?=
 =?us-ascii?Q?yp/Ls5YBMcjQhBCRa9CVMxhHumUHCwgTMMKlkkFzREGHJ8ijZuP6+HRjoEOn?=
 =?us-ascii?Q?gMr6xPmu6lMrogN5JEbkVi3004LglcgV09YR0gd5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cc11a8a-0811-4d4c-ffdd-08db6e36d149
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 06:56:32.1613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z6AvqX/LXQhYZRYVPi7Oc9QhMqkHioww5theeSodk9gnITtZgCuoCBqS1Ekkq01I0SfLxkifakorOpGCetNIog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8192
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Saturday, June 3, 2023 6:03 AM
>=20
> This is the initial framework for the new pds_vfio device driver. This
> does the very basics of registering the PDS PCI device and configuring
> it as a VFIO PCI device.
>=20
> With this change, the VF device can be bound to the pds_vfio driver on
> the host and presented to the VM as the VF's device type.

while this should be generic to multiple PDS device types this patch only
supports the ethernet VF. worth a clarification here.

> +static const struct pci_device_id
> +pds_vfio_pci_table[] =3D {

no need to break line.

> +
> +MODULE_DESCRIPTION(PDS_VFIO_DRV_DESCRIPTION);
> +MODULE_AUTHOR("Advanced Micro Devices, Inc.");

author usually describes the personal name plus mail address.

> +
> +	err =3D vfio_pci_core_init_dev(vdev);
> +	if (err)
> +		return err;
> +
> +	pds_vfio->vf_id =3D pci_iov_vf_id(pdev);

pci_iov_vf_id() could fail.


