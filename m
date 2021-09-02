Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8F23FE666
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243142AbhIBAQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 20:16:30 -0400
Received: from mail-oln040093008007.outbound.protection.outlook.com ([40.93.8.7]:40430
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237130AbhIBAQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 20:16:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4b3tJqAMNcxiBzzEYA+v8JE1ZchrBMzycvlyjyyEaC0jibjIvp+NMHjfnl2zmnDwsHyahDsfktZS8PTxXLG+popmuIiBWOXz62JNRCg9cA3EIm3Fl2xpFj6Zb2E/Ag12U7AtWeOq4NSjPWf3SV5ApwYFF+YKVYCId1L+R6KTZgx4cfIU/K5XPnwYiY1o/g4hR/u1cb1vUVxSKhGMtzSSJHjHZb5BPRHV3RnDzTsYRaTSA+xSq2F8Taod9dNaV71f1ckAKaLxZ5Qrqk+CmtCaJL1DO4F+SyEp1a8zv0sXuUqZuBN1RaDEnrXuzNTwu4E/W1rIOKs+UF6tV8gxM7bGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=6tVUDVw6S4dvfWR9PY8PHDrUdy5zfJaPLLhUIx49AUM=;
 b=JZjZjgEg7RToqs/5LVea8kPluWOU/O61jvpFHollPfj+oJSi4JR6eH8JW9kRxmyA4RWMfTsnQqQ9vk17ASZSn0SBndGQ80RprXLJvPnw2hHOZFV2OUh4LdbhMb5jVIhtJs3mWBUI3PNFrzD7ylBwuFNgnu/mIEsIDCM9MW/6rDWCEHCQCSKU085CFaUyU+tpEjMWtatYhqNFOx7W3vy9K9wJIswRA4qOifGPTLZstnDYGQmBn7ysip7alJ6+IzLOcVCvmoyD21LhMQseCHCxpNVNstFrjO4eGcsMRqRscHSddmU7n0N199RZiy80BVwWLHDvY6pb+7o+me7ayHlk7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tVUDVw6S4dvfWR9PY8PHDrUdy5zfJaPLLhUIx49AUM=;
 b=XumoSZuZrB97O7Abt8lXvJ9jNJfQv5OV+xW/t/sl9NOQ/+OdR4zwVipb0ca/QetLiiid3b5PZeIMVJ443lNTePri9lg8ZMU+k+6BuJWmz0nL0oKwaKRHiUIC7602NP1teRCekzNyw17VX8V+3GXFOslyI6mSMYd+0qzlfcZegFg=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0797.namprd21.prod.outlook.com (2603:10b6:300:11b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.1; Thu, 2 Sep
 2021 00:15:28 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86%8]) with mapi id 15.20.4478.014; Thu, 2 Sep 2021
 00:15:28 +0000
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
Subject: RE: [PATCH V4 02/13] x86/hyperv: Initialize shared memory boundary in
 the Isolation VM.
Thread-Topic: [PATCH V4 02/13] x86/hyperv: Initialize shared memory boundary
 in the Isolation VM.
