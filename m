Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DE83EDC68
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 19:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhHPR3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 13:29:16 -0400
Received: from mail-mw2nam10on2135.outbound.protection.outlook.com ([40.107.94.135]:11936
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230468AbhHPR3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 13:29:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkDMkuYinqTWXuSGdKjWplTTLVEYvD0n0AeitWm68HT1vey6j7JHipo85rlV/nMKmxxxeqM89noq4tBX4DUdFyekQfcpoDxpfxUaoeaXeWw6ZB1pwtNGtLbycDiD6IGyo2Z7F04Do67d6+U9bTGST+Q6Sx86ZwuzHsg2ZQmpRxRf6L7fktyrIRjAV72WG9DC3B/R7NvQOLPD/+Bvdt2AS3DRJb4/9zFNThUswrRhDaVpqe+u4glsW6TyZlbhbJQ5mplEAj+0by7AElewzldRTWUhNWiViKWLoO/WJ4pnDthRAu7T3UZPLPICKgFCEwwnYG9DGivY0gPZxhspBZxCsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hHYh+59p26U2UEzCDzT7jwLliJZHyK2g/ne2bVbIPAI=;
 b=VK3flP4Xsefbxbx6oEQvBWLJPos4oPreI9oPA4YhfmI0/NcV19rDwoa1HYHMQfdp3rNLTNwKOUqIwJXiWym/Se+M51DwyeGbXxDcD/LbC73aJrRUoN0v/3ixnD4ApOaHn5u+REjlwSDZoj4j2+hTbpaDtt5OqamqshJ0ySZWIxNo84IoqtX4dWivnxtjfZkxUM/KUq+R+YaoxHTKM9P7bZZaZ9maRTRD3Pfua7YnfLbl5VeeO/+Iqu7wUIbLxGFJHA+mtvtZy4h+KSVVbJjD9QLpO7bLPwtvaG3S5C+d++7Hsfv65f58uFhJHJLKhit//og6igVzvghTPKfK6vEjkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hHYh+59p26U2UEzCDzT7jwLliJZHyK2g/ne2bVbIPAI=;
 b=Y2wLsNBjtIbhX2b89vDjzy5ketAUC/2M5O/sWgybGg1fgH3/Xk9ADGV2VIBkGQb8Ua831dvUEwT1E+zdc9EfR4zNnveKlGnWcnUpMte9a0I8W+3ep0NUFBjlxZb5jcfRL09PhDj1Aub5LifuwlwV2R51MW6yvpU7jhmJT7Tmh+o=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW2PR2101MB1820.namprd21.prod.outlook.com (2603:10b6:302:b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.7; Mon, 16 Aug
 2021 17:28:31 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55%2]) with mapi id 15.20.4436.012; Mon, 16 Aug 2021
 17:28:31 +0000
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
Subject: RE: [PATCH V3 08/13] HV/Vmbus: Initialize VMbus ring buffer for
 Isolation VM
Thread-Topic: [PATCH V3 08/13] HV/Vmbus: Initialize VMbus ring buffer for
 Isolation VM
