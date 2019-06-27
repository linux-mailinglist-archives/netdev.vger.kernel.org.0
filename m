Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4893D58456
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 16:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfF0OSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 10:18:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47208 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726370AbfF0OSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 10:18:38 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RE4Hk4009821;
        Thu, 27 Jun 2019 07:18:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=bVmVN4tTyx8vklfZMD8h8XLqH7sDwKvGMH6PeLaWtTo=;
 b=jj13y++eTGWybRzqZuxHQqQfZpQi3lnOJe7WSTzK936znG64c9lwwMbG3GYanZe58oCK
 qLwykJ7W3mA8I+daoPfcC7tF0PVZT+Q5g2SiVdKJI83JEy0wYS24Wzah0pRXgJ+kHmlJ
 AUsTgo9EIO8kOSpQ/Z42ssH+yzPuEkuD1ZVRAUOwGNQFvKKTACS4H9eyUIFgbd3ZwyLM
 oNZPSAmIdalzkyLYYFxUZm2G7OKpuHU/e/zmyfEbm31B7Hz8oQiD/v4Em1uRZy5/dPNx
 wLxyIqf0hjc50n9BJqYV1KGRRGMafdbb6ejw2BpIvAPv5oQWn3xd4JjZqJim1FEW050S zQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tcvnh8p4u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 Jun 2019 07:18:34 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 27 Jun
 2019 07:18:32 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.53) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 27 Jun 2019 07:18:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVmVN4tTyx8vklfZMD8h8XLqH7sDwKvGMH6PeLaWtTo=;
 b=mGXF6DoTmeb19utNiUxqk4e4UGrrVbAT4yFyZNACg6XM/bVOYsiElEP/SbqEnH5JELMQkr1WfA9NT0CTJZpi0IJ2revozZZbt+apoS0RqaP3NipSjyMkWOEJGgrYfAXw0+2nuwLf2q+bXHtXni6JvhrA5FXShrQ/r5mx2i9j6K0=
Received: from DM6PR18MB2697.namprd18.prod.outlook.com (20.179.49.204) by
 DM6PR18MB2508.namprd18.prod.outlook.com (20.179.105.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Thu, 27 Jun 2019 14:18:27 +0000
Received: from DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631]) by DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631%6]) with mapi id 15.20.2008.018; Thu, 27 Jun 2019
 14:18:27 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Benjamin Poirier <bpoirier@suse.com>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH net-next 16/16] qlge: Refill empty buffer queues
 from wq
Thread-Topic: [EXT] [PATCH net-next 16/16] qlge: Refill empty buffer queues
 from wq
