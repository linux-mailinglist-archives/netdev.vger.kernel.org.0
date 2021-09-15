Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE0240C871
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238032AbhIOPmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:42:44 -0400
Received: from mail-oln040093003012.outbound.protection.outlook.com ([40.93.3.12]:57880
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234154AbhIOPmk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 11:42:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1oQ+BdmlwuKjbpzXOvUz6hvQSV0kOaslOZBkM2YVQWPy8C4L0XqqASX1R3rTjGBbK73IORsl85AdWR9IX564QecvhwfnGG30At7epj3GyE6BryYl55XIvQ1mIgnouK2oisqmPRtP3RRqwAzLbjCNBKoF9J/oh3QXmuPN3uAzt2fb0bwouBWk/YabqYFPHiqxct9yGUnIMDJGTS1qew2zHPWSJ5Fwwvpl6BD1dGT/5R04Ev60zILrs+5jtnNCv259BHTJYmHPeoZ2PPQYQsEr/XoJh5Dx8w1oSJAR7Tz/ucgIlPfa+HcoIeGj197tPlGk272/sarxRKhABAW44rwmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cAjeTAevZElnIv9aFi1h/zCK5mbtaqIBDeFtbOXKBh8=;
 b=CxU2fkqyaPMKby26yxu7RpfUVxAXBR+KWXWEfhRRD+Mwh+Dwc1XS/5aazfPwuQHt43PG1OVnqlwOFatSoGPUrbLcKw/QXIi6lapnYLnLhkWU1VDJIyK3NhdGgHVGbIZvE5gW70ChpqnX3SQAru+vRfb97O7wdLO8ZX7TuPbACMY/iiiODShNuQDGDITencVOMXNAy0kcTrBcYAbj5z9K+4oGtO+tQkuxZ4KCzVzD+0u+C9XHODwwRiTKLtrQUKywa8HwLPn4w0DvUhZL77Zfz3cQ7bsEdQNLxyFeWrE/qkhg3QRLbpdqgDtJRun4y0wYzlnCZJa4bx3lIQ+x7Ovm2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAjeTAevZElnIv9aFi1h/zCK5mbtaqIBDeFtbOXKBh8=;
 b=OMEhoceFD9kFQKJDsoYh94pBJwmSVdaCwfG8wVUtBI8j2urs80SiDPoRXfDzecQBBPLeUZvE/D/ipc4MG/YIIpDUGxYr/2yPyWF4pJkrxOG2aSTeaCLFo/yV3SiWsDu76hGuMNcjX4U0hc8Xd+zIky/CpbIYHQsQVrGF5IvzF3E=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0783.namprd21.prod.outlook.com (2603:10b6:300:77::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.1; Wed, 15 Sep
 2021 15:41:14 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9cb:4254:eba4:a4c3]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9cb:4254:eba4:a4c3%7]) with mapi id 15.20.4544.005; Wed, 15 Sep 2021
 15:41:14 +0000
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
Subject: RE: [PATCH V5 05/12] x86/hyperv: Add Write/Read MSR registers via
 ghcb page
Thread-Topic: [PATCH V5 05/12] x86/hyperv: Add Write/Read MSR registers via
 ghcb page
Thread-Index: AQHXqW39j2hpzRTyUUG/YzVB4+nRcqujwImA
Date:   Wed, 15 Sep 2021 15:41:14 +0000
Message-ID: <MWHPR21MB15937575DE3050863C56F3D2D7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210914133916.1440931-1-ltykernel@gmail.com>
 <20210914133916.1440931-6-ltykernel@gmail.com>