Thread-Index: AQHXjUfrruzh6q5VrEqe79CjktZwpKt2SJQQ
Date:   Mon, 16 Aug 2021 17:28:30 +0000
Message-ID: <MWHPR21MB1593FFD7F3402753751F433CD7FD9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-9-ltykernel@gmail.com>
In-Reply-To: <20210809175620.720923-9-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=151d8e1b-315b-4252-a2ea-b7f2a7065a33;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-16T15:15:38Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa5be945-23b3-4ed1-df7c-08d960db447d
x-ms-traffictypediagnostic: MW2PR2101MB1820:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB1820F281C0DAC2708EC4E328D7FD9@MW2PR2101MB1820.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cy1VRzpxjngCTtD+qEfFJY00HjkGcEaStnVTRNFU6y1O13ZQLFZKFSxdfHf/+QqYgpCedc0SZ1CWAGNTsKy1TBF6x6+lJSLB9mtGeH5K1GtsfLsjB160btEG3867oJNlMTPviOaei9km64uNhBe2HnMiuB33yhkvbgPFODMbJ0BP7Br8DGKtyPgXh1nxwMDdofSDR6YOpRWoNHecKi8DCkfhIwbVJmimFuEoBLw0KCsJyBPtoKYRMSRCKFDxmFL6zwLSfOeIaczASCa1aMJ1sgP3w76hFgc1iV3kmscUEUs8C6owAOzskGO7RfmjMmqjAR3/LkqoHpnc8Z5vdOX/YMoCZB1yTYyWyhM61EMoCuRv6Do/lMcTbYs1ADp22nQ2tG9Pmo5O5JJCRft5XeZjCrulyjqwV5+36dKTZ1z9IVL09SYmGHn8ezW8uqG9UwTETZciM0B4FnNNNiHpgXsmRDFC75EGrHsXIJRM0ZaLP38C7EWsKDSObAeKsfzCjK6IzkXnvNpJCWzGOPGtyh8OT5PWQsm6q3stGP7uqCdI4glnxRvFBZH3nfZ2254yVj1ksQOWOboqhMx5dhsYDfZBE4V6hsYSfyU3LA9sUycKQ6gxO6iWZtURlE4P5//DsX1bQvkYylE2ijry3PKZ0qFwXCHyknwv8Hn3mOSluXPLy1KSplmZWTbBd9DGdxTs+9PC7mUSbBlqyMR7njvxCt2ft/3J+ERcOOEWsYZ+qbXevyQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(52536014)(7696005)(55016002)(5660300002)(71200400001)(122000001)(54906003)(8990500004)(38100700002)(110136005)(316002)(8936002)(921005)(8676002)(86362001)(83380400001)(82950400001)(82960400001)(508600001)(10290500003)(7406005)(2906002)(9686003)(7416002)(38070700005)(66946007)(66556008)(66476007)(33656002)(64756008)(26005)(66446008)(4326008)(186003)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ben7dDwl6TZm/A+N/mESE+SLutP1QPFf2Evz2K8zpwOXL+3Fw4+ul9VQ4Byi?=
 =?us-ascii?Q?7Gf+0dYjVak0urDn4bWjGwnmm//jxOh5Cuvt9B3BBX/4hF/P/pq8m6b9Fuvo?=
 =?us-ascii?Q?Y+hXelCN97QDw9MBF4eJkiTZ6BHoox3CUGWhZBoKicY3QRLEU99MN7mb6RDF?=
 =?us-ascii?Q?ItRMBNO/Ih+8+Wq/HbdwnP4chSQaD+v74qs0UnSfgnJX/noEqATo2GZVWzEz?=
 =?us-ascii?Q?zq+8Ty733WGSxfI/w0v8yClegLTL562gLcezYYNwAspfZedQo3i/GZpim/OD?=
 =?us-ascii?Q?kjZ1/nnc12JsPyueFETezNo2QFSjqrCzhhdond423+RvT1fGuVBMo+uKA2a5?=
 =?us-ascii?Q?eVIT/x3YTT9szUYUox6KHY24Cyjp0HM9G62kPuHLcZNjdlbOSvGx6SrwOgGY?=
 =?us-ascii?Q?iFDl9L3uo2IL+OjfmPZjsIeqsBqEiF9IGSqrelaEIG9XQ+8ZRhp/VndPGDC3?=
 =?us-ascii?Q?XBB6kDyUkmzNI6KTqCRsjcnNzz6dzPmBQ3kr+OwOSXjEMfcHWIDNPYllANVY?=
 =?us-ascii?Q?h+h1fk028vIxt+73vPzCngrznAjrnYEJTFKBtNMSdfZS57viSgBMf0hSuysY?=
 =?us-ascii?Q?am2Gl8qESbs9/SHNNwYpIT9yFkApIhsNvdSVEJcNHxMo5DdGdy1+UkB8FaAC?=
 =?us-ascii?Q?R4Bp924wI+MLpwVVfCxylPPIiUz7Qa6WSe8V2eKb9wn6S4i3SAFFfgGkqKwg?=
 =?us-ascii?Q?2OpesXz6Fgo/qsZbxz+VEhLXHQQPFPIuBnOsOT31IVw0BxM76J4gIFOGSDPn?=
 =?us-ascii?Q?KxZFlzvZai8C9rjiLMR4t5tWEmS2fbrVqyUMfvXd+Mah4jieWwnOwUv0sWmW?=
 =?us-ascii?Q?rdMlLRz8lPuoyv6o2FdOt6RNZ5ln2gR3QRdOBiNfaA60xBT/otCkoUO8m5IN?=
 =?us-ascii?Q?0EODYclRNbkRDBt19m32vrgirCZd/5sXQ8SYDUbc5vYY5pSDjC0+A+9h00uE?=
 =?us-ascii?Q?/0x8r6vTDOTaFP4HmeMAkGfHETbt7TwmBEo1S55Pmg9OsWUWFhlXCTUrQE3h?=
 =?us-ascii?Q?VT0V5NcDWrY1fuFfKLIbfFkTOhMBpT11mpdQ/1WsA7xSuyS27AhAUdUWTb/j?=
 =?us-ascii?Q?qCfbkGfmfsZLkiDbvZ0obXWsWPsETqKLNn9r1MNpI3JVrZx2SrzU9jLZmrap?=
 =?us-ascii?Q?4DrRcFfT86vru5OOiFY8brUK+nsNEOclgh6tQwYmcbdaPaH1536wsFI5Gzje?=
 =?us-ascii?Q?nnV4sT41eduDc4Xo5GDjg2+4D9Ll4pngjhtNbmakUwmRpfWkMx3zddtYMhNc?=
 =?us-ascii?Q?/rTCWr6WOk2VpjF1suaymdG3sBEGdsuHVYdJe1en7H7tndS8MJ91SpOE29kf?=
 =?us-ascii?Q?GLDSGqMPurTGO/wsxu9yMAws?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa5be945-23b3-4ed1-df7c-08d960db447d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 17:28:31.0231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tT+BSF4rsIeFfkzSAY0V79Lyuyb8X0fbhGGUrf8L36tusFWN9emLBabBYYeM164icPiU94iltqVfQ5nefEVEmFVU5KOQeQQLV9kdItNYO6c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1820
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Monday, August 9, 2021 10:56 A=
M
>=20
> VMbus ring buffer are shared with host and it's need to

