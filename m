Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAD340A694
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 08:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240150AbhINGPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 02:15:51 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35401 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240085AbhINGPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 02:15:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id F02D45C00AC;
        Tue, 14 Sep 2021 02:14:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 14 Sep 2021 02:14:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=5wdKpatp/vz53RJUWE1o8xA4CJUNHeMQiQeWSHUbtmg=; b=U1kZxewL
        xYMax+hUztWW0D/gw/JHeVTWtgmoG8QLTbSd/bOsq7/zx8PSMdrJrp6TYjKDnskU
        6oJL05G12z3PqPNne4wRqrLL6zD+NTfTt7GwTLp/ydfpHriwe7JBQbiUEdTUQUgT
        g/Bi2CPzT4SX6sCvP97cu0HyzZmekupUsGzJbijUdSamQ0BGBbeabl8i1B5dHBq8
        KliPKWtvKFizMz1q72C5VrSV+tdeTwt/JbiRz6Ow1u2DYnpeUWjWuZdXty4gYlHB
        jOk8CILiuSZpEhz7sNcprnUKlBemeI65y2teckVN+QTBlH8tM6Kq4EKgUudi8yZe
        AIY5JoHxeiGwsQ==
X-ME-Sender: <xms:xj1AYeERgv5PesuhLep6IqF1slQ3uK_LxLa766lJo2WwPz1LSaepKw>
    <xme:xj1AYfXe0xqdBUfOPiYiFdONEGBlRQ9Cf_w_66sJK87mupagFekQKQkTE0YnPBcgh
    GKom27yyaUtewM>
X-ME-Received: <xmr:xj1AYYJkwr1upDPNi8BANV4eonZKtzlWglnH9h8rxWguGZL7ytIZHNaYR7v1XLmSDIXRDvmE7O382buwkz7SdO80UK8Z6V_Mww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedunecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:xj1AYYEDzRqsv3e2oX3fEOE81evRcJLv6VkChhQQj_Lu1LeCjuuRqA>
    <xmx:xj1AYUUooO8BjWqXyVhKCW2wlvVRaRgmOG2kqs_-dLRdUXGxQSNRdg>
    <xmx:xj1AYbO_4WF6rag9e7z5ogtVC9rJYwQ5VrQGu3QXTkbW6zhKMuyBiw>
    <xmx:xj1AYbRIsZtMyZe_0nf-jzpccQl1csXCE7dYCuMhm11X7VNCMyCMXw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 02:14:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/8] mlxsw: reg: Add Port Module To local DataBase Register
Date:   Tue, 14 Sep 2021 09:13:28 +0300
Message-Id: <20210914061330.226000-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914061330.226000-1-idosch@idosch.org>
References: <20210914061330.226000-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The PMTDB register allows to query the possible module<->local port
mapping than can be used in PMLP. It does not represent the actual/current
mapping of the local to module. Actual mapping is only defined by PMLP.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 64 +++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 97f46c468c6d..390e467050f3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5766,6 +5766,69 @@ static inline void mlxsw_reg_pplr_pack(char *payload, u8 local_port,
 				 MLXSW_REG_PPLR_LB_TYPE_BIT_PHY_LOCAL : 0);
 }
 
+/* PMTDB - Port Module To local DataBase Register
+ * ----------------------------------------------
+ * The PMTDB register allows to query the possible module<->local port
+ * mapping than can be used in PMLP. It does not represent the actual/current
+ * mapping of the local to module. Actual mapping is only defined by PMLP.
+ */
+#define MLXSW_REG_PMTDB_ID 0x501A
+#define MLXSW_REG_PMTDB_LEN 0x40
+
+MLXSW_REG_DEFINE(pmtdb, MLXSW_REG_PMTDB_ID, MLXSW_REG_PMTDB_LEN);
+
+/* reg_pmtdb_slot_index
+ * Slot index (0: Main board).
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pmtdb, slot_index, 0x00, 24, 4);
+
+/* reg_pmtdb_module
+ * Module number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pmtdb, module, 0x00, 16, 8);
+
+/* reg_pmtdb_ports_width
+ * Port's width
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pmtdb, ports_width, 0x00, 12, 4);
+
+/* reg_pmtdb_num_ports
+ * Number of ports in a single module (split/breakout)
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pmtdb, num_ports, 0x00, 8, 4);
+
+enum mlxsw_reg_pmtdb_status {
+	MLXSW_REG_PMTDB_STATUS_SUCCESS,
+};
+
+/* reg_pmtdb_status
+ * Status
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, pmtdb, status, 0x00, 0, 4);
+
+/* reg_pmtdb_port_num
+ * The local_port value which can be assigned to the module.
+ * In case of more than one port, port<x> represent the /<x> port of
+ * the module.
+ * Access: RO
+ */
+MLXSW_ITEM16_INDEXED(reg, pmtdb, port_num, 0x04, 0, 8, 0x02, 0x00, false);
+
+static inline void mlxsw_reg_pmtdb_pack(char *payload, u8 slot_index, u8 module,
+					u8 ports_width, u8 num_ports)
+{
+	MLXSW_REG_ZERO(pmtdb, payload);
+	mlxsw_reg_pmtdb_slot_index_set(payload, slot_index);
+	mlxsw_reg_pmtdb_module_set(payload, module);
+	mlxsw_reg_pmtdb_ports_width_set(payload, ports_width);
+	mlxsw_reg_pmtdb_num_ports_set(payload, num_ports);
+}
+
 /* PMPE - Port Module Plug/Unplug Event Register
  * ---------------------------------------------
  * This register reports any operational status change of a module.
@@ -12247,6 +12310,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(pspa),
 	MLXSW_REG(pmaos),
 	MLXSW_REG(pplr),
+	MLXSW_REG(pmtdb),
 	MLXSW_REG(pmpe),
 	MLXSW_REG(pddr),
 	MLXSW_REG(pllp),
-- 
2.31.1

