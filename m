Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2943FE658
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242579AbhIBAQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 20:16:05 -0400
Received: from mail-oln040093008003.outbound.protection.outlook.com ([40.93.8.3]:31608
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229898AbhIBAQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 20:16:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8BvVlJXCwbhMTEelowaN9kx+nSDBGru5s7InceIX2Po4KWVpJ9roHMd/HCgBjctY+yfPUfYaGNLdP0C7C3/k3ibkdI3yS8myRWQ9hSAdwm3RmSgF4ic3PwzTh+Ohfs+bJc0QJ3CJy2p/VsqBqit7kPKrafI+XuMeCOkvhEidSOTySuNX/5lq7eUVBuymJX//cN1tcVRrsuR/E7FrJDR7mrAww93YjW5uljePBfs9Yzw8nXxhffKaIH97oJ68UrXfRd20GiPMro2luozaSykmfstmHPOP+V/5hqh67T4Bxu/qVIxO3B3mOaE01uFDrbW4avWGix5Zu/9cYBxrFUmLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=2wJZwyg52cCLIvGROM9MWlEN9cOqwTvnQY12hCyFx/M=;
 b=PBg5e0gbR6i6m1kfUdBM0yttzgG6W3oki6YYMb+OpIhotgMUyPhbW/zmQqSfdenV5yHItttnIcqtZjyZtxHGNhRiM8A2XYeRSl/Cj92gJUdhaWkUgov87B+UkKqmp6oVPKIIEw6ETznyygch+fSUdwnIY4mkFFgzryPgGHDeC+5a2AVdLSONFKAkf+p7Gm+l/PVtc/MOanHkQRSKxFnRaQwT7PxVT8ZlM0PV5eca63f/J7m24zMpHzY9eptYV0Kivpl/xlbRRBI6Po8SGvg4uctJU8fSdJGIJ4njXkQaehViwJQPV9x6bYIHXnI8lEGRt1I4xEPkQKP/+90DvR7wnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2wJZwyg52cCLIvGROM9MWlEN9cOqwTvnQY12hCyFx/M=;
 b=aIfunch/uFPwfCEApTqxLCAAZxJPvXnaRb7Pj8i7HYwjQ8P8SbWpTRgpUiYkQLLmQVAKBJZ3ttPxukfts2EM+obZus2xdhUWv56/DaGyXjYJFT/fM0RvR7hCvbagI3R+8jullzbTd+QlKODpqdoy3y4R+/5uzJJAHAHD0vo+GI8=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0797.namprd21.prod.outlook.com (2603:10b6:300:11b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.1; Thu, 2 Sep
 2021 00:15:03 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86%8]) with mapi id 15.20.4478.014; Thu, 2 Sep 2021
 00:15:03 +0000
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
Subject: RE: [PATCH V4 01/13] x86/hyperv: Initialize GHCB page in Isolation VM
Thread-Topic: [PATCH V4 01/13] x86/hyperv: Initialize GHCB page in Isolation
 VM
