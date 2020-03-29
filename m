Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 992C5196F38
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 20:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgC2SWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 14:22:20 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:50193 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728467AbgC2SWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 14:22:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 39A4E58090B;
        Sun, 29 Mar 2020 14:22:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 29 Mar 2020 14:22:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=6jeF+GuGnDUq5II/3VKlsTHDQ4l0u51Ayw3unk6YsBQ=; b=Y8m6Sunh
        Y54liBYoj6GF5f6Efbva0rmuAZSdv/ujafa/MNdiPENvYTyFoMGhQ4vK7HIxi9PZ
        EAGU0mocgdKPMGn3EzJ+iQ4oJ5yomVxJXIUqXqVMMOKfKKQBHXx6S5/dWCoeE3jF
        yRFw21BbjKFIlpjiykje4EBwiL7W+onMRHn5B3CZFXJc9pTUYQoqeoSCWHrTGQHL
        5iEKS7pt902cy0nBjDvrK9AVNAy3KD6kpiIutCd96GfwFb6W2YzJzMRRIwprfgzv
        9SvRwt7n99UlcxBoJ18tw4skYzoRAegUfoUox4fsNSrrWs8Z8dFw0ovSA7OMX4Ec
        tx7i3jl2CDnjrQ==
X-ME-Sender: <xms:W-eAXkfRTJ7AYzeJDcjZD0CeDzT1ebCUUGDNTZKSVtBS0VEkn7cmug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeifedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:W-eAXjY8ZwBIQc_PMlvv1JXkg13JoR3o4O0iluzb44YJAz188RPTUw>
    <xmx:W-eAXqCfjDntEEnZtl8g2fJWeqL0kmwfmfwfQSt_k_L75vBxZtVg4w>
    <xmx:W-eAXmK-ktW8lKAMO8Cwnp47ftVvqEl0bxZC1PSElkj1hBWmTQT8cw>
    <xmx:W-eAXmHf2fbXjXt4bbJDGaDFsRycjcQnRyfdKR5zJeRzk9J37aSCHw>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id AEBE03280059;
        Sun, 29 Mar 2020 14:22:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 08/15] mlxsw: reg: Extend QPCR register
Date:   Sun, 29 Mar 2020 21:21:12 +0300
Message-Id: <20200329182119.2207630-9-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200329182119.2207630-1-idosch@idosch.org>
References: <20200329182119.2207630-1-idosch@idosch.org>
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

