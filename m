Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617BC3DE15B
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 23:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbhHBVTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 17:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbhHBVTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 17:19:38 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4179C0613D5
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 14:19:28 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id k4-20020a17090a5144b02901731c776526so851126pjm.4
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 14:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gB7YFrieIpmwVCmE7FizVML0zcWrHXYydeLPQdihUz4=;
        b=S/pRWwTVzlbZMfxX44uINtBvykBVML7GHvPj/N/zYNtvYZgXV9ZcQPs8nnQci/OYJG
         r+zMFXQi7GLtgEA72n4WC5TVz7Sh985DoEKIMnWvct7wmQqP2lBi9cFG74oFbLNn/vBW
         mTctdwglEUz3DLAGCTiT1Ta57dY/ch+qyO6ISrc6FKrr2AtGvH+DCGcLxesLkz351FmB
         4CK8hgIcKGjfD57stZ7SfTnu0v0yl9lZ7UhIsblOAHETz2OW1Bfgbv9vRO/DoIS1uVMX
         leIXzZ2Zfmmv3TrujCvcGCYIKgNG2Ns+8CkJ80hIwDH2hng85ODddAqar6KY8ZFlDuNU
         S7MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gB7YFrieIpmwVCmE7FizVML0zcWrHXYydeLPQdihUz4=;
        b=UxqV+AJcb15ACbg/B4IWvjJU1aG4HNXMXnMOo7lQ/3vsPmpn8klpwYySpHsTwSN4yf
         Rj3dTwrgzY9g2jU/59UgLZ4slB0BR5ngJCyRu1oESlbqkA+FNq5hmBOHeHX78rQn17fU
         0te3En+yoHd8YD07kkDiqsYjnofLp+EnpPBt6V8+KSRPayElMnfxBsngNPI44tigYGr1
         KG9y6IFm3WKsCEWrR+TLTx4nwFCz5iIQjd62eq3VbeIizl9rTVwO30X/8sc+6HYXZIKl
         7eRJnNhxjugZPPn+r9v3+GOQ5Ib/3yKKwHi9amWpjPBb8dWbodvh5gfQ9a9lepU+q2cs
         FR8Q==
X-Gm-Message-State: AOAM531WEq5g9Fa5I4m5h5U4CedWWPaO5nRsLSGk2ud7KsFtNuF5ekwS
        KnVumBTpspqRygmciBXTVCtJmcvxnNmnSA==
X-Google-Smtp-Source: ABdhPJwI66JYy/BibL9BT54xY85Hdzga6ldif9ry5yFD41JVVMqtj5dUpSFqUjrCpkLbfCqqe+E2rQ==
X-Received: by 2002:a17:90a:bd92:: with SMTP id z18mr19229054pjr.195.1627939168194;
        Mon, 02 Aug 2021 14:19:28 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id 10sm12949212pjc.41.2021.08.02.14.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 14:19:27 -0700 (PDT)
From:   Jiang Wang <jiang.wang@bytedance.com>
To:     netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, duanxiongchun@bytedance.com,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v3 1/5] af_unix: add read_sock for stream socket types
Date:   Mon,  2 Aug 2021 21:19:05 +0000
Message-Id: <20210802211912.116329-2-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210802211912.116329-1-jiang.wang@bytedance.com>
References: <20210802211912.116329-1-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support sockmap for af_unix stream type, implement
read_sock, which is similar to the read_sock for unix
dgram sockets.

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
---
 net/unix/af_unix.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 89927678c..0ae3fc4c8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -672,6 +672,8 @@ static int unix_dgram_sendmsg(struct socket *, struct msghdr *, size_t);
 static int unix_dgram_recvmsg(struct socket *, struct msghdr *, size_t, int);
 static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
 			  sk_read_actor_t recv_actor);
+static int unix_stream_read_sock(struct sock *sk, read_descriptor_t *desc,
+				 sk_read_actor_t recv_actor);
 static int unix_dgram_connect(struct socket *, struct sockaddr *,
 			      int, int);
 static int unix_seqpacket_sendmsg(struct socket *, struct msghdr *, size_t);
@@ -725,6 +727,7 @@ static const struct proto_ops unix_stream_ops = {
 	.shutdown =	unix_shutdown,
 	.sendmsg =	unix_stream_sendmsg,
 	.recvmsg =	unix_stream_recvmsg,
+	.read_sock =	unix_stream_read_sock,
 	.mmap =		sock_no_mmap,
 	.sendpage =	unix_stream_sendpage,
 	.splice_read =	unix_stream_splice_read,
@@ -2311,6 +2314,15 @@ struct unix_stream_read_state {
 	unsigned int splice_flags;
 };
 
+static int unix_stream_read_sock(struct sock *sk, read_descriptor_t *desc,
+				 sk_read_actor_t recv_actor)
+{
+	if (unlikely(sk->sk_state != TCP_ESTABLISHED))
+		return -ENOTCONN;
+
+	return unix_read_sock(sk, desc, recv_actor);
+}
+
 static int unix_stream_read_generic(struct unix_stream_read_state *state,
 				    bool freezable)
 {
-- 
2.20.1

