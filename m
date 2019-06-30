Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB5945AECA
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 08:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfF3GFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 02:05:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51261 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726525AbfF3GFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 02:05:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 70733210DC;
        Sun, 30 Jun 2019 02:05:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 Jun 2019 02:05:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=LrlAygRyMoWOVyhRoWk1TG3yiHbYfMvTX7V5VS++sXE=; b=1NqELG95
        SoTFCNhpP0gCqdhyGPohZBPvHB6YHx2YLlbI/wGoOeyloKYIIX9jDOrN6pguS5pU
        lK/nxOJ2AeWaFwK2RitjPv5qRx7eUWy8fsB9PlU5t0//UhA8yMvrZDs0OC1mqIo0
        gYVm48Mp3BUL9/yzRweNqtztjEEUKvmHrKh3SVFI1Mdv3L90fTFuLiml/uPH1yKR
        bVCDBWjAUAykbjSuabEFrc0XsvwbG5Ogc5viWkGAT46RGcnGpYJ8cfqeMqUghik3
        kjcUhIQT2q2SqXMLpq5Eq+ylCTrh9NgaGsd/FmUhvzb2Ews9FL9U6SHgahZvBezX
        3PTPn5pkG2+RQQ==
X-ME-Sender: <xms:PVEYXc1n4fFXwEFZKe4v8OewEjvWPJkC5KRE73At0eeJe1EKl4BZRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdefgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:PVEYXTJpfCIxjhilayQo4shcIvzCuhz_OLol9uoJaIK1pb1syhelKA>
    <xmx:PVEYXa1wMmLw3Zw_aYul4a8fOSJ0_zSHSsvwylmNy7IU8lZLev7suA>
    <xmx:PVEYXWx1g_y7G5uLGFVksPXpSaLCIrBxNOipufw_O_yGp6J6v2XShg>
    <xmx:PVEYXb1Ny1PLt3rqve3YSjGzMXCDWb0ZQjivNk_QjoUTPCprE0R0BQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 95AFB80059;
        Sun, 30 Jun 2019 02:05:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 03/16] mlxsw: reg: Add Time Precision Packet Timestamping Reading
Date:   Sun, 30 Jun 2019 09:04:47 +0300
Message-Id: <20190630060500.7882-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190630060500.7882-1-idosch@idosch.org>
References: <20190630060500.7882-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The MTPPTR is used for reading the per port PTP timestamp FIFO.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 110 ++++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 5c5f63289468..197599890bdf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9185,6 +9185,115 @@ static inline void mlxsw_reg_mtpppc_pack(char *payload, u16 ing, u16 egr)
 	mlxsw_reg_mtpppc_egr_timestamp_message_type_set(payload, egr);
 }
 
