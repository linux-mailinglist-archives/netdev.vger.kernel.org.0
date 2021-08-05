Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BF03E0D9F
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 07:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbhHEFOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 01:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237075AbhHEFOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 01:14:14 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BE7C0613C1
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 22:14:00 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso6936008pjo.1
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 22:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bk6BNtpX2bsqpgJ2JxfChzF+Dc9XGh58ZUTm6AVu4O8=;
        b=kbbIfWLnf1f9HRgVSHpYM44TCZobQoXD04sDX3qdumrizkrXTm4JzaSoxVEIH82beG
         Z+EPdXRCZne5sgygWSflaYL+N4EZmWuJv2yevWIYayEQe/RctKj6jJu7SA1v5bZN1155
         E8Ydl8mHRceDPOkCopzefU27eFn7e7lenDmEZkd4oSVghqrEtcRwdjZbtXR0lOmay2BH
         pB+6UHNKgcHMnqPKqNDpbaq5OrJW/g646ISrefB1q9OmNhekn5uzhm8254m7plqJPuxg
         vDsPknCOKdMlqsXmgZpQApcMu0JaMJfF7KXi8WExg745ssFH5ChWWXT7sHayLTVnFBwk
         L1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bk6BNtpX2bsqpgJ2JxfChzF+Dc9XGh58ZUTm6AVu4O8=;
        b=ijLGPHl/+5bofa+scCzQfsVfyS6E6vXCZicF44voy3gjADCxUEDpkoammzHUxissY7
         KHbzCnXCr1w6ZWXgZBtJDJNkWE7u1me2UIRHk3w2b0SVuTLDVlqFZp8ey2Uwke7oCHYV
         6bWu3IgOlTHU5Ak9Xzx4xVU7h2OxLWGDHltbVMZNjeXIq1zjmRVoJ/RJg4tzasiYsvob
         INjMffRROYjPiwwnR1UoK5blYQ1+1iAdFimH8v61oXFVappTxxztHQBo/MY0LmxMZff3
         chcB9HAyHHV0s+ny+sqPoO3i+5hEalbGrrmC0TKJ3VlA8FdVY6fxmHy5phVBQCKTy3K/
         VbwA==
X-Gm-Message-State: AOAM5335J6WguH/CYluciS3XX6glyKgh6FfvxzE7Ua3Gq7Xcn+zVeIi4
        yM7x6CpFqek9/E6RfkARbOcPLbeErNlVRg==
X-Google-Smtp-Source: ABdhPJznw+OwJbXaiRxq0eHbyq4ucXBZQnNETJpBKxvtBSvC2eaHeDuav93b58aszECTGl8leLaslg==
X-Received: by 2002:a17:90b:514:: with SMTP id r20mr2815663pjz.80.1628140440230;
        Wed, 04 Aug 2021 22:14:00 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id k4sm4201098pjs.55.2021.08.04.22.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 22:13:59 -0700 (PDT)
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
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v4 1/5] af_unix: add read_sock for stream socket types
Date:   Thu,  5 Aug 2021 05:13:33 +0000
Message-Id: <20210805051340.3798543-2-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210805051340.3798543-1-jiang.wang@bytedance.com>
References: <20210805051340.3798543-1-jiang.wang@bytedance.com>
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
index 256c4e31132e..c020ad0e8438 100644
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
@@ -2358,6 +2361,15 @@ struct unix_stream_read_state {
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

