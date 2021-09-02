Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358B73FE805
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 05:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242235AbhIBDdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 23:33:12 -0400
Received: from mail-oln040093003014.outbound.protection.outlook.com ([40.93.3.14]:17391
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233094AbhIBDdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 23:33:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQbXSpgvwBAqzskd+XYzXa9qd1ZwoapNxtxzqozS6nQxvzYigLh+evBweV2kRwNBwz7ekzLu2XVsXXi2v7i5ItqEu7BuwK5CdgKyPLq1DcbYN7pVpwDgkTf/UG6qUz7Z9HjWehMaJ3ETymj3b1I+CrfC9x22KDGThi/fUW8hMT/V7cXb3J2EFCGQaXeDqUv/1y0iSIZfwv76cYWZNfg1aCrnC+RGZ1cQ7NrR4ckbQgG9StnsAb+X1FqStW11xRTsVvTttdjrisGXI9dBqy0x/ikW91fE2YbLvlb48ANt13T3TdYHRpB3YtQy/4GCnpBnGVurTLZw71gBiVGIOUNInw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jphdFbQcqCygNrEGqinmRvb9upDBy+g/qvA+rRnOhP8=;
 b=SYYxwG0OsrpLcH4Q6CDa18r/qgihczGLjh7H3l0GDkZ+w53MzhVPPYaI5n3cKFjlWv4lOOLOM0uXIjJDG3KriE3w+ot7G4cNolUNacC3bEOdyxLaATCgROOyzrDkpv3/Z77QRHreailtiyGDQENGEwq50ixH/7jz1aF2VNUPinI8FcpcWnckIygsfHfrABHt4INlXI6o9X4MAB3ONKUVaBOkz1FCR7jaz00S7f+edoPhdqPB8ZybkE1Lr+v4Kbe/30fslCM3DNf+jXHGKilq7St6Mzdh6sCvIiWtOC8m/q9axraXxVMu86hH6/HQCvcOYivaQz+rj9e6GWYhI9lY5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jphdFbQcqCygNrEGqinmRvb9upDBy+g/qvA+rRnOhP8=;
 b=NYdFsYXX4yDXiFL7Tfpi03UbXXyFUwBxfcu1Ah8CAumhgn+kuBMN3OmR6XtBqEgcVgzUfQ6PZwBKhP0pmzP3DEM9JrHQibw3t2Q7JYVCdeZgNnyZ3uWYG0XFQxR7C6H0Rjm7ulI+IStOpsC8s0xiVm5z/vgnpcAWWAIUA9NoBcE=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW2PR2101MB1034.namprd21.prod.outlook.com (2603:10b6:302:a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.5; Thu, 2 Sep
 2021 03:32:03 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86%8]) with mapi id 15.20.4478.014; Thu, 2 Sep 2021
 03:32:03 +0000
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
Subject: RE: [PATCH V4 05/13] hyperv: Add Write/Read MSR registers via ghcb
 page
Thread-Topic: [PATCH V4 05/13] hyperv: Add Write/Read MSR registers via ghcb
 page
