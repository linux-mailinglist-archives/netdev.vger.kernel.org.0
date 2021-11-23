Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA0C45AA51
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbhKWRsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:48:22 -0500
Received: from mail-oln040093013011.outbound.protection.outlook.com ([40.93.13.11]:12422
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231621AbhKWRsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 12:48:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PwGWpAsN4JPTDyabFy5CC/qEaL/7R8XiI3wfS0zU6v+txO+ZpKtf9i83JsXwVs6hb48dk1wEi2lukMOyLOn3Ozl0/Hlxb/++tuI0Xjy7s595RFZmmGw+ug7BIhntNBxmp6YlunRPY0C3LslcvUBh1wWyQ7d+efuO2rBnMWGbDRhHEcvICMcRYuxYJWyegfnMrGTjJuLH9SUn4Y85BDKAeaDhVU7kr26Byz4t9mfiMBU2zoNQ3UC/pjTURAukFo24HVM+gxKadT7YXOIJCCEW8+wfOq85XACrsqh0ieBEI63QuL6ec0hWFQFFEVpTfkmflu/jK+XokQIb9qsaRqOa6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IoeEDz8RJcg9PZleLooYwnpY2A5G19CQR2Rx90ECbAY=;
 b=kNAVUkNm0AtUfwCCTkpYyE1HMAbAIUs1sZhQZbR67VN+jc1J8zDxoGiNA/FYPQ8cz+JCaHS+x6KfTZBzMWLujnQSDIcABmWOfrLNLJjjEpQu8xMNOkM+cavkRiomyQlUmJnHoCIxLfCRq7F6ZszH/247uKo7EOlexYRTMI7M3xxz3TwxBAdS81wpFEbj9n/VVJ46i4H4YL8vXwl+8MKL3wftC93qeTLSWbfa4GIeGuEgdhJjPGK/h7OFLKXO469MDImlusV6AkJxF1uwWCqgZfHmXl6C7f86TrTAz/XV/9/lb2hr4/4IBaYO2b5pH+OBKEz0J+1BvvOZvuQfCSeQDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoeEDz8RJcg9PZleLooYwnpY2A5G19CQR2Rx90ECbAY=;
 b=ax1SdL7QWQEs3Mm4figypoTN+iYMls4K6NtKCmy2s2Sa0pEqF1AHgtYDGuGQE+hKYmzZAIurTaDUbMVwTZ/+8S46c6pVHTbi1xuPiCWbK60EYZ5wwr/XX6Mj4xtrJExEVzsHG8lpgNoVwrzrgLmFPEyWnCS5IAyhEaE23mzzeYg=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0766.namprd21.prod.outlook.com (2603:10b6:300:76::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.5; Tue, 23 Nov
 2021 17:44:56 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9401:9c8b:c334:4336]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9401:9c8b:c334:4336%2]) with mapi id 15.20.4755.001; Tue, 23 Nov 2021
 17:44:56 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V2 4/6] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Thread-Topic: [PATCH V2 4/6] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Thread-Index: AQHX4HeZTePwP1ztSUyjgsbuNOQDvKwRXCXw
Date:   Tue, 23 Nov 2021 17:44:56 +0000
Message-ID: <MWHPR21MB15939F017D1D6B8F62B90A8DD7609@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20211123143039.331929-1-ltykernel@gmail.com>
 <20211123143039.331929-5-ltykernel@gmail.com>
