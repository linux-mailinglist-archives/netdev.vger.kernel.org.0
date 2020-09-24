Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DC627657F
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIXA7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXA7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:59:16 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB78C0613CE;
        Wed, 23 Sep 2020 17:59:16 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id k133so808432pgc.7;
        Wed, 23 Sep 2020 17:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=caeOrIOiWzUnYpp7IiQWCVx7AsBLB7hgOndSGgrX5Gk=;
        b=A+w9Rw6SyEI43czzAmd7oHvoRqydl8clyM3C8ClOVgQCfO74S02EvNMxY3TfslPQLF
         YOC81YxdMeaMkgtMyP2Ulij/i5WgZxMrC4BbW9ZfkX0y4Lj2ebnXjrD5vgsH6qCcWr7L
         qIyiSIDEwetm3DU67z+HvVvhYmNn7AdoJEr8k0KD9tYGNzTTztl3zka86trlRf7J7Jvx
         5v99NtLLnNg8lo0xFnJ733bPl1jSt+coGYWPWwMun1rO0+5OQNcJ8RUtTbK2IszZo7ft
         JJ3kxiBdMU5br4h+NGZyycsgGDhwYKWnnlup3bZ7mDT6G84evJfEmfsYlUeWbrT6+UHH
         BQAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=caeOrIOiWzUnYpp7IiQWCVx7AsBLB7hgOndSGgrX5Gk=;
        b=g1swsDvvCcvDdqoemT9fZVKKYAuYdzYaEJHONc93z7t3D2AX4y9pIqMrFybR9Gq9Ly
         JYDcJrcxqMWuJxRhJyVrP9FLV2BoGlTlq+5ViL1y5t6nsVt1EBaqoSOaN0KclaEKDIQq
         c+1i6eIwu76yKaIIWltySRGFoyDaajcQXnG5+qStXBbRkST9sVwUrQ3WELozOszPW/PL
         dsFpOIIn6Ay8J/48iBvgEd00TlpgYprbZbfLvNswQd9iE4lK2OfKtCv0m8Mo6f2/LEE+
         +lwxu6o8vcQNHQY46Ni0ZKy89rQhJqgfckRJrnQV0sihHNx9czqrnXSZF8vyHfl7a0Rn
         4aDg==
X-Gm-Message-State: AOAM5326OoOQdN3LaxDgaHz8PivB54WylcXM0gtr9y4tCvG5jW4Ch7TS
        LtrouryiPyHi1xsST3IfnQU=
X-Google-Smtp-Source: ABdhPJytDZ8UoWMFGkes4Q/X0vLr/CJXZP9ZSSTfzJTY62QE6UHAyGz0adcgCIEaMPTORUEY1c0lhQ==
X-Received: by 2002:a63:4e0a:: with SMTP id c10mr1845032pgb.369.1600909155791;
        Wed, 23 Sep 2020 17:59:15 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id 27sm889290pgy.26.2020.09.23.17.59.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 17:59:15 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 12/16] selftests: mptcp: add remove cfg in mptcp_connect
Date:   Thu, 24 Sep 2020 08:29:58 +0800
Message-Id: <aa4ffb8cb7f8c135e5704eb11cfce7cb0bf7ecd4.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
In-Reply-To: <fcebccadfa3127e0f55103cc7ee4cd00841e2ea0.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com> <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com> <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com> <f9b7f06f71698c2e78366da929a7fef173d01856.1600853093.git.geliangtang@gmail.com> <430dd4f9c241ae990a5cfa6809276b36993ce91b.1600853093.git.geliangtang@gmail.com> <7b0898eff793dde434464b5fac2629739d9546fd.1600853093.git.geliangtang@gmail.com> <98bcc56283c482c294bd6ae9ce1476821ddc6837.1600853093.git.geliangtang@gmail.com> <37f2befac450fb46367f62446a4bb2c9d0a5986a.1600853093.git.geliangtang@gmail.com> <5018fd495529e058ea866e8d8edbe0bb98ec733a.1600853093.git.geliangtang@gmail.com> <644420f22ba6f0b9f9f3509c081d8d639ff4bbf3.1600853093.git.geliangtang@gmail.com> <fcebccadfa3127e0f55103cc7ee4cd00841e2ea0.1600853093.git.geliangtang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added a new cfg, named cfg_remove in mptcp_connect. This new
cfg_remove is copied from cfg_join. The only difference between them is in
the do_rnd_write function. Here we slow down the transfer process of all
data to let the RM_ADDR suboption can be sent and received completely.
Otherwise the remove address and subflow test cases don't work.

Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 .../selftests/net/mptcp/mptcp_connect.c        | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index a54966531a64..77bb62feb872 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -54,6 +54,7 @@ static int pf = AF_INET;
 static int cfg_sndbuf;
 static int cfg_rcvbuf;
 static bool cfg_join;
+static bool cfg_remove;
 static int cfg_wait;
 
 static void die_usage(void)
@@ -271,6 +272,9 @@ static size_t do_rnd_write(const int fd, char *buf, const size_t len)
 	if (cfg_join && first && do_w > 100)
 		do_w = 100;
 
+	if (cfg_remove && do_w > 50)
+		do_w = 50;
+
 	bw = write(fd, buf, do_w);
 	if (bw < 0)
 		perror("write");
@@ -281,6 +285,9 @@ static size_t do_rnd_write(const int fd, char *buf, const size_t len)
 		first = false;
 	}
 
+	if (cfg_remove)
+		usleep(200000);
+
 	return bw;
 }
 
@@ -428,7 +435,7 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd)
 	}
 
 	/* leave some time for late join/announce */
-	if (cfg_join)
+	if (cfg_join || cfg_remove)
 		usleep(cfg_wait);
 
 	close(peerfd);
@@ -686,7 +693,7 @@ static void maybe_close(int fd)
 {
 	unsigned int r = rand();
 
-	if (!cfg_join && (r & 1))
+	if (!(cfg_join || cfg_remove) && (r & 1))
 		close(fd);
 }
 
@@ -822,13 +829,18 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "6jlp:s:hut:m:S:R:w:")) != -1) {
+	while ((c = getopt(argc, argv, "6jrlp:s:hut:m:S:R:w:")) != -1) {
 		switch (c) {
 		case 'j':
 			cfg_join = true;
 			cfg_mode = CFG_MODE_POLL;
 			cfg_wait = 400000;
 			break;
+		case 'r':
+			cfg_remove = true;
+			cfg_mode = CFG_MODE_POLL;
+			cfg_wait = 400000;
+			break;
 		case 'l':
 			listen_mode = true;
 			break;
-- 
2.17.1

