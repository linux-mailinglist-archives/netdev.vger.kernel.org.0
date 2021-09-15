Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D11640C88F
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238205AbhIOPoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:44:30 -0400
Received: from mail-oln040093003011.outbound.protection.outlook.com ([40.93.3.11]:51415
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233838AbhIOPo0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 11:44:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ar4Wvx31l2w/ihCAiuOKxLx6Pi6oBmOLIA49gWTySOAyMIlnh++hYmIdN3j1NCZ+7vplYREnOcBSiGbL+mw4ZZVzXJCdxVjutmfS/PW+kXZGB45i+cMgdwA0K/M4Fbm4Zri8e9Nzh18r85A+qSiCzFMwz9kFke442Y+Fl3ZPc/wO/Ufp56OYbNxieDucXSBIYoNnrPO/K+YvcJ0UQMAYgEmTmBTe4wBoE9t0gk/4r8iGV6XeL3k88fn9PZsW94UzknYovApuqSKcowRa48icGLyaCAUHPRPbL2ywEz34TeaZvJMQext3HpUXF89ArxuJvi6EYkuMK3HhHMsBN/fsjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=UdGf2dhGjdjrNSBr29knkOq/iN6qPOnXJ4Q3+w/IWiY=;
 b=ZblGtUWarLpPSp5BlrH1UE5OakPIg7ONf8X3klfJiOuAewiMFMn920W5G0coE7CDk0h4WBOqIr+T/lvDozL9N/DMNeigcaKkI1YFaxbdaYLJPybRc3WO+ut50+JJY2JqnOYDOfQXkshKUBEJK/mdXDJ/aoOMwI6+UTe3xk9oMO2t64LwEXZYWPvcriGJnI9sVmr1HLWgahfRvf8pqkMsmF9W2bCDb/FH3v6vUf4ICxJ7skjNdNmXHD9PXDN41sCWsE5AByY3zpz1cF5FCI2xhhgPYZHBJCbAhnY42mUHHpc8dy9RX6a1d0Vwf9NT2VqLiifY+IN4K2N53M0ntAK9Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdGf2dhGjdjrNSBr29knkOq/iN6qPOnXJ4Q3+w/IWiY=;
 b=CM5IUcO6NalZWF3FIV3eQjZfLTH9jXovMWG6mhwmrMxTorQB1F/MbTvOOK/Bu0eIbVE0PnQmMV+Pyjk5l2V6URh1kWSSnZVn14iS+siUHIPUPRuXITiA2RQsfm+SJeW9yXcwdzNa4Ei86pQ8E2cZ64n0P/QizaCJqYvZGZ2hmKc=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW2PR2101MB1819.namprd21.prod.outlook.com (2603:10b6:302:8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.2; Wed, 15 Sep
 2021 15:43:02 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9cb:4254:eba4:a4c3]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9cb:4254:eba4:a4c3%7]) with mapi id 15.20.4544.005; Wed, 15 Sep 2021
 15:43:02 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
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
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "rientjes@google.com" <rientjes@google.com>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V5 10/12] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Thread-Topic: [PATCH V5 10/12] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Thread-Index: AQHXqW4CnT0aDhDGb0m/WeqqHfER86ulOJww
Date:   Wed, 15 Sep 2021 15:43:02 +0000
Message-ID: <MWHPR21MB1593A1ACC6B61B1296E2AF27D7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210914133916.1440931-1-ltykernel@gmail.com>
 <20210914133916.1440931-11-ltykernel@gmail.com>
