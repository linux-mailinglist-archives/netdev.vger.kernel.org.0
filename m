Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 832771485EC
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389641AbgAXNYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:24:20 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37635 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389518AbgAXNYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:24:19 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 638F821F48;
        Fri, 24 Jan 2020 08:24:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Jan 2020 08:24:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=/u/I2Kd3ROKhIO5MZHmTFMtOKZLNNhEo3X+BI8ZXFjY=; b=vJRp5+JX
        2WL913LCNsIHoS2GG6KW1/+qfNR9KX+WJomvRih8jCzGzSNM+fM76G7T7p1uGiUq
        mr8k9QOjJ5PJpPTyF/CqrGOYdlbZiJ+ps8TX30fwSbzXHh49kXAApSasKviix2gy
        RDjIPq5EncrbXt6j3G4tRxW0dKPxRgmGQPCkwL9FUdZir66O0phXfjIjs7jCgkjb
        xzXnGvT0EGHx8AFPGi6mcx6jzSUdwNARUeup0yAAzGQyfUpgU6+qfXLvWi40W2ob
        s4uX1t6wj8fFPIAdoRJrRygSELkiAcoXerjYk+Z0GIRNZLg7vfc3jEb5tE1mr2iY
        KE8+V4cKVxvRsw==
X-ME-Sender: <xms:AvAqXi4jhwJvwZ7oMl3l8KkED5nEbi2PSQQoYZf-yoLu7MY6T8wZBA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukeefrddutdejrdduvddtnecuvehluhhsthgvrh
    fuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:AvAqXhHdy_fEwJmPChXruA2zCz4tsRyGy31ybEeB78Fo3VROercP0Q>
    <xmx:AvAqXiVkzhSTwgUP9IeJ57NBWLDeTxK4Cz3JWSui7OxZnaEio7Q2Sg>
    <xmx:AvAqXlUyuTQ6BSEz8eDwCC50ivGXwtggunJAHrqflZ7ElWi8yriVzA>
    <xmx:AvAqXsyw1kQB50azpIFlBiTMA_wypxfx19sUrdDhekK8WGtCV8jK_A>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D1D030610F6;
        Fri, 24 Jan 2020 08:24:16 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/14] mlxsw: reg: Increase MLXSW_REG_QEEC_MAS_DIS
Date:   Fri, 24 Jan 2020 15:23:11 +0200
Message-Id: <20200124132318.712354-8-idosch@idosch.org>
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

As the port speeds grow, the current value of "unlimited shaper",
200000000Kbps, might become lower than the actually supported speeds. Bump
it to the maximum value that fits in the corresponding QEEC field, which is
about 2.1Tbps.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index afd712d8fd46..dd6685156396 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -3563,8 +3563,8 @@ MLXSW_ITEM32(reg, qeec, min_shaper_rate, 0x0C, 0, 28);
  */
 MLXSW_ITEM32(reg, qeec, mase, 0x10, 31, 1);
 
-/* A large max rate will disable the max shaper. */
-#define MLXSW_REG_QEEC_MAS_DIS	200000000	/* Kbps */
+/* The largest max shaper value possible to disable the shaper. */
+#define MLXSW_REG_QEEC_MAS_DIS	((1u << 31) - 1)	/* Kbps */
 
 /* reg_qeec_max_shaper_rate
  * Max shaper information rate.
-- 
2.24.1

