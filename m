Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3F93FE6A6
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244382AbhIBAYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 20:24:11 -0400
Received: from mail-oln040093003009.outbound.protection.outlook.com ([40.93.3.9]:27579
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239492AbhIBAYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 20:24:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8hY9iJsRcCnx9oyRQ/hspUHIv5ff5374Rs6oJjEBnrTbvDk5OVpo0Dytg9YAtPPhZr2l5bsIK+3ilDvmgjxGyhDo5DazVJGf5g3p9s+a7ifYE/OqB+IVNp6W/b1GDIf14H4eQPlzE5fHzkG9QcOTAaGkRXI0CheiguOKNcKQBwnDgTmC20tuonkdBTxywuHT+oa3OFcYQE4s+NacqVM7320m1M2DWs3PTUtXvlQlWH4xqX/50jUCo0tmFahSIIj/Oq7ny4p7lSYujeyDChp/0Ze+ZUy5UBVLgnyj/inOOjQp+xFjvmb3XKi38+uCARx9Yx0y7ezjshT6Ergk0biRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qzrjg2Ld5ycVv0rSLliu9cUFTVcVw5lvAUeicQF2lCU=;
 b=TD5YCrNUvn78vMeILZY/K1kN7MDYqpxRmyv1nyfnfetEvkiiGIWOviUgmGTxUOT3tTz8DT6AcojE/n4UXu+xZujVVXiORo734A80/XxTJrls2GzULEfoo5gU20wm6ZO9C8LxbRPQHJt8ZPIubtjEJdOnrWFCsmEcCuk5mEFvdbGkkO11QK7njiEmOONbnL2RYCgWzLX+yJL8B7gQlzVffowcYscJWFwefoK/8KWpqtwihCvDRisT3CBgLgf1QciWejLJmWELbTH+YzPtVfqhhRSuy3TmZh07wf6x+5vBZzen2El8KBTx5ivWGaJ8+JpsJhC0VRrSnVJ9Qsl5D8CYHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzrjg2Ld5ycVv0rSLliu9cUFTVcVw5lvAUeicQF2lCU=;
 b=U5bibdZiNOinwuDMK081bP3N0/p7F9BHnGIsAEpvJQuA6Ihj7otxojR0zUqUnUiD0Yh4MRNEIdDf402n6pckNC3TDDyvLAY8dufxHi/UK6uoVZLuRrk7ZJ6pH91S32HeTbmhMDfTzCVd+wpm6DZK8k33MsTtVd3/LunuK+n82Qk=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW2PR2101MB1019.namprd21.prod.outlook.com (2603:10b6:302:5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.6; Thu, 2 Sep
 2021 00:23:08 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86%8]) with mapi id 15.20.4478.014; Thu, 2 Sep 2021
 00:23:08 +0000
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
Subject: RE: [PATCH V4 08/13] hyperv/vmbus: Initialize VMbus ring buffer for
 Isolation VM
Thread-Topic: [PATCH V4 08/13] hyperv/vmbus: Initialize VMbus ring buffer for
 Isolation VM
