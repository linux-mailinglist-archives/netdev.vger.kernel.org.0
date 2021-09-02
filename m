Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8BB3FE71F
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 03:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhIBB2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 21:28:30 -0400
Received: from mail-oln040093008007.outbound.protection.outlook.com ([40.93.8.7]:60314
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229606AbhIBB23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 21:28:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqH6zbdXDocj/kohzFNuFSZBk5b/2UyJU4cNNkSedGUI/Bt9AxktZr3L9inKZ89BLNZWRm8pjRFCVSdZmWh/D7zCDBnsK08tTqyTw8xnPM9T8qD795zce97qnANfvL4DnnQWxwCb2N4JEwDw0UEvFAm8otRci6Tysb/aS5cHwHhOfjMh3cXZAj1eIBlay6EwhFekB2EYr8FJCDpHO5MVGXV2/2iIorc6FfGOf9YZax4NWdmFeVRYUsLHy0SiExMp8GxVdCILOrEVCk4FOUhnoaVD2FX2c9FWXysJSUXRZcQi06bPgUZu/8NUdXzsATcF5LAx2D2WuDHfJe7lhyKDHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BZ2kwHMnelplbCchdbwZ+ia6PwO7lsSSD7ssrmF5dHQ=;
 b=dp8QKS4leVE/cV8OgvsZK9JLaqJ7eGztPQq3Qf2qrspWwGLK2Ys0PMv8qGHsPkGBKmaiFNJTmyJ27T6w1rxsJvMl9L83mH/xVWiVI8vUNkIC7JexfSgzx8/Vfl2ISUmJltmBEjp7JSzWVHyZxHuNBprA5P5NHl3VMYE1zmE6ACs3LpDfNWq1FUjoNp6/EIAsZsvm/505P1UXIw2TKXH/GyQnyK8OB/FF5og9GMqmW87u5UvwctGCN7/F/sadvMj454yKssyDGfjXlwLOtm3AX9vao2CUITlniy2ov2giGs+dfJfYtvU2SyznIOQjF1qqwxTb1HWM5AvGNsY4v6VoPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZ2kwHMnelplbCchdbwZ+ia6PwO7lsSSD7ssrmF5dHQ=;
 b=YHOFezUF1yqpjllueuzWf+I0rHCtn83zrPTxn6ZddbZkFWosRcY7pGRkctpTaFd5I318INsrp+RQMmpsEpNjrO1bXE1mmqkIZDv0nFyFWs2LtR75VcpuZZTLMsJP0SuJTo3dkxZyNT5Z8InyQJ1QrId29JvNHTHxv7r7b4eyu1A=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0767.namprd21.prod.outlook.com (2603:10b6:300:76::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.0; Thu, 2 Sep
 2021 01:27:14 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86%8]) with mapi id 15.20.4478.014; Thu, 2 Sep 2021
 01:27:14 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "ardb@kernel.org" <ardb@kernel.org>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V4 11/13] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Thread-Topic: [PATCH V4 11/13] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Thread-Index: AQHXm2gQQ4+yOBIZA0OE+jNjJUIyPauJR4sw
