Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F19B40C87E
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238111AbhIOPnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:43:23 -0400
Received: from mail-oln040093003014.outbound.protection.outlook.com ([40.93.3.14]:41844
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234294AbhIOPnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 11:43:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oj3Kbpw5bPy0Oq0iGwhWJKBOhtiUv2eSJ6ogKlkbyKjQWA4zbJqdI51ZU6QAEa0V8imOLv49A+PScsIE5ys5Xc4N0YVJ4rSIXnP3Zq7OxS9Oar1rUJ10ZG67NU1rl0RYGz0xO+ia2vhz5H5kdCHa2Pe1nJrxo1T+UIBE7ouU4j0nriO0hnp0RHpXkSrJHok7FqZAV79rOO+JC1kVSIH7BWo92DnqpxtZtwVgaWsIIsc+hG6Oxar42MFHgY89MugZcrd72oNGRzK4biAjm8b4WenI1A8zOdJznJGqdV9PJVh6TI5058WlPIvlePSwvBr81s4BY66T6OpidQnUWetGrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=F/918hg1YuX4z9H7s+A+X/uldHZBwBC2qP5cL5HAq7U=;
 b=c6anx5doZ7xjEd4dZAJj7N5uKX7KbvLbHFvoP37kiZOPb3WrgHAFWdDeUEuDhxd5xtTvOT8zXKmDu7+AnKe2QT44wL290hnI8t+M4ipLJOjCAC14vgByXxM0HI6478h9HuI3+3jvDsH3cCC7YlgORhtYb3Z5fWsQ9tcUVA3+8H8EIfd3CYMGmvZtfchySBHm3Nu4vZzEvxfaZALAVyM1mrza2XouJ3RYxD6+NNuttrCZGX2Kr259dnC0j3V1n0XCQeXOjkG+aQ/s8GXSLKc+JoL6Jsort7GPe1XmvsL/YfyxpbT3z2tbdQizW5G+PBbrLVbQtl3UUnu8fldHFWbixQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/918hg1YuX4z9H7s+A+X/uldHZBwBC2qP5cL5HAq7U=;
 b=H9j+UEgzzhMp7xaBJ3R+wx3E9ALA6nb/IH4dbAZcdHbT0Upfho15di3+0J4xQAKvXqNM8TCdPZAUZEZZa7c9r3BahRQVfSVdGJIa4kA+IiQVwpQcIBhgyFOsy8ZKYZmRDAXWlNsZVvq9JC4VAd9tezIbueqPpbYRC+6lHeNxrVE=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0783.namprd21.prod.outlook.com (2603:10b6:300:77::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.1; Wed, 15 Sep
 2021 15:41:55 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9cb:4254:eba4:a4c3]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9cb:4254:eba4:a4c3%7]) with mapi id 15.20.4544.005; Wed, 15 Sep 2021
 15:41:55 +0000
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
Subject: RE: [PATCH V5 07/12] Drivers: hv: vmbus: Add SNP support for VMbus
 channel initiate  message
Thread-Topic: [PATCH V5 07/12] Drivers: hv: vmbus: Add SNP support for VMbus
 channel initiate  message
Thread-Index: AQHXqW4CCd5VufaU3kyHpkfVIyVvMaulLo1w
Date:   Wed, 15 Sep 2021 15:41:55 +0000
Message-ID: <MWHPR21MB1593D9CB27D41B128BF21DC9D7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210914133916.1440931-1-ltykernel@gmail.com>
 <20210914133916.1440931-8-ltykernel@gmail.com>
