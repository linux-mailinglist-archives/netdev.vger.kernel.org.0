Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B516D3EAACC
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 21:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbhHLTTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 15:19:01 -0400
Received: from mail-mw2nam12on2094.outbound.protection.outlook.com ([40.107.244.94]:56429
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233750AbhHLTS7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 15:18:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftWryGqzH6vvqKzIYFd1fo9gg3tixhYCixF+Wr005TEepGPCCaqMX17CkaongcoLbZtmUtp3fnXqwJY+bYdNwoeja6RgxMyoSxBnT8ChOq4JDvojC0Q65bHSO6g+gQ8HatzxFkVN+W9eNhvRL7WMhQWhefavo6o56IAAo6942aPQ5NlZIa7n2Cs2S4HHdTyfJnYKS9+QgdAo9Gaqsw5UPOpguubmZHzAu2QE5XSdUnzgTS5ZcqVG+i6KmvojsfAXxLCktwroNYdYRDze8zYsK+MrYHtIoGsJDiCbkRi4Qi0NsqfOMlbqg6K6Cvw+iG1kMQoEpEWCGuM80XLAMByNqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Ml/pDsLQ8y9j5HouSL5yGOSfNnF2kN6EzPfxU2Kbf0=;
 b=fKE0T92NgibawBd7zdFhAmADACvbJp5B5f7RxbwKKZ5dVLNZkYGUfi/nMIFvcleBzc28Vy26U58SIja/RfW7XNnGTuCvf92+G5FZ3OfpZEXhigPB9z9XYrDFw8FYsJopkGVlSozWjogYBs34p/+Xv28XpX6Yc8ioditCNg9UYBdcoGm9dOlNcQ1w5M1g0TrfjltxLbhlkGGgHttPYCzYeMyIgRvIitgF8bj4AfsdWNZsbWiTnkMhsOcCROBd+siv9p1f88LALWKa5ARBENUGFwsHqw/HlX/88pt29d+u5DV8Aq2vAwz6U4tMgM3gz5Ahras6xy45le2WtfeEBSri7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Ml/pDsLQ8y9j5HouSL5yGOSfNnF2kN6EzPfxU2Kbf0=;
 b=GbsBnOZdqcWwEMUfr9qsB+qIyRFp+JDDqP/Q92Y/aHF0DtQsQdaVW2XBAr1lfUYwQc4V9eJfCod7Mikdkm378fnthKduGUNrNFQbPqKKKGWX+4fc9VRi2fScdfnzMnXj9PAt5uNagHFfs8j4r5m/Bo7SAzPTqPW3U+MDqyGb1vI=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0861.namprd21.prod.outlook.com (2603:10b6:300:77::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.6; Thu, 12 Aug
 2021 19:18:30 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55%2]) with mapi id 15.20.4436.012; Thu, 12 Aug 2021
 19:18:30 +0000
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
Subject: RE: [PATCH V3 02/13] x86/HV: Initialize shared memory boundary in the
 Isolation VM.
Thread-Topic: [PATCH V3 02/13] x86/HV: Initialize shared memory boundary in
 the Isolation VM.
