Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7C340C886
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238147AbhIOPoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:44:02 -0400
Received: from mail-oln040093003013.outbound.protection.outlook.com ([40.93.3.13]:26283
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238022AbhIOPoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 11:44:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtKrp+lzji7XMd98vnSDmCDWfletLqhX00sGIiRD73cIb16nDoQkDGvE3pN2oe71HFHh2fae7NAh+o9A9cUJG1kbGMMR0FqXGeloiFfJxM0FwZ+od0+fMFISyMBI5xm785hYPNbO90c3+S5wopG7FoAl5Xzq5WMpHUvSexmExn585mcQBgCvPvR6vQKL1z7a9yQUFaNlUac+lG+j8OKyklDWcFaRdHxX7aZjnqxgjr0DOKJM62qKwrRHo116GW9T+9lylqesXiCK7ATh8+/loc5wNw8v3I1RqndDa/1H4t6DdQezIy+2b5eNr2GlUfQ3tXBGywAtOWuEAYlr5Gl92w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BmgFBrbCC5NBlik2Cix7zD+7gpr/CsJhBYJ5DLtJP7Y=;
 b=eXZZn990OBqrqIvpN9oGye2FcerLP6uStqaDsTbq8TdVKy5c3vQRQB2iP7wnKOe5GZ7MUrjC+0vkhkQ90DoC/bWML8s1tYKRNBwcolvGwffFl2qlmdhflz3li/o15o6HUhkBuijrG4nSrfMzQz+q6tlrGfddmwHZJWOstlh9LBoZoNxA0Z1vK1FJiXvNnPasdfFD+ITiOaQFANhztPvHU6j80+b9YKQ6kihYi0dFx0kavy13WADN37JAAvIQ/q581zu6/PPxPpeJBJ56ZlFYki/3t8a42bt2UKlBJWIh5xGzQZyeZId6jfu6KVWniAYtq8p86O/LAIhhxYsKB57yRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmgFBrbCC5NBlik2Cix7zD+7gpr/CsJhBYJ5DLtJP7Y=;
 b=GXftKEyuhJh++1UnWeEAC0QWnYCFvPvGVS19qUJcwlUra/4kknm0QX3H3UbafklD0YUWdGxFEBCRqxQeo7TZUNOoXba6qQ65e2/nw6aw96gFRHxc7kzqzrUE6OjfGTaZYOYqqtnPk8ZkV1Mh+Dh7RVOHbUAYvTHHxtMPY92DWJQ=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW2PR2101MB1819.namprd21.prod.outlook.com (2603:10b6:302:8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.2; Wed, 15 Sep
 2021 15:42:29 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9cb:4254:eba4:a4c3]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9cb:4254:eba4:a4c3%7]) with mapi id 15.20.4544.005; Wed, 15 Sep 2021
 15:42:29 +0000
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
Subject: RE: [PATCH V5 09/12] x86/Swiotlb: Add Swiotlb bounce buffer remap
 function for HV IVM
Thread-Topic: [PATCH V5 09/12] x86/Swiotlb: Add Swiotlb bounce buffer remap
 function for HV IVM
Thread-Index: AQHXqW4AcVkxLZ5eA0abh07NwOrvvKulNF0Q
Date:   Wed, 15 Sep 2021 15:42:29 +0000
Message-ID: <MWHPR21MB159349234C15D0F04F87845CD7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210914133916.1440931-1-ltykernel@gmail.com>
 <20210914133916.1440931-10-ltykernel@gmail.com>
