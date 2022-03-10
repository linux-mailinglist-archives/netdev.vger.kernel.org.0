Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202534D4C4A
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244721AbiCJOyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245214AbiCJOjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:39:18 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BF62672
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=t/ci4HxTSIxtB5zk0xbrq5lg/qcvKevxFThZk+qM/nQ=; b=k0jwSr7dXMVTnUZrmq1wK7qIfN
        9FuUF3sE7ckBbTYnPQWbd9qs1sIxRUh6mbPgI/zErE3RMZp91nflwuzqJGVPCw2qckcuLKth1xgvV
        B42p04aFI0r/x56zWGR0nDKVVCMoKkp4Jfdu/3y1CBOXOYG1mXE1YquBk2zZF6vYYwgOBT9OxcQ71
        5LlJLkuKAVdjwOGSPk/sQjREgSKRb1JROpMalcf64dmfoEcmKb4zYYRuRDqkyhpSDlxgfWsXW925V
        Zz/F4EHeaTDVUOCBMVPPe0Z0uLmKxwtKr+ToZV7rNNYkPo+lzYL005LKNPhjJlNLsnVhMLO9J6bF7
        1bdHTSDQ==;
Received: from [2001:4bb8:184:7746:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nSJqC-00D7yY-EU; Thu, 10 Mar 2022 14:32:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH] tcp: unexport tcp_ca_get_key_by_name and tcp_ca_get_name_by_key
Date:   Thu, 10 Mar 2022 15:32:29 +0100
Message-Id: <20220310143229.895319-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both functions are only used by core networking code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv4/tcp_cong.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index db5831e6c136a..dc95572163df3 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -135,7 +135,6 @@ u32 tcp_ca_get_key_by_name(struct net *net, const char *name, bool *ecn_ca)
 
 	return key;
 }
-EXPORT_SYMBOL_GPL(tcp_ca_get_key_by_name);
 
 char *tcp_ca_get_name_by_key(u32 key, char *buffer)
 {
@@ -151,7 +150,6 @@ char *tcp_ca_get_name_by_key(u32 key, char *buffer)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tcp_ca_get_name_by_key);
 
 /* Assign choice of congestion control. */
 void tcp_assign_congestion_control(struct sock *sk)
-- 
2.30.2

