Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73294467DF7
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 20:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353493AbhLCTVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 14:21:18 -0500
Received: from mail-cusazlp17010005.outbound.protection.outlook.com ([40.93.13.5]:11593
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235267AbhLCTVS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 14:21:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jlKkrXUDcjSaNNJAmPpDb3GnG4BvTfHy7JIcGJ25CIsnqiPnj9B2WpEoec91L8M1tmuTxzFRrGvRF1qRfjO/OP5i8KjpOSvHmbqIBBNSa2l3Q794Z6gY3/9o3oizsYa7eu/2VpLShpxEk1r/dzqz8dRQoNqTClgg9Q4n+1aIV/lT3e+c2PZhbc0cJqhhBw7ogFRiTs9lqYKpmadq+EZDcN3OkmJiAOpZRIjcRwQtAMEQKyX67lMASghe2aR48ukHI7TauoHTPJKwXCIR/5RQUBzSu7wYLZR5I898X5AdMxj54eoVVyl40aE/7txCkeoA8c77dW8JhO16XxB/RciWqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6QKFdHkFnmZT/268ovAJY1KqmJi2qAxqEcFjgnH4g64=;
 b=JnPxzOiHuefFYRrAZ9sUvaEgfLdkslk0r1Dk0X74KmObG4JajOPTTFzTQbuwseQ9fecaM3yV7dB4ru0VvUdUgpQxcxt++G16wXsu2kRZMEdCCP74DTS0SqD3sJUhzU6QFmqMbFnDGuh5c4DRb+WQltU2qTLlfOXIQ361HlDV+ksF/2AF43walPj66pmyvGX5bWORlsYFAlJg9VhXapWG8zTpWF3NagmwKWzPi/TqrrNxw3WaDu24C3UKmSqB1bxoblP/zKO3YyvpgfsJN/21r4JGHZpMnjjIosJBeEdJmzq8o4g+GpSqfZ4IVFPUOFH+OHnioZ1Us7h1elMzOeDuWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QKFdHkFnmZT/268ovAJY1KqmJi2qAxqEcFjgnH4g64=;
 b=F4f5y9mW5sziN9S049BCwGy644n4tQfdiDac8kcj2CaJTB4JHGdjVrqlZP4O9lQIeCuHyByjnA36lcVBg9Q5ItpBs7/z5D12gQDEwp3IBmnA+m8s6Z7kxw2+2S0o7B5sEFc5oy/w3i6uUitVjWKvBNSevbRXURUz+C0XA0bc2OE=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by CO1PR21MB1299.namprd21.prod.outlook.com (2603:10b6:303:162::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.8; Fri, 3 Dec
 2021 19:17:43 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::40d7:92be:b38f:a9cd]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::40d7:92be:b38f:a9cd%3]) with mapi id 15.20.4778.007; Fri, 3 Dec 2021
 19:17:43 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
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
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V3 3/5] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Thread-Topic: [PATCH V3 3/5] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Thread-Index: AQHX5sz0da2bpS4G3kSooomr0KO256whJnrA
Date:   Fri, 3 Dec 2021 19:17:43 +0000
Message-ID: <MWHPR21MB159390BE1B546A6F90FB1F18D76A9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20211201160257.1003912-1-ltykernel@gmail.com>
 <20211201160257.1003912-4-ltykernel@gmail.com>
