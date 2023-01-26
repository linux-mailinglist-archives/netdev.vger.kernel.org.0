Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CAF67CC4D
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 14:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbjAZNef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 08:34:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237034AbjAZNea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 08:34:30 -0500
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9057B4C6F6;
        Thu, 26 Jan 2023 05:34:24 -0800 (PST)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30QAdN2C013300;
        Thu, 26 Jan 2023 08:34:14 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3n8dua5ksm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 08:34:13 -0500
Received: from m0167089.ppops.net (m0167089.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30QDYDfG010618;
        Thu, 26 Jan 2023 08:34:13 -0500
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3n8dua5ksg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 08:34:13 -0500
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 30QDYBK4008426
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 26 Jan 2023 08:34:11 -0500
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by ASHBMBX8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Thu, 26 Jan
 2023 08:34:11 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Thu, 26 Jan 2023 08:34:11 -0500
Received: from tachici-Precision-5530.ad.analog.com ([10.48.65.156])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 30QDXoap000628;
        Thu, 26 Jan 2023 08:34:05 -0500
From:   Alexandru Tachici <alexandru.tachici@analog.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <yangyingliang@huawei.com>,
        <weiyongjun1@huawei.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <devicetree@vger.kernel.org>,
        <lennart@lfdomain.com>
Subject: [net-next v2 2/3] net: ethernet: adi: adin1110: add timestamping support
Date:   Thu, 26 Jan 2023 15:33:45 +0200
Message-ID: <20230126133346.61097-3-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126133346.61097-1-alexandru.tachici@analog.com>
References: <20230126133346.61097-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: z8kMgsbrXwHaLuLLj1AOz0aXyda6Kn-X
X-Proofpoint-ORIG-GUID: PwpgaBclT1vsu26wpvwshLoEvzcY1_9-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_05,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 bulkscore=0 malwarescore=0 phishscore=0
 mlxscore=0 spamscore=0 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301260131
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add timestamping support for RX/TX.

RX frames are automatically timestamped by the device at hardware
level when the feature is enabled. Time of day is the one used by the
MAC device.

When sending a TX frame to the MAC device, driver needs to send
a custom header ahead of the ethernet one where it specifies where
the MAC device should store the timestamp after the frame has
successfully been sent on the MII line. It has 3 timestamp slots that can
be read afterwards. Host will be notified by the TX_RDY IRQ.

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/ethernet/adi/adin1110.c | 426 +++++++++++++++++++++++++++-
 1 file changed, 416 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index 1b0caec847b9..73381753ae90 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -49,13 +49,27 @@
 #define   ADIN1110_FWD_UNK2HOST			BIT(2)
 
 #define ADIN1110_STATUS0			0x08
+#define   ADIN1110_TTSCAXM_P1(slot)		BIT(8 + (slot))
 
 #define ADIN1110_STATUS1			0x09
+#define   ADIN1110_TTSCAXM_P2(slot)		BIT(20 + (slot))
 #define   ADIN2111_P2_RX_RDY			BIT(17)
 #define   ADIN1110_SPI_ERR			BIT(10)
 #define   ADIN1110_RX_RDY			BIT(4)
+#define   ADIN1110_TX_RDY			BIT(3)
+
+#define ADIN1110_TTSCAXM_PY(slot, port)		((port) ? \
+						ADIN1110_TTSCAXM_P2(slot) : \
+						ADIN1110_TTSCAXM_P1(slot))
+
+#define ADIN1110_P1_TTSCXH(slot)		(0x10 + 2 * (slot))
+#define ADIN1110_P1_TTSCXL(slot)		(0x11 + 2 * (slot))
+
+#define ADIN1110_IMASK0				0x0C
+#define   ADIN1110_TTSCAXM_P1_IRQ(slot)		BIT(8 + (slot))
 
 #define ADIN1110_IMASK1				0x0D
+#define   ADIN1110_TTSCAXM_P2_IRQ(slot)		BIT(20 + (slot))
 #define   ADIN2111_RX_RDY_IRQ			BIT(17)
 #define   ADIN1110_SPI_ERR_IRQ			BIT(10)
 #define   ADIN1110_RX_RDY_IRQ			BIT(4)
@@ -104,7 +118,19 @@
 #define ADIN2111_RX_P2_FSIZE			0xC0
 #define ADIN2111_RX_P2				0xC1
 
