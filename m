Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B624F5B95
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 12:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349113AbiDFKbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 06:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376555AbiDFK2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 06:28:42 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7771B2976C3;
        Tue,  5 Apr 2022 23:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649227929; x=1680763929;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wf7/CcT0a5yPgt+TL7C91Be1g59B6GFWr4gWWKYIxrY=;
  b=YLZk+xDmOdG7SGeKzKtD7YYP+rhLigHv92Uv4r7HcTr959hdRh7I1+qz
   3eTJ1o35bGDNNzUKeurF+3dkVHfZMzwwR5EayV+E586z36CIYmSUMzVOU
   tL7/2MWgMv49Klx8UScSaSHPwahI4gSCz+01Y9+GSDHo8MvK437/B7+Jd
   WhjAsqN/J2TapoMsXbPG7Huv2SK6ShHUls6NlG+YaJyei7hEpXxOnP/5+
   77ujxJpBTgOaeYB1eJNlsHpYC2ctEVrihz4pBpkVyWpV9GKqVnA4oxsu0
   dUwdhk4ZnRUMmJwI06cT8w8Rxc97Y7nGXdP6mGoEbyFiOZUIgsHDXYI46
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243107247"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243107247"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 23:52:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="608775548"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 05 Apr 2022 23:52:07 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 23:52:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 23:52:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 5 Apr 2022 23:52:06 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 5 Apr 2022 23:52:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQ6+BXOUaPJvMyoVi6rsrKiWfEq0dNEZSBttqianjdIdgabbepCMbQ1YaFBWeCZWGCT38InkgsljUWr9WshnIbnwRZVXGNsUBQx1J2OvZoAAfeqNOARJJHN4/i7tGaV2CDkaRYFP4y52BavoigAfNXmGpyyznq29Knq7AYmP8/jm+sksoZ4qZppZXr8a6fz756fKio7xTDTZx2bZfwF0bwahrUMrFVc/U8uPFlrH3vMCLahoeZ95iPRz4fKkbivN7I8QmlnyUyoYR/yTUjSdBqUUbIyGwUN2jDNOCEaEPtZbjPLqMj7nCAgNeA/x1ldk0o/2WlULDYNYbZE5lIfJnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JR0dNazwoir/SlrnpQitd1kqkNBZo8m5ipI8RWmHMr0=;
 b=UbwjgWu0s4ccEeufwmVtOJAMA6nYxzKzkDeSiFXVyDbClPKI7XuAl/vwjxvrF3IMGv2dukiDZqpIuU0JaxvDEWBHPuzUW3+85O5G7kBUjehCYnikg3rS+0YNtBDIfS9131QOm0MMHUUEAOWrlMZf0wlTQ9okdbG2psbjYuFM0HjD9eVweC3yEanmZ3FdXaWkeqle2JXsBr/KXHMPV7Y7JcK4Vj4rvAqQcTM5jeMp3d2v7F5rTxoaZyPmFgMIbHpDFsCJWoXW3gsVp7wgmuYA6B5WX2bDmjC+O1AdQJmrkQCA1KfSAHYSJ0OW7Bo3dL8NWB6D06o7bEMvsJGj0HjPqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB1285.namprd11.prod.outlook.com (2603:10b6:903:25::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Wed, 6 Apr
 2022 06:52:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%7]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 06:52:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
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
        Robin Murphy <robin.murphy@arm.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Will Deacon <will@kernel.org>
CC:     Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH 0/5] Make the iommu driver no-snoop block feature
 consistent
Thread-Topic: [PATCH 0/5] Make the iommu driver no-snoop block feature
 consistent
