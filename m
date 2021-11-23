Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366A245AA9D
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239430AbhKWR7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:59:05 -0500
Received: from mail-cusazlp17010007.outbound.protection.outlook.com ([40.93.13.7]:43300
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234200AbhKWR7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 12:59:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GwG4/SFffNQkdljJgKDFCtBVrtn/YvjVX7GMAe4nYBx1vM6PE/tPN//KBfKdpPK7d2At/cjoEvUjyj7Biq9HlyUPOcexltbg83U7+02YuxuUM+jOtZjeNnEbNRHoSu+wuXodsn17DzymjlkaliQaCH2+LBBuVqmtzkNPkXt0UIB5lJ1y/ZCxnZ9z4TzQsaZrS8M5+ceH7uxxko3Y/YsOlKYpGlar0C+kXLK0n7AelbPvz2d2gWD/A6qamiFs/ibWasn+e2jXIuUmbQ+W032mbb5pDejRdF6z/UfWu+ztxvms8O7u3DPYZvif1vFBeVlwvGmkLqNeN8u2j5AqNYYh0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TbaHwqX0avxNS6HNpAIGUAI2NHTK78YDNolrUCewJk4=;
 b=nWAhJHciwZa0MCxLhCaoARzPGTir7g9Pg7gSQgPC39JnyLaRefU5V84cQ6cNX9i4LufTwhuIA7r616cN4srCkbJ/l6rN9jgR0xlqZBtxqkNvnETwHdrCpfk65ayj9JjIRkkdTwau9FbkI2zqYEtcRryMrMNJTE2SWbMHRkVrR6Qmp+to5FYOcc0Bz4gnZ9kPFMkWK8PdOevuaJhtWWTUCcezRYU+BMQrgliUtl/hHhWcgqtB0VhuBdQwwg1Y6Z21KSRD7TbeUHazrSHazzfUj2uCIwn++y9YBdaAOcUpJhMW/q8ja/Nuhjx7X0h4iUzXBMny62QhMMV1T0bsbsiGbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TbaHwqX0avxNS6HNpAIGUAI2NHTK78YDNolrUCewJk4=;
 b=QGfmY/jzR6gNK3OcPJlEyFn4xuRncqxInnk07VbUAP0xJgdu6X2LI9UvT2Wi+NG8rPugNX2G2YDmFmtGQ0SG6iNewBf/7xGxKPierTHAOu3LBWgbSKqDRJeqFKtTCwxodhFslf1ApTxN5YifBlm+8K1u4XOolxAexGnGPAMFbcg=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0765.namprd21.prod.outlook.com (2603:10b6:300:76::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.5; Tue, 23 Nov
 2021 17:55:51 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9401:9c8b:c334:4336]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9401:9c8b:c334:4336%2]) with mapi id 15.20.4755.001; Tue, 23 Nov 2021
 17:55:51 +0000
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
Subject: RE: [PATCH V2 5/6] net: netvsc: Add Isolation VM support for netvsc
 driver
Thread-Topic: [PATCH V2 5/6] net: netvsc: Add Isolation VM support for netvsc
 driver
Thread-Index: AQHX4HeYtAEila+YgkS3X1o35FDXYawRY0/A
Date:   Tue, 23 Nov 2021 17:55:51 +0000
Message-ID: <MWHPR21MB1593FF92E42C1FD3C2755A51D7609@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20211123143039.331929-1-ltykernel@gmail.com>
 <20211123143039.331929-6-ltykernel@gmail.com>