In-Reply-To: <20210914133916.1440931-6-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c7a4a87b-c9ee-4bd7-bbd3-c03c9a3f412f;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-14T16:58:10Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52a3c87e-93a2-4615-7419-08d9785f405f
x-ms-traffictypediagnostic: MWHPR21MB0783:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB07832FA927AB6D27E88F3E00D7DB9@MWHPR21MB0783.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:127;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O+ICcdiaZxhXo8oCd0aeWIPXBSrRl5YaIzPVeWbJBlh9XKWrv9mllGkXDLrcZ4LTc93rd7+zRu/j8xHwu/fQm4CB6xnfvs00lUyKdS+RsonWRICKcR3g6+UNkmfu3zwowVN0xFIlCMDqH4lsp6TlJrUdUI7+SGAzuNsgt7RBMVnMEHeF/55pj/C8LpIVok++JyCWoSMhxO+GYj4X1qOBam6xbCdA19MN/trmpPxBNE8nUkNDyWY9Ls5YfjuPlSKX5ijXlxr293Kkw5a/5LDXLxYnuTbnTisuzlANH/jCYbcg+BECW2JabIrSNP1/fBCtrouCwFOd5cx7mYnc8qVb6LQwipNGhDvN5BNGdDFjVrDKy4o2ACYNV7WkI21RqDGBX42D3gF4kKXIn9flw35E7/nIXLKP7V8JnFshtVhPCAGjzXVV+Fw1d5UGcfIuThfs5L2IrZek+dcIPqQRndz756eJx2ZlWXbf0vX1HgfXkwaCgO7TL6zxAm+pO2rGwikAcEovWcOtRSbc9crOH8MfXSnc/Xl280OyOr2WmIC2Pld5pXbxBsHrtxJOuUK+LUKhgGQMN01jfkYEV8WlQeaKtKG5m+INoFOpjSiUeOIts3lnhuYaKYFJC+u9CSyTOyq80Hl25ZIpMCWJ3s/DwJ+ElgtgGYeyD2nWAMMkVW0VjZPacbMvWoDB40XsIsyXmxKjK0KWTsbvXyHosGSchyhYqbKb/JWtHSaAHXkgueYt9Ag=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(33656002)(7416002)(7406005)(66946007)(26005)(508600001)(9686003)(8936002)(2906002)(8676002)(30864003)(82960400001)(82950400001)(5660300002)(86362001)(921005)(186003)(122000001)(38070700005)(66556008)(10290500003)(66476007)(66446008)(64756008)(76116006)(38100700002)(316002)(54906003)(55016002)(83380400001)(6506007)(110136005)(71200400001)(52536014)(7696005)(8990500004)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?E5CCjcHCN7/4g0U3P52aMjrEANBXOOAtDwkNNNtAm6u1PUxcJUZMFgWkfQ2i?=
 =?us-ascii?Q?cg/HObkFLLM/CrnjDl8w/jynUD9FtiiyfbAVgRV+ooQEmR0OL0vdgJiQdGfp?=
 =?us-ascii?Q?V37m3wuxwEe6ulM8ptB03dysMXhlA8iJHk6qfc2e3oI2OZTXWvD0Qp7hf9uY?=
 =?us-ascii?Q?OtL+jQEZBynzNRztTtrsYPcWXDEVaqTAQhaqjiW2sHTDRG3Bx6VKyCMhYW2p?=
 =?us-ascii?Q?A8MctyD9eZP0A1oLnqaBuLRAmUliKlcZo2AKLQ8ZDXPzcnXM2bWfV59fX2tY?=
 =?us-ascii?Q?pSGJG1l8sn2lL+1/W4BkIreURTUbMFDvYQ3DdGCDgEs6iW5TTUU3d6Z/7HG8?=
 =?us-ascii?Q?dO/nYQ62O/A18yacZ7U47ufDCQypsWtwWQNULngEWTIPZXDy4KCSpxITW87E?=
 =?us-ascii?Q?OFvscc4yXb96j6PbH0jChQqKwSeDQKz8fSgO3OLGeevV/6bwx2duhSs5+J0R?=
 =?us-ascii?Q?fXhVWPAFhXLoF9yMlkIDl2Qofsv8ST/qBzs+TLzFnZWRekOUUp6XA/bChWUY?=
 =?us-ascii?Q?sJaFz2lvIByra0r4D+sZ9jgwH3wJ4Jt4H45SW/qsmccNqME/YI+q6sKrZhxA?=
 =?us-ascii?Q?kKMSnswnhhn6Pg46KkZx9kfIXeMphdh7MC+GClw0UftxsY5WgN4HVgcRDwbs?=
 =?us-ascii?Q?0orc1R7/JtLXfEdf5HF3CRLYMh1CiiiYljG60S2k3k6x2BQ6S/kbkdfVyzJs?=
 =?us-ascii?Q?jRMTA+Un+98z950DTkXpC99IJJEgQSZ7Ys7X/UQ1ZAuPal5xLBdujliXxct5?=
 =?us-ascii?Q?mV9ObgJY7Ba0bdV72gdBg0t/7l/ZT/lPDIohjG3DslMwR0odT9rrGNgs5khs?=
 =?us-ascii?Q?CSiTY+iJ4mrIXp5lju/Kl9uv7Pn8xEk8GHDra1C5iW/pNmUIaz1kObNQZ/el?=
 =?us-ascii?Q?QRgzfemTREnx9R2fbEo6lhv1RN5xu7PCLHt00KqHGXHIRfKivfvzlghtviLu?=
 =?us-ascii?Q?1rdq5vPNUlRouCXAhMhWlciy5+r8tijbOEbmtFm8PCXRY10EWIj40MbeSfwH?=
 =?us-ascii?Q?T5SmfAfBSU2TnCAXDud+u22n6PQND049wdMDq9BhnfszUIoUViGwqCqeCb1n?=
 =?us-ascii?Q?z0TMDzK6wnwBUYaZUDmOkEUG+gTg71g+Y2+/66Fd2/Iq2aCbhGSHyC8XO1gI?=
 =?us-ascii?Q?wClvICTDprvqTT65rD5oQ5duS6hVEKhGntJM2O5yVnydWm4/YcgP+u3SDhBJ?=
 =?us-ascii?Q?bqZ1qOg+67IHYmz6tMG+I9dggpHWeCTpLJLOS/NPfF7S2UYS5T36rGEAVC7O?=
 =?us-ascii?Q?KU0NFX8et8kip4mOlghQdujQATbO1VUh0YmImVLprhvejTmz7gYeRoxmPZzc?=
 =?us-ascii?Q?vyURd62N/4Riv0USYE+6gNTc?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52a3c87e-93a2-4615-7419-08d9785f405f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 15:41:14.4081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 95l4bNYpqLPIt8DCGglG3iq9trViuNpC2WMxH6riGLSIXKUaPjqQbOJBipkzOxlmoU3LgS1J9IHdQM23RMbHwOwzFjFDg9s5xC2glEChu8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0783
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Tuesday, September 14, 2021 6:=
39 AM
>=20
> Hyperv provides GHCB protocol to write Synthetic Interrupt
> Controller MSR registers in Isolation VM with AMD SEV SNP
> and these registers are emulated by hypervisor directly.
> Hyperv requires to write SINTx MSR registers twice. First
> writes MSR via GHCB page to communicate with hypervisor
> and then writes wrmsr instruction to talk with paravisor
> which runs in VMPL0. Guest OS ID MSR also needs to be set
> via GHCB page.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v4:
> 	 * Remove hv_get_simp(), hv_get_siefp()  hv_get_synint_*()
> 	   helper function. Move the logic into hv_get/set_register().
>=20
> Change since v3:
>          * Pass old_msg_type to hv_signal_eom() as parameter.
> 	 * Use HV_REGISTER_* marcro instead of HV_X64_MSR_*
> 	 * Add hv_isolation_type_snp() weak function.
> 	 * Add maros to set syinc register in ARM code.
>=20
> Change since v1:
>          * Introduce sev_es_ghcb_hv_call_simple() and share code
> 	   between SEV and Hyper-V code.
>=20
> Fix for hyperv: Add Write/Read MSR registers via ghcb page
> ---
>  arch/x86/hyperv/hv_init.c       |  36 +++--------
>  arch/x86/hyperv/ivm.c           | 103 ++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/mshyperv.h |  56 ++++++++++++-----
>  arch/x86/include/asm/sev.h      |   6 ++
>  arch/x86/kernel/sev-shared.c    |  63 +++++++++++--------
>  drivers/hv/hv.c                 |  77 +++++++++++++++++++-----
>  drivers/hv/hv_common.c          |   6 ++
>  include/asm-generic/mshyperv.h  |   2 +
>  8 files changed, 266 insertions(+), 83 deletions(-)
>=20
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index d57df6825527..a16a83e46a30 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -37,7 +37,7 @@ EXPORT_SYMBOL_GPL(hv_current_partition_id);
>  void *hv_hypercall_pg;
>  EXPORT_SYMBOL_GPL(hv_hypercall_pg);
>=20
> -void __percpu **hv_ghcb_pg;
> +union hv_ghcb __percpu **hv_ghcb_pg;
>=20
>  /* Storage to save the hypercall page temporarily for hibernation */
>  static void *hv_hypercall_pg_saved;
> @@ -406,7 +406,7 @@ void __init hyperv_init(void)
>  	}
>=20
>  	if (hv_isolation_type_snp()) {
> -		hv_ghcb_pg =3D alloc_percpu(void *);
> +		hv_ghcb_pg =3D alloc_percpu(union hv_ghcb *);
>  		if (!hv_ghcb_pg)
>  			goto free_vp_assist_page;
>  	}
> @@ -424,6 +424,9 @@ void __init hyperv_init(void)
>  	guest_id =3D generate_guest_id(0, LINUX_VERSION_CODE, 0);
>  	wrmsrl(HV_X64_MSR_GUEST_OS_ID, guest_id);
>=20
> +	/* Hyper-V requires to write guest os id via ghcb in SNP IVM. */
> +	hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, guest_id);
> +
>  	hv_hypercall_pg =3D __vmalloc_node_range(PAGE_SIZE, 1, VMALLOC_START,
>  			VMALLOC_END, GFP_KERNEL, PAGE_KERNEL_ROX,
>  			VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
> @@ -501,6 +504,7 @@ void __init hyperv_init(void)
>=20
>  clean_guest_os_id:
>  	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
> +	hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, 0);
>  	cpuhp_remove_state(cpuhp);
>  free_ghcb_page:
>  	free_percpu(hv_ghcb_pg);
> @@ -522,6 +526,7 @@ void hyperv_cleanup(void)
>=20
>  	/* Reset our OS id */
>  	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
> +	hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, 0);
>=20
>  	/*
>  	 * Reset hypercall page reference before reset the page,
> @@ -592,30 +597,3 @@ bool hv_is_hyperv_initialized(void)
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
> -		return false;
> -
> -	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
> -		return false;
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
> index 79e7fb83472a..5439723446c9 100644
> --- a/arch/x86/hyperv/ivm.c
> +++ b/arch/x86/hyperv/ivm.c
> @@ -6,12 +6,115 @@
>   *  Tianyu Lan <Tianyu.Lan@microsoft.com>
>   */
>=20
> +#include <linux/types.h>
> +#include <linux/bitfield.h>
>  #include <linux/hyperv.h>
>  #include <linux/types.h>
>  #include <linux/bitfield.h>
>  #include <linux/slab.h>
> +#include <asm/svm.h>
> +#include <asm/sev.h>
>  #include <asm/io.h>
>  #include <asm/mshyperv.h>
> +#include <asm/hypervisor.h>
> +
> +union hv_ghcb {
> +	struct ghcb ghcb;
> +} __packed __aligned(HV_HYP_PAGE_SIZE);
> +
> +void hv_ghcb_msr_write(u64 msr, u64 value)
> +{
> +	union hv_ghcb *hv_ghcb;
> +	void **ghcb_base;
> +	unsigned long flags;
> +
> +	if (!hv_ghcb_pg)
> +		return;
> +
> +	WARN_ON(in_nmi());
> +
> +	local_irq_save(flags);
> +	ghcb_base =3D (void **)this_cpu_ptr(hv_ghcb_pg);
> +	hv_ghcb =3D (union hv_ghcb *)*ghcb_base;
> +	if (!hv_ghcb) {
> +		local_irq_restore(flags);
> +		return;
> +	}
> +
> +	ghcb_set_rcx(&hv_ghcb->ghcb, msr);
> +	ghcb_set_rax(&hv_ghcb->ghcb, lower_32_bits(value));
> +	ghcb_set_rdx(&hv_ghcb->ghcb, upper_32_bits(value));
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
> +	/* Check size of union hv_ghcb here. */
> +	BUILD_BUG_ON(sizeof(union hv_ghcb) !=3D HV_HYP_PAGE_SIZE);
> +
> +	if (!hv_ghcb_pg)
> +		return;
> +
> +	WARN_ON(in_nmi());
> +
> +	local_irq_save(flags);
> +	ghcb_base =3D (void **)this_cpu_ptr(hv_ghcb_pg);
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
> +	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
> +		return false;
> +
> +	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
> +		return false;
> +
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
>=20
>  /*
>   * hv_mark_gpa_visibility - Set pages visible to host via hvcall.
> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyp=
erv.h
> index ede440f9a1e2..165423e8b67a 100644
> --- a/arch/x86/include/asm/mshyperv.h
> +++ b/arch/x86/include/asm/mshyperv.h
> @@ -11,25 +11,14 @@
>  #include <asm/paravirt.h>
>  #include <asm/mshyperv.h>
>=20
> +union hv_ghcb;
> +
>  DECLARE_STATIC_KEY_FALSE(isolation_type_snp);
>=20
>  typedef int (*hyperv_fill_flush_list_func)(
>  		struct hv_guest_mapping_flush_list *flush,
>  		void *data);
>=20
> -static inline void hv_set_register(unsigned int reg, u64 value)
> -{
> -	wrmsrl(reg, value);
> -}
> -
> -static inline u64 hv_get_register(unsigned int reg)
> -{
> -	u64 value;
> -
> -	rdmsrl(reg, value);
> -	return value;
> -}
> -
>  #define hv_get_raw_timer() rdtsc_ordered()
>=20
>  void hyperv_vector_handler(struct pt_regs *regs);
> @@ -41,7 +30,7 @@ extern void *hv_hypercall_pg;
>=20
>  extern u64 hv_current_partition_id;
>=20
> -extern void __percpu **hv_ghcb_pg;
> +extern union hv_ghcb  __percpu **hv_ghcb_pg;
>=20
>  int hv_call_deposit_pages(int node, u64 partition_id, u32 num_pages);
>  int hv_call_add_logical_proc(int node, u32 lp_index, u32 acpi_id);
> @@ -193,6 +182,8 @@ int hv_map_ioapic_interrupt(int ioapic_id, bool level=
, int vcpu, int vector,
>  		struct hv_interrupt_entry *entry);
>  int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *=
entry);
>  int hv_set_mem_host_visibility(unsigned long addr, int numpages, bool vi=
sible);
> +void hv_ghcb_msr_write(u64 msr, u64 value);
> +void hv_ghcb_msr_read(u64 msr, u64 *value);
>  #else /* CONFIG_HYPERV */
>  static inline void hyperv_init(void) {}
>  static inline void hyperv_setup_mmu_ops(void) {}
> @@ -209,9 +200,46 @@ static inline int hyperv_flush_guest_mapping_range(u=
64 as,
>  {
>  	return -1;
>  }
> +
> +static inline void hv_ghcb_msr_write(u64 msr, u64 value) {}
> +static inline void hv_ghcb_msr_read(u64 msr, u64 *value) {}
>  #endif /* CONFIG_HYPERV */
>=20
> +static inline void hv_set_register(unsigned int reg, u64 value);

I'm not seeing why this declaration is needed.

>=20
>  #include <asm-generic/mshyperv.h>
>=20
> +static inline bool hv_is_synic_reg(unsigned int reg)
> +{
> +	if ((reg >=3D HV_REGISTER_SCONTROL) &&
> +	    (reg <=3D HV_REGISTER_SINT15))
> +		return true;
> +	return false;
> +}
> +
> +static inline u64 hv_get_register(unsigned int reg)
> +{
> +	u64 value;
> +
> +	if (hv_is_synic_reg(reg) && hv_isolation_type_snp())
> +		hv_ghcb_msr_read(reg, &value);
> +	else
> +		rdmsrl(reg, value);
> +	return value;
> +}
> +
> +static inline void hv_set_register(unsigned int reg, u64 value)
> +{
> +	if (hv_is_synic_reg(reg) && hv_isolation_type_snp()) {
> +		hv_ghcb_msr_write(reg, value);
> +
> +		/* Write proxy bit via wrmsl instruction */
> +		if (reg >=3D HV_REGISTER_SINT0 &&
> +		    reg <=3D HV_REGISTER_SINT15)
> +			wrmsrl(reg, value | 1 << 20);
> +	} else {
> +		wrmsrl(reg, value);
> +	}
> +}
> +

This all looks OK to me, except that it would really be nice if the
#include of asm-generic/mshyperv.h stays last in the file.  I think the
problem is needing a declaration for hv_isolation_type_snp(), right?
And it is added into asm-generic/mshyperv.h at the very end of this
patch.

The alternative would be to put hv_get_register() and
hv_set_register() in a .c file rather than as static inline.  They get
called in quite a few places, and arguably are now fairly large for
being static inline, in my judgment.  But I guess I'm OK either way.

In previous versions, the EOM register was being handled
differently (GHCB vs. MSR write) for timer messages vs. other messages.
That distinction is no longer being made.  Did you learn something new
from the Hyper-V team about this?  Just want to make sure nothing
was inadvertently dropped.

>  #endif
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index fa5cd05d3b5b..60bfdbd141b1 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -81,12 +81,18 @@ static __always_inline void sev_es_nmi_complete(void)
>  		__sev_es_nmi_complete();
>  }
>  extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
> +extern enum es_result sev_es_ghcb_hv_call_simple(struct ghcb *ghcb,
> +				   u64 exit_code, u64 exit_info_1,
> +				   u64 exit_info_2);
>  #else
>  static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>  static inline void sev_es_ist_exit(void) { }
>  static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rm=
h) { return 0; }
>  static inline void sev_es_nmi_complete(void) { }
>  static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
> +static inline enum es_result sev_es_ghcb_hv_call_simple(struct ghcb *ghc=
b,
> +				   u64 exit_code, u64 exit_info_1,
> +				   u64 exit_info_2) { return ES_VMM_ERROR; }
>  #endif
>=20
>  #endif
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
> index e83507f49676..dee1a96bc535 100644
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
> @@ -201,16 +209,35 @@ void hv_synic_enable_regs(unsigned int cpu)
>  	/* Setup the Synic's message page */
>  	simp.as_uint64 =3D hv_get_register(HV_REGISTER_SIMP);
>  	simp.simp_enabled =3D 1;
> -	simp.base_simp_gpa =3D virt_to_phys(hv_cpu->synic_message_page)
> -		>> HV_HYP_PAGE_SHIFT;
> +
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
>=20
>  	hv_set_register(HV_REGISTER_SIMP, simp.as_uint64);
>=20
>  	/* Setup the Synic's event page */
>  	siefp.as_uint64 =3D hv_get_register(HV_REGISTER_SIEFP);
>  	siefp.siefp_enabled =3D 1;
> -	siefp.base_siefp_gpa =3D virt_to_phys(hv_cpu->synic_event_page)
> -		>> HV_HYP_PAGE_SHIFT;
> +
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
>=20
>  	hv_set_register(HV_REGISTER_SIEFP, siefp.as_uint64);
>=20
> @@ -257,30 +284,48 @@ int hv_synic_init(unsigned int cpu)
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
> +