Thread-Index: AQHVJOFVVEYc7h8aj0a0GocJ7dF/Jaavma9w
Date:   Thu, 27 Jun 2019 14:18:27 +0000
Message-ID: <DM6PR18MB2697EC53399F214EC3DFC4ABABFD0@DM6PR18MB2697.namprd18.prod.outlook.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-16-bpoirier@suse.com>
In-Reply-To: <20190617074858.32467-16-bpoirier@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ece81cf1-9692-4da1-0aed-08d6fb0a52ce
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR18MB2508;
x-ms-traffictypediagnostic: DM6PR18MB2508:
x-microsoft-antispam-prvs: <DM6PR18MB25088685134E2C9C2062E626ABFD0@DM6PR18MB2508.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:152;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(39860400002)(366004)(396003)(376002)(189003)(199004)(13464003)(74316002)(102836004)(9686003)(446003)(55016002)(6116002)(3846002)(6436002)(73956011)(6246003)(66556008)(64756008)(66446008)(66476007)(66946007)(25786009)(316002)(26005)(110136005)(66066001)(14454004)(71200400001)(71190400001)(86362001)(2501003)(68736007)(256004)(486006)(476003)(11346002)(8676002)(229853002)(33656002)(14444005)(186003)(81156014)(2906002)(81166006)(53546011)(53936002)(478600001)(52536014)(8936002)(76176011)(7696005)(76116006)(5660300002)(305945005)(6506007)(99286004)(7736002)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB2508;H:DM6PR18MB2697.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KBdloki+NN22/DFylOPbTjmfMT3i/G4AMxgxGqw+WFD4vrAV/QPF0GWm4PkjjLuq5mevxP3PGS8NqnhJlUrPRxv1Z7SwxV2NEX2if28DtK4sjuYperJkzWzQ2JNEJWelR0GaS1HOyh6tB/N7TpeyvhayhpmNWLdVfPYw9oMIlE5DMHFBr3RYWGwwyNblHgNpoAd4TkoVeE6ATssXgOrLhfwL+Z7TvsTJp5TlC9/JdmotgIolq4nc4VUge+2yvt1/jNDeKRl6Gi0UOzYhQVno8PYs6fp2YUPfbxA1xrwbOyWRHmqTxhybZV4XS37fNjSPDA+TsAgcNPUcfx4b1LbitpI8TAl6Uht/Q4q8gssWURU70O/ZQsqB1SnbrlZHXb/kl0CY3IkyQAjLNbG51KUvVtnE85CK4NnxIhQ3QGYzT8k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ece81cf1-9692-4da1-0aed-08d6fb0a52ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 14:18:27.4864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: manishc@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2508
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_08:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Benjamin Poirier <bpoirier@suse.com>
> Sent: Monday, June 17, 2019 1:19 PM
> To: Manish Chopra <manishc@marvell.com>; GR-Linux-NIC-Dev <GR-Linux-
> NIC-Dev@marvell.com>; netdev@vger.kernel.org
> Subject: [EXT] [PATCH net-next 16/16] qlge: Refill empty buffer queues fr=
om
> wq
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> When operating at mtu 9000, qlge does order-1 allocations for rx buffers =
in
> atomic context. This is especially unreliable when free memory is low or
> fragmented. Add an approach similar to commit 3161e453e496 ("virtio: net
> refill on out-of-memory") to qlge so that the device doesn't lock up if t=
here
> are allocation failures.
>=20
> Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
> ---
>  drivers/net/ethernet/qlogic/qlge/qlge.h      |  8 ++
>  drivers/net/ethernet/qlogic/qlge/qlge_main.c | 80 ++++++++++++++++----
>  2 files changed, 72 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qlge/qlge.h
> b/drivers/net/ethernet/qlogic/qlge/qlge.h
> index 1d90b32f6285..9c4d933c1ff7 100644
> --- a/drivers/net/ethernet/qlogic/qlge/qlge.h
> +++ b/drivers/net/ethernet/qlogic/qlge/qlge.h
> @@ -1453,6 +1453,13 @@ struct qlge_bq {
>=20
>  #define QLGE_BQ_WRAP(index) ((index) & (QLGE_BQ_LEN - 1))
>=20
> +#define QLGE_BQ_HW_OWNED(bq) \
> +({ \
> +	typeof(bq) _bq =3D bq; \
> +	QLGE_BQ_WRAP(QLGE_BQ_ALIGN((_bq)->next_to_use) - \
> +		     (_bq)->next_to_clean); \
> +})
> +
>  struct rx_ring {
>  	struct cqicb cqicb;	/* The chip's completion queue init control
> block. */
>=20
> @@ -1480,6 +1487,7 @@ struct rx_ring {
>  	/* Misc. handler elements. */
>  	u32 irq;		/* Which vector this ring is assigned. */
>  	u32 cpu;		/* Which CPU this should run on. */
> +	struct delayed_work refill_work;
>  	char name[IFNAMSIZ + 5];
>  	struct napi_struct napi;
>  	u8 reserved;
> diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> index 7db4c31c9cc4..a13bda566187 100644
> --- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> +++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> @@ -1029,7 +1029,7 @@ static const char * const bq_type_name[] =3D {
>=20
>  /* return 0 or negative error */
>  static int qlge_refill_sb(struct rx_ring *rx_ring,
> -			  struct qlge_bq_desc *sbq_desc)
> +			  struct qlge_bq_desc *sbq_desc, gfp_t gfp)
>  {
>  	struct ql_adapter *qdev =3D rx_ring->qdev;
>  	struct sk_buff *skb;
> @@ -1041,7 +1041,7 @@ static int qlge_refill_sb(struct rx_ring *rx_ring,
>  		     "ring %u sbq: getting new skb for index %d.\n",
>  		     rx_ring->cq_id, sbq_desc->index);
>=20
> -	skb =3D netdev_alloc_skb(qdev->ndev, SMALL_BUFFER_SIZE);
> +	skb =3D __netdev_alloc_skb(qdev->ndev, SMALL_BUFFER_SIZE, gfp);
>  	if (!skb)
>  		return -ENOMEM;
>  	skb_reserve(skb, QLGE_SB_PAD);
> @@ -1062,7 +1062,7 @@ static int qlge_refill_sb(struct rx_ring *rx_ring,
>=20
>  /* return 0 or negative error */
>  static int qlge_refill_lb(struct rx_ring *rx_ring,
> -			  struct qlge_bq_desc *lbq_desc)
> +			  struct qlge_bq_desc *lbq_desc, gfp_t gfp)
>  {
>  	struct ql_adapter *qdev =3D rx_ring->qdev;
>  	struct qlge_page_chunk *master_chunk =3D &rx_ring->master_chunk;
> @@ -1071,8 +1071,7 @@ static int qlge_refill_lb(struct rx_ring *rx_ring,
>  		struct page *page;
>  		dma_addr_t dma_addr;
>=20
> -		page =3D alloc_pages(__GFP_COMP | GFP_ATOMIC,
> -				   qdev->lbq_buf_order);
> +		page =3D alloc_pages(gfp | __GFP_COMP, qdev-
> >lbq_buf_order);
>  		if (unlikely(!page))
>  			return -ENOMEM;
>  		dma_addr =3D pci_map_page(qdev->pdev, page, 0, @@ -
> 1109,33 +1108,33 @@ static int qlge_refill_lb(struct rx_ring *rx_ring,
>  	return 0;
>  }
>=20
> -static void qlge_refill_bq(struct qlge_bq *bq)
> +/* return 0 or negative error */
> +static int qlge_refill_bq(struct qlge_bq *bq, gfp_t gfp)
>  {
>  	struct rx_ring *rx_ring =3D QLGE_BQ_CONTAINER(bq);
>  	struct ql_adapter *qdev =3D rx_ring->qdev;
>  	struct qlge_bq_desc *bq_desc;
>  	int refill_count;
> +	int retval;
>  	int i;
>=20
>  	refill_count =3D QLGE_BQ_WRAP(QLGE_BQ_ALIGN(bq->next_to_clean -
> 1) -
>  				    bq->next_to_use);
>  	if (!refill_count)
> -		return;
> +		return 0;
>=20
>  	i =3D bq->next_to_use;
>  	bq_desc =3D &bq->queue[i];
>  	i -=3D QLGE_BQ_LEN;
>  	do {
> -		int retval;
> -
>  		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
>  			     "ring %u %s: try cleaning idx %d\n",
>  			     rx_ring->cq_id, bq_type_name[bq->type], i);
>=20
>  		if (bq->type =3D=3D QLGE_SB)
> -			retval =3D qlge_refill_sb(rx_ring, bq_desc);
> +			retval =3D qlge_refill_sb(rx_ring, bq_desc, gfp);
>  		else
> -			retval =3D qlge_refill_lb(rx_ring, bq_desc);
> +			retval =3D qlge_refill_lb(rx_ring, bq_desc, gfp);
>  		if (retval < 0) {
>  			netif_err(qdev, ifup, qdev->ndev,
>  				  "ring %u %s: Could not get a page chunk, idx
> %d\n", @@ -1163,12 +1162,52 @@ static void qlge_refill_bq(struct qlge_bq
> *bq)
>  		}
>  		bq->next_to_use =3D i;
>  	}
> +
> +	return retval;
> +}
> +
> +static void ql_update_buffer_queues(struct rx_ring *rx_ring, gfp_t gfp,
> +				    unsigned long delay)
> +{
> +	bool sbq_fail, lbq_fail;
> +
> +	sbq_fail =3D !!qlge_refill_bq(&rx_ring->sbq, gfp);
> +	lbq_fail =3D !!qlge_refill_bq(&rx_ring->lbq, gfp);
> +
> +	/* Minimum number of buffers needed to be able to receive at least
> one
> +	 * frame of any format:
> +	 * sbq: 1 for header + 1 for data
> +	 * lbq: mtu 9000 / lb size
> +	 * Below this, the queue might stall.
> +	 */
> +	if ((sbq_fail && QLGE_BQ_HW_OWNED(&rx_ring->sbq) < 2) ||
> +	    (lbq_fail && QLGE_BQ_HW_OWNED(&rx_ring->lbq) <
> +	     DIV_ROUND_UP(9000, LARGE_BUFFER_MAX_SIZE)))
> +		/* Allocations can take a long time in certain cases (ex.
> +		 * reclaim). Therefore, use a workqueue for long-running
> +		 * work items.
> +		 */
> +		queue_delayed_work_on(smp_processor_id(),
> system_long_wq,
> +				      &rx_ring->refill_work, delay);
>  }
>=20

This is probably going to mess up when at the interface load time (qlge_ope=
n()) allocation failure occurs, in such cases we don't really want to re-tr=
y allocations
using refill_work but rather simply fail the interface load. Just to make s=
ure here in such cases it shouldn't lead to kernel panic etc. while complet=
ing qlge_open() and
leaving refill_work executing in background. Or probably handle such alloca=
tion failures from the napi context and schedule refill_work from there.


