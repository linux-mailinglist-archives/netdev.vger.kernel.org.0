Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC606957E0
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 05:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjBNEXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 23:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBNEXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 23:23:20 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5945FEF9B;
        Mon, 13 Feb 2023 20:23:19 -0800 (PST)
From:   =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1676348597;
        bh=XNGLB3UhxdSqVyS81dpprAvvvxiF/US4JFBcP36WqyI=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=UReHhwNqGK8rqcq/xW7yonrURSIxpGN9fAfxi/rlWADYHupWSRZbpF7JbeQzFgWJw
         eA3jzJapx3aUFjy5M7lEQsHjtafl+zJ36gwXm94M0qraxF77baaVH7qSbQfpV2YtSK
         cRvY3bk+H+xMxDf7O9gddVE2CTq4q6zydNF73VgU=
Date:   Tue, 14 Feb 2023 04:23:12 +0000
Subject: [PATCH net-next v2 2/2] net-sysfs: make kobj_type structures
 constant
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20230211-kobj_type-net-v2-2-013b59e59bf3@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1676348594; l=1293;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=XNGLB3UhxdSqVyS81dpprAvvvxiF/US4JFBcP36WqyI=;
 b=e3JEW3GQbCOozB5YsgCio/CYP6aWitXRRwFV1mCB42LQ+4l60CNQrnFhoIxZzGcRzreeviOxR
 i0VVsnJgoN2Cc3sl19l3nfsBxaGQ/xwqe6lHMY4QQJH6C+YdCyr+yCU
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
 net/core/net-sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index ca55dd747d6c..a3771bba841a 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1040,7 +1040,7 @@ static void rx_queue_get_ownership(const struct kobject *kobj,
 	net_ns_get_ownership(net, uid, gid);
 }
 
-static struct kobj_type rx_queue_ktype __ro_after_init = {
+static const struct kobj_type rx_queue_ktype = {
 	.sysfs_ops = &rx_queue_sysfs_ops,
 	.release = rx_queue_release,
 	.default_groups = rx_queue_default_groups,
@@ -1643,7 +1643,7 @@ static void netdev_queue_get_ownership(const struct kobject *kobj,
 	net_ns_get_ownership(net, uid, gid);
 }
 
-static struct kobj_type netdev_queue_ktype __ro_after_init = {
+static const struct kobj_type netdev_queue_ktype = {
 	.sysfs_ops = &netdev_queue_sysfs_ops,
 	.release = netdev_queue_release,
 	.default_groups = netdev_queue_default_groups,

-- 
2.39.1

