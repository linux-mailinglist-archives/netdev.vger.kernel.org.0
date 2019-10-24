Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0D92E2F99
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 12:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438914AbfJXKz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 06:55:59 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:58381
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392753AbfJXKz6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 06:55:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBQ2lXu0xdXmlKVKQ99v9mb6tOd6Yi8143wDMzyZUuXJv22DR7ej3ex6tiqeZaxe5r7J1dUDbMAX0tR1inUyS1Gf3zPR6Xu8jPPfmnDR5TG5qDqDKBS/QUmkggsRdyzcWp0TZtDvTWTzcfbq3AJYQ94QiRDuoG7Fh8iF9S93GCkCGCflKbPrXy6MQZvyM7MmR5KRVfA1lEC1jvl81sJrUQiQJjEY7yH2z5QltMQK95nROUSoV0T9A5jsFsNtGxlJOCmHy+nYWK9EK7iQkCzMdaKIdjJq+WZSp31/HKs2fwu0ddav4zAyNHedSI3Wboh37s01Kzf+krc7Ckey+KscGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPAlbhpVhTWlcS7Xn0xhpkI/3bwsgpV/RF6MSHyritU=;
 b=O8Uu32LnPhpjmx8cWTMZqtMLtLM/z6q3E0G79JJRMII9jalTMOgFzci7jEe5fvls3LZs3Dha5b1OT0uejm3/pstyJTMYZPi//ohXjfv8RkFa5iiNiem8bzqNUC9KvcWMeAYNJJZnZJAQX0Qd2bmqLr3k8EBKH++9aaqc16dnWF3kjcTyBp5usyAhVsvgiKEohW5vEesTUsbaTXgkvbkTvrXM15iydC2icRCv1KWgmhTOfwXG4Bbc9uZ8YgUNLg2jBA4af26+M1m5QIbYPcJ92NKnb91dfmDMmhb8tzxoRKTSLta+9wvpJsnxSraDX7ci/TdUI0++p/7ov3XxRRLtrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPAlbhpVhTWlcS7Xn0xhpkI/3bwsgpV/RF6MSHyritU=;
 b=J0r6T+Z4aPtCkOskKAuJcZGdFjftkR1Wu0noGHLCY24DNQ/qLaYpQS6R7BFWI8duWKC3fiz1qj2RVbRj4p+IPZEPdICuf/Yp7XUOwO8aKoaIJaQcOscWiU8ZGKUElxciJDhKIhRuvNJF+E9gn9GNK361DZmoYKbtnkMkF2e/j5M=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB4190.eurprd04.prod.outlook.com (52.134.123.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Thu, 24 Oct 2019 10:55:51 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 10:55:51 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     "hch@lst.de" <hch@lst.de>, "joro@8bytes.org" <joro@8bytes.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
CC:     Leo Li <leoyang.li@nxp.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: [PATCH 3/3] dpaa2_eth: use new unmap and sync dma api variants
Thread-Topic: [PATCH 3/3] dpaa2_eth: use new unmap and sync dma api variants
Thread-Index: AQHVilmZiZqW7rAckkadF47X2A/2UQ==
Date:   Thu, 24 Oct 2019 10:55:51 +0000
Message-ID: <20191024105534.16102-4-laurentiu.tudor@nxp.com>
References: <20191024105534.16102-1-laurentiu.tudor@nxp.com>
In-Reply-To: <20191024105534.16102-1-laurentiu.tudor@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0040.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::28) To VI1PR04MB5134.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::16)
x-mailer: git-send-email 2.17.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5d844f71-58d3-472b-eda9-08d75870bc04
x-ms-traffictypediagnostic: VI1PR04MB4190:|VI1PR04MB4190:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4190CF7B0E31A55B54CB787CEC6A0@VI1PR04MB4190.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(189003)(199004)(446003)(71190400001)(71200400001)(2906002)(476003)(8676002)(2201001)(36756003)(316002)(1076003)(11346002)(52116002)(81156014)(14454004)(2501003)(81166006)(478600001)(7736002)(2616005)(6436002)(6486002)(4326008)(66446008)(86362001)(54906003)(186003)(6636002)(66066001)(99286004)(6116002)(66946007)(66476007)(305945005)(66556008)(8936002)(50226002)(64756008)(14444005)(3846002)(256004)(5660300002)(25786009)(486006)(6512007)(6506007)(110136005)(76176011)(44832011)(102836004)(386003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4190;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n4SzDxYSpTpIKJ4GyvVdFFmKydTMAc/ZbY+yCQKwKRRYBPI/cb9d4LU8kmjnLg1SqHds5yTi9ayAcdq2WdGoDlADfOVMQpMDxddcgVD98W7cD3HsAG28ns6Z+foKXvwypkWN/jI6/XdGKj5VxMzticbQhFMFQkoNOm7CN9zPAF9RebrsvxLJmH0E9/s5YpgELwHyr8SbddIrP+dRIKXYSo4o4ilX9DRXdC5Z2ntOWAfsMBxLBluIFTG+NxUdbZY5nHZM3pJQsohI41e2ot8FE7YvulZEvBXUJyz58I7+9DvJbOSHvwxnX9Ehf/NPL8aw5OOwfspOiUL7zPedD21BIe0YUuTr2Y2mOiaQuVU8mpycxmxknOI5BO/TfVruPipp44gBzEl3PgWLgToEPHc87sny2w6KkdqCnuVoEhgxpNgx16kdiV/ysztoabdMbKy4
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AFF25E5DEDB5FD44998222D703860266@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d844f71-58d3-472b-eda9-08d75870bc04
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 10:55:51.2304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N+CllrQNDGbot+v54k/O1eBBXzlgsGdpFjnYg9ARxcxHZVZbMxeL6HsjcHv7wCGdQFV0Wn6gzBkXuHvfBi/V9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4190
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

Convert this driver to usage of the newly introduced dma unmap and
sync DMA APIs. This will get rid of the unsupported direct usage of
iommu_iova_to_phys() API.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 43 ++++++++-----------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  1 -
 2 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net=
/ethernet/freescale/dpaa2/dpaa2-eth.c
index 19379bae0144..bd43bfcb3126 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -29,16 +29,6 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Freescale Semiconductor, Inc");
 MODULE_DESCRIPTION("Freescale DPAA2 Ethernet Driver");
=20
-static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
-				dma_addr_t iova_addr)
-{
-	phys_addr_t phys_addr;
-
-	phys_addr =3D domain ? iommu_iova_to_phys(domain, iova_addr) : iova_addr;
-
-	return phys_to_virt(phys_addr);
-}
-
 static void validate_rx_csum(struct dpaa2_eth_priv *priv,
 			     u32 fd_status,
 			     struct sk_buff *skb)
