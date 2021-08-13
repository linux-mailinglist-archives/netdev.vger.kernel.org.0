Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B09B3EBC89
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 21:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbhHMTbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 15:31:41 -0400
Received: from mail-bn8nam12on2111.outbound.protection.outlook.com ([40.107.237.111]:25607
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229601AbhHMTbk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 15:31:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWJaxu7GN/aPdLTUyfcdv0QLmIrTYqv+39q25mOaftFC871Uw5hfnAhJ73nmycc9XgqmfWTT6hBlowNq0hXI1mFSx3BpAybLzcNlsJ9fLY0o4FcguiHex29ThrsbyBsGyTVhAwTi0dhgxFAlLsl+N2ctElm1hURE7icy0LmLdubOSoElRKlM2FkhYps4sn24b9soLm9oSTp4tA2rGjDEaxRMSp5fg/C3pRUCaOpduiaUzO8zPdfe4vHEYPIAGl9xA72dt14MV4VphItHg8tpGpTmTR54Y9oByrMj6lR9r8zp+lBmsuZu/3+5b4VsDpuM9nbIOaVptIyoKvPRlwkTvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0OFrDlirRTgp9grW+dRUWAvCttNe5zyD+0jp89Tm7Q=;
 b=N2FNKod0G56kPAkXBdf1a3Lv3VUDRLEv/kCEjxJCTnES3Kie3PGV0+sj1wcFEo+928Me2WLQxvnl/XF90nP0x78Oh+bDdmLgOM4Wr6iPtj6ZuMi+PKnrOJhZCkic5VI5ALkJN/SLAlrar1khW+fVpWVneDKn5lXmBmecNp+0BlwR+gF8o66CA3f7XG0AiNVy9/spwIfQBUdl94JdQwhXJMCNEyYf6NVuO0XJ0z2WBMb+6DkLIJ6dE0w0Cu0Cdto8wkgoSvUGTHztl/pTa11NyzOgSYEbZllEu30JPAu0HGbERqppH3low+B/DOFG6cQCAk7CVFNypCjvFab6JJybxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0OFrDlirRTgp9grW+dRUWAvCttNe5zyD+0jp89Tm7Q=;
 b=KwbGXdQwTCOmZxRDGn7Gow/4xF+KmYW2DShhUuxCbSmbYydr7gUnLrN7/4lp+khyPcHKiaUVg4h+0QL5MNh1v9PwXgD3tdYFt7eh6RLFzhxoWZgPvW+CNh/e6J+QiV4ZBexdSov4LHs6MzNlwrPtjeI1waSl/ul+bbZuwkkyI2A=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.5; Fri, 13 Aug
 2021 19:31:08 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55%2]) with mapi id 15.20.4436.012; Fri, 13 Aug 2021
 19:31:08 +0000
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
Subject: RE: [PATCH V3 05/13] HV: Add Write/Read MSR registers via ghcb page
Thread-Topic: [PATCH V3 05/13] HV: Add Write/Read MSR registers via ghcb page
Thread-Index: AQHXjUfuQqXPk5/9iUqTH41i8so9wqtxzWQQ
Date:   Fri, 13 Aug 2021 19:31:08 +0000
Message-ID: <MWHPR21MB15931FEC5CE9383B385C263CD7FA9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-6-ltykernel@gmail.com>
In-Reply-To: <20210809175620.720923-6-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d2377fda-39f2-4403-a606-910723ff0f1f;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-13T18:49:42Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97c79cf5-55d5-4806-cd45-08d95e90e664
x-ms-traffictypediagnostic: MW4PR21MB1953:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW4PR21MB19538DE1BA94379EA16F46EDD7FA9@MW4PR21MB1953.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:178;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: au52+EnZex4BLaEiMHMz8gya0QDg6AFZdlPDEkEzVIO8FzH2G4fo0Hna6OO6LC3DcejPIsYTdr/99E0r3nXTlDCXAWhD96eNapCkaYQxklMDIi0035FEB8liUBQwNXzLwwOxlUO4mICsoY/Sq/h6u9XuGYaCG9ff3WAu4SOxS8c5YIiof/T9jc/7BZObsDvlmig5D/r9ek8fHbZk8JlGgSrYtF6jm5N13KM9TMz/PVjV18g/xmgs4UF/gccjSK3Y9Fcz4pPtX8MeYYWgfwoR9jSxPQAzyu0HUmCxXKnZ8okh3n1zkEM3YFL0Ry5BHTEmqce1NfHK/8rg8pKEVeB5oi/1W9Lvr8/JRe6VktUSK8arhCmubs+WUJZpihqHbPND54lAg/x5mBKA12wsHAmi9nqs5HHS6YJ0XXl6IWmB/PY+DMgPEasQterTtWqQz3nnPCmQaubzA2OlmRjoFeR7u8LT+BAv6tl6jTxTWCDhIsDRINVibP/A657f/RH/tq89DnosZwM/iWmnCLJqxcQi3IPNDM3W94zmet9KAedAIaepKXHOWbw2yTw3DW7dZPlfmisT74oc+DRba91Cq7FBJK3rIGqQlVqeO41lCJXG1Wy6Bm3+Miu/uBXrbsnMYLvmSYF6cGTGqWtPYOAOXMLLRyqv+vKO/Yqm9C/rERXdQae0xxYUoiYYpGZ7Qz0GY1hWkzQMj/rGeouNCXNlkBgbH6r77NpVlD5Z//AkdUVfETQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(66476007)(52536014)(8676002)(76116006)(26005)(38100700002)(66556008)(186003)(55016002)(921005)(64756008)(66446008)(53546011)(7696005)(9686003)(38070700005)(6506007)(122000001)(7416002)(83380400001)(33656002)(54906003)(5660300002)(7406005)(316002)(110136005)(4326008)(8990500004)(8936002)(71200400001)(66946007)(10290500003)(508600001)(82950400001)(82960400001)(86362001)(30864003)(559001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KgmMrBmhTIw7tuG8WTTrU2Djnik1N5qdqROFwWn5B+iHe752lBv+yoKtVIPb?=
 =?us-ascii?Q?j+EmofG2ZOpTWI7kFZmcVs+liJuFkBeWiyXYMYYXdzluzfOCKlRMF7dh9jQg?=
 =?us-ascii?Q?bZMQR453XTNGkWk4SKdo6D+ad5FTUQkDDYuHpLd6CZBVASX6tKIdlhmwEMwF?=
 =?us-ascii?Q?kgru1mZfXN3P6tiyq5faVMZn+JwtwGAviknvZp1on7A/aCU0FQXOobdz3HS3?=
 =?us-ascii?Q?rBl2PAp2L0ZBfrQqdfNCe0NbQUOCI39HhB4zkZWEVggK2Rrl2vcnaiRf8WL2?=
 =?us-ascii?Q?03qcnwI1xVW2FaoWgQa414wc7HzItC4zn0anR0RhdgHRjIClFyBKLNy9ufBA?=
 =?us-ascii?Q?kS/Lf1xC1huHDwd8ZgVxXOOUnedchRsDk6cww/74C67hyPMsKD6g08VIzOHn?=
 =?us-ascii?Q?PX5H6o2TpcvremviXYB39MieEQ9VyM8o7qLPnbSPnIE9aO5Z57JalJ6WNyDf?=
 =?us-ascii?Q?AVejdzN7ki+I0ZHfuQpeN3L53sI+FJnU4mvJnc8J9h6FG1m5N2Bk8Fvh6m8j?=
 =?us-ascii?Q?mSfQF4Vj35M1vgYsDdx42mEugEVrQ0N6cSbBMcTs5bEc21K25cTlkP7im8dA?=
 =?us-ascii?Q?HSXoOYtcCAVeyZS7X0MTsvXk+TP0BiyqXLsPCua1QEzxYpxML16nQIYo7XZv?=
 =?us-ascii?Q?az1od99pZtEbPSIKmsOL2KDKOmw09oW9+QdG6NrONK9uU0C9MFdHdwPkzaqe?=
 =?us-ascii?Q?M+I+33LneXPKftOvGlUMTbJ5lXqf4t96y2JeBVbnMo9joePORoglBzj4VSNj?=
 =?us-ascii?Q?RuQEuu2sduaFsbDS3EdeQhICKwqS4dgcEtGKkspbvB63gV5/KGYRLtWHiS83?=
 =?us-ascii?Q?lILCG/E+YJli/nvSLrc3uh7AGlDaXgUBNU+Vv07uGKEgLamGK1quiTp4xx40?=
 =?us-ascii?Q?0vqOg/S8UC2k23n7Jmxyt82V/YvUz4Hc7FRvf+fsPm23ze1gUqW0/bsC2A/t?=
 =?us-ascii?Q?n8vJHUTxn3aixOnmhE5lJJPFg3+wuhad5z3O2lHammMFm6AeUW00vbHMKj5G?=
 =?us-ascii?Q?v93OhhSJDjdae3Rrw5odsCI6NP23AyzScZCoOamfultTRgnfbYPfpLrlMeXT?=
 =?us-ascii?Q?zw7p56ZPa4ojpePwKEk5k49U56WXSITK0xFQU0qaeGhPhMW7RzfyyK6jpgUZ?=
 =?us-ascii?Q?jq24RP9XXnsuqiAs2nQKhbQbNzDycTrCnOovRmuWVOz9gEWOsMobzgAIClrW?=
 =?us-ascii?Q?IMvv2r+rZ91ryqnrtwSDSbm2Bq0cvBk+ih/mLQED12ugMF2IKrKp19ib19U0?=
 =?us-ascii?Q?1MfiZ0Lw4J3UIf7q6WhPmtuuyFv5Mkfc8GERjGctOnfrVbpVOxoaJA50w+6j?=
 =?us-ascii?Q?a1fsOLYUoyL4Zn44P2Y0Qg26?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97c79cf5-55d5-4806-cd45-08d95e90e664
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2021 19:31:08.0344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ESTBDW2syx1QGsd4Vbii4VFaFQ1+pPdtm3iH5SJclBYZcc3l/Tss08Jtd8NALjweW9OeDGULNraQFsk5WBR766Q2w66Qs5m/Cb3HEpaUKAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1953
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Monday, August 9, 2021 10:56 A=
M
> Subject: [PATCH V3 05/13] HV: Add Write/Read MSR registers via ghcb page

