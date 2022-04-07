Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5B14F774F
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241641AbiDGHVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbiDGHVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:21:52 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06C23DA57;
        Thu,  7 Apr 2022 00:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649315993; x=1680851993;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5e8ATo0klmZdaCEBi88L0q/LM7DWwEXqIrBKodph0Us=;
  b=fzONDCXjlMJshkQrB8OMg6AzVa04Casvub5E5YWo+Ylhn8mEWBFp0NTp
   CJ2YVkd4SkTdTCjqO6Ph/17JsdEMc4TV/JnTXFvnUuj+FZZvHIHRPbAHD
   HyUsF1pyNDqipOeRX9viRWmXXgaLi9kGGy44k/jnl/jVxK82bQdyga3Lz
   12qqqDxkoWaSdxmydnlhVLPDfNN8gPdJeL5BmfxiC4i5LnfzUwa/jaO1V
   SQhmE4VOy+sUQPEOgV3cEX3YCypolr9c+9R46LwxdaosCQDFzU1CAcZw2
   Zn8CebeZ2ss0tiJHqg7qj3jMD4oIcPZufGhVQ9GzdLpp4brtNpMkL7qgw
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="324413253"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="324413253"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 00:18:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="524261484"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 07 Apr 2022 00:18:50 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 7 Apr 2022 00:18:49 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 7 Apr 2022 00:18:49 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 7 Apr 2022 00:18:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=krkrtgu/2y50qXXjH78qNd0drEw+SOw2aHAKY7EUgmtKREL79h0xNhmDa99KKUjXNtGH6/oKEKJI4btlRCCq7FDLb36BtS50k3+OSs9yEV8oFHk0L7y71BZDfXclzNDEYqHxACuthHA1MXu3tgb4AunYyr32qL9lSaVnQ703c9AADfywjd15sLnH5GEtvcReG0b5donwIpsPmTtFtGKf1DQBoR+c5XAmSt83zDDndns+hRVZ2RPs/AT+XwZJarwtis8iPCIHl6ISqGJbK+nbZy5lvOFVEOO/tudF/3NTpW6k/9g6e1h3rxxfe7NwWeEzpVvuGirJFoDtq4oDraoNTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p8j15PPB/AeE8HEaprZGW4TrUC6om0xeGAM72fywzD0=;
 b=AAHggMlEwU9v3w3SacXWyzW60+tLaTmyhnddWsqP9HfX4gUTTL9i0g0khhMcwlQu+AhWTfObZerCxSSk0A7Z7xS2hEfIIegO2A0ciNUeiEmgOiJNlyAu5+jk9yoBGgHDLjd4Itgz+s9RdenKKKKJw6tAziRLJMXozpX57eb8Z0mvVIN5aS0MuFRkzpwdPUQgY4TOw2/o3gm+qJq+yNVKLp444x/xEufHK++Pyst4ZXwRU62NupPOndmVepYEzCmQO+ssLZOj0k6Rp2Clw+/RlXNp1B1RpUSCflbzZ0H6S5tmTANhB+9so96WC6mhfL3Uh1pwg7F9djD10qPE8fb1AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB5707.namprd11.prod.outlook.com (2603:10b6:610:110::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 07:18:48 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%9]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:18:48 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>
CC:     Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Christian Benvenuti" <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Will Deacon <will@kernel.org>
Subject: RE: [PATCH 1/5] iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY with
 dev_is_dma_coherent()
Thread-Topic: [PATCH 1/5] iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY
 with dev_is_dma_coherent()
Thread-Index: AQHYSQh/TPpLZZyKkUyXi1ZQWx4kH6zi6kkAgAAHtgCAAA8MgIAACRgAgAAEUYCAAAEogIAAEraAgADoPXA=
Date:   Thu, 7 Apr 2022 07:18:48 +0000
Message-ID: <BN9PR11MB5276F9CEA2B01B3E75094B6D8CE69@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <1-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <db5a6daa-bfe9-744f-7fc5-d5167858bc3e@arm.com>
 <20220406142432.GF2120790@nvidia.com> <20220406151823.GG2120790@nvidia.com>
 <20220406155056.GA30433@lst.de> <20220406160623.GI2120790@nvidia.com>
 <20220406161031.GA31790@lst.de> <20220406171729.GJ2120790@nvidia.com>