Thread-Index: AQHXm2f8V9hgDb15oEeIZM6sY/3E8auH7dAA
Date:   Thu, 2 Sep 2021 00:15:03 +0000
Message-ID: <MWHPR21MB1593366997ACAFCC79EBC0B0D7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210827172114.414281-2-ltykernel@gmail.com>
In-Reply-To: <20210827172114.414281-2-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=11e436c2-915c-4d7c-84ac-3bd04a4dfdb3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-27T22:24:34Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a93f77f8-5e8d-4146-86b8-08d96da6b5ec
x-ms-traffictypediagnostic: MWHPR21MB0797:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB07976EFF864A059B6428E017D7CE9@MWHPR21MB0797.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: epIsuYLDpNuvDcYJI1k0v+H+bBdkVs7GflPwJ89C7scLQt3PA8qBjBhhCjLcJ3STPnN7wrJytjcvU4hl0MYDSA/M207W9ZMTZ37Wd6OugAl6aezKycuTmFk77kpY88OfUh09NeI0vZ4l6URGi1BH3jkOgO+sBcjXVlellQ8kYwwGTZgl6scPuWO8up0RHHvR4XObjCS7HjHaI42LIbnIFzqWLzxJXgHp8+oIix3fh+zOf65qNMd4iPQv2BVuuaBLCRWplWUr6H6vAJsDFInSEDqIyrmje5XPV1EtXzoD4nLSWfOU/9a2gtMZBFaMWlOl7UAN59dHTNCldAD3s3wEI9/wOLRjXaRJzoBwjuSFBNjl6RzLrbZ89J8F4nI1fw1zrMoMilaQVJ70R0JBJ3ZwpI5Ofnc9WCTeH5wWTQ6Sb+McqQLhvO5+cie/iUTFJD5dls2fMYR6e8/pYxNXIN6EMcUR2KVAg6ys9nRDPECW3zkcnpIqDVHkPioYmSY7FgpGUFN3fA4//FfoMO0FLRP+K7Ce7o48GQ8mGf09t+UBtngfnTv0eBbrJTOu+Sa0H/sM4I1zEIBewjnOW0yLv+eQ4zPILbVDpuUHDPmP6sX8KJNwCtY+VtTxvts+r5CeSerSZ4SqHQKDausoCx4hUmtY+NW/I839xu+E8yjEnKCrz7eHixQWz5DX0oYg0LQdZzN9/TRgoXgK78QrvIGhVO7kFhR6FAN4+CDioU83HC74qgE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38070700005)(8936002)(316002)(8676002)(7696005)(71200400001)(5660300002)(52536014)(10290500003)(82960400001)(508600001)(8990500004)(82950400001)(7366002)(7406005)(66446008)(83380400001)(186003)(66476007)(66556008)(122000001)(76116006)(86362001)(921005)(33656002)(66946007)(9686003)(54906003)(55016002)(110136005)(64756008)(6506007)(4326008)(7416002)(38100700002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+SGvGo5LkyV3z+SW3AVjl3lmleGqyjpZ/boSbjjpuWW5SKx1ApAWYE1hlCTO?=
 =?us-ascii?Q?M7dMdQq8LUMvGbrXI86PorsvIaGjOuHQgc8ceSyzq6p2IEw6aj9e7RoNsLzh?=
 =?us-ascii?Q?+2RamO64+yd2hERjxFouOqyFd7ereJcl5HrAbIk/6CgQp6X3igVVNtA+OIXb?=
 =?us-ascii?Q?/V8Jr8+Swayl2Zkek8ng1r0qv6bnyZ4e2yq6vGz3XJIDzVWJQnsPtXRZ4n3Y?=
 =?us-ascii?Q?hToD/HPrFnHlMOK7KCeeuPruWaF4duxcruMBuYlSYsdvjiX/NYtevhjo4mPk?=
 =?us-ascii?Q?Pp1BPdyc54XNnenMlC5Rcx4zBjW2lPehSKRIYjtSy3u8A2hT3i/fIZ+rLS1W?=
 =?us-ascii?Q?skCK43EqJq9ZRA/0ayPuCPeUln685c3+YEU4DDVj/V2Awtfnlmw3Spy978Cl?=
 =?us-ascii?Q?G4mqEOPp0hFGPKHcY7Ppkz/S6ZkUYqZzKGH9g0lIBlbQVZKSrnVXaT/xpxuM?=
 =?us-ascii?Q?eO24L6OEKTYxWDhBCkaXqzRgVYLmMXdDCy0+JDoLdIEVBKvUUtzqX0pThptA?=
 =?us-ascii?Q?pExZRrp8K19Sf2lPHyjS6LtJrHvGRL8qwNHNdxVJCqtyZGpkYERdxwHXNt0K?=
 =?us-ascii?Q?dzF3dwCHdaOFdglJHBoihyelfe3V1o5d8A2lfM0GWICQOHEcZLQPqeOaOYFt?=
 =?us-ascii?Q?n4rabWOuGaNTLALS5eIwgjX548KNnEOuoP+77UvnBS1uNcnijusVJEiGF09J?=
 =?us-ascii?Q?JcgHidD1tXjJTsSNdnFGr+h8DtyEx7eop+uJtdq0dcoqM+UHqXBDG7wIygjG?=
 =?us-ascii?Q?qzn6p4DT21ArJV8QRDEewJCEdMw6BCtIPj1BXXqIH7dQD62DjHU7VvmUrUhC?=
 =?us-ascii?Q?JCSGgUn1pxSZDm+E1ydRtgM8UnQzzvSDJLMIyFx0YT3HM3huVz5TFRXqUmJ9?=
 =?us-ascii?Q?UxGP7a1EUwoftA0kAEj2zLBcTjqblpcnT27wzhwEzMfkRpaqSg7GSF/64xvy?=
 =?us-ascii?Q?4UB/j/0IBxnyPxY/hwJgVr4zpFAsIKyaYhE8SswCoPSQC1Va3yraTzHVJhJB?=
 =?us-ascii?Q?GWhOODZX3rIKIUGD0IiXw0IQASfRTS/4+Us/SKfYFOnvhD5PqRIy95JkjsIG?=
 =?us-ascii?Q?lDPpsidDnekVVuLsMKzaGYmmLSlqdUWCA9gRttqi8MJUyKf5pWY8dFxmGCqv?=
 =?us-ascii?Q?2y5AmFXa1jJRXarV4vIoPvevlzJqmtbgToTktN+Y1CxX8F4Fvl3wtHsfmZB3?=
 =?us-ascii?Q?A1ZWW4MKulOUpPCCsBOsVgROJuS9wvCloK1LZKwWqqMbqguRY5EDJ395PM2D?=
 =?us-ascii?Q?A2bcYFF+ZlueEd2dVCTkguUibyFLiqHbMdXYdvk6Q32xl2Mn8EEvqlAioWsz?=
 =?us-ascii?Q?H+rz7J+co1poMS4EpHmARJCo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a93f77f8-5e8d-4146-86b8-08d96da6b5ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 00:15:03.0983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p8dISAuhX9IHX9/2j7Bsfwp5edDHyaJ+23+T2AH2eOY3r/aR7IqvRmfOlB8qS0BdABm/bMD8pSHZu6ldb6ZT/WmE/DgBmGyuWoge9svJhZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Friday, August 27, 2021 10:21 =
