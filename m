Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297E5692DE5
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjBKDcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjBKDcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:32:41 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107E83A080;
        Fri, 10 Feb 2023 19:32:41 -0800 (PST)
From:   =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1676086359;
        bh=Dnmm9EisyiwPWuqnhssGEUllu7crqwubee2hNSJAG8M=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=UjNXQ4sAm7gTMcAakOeheIUjKxttHPo9C+4JiCsux7rS5UwNSceKBz3Shzghl6KKu
         OQhOEHOSPTivXqHhxF63huaf28WpWD1y3OvnSm304qTiT/OrfydCE8paw+1zS9BtBi
         tlcoz9c31vKJr0p+viUNWg9mSuXcmilCnhgVNVDo=
Date:   Sat, 11 Feb 2023 03:32:31 +0000
Subject: [PATCH 3/3] SUNRPC: make kobj_type structures constant
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20230211-kobj_type-net-v1-3-e3bdaa5d8a78@weissschuh.net>
References: <20230211-kobj_type-net-v1-0-e3bdaa5d8a78@weissschuh.net>
In-Reply-To: <20230211-kobj_type-net-v1-0-e3bdaa5d8a78@weissschuh.net>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1676086354; l=1793;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=Dnmm9EisyiwPWuqnhssGEUllu7crqwubee2hNSJAG8M=;
 b=onqdqhxHmXHKN3enPa0T1Gz+7MRmxgAzhxlzCohHIJ/hJg/Czxo1RYAbabMEPlV0N+RLZ5GqH
 xsbzqvl8cG2Bd5xlzMTSFa68hl+5U9j2Z1xgWzALMttXy92f2Ixd6zp
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

-- 
2.39.1

