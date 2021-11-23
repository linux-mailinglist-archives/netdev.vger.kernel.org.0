Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D079845A9CB
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239058AbhKWRSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:18:23 -0500
Received: from mail-cusazon11021017.outbound.protection.outlook.com ([52.101.62.17]:9165
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230176AbhKWRSW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 12:18:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofeO3IbaEIXYKeT1TsuF9vyBcAiDKIr63Pl2J/XmdOCi1FIpB/mi2WUn0I50trgVBsDltAsalGa8wL3WcpDTqdbVwHO5yQ2egWCpC8h2vQSmQSVaf65CpBAEiR0ZRvBhnheWyxBvFROViLj01G7vRBBsWlW1zdypPDmZYcE7VxbedfICMhAit54G5jNJIgngIGYtDeP6btB2Cl4qbP21aDbpfqe1NPDo5cQaDzzx33Qch2L1SDiO9DExoUVFnyNkBiRVnzeTkKyiGWq7so9piqGLjrfJTOUABVYEDyCPsvJGjkBtsNXfka4+MR16M0lhTdaDRwHuJJQFahuh33jWNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P/AgrRAsE3e8DwVFyZb8mhen++/8s7P4Fv34JlkvGGY=;
 b=VzXLSexfFuAhvdqPvnPnrCNAa5dbJi3hJbMyMb5OG/NvlTeOKpW37ZnTJ21aFz4dCHjQLgYf0CVaAR+OUXl7cbYeaGHRItM8Yjz4JysfCh1UZy1lQcwdntQmRHhpl59ROVlA2AFPM7t7UG6mdONlh/Lhxyqqfcqr8C7WZO8hKRyiGHoz8V1zU66Jewo0nHle/DhZQNw9Sg30cqKebxYCMBaHXyv9UVJi+U9JFcnFMZpDJO5pgWdk66Au1en/gqXbvrky8iLIHpC2XurwygspZEd9twJhDZorX+nnSXL0xiJeG0iHwJZhi/mdX1bFyNyl+L619KaqhlIFViQIYMPtDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/AgrRAsE3e8DwVFyZb8mhen++/8s7P4Fv34JlkvGGY=;
 b=LRbON/l4Wn4pQbkGozGRsjGU4x/WFNw2ml93FZI5b39xp+wBEipFK6g5tZ91ZMrIIy3Udqq+AdtEdOzOvVoPflvUvq7/8PsIp9ZYnKa+P3n7ABQ54NVu9A7RIh4Q+a9eSRAJan6wEVG4SIW+3Y5rP4OSurHxJwx9RQZ+y1dJIBU=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW4PR21MB1971.namprd21.prod.outlook.com (2603:10b6:303:7d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.2; Tue, 23 Nov
 2021 17:15:05 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9401:9c8b:c334:4336]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9401:9c8b:c334:4336%2]) with mapi id 15.20.4755.001; Tue, 23 Nov 2021
 17:15:05 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V2 1/6] Swiotlb: Add Swiotlb bounce buffer remap function
 for HV IVM
Thread-Topic: [PATCH V2 1/6] Swiotlb: Add Swiotlb bounce buffer remap function
 for HV IVM
Thread-Index: AQHX4HeSpdu4+UVN+0mZE44Ng5xByawRUlog
Date:   Tue, 23 Nov 2021 17:15:05 +0000
Message-ID: <MWHPR21MB1593169593AD833A91DF553FD7609@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20211123143039.331929-1-ltykernel@gmail.com>
 <20211123143039.331929-2-ltykernel@gmail.com>
