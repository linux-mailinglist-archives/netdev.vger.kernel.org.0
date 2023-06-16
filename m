Return-Path: <netdev+bounces-11308-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A408732853
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:05:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4681728164D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50DC03FEC;
	Fri, 16 Jun 2023 07:05:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D646210A
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 07:05:02 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F533592;
	Fri, 16 Jun 2023 00:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686899096; x=1718435096;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qM8NvitybD74yebDBqJjhrRhClcIK5uwdhF3sIMEXQM=;
  b=hCjYem2x6EZk9AvpwSZZ7TargEKS/Hjrwokq6F1YtqXtec8Xhaz9krzd
   xdoCEq8pF2W11jYSnIqShE3nsyMXGVQKodtj4n6A5FfpYyA3D1YiHaDoW
   GgDzQfzuHww0XwZIwKh7IltWxttyqGemOeAvHfiwqDxseUKdEXzJydAHe
   iM2AM+RuZcJcMPktJkE43icKdok/9CcurE6HsEFm9dEVQNgNViBS1zBs4
   6cg5AN1dlTMlRiU8BogPKIF4mtAg1ma8qSOy71EP++ofLKShxNP8EQOK8
   o+zLiEiDOPVFWYrUbzCzkRTidZ6BDMR7bTA+bMtEpXGLhHFM5hKc6CT1N
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="445526491"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="445526491"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 00:04:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="802724404"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="802724404"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jun 2023 00:04:55 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 00:04:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 00:04:53 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 00:04:53 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 00:04:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntMzy4zEeP81lUClRcAZxeHDb2xwUlKn81ztjW5FNu+AxdZM+DvdkncGhuqr0rfTBl0ww9giSKx15l0yyU2/smqYBjghFZIRe4YqmhO6Fn+DPQKLwet+lgYSVjZ3CjXM5OdGlpJRTR90KE5aeXlH7dApDLzXe4G1EIswqzPtmt/Ks+tKe6cXK4sBEbTg2COCB7zuSRkUUX+5yDz6t8gGwtZhaL3hz/IWepPbJHdg8gZ2r/ygRals/eiZo3NcvJwS6l/wPBAS1q5wCRtZyNnS112Mis8JpiC8ZJi29hIEcpRDA9jhxj47ejkXKggoOjeT+xOPPO7kgHmN5BR7gYdmPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQ1YjwM6vTDxq1ozxVpocFNQ1Gfq1AsZTxb2d9XhDjk=;
 b=mNNaYMTTtK6niceA2CxwzximJIhIh0cc5Fxv5MXVe/2mOXoBX2xFVZMopO9kLhM6a4rfCUt5WnwDxO3neVP4sUXdMTuzv/Qs/8bDblBYNxYh90zrpbS7znH2cDTFbZaRwWDyBClI0Y4wWtN2vZ80ppLdHQwiVKiWr/zmawhvgeeuNBCtJK4LJAmL53Uhk2sYJ1VgxlW3gFqr8+bTLAXiWMZq5/HwW/yllPaIQOca2pdZs1xHNBCBXiB4ssfKTw3HluIkKXUz1i5a/Vtt4HzZwP1rfR1DkbblrSaeGGa7O2unRrHW0n8Slrj+GQXK+B9frOa/MzVrGYA2w2J3t3MVyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB6988.namprd11.prod.outlook.com (2603:10b6:930:54::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 07:04:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6500.026; Fri, 16 Jun 2023
 07:04:50 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Brett Creeley <brett.creeley@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v10 vfio 3/7] vfio/pds: register with the pds_core PF