In-Reply-To: <20211123143039.331929-5-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=01595679-7835-4908-9946-56a7173067a5;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-11-23T17:21:24Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad468222-e641-4222-cfca-08d9aea8f6d0
x-ms-traffictypediagnostic: MWHPR21MB0766:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB0766610FE18BE30DC3AFF026D7609@MWHPR21MB0766.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:107;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PQHX+WfrutwZHoDw2EkkZhgKmBDUKUwwh01GlsdycqRch95JfJRX8eCkvSFLdsij5F9tLZm44zX6wJIXlqx13PrE9Ufjev6une7Q72Qdqx75zkoeLmLctuQHR3hI+sjlsLElf1e3th/pEPm6IqntCRbXvY9+/SOU794BhVBlUQkpxsPHhQF+ddmlYt19Zxr77BbzIQa6PLokR9enhRrFublaYYhWvTuumUDK5hoZP/kY7jBVKYTHoO4DcNh0v6nqNSs98UpdPaU0pKQ61vWrte9PiCh3q21YhIcJ/oqBo+rs0z3e71QulSNwG9vfKWAjvPPC99a3hxxc7/eMij4rLb6OLfXsY5Ra09NUlweOlPIjBiBDTPktUyo+CuDDVS1r0mfnjMtsMKM0Eu/0TtpbFawuKMFc03WemUm8kW/3UcjDwQVw6ApDuzIWbIe9fTD7rAcYK3mz8VtrpdfmvB2Hch2oZm78s6em6gtpBOR1kbuPIe2dGHC2B6gss36SZ0NyTQJsG18qTrJfOYR70KcMSKbrOjZSVxt+z45N9yNC9ATN1t5rv52K0qV5PtXTDGbNutHncSBF2uP0gw08j9C8ZGpkJ8VlTStTZYrlddeamxD4K7Vl02hrVeOVv3LiQhlrWDpLWWLkrfqsjRufETy0vgx64b9NZcbdWGa+lIHqzd2xJ2u4GdEquM+973P78lXiTva4DZ5Uo+ACScYqKaV2KxtG/Zq4uNCyU7ju8f7vgcFxRbaTsikBJ9izamquQhpPmSdMvJ7rbitWq3PGkpkfCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(316002)(10290500003)(86362001)(508600001)(8676002)(110136005)(7416002)(76116006)(33656002)(5660300002)(8936002)(82950400001)(55016003)(82960400001)(38100700002)(4326008)(64756008)(66556008)(66476007)(66446008)(71200400001)(9686003)(7406005)(122000001)(54906003)(52536014)(6506007)(8990500004)(186003)(26005)(66946007)(38070700005)(921005)(30864003)(83380400001)(7696005)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oIiCGN/JDykGgKkdoKHpmIRN6x2zdYFhZJMciGoQK7qYSAPf5VAbJ9QfLd41?=
 =?us-ascii?Q?5tQfMI5c73cZl/bolu159YkWLHYN0w1JjXXrWaHbeuaxBZoaKWTZmS7pLJqi?=
 =?us-ascii?Q?m0VEqrLg0C4KAZVuORIFGHBZWfvJ18dIAt/SHbXPDgk92j7a3njSUnhJJ8fB?=
 =?us-ascii?Q?P0ZSfGEUKbcQkybBiw4fgTq16rEQVil3QShxjcaPevuOLBOIefFKUDbrADNP?=
 =?us-ascii?Q?4E5s6ZNyLwI7m7Ue8ogTsUfCMdazI9KdMEePA2KvEXlDuIG0NoaA86zXC5Wm?=
 =?us-ascii?Q?bkirtbt0rrzStyjvsssrXXh88ncLahYuU6nr02c81ydnn0m7NIaJRXVaG4Gd?=
 =?us-ascii?Q?vVIQBbaOThPglQ6xpKPadlMOoQSq+Ifu4NY+yHRrwRdORmH/ZJA9VxG5Kh6b?=
 =?us-ascii?Q?z9RiDJj8wNN/lwVwF9x8njslgH3drJ4hqJ+jR9WYRLH/Z3VErRPuHx1tpjP8?=
 =?us-ascii?Q?vmGLKk+00KRN8pjGtaiMd9xbvzx5LFZqjY+g1liwz2seucjVWEgjk499TE4G?=
 =?us-ascii?Q?YcDnLH/ofvTtWxePn3C2qyULcT0C8J1nXegBzellqJZRMQtFxnNJCXB/upSV?=
 =?us-ascii?Q?iUwxgOtSc32/GTK11G69JVTGJB0gX9zodUm9Fop8l8Ylb7dfssMPpAo9vNI3?=
 =?us-ascii?Q?JQtyvrLI/Gwd/uSsGtoXa8hyrpuE18FAWxYBcCdfclNq8sSOApQ9E2ySGPtt?=
 =?us-ascii?Q?PIdhqP9gC0sDzJyVokdKp3NiHL2yedqoFq/Zm8r+kPbpsiCr6FQnGxKOipke?=
 =?us-ascii?Q?ABbT+/h+vl+6cPlEYkrWi8W9ZY2yJ9rhAYbre76Q4ceRByPnWpqYL0t08Mfa?=
 =?us-ascii?Q?24x36G4YXZB0UAuy5EeBoFN6ScbD+ETwURdOARma+5d+mN7y/fuzdtZYzAey?=
 =?us-ascii?Q?iFd82Fj6SFNznrKbaL6LSqywxtI8CUwFoQeGDuRwa4cYUB1uFj45r40c1F4+?=
 =?us-ascii?Q?vQ0TJceAko2E4bADiT5AQBJVnDtvZ6VAf34iuivgnRGSqn2hVi+cV8qHd+G9?=
 =?us-ascii?Q?ZumGAlyHYUU7T0mxe/fUH2Fzfh3cgkACRr4IAT9OghB10mGVHKtScu1Hwq27?=
 =?us-ascii?Q?PDafH2A4OMS8rs4Bcj4UGNsN5I6DPEBUAroRjHMNiVoEPLkXrakF3wXGNvxi?=
 =?us-ascii?Q?B6U1fW+TGINwBFpkMhzkY8Twz3V3f3ZlWhQt+sDx1sHr3qYagVHWWNlHPI2g?=
 =?us-ascii?Q?8C3e87ZMT4HC0F4ULjTcbkRy7SrdUvGiU/yWOK7PyDsPEbBWpraWPEr+W+Ux?=
 =?us-ascii?Q?fNP9O3dVbrTsR/UH6ddGRrKzaAwgleAQzairEH02q7g/LjymghxNgjmXptoj?=
 =?us-ascii?Q?ph+lmB6cBlXDQJy3T35hycTp+ByrOHuLPnmO265NqGRDJJjBzlr/oVihQllM?=
 =?us-ascii?Q?k3RVEw8A+yFCqunPC8dnUeFKQ71S2ML15jpGCMAJDyWfjI1Q8lnTIVOCSqE7?=
 =?us-ascii?Q?kJj1X8qiZnUghjaAlN5SPmCH+D2a01Vm8Wg+agdHeCpvPUmndfBfECBJHOr3?=
 =?us-ascii?Q?HoQWDqIBwSYV5BlnwR0a8ummJNEHVdeosYQVoNqumDL3GeWG5jlj8S2SFfwy?=
 =?us-ascii?Q?qwiptrGVmFGJyJQKxzc5RoKJW7T0wMSpR6HqGdsPchnVKMiIAqVHXYcEpyNG?=
 =?us-ascii?Q?RfFrG3X2hroXxZDSeJWoTDJwGKPakLbHBtVR1yN0B3OlQaNXiOZWs3lacXic?=
 =?us-ascii?Q?w1kILA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad468222-e641-4222-cfca-08d9aea8f6d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 17:44:56.7534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HirjXOPg7516nskoSMI97AYHuXPmpOv+pekjcHQb3yVj0UpmdpoXFSIXzfn1ke2EQgmVMviyGziOTTZbgPMktc/jVGi9keZlONzsu1GkfDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0766
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Tuesday, November 23, 2021 6:3=
1 AM
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
> Add Hyper-V dma ops and provide alloc/free and vmap/vunmap noncontiguous
> callback to handle request of  allocating and mapping noncontiguous dma
> memory in vmbus device driver. Netvsc driver will use this. Set dma_ops_
> bypass flag for hv device to use dma direct functions during mapping/unma=
pping
> dma page.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v1:
> 	* Remove hv isolation check in the sev_setup_arch()
>=20
>  arch/x86/mm/mem_encrypt.c      |   1 +
>  arch/x86/xen/pci-swiotlb-xen.c |   3 +-
>  drivers/hv/Kconfig             |   1 +
>  drivers/hv/vmbus_drv.c         |   6 ++
>  drivers/iommu/hyperv-iommu.c   | 164 +++++++++++++++++++++++++++++++++
>  include/linux/hyperv.h         |  10 ++
>  6 files changed, 184 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 35487305d8af..e48c73b3dd41 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -31,6 +31,7 @@
>  #include <asm/processor-flags.h>
>  #include <asm/msr.h>
>  #include <asm/cmdline.h>
> +#include <asm/mshyperv.h>