Thread-Index: AQHYSQh7yOOnyyXkDU6kVW/BqdTa9azib6ag
Date:   Wed, 6 Apr 2022 06:52:04 +0000
Message-ID: <BN9PR11MB527679A12CF8298840D12B488CE79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
In-Reply-To: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3998be38-7fb7-4ec4-e39a-08da1799f5ae
x-ms-traffictypediagnostic: CY4PR11MB1285:EE_
x-microsoft-antispam-prvs: <CY4PR11MB12857557DA39EF6E1CDC56848CE79@CY4PR11MB1285.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oWJ2fe+2xYdrSnElnia0+RTSQQV1pwZgdJ6ljRInrWCXEn44K2TVngdvlSzxakK8KlGoRkWwvI+z90XZIP55qBY82/3/64gMeoE6F2ALJtGdSCe3NqiDi25yDJl7gv1+TWLiunBjs4XWuG/H7mRqBTCBcD0Oxzwg6+zEiIasRzFivO0AzhaaKeK3C7VBYMpBzOqkjJXgQBfAu91HUm03lf+sY72OhXKpfeQtoyzPXD1xUGzkV4Ojgy5jiEPqp53kG36f5E+CyhE+s5HOIfZchzBIxmdAe5RibJLJwhLuQoI3Ej1HIaat9cx48WyHrB68s/Ujy+ZzxV1Hsu3hoVUy2+TNpaVmsalvM5e0vbSrXog3cX7Bid8iYDQCuvqmSqlEggPdruYiKDWPnqwmUbuiidMMcAM5PupfVYVhhxo2Elg4VHC5D6lVPVZ2i7z1+nARijric9yQ8z8O4zNOTyjAoUlQCMsS2wS5Y52+e2RSRdEN8+mQFEvtIE3tZMrgT3UqTIMmZrTNFCa+k3yF0VFKcxSBHPrw3fhkrMVk5BMloiXHuodm6ZC6Q0s+dZqQP30UWY6GyKoPS/oUFSkBBrfnD78GS0nBiVYFEirfWXOl+v/p1lzgyuJRw1F116TMY97vTufZrd813qtVeMcNdiGAtXwCvmsbrEKKheVUXyuRBvdKd5DCb9/NbabLM4LHKJHSF6nZi7JjDEi5G9OJL/ZWC5wSRdC1ouoTlG/EyZNE/zeX8zcNzVfaJlguGgfSjraemo/x7Mp74tOdMJZj4EtB6t+GPRhFS12ZAp8ie6U5AeF4Wt7KSNi6hxWB1oZCGjqg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(76116006)(66946007)(66476007)(9686003)(6506007)(7696005)(4326008)(66446008)(64756008)(508600001)(8676002)(122000001)(966005)(38070700005)(2906002)(86362001)(921005)(38100700002)(82960400001)(83380400001)(8936002)(110136005)(7416002)(5660300002)(55016003)(186003)(26005)(71200400001)(33656002)(316002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4gNdTrl1VZdf1qij0yH2QnEbbMiJf2sr1DA5FZ2ylEo/kcyn8SanfRmRC27F?=
 =?us-ascii?Q?5tTfeH4a+tKzPwpVYwf3SxfgqSzCxV929EzcLZ7PoDk5A1ENAt2gKvCVetyj?=
 =?us-ascii?Q?JvzvCQElmv82dJxmk8ulp4wOwLKtY9UwBzFtncipLzDPWBNVkRvdllcOrhTl?=
 =?us-ascii?Q?qBps4mpUqgCNIUBkLiS5Z4bO3g1hB1Y0cdUTN9r9XJZ02viQjqVcIMVjWr8E?=
 =?us-ascii?Q?vq9rkA2do6y58+Rp0/AYyqWtpJO6XuaC4nUT6FDXWHVxMtfry9QrV929wGYl?=
 =?us-ascii?Q?8jSfz7pVtbb788ET2lOE0wQpOyn0oJ5E500RTQ8UHhR8AtM7TOB+6hi9+WzN?=
 =?us-ascii?Q?Cibc5rX7kYwcHNx0FgIc/2Zy+dhrfI/a7CJHQVPaqwOa8ux1vpcG2Xt4YrYR?=
 =?us-ascii?Q?+PavdKZ4Yr2Sonpvos5h0O7e6ym/IJAkLJOeo0I0EPtuH9gMLKq0zWHKuf/+?=
 =?us-ascii?Q?6CaqcvV/B3qoLt826RUrfNv7+8rQBvlRSEmA5SCCvO/qriy3QlNtUa+/8+6O?=
 =?us-ascii?Q?Jv3kcWtjszN+WWLJLBTqjA5rlo/yjmmtOmQgn0pr8AFGbYQ5SnMRWA5H/PZA?=
 =?us-ascii?Q?E/3w/vkzJHIyqA64WiJOURROYNnYrOa+pIOla9MWTZmblbz5KexNQic3K9Cj?=
 =?us-ascii?Q?qfMlM+1+L7QBtIe7ZIL42lG/GAZxc/J0oj34i4rJgHvtJULMDG0mTDeQHpnJ?=
 =?us-ascii?Q?4uTFfdirssMDM3Uv+rG1WUr1ldQuwT5CyKrj65Y3yj+k8nt5Zel645sTLrlD?=
 =?us-ascii?Q?CoLt6kkAN436xyoJhJEQIQaNGdQhwA6SlejvrhlNaBnb+VnY5Cffx3LXRk1v?=
 =?us-ascii?Q?MIB5nwq9sIz9k9qtDQxCXtbNX0QD7adxVH0cp60BJna0t4JdJwL0a3/9pNUr?=
 =?us-ascii?Q?pScJlW3g0mEfeNk/NRXuGW7iRcr/XupVjAcOINkVpAYllIiJKS5cfgeSyj9p?=
 =?us-ascii?Q?3TZaVL8G5okMv+K/87aEjDEkMe0jUuAJKGOyOS+BIXNaXldjuORsCcr6rHY5?=
 =?us-ascii?Q?XtU/cTgBcko7/BPTBL5N33c1k1gwSPozesfRrPQdLdzrADwfsl4ktNXGtXIQ?=
 =?us-ascii?Q?mpqAo2wViI0rh16+K0bt49f89CoKGJLlDh1NbieKQmVo+jnxXXb9rwJy2hTv?=
 =?us-ascii?Q?a2HIf/lhAXxpqEQq/pLeSh/KNrmS0Ha4ahIZc/LPobGIYwIyP5EJ9CsbGt/Z?=
 =?us-ascii?Q?G8krrFotcpjbMXjaN4yJ/YEbet1Z0d9hpGiIVMpEJ79sS7CUGSagdLMmP+jZ?=
 =?us-ascii?Q?KasJ9kNkD6EluDV5Cv6zhYJdhqM6pXNuqGhVQrvxTpLdO86heEY7WtAipSzP?=
 =?us-ascii?Q?WVPUKs08JjHSx+mz7mY7aXjG4i6s9Eb4/aCw7e2hKikSIpFPiXfGUZpbcdyU?=
 =?us-ascii?Q?nxx6/aXh7Rtt4weN+Cmo2VhX9w4MGMFqhB30ucMswckkbcmSLawAso4Lx2A5?=
 =?us-ascii?Q?LwSeoVrLfKfgc/TVSEA3N3ef8bUp8vJRW7w5/eJAJsG9W/PaCeNyj2HAOidy?=
 =?us-ascii?Q?ciDdJhT8s4wsiFLglfCZBwBXEjlu8V9sI+b7KX/HLjXiCQxYR/m1IHbZ5Yi8?=
 =?us-ascii?Q?9ATijdn2LR14bVGOhmEx/aIG3cbm4gQstgGwTh2JgqCYKBTGmXLjDX5XBUtn?=
 =?us-ascii?Q?NK0FAxUTdWPIo0R1Fk7myBnzzXY11e8qH/QIm9phcw96dY1AwySKqPISWuuf?=
 =?us-ascii?Q?T6LcM2gWr6kvZpO6Y43QwYc+41W7qcS6klZA7pyDTX6cEELITof/HqseUzKX?=
 =?us-ascii?Q?Hv9btq8EVQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3998be38-7fb7-4ec4-e39a-08da1799f5ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 06:52:04.4395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mHCqguzgX84C7lhiVpxkxXqpBniCcWptMy2iMiE9qhgv52Q8plS7nvwkrD55Ao5TKnAy3n+J/OLkVvT92ai6QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1285
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 6, 2022 12:16 AM
>=20
> PCIe defines a 'no-snoop' bit in each the TLP which is usually implemente=
d
> by a platform as bypassing elements in the DMA coherent CPU cache
> hierarchy. A driver can command a device to set this bit on some of its
> transactions as a micro-optimization.
>=20
> However, the driver is now responsible to synchronize the CPU cache with
> the DMA that bypassed it. On x86 this is done through the wbinvd
> instruction, and the i915 GPU driver is the only Linux DMA driver that
> calls it.

More accurately x86 supports both unprivileged clflush instructions
to invalidate one cacheline and a privileged wbinvd instruction to
invalidate the entire cache. Replacing 'this is done' with 'this may
be done' is clearer.

>=20
> The problem comes that KVM on x86 will normally disable the wbinvd
> instruction in the guest and render it a NOP. As the driver running in th=
e
> guest is not aware the wbinvd doesn't work it may still cause the device
> to set the no-snoop bit and the platform will bypass the CPU cache.
> Without a working wbinvd there is no way to re-synchronize the CPU cache
> and the driver in the VM has data corruption.
>=20
> Thus, we see a general direction on x86 that the IOMMU HW is able to bloc=
k
> the no-snoop bit in the TLP. This NOP's the optimization and allows KVM t=
o
> to NOP the wbinvd without causing any data corruption.
>=20
> This control for Intel IOMMU was exposed by using IOMMU_CACHE and
> IOMMU_CAP_CACHE_COHERENCY, however these two values now have
> multiple
> meanings and usages beyond blocking no-snoop and the whole thing has
> become confused.

Also point out your finding about AMD IOMMU?

>=20
> Change it so that:
>  - IOMMU_CACHE is only about the DMA coherence of normal DMAs from a
>    device. It is used by the DMA API and set when the DMA API will not be
>    doing manual cache coherency operations.
>=20
>  - dev_is_dma_coherent() indicates if IOMMU_CACHE can be used with the
>    device
>=20
>  - The new optional domain op enforce_cache_coherency() will cause the
>    entire domain to block no-snoop requests - ie there is no way for any
>    device attached to the domain to opt out of the IOMMU_CACHE behavior.
>=20
> An iommu driver should implement enforce_cache_coherency() so that by
> default domains allow the no-snoop optimization. This leaves it available
> to kernel drivers like i915. VFIO will call enforce_cache_coherency()
> before establishing any mappings and the domain should then permanently
> block no-snoop.
>=20
> If enforce_cache_coherency() fails VFIO will communicate back through to
> KVM into the arch code via kvm_arch_register_noncoherent_dma()
> (only implemented by x86) which triggers a working wbinvd to be made
> available to the VM.
>=20
> While other arches are certainly welcome to implement
> enforce_cache_coherency(), it is not clear there is any benefit in doing
> so.
>=20
> After this series there are only two calls left to iommu_capable() with a
> bus argument which should help Robin's work here.
>=20
> This is on github:
> https://github.com/jgunthorpe/linux/commits/intel_no_snoop
>=20
> Cc: "Tian, Kevin" <kevin.tian@intel.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Jason Gunthorpe (5):
>   iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY with
>     dev_is_dma_coherent()
>   vfio: Require that devices support DMA cache coherence
>   iommu: Introduce the domain op enforce_cache_coherency()
>   vfio: Move the Intel no-snoop control off of IOMMU_CACHE
>   iommu: Delete IOMMU_CAP_CACHE_COHERENCY
>=20
>  drivers/infiniband/hw/usnic/usnic_uiom.c    | 16 +++++------
>  drivers/iommu/amd/iommu.c                   |  9 +++++--
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  2 --
>  drivers/iommu/arm/arm-smmu/arm-smmu.c       |  6 -----
>  drivers/iommu/arm/arm-smmu/qcom_iommu.c     |  6 -----
>  drivers/iommu/fsl_pamu_domain.c             |  6 -----
>  drivers/iommu/intel/iommu.c                 | 15 ++++++++---
>  drivers/iommu/s390-iommu.c                  |  2 --
>  drivers/vfio/vfio.c                         |  6 +++++
>  drivers/vfio/vfio_iommu_type1.c             | 30 +++++++++++++--------
>  drivers/vhost/vdpa.c                        |  3 ++-
>  include/linux/intel-iommu.h                 |  1 +
>  include/linux/iommu.h                       |  6 +++--
>  13 files changed, 58 insertions(+), 50 deletions(-)
>=20
>=20
> base-commit: 3123109284176b1532874591f7c81f3837bbdc17
> --
> 2.35.1

