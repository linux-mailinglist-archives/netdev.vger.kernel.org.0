Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D938940C869
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbhIOPlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:41:47 -0400
Received: from mail-oln040093003014.outbound.protection.outlook.com ([40.93.3.14]:5592
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234190AbhIOPln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 11:41:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQ+p/BEtE4Hu/1LS95NVH64lnNhmp5NJu60ibIfvHlW5NuaQR52CWKcGHBIBFa2Mpvync7D+X60eygG0TptF+kPFxGY00h/TfEOk53BqKQg4LaHTkzKkeM4feA1CfHmYHRBP+u+YdsdpWHZaTHzTCJ06rKAwhLAljzxHp9fR3j0j33eMCBbXW5if38jxJwhC1kwTUyoO4dQzrePDVcPPELNKhuQVwggxn8TXJvDURGGQC3/UAmJzMvltYG4qrrWv030OJTWEN5zz7K/tYRd0fTN7hLFGZVU3ZcmhMNqTnC45AFamv+p49KuIF45+irBmrtpexDyG7q68sNtuoUjLOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PuiDQ1qvHjVypg/77M68eUNojTmrE1TqpS61yWw/nTs=;
 b=jO6omh9/jiWeHLegYqyuZO4/cITO/cSc7G2PhFHI6CMf+CHiPMCfMdNWKXfrIH8GEFqeaQkwJyPDq3F7Wp8gNrIWJNOiGoHovtWsynKQp3jyaLBrBBOH3DjhxbVzPxso8Ulnt6qdM8SJ30/p36cI8MZcG9tqcELyMk787b9Vk2OafUhWWMy0F9N/BSEdRDGXnQdZINA7r6mtjTV0xGg2gdVs7FYxUg8eqDmg+QtcpiWdzSjw1+Sdp0n2wlO0oepLtCLzTfjfyy0WoTo6G2XBMO99bOYb47aLuMptsCfpbDJhZASW26lJhwBZLfU2yWrGaNWDMC/451KfDEQaF7i0Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuiDQ1qvHjVypg/77M68eUNojTmrE1TqpS61yWw/nTs=;
 b=RZdWRmkpLxUjbs9Klonz0Q9MWBWeFWRMfsLJoErHzhqHNoLGBZ9PNgQ0VCzOrCnnxjW+OvjtY2AMp9WyjazHj0p+MdPn7YYHBmqio6kr6IuVUc/K3IrkslrRRIryzIEbHBG9W3+eqVbOZvIN4bBnHFMycUYaNtZm2XlwPWun66Y=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0783.namprd21.prod.outlook.com (2603:10b6:300:77::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.1; Wed, 15 Sep
 2021 15:40:18 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9cb:4254:eba4:a4c3]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9cb:4254:eba4:a4c3%7]) with mapi id 15.20.4544.005; Wed, 15 Sep 2021
 15:40:18 +0000
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
Subject: RE: [PATCH V5 04/12] Drivers: hv: vmbus: Mark vmbus ring buffer
 visible to host in Isolation VM
Thread-Topic: [PATCH V5 04/12] Drivers: hv: vmbus: Mark vmbus ring buffer
 visible to host in Isolation VM
Thread-Index: AQHXqW3+Ls5cj1t0FE+tX661cSIFmqujrk9Q
Date:   Wed, 15 Sep 2021 15:40:17 +0000
Message-ID: <MWHPR21MB159336E9CB0BE98CB3F20348D7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210914133916.1440931-1-ltykernel@gmail.com>
 <20210914133916.1440931-5-ltykernel@gmail.com>