Thread-Index: AQHXm2gFIWSYU02+UUyReBHQOl5/ZauK4YnA
Date:   Thu, 2 Sep 2021 00:23:08 +0000
Message-ID: <MWHPR21MB1593B416ED91CD454FC036E5D7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210827172114.414281-9-ltykernel@gmail.com>
In-Reply-To: <20210827172114.414281-9-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=bc1bd6dd-73be-4423-bfec-d24cf5650634;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-29T19:29:24Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fdd00e19-74c7-465e-488a-08d96da7d743
x-ms-traffictypediagnostic: MW2PR2101MB1019:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB10194E3D49874ACDD0F694DFD7CE9@MW2PR2101MB1019.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a/1uWWyCm6KRWpOZ3PLSe+hwH5KkYNdAfvjSkhJa6lFuCklklUG/XcyZBFKgN2AmmBkr2TBUHNINXZNh0dNw4ocmONb7WXoudBjauOPc3GnHW4Wg/qf5gmFold/8RyJO7lTfbQrenuk7lt8iraXKKwG1PTU24Fi5pm3jjxvzwoErjxm0Rk3pGEuIhCb2yt/jHdUohFwAJLrtIvyy/49dwrizA4T+wUah8Ydz/Zj4XnKnbNdJZSCobmq1u2VKgoxxZCODLTqyUjE3Mynw9xmlOYY8MMMaw1yZNSMDK45zhYSEjigcd6DBOcTRRVniT1qsRFMpwNpmtA+mIM+a0MUW86c0SFDSZoS+NbOp8J5RP9iFmaRdRmiMYYGYJ14vVmkrtqLCd0AD+jRbTPgTMWN2a3jem1lPpfnOSuZtLLjEI1s2CxJT2f+l3tIzzMp+U+vRsAwEYhRvlHT6+v47USlJufwuSsjmfG2BFgoRWAo8+LGnfd4cp/+f5KQDfPLigB7oTEGNKVc2sJR+T7Z5J1pQduSXsskar11wKYUD8XHYCaM2Qd4lsEPFR9Kmb92XK/YIsQrOiaGtJw21wMlwgUNUorsDwOXEkhWymepocLVf7Q94IDyyMEUBcLH/V5//3uUc2/Wdt0+z9PYdVcNrOKn9tLXZrqSsuMnIoDizHEX72nYhCg2KyUSvRmna68APZlkt4iw8SwP5mEH4CiXI407t1fR3sOBR6YA7uF5M0Xye0y0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(66556008)(66476007)(64756008)(921005)(66446008)(10290500003)(26005)(55016002)(66946007)(2906002)(7416002)(82950400001)(82960400001)(52536014)(7366002)(5660300002)(7406005)(76116006)(6506007)(316002)(508600001)(8676002)(8990500004)(71200400001)(122000001)(9686003)(86362001)(7696005)(38100700002)(83380400001)(38070700005)(33656002)(186003)(8936002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6XoYftWOuBZ8DMMdcUow8qMAsztK90BM4zwgFHqXCTT0/q3RP3X2SwCIN0AN?=
 =?us-ascii?Q?1CO7TSM7aUgUQLy7/CS7apcmkWvaltP9dLrgtfUDUC21iu4mseZZaxiPcowW?=
 =?us-ascii?Q?FMzfYbCUD/MFcaRSpeOttttCfjw3BU+ayYxvspuBvq37pb7GREN1+j54ihRI?=
 =?us-ascii?Q?q+YKDNIRsQ8e5q9Mm49uRK3NMEPv1wDKWzDX4Dr9DfKAC3P/szxR4vsOu5ji?=
 =?us-ascii?Q?an3hnegJR3hQpW5lgodD7eGTGEl+yACooBujO62NgBtEvX2F3cKyTtYGg7Dv?=
 =?us-ascii?Q?qxlWTBCFJ372GbfMENy6ySZbmimtyzpCb9XIr2BsANfKh7KQSIyNryOjHC+S?=
 =?us-ascii?Q?lei2n1cWW4Zkbp59Uow5NopFsoKMwh8GpQmwLoXvfg6tex7uXWqDWO0q6/2/?=
 =?us-ascii?Q?d1DZ9BhOXns3eLlElLCP432cZOsypM9iC9J7ZqLpPF9U9wSJQpqcP9ssyrRW?=
 =?us-ascii?Q?zWbSM3DX8sO/rXmASE5w4QQVm007eC3GdWNg19sRSWdWAQe6TufvoVdHG97T?=
 =?us-ascii?Q?z6aUCZyPbPwv9Hmv3voLunZ5wMGOrsjrDqeeEEBu0ra3tb7zQ33xsJrELABw?=
 =?us-ascii?Q?stXUSAkVZg/1YtJbdRvCmIYsghJ7CdGKEo8LWxfaV+/pzXGuRrYLVEKyzccg?=
 =?us-ascii?Q?uHS0Ac94KveJFfPz8X9ggjJWrkzeNt9GJ+9PA8Q3nXrtYgyBL+vk27ZAsNvV?=
 =?us-ascii?Q?Xo+wRjsh7oIVMxQOAwDmROPephgD8IaokpRhpnr3JWa0077FA9EpgtSnqOSg?=
 =?us-ascii?Q?148fkt6WhUETRuE9dcbdbDda9c4b0hJ5F1dMTS1I2UPgSpUo9LXXUh0LIDt8?=
 =?us-ascii?Q?8/k2FJkot+Nc82CvZvBob6T4ntN9duPJtHpnV0fZAEc0KZ5eyohvIJNyZlU1?=
 =?us-ascii?Q?kWzW0qNRF7ofsWr1haiGZfqkplyq+PShvF/9C80NnqZSWC2vLfgqGTjxMgDj?=
 =?us-ascii?Q?NUhxmBOvxs+284vS99i5RTaL26s28x/V3OdB5u38+M6+sblMeeYIARkqWaS/?=
 =?us-ascii?Q?v2Bpm45vyAYk7NPFqOpiuxPLKsbyFqdZgNeQUDMLoKmf58EBDi9qdbV2QbSh?=
 =?us-ascii?Q?rq1BiCTg6y0U9W1rBsL3quQ1AJFe8yqXkuELcZObY+COu/BQlUVZys9+mJiy?=
 =?us-ascii?Q?MZ7HJL41DJJmC/9yrNJn8rCb5Y3K+DR8K+S1IsrUflLh3r+MeuVTXs28LwwO?=
 =?us-ascii?Q?JNztev9TSSmPYmRm9g2k3TTuad7FbXxy8kfAQaX3/pbrSkVqTy+wpJSgR8yL?=
 =?us-ascii?Q?xyPkiLcnYOOQjVYm8k/3s/ZYp5fjpLDafvtV9xpv25hsgcalc+ravYcCs5BA?=
 =?us-ascii?Q?8MmkSCuy0Xlhbl8Au+1+r8+q?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdd00e19-74c7-465e-488a-08d96da7d743
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 00:23:08.5814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bDiVg39aGq1FaXP2zo95/QN78I8IgtTSDrwy0TrxEwRiCpJ/PsqE6NddNnIMEFHdz5LmrkDwBlr26DPvAdo1fd6EHWSKXQK+l7enS4fOYHQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1019
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Friday, August 27, 2021 10:21 =
AM
>=20

