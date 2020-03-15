Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B6B185B22
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 09:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbgCOIIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 04:08:02 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50385 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727163AbgCOIIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 04:08:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 20E7A21F83;
        Sun, 15 Mar 2020 04:08:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 15 Mar 2020 04:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=F03pYUvxXf0Pggosw
        i8te+3HioL2E3fz1gWzKhDQZaE=; b=u03j5LCGMthD5tZzuCIz3mphmIad0A83d
        w7xABQNdQSk1YPaoVl07qn2uCc9TV1OrwHIwFBvUb684/2GdEhmVaDINmQkoBbXe
        6veVKgkfyTaHP0Iqyeosh9enSV35j/tYQIY/SWCPtF85j08PFenULXbJRB+I6Bdd
        +aWVjmnz19ALqic6HZ1WhAF3JhTHIVmRTzvjZKV3lpzCJeGN01jkRGYq8fCcHnIH
        cq1Aj8cUA3+jeMl2nab3/WAN8qBTH+nqEQ0ch7A6XVEj8bau1BNSTVOyZ8teN6Od
        liA2Dov/7lrzuvE+xBqloNZWlvEuZI5Lvv9k8mHULQv7cA2qIm/MQ==
X-ME-Sender: <xms:YOJtXq9D8nWmtZyR94A1yfMkDBD_P9U3hZPCrv9coXY3NuaSByqMfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeftddguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:YOJtXh8VKSDKLLUMwBW-r0iX4VM-fBUgHJzFlnJVqtI32sTN6nc0kg>
    <xmx:YOJtXktXE8sQGGHHwvtI3B1IMm46w6VWqb05_LG0R3mNETywY0btZA>
    <xmx:YOJtXvJsKQQKPS5dS5r17-FltNWigPOUGNJ-QvF5cYoiqwBWHpvARw>
    <xmx:YeJtXsxaBrT5eoxzN3UpVGTPzs2QzmmtXAySfczDb53swGuwWFkAUA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C4FE8328005D;
        Sun, 15 Mar 2020 04:07:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] mlxsw: reg: Increase register field length to 31 bits
Date:   Sun, 15 Mar 2020 10:07:35 +0200
Message-Id: <20200315080735.747353-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The cited commit set a value of 2^31-1 in order to "disable" the shaper
on a given a port. However, the length of the maximum shaper rate field
was not updated from 28 bits to 31 bits, which means ports are still
limited to ~268Gbps despite supporting speeds of 400Gbps.

Fix this by increasing the field's length.

Fixes: 92afbfedb77d ("mlxsw: reg: Increase MLXSW_REG_QEEC_MAS_DIS")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index dd6685156396..e05d1d1be2fd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -3572,7 +3572,7 @@ MLXSW_ITEM32(reg, qeec, mase, 0x10, 31, 1);
  * When in bytes mode, value is specified in units of 1000bps.
  * Access: RW
  */
-MLXSW_ITEM32(reg, qeec, max_shaper_rate, 0x10, 0, 28);
+MLXSW_ITEM32(reg, qeec, max_shaper_rate, 0x10, 0, 31);
 
 /* reg_qeec_de
  * DWRR configuration enable. Enables configuration of the dwrr and
-- 
2.24.1