+/* MTPPTR - Time Precision Packet Timestamping Reading
+ * ---------------------------------------------------
+ * The MTPPTR is used for reading the per port PTP timestamp FIFO.
+ * There is a trap for packets which are latched to the timestamp FIFO, thus the
+ * SW knows which FIFO to read. Note that packets enter the FIFO before been
+ * trapped. The sequence number is used to synchronize the timestamp FIFO
+ * entries and the trapped packets.
+ * Reserved when Spectrum-2.
+ */
+
+#define MLXSW_REG_MTPPTR_ID 0x9091
+#define MLXSW_REG_MTPPTR_BASE_LEN 0x10 /* base length, without records */
+#define MLXSW_REG_MTPPTR_REC_LEN 0x10 /* record length */
+#define MLXSW_REG_MTPPTR_REC_MAX_COUNT 4
+#define MLXSW_REG_MTPPTR_LEN (MLXSW_REG_MTPPTR_BASE_LEN +		\
+		    MLXSW_REG_MTPPTR_REC_LEN * MLXSW_REG_MTPPTR_REC_MAX_COUNT)
+
+MLXSW_REG_DEFINE(mtpptr, MLXSW_REG_MTPPTR_ID, MLXSW_REG_MTPPTR_LEN);
+
+/* reg_mtpptr_local_port
+ * Not supported for CPU port.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mtpptr, local_port, 0x00, 16, 8);
+
+enum mlxsw_reg_mtpptr_dir {
+	MLXSW_REG_MTPPTR_DIR_INGRESS,
+	MLXSW_REG_MTPPTR_DIR_EGRESS,
+};
+
+/* reg_mtpptr_dir
+ * Direction.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mtpptr, dir, 0x00, 0, 1);
+
+/* reg_mtpptr_clr
+ * Clear the records.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, mtpptr, clr, 0x04, 31, 1);
+
+/* reg_mtpptr_num_rec
+ * Number of valid records in the response
+ * Range 0.. cap_ptp_timestamp_fifo
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mtpptr, num_rec, 0x08, 0, 4);
+
+/* reg_mtpptr_rec_message_type
+ * MessageType field as defined by IEEE 1588 Each bit corresponds to a value
+ * (e.g. Bit0: Sync, Bit1: Delay_Req)
+ * Access: RO
+ */
+MLXSW_ITEM32_INDEXED(reg, mtpptr, rec_message_type,
+		     MLXSW_REG_MTPPTR_BASE_LEN, 8, 4,
+		     MLXSW_REG_MTPPTR_REC_LEN, 0, false);
+
+/* reg_mtpptr_rec_domain_number
+ * DomainNumber field as defined by IEEE 1588
+ * Access: RO
+ */
+MLXSW_ITEM32_INDEXED(reg, mtpptr, rec_domain_number,
+		     MLXSW_REG_MTPPTR_BASE_LEN, 0, 8,
+		     MLXSW_REG_MTPPTR_REC_LEN, 0, false);
+
+/* reg_mtpptr_rec_sequence_id
+ * SequenceId field as defined by IEEE 1588
+ * Access: RO
+ */
+MLXSW_ITEM32_INDEXED(reg, mtpptr, rec_sequence_id,
+		     MLXSW_REG_MTPPTR_BASE_LEN, 0, 16,
+		     MLXSW_REG_MTPPTR_REC_LEN, 0x4, false);
+
+/* reg_mtpptr_rec_timestamp_high
+ * Timestamp of when the PTP packet has passed through the port Units of PLL
+ * clock time.
+ * For Spectrum-1 the PLL clock is 156.25Mhz and PLL clock time is 6.4nSec.
+ * Access: RO
+ */
+MLXSW_ITEM32_INDEXED(reg, mtpptr, rec_timestamp_high,
+		     MLXSW_REG_MTPPTR_BASE_LEN, 0, 32,
+		     MLXSW_REG_MTPPTR_REC_LEN, 0x8, false);
+
+/* reg_mtpptr_rec_timestamp_low
+ * See rec_timestamp_high.
+ * Access: RO
+ */
+MLXSW_ITEM32_INDEXED(reg, mtpptr, rec_timestamp_low,
+		     MLXSW_REG_MTPPTR_BASE_LEN, 0, 32,
+		     MLXSW_REG_MTPPTR_REC_LEN, 0xC, false);
+
+static inline void mlxsw_reg_mtpptr_unpack(const char *payload,
+					   unsigned int rec,
+					   u8 *p_message_type,
+					   u8 *p_domain_number,
+					   u16 *p_sequence_id,
+					   u64 *p_timestamp)
+{
+	u32 timestamp_high, timestamp_low;
+
+	*p_message_type = mlxsw_reg_mtpptr_rec_message_type_get(payload, rec);
+	*p_domain_number = mlxsw_reg_mtpptr_rec_domain_number_get(payload, rec);
+	*p_sequence_id = mlxsw_reg_mtpptr_rec_sequence_id_get(payload, rec);
+	timestamp_high = mlxsw_reg_mtpptr_rec_timestamp_high_get(payload, rec);
+	timestamp_low = mlxsw_reg_mtpptr_rec_timestamp_low_get(payload, rec);
+	*p_timestamp = (u64)timestamp_high << 32 | timestamp_low;
+}
+
 /* MTPTPT - Monitoring Precision Time Protocol Trap Register
  * ---------------------------------------------------------
  * This register is used for configuring under which trap to deliver PTP
@@ -10292,6 +10401,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mgpc),
 	MLXSW_REG(mprs),
 	MLXSW_REG(mtpppc),
+	MLXSW_REG(mtpptr),
 	MLXSW_REG(mtptpt),
 	MLXSW_REG(mgpir),
 	MLXSW_REG(tngcr),
-- 
2.20.1