In-Reply-To: <20211123143039.331929-2-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=20ac84dd-6068-4158-8f23-31c48ca2fb69;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-11-23T16:46:20Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53492aa7-ed12-4d2a-c4a9-08d9aea4cb26
x-ms-traffictypediagnostic: MW4PR21MB1971:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW4PR21MB1971D59BCDA7CB082BD583D7D7609@MW4PR21MB1971.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:33;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BXFhhPGWjUIhW86hag+IGKX2AN6z4EyarBn7Qc4McNDeHg6TSwJhkEjOVl8neYr5gw9gmvUkK1he8hJEL3RWGJsKBFuqMf3HkP7+mTGE9QuDCeYxkhVU4QbTsfmsmlN7I1of0apRzOR1MU6r5/BETidQkc9iakKkJOGZ5kOZrjKvUX3TXesk3f73eY+jMw4/A0cKuiHdFWFeLZSkinZFfAIOzrN1xYY4uEHVnsSqNMHSAGoEYhN9B2J2oCLrZYm+Fgi/Y7s3ZQtCiMPpV1ogEsvAo7fUOQD43miXe4pebQDEMcs66JTHcmrhH0PsWQNVtIpLWefxaLx8YzV7EFWX40GVIe5pu5LGpgkYcWLU5BDZkYfYQjKGJ/kBfxgKuQGtobD2h372cW4tciiAQV/zy9xkl1tlCM6fs+CGcp5E/LOtiq8gRbjL7PF04j/AWMT+ej4t8H2O2yikWNwCLVqVuQIs3PQwOhL/jHKj22tOxni5Tw8FuxPHsRdgieyc9GuhzWRgvDS+1nejLoQhVh1RrbKjX+/vq0PCWfWi1hESEYNDj/Fzjqe/BfJKlqEHEx+B8/tnjZ0uJxT6ZB7D7waL8jOpXr/jPuaLzP4WE8+9rHPNnm9Rgsh/3qM4zRwUwIOLkim3ZXr35Bt12VhdJmmF9JCgx7faa57NTRxZhNAK4r1jVafXdzO4vKiNS+CJ+/Ahfs2XYQoShEK2Tg8X3+LKL9dc5nJe6Kck1npvgPoBsuemdGLEIGRjR5Junx2rxLFo10+zmiXhtlCN8Kbeoa4d6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(10290500003)(8676002)(52536014)(122000001)(86362001)(66446008)(38100700002)(4326008)(55016003)(316002)(64756008)(2906002)(83380400001)(66946007)(33656002)(66556008)(9686003)(76116006)(8936002)(110136005)(921005)(66476007)(38070700005)(54906003)(82960400001)(508600001)(8990500004)(7406005)(7416002)(5660300002)(7696005)(71200400001)(6506007)(26005)(186003)(82950400001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qISMY46OkQlgn6H3Q+Fooujnc0qtjjsuFvjmlGqNjADwI/t3dApfBKnJQqAi?=
 =?us-ascii?Q?LhSqbZ4AxJDpwRrzc7u1RpQ+vm19FSk54j0IGjA8EZf8YBnEsZSd2lkcZsCu?=
 =?us-ascii?Q?dUigtnQaRzHbRlHnnmL2EiIcpunEfZORCYU54REGEKHCxXkqgUwBpD2Kg/8T?=
 =?us-ascii?Q?4Uc6D6hKnsxUKvmul/pGVPO4nOwPWI8QHnq7DiBTEspZ7W63uncbzodNk/+H?=
 =?us-ascii?Q?E+D1J1aoZbS76vHWva0rutqG5Aj1fH71UabpZuNyVafpvdZwlDkOT5kMAL3M?=
 =?us-ascii?Q?KZuQS/IJvggbG69rmEjXMWg0QllMCme3BuGdlo6TSGNeBfBjHFeDAdGEmSMl?=
 =?us-ascii?Q?+Ge9bM5HUeB/GW6BUpQ5tMN1nmAIMBIZY81yYLq+79Ve+T98OnkevqKHZVKw?=
 =?us-ascii?Q?c3+igq9hp1gJnF6JRWIX8iXQA5TgmA4ebDCQ8i4bP6LKlOUTj8CgaVXMsC+j?=
 =?us-ascii?Q?T99OJbyIB8tnxcfSDJlFGs0V67X5E5tvT7Ee+F4uGkUDUrOhsCeZSflUgKTZ?=
 =?us-ascii?Q?XbVxwt9u62qbLoS8za9VMuXovi96lh9D71Fz4gEd8P0+o/r2OrtUq3LMF9aa?=
 =?us-ascii?Q?W8yXsrbbwrm5l7ji8eiEby+c5cinyfcLDIuBN/ir6xnpdUmzk3a+f9Ell675?=
 =?us-ascii?Q?Ae+rZDIVmaabImPhIDmR6iXXBVt9SB05GwplFjiKhd3iQbTKd/DrZQQ3pVHf?=
 =?us-ascii?Q?+8oFJtp3TqPekFbovgX251rIwdV/p9/I352mSFPyL0pAQw1ifSgqRhYtSMPa?=
 =?us-ascii?Q?A2vrcrwD72Wk0ibEmkHXfxe6Wr8ynV7TqUIqwnfBizNH639fD0R6b/488Dab?=
 =?us-ascii?Q?b1VWosuelySMOZ5zuNTEl2Ea9p2V1VHUYQrrhS6AzP0YNnh26TRhuPKGJJzz?=
 =?us-ascii?Q?chOkU2DW9ZEHoTrO+D/JLqb6YwXee0/Q6IOkIqyjo5deCmHB2iVbCKZlLL6/?=
 =?us-ascii?Q?QueJUgp2TMBWdT8KkG4eNBIXiuk3UzHadn3fJ6JChhgpwRRI+kLVG8vn8IO/?=
 =?us-ascii?Q?hG0Zw5+QM48RQfjF0p0KH461iCBThm5eFtz1DDPPcmNQZV1xY9NGll81QafF?=
 =?us-ascii?Q?bmVYddjSjStF2l27QNQKz6i9oowIcmmIFpMuToGaHbFw+D9375NzjntEYuk4?=
 =?us-ascii?Q?XBpD/oArQTrL2dQFXirXMkkolf8YgunNxPSGM7vzVNf5opxyOb77/XCpsQ6w?=
 =?us-ascii?Q?qQjXjav1pCVM4H2KedC3HZUFnhElwJRaUWuTU0yGtUZwk6055N28FKWHs+mG?=
 =?us-ascii?Q?gwmrF0h7fL+0hpQwqsz+HNAf3Xb7NWgm0fvUk7868SZ+kGfvVd2zM8F7/rJ3?=
 =?us-ascii?Q?dp/I0NkxJjnp77x11byGMidgQMmO3bDc2bvSZ39R2q7fKDYvwx79zMz/btYV?=
 =?us-ascii?Q?rzomLqrftvhqjFRRqnjI92Nq3FiWvQd9hKaYVLbuhG0sah3NjLL1c1JtUT7t?=
 =?us-ascii?Q?yEoPliQvo13G9VVGtpHkoFcImQGKS5j5MzGGQ3Cw6s9gc0Xl5H6+aZQq0+EX?=
 =?us-ascii?Q?+CGBAaxcQq5P0MNzzJKQb95OhpNbia3wRecfEWqRarcgzZWZKAAn7T4kfwOK?=
 =?us-ascii?Q?pqedMNb2NTnq/RJlpwcJnIRsZv3vCGVip+jzRUNco/pGQDBteTSfEmoTLqG4?=
 =?us-ascii?Q?nR4tYLXJh6KcBCwvTUjlBDjJGXLrVctJqC6VX7bGJ2FfXRBidEDIPihqIswO?=
 =?us-ascii?Q?u6uoCQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53492aa7-ed12-4d2a-c4a9-08d9aea4cb26
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 17:15:05.4451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qOra8OzZ1qzl4uDv+Uqevz5sK8v2xfxSnG8vFqHfIOM0Oy922aI0mTzsdUUVDZVH/Wnt8KuFdM80KvCyac4asMKfi1SHXugr+JXT1telu3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Tuesday, November 23, 2021 6:3=
1 AM
>=20
> In Isolation VM with AMD SEV, bounce buffer needs to be accessed via
> extra address space which is above shared_gpa_boundary (E.G 39 bit
> address line) reported by Hyper-V CPUID ISOLATION_CONFIG. The access
> physical address will be original physical address + shared_gpa_boundary.
> The shared_gpa_boundary in the AMD SEV SNP spec is called virtual top of
> memory(vTOM). Memory addresses below vTOM are automatically treated as
> private while memory above vTOM is treated as shared.
>=20
> Expose swiotlb_unencrypted_base for platforms to set unencrypted
> memory base offset and platform calls swiotlb_update_mem_attributes()
> to remap swiotlb mem to unencrypted address space. memremap() can
> not be called in the early stage and so put remapping code into
> swiotlb_update_mem_attributes(). Store remap address and use it to copy
> data from/to swiotlb bounce buffer.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v1:
> 	* Rework comment in the swiotlb_init_io_tlb_mem()
> 	* Make swiotlb_init_io_tlb_mem() back to return void.
> ---
>  include/linux/swiotlb.h |  6 +++++
>  kernel/dma/swiotlb.c    | 53 +++++++++++++++++++++++++++++++++++++----
>  2 files changed, 54 insertions(+), 5 deletions(-)
>=20
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index 569272871375..f6c3638255d5 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -73,6 +73,9 @@ extern enum swiotlb_force swiotlb_force;
>   * @end:	The end address of the swiotlb memory pool. Used to do a quick
>   *		range check to see if the memory was in fact allocated by this
>   *		API.
> + * @vaddr:	The vaddr of the swiotlb memory pool. The swiotlb memory pool
> + *		may be remapped in the memory encrypted case and store virtual
> + *		address for bounce buffer operation.
>   * @nslabs:	The number of IO TLB blocks (in groups of 64) between @start=
 and
>   *		@end. For default swiotlb, this is command line adjustable via
>   *		setup_io_tlb_npages.
> @@ -92,6 +95,7 @@ extern enum swiotlb_force swiotlb_force;
>  struct io_tlb_mem {
>  	phys_addr_t start;
>  	phys_addr_t end;
> +	void *vaddr;
>  	unsigned long nslabs;
>  	unsigned long used;
>  	unsigned int index;
> @@ -186,4 +190,6 @@ static inline bool is_swiotlb_for_alloc(struct device=
 *dev)
>  }
>  #endif /* CONFIG_DMA_RESTRICTED_POOL */
>=20
> +extern phys_addr_t swiotlb_unencrypted_base;
> +
>  #endif /* __LINUX_SWIOTLB_H */
> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index 8e840fbbed7c..c303fdeba82f 100644
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
> @@ -155,6 +158,31 @@ static inline unsigned long nr_slots(u64 val)
>  	return DIV_ROUND_UP(val, IO_TLB_SIZE);
>  }
>=20
> +/*
> + * Remap swioltb memory in the unencrypted physical address space
> + * when swiotlb_unencrypted_base is set. (e.g. for Hyper-V AMD SEV-SNP
> + * Isolation VMs).
> + */
> +void *swiotlb_mem_remap(struct io_tlb_mem *mem, unsigned long bytes)
> +{
> +	void *vaddr;
> +
> +	if (swiotlb_unencrypted_base) {
> +		phys_addr_t paddr =3D mem->start + swiotlb_unencrypted_base;
> +
> +		vaddr =3D memremap(paddr, bytes, MEMREMAP_WB);
> +		if (!vaddr) {
> +			pr_err("Failed to map the unencrypted memory %llx size %lx.\n",
> +			       paddr, bytes);
> +			return NULL;
> +		}
> +
> +		return vaddr;
> +	}
> +
> +	return phys_to_virt(mem->start);
> +}
> +
>  /*
>   * Early SWIOTLB allocation may be too early to allow an architecture to
>   * perform the desired operations.  This function allows the architectur=
e to
> @@ -172,7 +200,14 @@ void __init swiotlb_update_mem_attributes(void)
>  	vaddr =3D phys_to_virt(mem->start);
>  	bytes =3D PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
>  	set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
> -	memset(vaddr, 0, bytes);
> +
> +	mem->vaddr =3D swiotlb_mem_remap(mem, bytes);
> +	if (!mem->vaddr) {
> +		pr_err("Fail to remap swiotlb mem.\n");
> +		return;
> +	}
> +
> +	memset(mem->vaddr, 0, bytes);
>  }

In the error case, do you want to leave mem->vaddr as NULL?  Or is it
better to leave it as the virtual address of mem-start?  Your code leaves i=
t
as NULL.

The interaction between swiotlb_update_mem_attributes() and the helper
function swiotlb_memo_remap() seems kind of clunky.  phys_to_virt() gets ca=
lled
twice, for example, and two error messages are printed.  The code would be
more straightforward by just putting the helper function inline:

mem->vaddr =3D phys_to_virt(mem->start);
bytes =3D PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
set_memory_decrypted((unsigned long)(mem->vaddr), bytes >> PAGE_SHIFT);

if (swiotlb_unencrypted_base) {
	phys_addr_t paddr =3D mem->start + swiotlb_unencrypted_base;

	mem->vaddr =3D memremap(paddr, bytes, MEMREMAP_WB);
	if (!mem->vaddr) {
		pr_err("Failed to map the unencrypted memory %llx size %lx.\n",
			       paddr, bytes);
		return;
	}
}

memset(mem->vaddr, 0, bytes);

(This version also leaves mem->vaddr as NULL in the error case.)

>=20
>  static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t =
start,
> @@ -196,7 +231,18 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_me=
m *mem, phys_addr_t start,
>  		mem->slots[i].orig_addr =3D INVALID_PHYS_ADDR;
>  		mem->slots[i].alloc_size =3D 0;
>  	}
> +
> +	/*
> +	 * If swiotlb_unencrypted_base is set, the bounce buffer memory will
> +	 * be remapped and cleared in swiotlb_update_mem_attributes.
> +	 */
> +	if (swiotlb_unencrypted_base)
> +		return;
> +
> +	set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);

