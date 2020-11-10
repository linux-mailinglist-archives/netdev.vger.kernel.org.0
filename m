Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5445A2AD2CD
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731106AbgKJJui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:50:38 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:38411 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726467AbgKJJud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:50:33 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 707A2514;
        Tue, 10 Nov 2020 04:50:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 04:50:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=n6S3mJR7nECMWWNumQQiL/YstAEvycM/xAqQ/0yr9NU=; b=bl4YsInd
        fYtq29Epj/MlJzJ3+napcCK5iUWsm3lgoayYaCeLh3P8M6PNpsZJCz3vjHfVWL55
        WCbOYFvRKwUmp0B/7YG058KruWKcHdwi0bHsm16caPVNHSM7msyAYjNpZZsD4VHK
        QPADvktPH22l/tOl6ws7IRIfQcmFynNw+f69zFTmAss1LtdLljAV/gn7DxEimdC2
        58FTP64yZH6mAxCeBZZMmDMhcCDtL1UODwfumsqprpXvbBZK2h2yPvef9vdx4+8I
        z/RzDvB5hZHsVATotfBnLFm6aURgSlxJ2GzinjWBZbxBKTY2pcvIlQ7m3rvPj5Z1
        0uidilRXfEp41Q==
X-ME-Sender: <xms:Z2KqX_LobOyLmM-7gfLWi73VIgmw3eA0CUeLTu52H5jPEHZ9zc6QWA>
    <xme:Z2KqXzK3tmYuO3nkTkGgFeo5wMap94yfDrxfZeDq5wLPcYzzeA-UpiXXf7vV9qatb
    dFPUaDPzUNfGd4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:aGKqX3tE2xlFo2DPnToew1Q3yMTzHz3BCd_QWJ8mQOhRsYYxWxYs3g>
    <xmx:aGKqX4YWKhL1dLSgl5h8dbpJebaNk2v8n2iAcphEFgKmxgfLdqyoxA>
    <xmx:aGKqX2a_87_yk-eYeH77ioe4aMwZUwUetII8gJ4K4YZy0rZfxrQOIA>
    <xmx:aGKqX1kT1eLjWDodF11x_Ac2n6CVC0iGyX9xp6NXiYondXOraUpnmw>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id C8CD53280060;
        Tue, 10 Nov 2020 04:50:30 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/15] mlxsw: spectrum_router: Prepare work context for possible bulking
Date:   Tue, 10 Nov 2020 11:48:56 +0200
Message-Id: <20201110094900.1920158-12-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110094900.1920158-1-idosch@idosch.org>
References: <20201110094900.1920158-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

For XMDR register it is possible to carry multiple FIB entry
operations in a single write. However the FW does not restrict mixing
the types of operations, make the code easier and indicate the bulking
is ok only in case the bulk contains FIB operations of the same family
and event.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c | 15 +++++++++++++--
 .../net/ethernet/mellanox/mlxsw/spectrum_router.h |  1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index ede67a28f278..39c04e45f253 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6191,14 +6191,25 @@ static void mlxsw_sp_router_fib_event_work(struct work_struct *work)
 	struct mlxsw_sp_router *router = container_of(work, struct mlxsw_sp_router, fib_event_work);
 	struct mlxsw_sp_fib_entry_op_ctx op_ctx = {};
 	struct mlxsw_sp *mlxsw_sp = router->mlxsw_sp;
-	struct mlxsw_sp_fib_event *fib_event, *tmp;
+	struct mlxsw_sp_fib_event *next_fib_event;
+	struct mlxsw_sp_fib_event *fib_event;
 	LIST_HEAD(fib_event_queue);
 
 	spin_lock_bh(&router->fib_event_queue_lock);
 	list_splice_init(&router->fib_event_queue, &fib_event_queue);
 	spin_unlock_bh(&router->fib_event_queue_lock);
 
-	list_for_each_entry_safe(fib_event, tmp, &fib_event_queue, list) {
+	list_for_each_entry_safe(fib_event, next_fib_event,
+				 &fib_event_queue, list) {
+		/* Check if the next entry in the queue exists and it is
+		 * of the same type (family and event) as the currect one.
+		 * In that case it is permitted to do the bulking
+		 * of multiple FIB entries to a single register write.
+		 */
+		op_ctx.bulk_ok = !list_is_last(&fib_event->list, &fib_event_queue) &&
+				 fib_event->family == next_fib_event->family &&
+				 fib_event->event == next_fib_event->event;
+
 		switch (fib_event->family) {
 		case AF_INET:
 			mlxsw_sp_router_fib4_event_process(mlxsw_sp, &op_ctx,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 2f700ad74385..859a5c5d51d0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -61,6 +61,7 @@ enum mlxsw_sp_fib_entry_op {
 };
 
 struct mlxsw_sp_fib_entry_op_ctx {
+	u8 bulk_ok:1;
 	char ralue_pl[MLXSW_REG_RALUE_LEN];
 };
 
-- 
2.26.2

