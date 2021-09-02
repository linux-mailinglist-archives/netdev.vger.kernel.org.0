Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F9E3FE674
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243433AbhIBARh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 20:17:37 -0400
Received: from mail-oln040093008011.outbound.protection.outlook.com ([40.93.8.11]:21136
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237130AbhIBARg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 20:17:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4w4QNo088iiDF7WpKo5d2HaaMS7RSYImGHIUr5/Tl//9csWEPwMnnX2KMUrNybliUOgQ1Sloxs+2j4rmwjbJmbbCIBFvjtlz85hZLLBGZ9TgOZToBXaRJNMNWSh91AKGSmyqtSiJLtdqOIfO9CUqDD/lyATiZqihVd1+b7QXC3XEfL9OooQ9O2zKto4VlElV7nm1X1EUtzlAIPyEeANEtDH+Pkt0VaPyroFgHjcCpROgDjTGRX2SX6BgaB1KNjxaxkB+8+IuhBBux5xF5RypFjlKhA2/LPxDLEXvGBl0Jc79ULx4pZSkdMiUKyGTCmQteA7HoztderafBWQw0665w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rGjVQNUXVDO4QwZnYpGSTcEEWMpwB5D9QDdioJ1qzYM=;
 b=PPe4WGH5WOMJJijs85AS7NtP8dE8jdNfodo5az0kecFnWGgjTwrXGbc9Bh0EAjFfakMIMPH6l6CtKKOoWWuvjKFH3+4d+9ljimrIrYwSN+i2dH62SPQRPb6tqiDK05RKcFCzyKhPqTaIRSAgGUm7yi0qk7FuOQKeHOYi/wjFy+dE29M1+V8+mapMfVrNwrUmKBz6xeqX/m/1sawbUL2LAmoXos6PljQVPjoxb6Wms0ANUoGpPw//MmbKYH7PsPRWz/Qkyx17lxkvFx//MTcFLbDp9k8pSdAKPg8Dq6KnCnlXyrg5J5xVAGGzUVFcR4RtyHIQz+4/u0u0o+y75NwpiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGjVQNUXVDO4QwZnYpGSTcEEWMpwB5D9QDdioJ1qzYM=;
 b=MIeMV26IwzWTaPJPirf8QDvR17EiHNKPWCapnyJH/eF0HmSxebOyZBlG7hPUktF8//ikMwtRGa7AFnHi3W1X2Qbzi7HAo2tLcka+rlM3qE2lfM6KqNdmMWAAHw9zQHACwHW1ZBU1ZZxBMqYE+geJk41lwvqvn/qXYcZDChSn0pc=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by CO1PR21MB1314.namprd21.prod.outlook.com (2603:10b6:303:151::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.4; Thu, 2 Sep
 2021 00:16:34 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86%8]) with mapi id 15.20.4478.014; Thu, 2 Sep 2021
 00:16:34 +0000
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
Subject: RE: [PATCH V4 03/13] x86/hyperv: Add new hvcall guest address host
 visibility support
Thread-Topic: [PATCH V4 03/13] x86/hyperv: Add new hvcall guest address host
 visibility support
