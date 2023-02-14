Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0656957DE
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 05:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjBNEXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 23:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBNEXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 23:23:19 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3ACEC42;
        Mon, 13 Feb 2023 20:23:19 -0800 (PST)
From:   =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1676348597;
        bh=xCR+Ptx6qu9QePzl0md5Tsxq8IclLdgajMp2skUDWSc=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=QK+U+tAOYrAj0sZrQXIL6TtxMwQeg4kIi5sIYz4bQjcWHzm7tb1L98L5OuIJDUv8h
         3c0T9CeDXWqfd5DZ1TwhAKyijk/GqoVUVgch1Mol7sIMuVOUlkZhq2YawRDBfyueAE
         gC0Eb5ZDh84ZcACRBxf43N9Ef9a9cZIMf3fnB8c0=
Date:   Tue, 14 Feb 2023 04:23:11 +0000
Subject: [PATCH net-next v2 1/2] net: bridge: make kobj_type structure
 constant
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20230211-kobj_type-net-v2-1-013b59e59bf3@weissschuh.net>
References: <20230211-kobj_type-net-v2-0-013b59e59bf3@weissschuh.net>
In-Reply-To: <20230211-kobj_type-net-v2-0-013b59e59bf3@weissschuh.net>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1676348594; l=853;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=xCR+Ptx6qu9QePzl0md5Tsxq8IclLdgajMp2skUDWSc=;
 b=NWW0VjzsZXAn/xhCKGtkf9tdTULpu3c716ULCSOoUHvm0eU+6lpfQCeutakurBowPQzWRjAJT
 lXTqu66KFNgBXsiemMukK36YHwoVoJaWCkKdOOunCAB/+D9lL4lNrOD
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

Take advantage of this to constify the structure definition to prevent
modification at runtime.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 net/bridge/br_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index ad13b48e3e08..24f01ff113f0 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -269,7 +269,7 @@ static void brport_get_ownership(const struct kobject *kobj, kuid_t *uid, kgid_t
 	net_ns_get_ownership(dev_net(p->dev), uid, gid);
 }
 
-static struct kobj_type brport_ktype = {
+static const struct kobj_type brport_ktype = {
 #ifdef CONFIG_SYSFS
 	.sysfs_ops = &brport_sysfs_ops,
 #endif

-- 
2.39.1

