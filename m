Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576E946DCD1
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240088AbhLHURu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:17:50 -0500
Received: from mail-eus2azlp17010006.outbound.protection.outlook.com ([40.93.12.6]:17097
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229656AbhLHURt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 15:17:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQI1rJSv2s66La/Ftj5WnvVzN2Y+NcN5f8vh3pSbI6ZGmRFAhwofjlYFzQ7/pw2rHDUPV79r1d4WmPcrkBAZ7O+ICUyWr3eJAqvhI52FHZlUz8dsO0BYj0q4A9GQMu/R7imHBRa/wGcXhW6vtZMvsGaGcrltD4y11M1fmEuktEf3DuukGPPhpzcWxqJvh543PlUv8ccgCLmpJMtxitTnusGXcCF+2jHiynB6OTDnm3ckxJBLs/n1/bTU3KCdvCQvv/dL03SV8HMZBZO/dnz6QGpVhGyOsoTGH7gpRUqFpr22US1xqSPrqfpifK+2+fRgfuKQP54ZdignIoCXzwLW4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/VhqP64SafiZZL4w7hgDIgQDwcfA747uRYFFmCbQUnU=;
 b=Vid26WdTIyzG5+cVeP0LyEV0fvayuAuDakbDKjNgnAbeRemHiNzACUKhsi6H8mCAjw6LwKa2NtnBi4tiCsZETJLry1f+uZ2xlaSSdTqokIOb1kOH4QBVzM4v8kD2zBcyFYIQc8sVTfNWyj3I3hszBiORbHRPhGBDxCmXJaBpuiEmIMFWJG5swfOXmC2rfxXvF0WCANRQrqWzGHJ1MUvsf5Skb7lJ7HBNd1N9XgjVwVDpiL81TVnv2bkP/+e9/blzrzTfCwKloSSIoQZeTPF5XqXjOsxklhiU1E4c0wIy+HalfIdq0F1SyuNAd0l0062ssondOPAK+sxmE1IeFVj8Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/VhqP64SafiZZL4w7hgDIgQDwcfA747uRYFFmCbQUnU=;
 b=Uau3zk606Vgr2r6hiY0COHzLYjhANTuGYQcSk6dRYWPCoHHkb5JI2tfGOD46AlCmJynuoP27jz0x6qATTCXhdnoZL1mnKUoXkpfXoSMiVrqujSSUZQrQwt6NLeFiUoraL21kgbpPBuiqmU+nLvWGayYSJVccmvMOp1BxPXkijao=
Received: from BN8PR21MB1284.namprd21.prod.outlook.com (2603:10b6:408:a2::22)
 by BY5PR21MB1460.namprd21.prod.outlook.com (2603:10b6:a03:21d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.3; Wed, 8 Dec
 2021 20:14:12 +0000
Received: from BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::8425:4248:bce6:df4a]) by BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::8425:4248:bce6:df4a%6]) with mapi id 15.20.4801.006; Wed, 8 Dec 2021
 20:14:12 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>, "joro@8bytes.org" <joro@8bytes.org>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V6 5/5] net: netvsc: Add Isolation VM support for netvsc
 driver
Thread-Topic: [PATCH V6 5/5] net: netvsc: Add Isolation VM support for netvsc
 driver
Thread-Index: AQHX6z/p0yAcVt7N4023h97u6uYex6wpB5Nw
Date:   Wed, 8 Dec 2021 20:14:11 +0000
Message-ID: <BN8PR21MB128401EEDE6B8C8553CC8009CA6F9@BN8PR21MB1284.namprd21.prod.outlook.com>
References: <20211207075602.2452-1-ltykernel@gmail.com>
 <20211207075602.2452-6-ltykernel@gmail.com>
