Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0953EAB17
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 21:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhHLTgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 15:36:39 -0400
Received: from mail-bn1nam07on2122.outbound.protection.outlook.com ([40.107.212.122]:22497
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229531AbhHLTgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 15:36:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNEx1uto80Ra+gK6zSmrf+7BFPzLQXo2y2CBzVUmPvRYpk3Bl4xwYsrYnuFPTGxajgn7BpQTuiOde1JDE/ZOmBQ73R+QcTWPvB46ER1BEdvs0lwAy8TMitEYfNsxt+ZbEYCn1zQTF267d/NgkxSp+BPU4DX5BjT30bTG4UYFuhK8h3lQFP/i7+C8qOWJz+zuLXD0FEq+JkoGflWV9Dz0TXIbd9MK+nQp8nLppasiBLMVhONsmF+BS2UJTFMH9jTin58yJ+mFKsPCmmxf78jrqa53avv4TJx0OGCLakG4Ht1QXjoE9JOUgQ7L4f4OFvTLsTEkUL0yuX43x+Orh5vh5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wM25SJ3Up4/7J7O8staMgksHsHt0fEx4uZJw6yF05n8=;
 b=BmsqndxNfvdfkECVmVzP5Mnugf1hVqhkq192zW8FfAdGs1OHn3ojzHTSUQD2svWIyWP5BR5MPlPmWRckXjuyZxk+BcglR/p1bwNNkpOVeGQXDDZSGQcUzrZxE3s8w/uu3kZIvxEGW/pEN1ttQJEpYIXC6LqFBTEe/xtp8bBT4nTMRdWstxzwjPdVnNQ7JlOpEh1iYbVayB+rUnZTcNOkfe+2jOwypDC+ibtvMm8BclDPFhAYtzhH8GvdXThV8J2WtBo3TfQFLybqmW+Obu0V27Rz6BwyloA5U+Gh+U/PbpErI6Oom1BEcijpXdOumtMCK5tIH6rXrlaw61++kQ/P7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wM25SJ3Up4/7J7O8staMgksHsHt0fEx4uZJw6yF05n8=;
 b=fmzqNw7t4u+fvYRgd13bCgilff6/91mqpTwkwiW8u7l6sHXnlvi5gPY0c/nAEgDXkZFbwRjtliEDYEks+ZxxG95H+ZMY4R32Oz8t28UD5rVLjBGFqiJsnX4gXxhhzMmY+uUDM88+TNlou0CHld+d5eAcoUK7AhHrtD3RHDMVEmU=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW2PR2101MB1036.namprd21.prod.outlook.com (2603:10b6:302:a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.4; Thu, 12 Aug
 2021 19:36:06 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55%2]) with mapi id 15.20.4436.012; Thu, 12 Aug 2021
 19:36:05 +0000
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
Subject: RE: [PATCH V3 03/13] x86/HV: Add new hvcall guest address host
 visibility support
Thread-Topic: [PATCH V3 03/13] x86/HV: Add new hvcall guest address host
 visibility support
