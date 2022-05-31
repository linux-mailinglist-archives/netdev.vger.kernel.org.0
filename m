Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D52538DF1
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 11:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245105AbiEaJnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 05:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiEaJnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 05:43:49 -0400
Received: from sym2.noone.org (sym.noone.org [178.63.92.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A6C8DDF2
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 02:43:47 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4LC6mK4S4WzvjhS; Tue, 31 May 2022 11:43:45 +0200 (CEST)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     Akhmat Karakotov <hmukos@yandex-team.ru>, netdev@vger.kernel.org
Subject: [PATCH v3] socket: Don't use u8 type in uapi socket.h
Date:   Tue, 31 May 2022 11:43:45 +0200
Message-Id: <20220531094345.13801-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220525085126.29977-1-tklauser@distanz.ch>
References: <20220525085126.29977-1-tklauser@distanz.ch>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use plain 255 instead, which also avoid introducing an additional header
dependency on <linux/types.h>

Fixes: 26859240e4ee ("txhash: Add socket option to control TX hash rethink behavior")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
v3: changed to plain 255 as suggested by David Laight and Paolo Abeni

 include/uapi/linux/socket.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/socket.h b/include/uapi/linux/socket.h
index 51d6bb2f6765..d3fcd3b5ec53 100644
--- a/include/uapi/linux/socket.h
+++ b/include/uapi/linux/socket.h
@@ -31,7 +31,7 @@ struct __kernel_sockaddr_storage {
 
 #define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
 
-#define SOCK_TXREHASH_DEFAULT	((u8)-1)
+#define SOCK_TXREHASH_DEFAULT	255
 #define SOCK_TXREHASH_DISABLED	0
 #define SOCK_TXREHASH_ENABLED	1
 
-- 
2.36.1

