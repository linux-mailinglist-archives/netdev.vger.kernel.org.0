Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0E328A5BC
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 07:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgJKFKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 01:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgJKFKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 01:10:20 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DE1C0613CE;
        Sat, 10 Oct 2020 22:10:20 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id u19so14415824ion.3;
        Sat, 10 Oct 2020 22:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=GhAxcO6z0s97SRWhKk0j8JILvo+IQBleeMoKI7214+M=;
        b=MA/ICLmJHTK8G9TqQ2oWkerJqaoxVq4lBKO4mYAzKX7zRHUYRtxpSoA7dbKPrXpray
         tYnRUW4syRNgdujNdykC9X8ujExEC/zJBrKH/XIQ8ZkdtwfCZ2ZoOOxrGvOlmUd2PkGA
         T/7MYHlawknpstr0GSYI5Oa9KeVMRzqSZazOoPwknzFfJsIzmwEWUzH6xA0/FZ1HsftE
         l2lXZYP1nH/zs86OLb3MAU0DO9duW55cAl2qByYL/ZyTwdTLggjuQK76M4Cbvu/ThZaD
         /aCnZP8cxXMdjuxJyAOxNa2sOc1bfdhKmQTn+90GfDspHVg9jE0NGtdkfhGtPvsdGPps
         yiEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=GhAxcO6z0s97SRWhKk0j8JILvo+IQBleeMoKI7214+M=;
        b=eGrfaTuQ3LbXoDvT0iq3m9s2Upf8RhjLKVB9X62NeIUvnlq+OueiDm1YdaL5oe99yu
         7AFG9r80Asicjq3vhJEmn64fqBpXitvI7h+BVPhElmE/n6WlGnMPde1HbWRCm0Rzv+XR
         TuOvJJxhcfomCllhkxX7VF8Pc+XXtbNB7fDf66PLzOZWK71mlOcMDzK458YagZ2WElvu
         KGKvddEAoSaN1hujyC3nf1FQ7eBEW6uq1uMBTpSOpOnXk0MNtWkZ+PgmlGawP3E0d5d4
         HQToEh1LwMbwMq8gP4L5KO2q4OreiTXWYn23TohHTL7Wp84NezjLeLnS4pnrrB85Nxcm
         ei5g==
X-Gm-Message-State: AOAM533p2EGrZiVJJSXthr1z1OZAyfBZqnUxzOlkmG6lp6DDC8hWUit1
        GgOgSs9z66nFMVuoEJWVTOE=
X-Google-Smtp-Source: ABdhPJyq2qTp7As2UKUFnU2dtV1gAHeL6RsW1NavcP44dEZgEwEjBvbx+sPRpoV2u9X2+pOUTLcBUQ==
X-Received: by 2002:a6b:8e4b:: with SMTP id q72mr13146947iod.104.1602393019352;
        Sat, 10 Oct 2020 22:10:19 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l7sm6884339ili.82.2020.10.10.22.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 22:10:18 -0700 (PDT)
Subject: [bpf-next PATCH 3/4] bpf,
 selftests: Add option to test_sockmap to omit adding parser program
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Sat, 10 Oct 2020 22:10:04 -0700
Message-ID: <160239300387.8495.11908295143121563076.stgit@john-Precision-5820-Tower>
In-Reply-To: <160239226775.8495.15389345509643354423.stgit@john-Precision-5820-Tower>
References: <160239226775.8495.15389345509643354423.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add option to allow running without a parser program in place. To test
with ping/pong program use,

 # test_sockmap -t ping --txmsg_omit_skb_parser

this will send packets between two socket bouncing through a proxy
socket that does not use a parser program.

   (ping)                                    (pong)
   sender         proxy_recv proxy_send      recv
     |                |                       |
     |              verdict -----+            |
     |                |          |            |
     +----------------+          +------------+

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c |   35 +++++++++++++++++-----------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 5cf45455de42..419c0b010d14 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -86,6 +86,7 @@ int txmsg_ktls_skb_redir;
 int ktls;
 int peek_flag;
 int skb_use_parser;
+int txmsg_omit_skb_parser;
 
 static const struct option long_options[] = {
 	{"help",	no_argument,		NULL, 'h' },
@@ -111,6 +112,7 @@ static const struct option long_options[] = {
 	{"txmsg_redir_skb", no_argument,	&txmsg_redir_skb, 1 },
 	{"ktls", no_argument,			&ktls, 1 },
 	{"peek", no_argument,			&peek_flag, 1 },
+	{"txmsg_omit_skb_parser", no_argument,      &txmsg_omit_skb_parser, 1},
 	{"whitelist", required_argument,	NULL, 'n' },
 	{"blacklist", required_argument,	NULL, 'b' },
 	{0, 0, NULL, 0 }
@@ -175,6 +177,7 @@ static void test_reset(void)
 	txmsg_apply = txmsg_cork = 0;
 	txmsg_ingress = txmsg_redir_skb = 0;
 	txmsg_ktls_skb = txmsg_ktls_skb_drop = txmsg_ktls_skb_redir = 0;
+	txmsg_omit_skb_parser = 0;
 	skb_use_parser = 0;
 }
 
@@ -912,13 +915,15 @@ static int run_options(struct sockmap_options *options, int cg_fd,  int test)
 		goto run;
 
 	/* Attach programs to sockmap */
-	err = bpf_prog_attach(prog_fd[0], map_fd[0],
-				BPF_SK_SKB_STREAM_PARSER, 0);
-	if (err) {
-		fprintf(stderr,
-			"ERROR: bpf_prog_attach (sockmap %i->%i): %d (%s)\n",
-			prog_fd[0], map_fd[0], err, strerror(errno));
-		return err;
+	if (!txmsg_omit_skb_parser) {
+		err = bpf_prog_attach(prog_fd[0], map_fd[0],
+				      BPF_SK_SKB_STREAM_PARSER, 0);
+		if (err) {
+			fprintf(stderr,
+				"ERROR: bpf_prog_attach (sockmap %i->%i): %d (%s)\n",
+				prog_fd[0], map_fd[0], err, strerror(errno));
+			return err;
+		}
 	}
 
 	err = bpf_prog_attach(prog_fd[1], map_fd[0],
@@ -931,13 +936,15 @@ static int run_options(struct sockmap_options *options, int cg_fd,  int test)
 
 	/* Attach programs to TLS sockmap */
 	if (txmsg_ktls_skb) {
-		err = bpf_prog_attach(prog_fd[0], map_fd[8],
-					BPF_SK_SKB_STREAM_PARSER, 0);
-		if (err) {
-			fprintf(stderr,
-				"ERROR: bpf_prog_attach (TLS sockmap %i->%i): %d (%s)\n",
-				prog_fd[0], map_fd[8], err, strerror(errno));
-			return err;
+		if (!txmsg_omit_skb_parser) {
+			err = bpf_prog_attach(prog_fd[0], map_fd[8],
+					      BPF_SK_SKB_STREAM_PARSER, 0);
+			if (err) {
+				fprintf(stderr,
+					"ERROR: bpf_prog_attach (TLS sockmap %i->%i): %d (%s)\n",
+					prog_fd[0], map_fd[8], err, strerror(errno));
+				return err;
+			}
 		}
 
 		err = bpf_prog_attach(prog_fd[2], map_fd[8],