+#define ADIN1110_P2_TTSCXH(slot)		(0xF0 + 2 * (slot))
+#define ADIN1110_P2_TTSCXL(slot)		(0xF1 + 2 * (slot))
+
+#define ADIN1110_PY_TTSCXH(slot, port)		((port) ? \
+						ADIN1110_P2_TTSCXH(slot) : \
+						ADIN1110_P1_TTSCXH(slot))
+
+#define ADIN1110_PY_TTSCXL(slot, port)		((port) ? \
+						ADIN1110_P2_TTSCXL(slot) \
+						: ADIN1110_P1_TTSCXL(slot))
+
 #define ADIN1110_CLEAR_STATUS0			0xFFF
+#define ADIN1110_CLEAR_STATUS1			0xFFFFFFFF
 
 /* MDIO_OP codes */
 #define ADIN1110_MDIO_OP_WR			0x1
@@ -126,12 +152,18 @@
 #define ADIN1110_CD				BIT(7)
 #define ADIN1110_WRITE				BIT(5)
 
+/* ADIN1110 frame header fields */
+#define ADIN1110_FRAME_HEADER_PORT		BIT(0)
+#define ADIN1110_FRAME_HEADER_TS_SLOT		GENMASK(7, 6)
+#define ADIN1110_FRAME_HEADER_TS_PRESENT	BIT(2)
+
 #define ADIN1110_MAX_BUFF			2048
 #define ADIN1110_MAX_FRAMES_READ		64
 #define ADIN1110_WR_HEADER_LEN			2
 #define ADIN1110_FRAME_HEADER_LEN		2
 #define ADIN1110_INTERNAL_SIZE_HEADER_LEN	2
 #define ADIN1110_RD_HEADER_LEN			3
+#define ADIN1110_TS_LEN				8
 #define ADIN1110_REG_LEN			4
 #define ADIN1110_FEC_LEN			4
 
@@ -182,6 +214,9 @@ struct adin1110_port_priv {
 	struct sk_buff_head		txq;
 	u32				nr;
 	u32				state;
+	bool				ts_rx_en;
+	bool				ts_tx_en;
+	struct sk_buff			*ts_slots[ADIN_MAC_MAX_TS_SLOTS];
 	struct adin1110_cfg		*cfg;
 };
 
@@ -198,7 +233,6 @@ struct adin1110_priv {
 	bool				append_crc;
 	struct adin1110_cfg		*cfg;
 	u32				tx_space;
-	u32				irq_mask;
 	bool				forwarding;
 	int				irq;
 	struct adin1110_port_priv	*ports[ADIN_MAC_MAX_PORTS];
@@ -333,8 +367,29 @@ static int adin1110_round_len(int len)
 	return len;
 }
 
+static void adin1110_get_rx_timestamp(struct sk_buff *rxb, int offset)
+{
+	struct skb_shared_hwtstamps *shhwtstamps = skb_hwtstamps(rxb);
+	struct timespec64 ts;
+	u16 frame_header;
+
+	frame_header = get_unaligned_be16(&rxb->data[0]);
+	if (!(frame_header & ADIN1110_FRAME_HEADER_TS_PRESENT))
+		return;
+
+	/* First data after the custom SPI frame header is the timestamp, if
+	 * it was signaled by the TS_PRESENT flag.
+	 */
+	ts.tv_sec = get_unaligned_be32(&rxb->data[offset]);
+	ts.tv_nsec = get_unaligned_be32(&rxb->data[offset + ADIN1110_REG_LEN]);
+
+	memset(shhwtstamps, 0, sizeof(*shhwtstamps));
+	shhwtstamps->hwtstamp = timespec64_to_ktime(ts);
+}
+
 static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
 {
+	u32 frame_header_len = ADIN1110_FRAME_HEADER_LEN;
 	struct adin1110_priv *priv = port_priv->priv;
 	u32 header_len = ADIN1110_RD_HEADER_LEN;
 	struct spi_transfer t;
@@ -357,10 +412,14 @@ static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
 	if (ret < 0)
 		return ret;
 
-	/* The read frame size includes the extra 2 bytes
-	 * from the  ADIN1110 frame header.
+	/* If timestamping is enabled the received data will also have an additional 8 bytes that
+	 * make up the seconds + nanoseconds timestamp.
 	 */
-	if (frame_size < ADIN1110_FRAME_HEADER_LEN + ADIN1110_FEC_LEN)
+	if (priv->ts_rx_append)
+		frame_header_len += ADIN1110_TS_LEN;
+
+	/* the read frame size includes the extra 2 bytes from the  ADIN1110 frame header */
+	if (frame_size < frame_header_len + ADIN1110_FEC_LEN)
 		return ret;
 
 	round_len = adin1110_round_len(frame_size);
@@ -394,7 +453,11 @@ static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
 		return ret;
 	}
 