In-Reply-To: <20211123143039.331929-6-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8c587921-095f-437c-878b-5459b0780a1b;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-11-23T17:47:02Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff17ca19-2b73-421c-fb36-08d9aeaa7cf8
x-ms-traffictypediagnostic: MWHPR21MB0765:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB0765E5743852AA26495F1037D7609@MWHPR21MB0765.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:49;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6MLiwjMXjDImKq1Tdkn2A7C4ntEWBKASZwiXxpgmRfPRqio3qJHUfRl8pVA5kWV97Lx+7B+p1xP1c22I0E5uz4YRkf+6tu1LV28RysARM1Qn2FL/I/SWCmRrdi3gAQXY71rU+7WbDAgDJYVax1ornuvXdH+ZPTciYOjs/a1L7yjenZkrJZUW+WSl2XdHiEQYI37o1bB/muPbzMYpS499wJuOKbwJ90y9Q+BiaDXhK49fnYVfEwRUZGp1Seri7nVa4pTgn9/mwYFU3kMqjbXrVuMidSUq7mWpxd1Cj+MYLAzpu/N+LArjrJ3Ae+NyuCKTUwgTpA70Rn3lR3MH/QPsFc/eu2NgQ5A3WGdPSgP2qhjK1HAgcHTaMsfzAiUP3lYZesD3OA3enUuLah4qcYrA3dQxBGy7p5bvHxJP0YyDUmIAIgdi0Kp7hKRuhgydHVLDkFPrFXgyJRHu+hd6eR4/JEZOfXPzzgAVtrv14q81Q2Z9LKon+nfSWS1yt9DwaQEhjP3LWzERyqUKVqhwteJhNhrKgOXYUosO49BCuQN4BGoK4gU8s1msQOJtRNlmv1JhaQaRxSSbLXMKXQFrsdJyFbMMYJJhhdfOFK0MGcv+zS86eIb/UkCDTbydIgxjykx5oig7evYoJXiAhCbl5B1e4xD+D+0jaLQnY+FoOBukwVOzckb5CxNlhEF4EVdF9/hmwC025VFe3t90Mdf7Q5o+WnsfZ3YTXbGhT4rwqtYOibDMyWZOx1JYNkGb7F9suDkPJyM0xqrkPU09pH8apcpWcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(9686003)(76116006)(10290500003)(83380400001)(6506007)(86362001)(66476007)(33656002)(71200400001)(82960400001)(122000001)(8936002)(508600001)(82950400001)(5660300002)(54906003)(66556008)(110136005)(7406005)(316002)(66446008)(4326008)(64756008)(52536014)(7696005)(55016003)(8676002)(30864003)(7416002)(26005)(921005)(2906002)(186003)(8990500004)(38070700005)(38100700002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/OsyLH6Ky6hjl6tVEfesjr8Gg8NZvRYJeTnmLoquMniwyRFP47ad2nIReqnv?=
 =?us-ascii?Q?hEUImw5afN2QKZiwW3kPBbJb147u5j9Eor4rLCYzMRzlwgiF8ih7xnZyks1i?=
 =?us-ascii?Q?BtS+eFsI2dXa4nM2Wd2vcCjmXAN6+WTK8hOTlmqzw9y8Z5U+BhrN0KjXCcKa?=
 =?us-ascii?Q?M6/snITqCb5QMtXabj9L9uwwkFjb56CpXX6c+gzFqzhnpc36hYzSe6NEbtb8?=
 =?us-ascii?Q?bU4/EEU1OHWVKv0kPjX4/Sajpr79DPDSjYrAO75Ya4HSIYH7TVz8VN9LBEgV?=
 =?us-ascii?Q?PnVYqyPELR4OWh6JQ1bPsK4kj6rR9sTXVKtcsx5l5mfpLInBTM49T7m95iY3?=
 =?us-ascii?Q?yr4yUfT0pPaE5hvX2ooRFWNCwOjuf3HAYeRDNDxg+cs5ZjqhOTjU/E+jJBdg?=
 =?us-ascii?Q?fJJaIbOgApi9/Kp4KIMES25bm9b8mLCF0HgSPJTuIZnHchOYDpQIegwOWZgm?=
 =?us-ascii?Q?xF5pZbSVl3rUfOQDW6HDxfvNrze/S8bngSTTS0K36o8z/HvAp6tbaQ87NCwI?=
 =?us-ascii?Q?8uc5KCnVa0OAAJwjm24H/w5afEq6498S1ld95NNZtMJcXxVseS1eczWDPfy0?=
 =?us-ascii?Q?bQO9BQtU/kDKwbPPISouqdxYkAb/PTHANFBbtJBhPFsVWtDTDE08IGyFxSeQ?=
 =?us-ascii?Q?j7Vg4eZl1HNhaRqha7SXs6oEx9VYYO3+qLfpHloog6/+Jvye6mFJ3NjUaSkI?=
 =?us-ascii?Q?gg/5z/feAzB/4Cv9t1EXEY9aVC+6YxcTJFnoyl+xu3kaAIUCtn3+x5EwSxSh?=
 =?us-ascii?Q?rUvqZuES+Cib7ku6321gzh9J9Ls7n/TxmC+ouil8jRzNNALY/QabISg3xWi6?=
 =?us-ascii?Q?UG/+2a9QpnQOGwRxW2+oHudHoLgJM5JfYbwPYJuC6LQrfVFlAZ3uvBPdOP0j?=
 =?us-ascii?Q?e8jTDHItSqCUxzrQFaPPb5/dd8cIulxZHKtuGzQy8Dhv6n0Jb4R3MU0Hhxsf?=
 =?us-ascii?Q?mTbjENjL93KTdgMkEAZJjlSjZfuCLwhZCLOnEyTLJ7jbK3G9I8+GjvsvACPc?=
 =?us-ascii?Q?W/OR2QrpocuTm6ElpH/uYtn03J6tgr87M1XWB8Akv057U/jyHydJh3/Qdv8h?=
 =?us-ascii?Q?vISQmm+jwYcRVO41ihFZv3YQeakicq3XB5GShwNi6ZDJRfCJHy3emho/Loaj?=
 =?us-ascii?Q?TMGe4+qrdgvEpU1nu1y9lQIrZAyt8CNDHyouHYYdktHxhYaN7AsB6pEgpTOF?=
 =?us-ascii?Q?mCZmOlDVG1pO/0AL7mhOmuGKv8l2pDK3zUoxG+a45U2aiSEkcI94SXAUfjlg?=
 =?us-ascii?Q?16ZNjwlMOj9QDxw+lE0ULJNYtTsAhqUhlmyHnjgJQqM6qm7ZFXnvCKYNVf7a?=
 =?us-ascii?Q?sS6CJ5QbjFZNPUL/CVM6n2ZBr/XAMQT8NViLqeBEQLtp26lYqyj9mHajwpRK?=
 =?us-ascii?Q?rVj30q5SD1xCN4iFdvh2TS9dRRoAAwWyQYKObfvJmOpsX6ndteAt0XfK5502?=
 =?us-ascii?Q?GuQcrak/P65SrsPfS9bweGuBe6U7eRt9uwROrVZD1d/s8y3xHoKLwT9hfChh?=
 =?us-ascii?Q?ji2yMpmDkB/CKltZgmFAuO9I+bfShyCM3KxRJnwQDREjvs8/F9dXATAiHzDu?=
 =?us-ascii?Q?762R3OOlZa8SxRwdRSUz8zEKCyW/AEo2H5gJQ3oAg2RGOer8NT+O2s4VsOTU?=
 =?us-ascii?Q?AK7XsHqOaegFiS1sl2vd7yEozgmsgDA318zKJ5QZ4iqcBXJoBEty98Iosh7z?=
 =?us-ascii?Q?lsX6Wg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff17ca19-2b73-421c-fb36-08d9aeaa7cf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 17:55:51.2821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PuCxbiXSUPbQr2heZYAk+MiZ8yTShrrK0gL9Ud6n513pPB0u+WOIFgfV/NuAwR+gOOVgd2Ns0lQC/JhQn+zxH++s/lS/XF5fHfoibKUKrGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0765
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Tuesday, November 23, 2021 6:3=
1 AM
>=20
> In Isolation VM, all shared memory with host needs to mark visible
> to host via hvcall. vmbus_establish_gpadl() has already done it for
> netvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
> pagebuffer() stills need to be handled. Use DMA API to map/umap
> these memory during sending/receiving packet and Hyper-V swiotlb
> bounce buffer dma address will be returned. The swiotlb bounce buffer
> has been masked to be visible to host during boot up.
>=20
> Allocate rx/tx ring buffer via dma_alloc_noncontiguous() in Isolation
> VM. After calling vmbus_establish_gpadl() which marks these pages visible
> to host, map these pages unencrypted addes space via dma_vmap_noncontiguo=
us().
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  drivers/net/hyperv/hyperv_net.h   |   5 +
>  drivers/net/hyperv/netvsc.c       | 192 +++++++++++++++++++++++++++---
>  drivers/net/hyperv/rndis_filter.c |   2 +
>  include/linux/hyperv.h            |   6 +
>  4 files changed, 190 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_=
net.h
> index 315278a7cf88..31c77a00d01e 100644
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
> +	struct sg_table *recv_sgt;
>  	u32 recv_buf_size; /* allocated bytes */
>  	struct vmbus_gpadl recv_buf_gpadl_handle;
>  	u32 recv_section_cnt;
> @@ -1082,6 +1084,7 @@ struct netvsc_device {
>=20
>  	/* Send buffer allocated by us */
>  	void *send_buf;
> +	struct sg_table *send_sgt;
>  	u32 send_buf_size;
>  	struct vmbus_gpadl send_buf_gpadl_handle;
>  	u32 send_section_cnt;
> @@ -1731,4 +1734,6 @@ struct rndis_message {
>  #define RETRY_US_HI	10000
>  #define RETRY_MAX	2000	/* >10 sec */
>=20
> +void netvsc_dma_unmap(struct hv_device *hv_dev,
> +		      struct hv_netvsc_packet *packet);
>  #endif /* _HYPERV_NET_H */
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 396bc1c204e6..9cdc71930830 100644
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
> @@ -146,15 +147,39 @@ static struct netvsc_device *alloc_net_device(void)
>  	return net_device;
>  }
>=20
> +static struct hv_device *netvsc_channel_to_device(struct vmbus_channel *=
channel)
> +{
> +	struct vmbus_channel *primary =3D channel->primary_channel;
> +
> +	return primary ? primary->device_obj : channel->device_obj;
> +}
> +
>  static void free_netvsc_device(struct rcu_head *head)
>  {
>  	struct netvsc_device *nvdev
>  		=3D container_of(head, struct netvsc_device, rcu);
> +	struct hv_device *dev =3D
> +		netvsc_channel_to_device(nvdev->chan_table[0].channel);
>  	int i;
>=20
>  	kfree(nvdev->extension);
> -	vfree(nvdev->recv_buf);
> -	vfree(nvdev->send_buf);
> +
> +	if (nvdev->recv_sgt) {
> +		dma_vunmap_noncontiguous(&dev->device, nvdev->recv_buf);
> +		dma_free_noncontiguous(&dev->device, nvdev->recv_buf_size,
> +				       nvdev->recv_sgt, DMA_FROM_DEVICE);
> +	} else {
> +		vfree(nvdev->recv_buf);
> +	}
> +
> +	if (nvdev->send_sgt) {
> +		dma_vunmap_noncontiguous(&dev->device, nvdev->send_buf);
> +		dma_free_noncontiguous(&dev->device, nvdev->send_buf_size,
> +				       nvdev->send_sgt, DMA_TO_DEVICE);
> +	} else {
> +		vfree(nvdev->send_buf);
> +	}
> +
>  	kfree(nvdev->send_section_map);
>=20
>  	for (i =3D 0; i < VRSS_CHANNEL_MAX; i++) {
> @@ -348,7 +373,21 @@ static int netvsc_init_buf(struct hv_device *device,
>  		buf_size =3D min_t(unsigned int, buf_size,
>  				 NETVSC_RECEIVE_BUFFER_SIZE_LEGACY);
>=20
> -	net_device->recv_buf =3D vzalloc(buf_size);
> +	if (hv_isolation_type_snp()) {
> +		net_device->recv_sgt =3D
> +			dma_alloc_noncontiguous(&device->device, buf_size,
> +						DMA_FROM_DEVICE, GFP_KERNEL, 0);
> +		if (!net_device->recv_sgt) {
> +			pr_err("Fail to allocate recv buffer buf_size %d.\n.", buf_size);
> +			ret =3D -ENOMEM;
> +			goto cleanup;
> +		}
> +
> +		net_device->recv_buf =3D (void *)net_device->recv_sgt->sgl->dma_addres=
s;

Use sg_dma_address() macro.

> +	} else {
> +		net_device->recv_buf =3D vzalloc(buf_size);
> +	}
> +
>  	if (!net_device->recv_buf) {
>  		netdev_err(ndev,
>  			   "unable to allocate receive buffer of size %u\n",
> @@ -357,8 +396,6 @@ static int netvsc_init_buf(struct hv_device *device,
>  		goto cleanup;
>  	}
>=20
> -	net_device->recv_buf_size =3D buf_size;
> -
>  	/*
>  	 * Establish the gpadl handle for this buffer on this
>  	 * channel.  Note: This call uses the vmbus connection rather
> @@ -373,6 +410,19 @@ static int netvsc_init_buf(struct hv_device *device,
>  		goto cleanup;
>  	}
>=20
> +	if (net_device->recv_sgt) {
> +		net_device->recv_buf =3D
> +			dma_vmap_noncontiguous(&device->device, buf_size,
> +					       net_device->recv_sgt);
> +		if (!net_device->recv_buf) {
> +			pr_err("Fail to vmap recv buffer.\n");
> +			ret =3D -ENOMEM;
> +			goto cleanup;
> +		}
> +	}
> +
> +	net_device->recv_buf_size =3D buf_size;
> +
>  	/* Notify the NetVsp of the gpadl handle */
>  	init_packet =3D &net_device->channel_init_pkt;
>  	memset(init_packet, 0, sizeof(struct nvsp_message));
> @@ -454,14 +504,27 @@ static int netvsc_init_buf(struct hv_device *device=
,
>  	buf_size =3D device_info->send_sections * device_info->send_section_siz=
e;
>  	buf_size =3D round_up(buf_size, PAGE_SIZE);
>=20
> -	net_device->send_buf =3D vzalloc(buf_size);
> +	if (hv_isolation_type_snp()) {
> +		net_device->send_sgt =3D
> +			dma_alloc_noncontiguous(&device->device, buf_size,
> +						DMA_TO_DEVICE, GFP_KERNEL, 0);
> +		if (!net_device->send_sgt) {
> +			pr_err("Fail to allocate send buffer buf_size %d.\n.", buf_size);
> +			ret =3D -ENOMEM;
> +			goto cleanup;
> +		}
> +
> +		net_device->send_buf =3D (void *)net_device->send_sgt->sgl->dma_addres=
s;

Use sg_dma_address() macro.

> +	} else {
> +		net_device->send_buf =3D vzalloc(buf_size);
> +	}
> +
>  	if (!net_device->send_buf) {
>  		netdev_err(ndev, "unable to allocate send buffer of size %u\n",
>  			   buf_size);
>  		ret =3D -ENOMEM;
>  		goto cleanup;
>  	}
> -	net_device->send_buf_size =3D buf_size;
>=20
>  	/* Establish the gpadl handle for this buffer on this
>  	 * channel.  Note: This call uses the vmbus connection rather
> @@ -476,6 +539,19 @@ static int netvsc_init_buf(struct hv_device *device,
>  		goto cleanup;
>  	}
>=20
> +	if (net_device->send_sgt) {
> +		net_device->send_buf =3D
> +			dma_vmap_noncontiguous(&device->device, buf_size,
> +					       net_device->send_sgt);
> +		if (!net_device->send_buf) {
> +			pr_err("Fail to vmap send buffer.\n");
> +			ret =3D -ENOMEM;
> +			goto cleanup;
> +		}
> +	}
> +
> +	net_device->send_buf_size =3D buf_size;
> +
>  	/* Notify the NetVsp of the gpadl handle */
>  	init_packet =3D &net_device->channel_init_pkt;
>  	memset(init_packet, 0, sizeof(struct nvsp_message));
> @@ -766,7 +842,7 @@ static void netvsc_send_tx_complete(struct net_device=
 *ndev,
>=20
>  	/* Notify the layer above us */
>  	if (likely(skb)) {
> -		const struct hv_netvsc_packet *packet
> +		struct hv_netvsc_packet *packet
>  			=3D (struct hv_netvsc_packet *)skb->cb;
>  		u32 send_index =3D packet->send_buf_index;
>  		struct netvsc_stats *tx_stats;
> @@ -782,6 +858,7 @@ static void netvsc_send_tx_complete(struct net_device=
 *ndev,
>  		tx_stats->bytes +=3D packet->total_bytes;
>  		u64_stats_update_end(&tx_stats->syncp);
>=20
> +		netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
>  		napi_consume_skb(skb, budget);
>  	}
>=20
> @@ -946,6 +1023,87 @@ static void netvsc_copy_to_send_buf(struct netvsc_d=
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
> +			  struct hv_netvsc_packet *packet,
> +			  struct hv_page_buffer *pb)
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

As noted in comments on an earlier version of this patch, the
pb[i].len and .offset fields should not be changed by doing
dma_map_single().  So there's no need to set them again here.  Adding
a comment to that effect might be good.

> +	}
> +
> +	return 0;
> +}
> +
>  static inline int netvsc_send_pkt(
>  	struct hv_device *device,
>  	struct hv_netvsc_packet *packet,
> @@ -986,14 +1144,24 @@ static inline int netvsc_send_pkt(
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
> @@ -1001,6 +1169,7 @@ static inline int netvsc_send_pkt(
>  				       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
>  	}
>=20
> +exit:
>  	if (ret =3D=3D 0) {
>  		atomic_inc_return(&nvchan->queue_sends);
>=20
> @@ -1515,13 +1684,6 @@ static int netvsc_process_raw_pkt(struct hv_device=
 *device,
>  	return 0;
>  }
>=20
> -static struct hv_device *netvsc_channel_to_device(struct vmbus_channel *=
channel)
> -{
> -	struct vmbus_channel *primary =3D channel->primary_channel;
> -
> -	return primary ? primary->device_obj : channel->device_obj;
> -}
> -
>  /* Network processing softirq
>   * Process data in incoming ring buffer from host
>   * Stops when ring is empty or budget is met or exceeded.
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
> index 4d44fb3b3f1c..8882e46d1070 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -25,6 +25,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/reciprocal_div.h>
>  #include <asm/hyperv-tlfs.h>
> +#include <linux/dma-map-ops.h>
>=20
>  #define MAX_PAGE_BUFFER_COUNT				32
>  #define MAX_MULTIPAGE_BUFFER_COUNT			32 /* 128K */
> @@ -1583,6 +1584,11 @@ struct hyperv_service_callback {
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

