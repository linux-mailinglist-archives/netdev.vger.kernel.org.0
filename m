Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADA93FE7B4
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 04:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243101AbhIBCf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 22:35:27 -0400
Received: from mail-oln040093008007.outbound.protection.outlook.com ([40.93.8.7]:25197
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229679AbhIBCf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 22:35:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCx04av9Xh77Ekv4nMdxj0EWuugkjJrPzsF+MpmbIaRcQvM+RxnE3gxDGupHQtUqDAwH69IrhLnYRqRtsE0dyrAMuhQbdUUSTCf8jLuL8Y/ajPuKCgslBJYAaOhyjsJ9aAb0woCKZt8knhURMmLjSAgct2Pherw8Q+qZ5AwQ4XRyNOMOU6ODl4lZhnAlBjvNMLGMWnF89eQIt/TcWCU6iRRvm8BpiSy1zsKr/ei4C6rkMxjTJpoqxj2ik0Y5vuPX64oRCvbKgmYgU+y4LGqpA9mu6ASDNNdDh86jFkGm9q+k3Qpy0qXgEB2oztT1+iFxNGuYbKxaQ9du/ld91anWWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=QKy56hNGj4/CPd4BTTIQaQKfTgUrKi7AodsQzErWTDY=;
 b=iIgSUeLqi9iUloQ1Cc5dm0nvKICmqky/SvABYtH+RfK9BRa8NCOM1G1bcKlpL5O39rmq9UG6FTPeLJWthPU/Yu3V2RXHJBdltqOxmW+RkIur9uNtWcXxLP325q++G7IM1IGslVgaA6ajgXsNlSXYesLJeme/UqaQTgkYmnCxTgp1NRWU5vuGG1m4rdFsjugqQRVOf+6blEBNe/vHPbyFrHE/Gd00tTuCl7CPuN1Bun+hya4bTeD9Gx2Tgv8xySjHvNho2+JzL1C5xisdBEOv6bCNzjFwLv0Q5D3dNaWugkI9uXwjg8SLXNlv/VWVMiCc0eIDUelM3ddYuwFY3Vi16w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKy56hNGj4/CPd4BTTIQaQKfTgUrKi7AodsQzErWTDY=;
 b=IpmkJTL5nBImCGGLSxRDJrrQor9sZgWdUpecAJfxBth+eYiOc/0sRoJ+IYAN0DbwJjuStPeTlMIvhX8QXnwhdKMBhr//AjVAPIMo9LeKKWrjwAKUhkp+U7ZPavc14xU/3VaEJ3eGEMjkYoUB9BUAxvdziaUyBK9w7C9Ni1z6AfI=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by CO1PR21MB1313.namprd21.prod.outlook.com (2603:10b6:303:150::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.1; Thu, 2 Sep
 2021 02:34:21 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86%8]) with mapi id 15.20.4478.014; Thu, 2 Sep 2021
 02:34:21 +0000
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
Subject: RE: [PATCH V4 12/13] hv_netvsc: Add Isolation VM support for netvsc
 driver
Thread-Topic: [PATCH V4 12/13] hv_netvsc: Add Isolation VM support for netvsc
 driver