In-Reply-To: <20211207075602.2452-6-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8f2b756c-5454-4ec4-ac2e-44d9b23f1862;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-12-08T20:06:08Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0be39d0-6771-4f98-7b59-08d9ba874cbf
x-ms-traffictypediagnostic: BY5PR21MB1460:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BY5PR21MB1460F07A4B7E8550571ECA8ECA6F9@BY5PR21MB1460.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fqSu7QXECQX+koxZhXW818FUF9Fn45rPw6rGH3VympO9P5mxmVHZnmpqjqkxNyvpvBkGPU448ww1ZCLjtGs1uM6qK2wtOTgS9I0tyyx0XzHfFPCy6NxubkTATc15tqJNT3GioH6Brr9CeTbjnLRYTUNpPrx4YW7eYIjeI4QXg0hfvdc9FwKnl/w4m5BHdbeFnv5qsBlcbDffjXusGsW9+ErBWxSDE2cYdR1cEEZRSLMFPOycs3bRV2YtNULuSLakgA5E7fNVgg1r+T7lJlma1RnLPTvEHrGAQFh4kwGnOE1PskrtCimJZHVmyFdq+duilPCg9pKX4RQ8uTknm85Pz50HoFC7PWU/uH5l/brepuEOL/AeNEh1KoSWgcVCHV+8ZAxImJWDnlHxr+WcQmtdsifSly/ehAq2Cs/MsDIFlqpPRIYPQMCJanDnk9EGbbhkKc/IhrEjeCBedXOUY5IIIUUxSpz49V9wXyvRcQSZxknqUl9IrSLtQp/MxzLroxKv6kOuSEqoV8FSjlRy+cF+Z13ZssLtgZn13AwIta9jA17UIdOX+0v7+djXXyVo/sRywZcjp7ZB7XLL5HuuzE7Mfz9KvkCMaFepNsAiliXXcG4aELwV9DLrWMeF25Q+bzmNkzISqEGx/s6OJeYKc4X/cLYYy/ZBe3nii/utD3Pt8/2Mmn6wdZQIqYZxITroD8XnP/lKDBZM0OJUsOUqrSZHglweia4jdnbrAmuCCMVQiNKAkU60kAta5k8wq1NZdHM5WMb5XaARngATD8eEY/I92g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1284.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(10290500003)(186003)(33656002)(86362001)(508600001)(8990500004)(6636002)(316002)(66946007)(110136005)(8676002)(26005)(9686003)(76116006)(54906003)(55016003)(7406005)(8936002)(7416002)(66446008)(64756008)(38070700005)(5660300002)(30864003)(38100700002)(921005)(82960400001)(6506007)(66476007)(83380400001)(82950400001)(122000001)(71200400001)(53546011)(7696005)(52536014)(66556008)(4326008)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mmqrJsZjly4znRk1m9dDNv+F0EEbJU5df/5gmyYQqPP7FV7I59XfAF09EtUY?=
 =?us-ascii?Q?5camBQy636/L2pbJMTaClPnHSqc40Nu26qhba76RVy58STZspL68aoeFApSH?=
 =?us-ascii?Q?kWrlvA36Qgac+hpjI2uKzlXAZ7vE2rUpR2P3FUg0dtUgpQgLUsk9n4csnBuS?=
 =?us-ascii?Q?Y3BzZlNjgHhV+wzGfLkxud4oZ8KJLfqj32BUNYtBWBXPbTyDqBcWK/MwrCIk?=
 =?us-ascii?Q?skISg7ExUrFBWgjvhJHARX0UGbnY86/iv7aB9wnVACkoSblP9GKb3aHsExSM?=
 =?us-ascii?Q?9e7lovi+r/Q0vAT2HfMNefrV+hHwqpSWgJ2G2Gk0jboofKgaNY7+Lna4QrVW?=
 =?us-ascii?Q?SIYCY3cf4djU4OYedK0lESlgKMtyCrRPf0Umz0AFnq6jcELb0T1u+lExBq+e?=
 =?us-ascii?Q?ihzDppTBsUZVNO//x6/VTmfTndpQy3PnoB0G/OaaCIj6PDGsStU8m0VLVruh?=
 =?us-ascii?Q?BzUp0csG2C0hDr0V1zBI1c4gl/eRJIGga5pyh68qn8TidPHo9UHVqhXtunYJ?=
 =?us-ascii?Q?1Kk1thEjAVCCBsLDo4s5wMMq/Y/TY4NkzVAnDpgavFF0gC4eNIMvAlSjseEA?=
 =?us-ascii?Q?jUkzP3og6rBoWvS2agtGFnCK64ZxMFMKl9H3ElRmqF1ODauFDzcYrPPc33Vn?=
 =?us-ascii?Q?napmcwEqcQYXzkYhMnOLF9T1ncB2xKUBuAiDW/v+oZoH6JkXur3RlUWDu0p/?=
 =?us-ascii?Q?WFz/vKGQM3QjG7y5RFZiEb3ywpg8RWKhAmbqmJmD+nGkgXYffacV0XphYa9O?=
 =?us-ascii?Q?SshCPxxFSjPybb/YFslbCd7OGbLO26grd6uku4orQKXr8O013Ao5lGqT/LJB?=
 =?us-ascii?Q?cuqr1NoKo5FZFl2tgwTI9FE0vlIf8tO3BAtnN8fKw4ikBca91mYB2xNtbNoj?=
 =?us-ascii?Q?xsBsC+m1f+5fTZ4jDFMzVBvN1De3VFnVfExNl6N6LsagqfdIfelptijtusI8?=
 =?us-ascii?Q?fGUsT5D45lzGdpWf0rxzHRXTiy41wWJ53CfPoW98Cnl86DGBXuU+7HzkVJTY?=
 =?us-ascii?Q?eZ7XEjOtF8tZ1aTPNXZzYQufuSlI9b2t3IOckhLdo7Ca+15vUAYQWTxRkOEF?=
 =?us-ascii?Q?9//UKRZgSQFSURs1OQl2aNViNobkoOMmDAaTGcBQ/enow+xNYFRRKg3LtRkI?=
 =?us-ascii?Q?dom9SoItLhvHvF1dEZ8ab26K9fQpEfc3ZkLcoMYsXFNfWg0dBDShFVoH9C2e?=
 =?us-ascii?Q?wdLpfBgNWTrvJTQevkTDpKWZSzFoh5/iESd1yfADtzk75bYOvfu+v+xJBIHw?=
 =?us-ascii?Q?0SuuA/xpae9LuRQB6nc2hf58Sxf8xjNNBHrUz4j8NBHh5hazDt/+q19wsX2N?=
 =?us-ascii?Q?/UTvgFQnsXS+P5xG7yX5dbk7oAqNpWuWHE77Doz7xYRfx486fT4u8FDRp0xN?=
 =?us-ascii?Q?pffqZOaHn20kj+EIhWMJjcfCzGqhBDvxa5mCHAJXXEP2VfPC0SWJ2lGRXgN7?=
 =?us-ascii?Q?qMWWpn4KfiHUM8LBJsuA8+C4PwFBprnX5JVZu69c2FdEnFyQipCsm7FuJk0G?=
 =?us-ascii?Q?Fo7Uqy5QSDOngrH9Ps28fcj1Wl37Z9jzEE/xojH8BhPjK5P+VcOzOL7SlndC?=
 =?us-ascii?Q?vGIg+6LjaHdlA6COIdz5DpMEboYBQVzlwbT1BfVEqaIZtZfgGXxLwzFYLnmI?=
 =?us-ascii?Q?Rw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR21MB1284.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0be39d0-6771-4f98-7b59-08d9ba874cbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2021 20:14:11.8004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wv/WHqpMWa1zcY5Bm/dgS1/NbSABqsXbzgPOTWwVhrYc/NqmP2/h9Hd7THm55DHEnl43eMTEi5AukOERtG72oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1460
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Tianyu Lan <ltykernel@gmail.com>
> Sent: Tuesday, December 7, 2021 2:56 AM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.=
com>; Stephen
> Hemminger <sthemmin@microsoft.com>; wei.liu@kernel.org; Dexuan Cui <decui=
@microsoft.com>;
> tglx@linutronix.de; mingo@redhat.com; bp@alien8.de; dave.hansen@linux.int=
el.com;
> x86@kernel.org; hpa@zytor.com; davem@davemloft.net; kuba@kernel.org; jejb=
@linux.ibm.com;
> martin.petersen@oracle.com; arnd@arndb.de; hch@infradead.org; m.szyprowsk=
i@samsung.com;
> robin.murphy@arm.com; Tianyu Lan <Tianyu.Lan@microsoft.com>; thomas.lenda=
cky@amd.com;
> Michael Kelley (LINUX) <mikelley@microsoft.com>
> Cc: iommu@lists.linux-foundation.org; linux-arch@vger.kernel.org; linux-
> hyperv@vger.kernel.org; linux-kernel@vger.kernel.org; linux-scsi@vger.ker=
nel.org;
> netdev@vger.kernel.org; vkuznets <vkuznets@redhat.com>; brijesh.singh@amd=
.com;
> konrad.wilk@oracle.com; hch@lst.de; joro@8bytes.org; parri.andrea@gmail.c=
om;
> dave.hansen@intel.com
> Subject: [PATCH V6 5/5] net: netvsc: Add Isolation VM support for netvsc =
driver
>=20
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>=20
> In Isolation VM, all shared memory with host needs to mark visible
> to host via hvcall. vmbus_establish_gpadl() has already done it for
> netvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
> pagebuffer() stills need to be handled. Use DMA API to map/umap
> these memory during sending/receiving packet and Hyper-V swiotlb
> bounce buffer dma address will be returned. The swiotlb bounce buffer
> has been masked to be visible to host during boot up.
>=20
> rx/tx ring buffer is allocated via vzalloc() and they need to be
> mapped into unencrypted address space(above vTOM) before sharing
> with host and accessing. Add hv_map/unmap_memory() to map/umap rx
> /tx ring buffer.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v3:
>        * Replace HV_HYP_PAGE_SIZE with PAGE_SIZE and virt_to_hvpfn()
>          with vmalloc_to_pfn() in the hv_map_memory()
>=20
> Change since v2:
>        * Add hv_map/unmap_memory() to map/umap rx/tx ring buffer.
> ---
>  arch/x86/hyperv/ivm.c             |  28 ++++++
>  drivers/hv/hv_common.c            |  11 +++
>  drivers/net/hyperv/hyperv_net.h   |   5 ++
>  drivers/net/hyperv/netvsc.c       | 136 +++++++++++++++++++++++++++++-
>  drivers/net/hyperv/netvsc_drv.c   |   1 +
>  drivers/net/hyperv/rndis_filter.c |   2 +
>  include/asm-generic/mshyperv.h    |   2 +
>  include/linux/hyperv.h            |   5 ++
>  8 files changed, 187 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
> index 69c7a57f3307..2b994117581e 100644
> --- a/arch/x86/hyperv/ivm.c
> +++ b/arch/x86/hyperv/ivm.c
> @@ -287,3 +287,31 @@ int hv_set_mem_host_visibility(unsigned long kbuffer=
, int pagecount,
> bool visibl
>  	kfree(pfn_array);
>  	return ret;
>  }
> +
> +/*
> + * hv_map_memory - map memory to extra space in the AMD SEV-SNP Isolatio=
n VM.
> + */
> +void *hv_map_memory(void *addr, unsigned long size)
> +{
> +	unsigned long *pfns =3D kcalloc(size / PAGE_SIZE,
> +				      sizeof(unsigned long), GFP_KERNEL);
> +	void *vaddr;
> +	int i;
> +
> +	if (!pfns)
> +		return NULL;
> +
> +	for (i =3D 0; i < size / PAGE_SIZE; i++)
> +		pfns[i] =3D vmalloc_to_pfn(addr + i * PAGE_SIZE) +
> +			(ms_hyperv.shared_gpa_boundary >> PAGE_SHIFT);
> +
> +	vaddr =3D vmap_pfn(pfns, size / PAGE_SIZE, PAGE_KERNEL_IO);
> +	kfree(pfns);
> +
> +	return vaddr;
> +}
> +
> +void hv_unmap_memory(void *addr)
> +{
> +	vunmap(addr);
> +}
> diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
> index 7be173a99f27..3c5cb1f70319 100644
> --- a/drivers/hv/hv_common.c
> +++ b/drivers/hv/hv_common.c
> @@ -295,3 +295,14 @@ u64 __weak hv_ghcb_hypercall(u64 control, void *inpu=
t, void *output,
> u32 input_s
>  	return HV_STATUS_INVALID_PARAMETER;
>  }
>  EXPORT_SYMBOL_GPL(hv_ghcb_hypercall);
> +
> +void __weak *hv_map_memory(void *addr, unsigned long size)
> +{
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(hv_map_memory);
> +
> +void __weak hv_unmap_memory(void *addr)
> +{
> +}
> +EXPORT_SYMBOL_GPL(hv_unmap_memory);
> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_=
net.h
> index 315278a7cf88..cf69da0e296c 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -164,6 +164,7 @@ struct hv_netvsc_packet {
>  	u32 total_bytes;
>  	u32 send_buf_index;
>  	u32 total_data_buflen;
> +	struct hv_dma_range *dma_range;
>  };
>=20
>  #define NETVSC_HASH_KEYLEN 40
> @@ -1074,6 +1075,7 @@ struct netvsc_device {
>=20
>  	/* Receive buffer allocated by us but manages by NetVSP */
>  	void *recv_buf;
> +	void *recv_original_buf;
>  	u32 recv_buf_size; /* allocated bytes */
>  	struct vmbus_gpadl recv_buf_gpadl_handle;
>  	u32 recv_section_cnt;
> @@ -1082,6 +1084,7 @@ struct netvsc_device {
>=20
>  	/* Send buffer allocated by us */
>  	void *send_buf;
> +	void *send_original_buf;
>  	u32 send_buf_size;
>  	struct vmbus_gpadl send_buf_gpadl_handle;
>  	u32 send_section_cnt;
> @@ -1731,4 +1734,6 @@ struct rndis_message {
>  #define RETRY_US_HI	10000
>  #define RETRY_MAX	2000	/* >10 sec */
>=20
> +void netvsc_dma_unmap(struct hv_device *hv_dev,
> +		      struct hv_netvsc_packet *packet);
>  #endif /* _HYPERV_NET_H */
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 396bc1c204e6..b7ade735a806 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -153,8 +153,21 @@ static void free_netvsc_device(struct rcu_head *head=
)
>  	int i;
>=20
>  	kfree(nvdev->extension);
> -	vfree(nvdev->recv_buf);
> -	vfree(nvdev->send_buf);
> +
> +	if (nvdev->recv_original_buf) {
> +		hv_unmap_memory(nvdev->recv_buf);
> +		vfree(nvdev->recv_original_buf);
> +	} else {
> +		vfree(nvdev->recv_buf);
> +	}
> +
> +	if (nvdev->send_original_buf) {
> +		hv_unmap_memory(nvdev->send_buf);
> +		vfree(nvdev->send_original_buf);
> +	} else {
> +		vfree(nvdev->send_buf);
> +	}
> +
>  	kfree(nvdev->send_section_map);
>=20
>  	for (i =3D 0; i < VRSS_CHANNEL_MAX; i++) {
> @@ -338,6 +351,7 @@ static int netvsc_init_buf(struct hv_device *device,
>  	unsigned int buf_size;
>  	size_t map_words;
>  	int i, ret =3D 0;
> +	void *vaddr;
>=20
>  	/* Get receive buffer area. */
>  	buf_size =3D device_info->recv_sections * device_info->recv_section_siz=
e;
> @@ -373,6 +387,17 @@ static int netvsc_init_buf(struct hv_device *device,
>  		goto cleanup;
>  	}
>=20
> +	if (hv_isolation_type_snp()) {
> +		vaddr =3D hv_map_memory(net_device->recv_buf, buf_size);
> +		if (!vaddr) {
> +			ret =3D -ENOMEM;
> +			goto cleanup;
> +		}
> +
> +		net_device->recv_original_buf =3D net_device->recv_buf;
> +		net_device->recv_buf =3D vaddr;
> +	}
> +
>  	/* Notify the NetVsp of the gpadl handle */
>  	init_packet =3D &net_device->channel_init_pkt;
>  	memset(init_packet, 0, sizeof(struct nvsp_message));
> @@ -476,6 +501,17 @@ static int netvsc_init_buf(struct hv_device *device,
>  		goto cleanup;
>  	}
>=20
> +	if (hv_isolation_type_snp()) {
> +		vaddr =3D hv_map_memory(net_device->send_buf, buf_size);
> +		if (!vaddr) {
> +			ret =3D -ENOMEM;
> +			goto cleanup;
> +		}
> +
> +		net_device->send_original_buf =3D net_device->send_buf;
> +		net_device->send_buf =3D vaddr;
> +	}
> +
>  	/* Notify the NetVsp of the gpadl handle */
>  	init_packet =3D &net_device->channel_init_pkt;
>  	memset(init_packet, 0, sizeof(struct nvsp_message));
> @@ -766,7 +802,7 @@ static void netvsc_send_tx_complete(struct net_device=
 *ndev,
>=20
>  	/* Notify the layer above us */
>  	if (likely(skb)) {
> -		const struct hv_netvsc_packet *packet
> +		struct hv_netvsc_packet *packet
>  			=3D (struct hv_netvsc_packet *)skb->cb;
>  		u32 send_index =3D packet->send_buf_index;
>  		struct netvsc_stats *tx_stats;
> @@ -782,6 +818,7 @@ static void netvsc_send_tx_complete(struct net_device=
 *ndev,
>  		tx_stats->bytes +=3D packet->total_bytes;
>  		u64_stats_update_end(&tx_stats->syncp);
>=20
> +		netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
>  		napi_consume_skb(skb, budget);
>  	}
>=20
> @@ -946,6 +983,88 @@ static void netvsc_copy_to_send_buf(struct netvsc_de=
vice *net_device,
>  		memset(dest, 0, padding);
>  }
>=20
> +void netvsc_dma_unmap(struct hv_device *hv_dev,
> +		      struct hv_netvsc_packet *packet)
> +{
> +	u32 page_count =3D packet->cp_partial ?
> +		packet->page_buf_cnt - packet->rmsg_pgcnt :
> +		packet->page_buf_cnt;
> +	int i;
> +
> +	if (!hv_is_isolation_supported())
> +		return;
> +
> +	if (!packet->dma_range)
> +		return;
> +
> +	for (i =3D 0; i < page_count; i++)
> +		dma_unmap_single(&hv_dev->device, packet->dma_range[i].dma,
> +				 packet->dma_range[i].mapping_size,
> +				 DMA_TO_DEVICE);
> +
> +	kfree(packet->dma_range);
> +}
> +
> +/* netvsc_dma_map - Map swiotlb bounce buffer with data page of
> + * packet sent by vmbus_sendpacket_pagebuffer() in the Isolation
> + * VM.
> + *
> + * In isolation VM, netvsc send buffer has been marked visible to
> + * host and so the data copied to send buffer doesn't need to use
> + * bounce buffer. The data pages handled by vmbus_sendpacket_pagebuffer(=
)
> + * may not be copied to send buffer and so these pages need to be
> + * mapped with swiotlb bounce buffer. netvsc_dma_map() is to do
> + * that. The pfns in the struct hv_page_buffer need to be converted
> + * to bounce buffer's pfn. The loop here is necessary because the
> + * entries in the page buffer array are not necessarily full
> + * pages of data.  Each entry in the array has a separate offset and
> + * len that may be non-zero, even for entries in the middle of the
> + * array.  And the entries are not physically contiguous.  So each
> + * entry must be individually mapped rather than as a contiguous unit.
> + * So not use dma_map_sg() here.
> + */
> +int netvsc_dma_map(struct hv_device *hv_dev,
> +		   struct hv_netvsc_packet *packet,
> +		   struct hv_page_buffer *pb)
> +{
> +	u32 page_count =3D  packet->cp_partial ?
> +		packet->page_buf_cnt - packet->rmsg_pgcnt :
> +		packet->page_buf_cnt;
> +	dma_addr_t dma;
> +	int i;
> +
> +	if (!hv_is_isolation_supported())
> +		return 0;
> +
> +	packet->dma_range =3D kcalloc(page_count,
> +				    sizeof(*packet->dma_range),
> +				    GFP_KERNEL);
> +	if (!packet->dma_range)
> +		return -ENOMEM;
> +
> +	for (i =3D 0; i < page_count; i++) {
> +		char *src =3D phys_to_virt((pb[i].pfn << HV_HYP_PAGE_SHIFT)
> +					 + pb[i].offset);
> +		u32 len =3D pb[i].len;
> +
> +		dma =3D dma_map_single(&hv_dev->device, src, len,
> +				     DMA_TO_DEVICE);
> +		if (dma_mapping_error(&hv_dev->device, dma)) {
> +			kfree(packet->dma_range);
> +			return -ENOMEM;
> +		}
> +
> +		/* pb[].offset and pb[].len are not changed during dma mapping
> +		 * and so not reassign.
> +		 */
> +		packet->dma_range[i].dma =3D dma;
> +		packet->dma_range[i].mapping_size =3D len;
> +		pb[i].pfn =3D dma >> HV_HYP_PAGE_SHIFT;
> +	}
> +
> +	return 0;
> +}
> +
>  static inline int netvsc_send_pkt(
>  	struct hv_device *device,
>  	struct hv_netvsc_packet *packet,
> @@ -986,14 +1105,24 @@ static inline int netvsc_send_pkt(
>=20
>  	trace_nvsp_send_pkt(ndev, out_channel, rpkt);
>=20
> +	packet->dma_range =3D NULL;
>  	if (packet->page_buf_cnt) {
>  		if (packet->cp_partial)
>  			pb +=3D packet->rmsg_pgcnt;
>=20
> +		ret =3D netvsc_dma_map(ndev_ctx->device_ctx, packet, pb);
> +		if (ret) {
> +			ret =3D -EAGAIN;
> +			goto exit;
> +		}

Returning EAGAIN will let the upper network layer busy retry,=20
which may make things worse.
I suggest to return ENOSPC here like another place in this=20
function, which will just drop the packet, and let the network=20
protocol/app layer decide how to recover.

Thanks,
- Haiyang
