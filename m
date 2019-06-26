Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59DD25659C
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 11:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfFZJYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 05:24:46 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22494 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725379AbfFZJYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 05:24:46 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5Q9AOaf010387;
        Wed, 26 Jun 2019 02:24:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=aXXYcVJAZyuq8QE35gogjvNXXfNgOXUT2zkLGBEOnU8=;
 b=uTpXbgr2gE2++bWmNE96sxzcQtsI4Lv3oE2Atc6Fg3Dm0N4ZQ2nQ4QLSxyBZsP49Cjp7
 W17Mxv1W1yXxy/MjtwJYU6Ys1IVJYZCmEtfOyNyQy/HID1sFHVMWqTD4hfXC3gfYPUqQ
 mVkdURE4dH66MgzdP5BM6roQQSl8hSk8FGpX2Ve/iW6vbPlfJ+gX5icX9VzMAuMrxg3j
 6ruH/ZXt+uOwXPlYnCMBijJFOnisLaTnm7sfO0J03V6VQvnddAEMFojOhh1yePKljf8b
 zRmnz+RcwZhTH2fKSx2wub58m+6Nk3529GIBOs3nG1aJ0I0WI+AxXbNkjxK1YgBxTcoz BQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tc3s6rh1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 02:24:40 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 26 Jun
 2019 02:24:38 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (104.47.48.51) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 26 Jun 2019 02:24:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXXYcVJAZyuq8QE35gogjvNXXfNgOXUT2zkLGBEOnU8=;
 b=WA6vaTMmXsL31LeSQvdknBZqKdzPYQyBT1yPR3KSgCC9XmqFHsbxEEQaD2oxtht0yf+YgOgC6QHcV8pkdCjhVFRonYv4+PuZ575jQ+I/j898fPyQbbHem0aOxrlBvrooYyDSVPQtIwrkgNpsBcc+Xe7gsk6MA7q9tcWFRA3+VUw=