Thread-Topic: [PATCH v10 vfio 3/7] vfio/pds: register with the pds_core PF
Thread-Index: AQHZlZ4hceEY8m3t0EmPqUpOuvje+K+NFCcg
Date: Fri, 16 Jun 2023 07:04:50 +0000
Message-ID: <BN9PR11MB5276B5AABEEEB9353BCF38308C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-4-brett.creeley@amd.com>
In-Reply-To: <20230602220318.15323-4-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB6988:EE_
x-ms-office365-filtering-correlation-id: 927a6e3c-dd35-468f-67b4-08db6e37fa17
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d+nmTTVezDIGAcpK0EtDmytssRhdrkgRl4biwJqER+CZLai0ncRfTRva1VDrIksATo+ousBpnDcnzAyGASh5rdMwerR1ixxJy3rfiLZ4w1h4YPEcZrJY4rmg95R5CxeyVnMKpYLnQyl9HLN2UnW6PCvof3XPU8/kdB4mLOJcIFAQh2G2RCCBc/IW6vLDrReCLH9T+7a6nf+uFmb753kLX0sdJ32BRA2ILfWmzqxEvUs2NaTvgKkshZFDubGkCtwE7++p2X7TEVuk1qGreB15ST+HRcx6VYGBu7htbF9+P0c343ezW7iDOsvJqpL/5+uqJDRyeeIdbXt7jbofXq8qYvZqj6O+SDN4PUdryyVNLB9aTWXNjayFFnNL5d0uOKE3mnpMChkuqcO7nCSngfHch0bwzLtIOAYC1u9d4QHns8oD4PTlGUjUlHsj7/j2+Zes4+UhohJZxkXEOnjQLZm5zSmq2NgUps7I1yajogfDFKZeb55aODpuzUFkLBSuOTWSCTFPhAafkZXHxLVao4ZR/0gXU+xdP/u2akK/ZuDEacknlaKM77/pMF2AjO1YSprUSI0NqMYVuYF5j1vloJvtQanKzYfSXv4UvSP/gYwDP7j1bCu9khJ1bhbX34vsZNT2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199021)(7696005)(5660300002)(76116006)(66556008)(66476007)(66946007)(64756008)(8936002)(52536014)(66446008)(33656002)(4326008)(71200400001)(316002)(38070700005)(82960400001)(8676002)(41300700001)(6506007)(9686003)(186003)(26005)(38100700002)(2906002)(55016003)(122000001)(478600001)(110136005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ntMdKGALn1clZNa6fPnHFZbNLO+GHfWQC6yV1+XDWDZJY9qCpG1WT5FkHzyn?=
 =?us-ascii?Q?xSwkhkODF1bdffRvs9xi+ZOpF0o5hwUJh+JBJgbUAMKBa4oJ67lOES92Dgow?=
 =?us-ascii?Q?iHWy7/jdwAmL6Imr8zjFR5y0JG4ljXKT4hBKMqQLxu0GteY4j0g8p6lPswSS?=
 =?us-ascii?Q?QXzAm5L8jwfcYEYfi5+K+zc9rdMJaitClN9p91VWAn4WIM5CeSkiOs9FcA8O?=
 =?us-ascii?Q?pqKc/tI9py51vFRiY/K3iKirddh9xAfASrCcLxxOyGhwrL5eXSNEHkto8hvo?=
 =?us-ascii?Q?6xmCedoOGAfz7CR/9nB2EMWWzqiSmH4I9TceIQCucu9Nm4ScWSyrXHNlTb21?=
 =?us-ascii?Q?9S+l29s8UYYmWvjBb+qFtiHVYkTY/fSERhfhUwgg9E44xcQLbU4n1r1DJ8DU?=
 =?us-ascii?Q?AhvE9e2rXGrXS28PU4TNuyOO68SA902BFBLfliYrPVIIPZCUblcgRZjEj1Yb?=
 =?us-ascii?Q?DE4WU4GpypAeojrKd41bnWeNiISMVOZByG42+SwIQ/JSu8CSogPeHCYCVJJ8?=
 =?us-ascii?Q?wqd25BnOPrQSBo7ewmmdTncQIyQnruyg5ju4sEynBJ48LdzWcHiuth+poXrY?=
 =?us-ascii?Q?P26OMUAPQEXfAkcPzjfLWbWLsE8pwrrHv9e/X6GhCQ+9SXPGzGPkNwGbrZm8?=
 =?us-ascii?Q?JIRsIHvG5WtHLlyjWznbFKoLl/aNZ8O+s37tfZ0NPfkjHEeQJ5hunwrsA2l9?=
 =?us-ascii?Q?q4iTpqabIMRYZAaTdCAkZBUvai7jy9mMMcEGKZ/Qg1AUea+cq4AM5KQnUEdE?=
 =?us-ascii?Q?iaDnzgOSfthfqIhqaD0vA1NWQPEsImWY86HntVrSxSfMN/GPEPJujvBqP6ea?=
 =?us-ascii?Q?CAxYEj5VLeaiegWZqyBmCAA8uvoGmLEfWVySe+8JSeUbxWTozsdfBpAUFy2J?=
 =?us-ascii?Q?pMzbpBuQRRoFpXKDIGHiTLXuGIe6iN3itVq7pMPC40Hx9qMi06E4w7HlVVFT?=
 =?us-ascii?Q?LrPPccKR0HIy1gFljA1EF7lnmlGWXG294WPBkxxE8mB4OT1U6FkRAoHPv5mf?=
 =?us-ascii?Q?lvJR+5JKnmW0wriruUy58YSYy1ZxwiSeV9hS6PxskJAK2hZllzPuRSKueAU5?=
 =?us-ascii?Q?Cntu9DWHuCarxzEVRQn46vG1shW+mmGu41IObjzEzDP7XDI36KCHg2KTXWpB?=
 =?us-ascii?Q?f2zoMA9Aoj+IbNuSNDwNtjj6X0iM0zWWTyq3JeQkWnju2BHAWSzBFABBoQRL?=
 =?us-ascii?Q?gZtbrRWAWE76Nddd9mfudqK7DwFBx3lmLhvyudodhaIS89WpmCCjjha5s5mh?=
 =?us-ascii?Q?Cx2LwZ9Iz1RWFBUjvkxASa5FpOcWZGTVZkhsYSaZE7fct6E68oXTPdgmmV6d?=
 =?us-ascii?Q?OPJvtEcsYHTcrm3ehOOY1JKcUQsSOWURD2FBeLYqdjjUbAcSOJyZXlnszHXw?=
 =?us-ascii?Q?b8dIeS5ZInixJjaNI+HDoA1c1jeCbNP6jchdsrnbZoGOkIWjqTOOs3J1SMbw?=
 =?us-ascii?Q?R0+mepxV8Y8weD6bTj9rTxpqCFPHHcFrK6R+eY1AQ6FF7WMWTvM+UgN2kMSH?=
 =?us-ascii?Q?wtYg4e0onOii0nLFEorsEudqcN003TAdKMAMIDea633K7cNY2ETpSJdFHkgT?=
 =?us-ascii?Q?Lj3DcmHBZPJ1F8xKa0qrlpBp/3CqncE+LjcXk/gh?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 927a6e3c-dd35-468f-67b4-08db6e37fa17
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 07:04:50.1151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HSqr3DUJ1bbPLgwXr3LIRGnhgcj/uCakRSuFsIzBIzsTl4Up574Ii1r0jrKWnmhqS+CnU7VOlXN4KkmiQ1FzhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6988
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Saturday, June 3, 2023 6:03 AM
>=20
> +
> +int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	struct pci_dev *pdev =3D pds_vfio_to_pci_dev(pds_vfio);
> +	char devname[PDS_DEVNAME_LEN];
> +	int ci;
> +
> +	snprintf(devname, sizeof(devname), "%s.%d-%u",
> PDS_LM_DEV_NAME,
> +		 pci_domain_nr(pdev->bus), pds_vfio->pci_id);
> +
> +	ci =3D pds_client_register(pci_physfn(pdev), devname);
> +	if (ci <=3D 0)
> +		return ci;

'ci' cannot be 0 since pds_client_register() already converts 0 into
-EIO.

btw the description of pds_client_register() is wrong. It said return
0 on success. should be positive client_id on success.

>=20
> +struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio=
)
> +{
> +	return pds_vfio->vfio_coredev.pdev;
> +}

Does this wrapper actually save the length?

>=20
> +	dev_dbg(&pdev->dev,
> +		"%s: PF %#04x VF %#04x (%d) vf_id %d domain %d
> pds_vfio %p\n",
> +		__func__, pci_dev_id(pdev->physfn), pds_vfio->pci_id,
> +		pds_vfio->pci_id, pds_vfio->vf_id, pci_domain_nr(pdev->bus),
> +		pds_vfio);

why printing pds_vfio->pci_id twice?

>=20
> +#define PDS_LM_DEV_NAME		PDS_CORE_DRV_NAME "."
> PDS_DEV_TYPE_LM_STR
> +

should this name include a 'vfio' string?