@@ -85,9 +75,10 @@ static void free_rx_fd(struct dpaa2_eth_priv *priv,
 	sgt =3D vaddr + dpaa2_fd_get_offset(fd);
 	for (i =3D 1; i < DPAA2_ETH_MAX_SG_ENTRIES; i++) {
 		addr =3D dpaa2_sg_get_addr(&sgt[i]);
-		sg_vaddr =3D dpaa2_iova_to_virt(priv->iommu_domain, addr);
-		dma_unmap_page(dev, addr, DPAA2_ETH_RX_BUF_SIZE,
-			       DMA_BIDIRECTIONAL);
+		sg_vaddr =3D phys_to_virt
+				(dma_unmap_page_phys(dev, addr,
+						    DPAA2_ETH_RX_BUF_SIZE,
+						    DMA_BIDIRECTIONAL));
=20
 		free_pages((unsigned long)sg_vaddr, 0);
 		if (dpaa2_sg_is_final(&sgt[i]))
@@ -143,9 +134,10 @@ static struct sk_buff *build_frag_skb(struct dpaa2_eth=
_priv *priv,
=20
 		/* Get the address and length from the S/G entry */
 		sg_addr =3D dpaa2_sg_get_addr(sge);
-		sg_vaddr =3D dpaa2_iova_to_virt(priv->iommu_domain, sg_addr);
-		dma_unmap_page(dev, sg_addr, DPAA2_ETH_RX_BUF_SIZE,
-			       DMA_BIDIRECTIONAL);
+		sg_vaddr =3D phys_to_virt
+				(dma_unmap_page_phys(dev, sg_addr,
+						    DPAA2_ETH_RX_BUF_SIZE,
+						    DMA_BIDIRECTIONAL));
=20
 		sg_length =3D dpaa2_sg_get_len(sge);
=20
@@ -210,9 +202,9 @@ static void free_bufs(struct dpaa2_eth_priv *priv, u64 =
*buf_array, int count)
 	int i;
=20
 	for (i =3D 0; i < count; i++) {
-		vaddr =3D dpaa2_iova_to_virt(priv->iommu_domain, buf_array[i]);
-		dma_unmap_page(dev, buf_array[i], DPAA2_ETH_RX_BUF_SIZE,
-			       DMA_BIDIRECTIONAL);
+		vaddr =3D phys_to_virt(dma_unmap_page_phys(dev, buf_array[i],
+							 DPAA2_ETH_RX_BUF_SIZE,
+							 DMA_BIDIRECTIONAL));
 		free_pages((unsigned long)vaddr, 0);
 	}
 }
@@ -369,9 +361,9 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 	/* Tracing point */
 	trace_dpaa2_rx_fd(priv->net_dev, fd);
=20
-	vaddr =3D dpaa2_iova_to_virt(priv->iommu_domain, addr);
-	dma_sync_single_for_cpu(dev, addr, DPAA2_ETH_RX_BUF_SIZE,
-				DMA_BIDIRECTIONAL);
+	vaddr =3D phys_to_virt(dma_sync_single_for_cpu_phys(dev, addr,
+							  DPAA2_ETH_RX_BUF_SIZE,
+							  DMA_BIDIRECTIONAL));
=20
 	fas =3D dpaa2_get_fas(vaddr, false);
 	prefetch(fas);
@@ -682,7 +674,10 @@ static void free_tx_fd(const struct dpaa2_eth_priv *pr=
iv,
 	u32 fd_len =3D dpaa2_fd_get_len(fd);
=20
 	fd_addr =3D dpaa2_fd_get_addr(fd);
-	buffer_start =3D dpaa2_iova_to_virt(priv->iommu_domain, fd_addr);
+	buffer_start =3D phys_to_virt
+			(dma_sync_single_for_cpu_phys(dev, fd_addr,
+						      sizeof(*swa),
+						      DMA_BIDIRECTIONAL));
 	swa =3D (struct dpaa2_eth_swa *)buffer_start;
=20
 	if (fd_format =3D=3D dpaa2_fd_single) {
@@ -3448,8 +3443,6 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni=
_dev)
 	priv =3D netdev_priv(net_dev);
 	priv->net_dev =3D net_dev;
=20
-	priv->iommu_domain =3D iommu_get_domain_for_dev(dev);
-
 	/* Obtain a MC portal */
 	err =3D fsl_mc_portal_allocate(dpni_dev, FSL_MC_IO_ATOMIC_CONTEXT_PORTAL,
 				     &priv->mc_io);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net=
/ethernet/freescale/dpaa2/dpaa2-eth.h
index 8a0e65b3267f..4e5183617ebd 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -374,7 +374,6 @@ struct dpaa2_eth_priv {
=20
 	struct fsl_mc_device *dpbp_dev;
 	u16 bpid;
-	struct iommu_domain *iommu_domain;
=20
 	bool tx_tstamp; /* Tx timestamping enabled */
 	bool rx_tstamp; /* Rx timestamping enabled */
--=20
2.17.1