In-Reply-To: <20211201160257.1003912-4-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8dd46aee-85bd-466d-b3ba-54bde5af1115;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-12-03T19:14:48Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5251b19c-f02a-416f-2cf4-08d9b6919537
x-ms-traffictypediagnostic: CO1PR21MB1299:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CO1PR21MB129956038B1237CE51CE9D01D76A9@CO1PR21MB1299.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:287;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qssSGgFrOaU2Eb0f+jm0raF00qJOlEhq+s2N0a/GMEn8KAhYprTvxQ1Q0qqmkdtpLgmI7LOE2EkqYo/8SvOXZ5qWNbQYXn6gqN+QWMmz/ng707O+PvuwhklHXXmkwYqGP+HiDCrI2LWjvjbUbeu9o5abs+eycew6AJsjtFq2+fQqNdqHoe6GXPKFyxYtvIn58nqcYQiNLc4qNiDn3bhnurSzP9f/YMjHFGvNgDZ7VZv11XG1MDpH3AM0cKZPqyKMDoWhaL0V2AoX/lh0tBk9MOGG/+xY5rkOidd/HbAyz4jlL7tElcFiCuxVYU+LC2FnjnMi7qLnHrwKsOR7Q+v+qwFwb+U/3frqJgoumJCFIhsGRIxHFp2So5t+dlchh7fX8HM3P9coVd61B2Dwl6ML0UDAg+J6eJ06IdTntrndEbT6uyICVYbBrx/3RPgJ+B/KLBzTEa62crE97ioPbdysJ+kpk0hzWrYeOmlaHSfuyo80tuhjEVJQlagmVM7xNGcaItU05oIQL30BiBr8yUUQmgahER9ILYxL+i2tDz3EERL3TliQzHLI+ahYp643y+uytrG/GvL7E1GDLfNXHCVfo7dPrJ8ocgt9vOeNA5/Of4j9X6YvURck+tCoxXzcFMiFpKbB/7sLoyVT9Gnvp+f9YtKGfWBTKWnEAytOvXwKVV4B9b0OD4pN7LRBcp9C4yh/84w/AeYXDqISCpJVJ5J9S1lcpTrq8ulB70mIHSnqgH35kii0lMXY+aM4QpGIR9jPJe0K/NPtdQlsbeeVV+qEew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(8936002)(7406005)(921005)(508600001)(66446008)(4326008)(5660300002)(7416002)(8676002)(2906002)(6506007)(186003)(38070700005)(71200400001)(7696005)(26005)(54906003)(66476007)(33656002)(66946007)(82950400001)(66556008)(316002)(82960400001)(8990500004)(38100700002)(55016003)(86362001)(64756008)(122000001)(52536014)(9686003)(10290500003)(110136005)(76116006)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jBeCuWxzy9lXQ1RGnkwZuvWLCe0xsZmEQsPvNgGdjFdd7qTKknJgagkEtoE7?=
 =?us-ascii?Q?sLk14MZO3Ptt3Np0cVK3pZXWUiOlbNyXFaMz8ywvMmqM7AQyDZEaQU8gAZlT?=
 =?us-ascii?Q?nSKnWwPr3tMAie5RPq3SgmJiKcwNho+qJwIZXS53FupmBckz0bEBY5KsMGTP?=
 =?us-ascii?Q?lDZhi/huUEOGuFPEk5kBHyHoHz6O8kd63tF+7CAW6AANKxxlghAQ3UoAInga?=
 =?us-ascii?Q?g25nnfeGkdYJX37Hcr/IRlPFLEjLBORrvFK63jh2c0XUNQtjZZhZDRFKir+X?=
 =?us-ascii?Q?7qIK3SWD45omT0AA4hI7/yxPP9SI6lXwG/BYcv6PX3Gk8HQmZ/tdR2cIG/wP?=
 =?us-ascii?Q?iBNDoM+3fCDPSMEUAD72RcdSlWcXPrxqAfVKSJ7Ah9yj8iFXS0uW/DIRHqDQ?=
 =?us-ascii?Q?rnGh182oDyYmJ4ozxT0r5IJF6ldVo+JEbXaKL4cbnOmdGdPcawjr5fHJn7E4?=
 =?us-ascii?Q?RU7V5tbrv7qHS2A1JoM8H3OEKF6iUl58mSaO/AV0J48FxCcRBSVQ+PCmPkVb?=
 =?us-ascii?Q?gkViz2dezigg9kpGMBZXMKoWMw7fdaQc4Ae0dwGdYBsrlZrRCIEA23V8jZWM?=
 =?us-ascii?Q?ri25h3bBgDjPh4RsKqXUqNC/DGvXPfgwX2dw9DXnAC/XLXY9l4JlAbhuNgIe?=
 =?us-ascii?Q?ExKhW218kg7HKuPMYpXvLfloHG6du+Fb8SQi8XNdmO0mZDnhn0XPo49Te5Kb?=
 =?us-ascii?Q?4PyM8XJRwd6T5LYKD5HqNgOu1Bs+2RXWIdDCGZminvxeNKilu2PP40hZEPtN?=
 =?us-ascii?Q?g2vsTXLp1bOtcLdU9iqO060yqntt8Tjz5nrOcHSBFkpnn0sLX9GSWUbNhgkC?=
 =?us-ascii?Q?ra2MVc4j8Fp2sN6siO9/tz1luMtRRL3evw8Tq8jvcSo1iy0RtsRMb43PQCSW?=
 =?us-ascii?Q?MhIOTkzLYK/hEkLr8kqf6XMoBXzI2imYrq+lgRLtFIlQ/X8PKUuWOGfWuPkI?=
 =?us-ascii?Q?+7TnG5ZQ+O6IWo+NAaadJjKSNK+IVj5pHTaUjyh++lkMzKC4tT7OmVmxDYJ3?=
 =?us-ascii?Q?RmjvnQ59+JUrE0GovOtk5+eXaTqex4Ku94348VjRA6+yEzt0iKoEI01jhOjD?=
 =?us-ascii?Q?F/VuTos6AN5tDxim3qQ0q0tsqZKZz3W8aVHgdazhI78EoQnWRAi+jJZzh3+q?=
 =?us-ascii?Q?3uXQgzqIayA1hZsLFN6kDUqzqzNsbi4rOuJVYYdMfCt0G7xqJvNE7FkHqF5X?=
 =?us-ascii?Q?S/QzDoMu2R7JIdzDqnEL6E4+N1rY7g/8WoCFimDtV/QHVHkV31nPN6P8NTwu?=
 =?us-ascii?Q?6oa8Ea+dwgv9OAYiAMhV8L11HsA+3cqKxcQJdrEX77hsujebIwk/17lspS4L?=
 =?us-ascii?Q?Fo5xGMPaBhopYAJmUleikiEfP51nuQuDgdLDnCXRxTg8z9KGvGic7gImEFCv?=
 =?us-ascii?Q?y5oSA1G3KjjSxWBWZPYk6NeBCcgo9HZu95Lh8c3u7QztqyXcvoLtxyEOtVBG?=
 =?us-ascii?Q?iuE36Q0iu7AYgd+g0n02wj6bDn7klluBiKL+2MwqcB0iwfVduxYtvb/kJHP4?=
 =?us-ascii?Q?Zue0N/21HfGiNe/sx4kgGiVyn8RSfDlAlfEat+HB1jQ4JcxRhK+uqW7bpvZM?=
 =?us-ascii?Q?Z3Q5JFGpJa7sYJQDay9GIbxtmX2cWoQGRZzLeMShag9fL64bCpkHz5fXRjiC?=
 =?us-ascii?Q?wJNI4H7xdLvv4OyT5IEhzDFFqzjmwUSudZTT+fTigq4eenix64m0EzMbZZlW?=
 =?us-ascii?Q?n3Uaug=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5251b19c-f02a-416f-2cf4-08d9b6919537
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2021 19:17:43.7670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gfd7gGbGDucndglGUVBEZe+9MhoIEPbgrtNFc5E50IBzPbi/E3o+H9w/csb+P3jKFZNhFVm3CidK/R8ICH5tF40HXiW+F6TCfi2K8gxo1kc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR21MB1299
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Wednesday, December 1, 2021 8:=
03 AM
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
> Hyper-V initalizes swiotlb bounce buffer and default swiotlb
> needs to be disabled. pci_swiotlb_detect_override() and
> pci_swiotlb_detect_4gb() enable the default one. To override
> the setting, hyperv_swiotlb_detect() needs to run before
> these detect functions which depends on the pci_xen_swiotlb_
> init(). Make pci_xen_swiotlb_init() depends on the hyperv_swiotlb
> _detect() to keep the order.
>=20
> Swiotlb bounce buffer code calls set_memory_decrypted()
> to mark bounce buffer visible to host and map it in extra
> address space via memremap. Populate the shared_gpa_boundary
> (vTOM) via swiotlb_unencrypted_base variable.
>=20
> The map function memremap() can't work in the early place
> hyperv_iommu_swiotlb_init() and so call swiotlb_update_mem_attributes()
> in the hyperv_iommu_swiotlb_later_init().
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  arch/x86/xen/pci-swiotlb-xen.c |  3 +-
>  drivers/hv/vmbus_drv.c         |  3 ++
>  drivers/iommu/hyperv-iommu.c   | 56 ++++++++++++++++++++++++++++++++++
>  include/linux/hyperv.h         |  8 +++++
>  4 files changed, 69 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xe=
n.c
> index 46df59aeaa06..30fd0600b008 100644
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
> index 392c1ac4f819..0a64ccfafb8b 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -33,6 +33,7 @@
>  #include <linux/random.h>
>  #include <linux/kernel.h>
>  #include <linux/syscore_ops.h>
> +#include <linux/dma-map-ops.h>
>  #include <clocksource/hyperv_timer.h>
>  #include "hyperv_vmbus.h"
>=20
> @@ -2078,6 +2079,7 @@ struct hv_device *vmbus_device_create(const guid_t =
*type,
>  	return child_device_obj;
>  }
>=20
> +static u64 vmbus_dma_mask =3D DMA_BIT_MASK(64);
>  /*
>   * vmbus_device_register - Register the child device
>   */
> @@ -2118,6 +2120,7 @@ int vmbus_device_register(struct hv_device *child_d=
evice_obj)
>  	}
>  	hv_debug_add_dev_dir(child_device_obj);
>=20
> +	child_device_obj->device.dma_mask =3D &vmbus_dma_mask;
>  	return 0;
>=20
>  err_kset_unregister:
> diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
> index e285a220c913..dd729d49a1eb 100644
> --- a/drivers/iommu/hyperv-iommu.c
> +++ b/drivers/iommu/hyperv-iommu.c
> @@ -13,14 +13,20 @@
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
> +#include <linux/dma-direct.h>
>=20
>  #include "irq_remapping.h"
>=20
> @@ -337,4 +343,54 @@ static const struct irq_domain_ops hyperv_root_ir_do=
main_ops =3D {
>  	.free =3D hyperv_root_irq_remapping_free,
>  };
>=20
> +static void __init hyperv_iommu_swiotlb_init(void)
> +{
> +	unsigned long hyperv_io_tlb_size;
> +	void *hyperv_io_tlb_start;
> +
> +	/*
> +	 * Allocate Hyper-V swiotlb bounce buffer at early place
> +	 * to reserve large contiguous memory.
> +	 */
> +	hyperv_io_tlb_size =3D swiotlb_size_or_default();
> +	hyperv_io_tlb_start =3D memblock_alloc(hyperv_io_tlb_size, PAGE_SIZE);
> +
> +	if (!hyperv_io_tlb_start)
> +		pr_warn("Fail to allocate Hyper-V swiotlb buffer.\n");

In the error case, won't swiotlb_init_with_tlb() end up panic'ing when
it tries to zero out the memory?   The only real choice here is to
return immediately after printing the message, and not call
swiotlb_init_with_tlb().

> +
> +	swiotlb_init_with_tbl(hyperv_io_tlb_start,
> +			      hyperv_io_tlb_size >> IO_TLB_SHIFT, true);
> +}
> +
> +int __init hyperv_swiotlb_detect(void)
> +{
> +	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
> +		return 0;
> +
> +	if (!hv_is_isolation_supported())
> +		return 0;
> +
> +	/*
> +	 * Enable swiotlb force mode in Isolation VM to
> +	 * use swiotlb bounce buffer for dma transaction.
> +	 */
> +	if (hv_isolation_type_snp())
> +		swiotlb_unencrypted_base =3D ms_hyperv.shared_gpa_boundary;
> +	swiotlb_force =3D SWIOTLB_FORCE;
> +	return 1;
> +}
> +
> +static void __init hyperv_iommu_swiotlb_later_init(void)
> +{
> +	/*
> +	 * Swiotlb bounce buffer needs to be mapped in extra address
> +	 * space. Map function doesn't work in the early place and so
> +	 * call swiotlb_update_mem_attributes() here.
> +	 */
> +	swiotlb_update_mem_attributes();
> +}
> +
> +IOMMU_INIT_FINISH(hyperv_swiotlb_detect,
> +		  NULL, hyperv_iommu_swiotlb_init,
> +		  hyperv_iommu_swiotlb_later_init);
>  #endif
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index b823311eac79..1f037e114dc8 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1726,6 +1726,14 @@ int hyperv_write_cfg_blk(struct pci_dev *dev, void=
 *buf, unsigned int len,
>  int hyperv_reg_block_invalidate(struct pci_dev *dev, void *context,
>  				void (*block_invalidate)(void *context,
>  							 u64 block_mask));
> +#if IS_ENABLED(CONFIG_HYPERV)
> +int __init hyperv_swiotlb_detect(void);
> +#else
> +static inline int __init hyperv_swiotlb_detect(void)
> +{
> +	return 0;
> +}
> +#endif
>=20
>  struct hyperv_pci_block_ops {
>  	int (*read_block)(struct pci_dev *dev, void *buf, unsigned int buf_len,
> --
> 2.25.1