Thread-Index: AQHXjUfncf0WY7cz0E6uX1luWMHXpKtwQyKw
Date:   Thu, 12 Aug 2021 19:36:05 +0000
Message-ID: <MWHPR21MB1593076766939A1FEC36AFB9D7F99@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-4-ltykernel@gmail.com>
In-Reply-To: <20210809175620.720923-4-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f59d3f6e-54e2-48d7-ba3a-4be654f8ed09;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-12T19:18:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aebc45f2-bacc-446b-28b1-08d95dc86d50
x-ms-traffictypediagnostic: MW2PR2101MB1036:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB1036C7E924ED7AAF33BED868D7F99@MW2PR2101MB1036.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4zpU7/rxMBy8o3RIzEOzI4zyyYL/J1yxvVhmheK2h50lClh13F4csT42lWQHRzIZvvDmzx4gdBAyWMWjmA3IvP8jso3M1H+qKoEs9vyc70KrRsSBqPkzyL5i6QDTRlqS5vuNwT6dWSG7sKV6PSQx59jJuBfMKMEMs/57lf7zaey8rKJs+OEUPZ8cmxVYlvO/8rp9Y9UYJo6kBS93FF84on83+TlY0m34P4CCodHvTTj8lK/tgDqKYvdlLC/FmVPWJaQrIm5o53/gnHLhR5TQjeMd64axO1myHfhRE+21AupfuIgeeAaPut3HShI/pbRuyfVUJskmH0Cri+64dz7Ka3jF0UA8Gc/UFal3mmqsdcqaox/DqbCM978cvyC07uZWhKzL0vpR7fuoTKL89E38omJpSGPMqZy3Uatnf5i3uQ0GMkj/0Y0Bgh21M3HFLEUwdtmMVWmhkcHMuDBbuqUJWgCHSSioa8Gyfr0rfBBc8W5HyvF3Iuags3MebHinUlN55lstqoRCdfvitbkkk6qyoXvxcL7VRgbTQv7aqcx5HZqcJfoYwnvt3WlafvF1+fgfKGoZE77HDOX2iQVO6qnLRqzEU6UKRBvG+ejcxm5w4hNjRsBlB+Gbz6xwdRBVj7eVKGLMP8AlgxM3hg/sLRFUoNKcFopIFmap9BvgoNkkXAD4fZjSwucoD5rN27bmN8mtR05a9laawxKla4zRL9UUigCEa5ZkwcA2f2XoRJTAdrg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(5660300002)(53546011)(122000001)(26005)(8936002)(6506007)(38100700002)(4326008)(7416002)(38070700005)(2906002)(921005)(8990500004)(7406005)(82960400001)(82950400001)(52536014)(7696005)(9686003)(8676002)(76116006)(55016002)(86362001)(508600001)(33656002)(71200400001)(10290500003)(83380400001)(110136005)(66476007)(66556008)(54906003)(66446008)(64756008)(316002)(30864003)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UNz+PLuMNgcBzWPw2v6ezG7Aokw/qh+OHNLej2hL8iR52U7PtUiDbkofLeIn?=
 =?us-ascii?Q?pTrtpcsVqnawuQi6MXjPSdYCm/ZNwKWLXyr1fVF87jWsW6UzKan5MmcTw4G2?=
 =?us-ascii?Q?2RswgNa+tLLy1wrR45J4+uxh9hY097lMRvoUimi0LcYtBfHG86apKM4+H80h?=
 =?us-ascii?Q?roBY/ip2B1dgb3K0m1/G9r4VI+sHhDGf/vmXjIQubXYbqynzvVedtBefR2gF?=
 =?us-ascii?Q?5ExxB6CYTwYMDBl6PuOmYtepYxD/DbWrP9K4guwXlmYRHp42XgTkVF1YAZPE?=
 =?us-ascii?Q?2zkt80Hi2f0iVB0+bL7qrns208JjruM46Spwb8U93cMPn9OiTGR11NX5ptH4?=
 =?us-ascii?Q?rs0WU06HmltI3ERu1feFuu8L3ZGpcbu0eM/As4l8s2XPkPjTJdnJlZ3/NDd+?=
 =?us-ascii?Q?nKl62JFo1sp5WxhkuuqEXZ8bk5kCPGkjoEUA37clGPmAMBw5jEsXRDAvl+wd?=
 =?us-ascii?Q?ZzUXgk+eujVpXdcW7lFjWZ1QAtAW4jgupR0xG9j9KMoexFDpZbnOog2LAsi8?=
 =?us-ascii?Q?J2FKklCU6G1lwLg3uEJY/C4jt1SS6Pj9RyZg/J6RMIVQyEYBYRYtB7UKTEAj?=
 =?us-ascii?Q?2XRZaAxXOBsHjvDWLMIL3vvu1kszL5x3k5pMB2AoTKW/0/MdRYZ/D+G/47BE?=
 =?us-ascii?Q?Ib8Zh231D+FImLvrBzlS/Qd/FIB/P3GT/mhfPBv8o8FMfUHeDEEHEUuF3A1z?=
 =?us-ascii?Q?MYQzQShblw+WqZb+GcHm6Ee67wVuhhSAUln33Tr3DyuBfwJnf4aXM77CuzWe?=
 =?us-ascii?Q?O8q5RGQpgrUdSTvVtYV6MxJSDQCoIMFVGnjtxSIkvzakPiWAr6utrWdPvX6z?=
 =?us-ascii?Q?E6DSf844PdkJptidrUbNZVuI6MeyaSOdqCTTQx427xXPOcOBpmHUOw4tsvMY?=
 =?us-ascii?Q?rI6h69JtPT5D7dqn14GyTisDqQ5m6sXyZqc1v8lc/KJu6Ml8/s7aWlyBbDio?=
 =?us-ascii?Q?EVO55h9tjU9OXJEHZq2TGMjxDw7IKHnDnX3bL2qealcOFWqmxhqKjfk6kqQl?=
 =?us-ascii?Q?sjbVXAH9ZtkHy4ziCc52s2nMQzcQwt6RE6FVSkFiJRzQwyKJhwa47EQhrDD6?=
 =?us-ascii?Q?HJVBFq5FBKVLvFxtkpmY7sZz3Di2pfhRWtGvQgmyLOULzOau1yWHRBmIPyMq?=
 =?us-ascii?Q?tLVIAJN/WyVz0IogucgOQqdkZHLAkOGGbWM7UIZGLThlbkIVevH1kVGdPoaB?=
 =?us-ascii?Q?EQI5wUFTjMjmcOuwWxbzyoWg+EujCdhUAljwTHbDjirDz7nuV2AmwNf1EfOG?=
 =?us-ascii?Q?34XJ7xX5YVeDfS9S7/r9U3GVjBmWdbG20cu0kaa5jm0XCZ3GajJ7N76aokHX?=
 =?us-ascii?Q?KxW18rdfjWjH3vmim1ITo6YD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aebc45f2-bacc-446b-28b1-08d95dc86d50
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 19:36:05.7148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /WVT5CCoUtRHvjNRck0rLCN2qEM9h+0plrC2oM5vBphBhj3Ot3y4cS9w73MR+EVNFJ4xcZz5Cp02eMYPFSCq7iGrgG4AdKDlI+8B630vRNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1036
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Monday, August 9, 2021 10:56 A=
M
> Subject: [PATCH V3 03/13] x86/HV: Add new hvcall guest address host visib=
ility support