Subject tag should be "Drivers: hv: vmbus: "

> VMbus ring buffer are shared with host and it's need to
> be accessed via extra address space of Isolation VM with
> AMD SNP support. This patch is to map the ring buffer
> address in extra address space via vmap_pfn(). Hyperv set
> memory host visibility hvcall smears data in the ring buffer
> and so reset the ring buffer memory to zero after mapping.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v3:
> 	* Remove hv_ringbuffer_post_init(), merge map
> 	operation for Isolation VM into hv_ringbuffer_init()
> 	* Call hv_ringbuffer_init() after __vmbus_establish_gpadl().
> ---
>  drivers/hv/Kconfig       |  1 +
>  drivers/hv/channel.c     | 19 +++++++-------
>  drivers/hv/ring_buffer.c | 56 ++++++++++++++++++++++++++++++----------
>  3 files changed, 54 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
> index d1123ceb38f3..dd12af20e467 100644
> --- a/drivers/hv/Kconfig
> +++ b/drivers/hv/Kconfig
> @@ -8,6 +8,7 @@ config HYPERV
>  		|| (ARM64 && !CPU_BIG_ENDIAN))
>  	select PARAVIRT
>  	select X86_HV_CALLBACK_VECTOR if X86
> +	select VMAP_PFN
>  	help
>  	  Select this option to run Linux as a Hyper-V client operating
>  	  system.
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index 82650beb3af0..81f8629e4491 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -679,15 +679,6 @@ static int __vmbus_open(struct vmbus_channel *newcha=
nnel,
>  	if (!newchannel->max_pkt_size)
>  		newchannel->max_pkt_size =3D VMBUS_DEFAULT_MAX_PKT_SIZE;
>=20
> -	err =3D hv_ringbuffer_init(&newchannel->outbound, page, send_pages, 0);
> -	if (err)
> -		goto error_clean_ring;
> -
> -	err =3D hv_ringbuffer_init(&newchannel->inbound, &page[send_pages],
> -				 recv_pages, newchannel->max_pkt_size);
> -	if (err)
> -		goto error_clean_ring;
> -
>  	/* Establish the gpadl for the ring buffer */
>  	newchannel->ringbuffer_gpadlhandle =3D 0;
>=20
> @@ -699,6 +690,16 @@ static int __vmbus_open(struct vmbus_channel *newcha=
nnel,
>  	if (err)
>  		goto error_clean_ring;
>=20
> +	err =3D hv_ringbuffer_init(&newchannel->outbound,
> +				 page, send_pages, 0);
> +	if (err)
> +		goto error_free_gpadl;
> +
> +	err =3D hv_ringbuffer_init(&newchannel->inbound, &page[send_pages],
> +				 recv_pages, newchannel->max_pkt_size);
> +	if (err)
> +		goto error_free_gpadl;
> +
>  	/* Create and init the channel open message */
>  	open_info =3D kzalloc(sizeof(*open_info) +
>  			   sizeof(struct vmbus_channel_open_channel),
> diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
> index 2aee356840a2..24d64d18eb65 100644
> --- a/drivers/hv/ring_buffer.c
> +++ b/drivers/hv/ring_buffer.c
> @@ -17,6 +17,8 @@
>  #include <linux/vmalloc.h>
>  #include <linux/slab.h>
>  #include <linux/prefetch.h>
> +#include <linux/io.h>
> +#include <asm/mshyperv.h>
>=20
>  #include "hyperv_vmbus.h"
>=20
> @@ -183,8 +185,10 @@ void hv_ringbuffer_pre_init(struct vmbus_channel *ch=
annel)
>  int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
>  		       struct page *pages, u32 page_cnt, u32 max_pkt_size)
>  {
> -	int i;
>  	struct page **pages_wraparound;
> +	unsigned long *pfns_wraparound;
> +	u64 pfn;
> +	int i;
>=20
>  	BUILD_BUG_ON((sizeof(struct hv_ring_buffer) !=3D PAGE_SIZE));
>=20
> @@ -192,23 +196,49 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *=
ring_info,
>  	 * First page holds struct hv_ring_buffer, do wraparound mapping for
>  	 * the rest.
>  	 */
> -	pages_wraparound =3D kcalloc(page_cnt * 2 - 1, sizeof(struct page *),
> -				   GFP_KERNEL);
> -	if (!pages_wraparound)
> -		return -ENOMEM;
> +	if (hv_isolation_type_snp()) {
> +		pfn =3D page_to_pfn(pages) +
> +			HVPFN_DOWN(ms_hyperv.shared_gpa_boundary);

Use PFN_DOWN, not HVPFN_DOWN.  This is all done in units of guest page
size, not Hyper-V page size.

>=20
> -	pages_wraparound[0] =3D pages;
> -	for (i =3D 0; i < 2 * (page_cnt - 1); i++)
> -		pages_wraparound[i + 1] =3D &pages[i % (page_cnt - 1) + 1];
> +		pfns_wraparound =3D kcalloc(page_cnt * 2 - 1,
> +			sizeof(unsigned long), GFP_KERNEL);
> +		if (!pfns_wraparound)
> +			return -ENOMEM;
>=20
> -	ring_info->ring_buffer =3D (struct hv_ring_buffer *)
> -		vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP, PAGE_KERNEL);
> +		pfns_wraparound[0] =3D pfn;
> +		for (i =3D 0; i < 2 * (page_cnt - 1); i++)
> +			pfns_wraparound[i + 1] =3D pfn + i % (page_cnt - 1) + 1;
>=20
> -	kfree(pages_wraparound);
> +		ring_info->ring_buffer =3D (struct hv_ring_buffer *)
> +			vmap_pfn(pfns_wraparound, page_cnt * 2 - 1,
> +				 PAGE_KERNEL);
> +		kfree(pfns_wraparound);
>=20
> +		if (!ring_info->ring_buffer)
> +			return -ENOMEM;
> +
> +		/* Zero ring buffer after setting memory host visibility. */
> +		memset(ring_info->ring_buffer, 0x00,
> +			HV_HYP_PAGE_SIZE * page_cnt);

The page_cnt parameter is in units of the guest page size.  So this
should use PAGE_SIZE, not HV_HYP_PAGE_SIZE.

> +	} else {
> +		pages_wraparound =3D kcalloc(page_cnt * 2 - 1,
> +					   sizeof(struct page *),
> +					   GFP_KERNEL);
> +
> +		pages_wraparound[0] =3D pages;
> +		for (i =3D 0; i < 2 * (page_cnt - 1); i++)
> +			pages_wraparound[i + 1] =3D
> +				&pages[i % (page_cnt - 1) + 1];
> +
> +		ring_info->ring_buffer =3D (struct hv_ring_buffer *)
> +			vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP,
> +				PAGE_KERNEL);
> +
> +		kfree(pages_wraparound);
> +		if (!ring_info->ring_buffer)
> +			return -ENOMEM;
> +	}

With this patch, the code is a big "if" statement with two halves -- one
when SNP isolation is in effect, and the other when not.  The SNP isolation
case does the work using PFNs with the shared_gpa_boundary added,
while the other case does the same work but using struct page.  Perhaps
I'm missing something, but can both halves be combined and always
do the work using PFNs?  The only difference is whether to add the
shared_gpa_boundary, and whether to zero the memory when done.
So get the starting PFN, then have an "if" statement for whether to
add the shared_gpa_boundary.  Then everything else is the same.
At the end, use an "if" statement to decide whether to zero the
memory.  It would really be better to have the logic in this algorithm
coded only once.

>=20
> -	if (!ring_info->ring_buffer)
> -		return -ENOMEM;
>=20
>  	ring_info->ring_buffer->read_index =3D
>  		ring_info->ring_buffer->write_index =3D 0;
> --
> 2.25.1