Thread-Index: AQHXm2f5YhiZigcKo0WndvjSqX/I9KuH761w
Date:   Thu, 2 Sep 2021 00:15:27 +0000
Message-ID: <MWHPR21MB1593EF63423A2422DA839793D7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210827172114.414281-3-ltykernel@gmail.com>
In-Reply-To: <20210827172114.414281-3-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0a271260-2add-4c88-99c4-2e5b54a0e418;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-27T22:31:14Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0bb98b2c-b332-43be-b6bc-08d96da6c4b7
x-ms-traffictypediagnostic: MWHPR21MB0797:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB079715FAF7178E238D3B3B27D7CE9@MWHPR21MB0797.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zzhi7VwaXM35ruQkmXyNvFX42K8MnHgcxR/I3JJ+p15J4AndM8A8FmXFNPW0Pw8Zmj5+C/dQkGgoAPemXaY0hIgueRmcLQgPytlXLZYv1msC0kBb0zg2LC1O/bANppFMlGFQstY1/XNvxZsH9spLv3aAl9A4dNcvZStMcPOVrKOLVuv+nDhIgq4fK3KXfsO4GdfwA1kEyDV25i4RCCxvMewMCc9uEP87gxhsd9Pl8+hCRnPMjvEcttz6uV0CP2h477ANsQg/YwF3fdGcCnJownxpZwVAUvFDf+hKjXN6ksIpzSW1U4gOHq2f0QIKx0i7mBp0Oma1Tyi4sQvsJ6YSHs2vTKVW4WOXUT1xl6ro+ymF7OzJk9Dysu2CKhEo8+1tCVg8bM3E1rnbYTrCWmAl7vRXivkk6XMwpUojkA1+rMvn3XEaQZwMM6GPP4WPuAIhp7+vByu4U8NP5lj2ffCybg6h6xUrShI4JkrArYq1qzNufWyC8aVh4p0k28nzgoVtL1cvWYZ7CT46DmYDP/gVhwwHKhgBtNVmcI+9dfUgW62vHeD77Qlo9uXoSxIjiVa2hLen6ZE+hCVPK4au4pauws+DPDiU64wJOURLa3BzaOGckOZ+MFRc5stLX/0DsR0UPlNCGbgqVCC4J3JNW4Tac2vCad2Ul8E8GLFt66H7NKEJf9IELvrkPYiHpEf8II1jmaYpQav5ec5kN7poLkKbHd/VfqCb79Ba6ivjZvF72Xg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38070700005)(8936002)(316002)(8676002)(7696005)(71200400001)(5660300002)(52536014)(10290500003)(82960400001)(508600001)(8990500004)(82950400001)(7366002)(7406005)(66446008)(83380400001)(186003)(66476007)(66556008)(122000001)(76116006)(86362001)(921005)(33656002)(66946007)(9686003)(54906003)(55016002)(110136005)(64756008)(6506007)(4326008)(7416002)(38100700002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a1LzKABlpY2yhIlj+iKhGJUcJvC5jESOKLs2Un6hyPqUyS6IMhSh+/lr4UEg?=
 =?us-ascii?Q?w4bnjgOkDQSxvfqIbFWEZAzGVSuLVIBM4RQ/I86Nn1ARK/FcNqUjRlr9TmSj?=
 =?us-ascii?Q?9qyHRcd495zNkey5DZL/fabj2qoNgeBp82a97j5ZQVGLE9vVLtvoggyGeUgp?=
 =?us-ascii?Q?2xCOv/jeJmCqda4zvsT3tgkxXvBWZVb3sISBZYsCRBDEmPamgwcUeBzVvbtX?=
 =?us-ascii?Q?VGIjkwOjmm10orfXz7Cgchunxbb1VuEFU/wMBozMap5TT6IiWP5+BQFfy/Iz?=
 =?us-ascii?Q?gupQltgZqYsx35Evb86AUkTXsp4fG3dYkzZ0P8u+uk5+BLqENGX5ssRaIoaS?=
 =?us-ascii?Q?DFIcuFZmoXPM7Of2oQkcWs5EACSU0XgrWQi61j4qki8Qssm8lT9Ia6XVa0Ji?=
 =?us-ascii?Q?os3x4qfNzqFQcZLqqUziRbomGbLaFNf/sB5gAcIkh+RGt9A2ozj+rmSvcKqV?=
 =?us-ascii?Q?2lLtSkDRdJA1KH8VdBc+s5qQsrtpaPn7WkL1Z6231nhUoOUaJmSsMm1wSi7t?=
 =?us-ascii?Q?ETzPaZHbWMN3NmCGr3hq07iKmE06QOLZclGMxy6ZO4vEnXY2iknm4oAMCbhv?=
 =?us-ascii?Q?/u1tex/FmTFBJyhfl02YFRCT2w/MiIcpK8utaFED4nNUN+vhdlo5IwmZ17QX?=
 =?us-ascii?Q?QP7r5xsNZVxjVoi+OCGRBHWpo/2uRpZQFojUCEKH4MssdzvR6BgC5vSh7LCk?=
 =?us-ascii?Q?e4lnYHSXS0lEkFsEkfTU0LVRer4M2HHgg/V9vbGUWU8iXrUK+l3gdvlSdJ8F?=
 =?us-ascii?Q?nXh0iWR7Pwk9p6pU1va7cOebYDKGsG2S8cAvT+O1RNYvU9aaFYsSXOF+InoU?=
 =?us-ascii?Q?tswUliudNqGh8ijCBXjReAIeb+XzWFrpBuQxBTrKMEj4adRifDNKRrisvXwu?=
 =?us-ascii?Q?1sopz+gy1XxgBpb2wbV3povJXd4rDFWXSjxbshyzGBGqSh9fsQEqax6hcE2p?=
 =?us-ascii?Q?G5AaQc5l3LvDxC0WSaqtHmyU0M1GBp1fu86fKP6CyhHWz0TbHekuiW/rHV6j?=
 =?us-ascii?Q?TfgIpj+iOZBMHdTdtBlAmLmA5v9JEs+26IrHhbO48+b2PaV9ImIixo370IWc?=
 =?us-ascii?Q?+4pdlJaIzduBwQn1/pzyIZ4NuHNoxJt01ab4/WTT+nBUlAa6sl4x9gs0KThQ?=
 =?us-ascii?Q?kmwqeNT+VXoO0T31VLZRNtJcz6rAZ0rWDrhj7rVfEYe5CQc/XEjRjoLS4+d4?=
 =?us-ascii?Q?Tm09Us06khNRTuhmGc+gGt8QG9UO+Sau7cnxUX6vm3h7U4HD3SpcI3WPwvR8?=
 =?us-ascii?Q?sxx+sFAULKiGz5tCKQ17Z8bJp9Myyb1bM+LObHFwNrntegCzX+UXMLAzXRyE?=
 =?us-ascii?Q?Ece15J/8FKpNHmK4Omwm5laf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bb98b2c-b332-43be-b6bc-08d96da6c4b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 00:15:27.9650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kqyCC46tRZ6Ol7tcUTWt/2lSA8O5oztS7qxpD8ekw1tgtmu+y1jejDT1KAvl57lUrUlPeLUjEzGIJsjVZ1O4C5AKq10LHwiGv5P17CeeGlQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Friday, August 27, 2021 10:21 =
AM
>=20
> Hyper-V exposes shared memory boundary via cpuid
> HYPERV_CPUID_ISOLATION_CONFIG and store it in the
> shared_gpa_boundary of ms_hyperv struct. This prepares
> to share memory with host for SNP guest.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v3:
> 	* user BIT_ULL to get shared_gpa_boundary
> 	* Rename field Reserved* to reserved
> ---
>  arch/x86/kernel/cpu/mshyperv.c |  2 ++
>  include/asm-generic/mshyperv.h | 12 +++++++++++-
>  2 files changed, 13 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyper=
v.c
> index 20557a9d6e25..8bb001198316 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -313,6 +313,8 @@ static void __init ms_hyperv_init_platform(void)
>  	if (ms_hyperv.priv_high & HV_ISOLATION) {
>  		ms_hyperv.isolation_config_a =3D cpuid_eax(HYPERV_CPUID_ISOLATION_CONF=
IG);
>  		ms_hyperv.isolation_config_b =3D cpuid_ebx(HYPERV_CPUID_ISOLATION_CONF=
IG);
> +		ms_hyperv.shared_gpa_boundary =3D
> +			BIT_ULL(ms_hyperv.shared_gpa_boundary_bits);
>=20
>  		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
>  			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
> diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyper=
v.h
> index 0924bbd8458e..7537ae1db828 100644
> --- a/include/asm-generic/mshyperv.h
> +++ b/include/asm-generic/mshyperv.h
> @@ -35,7 +35,17 @@ struct ms_hyperv_info {
>  	u32 max_vp_index;
>  	u32 max_lp_index;
>  	u32 isolation_config_a;
> -	u32 isolation_config_b;
> +	union {
> +		u32 isolation_config_b;
> +		struct {
> +			u32 cvm_type : 4;
> +			u32 reserved11 : 1;
> +			u32 shared_gpa_boundary_active : 1;
> +			u32 shared_gpa_boundary_bits : 6;
> +			u32 reserved12 : 20;

I'm still curious about the "11" and "12" in the reserved
field names.  Why not just "reserved1" and "reserved2"?
Having the "11" and "12" isn't wrong, but it makes one
wonder why since it's not usual. :-)

> +		};
> +	};
> +	u64 shared_gpa_boundary;
>  };
>  extern struct ms_hyperv_info ms_hyperv;
>=20
> --
> 2.25.1

