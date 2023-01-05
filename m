Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD96965E1BD
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 01:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbjAEAlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 19:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240630AbjAEAio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 19:38:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876C0B2D;
        Wed,  4 Jan 2023 16:38:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2174FB81987;
        Thu,  5 Jan 2023 00:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916B4C43323;
        Thu,  5 Jan 2023 00:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672879095;
        bh=zQrOASeiQkWJ2fTAnSKZb1lM+olIZOfGqaBBzWSL5Os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=st3dkbbgHwtbilG5So1Lzkk0fgRX5Eq6lT3vyl8jLa/WC/soo489AykwAVP6KCJSd
         dRUEfg2RnrIn0m9pSaO7J06wTbTU11Z6C3S+I3/xOvj4H/2fk8Swz3zTFP4xpORiT7
         MUQpUMrEw+F2pFEAXofRXAH4nrUEC7J1DndkjcblZNz+2ySfaTF06QQMJCVCNojXID
         IeV5X6viB08711cPeFqw4cPblG8syj+hHmsAdozXmwuX56CjxkrNQ5VtoBl1evOa+0
         3mswbNhX+HqxEEdepbe2FVgZKN4iz1LZscAXADU4Dx4TMdo8cFDyY4PvGZVfudKXeD
         nCz3CSLOzoWdA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id D0DD85C1C99; Wed,  4 Jan 2023 16:38:14 -0800 (PST)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org, "Paul E. McKenney" <paulmck@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH rcu 15/27] drivers/net: Remove "select SRCU"
Date:   Wed,  4 Jan 2023 16:38:01 -0800
Message-Id: <20230105003813.1770367-15-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
References: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
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

Now that the SRCU Kconfig option is unconditionally selected, there is
no longer any point in selecting it.  Therefore, remove the "select SRCU"
Kconfig statements.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: <netdev@vger.kernel.org>
---
 drivers/net/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 9e63b8c43f3e2..12910338ea1a0 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -334,7 +334,6 @@ config NETCONSOLE_DYNAMIC
 
 config NETPOLL
 	def_bool NETCONSOLE
-	select SRCU
 
 config NET_POLL_CONTROLLER
 	def_bool NETPOLL
-- 
2.31.1.189.g2e36527f23