See previous comments about tag in the Subject line.

> Hyper-V provides GHCB protocol to write Synthetic Interrupt
> Controller MSR registers in Isolation VM with AMD SEV SNP
> and these registers are emulated by hypervisor directly.
> Hyper-V requires to write SINTx MSR registers twice. First
> writes MSR via GHCB page to communicate with hypervisor
> and then writes wrmsr instruction to talk with paravisor
> which runs in VMPL0. Guest OS ID MSR also needs to be set
> via GHCB.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v1:
>          * Introduce sev_es_ghcb_hv_call_simple() and share code
>            between SEV and Hyper-V code.
> ---
>  arch/x86/hyperv/hv_init.c       |  33 ++-------
>  arch/x86/hyperv/ivm.c           | 110 +++++++++++++++++++++++++++++
>  arch/x86/include/asm/mshyperv.h |  78 +++++++++++++++++++-
>  arch/x86/include/asm/sev.h      |   3 +
>  arch/x86/kernel/cpu/mshyperv.c  |   3 +
>  arch/x86/kernel/sev-shared.c    |  63 ++++++++++-------
>  drivers/hv/hv.c                 | 121 ++++++++++++++++++++++----------
>  include/asm-generic/mshyperv.h  |  12 +++-
>  8 files changed, 329 insertions(+), 94 deletions(-)
>=20
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index b3683083208a..ab0b33f621e7 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -423,7 +423,7 @@ void __init hyperv_init(void)
>  		goto clean_guest_os_id;
>=20
>  	if (hv_isolation_type_snp()) {
> -		ms_hyperv.ghcb_base =3D alloc_percpu(void *);
> +		ms_hyperv.ghcb_base =3D alloc_percpu(union hv_ghcb __percpu *);

union hv_ghcb isn't defined.  It is not added until patch 6 of the series.

>  		if (!ms_hyperv.ghcb_base)
>  			goto clean_guest_os_id;
>=20
> @@ -432,6 +432,9 @@ void __init hyperv_init(void)
>  			ms_hyperv.ghcb_base =3D NULL;
>  			goto clean_guest_os_id;
>  		}
> +
> +		/* Hyper-V requires to write guest os id via ghcb in SNP IVM. */
> +		hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, guest_id);
>  	}
>=20
>  	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
> @@ -523,6 +526,7 @@ void hyperv_cleanup(void)
>=20
>  	/* Reset our OS id */
>  	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
> +	hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, 0);
>=20
>  	/*
>  	 * Reset hypercall page reference before reset the page,
> @@ -596,30 +600,3 @@ bool hv_is_hyperv_initialized(void)
>  	return hypercall_msr.enable;
>  }
>  EXPORT_SYMBOL_GPL(hv_is_hyperv_initialized);
> -
> -enum hv_isolation_type hv_get_isolation_type(void)
> -{
> -	if (!(ms_hyperv.priv_high & HV_ISOLATION))
> -		return HV_ISOLATION_TYPE_NONE;
> -	return FIELD_GET(HV_ISOLATION_TYPE, ms_hyperv.isolation_config_b);
> -}
> -EXPORT_SYMBOL_GPL(hv_get_isolation_type);
> -
> -bool hv_is_isolation_supported(void)
> -{
> -	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
> -		return 0;
> -
> -	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
> -		return 0;
> -
> -	return hv_get_isolation_type() !=3D HV_ISOLATION_TYPE_NONE;
> -}
> -
> -DEFINE_STATIC_KEY_FALSE(isolation_type_snp);
> -
> -bool hv_isolation_type_snp(void)
> -{
> -	return static_branch_unlikely(&isolation_type_snp);
> -}
> -EXPORT_SYMBOL_GPL(hv_isolation_type_snp);
> diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
> index 8c905ffdba7f..ec0e5c259740 100644
> --- a/arch/x86/hyperv/ivm.c
> +++ b/arch/x86/hyperv/ivm.c
> @@ -6,6 +6,8 @@
>   *  Tianyu Lan <Tianyu.Lan@microsoft.com>
>   */
>=20
> +#include <linux/types.h>
> +#include <linux/bitfield.h>
>  #include <linux/hyperv.h>
>  #include <linux/types.h>
>  #include <linux/bitfield.h>
> @@ -13,6 +15,114 @@
>  #include <asm/io.h>
>  #include <asm/mshyperv.h>
>=20
> +void hv_ghcb_msr_write(u64 msr, u64 value)
> +{
> +	union hv_ghcb *hv_ghcb;
> +	void **ghcb_base;
> +	unsigned long flags;
> +
> +	if (!ms_hyperv.ghcb_base)
> +		return;
> +
> +	WARN_ON(in_nmi());
> +
> +	local_irq_save(flags);
> +	ghcb_base =3D (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
> +	hv_ghcb =3D (union hv_ghcb *)*ghcb_base;
> +	if (!hv_ghcb) {
> +		local_irq_restore(flags);
> +		return;
> +	}
> +
> +	ghcb_set_rcx(&hv_ghcb->ghcb, msr);
> +	ghcb_set_rax(&hv_ghcb->ghcb, lower_32_bits(value));
> +	ghcb_set_rdx(&hv_ghcb->ghcb, value >> 32);

Having used lower_32_bits() in the previous line, perhaps use
upper_32_bits() here?

> +
> +	if (sev_es_ghcb_hv_call_simple(&hv_ghcb->ghcb, SVM_EXIT_MSR, 1, 0))
> +		pr_warn("Fail to write msr via ghcb %llx.\n", msr);
> +
> +	local_irq_restore(flags);
> +}
> +
> +void hv_ghcb_msr_read(u64 msr, u64 *value)
> +{
> +	union hv_ghcb *hv_ghcb;
> +	void **ghcb_base;
> +	unsigned long flags;
> +
> +	if (!ms_hyperv.ghcb_base)
> +		return;
> +
> +	WARN_ON(in_nmi());
> +
> +	local_irq_save(flags);
> +	ghcb_base =3D (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
> +	hv_ghcb =3D (union hv_ghcb *)*ghcb_base;
> +	if (!hv_ghcb) {
> +		local_irq_restore(flags);
> +		return;
> +	}
> +
> +	ghcb_set_rcx(&hv_ghcb->ghcb, msr);
> +	if (sev_es_ghcb_hv_call_simple(&hv_ghcb->ghcb, SVM_EXIT_MSR, 0, 0))
> +		pr_warn("Fail to read msr via ghcb %llx.\n", msr);
> +	else
> +		*value =3D (u64)lower_32_bits(hv_ghcb->ghcb.save.rax)
> +			| ((u64)lower_32_bits(hv_ghcb->ghcb.save.rdx) << 32);
> +	local_irq_restore(flags);
> +}
> +
> +void hv_sint_rdmsrl_ghcb(u64 msr, u64 *value)
> +{
> +	hv_ghcb_msr_read(msr, value);
> +}
> +EXPORT_SYMBOL_GPL(hv_sint_rdmsrl_ghcb);
> +
> +void hv_sint_wrmsrl_ghcb(u64 msr, u64 value)
> +{
> +	hv_ghcb_msr_write(msr, value);
> +
> +	/* Write proxy bit vua wrmsrl instruction. */

s/vua/via/

> +	if (msr >=3D HV_X64_MSR_SINT0 && msr <=3D HV_X64_MSR_SINT15)
> +		wrmsrl(msr, value | 1 << 20);
> +}
> +EXPORT_SYMBOL_GPL(hv_sint_wrmsrl_ghcb);
> +
> +void hv_signal_eom_ghcb(void)
> +{
> +	hv_sint_wrmsrl_ghcb(HV_X64_MSR_EOM, 0);
> +}
> +EXPORT_SYMBOL_GPL(hv_signal_eom_ghcb);

Is there a reason for this to be a function instead of a #define?
Seemingly parallel calls such as  hv_set_synic_state_ghcb()
are #defines.

> +
> +enum hv_isolation_type hv_get_isolation_type(void)
> +{
> +	if (!(ms_hyperv.priv_high & HV_ISOLATION))
> +		return HV_ISOLATION_TYPE_NONE;
> +	return FIELD_GET(HV_ISOLATION_TYPE, ms_hyperv.isolation_config_b);
> +}
> +EXPORT_SYMBOL_GPL(hv_get_isolation_type);
> +
> +/*
> + * hv_is_isolation_supported - Check system runs in the Hyper-V
> + * isolation VM.
> + */
> +bool hv_is_isolation_supported(void)
> +{
> +	return hv_get_isolation_type() !=3D HV_ISOLATION_TYPE_NONE;
> +}
> +
> +DEFINE_STATIC_KEY_FALSE(isolation_type_snp);
> +
> +/*
> + * hv_isolation_type_snp - Check system runs in the AMD SEV-SNP based
> + * isolation VM.
> + */
> +bool hv_isolation_type_snp(void)
> +{
> +	return static_branch_unlikely(&isolation_type_snp);
> +}
> +EXPORT_SYMBOL_GPL(hv_isolation_type_snp);
> +

hv_isolation_type_snp() is implemented here in a file under arch/x86,
but it is called from architecture independent code in drivers/hv, so it
needs to do the right thing on ARM64 as well as x86.  For an example,
see the handling of hv_is_isolation_supported() in the latest linux-next
tree.

>  /*
>   * hv_mark_gpa_visibility - Set pages visible to host via hvcall.
>   *
> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyp=
erv.h
> index 87a386fa97f7..730985676ea3 100644
> --- a/arch/x86/include/asm/mshyperv.h
> +++ b/arch/x86/include/asm/mshyperv.h
> @@ -30,6 +30,63 @@ static inline u64 hv_get_register(unsigned int reg)
>  	return value;
>  }
>=20
> +#define hv_get_sint_reg(val, reg) {		\
> +	if (hv_isolation_type_snp())		\
> +		hv_get_##reg##_ghcb(&val);	\
> +	else					\
> +		rdmsrl(HV_X64_MSR_##reg, val);	\
> +	}
> +
> +#define hv_set_sint_reg(val, reg) {		\
> +	if (hv_isolation_type_snp())		\
> +		hv_set_##reg##_ghcb(val);	\
> +	else					\
> +		wrmsrl(HV_X64_MSR_##reg, val);	\
> +	}
> +
> +
> +#define hv_get_simp(val) hv_get_sint_reg(val, SIMP)
> +#define hv_get_siefp(val) hv_get_sint_reg(val, SIEFP)
> +
> +#define hv_set_simp(val) hv_set_sint_reg(val, SIMP)
> +#define hv_set_siefp(val) hv_set_sint_reg(val, SIEFP)
> +
> +#define hv_get_synic_state(val) {			\
> +	if (hv_isolation_type_snp())			\
> +		hv_get_synic_state_ghcb(&val);		\
> +	else						\
> +		rdmsrl(HV_X64_MSR_SCONTROL, val);	\

Many of these registers that exist on x86 and ARM64 architectures
have new names without the "X64_MSR" portion.  For
example, include/asm-generic/hyperv-tlfs.h defines
HV_REGISTER_SCONTROL.  The x86-specific version of=20
hyperv-tlfs.h currently has a #define for HV_X64_MSR_SCONTROL,
but we would like to get rid of these temporary aliases.
So prefer to use HV_REGISTER_SCONTROL.

Same comment applies several places in this code for other
similar registers.

> +	}
> +#define hv_set_synic_state(val) {			\
> +	if (hv_isolation_type_snp())			\
> +		hv_set_synic_state_ghcb(val);		\
> +	else						\
> +		wrmsrl(HV_X64_MSR_SCONTROL, val);	\
> +	}
> +
> +#define hv_get_vp_index(index) rdmsrl(HV_X64_MSR_VP_INDEX, index)
> +
> +#define hv_signal_eom() {			 \
> +	if (hv_isolation_type_snp() &&		 \
> +	    old_msg_type !=3D HVMSG_TIMER_EXPIRED) \

Why is a test of the old_msg_type embedded in this macro?
And given that old_msg_type isn't a parameter of the
macro, its use is really weird.

> +		hv_signal_eom_ghcb();		 \
> +	else					 \
> +		wrmsrl(HV_X64_MSR_EOM, 0);	 \
> +	}
> +
> +#define hv_get_synint_state(int_num, val) {		\
> +	if (hv_isolation_type_snp())			\0
> +		hv_get_synint_state_ghcb(int_num, &val);\
> +	else						\
> +		rdmsrl(HV_X64_MSR_SINT0 + int_num, val);\
> +	}
> +#define hv_set_synint_state(int_num, val) {		\
> +	if (hv_isolation_type_snp())			\
> +		hv_set_synint_state_ghcb(int_num, val);	\
> +	else						\
> +		wrmsrl(HV_X64_MSR_SINT0 + int_num, val);\
> +	}
> +
>  #define hv_get_raw_timer() rdtsc_ordered()
>=20
>  void hyperv_vector_handler(struct pt_regs *regs);
> @@ -193,6 +250,25 @@ int hv_unmap_ioapic_interrupt(int ioapic_id, struct =
hv_interrupt_entry *entry);
>  int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
>  			   enum hv_mem_host_visibility visibility);
>  int hv_set_mem_host_visibility(unsigned long addr, int numpages, bool vi=
sible);
> +void hv_sint_wrmsrl_ghcb(u64 msr, u64 value);
> +void hv_sint_rdmsrl_ghcb(u64 msr, u64 *value);
> +void hv_signal_eom_ghcb(void);
> +void hv_ghcb_msr_write(u64 msr, u64 value);
> +void hv_ghcb_msr_read(u64 msr, u64 *value);
> +
> +#define hv_get_synint_state_ghcb(int_num, val)			\
> +	hv_sint_rdmsrl_ghcb(HV_X64_MSR_SINT0 + int_num, val)
> +#define hv_set_synint_state_ghcb(int_num, val) \
> +	hv_sint_wrmsrl_ghcb(HV_X64_MSR_SINT0 + int_num, val)
> +
> +#define hv_get_SIMP_ghcb(val) hv_sint_rdmsrl_ghcb(HV_X64_MSR_SIMP, val)
> +#define hv_set_SIMP_ghcb(val) hv_sint_wrmsrl_ghcb(HV_X64_MSR_SIMP, val)
> +
> +#define hv_get_SIEFP_ghcb(val) hv_sint_rdmsrl_ghcb(HV_X64_MSR_SIEFP, val=
)
> +#define hv_set_SIEFP_ghcb(val) hv_sint_wrmsrl_ghcb(HV_X64_MSR_SIEFP, val=
)
> +
> +#define hv_get_synic_state_ghcb(val) hv_sint_rdmsrl_ghcb(HV_X64_MSR_SCON=
TROL, val)
> +#define hv_set_synic_state_ghcb(val) hv_sint_wrmsrl_ghcb(HV_X64_MSR_SCON=
TROL, val)
>  #else /* CONFIG_HYPERV */
>  static inline void hyperv_init(void) {}
>  static inline void hyperv_setup_mmu_ops(void) {}
> @@ -209,9 +285,9 @@ static inline int hyperv_flush_guest_mapping_range(u6=
4 as,
>  {
>  	return -1;
>  }
> +static inline void hv_signal_eom_ghcb(void) { };
>  #endif /* CONFIG_HYPERV */
>=20
> -
>  #include <asm-generic/mshyperv.h>
>=20
>  #endif
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index fa5cd05d3b5b..81beb2a8031b 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -81,6 +81,9 @@ static __always_inline void sev_es_nmi_complete(void)
>  		__sev_es_nmi_complete();
>  }
>  extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
> +extern enum es_result sev_es_ghcb_hv_call_simple(struct ghcb *ghcb,
> +				   u64 exit_code, u64 exit_info_1,
> +				   u64 exit_info_2);
>  #else
>  static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>  static inline void sev_es_ist_exit(void) { }
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyper=
v.c
> index 2b7f396ef1a5..3633f871ac1e 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -318,6 +318,9 @@ static void __init ms_hyperv_init_platform(void)
>=20
>  		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
>  			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
> +
> +		if (hv_get_isolation_type() =3D=3D HV_ISOLATION_TYPE_SNP)
> +			static_branch_enable(&isolation_type_snp);
>  	}
>=20
>  	if (hv_max_functions_eax >=3D HYPERV_CPUID_NESTED_FEATURES) {
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 9f90f460a28c..dd7f37de640b 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -94,10 +94,9 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
>  	ctxt->regs->ip +=3D ctxt->insn.length;
>  }
>=20
> -static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> -					  struct es_em_ctxt *ctxt,
> -					  u64 exit_code, u64 exit_info_1,
> -					  u64 exit_info_2)
> +enum es_result sev_es_ghcb_hv_call_simple(struct ghcb *ghcb,
> +				   u64 exit_code, u64 exit_info_1,
> +				   u64 exit_info_2)
>  {
>  	enum es_result ret;
>=20
> @@ -109,29 +108,45 @@ static enum es_result sev_es_ghcb_hv_call(struct gh=
cb *ghcb,
>  	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
>  	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
>=20
> -	sev_es_wr_ghcb_msr(__pa(ghcb));
>  	VMGEXIT();
>=20
> -	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) =3D=3D 1) {
> -		u64 info =3D ghcb->save.sw_exit_info_2;
> -		unsigned long v;
> -
> -		info =3D ghcb->save.sw_exit_info_2;
> -		v =3D info & SVM_EVTINJ_VEC_MASK;
> -
> -		/* Check if exception information from hypervisor is sane. */
> -		if ((info & SVM_EVTINJ_VALID) &&
> -		    ((v =3D=3D X86_TRAP_GP) || (v =3D=3D X86_TRAP_UD)) &&
> -		    ((info & SVM_EVTINJ_TYPE_MASK) =3D=3D SVM_EVTINJ_TYPE_EXEPT)) {
> -			ctxt->fi.vector =3D v;
> -			if (info & SVM_EVTINJ_VALID_ERR)
> -				ctxt->fi.error_code =3D info >> 32;
> -			ret =3D ES_EXCEPTION;
> -		} else {
> -			ret =3D ES_VMM_ERROR;
> -		}
> -	} else {
> +	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) =3D=3D 1)
> +		ret =3D ES_VMM_ERROR;
> +	else
>  		ret =3D ES_OK;
> +
> +	return ret;
> +}
> +
> +static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +				   struct es_em_ctxt *ctxt,
> +				   u64 exit_code, u64 exit_info_1,
> +				   u64 exit_info_2)
> +{
> +	unsigned long v;
> +	enum es_result ret;
> +	u64 info;
> +
> +	sev_es_wr_ghcb_msr(__pa(ghcb));
> +
> +	ret =3D sev_es_ghcb_hv_call_simple(ghcb, exit_code, exit_info_1,
> +					 exit_info_2);
> +	if (ret =3D=3D ES_OK)
> +		return ret;
> +
> +	info =3D ghcb->save.sw_exit_info_2;
> +	v =3D info & SVM_EVTINJ_VEC_MASK;
> +
> +	/* Check if exception information from hypervisor is sane. */
> +	if ((info & SVM_EVTINJ_VALID) &&
> +	    ((v =3D=3D X86_TRAP_GP) || (v =3D=3D X86_TRAP_UD)) &&
> +	    ((info & SVM_EVTINJ_TYPE_MASK) =3D=3D SVM_EVTINJ_TYPE_EXEPT)) {
> +		ctxt->fi.vector =3D v;
> +		if (info & SVM_EVTINJ_VALID_ERR)
> +			ctxt->fi.error_code =3D info >> 32;
> +		ret =3D ES_EXCEPTION;
> +	} else {
> +		ret =3D ES_VMM_ERROR;
>  	}
>=20
>  	return ret;
> diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
> index e83507f49676..59f7173c4d9f 100644
> --- a/drivers/hv/hv.c
> +++ b/drivers/hv/hv.c
> @@ -8,6 +8,7 @@
>   */
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>=20
> +#include <linux/io.h>
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
>  #include <linux/slab.h>
> @@ -136,17 +137,24 @@ int hv_synic_alloc(void)
>  		tasklet_init(&hv_cpu->msg_dpc,
>  			     vmbus_on_msg_dpc, (unsigned long) hv_cpu);
>=20
> -		hv_cpu->synic_message_page =3D
> -			(void *)get_zeroed_page(GFP_ATOMIC);
> -		if (hv_cpu->synic_message_page =3D=3D NULL) {
> -			pr_err("Unable to allocate SYNIC message page\n");
> -			goto err;
> -		}
> +		/*
> +		 * Synic message and event pages are allocated by paravisor.
> +		 * Skip these pages allocation here.
> +		 */
> +		if (!hv_isolation_type_snp()) {
> +			hv_cpu->synic_message_page =3D
> +				(void *)get_zeroed_page(GFP_ATOMIC);
> +			if (hv_cpu->synic_message_page =3D=3D NULL) {
> +				pr_err("Unable to allocate SYNIC message page\n");
> +				goto err;
> +			}
>=20
> -		hv_cpu->synic_event_page =3D (void *)get_zeroed_page(GFP_ATOMIC);
> -		if (hv_cpu->synic_event_page =3D=3D NULL) {
> -			pr_err("Unable to allocate SYNIC event page\n");
> -			goto err;
> +			hv_cpu->synic_event_page =3D
> +				(void *)get_zeroed_page(GFP_ATOMIC);
> +			if (hv_cpu->synic_event_page =3D=3D NULL) {
> +				pr_err("Unable to allocate SYNIC event page\n");
> +				goto err;
> +			}
>  		}
>=20
>  		hv_cpu->post_msg_page =3D (void *)get_zeroed_page(GFP_ATOMIC);
> @@ -173,10 +181,17 @@ void hv_synic_free(void)
>  	for_each_present_cpu(cpu) {
>  		struct hv_per_cpu_context *hv_cpu
>  			=3D per_cpu_ptr(hv_context.cpu_context, cpu);
> +		free_page((unsigned long)hv_cpu->post_msg_page);
> +
> +		/*
> +		 * Synic message and event pages are allocated by paravisor.
> +		 * Skip free these pages here.
> +		 */
> +		if (hv_isolation_type_snp())
> +			continue;
>=20
>  		free_page((unsigned long)hv_cpu->synic_event_page);
>  		free_page((unsigned long)hv_cpu->synic_message_page);
> -		free_page((unsigned long)hv_cpu->post_msg_page);

You could skip making these changes to hv_synic_free().  If the message
and event pages aren't allocated, the pointers will be NULL and
free_page() will happily do nothing.

>  	}
>=20
>  	kfree(hv_context.hv_numa_map);
> @@ -199,26 +214,43 @@ void hv_synic_enable_regs(unsigned int cpu)
>  	union hv_synic_scontrol sctrl;
>=20
>  	/* Setup the Synic's message page */
> -	simp.as_uint64 =3D hv_get_register(HV_REGISTER_SIMP);
> +	hv_get_simp(simp.as_uint64);

This code is intended to be architecture independent and builds for
x86 and for ARM64.  Changing the use of hv_get_register() and hv_set_regist=
er()
will fail badly when built for ARM64.   I haven't completely thought throug=
h
what the best solution might be, but the current set of mappings from
hv_get_simp() down to hv_ghcb_msr_read() isn't going to work on ARM64.

Is it possible to hide all the x86-side complexity in the implementation of
hv_get_register()?   Certain MSRs would have to be special-cased when
SNP isolation is enabled, but that might be easier than trying to no-op out
the ghcb machinery on the ARM64 side.=20

>  	simp.simp_enabled =3D 1;
> -	simp.base_simp_gpa =3D virt_to_phys(hv_cpu->synic_message_page)
> -		>> HV_HYP_PAGE_SHIFT;
>=20
> -	hv_set_register(HV_REGISTER_SIMP, simp.as_uint64);
> +	if (hv_isolation_type_snp()) {
> +		hv_cpu->synic_message_page
> +			=3D memremap(simp.base_simp_gpa << HV_HYP_PAGE_SHIFT,
> +				   HV_HYP_PAGE_SIZE, MEMREMAP_WB);
> +		if (!hv_cpu->synic_message_page)
> +			pr_err("Fail to map syinc message page.\n");
> +	} else {
> +		simp.base_simp_gpa =3D virt_to_phys(hv_cpu->synic_message_page)
> +			>> HV_HYP_PAGE_SHIFT;
> +	}
> +
> +	hv_set_simp(simp.as_uint64);
>=20
>  	/* Setup the Synic's event page */
> -	siefp.as_uint64 =3D hv_get_register(HV_REGISTER_SIEFP);
> +	hv_get_siefp(siefp.as_uint64);
>  	siefp.siefp_enabled =3D 1;
> -	siefp.base_siefp_gpa =3D virt_to_phys(hv_cpu->synic_event_page)
> -		>> HV_HYP_PAGE_SHIFT;
>=20
> -	hv_set_register(HV_REGISTER_SIEFP, siefp.as_uint64);
> +	if (hv_isolation_type_snp()) {
> +		hv_cpu->synic_event_page =3D
> +			memremap(siefp.base_siefp_gpa << HV_HYP_PAGE_SHIFT,
> +				 HV_HYP_PAGE_SIZE, MEMREMAP_WB);
> +
> +		if (!hv_cpu->synic_event_page)
> +			pr_err("Fail to map syinc event page.\n");
> +	} else {
> +		siefp.base_siefp_gpa =3D virt_to_phys(hv_cpu->synic_event_page)
> +			>> HV_HYP_PAGE_SHIFT;
> +	}
> +	hv_set_siefp(siefp.as_uint64);
>=20
>  	/* Setup the shared SINT. */
>  	if (vmbus_irq !=3D -1)
>  		enable_percpu_irq(vmbus_irq, 0);
> -	shared_sint.as_uint64 =3D hv_get_register(HV_REGISTER_SINT0 +
> -					VMBUS_MESSAGE_SINT);
> +	hv_get_synint_state(VMBUS_MESSAGE_SINT, shared_sint.as_uint64);
>=20
>  	shared_sint.vector =3D vmbus_interrupt;
>  	shared_sint.masked =3D false;
> @@ -233,14 +265,12 @@ void hv_synic_enable_regs(unsigned int cpu)
>  #else
>  	shared_sint.auto_eoi =3D 0;
>  #endif
> -	hv_set_register(HV_REGISTER_SINT0 + VMBUS_MESSAGE_SINT,
> -				shared_sint.as_uint64);
> +	hv_set_synint_state(VMBUS_MESSAGE_SINT, shared_sint.as_uint64);
>=20
>  	/* Enable the global synic bit */
> -	sctrl.as_uint64 =3D hv_get_register(HV_REGISTER_SCONTROL);
> +	hv_get_synic_state(sctrl.as_uint64);
>  	sctrl.enable =3D 1;
> -
> -	hv_set_register(HV_REGISTER_SCONTROL, sctrl.as_uint64);
> +	hv_set_synic_state(sctrl.as_uint64);
>  }
>=20
>  int hv_synic_init(unsigned int cpu)
> @@ -257,37 +287,50 @@ int hv_synic_init(unsigned int cpu)
>   */
>  void hv_synic_disable_regs(unsigned int cpu)
>  {
> +	struct hv_per_cpu_context *hv_cpu
> +		=3D per_cpu_ptr(hv_context.cpu_context, cpu);
>  	union hv_synic_sint shared_sint;
>  	union hv_synic_simp simp;
>  	union hv_synic_siefp siefp;
>  	union hv_synic_scontrol sctrl;
>=20
> -	shared_sint.as_uint64 =3D hv_get_register(HV_REGISTER_SINT0 +
> -					VMBUS_MESSAGE_SINT);
> -
> +	hv_get_synint_state(VMBUS_MESSAGE_SINT, shared_sint.as_uint64);
>  	shared_sint.masked =3D 1;
> +	hv_set_synint_state(VMBUS_MESSAGE_SINT, shared_sint.as_uint64);
> +
>=20
>  	/* Need to correctly cleanup in the case of SMP!!! */
>  	/* Disable the interrupt */
> -	hv_set_register(HV_REGISTER_SINT0 + VMBUS_MESSAGE_SINT,
> -				shared_sint.as_uint64);
> +	hv_get_simp(simp.as_uint64);
>=20
> -	simp.as_uint64 =3D hv_get_register(HV_REGISTER_SIMP);
> +	/*
> +	 * In Isolation VM, sim and sief pages are allocated by
> +	 * paravisor. These pages also will be used by kdump
> +	 * kernel. So just reset enable bit here and keep page
> +	 * addresses.
> +	 */
>  	simp.simp_enabled =3D 0;
> -	simp.base_simp_gpa =3D 0;
> +	if (hv_isolation_type_snp())
> +		memunmap(hv_cpu->synic_message_page);
> +	else
> +		simp.base_simp_gpa =3D 0;
>=20
> -	hv_set_register(HV_REGISTER_SIMP, simp.as_uint64);
> +	hv_set_simp(simp.as_uint64);
>=20
> -	siefp.as_uint64 =3D hv_get_register(HV_REGISTER_SIEFP);
> +	hv_get_siefp(siefp.as_uint64);
>  	siefp.siefp_enabled =3D 0;
> -	siefp.base_siefp_gpa =3D 0;
>=20
> -	hv_set_register(HV_REGISTER_SIEFP, siefp.as_uint64);
> +	if (hv_isolation_type_snp())
> +		memunmap(hv_cpu->synic_event_page);
> +	else
> +		siefp.base_siefp_gpa =3D 0;
> +
> +	hv_set_siefp(siefp.as_uint64);
>=20
>  	/* Disable the global synic bit */
> -	sctrl.as_uint64 =3D hv_get_register(HV_REGISTER_SCONTROL);
> +	hv_get_synic_state(sctrl.as_uint64);
>  	sctrl.enable =3D 0;
> -	hv_set_register(HV_REGISTER_SCONTROL, sctrl.as_uint64);
> +	hv_set_synic_state(sctrl.as_uint64);
>=20
>  	if (vmbus_irq !=3D -1)
>  		disable_percpu_irq(vmbus_irq);
> diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyper=
v.h
> index 079988ed45b9..90dac369a2dc 100644
> --- a/include/asm-generic/mshyperv.h
> +++ b/include/asm-generic/mshyperv.h
> @@ -23,9 +23,16 @@
>  #include <linux/bitops.h>
>  #include <linux/cpumask.h>
>  #include <linux/nmi.h>
> +#include <asm/svm.h>
> +#include <asm/sev.h>
>  #include <asm/ptrace.h>
> +#include <asm/mshyperv.h>
>  #include <asm/hyperv-tlfs.h>
>=20
> +union hv_ghcb {
> +	struct ghcb ghcb;
> +} __packed __aligned(PAGE_SIZE);
> +
>  struct ms_hyperv_info {
>  	u32 features;
>  	u32 priv_high;
> @@ -45,7 +52,7 @@ struct ms_hyperv_info {
>  			u32 Reserved12 : 20;
>  		};
>  	};
> -	void  __percpu **ghcb_base;
> +	union hv_ghcb __percpu **ghcb_base;
>  	u64 shared_gpa_boundary;
>  };
>  extern struct ms_hyperv_info ms_hyperv;
> @@ -55,6 +62,7 @@ extern void  __percpu  **hyperv_pcpu_output_arg;
>=20
>  extern u64 hv_do_hypercall(u64 control, void *inputaddr, void *outputadd=
r);
>  extern u64 hv_do_fast_hypercall8(u16 control, u64 input8);
> +extern bool hv_isolation_type_snp(void);
>=20
>  /* Helper functions that provide a consistent pattern for checking Hyper=
-V hypercall status. */
>  static inline int hv_result(u64 status)
> @@ -149,7 +157,7 @@ static inline void vmbus_signal_eom(struct hv_message=
 *msg, u32 old_msg_type)
>  		 * possibly deliver another msg from the
>  		 * hypervisor
>  		 */
> -		hv_set_register(HV_REGISTER_EOM, 0);
> +		hv_signal_eom();
>  	}
>  }
>=20
> --
> 2.25.1