In-Reply-To: <20210914133916.1440931-11-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f1f7c7ec-7ac2-4096-b62b-ee94b06036b3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-15T15:24:11Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f433b1c-7082-4bca-01e7-08d9785f8093
x-ms-traffictypediagnostic: MW2PR2101MB1819:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB181981995E068CEBD4288FD7D7DB9@MW2PR2101MB1819.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:40;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nypIRcpS7/9undBUoTXZ/SXlOP/49tVAp8/f5PC0tz/hSA0fEYl6GtrsdY8qP1O58WOjY25QLZCc4nXhVWzEWK2uPsZ5tj16M/R/M+azdKmW/pWgOjz8bf4/slVYDQZZ1lPbvB1yQUGgINUVLyqlvNTEzv7+OubJLj9CSan+iJqQVexI7mUaFaT1h2Ot0jkMyhZ7mxvWxWLwQuSxWoMLU029IPGCSgf8urf4k64cx22DjuRcDEEbLgjrBwfGE2V9Rt3LCdQi0juapLnVE7kqj2hgMLnSqpWps7+s0Vzunj7VB5EZ75Fg2DGalfC0koXJA15hILK97dhhMM7vSR1pnzXwn8kls4ysFNdvOt0gplGKm6g+6OfF29nNzmf1fPAGchCE8YfFYJaSrhDgqhdWKVPHeSBepiqbDTIjGm05vrFhcxtkUcrA32xHlExV4tExJnKG8fwYO5gcNqHBguw0Oh+5A95SS1VevvYH3AfJUr+GBm01jGVuCDWg3ZTc/++VmM6BBfaVTw19rHIwT/kde5fENQXZrBEsHy3CRRtUM964mRCQvv9MJ6rPkeEAnf4Vte3Nc6PfNd+wzQLsK5Kd9jWwvq024D5GDvoMfxQGjjoi+UTdtLF+AAZP0ijWfYf5njEoCDlBInMU+uTZ1HGFRGpoMuMgnw/3sraC/aRoQAq02RFeSQ7nHG82wbybpw37wiJGuUmXgdkfyevneWIIRXsOEqBf7vMS3AR5wcUB4A8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(921005)(71200400001)(110136005)(82950400001)(54906003)(5660300002)(10290500003)(7406005)(6506007)(9686003)(33656002)(8936002)(83380400001)(66946007)(38070700005)(38100700002)(316002)(122000001)(7416002)(55016002)(26005)(66556008)(66446008)(86362001)(76116006)(66476007)(64756008)(8676002)(508600001)(7696005)(2906002)(82960400001)(52536014)(4326008)(186003)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pMI6xj/WxsOzorED9H7aWIdQzaKfcV9t39U93aywGTxcHi0eXBdW5w0tO5yI?=
 =?us-ascii?Q?E/2sCKPb+5mUl5FgKQHGejhH3p+kxwevpUorBfRR0VL1VWc+/uJjHl0dYcqJ?=
 =?us-ascii?Q?aHHnD0u3UDoKR3Vxsf122xoDpHUUprDmYJpKZxKE23JlL4L5ZXVPxdVY0lt8?=
 =?us-ascii?Q?rPy2ZbZfz3uQOo7sJHpfyqQxx8/c8Hu79d7gB5CjMfAlY4BQzn0sSJDjxTqC?=
 =?us-ascii?Q?ReRvwZKpdrKLiys/WGiB8/PrnDufG/KjBMb+G1PZU+W6qvt37gULBkrdSpbl?=
 =?us-ascii?Q?RROSkRjw5O/OIjO8TBsq6CaEoA75tnPhVQtTd1v5u8Pu/rT3IoKpNd77YYvT?=
 =?us-ascii?Q?U34XA8FTq5gvCtkzCIiLYzPep1Pz/n2+1aBbyiPkI+0CF3Wz5JfmixQmOOwU?=
 =?us-ascii?Q?7lXqvE9KNkJ107RWpUZbeM47Ar7P9jiUPL47aCrHVDGvgCmRxf/dNwrtHbav?=
 =?us-ascii?Q?a7+fUfn9eUORJknaZNRxHzzLcIx3cpLbB51wQc6KkLh0c2h2g1WldK6SOIhN?=
 =?us-ascii?Q?QGKN/XCpJ+Lrq7Y3f5HKOU3Aq3HalB8D3tPloB1xznyLeJdivev2E6TCaD40?=
 =?us-ascii?Q?OM5xYXniFdVz4Rclkde9avqHUS83MQVIsyMMUgLtsK10Rf8N48yWOZ5IcWDr?=
 =?us-ascii?Q?PLJhZZlsWFHdiw1anf+Epyrq+0M08BUKnGirSgDVgEBdBzAA2nDu9nDsoE4/?=
 =?us-ascii?Q?B9JDrD8IZFHZS2xJN6KtTYbYAhCumalehr+emJAWoCvTI8N+ScRQXG4CvCdB?=
 =?us-ascii?Q?HdVuVgGEaGVP1MIvkiySL5eRIOylJdN3YqHa7cdwDqpH7ZGrnoR4yvOGMX8O?=
 =?us-ascii?Q?FgZHQKyESb7m8h9kiKUNYkmghiZVl2Ju6pEoMbE+mFVBqOKUKka79VMpDVXo?=
 =?us-ascii?Q?4yTnROzy+1pvNBRaEXzwuz29chDMhG59Fmb1A+2+BmenJcrFOJ6uGGZN5Yw1?=
 =?us-ascii?Q?UcY39+tzD0wj82dJE4QtQJb2WJDlMeNInotsDXdY4tAIlwQR2Peu64CgZsbN?=
 =?us-ascii?Q?4axjCwgaYCwew+G5re6dhMrSvP1rafKcxOiLHKmG3nLzTzjsvRjQG7PLZQpp?=
 =?us-ascii?Q?Npttw9nDhQ5xB5oLZli1D5hlvSev7T+G//7vmOOnvafD4OnOzno7PIfYBexM?=
 =?us-ascii?Q?4chasNa+qPXHZbhamPShPDxEAHYxls0G+8OflW50vn4EXgHW0EPw5l1NDFZG?=
 =?us-ascii?Q?k6fJFPC7O1F2VWFWQIqn0vgOr/JTbAyWZHKLZXLWmaTgiLb8yYyQKIDn4K7r?=
 =?us-ascii?Q?+tMEphvemquakwc0tt3NTT0kQbcy51SnHFcZgBFQj2Dv30KCriYKvFs1Bfjl?=
 =?us-ascii?Q?HckH0qsQxDNGmIieUcdkEqrq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f433b1c-7082-4bca-01e7-08d9785f8093
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 15:43:02.0931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 78pkugS2AS6yDDws9kXGtcNRQGeOatlOsS2DkKE3GCbQmL24do8utGa8uCOUzNGlzfKggzgTRzScaXRA6S7jNTI5gCANjccJK2qrtUHxTGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1819
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Tuesday, September 14, 2021 6:=
39 AM
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
> hyperv_iommu_swiotlb_init() and so initialize swiotlb bounce
> buffer in the hyperv_iommu_swiotlb_later_init().
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v4:
>        * Use swiotlb_unencrypted_base variable to pass shared_gpa_
>          boundary and map bounce buffer inside swiotlb code.
>=20
> Change since v3:
>        * Get hyperv bounce bufffer size via default swiotlb
>        bounce buffer size function and keep default size as
>        same as the one in the AMD SEV VM.
> ---
>  arch/x86/include/asm/mshyperv.h |  2 ++
>  arch/x86/mm/mem_encrypt.c       |  3 +-
>  arch/x86/xen/pci-swiotlb-xen.c  |  3 +-
>  drivers/hv/vmbus_drv.c          |  3 ++
>  drivers/iommu/hyperv-iommu.c    | 60 +++++++++++++++++++++++++++++++++
>  include/linux/hyperv.h          |  1 +
>  6 files changed, 70 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyp=
erv.h
> index 165423e8b67a..2d22f29f90c9 100644
> --- a/arch/x86/include/asm/mshyperv.h
> +++ b/arch/x86/include/asm/mshyperv.h
> @@ -182,6 +182,8 @@ int hv_map_ioapic_interrupt(int ioapic_id, bool level=
, int vcpu, int vector,
>  		struct hv_interrupt_entry *entry);
>  int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *=
entry);
>  int hv_set_mem_host_visibility(unsigned long addr, int numpages, bool vi=
sible);
> +void *hv_map_memory(void *addr, unsigned long size);
> +void hv_unmap_memory(void *addr);

