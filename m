Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB3561090D
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 05:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbiJ1DxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 23:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbiJ1DxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 23:53:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D41FB5FDF
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 20:53:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBE77625AF
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7A6C433B5;
        Fri, 28 Oct 2022 03:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666929181;
        bh=ICJBQjd7d89gzV+vapnRqpEDX/+vfmhR0lLwekLQEVU=;
        h=From:To:Cc:Subject:Date:From;
        b=COsrMNvZcbfiMq1izJZ0YA6XAsB95wO7fHEqkWqCSoEGWpQZDMC6lQS7u/Xpxp7wV
         SkrSE6IQbvv6G5cBi/f2tFtdV4e5LNy87JVUgcDamp6qu2kjcWwVl1G3LMgdLMnptO
         W1EDTNefRviuqMO/SkQysZtv1ivLcfq3Y1Kz8w7zxZnmPO6Re9yhkl5wqCjoUe/u12
         xvDUiBVbUYUbdKXYWWM+RwptgOlBwCsDzPvAn11DGbXCXOlbLx3o4emJEg+KGIqihT
         4fPsckrUH7g5bCAdp8fpuHsGBTcHGjCTP442fTCpKHl7azhdkHygX6o4gsIiaX6sCu
         Vrmi6BWo5cuIA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: geneve: fix array of flexible structures warnings
Date:   Thu, 27 Oct 2022 20:52:59 -0700
Message-Id: <20221028035259.2728736-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New compilers don't like flexible array of flexible structs:

  include/net/geneve.h:62:34: warning: array of flexible structures

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/geneve.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/geneve.h b/include/net/geneve.h
index bced0b1d9fe4..5c96827a487e 100644
--- a/include/net/geneve.h
+++ b/include/net/geneve.h
@@ -59,7 +59,7 @@ struct genevehdr {
 	__be16 proto_type;
 	u8 vni[3];
 	u8 rsvd2;
-	struct geneve_opt options[];
+	u8 options[];
 };
 
 static inline bool netif_is_geneve(const struct net_device *dev)
-- 
2.37.3