Date:   Thu, 2 Sep 2021 01:27:14 +0000
Message-ID: <MWHPR21MB159386DFD2EA14A585288C0FD7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210827172114.414281-12-ltykernel@gmail.com>
In-Reply-To: <20210827172114.414281-12-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=38142b78-d6f5-49b9-b305-836e5d853fb5;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-28T19:01:59Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b34df77-4512-4c58-304d-08d96db0cbb2
x-ms-traffictypediagnostic: MWHPR21MB0767:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB0767F12FD371AC9DD10BFF9CD7CE9@MWHPR21MB0767.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:50;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dNq0v0YJw7pRWijNhH6+mIFGGl3G+Qy79F9GPxBTEW6zvQTzNqClqowJIrhXZYp9GMtvZLsJp+tfuP2Tq9Qzulp93q84HKxOehoOdf6j5szdLfh8p6NKk4iBe0baCWKjhzr/XVFCpi2tzdKK7mhtiQXQdsKXcc+fAKRo/nIVdw1dBzrRoiMOsLwHrPNJl33LKNf/mTN2SCqHWsKWNnKgs70cJ27xsUSSU9jgWcxgraVidVFIrG+lJL0jVO7cL+tGq8qLvO0/E2f2dApLKfSVWxpmBzjXhM9KrqBRioxe2hXhZApwWIpsjYaGp37/uQZjdvb3HrwX4crtF5ITsReC2o5kK3wwjo37h/aJLeedmXT1rVes9TIc8Y6cUWGdejCHMoGfNYeisGNCby/L7jGOxFU4CXJgRRgKt+VRvayQwPh+fP+FsOEj9loTggZaNzdFNxYYj+QASN+y6ba9wth9UbMhI82frDFbwjruTQ1KnVrA7wIBMd4ZkpbfdkqkRbGIRGW11qQrY6a06A9mA4mnbSP/WIOH/9adlHFdVVA6F5WfiQWe7hUqMuqYC8DXeSz120oAzCMrDApGxQ5zZQ8MGTdwIfibzSrUc4ysz7CPc2G9TBXSbhSG+R2Aqxkuh7PuwyMx2hx3fuLZ2svCeqDC6n1ovPoJYs3UQU37UGg0XjVuR/ltirl+LZk8Sm+t5QRDajCrPxWnjESMJSZ46C9Cil2Ckv2R+mNO5DdNtc7RKUA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7366002)(71200400001)(83380400001)(66476007)(66946007)(82950400001)(7416002)(316002)(38100700002)(7406005)(86362001)(9686003)(76116006)(921005)(66446008)(4326008)(64756008)(33656002)(10290500003)(2906002)(508600001)(186003)(7696005)(6506007)(55016002)(38070700005)(82960400001)(8676002)(122000001)(8936002)(52536014)(8990500004)(54906003)(26005)(5660300002)(110136005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?49jzUXvgf7ZLIZvLg6Q1/1eUHzzwc3TfIDOhgzDpWNqfBbBgjatdlOGSnacX?=
 =?us-ascii?Q?ENqJRp+Z0muZsNhTVYljQwAe/VGj2sStR4WnwzZc79blYZvjVMk+GG0MweJe?=
 =?us-ascii?Q?2JqqGqlvmjOnf4EXWk+S1brb/7E1P9hA5Oiawk0Zfw+v4bTMJIi/V6FXez2D?=
 =?us-ascii?Q?ci8LPNuzdPxLnUkIwX/5AfMsb+4g5Tm33b7LPpZMtiLGrhDTlCH9hRF6dz28?=
 =?us-ascii?Q?XQ+9iLPB0lid5Rd+ouoAatq4QEGqryt/JqQrDB64Arr+YXHMpGTYN5K81L9Y?=
 =?us-ascii?Q?wJF628NgGQSRV9cgx64AmqJ4pdV7onoO9aT3xMzSZ7uuxdkjtNm7cFyuKz7d?=
 =?us-ascii?Q?JdP4kC1d33iP9/Fy/9xiKq9fxhkEgySgN2uEJcwA62mHZoShL5HfMPw17oL1?=
 =?us-ascii?Q?2o5NLnScTG89+ja+xQQIH9+ZFXAmtNDxDLjQXexz4s3d7oZHGsRHDpkor/3z?=
 =?us-ascii?Q?Xz7K1yGKF1+d3geiaFVInqOs1B1PRX/ISoy66V8EJG83zv/tng4lN62g0VU6?=
 =?us-ascii?Q?EHFWVPQwulkliliYaj83EyaMBfE0tKy6lSA9i/e7aqiK/GVz+KdwRe/GM83C?=
 =?us-ascii?Q?3IqSpRfKdZHHrQfXW0b9Tz9m5791BaKicfzQLqopfkn+Bm9fAzOyLsDYPId/?=
 =?us-ascii?Q?rRPI/mORNTvsSZ43cQThwfR//IzO27dIfeRi4EqtEd4TmpkdxE6hNj7xIF2E?=
 =?us-ascii?Q?DY0hfGunCRPEpkvCxRGUVvRHxkzQ7Xi7lCTVYFCNkZRLEyPnk2DfzTfphJ5v?=
 =?us-ascii?Q?f1FhT8/5vTYzmdsBX7mDQuxMQb1pNuSND18uQ6wVzHML9exonLJWPKldospq?=
 =?us-ascii?Q?PfKItemm+7ZwQVg+Dfn+jlBmMuB0uiaFKZXWzB3xyMvwvy2H0gE5wETBA7pM?=
 =?us-ascii?Q?pYlH/htXd34h/GFdDYo8TqMI5lbfI1zQ7Xmpa01bOMRzT3yr7TvvLFx3ozXT?=
 =?us-ascii?Q?59AoBSq0rNeJfOXXJmMBTJHZbtZVg2lw9u0S788POdPmqLonKm/LA64/QtiU?=
 =?us-ascii?Q?nYnglQMC4AF/hH8P9+CyOOFokvkJeUrKsyyF7Hy9Wgy5QC1rSCS0xM7hOTLf?=
 =?us-ascii?Q?EF+5WVbpx6UKzzsgThY0B/RSWIk5wXoSLEr/aDXhWAhyPVUznQqaLoI1o7tg?=
 =?us-ascii?Q?DxYNRg48YTnP7nuF8p2UheDY/7jtOJGIz+cBnGn0brq9gya+pKXcNZU6fusb?=
 =?us-ascii?Q?lQghAss56HBsmXFDmJQVOp/5XUoBjjMle/4yh6rwurNoEWHZOaAGPgx9l3UA?=
 =?us-ascii?Q?ODSn8cZc52xyUtnnI4yHzECBTay9uqWw5IVAdqEZuTZHLr7+fX3XTOArA0q7?=
 =?us-ascii?Q?YItS/HFI811TBI46JLo079y1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b34df77-4512-4c58-304d-08d96db0cbb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 01:27:14.5072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2KGO2qEIsLkOxALKzCEuY2PwU2DdLRgZF+IJZLEV/P7dB4OctEWxjII6iy63CCsAmyNnusPkM8cmgSdfqC69NrrNVbuVYcoMq/KOXZBRD5g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0767
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Friday, August 27, 2021 10:21 =
AM
>=20
> hyperv Isolation VM requires bounce buffer support to copy
> data from/to encrypted memory and so enable swiotlb force
> mode to use swiotlb bounce buffer for DMA transaction.
>=20
> In Isolation VM with AMD SEV, the bounce buffer needs to be
> accessed via extra address space which is above shared_gpa_boundary
> (E.G 39 bit address line) reported by Hyper-V CPUID ISOLATION_CONFIG.
> The access physical address will be original physical address +
> shared_gpa_boundary. The shared_gpa_boundary in the AMD SEV SNP
> spec is called virtual top of memory(vTOM). Memory addresses below
> vTOM are automatically treated as private while memory above
> vTOM is treated as shared.
>=20
> Swiotlb bounce buffer code calls dma_map_decrypted()
> to mark bounce buffer visible to host and map it in extra
> address space. Populate dma memory decrypted ops with hv
> map/unmap function.
>=20
> Hyper-V initalizes swiotlb bounce buffer and default swiotlb
> needs to be disabled. pci_swiotlb_detect_override() and
> pci_swiotlb_detect_4gb() enable the default one. To override
> the setting, hyperv_swiotlb_detect() needs to run before
> these detect functions which depends on the pci_xen_swiotlb_
> init(). Make pci_xen_swiotlb_init() depends on the hyperv_swiotlb
> _detect() to keep the order.
>=20
> The map function vmap_pfn() can't work in the early place
> hyperv_iommu_swiotlb_init() and so initialize swiotlb bounce
> buffer in the hyperv_iommu_swiotlb_later_init().
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v3:
>        * Get hyperv bounce bufffer size via default swiotlb
>        bounce buffer size function and keep default size as
>        same as the one in the AMD SEV VM.
> ---
>  arch/x86/hyperv/ivm.c           | 28 +++++++++++++++
>  arch/x86/include/asm/mshyperv.h |  2 ++
>  arch/x86/mm/mem_encrypt.c       |  3 +-
>  arch/x86/xen/pci-swiotlb-xen.c  |  3 +-
>  drivers/hv/vmbus_drv.c          |  3 ++
>  drivers/iommu/hyperv-iommu.c    | 61 +++++++++++++++++++++++++++++++++
>  include/linux/hyperv.h          |  1 +
>  7 files changed, 99 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
> index e761c67e2218..84563b3c9f3a 100644
> --- a/arch/x86/hyperv/ivm.c
> +++ b/arch/x86/hyperv/ivm.c
> @@ -294,3 +294,31 @@ int hv_set_mem_host_visibility(unsigned long addr, i=
nt numpages, bool visible)
>=20
>  	return __hv_set_mem_host_visibility((void *)addr, numpages, visibility)=
;
>  }
> +
> +/*
> + * hv_map_memory - map memory to extra space in the AMD SEV-SNP Isolatio=
n VM.
> + */
> +void *hv_map_memory(void *addr, unsigned long size)
> +{
> +	unsigned long *pfns =3D kcalloc(size / HV_HYP_PAGE_SIZE,
> +				      sizeof(unsigned long), GFP_KERNEL);

Should be PAGE_SIZE, not HV_HYP_PAGE_SIZE, since this code
only manipulates guest page tables.  There's no communication with
Hyper-V that requires HV_HYP_PAGE_SIZE.

> +	void *vaddr;
> +	int i;
> +
> +	if (!pfns)
> +		return NULL;
> +
> +	for (i =3D 0; i < size / PAGE_SIZE; i++)
> +		pfns[i] =3D virt_to_hvpfn(addr + i * PAGE_SIZE) +

Use virt_to_pfn(), not virt_to_hvpfn(), for the same reason.

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
> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyp=
erv.h
> index b77f4caee3ee..627fcf8d443c 100644
> --- a/arch/x86/include/asm/mshyperv.h
> +++ b/arch/x86/include/asm/mshyperv.h
> @@ -252,6 +252,8 @@ int hv_unmap_ioapic_interrupt(int ioapic_id, struct h=
v_interrupt_entry *entry);
>  int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
>  			   enum hv_mem_host_visibility visibility);
>  int hv_set_mem_host_visibility(unsigned long addr, int numpages, bool vi=
sible);
> +void *hv_map_memory(void *addr, unsigned long size);
> +void hv_unmap_memory(void *addr);
>  void hv_sint_wrmsrl_ghcb(u64 msr, u64 value);
>  void hv_sint_rdmsrl_ghcb(u64 msr, u64 *value);
>  void hv_signal_eom_ghcb(void);
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index ff08dc463634..e2db0b8ed938 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -30,6 +30,7 @@
>  #include <asm/processor-flags.h>
>  #include <asm/msr.h>
>  #include <asm/cmdline.h>
> +#include <asm/mshyperv.h>
>=20
>  #include "mm_internal.h"
>=20
> @@ -202,7 +203,7 @@ void __init sev_setup_arch(void)
>  	phys_addr_t total_mem =3D memblock_phys_mem_size();
>  	unsigned long size;
>=20
> -	if (!sev_active())
> +	if (!sev_active() && !hv_is_isolation_supported())
>  		return;
>=20
>  	/*
> diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xe=
n.c
> index 54f9aa7e8457..43bd031aa332 100644
> --- a/arch/x86/xen/pci-swiotlb-xen.c
> +++ b/arch/x86/xen/pci-swiotlb-xen.c
> @@ -4,6 +4,7 @@
>=20
>  #include <linux/dma-map-ops.h>
>  #include <linux/pci.h>
> +#include <linux/hyperv.h>
>  #include <xen/swiotlb-xen.h>
>=20
>  #include <asm/xen/hypervisor.h>
> @@ -91,6 +92,6 @@ int pci_xen_swiotlb_init_late(void)
>  EXPORT_SYMBOL_GPL(pci_xen_swiotlb_init_late);
>=20
>  IOMMU_INIT_FINISH(pci_xen_swiotlb_detect,
> -		  NULL,
> +		  hyperv_swiotlb_detect,
>  		  pci_xen_swiotlb_init,
>  		  NULL);
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 57bbbaa4e8f7..f068e22a5636 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -23,6 +23,7 @@
>  #include <linux/cpu.h>
>  #include <linux/sched/task_stack.h>
>=20
> +#include <linux/dma-map-ops.h>
>  #include <linux/delay.h>
>  #include <linux/notifier.h>
>  #include <linux/panic_notifier.h>
> @@ -2081,6 +2082,7 @@ struct hv_device *vmbus_device_create(const guid_t =
*type,
>  	return child_device_obj;
>  }
>=20
> +static u64 vmbus_dma_mask =3D DMA_BIT_MASK(64);
>  /*
>   * vmbus_device_register - Register the child device
>   */
> @@ -2121,6 +2123,7 @@ int vmbus_device_register(struct hv_device *child_d=
evice_obj)
>  	}
>  	hv_debug_add_dev_dir(child_device_obj);
>=20
> +	child_device_obj->device.dma_mask =3D &vmbus_dma_mask;
>  	return 0;
>=20
>  err_kset_unregister:
> diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
> index e285a220c913..899563551574 100644
> --- a/drivers/iommu/hyperv-iommu.c
> +++ b/drivers/iommu/hyperv-iommu.c
> @@ -13,14 +13,22 @@
>  #include <linux/irq.h>
>  #include <linux/iommu.h>
>  #include <linux/module.h>
> +#include <linux/hyperv.h>
> +#include <linux/io.h>
>=20
>  #include <asm/apic.h>
>  #include <asm/cpu.h>
>  #include <asm/hw_irq.h>
>  #include <asm/io_apic.h>
> +#include <asm/iommu.h>
> +#include <asm/iommu_table.h>
>  #include <asm/irq_remapping.h>
>  #include <asm/hypervisor.h>
>  #include <asm/mshyperv.h>
> +#include <asm/swiotlb.h>
> +#include <linux/dma-map-ops.h>
> +#include <linux/dma-direct.h>
> +#include <linux/set_memory.h>
>=20
>  #include "irq_remapping.h"
>=20
> @@ -36,6 +44,9 @@
>  static cpumask_t ioapic_max_cpumask =3D { CPU_BITS_NONE };
>  static struct irq_domain *ioapic_ir_domain;
>=20
> +static unsigned long hyperv_io_tlb_size;
> +static void *hyperv_io_tlb_start;
> +
>  static int hyperv_ir_set_affinity(struct irq_data *data,
>  		const struct cpumask *mask, bool force)
>  {
> @@ -337,4 +348,54 @@ static const struct irq_domain_ops hyperv_root_ir_do=
main_ops =3D {
>  	.free =3D hyperv_root_irq_remapping_free,
>  };
>=20
> +void __init hyperv_iommu_swiotlb_init(void)
> +{
> +	/*
> +	 * Allocate Hyper-V swiotlb bounce buffer at early place
> +	 * to reserve large contiguous memory.
> +	 */
> +	hyperv_io_tlb_size =3D swiotlb_size_or_default();
> +	hyperv_io_tlb_start =3D memblock_alloc(
> +		hyperv_io_tlb_size, HV_HYP_PAGE_SIZE);

Could the alignment be specified as just PAGE_SIZE?  I don't
see any particular relationship here to the Hyper-V page size.

> +
> +	if (!hyperv_io_tlb_start) {
> +		pr_warn("Fail to allocate Hyper-V swiotlb buffer.\n");
> +		return;
> +	}
> +}
> +
> +int __init hyperv_swiotlb_detect(void)
> +{
> +	if (hypervisor_is_type(X86_HYPER_MS_HYPERV)
> +	    && hv_is_isolation_supported()) {
> +		/*
> +		 * Enable swiotlb force mode in Isolation VM to
> +		 * use swiotlb bounce buffer for dma transaction.
> +		 */
> +		swiotlb_force =3D SWIOTLB_FORCE;
> +
> +		dma_memory_generic_decrypted_ops.map =3D hv_map_memory;
> +		dma_memory_generic_decrypted_ops.unmap =3D hv_unmap_memory;
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +void __init hyperv_iommu_swiotlb_later_init(void)
> +{
> +	/*
> +	 * Swiotlb bounce buffer needs to be mapped in extra address
> +	 * space. Map function doesn't work in the early place and so
> +	 * call swiotlb_late_init_with_tbl() here.
> +	 */
> +	if (swiotlb_late_init_with_tbl(hyperv_io_tlb_start,
> +				       hyperv_io_tlb_size >> IO_TLB_SHIFT))
> +		panic("Fail to initialize hyperv swiotlb.\n");
> +}
> +
> +IOMMU_INIT_FINISH(hyperv_swiotlb_detect,
> +		  NULL, hyperv_iommu_swiotlb_init,
> +		  hyperv_iommu_swiotlb_later_init);
> +
>  #endif
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 757e09606fd3..724a735d722a 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1739,6 +1739,7 @@ int hyperv_write_cfg_blk(struct pci_dev *dev, void =
*buf, unsigned int len,
>  int hyperv_reg_block_invalidate(struct pci_dev *dev, void *context,
>  				void (*block_invalidate)(void *context,
>  							 u64 block_mask));
> +int __init hyperv_swiotlb_detect(void);
>=20
>  struct hyperv_pci_block_ops {
>  	int (*read_block)(struct pci_dev *dev, void *buf, unsigned int buf_len,
> --
> 2.25.1

