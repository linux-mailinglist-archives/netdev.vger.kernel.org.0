Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900EA24D315
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 12:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgHUKsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 06:48:09 -0400
Received: from mail.katalix.com ([3.9.82.81]:45446 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727870AbgHUKr4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 06:47:56 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id E070186BEA;
        Fri, 21 Aug 2020 11:47:43 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1598006864; bh=VoPkmnFc1nwCqpJg17f21N6Q3oMR/TFhQ4XMIOoLvs0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=207/9]=20l2tp:=20remove=20custom
         =20logging=20macros|Date:=20Fri,=2021=20Aug=202020=2011:47:26=20+0
         100|Message-Id:=20<20200821104728.23530-8-tparkin@katalix.com>|In-
         Reply-To:=20<20200821104728.23530-1-tparkin@katalix.com>|Reference
         s:=20<20200821104728.23530-1-tparkin@katalix.com>;
        b=nhko6FJB4utsLQf+52y/931rRZQVju0lzWbBU3bnO7+aclgGU7JhFVcmZdE3T1bv1
         ox8wNK9G9tSTaAkBQWDfsmh7lZZyJoFMpHLCcH9cwcx6R321FooJjQ03Zm44lzy0e8
         kETKsUnOdQpw7wza9toSa4nc+P1hHK+wqIpTuE5P8L44UukmtRn7xGhalheRG7CLjA
         5UB010jQyxz9JPTPkzkrEojdiStUlZJRIysiqcuZS+j1P35/GWkcS+TEIpUTJpQUm1
         5TLDa0zX3+BKsNnVEiuqNKyGjcF0ARwYs30HxPz0T5ELFKoJRfAGhmsn/gg1D+XOle
         a4cJa5bDPKfkw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 7/9] l2tp: remove custom logging macros
Date:   Fri, 21 Aug 2020 11:47:26 +0100
Message-Id: <20200821104728.23530-8-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200821104728.23530-1-tparkin@katalix.com>
References: <20200821104728.23530-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All l2tp's informational and warning logging is now carried out using
standard kernel APIs.

Debugging information is now handled using tracepoints.

Now that no code is using the custom logging macros, remove them from
l2tp_core.h.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.h | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 835c4645a0ec..7a06ac135a9b 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -339,19 +339,6 @@ static inline int l2tp_v3_ensure_opt_in_linear(struct l2tp_session *session, str
 	return 0;
 }
 
-#define l2tp_printk(ptr, type, func, fmt, ...)				\
-do {									\
-	if (((ptr)->debug) & (type))					\
-		func(fmt, ##__VA_ARGS__);				\
-} while (0)
-
-#define l2tp_warn(ptr, type, fmt, ...)					\
-	l2tp_printk(ptr, type, pr_warn, fmt, ##__VA_ARGS__)
-#define l2tp_info(ptr, type, fmt, ...)					\
-	l2tp_printk(ptr, type, pr_info, fmt, ##__VA_ARGS__)
-#define l2tp_dbg(ptr, type, fmt, ...)					\
-	l2tp_printk(ptr, type, pr_debug, fmt, ##__VA_ARGS__)
-
 #define MODULE_ALIAS_L2TP_PWTYPE(type) \
 	MODULE_ALIAS("net-l2tp-type-" __stringify(type))
 
-- 
2.17.1