Thread-Index: AQHXm2gP6jy1GRuc+0K7S1qphPLgHKuQCC+w
Date:   Thu, 2 Sep 2021 02:34:21 +0000
Message-ID: <MWHPR21MB1593CD9E7B545EF5A268B745D7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210827172114.414281-13-ltykernel@gmail.com>
In-Reply-To: <20210827172114.414281-13-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=24c2ad3d-af1e-4524-bef7-f93352ae7e8f;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-02T02:09:02Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 689d41b7-625c-4abb-a483-08d96dba2bc1
x-ms-traffictypediagnostic: CO1PR21MB1313:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CO1PR21MB1313A834F78F6B030DD374F0D7CE9@CO1PR21MB1313.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DAvZwmqwIU8z/VumI40sOIsAL8kY1QtKrD+eDOHx9Sz3XiadoCQcQobAFINlK3ApTacKo8PgaJfemchgf+GLNMTzHG08fpXiUrfUe4MJhuvMfdnT1kVSw5KOvrIgS3Enl8VZRwxQZlc5eqGhZRrc91vSx4ZB1ndPjIbuTF5x1+aDRwIIpA3GIRUSG8aiY1FFeDoVtrLRXMFBR/btQtBEY0xtLlHSGYC0nrfFdB4IWF+KYdBrF6pNpTZ3X+pY46fkK5md+aPJH6u6vM2TedUR+POIxPEbakPeeEj1/11JEYFI1FsNs87RKncViF2p4tSDV+P1sJ+7kjtVyaWCDS++zFv3/nfIYeay1/CT7rQ1fb9Vf8DZZZ4zBksxwXXtIC4jyWB/waxNHcN0mtI1DW393SpXA4a68MkCFUFk80JrGNfxEpTaC3FDP7hp14VoRMrSBP9sLWrC/hBDa0x8dF0kz3VCtUUlG8RS1ScK7vBzRfVSCPf7NC5niNrBGW09242FijzSE1spD5qKJ/Cod1nM74Rd55ec3fewa5tk2e1rHForKqOY9R6KucRXhvWBSVfkaf1BFKJXBXR/UO6ZMAXgQd7PfZn63JE2JEhrSRa5xjcclApHQTb+dJLtofa4MxMxZFkAS0A1QWKtgGUay2+aPJtmedGp8qa9f8FjG84Nt2Mo3B8CRCJAaSO5tLH92WwiMRVgXAeNrx7eVrHnbv0CiEt1tZGqCXCl6GS6IX3dGoI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(86362001)(76116006)(5660300002)(66946007)(186003)(54906003)(30864003)(921005)(66476007)(66556008)(64756008)(66446008)(7416002)(7366002)(7406005)(52536014)(2906002)(82960400001)(6506007)(316002)(82950400001)(9686003)(55016002)(8936002)(8990500004)(83380400001)(38100700002)(10290500003)(38070700005)(122000001)(8676002)(4326008)(508600001)(33656002)(7696005)(110136005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xQlDpLVHR5QkNC1X7tRB4TxveZLJaQS1hw8CRJaKaAeeVaMhzp7LecYMifJh?=
 =?us-ascii?Q?s5wS2OsCPzuMHkmVRyjamNhZzwzDFRCeqRMAR3jtBg35DVJj1poV5cOfp0rd?=
 =?us-ascii?Q?OaN1z64LV+DT7xaTzo6vwp1wM7tIMQDoQ/YrK4+qjE4kXlRb62jCDIaaMlp9?=
 =?us-ascii?Q?8Ua0ik61reSOxctXQRuhxfeg2YidtdLKlzQZ+t6pSjN1S+GYNj6pJTcHr28x?=
 =?us-ascii?Q?9neCEGMaxMdhzndRPEvsqXou36pCHJKKzsGZnqaBxyIZ33ogDCQPqTyQaR0p?=
 =?us-ascii?Q?PJ/x+dRxTeSEWn8pJG/Hw8ygZVgc/YbqQLnkqBqBx8MjI9rJQMH9i5bcBSKv?=
 =?us-ascii?Q?AVh5p0g4KtSU54zj5Y4MjEoejzQfRvrdnqc9dCPWoPSCQr+DaKvIlV0Eusqm?=
 =?us-ascii?Q?VCipJ6alCUyB0ZpoB1AuH/fdqRrDEPoqAg2L/LZS199pA3MKCpjawD0UvIwj?=
 =?us-ascii?Q?MDwDxXvdfP6fkYJkpOs/xp4juA1fjtK9/Xr00TtC/TCULrcdCZ+a8fgK5DHp?=
 =?us-ascii?Q?K01HOwCJv608Ei39PuKX7T4v9A66WRGVcPoKDmCFDIqY0B0pVow7DKHCyHcp?=
 =?us-ascii?Q?61coUmemBmab6FzEIqyl5NACtoTvNJ9EyJP87A25QbCGTQibvQqk2rQM72NV?=
 =?us-ascii?Q?hDyGrG36RGqhhwoz2x0+pnu9biZOXlPjdnR+vLKN1NnfQl3yndjmPNRPsWyJ?=
 =?us-ascii?Q?z2yTjCswKMEME9zgqj72S79oxR8MAriVHWa21DSgkEJf5mulLWmK+3VoOhzT?=
 =?us-ascii?Q?+81GIePqODB1bMvXwzZjcd9Mw9WC5e0nnN9Gdt0g+Cqxz5HhTgCa/QdT8jb6?=
 =?us-ascii?Q?oMsXTvJ0zSAdhIVaHNMSsQ3r96c70O/EdlfunILaVpe9qV4UiUCnLXqQyqh6?=
 =?us-ascii?Q?8edXaMRqY6yOVkO6cjqi56xS3yD/wknEDIgPsoGLaJwlkf/lbRYx9M6iEUaH?=
 =?us-ascii?Q?cPWqL/u5F2i7eTpFSUUr3SfjGml4N/kFgfitpqe+ao0yOICH/K7iBqmg1CR+?=
 =?us-ascii?Q?Bj31b1hZtq4+AT+CCoq7seB3RTGKm7mKeV2OsOiRIHosYa/YN8adSNOZCNHg?=
 =?us-ascii?Q?DjiWfF2ofh+FvH0LArOcrWLTEIzJb7m68dvsF+1DeZsC4wTbxvbAFTu55oXy?=
 =?us-ascii?Q?v0KEB91O0Y8nsNzG9sFdzXT4fhghv6KcBHdWKq3dCbmRKwFqA+VvclfLKu8+?=
 =?us-ascii?Q?1UPzihMFvB19heOQB3gd20WEVh8tjULPLwtcN0QiejgDUz9oWj6Z+K8cOtyk?=
 =?us-ascii?Q?aXwtJHgUnv9id+DTfgkwUQ4F8T7W75VIFSTBxSpfPEetmFIFAY+EWrIgzc6c?=
 =?us-ascii?Q?6l+C3cUDAdMMToQg9hUG9EFd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 689d41b7-625c-4abb-a483-08d96dba2bc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 02:34:21.2342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g08ziwEqEgDWZKHJyOVnRnVS6cDO5fPg8rfoY4T/qM5/GwGsBOZ+r3nX6j9fGc5D+JukmU5NjK7Zmkh8voCMtGf2u1QtxeKzRuqBo/ZDvrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR21MB1313
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Friday, August 27, 2021 10:21 =
AM
>=20
> In Isolation VM, all shared memory with host needs to mark visible
> to host via hvcall. vmbus_establish_gpadl() has already done it for
> netvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
> pagebuffer() stills need to be handled. Use DMA API to map/umap
> these memory during sending/receiving packet and Hyper-V swiotlb
> bounce buffer dma adress will be returned. The swiotlb bounce buffer
> has been masked to be visible to host during boot up.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v3:
> 	* Add comment to explain why not to use dma_map_sg()
> 	* Fix some error handle.
> ---
>  arch/x86/hyperv/ivm.c             |   1 +
>  drivers/net/hyperv/hyperv_net.h   |   5 ++
>  drivers/net/hyperv/netvsc.c       | 135 +++++++++++++++++++++++++++++-
>  drivers/net/hyperv/rndis_filter.c |   2 +
>  include/linux/hyperv.h            |   5 ++
>  5 files changed, 145 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
> index 84563b3c9f3a..08d8e01de017 100644
> --- a/arch/x86/hyperv/ivm.c
> +++ b/arch/x86/hyperv/ivm.c
> @@ -317,6 +317,7 @@ void *hv_map_memory(void *addr, unsigned long size)
>=20
>  	return vaddr;
>  }
> +EXPORT_SYMBOL_GPL(hv_map_memory);
>=20
>  void hv_unmap_memory(void *addr)
>  {
> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_=
net.h
> index aa7c9962dbd8..862419912bfb 100644
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
> @@ -1074,6 +1075,7 @@ struct netvsc_device {
>=20
>  	/* Receive buffer allocated by us but manages by NetVSP */
>  	void *recv_buf;
> +	void *recv_original_buf;
>  	u32 recv_buf_size; /* allocated bytes */
>  	u32 recv_buf_gpadl_handle;
>  	u32 recv_section_cnt;
> @@ -1082,6 +1084,7 @@ struct netvsc_device {
>=20
>  	/* Send buffer allocated by us */
>  	void *send_buf;
> +	void *send_original_buf;
>  	u32 send_buf_size;
>  	u32 send_buf_gpadl_handle;
>  	u32 send_section_cnt;
> @@ -1731,4 +1734,6 @@ struct rndis_message {
>  #define RETRY_US_HI	10000
>  #define RETRY_MAX	2000	/* >10 sec */
>=20
> +void netvsc_dma_unmap(struct hv_device *hv_dev,
> +		      struct hv_netvsc_packet *packet);
>  #endif /* _HYPERV_NET_H */
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index f19bffff6a63..edd336b08c2c 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -153,8 +153,21 @@ static void free_netvsc_device(struct rcu_head *head=
)
>  	int i;
>=20
>  	kfree(nvdev->extension);
> -	vfree(nvdev->recv_buf);
> -	vfree(nvdev->send_buf);
> +
> +	if (nvdev->recv_original_buf) {
> +		vunmap(nvdev->recv_buf);

In patch 11, you have added a hv_unmap_memory()
function as the inverse of hv_map_memory().  Since this
buffer was mapped with hv_map_memory() and you have
added that function, the cleanup should use
hv_unmap_memory() rather than calling vunmap() directly.

> +		vfree(nvdev->recv_original_buf);
> +	} else {
> +		vfree(nvdev->recv_buf);
> +	}
> +
> +	if (nvdev->send_original_buf) {
> +		vunmap(nvdev->send_buf);

Same here.

> +		vfree(nvdev->send_original_buf);
> +	} else {
> +		vfree(nvdev->send_buf);
> +	}
> +
>  	kfree(nvdev->send_section_map);
>=20
>  	for (i =3D 0; i < VRSS_CHANNEL_MAX; i++) {
> @@ -347,6 +360,7 @@ static int netvsc_init_buf(struct hv_device *device,
>  	unsigned int buf_size;
>  	size_t map_words;
>  	int i, ret =3D 0;
> +	void *vaddr;
>=20
>  	/* Get receive buffer area. */
>  	buf_size =3D device_info->recv_sections * device_info->recv_section_siz=
e;
> @@ -382,6 +396,17 @@ static int netvsc_init_buf(struct hv_device *device,
>  		goto cleanup;
>  	}
>=20
> +	if (hv_isolation_type_snp()) {
> +		vaddr =3D hv_map_memory(net_device->recv_buf, buf_size);

Since the netvsc driver is architecture neutral, this code also needs
to compile for ARM64.  A stub will be needed for hv_map_memory()
on the ARM64 side.  Same for hv_unmap_memory() as suggested
above.  Or better, move hv_map_memory() and hv_unmap_memory()
to an architecture neutral module such as hv_common.c.

Or if Christop's approach of creating the vmap_phys_addr() helper
comes to fruition, that's an even better approach since it will already
handle multiple architectures.

> +		if (!vaddr) {
> +			ret =3D -ENOMEM;
> +			goto cleanup;
> +		}
> +
> +		net_device->recv_original_buf =3D net_device->recv_buf;
> +		net_device->recv_buf =3D vaddr;
> +	}
> +
>  	/* Notify the NetVsp of the gpadl handle */
>  	init_packet =3D &net_device->channel_init_pkt;
>  	memset(init_packet, 0, sizeof(struct nvsp_message));
> @@ -485,6 +510,17 @@ static int netvsc_init_buf(struct hv_device *device,
>  		goto cleanup;
>  	}
>=20
> +	if (hv_isolation_type_snp()) {
> +		vaddr =3D hv_map_memory(net_device->send_buf, buf_size);
> +		if (!vaddr) {
> +			ret =3D -ENOMEM;
> +			goto cleanup;
> +		}
> +
> +		net_device->send_original_buf =3D net_device->send_buf;
> +		net_device->send_buf =3D vaddr;
> +	}
> +
>  	/* Notify the NetVsp of the gpadl handle */
>  	init_packet =3D &net_device->channel_init_pkt;
>  	memset(init_packet, 0, sizeof(struct nvsp_message));
> @@ -775,7 +811,7 @@ static void netvsc_send_tx_complete(struct net_device=
 *ndev,
>=20
>  	/* Notify the layer above us */
>  	if (likely(skb)) {
> -		const struct hv_netvsc_packet *packet
> +		struct hv_netvsc_packet *packet
>  			=3D (struct hv_netvsc_packet *)skb->cb;
>  		u32 send_index =3D packet->send_buf_index;
>  		struct netvsc_stats *tx_stats;
> @@ -791,6 +827,7 @@ static void netvsc_send_tx_complete(struct net_device=
 *ndev,
>  		tx_stats->bytes +=3D packet->total_bytes;
>  		u64_stats_update_end(&tx_stats->syncp);
>=20
> +		netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
>  		napi_consume_skb(skb, budget);
>  	}
>=20
> @@ -955,6 +992,87 @@ static void netvsc_copy_to_send_buf(struct netvsc_de=
vice *net_device,
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
> + * to bounce buffer's pfn. The loop here is necessary becuase the

s/becuase/because/

> + * entries in the page buffer array are not necessarily full
> + * pages of data.  Each entry in the array has a separate offset and
> + * len that may be non-zero, even for entries in the middle of the
> + * array.  And the entries are not physically contiguous.  So each
> + * entry must be individually mapped rather than as a contiguous unit.
> + * So not use dma_map_sg() here.
> + */
> +int netvsc_dma_map(struct hv_device *hv_dev,
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
> +		pb[i].len =3D len;
> +	}

Just to confirm, this driver does *not* set the DMA min_align_mask
like storvsc does.  So after the call to dma_map_single(), the offset
in the page could be different.  That's why you are updating
the pb[i].offset value.  Alternatively, you could set the DMA
min_align_mask, which would ensure the offset is unchanged.
I'm OK with either approach, though perhaps a comment is
warranted to explain, as this is a subtle issue.

> +
> +	return 0;
> +}
> +
>  static inline int netvsc_send_pkt(
>  	struct hv_device *device,
>  	struct hv_netvsc_packet *packet,
> @@ -995,14 +1113,24 @@ static inline int netvsc_send_pkt(
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
> @@ -1010,6 +1138,7 @@ static inline int netvsc_send_pkt(
>  				       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
>  	}
>=20
> +exit:
>  	if (ret =3D=3D 0) {
>  		atomic_inc_return(&nvchan->queue_sends);
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
> index 724a735d722a..139a43ad65a1 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1596,6 +1596,11 @@ struct hyperv_service_callback {
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