Thread-Index: AQHXm2gCMSN7/9Nrs0WqDjRR9LMyqquJGfKw
Date:   Thu, 2 Sep 2021 03:32:03 +0000
Message-ID: <MWHPR21MB15937EFF970147CEC61DE227D7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210827172114.414281-6-ltykernel@gmail.com>
In-Reply-To: <20210827172114.414281-6-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2fbe6f01-ab97-4a86-a26b-7e5e56e5a33e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-28T16:18:47Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1470254-253b-409a-9a29-08d96dc23b3a
x-ms-traffictypediagnostic: MW2PR2101MB1034:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB1034343B123E288F391ABD5BD7CE9@MW2PR2101MB1034.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:127;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qLKUGIr7FLuydpSAU/8sGZ+xE0tOXbhOYJ7JeyuXCj9gMJI28oJ3xLcB4MCazN7HHAvjeS/Ud+l753dD0ZgVT32um1Mx/ZD4d3JGXji6s1KYAk2q/Ky7l1e6RpE4luX4rVOd2gioJu02xeJ1Aykf0gm9CBC1ls0Y7GoMY/fXKZLqb/YDAYTop61raq2HF1DmaR6PWhwR8UBxSKLG3LQIlJRGNyEs/mP+NJ7hLnto3iWe9VOSI2EL4R5MSSvzKnR2sSsTHZiZWAQXwHiYyuANUakgaeMB0W0rg+4e59ukpIrxXPr7LgL5SEJJN51HxfeCeipaQgvmY6AWlaejF0wEqT1AG0D6yBxBgDAYqBH/bXPgz3AmPiDiklOXI3NRciHQB78G480xQhGsxw8dGMOV8M/jIj2ZzM68PRe/LQmFOBvJeXkeYGOcZ84915Gc6x0qWvbabCrcCbTnS/4iPN0/IJJ5QVqMAWDQsdaCVr99YfIEB0caHRVaFroyNOxyl482Pa+ubJDVZh78bkE7u6z4j4OBcAi+RKLbA7AmHVqIFUB4wt4IAJJSu+x/bgltGK/drCUWhD6/7a6NJyOIZ5lwhqPeZDaaXWRgkyrr8JIdkxsAXg1Y/SRnBFF4K/knyXAURiDQQRuJr2+K0HE0bgLFRdZq/RD9voETWt9mSxaikD8NUlZss/nJG6Pxidly8w19YOIChxXKJgnHvYf8YWwekGWryuTPyi7juTWMYD9k9Oc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8990500004)(55016002)(8676002)(186003)(30864003)(26005)(9686003)(82960400001)(82950400001)(71200400001)(83380400001)(38070700005)(8936002)(7406005)(38100700002)(33656002)(52536014)(54906003)(66946007)(4326008)(66446008)(66476007)(64756008)(122000001)(66556008)(76116006)(10290500003)(2906002)(921005)(6506007)(5660300002)(110136005)(7416002)(7696005)(7366002)(508600001)(316002)(86362001)(559001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B5IQac8XXoI6m6n27Qn50J6iupQuKS7E221ZRdCyye0Le6JfVsFtHXomwvMo?=
 =?us-ascii?Q?XfbrEc7tBAsCxOGO1hqQqFa4AlZEP8weaZ3czpp1mh02Z8NUkto3s+Xb29Q4?=
 =?us-ascii?Q?f24GPCTtJl1AObkdHjme+sYyrQ4ZylFSkzf3Bowsjh5GWXuzZSh8JCxDTHby?=
 =?us-ascii?Q?LULMRPrEK+Tr9s3EGYI7C+aYElVfg60PIUOFq2Rl95c95QD4P/1DyTMnL18+?=
 =?us-ascii?Q?J04O8qCtd3Ka2gIQrVUrXKxzlAPY3yyaIeP96cjbqq1kX5HKRsUfD/PV4BGw?=
 =?us-ascii?Q?XzQdDuXxmoQ5pVuA56Q52Yat9ut3sXYnBuGQttTrvcQrLZTLKJX7LiuaKXvR?=
 =?us-ascii?Q?ePMuIBTrjig7U0RXgO7C0Ui5eDHX9BF/PJ7XuopGyQkJ+/8uaz3UcNdu8Gev?=
 =?us-ascii?Q?aCYwKzLS0+c9lb6CRTZ6x+H2QviqPLPFjdDxKAsEMmBc8z7+Oagif1znE/Ui?=
 =?us-ascii?Q?VaZ0BezrilepyKsTV6cG4PYN5orWGEmPtq4asC1dT8r9LVcnuuj2xm1e5UTy?=
 =?us-ascii?Q?ka5Sv5xrAJLHFLMYD7XMWEch4S/yT1nsyySt8p6vq5awiBnaonh3gahObBnl?=
 =?us-ascii?Q?3jLwlVS4j28w3VfIWQ++wagwye0kXVlGoRdMrm8jDXOiO834heMF8JzTGi7L?=
 =?us-ascii?Q?RhKApIg8+zs713eMKa7IZWbdQEL41BVLrfj+FsfB9b4HQULQ/fbNwI0ssvAf?=
 =?us-ascii?Q?DYLP4rZwTkOoy21QOkbNqbEcQzgxC/b7tmQO6QRG7I0FTwLdLwQEWa3x7QgI?=
 =?us-ascii?Q?7QKeLVa5J19B0vHzKNpJpopoTzgQfDdnUS74fmx56RxYe3hHjZyhruIizOpu?=
 =?us-ascii?Q?p4DJ5iKvDcs+PC/E7+7cy5Jq3Xl70nR6ahz5k+VI1nx+G5qYg+l6lmuyH7Ey?=
 =?us-ascii?Q?x00pUuMmo74nxSLcFNm6w5UJ4q+MErjqYtzr7WvsUZX9HJnpAmt9r6rRbVwP?=
 =?us-ascii?Q?ngtc6ZPwe+mrEVL8ZXGdOEpKEnv/WvbGTD7HQ9eCUjEYLf7nrzjz7tKd5Wcs?=
 =?us-ascii?Q?gQEUp1h/X7YLNN3rLNozyBSOY0QzQMqXZ/cKb4vn4MKAa+vdcKwDOram6ZED?=
 =?us-ascii?Q?VBLnoWrEW8zHbwU98vQlAFri+Edn6VozfE79m1W1STEOYqEl5cD9RA/NjE4i?=
 =?us-ascii?Q?ASPXqecl8/hRFAWwUipQMqEr1fMI/myLPDwR0LAgduOVjsN0WRQTQPMwSCi7?=
 =?us-ascii?Q?Q7PvBfx5Gp39rfUvbQFxh7Hq8o+wp0JeK+UGuAPFIxjrCwIDKMDvQdmrI//9?=
 =?us-ascii?Q?Fh1YTE56V03umqHp/K2tB3TQwL+xGPZqqIdb0Aees/ni0+ha6YrW0H7cCq3S?=
 =?us-ascii?Q?qkVPssI+4XCiw8lC5sntpFL4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1470254-253b-409a-9a29-08d96dc23b3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 03:32:03.1186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vPzNSqamS7p5aXRDNKV/5JzW1XO7DWUJFW0QQGcNNAlVGQK0/oQWaD5sx5rOxa0wqmrqVlRCyigO1wAzb/PRDCUXClSEn+7Xor8QiiWC55I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1034
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Friday, August 27, 2021 10:21 =
AM
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
> Change since v1:
>          * Introduce sev_es_ghcb_hv_call_simple() and share code
>            between SEV and Hyper-V code.
> Change since v3:
>          * Pass old_msg_type to hv_signal_eom() as parameter.
> 	 * Use HV_REGISTER_* marcro instead of HV_X64_MSR_*
> 	 * Add hv_isolation_type_snp() weak function.
> 	 * Add maros to set syinc register in ARM code.
> ---
>  arch/arm64/include/asm/mshyperv.h |  23 ++++++
>  arch/x86/hyperv/hv_init.c         |  36 ++--------
>  arch/x86/hyperv/ivm.c             | 112 ++++++++++++++++++++++++++++++
>  arch/x86/include/asm/mshyperv.h   |  80 ++++++++++++++++++++-
>  arch/x86/include/asm/sev.h        |   3 +
>  arch/x86/kernel/sev-shared.c      |  63 ++++++++++-------
>  drivers/hv/hv.c                   | 112 ++++++++++++++++++++----------
>  drivers/hv/hv_common.c            |   6 ++
>  include/asm-generic/mshyperv.h    |   4 +-
>  9 files changed, 345 insertions(+), 94 deletions(-)
>=20
> diff --git a/arch/arm64/include/asm/mshyperv.h b/arch/arm64/include/asm/m=
shyperv.h
> index 20070a847304..ced83297e009 100644
> --- a/arch/arm64/include/asm/mshyperv.h
> +++ b/arch/arm64/include/asm/mshyperv.h
> @@ -41,6 +41,29 @@ static inline u64 hv_get_register(unsigned int reg)
>  	return hv_get_vpreg(reg);
>  }
>=20
> +#define hv_get_simp(val)	{ val =3D hv_get_register(HV_REGISTER_SIMP); }
> +#define hv_set_simp(val)	hv_set_register(HV_REGISTER_SIMP, val)
> +
> +#define hv_get_siefp(val)	{ val =3D hv_get_register(HV_REGISTER_SIEFP); =
}
> +#define hv_set_siefp(val)	hv_set_register(HV_REGISTER_SIEFP, val)
> +
> +#define hv_get_synint_state(int_num, val) {			\
> +	val =3D hv_get_register(HV_REGISTER_SINT0 + int_num);	\
> +	}
> +
> +#define hv_set_synint_state(int_num, val)			\
> +	hv_set_register(HV_REGISTER_SINT0 + int_num, val)
> +
> +#define hv_get_synic_state(val) {			\
> +	val =3D hv_get_register(HV_REGISTER_SCONTROL);	\
> +	}
> +
> +#define hv_set_synic_state(val)			\
> +	hv_set_register(HV_REGISTER_SCONTROL, val)
> +
> +#define hv_signal_eom(old_msg_type)		 \
> +	hv_set_register(HV_REGISTER_EOM, 0)
> +
>  /* SMCCC hypercall parameters */
>  #define HV_SMCCC_FUNC_NUMBER	1
>  #define HV_FUNC_ID	ARM_SMCCC_CALL_VAL(			\
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index b1aa42f60faa..be6210a3fd2f 100644
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
> index a069c788ce3c..f56fe4f73000 100644
> --- a/arch/x86/hyperv/ivm.c
> +++ b/arch/x86/hyperv/ivm.c
> @@ -6,13 +6,125 @@
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
>=20
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
> +
>  /*
>   * hv_mark_gpa_visibility - Set pages visible to host via hvcall.
>   *
> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyp=
erv.h
> index ffb2af079c6b..b77f4caee3ee 100644
> --- a/arch/x86/include/asm/mshyperv.h
> +++ b/arch/x86/include/asm/mshyperv.h
> @@ -11,6 +11,8 @@
>  #include <asm/paravirt.h>
>  #include <asm/mshyperv.h>
>=20
> +union hv_ghcb;
> +
>  DECLARE_STATIC_KEY_FALSE(isolation_type_snp);
>=20
>  typedef int (*hyperv_fill_flush_list_func)(
> @@ -30,6 +32,61 @@ static inline u64 hv_get_register(unsigned int reg)
>  	return value;
>  }
>=20
> +#define hv_get_sint_reg(val, reg) {		\
> +	if (hv_isolation_type_snp())		\
> +		hv_get_##reg##_ghcb(&val);	\
> +	else					\
> +		rdmsrl(HV_REGISTER_##reg, val);	\
> +	}
> +
> +#define hv_set_sint_reg(val, reg) {		\
> +	if (hv_isolation_type_snp())		\
> +		hv_set_##reg##_ghcb(val);	\
> +	else					\
> +		wrmsrl(HV_REGISTER_##reg, val);	\
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
> +		rdmsrl(HV_REGISTER_SCONTROL, val);	\
> +	}
> +#define hv_set_synic_state(val) {			\
> +	if (hv_isolation_type_snp())			\
> +		hv_set_synic_state_ghcb(val);		\
> +	else						\
> +		wrmsrl(HV_REGISTER_SCONTROL, val);	\
> +	}
> +
> +#define hv_signal_eom(old_msg_type) {		 \
> +	if (hv_isolation_type_snp() &&		 \
> +	    old_msg_type !=3D HVMSG_TIMER_EXPIRED) \
> +		hv_sint_wrmsrl_ghcb(HV_REGISTER_EOM, 0); \
> +	else						\
> +		wrmsrl(HV_REGISTER_EOM, 0);		\
> +	}
> +
> +#define hv_get_synint_state(int_num, val) {		\
> +	if (hv_isolation_type_snp())			\
> +		hv_get_synint_state_ghcb(int_num, &val);\
> +	else						\
> +		rdmsrl(HV_REGISTER_SINT0 + int_num, val);\
> +	}
> +#define hv_set_synint_state(int_num, val) {		\
> +	if (hv_isolation_type_snp())			\
> +		hv_set_synint_state_ghcb(int_num, val);	\
> +	else						\
> +		wrmsrl(HV_REGISTER_SINT0 + int_num, val);\
> +	}
> +
>  #define hv_get_raw_timer() rdtsc_ordered()
>=20
>  void hyperv_vector_handler(struct pt_regs *regs);
> @@ -41,7 +98,7 @@ extern void *hv_hypercall_pg;
>=20
>  extern u64 hv_current_partition_id;
>=20
> -extern void __percpu **hv_ghcb_pg;
> +extern union hv_ghcb  __percpu **hv_ghcb_pg;
>=20
>  int hv_call_deposit_pages(int node, u64 partition_id, u32 num_pages);
>  int hv_call_add_logical_proc(int node, u32 lp_index, u32 acpi_id);
> @@ -195,6 +252,25 @@ int hv_unmap_ioapic_interrupt(int ioapic_id, struct =
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


I'm not seeing the value in the multiple layers of #define to get and set t=
he
various syinc registers.  My thought was a completely different approach, w=
hich is
to simply implement the hv_get_register() and hv_set_register() functions w=
ith=20
a little bit more logic.  Here's my proposal.  This code is not even compil=
e tested,
but you get the idea:

static bool hv_is_synic_reg(unsigned int reg)
{
	if ((reg >=3D HV_REGISTER_SCONTROL) &&
	    (reg <=3D HV_REGISTER_SINT15))
		return true;
	return false;
}

u64 hv_get_register(unsigned int reg)
{
	u64 value;

	if (hv_is_synic_reg(reg) && hv_isolation_type_snp())
		hv_ghcb_msr_read(reg, &value);
	else
		rdmsrl(reg, value);
	return value;
}

void hv_set_register(unsigned int reg, u64 value)
{
	if (hv_is_synic_reg(reg) && hv_isolation_type_snp()) {
		hv_ghcb_msr_write(reg, value);

		/* Write proxy bit via wrmsl instruction */
		if (reg >=3D HV_REGISTER_SINT0 &&
		    reg <=3D HV_REGISTER_SINT15)
			wrmsrl(reg, value | 1 << 20);
	} else {
		wrmsrl(reg, value);
	}
}

