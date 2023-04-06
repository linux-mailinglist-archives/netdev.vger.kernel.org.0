Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBFC6D8E40
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 06:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbjDFENF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 00:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbjDFEND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 00:13:03 -0400
X-Greylist: delayed 1820 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 05 Apr 2023 21:13:00 PDT
Received: from mail-17766.188.com (mail-17766.188.com [123.58.177.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A0B710C1;
        Wed,  5 Apr 2023 21:12:59 -0700 (PDT)
Received: from localhost.localdomain (unknown [119.3.119.19])
        by smtp1 (Coremail) with SMTP id EGZ4CgDH_7iPPy5k_4q3AQ--.4828S2;
        Thu, 06 Apr 2023 11:42:08 +0800 (CST)
From:   Chen Aotian <chenaotian@188.com>
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Aotian <chenaotian@188.com>
Subject: [PATCH] netfilter: nf_tables: Modify nla_memdup's flag to GFP_KERNEL_ACCOUNT
Date:   Thu,  6 Apr 2023 11:41:44 +0800
Message-Id: <20230406034144.1511-1-chenaotian@188.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EGZ4CgDH_7iPPy5k_4q3AQ--.4828S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZrykKFykGF45Ar48ZFyDAwb_yoW3ZwbEka
        4vqr40krWrJrZFqr1rJ3yqyrySgay8Z3WS9a4fZFZ0yayrGw409FZ7XF1rZan8Ww4UA3W5
        Z3sFqF1DJw4jkjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnfR6UUUUUU==
X-Originating-IP: [119.3.119.19]
X-CM-SenderInfo: xfkh0tprwlt0a6rymhhfrp/1tbiARdJiVeMiQV6hgABs8
X-Spam-Status: No, score=0.0 required=5.0 tests=FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For memory alloc that store user data from nla[NFTA_OBJ_USERDATA], 
use GFP_KERNEL_ACCOUNT is more suitable.

Signed-off-by: Chen Aotian <chenaotian@188.com>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6004d4b24..cd52109e6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7052,7 +7052,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (nla[NFTA_OBJ_USERDATA]) {
-		obj->udata = nla_memdup(nla[NFTA_OBJ_USERDATA], GFP_KERNEL);
+		obj->udata = nla_memdup(nla[NFTA_OBJ_USERDATA], GFP_KERNEL_ACCOUNT);
 		if (obj->udata == NULL)
 			goto err_userdata;
 
-- 
2.25.1

