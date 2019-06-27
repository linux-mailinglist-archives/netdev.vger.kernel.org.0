Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42FD2583E3
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfF0Nxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:53:47 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50023 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726874AbfF0Nxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:53:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D2C52221B6;
        Thu, 27 Jun 2019 09:53:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 27 Jun 2019 09:53:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=LrlAygRyMoWOVyhRoWk1TG3yiHbYfMvTX7V5VS++sXE=; b=JhG5k3tK
        i620trYjMRA2rOV+VE0+DMU+uB+7Ze7atZUxGdckcyFMa1aeQfjHONbVqgMpk3xY
        avDJDTFNUlRgX7iGNQrAItTqLg2Ujg/Zfyn6F+sW6u2w8qf/eyExqsWam9bdMSlj
        IeJBID2RUx8jPaC4dSoP1bd7eso2w7PYCyexqVQEIr8XxFeEudOnLMf8PMD/LtC/
        Wduf4HiMzSZM0bmKBnIW9VZ8WZasMQAwQaWPULLhIjKm7584ApYXbSSzLV82KmmS
        kxkBRYa51h99fRW9cIO2+nzbPW1yKcEGhKrAYhdLperasBrTDGZaDoNtzoyfewpd
        FtjjghOrwwxgAg==
X-ME-Sender: <xms:aMoUXbmllS4-3Zv_Fj9fZ1nLzRQPEeiujIQ3bnLXr0VU-k_e5r2u_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepud
X-ME-Proxy: <xmx:aMoUXTG7TB5NJZXKN4XeYv3EvGvRcAEArhtlPrtPgdnVzxXP0OTviQ>
    <xmx:aMoUXcqmsKcMXma0wIpVTcMVuMT8EmpsMJfCW6BvRIVbnMudSMMM2Q>
    <xmx:aMoUXX6JRxnffatY0nyMeRz8BYwuIyV3K4862AbykBR3_KMfV7uHDw>
    <xmx:aMoUXT31UC_oY1YhMMlVWNTkOiCOtsZ3oTmXxVunpMRjFfmxJ20ipQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0DEB68005B;
        Thu, 27 Jun 2019 09:53:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/16] mlxsw: reg: Add Time Precision Packet Timestamping Reading
Date:   Thu, 27 Jun 2019 16:52:46 +0300
Message-Id: <20190627135259.7292-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627135259.7292-1-idosch@idosch.org>
References: <20190627135259.7292-1-idosch@idosch.org>
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