In-Reply-To: <20220406171729.GJ2120790@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22fda281-f893-42d1-4e51-08da1866dbf0
x-ms-traffictypediagnostic: CH0PR11MB5707:EE_
x-microsoft-antispam-prvs: <CH0PR11MB5707883014D9342003E749908CE69@CH0PR11MB5707.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5mjgxGVM+/EqvYHJB5AytpFHVz9phvYZ5P52vxcHLDwL1tolcYLMqNihbw8axleuGQ4ISfePMNkOX8reGY612fxUvYGx3tnX5QBQWQHICnEOT9odbpBKXzBi6O6NFt9vqBxZO7Dg2fHZvryz1o9lj1Izr3/LKNvQDpRndVJ3ANsC0xieweKsg69gU284+tQTdpaVHxyZ558rZGOTHlzN8b4hA671grfE6d3xaTJ/6odVH/YclSGexh3X1NqbQ33jhDu26UonBPDoUoV8joNQomDmd1Jki0cdoKheEhX5XVlpOtDTdRzfFFBB/FaY9D33bU1fFLJivN/3NqfM/wf8lpNkClfvj20Nxagf0eubjVZciThXS/W7/KF8zba/fiuY7QmiESrWfTs39jcaV2rHDQjgZTTmPUGTuWwTS69mw5G00JPEaUTWz+C+7FwvKzbZHmVfxhqMtvn710Eu96E/3aNjtnecF+2XAvf4NqM6S7sQ0/5wI3x5hsqvh+WEP624ddMZce64wV0bVCTl3S8fGLWVsn4yRVovptaTpeCLxyeSN1iXm8OHqXaIA0clmCcgZGEmP6O3a5P+5nd1tU4UBjTMnfl662aCunZyEpm7PvmGd1R0uzHOjKdIKKiijZujm8usbS3y/dkwdmh6mzvreaLl2mzzRgxd48FXJt2BFjJfoHb6wu/L3X8Nal34bfUHHeD11REfI/SsmXTbavVOxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(55016003)(4326008)(8676002)(76116006)(64756008)(66446008)(6506007)(7696005)(508600001)(9686003)(71200400001)(26005)(186003)(7416002)(82960400001)(110136005)(54906003)(316002)(38070700005)(122000001)(66556008)(66476007)(66946007)(8936002)(2906002)(86362001)(52536014)(38100700002)(33656002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A/kC1SCg4Xd3Ay+lXXrt+k3qlot0Veg2lw+584lGucDuMsgxu53GfrnpNvwn?=
 =?us-ascii?Q?2xClBb3HgGAY4EBE1web5uBpTFGMqehZIoCDj8Ydf/wsK9KG4LrgZol+ZOy4?=
 =?us-ascii?Q?z59roiLthGkSpeDFh58384cF5yqA1xs8TPHwCxZXa49drrnqngJ+yrw9xuFW?=
 =?us-ascii?Q?yYqcWDN15nEgFgJmKSDOGTMlHF86SedpBiajzNKj5Pq9BWpZ616MLWnf0TnJ?=
 =?us-ascii?Q?Fw5LPUSNZQMNmZyNI0/PvlFFURIL5M2WPDhpqYUgha6y8Y+KmgfGY1NRvpvZ?=
 =?us-ascii?Q?+ckFuKTdBdavonK8g9M4iywKR03JJFjTK2yqhBr07YgABOI6Td6YmOqrO0jt?=
 =?us-ascii?Q?on0DCgZ2YQ3J4HUPkq1sMc3pu/Z2anixZU4lBIWlnFcIxRZJ3nQI2lrM0ruK?=
 =?us-ascii?Q?T+ptMDBuVR/5HM7HRRSRSfRNRW9WBpnhxBWBTyIJaYcaM76Bo7EjQoaP/pEJ?=
 =?us-ascii?Q?PWwHDg+pbENmsi0R7ddUbjX/BjCfz3ybIyQsE0bHQiEO0weywsEvRLART6Vj?=
 =?us-ascii?Q?k1XOvUwR+jM+xxpTJO2bYrLItQB8yRsgYCoc63pvqyuJY5CuLTInERuX7QG3?=
 =?us-ascii?Q?WWbbAXhmrniuy/BrvZtxA08S+MHRx0Huc+Z8a1gkXodlPdtenjLBGVa/yiFM?=
 =?us-ascii?Q?Isbkv6Q5QdJdS0bdqfezkLa6OxkagWOed/I9JRfS6SfqWAI4pEK9IM7uMz9J?=
 =?us-ascii?Q?0N+Vf4eFKHUHTQnECreGLMLzYK8pxizg0DXbi5b0W8PI50OxuH9xE/fN22eg?=
 =?us-ascii?Q?nrmjg82FmDcgxuj7twVssqB5HyYUQTVslrZNlXDwvnDwfsiwRQLKtWzD2eYf?=
 =?us-ascii?Q?BQYcu+g/VhI+SwHJqVMCbcX2ftVq3hqLZhVPH0GassVMvwZnCJ9rZQK40Mqv?=
 =?us-ascii?Q?2gCEmEKrfE1804FgJkIyLChoGKoUBRUMZ6q1ddt7cwr27q3ItYXvjTkPpmsk?=
 =?us-ascii?Q?iJvOZNKl1qAqE4jogZr1lXKTDwPqwxmH5VhmtDEcV0cxZcqIpoChk2wwXtF5?=
 =?us-ascii?Q?KP6B4QfOgwVE42v1OMPl1RiRJQQrLb+cbZMpu56V3dKKiiOLsPQCZwps+9zF?=
 =?us-ascii?Q?X7vcFE8ATbqEDljifBnJXaQFVMOh66lFvW5krCjjDq8YPZVbIrPTzjYRIT4W?=
 =?us-ascii?Q?EMVoIQd/YwTp00jAmQ68Uaasy7myMoxIFI9CO9YApit29oEhRrGLX3r9PXFZ?=
 =?us-ascii?Q?Glf3yZ71ULm2et6oYAjrIpaBtUC5lYQc9UP15KpXoAPUInwehNfSCbpmRofn?=
 =?us-ascii?Q?gk0IkzunrKDo3/eCX3w6M5LB7rnFHB4GCm3HcREmBmf7IyvdFR25dl0CCE71?=
 =?us-ascii?Q?Q0ah8whPp60o1nG9ReXfO3NKPOFBpMxpZYppNkiXnHx9GPn/ML/ooXPMCIeu?=
 =?us-ascii?Q?YFwUePCTUEgcNvebnvzeCXp/di2DR/iq646EAccT4Z2WOqpdT+q6BL5D6LZ+?=
 =?us-ascii?Q?wDo30PJ3bsvJbk4WmXvb38hwZAcZdtJzhotE5ReV/nTDieyTPLnh4IEpJOzc?=
 =?us-ascii?Q?SEeVFzt66fkwc7CvS5o9IBAfu7KKoArR5WguaYJwSBCB0Z9wHtYtvDwACd+3?=
 =?us-ascii?Q?RllIqgrqMPTioq6sordNvN4ue/coc/6344S4mgS8jufGDhDcebX+Ah0qNGp3?=
 =?us-ascii?Q?M3a02ZegnV5x1q7OlMf8MXTpCYaQ/NHuvF2Il/ewi1NZXAtpazuqapOXmy99?=
 =?us-ascii?Q?eg1nAhDr2bN2kt7NQTYUyFZPFI+SVBFANVx7r5Zy7ZLCAqAE8sDw0xxuUOlJ?=
 =?us-ascii?Q?WvhidKLZTw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22fda281-f893-42d1-4e51-08da1866dbf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2022 07:18:48.0161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tI6z4EE9qQUvFvSe+UKzqGjY/5+N/WNoqTxSl1w13Sb1wlXKLhKTVZchlGtAQVUZVxigP8BkLMXX5j5xA6I2zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5707
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, April 7, 2022 1:17 AM
>=20
> On Wed, Apr 06, 2022 at 06:10:31PM +0200, Christoph Hellwig wrote:
> > On Wed, Apr 06, 2022 at 01:06:23PM -0300, Jason Gunthorpe wrote:
> > > On Wed, Apr 06, 2022 at 05:50:56PM +0200, Christoph Hellwig wrote:
> > > > On Wed, Apr 06, 2022 at 12:18:23PM -0300, Jason Gunthorpe wrote:
> > > > > > Oh, I didn't know about device_get_dma_attr()..
> > > >
> > > > Which is completely broken for any non-OF, non-ACPI plaform.
> > >
> > > I saw that, but I spent some time searching and could not find an
> > > iommu driver that would load independently of OF or ACPI. ie no IOMMU
> > > platform drivers are created by board files. Things like Intel/AMD
> > > discover only from ACPI, etc.

Intel discovers IOMMUs (and optionally ACPI namespace devices) from
ACPI, but there is no ACPI description for PCI devices i.e. the current
logic of device_get_dma_attr() cannot be used on PCI devices.=20

> >
> > s390?
>=20
> Ah, I missed looking in s390, hyperv and virtio..
>=20
> hyperv is not creating iommu_domains, just IRQ remapping
>=20
> virtio is using OF
>=20
> And s390 indeed doesn't obviously have OF or ACPI parts..
>=20
> This seems like it would be consistent with other things:
>=20
> enum dev_dma_attr device_get_dma_attr(struct device *dev)
> {
> 	const struct fwnode_handle *fwnode =3D dev_fwnode(dev);
> 	struct acpi_device *adev =3D to_acpi_device_node(fwnode);
>=20
> 	if (is_of_node(fwnode)) {
> 		if (of_dma_is_coherent(to_of_node(fwnode)))
> 			return DEV_DMA_COHERENT;
> 		return DEV_DMA_NON_COHERENT;
> 	} else if (adev) {
> 		return acpi_get_dma_attr(adev);
> 	}
>=20
> 	/* Platform is always DMA coherent */
> 	if (!IS_ENABLED(CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE) &&
> 	    !IS_ENABLED(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU) &&
> 	    !IS_ENABLED(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL) &&
> 	    device_iommu_mapped(dev))
> 		return DEV_DMA_COHERENT;
> 	return DEV_DMA_NOT_SUPPORTED;
> }
> EXPORT_SYMBOL_GPL(device_get_dma_attr);
>=20
> ie s390 has no of or acpi but the entire platform is known DMA
> coherent at config time so allow it. Not sure we need the
> device_iommu_mapped() or not.

Probably not. If adding an iommu may change the coherency it would
come from specific IOPTE attributes for a device. The fact whether the
device is mapped by iommu doesn't tell that information.

>=20
> We could alternatively use existing device_get_dma_attr() as a default
> with an iommu wrapper and push the exception down through the iommu
> driver and s390 can override it.
>=20

if going this way probably device_get_dma_attr() should be renamed to
device_fwnode_get_dma_attr() instead to make it clearer?

Thanks
Kevin
