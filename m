Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954FA41FC4C
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 15:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbhJBN2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 09:28:19 -0400
Received: from mail-oln040093003014.outbound.protection.outlook.com ([40.93.3.14]:32320
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230089AbhJBN2R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 09:28:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6xoQAQfvZma7qKWhId98USvBogAytL6flv/vzdSseiLsrLAPODZbL77yP0b2lh+sqpaNmyuwCUxNjopMw8hbKZP122URBY6e3fR5Xt0Ch3so8m16v0xVTt/uCO3P6oA2BUzc87FLEvN+N4eQV9nyxNft70jYQIiWnwsGOKTkU1kZXLwpd3k8DNoiyB0d5R3o1whoDVQSGq95hTVGd5J5eRP1IknxJZ+IjlpD3CcwGTOf9zp50iBDKvNLERSKERkn4yAuNFd6xnmI6C8yagNev/jLBD85z5SjVRWWsF9hTCNjwcH09/ocEcZ8x0X4esI129wfbkYMV+dhVtBeO9rmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ccapwOvJcvZZbX9Dpho2siajlm0alArAyVUpX0nxPMA=;
 b=kwcWPRD0KyYNbYejFHfFI4a7Onaz9/lWkkRC47SJ6bEsr7lK4+663pk3gAj1gGHQ+dSrCpcUyGuYu4wg9X85JLEi/tpOzquKxQvHxw0QKWKJh/6+fNS8MJHAbOOUYks8X26yFrqH7Fewmd4Wca9W64pBZsQsUe4CAv11I1kVyJ2JBDB7nl5ks9RO7wD8BhxbrpNcxUFdSXadyStYle3f0TkF6zGsYGXYxRqNfnxvLTKXcHNK0q0tgNge9jtrYXt7YS0+rODoSDNeRNwNubFwKti1O6aoOvOKK7X0EGx7e+pDonNpZVhULQU8ZhsEZwIspDpNTcTh3msLsSLLzg+2Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccapwOvJcvZZbX9Dpho2siajlm0alArAyVUpX0nxPMA=;
 b=SPyp8B416AJCMwFBBjpHeb/cxSWRQBOEC9xvVf2utEHVPKvmdH3CWCd09qkl9IedVT2bOUBAx/Sv1fI5iCu298kAAkuredc4X4S/3tI6GR0ZpPhT3XCS9B6owtYrK4gLl9cmarhO2GP21pFgicoABLoDpRkx+xfdYg5NPZx+zT0=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by CO1PR21MB1281.namprd21.prod.outlook.com (2603:10b6:303:160::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.2; Sat, 2 Oct
 2021 13:26:26 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::6129:c6f7:3f56:c899]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::6129:c6f7:3f56:c899%4]) with mapi id 15.20.4587.013; Sat, 2 Oct 2021
 13:26:26 +0000
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
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "tj@kernel.org" <tj@kernel.org>
CC:     "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V6 7/8] Drivers: hv: vmbus: Add SNP support for VMbus
 channel initiate  message
Thread-Topic: [PATCH V6 7/8] Drivers: hv: vmbus: Add SNP support for VMbus
 channel initiate  message
Thread-Index: AQHXtfvyIQOjP+tUd0awi444HXmTFqu/ss0Q
Date:   Sat, 2 Oct 2021 13:26:26 +0000
Message-ID: <MWHPR21MB15933BC87034940AB7170552D7AC9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210930130545.1210298-1-ltykernel@gmail.com>
 <20210930130545.1210298-8-ltykernel@gmail.com>
