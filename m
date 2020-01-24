Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1925E1485EB
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389619AbgAXNYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:24:17 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34041 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389518AbgAXNYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:24:16 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 01EA021B74;
        Fri, 24 Jan 2020 08:24:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Jan 2020 08:24:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=tDEj6ozXFlr0WTrOlP7WK9FTbDZKsnENecvkvR/hW6s=; b=aWA7caKt
        6eFwF0CIz1Eh3wDXG1BAv6IzfyayaO6MqaT54xvT6DHErluc/papyUzUcxBORS6O
        03HSsxUc5xXuPSJGa1N2jMF/5QEmz71rYcUUjxIi5E5ra5isQxF2E5MzccDARMWT
        CugGrsg68nz71WJfIUWbU7JjxlGHzkROnNa0U33RFG6DVakSdTev58U4YIY4HWmu
        91zteu06gjVvNnjUA6+0ZIQasxiplJAtlo8woniCqm/5z+KhCTNJKjbEPliW2tUk
        RFJN+eBnzIwX4AdKY0M98/+AmvHWMvLtkqw6A9jutyCl6jPtxr/iPLG3XxTKeV5+
        msbdvttpkmyqyQ==
X-ME-Sender: <xms:_-8qXmSOLU9rtvU9Uw6D_pdRS73djIRnIFhG1ODMRi4JqxEPHd4qbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukeefrddutdejrdduvddtnecuvehluhhsthgvrh
    fuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:_-8qXl6WiLc_QeuLlhbcRXw6KYw9d4TsjpZA1n0jMjx3yay8VAMC5g>
    <xmx:_-8qXlgDwtIEwNqPs02iU6yknTF5GDMzaMKtUUlGC8hVHbi0s67FsA>
    <xmx:_-8qXgtO-PJWbybRpCos3yO_g_5gRr7mxvlh7-6i0xSiZ2N6OHQrzA>
    <xmx:APAqXoLZI4xCjc1pu7rXkZShEHScWqqvQPFysHsImrWx7--Sd-EZSw>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id EA30730610F6;
        Fri, 24 Jan 2020 08:24:13 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/14] mlxsw: reg: Add max_shaper_bs to QoS ETS Element Configuration
Date:   Fri, 24 Jan 2020 15:23:10 +0200
Message-Id: <20200124132318.712354-7-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200124132318.712354-1-idosch@idosch.org>
References: <20200124132318.712354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The QEEC register configures scheduling elements. One of the bits of
configuration is the burst size to use for the shaper installed on the
element. Add the necessary fields to support this configuration.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 0b80e75e87c3..afd712d8fd46 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -3602,6 +3602,21 @@ MLXSW_ITEM32(reg, qeec, dwrr, 0x18, 15, 1);
  */
 MLXSW_ITEM32(reg, qeec, dwrr_weight, 0x18, 0, 8);
 
+/* reg_qeec_max_shaper_bs
+ * Max shaper burst size
+ * Burst size is 2^max_shaper_bs * 512 bits
+ * For Spectrum-1: Range is: 5..25
+ * For Spectrum-2: Range is: 11..25
+ * Reserved when ptps = 1
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, qeec, max_shaper_bs, 0x1C, 0, 6);
+
+#define MLXSW_REG_QEEC_HIGHEST_SHAPER_BS	25
+#define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP1	5
+#define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP2	11
+#define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP3	5
+
 static inline void mlxsw_reg_qeec_pack(char *payload, u8 local_port,
 				       enum mlxsw_reg_qeec_hr hr, u8 index,
 				       u8 next_index)
-- 
2.24.1

