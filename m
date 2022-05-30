Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310A45376F5
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 10:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbiE3IPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbiE3IPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:15:13 -0400
Received: from sym2.noone.org (sym.noone.org [178.63.92.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADF0793A1
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 01:14:56 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4LBSrB6KvVzvjhQ; Mon, 30 May 2022 10:14:50 +0200 (CEST)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     Akhmat Karakotov <hmukos@yandex-team.ru>, netdev@vger.kernel.org
Subject: [PATCH v2] socket: Use __u8 instead of u8 in uapi socket.h
Date:   Mon, 30 May 2022 10:14:50 +0200
Message-Id: <20220530081450.16591-1-tklauser@distanz.ch>
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

Use the uapi variant of the u8 type.

Fixes: 26859240e4ee ("txhash: Add socket option to control TX hash rethink behavior")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
v2: add missing <linux/types.h> include as reported by kernel test robot

 include/uapi/linux/socket.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/socket.h b/include/uapi/linux/socket.h
index 51d6bb2f6765..62a32040ad4f 100644
--- a/include/uapi/linux/socket.h
+++ b/include/uapi/linux/socket.h
@@ -2,6 +2,8 @@
 #ifndef _UAPI_LINUX_SOCKET_H
 #define _UAPI_LINUX_SOCKET_H
 
+#include <linux/types.h>
+
 /*
  * Desired design of maximum size and alignment (see RFC2553)
  */
@@ -31,7 +33,7 @@ struct __kernel_sockaddr_storage {
 
 #define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
 
-#define SOCK_TXREHASH_DEFAULT	((u8)-1)
+#define SOCK_TXREHASH_DEFAULT	((__u8)-1)
 #define SOCK_TXREHASH_DISABLED	0
 #define SOCK_TXREHASH_ENABLED	1
 
-- 
2.36.1