Thread-Index: AQHXm2f+zKaCHZTB30K5pZMyKctp/auH8Tww
Date:   Thu, 2 Sep 2021 00:16:34 +0000
Message-ID: <MWHPR21MB159348E5A5BE84C36E84800AD7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210827172114.414281-4-ltykernel@gmail.com>
In-Reply-To: <20210827172114.414281-4-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a96f9a08-110c-4822-a43b-0d2d08ef1746;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-27T22:36:48Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a47f00d8-8849-4fbb-ac96-08d96da6ec39
x-ms-traffictypediagnostic: CO1PR21MB1314:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CO1PR21MB1314DBA2810799F5F62DE9C5D7CE9@CO1PR21MB1314.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bTLYupGy/LbS0xQhhUnKkQfH9+pV+XrKMU1UnFme7fWER5H9Lr3jDBjpUkxY0EkbkHZcSGWKDKclo+u+QKdSeGEisecMjpytRwf9xNfDlXpv+V8ENWd8PKHKIw3kARh0Nh4V/da9ORN23Kh/DeSFEBtzpFBrP6xMANv7yrPfXAvaaI58RXcIP1t1jhNgAFHHfj4UnnmnWR0o7fZSjReGnURTZCdxeb8/swyFn581WqpbFyTD8bcn9OfkaRMwmG6Sgbj+5qifE3gIXkITOw/zFaiCeWNoxi2jn8R3kZiYnYwIOLUMVhy9qXs3wSgiLiQsvrHnIlf+UZWaEmvilnyR3usEack32K63cAqL/B3NrrzuOM8L6nxRO9m4uMVT/nHl/t9QHlqolHaVENQOrlh2jSLkkluiH+Nr0XB9w70sesqPJF7aE/okVzfkm+6+yTbL9VvrEllLpMtBpRj5wQWzoAij3Puc0gM168glxxBQj18MAockWNwPgLDseDANo9f+p54S71AL4p5jowoDOUySP/FxCZz6RKJX1bay9EtELMdVRumApAMrrF4rvD/7i3KH8VloBbAn6uhuo8WlMCoZFayEMRJ6diiBg9dYV+1pHd+1g4dIHfN6oiPz/jbEGea9VRy3gCGeopeTZGJqO5SbZOlGkmD+BWXv+FK8gt5I1gQ1XzdtpmBLne4S2tacAqqJi3kKqW/xFvMXia3b7ipzAcq4V8is9c4ng75n34p5f74=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(10290500003)(7696005)(186003)(66946007)(6506007)(76116006)(38100700002)(8676002)(110136005)(9686003)(316002)(54906003)(71200400001)(38070700005)(8990500004)(86362001)(55016002)(2906002)(122000001)(508600001)(8936002)(4326008)(7406005)(5660300002)(7416002)(7366002)(33656002)(52536014)(83380400001)(82950400001)(30864003)(66556008)(82960400001)(921005)(66476007)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Oyj20tWEpY4HT/oJ0UQqteE/BHXeBnXQUewR3f2TeAjvT1uuMkia78HGPYvo?=
 =?us-ascii?Q?/uacGbRrpw/7VcTrGhpFMstHzc0fC8fO7Uw5Bb0kUKI1fOQdpN83fNfQxbXW?=
 =?us-ascii?Q?D5OCEJMIVHVv6Ncg9Cxv2+sUly5BVW4t9Yk+IVGKbuVnNhDV6uKotO5ve6lg?=
 =?us-ascii?Q?uwBlEL0ci6e3XakoPhb7mbCI7RYJZjcwyAc7uST8rLK6w7K0ne/NzfRKFnh6?=
 =?us-ascii?Q?rRA8hpkvJjEktQiB61q1wFPWr8mRdW0/CmTBfD33kAy7SGey2SPSuCm/BG8s?=
 =?us-ascii?Q?Kv95F7VSo9HxxJSjYIq5ibFONL1FXWgPjofkqblmd2ovd2ad/mLcvV4ISWcE?=
 =?us-ascii?Q?WwGaFkpatO2zq9l1RaWGgsxeX03ZP3W+cDtE2qByEZlVJvpRZie9XaiIzwFc?=
 =?us-ascii?Q?QvRtnO0wTQiAFv/Vo5Vx40kiTtmbKCXnbQG+dzlZlDts2z0/IbnRaxU6d6P9?=
 =?us-ascii?Q?yhoMNLAYM58UQs119ru35xWRyLJ/nN5vDMTwH4pmttQUmaHj6ZMBvJ41kOFC?=
 =?us-ascii?Q?Hwc24zW7BlOi9Y68VlvcZ/2G1w3FTSgO/ArRJ/1IKeJ7e24Yt4wdA+d15FiP?=
 =?us-ascii?Q?qzX0q2jA0GHD/fvrYz9dkmx8yf/vNMSCv2xzAoK4QO6owDL5uuxSIwlJNVcj?=
 =?us-ascii?Q?Uedr/m9USGqqXg9RwWw2kuwQX39q0U1Wbmug0D4NGxbnHxYynPZBs/7rL3l2?=
 =?us-ascii?Q?SDWbHl0oj4wADgD/bpFhaz91PMv68rklAYXj/5GdNzMzWYWUONKQsznKKGwH?=
 =?us-ascii?Q?KIXB4VWEO+5wW0vuO5ydrPUgXzk86IcWBdhq36tmpZI360haF53Ts8U4Vc/6?=
 =?us-ascii?Q?82+mvgYqeVGfKB1EHNTv/w1CVUnKMnbcKtXSWLbp4gNxS2htKc7NscF5IJ5u?=
 =?us-ascii?Q?qiLG9VBT6F9dMweSXpR50DgSmgQrT1Aag8QgXb6RJeA+BIOZ+3vT4ujLf+CI?=
 =?us-ascii?Q?azag7e+UT03PqqBKtrxhnrelfjta8AUUBEfgursanYZG4WMgydj9exK9w5q0?=
 =?us-ascii?Q?YlG3gguR2WncMBb4UXV0ZWp45zoCpuL9GmF+hN7M7H4g7IN5cycZaDFuq3dR?=
 =?us-ascii?Q?Kcp/8nHaiVltDvUC3mh9BA5gpfiir8JnPRtXqu72nV1hz0An0vF5MOPo1rJu?=
 =?us-ascii?Q?fGpkAWMOw7QKfLD0jEumZO5cONj4c4Ic9LkJX6KlrjE41CTd0j4WURg46EBF?=
 =?us-ascii?Q?hkZ/vJXFuBr+pOFkbACLizdbLqpoxyRi4P8k6cHFqmIcHePqcG8drUEIhv+w?=
 =?us-ascii?Q?hoBcAFW1u09sn1dvP47QsLMkAku0hCZmlmjtd074t982tKScsc5dNyi8rnBH?=
 =?us-ascii?Q?btNv23jiKRhT+7da4+VEJf4Z?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a47f00d8-8849-4fbb-ac96-08d96da6ec39
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 00:16:34.1759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iy7Bm09R2ybhwyJZEZLyvD9iuXUgQWan7i+o0pFTehAQFo+nV250s0Vhubtgu9mRkpslfJasLFpR6yX495cvj7CTXKrGKBt/EevN0WlWfzE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR21MB1314
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Friday, August 27, 2021 10:21 =
AM
>=20
> Add new hvcall guest address host visibility support to mark
> memory visible to host. Call it inside set_memory_decrypted
> /encrypted(). Add HYPERVISOR feature check in the
> hv_is_isolation_supported() to optimize in non-virtualization
> environment.
>=20
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v3:
> 	* Fix error code handle in the __hv_set_mem_host_visibility().
> 	* Move HvCallModifySparseGpaPageHostVisibility near to enum
> 	  hv_mem_host_visibility.
>=20
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
>  arch/x86/hyperv/ivm.c              | 113 +++++++++++++++++++++++++++++
>  arch/x86/include/asm/hyperv-tlfs.h |  17 +++++
>  arch/x86/include/asm/mshyperv.h    |   4 +-
>  arch/x86/mm/pat/set_memory.c       |  19 +++--
>  include/asm-generic/hyperv-tlfs.h  |   1 +
>  include/asm-generic/mshyperv.h     |   1 +
>  8 files changed, 156 insertions(+), 7 deletions(-)
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
> index eba10ed4f73e..b1aa42f60faa 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -603,6 +603,12 @@ EXPORT_SYMBOL_GPL(hv_get_isolation_type);
>=20
>  bool hv_is_isolation_supported(void)
>  {
> +	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
> +		return 0;

Use "return false" per previous comment from Wei Liu.

> +
> +	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
> +		return 0;

Use "return false".

> +
>  	return hv_get_isolation_type() !=3D HV_ISOLATION_TYPE_NONE;
>  }
>=20
> diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
> new file mode 100644
> index 000000000000..a069c788ce3c
> --- /dev/null
> +++ b/arch/x86/hyperv/ivm.c
> @@ -0,0 +1,113 @@
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

