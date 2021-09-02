Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000AC3FE69E
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244251AbhIBAW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 20:22:27 -0400
Received: from mail-oln040093003010.outbound.protection.outlook.com ([40.93.3.10]:12998
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243369AbhIBAWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 20:22:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpFAEAVFtRJX1cTnnpRrX3R9Pm8gSHt0iXZHDYb88Ud8MzsVIKt0rQdFMcNLZlm0LHgQhOL99Xo1yH6JTnxDpqXM3nbtPc/lyPIkSLqLHLZTwFputX5NZuSiXZ1Vm/5dUyps0EGsiBAC+Zkmu8mGkINU3TAuGnAWNdNV+FTLQ47olsWuhp5cMEPn0NF8LFs6bt5cmSfhj64fBOim9HjOaa/K1lmSXDoPoPV7pi/bhcPz4r2koxMX1HcOi7j9DPIdLIOFmJBNWkig/PAr3XKHfCvBHkdMV9SIB5U6ph8xEpLJt9wnd9LMRcCevwtC4mcG8j0RVdO71mw22MbqfUCXLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Mqf14wQtw+7JBy9v/vfQD5FN7Z7H44udWTOYeVPnD5A=;
 b=T7SuaRWd0/1riTDQu1TvUyEICtpJthhBkGQpZ9xd/R46UTMCDHn7592zKpzg8fGjXDrcUweNiNcOdwCpn255g4f5rrR+bRghzPBIutc5+TOt9j+bwpOL8QLrrtoE2nB59dRQii0R1PHyNnk+6leXMPfxnMQ2YBYjVaDdxK5zsx0LMi0FsMdgsrhthqSnZIpWKoK926sRFWFNDYuN+XB1H2EMIvkiP1x8rEF/kHJ/j160HRV/dzpdoBsVDqVI4j0/Taai6mlk+SL7f7MItqooweZ8SA9L/PgE6Go2J+hpnzd+1MUHUo4jY0pGfxSqXzMZvI0Wn/Ya7egdLwPvhWyb7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mqf14wQtw+7JBy9v/vfQD5FN7Z7H44udWTOYeVPnD5A=;
 b=WRS/XTElGOOmSfSxr8RARTjq6kei7DdGfXZSQeOIEASbO2LFrNR5iACVCa0FNfGdT8Ech8QPYtCIoRfUZyPbtGjgS24mc1NdB7q/Cz3nj6yOsvQENJfvSdJTcbz7ecGD4mXQUmgJd1rPOpCrQWUjQ0pstyJglbDhtysSDP3u2iM=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW2PR2101MB1019.namprd21.prod.outlook.com (2603:10b6:302:5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.6; Thu, 2 Sep
 2021 00:21:24 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86%8]) with mapi id 15.20.4478.014; Thu, 2 Sep 2021
 00:21:24 +0000
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
Subject: RE: [PATCH V4 07/13] hyperv/Vmbus: Add SNP support for VMbus channel
 initiate  message
Thread-Topic: [PATCH V4 07/13] hyperv/Vmbus: Add SNP support for VMbus channel
 initiate  message