Use "x86/hyperv:" tag in the Subject line.

>=20
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>=20
> Add new hvcall guest address host visibility support to mark
> memory visible to host. Call it inside set_memory_decrypted
> /encrypted(). Add HYPERVISOR feature check in the
> hv_is_isolation_supported() to optimize in non-virtualization
> environment.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v2:
>        * Rework __set_memory_enc_dec() and call Hyper-V and AMD function
>          according to platform check.
>=20
> Change since v1:
>        * Use new staic call x86_set_memory_enc to avoid add Hyper-V
>          specific check in the set_memory code.
> ---
>  arch/x86/hyperv/Makefile           |   2 +-
>  arch/x86/hyperv/hv_init.c          |   6 ++
>  arch/x86/hyperv/ivm.c              | 114 +++++++++++++++++++++++++++++
>  arch/x86/include/asm/hyperv-tlfs.h |  20 +++++
>  arch/x86/include/asm/mshyperv.h    |   4 +-
>  arch/x86/mm/pat/set_memory.c       |  19 +++--
>  include/asm-generic/hyperv-tlfs.h  |   1 +
>  include/asm-generic/mshyperv.h     |   1 +
>  8 files changed, 160 insertions(+), 7 deletions(-)
>  create mode 100644 arch/x86/hyperv/ivm.c
>=20
> diff --git a/arch/x86/hyperv/Makefile b/arch/x86/hyperv/Makefile
> index 48e2c51464e8..5d2de10809ae 100644
> --- a/arch/x86/hyperv/Makefile
> +++ b/arch/x86/hyperv/Makefile
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -obj-y			:=3D hv_init.o mmu.o nested.o irqdomain.o
> +obj-y			:=3D hv_init.o mmu.o nested.o irqdomain.o ivm.o
>  obj-$(CONFIG_X86_64)	+=3D hv_apic.o hv_proc.o
>=20
>  ifdef CONFIG_X86_64
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index 0bb4d9ca7a55..b3683083208a 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -607,6 +607,12 @@ EXPORT_SYMBOL_GPL(hv_get_isolation_type);
>=20
>  bool hv_is_isolation_supported(void)
>  {
> +	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
> +		return 0;
> +
> +	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
> +		return 0;
> +
>  	return hv_get_isolation_type() !=3D HV_ISOLATION_TYPE_NONE;

Could all of the tests in this function be run at initialization time, and
a single Boolean value pre-computed that this function returns?  I don't
think any of tests would change during the lifetime of the Linux instance,
so running the tests every time is slower than it needs to be.

>  }
>=20
> diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
> new file mode 100644
> index 000000000000..8c905ffdba7f
> --- /dev/null
> +++ b/arch/x86/hyperv/ivm.c
> @@ -0,0 +1,114 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Hyper-V Isolation VM interface with paravisor and hypervisor
> + *
> + * Author:
> + *  Tianyu Lan <Tianyu.Lan@microsoft.com>
> + */
> +
> +#include <linux/hyperv.h>
> +#include <linux/types.h>
> +#include <linux/bitfield.h>
> +#include <linux/slab.h>
> +#include <asm/io.h>
> +#include <asm/mshyperv.h>
> +
> +/*
> + * hv_mark_gpa_visibility - Set pages visible to host via hvcall.
> + *
> + * In Isolation VM, all guest memory is encripted from host and guest
> + * needs to set memory visible to host via hvcall before sharing memory
> + * with host.
> + */
> +int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
> +			   enum hv_mem_host_visibility visibility)
> +{
> +	struct hv_gpa_range_for_visibility **input_pcpu, *input;
> +	u16 pages_processed;
> +	u64 hv_status;
> +	unsigned long flags;
> +
> +	/* no-op if partition isolation is not enabled */
> +	if (!hv_is_isolation_supported())
> +		return 0;
> +
> +	if (count > HV_MAX_MODIFY_GPA_REP_COUNT) {
> +		pr_err("Hyper-V: GPA count:%d exceeds supported:%lu\n", count,
> +			HV_MAX_MODIFY_GPA_REP_COUNT);
> +		return -EINVAL;
> +	}
> +
> +	local_irq_save(flags);
> +	input_pcpu =3D (struct hv_gpa_range_for_visibility **)
> +			this_cpu_ptr(hyperv_pcpu_input_arg);
> +	input =3D *input_pcpu;
> +	if (unlikely(!input)) {
> +		local_irq_restore(flags);
> +		return -EINVAL;
> +	}
> +
> +	input->partition_id =3D HV_PARTITION_ID_SELF;
> +	input->host_visibility =3D visibility;
> +	input->reserved0 =3D 0;
> +	input->reserved1 =3D 0;
> +	memcpy((void *)input->gpa_page_list, pfn, count * sizeof(*pfn));
> +	hv_status =3D hv_do_rep_hypercall(
> +			HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY, count,
> +			0, input, &pages_processed);
> +	local_irq_restore(flags);
> +
> +	if (!(hv_status & HV_HYPERCALL_RESULT_MASK))
> +		return 0;

pages_processed should also be checked to ensure that it equals count.
If not, something has gone wrong in the hypercall.

> +
> +	return hv_status & HV_HYPERCALL_RESULT_MASK;
> +}
> +EXPORT_SYMBOL(hv_mark_gpa_visibility);
> +
> +static int __hv_set_mem_host_visibility(void *kbuffer, int pagecount,
> +				      enum hv_mem_host_visibility visibility)
> +{
> +	u64 *pfn_array;
> +	int ret =3D 0;
> +	int i, pfn;
> +
> +	if (!hv_is_isolation_supported() || !ms_hyperv.ghcb_base)
> +		return 0;
> +
> +	pfn_array =3D kzalloc(HV_HYP_PAGE_SIZE, GFP_KERNEL);

Does the page need to be zero'ed?  All bytes that are used will
be explicitly written in the loop below.

> +	if (!pfn_array)
> +		return -ENOMEM;
> +
> +	for (i =3D 0, pfn =3D 0; i < pagecount; i++) {
> +		pfn_array[pfn] =3D virt_to_hvpfn(kbuffer + i * HV_HYP_PAGE_SIZE);
> +		pfn++;
> +
> +		if (pfn =3D=3D HV_MAX_MODIFY_GPA_REP_COUNT || i =3D=3D pagecount - 1) =
{
> +			ret |=3D hv_mark_gpa_visibility(pfn, pfn_array,
> +					visibility);

I don't see why value of "ret" is OR'ed.   If the result of hv_mark_gpa_vis=
ibility()
is ever non-zero, we'll exit immediately.  There's no need to accumulate th=
e
results of multiple calls to hv_mark_gpa_visibility().

> +			pfn =3D 0;
> +
> +			if (ret)
> +				goto err_free_pfn_array;
> +		}
> +	}
> +
> + err_free_pfn_array:
> +	kfree(pfn_array);
> +	return ret;
> +}
> +
> +/*
> + * hv_set_mem_host_visibility - Set specified memory visible to host.
> + *
> + * In Isolation VM, all guest memory is encrypted from host and guest
> + * needs to set memory visible to host via hvcall before sharing memory
> + * with host. This function works as wrap of hv_mark_gpa_visibility()
> + * with memory base and size.
> + */
> +int hv_set_mem_host_visibility(unsigned long addr, int numpages, bool vi=
sible)
> +{
> +	enum hv_mem_host_visibility visibility =3D visible ?
> +			VMBUS_PAGE_VISIBLE_READ_WRITE : VMBUS_PAGE_NOT_VISIBLE;
> +
> +	return __hv_set_mem_host_visibility((void *)addr, numpages, visibility)=
;
> +}
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hy=
perv-tlfs.h
> index 2322d6bd5883..1691d2bce0b7 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -276,6 +276,13 @@ enum hv_isolation_type {
>  #define HV_X64_MSR_TIME_REF_COUNT	HV_REGISTER_TIME_REF_COUNT
>  #define HV_X64_MSR_REFERENCE_TSC	HV_REGISTER_REFERENCE_TSC
>=20
> +/* Hyper-V memory host visibility */
> +enum hv_mem_host_visibility {
> +	VMBUS_PAGE_NOT_VISIBLE		=3D 0,
> +	VMBUS_PAGE_VISIBLE_READ_ONLY	=3D 1,
> +	VMBUS_PAGE_VISIBLE_READ_WRITE	=3D 3
> +};
> +
>  /*
>   * Declare the MSR used to setup pages used to communicate with the hype=
rvisor.
>   */
> @@ -587,4 +594,17 @@ enum hv_interrupt_type {
>=20
>  #include <asm-generic/hyperv-tlfs.h>
>=20
> +/* All input parameters should be in single page. */
> +#define HV_MAX_MODIFY_GPA_REP_COUNT		\
> +	((PAGE_SIZE / sizeof(u64)) - 2)
> +
> +/* HvCallModifySparseGpaPageHostVisibility hypercall */
> +struct hv_gpa_range_for_visibility {
> +	u64 partition_id;
> +	u32 host_visibility:2;
> +	u32 reserved0:30;
> +	u32 reserved1;
> +	u64 gpa_page_list[HV_MAX_MODIFY_GPA_REP_COUNT];
> +} __packed;
> +

We should avoid adding definitions *after* the #include of
<asm-generic/hyperv-tlfs.h>.   That #include should be last.  Any
reason these can't go earlier?  And they really go together with
enum hv_mem_host_visibility.

Separately, take a look at how the structure hv_memory_hint
and HV_MEMORY_HINT_MAX_GPA_PAGE_RANGES is handled.
It's a close parallel to what you are doing above, and is a slightly
cleaner approach.

>  #endif
> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyp=
erv.h
> index 6627cfd2bfba..87a386fa97f7 100644
> --- a/arch/x86/include/asm/mshyperv.h
> +++ b/arch/x86/include/asm/mshyperv.h
> @@ -190,7 +190,9 @@ struct irq_domain *hv_create_pci_msi_domain(void);
>  int hv_map_ioapic_interrupt(int ioapic_id, bool level, int vcpu, int vec=
tor,
>  		struct hv_interrupt_entry *entry);
>  int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *=
entry);
> -
> +int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
> +			   enum hv_mem_host_visibility visibility);
> +int hv_set_mem_host_visibility(unsigned long addr, int numpages, bool vi=
sible);
>  #else /* CONFIG_HYPERV */
>  static inline void hyperv_init(void) {}
>  static inline void hyperv_setup_mmu_ops(void) {}
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index ad8a5c586a35..1e4a0882820a 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -29,6 +29,8 @@
>  #include <asm/proto.h>
>  #include <asm/memtype.h>
>  #include <asm/set_memory.h>
> +#include <asm/hyperv-tlfs.h>
> +#include <asm/mshyperv.h>
>=20
>  #include "../mm_internal.h"
>=20
> @@ -1980,15 +1982,11 @@ int set_memory_global(unsigned long addr, int num=
pages)
>  				    __pgprot(_PAGE_GLOBAL), 0);
>  }
>=20
> -static int __set_memory_enc_dec(unsigned long addr, int numpages, bool e=
nc)
> +static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bo=
ol enc)
>  {
>  	struct cpa_data cpa;
>  	int ret;
>=20
> -	/* Nothing to do if memory encryption is not active */
> -	if (!mem_encrypt_active())
> -		return 0;
> -
>  	/* Should not be working on unaligned addresses */
>  	if (WARN_ONCE(addr & ~PAGE_MASK, "misaligned address: %#lx\n", addr))
>  		addr &=3D PAGE_MASK;
> @@ -2023,6 +2021,17 @@ static int __set_memory_enc_dec(unsigned long addr=
, int numpages, bool enc)
>  	return ret;
>  }
>=20
> +static int __set_memory_enc_dec(unsigned long addr, int numpages, bool e=
nc)
> +{
> +	if (hv_is_isolation_supported())
> +		return hv_set_mem_host_visibility(addr, numpages, !enc);
> +
> +	if (mem_encrypt_active())
> +		return __set_memory_enc_pgtable(addr, numpages, enc);
> +
> +	return 0;
> +}
> +
>  int set_memory_encrypted(unsigned long addr, int numpages)
>  {
>  	return __set_memory_enc_dec(addr, numpages, true);
> diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hype=
rv-tlfs.h
> index 56348a541c50..8ed6733d5146 100644
> --- a/include/asm-generic/hyperv-tlfs.h
> +++ b/include/asm-generic/hyperv-tlfs.h
> @@ -158,6 +158,7 @@ struct ms_hyperv_tsc_page {
>  #define HVCALL_RETARGET_INTERRUPT		0x007e
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
> +#define HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY 0x00db
>=20
>  /* Extended hypercalls */
>  #define HV_EXT_CALL_QUERY_CAPABILITIES		0x8001
> diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyper=
v.h
> index aa26d24a5ca9..079988ed45b9 100644
> --- a/include/asm-generic/mshyperv.h
> +++ b/include/asm-generic/mshyperv.h
> @@ -255,6 +255,7 @@ bool hv_query_ext_cap(u64 cap_query);
>  static inline bool hv_is_hyperv_initialized(void) { return false; }
>  static inline bool hv_is_hibernation_supported(void) { return false; }
>  static inline void hyperv_cleanup(void) {}
> +static inline hv_is_isolation_supported(void);
>  #endif /* CONFIG_HYPERV */
>=20
>  #endif
> --
> 2.25.1