In-Reply-To: <20210930130545.1210298-8-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e5d00b32-ac26-4827-8703-4e604eb1f01c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-02T13:14:09Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c3533ea-5dd3-4e4b-ce86-08d985a83c68
x-ms-traffictypediagnostic: CO1PR21MB1281:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CO1PR21MB12812AA9542EDFBCC5C08977D7AC9@CO1PR21MB1281.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UOgvP6Vo5M32XgD6v+Mj8xWzwFW61iQb7eE+1gHfVvFZgguOYnoUVPsLZtBTgVIwC7MjHJD6ewTB9Jwa38bVlQw96vJuP6b1BVjE0kzEAOlOOdJoZiEktpLC6Nt/GFVGjLECyGKfDeOtbJ0e5R4I0K67mFFGZoTDyNX79b+4QQB3lpkX7dcOc4rac3vEoOYv2eUtWIsMYv+t2PMnLYTLXQoenFo2wuGZ3MkV819DrvPMbtKImlnpv1m5aTyrixZM2NnIa8agZj1YE+UG6ziduVH8QCjXitYqMHT5lTO4vWFlzoqtVOf+R7mLPkTOnvzXhIpfplx8/bBe8JbOmGFfG25tAEw310nwTqQ0HICYyRZtWYu0wCwmKvK3GtBu6AX3TvSvvDk1uzk95dysX0anFPZmAv3eWvomf8zqBHHHR4LUWkJ0WRfYuBubrklSXXukrYCRyVzCk7UDbt77yVQOhQqN/xm5lEet8vQseS6xOKeSdqeaBo86jud+VEU+QZt/tghDRz+G5RNpVjgwHHWe7YQ7aHzoZFz0Nyh7KyDBFQQ1PK4VJRXviLC2kZH4OHsT6IjkdpLZvC54FgCD9QQku1P1OLDiUZ8gR+LulYHvOR+L0MvvNhwArFDas5ocmVrHptydMGG+Izi8tSST92ul0tILjkB/0z4fLkSHpe3OnMmlu+JuH62yW/jrL4pUlQjR2EOwtCect64obK2E5IrZs4GkUDGJrSjFceFqRTkaMxc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(9686003)(7406005)(7416002)(921005)(76116006)(66476007)(2906002)(82950400001)(82960400001)(110136005)(7696005)(15650500001)(54906003)(316002)(83380400001)(66556008)(8936002)(64756008)(66446008)(6506007)(66946007)(5660300002)(86362001)(122000001)(4326008)(38100700002)(71200400001)(33656002)(10290500003)(55016002)(8676002)(186003)(8990500004)(52536014)(26005)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Iw4rB2+U/8uMNineIP0ruu1Nl0YWFhuTtOPICPaFNeKigQC8E2/lrdEmNo3q?=
 =?us-ascii?Q?3EDzLrnaVE8MW8MUg+HYcV49VazHI9tWZuu3Q95O/cXzu/TosWW87k6ZNUPw?=
 =?us-ascii?Q?gj+QryrR+OXbnL2KmITz3Ys9bGVP50RUdGvUTjoqDc+ThSJvqXW+QRYG4+p6?=
 =?us-ascii?Q?ve2lVn8UXN6NPpPmHEV7GNQwMLi+NLsbjbtt7hjpCRPS03s5FTKV+lJSfQQH?=
 =?us-ascii?Q?GQCftX4tA6fYULOTHi1k3zPja/E2ypXrWLbXYRKo6R1MhReEifUp6qVb0nDH?=
 =?us-ascii?Q?6eHrlQKRuiL6mY3hCOcO5gSj+Yh81+kp6+1416GNZjO/e/jNWKWTdB445F3c?=
 =?us-ascii?Q?kDVpPBA7qA2IHdmqkkhO6v6ASCxpy001nngJ38t+UC58QNnk5I4i3nE0Ei7a?=
 =?us-ascii?Q?jXv5cNZL8j4/sxHu8NR9d2zdogLmuLG8e/3WAZo2cu6y5jHdj/1WP64lwNVm?=
 =?us-ascii?Q?Z33zadEWDWT0JuQ9ppo3mSoT7JxW7tNWW6GhKAA5v759xDgbl0ETKO4soO8/?=
 =?us-ascii?Q?oaXpjpk3+Zf5VteOs8ctvxR11FZHaQ1sNA8BOwY3hzMrMUlTX2wVKzjbrMKz?=
 =?us-ascii?Q?JN5ZrAPsWZ4p3Di2RIl04cB/F4MBckQso1BWlmdjtJY41lx4gT12MEjltPao?=
 =?us-ascii?Q?9E4wKIK59QzRjvx0x55S/f/a3ggXcw+u6PN8XDwRMAKj9JLhZcmoCnpDwYvy?=
 =?us-ascii?Q?wLzZKaQ/auKgQdA1SggGEPp9kIzkPWpRNSASNAXOJvplWqpBqcldLLe1aK8t?=
 =?us-ascii?Q?7WUQ4cGwSWXU4QdKLVWkhnStJ/9P+iuYIFxcGs9VZvrmGZcsqFjeefq921iw?=
 =?us-ascii?Q?dbfP4VvfHiw+XjXqhK77jPvS6D2p6f2HPBcEXX5fmDFnNffKsyDTWNJ1Oowd?=
 =?us-ascii?Q?0vzUpKPUwwHfgnbex7PsjxHKHjInbZwz4s37Sex2f9SWwmnkIz5OJU25y0g2?=
 =?us-ascii?Q?iN6KzyYz6A31O465WVK0Uxvb5KrpsGkz3WvP9Qknarq5WwXRHsl2T+LMOE05?=
 =?us-ascii?Q?40q/iGHPkcCABbo8Se2ifo9CZL3NnwWq+Y8OaubWqqJO5W5Ofdmm87K1MCeB?=
 =?us-ascii?Q?GZp+X0fGh7UW9/6P04eUJ/1uwuX7TGQWW5EqRHRXM+dEWkUX95om4J9X0gcv?=
 =?us-ascii?Q?FHdLbXSZ/y0PZhQE4VlrNvX8nrG0rgPGUvDPlmK63oH5HSK2j4o4/+wtyin7?=
 =?us-ascii?Q?x65UJeIcmf26ZEJVvHYNxxILIjpoW6JplhMS0bMe/4lCbDPj8vYlkL1Ix549?=
 =?us-ascii?Q?4WxXk2J5KvFML1+IOrKTtl+maQgNlcIGPV80ETxF4Zan6afbRnIZnIJRkFE+?=
 =?us-ascii?Q?Vb7YjaTMA+NbMTDNLnPV5Eg5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c3533ea-5dd3-4e4b-ce86-08d985a83c68
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2021 13:26:26.3167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nxfq8qbtj52UDNJqXOuGqzqoKZ+5Bbv4F57P390V2fyu5gAxUVSWNveG8bpMXuF2d40N7P9NG893S5IFZFeJ+VRoTaqMSGl5aqfyGC5eApU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR21MB1281
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Thursday, September 30, 2021 6=
:06 AM
>=20
> The monitor pages in the CHANNELMSG_INITIATE_CONTACT msg are shared
> with host in Isolation VM and so it's necessary to use hvcall to set
> them visible to host. In Isolation VM with AMD SEV SNP, the access
> address should be in the extra space which is above shared gpa
> boundary. So remap these pages into the extra address(pa +
> shared_gpa_boundary).
>=20
> Introduce monitor_pages_original[] in the struct vmbus_connection
> to store monitor page virtual address returned by hv_alloc_hyperv_
> zeroed_page() and free monitor page via monitor_pages_original in
> the vmbus_disconnect(). The monitor_pages[] is to used to access
> monitor page and it is initialized to be equal with monitor_pages_
> original. The monitor_pages[] will be overridden in the isolation VM
> with va of extra address. Introduce monitor_pages_pa[] to store
> monitor pages' physical address and use it to populate pa in the
> initiate msg.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v5:
> 	*  change vmbus_connection.monitor_pages_pa type from
> 	   unsigned long to phys_addr_t
> 	*  Plus vmbus_connection.monitor_pages_pa with ms_hyperv.
> 	   shared_gpa_boundary only in the IVM with AMD SEV.
>=20
> Change since v4:
> 	* Introduce monitor_pages_pa[] to store monitor pages' physical
> 	  address and use it to populate pa in the initiate msg.
> 	* Move code of mapping moniter pages in extra address into
> 	  vmbus_connect().
>=20
> Change since v3:
> 	* Rename monitor_pages_va with monitor_pages_original
> 	* free monitor page via monitor_pages_original and
> 	  monitor_pages is used to access monitor page.
>=20
> Change since v1:
>         * Not remap monitor pages in the non-SNP isolation VM.
> ---
>  drivers/hv/connection.c   | 90 ++++++++++++++++++++++++++++++++++++---
>  drivers/hv/hyperv_vmbus.h |  2 +
>  2 files changed, 86 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
> index 8820ae68f20f..7fac8d99541c 100644
> --- a/drivers/hv/connection.c
> +++ b/drivers/hv/connection.c
> @@ -19,6 +19,8 @@
>  #include <linux/vmalloc.h>
>  #include <linux/hyperv.h>
>  #include <linux/export.h>
> +#include <linux/io.h>
> +#include <linux/set_memory.h>
>  #include <asm/mshyperv.h>
>=20
>  #include "hyperv_vmbus.h"
> @@ -102,8 +104,9 @@ int vmbus_negotiate_version(struct vmbus_channel_msgi=
nfo *msginfo, u32 version)
>  		vmbus_connection.msg_conn_id =3D VMBUS_MESSAGE_CONNECTION_ID;
>  	}
>=20
> -	msg->monitor_page1 =3D virt_to_phys(vmbus_connection.monitor_pages[0]);
> -	msg->monitor_page2 =3D virt_to_phys(vmbus_connection.monitor_pages[1]);
> +	msg->monitor_page1 =3D vmbus_connection.monitor_pages_pa[0];
> +	msg->monitor_page2 =3D vmbus_connection.monitor_pages_pa[1];
> +
>  	msg->target_vcpu =3D hv_cpu_number_to_vp_number(VMBUS_CONNECT_CPU);
>=20
>  	/*
> @@ -216,6 +219,65 @@ int vmbus_connect(void)
>  		goto cleanup;
>  	}
>=20
> +	vmbus_connection.monitor_pages_original[0]
> +		=3D vmbus_connection.monitor_pages[0];
> +	vmbus_connection.monitor_pages_original[1]
> +		=3D vmbus_connection.monitor_pages[1];
> +	vmbus_connection.monitor_pages_pa[0]
> +		=3D virt_to_phys(vmbus_connection.monitor_pages[0]);
> +	vmbus_connection.monitor_pages_pa[1]
> +		=3D virt_to_phys(vmbus_connection.monitor_pages[1]);
> +
> +	if (hv_is_isolation_supported()) {
> +		ret =3D set_memory_decrypted((unsigned long)
> +					   vmbus_connection.monitor_pages[0],
> +					   1);
> +		ret |=3D set_memory_decrypted((unsigned long)
> +					    vmbus_connection.monitor_pages[1],
> +					    1);
> +		if (ret)
> +			goto cleanup;
> +
> +		/*
> +		 * Isolation VM with AMD SNP needs to access monitor page via
> +		 * address space above shared gpa boundary.
> +		 */
> +		if (hv_isolation_type_snp()) {
> +			vmbus_connection.monitor_pages_pa[0] +=3D
> +				ms_hyperv.shared_gpa_boundary;
> +			vmbus_connection.monitor_pages_pa[1] +=3D
> +				ms_hyperv.shared_gpa_boundary;
> +
> +			vmbus_connection.monitor_pages[0]
> +				=3D memremap(vmbus_connection.monitor_pages_pa[0],
> +					   HV_HYP_PAGE_SIZE,
> +					   MEMREMAP_WB);
> +			if (!vmbus_connection.monitor_pages[0]) {
> +				ret =3D -ENOMEM;
> +				goto cleanup;
> +			}
> +
> +			vmbus_connection.monitor_pages[1]
> +				=3D memremap(vmbus_connection.monitor_pages_pa[1],
> +					   HV_HYP_PAGE_SIZE,
> +					   MEMREMAP_WB);
> +			if (!vmbus_connection.monitor_pages[1]) {
> +				ret =3D -ENOMEM;
> +				goto cleanup;
> +			}
> +		}
> +
> +		/*
> +		 * Set memory host visibility hvcall smears memory
> +		 * and so zero monitor pages here.
> +		 */
> +		memset(vmbus_connection.monitor_pages[0], 0x00,
> +		       HV_HYP_PAGE_SIZE);
> +		memset(vmbus_connection.monitor_pages[1], 0x00,
> +		       HV_HYP_PAGE_SIZE);
> +
> +	}
> +
>  	msginfo =3D kzalloc(sizeof(*msginfo) +
>  			  sizeof(struct vmbus_channel_initiate_contact),
>  			  GFP_KERNEL);
> @@ -303,10 +365,26 @@ void vmbus_disconnect(void)
>  		vmbus_connection.int_page =3D NULL;
>  	}
>=20
> -	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[0]);
> -	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[1]);
> -	vmbus_connection.monitor_pages[0] =3D NULL;
> -	vmbus_connection.monitor_pages[1] =3D NULL;
> +	if (hv_is_isolation_supported()) {
> +		memunmap(vmbus_connection.monitor_pages[0]);
> +		memunmap(vmbus_connection.monitor_pages[1]);

The matching memremap() calls are made in vmbus_connect() only in the
SNP case.  In the non-SNP case, monitor_pages and monitor_pages_original
are the same, so you would be doing an unmap, and then doing the
set_memory_encrypted() and hv_free_hyperv_page() using an address
that is no longer mapped, which seems wrong.   Looking at memunmap(),
it might be a no-op in this case, but even if it is, making them conditiona=
l
on the SNP case might be a safer thing to do, and it would make the code
more symmetrical.

> +
> +		set_memory_encrypted((unsigned long)
> +			vmbus_connection.monitor_pages_original[0],
> +			1);
> +		set_memory_encrypted((unsigned long)
> +			vmbus_connection.monitor_pages_original[1],
> +			1);
> +	}
> +
> +	hv_free_hyperv_page((unsigned long)
> +		vmbus_connection.monitor_pages_original[0]);
> +	hv_free_hyperv_page((unsigned long)
> +		vmbus_connection.monitor_pages_original[1]);
> +	vmbus_connection.monitor_pages_original[0] =3D
> +		vmbus_connection.monitor_pages[0] =3D NULL;
> +	vmbus_connection.monitor_pages_original[1] =3D
> +		vmbus_connection.monitor_pages[1] =3D NULL;
>  }
>=20
>  /*
> diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
> index 42f3d9d123a1..d0a5232a1c3e 100644
> --- a/drivers/hv/hyperv_vmbus.h
> +++ b/drivers/hv/hyperv_vmbus.h
> @@ -240,6 +240,8 @@ struct vmbus_connection {
>  	 * is child->parent notification
>  	 */
>  	struct hv_monitor_page *monitor_pages[2];
> +	void *monitor_pages_original[2];
> +	phys_addr_t monitor_pages_pa[2];
>  	struct list_head chn_msg_list;
>  	spinlock_t channelmsg_lock;
>=20
> --
> 2.25.1