Thread-Index: AQHXm2gBdvpa+X8MqESuEZ+wA8gCQ6uKsPEw
Date:   Thu, 2 Sep 2021 00:21:24 +0000
Message-ID: <MWHPR21MB1593CF062ACBE0707D0F46AFD7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210827172114.414281-8-ltykernel@gmail.com>
In-Reply-To: <20210827172114.414281-8-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=18641334-deb6-4e85-959f-298ebfb11fed;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-29T16:35:29Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24e4b7bc-b0c1-4b1d-8cec-08d96da7992c
x-ms-traffictypediagnostic: MW2PR2101MB1019:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB101914B265525342CCD17035D7CE9@MW2PR2101MB1019.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DXQW1zzjyK4YVkF1ykwSGWrws5AuKCpcL60tLoEFQfNz4OE7v47/9aWyCXZgxHs2OfyoZcU1s/7pzwcK52fMuoSWu1PLT7xQg5x+NXGlvDAteXE+bRTTu5C7JmM9cf/2hxdBi7dxz+byW25l9TH6FPHQXtzXk762upIUw5ry0c3Pr1eiLPXlq/LIDh6QE2o63LX3Xy5LT6qQb4tyEFDAb/YwY0XqAf8zRJefLyWPS9JzzHyCDX1iil4W9scABHTddjwPwm/bHHxSNCnQQqABixngwYIs9ohyjVegZPDSaPJGZR11lzkMUKWm9IJ2QBckpNcIhloJ0Uzuxf9XMUMrebWHwrLtz03RrlukRWZ5vntjeGGVTW5K12t1UWLRQF6FAnLTS4BV1QZA8MKVWOGBScX4xwOkwfWPWDXBtAQwmczPxhcnWyqNTiSwlYrh/TFYU/mYXrE3E8kjrrcnfGlUdGatu3caVm2uRDlE4gePdzoHkLtaNav+qKFK6bhDbVEBt3IhWL07HhCHC6hYM79cAnZT+2flvTVG1Gf0VFxMo3wkgFdULXl0lQ3HWqqm12h+lpyqnD0LKTlgnMm90tpc28EqQCqS7u4qQEvrAKXhQ4tAOI/Rkr5vOrYnODFp62MOFDvITTOuj0zK+Y3EzRUZ/n81hEdVy75UbEOqPIswBIX6jtaPxpAJv50Qn0XgAJtZ7yq9Z7TM8nothzzVnV6+LM8gBzUt6RFI+fEsu7PyjeM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(66556008)(66476007)(64756008)(921005)(66446008)(10290500003)(26005)(55016002)(66946007)(2906002)(7416002)(82950400001)(82960400001)(52536014)(7366002)(5660300002)(7406005)(76116006)(6506007)(316002)(508600001)(8676002)(8990500004)(15650500001)(71200400001)(122000001)(9686003)(86362001)(7696005)(38100700002)(83380400001)(38070700005)(33656002)(186003)(8936002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?80/e3gUgachnycbVd5r3uUqOemHZxHUVPdbVExd1VVw7E5+cFX8fzMliAkjq?=
 =?us-ascii?Q?NVp0Sl9gVYXLNgOrb/zhkTWrjhRVaF4CeExuSuBg+P/fILrA6B1oNqOXKgWf?=
 =?us-ascii?Q?3vhi5VovoPdDncZotT3ktFkm2RSpHFhUD5vfJ630psAWUbJsRlDna9xwSodE?=
 =?us-ascii?Q?v44mdrCLv13r36yBxZFbz5wXSaBDoyOdu0HKdn1/9/D2Y+HpKbVIlsdMYrfs?=
 =?us-ascii?Q?pFMsG25nU0W0T1GIfXfKp91MrnPhjkKLLrEJl49FO99T0y8lXidw1Eb0Slfa?=
 =?us-ascii?Q?qK615ya9jCH3C7YW89JJ2EdOi1b0lJZawwdw9tHVPzCPmc33B8/I9WghhPwn?=
 =?us-ascii?Q?1jj41MowK5iMTQ0J90rzxFWVy7nVZYrDQu+rHFYz3itwRl4wZAqziTdCz0dW?=
 =?us-ascii?Q?B5tIN4u0im/teed4Q5sLszoUKYkqGfzAN3HAe+k2AeFcslkf3pZCpEof4zog?=
 =?us-ascii?Q?Gp8Cq1ZJQkfyXTLpoh3fdYTieVKi6HuF3WHxr/N04ljtCt5bYwItS1byfczJ?=
 =?us-ascii?Q?tXoqwN1rWfYxEu5SenG0R3AIfpfOojO93WXgJUpmiPPxjQjJywulNeeAHU+B?=
 =?us-ascii?Q?ZvWpmlm5oF5HRBOjv+dkEFE0Iq1+io4hssD9Vx8TOqWapbOOTu2WaxE00h22?=
 =?us-ascii?Q?GUXsJlUi6HoOKvIgCwjbFRC4RATmrvlNLaX+8mnEGGtSuomDjAJwQOG46aNo?=
 =?us-ascii?Q?O7QNGTwIjIMKhnqfZ3SyJPX2ZuuCDd3+mudmIEJtpd1VuQgYxaAkfBZdHJgG?=
 =?us-ascii?Q?gG54nU29LkLgPVHoRroTR0EQwIhxpKtWun0RrrBBdoq8ZVObxZOeMGw1UObX?=
 =?us-ascii?Q?YTGu8kXnPSyyUUr9kKktZpU7fbjMxzNCvOcKFimKeMZ6YORnY2/UBPxsZenO?=
 =?us-ascii?Q?Gkl+AjHsucnAuZ43jVsBFH8nkBY37RZWOAj0LSlNrKUf5877ZgxEFO4l3jb9?=
 =?us-ascii?Q?nE9xfNOadBsiLxzbjj5u7zYqQ2ud6BkPBEQ6higZl2OCdJ2TL3f6CF7BZqqp?=
 =?us-ascii?Q?oLFRTqxVMmdyLMsUgCmb+aJtI3bOySO/wHX1w+wo1Iz2W/pJBOKc7kgBAjnw?=
 =?us-ascii?Q?BIxVDY2w9LkRchVClpu19mvsNJeu2kRf+3EyqXg+IiBSc0LukXRB7166NWXQ?=
 =?us-ascii?Q?yiEgcTn/sxrD4jAaiSlF1mdzt/OUAMZ8PBIkYXhVIMIMQ4irna/kHGmsfV3W?=
 =?us-ascii?Q?rngpaCeAJKB+7HPsP3UiOBC5PygUjaNt/iAL+UL9SrJ2g8UFuASFydBPjW2Z?=
 =?us-ascii?Q?PdDBZw0RxX+Y8zc7IHfy7E+Xwfv+EKL+EnDF3UMAjf0+wiBA0BULLPAkRYXU?=
 =?us-ascii?Q?6CHGz2V6NC6lwXkHoZh9vGKD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24e4b7bc-b0c1-4b1d-8cec-08d96da7992c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 00:21:24.4076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r07DIs7vHswtxB9LhpsP5x44bMSZ3HFWS6aSop8iZ2SVU44k5Q6//diDx1yPWIqR6SKynf4MyuvRP4ypBuzp1/Qi0qvz5lF9wjYTwpI2mQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1019
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Friday, August 27, 2021 10:21 =
AM
>=20

Subject line tag should be "Drivers: hv: vmbus:"

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
> with va of extra address.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v3:
> 	* Rename monitor_pages_va with monitor_pages_original
> 	* free monitor page via monitor_pages_original and
> 	  monitor_pages is used to access monitor page.
>=20
> Change since v1:
>         * Not remap monitor pages in the non-SNP isolation VM.
> ---
>  drivers/hv/connection.c   | 75 ++++++++++++++++++++++++++++++++++++---
>  drivers/hv/hyperv_vmbus.h |  1 +
>  2 files changed, 72 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
> index 6d315c1465e0..9a48d8115c87 100644
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
> @@ -148,6 +155,35 @@ int vmbus_negotiate_version(struct vmbus_channel_msg=
info *msginfo, u32 version)
>  		return -ECONNREFUSED;
>  	}
>=20
> +
> +	if (hv_is_isolation_supported()) {
> +		if (hv_isolation_type_snp()) {
> +			vmbus_connection.monitor_pages[0]
> +				=3D memremap(msg->monitor_page1, HV_HYP_PAGE_SIZE,
> +					   MEMREMAP_WB);
> +			if (!vmbus_connection.monitor_pages[0])
> +				return -ENOMEM;
> +
> +			vmbus_connection.monitor_pages[1]
> +				=3D memremap(msg->monitor_page2, HV_HYP_PAGE_SIZE,
> +					   MEMREMAP_WB);
> +			if (!vmbus_connection.monitor_pages[1]) {
> +				memunmap(vmbus_connection.monitor_pages[0]);
> +				return -ENOMEM;
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

I still find it somewhat confusing to have the handling of the
shared_gpa_boundary and memory mapping in the function for
negotiating the VMbus version.  I think the code works as written,
but it would seem cleaner and easier to understand to precompute
the physical addresses and do all the mapping and memory zero'ing
in a single place in vmbus_connect().  Then the negotiate version
function can focus on doing only the version negotiation.

> +
>  	return ret;
>  }
>=20
> @@ -159,6 +195,7 @@ int vmbus_connect(void)
>  	struct vmbus_channel_msginfo *msginfo =3D NULL;
>  	int i, ret =3D 0;
>  	__u32 version;
> +	u64 pfn[2];
>=20
>  	/* Initialize the vmbus connection */
>  	vmbus_connection.conn_state =3D CONNECTING;
> @@ -216,6 +253,21 @@ int vmbus_connect(void)
>  		goto cleanup;
>  	}
>=20
> +	vmbus_connection.monitor_pages_original[0]
> +		=3D vmbus_connection.monitor_pages[0];
> +	vmbus_connection.monitor_pages_original[1]
> +		=3D vmbus_connection.monitor_pages[1];
> +
> +	if (hv_is_isolation_supported()) {
> +		pfn[0] =3D virt_to_hvpfn(vmbus_connection.monitor_pages[0]);
> +		pfn[1] =3D virt_to_hvpfn(vmbus_connection.monitor_pages[1]);
> +		if (hv_mark_gpa_visibility(2, pfn,
> +				VMBUS_PAGE_VISIBLE_READ_WRITE)) {

In Patch 4 of this series, host visibility for the specified buffer is done
by calling set_memory_decrypted()/set_memory_encrypted().  Could
the same be done here?   The code would be more consistent overall
with better encapsulation.  hv_mark_gpa_visibility() would not need to
be exported or need an ARM64 stub.

set_memory_decrypted()/encrypted() seem to be the primary functions
that should be used for this purpose, and they have already have the
appropriate stubs for architectures that don't support memory encryption.

> +			ret =3D -EFAULT;
> +			goto cleanup;
> +		}
> +	}
> +
>  	msginfo =3D kzalloc(sizeof(*msginfo) +
>  			  sizeof(struct vmbus_channel_initiate_contact),
>  			  GFP_KERNEL);
> @@ -284,6 +336,8 @@ int vmbus_connect(void)
>=20
>  void vmbus_disconnect(void)
>  {
> +	u64 pfn[2];
> +
>  	/*
>  	 * First send the unload request to the host.
>  	 */
> @@ -303,10 +357,23 @@ void vmbus_disconnect(void)
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
> +		pfn[0] =3D virt_to_hvpfn(vmbus_connection.monitor_pages[0]);
> +		pfn[1] =3D virt_to_hvpfn(vmbus_connection.monitor_pages[1]);
> +		hv_mark_gpa_visibility(2, pfn, VMBUS_PAGE_NOT_VISIBLE);

Same comment about using set_memory_encrypted() instead.

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
> index 42f3d9d123a1..7cb11ef694da 100644
> --- a/drivers/hv/hyperv_vmbus.h
> +++ b/drivers/hv/hyperv_vmbus.h
> @@ -240,6 +240,7 @@ struct vmbus_connection {
>  	 * is child->parent notification
>  	 */
>  	struct hv_monitor_page *monitor_pages[2];
> +	void *monitor_pages_original[2];
>  	struct list_head chn_msg_list;
>  	spinlock_t channelmsg_lock;
>=20
> --
> 2.25.1