Thread-Index: AQHXjUfnHZ9QYgRpj0m0r+snbnmZg6twQiTQ
Date:   Thu, 12 Aug 2021 19:18:30 +0000
Message-ID: <MWHPR21MB159376E024639D8F0465BCA2D7F99@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-3-ltykernel@gmail.com>
In-Reply-To: <20210809175620.720923-3-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=554cbf34-fbb7-44b9-8159-933acafadcb9;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-12T19:15:02Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0e43c59-6a82-4e84-1131-08d95dc5f87a
x-ms-traffictypediagnostic: MWHPR21MB0861:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB086139FC4B3AE2C13677FF8BD7F99@MWHPR21MB0861.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k4h0lSuYoZKNBm7yODlYkyykM+eKlWUfkryGyFa6mwk7nbyBl0dgw7qf7/wl2nAss91euPoXtlEGtdyXp0w1mZhv2j8fZ/0h+0OUUUf/iWkHAaj1jf7XS/B53LDfzM4M8Qbum20FqU9gZSlZiL+s/xyXz5L38QDKhyVbzFOJkG4J6g4IlkCSSIr0hWd6M4EL7jwtM/Hx1OocwXF7rwrjU90mlfsa8uGq+a72+1ItmexgO0mNiYtNROns5TV8dIXdPYa6J0KtuK1E/rvuRkuHrQyCPjt0EqZOjOBQnkK5YevNAEWuxn4jwA/tnG16/34kBR6wr9rJezvyTR5lyeqdlf3GctBNDJWWwXD37EDSxJVDGcz6zzRtWniskslldJ6Wm6ZzbJ9J7mBX9X4grnS0kXU0fNUi76FLYzfBQS9bqmJQ4PH+IaaebMLF1qlz2/xUU406fqEXQoJHFQ3/nBX4QttsdYwcMh8DihlFWoMlKoBfaZd7iTkZLwt42BeDZ++u+qCJuf7MoOYh+fbI0n41RUDvGEo92cGcm6885Tu3cTbZZDxkX0HNMMuHh5C2fK37DCdW7P3z3PcmbB0SwVSZ4LaJanPmoKO//wd05Gmvw0xItoh0oyosYHAIbsJGkxHZgpjyOBGkxJfW8NI49u9EQ2uEEcNnXf6OqyTxoBZ9eVIQwHgZWt0/h0zkT9AdKN6A61dtEsXEOUzKv4Jt94Ec+GotrUadBKZ3YSdyIw4Ydqg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(5660300002)(110136005)(66946007)(54906003)(66556008)(508600001)(71200400001)(122000001)(64756008)(8676002)(66446008)(76116006)(316002)(33656002)(26005)(7696005)(52536014)(10290500003)(2906002)(186003)(55016002)(7416002)(38070700005)(7406005)(921005)(8936002)(9686003)(83380400001)(6506007)(53546011)(82950400001)(4326008)(82960400001)(8990500004)(38100700002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CH5vmLBRd+jug8MHuck4kGKLBac5ncTT2zkTplxQ1SJTLnC0ycSP+bFSFW3R?=
 =?us-ascii?Q?0HHt+kX+Vw1y44bkRGb80GZgX1LpNGajdP07FcMAEF6daimiXBDP69PMZqrY?=
 =?us-ascii?Q?FOORhqWIsvNMrO+gfyOH6x3Ht0vU+R2aWZEV6U38gkXKYupI6rcfMiLwARN9?=
 =?us-ascii?Q?M1asT87vQ6zzeobRahWhVoVmayaz0ON+47mfLUkEIJWeU3oZzBdBQAaQyqV2?=
 =?us-ascii?Q?WTyGMHhiYUaP3wrxxn3mBEbwlr3gmNIq17rT/KVxkafXBmAVkcHvpOrz6nNu?=
 =?us-ascii?Q?pvwmymyQEualti2M/4LoQzADPdWIxbbt4KF0eqeU34+2+bfVknDao5Z7srXH?=
 =?us-ascii?Q?34RjVXQ03qvDWLH0TXGwVF+g/T8J5Qc8JAd7c3W6aRw+b54sAqy1JPmB8nX0?=
 =?us-ascii?Q?5D9KkhCPw3cpFeqs1kRRTNCSLUF7ZwpExYg1llKLcyhCGWD0fYmwiU1z04EN?=
 =?us-ascii?Q?qSgAPXuVMkwVSpDXY2bKxNU8PmTytSLFQxS0S64fDDicEJxAQdoi7xPOs0gy?=
 =?us-ascii?Q?RdQYza7ilRMdSEZhsdzfIMkivo685k5PW30W6Uy8bXaztWduAfTEQek70eA2?=
 =?us-ascii?Q?cgG9tRfx/afTg/pqoJETJkKko5D6TrcWQ+FbgQvj3O8LGfwRIsc6WMhZN8ne?=
 =?us-ascii?Q?vx3knkXHnvbcLhYikECppUr4rjBEAuITRfZQl20OIupA/RblaSGQ5BZxpfcm?=
 =?us-ascii?Q?VsblSNQQz9ardZ8U3Qgwtgd637q9zEuryXl5H/vw/kUWcpYMCr70NaNR6wrr?=
 =?us-ascii?Q?wp5PEXWwadyWRL1Zm3v7VR3S7bJbcHPvLZsQL1/a24Hupd9C/yWqqnOY37R3?=
 =?us-ascii?Q?JRemBqtLwXUkzFiIPYN3YSDmTF6nao8c4cJ2w8+7m68SPKZDfsAqyIoBBVRg?=
 =?us-ascii?Q?A0j7bUolSUIN/Au4jI1s9GHpp6bG0s51aLnsOoHWvZjDfHQKXKxB7Fujomz0?=
 =?us-ascii?Q?ePvRKGqTgh03cAmD0se1Y+Pn7zJOZPnmB4jzpS+P+o1yUVsClEW/HY3a95p7?=
 =?us-ascii?Q?/WeoQMYLvaBOhsafO87P8NgV48f0y+xi3A3OhQ7gWQTh6NgCJQ5EDGDX65iY?=
 =?us-ascii?Q?EEwWzT/kji5+vtVko4M5K4oJgMI8YSzj6CcUGNP+59Lb7O4QzivPXIyJNGVW?=
 =?us-ascii?Q?U+1Hv3/qIXPlNm5JKGxEK+mrBPzXd1QnPqCB6cDkBJCkl7ljo6dZwoguql/f?=
 =?us-ascii?Q?XsiD+/DHY4NU18xTerZivtL5aB0sIsM9CoV2Wn7K8QOA+AiM0Nod9XFqAfi6?=
 =?us-ascii?Q?huzxLjrtsrUa1JKElngKuNT8E/fj1+DxNHhuYAEOi3F285VEMTquoZv+2R0b?=
 =?us-ascii?Q?rN0JHZ5szfphmrlWLznCoy8k?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0e43c59-6a82-4e84-1131-08d95dc5f87a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 19:18:30.7416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dTbwBIc20NOA+EWIaqRsudNGaQ8BeMq7shzU8tr3ThCtGGe5Wtx7pa7WF20ZojFJc78hP0wovlJniZwpiVCRmcNOePzSXW9w1mRs6NO3FOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Monday, August 9, 2021 10:56 A=