In-Reply-To: <20210914133916.1440931-5-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=39426b82-def3-4a21-8141-3f397c0df985;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-14T15:52:56Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 301ab89b-df54-4fde-3dc4-08d9785f1ec3
x-ms-traffictypediagnostic: MWHPR21MB0783:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB07838DAD01D32D38D645699DD7DB9@MWHPR21MB0783.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:48;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z+w68+6cVGdajtk43BjOr0SrcUOhlmNoe6kMDvTlBbjLDGolIQ4YgSctfSkGfOa2Y3BsG1qdFxm70U1AGhstgO5IP4MacFz5/0SKPyoNTc//rkmLcelUhkylvriCyRFMR0cJ2J7TDSf2wQ0og3/EG6w4m/2Dbwq4ZrgKfvuqJ82CuG4AhG+YicYXspuTZIX0ySJY1ydbMrJOYeS4wLne2rhuDJqIKF8nVW0eBAFx21oqc14QRQQmxL9jm874NVcUzXFexi7tIE7dtgjiRHi1KUPGE1YPpJNiS/TS4L2Mis8sVi9uBr/qJ1DQ9PymKyXovpnQDlIQQHVdZA3nBdr1GncRY0+k/+fQwMq+tUL4pxdIa0PfWbIwDoeElnNuKUtrw6b4GO+fYLR3iyTFEQv+FDgouPsGX4NuG1W2MfjS2IulKDc5AbhEAyJ3eh5hBnVuwAol96Egcmy6R5TEPbf6gMEcMSgPjaPNTNkHrXJURBIvpEwMcW6xLBRkgEN2jwFK7v4APaABYdCnbwaRfzPdmubdBbcg4gNxwTmvQKZgcC/VrjoVQxMnzrnhW9+Pe8jKo15DJMqU5U2fm6R85dMZeVo4FCKzvFIDpQqsuqHRHOYHbds2FFdqE0jU3ijg6eTBwvUPPK/vUBI1jqCb/BAyfYY07gfQ8AGX1iFcbMg5Nw/+HiykDWkzEBZXIQv1NpxwMjtHScvORBtLlgi8uW/TSOLl3gOnyH7E0ZCkmWTcbVc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(33656002)(7416002)(7406005)(66946007)(26005)(508600001)(9686003)(8936002)(2906002)(8676002)(30864003)(82960400001)(82950400001)(5660300002)(86362001)(921005)(186003)(122000001)(38070700005)(66556008)(10290500003)(66476007)(66446008)(64756008)(76116006)(38100700002)(316002)(54906003)(55016002)(83380400001)(6506007)(110136005)(71200400001)(52536014)(7696005)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5gpL0Yw3zFTsyL2aIf2DOBITn0FMvZDLaVRDDwtzb+k5e0vrmFfOJDuud08k?=
 =?us-ascii?Q?QCiiGVtkcJpoyb8+L9QpYV3Uyv5HsiuLrygXxlBKNNCVazx6rR0RLD1oAMwu?=
 =?us-ascii?Q?g3w9wSjzxerehacMJZ2Q3azCAB2thHYwb/oIDqe6wzO+CAu61dpFx4RbTB0R?=
 =?us-ascii?Q?CMZaV2Rf13RAdWkewiTgqy9sBHQ9FIq6snHBZb7ufwwMtAcMhyj881u6L0L1?=
 =?us-ascii?Q?AE6050MwVDVe6tHjnNSI/+cNsd+yYWnYquxKOQlcwtbNRJ+yCBHUvjI+tGMt?=
 =?us-ascii?Q?3Jb9gBCja+9nUE7yj9zvNhpMsC96YM1aZxHoK43TDVDd9+eEsKmPqSf26dNq?=
 =?us-ascii?Q?td3f8UM6noh3GHNsjJRy1akbrK9x6q9LxGy7o3o1dm9vzb9/VCuOn6AWu1oj?=
 =?us-ascii?Q?BxlR0cC4XkZ5S0apSNdTfH9CHlOq4qjNp1tEIc13hY2edLs/jY2V6lSQEyYW?=
 =?us-ascii?Q?roQjk2TXFr1UI5AclMYwHMHorN5q8MAV7g+U9oN5d+zrxZDsoHMxy+mV8rpi?=
 =?us-ascii?Q?b+kQsVaodzgfcrCjJOipPJg0fNjIhen3zTOJPoLJ+BFAms16sEFz/j5HKXDr?=
 =?us-ascii?Q?Hnq1Bq+fb/4hVjxFiOdI7+ax5PeIwwPAkZ2FtQYhH32DwyOntrZZw8xer4MA?=
 =?us-ascii?Q?ZjfnT23tnFrwF4jIyslRHgNSKFwxONm2Gb+3aps87sh6+ctq1kc5qYe814AJ?=
 =?us-ascii?Q?+fcF6lhz24hnnSEpGOiH9M571avCQhqwcLwcgxyd+eK82gveJ0cZy1/lIJMd?=
 =?us-ascii?Q?JPnIZmAua4aEyifHza5Tm5Eatv+sGJ/YbGx3Nq9QfarCdEZlm4Uq8amXqgNG?=
 =?us-ascii?Q?Zgy/nrdZxRmhjwiXWnwxGSl8Iee957l8HFHEWLADXAa9IBgRC3gq5WbNzCjO?=
 =?us-ascii?Q?CJlMn7blH+WfXdWKaefsrc6AvdnlTsEKwQsNgpnosD30AAcV2VdZAqLlALDK?=
 =?us-ascii?Q?TmlPtdtAdgx7Nko578Wnzx7h4Hmrv+lk8uvkqBqsZ/93WuozZEPLj1RL7Sni?=
 =?us-ascii?Q?Fr4Ghme1EUHBBs96f5IUBhE6t8WefV7pcqN9MG8noE5Jw9BtrLeSoaio74qu?=
 =?us-ascii?Q?BTRwa0KAkRUTVwcZp+i4LxSXBxQtxJHKjajzxNDo8+BGYIW6Rac8qiJvkPIi?=
 =?us-ascii?Q?YFanuSGc6qUkmaXNfnfuRMNc74Xs7wXIjmhMP4YKmLo3PRQT8h5CbMid2CFD?=
 =?us-ascii?Q?0qq1QUclKyxjNCD1G2xugjs8kS5xQKbQtPSlqG+nXc0fZhCsyI6/X+aGgeGQ?=
 =?us-ascii?Q?op+aID1i28hn5UFlyIS/FzAyTAhrodTv6g9o8aJnn7CkPvJogTJj4dbEHynz?=
 =?us-ascii?Q?uMJ92e7+NPntjSC7xkR3vXM4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 301ab89b-df54-4fde-3dc4-08d9785f1ec3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 15:40:17.9126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sz49JHb3QuT41F68vM7pdl6fZq1l26Djcqb9/tU8Gq4wgbQbUaCSgI4PdTkzd7fWEf3YfFZH5dt+MDvK0UYEDokvc0E1iTLeC92zRCIasMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0783
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Tuesday, September 14, 2021 6:=
39 AM
>=20
> Mark vmbus ring buffer visible with set_memory_decrypted() when
> establish gpadl handle.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change sincv v4
> 	* Change gpadl handle in netvsc and uio driver from u32 to
> 	  struct vmbus_gpadl.
> 	* Change vmbus_establish_gpadl()'s gpadl_handle parameter
> 	  to vmbus_gpadl data structure.
>=20
> Change since v3:
> 	* Change vmbus_teardown_gpadl() parameter and put gpadl handle,
> 	  buffer and buffer size in the struct vmbus_gpadl.
> ---
>  drivers/hv/channel.c            | 54 ++++++++++++++++++++++++---------
>  drivers/net/hyperv/hyperv_net.h |  5 +--
>  drivers/net/hyperv/netvsc.c     | 17 ++++++-----
>  drivers/uio/uio_hv_generic.c    | 20 ++++++------
>  include/linux/hyperv.h          | 12 ++++++--
>  5 files changed, 71 insertions(+), 37 deletions(-)
>=20
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index f3761c73b074..cf419eb1de77 100644
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
> @@ -456,7 +457,7 @@ static int create_gpadl_header(enum hv_gpadl_type typ=
e, void *kbuffer,
>  static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
>  				   enum hv_gpadl_type type, void *kbuffer,
>  				   u32 size, u32 send_offset,
> -				   u32 *gpadl_handle)
> +				   struct vmbus_gpadl *gpadl)
>  {
>  	struct vmbus_channel_gpadl_header *gpadlmsg;
>  	struct vmbus_channel_gpadl_body *gpadl_body;
> @@ -474,6 +475,15 @@ static int __vmbus_establish_gpadl(struct vmbus_chan=
nel *channel,
>  	if (ret)
>  		return ret;
>=20
> +	ret =3D set_memory_decrypted((unsigned long)kbuffer,
> +				   HVPFN_UP(size));

This should be PFN_UP, not HVPFN_UP.  The numpages parameter to
set_memory_decrypted() is in guest size pages, not Hyper-V size pages.

> +	if (ret) {
> +		dev_warn(&channel->device_obj->device,
> +			 "Failed to set host visibility for new GPADL %d.\n",
> +			 ret);
> +		return ret;
> +	}
> +
>  	init_completion(&msginfo->waitevent);
>  	msginfo->waiting_channel =3D channel;
>=20
> @@ -537,7 +547,10 @@ static int __vmbus_establish_gpadl(struct vmbus_chan=
nel *channel,
>  	}
>=20
>  	/* At this point, we received the gpadl created msg */
> -	*gpadl_handle =3D gpadlmsg->gpadl;
> +	gpadl->gpadl_handle =3D gpadlmsg->gpadl;
> +	gpadl->buffer =3D kbuffer;
> +	gpadl->size =3D size;
> +
>=20
>  cleanup:
>  	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
> @@ -549,6 +562,11 @@ static int __vmbus_establish_gpadl(struct vmbus_chan=
nel *channel,
>  	}
>=20
>  	kfree(msginfo);
> +
> +	if (ret)
> +		set_memory_encrypted((unsigned long)kbuffer,
> +				     HVPFN_UP(size));

Should be PFN_UP as noted on the previous call to set_memory_decrypted().

> +
>  	return ret;
>  }
>=20
> @@ -561,10 +579,10 @@ static int __vmbus_establish_gpadl(struct vmbus_cha=
nnel *channel,
>   * @gpadl_handle: some funky thing
>   */
>  int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
> -			  u32 size, u32 *gpadl_handle)
> +			  u32 size, struct vmbus_gpadl *gpadl)
>  {
>  	return __vmbus_establish_gpadl(channel, HV_GPADL_BUFFER, kbuffer, size,
> -				       0U, gpadl_handle);
> +				       0U, gpadl);
>  }
>  EXPORT_SYMBOL_GPL(vmbus_establish_gpadl);
>=20
> @@ -639,6 +657,7 @@ static int __vmbus_open(struct vmbus_channel *newchan=
nel,
>  	struct vmbus_channel_open_channel *open_msg;
>  	struct vmbus_channel_msginfo *open_info =3D NULL;
>  	struct page *page =3D newchannel->ringbuffer_page;
> +	struct vmbus_gpadl gpadl;

I think this local variable was needed in a previous version of the patch, =
but
is now unused and should be deleted.

>  	u32 send_pages, recv_pages;
>  	unsigned long flags;
>  	int err;
> @@ -675,7 +694,7 @@ static int __vmbus_open(struct vmbus_channel *newchan=
nel,
>  		goto error_clean_ring;
>=20
>  	/* Establish the gpadl for the ring buffer */
> -	newchannel->ringbuffer_gpadlhandle =3D 0;
> +	newchannel->ringbuffer_gpadlhandle.gpadl_handle =3D 0;
>=20
>  	err =3D __vmbus_establish_gpadl(newchannel, HV_GPADL_RING,
>  				      page_address(newchannel->ringbuffer_page),
> @@ -701,7 +720,8 @@ static int __vmbus_open(struct vmbus_channel *newchan=
nel,
>  	open_msg->header.msgtype =3D CHANNELMSG_OPENCHANNEL;
>  	open_msg->openid =3D newchannel->offermsg.child_relid;
>  	open_msg->child_relid =3D newchannel->offermsg.child_relid;
> -	open_msg->ringbuffer_gpadlhandle =3D newchannel->ringbuffer_gpadlhandle=
;
> +	open_msg->ringbuffer_gpadlhandle
> +		=3D newchannel->ringbuffer_gpadlhandle.gpadl_handle;
>  	/*
>  	 * The unit of ->downstream_ringbuffer_pageoffset is HV_HYP_PAGE and
>  	 * the unit of ->ringbuffer_send_offset (i.e. send_pages) is PAGE, so
> @@ -759,8 +779,8 @@ static int __vmbus_open(struct vmbus_channel *newchan=
nel,
>  error_free_info:
>  	kfree(open_info);
>  error_free_gpadl:
> -	vmbus_teardown_gpadl(newchannel, newchannel->ringbuffer_gpadlhandle);
> -	newchannel->ringbuffer_gpadlhandle =3D 0;
> +	vmbus_teardown_gpadl(newchannel, &newchannel->ringbuffer_gpadlhandle);
> +	newchannel->ringbuffer_gpadlhandle.gpadl_handle =3D 0;

My previous comments had suggested letting vmbus_teardown_gpadl() set the
gpadl_handle to zero, avoiding the need for all the callers to set it to ze=
ro.
Did that not work for some reason?  Just curious ....

>  error_clean_ring:
>  	hv_ringbuffer_cleanup(&newchannel->outbound);
>  	hv_ringbuffer_cleanup(&newchannel->inbound);
> @@ -806,7 +826,7 @@ EXPORT_SYMBOL_GPL(vmbus_open);
>  /*
>   * vmbus_teardown_gpadl -Teardown the specified GPADL handle
>   */
> -int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle=
)
> +int vmbus_teardown_gpadl(struct vmbus_channel *channel, struct vmbus_gpa=
dl *gpadl)
>  {
>  	struct vmbus_channel_gpadl_teardown *msg;
>  	struct vmbus_channel_msginfo *info;
> @@ -825,7 +845,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channe=
l, u32 gpadl_handle)
>=20
>  	msg->header.msgtype =3D CHANNELMSG_GPADL_TEARDOWN;
>  	msg->child_relid =3D channel->offermsg.child_relid;
> -	msg->gpadl =3D gpadl_handle;
> +	msg->gpadl =3D gpadl->gpadl_handle;
>=20
>  	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
>  	list_add_tail(&info->msglistentry,
> @@ -859,6 +879,12 @@ int vmbus_teardown_gpadl(struct vmbus_channel *chann=
el, u32 gpadl_handle)
>  	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
>=20
>  	kfree(info);
> +
> +	ret =3D set_memory_encrypted((unsigned long)gpadl->buffer,
> +				   HVPFN_UP(gpadl->size));

PFN_UP here as well.

> +	if (ret)
> +		pr_warn("Fail to set mem host visibility in GPADL teardown %d.\n", ret=
);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(vmbus_teardown_gpadl);
> @@ -896,6 +922,7 @@ void vmbus_reset_channel_cb(struct vmbus_channel *cha=
nnel)
>  static int vmbus_close_internal(struct vmbus_channel *channel)
>  {
>  	struct vmbus_channel_close_channel *msg;
> +	struct vmbus_gpadl gpadl;

I think this local variable was needed in a previous version of the patch, =
but
is now unused and should be deleted.

>  	int ret;
>=20
>  	vmbus_reset_channel_cb(channel);
> @@ -933,9 +960,8 @@ static int vmbus_close_internal(struct vmbus_channel =
*channel)
>  	}
>=20
>  	/* Tear down the gpadl for the channel's ring buffer */
> -	else if (channel->ringbuffer_gpadlhandle) {
> -		ret =3D vmbus_teardown_gpadl(channel,
> -					   channel->ringbuffer_gpadlhandle);
> +	else if (channel->ringbuffer_gpadlhandle.gpadl_handle) {
> +		ret =3D vmbus_teardown_gpadl(channel, &channel->ringbuffer_gpadlhandle=
);
>  		if (ret) {
>  			pr_err("Close failed: teardown gpadl return %d\n", ret);
>  			/*
> @@ -944,7 +970,7 @@ static int vmbus_close_internal(struct vmbus_channel =
*channel)
>  			 */
>  		}
>=20
> -		channel->ringbuffer_gpadlhandle =3D 0;
> +		channel->ringbuffer_gpadlhandle.gpadl_handle =3D 0;
>  	}
>=20
>  	if (!ret)
> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_=
net.h
> index bc48855dff10..315278a7cf88 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -1075,14 +1075,15 @@ struct netvsc_device {
>  	/* Receive buffer allocated by us but manages by NetVSP */
>  	void *recv_buf;
>  	u32 recv_buf_size; /* allocated bytes */
> -	u32 recv_buf_gpadl_handle;
> +	struct vmbus_gpadl recv_buf_gpadl_handle;
>  	u32 recv_section_cnt;
>  	u32 recv_section_size;
>  	u32 recv_completion_cnt;
>=20
>  	/* Send buffer allocated by us */
>  	void *send_buf;
> -	u32 send_buf_gpadl_handle;
> +	u32 send_buf_size;
> +	struct vmbus_gpadl send_buf_gpadl_handle;
>  	u32 send_section_cnt;
>  	u32 send_section_size;
>  	unsigned long *send_section_map;
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 7bd935412853..1f87e570ed2b 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -278,9 +278,9 @@ static void netvsc_teardown_recv_gpadl(struct hv_devi=
ce *device,
>  {
>  	int ret;
>=20
> -	if (net_device->recv_buf_gpadl_handle) {
> +	if (net_device->recv_buf_gpadl_handle.gpadl_handle) {
>  		ret =3D vmbus_teardown_gpadl(device->channel,
> -					   net_device->recv_buf_gpadl_handle);
> +					   &net_device->recv_buf_gpadl_handle);
>=20
>  		/* If we failed here, we might as well return and have a leak
>  		 * rather than continue and a bugchk
> @@ -290,7 +290,7 @@ static void netvsc_teardown_recv_gpadl(struct hv_devi=
ce *device,
>  				   "unable to teardown receive buffer's gpadl\n");
>  			return;
>  		}
> -		net_device->recv_buf_gpadl_handle =3D 0;
> +		net_device->recv_buf_gpadl_handle.gpadl_handle =3D 0;
>  	}
>  }
>=20
> @@ -300,9 +300,9 @@ static void netvsc_teardown_send_gpadl(struct hv_devi=
ce *device,
>  {
>  	int ret;
>=20
> -	if (net_device->send_buf_gpadl_handle) {
> +	if (net_device->send_buf_gpadl_handle.gpadl_handle) {
>  		ret =3D vmbus_teardown_gpadl(device->channel,
> -					   net_device->send_buf_gpadl_handle);
> +					   &net_device->send_buf_gpadl_handle);
>=20
>  		/* If we failed here, we might as well return and have a leak
>  		 * rather than continue and a bugchk
> @@ -312,7 +312,7 @@ static void netvsc_teardown_send_gpadl(struct hv_devi=
ce *device,
>  				   "unable to teardown send buffer's gpadl\n");
>  			return;
>  		}
> -		net_device->send_buf_gpadl_handle =3D 0;
> +		net_device->send_buf_gpadl_handle.gpadl_handle =3D 0;
>  	}
>  }
>=20
> @@ -380,7 +380,7 @@ static int netvsc_init_buf(struct hv_device *device,
>  	memset(init_packet, 0, sizeof(struct nvsp_message));
>  	init_packet->hdr.msg_type =3D NVSP_MSG1_TYPE_SEND_RECV_BUF;
>  	init_packet->msg.v1_msg.send_recv_buf.
> -		gpadl_handle =3D net_device->recv_buf_gpadl_handle;
> +		gpadl_handle =3D net_device->recv_buf_gpadl_handle.gpadl_handle;
>  	init_packet->msg.v1_msg.
>  		send_recv_buf.id =3D NETVSC_RECEIVE_BUFFER_ID;
>=20
> @@ -463,6 +463,7 @@ static int netvsc_init_buf(struct hv_device *device,
>  		ret =3D -ENOMEM;
>  		goto cleanup;
>  	}
> +	net_device->send_buf_size =3D buf_size;
>=20
>  	/* Establish the gpadl handle for this buffer on this
>  	 * channel.  Note: This call uses the vmbus connection rather
> @@ -482,7 +483,7 @@ static int netvsc_init_buf(struct hv_device *device,
>  	memset(init_packet, 0, sizeof(struct nvsp_message));
>  	init_packet->hdr.msg_type =3D NVSP_MSG1_TYPE_SEND_SEND_BUF;
>  	init_packet->msg.v1_msg.send_send_buf.gpadl_handle =3D
> -		net_device->send_buf_gpadl_handle;
> +		net_device->send_buf_gpadl_handle.gpadl_handle;
>  	init_packet->msg.v1_msg.send_send_buf.id =3D NETVSC_SEND_BUFFER_ID;
>=20
>  	trace_nvsp_send(ndev, init_packet);
> diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
> index 652fe2547587..548243dcd895 100644
> --- a/drivers/uio/uio_hv_generic.c
> +++ b/drivers/uio/uio_hv_generic.c
> @@ -58,11 +58,11 @@ struct hv_uio_private_data {
>  	atomic_t refcnt;
>=20
>  	void	*recv_buf;
> -	u32	recv_gpadl;
> +	struct vmbus_gpadl recv_gpadl;
>  	char	recv_name[32];	/* "recv_4294967295" */
>=20
>  	void	*send_buf;
> -	u32	send_gpadl;
> +	struct vmbus_gpadl send_gpadl;
>  	char	send_name[32];
>  };
>=20
> @@ -179,15 +179,15 @@ hv_uio_new_channel(struct vmbus_channel *new_sc)
>  static void
>  hv_uio_cleanup(struct hv_device *dev, struct hv_uio_private_data *pdata)
>  {
> -	if (pdata->send_gpadl) {
> -		vmbus_teardown_gpadl(dev->channel, pdata->send_gpadl);
> -		pdata->send_gpadl =3D 0;
> +	if (pdata->send_gpadl.gpadl_handle) {
> +		vmbus_teardown_gpadl(dev->channel, &pdata->send_gpadl);
> +		pdata->send_gpadl.gpadl_handle =3D 0;
>  		vfree(pdata->send_buf);
>  	}
>=20
> -	if (pdata->recv_gpadl) {
> -		vmbus_teardown_gpadl(dev->channel, pdata->recv_gpadl);
> -		pdata->recv_gpadl =3D 0;
> +	if (pdata->recv_gpadl.gpadl_handle) {
> +		vmbus_teardown_gpadl(dev->channel, &pdata->recv_gpadl);
> +		pdata->recv_gpadl.gpadl_handle =3D 0;
>  		vfree(pdata->recv_buf);
>  	}
>  }
> @@ -303,7 +303,7 @@ hv_uio_probe(struct hv_device *dev,
>=20
>  	/* put Global Physical Address Label in name */
>  	snprintf(pdata->recv_name, sizeof(pdata->recv_name),
> -		 "recv:%u", pdata->recv_gpadl);
> +		 "recv:%u", pdata->recv_gpadl.gpadl_handle);
>  	pdata->info.mem[RECV_BUF_MAP].name =3D pdata->recv_name;
>  	pdata->info.mem[RECV_BUF_MAP].addr
>  		=3D (uintptr_t)pdata->recv_buf;
> @@ -324,7 +324,7 @@ hv_uio_probe(struct hv_device *dev,
>  	}
>=20
>  	snprintf(pdata->send_name, sizeof(pdata->send_name),
> -		 "send:%u", pdata->send_gpadl);
> +		 "send:%u", pdata->send_gpadl.gpadl_handle);
>  	pdata->info.mem[SEND_BUF_MAP].name =3D pdata->send_name;
>  	pdata->info.mem[SEND_BUF_MAP].addr
>  		=3D (uintptr_t)pdata->send_buf;
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index ddc8713ce57b..a9e0bc3b1511 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -803,6 +803,12 @@ struct vmbus_device {
>=20
>  #define VMBUS_DEFAULT_MAX_PKT_SIZE 4096
>=20
> +struct vmbus_gpadl {
> +	u32 gpadl_handle;
> +	u32 size;
> +	void *buffer;
> +};
> +
>  struct vmbus_channel {
>  	struct list_head listentry;
>=20
> @@ -822,7 +828,7 @@ struct vmbus_channel {
>  	bool rescind_ref; /* got rescind msg, got channel reference */
>  	struct completion rescind_event;
>=20
> -	u32 ringbuffer_gpadlhandle;
> +	struct vmbus_gpadl ringbuffer_gpadlhandle;
>=20
>  	/* Allocated memory for ring buffer */
>  	struct page *ringbuffer_page;
> @@ -1192,10 +1198,10 @@ extern int vmbus_sendpacket_mpb_desc(struct vmbus=
_channel *channel,
>  extern int vmbus_establish_gpadl(struct vmbus_channel *channel,
>  				      void *kbuffer,
>  				      u32 size,
> -				      u32 *gpadl_handle);
> +				      struct vmbus_gpadl *gpadl);
>=20
>  extern int vmbus_teardown_gpadl(struct vmbus_channel *channel,
> -				     u32 gpadl_handle);
> +				     struct vmbus_gpadl *gpadl);
>=20
>  void vmbus_reset_channel_cb(struct vmbus_channel *channel);
>=20
> --
> 2.25.1

