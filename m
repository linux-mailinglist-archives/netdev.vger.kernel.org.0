Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C8761453
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfGGIAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:00:12 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:60581 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGIAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:00:12 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 748372775;
        Sun,  7 Jul 2019 04:00:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:00:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=/MIZRIxMHRTVD0T8vaPtS5/Lqz//EZxBTdz6jdTEtKg=; b=cIT9V6wJ
        VhgKTzjyDYPUAWkyS9Tc1RA9C0LWv00gTaEZPLI9It8Uq2TCnS4pXtIVSlDA1pBn
        Vd3kIIknoFqd3H6k5fK7grXiPgbwjYTablwAUMglzayOnzST39rf1L98udvL+AEQ
        v7hsZd1n8sG3DQj6BVvsVitMbH9BciBDx8wxZ1KK8fuDKD+z/v6CIXya2GNRBl4J
        f/d0oaptQAqbyP9hyL1BKGONKKKG8s3IMler4HJxhFHzABTRY3lNuKYQtj7imlGF
        uZQd3tiM5Aq5yHTtBcOl0bxHnfKRoeG4hrz5NXkTSWpL+CHEMn3Hn265X0gcECTN
        7+w+RehFVPJM9w==
X-ME-Sender: <xms:i6YhXfwTzE7WOcuATdW0rTboHN7Fu4SfRN7mewo3AE0b-byqQHzv3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:i6YhXRYILvJPlNrX-Xfla3xZoy_Of3EY-jMRgxa2YqOjme1SyNz_1A>
    <xmx:i6YhXbC-_tT2hqtiQLXnMwZtwcFJX3Ddx0rIsTE0hzjCtLSLpAHSHA>
    <xmx:i6YhXYMiRXwILltZvpsPyJnNg0oRt3Y4Z-8rMympy6l1guJpL-x4rg>
    <xmx:i6YhXfo1ljuwUC69RZrAZlFC60EvjKGGBl-DPomEcE7cLpvHNpdGHw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id CDDFF380086;
        Sun,  7 Jul 2019 04:00:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/11] mlxsw: reg: Add new trap action
Date:   Sun,  7 Jul 2019 10:58:25 +0300
Message-Id: <20190707075828.3315-9-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707075828.3315-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Subsequent patches will add discard traps support in mlxsw. The driver
cannot configure such traps with a normal trap action, but need to use
exception trap action, which also increments an error counter.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index ead36702549a..55211218ec1a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5559,6 +5559,7 @@ enum mlxsw_reg_hpkt_action {
 	MLXSW_REG_HPKT_ACTION_DISCARD,
 	MLXSW_REG_HPKT_ACTION_SOFT_DISCARD,
 	MLXSW_REG_HPKT_ACTION_TRAP_AND_SOFT_DISCARD,
+	MLXSW_REG_HPKT_ACTION_TRAP_EXCEPTION_TO_CPU,
 };
 
 /* reg_hpkt_action
@@ -5569,6 +5570,7 @@ enum mlxsw_reg_hpkt_action {
  * 3 - Discard.
  * 4 - Soft discard (allow other traps to act on the packet).
  * 5 - Trap and soft discard (allow other traps to overwrite this trap).
+ * 6 - Trap to CPU (CPU receives sole copy) and count it as error.
  * Access: RW
  *
  * Note: Must be set to 0 (forward) for event trap IDs, as they are already
-- 
2.20.1

