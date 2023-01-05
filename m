Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B461065F510
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 21:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbjAEUNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 15:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbjAEUNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 15:13:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C68E1AA32
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 12:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672949543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qP7GgaungF4LpLiIW53DOAlPCQeFqX17MNRkX0URUPQ=;
        b=LMiHlh3ujyRev7trKbSNxVNgrlsVI6gCzB4EL7XrcXa8Qci0sw127e7GaBOe7uWASkRmLr
        0yFYpcAcvjKx+uRxYGNIp4Akkt9jF+E4YjstyMrmqgSDwgFeYSbAwnyqIpVOA0MXIY/Pva
        2bZdolmp8+Sd5yfLz07Fsrm7SW/jJqM=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-212-aFj9VkceMoag3tFvFF4uVA-1; Thu, 05 Jan 2023 15:12:22 -0500
X-MC-Unique: aFj9VkceMoag3tFvFF4uVA-1
Received: by mail-pj1-f72.google.com with SMTP id y2-20020a17090a784200b00225c0839b80so13022237pjl.5
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 12:12:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qP7GgaungF4LpLiIW53DOAlPCQeFqX17MNRkX0URUPQ=;
        b=Ms0zF2PdRTDMPUc9nY2CdsDLhmF2f7WILmzNRQ5i/fB9g3B//f+dr+mmQXytnv+O+x
         o5YY+MPysGUJCWEhqFYNJTrb/xRNpzV8p+Wdnj4yLZROWpbCYq9oFgbA6PD8wGwpqCcN
         ouaSUJSPOsPZWniy7xOL20vJhVMf/oSmAoXgs3D3opbvRr57eorJyfoKDL7uiSfBk/Ii
         rK9KiPxDfgnHJEx755ORiVXNrP4GwKoAZDTWrVbkINzZQeYy4UvHcHKtqrGmLb1VFR9F
         XhRwLlIFPUrT/b+8lNwRzO7iWyC9imLnwxxhYmNOR1s+7knsuJaUMRSYwyKwSGyACKBY
         3u4g==
X-Gm-Message-State: AFqh2krJEOT9HuODe+kfFI77PFbyCEo4oSq+dmnKKXkVvrLgQK4ac/KB
        sw/5s8IgemTcAjCrhCMiJCx4a4DirPOwqdD63A9ZMOCtcRFrBUGOT4iXImdAlrcAwhSYu2PsDDg
        4UfafXs4iUCr4mIY9
X-Received: by 2002:a17:902:f711:b0:192:8ca0:b86e with SMTP id h17-20020a170902f71100b001928ca0b86emr44610316plo.35.1672949540783;
        Thu, 05 Jan 2023 12:12:20 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvh5BYK9jnJ1/ierKFbMs7rt9oYDnwOUEI3E2+7h8gq5HjwHZr6D4+K/PXVYDnWkRaAoFcGJQ==
X-Received: by 2002:a17:902:f711:b0:192:8ca0:b86e with SMTP id h17-20020a170902f71100b001928ca0b86emr44610295plo.35.1672949540483;
        Thu, 05 Jan 2023 12:12:20 -0800 (PST)
Received: from localhost.localdomain ([240d:1a:c0d:9f00:ca6:1aff:fead:cef4])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090322cf00b001896ba683b9sm16754710plg.131.2023.01.05.12.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 12:12:20 -0800 (PST)
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dmytro@shytyi.net, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        Shigeru Yoshida <syoshida@redhat.com>
Subject: [PATCH] mptcp: Fix deadlock in mptcp_sendmsg()
Date:   Fri,  6 Jan 2023 05:12:05 +0900
Message-Id: <20230105201205.1087439-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__mptcp_close_ssk() can be called from mptcp_sendmsg() with subflow
socket locked.  This can cause a deadlock as below:

mptcp_sendmsg()
  mptcp_sendmsg_fastopen() --> lock ssk
    tcp_sendmsg_fastopen()
       __inet_stream_connect()
          mptcp_disconnect()
             mptcp_destroy_common()
                __mptcp_close_ssk() --> lock ssk again

This patch fixes the issue by skipping locking for subflow socket
which is already locked.

Fixes: d98a82a6afc7 ("mptcp: handle defer connect in mptcp_sendmsg")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
 net/mptcp/protocol.c | 15 +++++++++------
 net/mptcp/protocol.h |  4 ++--
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f6f93957275b..979265f66082 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1672,9 +1672,9 @@ static int mptcp_sendmsg_fastopen(struct sock *sk, struct sock *ssk, struct msgh
 	lock_sock(ssk);
 	msg->msg_flags |= MSG_DONTWAIT;
 	msk->connect_flags = O_NONBLOCK;
-	msk->is_sendmsg = 1;
+	msk->sendmsg_locked_sk = ssk;
 	ret = tcp_sendmsg_fastopen(ssk, msg, copied_syn, len, NULL);
-	msk->is_sendmsg = 0;
+	msk->sendmsg_locked_sk = NULL;
 	msg->msg_flags = saved_flags;
 	release_sock(ssk);
 
@@ -2319,7 +2319,8 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	if (dispose_it)
 		list_del(&subflow->node);
 
-	lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
+	if (msk->sendmsg_locked_sk != ssk)
+		lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
 
 	if (flags & MPTCP_CF_FASTCLOSE) {
 		/* be sure to force the tcp_disconnect() path,
@@ -2335,7 +2336,8 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		tcp_disconnect(ssk, 0);
 		msk->subflow->state = SS_UNCONNECTED;
 		mptcp_subflow_ctx_reset(subflow);
-		release_sock(ssk);
+		if (msk->sendmsg_locked_sk != ssk)
+			release_sock(ssk);
 
 		goto out;
 	}
@@ -2362,7 +2364,8 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		/* close acquired an extra ref */
 		__sock_put(ssk);
 	}
-	release_sock(ssk);
+	if (msk->sendmsg_locked_sk != ssk)
+		release_sock(ssk);
 
 	sock_put(ssk);
 
@@ -3532,7 +3535,7 @@ static int mptcp_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	/* if reaching here via the fastopen/sendmsg path, the caller already
 	 * acquired the subflow socket lock, too.
 	 */
-	if (msk->is_sendmsg)
+	if (msk->sendmsg_locked_sk)
 		err = __inet_stream_connect(ssock, uaddr, addr_len, msk->connect_flags, 1);
 	else
 		err = inet_stream_connect(ssock, uaddr, addr_len, msk->connect_flags);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 955fb3d88eb3..43afc399e16b 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -294,8 +294,7 @@ struct mptcp_sock {
 	u8		mpc_endpoint_id;
 	u8		recvmsg_inq:1,
 			cork:1,
-			nodelay:1,
-			is_sendmsg:1;
+			nodelay:1;
 	int		connect_flags;
 	struct work_struct work;
 	struct sk_buff  *ooo_last_skb;
@@ -318,6 +317,7 @@ struct mptcp_sock {
 	u32 setsockopt_seq;
 	char		ca_name[TCP_CA_NAME_MAX];
 	struct mptcp_sock	*dl_next;
+	struct sock	*sendmsg_locked_sk;
 };
 
 #define mptcp_data_lock(sk) spin_lock_bh(&(sk)->sk_lock.slock)
-- 
2.39.0