There is no longer any need to add this #include since code changes to this
file in a previous version of the patch are now gone.

>=20
>  #include "mm_internal.h"
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
> diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
> index dd12af20e467..d43b4cd88f57 100644
> --- a/drivers/hv/Kconfig
> +++ b/drivers/hv/Kconfig
> @@ -9,6 +9,7 @@ config HYPERV
>  	select PARAVIRT
>  	select X86_HV_CALLBACK_VECTOR if X86
>  	select VMAP_PFN
> +	select DMA_OPS_BYPASS
>  	help
>  	  Select this option to run Linux as a Hyper-V client operating
>  	  system.
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 392c1ac4f819..32dc193e31cd 100644
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
> @@ -2118,6 +2120,10 @@ int vmbus_device_register(struct hv_device *child_=
device_obj)
>  	}
>  	hv_debug_add_dev_dir(child_device_obj);
>=20
> +	child_device_obj->device.dma_ops_bypass =3D true;
> +	child_device_obj->device.dma_ops =3D &hyperv_iommu_dma_ops;
> +	child_device_obj->device.dma_mask =3D &vmbus_dma_mask;
> +	child_device_obj->device.dma_parms =3D &child_device_obj->dma_parms;
>  	return 0;
>=20
>  err_kset_unregister:
> diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
> index e285a220c913..ebcb628e7e8f 100644
> --- a/drivers/iommu/hyperv-iommu.c
> +++ b/drivers/iommu/hyperv-iommu.c
> @@ -13,14 +13,21 @@
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
>=20
>  #include "irq_remapping.h"
>=20
> @@ -337,4 +344,161 @@ static const struct irq_domain_ops hyperv_root_ir_d=
omain_ops =3D {
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
> +
> +static struct sg_table *hyperv_dma_alloc_noncontiguous(struct device *de=
v,
> +		size_t size, enum dma_data_direction dir, gfp_t gfp,
> +		unsigned long attrs)
> +{
> +	struct dma_sgt_handle *sh;
> +	struct page **pages;
> +	int num_pages =3D size >> PAGE_SHIFT;

This assumes "size" is a multiple of PAGE_SIZE.  Probably should round
up for safety.

> +	void *vaddr, *ptr;
> +	int rc, i;
> +
> +	if (!hv_isolation_type_snp())
> +		return NULL;
> +
> +	sh =3D kmalloc(sizeof(*sh), gfp);
> +	if (!sh)
> +		return NULL;
> +
> +	vaddr =3D vmalloc(size);
> +	if (!vaddr)
> +		goto free_sgt;
> +
> +	pages =3D kvmalloc_array(num_pages, sizeof(struct page *),
> +				    GFP_KERNEL | __GFP_ZERO);
> +	if (!pages)
> +		goto free_mem;
> +
> +	for (i =3D 0, ptr =3D vaddr; i < num_pages; ++i, ptr +=3D PAGE_SIZE)
> +		pages[i] =3D vmalloc_to_page(ptr);
> +
> +	rc =3D sg_alloc_table_from_pages(&sh->sgt, pages, num_pages, 0, size, G=
FP_KERNEL);
> +	if (rc)
> +		goto free_pages;
> +
> +	sh->sgt.sgl->dma_address =3D (dma_addr_t)vaddr;
> +	sh->sgt.sgl->dma_length =3D size;

include/linux/scatterlist.h defines macros sg_dma_address() and
sg_dma_len() for accessing these two fields.   It's probably best to use th=
em.

> +	sh->pages =3D pages;
> +
> +	return &sh->sgt;
> +
> +free_pages:
> +	kvfree(pages);
> +free_mem:
> +	vfree(vaddr);
> +free_sgt:
> +	kfree(sh);
> +	return NULL;
> +}
> +
> +static void hyperv_dma_free_noncontiguous(struct device *dev, size_t siz=
e,
> +		struct sg_table *sgt, enum dma_data_direction dir)
> +{
> +	struct dma_sgt_handle *sh =3D sgt_handle(sgt);
> +
> +	if (!hv_isolation_type_snp())
> +		return;
> +
> +	vfree((void *)sh->sgt.sgl->dma_address);

Use sg_dma_address()

> +	sg_free_table(&sh->sgt);
> +	kvfree(sh->pages);
> +	kfree(sh);
> +}
> +
> +static void *hyperv_dma_vmap_noncontiguous(struct device *dev, size_t si=
ze,
> +			struct sg_table *sgt)
> +{
> +	int pg_count =3D size >> PAGE_SHIFT;

Round up so don't assume size is a multiple of PAGE_SIZE?

> +	unsigned long *pfns;
> +	struct page **pages =3D sgt_handle(sgt)->pages;
> +	void *vaddr =3D NULL;
> +	int i;
> +
> +	if (!hv_isolation_type_snp())
> +		return NULL;
> +
> +	if (!pages)
> +		return NULL;
> +
> +	pfns =3D kcalloc(pg_count, sizeof(*pfns), GFP_KERNEL);
> +	if (!pfns)
> +		return NULL;
> +
> +	for (i =3D 0; i < pg_count; i++)
> +		pfns[i] =3D page_to_pfn(pages[i]) +
> +			(ms_hyperv.shared_gpa_boundary >> PAGE_SHIFT);
> +
> +	vaddr =3D vmap_pfn(pfns, pg_count, PAGE_KERNEL);
> +	kfree(pfns);
> +	return vaddr;
> +
> +}
> +
> +static void hyperv_dma_vunmap_noncontiguous(struct device *dev, void *ad=
dr)
> +{
> +	if (!hv_isolation_type_snp())
> +		return;
> +	vunmap(addr);
> +}
> +
> +const struct dma_map_ops hyperv_iommu_dma_ops =3D {
> +		.alloc_noncontiguous =3D hyperv_dma_alloc_noncontiguous,
> +		.free_noncontiguous =3D hyperv_dma_free_noncontiguous,
> +		.vmap_noncontiguous =3D hyperv_dma_vmap_noncontiguous,
> +		.vunmap_noncontiguous =3D hyperv_dma_vunmap_noncontiguous,
> +};
> +EXPORT_SYMBOL_GPL(hyperv_iommu_dma_ops);
> +
>  #endif
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index b823311eac79..4d44fb3b3f1c 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1726,6 +1726,16 @@ int hyperv_write_cfg_blk(struct pci_dev *dev, void=
 *buf, unsigned int len,
>  int hyperv_reg_block_invalidate(struct pci_dev *dev, void *context,
>  				void (*block_invalidate)(void *context,
>  							 u64 block_mask));
> +#ifdef CONFIG_HYPERV
> +int __init hyperv_swiotlb_detect(void);
> +#else
> +static inline int __init hyperv_swiotlb_detect(void)
> +{
> +	return 0;
> +}
> +#endif
> +
> +extern const struct dma_map_ops hyperv_iommu_dma_ops;
>=20
>  struct hyperv_pci_block_ops {
>  	int (*read_block)(struct pci_dev *dev, void *buf, unsigned int buf_len,
> --
> 2.25.1

