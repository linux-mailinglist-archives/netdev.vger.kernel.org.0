Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D9B61454
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfGGIAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:00:15 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:60115 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGIAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:00:14 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id EC1AC2861;
        Sun,  7 Jul 2019 04:00:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:00:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=9iRvZl0IQidkR6juRVX4WlmDZpKp7y0LGdvicOknTuk=; b=affncZvj
        ehB9Zh5jtTMJidVuvpNXAJzdBStub5HDrURulcSSOJ2o+huTdYMdUDjFS3sFAa0r
        /rKWRaVPh9RnoNHWL+6I5NVCvJIobW4O70qxu9lDw3X7l8GsnaiAQsaXYnFGrJl4
        mqoxEhctMOVLc0EoaMYiwF6TrmoKfR0Uob4YImhSJ+4l1V8K5PWPR2i5sNpeA6yh
        KTCeu1rRqxqoWV3CxHt2HHKqNIxu2RfGmqZamAhOVy1oJ/IdUjGttWUqRP2i1m8k
        TgdHSk3WOohPQwwBt+a3OAz4orxjAR7dJx70zwLn6VhnnPoZ50zSqpcpSZiKmsmy
        PtSFpk9vi7MVDQ==
X-ME-Sender: <xms:jaYhXShlhse5Tmo2f1xo4T8LVttdWT5OnteiZebvQtrJix6PJgb1Qg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:jaYhXc1JZhc8x0d6P3MInn6UjNNvoeAZmIYBvHZKhN8i1VYif5JN3A>
    <xmx:jaYhXY6FgLE_ZznpMrmFiK7sACjebNCMm9PVvubhGIJ_4rIITYRtxg>
    <xmx:jaYhXWqbA-0l7Df7fxOqQLkwQi8wcxRehW8ms33Z09TmyWngsw_Kfg>
    <xmx:jaYhXYW5-RQD0577HB98oNNhiDiXsssZ3LEjB_dSfFxSEiCEMAQHrw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5F65F380079;
        Sun,  7 Jul 2019 04:00:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/11] mlxsw: Add layer 2 discard trap IDs
Date:   Sun,  7 Jul 2019 10:58:26 +0300
Message-Id: <20190707075828.3315-10-idosch@idosch.org>
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

Add the trap IDs used to report layer 2 drops.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/trap.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 19202bdb5105..7618f084cae9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -66,6 +66,13 @@ enum {
 	MLXSW_TRAP_ID_NVE_ENCAP_ARP = 0xBD,
 	MLXSW_TRAP_ID_ROUTER_ALERT_IPV4 = 0xD6,
 	MLXSW_TRAP_ID_ROUTER_ALERT_IPV6 = 0xD7,
+	MLXSW_TRAP_ID_DISCARD_ING_PACKET_SMAC_MC = 0x140,
+	MLXSW_TRAP_ID_DISCARD_ING_SWITCH_VTAG_ALLOW = 0x148,
+	MLXSW_TRAP_ID_DISCARD_ING_SWITCH_VLAN = 0x149,
+	MLXSW_TRAP_ID_DISCARD_ING_SWITCH_STP = 0x14A,
+	MLXSW_TRAP_ID_DISCARD_LOOKUP_SWITCH_UC = 0x150,
+	MLXSW_TRAP_ID_DISCARD_LOOKUP_SWITCH_MC_NULL = 0x151,
+	MLXSW_TRAP_ID_DISCARD_LOOKUP_SWITCH_LB = 0x152,
 	MLXSW_TRAP_ID_ACL0 = 0x1C0,
 	/* Multicast trap used for routes with trap action */
 	MLXSW_TRAP_ID_ACL1 = 0x1C1,
-- 
2.20.1

