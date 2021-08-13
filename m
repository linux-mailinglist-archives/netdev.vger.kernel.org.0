Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09953EBDD8
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 23:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbhHMV3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 17:29:15 -0400
Received: from mail-co1nam11on2111.outbound.protection.outlook.com ([40.107.220.111]:56769
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234716AbhHMV3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 17:29:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lM9GMkQ0CZSF6GcW8MmJykNorU4W3vROSFp9OpMWUpORxqWGY2xKiKRyW/DYdbXHcp+hv75N6vxrYIwD0+BXgRasvE/lCKf8xBHZz0JGe48Pgv+uM2M7PWqgGDtwAJ4z68HVLgk2ltpRiSpTNxY94o/Oqir1sBCVHozLuB4chZMsbFvFpcMfqX82Z3pIrSTvXg9xG07vu4Supnd0kpTwivtQITp6oJRbgAUfJnmoI8P59Hncx8mbGRdWyO2ftnuKaT6ndR2PldfI0tzBOMdJS51Ed8D/VSuaBg5aM/gF13cdikt/R7SoT6Voc4kXudJZy7780fJS9DJUrFgk/QPytA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFr/KaTPD182VDnGFw4G1DU5W3PZzQMKCsybADs7tdw=;
 b=IGlght9cNCY9OCkHeWUQmBMXCJPDJsKmWdD14PA/LMEFBjfqLMK7AIARIjWcinqwpCEgfZLyRzHtqf7D24HJM14+tjDlh6SmBVsGaoCSO6cHxh6GXXQJN8djcGIk3OBHp8L3djn29E4+WSu8ct2TqPPEc96Axm9jqpPMrWEvbzPCgqJm5N0kb1Unf0YHdGXzSxV+SMnvxEZkzCKcAEp+fgcQvqrz/sOSWkZDpBSWU/GBUbmAuLxI5KbRnqRHn/o3Afd5Gsj0WQeZiDSEgAikLeq5/mtUzRxe0PD0d+GdvPNmNolKxg04W47U9sSfP8J6y5F4kmJqI9mu6Hj/qb8gVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFr/KaTPD182VDnGFw4G1DU5W3PZzQMKCsybADs7tdw=;
 b=Ma8Sdr4yWNsaxQT5BfRvtkuXHY1ZDOPqnYs9FecMsAq5GAnUJPdmim7Inid47cWpOzoKKKFZTar/y+BhP4a14UReRxWJkfkgPzrBVyHAJobC79WQ6GP1mZ4hk2vWHs8C/q7w0eTeF1uO0sDKmf4jmXLs6rhirn/TbTq7jCoSzzk=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by CO1PR21MB1297.namprd21.prod.outlook.com (2603:10b6:303:160::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.4; Fri, 13 Aug
 2021 21:28:42 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55%2]) with mapi id 15.20.4436.012; Fri, 13 Aug 2021
 21:28:42 +0000
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
Subject: RE: [PATCH V3 07/13] HV/Vmbus: Add SNP support for VMbus channel
 initiate message
Thread-Topic: [PATCH V3 07/13] HV/Vmbus: Add SNP support for VMbus channel
 initiate message