In-Reply-To: <20210914133916.1440931-8-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=08510df9-4063-4ea9-b787-b1133475bb7b;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-15T14:48:11Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a283cbd-86ce-40f3-64ac-08d9785f58e9
x-ms-traffictypediagnostic: MWHPR21MB0783:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB0783EE0DFCF6600D36BCD94BD7DB9@MWHPR21MB0783.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EecLWhEpd9Yp8oSk4zhS0TGn/JGW3LxPvSYij5heKFZzKQ/lIkNfgacvuggazXz5vfNFe9it7HNRD+lnlWgQRvqfuOQg7nRwCHTKUH5954CoQfphLsYZoQI3AzYAx82hA1I3Dvfe5VSXn82DHAloXSW7aIvCmxTEmiTOf13hYVPsUN4WJQuLpahttNDcRL+bABTEuUQB2SFKNzyxfT8Y47+RMXX/QiAzsF/V245sZGYK0ibzbZH5/eajdSIfmud1SqmfJhNHrk7yJUEAt0CYTb/pTpo8PS1gafjHIDiAgIXb6Ml75LW2Jhf1Q6lRo+1XNiT4PNvGEdfnxesZMuylRAM72rvnuJJUisjzdHW+gjsPDRnrekz5U5JJzsk7bRCOXQMmQfryrd3OVqJZdCH4cFvdVtBO98d8spah8vyybSUUQMZp8A7mH2xLeDO0a69zrDywq+zCDOW1IsuPNYJfePHJQLVI/cqeHOPNp8mtSfibt3hUJfn7zuzUmXVaXap+ytTCvh+RPy2ESe0+VYt3eFezPNVJuQCINGOdx95riPS3moIUykSd/u+Pz4bkZ/3Wb4ZeUIJvB1gjzc+GHD3QpgMntu/js9n/Vl/xPrL92JoBUvYm2SA4+KK68zOFOvp0zQaJtkz+xvQRHfSpu0pzu1pVPghdP/jG0//KHvCwdtT0yJjSyrHS/EmISSv+c2S5e3jrJVfNjIE8QT/LSVFzx5mSCCsog/Q50TFTcOZUW/g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(33656002)(7416002)(7406005)(66946007)(26005)(508600001)(9686003)(8936002)(2906002)(8676002)(82960400001)(82950400001)(5660300002)(86362001)(921005)(186003)(122000001)(38070700005)(66556008)(10290500003)(66476007)(66446008)(64756008)(76116006)(38100700002)(316002)(54906003)(55016002)(15650500001)(83380400001)(6506007)(110136005)(71200400001)(52536014)(7696005)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6ds3IGWen8r4I7FNzQCxiRe74jaiPJgyaH9dqCDRzYpdyyg96DjGIK+p5ML/?=
 =?us-ascii?Q?foo9Qn5cUqlkqciKeim3dHhpHsmkgDFE1msLck84xh5de/9/1NDCcamfelS9?=
 =?us-ascii?Q?AQFaNXwd3piYkHB3hnmwCfThZHbqSJIQ4mvRPdudiuYP4WRLMqYnJILjckgD?=
 =?us-ascii?Q?dT+SHtC3KPORp/vejl/g4KSM49Kqszljdpb0vlKg8pUzp0xHhype1ff8nnX4?=
 =?us-ascii?Q?zyfOQDjRwjrMBTiSLuNFgOCjppwF+a+dg2IFX4xWTus/byV25MWaqjSNm32l?=
 =?us-ascii?Q?vFXM2YRtz2KJhxX+acrvK4GVOMmjUbdN+n/TqhHl0C/VXsU3J5AkgQ5g66KQ?=
 =?us-ascii?Q?SRhyOMvUC7OOBvZGqza/eY6/UMyNeY99HV1i+BPn24rCjHpTNdxxQOd8tGDV?=
 =?us-ascii?Q?M34XUPZFIQ/HhYCZksMQqNIcny5oa3WeT99238V5QAYUY+9tNLgvBz61sZ5t?=
 =?us-ascii?Q?ydDmmAgOMNVk1LV7EPeyuNxAv6EC98DlywWiyW2fcZm6Dp9pAqSJmqA+D4FN?=
 =?us-ascii?Q?rq1+SQjHMMJ9JuetPbHpEMfCWBdnXNdkCn7q+kQWU/kqJs6vStAifo8c4kma?=
 =?us-ascii?Q?eR1kdAy0HNjHkSRWWTJHKeqZlw7MUPehtjV22fS3KveGucHYekCLGg0bWskG?=
 =?us-ascii?Q?JILMU1do4yt4e1sTSbmu4kntlazON6euj4Dr0bBrvhi2AH+fQs9jTF2VyxfK?=
 =?us-ascii?Q?nlwhiOfMGn95DWZWPAC0XpytuYc0MP2UPCLViBCMQ0i2W/Vyxnkx/XlFa1RM?=
 =?us-ascii?Q?SIN8Arw8jUDXFqeWKiN3A07y7H3LBUKZ8ggL6DU7/N56FXHyTYRp13LaElf/?=
 =?us-ascii?Q?zdMsR+E1ki0X84IsansA4qUK6y/5o8QuU4FZzf4SmsM2MzvRwn/VoVlmUScJ?=
 =?us-ascii?Q?yAKtg2LrsY9pvM6SKviBRpjXfn+oqq1VS/Q0XDHyF0jtFKsF2KVO0shA2WpL?=
 =?us-ascii?Q?ogzJAj4ODlLbE8ATnbAdo/BfhRq6sI4799PwdWXZ9Trd7wYxC76+HWFeyKyO?=
 =?us-ascii?Q?JK5eiNf71nkCKI8kBDFNG6PcIteDbsri+vtsmnwseCH98TxEeap9CzwN2DVu?=
 =?us-ascii?Q?nxc9fxqP5V42qKNh16WYENbVN4pOg3W6kc/OD8TMzzReZNhjEPFRcVYsqzN2?=
 =?us-ascii?Q?1DB4vklqVxHyJHytFCAOSfArsTmV2QPVU9pKPg1tfDcLSJmEgbD+eO4KmOZr?=
 =?us-ascii?Q?26FTlHcEpcfc9wQMlBPLmXBkS04qxxi8JqlTFhu/9GhSbr/73uyMk+0LNpvf?=
 =?us-ascii?Q?/q2FJV6rDRzcOZQdl2cffek7+3v2wniinf+ksnf6GDXXOCENgBY7Qkof7kmr?=
 =?us-ascii?Q?pgtme/KnhQ5yZnz3PmRzLSnW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a283cbd-86ce-40f3-64ac-08d9785f58e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 15:41:55.5834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sutlvI5gLKCFm8+kq4Fx9lAI3owHHagLGcVPeuWtzcY6JebzZmx+KV4pMzuRNIq2weYyEKIwS9D4wAVfDwZsBMR31J/PXq+Q1hJUfNL9bP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0783
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Tuesday, September 14, 2021 6:=
39 AM
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
> index 8820ae68f20f..edd8f7dd169f 100644
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
> +		vmbus_connection.monitor_pages_pa[0] +=3D
> +			ms_hyperv.shared_gpa_boundary;
> +		vmbus_connection.monitor_pages_pa[1] +=3D
> +			ms_hyperv.shared_gpa_boundary;
> +
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

This all looks good.  To me, this is a lot clearer to have all the mapping
and encryption/decryption handled in one place.

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
> index 42f3d9d123a1..560cba916d1d 100644
> --- a/drivers/hv/hyperv_vmbus.h
> +++ b/drivers/hv/hyperv_vmbus.h
> @@ -240,6 +240,8 @@ struct vmbus_connection {
>  	 * is child->parent notification
>  	 */
>  	struct hv_monitor_page *monitor_pages[2];
> +	void *monitor_pages_original[2];
> +	unsigned long monitor_pages_pa[2];

The type of this field really should be phys_addr_t.  In addition to
just making semantic sense, then it will match the return type from
virt_to_phys() and the input arg to memremap() since resource_size_t
is typedef'ed as phys_addr_t.

>  	struct list_head chn_msg_list;
>  	spinlock_t channelmsg_lock;
>=20
> --
> 2.25.1

