Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFB6DEC2F
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbfJUM2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:28:07 -0400
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:30678
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728693AbfJUM2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 08:28:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQ4pO5Lh4tiQCj6SUVSfgLtCIagVK/kvq17mPNsvrdS5GhOyCxi3shSJvM7PHuOhfAD33dbdbKw4X5GAD0ssPW1+Eit34E6TFNFNLgLTYTy7/r5v9BQ0izYJU6XJLJjAqIEU4EEqLzQbsiO8ecKSA9E/bwZoaznViqUhTUpYJYYZRF3qlWM4mkMF+oJOTrhh3r/dx7gnRUllEwBpap72XKmV+bOke3YMLIvcKY/5leHIzxQAJXLqNln/8DXEiAJmPWHQgRgLw7yzv0UmXr+5YQQt2XVFGCK+h7+3lw9RKs/AKJnNU0af/7/pht7pae67/6JAOOla939zLwMDj2a+Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maGHD3k2z3jS8GEvoyabljfJ657gsBNM2AlMnhl2iP0=;
 b=TEh68tT9P3Nho79maIvnieuNPtQo3jT11nU0NCE+nMqi/os2W7eOPQTZKJu5cY1j9pERDETDQhtsAdl7BpE0Vm/Yg11p3EjbS+iaCer1q8WtCyOL7HXJ+1wiX/2OAEbfEg8otjP/1CF8tGM10Ygwrvoj2TPqoUSLppXdGX03eRmYCzHODDU8yW/ok61QjGOnffyLpxjSFJ3litA7sXTNnllENpom0ML5SwBCwt+9ja1v9xNs2Cyb/JGW8XuDuG8gTDW/kCfsNXL1pFJVg/0IqFiowLC9tHtrzj4oB7sAHH7H0wzrWLvuCdUumqqk0UUrhbZ00XnFaCVhMpEA/U8UFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maGHD3k2z3jS8GEvoyabljfJ657gsBNM2AlMnhl2iP0=;
 b=ouULyMbviYyPrpqANeQshfFnNA/ikxRw2e/wzHeeZuQkmzcTj4A5JewIGjguj07+TKwd7FQUlb4gSOkHQDjRAZiClH/EvWvKydHFSasBNUEKCgNAHRc9GMSYMsxMTGx7n7hvqi6r2YEARQ8FXUhVNDkebIGROwW88zBNecmlKZw=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB5807.eurprd04.prod.outlook.com (20.178.204.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Mon, 21 Oct 2019 12:28:02 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4%6]) with mapi id 15.20.2347.028; Mon, 21 Oct 2019
 12:28:02 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Roy Pledge <roy.pledge@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next 5/6] dpaa_eth: change DMA device
Thread-Topic: [PATCH net-next 5/6] dpaa_eth: change DMA device
Thread-Index: AQHViAr73nMz58c3IkSLdCljb94Yjg==
Date:   Mon, 21 Oct 2019 12:28:02 +0000
Message-ID: <1571660862-18313-6-git-send-email-madalin.bucur@nxp.com>
References: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
In-Reply-To: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
Reply-To: Madalin-cristian Bucur <madalin.bucur@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [89.37.124.34]
x-clientproxiedby: AM7PR02CA0022.eurprd02.prod.outlook.com
 (2603:10a6:20b:100::32) To VI1PR04MB5567.eurprd04.prod.outlook.com
 (2603:10a6:803:d4::21)