If the above code is implemented in one of the modules under arch/x86
to replace the existing implementations in arch/x86/include/asm/mshyper.h,
then it will only be built for x86/x64, and the existing code will just wor=
k
for ARM64.   Architecture neutral code in hv_synic_enable_regs() and
hv_synic_disable_regs() will still need check for hv_isolation_type_snp()
and take some special actions, but the calls to hv_get_register() and
hv_set_register() can remain unchanged.

This approach seems a lot simpler to me, but maybe I'm missing
something that your current patch is doing.

Your code does have a special case for HV_REGISTER_EOM.  Is
there a reason it needs to do an additional check of the old_msg_type?
I'm just not understanding why an SNP isolated VM requires
special treatment of this register.

A key point:  Getting/setting any of the synthetic MSRs requires
a trap to the hypervisor.  So they already not super-fast.  The
only code path in Linux that is performance sensitive is setting
HV_REGISTER_STIMER0_COUNT in hv_ce_set_next_event().
That's not a synic register, so the only additional burden with the
above implementation is checking the MSR value to see if it is
in the synic range.  The cost of that check is reasonable for
something that has to trap to the hypervisor anyway.


>  #else /* CONFIG_HYPERV */
>  static inline void hyperv_init(void) {}
>  static inline void hyperv_setup_mmu_ops(void) {}
> @@ -211,9 +287,9 @@ static inline int hyperv_flush_guest_mapping_range(u6=
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
> index e83507f49676..97b21256a9db 100644
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
> @@ -199,26 +207,43 @@ void hv_synic_enable_regs(unsigned int cpu)
>  	union hv_synic_scontrol sctrl;
>=20
>  	/* Setup the Synic's message page */
> -	simp.as_uint64 =3D hv_get_register(HV_REGISTER_SIMP);
> +	hv_get_simp(simp.as_uint64);
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
> @@ -233,14 +258,12 @@ void hv_synic_enable_regs(unsigned int cpu)
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
> @@ -257,37 +280,50 @@ int hv_synic_init(unsigned int cpu)
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
> index aa55447b9700..04a687d95eac 100644
> --- a/include/asm-generic/mshyperv.h
> +++ b/include/asm-generic/mshyperv.h
> @@ -24,6 +24,7 @@
>  #include <linux/cpumask.h>
>  #include <linux/nmi.h>
>  #include <asm/ptrace.h>
> +#include <asm/mshyperv.h>
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
> @@ -148,7 +150,7 @@ static inline void vmbus_signal_eom(struct hv_message=
 *msg, u32 old_msg_type)
>  		 * possibly deliver another msg from the
>  		 * hypervisor
>  		 */
> -		hv_set_register(HV_REGISTER_EOM, 0);
> +		hv_signal_eom(old_msg_type);
>  	}
>  }
>=20
> --
> 2.25.1