Thread-Index: AQHXjUfv24BSqXdZjUClmJbxPo3yw6tx7wUg
Date:   Fri, 13 Aug 2021 21:28:42 +0000
Message-ID: <MWHPR21MB15934F9D5617224608073CE7D7FA9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-8-ltykernel@gmail.com>
In-Reply-To: <20210809175620.720923-8-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4db12a68-da5e-4335-95dc-8738a43aac1e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-13T20:50:04Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98b0b9a1-c51b-4bba-9ca6-08d95ea15337
x-ms-traffictypediagnostic: CO1PR21MB1297:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CO1PR21MB12972358D5949C41735B40B8D7FA9@CO1PR21MB1297.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3gdBQr+uaC/cH62f4x1FyA31Ggv7YkIy0azhogOJsnsNNDB0j3b+JRim3OKb74MQFbxb7RlIeQm5EhnB9Y1281XA0XpgSxvH3VYFNQgMqB92WaodbZ3GFqUZ53OLqJ0xz65i9EmvfRt3EKohriAnKNoPUn/MTKUjfylwHBI4oESuB41+4nU+Ebv/EP/R6XluxyOWw5zEqbbWD4h2b0s3cdtfVOC/38xJUUM9X0itbiC2i3mkmg+BDaAH9MYOMGZxYyIyz2cfaAYQYIZhSOs2qB6RPi8JFxFAJrrC8nG/zM6nTVhQgi4GLr933+wKrisfTfJrFG+a+3G0+J159C903tLRgQInrG3dgi3F6Ly12DvBbSukuA0fHL+ppjgU6QPEMRKAq9wlK5BB53/iJzlMLbEsg5WDyDkIpB3sdcOARlnnFHAyG41tGpkWvve7gzcTV4EAE2BAj740v1Sfbj1Aln9CYYQ34qEtJOp/KUzDxcEEV8NtLXp1FLWh/nU27fm7oakeF0Q4ZMgHZA1qxlU/MzYtMm42x45MRq5xM3ZEBI5TXxA4AW5SNfiMjqh7wrGpaFPc55H6aQsTxs7SPA6g7LRHt+SSaxUlz2m5MGGQMnNA7qvk4It/Jt+JxSECGZYk7ohCeeWIJ0JGFxSWFv1endAKgcvNdzfW2IZBzoOvsZiBtGMomHpdrDroGf2yxmzxsUu54WcqBpRyo5PL2UNsPJxz4KOJB1n97Tsr1roDYxI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(55016002)(6506007)(10290500003)(5660300002)(9686003)(76116006)(82950400001)(8936002)(122000001)(38100700002)(66556008)(8676002)(64756008)(66946007)(66446008)(110136005)(52536014)(71200400001)(33656002)(38070700005)(86362001)(316002)(15650500001)(66476007)(54906003)(82960400001)(7696005)(921005)(8990500004)(83380400001)(2906002)(7416002)(186003)(4326008)(26005)(7406005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PI8niaD816S/UGWfeiG2CzBZYApmgTd1MXNm3ntN3Gu/tVDMXv9DoBc6+t1v?=
 =?us-ascii?Q?R1kfPCnSRpSiG57uJJOrntPgM7HcfVpJ15sGD4RZP7Fl13UwITUC3LDcQeit?=
 =?us-ascii?Q?97+PbvTZElm1FDv8E75dOPhheZYTiRuBLRv9JG2spF6cK5kTvSCIDtKB6Au2?=
 =?us-ascii?Q?RRj6soRUmFkOEn9F2N9mEvtqkhwRBh3XvY+yx0SwL6dW1MjDkGUWtX45EmuD?=
 =?us-ascii?Q?YEeHqwijiNdTjSVjMVwURfHFaudSSssyG5KJi/8fY0ydY+iRErRjyboWBHnN?=
 =?us-ascii?Q?2DLoMWjTiUmGx/lxb9SY8OfMN+tDOjF+msaMXnlYdOsARNh69o4PKIz4QrIw?=
 =?us-ascii?Q?itAAUiygWh6JD1TvLmoAF7F1DPmgNmao3GaGcBpATHo+EM1SrklyJvClAjKp?=
 =?us-ascii?Q?ob3uM/+LqaQrfGWy//1SGK0lQ8dzrMcn6TxH7Ug4DqjF6Y06kF6uWDGoPk9f?=
 =?us-ascii?Q?sUmQA0Q+vjGWTHiYgwl7aybYPwOGPYTbcocwhC5waln4I6D0ip0F5tX1qFpr?=
 =?us-ascii?Q?uewC/TURDW3EZ/DdCuCTTzi4GzAOu4Xpvt0o9DSKh7/lUqTRFqLHGmAgoUPe?=
 =?us-ascii?Q?7E3WYvb3NoWDlp8k8gcavnkouazT1YJat1RtRVY5jppHM1+Wc/kHoXjoyxTg?=
 =?us-ascii?Q?ai7VTSFmbjH1sc64jwChCcQwFblmuo52S9XfHVzzpT9d1jL5kM5QV+afLoyA?=
 =?us-ascii?Q?B4UeuadKypZ9ExzPw44217pZ33mCl145cfk+P02hWcp8p0GP2iJ9wpaGXz/w?=
 =?us-ascii?Q?uZ8s68l+l8TKzUbq88JEmtJScpmu9izs3M5EUwxrM4PNp9ti9WGyg/WWkYW3?=
 =?us-ascii?Q?7DKhptunUpT+JWb648aYcswGLLaQa8hLXe9+dBFx3ngkZU2miH46UlrPvrV6?=
 =?us-ascii?Q?871GN4VB5cdv1R2owKu4y8l6MZIj/qtMOMulHLkaxbPYHCee5II++OUAyual?=
 =?us-ascii?Q?Rvs4bCeQT8s6Ezm7dmkAz+DNit6XiMZncUU3W7JuR7JTNpflcZUXOn+sR+CX?=
 =?us-ascii?Q?ax737yG6smY4+c9Aa1mOBdA2hX0t3Cbg4tiP2SOBzJyq3K57KDAamcXagxk/?=
 =?us-ascii?Q?BKOmQzAtHPZZj6Bi73t8evdDVGfhp0ne5dfAQ0dtbUqSxjIZ9bsHuAzcV5tP?=
 =?us-ascii?Q?njY1LDSOJEO1lm/z9DBQz4b+leOi7XznGhOMEU0wyYKoldN6MVe32msRcCFX?=
 =?us-ascii?Q?BtM+vIoFISIURMxKFe7zoHXm7goQTXm0ozp96edgQ6R30AgPkpncsUNDYg5T?=
 =?us-ascii?Q?8nWrRLZYOCEsTMWzJdBUywik7C3XWpNtXEdNgwRqLdSyEfQiEPuD3sGnMbQL?=
 =?us-ascii?Q?97gmhx77iDT7wLoRxXQLJG7W?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b0b9a1-c51b-4bba-9ca6-08d95ea15337
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2021 21:28:42.5526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2GlRry51dOGFLEy7qqNRQefh0YZsixtx9+RUI/RWWHP4M+m1dHGK/+j6WV1ge08uWzwqfz1rLzM7tiftV89eEyF/cN1aHAL+veCkNvjH/Wo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR21MB1297
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Monday, August 9, 2021 10:56 A=
M
>=20
> The monitor pages in the CHANNELMSG_INITIATE_CONTACT msg are shared
> with host in Isolation VM and so it's necessary to use hvcall to set
> them visible to host. In Isolation VM with AMD SEV SNP, the access
> address should be in the extra space which is above shared gpa
> boundary. So remap these pages into the extra address(pa +
> shared_gpa_boundary). Introduce monitor_pages_va to store
> the remap address and unmap these va when disconnect vmbus.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v1:
>         * Not remap monitor pages in the non-SNP isolation VM.
> ---
>  drivers/hv/connection.c   | 65 +++++++++++++++++++++++++++++++++++++++
>  drivers/hv/hyperv_vmbus.h |  1 +
>  2 files changed, 66 insertions(+)
>=20
> diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
> index 6d315c1465e0..bf0ac3167bd2 100644
> --- a/drivers/hv/connection.c
> +++ b/drivers/hv/connection.c
> @@ -19,6 +19,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/hyperv.h>
>  #include <linux/export.h>
> +#include <linux/io.h>
>  #include <asm/mshyperv.h>
>=20
>  #include "hyperv_vmbus.h"
> @@ -104,6 +105,12 @@ int vmbus_negotiate_version(struct vmbus_channel_msg=
info *msginfo, u32 version)
>=20
>  	msg->monitor_page1 =3D virt_to_phys(vmbus_connection.monitor_pages[0]);
>  	msg->monitor_page2 =3D virt_to_phys(vmbus_connection.monitor_pages[1]);
> +
> +	if (hv_isolation_type_snp()) {
> +		msg->monitor_page1 +=3D ms_hyperv.shared_gpa_boundary;
> +		msg->monitor_page2 +=3D ms_hyperv.shared_gpa_boundary;
> +	}
> +
>  	msg->target_vcpu =3D hv_cpu_number_to_vp_number(VMBUS_CONNECT_CPU);
>=20
>  	/*
> @@ -148,6 +155,31 @@ int vmbus_negotiate_version(struct vmbus_channel_msg=
info *msginfo, u32 version)
>  		return -ECONNREFUSED;
>  	}
>=20
> +	if (hv_isolation_type_snp()) {
> +		vmbus_connection.monitor_pages_va[0]
> +			=3D vmbus_connection.monitor_pages[0];
> +		vmbus_connection.monitor_pages[0]
> +			=3D memremap(msg->monitor_page1, HV_HYP_PAGE_SIZE,
> +				   MEMREMAP_WB);
> +		if (!vmbus_connection.monitor_pages[0])
> +			return -ENOMEM;

This error case causes vmbus_negotiate_version() to return with
vmbus_connection.con_state set to CONNECTED.  But the caller never checks t=
he
returned error code except for ETIMEDOUT.  So the caller will think that
vmbus_negotiate_version() succeeded when it didn't.  There may be some
existing bugs in that error handling code. :-(

> +
> +		vmbus_connection.monitor_pages_va[1]
> +			=3D vmbus_connection.monitor_pages[1];
> +		vmbus_connection.monitor_pages[1]
> +			=3D memremap(msg->monitor_page2, HV_HYP_PAGE_SIZE,
> +				   MEMREMAP_WB);
> +		if (!vmbus_connection.monitor_pages[1]) {
> +			memunmap(vmbus_connection.monitor_pages[0]);
> +			return -ENOMEM;
> +		}
> +
> +		memset(vmbus_connection.monitor_pages[0], 0x00,
> +		       HV_HYP_PAGE_SIZE);
> +		memset(vmbus_connection.monitor_pages[1], 0x00,
> +		       HV_HYP_PAGE_SIZE);
> +	}
> +

I don't think the memset() calls are needed.  The memory was originally
allocated with hv_alloc_hyperv_zeroed_page(), so it should already be zeroe=
d.

>  	return ret;
>  }
>=20
> @@ -159,6 +191,7 @@ int vmbus_connect(void)
>  	struct vmbus_channel_msginfo *msginfo =3D NULL;
>  	int i, ret =3D 0;
>  	__u32 version;
> +	u64 pfn[2];
>=20
>  	/* Initialize the vmbus connection */
>  	vmbus_connection.conn_state =3D CONNECTING;
> @@ -216,6 +249,16 @@ int vmbus_connect(void)
>  		goto cleanup;
>  	}
>=20
> +	if (hv_is_isolation_supported()) {
> +		pfn[0] =3D virt_to_hvpfn(vmbus_connection.monitor_pages[0]);
> +		pfn[1] =3D virt_to_hvpfn(vmbus_connection.monitor_pages[1]);
> +		if (hv_mark_gpa_visibility(2, pfn,
> +				VMBUS_PAGE_VISIBLE_READ_WRITE)) {

Note that hv_mark_gpa_visibility() will need an appropriate no-op stub so
that this architecture independent code will compile for ARM64.

> +			ret =3D -EFAULT;
> +			goto cleanup;
> +		}
> +	}
> +
>  	msginfo =3D kzalloc(sizeof(*msginfo) +
>  			  sizeof(struct vmbus_channel_initiate_contact),
>  			  GFP_KERNEL);
> @@ -284,6 +327,8 @@ int vmbus_connect(void)
>=20
>  void vmbus_disconnect(void)
>  {
> +	u64 pfn[2];
> +
>  	/*
>  	 * First send the unload request to the host.
>  	 */
> @@ -303,6 +348,26 @@ void vmbus_disconnect(void)
>  		vmbus_connection.int_page =3D NULL;
>  	}
>=20
> +	if (hv_is_isolation_supported()) {
> +		if (vmbus_connection.monitor_pages_va[0]) {
> +			memunmap(vmbus_connection.monitor_pages[0]);
> +			vmbus_connection.monitor_pages[0]
> +				=3D vmbus_connection.monitor_pages_va[0];
> +			vmbus_connection.monitor_pages_va[0] =3D NULL;
> +		}
> +
> +		if (vmbus_connection.monitor_pages_va[1]) {
> +			memunmap(vmbus_connection.monitor_pages[1]);
> +			vmbus_connection.monitor_pages[1]
> +				=3D vmbus_connection.monitor_pages_va[1];
> +			vmbus_connection.monitor_pages_va[1] =3D NULL;
> +		}
> +
> +		pfn[0] =3D virt_to_hvpfn(vmbus_connection.monitor_pages[0]);
> +		pfn[1] =3D virt_to_hvpfn(vmbus_connection.monitor_pages[1]);
> +		hv_mark_gpa_visibility(2, pfn, VMBUS_PAGE_NOT_VISIBLE);
> +	}
> +