x-mailer: git-send-email 2.1.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 019ac650-a727-4d9d-9997-08d756221d90
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR04MB5807:|VI1PR04MB5807:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB58071D7E5983354D0ADDAFCAEC690@VI1PR04MB5807.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(199004)(189003)(102836004)(486006)(3846002)(26005)(6486002)(446003)(11346002)(2616005)(476003)(6116002)(2906002)(3450700001)(36756003)(86362001)(25786009)(8676002)(6506007)(386003)(7736002)(186003)(305945005)(99286004)(4326008)(6436002)(52116002)(81166006)(81156014)(76176011)(6512007)(66066001)(14454004)(50226002)(478600001)(54906003)(2501003)(8936002)(30864003)(316002)(5660300002)(110136005)(66946007)(71200400001)(71190400001)(256004)(66556008)(66476007)(64756008)(66446008)(43066004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5807;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wleqmImsEyI18a3gNqZzG5mdg23uWozQyAU1F7hAYzGzNtO07JDOtRWrb3D0G6RzO9Cjazdvdg8tguiYXSY1O4Iankl2Ib2etukokAxZoXpTx+C+rS4HHpGeg2AYbikrtWLh3gP5i5Gn0rYrXduVX+wgQx9ZYXPhZq83J2UaFaud1cQNbK75bhiGo+Nu97peQU3FfGK1b7mc2ogbT3gpR5M9Qt0ZMMF2JnrliHGSqBU/Q3XIkrDFM6sqd6yb14+HDbJZadAAxbXv3mM2HasHnwDfM3QXnuqK3sqEvL/q8xmTTeZVyAuuz29mfp1sHRDz2DEHf4B9nP/EPXn3p/XSCHfLCpMmQsyEVHnM623OMI5KrBpdC1i1hjjo+MTEL/Io3IX1NLyWhDv6yFp6CQqLuwCGZuwLMtsMzMmXOIBILwDVzRgP00+N036ghCdHFSUC
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A80038DE22E514478AA81D1A2B9D6D35@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 019ac650-a727-4d9d-9997-08d756221d90
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 12:28:02.3035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bD8u6C0+AHV91a9qS5BFeEgGo3iJDzDlf3BBiOhQj/vvt+5849+/9Yxn781Mq+TvrzBh5q1Zk2ex17rG4SpfpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5807
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DPAA Ethernet driver is using the FMan MAC as the device for DMA
mapping. This is not actually correct, as the real DMA device is the
FMan port (the FMan Rx port for reception and the FMan Tx port for
transmission). Changing the device used for DMA mapping to the Fman
Rx and Tx port devices.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 105 +++++++++++++--------=
----
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |   8 +-
 2 files changed, 62 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/e=
thernet/freescale/dpaa/dpaa_eth.c
index 8d5686d88d30..639cafaa59b8 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1335,15 +1335,15 @@ static void dpaa_fd_release(const struct net_device=
 *net_dev,
 		vaddr =3D phys_to_virt(qm_fd_addr(fd));
 		sgt =3D vaddr + qm_fd_get_offset(fd);
=20
-		dma_unmap_single(dpaa_bp->dev, qm_fd_addr(fd), dpaa_bp->size,
-				 DMA_FROM_DEVICE);
+		dma_unmap_single(dpaa_bp->priv->rx_dma_dev, qm_fd_addr(fd),
+				 dpaa_bp->size, DMA_FROM_DEVICE);
=20
 		dpaa_release_sgt_members(sgt);
=20
-		addr =3D dma_map_single(dpaa_bp->dev, vaddr, dpaa_bp->size,
-				      DMA_FROM_DEVICE);
-		if (dma_mapping_error(dpaa_bp->dev, addr)) {
-			dev_err(dpaa_bp->dev, "DMA mapping failed");
+		addr =3D dma_map_single(dpaa_bp->priv->rx_dma_dev, vaddr,
+				      dpaa_bp->size, DMA_FROM_DEVICE);
+		if (dma_mapping_error(dpaa_bp->priv->rx_dma_dev, addr)) {
+			netdev_err(net_dev, "DMA mapping failed");
 			return;
 		}
 		bm_buffer_set64(&bmb, addr);
@@ -1488,7 +1488,7 @@ static int dpaa_enable_tx_csum(struct dpaa_priv *priv=
,
=20
 static int dpaa_bp_add_8_bufs(const struct dpaa_bp *dpaa_bp)
 {
-	struct device *dev =3D dpaa_bp->dev;
+	struct net_device *net_dev =3D dpaa_bp->priv->net_dev;
 	struct bm_buffer bmb[8];
 	dma_addr_t addr;
 	void *new_buf;
@@ -1497,16 +1497,18 @@ static int dpaa_bp_add_8_bufs(const struct dpaa_bp =
*dpaa_bp)
 	for (i =3D 0; i < 8; i++) {
 		new_buf =3D netdev_alloc_frag(dpaa_bp->raw_size);
 		if (unlikely(!new_buf)) {
-			dev_err(dev, "netdev_alloc_frag() failed, size %zu\n",
-				dpaa_bp->raw_size);
+			netdev_err(net_dev,
+				   "netdev_alloc_frag() failed, size %zu\n",
+				   dpaa_bp->raw_size);
 			goto release_previous_buffs;
 		}
 		new_buf =3D PTR_ALIGN(new_buf, SMP_CACHE_BYTES);
=20
-		addr =3D dma_map_single(dev, new_buf,
+		addr =3D dma_map_single(dpaa_bp->priv->rx_dma_dev, new_buf,
 				      dpaa_bp->size, DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(dev, addr))) {
-			dev_err(dpaa_bp->dev, "DMA map failed");
+		if (unlikely(dma_mapping_error(dpaa_bp->priv->rx_dma_dev,
+					       addr))) {
+			netdev_err(net_dev, "DMA map failed");
 			goto release_previous_buffs;
 		}
=20
@@ -1634,7 +1636,7 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struc=
t dpaa_priv *priv,
=20
 	if (unlikely(qm_fd_get_format(fd) =3D=3D qm_fd_sg)) {
 		nr_frags =3D skb_shinfo(skb)->nr_frags;
-		dma_unmap_single(dev, addr,
+		dma_unmap_single(priv->tx_dma_dev, addr,
 				 qm_fd_get_offset(fd) + DPAA_SGT_SIZE,
 				 dma_dir);
=20
@@ -1644,21 +1646,21 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const str=
uct dpaa_priv *priv,
 		sgt =3D phys_to_virt(addr + qm_fd_get_offset(fd));
=20
 		/* sgt[0] is from lowmem, was dma_map_single()-ed */
-		dma_unmap_single(dev, qm_sg_addr(&sgt[0]),
+		dma_unmap_single(priv->tx_dma_dev, qm_sg_addr(&sgt[0]),
 				 qm_sg_entry_get_len(&sgt[0]), dma_dir);
=20
 		/* remaining pages were mapped with skb_frag_dma_map() */
 		for (i =3D 1; i <=3D nr_frags; i++) {
 			WARN_ON(qm_sg_entry_is_ext(&sgt[i]));
=20
-			dma_unmap_page(dev, qm_sg_addr(&sgt[i]),
+			dma_unmap_page(priv->tx_dma_dev, qm_sg_addr(&sgt[i]),
 				       qm_sg_entry_get_len(&sgt[i]), dma_dir);
 		}
=20
 		/* Free the page frag that we allocated on Tx */
 		skb_free_frag(phys_to_virt(addr));
 	} else {
-		dma_unmap_single(dev, addr,
+		dma_unmap_single(priv->tx_dma_dev, addr,
 				 skb_tail_pointer(skb) - (u8 *)skbh, dma_dir);
 	}
=20
@@ -1762,8 +1764,8 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa=
_priv *priv,
 			goto free_buffers;
=20
 		count_ptr =3D this_cpu_ptr(dpaa_bp->percpu_count);
-		dma_unmap_single(dpaa_bp->dev, sg_addr, dpaa_bp->size,
-				 DMA_FROM_DEVICE);
+		dma_unmap_single(dpaa_bp->priv->rx_dma_dev, sg_addr,
+				 dpaa_bp->size, DMA_FROM_DEVICE);
 		if (!skb) {
 			sz =3D dpaa_bp->size +
 				SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
@@ -1853,7 +1855,6 @@ static int skb_to_contig_fd(struct dpaa_priv *priv,
 			    int *offset)
 {
 	struct net_device *net_dev =3D priv->net_dev;
-	struct device *dev =3D net_dev->dev.parent;
 	enum dma_data_direction dma_dir;
 	unsigned char *buffer_start;
 	struct sk_buff **skbh;
@@ -1889,9 +1890,9 @@ static int skb_to_contig_fd(struct dpaa_priv *priv,
 	fd->cmd |=3D cpu_to_be32(FM_FD_CMD_FCO);
=20
 	/* Map the entire buffer size that may be seen by FMan, but no more */
-	addr =3D dma_map_single(dev, skbh,
+	addr =3D dma_map_single(priv->tx_dma_dev, skbh,
 			      skb_tail_pointer(skb) - buffer_start, dma_dir);
-	if (unlikely(dma_mapping_error(dev, addr))) {
+	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
 		if (net_ratelimit())
 			netif_err(priv, tx_err, net_dev, "dma_map_single() failed\n");
 		return -EINVAL;
@@ -1907,7 +1908,6 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 	const enum dma_data_direction dma_dir =3D DMA_TO_DEVICE;
 	const int nr_frags =3D skb_shinfo(skb)->nr_frags;
 	struct net_device *net_dev =3D priv->net_dev;
-	struct device *dev =3D net_dev->dev.parent;
 	struct qm_sg_entry *sgt;
 	struct sk_buff **skbh;
 	int i, j, err, sz;
@@ -1946,10 +1946,10 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 	qm_sg_entry_set_len(&sgt[0], frag_len);
 	sgt[0].bpid =3D FSL_DPAA_BPID_INV;
 	sgt[0].offset =3D 0;
-	addr =3D dma_map_single(dev, skb->data,
+	addr =3D dma_map_single(priv->tx_dma_dev, skb->data,
 			      skb_headlen(skb), dma_dir);
-	if (unlikely(dma_mapping_error(dev, addr))) {
-		dev_err(dev, "DMA mapping failed");
+	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
+		netdev_err(priv->net_dev, "DMA mapping failed");
 		err =3D -EINVAL;
 		goto sg0_map_failed;
 	}
@@ -1960,10 +1960,10 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 		frag =3D &skb_shinfo(skb)->frags[i];
 		frag_len =3D skb_frag_size(frag);
 		WARN_ON(!skb_frag_page(frag));
-		addr =3D skb_frag_dma_map(dev, frag, 0,
+		addr =3D skb_frag_dma_map(priv->tx_dma_dev, frag, 0,
 					frag_len, dma_dir);
-		if (unlikely(dma_mapping_error(dev, addr))) {
-			dev_err(dev, "DMA mapping failed");
+		if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
+			netdev_err(priv->net_dev, "DMA mapping failed");
 			err =3D -EINVAL;
 			goto sg_map_failed;
 		}
@@ -1986,10 +1986,10 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 	skbh =3D (struct sk_buff **)buffer_start;
 	*skbh =3D skb;
=20
-	addr =3D dma_map_single(dev, buffer_start,
+	addr =3D dma_map_single(priv->tx_dma_dev, buffer_start,
 			      priv->tx_headroom + DPAA_SGT_SIZE, dma_dir);
-	if (unlikely(dma_mapping_error(dev, addr))) {
-		dev_err(dev, "DMA mapping failed");
+	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
+		netdev_err(priv->net_dev, "DMA mapping failed");
 		err =3D -EINVAL;
 		goto sgt_map_failed;
 	}
@@ -2003,7 +2003,7 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 sgt_map_failed:
 sg_map_failed:
 	for (j =3D 0; j < i; j++)
-		dma_unmap_page(dev, qm_sg_addr(&sgt[j]),
+		dma_unmap_page(priv->tx_dma_dev, qm_sg_addr(&sgt[j]),
 			       qm_sg_entry_get_len(&sgt[j]), dma_dir);
 sg0_map_failed:
 csum_failed:
@@ -2304,7 +2304,8 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struc=
t qman_portal *portal,
 		return qman_cb_dqrr_consume;
 	}
=20
-	dma_unmap_single(dpaa_bp->dev, addr, dpaa_bp->size, DMA_FROM_DEVICE);
+	dma_unmap_single(dpaa_bp->priv->rx_dma_dev, addr, dpaa_bp->size,
+			 DMA_FROM_DEVICE);
=20
 	/* prefetch the first 64 bytes of the frame or the SGT start */
 	vaddr =3D phys_to_virt(addr);
@@ -2659,7 +2660,7 @@ static inline void dpaa_bp_free_pf(const struct dpaa_=
bp *bp,
 {
 	dma_addr_t addr =3D bm_buf_addr(bmb);
=20
-	dma_unmap_single(bp->dev, addr, bp->size, DMA_FROM_DEVICE);
+	dma_unmap_single(bp->priv->rx_dma_dev, addr, bp->size, DMA_FROM_DEVICE);
=20
 	skb_free_frag(phys_to_virt(addr));
 }
@@ -2769,25 +2770,27 @@ static int dpaa_eth_probe(struct platform_device *p=
dev)
 	int err =3D 0, i, channel;
 	struct device *dev;
=20
+	dev =3D &pdev->dev;
+
 	err =3D bman_is_probed();
 	if (!err)
 		return -EPROBE_DEFER;
 	if (err < 0) {
-		dev_err(&pdev->dev, "failing probe due to bman probe error\n");
+		dev_err(dev, "failing probe due to bman probe error\n");
 		return -ENODEV;
 	}
 	err =3D qman_is_probed();
 	if (!err)
 		return -EPROBE_DEFER;
 	if (err < 0) {
-		dev_err(&pdev->dev, "failing probe due to qman probe error\n");
+		dev_err(dev, "failing probe due to qman probe error\n");
 		return -ENODEV;
 	}
 	err =3D bman_portals_probed();
 	if (!err)
 		return -EPROBE_DEFER;
 	if (err < 0) {
-		dev_err(&pdev->dev,
+		dev_err(dev,
 			"failing probe due to bman portals probe error\n");
 		return -ENODEV;
 	}
@@ -2795,19 +2798,11 @@ static int dpaa_eth_probe(struct platform_device *p=
dev)
 	if (!err)
 		return -EPROBE_DEFER;
 	if (err < 0) {
-		dev_err(&pdev->dev,
+		dev_err(dev,
 			"failing probe due to qman portals probe error\n");
 		return -ENODEV;
 	}
=20
-	/* device used for DMA mapping */
-	dev =3D pdev->dev.parent;
-	err =3D dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(40));
-	if (err) {
-		dev_err(dev, "dma_coerce_mask_and_coherent() failed\n");
-		return err;
-	}
-
 	/* Allocate this early, so we can store relevant information in
 	 * the private area
 	 */
@@ -2828,11 +2823,23 @@ static int dpaa_eth_probe(struct platform_device *p=
dev)
=20
 	mac_dev =3D dpaa_mac_dev_get(pdev);
 	if (IS_ERR(mac_dev)) {
-		dev_err(dev, "dpaa_mac_dev_get() failed\n");
+		netdev_err(net_dev, "dpaa_mac_dev_get() failed\n");
 		err =3D PTR_ERR(mac_dev);
 		goto free_netdev;
 	}
=20
+	/* Devices used for DMA mapping */
+	priv->rx_dma_dev =3D fman_port_get_device(mac_dev->port[RX]);
+	priv->tx_dma_dev =3D fman_port_get_device(mac_dev->port[TX]);
+	err =3D dma_coerce_mask_and_coherent(priv->rx_dma_dev, DMA_BIT_MASK(40));
+	if (!err)
+		err =3D dma_coerce_mask_and_coherent(priv->tx_dma_dev,
+						   DMA_BIT_MASK(40));
+	if (err) {
+		netdev_err(net_dev, "dma_coerce_mask_and_coherent() failed\n");
+		return err;
+	}
+
 	/* If fsl_fm_max_frm is set to a higher value than the all-common 1500,
 	 * we choose conservatively and let the user explicitly set a higher
 	 * MTU via ifconfig. Otherwise, the user may end up with different MTUs
@@ -2859,7 +2866,7 @@ static int dpaa_eth_probe(struct platform_device *pde=
v)
 		dpaa_bps[i]->raw_size =3D bpool_buffer_raw_size(i, DPAA_BPS_NUM);
 		/* avoid runtime computations by keeping the usable size here */
 		dpaa_bps[i]->size =3D dpaa_bp_size(dpaa_bps[i]->raw_size);
-		dpaa_bps[i]->dev =3D dev;
+		dpaa_bps[i]->priv =3D priv;
=20
 		err =3D dpaa_bp_alloc_pool(dpaa_bps[i]);
 		if (err < 0)
@@ -2982,7 +2989,7 @@ static int dpaa_remove(struct platform_device *pdev)
 	struct device *dev;
 	int err;
=20
-	dev =3D pdev->dev.parent;
+	dev =3D &pdev->dev;
 	net_dev =3D dev_get_drvdata(dev);
=20
 	priv =3D netdev_priv(net_dev);
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h b/drivers/net/e=
thernet/freescale/dpaa/dpaa_eth.h
index f7e59e8db075..1bdfead1d334 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
@@ -80,9 +80,11 @@ struct dpaa_fq_cbs {
 	struct qman_fq egress_ern;
 };
=20
+struct dpaa_priv;
+
 struct dpaa_bp {
-	/* device used in the DMA mapping operations */
-	struct device *dev;
+	/* used in the DMA mapping operations */
+	struct dpaa_priv *priv;
 	/* current number of buffers in the buffer pool alloted to each CPU */
 	int __percpu *percpu_count;
 	/* all buffers allocated for this pool have this raw size */
@@ -153,6 +155,8 @@ struct dpaa_priv {
 	u16 tx_headroom;
 	struct net_device *net_dev;
 	struct mac_device *mac_dev;
+	struct device *rx_dma_dev;
+	struct device *tx_dma_dev;
 	struct qman_fq *egress_fqs[DPAA_ETH_TXQ_NUM];
 	struct qman_fq *conf_fqs[DPAA_ETH_TXQ_NUM];
=20
--=20
2.1.0

