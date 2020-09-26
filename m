Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D1D2796E4
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 06:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725208AbgIZE1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 00:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgIZE1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 00:27:39 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE422C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 21:27:38 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id c13so5030987oiy.6
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 21:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Esvmu2mi+tSqITrH0Uemcr2L2tuGtFSyiVNfueGSLzg=;
        b=YXiK0KLRG+IUVqFJWEL1nf979+r3D1fXmn6c33PYQhnAI0kMIQDsVEvSBMXcxImrxd
         8HPcEzksTr3nMvNTCGLyaw8nNYiP6y2NdlOW46l27u80AuD3GbneWnHR3r/x4zzzySXE
         9HYNG4xU2PUOhNEr1NBrVJbF3vPrZWmtVO7jEJx4wXdXDgm0jOoXwHVNvx89c1bmkUFt
         s5dVXzA7iv2o0Hk0MkRLV7iBBn3IEFbM78d4jxwefYLOkjfSIBLk/DccbDXcA+rRJIgv
         YH5W7rE/g8y9wBr7ZPoSPy6Q1g2FLGNGYWSkE9f3hdo9SCyEb5rGtMgau8VVunClVbvi
         9Uaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Esvmu2mi+tSqITrH0Uemcr2L2tuGtFSyiVNfueGSLzg=;
        b=fffB0bytsqyeVZhsddXZOKiKOUBzdGirq+Frktrw+JaXrSoO4uHye1NSh/1kpxt9NU
         ekvecDYdhJvi+jh3CHo7ffi2Hqxe2kOKAMoOCAsrndSOODpvdpD7BpbzRWN1QuVpmrpp
         q+XWKuYw13D7MGGNkGAQeJGGbuKF1ph1alaaQp21COULNgT/tzHbU5cqABZtYdZD7NGA
         vot29SIeElFiA4mD5cKH+jUqdWcb3iNYBVFLk20rcmLHSIiZp7Z+bc4pc0BJbwR1xBRB
         DJ87z03M+SGARTh1BTqP/c+B17JVi6+P4aZQLLxE7NtyPhbNyAnQcu6UMqSlwqxZQGdR
         Oslg==
X-Gm-Message-State: AOAM531bNQX6rO4ZuePxQqiZGy6/IDSA7jbUBfx54TMKXGuD9J+WMlRZ
        Gu9lqN4jzv5FcFKBb2fzOac=
X-Google-Smtp-Source: ABdhPJyurbztNhXSLwsGvAyo8UzBgku9IBbpi3wLajeG0jDeMnw0JvD2R8Cn+QGQeu8NI82Wi9uEyQ==
X-Received: by 2002:aca:4d91:: with SMTP id a139mr409058oib.151.1601094457324;
        Fri, 25 Sep 2020 21:27:37 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id o108sm1186436ota.25.2020.09.25.21.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 21:27:36 -0700 (PDT)
Subject: [bpf-next PATCH 2/2] bpf,
 sockmap: update selftests to use skb_adjust_room
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, lmb@cloudflare.com
Date:   Fri, 25 Sep 2020 21:27:24 -0700
Message-ID: <160109444404.6363.9339278636807982940.stgit@john-Precision-5820-Tower>
In-Reply-To: <160109391820.6363.6475038352873960677.stgit@john-Precision-5820-Tower>
References: <160109391820.6363.6475038352873960677.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of working around TLS headers in sockmap selftests use the
new skb_adjust_room helper. This allows us to avoid special casing
the receive side to skip headers.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/progs/test_sockmap_kern.h        |   34 +++++++++++++++-----
 tools/testing/selftests/bpf/test_sockmap.c         |   27 ++++------------
 2 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_kern.h b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
index 3dca4c2e2418..1858435de7aa 100644
--- a/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
@@ -131,39 +131,55 @@ int bpf_prog2(struct __sk_buff *skb)
 
 }
 
-SEC("sk_skb3")
-int bpf_prog3(struct __sk_buff *skb)
+static inline void bpf_write_pass(struct __sk_buff *skb, int offset)
 {
-	const int one = 1;
-	int err, *f, ret = SK_PASS;
+	int err = bpf_skb_pull_data(skb, 6 + offset);
 	void *data_end;
 	char *c;
 
-	err = bpf_skb_pull_data(skb, 19);
 	if (err)
-		goto tls_out;
+		return;
 
 	c = (char *)(long)skb->data;
 	data_end = (void *)(long)skb->data_end;
 
-	if (c + 18 < data_end)
-		memcpy(&c[13], "PASS", 4);
+	if (c + 5 + offset < data_end)
+		memcpy(c + offset, "PASS", 4);
+}
+
+SEC("sk_skb3")
+int bpf_prog3(struct __sk_buff *skb)
+{
+	int err, *f, ret = SK_PASS;
+	const int one = 1;
+
 	f = bpf_map_lookup_elem(&sock_skb_opts, &one);
 	if (f && *f) {
 		__u64 flags = 0;
 
 		ret = 0;
 		flags = *f;
+
+		err = bpf_skb_adjust_room(skb, -13, 0, 0);
+		if (err)
+			return SK_DROP;
+		err = bpf_skb_adjust_room(skb, 4, 0, 0);
+		if (err)
+			return SK_DROP;
+		bpf_write_pass(skb, 0);
 #ifdef SOCKMAP
 		return bpf_sk_redirect_map(skb, &tls_sock_map, ret, flags);
 #else
 		return bpf_sk_redirect_hash(skb, &tls_sock_map, &ret, flags);
 #endif
 	}
-
 	f = bpf_map_lookup_elem(&sock_skb_opts, &one);
 	if (f && *f)
 		ret = SK_DROP;
+	err = bpf_skb_adjust_room(skb, 4, 0, 0);
+	if (err)
+		return SK_DROP;
+	bpf_write_pass(skb, 13);
 tls_out:
 	return ret;
 }
diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 9b6fb00dc7a0..5cf45455de42 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -518,28 +518,13 @@ static int msg_verify_data(struct msghdr *msg, int size, int chunk_sz)
 		if (i == 0 && txmsg_ktls_skb) {
 			if (msg->msg_iov[i].iov_len < 4)
 				return -EIO;
-			if (txmsg_ktls_skb_redir) {
-				if (memcmp(&d[13], "PASS", 4) != 0) {
-					fprintf(stderr,
-						"detected redirect ktls_skb data error with skb ingress update @iov[%i]:%i \"%02x %02x %02x %02x\" != \"PASS\"\n", i, 0, d[13], d[14], d[15], d[16]);
-					return -EIO;
-				}
-				d[13] = 0;
-				d[14] = 1;
-				d[15] = 2;
-				d[16] = 3;
-				j = 13;
-			} else if (txmsg_ktls_skb) {
-				if (memcmp(d, "PASS", 4) != 0) {
-					fprintf(stderr,
-						"detected ktls_skb data error with skb ingress update @iov[%i]:%i \"%02x %02x %02x %02x\" != \"PASS\"\n", i, 0, d[0], d[1], d[2], d[3]);
-					return -EIO;
-				}
-				d[0] = 0;
-				d[1] = 1;
-				d[2] = 2;
-				d[3] = 3;
+			if (memcmp(d, "PASS", 4) != 0) {
+				fprintf(stderr,
+					"detected skb data error with skb ingress update @iov[%i]:%i \"%02x %02x %02x %02x\" != \"PASS\"\n",
+					i, 0, d[0], d[1], d[2], d[3]);
+				return -EIO;
 			}
+			j = 4; /* advance index past PASS header */
 		}
 
 		for (; j < msg->msg_iov[i].iov_len && size; j++) {

