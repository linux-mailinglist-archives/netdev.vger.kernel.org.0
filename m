Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403F93EAD11
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 00:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238224AbhHLWVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 18:21:25 -0400
Received: from mail-mw2nam10on2125.outbound.protection.outlook.com ([40.107.94.125]:29664
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234435AbhHLWVY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 18:21:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kK4SO3ztPBOQkZKkQPTe77bwluzZV9djyzIGP+aczqLblLvcSIDPAuSUH+vB3fChI16WEefyGIyL54c6C4z5jwQrr8WJU9t+YrdDs4IGL4zi+Kou5TDPdhwL25S+QZUz84Xm5BsfACeWCWZBm6KWjXbc/IOVsY1Lz9jMNzjnsKkE5YZvrfV2FQrdjQwRaBWbwcGiN9cbyX1crG7mhuclR7FWEttwWi6X2XnCbEuk6beouyGNFrF5iF1nhMO92DR63KPDq7nEHLZczY/e4ESqVEDxrhTb5EqJIBWKilsW2Sv4qnwiHFx2UyIRNAr1y7CUQbIvOb/Ne7zM3W/v/jHEaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOYu3quSV0ofQ2yQ86AJoRS0udsqWiS3jqNjlfnxl1A=;
 b=js3T+qGMr8Pcs4HJ2+LLLJRChR1sJKby9jgLn7MtAiUCkmfzVd27YXeu4G60U7y6oHFQ2erVMg/fJPVVWDNvB/7I6gpkfmYF6qSRBxeT2Cnms70KROvMl2oEQGL3U5Q5zIK1+o9utx6ICL4R2GYZmQl+9CJlFsuNJr7h9bp4y33sybMdbQk+tipX4DHYX5A16iglihgziZc8jOwwk+URWd04P9vBRQ93o648YJLyXgdE0Gw/VxUAZWAE28G9OdB+FLJRzpc+ipI4Xpg5gTHVFstoDCRnj2+gjDEqnMJVMazwyIwb9hJFq9PCj4jEEYB2zh0Ui6kZyNqV+rXN8WEp4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOYu3quSV0ofQ2yQ86AJoRS0udsqWiS3jqNjlfnxl1A=;
 b=bgimrThB75ZLcR677oDL/wyaMnF7qB8UKDjUhMPJqVzS5m0k40iXIPzsPo3IL6WQtWoJbWZB/IGB6BBJ4pdYBtiJKEMdPV83XKP25vHC7SomTAmES/qVmiuCViL3+IknTZgsh6penNzM4XNUOPXe54KyaU1ddiQESjbGR+Xj9lU=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW4PR21MB2028.namprd21.prod.outlook.com (2603:10b6:303:11f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.9; Thu, 12 Aug
 2021 22:20:46 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55%2]) with mapi id 15.20.4436.012; Thu, 12 Aug 2021
 22:20:46 +0000
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
Subject: RE: [PATCH V3 04/13] HV: Mark vmbus ring buffer visible to host in
 Isolation VM
Thread-Topic: [PATCH V3 04/13] HV: Mark vmbus ring buffer visible to host in
 Isolation VM