Aren't these two declarations now spurious?

>  void hv_ghcb_msr_write(u64 msr, u64 value);
>  void hv_ghcb_msr_read(u64 msr, u64 *value);
>  #else /* CONFIG_HYPERV */
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
> index 392c1ac4f819..b0be287e9a32 100644
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
> index e285a220c913..a8ac2239de0f 100644
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
> @@ -337,4 +348,53 @@ static const struct irq_domain_ops hyperv_root_ir_do=
main_ops =3D {
>  	.free =3D hyperv_root_irq_remapping_free,
>  };
>=20
> +static void __init hyperv_iommu_swiotlb_init(void)
> +{
> +	/*
> +	 * Allocate Hyper-V swiotlb bounce buffer at early place
> +	 * to reserve large contiguous memory.
> +	 */
> +	hyperv_io_tlb_size =3D swiotlb_size_or_default();
> +	hyperv_io_tlb_start =3D memblock_alloc(
> +		hyperv_io_tlb_size, PAGE_SIZE);
> +
> +	if (!hyperv_io_tlb_start) {
> +		pr_warn("Fail to allocate Hyper-V swiotlb buffer.\n");
> +		return;
> +	}
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
> +	swiotlb_unencrypted_base =3D ms_hyperv.shared_gpa_boundary;
> +	swiotlb_force =3D SWIOTLB_FORCE;
> +	return 1;
> +}
> +
> +static void __init hyperv_iommu_swiotlb_later_init(void)
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
> index a9e0bc3b1511..bb1a1519b93a 100644
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

