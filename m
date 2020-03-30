Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D79DD1984AC
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgC3TjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:39:25 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:42829 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728405AbgC3TjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:39:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 952CF580542;
        Mon, 30 Mar 2020 15:39:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 30 Mar 2020 15:39:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=6jeF+GuGnDUq5II/3VKlsTHDQ4l0u51Ayw3unk6YsBQ=; b=mv/SG592
        kXkQgsBbkLbhRkx8v6qvT321yehoRsAzcNoO6kkk8EspuhHgeTcnjUZDStxcZQZM
        HcXQRwmMIezZbCkB2olbsRdix6asHRwmqxPUqGmzfIUDXuOvyZHx2j2UVNF7YphU
        bhZAjYj9hoGflu/rO1vpagCG9wVGFSAS5GtxTbqEswxqJ5buP92fBSKPfr8uCQGq
        f9S5XqiccQJKrenz5BNG3wR9E1fFVtQszqWQxKUszPIObcJBbYweSV+KiXq2wu/d
        GT8oAqR/e/ny/3EUYt5zHFjmVTu1X79x1hifsz2AZUfMt7NxY8bKRpMI2H5w0Qdu
        UEf7SyLPwViHvA==
X-ME-Sender: <xms:60qCXo1TRlumWO0zdWixTAvsje_3Y1a1bPD9muQAXrsYEnTPKQacRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:60qCXl-jiUaI_wyyy0wmnKWQmVVy8TB71GhrDRD3QxYU6RR3HGOPaQ>
    <xmx:60qCXhuJaZAhNv_I8TX4D26rUE6Pqu-BhdFEHDEM4dGV9_7orfCCYw>
    <xmx:60qCXjp4vk7eckHi24OqWHuVlQI29dBirZhDvMPJiHm5tdzIHCb7eA>
    <xmx:60qCXmx0KKfd4Yk1_J1HIWglwlHcRQB2_GZCA8xw1lRE3CKhgc8IXQ>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7BA11306C9F4;
        Mon, 30 Mar 2020 15:39:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 08/15] mlxsw: reg: Extend QPCR register
Date:   Mon, 30 Mar 2020 22:38:25 +0300
Message-Id: <20200330193832.2359876-9-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200330193832.2359876-1-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The QoS Policer Configuration Register (QPCR) is used to configure
hardware policers. Extend this register with following fields and
defines which will be used by subsequent patches:

1. Violate counter: reads number of packets dropped by the policer
2. Clear counter: to ensure we start counting from 0
3. Rate and burst size limits

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index bf7ef514becb..2cfc268fb8bb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -3296,6 +3296,12 @@ MLXSW_ITEM32(reg, qpcr, g, 0x00, 14, 2);
  */
 MLXSW_ITEM32(reg, qpcr, pid, 0x00, 0, 14);
 
+/* reg_qpcr_clear_counter
+ * Clear counters.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, qpcr, clear_counter, 0x04, 31, 1);
+
 /* reg_qpcr_color_aware
  * Is the policer aware of colors.
  * Must be 0 (unaware) for cpu port.
@@ -3393,6 +3399,17 @@ enum mlxsw_reg_qpcr_action {
  */
 MLXSW_ITEM32(reg, qpcr, violate_action, 0x18, 0, 4);
 
+/* reg_qpcr_violate_count
+ * Counts the number of times violate_action happened on this PID.
+ * Access: RW
+ */
+MLXSW_ITEM64(reg, qpcr, violate_count, 0x20, 0, 64);
+
+#define MLXSW_REG_QPCR_LOWEST_CIR	1
+#define MLXSW_REG_QPCR_HIGHEST_CIR	(2 * 1000 * 1000 * 1000) /* 2Gpps */
+#define MLXSW_REG_QPCR_LOWEST_CBS	4
+#define MLXSW_REG_QPCR_HIGHEST_CBS	24
+
 static inline void mlxsw_reg_qpcr_pack(char *payload, u16 pid,
 				       enum mlxsw_reg_qpcr_ir_units ir_units,
 				       bool bytes, u32 cir, u16 cbs)
-- 
2.24.1