s/encripted/encrypted/

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
> +	if (hv_result_success(hv_status))
> +		return 0;
> +	else
> +		return -EFAULT;
> +}
> +EXPORT_SYMBOL(hv_mark_gpa_visibility);

In later comments on Patch 7 of this series, I have suggested that
code in that patch should not call hv_mark_gpa_visibility() directly,
but instead should call set_memory_encrypted() and
set_memory_decrypted().  I'm thinking that those functions should
be the standard way to change the visibility of pages in the Isolated
VM case.  Then hv_mark_gpa_visibility() could be static and it would
not need a stub version for ARM64.  It would only be called by
__hv_set_mem_host_visibility below, and in turn by
set_memory_encrypted()/decrypted(). =20

> +
> +static int __hv_set_mem_host_visibility(void *kbuffer, int pagecount,
> +				      enum hv_mem_host_visibility visibility)
> +{
> +	u64 *pfn_array;
> +	int ret =3D 0;
> +	int i, pfn;
> +
> +	if (!hv_is_isolation_supported() || !hv_hypercall_pg)
> +		return 0;
> +
> +	pfn_array =3D kmalloc(HV_HYP_PAGE_SIZE, GFP_KERNEL);
> +	if (!pfn_array)
> +		return -ENOMEM;
> +
> +	for (i =3D 0, pfn =3D 0; i < pagecount; i++) {
> +		pfn_array[pfn] =3D virt_to_hvpfn(kbuffer + i * HV_HYP_PAGE_SIZE);
> +		pfn++;
> +
> +		if (pfn =3D=3D HV_MAX_MODIFY_GPA_REP_COUNT || i =3D=3D pagecount - 1) =
{
> +			ret =3D hv_mark_gpa_visibility(pfn, pfn_array,
> +						     visibility);
> +			if (ret)
> +				goto err_free_pfn_array;
> +			pfn =3D 0;
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

Is there a need for this wrapper function?  Couldn't the handling of the ho=
st
visibility enum be folded into __hv_set_mem_host_visibility() and the initi=
al
double underscore dropped?  Maybe I missed it, but I don't see that
__hv_set_mem_host_visibility() is called anyplace else.   Just trying to av=
oid
complexity if it isn't really needed.

> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hy=
perv-tlfs.h
> index 2322d6bd5883..381e88122a5f 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -276,6 +276,23 @@ enum hv_isolation_type {
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
> +/* HvCallModifySparseGpaPageHostVisibility hypercall */
> +#define HV_MAX_MODIFY_GPA_REP_COUNT	((PAGE_SIZE / sizeof(u64)) - 2)
> +struct hv_gpa_range_for_visibility {
> +	u64 partition_id;
> +	u32 host_visibility:2;
> +	u32 reserved0:30;
> +	u32 reserved1;
> +	u64 gpa_page_list[HV_MAX_MODIFY_GPA_REP_COUNT];
> +} __packed;
> +
>  /*
>   * Declare the MSR used to setup pages used to communicate with the hype=
rvisor.
>   */
> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyp=
erv.h
> index 37739a277ac6..ffb2af079c6b 100644
> --- a/arch/x86/include/asm/mshyperv.h
> +++ b/arch/x86/include/asm/mshyperv.h
> @@ -192,7 +192,9 @@ struct irq_domain *hv_create_pci_msi_domain(void);
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
> index 7537ae1db828..aa55447b9700 100644
> --- a/include/asm-generic/mshyperv.h
> +++ b/include/asm-generic/mshyperv.h
> @@ -254,6 +254,7 @@ bool hv_query_ext_cap(u64 cap_query);
>  static inline bool hv_is_hyperv_initialized(void) { return false; }
>  static inline bool hv_is_hibernation_supported(void) { return false; }
>  static inline void hyperv_cleanup(void) {}
> +static inline hv_is_isolation_supported(void);
>  #endif /* CONFIG_HYPERV */
>=20
>  #endif
> --
> 2.25.1

