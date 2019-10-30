Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87591E993B
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 10:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfJ3JfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 05:35:07 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44233 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725822AbfJ3JfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 05:35:05 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 68BD921C24;
        Wed, 30 Oct 2019 05:35:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 30 Oct 2019 05:35:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=QJXXr10jtVMWkJj893hGQGpAkZiIW6A5BQ4tyaq05Ho=; b=uWqTuy6s
        wJCGdLbVSOKzDECNB8OsbnKx9OtRxSCcrufTCXY8SHPRdJzzjifAIopRJ9MAx0Gw
        BETB711irRAAAeQ5grXln2AhYbcNqjKYcYZfVhHYbWKSzrzUMRrmW2AFJHjcWdSy
        YzIi5oxRAKNr+zbRK7FqDSWKhT4l+Xxm6ShU7BCebqEKDX698KUeUAMpl0gGOdLh
        eHCKJw0xbi+TVOjux5xetvqaUrVRMLPGjcrigUOE7y08HuJg8AQ76Ia91BPjeyth
        WvNpdFT3yxZbpSzlPemrWJE1v4Sce6nfoS6dZUYi37dPMIkshkamYHNvxVNfa2jw
        fyzkx235yzlepw==
X-ME-Sender: <xms:SFm5XbCxfjfdqOU721DXD4XxV06z346uhh07rlAE9WZ3CC6iP2eAFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtfedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:SFm5XWW71UCwxGNP6V7qkcqxIrMiyxzVZzkSBf_7p-NK0LRqW6JzHg>
    <xmx:SFm5XfAiA-ukMEoFfJt_9Ur5iIquvy3FCK2wbstNOHQ27nKWZ1nvdw>
    <xmx:SFm5XUgiOPJZGhaeyU9gUFAHsY-YV3Kf6kYq07dxUglK5ceWdO8yKQ>
    <xmx:SFm5XXsbKPhCOTFP0HhgpQ63DrY9nVYmWmYSLCxsA7KHxFanoiIHEQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4BBD63060068;
        Wed, 30 Oct 2019 05:35:03 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 1/4] mlxsw: reg: Increase size of MPAR register
Date:   Wed, 30 Oct 2019 11:34:48 +0200
Message-Id: <20191030093451.26325-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030093451.26325-1-idosch@idosch.org>
References: <20191030093451.26325-1-idosch@idosch.org>
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

