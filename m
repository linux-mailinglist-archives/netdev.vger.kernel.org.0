Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D7649D25B
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244405AbiAZTLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:11:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55116 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244370AbiAZTLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:11:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18405616E3
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 19:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CF9C340EA;
        Wed, 26 Jan 2022 19:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643224278;
        bh=BG6BnPctooTBwFqa7t+hX9i6hf8qYsGFcFBzkIdS0og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gr4W4XrRx2IBJHH3lqMiJUbq/KwVWbhfsDBd/v+FQR1QTqXWR80bF8UUE9tF8+4f/
         4pZZjWSLMr5yb3qVjsBpW3PM608BEHUQmY33VQluC8OUFZZ6C/pKjZVbzd4CitejUP
         SoZ2eY7/SqUcI98Yna+4Mwsm0smeMVMT+n6OO0yktnC6nFq5Vxjhx68NVFMbFJm95k
         2kQWdPZ8TXWVI9R2iute/eVU8Qs616Z9JWmsIwm0NY73F9nv5GkQHWTswnA4rvlpWC
         bpCLpUJ71nhH8gQPrRoeD2kzRINwHASnQGj5bsmiqafuL0a+L3rRecBTB4QNABPDl1
         5mxd1e8eu19wg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        jmaloy@redhat.com, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH net-next 15/15] net: tipc: remove unused static inlines
Date:   Wed, 26 Jan 2022 11:11:09 -0800
Message-Id: <20220126191109.2822706-16-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126191109.2822706-1-kuba@kernel.org>
References: <20220126191109.2822706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IIUC the TIPC msg helpers are not meant to provide
and exhaustive API, so remove the unused ones.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jmaloy@redhat.com
CC: ying.xue@windriver.com
CC: tipc-discussion@lists.sourceforge.net
---
 net/tipc/msg.h | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 64ae4c4c44f8..c5eec16213d7 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -226,14 +226,6 @@ static inline void msg_set_bits(struct tipc_msg *m, u32 w,
 	m->hdr[w] |= htonl(val);
 }
 
-static inline void msg_swap_words(struct tipc_msg *msg, u32 a, u32 b)
-{
-	u32 temp = msg->hdr[a];
-
-	msg->hdr[a] = msg->hdr[b];
-	msg->hdr[b] = temp;
-}
-
 /*
  * Word 0
  */
@@ -480,11 +472,6 @@ static inline void msg_incr_reroute_cnt(struct tipc_msg *m)
 	msg_set_bits(m, 1, 21, 0xf, msg_reroute_cnt(m) + 1);
 }
 
-static inline void msg_reset_reroute_cnt(struct tipc_msg *m)
-{
-	msg_set_bits(m, 1, 21, 0xf, 0);
-}
-
 static inline u32 msg_lookup_scope(struct tipc_msg *m)
 {
 	return msg_bits(m, 1, 19, 0x3);
@@ -800,11 +787,6 @@ static inline void msg_set_dest_domain(struct tipc_msg *m, u32 n)
 	msg_set_word(m, 2, n);
 }
 
-static inline u32 msg_bcgap_after(struct tipc_msg *m)
-{
-	return msg_bits(m, 2, 16, 0xffff);
-}
-
 static inline void msg_set_bcgap_after(struct tipc_msg *m, u32 n)
 {
 	msg_set_bits(m, 2, 16, 0xffff, n);
@@ -868,11 +850,6 @@ static inline void msg_set_next_sent(struct tipc_msg *m, u16 n)
 	msg_set_bits(m, 4, 0, 0xffff, n);
 }
 
-static inline void msg_set_long_msgno(struct tipc_msg *m, u32 n)
-{
-	msg_set_bits(m, 4, 0, 0xffff, n);
-}
-
 static inline u32 msg_bc_netid(struct tipc_msg *m)
 {
 	return msg_word(m, 4);
-- 
2.34.1

