Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CED6280BDC
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387561AbgJBBKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387511AbgJBBKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 21:10:21 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A624C0613D0;
        Thu,  1 Oct 2020 18:10:21 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id o9so283724ils.9;
        Thu, 01 Oct 2020 18:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Esvmu2mi+tSqITrH0Uemcr2L2tuGtFSyiVNfueGSLzg=;
        b=uLbEX7VLS/XdZRZVBpc5cXRUs5LqY7YwqclFPL6H27Mnd/9IXSO4yPPy+ML5KFxi+n
         ckGS8M1zqHtxYMZi7f4kmSDMGfQspXBOIKPGCWo3Z4ZQIIkyHlyL6ZEe9yRevT7b238U
         npVeULz1rn4ksKwZVM+p5lvEQ+JJszt0CTc2DYQ8vFGYxf6d/Z9Y/3O09MkH3J53Z/CU
         ub3Ws55ObQq8O1bl9hJQZ1y4Dew3ZAa4upf7zoPe32toGSYX9ka46FnVwBV4DS/64c0r
         otlyY9uqXWtdH6pA/3aL79+k+PKeaGuH+b5g3gVQIppqQKW2bydfluvj7BkYH2kC6M7O
         H9rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Esvmu2mi+tSqITrH0Uemcr2L2tuGtFSyiVNfueGSLzg=;
        b=br4m6J7morCXcUv2hp8XMXi5ZKP6w0M4rFEt01G1WMG9J6TSMhUTXCYZffCzqPm2Qx
         z1Hd6KrOIHHM5X4c1aGbybY6kMXj6e7LylJJ26hLI0Hr3VP1Epve9jWFQTxXVIOka6XR
         ng3B1Up65IlPQwUtiueygxs8fbd6dbls/dDVb7Y53NF8KIiK6hOOBlXpweT+oO+Jlb1Y
         xVfb22XOI/WY+GgppcyEl+toQoyLTVVPhFR711JvkYK9RH78TrQqb870v2g95YOUJYUL
         fmYTsct7cx5XwaHvOoTMlCKa2+SCr6uwn0JvfRfPRJpGBO7VUwAvFC6Mn7R1zDmzJWm2
         HhSQ==
X-Gm-Message-State: AOAM532X9e+AGFLhobGD77xuuc7y55U7ixSHd14vtM0xY0VIytEE3C+/
        Cz9ZVc/tH6iVkBQ1Uwb6MQc=
X-Google-Smtp-Source: ABdhPJxFMQ1LgPfvq1CTsg23AC77g81ANSnbVafWv+WiCUmNL8Hpi7ZyVJNGGww56H9PLkWT7El27Q==
X-Received: by 2002:a92:4142:: with SMTP id o63mr5015625ila.138.1601601020961;
        Thu, 01 Oct 2020 18:10:20 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m20sm2135804iob.44.2020.10.01.18.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 18:10:20 -0700 (PDT)
Subject: [bpf-next PATCH v2 2/2] bpf,
 sockmap: update selftests to use skb_adjust_room
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, jakub@cloudflare.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 01 Oct 2020 18:10:09 -0700
Message-ID: <160160100932.7052.3646935243867660528.stgit@john-Precision-5820-Tower>
In-Reply-To: <160160094764.7052.2711632803258461907.stgit@john-Precision-5820-Tower>
References: <160160094764.7052.2711632803258461907.stgit@john-Precision-5820-Tower>
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