Spurious blank line?

>  	shared_sint.as_uint64 =3D hv_get_register(HV_REGISTER_SINT0 +
>  					VMBUS_MESSAGE_SINT);
>=20
>  	shared_sint.masked =3D 1;
>=20
> +
> +

Spurious blank lines?

>  	/* Need to correctly cleanup in the case of SMP!!! */
>  	/* Disable the interrupt */
>  	hv_set_register(HV_REGISTER_SINT0 + VMBUS_MESSAGE_SINT,
>  				shared_sint.as_uint64);
>=20
>  	simp.as_uint64 =3D hv_get_register(HV_REGISTER_SIMP);
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
>  	hv_set_register(HV_REGISTER_SIMP, simp.as_uint64);
>=20
>  	siefp.as_uint64 =3D hv_get_register(HV_REGISTER_SIEFP);
>  	siefp.siefp_enabled =3D 0;
> -	siefp.base_siefp_gpa =3D 0;
> +
> +	if (hv_isolation_type_snp())
> +		memunmap(hv_cpu->synic_event_page);
> +	else
> +		siefp.base_siefp_gpa =3D 0;
>=20
>  	hv_set_register(HV_REGISTER_SIEFP, siefp.as_uint64);
>=20
> diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
> index c0d9048a4112..1fc82d237161 100644
> --- a/drivers/hv/hv_common.c
> +++ b/drivers/hv/hv_common.c
> @@ -249,6 +249,12 @@ bool __weak hv_is_isolation_supported(void)
>  }
>  EXPORT_SYMBOL_GPL(hv_is_isolation_supported);
>=20
> +bool __weak hv_isolation_type_snp(void)
> +{
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(hv_isolation_type_snp);
> +
>  void __weak hv_setup_vmbus_handler(void (*handler)(void))
>  {
>  }
> diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyper=
v.h
> index cb529c85c0ad..94750bafd4cc 100644
> --- a/include/asm-generic/mshyperv.h
> +++ b/include/asm-generic/mshyperv.h
> @@ -24,6 +24,7 @@
>  #include <linux/cpumask.h>
>  #include <linux/nmi.h>
>  #include <asm/ptrace.h>
> +#include <asm/mshyperv.h>

This #include should not be done.  The architecture specific version
of mshyperv.h #includes the asm-generic version, not the other
way around.

In any case, I'm not seeing that this #include is needed.

>  #include <asm/hyperv-tlfs.h>
>=20
>  struct ms_hyperv_info {
> @@ -54,6 +55,7 @@ extern void  __percpu  **hyperv_pcpu_output_arg;
>=20
>  extern u64 hv_do_hypercall(u64 control, void *inputaddr, void *outputadd=
r);
>  extern u64 hv_do_fast_hypercall8(u16 control, u64 input8);
> +extern bool hv_isolation_type_snp(void);
>=20
>  /* Helper functions that provide a consistent pattern for checking Hyper=
-V hypercall status. */
>  static inline int hv_result(u64 status)
> --
> 2.25.1
