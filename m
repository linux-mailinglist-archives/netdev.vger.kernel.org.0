Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DE040C9F0
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 18:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhIOQXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 12:23:37 -0400
Received: from mail-oln040093003010.outbound.protection.outlook.com ([40.93.3.10]:49913
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229467AbhIOQXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 12:23:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3LX07e8BZhXgp9xN84lTvA+yllLu+JyJkg4ZXyI0VS479caRGhQS/YPj7QBboAUXtM3F1Uq0C3bZ9PEhVMbANqxiuZEdYsbzcyYzbylZ4A3OgBwwxgFyab6EAlEsOIuwsHltlnQIa5oy6SVICV/WKMqBc3wEtJDrjMgXJ6+erSYs+uzDko3ulobfNgbC1knSNrn6qaDYtwihOiKqGxwjjcf7ZZWrZsTPw3Vg2JDMgKpkGl0bDcFb0+Q/cEc9mxJ/0KWB99kCStTtyq8NOHB/qOH6HtYPM3AIgs71Jh85/n5ZZAidEn69+V/9jjKb8Y7rhCMLJkrUzm0R5mrwlfPNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Ja/LOgfHueyT+LFgGDjiCoTKEGIMWDcRcL8Q7H+Bn24=;
 b=kY5MNuQ/KtzeNWRkv82J8UlHPyyqr8AklH0MM+0kH/tr8TtY+hRbhmB5ZYnVQBHkdgpBKWsZdEI13PjY0oXXp81v/i1znIrRyOs+2mOKkj8fzGLFe3nKNDOe6xn4YGC4db6vVaMNmU2oLS5BN8qckGS1EDw1/O9snJ4jeK3xBPZI7vbVaYMnqQxMW2ENyc1qDH3l0DwsquS30/sX0kaZrxwL83kQWWUaTmAJwkc6wA9kFLvN5/6KoYvhgWdw0gga0aaoCFg6ECK68dJSVtWebwQzoQasvl4fEyA8J8DESvETOXFpyEYR05dOyAHx+TEQo+tvy+os6FRRgvo+7KLVzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ja/LOgfHueyT+LFgGDjiCoTKEGIMWDcRcL8Q7H+Bn24=;
 b=dMdSilmzqLRTmni51o47JOosuhnttehp+m7PVa7uz6V4v5pZHU06TL9hIHlYqylmfnmuFjLdydqaG/6ZlAV/V2oxTkeRca1srWW10MM9sR/Dvo6SSU53KxTItpL5hKMGW4XDX8ML4+40D5VZc1om8/UFrDwfBrSNOFbsKK9fTAU=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW2PR2101MB0908.namprd21.prod.outlook.com (2603:10b6:302:10::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.1; Wed, 15 Sep
 2021 16:21:58 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9cb:4254:eba4:a4c3]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9cb:4254:eba4:a4c3%7]) with mapi id 15.20.4544.005; Wed, 15 Sep 2021
 16:21:58 +0000
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
Subject: RE: [PATCH V5 12/12] net: netvsc: Add Isolation VM support for netvsc
 driver
Thread-Topic: [PATCH V5 12/12] net: netvsc: Add Isolation VM support for
 netvsc driver
Thread-Index: AQHXqW4FepA+T2dkA0WfAWppSl9u0auj6xtA
Date:   Wed, 15 Sep 2021 16:21:58 +0000
Message-ID: <MWHPR21MB15939A5D74CA1DF25EE816ADD7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210914133916.1440931-1-ltykernel@gmail.com>
 <20210914133916.1440931-13-ltykernel@gmail.com>
