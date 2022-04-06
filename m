Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341244F5CCE
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiDFLxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiDFLwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:52:24 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A4E3D51A6;
        Wed,  6 Apr 2022 00:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649228583; x=1680764583;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9yXnWPFaJPcfSAhgXMQM40zFYivmgfvuHZVyoADMm+c=;
  b=QYuIUUTFgKNNUhoLPEjr+MFALjO1/xIRd7ix+BTczNghBfuxHKFeaJyl
   tsYsy/UmrfyWFRIFBj/gMwotMHJ0W+QuRpImB8pNtTB6wEPHmbtRZyJVL
   KH5wCOiWpwP4r2jKI/RePMTpPt1c81ODPK6QvRvRES9FyN1LZIBGVWcp5
   AkJCqsgPTZWs+RBcJY3Qr8x9sKQFB+W+37sFs4HQIY/U4Ltg0tiOfRHtq
   x65sluwRXAl5uvRrzOY3pwhtyiLodoZGwm0eOOPLoYCdeKXO8Cxw1hpbh
   Nu6tCYVdeDE05VQ2VagN8cz3t7oaQSKWB/2Z6gvIZncK0KiyNdkqzSoI8
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="248491673"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="248491673"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 00:02:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="549419306"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 06 Apr 2022 00:02:38 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 6 Apr 2022 00:02:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 6 Apr 2022 00:02:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 6 Apr 2022 00:02:37 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 6 Apr 2022 00:02:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBsP97RyNVSYXfzW8F4rHWni1sG/h3uEbWD6PLNUBSygD18SAKz/2QGaWvwkWKOJvIuxtC0TlRXQpImmoftz/2uSqVx3+Ehq8gxCVS6Bf314AcShdPb7pYTcSpmQcbfv3tMnkZ3Xr8f0Qqlc4td0mx6k/JeRDXojsBJz4NDEH3H0NJF0LI2CjMRA14a8ZFLXxHb/3SiyELxUuZVL7S7xq1W/ARyqWTNvXZhKbuVB9su3DqB8Gt9imp80pIbelQDu2HBfhclZTSVEFQ95Gh+uX8IHaDguzDytGDjbyiZKWbDnKY1/F58jeU9hO+TYr7k/jrvRsU3m1ZDF0Ihlm1s0GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MpZ5rpjZ/323Q4FiP3H6XfuAq/WWbmz2u2b2ATpZRiM=;
 b=I7SefwtHVKGK5w/dzLMRezmQMPcMjak4bDmfbhQOrh9owDU7qceXEvhUx7QP6vTIEl7X3E6wF9kehI3JoQY+9MqI3obUP2+1Ar7gotsixxCrtDuQQdVs055tSrUUgmXSkXeJJ5i9F56+fHIRR4CPi0e+xZF0gIdkjYA6POen9mE23p51vhYiMEcm9qcohDdqIunLz3cF3ev7a/0Sh912/q61+IaM/AK48mtwGcV+8Aci8YqFf5c4LHunoZ6KeDI2W5zqdi6LD5bNC6orRhoSa561uibmqvX0VLUoXnNkyrvTUNl8cozuRWCwqmHO6InLXmo9ebT7NxfMjOSLQb9NJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB5885.namprd11.prod.outlook.com (2603:10b6:510:134::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.30; Wed, 6 Apr
 2022 07:02:36 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%7]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 07:02:36 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Jason Wang" <jasowang@redhat.com>, Joerg Roedel <joro@8bytes.org>,
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
        Robin Murphy <robin.murphy@arm.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH 2/5] vfio: Require that devices support DMA cache
 coherence
Thread-Topic: [PATCH 2/5] vfio: Require that devices support DMA cache
 coherence
Thread-Index: AQHYSQh+iGQB4aLBFUu6szRllIBFLqzhr6EAgAAFLgCAAMFI0A==
Date:   Wed, 6 Apr 2022 07:02:36 +0000
Message-ID: <BN9PR11MB52766319F89353256863D41E8CE79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <2-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <20220405131044.23910b77.alex.williamson@redhat.com>
 <20220405192916.GT2120790@nvidia.com>