Prior to this patch, and here in the new version as well, the return value =
from
set_memory_decrypted() is ignored in several places in this file.  As previ=
ously
discussed, swiotlb_init_io_tlb_mem() is a void function, so there's no plac=
e to
return an error. Is that OK?

>  	memset(vaddr, 0, bytes);
> +	mem->vaddr =3D vaddr;
> +	return;
>  }
>=20
>  int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int ve=
rbose)
> @@ -318,7 +364,6 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long n=
slabs)
>  	if (!mem->slots)
>  		return -ENOMEM;
>=20
> -	set_memory_decrypted((unsigned long)tlb, bytes >> PAGE_SHIFT);
>  	swiotlb_init_io_tlb_mem(mem, virt_to_phys(tlb), nslabs, true);
>=20
>  	swiotlb_print_info();
> @@ -371,7 +416,7 @@ static void swiotlb_bounce(struct device *dev, phys_a=
ddr_t tlb_addr, size_t size
>  	phys_addr_t orig_addr =3D mem->slots[index].orig_addr;
>  	size_t alloc_size =3D mem->slots[index].alloc_size;
>  	unsigned long pfn =3D PFN_DOWN(orig_addr);
> -	unsigned char *vaddr =3D phys_to_virt(tlb_addr);
> +	unsigned char *vaddr =3D mem->vaddr + tlb_addr - mem->start;
>  	unsigned int tlb_offset, orig_addr_offset;
>=20
>  	if (orig_addr =3D=3D INVALID_PHYS_ADDR)
> @@ -806,8 +851,6 @@ static int rmem_swiotlb_device_init(struct reserved_m=
em *rmem,
>  			return -ENOMEM;
>  		}
>=20
> -		set_memory_decrypted((unsigned long)phys_to_virt(rmem->base),
> -				     rmem->size >> PAGE_SHIFT);
>  		swiotlb_init_io_tlb_mem(mem, rmem->base, nslabs, false);
>  		mem->force_bounce =3D true;
>  		mem->for_alloc =3D true;
> --
> 2.25.1