Received: from DM6PR18MB2697.namprd18.prod.outlook.com (20.179.49.204) by
 DM6PR18MB2668.namprd18.prod.outlook.com (20.179.107.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Wed, 26 Jun 2019 09:24:33 +0000
Received: from DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631]) by DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631%6]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 09:24:33 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Benjamin Poirier <bpoirier@suse.com>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH net-next 03/16] qlge: Deduplicate lbq_buf_size
Thread-Topic: [EXT] [PATCH net-next 03/16] qlge: Deduplicate lbq_buf_size
Thread-Index: AQHVJOFEiAHZ7YhaU0yRRmmCZGdwZqattlrg
Date:   Wed, 26 Jun 2019 09:24:32 +0000
Message-ID: <DM6PR18MB2697BAC4CA9B876306BEDBEBABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-3-bpoirier@suse.com>
In-Reply-To: <20190617074858.32467-3-bpoirier@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d133715-0a69-4c19-eb59-08d6fa181961
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR18MB2668;
x-ms-traffictypediagnostic: DM6PR18MB2668:
x-microsoft-antispam-prvs: <DM6PR18MB2668604202CD29F720714BE2ABE20@DM6PR18MB2668.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:569;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(346002)(376002)(366004)(136003)(396003)(13464003)(189003)(199004)(9686003)(74316002)(476003)(66066001)(81166006)(11346002)(305945005)(446003)(33656002)(81156014)(8676002)(14454004)(256004)(14444005)(8936002)(6436002)(486006)(6116002)(3846002)(229853002)(86362001)(2906002)(55016002)(478600001)(25786009)(53936002)(7736002)(6246003)(66476007)(99286004)(73956011)(66446008)(66556008)(186003)(76116006)(2501003)(53546011)(102836004)(76176011)(26005)(110136005)(316002)(7696005)(68736007)(5660300002)(66946007)(71200400001)(52536014)(71190400001)(64756008)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB2668;H:DM6PR18MB2697.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2677rkH0K43cM+MniHCwW2IkNeDzArZVO2eU3j5o8mIO6/tLYG3GfE2zFBOpmrzYNCZrqTdSn8yLKWhYUEp0ElD9CMjtCIgtNj34Zd04iaOM15AbKFij63GVNwtsHEDpm83KGn+NckdGvACfURI3OrbjEjlKbLjJD7qPQzUbJZfTtm9eo2rJD5k1V/Mhu/uhHH+HMddxKLXSZ5y3zlo40lfFJDSzb2rEZgovR9efLChKnWt1mAqq/I4uy4MZ8iWATyfWss8gf+fsd9Asf9km3ef5fn1kPXJw3wwJ31KfWaOK8Z1hLy86ka/4becSBRIibQQVHktnuuh2Fkhvnt6U21f4b3niKE015JSbP/6GsyD+DxG+iym1r4JRjUnVJJW5SrjWD95Mr6WRcb+l6uQw0DaOwI3Fyau2BtVHoHXmhpI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d133715-0a69-4c19-eb59-08d6fa181961
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 09:24:32.9971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: manishc@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2668
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_05:,,
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
> Subject: [EXT] [PATCH net-next 03/16] qlge: Deduplicate lbq_buf_size
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> lbq_buf_size is duplicated to every rx_ring structure whereas lbq_buf_ord=
er is
> present once in the ql_adapter structure. All rings use the same buf size=
, keep
> only one copy of it. Also factor out the calculation of lbq_buf_size inst=
ead of
> having two copies.
>=20
> Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
> ---
>  drivers/net/ethernet/qlogic/qlge/qlge.h      |  2 +-
>  drivers/net/ethernet/qlogic/qlge/qlge_dbg.c  |  2 +-
> drivers/net/ethernet/qlogic/qlge/qlge_main.c | 61 +++++++++-----------
>  3 files changed, 28 insertions(+), 37 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qlge/qlge.h
> b/drivers/net/ethernet/qlogic/qlge/qlge.h
> index 0a156a95e981..ba61b4559dd6 100644
> --- a/drivers/net/ethernet/qlogic/qlge/qlge.h
> +++ b/drivers/net/ethernet/qlogic/qlge/qlge.h
> @@ -1433,7 +1433,6 @@ struct rx_ring {
>  	/* Large buffer queue elements. */
>  	u32 lbq_len;		/* entry count */
>  	u32 lbq_size;		/* size in bytes of queue */
> -	u32 lbq_buf_size;
>  	void *lbq_base;
>  	dma_addr_t lbq_base_dma;
>  	void *lbq_base_indirect;
> @@ -2108,6 +2107,7 @@ struct ql_adapter {
>  	struct rx_ring rx_ring[MAX_RX_RINGS];
>  	struct tx_ring tx_ring[MAX_TX_RINGS];
>  	unsigned int lbq_buf_order;
> +	u32 lbq_buf_size;
>=20
>  	int rx_csum;
>  	u32 default_rx_queue;
> diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c
> b/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c
> index 31389ab8bdf7..46599d74c6fb 100644
> --- a/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c
> +++ b/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c
> @@ -1630,6 +1630,7 @@ void ql_dump_qdev(struct ql_adapter *qdev)
>  	DUMP_QDEV_FIELD(qdev, "0x%08x", xg_sem_mask);
>  	DUMP_QDEV_FIELD(qdev, "0x%08x", port_link_up);
>  	DUMP_QDEV_FIELD(qdev, "0x%08x", port_init);
> +	DUMP_QDEV_FIELD(qdev, "%u", lbq_buf_size);
>  }
>  #endif
>=20
> @@ -1774,7 +1775,6 @@ void ql_dump_rx_ring(struct rx_ring *rx_ring)
>  	pr_err("rx_ring->lbq_curr_idx =3D %d\n", rx_ring->lbq_curr_idx);
>  	pr_err("rx_ring->lbq_clean_idx =3D %d\n", rx_ring->lbq_clean_idx);
>  	pr_err("rx_ring->lbq_free_cnt =3D %d\n", rx_ring->lbq_free_cnt);
> -	pr_err("rx_ring->lbq_buf_size =3D %d\n", rx_ring->lbq_buf_size);
>=20
>  	pr_err("rx_ring->sbq_base =3D %p\n", rx_ring->sbq_base);
>  	pr_err("rx_ring->sbq_base_dma =3D %llx\n", diff --git
> a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> index 038a6bfc79c7..9df06ad3fb93 100644
> --- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> +++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> @@ -995,15 +995,14 @@ static struct bq_desc *ql_get_curr_lchunk(struct
> ql_adapter *qdev,
>  	struct bq_desc *lbq_desc =3D ql_get_curr_lbuf(rx_ring);
>=20
>  	pci_dma_sync_single_for_cpu(qdev->pdev,
> -					dma_unmap_addr(lbq_desc,
> mapaddr),
> -				    rx_ring->lbq_buf_size,
> -					PCI_DMA_FROMDEVICE);
> +				    dma_unmap_addr(lbq_desc, mapaddr),
> +				    qdev->lbq_buf_size,
> PCI_DMA_FROMDEVICE);
>=20
>  	/* If it's the last chunk of our master page then
>  	 * we unmap it.
>  	 */
> -	if ((lbq_desc->p.pg_chunk.offset + rx_ring->lbq_buf_size)
> -					=3D=3D ql_lbq_block_size(qdev))
> +	if (lbq_desc->p.pg_chunk.offset + qdev->lbq_buf_size =3D=3D
> +	    ql_lbq_block_size(qdev))
>  		pci_unmap_page(qdev->pdev,
>  				lbq_desc->p.pg_chunk.map,
>  				ql_lbq_block_size(qdev),
> @@ -1074,11 +1073,11 @@ static int ql_get_next_chunk(struct ql_adapter
> *qdev, struct rx_ring *rx_ring,
>  	/* Adjust the master page chunk for next
>  	 * buffer get.
>  	 */
> -	rx_ring->pg_chunk.offset +=3D rx_ring->lbq_buf_size;
> +	rx_ring->pg_chunk.offset +=3D qdev->lbq_buf_size;
>  	if (rx_ring->pg_chunk.offset =3D=3D ql_lbq_block_size(qdev)) {
>  		rx_ring->pg_chunk.page =3D NULL;
>  	} else {
> -		rx_ring->pg_chunk.va +=3D rx_ring->lbq_buf_size;
> +		rx_ring->pg_chunk.va +=3D qdev->lbq_buf_size;
>  		get_page(rx_ring->pg_chunk.page);
>  	}
>  	return 0;
> @@ -1110,12 +1109,12 @@ static void ql_update_lbq(struct ql_adapter
> *qdev, struct rx_ring *rx_ring)
>  				lbq_desc->p.pg_chunk.offset;
>  			dma_unmap_addr_set(lbq_desc, mapaddr, map);
>  			dma_unmap_len_set(lbq_desc, maplen,
> -					rx_ring->lbq_buf_size);
> +					  qdev->lbq_buf_size);
>  			*lbq_desc->addr =3D cpu_to_le64(map);
>=20
>  			pci_dma_sync_single_for_device(qdev->pdev, map,
> -						rx_ring->lbq_buf_size,
> -						PCI_DMA_FROMDEVICE);
> +						       qdev->lbq_buf_size,
> +						       PCI_DMA_FROMDEVICE);
>  			clean_idx++;
>  			if (clean_idx =3D=3D rx_ring->lbq_len)
>  				clean_idx =3D 0;
> @@ -1880,8 +1879,7 @@ static struct sk_buff *ql_build_rx_skb(struct
> ql_adapter *qdev,
>  		}
>  		do {
>  			lbq_desc =3D ql_get_curr_lchunk(qdev, rx_ring);
> -			size =3D (length < rx_ring->lbq_buf_size) ? length :
> -				rx_ring->lbq_buf_size;
> +			size =3D min(length, qdev->lbq_buf_size);
>=20
>  			netif_printk(qdev, rx_status, KERN_DEBUG, qdev-
> >ndev,
>  				     "Adding page %d to skb for %d bytes.\n",
> @@ -2776,12 +2774,12 @@ static int ql_alloc_tx_resources(struct ql_adapte=
r
> *qdev,
>=20
>  static void ql_free_lbq_buffers(struct ql_adapter *qdev, struct rx_ring
> *rx_ring)  {
> -	unsigned int last_offset =3D ql_lbq_block_size(qdev) -
> -		rx_ring->lbq_buf_size;
> +	unsigned int last_offset;
>  	struct bq_desc *lbq_desc;
>=20
>  	uint32_t  curr_idx, clean_idx;
>=20
> +	last_offset =3D ql_lbq_block_size(qdev) - qdev->lbq_buf_size;
>  	curr_idx =3D rx_ring->lbq_curr_idx;
>  	clean_idx =3D rx_ring->lbq_clean_idx;
>  	while (curr_idx !=3D clean_idx) {
> @@ -3149,8 +3147,8 @@ static int ql_start_rx_ring(struct ql_adapter *qdev=
,
> struct rx_ring *rx_ring)
>  		} while (page_entries < MAX_DB_PAGES_PER_BQ(rx_ring-
> >lbq_len));
>  		cqicb->lbq_addr =3D
>  		    cpu_to_le64(rx_ring->lbq_base_indirect_dma);
> -		bq_len =3D (rx_ring->lbq_buf_size =3D=3D 65536) ? 0 :
> -			(u16) rx_ring->lbq_buf_size;
> +		bq_len =3D (qdev->lbq_buf_size =3D=3D 65536) ? 0 :
> +			(u16)qdev->lbq_buf_size;
>  		cqicb->lbq_buf_size =3D cpu_to_le16(bq_len);
>  		bq_len =3D (rx_ring->lbq_len =3D=3D 65536) ? 0 :
>  			(u16) rx_ring->lbq_len;
> @@ -4048,16 +4046,21 @@ static int qlge_close(struct net_device *ndev)
>  	return 0;
>  }
>=20
> +static void qlge_set_lb_size(struct ql_adapter *qdev) {
> +	if (qdev->ndev->mtu <=3D 1500)
> +		qdev->lbq_buf_size =3D LARGE_BUFFER_MIN_SIZE;
> +	else
> +		qdev->lbq_buf_size =3D LARGE_BUFFER_MAX_SIZE;
> +	qdev->lbq_buf_order =3D get_order(qdev->lbq_buf_size); }
> +
>  static int ql_configure_rings(struct ql_adapter *qdev)  {
>  	int i;
>  	struct rx_ring *rx_ring;
>  	struct tx_ring *tx_ring;
>  	int cpu_cnt =3D min(MAX_CPUS, (int)num_online_cpus());
> -	unsigned int lbq_buf_len =3D (qdev->ndev->mtu > 1500) ?
> -		LARGE_BUFFER_MAX_SIZE : LARGE_BUFFER_MIN_SIZE;
> -
> -	qdev->lbq_buf_order =3D get_order(lbq_buf_len);
>=20
>  	/* In a perfect world we have one RSS ring for each CPU
>  	 * and each has it's own vector.  To do that we ask for @@ -4105,7
> +4108,6 @@ static int ql_configure_rings(struct ql_adapter *qdev)
>  			rx_ring->lbq_len =3D NUM_LARGE_BUFFERS;
>  			rx_ring->lbq_size =3D
>  			    rx_ring->lbq_len * sizeof(__le64);
> -			rx_ring->lbq_buf_size =3D (u16)lbq_buf_len;
>  			rx_ring->sbq_len =3D NUM_SMALL_BUFFERS;
>  			rx_ring->sbq_size =3D
>  			    rx_ring->sbq_len * sizeof(__le64); @@ -4121,7
> +4123,6 @@ static int ql_configure_rings(struct ql_adapter *qdev)
>  			    rx_ring->cq_len * sizeof(struct ql_net_rsp_iocb);
>  			rx_ring->lbq_len =3D 0;
>  			rx_ring->lbq_size =3D 0;
> -			rx_ring->lbq_buf_size =3D 0;
>  			rx_ring->sbq_len =3D 0;
>  			rx_ring->sbq_size =3D 0;
>  			rx_ring->sbq_buf_size =3D 0;
> @@ -4140,6 +4141,7 @@ static int qlge_open(struct net_device *ndev)
>  	if (err)
>  		return err;
>=20
> +	qlge_set_lb_size(qdev);
>  	err =3D ql_configure_rings(qdev);
>  	if (err)
>  		return err;
> @@ -4161,9 +4163,7 @@ static int qlge_open(struct net_device *ndev)
>=20
>  static int ql_change_rx_buffers(struct ql_adapter *qdev)  {
> -	struct rx_ring *rx_ring;
> -	int i, status;
> -	u32 lbq_buf_len;
> +	int status;
>=20
>  	/* Wait for an outstanding reset to complete. */
>  	if (!test_bit(QL_ADAPTER_UP, &qdev->flags)) { @@ -4186,16 +4186,7
> @@ static int ql_change_rx_buffers(struct ql_adapter *qdev)
>  	if (status)
>  		goto error;
>=20
> -	/* Get the new rx buffer size. */
> -	lbq_buf_len =3D (qdev->ndev->mtu > 1500) ?
> -		LARGE_BUFFER_MAX_SIZE : LARGE_BUFFER_MIN_SIZE;
> -	qdev->lbq_buf_order =3D get_order(lbq_buf_len);
> -
> -	for (i =3D 0; i < qdev->rss_ring_count; i++) {
> -		rx_ring =3D &qdev->rx_ring[i];
> -		/* Set the new size. */
> -		rx_ring->lbq_buf_size =3D lbq_buf_len;
> -	}
> +	qlge_set_lb_size(qdev);
>=20
>  	status =3D ql_adapter_up(qdev);
>  	if (status)
> --
> 2.21.0

Not sure if this change is really required, I think fields relevant to rx_r=
ing should be present in the rx_ring structure.
There are various other fields like "lbq_len" and "lbq_size" which would be=
 same for all rx rings but still under the relevant rx_ring structure.=20