s/it's need/it needs/

> be accessed via extra address space of Isolation VM with
> SNP support. This patch is to map the ring buffer
> address in extra address space via ioremap(). HV host

It's actually using vmap_pfn(), not ioremap().

> visibility hvcall smears data in the ring buffer and
> so reset the ring buffer memory to zero after calling
> visibility hvcall.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  drivers/hv/Kconfig        |  1 +
>  drivers/hv/channel.c      | 10 +++++
>  drivers/hv/hyperv_vmbus.h |  2 +
>  drivers/hv/ring_buffer.c  | 84 ++++++++++++++++++++++++++++++---------
>  4 files changed, 79 insertions(+), 18 deletions(-)
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
> index 4c4717c26240..60ef881a700c 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -712,6 +712,16 @@ static int __vmbus_open(struct vmbus_channel *newcha=
nnel,
>  	if (err)
>  		goto error_clean_ring;
>=20
> +	err =3D hv_ringbuffer_post_init(&newchannel->outbound,
> +				      page, send_pages);
> +	if (err)
> +		goto error_free_gpadl;
> +
> +	err =3D hv_ringbuffer_post_init(&newchannel->inbound,
> +				      &page[send_pages], recv_pages);
> +	if (err)
> +		goto error_free_gpadl;
> +
>  	/* Create and init the channel open message */
>  	open_info =3D kzalloc(sizeof(*open_info) +
>  			   sizeof(struct vmbus_channel_open_channel),
> diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
> index 40bc0eff6665..15cd23a561f3 100644
> --- a/drivers/hv/hyperv_vmbus.h
> +++ b/drivers/hv/hyperv_vmbus.h
> @@ -172,6 +172,8 @@ extern int hv_synic_cleanup(unsigned int cpu);
>  /* Interface */
>=20
>  void hv_ringbuffer_pre_init(struct vmbus_channel *channel);
> +int hv_ringbuffer_post_init(struct hv_ring_buffer_info *ring_info,
> +		struct page *pages, u32 page_cnt);
>=20
>  int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
>  		       struct page *pages, u32 pagecnt, u32 max_pkt_size);
> diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
> index 2aee356840a2..d4f93fca1108 100644
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
> @@ -179,43 +181,89 @@ void hv_ringbuffer_pre_init(struct vmbus_channel *c=
hannel)
>  	mutex_init(&channel->outbound.ring_buffer_mutex);
>  }
>=20
> -/* Initialize the ring buffer. */
> -int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
> -		       struct page *pages, u32 page_cnt, u32 max_pkt_size)
> +int hv_ringbuffer_post_init(struct hv_ring_buffer_info *ring_info,
> +		       struct page *pages, u32 page_cnt)
>  {
> +	u64 physic_addr =3D page_to_pfn(pages) << PAGE_SHIFT;
> +	unsigned long *pfns_wraparound;
> +	void *vaddr;
>  	int i;
> -	struct page **pages_wraparound;
>=20
> -	BUILD_BUG_ON((sizeof(struct hv_ring_buffer) !=3D PAGE_SIZE));
> +	if (!hv_isolation_type_snp())
> +		return 0;
> +
> +	physic_addr +=3D ms_hyperv.shared_gpa_boundary;
>=20
>  	/*
>  	 * First page holds struct hv_ring_buffer, do wraparound mapping for
>  	 * the rest.
>  	 */
> -	pages_wraparound =3D kcalloc(page_cnt * 2 - 1, sizeof(struct page *),
> +	pfns_wraparound =3D kcalloc(page_cnt * 2 - 1, sizeof(unsigned long),
>  				   GFP_KERNEL);
> -	if (!pages_wraparound)
> +	if (!pfns_wraparound)
>  		return -ENOMEM;
>=20
> -	pages_wraparound[0] =3D pages;
> +	pfns_wraparound[0] =3D physic_addr >> PAGE_SHIFT;
>  	for (i =3D 0; i < 2 * (page_cnt - 1); i++)
> -		pages_wraparound[i + 1] =3D &pages[i % (page_cnt - 1) + 1];
> -
> -	ring_info->ring_buffer =3D (struct hv_ring_buffer *)
> -		vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP, PAGE_KERNEL);
> -
> -	kfree(pages_wraparound);
> +		pfns_wraparound[i + 1] =3D (physic_addr >> PAGE_SHIFT) +
> +			i % (page_cnt - 1) + 1;
>=20
> -
> -	if (!ring_info->ring_buffer)
> +	vaddr =3D vmap_pfn(pfns_wraparound, page_cnt * 2 - 1, PAGE_KERNEL_IO);
> +	kfree(pfns_wraparound);
> +	if (!vaddr)
>  		return -ENOMEM;
>=20
> -	ring_info->ring_buffer->read_index =3D
> -		ring_info->ring_buffer->write_index =3D 0;
> +	/* Clean memory after setting host visibility. */
> +	memset((void *)vaddr, 0x00, page_cnt * PAGE_SIZE);
> +
> +	ring_info->ring_buffer =3D (struct hv_ring_buffer *)vaddr;
> +	ring_info->ring_buffer->read_index =3D 0;
> +	ring_info->ring_buffer->write_index =3D 0;
>=20
>  	/* Set the feature bit for enabling flow control. */
>  	ring_info->ring_buffer->feature_bits.value =3D 1;
>=20
> +	return 0;
> +}
> +
> +/* Initialize the ring buffer. */
> +int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
> +		       struct page *pages, u32 page_cnt, u32 max_pkt_size)
> +{
> +	int i;
> +	struct page **pages_wraparound;
> +
> +	BUILD_BUG_ON((sizeof(struct hv_ring_buffer) !=3D PAGE_SIZE));
> +
> +	if (!hv_isolation_type_snp()) {
> +		/*
> +		 * First page holds struct hv_ring_buffer, do wraparound mapping for
> +		 * the rest.
> +		 */
> +		pages_wraparound =3D kcalloc(page_cnt * 2 - 1, sizeof(struct page *),
> +					   GFP_KERNEL);
> +		if (!pages_wraparound)
> +			return -ENOMEM;
> +
> +		pages_wraparound[0] =3D pages;
> +		for (i =3D 0; i < 2 * (page_cnt - 1); i++)
> +			pages_wraparound[i + 1] =3D &pages[i % (page_cnt - 1) + 1];
> +
> +		ring_info->ring_buffer =3D (struct hv_ring_buffer *)
> +			vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP, PAGE_KERNEL);
> +
> +		kfree(pages_wraparound);
> +
> +		if (!ring_info->ring_buffer)
> +			return -ENOMEM;
> +
> +		ring_info->ring_buffer->read_index =3D
> +			ring_info->ring_buffer->write_index =3D 0;
> +
> +		/* Set the feature bit for enabling flow control. */
> +		ring_info->ring_buffer->feature_bits.value =3D 1;
> +	}
> +
>  	ring_info->ring_size =3D page_cnt << PAGE_SHIFT;
>  	ring_info->ring_size_div10_reciprocal =3D
>  		reciprocal_value(ring_info->ring_size / 10);
> --
> 2.25.1

This patch does the following:

1) The existing ring buffer wrap-around mapping functionality is still
executed in hv_ringbuffer_init() when not doing SNP isolation.
This mapping is based on an array of struct page's that describe the
contiguous physical memory.

2) New ring buffer wrap-around mapping functionality is added in
hv_ringbuffer_post_init() for the SNP isolation case.  The case is
handled in hv_ringbuffer_post_init() because it must be done after
the GPADL is established, since that's where the host visibility
is set.  What's interesting is that this case is exactly the same
as #1 above, except that the mapping is based on physical
memory addresses instead of struct page's.  We have to use physical
addresses because of applying the GPA boundary, and there are no
struct page's for those physical addresses.

Unfortunately, this duplicates a lot of logic in #1 and #2, except
for the struct page vs. physical address difference.

Proposal:  Couldn't we always do #2, even for the normal case
where SNP isolation is not being used?   The difference would
only be in whether the GPA boundary is added.  And it looks like
the normal case could be done after the GPADL is established,
as setting up the GPADL doesn't have any dependencies on
having the ring buffer mapped.  This approach would remove
a lot of duplication.  Just move the calls to hv_ringbuffer_init()
to after the GPADL is established, and do all the work there for
both cases.

Michael
