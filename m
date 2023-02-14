Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCDD6957DA
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 05:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbjBNEVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 23:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbjBNEVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 23:21:30 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9721A943;
        Mon, 13 Feb 2023 20:21:28 -0800 (PST)
From:   =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1676348486;
        bh=Nr1hUWm2/2M5eU6GyFPY5mncdEQNhoPi4PvyVBi93w0=;
        h=From:Date:Subject:To:Cc:From;
        b=i8AuTSsYAVGcSQbJGMYC9J1Wx6DTUaHXTV09m3GaIyRZFQ+umhvfLcYGNKdPYJs2z
         Rmq9KjLOPvAaGOgiSNpYjfUPQy8Xj/gk7uIKlZSMgOtmPjgO0JHGMBw7G+gmGndeps
         fvnzUOJeq8sn6kwBw07eNusM7ktVafqiEPpqieGA=
Date:   Tue, 14 Feb 2023 04:21:24 +0000
Subject: [PATCH] SUNRPC: make kobj_type structures constant
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20230214-kobj_type-sunrpc-v1-1-44ca9d5cb471@weissschuh.net>
X-B4-Tracking: v=1; b=H4sIAEMM62MC/x2N0QrCMAwAf2Xk2UBbRa2/IkPaGl10ZKVxooz9u
 8HHOzhuAaXGpHDqFmj0ZuVJDPymgzIkuRPy1RiCC1sX/A6fU35cXt9KqLO0WtAdYqR03LvoI1i
 WkxLmlqQMFso8jiZroxt//p9zv64/27nAUncAAAA=
To:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1676348484; l=2122;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=Nr1hUWm2/2M5eU6GyFPY5mncdEQNhoPi4PvyVBi93w0=;
 b=lqS/x8c3SB9xeYhRCDajxwhIe1CkgrRsNqRybzRH/vY87dyxMpJI+xVBuzRCkrE2laNiVuP5k
 9mLmKbteBXfAooRWK+4z1vgO0UUgZ18ogILtxqbr89NMnMhHA9mrMwU
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.")
the driver core allows the usage of const struct kobj_type.

Take advantage of this to constify the structure definitions to prevent
modification at runtime.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---

This is split out from the series
"net: make kobj_type structures constant" as requested in
https://lore.kernel.org/lkml/20230213201131.7ed238f9@kernel.org/
---
 net/sunrpc/sysfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/sysfs.c b/net/sunrpc/sysfs.c
index 1e05a2d723f4..0d0db4e1064e 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -36,7 +36,7 @@ rpc_sysfs_object_child_ns_type(const struct kobject *kobj)
 	return &net_ns_type_operations;
 }
 
-static struct kobj_type rpc_sysfs_object_type = {
+static const struct kobj_type rpc_sysfs_object_type = {
 	.release = rpc_sysfs_object_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.child_ns_type = rpc_sysfs_object_child_ns_type,
@@ -427,20 +427,20 @@ static struct attribute *rpc_sysfs_xprt_switch_attrs[] = {
 };
 ATTRIBUTE_GROUPS(rpc_sysfs_xprt_switch);
 
-static struct kobj_type rpc_sysfs_client_type = {
+static const struct kobj_type rpc_sysfs_client_type = {
 	.release = rpc_sysfs_client_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.namespace = rpc_sysfs_client_namespace,
 };
 
-static struct kobj_type rpc_sysfs_xprt_switch_type = {
+static const struct kobj_type rpc_sysfs_xprt_switch_type = {
 	.release = rpc_sysfs_xprt_switch_release,
 	.default_groups = rpc_sysfs_xprt_switch_groups,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.namespace = rpc_sysfs_xprt_switch_namespace,
 };
 
-static struct kobj_type rpc_sysfs_xprt_type = {
+static const struct kobj_type rpc_sysfs_xprt_type = {
 	.release = rpc_sysfs_xprt_release,
 	.default_groups = rpc_sysfs_xprt_groups,
 	.sysfs_ops = &kobj_sysfs_ops,

---
base-commit: f6feea56f66d34259c4222fa02e8171c4f2673d1
change-id: 20230214-kobj_type-sunrpc-0799ea860919

Best regards,
-- 
Thomas Weißschuh <linux@weissschuh.net>