In-Reply-To: <20210914133916.1440931-10-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=58de890b-0740-424d-90fe-6625ce1167d3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-15T15:09:00Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3711a4b1-0969-4987-2dd8-08d9785f6cec
x-ms-traffictypediagnostic: MW2PR2101MB1819:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB181994E36D2DD88A5BA50479D7DB9@MW2PR2101MB1819.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i6IDirtIG/JY8dhPqpLI67X0jaa0NIi01ef16Iln5fgM1oQ5SqZIRiU0HLKRkeetbD2VsbqvQEWuNL8nq2MQN1XJ3Sx/yrgsWCno6fJoZBG8EkY5iXMUO+JXxz/jGPSi0ATVfi8w3wjf26UBFIyExewxg9VzB4do/FjwZj+CViixlLmjUUeHoujzTx/QYyB8tatm0DGC4aZMo844Mmd8JMMwar3pTqndadrldKSUAEDf6aO8U2cYmqzUFNjM8H6mVFEsGmb2UWms4q9ZWDsBHP8ykbIvLKpOW2dKtnNDo/JgxTorLrDmmjaVOPzPEVZ1JxfwQL431y9qepoi+MYF+RERb3yw/MoJCOpva5RH8NvOdv5OuXY5qtNrtHW4xS6d93VQrjyPBgWBggyMMRwTWm7dnf+WdYeV3k60uBrE481GXpSONyQCUWhdP0ee+1ElB+Lo5ZIcmMM+XpFp5e3HYKr2C1wzJLORdMTqRDG3oufDbppyhfLNohzJVKd7hozVdid4/ayHYi19uYAbVYPxctGpIeTvzvubSuN4KVgLYTN47/iLp0fRH6KbigdPJTKUq3jVsLt0MPdehbGlZXVCSrAYp5Fo3K1y6K6rvZCGGlZUiB0W1GDN1tk+2C1WhukGuqpIkEmb1JGlRXG4clCcLkFDvMP91qLX/fOYkhA4whmYTM0pSQTTqonPumXYpaBCgeZ16BH11TZYG0XZZnAVwR0sXmd69b9+UXfx1MhqY8U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(921005)(71200400001)(110136005)(82950400001)(54906003)(5660300002)(10290500003)(7406005)(6506007)(9686003)(33656002)(8936002)(83380400001)(66946007)(38070700005)(38100700002)(316002)(122000001)(7416002)(55016002)(26005)(66556008)(66446008)(86362001)(76116006)(66476007)(64756008)(8676002)(508600001)(7696005)(2906002)(82960400001)(52536014)(4326008)(186003)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?e63sg6qzwihPKEL2sQ0AiD7T/von3zNlILMkOCDOntRohQmYXi8yhQ62u2IC?=
 =?us-ascii?Q?zQVrVzzeqS28QexASAlBYGWVE8KIZZzOLI7e1dKJqd0KDpTJ1tHmdY3iA1Ep?=
 =?us-ascii?Q?4O7faisDjTP1du5xqGKm3kQqMi60TEXxot5LA/J8bSHta5WW2s/3T56VYswl?=
 =?us-ascii?Q?9hmIMRNAADOzAgL21BUHquxLe/H7htXPzad0WgsG6M6x5eIqIwvm6kKN2XBf?=
 =?us-ascii?Q?XaU/wBuwSR/bmGD8WcWSqsEYgyVcxlKdRpXvLzixuFQUQpMF8t0IKn1g4nvR?=
 =?us-ascii?Q?FxSUfp42g0EeWqfeFo+cBUq+2/foBSVtwJG5j9IysfPVtJZkb3UkNILZOmAc?=
 =?us-ascii?Q?WJB2m0l9u2O6Jz1QvQs0cQI7UgXWHuV6cXU4C4pWjAwSFTXy+P2BoJj3jcIJ?=
 =?us-ascii?Q?OGqSDNfZhvMsuMRb1wYqev8b6WRs+JZ/2ONjDo05Y9s8tlbOmtVl+s5vlpQu?=
 =?us-ascii?Q?FkZnkywD+JmEMhYAIY/5eG7u2gByWfQ/x+zvnFfxSEcqA98wzIbESm/7/bM8?=
 =?us-ascii?Q?cAabRqL89E/+v8g7rr/rE0lMnEZ2hSQIi8DSSVcdleZ5SRM/uehRTyEkLbkW?=
 =?us-ascii?Q?50H4h3VbPuNucjaqgVLE0EkYptAsCWCIvlPeRV1kK2UGbfAhAUFrDwnoDH7Z?=
 =?us-ascii?Q?/R6FpRVigwiBuHMecqA7+gJyKG2/fOnv6Zcm5x3sgaqWslaPjKbPlGhJE4e7?=
 =?us-ascii?Q?s+13149KLiP2Jke5Q0P6bALqwtfWKQJrLSOiQ+WDvAUlsR2yqZ1hJuiMEqNQ?=
 =?us-ascii?Q?9lNkKo4dl2bvAWu4QFfcdX+38Rlf33+naaa22lvsEE2xroRFoCqai3tg1r7x?=
 =?us-ascii?Q?j5ZVB4vhO3j+FVeeKXzkoEHAH4MTAY6QPF26rZ16F+8TpentmNOu3FL0JZJS?=
 =?us-ascii?Q?lfMYPAsKfrAqYo9AZRWu472Lhlmo/ZTLzuShXlQNGjQJGtKEdrbgsZgxAPU4?=
 =?us-ascii?Q?EUSQIekX5fy1Fxz6vaR0DPW57nZ5Z/+Unduro+LjdYy4zDE1A3BATkTdxnMw?=
 =?us-ascii?Q?LItU1ujLcD61wgcZk3E/BWwabOWonqAT3Kvw5kfaQGUBz/XrOQMhc3tC/E4N?=
 =?us-ascii?Q?+gp+iszOIOBcCQ2fKlNVPPBbmR3rPiUL7sjHxkP3YO9ojNliFqRLw/Rky7f+?=
 =?us-ascii?Q?6GQi5Lxxii/dBpZ9/1Pcl520UPU7JmKp54X864TWxI4mvd2N95V7bbC5cn3T?=
 =?us-ascii?Q?h57vuF5xSZK+AtEs/aYPM4An/4W1XDrlLspr5WY/tb2y7pQtmMJ+j2wXazfr?=
 =?us-ascii?Q?k9NvkQnvWmN7uspM8uT6ejfXbHLs2dDQWB5LpIO/pgoMo4PUbIOmR3YESXZu?=
 =?us-ascii?Q?Lq3utGvUcnJDcakCx6iaWr/U?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3711a4b1-0969-4987-2dd8-08d9785f6cec
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 15:42:29.1121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OfTbv+rW/eXSEDAIeHRYn6QW2NszlnXQS++cu8KUsMmq5B6uFZqOwTn+HhCrGrFIvF/UaX7eT2ijYBx0HsPtLg7TuAs/iDaGIARXtxHSfuo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1819
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Tuesday, September 14, 2021 6:=
39 AM
>=20
> In Isolation VM with AMD SEV, bounce buffer needs to be accessed via
> extra address space which is above shared_gpa_boundary
> (E.G 39 bit address line) reported by Hyper-V CPUID ISOLATION_CONFIG.
> The access physical address will be original physical address +
> shared_gpa_boundary. The shared_gpa_boundary in the AMD SEV SNP
> spec is called virtual top of memory(vTOM). Memory addresses below
> vTOM are automatically treated as private while memory above
> vTOM is treated as shared.
>=20
> Expose swiotlb_unencrypted_base for platforms to set unencrypted
> memory base offset and call memremap() to map bounce buffer in the
> swiotlb code, store map address and use the address to copy data
> from/to swiotlb bounce buffer.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v4:
> 	* Expose swiotlb_unencrypted_base to set unencrypted memory
> 	  offset.
> 	* Use memremap() to map bounce buffer if swiotlb_unencrypted_
> 	  base is set.
>=20
> Change since v1:
> 	* Make swiotlb_init_io_tlb_mem() return error code and return
>           error when dma_map_decrypted() fails.
> ---
>  include/linux/swiotlb.h |  6 ++++++
>  kernel/dma/swiotlb.c    | 41 +++++++++++++++++++++++++++++++++++------
>  2 files changed, 41 insertions(+), 6 deletions(-)
>=20
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index b0cb2a9973f4..4998ed44ae3d 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -72,6 +72,9 @@ extern enum swiotlb_force swiotlb_force;
>   * @end:	The end address of the swiotlb memory pool. Used to do a quick
>   *		range check to see if the memory was in fact allocated by this
>   *		API.
> + * @vaddr:	The vaddr of the swiotlb memory pool. The swiotlb
> + *		memory pool may be remapped in the memory encrypted case and store
> + *		virtual address for bounce buffer operation.
>   * @nslabs:	The number of IO TLB blocks (in groups of 64) between @start=
 and