-	skb_pull(rxb, header_len + ADIN1110_FRAME_HEADER_LEN);
+	if (priv->ts_rx_append)
+		adin1110_get_rx_timestamp(rxb, header_len + ADIN1110_FRAME_HEADER_LEN);
+
+	skb_pull(rxb, header_len + frame_header_len);
+
 	rxb->protocol = eth_type_trans(rxb, port_priv->netdev);
 
 	if ((port_priv->flags & IFF_ALLMULTI && rxb->pkt_type == PACKET_MULTICAST) ||
@@ -403,7 +466,7 @@ static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
 
 	netif_rx(rxb);
 
-	port_priv->rx_bytes += frame_size - ADIN1110_FRAME_HEADER_LEN;
+	port_priv->rx_bytes += frame_size - frame_header_len;
 	port_priv->rx_packets++;
 
 	return 0;
@@ -418,6 +481,7 @@ static int adin1110_write_fifo(struct adin1110_port_priv *port_priv,
 	int padding = 0;
 	int padded_len;
 	int round_len;
+	u16 val = 0;
 	int ret;
 
 	/* Pad frame to 64 byte length,
@@ -449,7 +513,14 @@ static int adin1110_write_fifo(struct adin1110_port_priv *port_priv,
 	}
 
 	/* mention the port on which to send the frame in the frame header */
-	frame_header = cpu_to_be16(port_priv->nr);
+	val = FIELD_PREP(ADIN1110_FRAME_HEADER_PORT, port_priv->nr);
+
+	/* Request TX capture for this frame in previously assign HW slot. */
+	if (port_priv->ts_tx_en && (skb_shinfo(txb)->tx_flags & SKBTX_IN_PROGRESS))
+		val |= FIELD_PREP(ADIN1110_FRAME_HEADER_TS_SLOT,
+				  txb->cb[0] + 1);
+
+	frame_header = cpu_to_be16(val);
 	memcpy(&priv->data[header_len], &frame_header,
 	       ADIN1110_FRAME_HEADER_LEN);
 
@@ -621,9 +692,72 @@ static void adin1110_wake_queues(struct adin1110_priv *priv)
 		netif_wake_queue(priv->ports[i]->netdev);
 }
 
+static int adin1110_read_tx_timestamp(struct adin1110_priv *priv,
+				      int port, int slot)
+{
+	struct skb_shared_hwtstamps shhwtstamps;
+	struct timespec64 ts;
+	struct sk_buff *skb;
+	u32 val;
+	int ret;
+
+	spin_lock(&priv->state_lock);
+	skb = priv->ports[port]->ts_slots[slot];
+	priv->ports[port]->ts_slots[slot] = NULL;
+	spin_unlock(&priv->state_lock);
+
+	/* Check if a SKB requested a timestamp from this slot. */
+	if (!skb)
+		return 0;
+
+	ret = adin1110_read_reg(priv, ADIN1110_PY_TTSCXH(slot, port), &val);
+	if (ret < 0)
+		goto out;
+
+	ts.tv_sec = val;
+
+	ret = adin1110_read_reg(priv, ADIN1110_PY_TTSCXL(slot, port), &val);
+	if (ret < 0)
+		goto out;
+
+	ts.tv_nsec = val;
+
+	/* Check if there is a timestamp actually saved. */
+	if (!ts.tv_sec && !ts.tv_nsec)
+		return 0;
+
+	shhwtstamps.hwtstamp = timespec64_to_ktime(ts);
+	skb_tstamp_tx(skb, &shhwtstamps);
+out:
+	dev_kfree_skb(skb);
+
+	return ret;
+}
+
+static int adin1110_handle_tx_timestamps(struct adin1110_priv *priv, u32 status)
+{
+	int port;
+	int slot;
+	int ret;
+
+	for (port = 0; port < priv->cfg->ports_nr; port++) {
+		if (!priv->ports[port]->ts_tx_en || !(status & ADIN1110_TX_RDY))
+			continue;
+
+		for (slot = 0; slot < ADIN_MAC_MAX_TS_SLOTS; slot++) {
+			ret = adin1110_read_tx_timestamp(priv, port, slot);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
 static irqreturn_t adin1110_irq(int irq, void *p)
 {
 	struct adin1110_priv *priv = p;
+	u32 status0;
 	u32 status1;
 	u32 val;
 	int ret;
@@ -631,6 +765,10 @@ static irqreturn_t adin1110_irq(int irq, void *p)
 
 	mutex_lock(&priv->lock);
 
+	ret = adin1110_read_reg(priv, ADIN1110_STATUS1, &status0);
+	if (ret < 0)
+		goto out;
+
 	ret = adin1110_read_reg(priv, ADIN1110_STATUS1, &status1);
 	if (ret < 0)
 		goto out;
@@ -639,6 +777,10 @@ static irqreturn_t adin1110_irq(int irq, void *p)
 		dev_warn_ratelimited(&priv->spidev->dev,
 				     "SPI CRC error on write.\n");
 
+	ret = adin1110_handle_tx_timestamps(priv, status1);
+	if (ret < 0)
+		goto out;
+
 	ret = adin1110_read_reg(priv, ADIN1110_TX_SPACE, &val);
 	if (ret < 0)
 		goto out;
@@ -654,7 +796,7 @@ static irqreturn_t adin1110_irq(int irq, void *p)
 
 	/* clear IRQ sources */
 	adin1110_write_reg(priv, ADIN1110_STATUS0, ADIN1110_CLEAR_STATUS0);
-	adin1110_write_reg(priv, ADIN1110_STATUS1, priv->irq_mask);
+	adin1110_write_reg(priv, ADIN1110_STATUS1, ADIN1110_CLEAR_STATUS1);
 
 out:
 	mutex_unlock(&priv->lock);
@@ -825,11 +967,193 @@ static int adin1110_ndo_set_mac_address(struct net_device *netdev, void *addr)
 	return adin1110_set_mac_address(netdev, sa->sa_data);
 }
 
+static int adin1110_hw_timestamping(struct adin1110_priv *priv, bool enable)
+{
+	int ret;
+
+	mutex_lock(&priv->lock);
+
+	ret = adin1110_set_bits(priv, ADIN1110_MAC_TS_CFG,
+				ADIN1110_MAC_TS_CFG_EN,
+				enable ? ADIN1110_MAC_TS_CFG_EN : 0);
+	if (ret < 0)
+		goto out;
+
+	ret = adin1110_set_bits(priv, ADIN1110_CONFIG1,
+				ADIN1110_CONFIG1_FTSE,
+				enable ? ADIN1110_CONFIG1_FTSE : 0);
+	if (ret < 0)
+		goto out;
+
+	/* use only 64 bit timestamps */
+	ret = adin1110_set_bits(priv, ADIN1110_CONFIG1, ADIN1110_CONFIG1_FTSS,
+				enable ? ADIN1110_CONFIG1_FTSS : 0);
+	if (ret < 0)
+		goto out;
+
+	/* Even if timestamping is enabled just for TX frames, RX frames
+	 * will start showing up with timestamps appended. Need to know
+	 * this when receivng frames from the SPI.
+	 */
+	priv->ts_rx_append = enable;
+
+	ret = adin1110_set_bits(priv, ADIN1110_CONFIG1, ADIN1110_CONFIG1_SYNC,
+				ADIN1110_CONFIG1_SYNC);
+out:
+	mutex_unlock(&priv->lock);
+
+	return ret;
+}
+
+/* ADIN1110 can track for each port 3 TX frames at a time that are stored
+ * for transfer in the FIFOs. When a TX frame will be sent by the MAC-PHY,
+ * a timestamp will be stored and an IRQ will be trigger, signaling
+ * the capture of the timestamp.
+ */
+static int adin1110_tx_ts_rdy_irq(struct adin1110_port_priv *port_priv,
+				  bool enable)
+{
+	struct adin1110_priv *priv = port_priv->priv;
+	int ret;
+	u32 val;
+
+	if (port_priv->nr)
+		val = ADIN1110_TTSCAXM_P2_IRQ(0) | ADIN1110_TTSCAXM_P2_IRQ(1) |
+		      ADIN1110_TTSCAXM_P2_IRQ(2);
+	else
+		val = ADIN1110_TTSCAXM_P1_IRQ(0) | ADIN1110_TTSCAXM_P1_IRQ(1) |
+		      ADIN1110_TTSCAXM_P1_IRQ(2);
+
+	mutex_lock(&priv->lock);
+	if (port_priv->nr)
+		ret = adin1110_set_bits(priv, ADIN1110_IMASK1, val,
+					enable ? 0 : val);
+	else
+		ret = adin1110_set_bits(priv, ADIN1110_IMASK0, val,
+					enable ? 0 : val);
+	mutex_unlock(&priv->lock);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int adin1110_hw_tx_timestamp_enable(struct adin1110_port_priv *port_priv)
+{
+	struct adin1110_priv *priv = port_priv->priv;
+	int ret;
+
+	ret = adin1110_tx_ts_rdy_irq(port_priv, true);
+	if (ret < 0)
+		return ret;
+
+	port_priv->ts_tx_en = true;
+
+	return adin1110_hw_timestamping(priv, true);
+}
+
+static int adin1110_hw_tx_timestamp_disable(struct adin1110_port_priv *port_priv)
+{
+	struct adin1110_priv *priv = port_priv->priv;
+	int ret;
+
+	ret = adin1110_tx_ts_rdy_irq(port_priv, false);
+	if (ret < 0)
+		return ret;
+
+	port_priv->ts_tx_en = false;
+
+	return adin1110_hw_timestamping(priv, false);
+}
+
+static int adin1110_hw_rx_timestamp_enable(struct adin1110_port_priv *port_priv)
+{
+	struct adin1110_priv *priv = port_priv->priv;
+
+	port_priv->ts_rx_en = true;
+
+	return adin1110_hw_timestamping(priv, true);
+}
+
+static int adin1110_hw_rx_timestamp_disable(struct adin1110_port_priv *port_priv)
+{
+	struct adin1110_priv *priv = port_priv->priv;
+
+	port_priv->ts_rx_en = false;
+
+	return adin1110_hw_timestamping(priv, false);
+}
+
+static int adin1110_ioctl_hw_timestamp(struct net_device *netdev,
+				       struct ifreq *rq)
+{
+	struct adin1110_port_priv *port_priv = netdev_priv(netdev);
+	struct hwtstamp_config config;
+	int ret;
+
+	if (copy_from_user(&config, rq->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	switch (config.tx_type) {
+	case HWTSTAMP_TX_OFF:
+		ret = adin1110_hw_tx_timestamp_disable(port_priv);
+		break;
+	case HWTSTAMP_TX_ON:
+		ret = adin1110_hw_tx_timestamp_enable(port_priv);
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	if (ret < 0)
+		return ret;
+
+	switch (config.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		ret = adin1110_hw_rx_timestamp_disable(port_priv);
+		break;
+	case HWTSTAMP_FILTER_ALL:
+	case HWTSTAMP_FILTER_SOME:
+	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+	case HWTSTAMP_FILTER_NTP_ALL:
+		ret = adin1110_hw_rx_timestamp_enable(port_priv);
+		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	if (ret < 0)
+		return ret;
+
+	if (copy_to_user(rq->ifr_data, &config, sizeof(config)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int adin1110_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 {
+	struct adin1110_port_priv *port_priv = netdev_priv(netdev);
+	struct adin1110_priv *priv = port_priv->priv;
+
 	if (!netif_running(netdev))
 		return -EINVAL;
 
+	if (priv->ptp_clock && cmd == SIOCSHWTSTAMP)
+		return adin1110_ioctl_hw_timestamp(netdev, rq);
+
 	return phy_do_ioctl(netdev, rq, cmd);
 }
 
@@ -941,7 +1265,6 @@ static int adin1110_net_open(struct net_device *net_dev)
 	if (priv->cfg->id == ADIN2111_MAC)
 		val |= ADIN2111_RX_RDY_IRQ;
 
-	priv->irq_mask = val;
 	ret = adin1110_write_reg(priv, ADIN1110_IMASK1, ~val);
 	if (ret < 0) {
 		netdev_err(net_dev, "Failed to enable chip IRQs: %d\n", ret);
@@ -996,6 +1319,14 @@ static int adin1110_net_stop(struct net_device *net_dev)
 	if (ret < 0)
 		return ret;
 
+	ret = adin1110_hw_rx_timestamp_disable(port_priv);
+	if (ret < 0)
+		return ret;
+
+	ret = adin1110_hw_tx_timestamp_disable(port_priv);
+	if (ret < 0)
+		return ret;
+
 	netif_stop_queue(port_priv->netdev);
 	flush_work(&port_priv->tx_work);
 	phy_stop(port_priv->phydev);
@@ -1016,17 +1347,62 @@ static void adin1110_tx_work(struct work_struct *work)
 	mutex_lock(&priv->lock);
 
 	while ((txb = skb_dequeue(&port_priv->txq))) {
+		if (skb_shinfo(txb)->tx_flags & SKBTX_SW_TSTAMP)
+			skb_tx_timestamp(txb);
+
 		ret = adin1110_write_fifo(port_priv, txb);
 		if (ret < 0)
 			dev_err_ratelimited(&priv->spidev->dev,
 					    "Frame write error: %d\n", ret);
 
-		dev_kfree_skb(txb);
+		/* If we do not expect a HW timestamp for the SKB free it here */
+		if (!(skb_shinfo(txb)->tx_flags & SKBTX_IN_PROGRESS))
+			dev_kfree_skb(txb);
 	}
 
 	mutex_unlock(&priv->lock);
 }
 
+static void adin1110_assign_ts_slot(struct adin1110_port_priv *port_priv,
+				    struct sk_buff *skb)
+{
+	struct adin1110_priv *priv = port_priv->priv;
+	int i;
+
+	if (!port_priv->ts_tx_en)
+		return;
+
+	spin_lock(&priv->state_lock);
+
+	for (i = 0; i < ADIN_MAC_MAX_TS_SLOTS; i++) {
+		if (!port_priv->ts_slots[i])
+			break;
+	}
+
+	/* This should not happen. Report that an error occurred. */
+	if (i == ADIN_MAC_MAX_TS_SLOTS) {
+		for (i = 0; i < ADIN_MAC_MAX_TS_SLOTS; i++) {
+			dev_kfree_skb(port_priv->ts_slots[i]);
+			port_priv->ts_slots[i] = NULL;
+		}
+
+		dev_warn_ratelimited(&priv->spidev->dev,
+				     "Time stamps slots full.\n");
+		i = 0;
+	}
+
+	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+
+	/* Need to store the slot number we will be using to return
+	 * the TX timestamp. This information will be shared with the device
+	 * when frame is sent over SPI.
+	 */
+	skb->cb[0] = i;
+	port_priv->ts_slots[i] = skb;
+
+	spin_unlock(&priv->state_lock);
+}
+
 static netdev_tx_t adin1110_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct adin1110_port_priv *port_priv = netdev_priv(dev);
@@ -1039,6 +1415,9 @@ static netdev_tx_t adin1110_start_xmit(struct sk_buff *skb, struct net_device *d
 		netif_stop_queue(dev);
 		netdev_ret = NETDEV_TX_BUSY;
 	} else {
+		if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
+			adin1110_assign_ts_slot(port_priv, skb);
+
 		priv->tx_space -= tx_space_needed;
 		skb_queue_tail(&port_priv->txq, skb);
 	}
@@ -1105,9 +1484,36 @@ static void adin1110_get_drvinfo(struct net_device *dev,
 	strscpy(di->bus_info, dev_name(dev->dev.parent), sizeof(di->bus_info));
 }
 
+static int adin1110_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
+{
+	struct adin1110_port_priv *port_priv = netdev_priv(dev);
+	struct adin1110_priv *priv = port_priv->priv;
+
+	info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE |
+				SOF_TIMESTAMPING_RX_SOFTWARE |
+				SOF_TIMESTAMPING_SOFTWARE    |
+				SOF_TIMESTAMPING_TX_HARDWARE |
+				SOF_TIMESTAMPING_RX_HARDWARE |
+				SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	info->tx_types = BIT(HWTSTAMP_TX_OFF) |
+			 BIT(HWTSTAMP_TX_ON);
+
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			   BIT(HWTSTAMP_FILTER_ALL);
+
+	if (priv->ptp_clock)
+		info->phc_index = ptp_clock_index(priv->ptp_clock);
+	else
+		info->phc_index = -1;
+
+	return 0;
+}
+
 static const struct ethtool_ops adin1110_ethtool_ops = {
 	.get_drvinfo		= adin1110_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
+	.get_ts_info		= adin1110_get_ts_info,
 	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
 	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
 };
-- 
2.34.1