In-Reply-To: <20220405192916.GT2120790@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd1d5368-9447-465b-35fd-08da179b6e30
x-ms-traffictypediagnostic: PH7PR11MB5885:EE_
x-microsoft-antispam-prvs: <PH7PR11MB58858129DB86C1F60B76C89E8CE79@PH7PR11MB5885.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Azv5BpEPVMypZ7ZE/68AxddWT9AhaSUULiUIPoVJ43Z/0MKytwAyzwrT8Yrxt5Dp0ZYkFzELg78LbjkYaHMquOq53uKZrUJy+lmTswDcMMmBN5RrXKckYsztRnkdaa/VZWuA+AwRKlgJlFg1ZIDDBLzT0dmUh2RcfBdPFoica0qEeg7hw8dBd0U4jeKHam3gIt1uL0tCJGFvb0lFhehH3qtC83T37r9P8Xokv4xKWU+AwTiKgHf1ft+fi/UNr/U1jPN6Yi7tD+7puHOzL8G/tmS0AbO71A/SVoL1Iew7gA4YaHECbP2FWe9HguZj6UnANprG74YMjjCFcPrr+9NaqKA/qPmwSFDN9QiE2TnHz5ZL0Tr3/HQsaU8fypcKGHtyhLj1LZGavzopgxXAt/RhVtgF2KbJp/m1hZ0xe1IEeSUUc+KNHeMLhjEVjy/7+zSnSVZeskLgwv9e2J/HPH/5rPtcArFwPJDSU+SyeVywNmVYC+tlRUCAD099uQu2LsPLwDEADO60oJTmGLKGKZ+YfdoUho5PgF2aY0Rk3XabBN5HHmPte5iLF76xk5yLYe6C0oEARuyxp2jRv3nuQ33cQdhuXd7bk3btMP60nY2D5i+GqBWYDVTu0KdKJxnsmuA3AlQWBU8ewvOV+wvZd9iGF8n3e8kjFAcIZdrTjy6vShaVMk46DF/w26JYLkrj7TGmkuaV4jyiZINYqWdrhmZIA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(8676002)(71200400001)(66446008)(4326008)(52536014)(66556008)(6506007)(66946007)(110136005)(66476007)(7696005)(54906003)(508600001)(55016003)(76116006)(8936002)(64756008)(7416002)(5660300002)(33656002)(86362001)(9686003)(186003)(26005)(83380400001)(38070700005)(2906002)(38100700002)(82960400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Gmd1F0kaSG5OHjvaZPLWx6NVaVyull7bel9d013fcaw/eZO66M3Nlk0keRtl?=
 =?us-ascii?Q?qXKs/c15VLZfQqrjKDz+6NRbKj/s4SC4rGViNbMb+NDxKmd8XfE3JFF2R5WY?=
 =?us-ascii?Q?n0nv4jZg9OFH6soZCsHJDj40gZMxcgWHivfd06apqJE8je4LmIrmlQJ50NER?=
 =?us-ascii?Q?iNheOoO4UGVfbz2onI8JcCEWyD3gIlHk1PTjMNb3hBMnTsCb9h3Y1kmeLoXW?=
 =?us-ascii?Q?W8bsQWFHAf2CR5QP4ru9aqvIhhy7+O8QfqGmv2KFvY/Sa8i6PFyIP2XcrZAn?=
 =?us-ascii?Q?5z7pe3JsIzs6UOOeGWVHdj3nCS0tby7si/rIKV75+ykVgXKL1bQwbMBI/MlI?=
 =?us-ascii?Q?JSqLhRJmRRwbBHlwFYdRCXI0jr83C25hmhNAGDNf5h0MZ2tTCF2k71l5bGWK?=
 =?us-ascii?Q?HCbAMCMpMBNnZAulkP3reD46EIRZ3dvHVB/5ZJtKkkUyoTxDzS/ov72nVDhK?=
 =?us-ascii?Q?2bpHACHXYHosAZGAsGyPboQLRmEzgwRZjsHRNFy2YJSI1YwZXYyuDa90MXqA?=
 =?us-ascii?Q?Y5mnSY79Hz8eZjZJa0KkSxZD0pgwieACaVwmuPPemBYl8y+oQsQU1FirHxCX?=
 =?us-ascii?Q?r+qkTzDgJWTjTEiZCQEmOK/rXxpNImDo3L+1oXW55Plrl2bwooUwjL0XgIG1?=
 =?us-ascii?Q?VjZvEsHaAd2J/s7Esb3cItMM6C2cwnJoCc3VqbGD9F3G3fdGToopNpMcZ3Gi?=
 =?us-ascii?Q?h/HnFNTktk/hoEy5fuL3rpZFbcCxEO8CNXhZX19IVoYuHI4JnCd3bwpTq04d?=
 =?us-ascii?Q?izOz6txSbXP/mv0nKwZlJJTqizYnGvh8/2rYx0OQdQZ4dvWMNZxj1dxsG1P5?=
 =?us-ascii?Q?cNiET/y45qWppgv+SQtmwiB+lgVP2JA8Xb/aJ7BDrDPpL9n2KZ1HUE4mMtoH?=
 =?us-ascii?Q?dlqg+TJCmtEsp1+Qu01XC7lbMLGTiYM5jXJH6dpPeY1opkE7KYm69HzJiH53?=
 =?us-ascii?Q?BpntXw4Xk12maVf5vCLMvSLKxso5p8u25XMOEt+2/SYGXq5OQfbAbAGVeGGA?=
 =?us-ascii?Q?RhEtSFIaE1c9Tc+efkqOVepP6Mx73Fs4Jv0mfHT7kTm9JWRlJVoaQuJ88nm+?=
 =?us-ascii?Q?HotDkb48k5pfBQFSWVKiWoKOBcp8fpuAR8GYKp85RrPaaBY02r4pMlln7dF+?=
 =?us-ascii?Q?dBYR1QPq7T66ZezYi1vT69vW0O3iJQyXEjFn+9f+RdATD1YtqwAfjYq/VSkp?=
 =?us-ascii?Q?HcRqId623/McuWWdEpoUgBrDaQG5YqHsgOLdPevAybSYNFuBK1P9c2T/6uVw?=
 =?us-ascii?Q?1e3J1hBExHlF6giKAJKQB+rfEXsKvRXXmNIpeGkcbOOpyjoipkef8lQIAnKv?=
 =?us-ascii?Q?/9cCV8eIXsvhthRjwQI1VY1LAs5jBhjwiMwYwO1vt2UesnLbubAR245RnSMY?=
 =?us-ascii?Q?jj8ZX4ZxYLod5yLxFgEWVeBZo7NyH9sLp3EAmjWKkzlC3fFaSpK/JudmfxFz?=
 =?us-ascii?Q?KN1v6PhPUxTtOow9q0i4A7Iu/lJnN6dYvlqFYqgxK2xM11g6XghiIp+VzqfS?=
 =?us-ascii?Q?1aYELPMwWCcKAtFpurpawVpA0KVaONCKLph89gy9ndocCfOxTrZKOqJy/NY5?=
 =?us-ascii?Q?fHlvn6vL5ejF6q12tXcVcD9+MuTy4QN/iqfJCgxzLtplTW0k/lsgbk2CQoxG?=
 =?us-ascii?Q?I8YaJ1mgTJgWBE7LfMvHMhKMxdpXcB1uqjK/AQpZfDvlC+8ryk53WArLR8tV?=
 =?us-ascii?Q?SKsaJJO4PHb4mDVcpWdb9FYN4t8iQENqWvya8oejN3H0SagMFpS48o7TXnWK?=
 =?us-ascii?Q?oDDpdNwP7g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd1d5368-9447-465b-35fd-08da179b6e30
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 07:02:36.1106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bnIj9JeokweneDmdbZpx8OX+uXUvq0hi4EJf212dVk9h+hRopZ0qPTT8ZZAqihWB/l8gdLrsiJoZgLSeSfMKIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5885
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 6, 2022 3:29 AM
>=20
> On Tue, Apr 05, 2022 at 01:10:44PM -0600, Alex Williamson wrote:
> > On Tue,  5 Apr 2022 13:16:01 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > > dev_is_dma_coherent() is the control to determine if IOMMU_CACHE can
> be
> > > supported.
> > >
> > > IOMMU_CACHE means that normal DMAs do not require any additional
> coherency
> > > mechanism and is the basic uAPI that VFIO exposes to userspace. For
> > > instance VFIO applications like DPDK will not work if additional cohe=
rency
> > > operations are required.
> > >
> > > Therefore check dev_is_dma_coherent() before allowing a device to joi=
n
> a
> > > domain. This will block device/platform/iommu combinations from using
> VFIO
> > > that do not support cache coherent DMA.
> > >
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > >  drivers/vfio/vfio.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > > index a4555014bd1e72..2a3aa3e742d943 100644
> > > +++ b/drivers/vfio/vfio.c
> > > @@ -32,6 +32,7 @@
> > >  #include <linux/vfio.h>
> > >  #include <linux/wait.h>
> > >  #include <linux/sched/signal.h>
> > > +#include <linux/dma-map-ops.h>
> > >  #include "vfio.h"
> > >
> > >  #define DRIVER_VERSION	"0.3"
> > > @@ -1348,6 +1349,11 @@ static int vfio_group_get_device_fd(struct
> vfio_group *group, char *buf)
> > >  	if (IS_ERR(device))
> > >  		return PTR_ERR(device);
> > >
> > > +	if (group->type =3D=3D VFIO_IOMMU && !dev_is_dma_coherent(device-
> >dev)) {
> > > +		ret =3D -ENODEV;
> > > +		goto err_device_put;
> > > +	}
> > > +
> >
> > Failing at the point where the user is trying to gain access to the
> > device seems a little late in the process and opaque, wouldn't we
> > rather have vfio bus drivers fail to probe such devices?  I'd expect
> > this to occur in the vfio_register_group_dev() path.  Thanks,
>=20
> Yes, that is a good point.
>=20
> So like this:
>=20
>  int vfio_register_group_dev(struct vfio_device *device)
>  {
> +       if (!dev_is_dma_coherent(device->dev))
> +               return -EINVAL;
> +
>         return __vfio_register_dev(device,
>                 vfio_group_find_or_alloc(device->dev));
>  }
>=20
> I fixed it up.
>=20

if that is the case should it also apply to usnic and vdpa in the first
patch (i.e. fail the probe)?