The code in this patch feels a bit more complicated than it needs to be.  A=
ltogether,
there are two different virtual addresses and one physical address for each=
 monitor
page.  The two virtual addresses are the one obtained from the original mem=
ory
allocation, and which will be used to free the memory.  The second virtual =
address
is the one used to actually access the data, which is the same as the first=
 virtual
address for a non-isolated VM.  The second VA is the result of memremap() c=
all for an
isolated VM.  The vmbus_connection data structure should save all three val=
ues for
each monitor page so they don't need to recomputed or moved around.  Then:

1) For isolated and for non-isolated VMs, setup the virtual and physical ad=
dresses
of the monitor pages in vmbus_connect(), and store them in the vmbus_connec=
tion
data structure.  The physical address should include the shared_gpa_boundar=
y offset
in the case of an isolated VM.  At this point the two virtual addresses are=
 the same.

2) vmbus_negotiate_version() just grabs the physical address from the
vmbus_connection data structure.  It doesn't make any changes to the virtua=
l
or physical addresses, which keeps it focused just on version negotiation.

3) Once vmbus_negotiate_version() is done, vmbus_connect() can determine
the remapped virtual address, and store that.  It can also change the visib=
ility
of the two pages using the previously stored physical address.

4) vmbus_disconnect() can do the memunmaps() and change the visibility if n=
eeded,
and then free the memory using the address from the original allocation in =
Step 1.

>  	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[0]);
>  	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[1]);
>  	vmbus_connection.monitor_pages[0] =3D NULL;
> diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
> index 42f3d9d123a1..40bc0eff6665 100644
> --- a/drivers/hv/hyperv_vmbus.h
> +++ b/drivers/hv/hyperv_vmbus.h
> @@ -240,6 +240,7 @@ struct vmbus_connection {
>  	 * is child->parent notification
>  	 */
>  	struct hv_monitor_page *monitor_pages[2];
> +	void *monitor_pages_va[2];
>  	struct list_head chn_msg_list;
>  	spinlock_t channelmsg_lock;
>=20
> --
> 2.25.1