AM
>=20
> Hyperv exposes GHCB page via SEV ES GHCB MSR for SNP guest
> to communicate with hypervisor. Map GHCB page for all
> cpus to read/write MSR register and submit hvcall request
> via ghcb page.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Chagne since v3:
>         * Rename ghcb_base to hv_ghcb_pg and move it out of
> 	  struct ms_hyperv_info.
> 	* Allocate hv_ghcb_pg before cpuhp_setup_state() and leverage
> 	  hv_cpu_init() to initialize ghcb page.
> ---
>  arch/x86/hyperv/hv_init.c       | 68 +++++++++++++++++++++++++++++----
>  arch/x86/include/asm/mshyperv.h |  4 ++
>  arch/x86/kernel/cpu/mshyperv.c  |  3 ++
>  include/asm-generic/mshyperv.h  |  1 +
>  4 files changed, 69 insertions(+), 7 deletions(-)
>=20
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index 708a2712a516..eba10ed4f73e 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -20,6 +20,7 @@
>  #include <linux/kexec.h>
>  #include <linux/version.h>
>  #include <linux/vmalloc.h>
> +#include <linux/io.h>
>  #include <linux/mm.h>
>  #include <linux/hyperv.h>
>  #include <linux/slab.h>
> @@ -36,12 +37,42 @@ EXPORT_SYMBOL_GPL(hv_current_partition_id);
>  void *hv_hypercall_pg;
>  EXPORT_SYMBOL_GPL(hv_hypercall_pg);
>=20
> +void __percpu **hv_ghcb_pg;
> +
>  /* Storage to save the hypercall page temporarily for hibernation */
>  static void *hv_hypercall_pg_saved;
>=20
>  struct hv_vp_assist_page **hv_vp_assist_page;
>  EXPORT_SYMBOL_GPL(hv_vp_assist_page);
>=20
> +static int hyperv_init_ghcb(void)
> +{
> +	u64 ghcb_gpa;
> +	void *ghcb_va;
> +	void **ghcb_base;
> +
> +	if (!hv_isolation_type_snp())
> +		return 0;
> +
> +	if (!hv_ghcb_pg)
> +		return -EINVAL;
> +
> +	/*
> +	 * GHCB page is allocated by paravisor. The address
> +	 * returned by MSR_AMD64_SEV_ES_GHCB is above shared
> +	 * ghcb boundary and map it here.

I'm not sure what the "shared ghcb boundary" is.  Did you
mean "shared_gpa_boundary"?

> +	 */
> +	rdmsrl(MSR_AMD64_SEV_ES_GHCB, ghcb_gpa);
> +	ghcb_va =3D memremap(ghcb_gpa, HV_HYP_PAGE_SIZE, MEMREMAP_WB);
> +	if (!ghcb_va)
> +		return -ENOMEM;
> +
> +	ghcb_base =3D (void **)this_cpu_ptr(hv_ghcb_pg);
> +	*ghcb_base =3D ghcb_va;
> +
> +	return 0;
> +}
> +
>  static int hv_cpu_init(unsigned int cpu)
>  {
>  	union hv_vp_assist_msr_contents msr =3D { 0 };
> @@ -85,7 +116,7 @@ static int hv_cpu_init(unsigned int cpu)
>  		}
>  	}
>=20
> -	return 0;
> +	return hyperv_init_ghcb();
>  }
>=20
>  static void (*hv_reenlightenment_cb)(void);
> @@ -177,6 +208,14 @@ static int hv_cpu_die(unsigned int cpu)
>  {
>  	struct hv_reenlightenment_control re_ctrl;
>  	unsigned int new_cpu;
> +	void **ghcb_va;
> +
> +	if (hv_ghcb_pg) {
> +		ghcb_va =3D (void **)this_cpu_ptr(hv_ghcb_pg);
> +		if (*ghcb_va)
> +			memunmap(*ghcb_va);
> +		*ghcb_va =3D NULL;
> +	}
>=20
>  	hv_common_cpu_die(cpu);
>=20
> @@ -366,10 +405,16 @@ void __init hyperv_init(void)
>  		goto common_free;
>  	}
>=20
> +	if (hv_isolation_type_snp()) {
> +		hv_ghcb_pg =3D alloc_percpu(void *);
> +		if (!hv_ghcb_pg)
> +			goto free_vp_assist_page;
> +	}
> +
>  	cpuhp =3D cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/hyperv_init:onlin=
e",
>  				  hv_cpu_init, hv_cpu_die);
>  	if (cpuhp < 0)
> -		goto free_vp_assist_page;
> +		goto free_ghcb_page;
>=20
>  	/*
>  	 * Setup the hypercall page and enable hypercalls.
> @@ -383,10 +428,8 @@ void __init hyperv_init(void)
>  			VMALLOC_END, GFP_KERNEL, PAGE_KERNEL_ROX,
>  			VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
>  			__builtin_return_address(0));
> -	if (hv_hypercall_pg =3D=3D NULL) {
> -		wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
> -		goto remove_cpuhp_state;
> -	}
> +	if (hv_hypercall_pg =3D=3D NULL)
> +		goto clean_guest_os_id;
>=20
>  	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
>  	hypercall_msr.enable =3D 1;
> @@ -456,8 +499,11 @@ void __init hyperv_init(void)
>  	hv_query_ext_cap(0);
>  	return;
>=20
> -remove_cpuhp_state:
> +clean_guest_os_id:
> +	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
>  	cpuhp_remove_state(cpuhp);
> +free_ghcb_page:
> +	free_percpu(hv_ghcb_pg);
>  free_vp_assist_page:
>  	kfree(hv_vp_assist_page);
>  	hv_vp_assist_page =3D NULL;
> @@ -559,3 +605,11 @@ bool hv_is_isolation_supported(void)
>  {
>  	return hv_get_isolation_type() !=3D HV_ISOLATION_TYPE_NONE;
>  }
> +
> +DEFINE_STATIC_KEY_FALSE(isolation_type_snp);
> +
> +bool hv_isolation_type_snp(void)
> +{
> +	return static_branch_unlikely(&isolation_type_snp);
> +}
> +EXPORT_SYMBOL_GPL(hv_isolation_type_snp);
> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyp=
erv.h
> index adccbc209169..37739a277ac6 100644
> --- a/arch/x86/include/asm/mshyperv.h
> +++ b/arch/x86/include/asm/mshyperv.h
> @@ -11,6 +11,8 @@
>  #include <asm/paravirt.h>
>  #include <asm/mshyperv.h>
>=20
> +DECLARE_STATIC_KEY_FALSE(isolation_type_snp);
> +
>  typedef int (*hyperv_fill_flush_list_func)(
>  		struct hv_guest_mapping_flush_list *flush,
>  		void *data);
> @@ -39,6 +41,8 @@ extern void *hv_hypercall_pg;
>=20
>  extern u64 hv_current_partition_id;
>=20
> +extern void __percpu **hv_ghcb_pg;
> +
>  int hv_call_deposit_pages(int node, u64 partition_id, u32 num_pages);
>  int hv_call_add_logical_proc(int node, u32 lp_index, u32 acpi_id);
>  int hv_call_create_vp(int node, u64 partition_id, u32 vp_index, u32 flag=
s);
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyper=
v.c
> index 6b5835a087a3..20557a9d6e25 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -316,6 +316,9 @@ static void __init ms_hyperv_init_platform(void)
>=20
>  		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
>  			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
> +
> +		if (hv_get_isolation_type() =3D=3D HV_ISOLATION_TYPE_SNP)
> +			static_branch_enable(&isolation_type_snp);
>  	}
>=20
>  	if (hv_max_functions_eax >=3D HYPERV_CPUID_NESTED_FEATURES) {
> diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyper=
v.h
> index c1ab6a6e72b5..0924bbd8458e 100644
> --- a/include/asm-generic/mshyperv.h
> +++ b/include/asm-generic/mshyperv.h
> @@ -237,6 +237,7 @@ bool hv_is_hyperv_initialized(void);
>  bool hv_is_hibernation_supported(void);
>  enum hv_isolation_type hv_get_isolation_type(void);
>  bool hv_is_isolation_supported(void);
> +bool hv_isolation_type_snp(void);
>  void hyperv_cleanup(void);
>  bool hv_query_ext_cap(u64 cap_query);
>  #else /* CONFIG_HYPERV */
> --
> 2.25.1

