Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D486E3EBD87
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 22:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbhHMUnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 16:43:01 -0400
Received: from mail-mw2nam10on2117.outbound.protection.outlook.com ([40.107.94.117]:35619
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233915AbhHMUm5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 16:42:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/PmMgenu25aFfpENzd6BmNaINIatJBdK2kHTs0T2C3eLzR8bAMCN69/sCgY1lPaegteFUYw++/VftAaOKEJfCia0cbNX6Q5+VFEkzXeDpWOkt7pL5hSbB4xG1g87g8Mgxzz8ul3WGIo3oBk+VctzH9HIjuWwNtSiCoe9riZ15pNOYC/RaZjvX1PMh7HyWwPcqiO1nWzNSI53V0oGkcB0Oi417sk6bh9cRQeq1i50AIAbWVvboaKBv9RkldIo82yOusTxqsoEyecfVLLcIzvMiPYYVK11jHnofInj3ck6CGpaBsY7nAyxYPDeOKP2c248a/vy/y2gfLXEOYfXyYD1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rypb+JEQTEQG5iMVSpatMOsXM7AJYRPM5NrU66ByIpU=;
 b=iMnW0KJKcevpVH2R6PmizDV+Un1DhRG6mjf7AxHpTNfdn4fK34/Vfg8QFdkt9qkl4LO9Rbb7NCmaho3AgHJ1og5XTlshxeveSS7+uuinLoc8MiT4/m7ZWEexlEucu4NwtnO7kgl3rUn+a0ImZW7B2J3pk0MUrVY1j67YargmRt9cGoD6utHnZqrX9nSGgjwbfLfsRNlfDuV5LA95yNrOaWgexwiiov+ZaZh7A0RZa7+FwaAMvTrZYT943JM8TukcIB3nxkPYzl4gU49QG+AwS+01gPGJS3CSdoFGNuMVKPmKcWRphtR2DEL+uE4YyaEsbdSzFPtqUREOjGVCwXJdpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rypb+JEQTEQG5iMVSpatMOsXM7AJYRPM5NrU66ByIpU=;
 b=OrkvDOb9QchvZJTeA7Lm7wexaNiL6C/cxYw9/VfOynVZuDgbqbUJUh7Nnf5WilcHFrwbNbIF1usDaJnYY0DDiJoHntne9+qeK8io5D4Ii6FCK1R+FxkpToq2mMSarstHebLhNqSf11Ybp47M0+nOnMlqLVvXK//FRV5LeAKirGw=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW4PR21MB1986.namprd21.prod.outlook.com (2603:10b6:303:7d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.4; Fri, 13 Aug
 2021 20:42:21 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55%2]) with mapi id 15.20.4436.012; Fri, 13 Aug 2021
 20:42:21 +0000
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
Subject: RE: [PATCH V3 06/13] HV: Add ghcb hvcall support for SNP VM
Thread-Topic: [PATCH V3 06/13] HV: Add ghcb hvcall support for SNP VM
Thread-Index: AQHXjUfzslCDYD8zc0CR/lAuMVKshKtx61Hg
Date:   Fri, 13 Aug 2021 20:42:20 +0000
Message-ID: <MWHPR21MB159387555A5405E07A2935D7D7FA9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-7-ltykernel@gmail.com>
In-Reply-To: <20210809175620.720923-7-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=dd098ba2-7655-44ee-883c-b53605cbede8;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-13T20:36:48Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d96ae8e2-a7fa-465d-b2bb-08d95e9ad92b
x-ms-traffictypediagnostic: MW4PR21MB1986:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW4PR21MB1986E8A0FE134FF4F3050788D7FA9@MW4PR21MB1986.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uPUYC4yfmDYLNp847IY/NfmVOn708h40sC/iPq6OV4i8qhcDyxZE2oSiYBn2O/cMjy3sCzwdTVW9+9mqy4BhWQHBP3baaJPCn5lfhFGdwUKoi4nbD8EdTd1KeqjSkw4/5jc1acThW4oqR2sMkEc5SwKCCjT7Yfe5MmsDuqbaAoHf81C8PMz8WvnZJHDAd3cWFNiDiOmuknXi8Ies0xByPnQVKK0PA0REXd9W/RsYfOqWmHAC7EWMtOMicA3EDBL0rSln8wh448tW2DU4uYgQMecOvxGMuFgDqBl/u4jOICHXd3b++JjDgR4GejyiRqP6XPiAueGUtqQfsMC12MIeNLVjtdRMkzLHhODdcBYqkz2lYSZLNd/3UswFbbfJStFXAPPsatHh9D2jWHiCV6436MZ2Fo+TutO8R4BzIshfv5hZPQxubtIBwC3MGiPSdWtgfE4e/EfEUl63GY4cdx0k9cJQHj7wdo5Y0jcpVtSZ3GT74P5Xcb8ExvVXw+a3QzTRfhShVaoL6CQBu0oJTOeBDKb/cewOjEG451ZteZxoThy+rAfCrsCz0rZDdjVGNz6vpzjDaHyvS6DvLAXfNjUN0IR9jVWx2nPpdq7nWw3BGIXq9B8GJvpbOZyG8P79Cg7McD43KSJIjvFElMNvm9x8DSLaISQatZ3PVcV4kRgH8OvD6rjcvTfBIU61U/QxbBkmrfyE/ElgtuOIUFNWsVHkcdQ+J+/myBNKlLojSE3s5+4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(83380400001)(186003)(71200400001)(110136005)(66946007)(54906003)(9686003)(921005)(66556008)(64756008)(66446008)(66476007)(8676002)(86362001)(10290500003)(26005)(76116006)(52536014)(122000001)(38100700002)(2906002)(7696005)(316002)(7416002)(7406005)(4326008)(6506007)(38070700005)(82950400001)(33656002)(82960400001)(8990500004)(55016002)(8936002)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TtEpRuBy04VIdx/dcG9yXpycNPRk6aDHFV1oCjpVxCy/w6AkrSw9Xdc0lrwz?=
 =?us-ascii?Q?QUGdfD+vQ2TaAbYddX+T30dhYf8XScCmrF9gPMIBgVyYmYNxLnJ6YtPVwiVn?=
 =?us-ascii?Q?8CwoE7Y4XnAen+zkFixPe9TQGD3JFrniY/JWrK1wwJtyRVfUOBKNuD4sts4T?=
 =?us-ascii?Q?pP0jwcQEJ/0gysYpjMF8y6WkIRMaUPTJO8yhtCjCxLnZLatOR60KfruJK1Hn?=
 =?us-ascii?Q?l1FOdDFwMzfQ3NdHDfzJZorruJZCo4yG9mDDzOc9UwTvrS3XUlzbxQ4Z/ZRe?=
 =?us-ascii?Q?7EYj1gAx71DOckYKlIepQL22M+uS1CF2EBotHuC1OwyrLkczCgTW+wb2+2pf?=
 =?us-ascii?Q?LvBhFZ8mGVuvz/sYF3whCMJkxhCcnDPKCabzWw0E1ROS7yiFzOP16EYm3mR6?=
 =?us-ascii?Q?rH/H50uD32UsB3/nNkwFSuAmVZldpZ5ZJrDkpyKFKs2cTQ1JEXoHfbZVdO6p?=
 =?us-ascii?Q?n+bRbnszgjqeWxxvvTUnSYygYKJ74oGax6XldBKPYDxMIMpBELNqobt8+u8D?=
 =?us-ascii?Q?mHz43mSzOuMS0SFyyyBegxZZcJZRYsRtcjsF1Odfq7j6EqlVyHTeeZ0CengX?=
 =?us-ascii?Q?6RbnCDdc+uc3lMU29Tds3sDv5UdIixxGJ2N0p47JYRX5+vn2iubsRFalbFqw?=
 =?us-ascii?Q?1CdJocZZrQMk/cM5vbTSQiHdmEZw+CxnDrNbhJKzYsU9hW3P/O4Paw5S091Y?=
 =?us-ascii?Q?AzKG5sW96b2XTxaE6nhaoG0thV8N/Yd2LEGjoM9owNFDPLDkMxKpKgFUNG/6?=
 =?us-ascii?Q?yErCSmhMigFr6qDbA2GAFg8msdNMs6KV7esPyPVp30TQr2HT8VevqAntZhW1?=
 =?us-ascii?Q?f7KpNBbC4bXnHfHaT6Oqi/dRZDGgzhdAkFoZNhhGL6CB+3pSDnDrqoJpTzPM?=
 =?us-ascii?Q?Kc2E3ckopeXB2aNETvst/o1KqUB0pW62oEfVrFxcmG28jp4GAUWF+7mTPncZ?=
 =?us-ascii?Q?c1JGbZcg9/fOU4qq138NBN8oOmg7fiqZ8svCMQFJNYNz5AXVeirBlkdN9mId?=
 =?us-ascii?Q?DwdpDx+712M2QwS0nwncGLqEQUf1otmGgQGS4eEKCnSCoqVAy5jgfmo66/yC?=
 =?us-ascii?Q?w/wRzwtklnjkp31FyNbt0rQgf59glwT6uJ0mc/2AJ1HA58waeO1XqK9AIliQ?=
 =?us-ascii?Q?+xVrZ547stu/zk8sdCNS3UQKz11Sv8En/g6LwBChRWh5zp1XulvxBb5vg1Vj?=
 =?us-ascii?Q?uHOSWVnr2cpHHZ/KSqPNcAWjp8dgZGRicR9cfk86A3S24OwjAT1UT+5oshFt?=
 =?us-ascii?Q?D7AhQWqPC40tVdD81vcbv8TCC/XORXWohlc82dEfcNMvMjTNf95sPlD9coa9?=
 =?us-ascii?Q?XH1PZoTiLIhajHysssBnkqM9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d96ae8e2-a7fa-465d-b2bb-08d95e9ad92b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2021 20:42:20.9371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yK8TOzD/DV0Z6f+xokh0xsHxAdMIhcIgYHZI/BHSNO0OkTR6ZX03jxOHZ0JLmKPp1VGFFKNMdSMFFqTB1zxIy0PvXdK5+ihzztRvkbH/Q+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1986
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Monday, August 9, 2021 10:56 A=
M
>=20
> Hyper-V provides ghcb hvcall to handle VMBus
> HVCALL_SIGNAL_EVENT and HVCALL_POST_MESSAGE
> msg in SNP Isolation VM. Add such support.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  arch/x86/hyperv/ivm.c           | 43 +++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/mshyperv.h |  1 +
>  drivers/hv/connection.c         |  6 ++++-
>  drivers/hv/hv.c                 |  8 +++++-
>  include/asm-generic/mshyperv.h  | 29 ++++++++++++++++++++++
>  5 files changed, 85 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
> index ec0e5c259740..c13ec5560d73 100644
> --- a/arch/x86/hyperv/ivm.c
> +++ b/arch/x86/hyperv/ivm.c
> @@ -15,6 +15,49 @@
>  #include <asm/io.h>
>  #include <asm/mshyperv.h>
>=20
> +#define GHCB_USAGE_HYPERV_CALL	1
> +
> +u64 hv_ghcb_hypercall(u64 control, void *input, void *output, u32 input_=
size)
> +{
> +	union hv_ghcb *hv_ghcb;
> +	void **ghcb_base;
> +	unsigned long flags;
> +
> +	if (!ms_hyperv.ghcb_base)
> +		return -EFAULT;
> +
> +	WARN_ON(in_nmi());
> +
> +	local_irq_save(flags);
> +	ghcb_base =3D (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
> +	hv_ghcb =3D (union hv_ghcb *)*ghcb_base;
> +	if (!hv_ghcb) {
> +		local_irq_restore(flags);
> +		return -EFAULT;
> +	}
> +
> +	hv_ghcb->ghcb.protocol_version =3D GHCB_PROTOCOL_MAX;
> +	hv_ghcb->ghcb.ghcb_usage =3D GHCB_USAGE_HYPERV_CALL;
> +
> +	hv_ghcb->hypercall.outputgpa =3D (u64)output;
> +	hv_ghcb->hypercall.hypercallinput.asuint64 =3D 0;
> +	hv_ghcb->hypercall.hypercallinput.callcode =3D control;
> +
> +	if (input_size)
> +		memcpy(hv_ghcb->hypercall.hypercalldata, input, input_size);
> +
> +	VMGEXIT();
> +
> +	hv_ghcb->ghcb.ghcb_usage =3D 0xffffffff;
> +	memset(hv_ghcb->ghcb.save.valid_bitmap, 0,
> +	       sizeof(hv_ghcb->ghcb.save.valid_bitmap));
> +
> +	local_irq_restore(flags);
> +
> +	return hv_ghcb->hypercall.hypercalloutput.callstatus;
> +}
> +EXPORT_SYMBOL_GPL(hv_ghcb_hypercall);

This function is called from architecture independent code, so it needs a
default no-op stub to enable the code to compile on ARM64.  The stub should
always return failure.

> +
>  void hv_ghcb_msr_write(u64 msr, u64 value)
>  {
>  	union hv_ghcb *hv_ghcb;
> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyp=
erv.h
> index 730985676ea3..a30c60f189a3 100644
> --- a/arch/x86/include/asm/mshyperv.h
> +++ b/arch/x86/include/asm/mshyperv.h
> @@ -255,6 +255,7 @@ void hv_sint_rdmsrl_ghcb(u64 msr, u64 *value);
>  void hv_signal_eom_ghcb(void);
>  void hv_ghcb_msr_write(u64 msr, u64 value);
>  void hv_ghcb_msr_read(u64 msr, u64 *value);
> +u64 hv_ghcb_hypercall(u64 control, void *input, void *output, u32 input_=
size);
>=20
>  #define hv_get_synint_state_ghcb(int_num, val)			\
>  	hv_sint_rdmsrl_ghcb(HV_X64_MSR_SINT0 + int_num, val)
> diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
> index 5e479d54918c..6d315c1465e0 100644
> --- a/drivers/hv/connection.c
> +++ b/drivers/hv/connection.c
> @@ -447,6 +447,10 @@ void vmbus_set_event(struct vmbus_channel *channel)
>=20
>  	++channel->sig_events;
>=20
> -	hv_do_fast_hypercall8(HVCALL_SIGNAL_EVENT, channel->sig_event);
> +	if (hv_isolation_type_snp())
> +		hv_ghcb_hypercall(HVCALL_SIGNAL_EVENT, &channel->sig_event,
> +				NULL, sizeof(u64));
> +	else
> +		hv_do_fast_hypercall8(HVCALL_SIGNAL_EVENT, channel->sig_event);
>  }
>  EXPORT_SYMBOL_GPL(vmbus_set_event);
> diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
> index 59f7173c4d9f..e5c9fc467893 100644
> --- a/drivers/hv/hv.c
> +++ b/drivers/hv/hv.c
> @@ -98,7 +98,13 @@ int hv_post_message(union hv_connection_id connection_=
id,
>  	aligned_msg->payload_size =3D payload_size;
>  	memcpy((void *)aligned_msg->payload, payload, payload_size);
>=20
> -	status =3D hv_do_hypercall(HVCALL_POST_MESSAGE, aligned_msg, NULL);
> +	if (hv_isolation_type_snp())
> +		status =3D hv_ghcb_hypercall(HVCALL_POST_MESSAGE,
> +				(void *)aligned_msg, NULL,
> +				sizeof(struct hv_input_post_message));
> +	else
> +		status =3D hv_do_hypercall(HVCALL_POST_MESSAGE,
> +				aligned_msg, NULL);
>=20
>  	/* Preemption must remain disabled until after the hypercall
>  	 * so some other thread can't get scheduled onto this cpu and
> diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyper=
v.h
> index 90dac369a2dc..400181b855c1 100644
> --- a/include/asm-generic/mshyperv.h
> +++ b/include/asm-generic/mshyperv.h
> @@ -31,6 +31,35 @@
>=20
>  union hv_ghcb {
>  	struct ghcb ghcb;
> +	struct {
> +		u64 hypercalldata[509];
> +		u64 outputgpa;
> +		union {
> +			union {
> +				struct {
> +					u32 callcode        : 16;
> +					u32 isfast          : 1;
> +					u32 reserved1       : 14;
> +					u32 isnested        : 1;
> +					u32 countofelements : 12;
> +					u32 reserved2       : 4;
> +					u32 repstartindex   : 12;
> +					u32 reserved3       : 4;
> +				};
> +				u64 asuint64;
> +			} hypercallinput;
> +			union {
> +				struct {
> +					u16 callstatus;
> +					u16 reserved1;
> +					u32 elementsprocessed : 12;
> +					u32 reserved2         : 20;
> +				};
> +				u64 asunit64;
> +			} hypercalloutput;
> +		};
> +		u64 reserved2;
> +	} hypercall;
>  } __packed __aligned(PAGE_SIZE);

Alignment should be to HV_HYP_PAGE_SIZE.  And it would be a good safety
play to have a BUILD_BUG_ON() somewhere asserting that
sizeof(union hv_ghcb) =3D=3D HV_HYP_PAGE_SIZE.

>=20
>  struct ms_hyperv_info {
> --
> 2.25.1

