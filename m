Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D5A3EAAB4
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 21:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbhHLTPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 15:15:30 -0400
Received: from mail-dm6nam11on2090.outbound.protection.outlook.com ([40.107.223.90]:36627
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229607AbhHLTP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 15:15:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XoNYOIx8mL8Q0zXc4H/tpK2UjuuQWJd/TLI8X5tXOVOzasgZYTv2cFOOejs7re+zxJ/B1+4okdzGzwGi9iyDz3uPwfMWMcugmgnAG7Hf1YCpPiY76UF61aJ0mkfEVFRUqrXGbipmw49si2hO5qpk3BshGQ/r9KTegZj70nQLNm9L7lf69YOzsIZXcHHlQpA9MEn1g5d6z0jYQ/auw0/CJMjgRTpty6HeC9FI8Tc7OC1YKQ50JVJZKybD+fn63ttyemj5w2edujf7EnlZkVrTH6odPUwdPAc64moVU1Vr+yIQA824GyoMgUNR+7Otr2bkDbvVdcssaQ2GPWAci2q3Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gpuys++vcODbpsGWQB3uRlx1IdhYOTtNFDrliIJ2G1M=;
 b=jpNpNIB50R7wxjmxlcO75VvEtK3X9yiHPsnEyIkgB+a9BXgcZvpfkNepO84mzCZKAoQv4b/IbVX2oPwPU9zUH6mO/lqR27fShUPsFcBACEklTh7pCc/KmExFd4RfyHNQKroW91ki2pqw8ihBdmUYNP14vXgkETCnhFnrPl+MzYgCTPGBJxfCnuchjWtMloeCW8pzudhu56sOKhfWN7oyHyEABysoM5fXziPuNpMCmdBH4sYD2t+FTrnABWpFCVSOA0pCXKMoX5kmy76mYpqvMyXDxVpai50d2jmnOwpAKx14YWEsaHSsz29IUXWZ/ulaLnu4r176nR21rTu5vQPtzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gpuys++vcODbpsGWQB3uRlx1IdhYOTtNFDrliIJ2G1M=;
 b=abE98PLm6OZPm1OQ5pzOqnitEm2AusVKl7dyz4ig24zxA81NIASpgwR84oD6hvPpOKMohWx59HKw5+3KnBCU3FyMCAfjHM5qn9HnIMdQBm4qrHs0OqjCU6cM/3D6Vo8EwFe9uBihQWIFjEDimR9tuchm2yQjIKIVq9Z4RHYfAMw=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by CO1PR21MB1283.namprd21.prod.outlook.com (2603:10b6:303:162::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.1; Thu, 12 Aug
 2021 19:14:58 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55%2]) with mapi id 15.20.4436.012; Thu, 12 Aug 2021
 19:14:58 +0000
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
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "tj@kernel.org" <tj@kernel.org>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V3 01/13] x86/HV: Initialize GHCB page in Isolation VM
Thread-Topic: [PATCH V3 01/13] x86/HV: Initialize GHCB page in Isolation VM
Thread-Index: AQHXjUfh3L5oGAIB0EmHDBGVrpI9rKtwO+iQ
Date:   Thu, 12 Aug 2021 19:14:58 +0000
Message-ID: <MWHPR21MB1593BDFA4A71CE6882E25400D7F99@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-2-ltykernel@gmail.com>
In-Reply-To: <20210809175620.720923-2-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=3bfdd0db-44ef-4cc1-aacb-5c4b1161b694;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-12T18:52:44Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed154913-3150-4242-52eb-08d95dc579f5
x-ms-traffictypediagnostic: CO1PR21MB1283:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CO1PR21MB12831F14641653FFE1CF4DD0D7F99@CO1PR21MB1283.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zAD0zptds3QUECqmDgLegJBW91ZPMlqGKdut1uA3XaBDTuKO0q/qQQ7g2mD1MHD3ZFTOeVKv1/DKxLqzfz7VokK1yy+5UN94nBv04f5p1mogCXwu+YSfxURVo0LD7lZmG6RFUwOjZVTNxwEJ3JbpmAwn3EpR2rvpMiOXbDMA6rrqaRdOehSBgGpW47NqaPZ6D5vp7zOUfhxDOHovn9OCSin+kAEXgJVAkwFKCeCjY3W4XX09Aa3hFIihwdJl26RiW27Evt4pL+mL4159hu81PhFj1TlAXYE2C0uRJWE2OC6+lzptfHflK00YA6sr6JW3SE4GBuD75abFn1r1pywwGij05foKb1l31IMoM+MsZB7TkDLi+41dOaMfdE9QvsZkAtsvIjVF2tTtcbPyXd47vU1qwwuY2ngsUcl/nowv74x8ROmoX7OR3qFZ4zTck0pwwodqAWOTz3IN+EYVjedb1CYxenFzbAJFdWejTWMfqBEPPNigeblgv7HdW932U6HWZpX3vsDPfAbdPFH8ntZNZGV7eKwSyC6AIjU3qkEm+DcinAzYpsgClpzPQDk7dlhwOvwHa22BFFXgyZ/8/zaaLEaliGortWoZa+MaMO/Lxxit55VCvtCRdy77zqkuUxk/aRenSvzCsw9f8ojjj6aBY1UWiwqdDqQmbBjGOwGijptlYXgX+BNdvy3JZ/O5zsBxyb2vrTLytVSkKjKx1sd+aR9x2H4rhHVH89Ig4mGMRSg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(82950400001)(6506007)(82960400001)(71200400001)(2906002)(921005)(10290500003)(7696005)(508600001)(86362001)(26005)(186003)(4326008)(7416002)(122000001)(7406005)(54906003)(8676002)(8936002)(9686003)(110136005)(5660300002)(66446008)(64756008)(76116006)(66946007)(33656002)(83380400001)(55016002)(38070700005)(316002)(52536014)(8990500004)(38100700002)(66476007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JJx9OHqprqGIl6IOQ06tKcKLUkeM5tuZVvsOA81J8By+5kpUL0nipy9GsNcN?=
 =?us-ascii?Q?5ruSTsR6FxEmDqS/fS3yDQc5pmqEfYJpvZSVJ3t1+MRTckQr/x2NN42qEN0L?=
 =?us-ascii?Q?CvluYUEBQuc+Y8Dl5Sc8drYd6tWKU2tT4sBt2oZn97e3olXJCBP8LP00nSzL?=
 =?us-ascii?Q?P3Xr1h9pz2LdsbEMsDkqe8KzLOgtSyRWL1u0flhe2vwGKaHOypt+jMZvFuKB?=
 =?us-ascii?Q?zmYoNJc5rcBF/PL8gmVMA6IwGLm0xvXSZoDks4LyHBnNrJvHjqmKKaXRYm84?=
 =?us-ascii?Q?augBx89owdqlUQMCQC9EKLRn468uWOtb9rQE6eWcvCl8ZqXnTZrwI9aOef0+?=
 =?us-ascii?Q?TMl1d66HAXSyS5iK1HLIVhCP8VoTezEwQjxChUplQyeFeO2bwJBjGmgZLQ2t?=
 =?us-ascii?Q?BAcOvICD9tmk+mz393k5Rgr0GQ0Ly4CPUx0xv8ubisbezSJutl93DNMdHN1p?=
 =?us-ascii?Q?SXy89DGHocXm9OgHjMgT0mTSrDNjnYnVMe0o5VsdMqzONiKa9ay9M2A7NhPu?=
 =?us-ascii?Q?SgsuvOicCFLQA+cdGuWW1skgu9g/wF8e8Yz8pnaFjz3mv0mepSv1fgohRw88?=
 =?us-ascii?Q?ja+XVY3mNhznPC2vmJvr5W/7M4Vp5Kt0wUFtNeYbPxVGIIjV8MWvjTRCiQSt?=
 =?us-ascii?Q?566SGD8uYnLq4o6MqAMnVhVelgE26P8GH/BgFvKq7kycD1wUIB13l35eXYso?=
 =?us-ascii?Q?DlTwqZUNJnexg9YqPY3HEx2eqmdbYSckkYRk5jlvbMtuXx5i37xROwl2G0QV?=
 =?us-ascii?Q?V9nCZCrXpILARBJui6q+bzi5dBD7VHwjCiDn4VxGNnmOQHcjcTKEnjl8dyrz?=
 =?us-ascii?Q?c7MqJPIfFMDkrtKORQRiYbaFPAteMDjwQGYFeOEedXg7Oqym8yHrD3/ufVLz?=
 =?us-ascii?Q?eBUfTCAuZGoOD7KwP+AsFaZZfEd3F0XnI0ecnVXjC2dGMOmoBEsvKZvwRCdU?=
 =?us-ascii?Q?KSgz+kPUez9irY8hbPcIT8rlTPzArb2b2qfJa7yh/nMlwQ6Yd3V93nGoSkL6?=
 =?us-ascii?Q?XnDbXhJ8kO//i9u5gD5INOGZHQqAEUUAGXxrAGSjbDf739/3b2nZ8UiUBiL7?=
 =?us-ascii?Q?P3jhMa8vYddnJvSIqxXeISLCpcnlLe+hT4YRil/i7mj4B5jAkaYT+Wytd5OR?=
 =?us-ascii?Q?crmKwkYg0oXxfa+K09H23q+V9DzkRUaeqpmvkAy/ngCMSK3njXATmDv48qNW?=
 =?us-ascii?Q?RpY2+hh6oeRm30nWS1APOtaaqFrhxsk8+AOSLqk5eZOv+cLFgw6YW7PWzJP9?=
 =?us-ascii?Q?Ubv9mCSuj3O3I7/I/9edQWRw+dj9lOkFjrdOBQ+sYovZJSbYCMZCUg9OL2aC?=
 =?us-ascii?Q?6fTVaFauNRWI+qF0gCQ993/h?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed154913-3150-4242-52eb-08d95dc579f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 19:14:58.4607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HdbeV510yJExLu5WL5x/AdyPokhvnPDxIsh21pCyfFEUrpXKjFBQDx+vb1GTCUcx2gk+5xk8zIUmI4i3mFL+7OqPgZbtGl5JsNZCtLQuibc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR21MB1283
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Monday, August 9, 2021 10:56 A=
M
> Subject: [PATCH V3 01/13] x86/HV: Initialize GHCB page in Isolation VM

The subject line tag on patches under arch/x86/hyperv is generally "x86/hyp=
erv:".
There's some variation in the spelling of "hyperv", but let's go with the a=
ll
lowercase "hyperv".

>=20
> Hyper-V exposes GHCB page via SEV ES GHCB MSR for SNP guest
> to communicate with hypervisor. Map GHCB page for all
> cpus to read/write MSR register and submit hvcall request
> via GHCB.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  arch/x86/hyperv/hv_init.c       | 66 +++++++++++++++++++++++++++++++--
>  arch/x86/include/asm/mshyperv.h |  2 +
>  include/asm-generic/mshyperv.h  |  2 +
>  3 files changed, 66 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index 708a2712a516..0bb4d9ca7a55 100644
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
> @@ -42,6 +43,31 @@ static void *hv_hypercall_pg_saved;
>  struct hv_vp_assist_page **hv_vp_assist_page;
>  EXPORT_SYMBOL_GPL(hv_vp_assist_page);
>=20
> +static int hyperv_init_ghcb(void)
> +{
> +	u64 ghcb_gpa;
> +	void *ghcb_va;
> +	void **ghcb_base;
> +
> +	if (!ms_hyperv.ghcb_base)
> +		return -EINVAL;
> +
> +	/*
> +	 * GHCB page is allocated by paravisor. The address
> +	 * returned by MSR_AMD64_SEV_ES_GHCB is above shared
> +	 * ghcb boundary and map it here.
> +	 */
> +	rdmsrl(MSR_AMD64_SEV_ES_GHCB, ghcb_gpa);
> +	ghcb_va =3D memremap(ghcb_gpa, HV_HYP_PAGE_SIZE, MEMREMAP_WB);
> +	if (!ghcb_va)
> +		return -ENOMEM;
> +
> +	ghcb_base =3D (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
> +	*ghcb_base =3D ghcb_va;
> +
> +	return 0;
> +}
> +
>  static int hv_cpu_init(unsigned int cpu)
>  {
>  	union hv_vp_assist_msr_contents msr =3D { 0 };
> @@ -85,6 +111,8 @@ static int hv_cpu_init(unsigned int cpu)
>  		}
>  	}
>=20
> +	hyperv_init_ghcb();
> +
>  	return 0;
>  }
>=20
> @@ -177,6 +205,14 @@ static int hv_cpu_die(unsigned int cpu)
>  {
>  	struct hv_reenlightenment_control re_ctrl;
>  	unsigned int new_cpu;
> +	void **ghcb_va =3D NULL;

I'm not seeing any reason why this needs to be initialized.

> +
> +	if (ms_hyperv.ghcb_base) {
> +		ghcb_va =3D (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
> +		if (*ghcb_va)
> +			memunmap(*ghcb_va);
> +		*ghcb_va =3D NULL;
> +	}
>=20
>  	hv_common_cpu_die(cpu);
>=20
> @@ -383,9 +419,19 @@ void __init hyperv_init(void)
>  			VMALLOC_END, GFP_KERNEL, PAGE_KERNEL_ROX,
>  			VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
>  			__builtin_return_address(0));
> -	if (hv_hypercall_pg =3D=3D NULL) {
> -		wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
> -		goto remove_cpuhp_state;
> +	if (hv_hypercall_pg =3D=3D NULL)
> +		goto clean_guest_os_id;
> +
> +	if (hv_isolation_type_snp()) {
> +		ms_hyperv.ghcb_base =3D alloc_percpu(void *);
> +		if (!ms_hyperv.ghcb_base)
> +			goto clean_guest_os_id;
> +
> +		if (hyperv_init_ghcb()) {
> +			free_percpu(ms_hyperv.ghcb_base);
> +			ms_hyperv.ghcb_base =3D NULL;
> +			goto clean_guest_os_id;
> +		}

Having the GHCB setup code here splits the hypercall page setup into
two parts, which is unexpected.  First the memory is allocated
for the hypercall page, then the GHCB stuff is done, then the hypercall
MSR is setup.  Is there a need to do this split?  Also, if the GHCB stuff
fails and you goto clean_guest_os_id, the memory allocated for the
hypercall page is never freed.

It's also unexpected to have hyperv_init_ghcb() called here and called
in hv_cpu_init().  Wouldn't it be possible to setup ghcb_base *before*
cpu_setup_state() is called, so that hv_cpu_init() would take care of
calling hyperv_init_ghcb() for the boot CPU?  That's the pattern used
by the VP assist page, the percpu input page, etc.

>  	}
>=20
>  	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
> @@ -456,7 +502,8 @@ void __init hyperv_init(void)
>  	hv_query_ext_cap(0);
>  	return;
>=20
> -remove_cpuhp_state:
> +clean_guest_os_id:
> +	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
>  	cpuhp_remove_state(cpuhp);
>  free_vp_assist_page:
>  	kfree(hv_vp_assist_page);
> @@ -484,6 +531,9 @@ void hyperv_cleanup(void)
>  	 */
>  	hv_hypercall_pg =3D NULL;
>=20
> +	if (ms_hyperv.ghcb_base)
> +		free_percpu(ms_hyperv.ghcb_base);
> +

I don't think this cleanup is necessary.  The primary purpose of
hyperv_cleanup() is to ensure that things like overlay pages are
properly reset in Hyper-V before doing a kexec(), or before
panic'ing and running the kdump kernel.  There's no need to do
general memory free'ing in Linux.  Doing so just adds to the risk
that the panic path could itself fail.

>  	/* Reset the hypercall page */
>  	hypercall_msr.as_uint64 =3D 0;
>  	wrmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
> @@ -559,3 +609,11 @@ bool hv_is_isolation_supported(void)
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
> index adccbc209169..6627cfd2bfba 100644
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
> diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyper=
v.h
> index c1ab6a6e72b5..4269f3174e58 100644
> --- a/include/asm-generic/mshyperv.h
> +++ b/include/asm-generic/mshyperv.h
> @@ -36,6 +36,7 @@ struct ms_hyperv_info {
>  	u32 max_lp_index;
>  	u32 isolation_config_a;
>  	u32 isolation_config_b;
> +	void  __percpu **ghcb_base;

This doesn't feel like the right place to put this pointer.  The other
fields in the ms_hyperv_info structure are just fixed values obtained
from the CPUID instruction.   The existing patterns similar to ghcb_base
are the VP assist page and the percpu input and output args.  They are
all based on standalone global variables.  It would be more consistent
to do the same with the ghcb_base.

>  };
>  extern struct ms_hyperv_info ms_hyperv;
>=20
> @@ -237,6 +238,7 @@ bool hv_is_hyperv_initialized(void);
>  bool hv_is_hibernation_supported(void);
>  enum hv_isolation_type hv_get_isolation_type(void);
>  bool hv_is_isolation_supported(void);
> +bool hv_isolation_type_snp(void);
>  void hyperv_cleanup(void);
>  bool hv_query_ext_cap(u64 cap_query);
>  #else /* CONFIG_HYPERV */
> --
> 2.25.1

