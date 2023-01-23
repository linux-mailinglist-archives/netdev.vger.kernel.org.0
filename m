Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4854678AB0
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 23:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbjAWWWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 17:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbjAWWWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 17:22:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD6A2F7AA;
        Mon, 23 Jan 2023 14:22:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C16FB80E84;
        Mon, 23 Jan 2023 22:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B679C433EF;
        Mon, 23 Jan 2023 22:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674512547;
        bh=J3FWQf8v2Xtdi31/P+roQNgwrUj1NLx5u7NBqDB/yxM=;
        h=From:To:Cc:Subject:Date:From;
        b=cs6ZsXyIM4b9APD+8r4cDZFexVMVyRyjIv87RiM/66l8MixvTermp9+ChIyT76pt/
         /HkhhL3gd9wUGb+M4nE5AlDoZLk2n/fzv1nCkVlIeR4zWsjlOzhNvb4OeyrkBcSSiW
         NBKoncXLPZH0v3dxB3CR0UEh1svOJQohYw5/TH/gvwSl9MEISLWhRQhR1njrGHISSL
         DNbexCxK4oom5jAbRXPpLLb5Opg4ILrxlhCCJdn502TfP2FTG3W8nwQGuuHg1+PgdJ
         p9Q8qLj5V2ZGRC+tWBZ+cm9vKob9D4QEzpw/oA2oLBdVKGsro9tUYej/rV+3aNBWNc
         uS6VpikQteIsw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>, jiri@nvidia.com,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        johannes@sipsolutions.net, ecree.xilinx@gmail.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH net-next] netlink: fix spelling mistake in dump size assert
Date:   Mon, 23 Jan 2023 14:22:24 -0800
Message-Id: <20230123222224.732338-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2c7bc10d0f7b ("netlink: add macro for checking dump ctx size")
misspelled the name of the assert as asset, missing an R.

Reported-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jiri@nvidia.com
CC: pablo@netfilter.org
CC: kadlec@netfilter.org
CC: fw@strlen.de
CC: johannes@sipsolutions.net
CC: ecree.xilinx@gmail.com
CC: netfilter-devel@vger.kernel.org
CC: coreteam@netfilter.org
---
 include/linux/netlink.h              | 2 +-
 net/devlink/devl_internal.h          | 2 +-
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 38f6334f408c..fa4d86da0ec7 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -263,7 +263,7 @@ struct netlink_callback {
 	};
 };
 
-#define NL_ASSET_DUMP_CTX_FITS(type_name)				\
+#define NL_ASSERT_DUMP_CTX_FITS(type_name)				\
 	BUILD_BUG_ON(sizeof(type_name) >				\
 		     sizeof_field(struct netlink_callback, ctx))
 
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 1aa1a9549549..d0d889038138 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -135,7 +135,7 @@ int devlink_nl_instance_iter_dump(struct sk_buff *msg,
 static inline struct devlink_nl_dump_state *
 devlink_dump_state(struct netlink_callback *cb)
 {
-	NL_ASSET_DUMP_CTX_FITS(struct devlink_nl_dump_state);
+	NL_ASSERT_DUMP_CTX_FITS(struct devlink_nl_dump_state);
 
 	return (struct devlink_nl_dump_state *)cb->ctx;
 }
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 90672e293e57..308fc0023c7e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3866,7 +3866,7 @@ static int __init ctnetlink_init(void)
 {
 	int ret;
 
-	NL_ASSET_DUMP_CTX_FITS(struct ctnetlink_list_dump_ctx);
+	NL_ASSERT_DUMP_CTX_FITS(struct ctnetlink_list_dump_ctx);
 
 	ret = nfnetlink_subsys_register(&ctnl_subsys);
 	if (ret < 0) {
-- 
2.39.1

