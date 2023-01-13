Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC9F668836
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 01:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240698AbjAMAMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 19:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240282AbjAMALn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 19:11:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F32E5DE44;
        Thu, 12 Jan 2023 16:11:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEDEBB8203A;
        Fri, 13 Jan 2023 00:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E97C43398;
        Fri, 13 Jan 2023 00:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673568695;
        bh=cTMHlhoolXwxR+XWJBWwI7YWwhu4f9xOx3xMf+RE4lA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pTZivndYQVJZ7qcUIoycYCQuR3FWm4j4olw3ymlzBFIWDmypktz+JBWgUZyG37z/h
         9TOoTAntfGOC6CwehiC/RIn3QVh54uR9LANH38Hc9BrLXqwXmEFFjJ1GybFGZN9qJ2
         p/nt9DApSWtPO2U2vINfXjBFPdEXTzfCk3OSPwC1HDRNFU3fKntGLe2bhtwK5o3Ajz
         62N2tfEN2+7J5ZTMhaG2VtqXFMkJJPZQaHuevHhtdiMR8xkK0Hy8cn6qFDnFsPFNyp
         rA6QLyCi5QUCoZHusJcTL8202gfEJ/v8zPPqjZxxFatURUvPFNAGP+O2LfgQaY+ZOS
         sN8PGszh/4Ojw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id A2C0C5C11A4; Thu, 12 Jan 2023 16:11:34 -0800 (PST)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org, "Paul E. McKenney" <paulmck@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        John Ogness <john.ogness@linutronix.de>
Subject: [PATCH rcu v2 07/20] drivers/net: Remove "select SRCU"
Date:   Thu, 12 Jan 2023 16:11:19 -0800
Message-Id: <20230113001132.3375334-7-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20230113001103.GA3374173@paulmck-ThinkPad-P17-Gen-1>
References: <20230113001103.GA3374173@paulmck-ThinkPad-P17-Gen-1>
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
Acked-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
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

