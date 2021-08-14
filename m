Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6703EC06D
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 06:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhHNE2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 00:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbhHNE2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 00:28:36 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795B2C0617AE
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 21:28:08 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j12-20020a17090aeb0c00b00179530520b3so3286701pjz.0
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 21:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d6SJ/0BzbhcL/AQI/DdNhZ/xDFhfJbOcXEvb92Bi/wU=;
        b=qmk3PVBzAY/iEPc9SONxP6krNMjaNMuYbuj0rt4sFXcmNzKhqH8Acpy2cluEclN/Bi
         bqoc+4cpnTzRGT62zR7KBkrWLC0thDPTp9CylOAuifoQIzdW1h25ZZbJwEE+CBJswf1B
         yAoCPR0QbzMsW2vm32D1AFfc/+EVDN+f7im84P/Xcyd5cW8WYFWonL1takYMbg7G0Tft
         LrCjdM2wI+NbYx//BYGWtNYkW4pcUVv0Y4xTtLeqeBiGNDBCpeDvPcnpeLzhkH9XR5A0
         c6hybRh0wz5TDqFd+qYeR5dCOmjPkC1OGj+ApTLRspU5DidK4p9AeVmXO4X1OEZHsWZh
         Vtuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d6SJ/0BzbhcL/AQI/DdNhZ/xDFhfJbOcXEvb92Bi/wU=;
        b=PiHY3dElq7jflJH0hP9iShqtncyJ5ly+MoYiserNv03rv0VoPY22MDNoU26mqe3L7X
         moe39QzVg1hHWkcwBEV5L8srzWq5ZINJ3u7u44i7nxIir36OzwfPiiwa70aNGWb2sz0H
         hjFWg6NDyliOQ0ZMKeP3rfklB9ejDfYn+UbPFGydYTzYQDxISX6lhCmRlm7RcZWX5kK4
         TEWK/egMs2BNZBzMM4WnOAV8D8E0MTMaR80fRo4MS5zNmn+i1t/IJyu3pJG8bFUFGAzC
         CZhd84qk/sjt4H71txB3mRU0fobhUvs0LRGTAT3iK9sux25OAV/vjwBXAOAo1b1M2F7T
         p9RQ==
X-Gm-Message-State: AOAM531jytyFUJ1VGj/trc5WiD4A4gBhgSAXP0juzm5PFRlioera3XY/
        zPeIA/lrCM2mEEC/c7dcrfmUI/h398UnzQ==
X-Google-Smtp-Source: ABdhPJx8mrakcQoTylEwRyECS8AgNyqu79qApoz4nSwtdQp4MeVoda2piDCjBcoGPAJYR5PvT8XC2g==
X-Received: by 2002:a17:90a:ff13:: with SMTP id ce19mr5652135pjb.114.1628915287934;
        Fri, 13 Aug 2021 21:28:07 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id q21sm4420492pgk.71.2021.08.13.21.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 21:28:07 -0700 (PDT)
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
        Rao Shoaib <rao.shoaib@oracle.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v6 1/5] af_unix: add read_sock for stream socket types
Date:   Sat, 14 Aug 2021 04:27:46 +0000
Message-Id: <20210814042754.3351268-2-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210814042754.3351268-1-jiang.wang@bytedance.com>
References: <20210814042754.3351268-1-jiang.wang@bytedance.com>
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
index 1c2224f05b51..31061304ccf2 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -678,6 +678,8 @@ static int unix_dgram_sendmsg(struct socket *, struct msghdr *, size_t);
 static int unix_dgram_recvmsg(struct socket *, struct msghdr *, size_t, int);
 static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
 			  sk_read_actor_t recv_actor);
+static int unix_stream_read_sock(struct sock *sk, read_descriptor_t *desc,
+				 sk_read_actor_t recv_actor);
 static int unix_dgram_connect(struct socket *, struct sockaddr *,
 			      int, int);
 static int unix_seqpacket_sendmsg(struct socket *, struct msghdr *, size_t);
@@ -731,6 +733,7 @@ static const struct proto_ops unix_stream_ops = {
 	.shutdown =	unix_shutdown,
 	.sendmsg =	unix_stream_sendmsg,
 	.recvmsg =	unix_stream_recvmsg,
+	.read_sock =	unix_stream_read_sock,
 	.mmap =		sock_no_mmap,
 	.sendpage =	unix_stream_sendpage,
 	.splice_read =	unix_stream_splice_read,
@@ -2490,6 +2493,15 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 }
 #endif
 
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