Thread-Index: AQHXjUfqCaYLLBWw5kOeNCdGavVaB6twbYXA
Date:   Thu, 12 Aug 2021 22:20:46 +0000
Message-ID: <MWHPR21MB1593CCBBBB83E721F8FDACD3D7F99@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-5-ltykernel@gmail.com>
In-Reply-To: <20210809175620.720923-5-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=360a1553-80d6-4b98-af48-a6ed69a048d8;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-12T21:50:18Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f81e2ea8-e287-4a18-a7b3-08d95ddf6eb1
x-ms-traffictypediagnostic: MW4PR21MB2028:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW4PR21MB2028B1ACC85CCDF6566D1134D7F99@MW4PR21MB2028.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:117;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rYCsX8VbVeNt46iWhFLS4tEu4bZ6vGOyVOrXzwfFXEa9C2zdNglejIjknkYkMNpB75Pq/JMMaqvZemNeCkw9gNPD9xhI5WW3FdjJQcuano+1DydLGMMTAGEwC0uAV5ILEm0g9ueuBcjyG8yh7Cjk4KXI6T/aGw/r5WpxuBCvR//qLEAVg4dIEYVrlysffKg12N2BZr9U+tMn3wup5n+t1fO2QkDSII3Li2g96DCix88PnR8FxMLeC1DCENttV+hX1CLITuPiahEo25gA3bpX6ZyQEYzWLtIqnwb9nDW3JHdvZTMk53713ZEOiaqoGA5R90DZpL/jXy+o5/Zv+DPwIaIgjpBfDWmEY1xptO9FBaoBZYoMHgwlK2LfRp9cpWiD74WrsOj2/zeD1isdvAd4jHKQGtwoM/ockmlgQClExUlIDsXLxb33ltEt1MObeZF8enfQZILSBBEYN88xq/hqVX1YCHhdq2OT7AnTWn4uuS3pW284ByRFk64gC7kTgO5recx04A3f/kS3807qkn1xyJ+c9UASTLlFDt/hK2WVOYpk+HcXkHTnEpnm9CWnuj86x001T2nFlQuzywdw3P11jchWefHS3ISVMVbo7d2rWW/w/0ZYEXkuNCONdQCFHrO45XfnYDLmWfisV1XIKd9OulsAPgIO3ZyQWZsiIoWI8kwwBlZhoExj4L3lW8PA8rIdV5aD6d/29L4v7nFwkbHbtjDSkeYuHHSnD0mMpfYml9s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(5660300002)(921005)(83380400001)(55016002)(9686003)(8936002)(54906003)(8676002)(110136005)(7406005)(8990500004)(86362001)(7416002)(186003)(508600001)(71200400001)(38070700005)(76116006)(122000001)(33656002)(10290500003)(26005)(66946007)(66556008)(66446008)(7696005)(64756008)(66476007)(38100700002)(53546011)(6506007)(82950400001)(4326008)(82960400001)(316002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jPd7poM9icPyar8JZNozthl5E+U0PZQjtUnpBwt1F9Oxh8sG+TvjsI95qjoi?=
 =?us-ascii?Q?3jwCYkJmTBOGa5dKqBjvnRb/BdAgdJMXvf4TELBSVoMIaQcnF6SQOK1pTJ29?=
 =?us-ascii?Q?8xEKOCSloQzTvRO8koyXZK543bvUlKH8Sb8JYLL4Nim1+FBv07I1eFuFpNIm?=
 =?us-ascii?Q?AjKQCfw21C50JhyP+eF4CrTKnKbg/QG/Jj94VRwdIpgz4UAcTHRvFyugnw9a?=
 =?us-ascii?Q?RaOELwv65+rbr+UUSMf4DjVwTuztj9ZatbcswlUw08qo6hxT2yXkzwWrlmbU?=
 =?us-ascii?Q?m6dwxLRrpdo5IbmklZ8e/VVQPndy6Q4a/wR9C6camuukEOKD0f+UbSaGjhKU?=
 =?us-ascii?Q?CzWKPuvwwoPWnDvQksbruTe70NEOTW8HmdqCVnJ5USf/ZifaPgVR/+09S9Z6?=
 =?us-ascii?Q?gxY3l84uXHUsq4dxCOxTxnCUeZ0WFwlMBtTAR1XGzsR9krZ0mIoXUUIaWV3L?=
 =?us-ascii?Q?p6Q/c4OQsNvYGS9ts+czg30KxzwrEDofOi1l9mKJJiiMY46+TuukpNuO8Bow?=
 =?us-ascii?Q?FIOuo6Om12VhYNI7NyOObSKctSHBcUZpzPMwxLG0axXY+0KEdkrvL057CgJd?=
 =?us-ascii?Q?bgA6IXmvJbMVmiDJS/26I5jsZiJ55LPNVcYMowMjaDOKXWqozYbOe+CV6Wtx?=
 =?us-ascii?Q?0aQRvMy7b+y6DfKFDPW8sg1iQZzzLw6h7EwQus/mRANqMlQiVC2Ri6VegGpR?=
 =?us-ascii?Q?uSa6ODbyV7ui72Aw/m0lI2FIFKgnyGWzFtof5Pc9VwArqG3BsGNMZRaizws2?=
 =?us-ascii?Q?79P9PcaqATlJjKfQXdTxLR7TFrIjeoz2LDgiKAgiIwt4aVIDho9rWSGVB3id?=
 =?us-ascii?Q?LuI65ab3kjGtBK5dksxn6pQM8CMqqlb8SA0pXzaiaRjQ972bCWEi116PSCUh?=
 =?us-ascii?Q?cuAp9zYf4IEa27bgy07m3/OM7f8kuxQmzTCHgvNMp5sGYEUdKzQSG0UjV//C?=
 =?us-ascii?Q?5+bFk8WmodidqFYMaJJc01ZSqq+aiPaOQFtRpHDrp8YuCKU9aVZHAiD1t2bT?=
 =?us-ascii?Q?PMvDuHe9zpXfyZKLQ5XD6FZFDuwFYxY5jPx4+v1/7SmYVfQkXF3/2Ys+Eps/?=
 =?us-ascii?Q?2PP4wCinOCQm6LNSpTNMkanMsmJsqsaG6LHqPIEpRm6cl0A76+ZWXejC4ElN?=
 =?us-ascii?Q?EuPLHvk6Tj3Fu8hmE1kus6JFQvxQ9XREGwdjCV1cjQpXujcuZ4PWE5VfsxsB?=
 =?us-ascii?Q?XpRlLzWwlX4Lo6NyM7p6Yg2tHO1rVS4dBGwU11Hf3wLf33zfV/4Boe46BVol?=
 =?us-ascii?Q?bsro0xZoDwYqWiYnFkb1PdmxxB2WxvEf2GIDhVOWP8ED8dWdtjMCz7TrWT4K?=
 =?us-ascii?Q?q5+90GUPtowOZ1rbCTBKCIl2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f81e2ea8-e287-4a18-a7b3-08d95ddf6eb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 22:20:46.2594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0vZECvQwyCv58s0VsEIe1ffCd+2LLgWpfn4gbwYOfLDSCVl+IQ9EFpWSO/dP6dWVfk8yNB2x93MEAaenaaojtR5/qWNSqQKyzjGARfGDJJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB2028
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Monday, August 9, 2021 10:56 A=
M
> Subject: [PATCH V3 04/13] HV: Mark vmbus ring buffer visible to host in I=
solation VM
>=20