>   *		@end. For default swiotlb, this is command line adjustable via
>   *		setup_io_tlb_npages.
> @@ -91,6 +94,7 @@ extern enum swiotlb_force swiotlb_force;
>  struct io_tlb_mem {
>  	phys_addr_t start;
>  	phys_addr_t end;
> +	void *vaddr;
>  	unsigned long nslabs;
>  	unsigned long used;
>  	unsigned int index;
> @@ -185,4 +189,6 @@ static inline bool is_swiotlb_for_alloc(struct device=
 *dev)
>  }
>  #endif /* CONFIG_DMA_RESTRICTED_POOL */
>=20
> +extern phys_addr_t swiotlb_unencrypted_base;
> +
>  #endif /* __LINUX_SWIOTLB_H */
> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index 87c40517e822..9e30cc4bd872 100644
> --- a/kernel/dma/swiotlb.c
> +++ b/kernel/dma/swiotlb.c
> @@ -50,6 +50,7 @@
>  #include <asm/io.h>
>  #include <asm/dma.h>
>=20
> +#include <linux/io.h>
>  #include <linux/init.h>
>  #include <linux/memblock.h>
>  #include <linux/iommu-helper.h>
> @@ -72,6 +73,8 @@ enum swiotlb_force swiotlb_force;
>=20
>  struct io_tlb_mem io_tlb_default_mem;
>=20
> +phys_addr_t swiotlb_unencrypted_base;
> +
>  /*
>   * Max segment that we can provide which (if pages are contingous) will
>   * not be bounced (unless SWIOTLB_FORCE is set).
> @@ -175,7 +178,7 @@ void __init swiotlb_update_mem_attributes(void)
>  	memset(vaddr, 0, bytes);
>  }
>=20
> -static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t =
start,
> +static int swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t s=
tart,
>  				    unsigned long nslabs, bool late_alloc)
>  {
>  	void *vaddr =3D phys_to_virt(start);
> @@ -196,13 +199,34 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_m=
em *mem, phys_addr_t start,
>  		mem->slots[i].orig_addr =3D INVALID_PHYS_ADDR;
>  		mem->slots[i].alloc_size =3D 0;
>  	}
> +
> +	if (set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT))
> +		return -EFAULT;
> +
> +	/*
> +	 * Map memory in the unencrypted physical address space when requested
> +	 * (e.g. for Hyper-V AMD SEV-SNP Isolation VMs).
> +	 */
> +	if (swiotlb_unencrypted_base) {
> +		phys_addr_t paddr =3D __pa(vaddr) + swiotlb_unencrypted_base;

Nit:  Use "start" instead of "__pa(vaddr)" since "start" is already the nee=
ded
physical address.

> +
> +		vaddr =3D memremap(paddr, bytes, MEMREMAP_WB);
> +		if (!vaddr) {
> +			pr_err("Failed to map the unencrypted memory.\n");
> +			return -ENOMEM;
> +		}
> +	}
> +
>  	memset(vaddr, 0, bytes);
> +	mem->vaddr =3D vaddr;
> +	return 0;
>  }
>=20
>  int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int ve=
rbose)
>  {
>  	struct io_tlb_mem *mem =3D &io_tlb_default_mem;
>  	size_t alloc_size;
> +	int ret;
>=20
>  	if (swiotlb_force =3D=3D SWIOTLB_NO_FORCE)
>  		return 0;
> @@ -217,7 +241,11 @@ int __init swiotlb_init_with_tbl(char *tlb, unsigned=
 long nslabs, int verbose)
>  		panic("%s: Failed to allocate %zu bytes align=3D0x%lx\n",
>  		      __func__, alloc_size, PAGE_SIZE);
>=20
> -	swiotlb_init_io_tlb_mem(mem, __pa(tlb), nslabs, false);
> +	ret =3D swiotlb_init_io_tlb_mem(mem, __pa(tlb), nslabs, false);
> +	if (ret) {
> +		memblock_free(__pa(mem), alloc_size);
> +		return ret;
> +	}
>=20
>  	if (verbose)
>  		swiotlb_print_info();
> @@ -304,7 +332,7 @@ int
>  swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
>  {
>  	struct io_tlb_mem *mem =3D &io_tlb_default_mem;
> -	unsigned long bytes =3D nslabs << IO_TLB_SHIFT;
> +	int ret;
>=20
>  	if (swiotlb_force =3D=3D SWIOTLB_NO_FORCE)
>  		return 0;
> @@ -318,8 +346,9 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long n=
slabs)
>  	if (!mem->slots)
>  		return -ENOMEM;
>=20
> -	set_memory_decrypted((unsigned long)tlb, bytes >> PAGE_SHIFT);
> -	swiotlb_init_io_tlb_mem(mem, virt_to_phys(tlb), nslabs, true);
> +	ret =3D swiotlb_init_io_tlb_mem(mem, virt_to_phys(tlb), nslabs, true);
> +	if (ret)

Before returning the error, free the pages obtained from the earlier call
to __get_free_pages()?

> +		return ret;
>=20
>  	swiotlb_print_info();
>  	swiotlb_set_max_segment(mem->nslabs << IO_TLB_SHIFT);
> @@ -371,7 +400,7 @@ static void swiotlb_bounce(struct device *dev, phys_a=
ddr_t tlb_addr, size_t size
>  	phys_addr_t orig_addr =3D mem->slots[index].orig_addr;
>  	size_t alloc_size =3D mem->slots[index].alloc_size;
>  	unsigned long pfn =3D PFN_DOWN(orig_addr);
> -	unsigned char *vaddr =3D phys_to_virt(tlb_addr);
> +	unsigned char *vaddr =3D mem->vaddr + tlb_addr - mem->start;
>  	unsigned int tlb_offset, orig_addr_offset;
>=20
>  	if (orig_addr =3D=3D INVALID_PHYS_ADDR)
> --
> 2.25.1
