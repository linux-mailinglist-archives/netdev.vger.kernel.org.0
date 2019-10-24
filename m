Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6599EE35FF
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 16:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409516AbfJXOwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 10:52:33 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33791 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732293AbfJXOwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 10:52:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C02F521B10;
        Thu, 24 Oct 2019 10:52:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 24 Oct 2019 10:52:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=QJXXr10jtVMWkJj893hGQGpAkZiIW6A5BQ4tyaq05Ho=; b=AoJBdGr+
        CPGJdzdw50lProJd6/ZN49nouupHRzZtjgWhE2mMc6bFovTZwfARv9ZIsCt8Bpu8
        072/2LQz9AgZHAihnfnYAhPaHPEOs+vj9b43vYJkso8p2HKFySnwu6iulV9Z+Qaq
        xZzcTGItUz6JHsLJuAje9ccxyERKsZy1xncQoSUXu+9dTimWhRWZd1e+Ce4MDX85
        hy7NzsqEpLyuAxyJ07Yy3vPxcj+Wch9PuW9058DvR3FpE/LdZuSp6//oymcyVsuE
        WXIOtkIIiclVISx67Dj6/rhBbmhimTPSrokNi6hJB59IrKB1K1ReK/tPNtY4JLEC
        1b7cGaHOLsKqBA==
X-ME-Sender: <xms:rrqxXXP-OzBuAwebgAYwImf_CFOalZ3B9pdDXGAStZ2t6h_7AiaaVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrledugdekudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:rrqxXZD6CSjbMksMChjdfbf91YGKpu-iIe9WqAKGCIxK0lEYG8SMGg>
    <xmx:rrqxXa8zRA1nEA9zOpxdU8QdURrEDdA4h8whBDlkf8GmFZr1zUxfSA>
    <xmx:rrqxXbn_3-K2gKBkPNsvZgLw_7WhMFdTUGlfbeTw3mnPpz-VT89R_A>
    <xmx:rrqxXR8_ZbahHN0YfsOtG0osAdhJQHlFygTJ4pI-0hiie2aOgdVtZw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6515380064;
        Thu, 24 Oct 2019 10:52:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/3] mlxsw: reg: Increase size of MPAR register
Date:   Thu, 24 Oct 2019 17:51:47 +0300
Message-Id: <20191024145149.6417-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191024145149.6417-1-idosch@idosch.org>
References: <20191024145149.6417-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In new firmware versions this register is extended with a sampling rate
for Spectrum-2 and future ASICs.

Increase the size of the register to ensure the field is initialized to
0 which means every packet is mirrored.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index adb63a266fc7..7f7f1b95290f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8680,7 +8680,7 @@ mlxsw_reg_mpat_eth_rspan_l3_ipv6_pack(char *payload, u8 ttl,
  * properties.
  */
 #define MLXSW_REG_MPAR_ID 0x901B
-#define MLXSW_REG_MPAR_LEN 0x08
+#define MLXSW_REG_MPAR_LEN 0x0C
 
 MLXSW_REG_DEFINE(mpar, MLXSW_REG_MPAR_ID, MLXSW_REG_MPAR_LEN);
 
-- 
2.21.0