Use tag "Drivers: hv: vmbus:" in the Subject line.

> Mark vmbus ring buffer visible with set_memory_decrypted() when
> establish gpadl handle.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  drivers/hv/channel.c   | 44 ++++++++++++++++++++++++++++++++++++++++--
>  include/linux/hyperv.h | 11 +++++++++++
>  2 files changed, 53 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index f3761c73b074..4c4717c26240 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -17,6 +17,7 @@
>  #include <linux/hyperv.h>
>  #include <linux/uio.h>
>  #include <linux/interrupt.h>
> +#include <linux/set_memory.h>
>  #include <asm/page.h>
>  #include <asm/mshyperv.h>
>=20
> @@ -465,7 +466,14 @@ static int __vmbus_establish_gpadl(struct vmbus_chan=
nel *channel,
>  	struct list_head *curr;
>  	u32 next_gpadl_handle;
>  	unsigned long flags;
> -	int ret =3D 0;
> +	int ret =3D 0, index;
> +
> +	index =3D atomic_inc_return(&channel->gpadl_index) - 1;
> +
> +	if (index > VMBUS_GPADL_RANGE_COUNT - 1) {
> +		pr_err("Gpadl handle position(%d) has been occupied.\n", index);
> +		return -ENOSPC;
> +	}
>=20
>  	next_gpadl_handle =3D
>  		(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
> @@ -474,6 +482,13 @@ static int __vmbus_establish_gpadl(struct vmbus_chan=
nel *channel,
>  	if (ret)
>  		return ret;
>=20
> +	ret =3D set_memory_decrypted((unsigned long)kbuffer,
> +				   HVPFN_UP(size));
> +	if (ret) {
> +		pr_warn("Failed to set host visibility.\n");

Enhance this message a bit.  "Failed to set host visibility for new GPADL\n=
"
and also output the value of ret.

> +		return ret;
> +	}
> +
>  	init_completion(&msginfo->waitevent);
>  	msginfo->waiting_channel =3D channel;
>=20
> @@ -539,6 +554,10 @@ static int __vmbus_establish_gpadl(struct vmbus_chan=
nel *channel,
>  	/* At this point, we received the gpadl created msg */
>  	*gpadl_handle =3D gpadlmsg->gpadl;
>=20
> +	channel->gpadl_array[index].size =3D size;
> +	channel->gpadl_array[index].buffer =3D kbuffer;
> +	channel->gpadl_array[index].gpadlhandle =3D *gpadl_handle;
> +

I can see the merits of transparently stashing the memory address and size
that will be needed by vmbus_teardown_gpadl(), so that the callers of
__vmbus_establish_gpadl() don't have to worry about it.  But doing the
stashing transparently is somewhat messy.

Given that the callers are already have memory allocated to save the
GPADL handle, a little refactoring would make for a much cleaner solution.
Instead of having memory allocated for the 32-bit GPADL handle, callers
should allocate the slightly larger struct vmbus_gpadl that you've
defined below.  The calling interfaces can be updated to take a pointer
to this structure instead of a pointer to the 32-bit GPADL handle, and
you can save the memory address and size right along with the GPADL
handle.  This approach touches a few more files, but I think there are
only two callers outside of the channel management code -- netvsc
and hv_uio -- so it's not a big change.

>  cleanup:
>  	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
>  	list_del(&msginfo->msglistentry);
> @@ -549,6 +568,13 @@ static int __vmbus_establish_gpadl(struct vmbus_chan=
nel *channel,
>  	}
>=20
>  	kfree(msginfo);
> +
> +	if (ret) {
> +		set_memory_encrypted((unsigned long)kbuffer,
> +				     HVPFN_UP(size));
> +		atomic_dec(&channel->gpadl_index);
> +	}
> +
>  	return ret;
>  }
>=20
> @@ -676,6 +702,7 @@ static int __vmbus_open(struct vmbus_channel *newchan=
nel,
>=20
>  	/* Establish the gpadl for the ring buffer */
>  	newchannel->ringbuffer_gpadlhandle =3D 0;
> +	atomic_set(&newchannel->gpadl_index, 0);
>=20
>  	err =3D __vmbus_establish_gpadl(newchannel, HV_GPADL_RING,
>  				      page_address(newchannel->ringbuffer_page),
> @@ -811,7 +838,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channe=
l, u32 gpadl_handle)
>  	struct vmbus_channel_gpadl_teardown *msg;
>  	struct vmbus_channel_msginfo *info;
>  	unsigned long flags;
> -	int ret;
> +	int ret, i;
>=20
>  	info =3D kzalloc(sizeof(*info) +
>  		       sizeof(struct vmbus_channel_gpadl_teardown), GFP_KERNEL);
> @@ -859,6 +886,19 @@ int vmbus_teardown_gpadl(struct vmbus_channel *chann=
el, u32 gpadl_handle)
>  	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
>=20
>  	kfree(info);
> +
> +	/* Find gpadl buffer virtual address and size. */
> +	for (i =3D 0; i < VMBUS_GPADL_RANGE_COUNT; i++)
> +		if (channel->gpadl_array[i].gpadlhandle =3D=3D gpadl_handle)
> +			break;
> +
> +	if (set_memory_encrypted((unsigned long)channel->gpadl_array[i].buffer,
> +			HVPFN_UP(channel->gpadl_array[i].size)))
> +		pr_warn("Fail to set mem host visibility.\n");

Enhance this message a bit: "Failed to set host visibility in GPADL teardow=
n\n".
Also output the returned error code to help in debugging any occurrences of
a failure.

> +
> +	channel->gpadl_array[i].gpadlhandle =3D 0;
> +	atomic_dec(&channel->gpadl_index);

Note that the array entry being cleared (index "i") may not
be the last used entry in the array, so decrementing the gpadl_index
might not have the right behavior.  But I'm pretty sure that all
GPADL's for a channel are freed in sequence with no intervening
allocations, so nothing actually breaks.  But this is one of the=20
messy areas with stashing the memory address and size transparently
to the caller.

> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(vmbus_teardown_gpadl);
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index ddc8713ce57b..90b542597143 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -803,6 +803,14 @@ struct vmbus_device {
>=20
>  #define VMBUS_DEFAULT_MAX_PKT_SIZE 4096
>=20
> +struct vmbus_gpadl {
> +	u32 gpadlhandle;
> +	u32 size;
> +	void *buffer;
> +};
> +
> +#define VMBUS_GPADL_RANGE_COUNT		3
> +
>  struct vmbus_channel {
>  	struct list_head listentry;
>=20
> @@ -823,6 +831,9 @@ struct vmbus_channel {
>  	struct completion rescind_event;
>=20
>  	u32 ringbuffer_gpadlhandle;
> +	/* GPADL_RING and Send/Receive GPADL_BUFFER. */
> +	struct vmbus_gpadl gpadl_array[VMBUS_GPADL_RANGE_COUNT];
> +	atomic_t gpadl_index;
>=20
>  	/* Allocated memory for ring buffer */
>  	struct page *ringbuffer_page;
> --
> 2.25.1