M
> Subject: [PATCH V3 02/13] x86/HV: Initialize shared memory boundary in th=
e Isolation VM.

As with Patch 1, use the "x86/hyperv:" tag in the Subject line.

>=20
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>=20
> Hyper-V exposes shared memory boundary via cpuid
> HYPERV_CPUID_ISOLATION_CONFIG and store it in the
> shared_gpa_boundary of ms_hyperv struct. This prepares
> to share memory with host for SNP guest.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  arch/x86/kernel/cpu/mshyperv.c |  2 ++
>  include/asm-generic/mshyperv.h | 12 +++++++++++-
>  2 files changed, 13 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyper=
v.c
> index 6b5835a087a3..2b7f396ef1a5 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -313,6 +313,8 @@ static void __init ms_hyperv_init_platform(void)
>  	if (ms_hyperv.priv_high & HV_ISOLATION) {
>  		ms_hyperv.isolation_config_a =3D cpuid_eax(HYPERV_CPUID_ISOLATION_CONF=
IG);
>  		ms_hyperv.isolation_config_b =3D cpuid_ebx(HYPERV_CPUID_ISOLATION_CONF=
IG);
> +		ms_hyperv.shared_gpa_boundary =3D
> +			(u64)1 << ms_hyperv.shared_gpa_boundary_bits;

You could use BIT_ULL() here, but it's kind of a shrug.

>=20
>  		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
>  			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
> diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyper=
v.h
> index 4269f3174e58..aa26d24a5ca9 100644
> --- a/include/asm-generic/mshyperv.h
> +++ b/include/asm-generic/mshyperv.h
> @@ -35,8 +35,18 @@ struct ms_hyperv_info {
>  	u32 max_vp_index;
>  	u32 max_lp_index;
>  	u32 isolation_config_a;
> -	u32 isolation_config_b;
> +	union {
> +		u32 isolation_config_b;
> +		struct {
> +			u32 cvm_type : 4;
> +			u32 Reserved11 : 1;
> +			u32 shared_gpa_boundary_active : 1;
> +			u32 shared_gpa_boundary_bits : 6;
> +			u32 Reserved12 : 20;

Any reason to name the reserved fields as "11" and "12"?  It
just looks a bit unusual.  And I'd suggest lowercase "r".

> +		};
> +	};
>  	void  __percpu **ghcb_base;
> +	u64 shared_gpa_boundary;
>  };
>  extern struct ms_hyperv_info ms_hyperv;
>=20
> --
> 2.25.1