In-Reply-To: <20210914133916.1440931-13-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=131cd4f8-e33d-45d8-94eb-3fa8bffaa59b;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-14T19:30:32Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c69d908-c1e5-4c24-9cd4-08d97864f11f
x-ms-traffictypediagnostic: MW2PR2101MB0908:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB09085FD9B123206B8A3BDDA8D7DB9@MW2PR2101MB0908.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uXxrmFQxEtGaDhzZ+dtP5PfrHN7w8XpRhnoh7Eez1AKpuQoKzsDutOeSrEcn9IBXkWrP082Kt0khZ+TByndJ/FD8hDHsl+SGYRpZlT0I6mDKS+9M/lar2VJAm3wT4O6vIqMAyoGBYkFQt/Xwn7vXuVTeYdZJrWgS5Foa+Gz5AJz60Hh9r7PAv8Y4UZxmzvRwYZMLcQeW5GPMSQupA+nfenmJBD1kRwvdSi/sWYKLGtZ+88OAknVfLmV2F/gNdebxWDlLfFJjtZTyNMi5irENRXs/hyfVifw9yyxcnTtfysLZXQymqgAVtY2ULRy8BzNNPpZCSufNTawUjWy/UQLgiiwADv47Abrg52CXpU7hrbL/9B5RV7WYNsD6OPBWPtldBfzK1uGEdWvCyG55WcVmm8rnNlSLmyATtVyw0OEgTd15vrLbqmyRX3+WBrwWlCoSRZSjEojLEuDG2hXRaf2d4egDI/2P8fZ3N0h+upaTaxgJ7X6O+LAVDfvsT1q/ORNsuAeDDY2lpfXTbKOUsmWnOGw+Sa10IDc4t0hdxVBYy0Ui8ZY2LPyzULK9I6iDUcXoIqEBnzwtfr5LhvAFKPC0FwFumqpLCEAupItwWNxjnK22kR5nplZyQ0sgaebKyvDi1let/YFeMeW2jWsfL10iLHoZlZh9gM/rVqDLFNl3GgSBhsQEkynGfT9KwK+QSoipYrtCB+SzhEIKpNQVnmDtrIsPRnV0/KGI+rIU2QZCHS4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(83380400001)(66946007)(6506007)(55016002)(7406005)(66556008)(26005)(82950400001)(8936002)(64756008)(110136005)(7416002)(86362001)(30864003)(8990500004)(2906002)(66446008)(71200400001)(54906003)(4326008)(5660300002)(122000001)(76116006)(66476007)(9686003)(38100700002)(52536014)(316002)(508600001)(33656002)(921005)(7696005)(186003)(10290500003)(8676002)(82960400001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OY4wX8wRURLgunokENF2AQdGJDcGHf+y0zTurd21ejJnyIPzXiNCdOTV/3d4?=
 =?us-ascii?Q?wOR7WRhiOirGz9gE5xoOYNq9OD68xGmjkB71c09DlXef+gTe7kcwc3qQJ3NP?=
 =?us-ascii?Q?fAvxc+pLijFmkx1ioZrMHgtSq51GzUNW7qu1UHHkloC6B49rvj3CJqLU99BK?=
 =?us-ascii?Q?XD1NHKLcAh3Snu5nbCPPn1zJD/xknB+R53CCPXTcItYViNYEIQiOpGj7vsLZ?=
 =?us-ascii?Q?fELS+6cY4ZMKCKd+WR5UyRmLeWrrtmMFeNVj+f0R+HAMx/HTy4JL8Wsora5U?=
 =?us-ascii?Q?1Gx1HgmS572oCUi4GUIC1F1iLfU/zyfhEmZvHxlr3+G2Wt73UgxFNOpU8aDT?=
 =?us-ascii?Q?6K7fTiH+5SdLXC+eqqKu1KDS4NOoFA9QXk5TYP60zdAquFRE4gE9BFWSt6ac?=
 =?us-ascii?Q?w0SVr2VJX6VA+3vlhVx1Rj/89zcnloYBiZQP0hNPcwddWgMP6aaw4d5hJbrg?=
 =?us-ascii?Q?vRxK3nI4a10fWJnZRMQ2dtW4Cjs40DAMsUVHwxU9cGaAKGKXVVKL3d+FivBC?=
 =?us-ascii?Q?6MsO6ILN2bAjOGqFpFgiPaFJSrtQbJFQb81pNGG52WJfFKKgZGitQG671sdf?=
 =?us-ascii?Q?9G/cD7Eg4wUJDWVeeKVlZD8JHFHantiSQIttctmUnEABeL/E39xLJ1hb1U2Y?=
 =?us-ascii?Q?LfTNBCB0Uj+5mq6P5uN47v+c2IfM9Un3VyhD72upbOQzYsaIKc8xXxUN9dBI?=
 =?us-ascii?Q?/+yVD1H4LOpU/wt1ABkEdUiWxHktmsJGl+j/J1B5I/lFpCO703rrF7e7W/Cx?=
 =?us-ascii?Q?JKmKKH889DRo1HAwBiUOo+oHSBiTgbMNbw43q/MXqsdRd2fDkQ2s81p9H/gY?=
 =?us-ascii?Q?uCl9bGJxCW1edLizRXeb5X6RMxf0IjivzhJocGGR8WR+IoYWRJJmkEtH+AXM?=
 =?us-ascii?Q?M5xe40up5Y17A6WCHtgKUT2xe9g8bLVQVv6THGIZk+mCOkrtBV8jnvUrVpzD?=
 =?us-ascii?Q?hczyR31vlanNjBfA6auCd6g/Nrrtl5jkle5o0UyXvmKLmXefDVsaHuOjZFnb?=
 =?us-ascii?Q?RiCs5oEmaKAqG3y3c16Ahp61CiNG52eNyq9HxOqsKzpHl/wvQ15w1VcjseAQ?=
 =?us-ascii?Q?QLaA0tA5bs+ay7c/wcuJf7xm4lQcozxGqLRAvkKbNrdQ+pMJvBRq1Nhv2dMh?=
 =?us-ascii?Q?IoclcGSr/Xwv/wF0PI5igVXDK5MiM5Hg3uhb1S0c5AmyrezhlWu/01eYFdJ5?=
 =?us-ascii?Q?RaBVjAZOFTKnldJCxEWUKz3bc/5cr0UINvAJm172nM/G1E4ZOgDMX3TYC3jQ?=
 =?us-ascii?Q?qkzoMyqigeLYwtaTGyKb5p34E43jmuaVv8mfMpX6oMxahgeZiz4ScZCfsPsx?=
 =?us-ascii?Q?u3YroatrMyjJkhrF6UtgWwog?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c69d908-c1e5-4c24-9cd4-08d97864f11f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 16:21:58.3861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IV8G1vkOqp4uyUANOHSYIIwYA2mFz6PKfvBk+khBaJnZhgEEALbnxTbK4ioov5Nx9DLoK3IpPkkpR63hEiEKIMCXl1IsbWYuKa1P544pAVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0908
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com>  Sent: Tuesday, September 14, 2021 6=
:39 AM
>=20
> In Isolation VM, all shared memory with host needs to mark visible
> to host via hvcall. vmbus_establish_gpadl() has already done it for
> netvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
> pagebuffer() stills need to be handled. Use DMA API to map/umap
> these memory during sending/receiving packet and Hyper-V swiotlb
> bounce buffer dma address will be returned. The swiotlb bounce buffer
> has been masked to be visible to host during boot up.
>=20
> Allocate rx/tx ring buffer via alloc_pages() in Isolation VM and map
> these pages via vmap(). After calling vmbus_establish_gpadl() which
> marks these pages visible to host, unmap these pages to release the
> virtual address mapped with physical address below shared_gpa_boundary
> and map them in the extra address space via vmap_pfn().
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v4:
> 	* Allocate rx/tx ring buffer via alloc_pages() in Isolation VM
> 	* Map pages after calling vmbus_establish_gpadl().
> 	* set dma_set_min_align_mask for netvsc driver.
>=20
> Change since v3:
> 	* Add comment to explain why not to use dma_map_sg()
> 	* Fix some error handle.
> ---
>  drivers/net/hyperv/hyperv_net.h   |   7 +
>  drivers/net/hyperv/netvsc.c       | 287 +++++++++++++++++++++++++++++-
>  drivers/net/hyperv/netvsc_drv.c   |   1 +
>  drivers/net/hyperv/rndis_filter.c |   2 +
>  include/linux/hyperv.h            |   5 +
>  5 files changed, 296 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_=
net.h
> index 315278a7cf88..87e8c74398a5 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -164,6 +164,7 @@ struct hv_netvsc_packet {
>  	u32 total_bytes;
>  	u32 send_buf_index;
>  	u32 total_data_buflen;
> +	struct hv_dma_range *dma_range;
>  };
>=20
>  #define NETVSC_HASH_KEYLEN 40
> @@ -1074,6 +1075,8 @@ struct netvsc_device {
>=20
>  	/* Receive buffer allocated by us but manages by NetVSP */
>  	void *recv_buf;
> +	struct page **recv_pages;
> +	u32 recv_page_count;
>  	u32 recv_buf_size; /* allocated bytes */
>  	struct vmbus_gpadl recv_buf_gpadl_handle;
>  	u32 recv_section_cnt;
> @@ -1082,6 +1085,8 @@ struct netvsc_device {
>=20
>  	/* Send buffer allocated by us */
>  	void *send_buf;
> +	struct page **send_pages;
> +	u32 send_page_count;
>  	u32 send_buf_size;
>  	struct vmbus_gpadl send_buf_gpadl_handle;
>  	u32 send_section_cnt;
> @@ -1731,4 +1736,6 @@ struct rndis_message {
>  #define RETRY_US_HI	10000
>  #define RETRY_MAX	2000	/* >10 sec */
>=20
> +void netvsc_dma_unmap(struct hv_device *hv_dev,
> +		      struct hv_netvsc_packet *packet);
>  #endif /* _HYPERV_NET_H */
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 1f87e570ed2b..7d5254bf043e 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -20,6 +20,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/prefetch.h>
> +#include <linux/gfp.h>
>=20
>  #include <asm/sync_bitops.h>
>  #include <asm/mshyperv.h>
> @@ -150,11 +151,33 @@ static void free_netvsc_device(struct rcu_head *hea=
d)
>  {
>  	struct netvsc_device *nvdev
>  		=3D container_of(head, struct netvsc_device, rcu);
> +	unsigned int alloc_unit;
>  	int i;
>=20
>  	kfree(nvdev->extension);
> -	vfree(nvdev->recv_buf);
> -	vfree(nvdev->send_buf);
> +
> +	if (nvdev->recv_pages) {
> +		alloc_unit =3D (nvdev->recv_buf_size /
> +			nvdev->recv_page_count) >> PAGE_SHIFT;
> +
> +		vunmap(nvdev->recv_buf);
> +		for (i =3D 0; i < nvdev->recv_page_count; i++)
> +			__free_pages(nvdev->recv_pages[i], alloc_unit);
> +	} else {
> +		vfree(nvdev->recv_buf);
> +	}
> +
> +	if (nvdev->send_pages) {
> +		alloc_unit =3D (nvdev->send_buf_size /
> +			nvdev->send_page_count) >> PAGE_SHIFT;
> +
> +		vunmap(nvdev->send_buf);
> +		for (i =3D 0; i < nvdev->send_page_count; i++)
> +			__free_pages(nvdev->send_pages[i], alloc_unit);
> +	} else {
> +		vfree(nvdev->send_buf);
> +	}
> +
>  	kfree(nvdev->send_section_map);
>=20
>  	for (i =3D 0; i < VRSS_CHANNEL_MAX; i++) {
> @@ -330,6 +353,108 @@ int netvsc_alloc_recv_comp_ring(struct netvsc_devic=
e *net_device, u32 q_idx)
>  	return nvchan->mrc.slots ? 0 : -ENOMEM;
>  }
>=20
> +void *netvsc_alloc_pages(struct page ***pages_array, unsigned int *array=
_len,
> +			 unsigned long size)
> +{
> +	struct page *page, **pages, **vmap_pages;
> +	unsigned long pg_count =3D size >> PAGE_SHIFT;
> +	int alloc_unit =3D MAX_ORDER_NR_PAGES;
> +	int i, j, vmap_page_index =3D 0;
> +	void *vaddr;
> +
> +	if (pg_count < alloc_unit)
> +		alloc_unit =3D 1;
> +
> +	/* vmap() accepts page array with PAGE_SIZE as unit while try to
> +	 * allocate high order pages here in order to save page array space.
> +	 * vmap_pages[] is used as input parameter of vmap(). pages[] is to
> +	 * store allocated pages and map them later.
> +	 */
> +	vmap_pages =3D kmalloc_array(pg_count, sizeof(*vmap_pages), GFP_KERNEL)=
;
> +	if (!vmap_pages)
> +		return NULL;
> +
> +retry:
> +	*array_len =3D pg_count / alloc_unit;
> +	pages =3D kmalloc_array(*array_len, sizeof(*pages), GFP_KERNEL);
> +	if (!pages)
> +		goto cleanup;
> +
> +	for (i =3D 0; i < *array_len; i++) {
> +		page =3D alloc_pages(GFP_KERNEL | __GFP_ZERO,
> +				   get_order(alloc_unit << PAGE_SHIFT));
> +		if (!page) {
> +			/* Try allocating small pages if high order pages are not available. =
*/
> +			if (alloc_unit =3D=3D 1) {
> +				goto cleanup;
> +			} else {

The "else" clause isn't really needed because of the goto cleanup above.  T=
hen
the indentation of the code below could be reduced by one level.

> +				memset(vmap_pages, 0,
> +				       sizeof(*vmap_pages) * vmap_page_index);
> +				vmap_page_index =3D 0;
> +
> +				for (j =3D 0; j < i; j++)
> +					__free_pages(pages[j], alloc_unit);
> +
> +				kfree(pages);
> +				alloc_unit =3D 1;

This is the case where a large enough contiguous physical memory chunk coul=
d
not be found.  But rather than dropping all the way down to single pages,
would it make sense to try something smaller, but not 1?  For example,
cut the alloc_unit in half and try again.  But I'm not sure of all the impl=
ications.

> +				goto retry;
> +			}
> +		}
> +
> +		pages[i] =3D page;
> +		for (j =3D 0; j < alloc_unit; j++)
> +			vmap_pages[vmap_page_index++] =3D page++;
> +	}
> +
> +	vaddr =3D vmap(vmap_pages, vmap_page_index, VM_MAP, PAGE_KERNEL);
> +	kfree(vmap_pages);
> +
> +	*pages_array =3D pages;
> +	return vaddr;
> +
> +cleanup:
> +	for (j =3D 0; j < i; j++)
> +		__free_pages(pages[i], alloc_unit);
> +
> +	kfree(pages);
> +	kfree(vmap_pages);
> +	return NULL;
> +}
> +
> +static void *netvsc_map_pages(struct page **pages, int count, int alloc_=
unit)
> +{
> +	int pg_count =3D count * alloc_unit;
> +	struct page *page;
> +	unsigned long *pfns;
> +	int pfn_index =3D 0;
> +	void *vaddr;
> +	int i, j;
> +
> +	if (!pages)
> +		return NULL;
> +
> +	pfns =3D kcalloc(pg_count, sizeof(*pfns), GFP_KERNEL);
> +	if (!pfns)
> +		return NULL;
> +
> +	for (i =3D 0; i < count; i++) {
> +		page =3D pages[i];
> +		if (!page) {
> +			pr_warn("page is not available %d.\n", i);
> +			return NULL;
> +		}
> +
> +		for (j =3D 0; j < alloc_unit; j++) {
> +			pfns[pfn_index++] =3D page_to_pfn(page++) +
> +				(ms_hyperv.shared_gpa_boundary >> PAGE_SHIFT);
> +		}
> +	}
> +
> +	vaddr =3D vmap_pfn(pfns, pg_count, PAGE_KERNEL_IO);
> +	kfree(pfns);
> +	return vaddr;
> +}
> +

I think you are proposing this approach to allocating memory for the send
and receive buffers so that you can avoid having two virtual mappings for
the memory, per comments from Christop Hellwig.  But overall, the approach
seems a bit complex and I wonder if it is worth it.  If allocating large co=
ntiguous
chunks of physical memory is successful, then there is some memory savings
in that the data structures needed to keep track of the physical pages is
smaller than the equivalent page tables might be.  But if you have to rever=
t
to allocating individual pages, then the memory savings is reduced.

Ultimately, the list of actual PFNs has to be kept somewhere.  Another appr=
oach
would be to do the reverse of what hv_map_memory() from the v4 patch
series does.  I.e., you could do virt_to_phys() on each virtual address tha=
t
maps above VTOM, and subtract out the shared_gpa_boundary to get the
list of actual PFNs that need to be freed.   This way you don't have two co=
pies
of the list of PFNs -- one with and one without the shared_gpa_boundary add=
ed.
But it comes at the cost of additional code so that may not be a great idea=
.

I think what you have here works, and I don't have a clearly better solutio=
n
at the moment except perhaps to revert to the v4 solution and just have two
virtual mappings.  I'll keep thinking about it.  Maybe Christop has other
thoughts.

>  static int netvsc_init_buf(struct hv_device *device,
>  			   struct netvsc_device *net_device,
>  			   const struct netvsc_device_info *device_info)
> @@ -337,7 +462,7 @@ static int netvsc_init_buf(struct hv_device *device,
>  	struct nvsp_1_message_send_receive_buffer_complete *resp;
>  	struct net_device *ndev =3D hv_get_drvdata(device);
>  	struct nvsp_message *init_packet;
> -	unsigned int buf_size;
> +	unsigned int buf_size, alloc_unit;
>  	size_t map_words;
>  	int i, ret =3D 0;
>=20
> @@ -350,7 +475,14 @@ static int netvsc_init_buf(struct hv_device *device,
>  		buf_size =3D min_t(unsigned int, buf_size,
>  				 NETVSC_RECEIVE_BUFFER_SIZE_LEGACY);
>=20
> -	net_device->recv_buf =3D vzalloc(buf_size);
> +	if (hv_isolation_type_snp())
> +		net_device->recv_buf =3D
> +			netvsc_alloc_pages(&net_device->recv_pages,
> +					   &net_device->recv_page_count,
> +					   buf_size);
> +	else
> +		net_device->recv_buf =3D vzalloc(buf_size);
> +

I wonder if it is necessary to have two different code paths here.  The
allocating and freeing of the send and receive buffers is not perf
sensitive, and it seems like netvsc_alloc_pages() could be used
regardless of whether SNP Isolation is in effect.  To my thinking,
one code path is better than two code paths unless there's a
compelling reason to have two.

>  	if (!net_device->recv_buf) {
>  		netdev_err(ndev,
>  			   "unable to allocate receive buffer of size %u\n",
> @@ -375,6 +507,27 @@ static int netvsc_init_buf(struct hv_device *device,
>  		goto cleanup;
>  	}
>=20
> +	if (hv_isolation_type_snp()) {
> +		alloc_unit =3D (buf_size / net_device->recv_page_count)
> +				>> PAGE_SHIFT;
> +
> +		/* Unmap previous virtual address and map pages in the extra
> +		 * address space(above shared gpa boundary) in Isolation VM.
> +		 */
> +		vunmap(net_device->recv_buf);
> +		net_device->recv_buf =3D
> +			netvsc_map_pages(net_device->recv_pages,
> +					 net_device->recv_page_count,
> +					 alloc_unit);
> +		if (!net_device->recv_buf) {
> +			netdev_err(ndev,
> +				   "unable to allocate receive buffer of size %u\n",
> +				   buf_size);
> +			ret =3D -ENOMEM;
> +			goto cleanup;
> +		}
> +	}
> +
>  	/* Notify the NetVsp of the gpadl handle */
>  	init_packet =3D &net_device->channel_init_pkt;
>  	memset(init_packet, 0, sizeof(struct nvsp_message));
> @@ -456,13 +609,21 @@ static int netvsc_init_buf(struct hv_device *device=
,
>  	buf_size =3D device_info->send_sections * device_info->send_section_siz=
e;
>  	buf_size =3D round_up(buf_size, PAGE_SIZE);
>=20
> -	net_device->send_buf =3D vzalloc(buf_size);
> +	if (hv_isolation_type_snp())
> +		net_device->send_buf =3D
> +			netvsc_alloc_pages(&net_device->send_pages,
> +					   &net_device->send_page_count,
> +					   buf_size);
> +	else
> +		net_device->send_buf =3D vzalloc(buf_size);
> +
>  	if (!net_device->send_buf) {
>  		netdev_err(ndev, "unable to allocate send buffer of size %u\n",
>  			   buf_size);
>  		ret =3D -ENOMEM;
>  		goto cleanup;
>  	}
> +
>  	net_device->send_buf_size =3D buf_size;
>=20
>  	/* Establish the gpadl handle for this buffer on this
> @@ -478,6 +639,27 @@ static int netvsc_init_buf(struct hv_device *device,
>  		goto cleanup;
>  	}
>=20
> +	if (hv_isolation_type_snp()) {
> +		alloc_unit =3D (buf_size / net_device->send_page_count)
> +				>> PAGE_SHIFT;
> +
> +		/* Unmap previous virtual address and map pages in the extra
> +		 * address space(above shared gpa boundary) in Isolation VM.
> +		 */
> +		vunmap(net_device->send_buf);
> +		net_device->send_buf =3D
> +			netvsc_map_pages(net_device->send_pages,
> +					 net_device->send_page_count,
> +					 alloc_unit);
> +		if (!net_device->send_buf) {
> +			netdev_err(ndev,
> +				   "unable to allocate receive buffer of size %u\n",
> +				   buf_size);
> +			ret =3D -ENOMEM;
> +			goto cleanup;
> +		}
> +	}
> +
>  	/* Notify the NetVsp of the gpadl handle */
>  	init_packet =3D &net_device->channel_init_pkt;
>  	memset(init_packet, 0, sizeof(struct nvsp_message));
> @@ -768,7 +950,7 @@ static void netvsc_send_tx_complete(struct net_device=
 *ndev,
>=20
>  	/* Notify the layer above us */
>  	if (likely(skb)) {
> -		const struct hv_netvsc_packet *packet
> +		struct hv_netvsc_packet *packet
>  			=3D (struct hv_netvsc_packet *)skb->cb;
>  		u32 send_index =3D packet->send_buf_index;
>  		struct netvsc_stats *tx_stats;
> @@ -784,6 +966,7 @@ static void netvsc_send_tx_complete(struct net_device=
 *ndev,
>  		tx_stats->bytes +=3D packet->total_bytes;
>  		u64_stats_update_end(&tx_stats->syncp);
>=20
> +		netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
>  		napi_consume_skb(skb, budget);
>  	}
>=20
> @@ -948,6 +1131,87 @@ static void netvsc_copy_to_send_buf(struct netvsc_d=
evice *net_device,
>  		memset(dest, 0, padding);
>  }
>=20
> +void netvsc_dma_unmap(struct hv_device *hv_dev,
> +		      struct hv_netvsc_packet *packet)
> +{
> +	u32 page_count =3D packet->cp_partial ?
> +		packet->page_buf_cnt - packet->rmsg_pgcnt :
> +		packet->page_buf_cnt;
> +	int i;
> +
> +	if (!hv_is_isolation_supported())
> +		return;
> +
> +	if (!packet->dma_range)
> +		return;
> +
> +	for (i =3D 0; i < page_count; i++)
> +		dma_unmap_single(&hv_dev->device, packet->dma_range[i].dma,
> +				 packet->dma_range[i].mapping_size,
> +				 DMA_TO_DEVICE);
> +
> +	kfree(packet->dma_range);
> +}
> +
> +/* netvsc_dma_map - Map swiotlb bounce buffer with data page of
> + * packet sent by vmbus_sendpacket_pagebuffer() in the Isolation
> + * VM.
> + *
> + * In isolation VM, netvsc send buffer has been marked visible to
> + * host and so the data copied to send buffer doesn't need to use
> + * bounce buffer. The data pages handled by vmbus_sendpacket_pagebuffer(=
)
> + * may not be copied to send buffer and so these pages need to be
> + * mapped with swiotlb bounce buffer. netvsc_dma_map() is to do
> + * that. The pfns in the struct hv_page_buffer need to be converted
> + * to bounce buffer's pfn. The loop here is necessary because the
> + * entries in the page buffer array are not necessarily full
> + * pages of data.  Each entry in the array has a separate offset and
> + * len that may be non-zero, even for entries in the middle of the
> + * array.  And the entries are not physically contiguous.  So each
> + * entry must be individually mapped rather than as a contiguous unit.
> + * So not use dma_map_sg() here.
> + */
> +static int netvsc_dma_map(struct hv_device *hv_dev,
> +		   struct hv_netvsc_packet *packet,
> +		   struct hv_page_buffer *pb)
> +{
> +	u32 page_count =3D  packet->cp_partial ?
> +		packet->page_buf_cnt - packet->rmsg_pgcnt :
> +		packet->page_buf_cnt;
> +	dma_addr_t dma;
> +	int i;
> +
> +	if (!hv_is_isolation_supported())
> +		return 0;
> +
> +	packet->dma_range =3D kcalloc(page_count,
> +				    sizeof(*packet->dma_range),
> +				    GFP_KERNEL);
> +	if (!packet->dma_range)
> +		return -ENOMEM;
> +
> +	for (i =3D 0; i < page_count; i++) {
> +		char *src =3D phys_to_virt((pb[i].pfn << HV_HYP_PAGE_SHIFT)
> +					 + pb[i].offset);
> +		u32 len =3D pb[i].len;
> +
> +		dma =3D dma_map_single(&hv_dev->device, src, len,
> +				     DMA_TO_DEVICE);
> +		if (dma_mapping_error(&hv_dev->device, dma)) {
> +			kfree(packet->dma_range);
> +			return -ENOMEM;
> +		}
> +
> +		packet->dma_range[i].dma =3D dma;
> +		packet->dma_range[i].mapping_size =3D len;
> +		pb[i].pfn =3D dma >> HV_HYP_PAGE_SHIFT;
> +		pb[i].offset =3D offset_in_hvpage(dma);

With the DMA min align mask now being set, the offset within
the Hyper-V page won't be changed by dma_map_single().  So I
think the above statement can be removed.

> +		pb[i].len =3D len;

A few lines above, the value of "len" is set from pb[i].len.  Neither
"len" nor "i" is changed in the loop, so this statement can also be
removed.

> +	}
> +
> +	return 0;
> +}
> +
>  static inline int netvsc_send_pkt(
>  	struct hv_device *device,
>  	struct hv_netvsc_packet *packet,
> @@ -988,14 +1252,24 @@ static inline int netvsc_send_pkt(
>=20
>  	trace_nvsp_send_pkt(ndev, out_channel, rpkt);
>=20
> +	packet->dma_range =3D NULL;
>  	if (packet->page_buf_cnt) {
>  		if (packet->cp_partial)
>  			pb +=3D packet->rmsg_pgcnt;
>=20
> +		ret =3D netvsc_dma_map(ndev_ctx->device_ctx, packet, pb);
> +		if (ret) {
> +			ret =3D -EAGAIN;
> +			goto exit;
> +		}
> +
>  		ret =3D vmbus_sendpacket_pagebuffer(out_channel,
>  						  pb, packet->page_buf_cnt,
>  						  &nvmsg, sizeof(nvmsg),
>  						  req_id);
> +
> +		if (ret)
> +			netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
>  	} else {
>  		ret =3D vmbus_sendpacket(out_channel,
>  				       &nvmsg, sizeof(nvmsg),
> @@ -1003,6 +1277,7 @@ static inline int netvsc_send_pkt(
>  				       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
>  	}
>=20
> +exit:
>  	if (ret =3D=3D 0) {
>  		atomic_inc_return(&nvchan->queue_sends);
>=20
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_=
drv.c
> index 382bebc2420d..c3dc884b31e3 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -2577,6 +2577,7 @@ static int netvsc_probe(struct hv_device *dev,
>  	list_add(&net_device_ctx->list, &netvsc_dev_list);
>  	rtnl_unlock();
>=20
> +	dma_set_min_align_mask(&dev->device, HV_HYP_PAGE_SIZE - 1);
>  	netvsc_devinfo_put(device_info);
>  	return 0;
>=20
> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis=
_filter.c
> index f6c9c2a670f9..448fcc325ed7 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -361,6 +361,8 @@ static void rndis_filter_receive_response(struct net_=
device *ndev,
>  			}
>  		}
>=20
> +		netvsc_dma_unmap(((struct net_device_context *)
> +			netdev_priv(ndev))->device_ctx, &request->pkt);
>  		complete(&request->wait_event);
>  	} else {
>  		netdev_err(ndev,
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index c94c534a944e..81e58dd582dc 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1597,6 +1597,11 @@ struct hyperv_service_callback {
>  	void (*callback)(void *context);
>  };
>=20
> +struct hv_dma_range {
> +	dma_addr_t dma;
> +	u32 mapping_size;
> +};
> +
>  #define MAX_SRV_VER	0x7ffffff
>  extern bool vmbus_prep_negotiate_resp(struct icmsg_hdr *icmsghdrp, u8 *b=
uf, u32 buflen,
>  				const int *fw_version, int fw_vercnt,
> --
> 2.25.1

