Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2481528A5BE
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 07:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgJKFKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 01:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgJKFKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 01:10:41 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33FAC0613CE;
        Sat, 10 Oct 2020 22:10:40 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t7so11681757ilf.10;
        Sat, 10 Oct 2020 22:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=6GQXG/Xg0mzB1f3ty4h1Dthp1etZqLKCAen1W821BOI=;
        b=IihVsWv3SFcB4WAYD7rsLTsC2Q67Pw7xqKWWOH6rwgORU5EUafzqroC595jVi2oUSW
         3ZF+4g8p70luAiKRLZOFhyviF/EY5pqGSFAXyjJQCTjWo3t0wcT/FyHkIZV4XPYX2syy
         bYMKA548bLE7wMS4XQJSGk1dgvOQtDzDhZNnBVDmTK8jVZuZkrMHfu9aVrTbEdnZZT6F
         XuNPByhJAmSzUG9ZeW6DGVgb3eOINhuHb15bhcE7pzSqd7O/nSQS+Re+pbefprfAkMy4
         dW1VYae5EjFqSQm/TKePb2FWdBREAoxzQ9ydGWU9M0bAoCKQutmGxDdhkrxr9ytBYoj/
         I6iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=6GQXG/Xg0mzB1f3ty4h1Dthp1etZqLKCAen1W821BOI=;
        b=duZW0TQxAufHT1Me1qAnpKRPCA5L3dMHQGAM9VbJrFs9/tMRglQ4gmQxqlQHF8Ib7q
         cM4aQ+BsweYiaN65Lau3e8Vimn+a2RkQp1F8m8PEJXr/wY0Iw1odhRtVegYPasK8zvPh
         +R5NnAMkR+ryHEjtPQxnU1GmQv0DW1mjKjQZXsny0L5YgZ5o/unBX97CFEUXp6Yarrwh
         jKz+W3xEPLWeysbnk+i6eJNAnvjnzMHerxfWy+K5Wnbnj2KPN71UdkfmULypzz4gu2VY
         kD6jP6qw93ZDN5OGX7UrRZGIluQmQa4mG1AUbRCdoW3piWlJYJOeIvCDBQR4H1ns5sRO
         Ke9g==
X-Gm-Message-State: AOAM530Io5ZoKG7ADYt8l//gPKuDqPUtIKZnWRPuRP2k0TJ4XFtpyX+C
        J8hcOY41NemfQ8veGJcAc6A=
X-Google-Smtp-Source: ABdhPJw4tq8xRk+P0BoVto05tqpC/nC9+8jPSeu7N8l2HvGtnclbWasNBcd9Adek138VPUccm2OBYw==
X-Received: by 2002:a92:ddcb:: with SMTP id d11mr16049768ilr.228.1602393040292;
        Sat, 10 Oct 2020 22:10:40 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t64sm7159708ild.10.2020.10.10.22.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 22:10:39 -0700 (PDT)
Subject: [bpf-next PATCH 4/4] bpf,
 selftests: Add three new sockmap tests for verdict only programs
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Sat, 10 Oct 2020 22:10:26 -0700
Message-ID: <160239302638.8495.17125996694402793471.stgit@john-Precision-5820-Tower>
In-Reply-To: <160239226775.8495.15389345509643354423.stgit@john-Precision-5820-Tower>
References: <160239226775.8495.15389345509643354423.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here we add three new tests for sockmap to test having a verdict program
without setting the parser program.

The first test covers the most simply case,

   sender         proxy_recv proxy_send      recv
     |                |                       |
     |              verdict -----+            |
     |                |          |            |
     +----------------+          +------------+

We load the verdict program on the proxy_recv socket without a
parser program. It then does a redirect into the send path of the
proxy_send socket using sendpage_locked().

Next we test the drop case to ensure if we kfree_skb as a result of
the verdict program everything behaves as expected.

Next we test the same configuration above, but with ktls and a
redirect into socket ingress queue. Shown here

   tls                                       tls
   sender         proxy_recv proxy_send      recv
     |                |                       |
     |              verdict ------------------+
     |                |      redirect_ingress
     +----------------+

Also to set up ping/pong test

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 419c0b010d14..0fa1e421c3d7 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -1472,12 +1472,29 @@ static void test_txmsg_skb(int cgrp, struct sockmap_options *opt)
 	txmsg_ktls_skb_drop = 0;
 	txmsg_ktls_skb_redir = 1;
 	test_exec(cgrp, opt);
+	txmsg_ktls_skb_redir = 0;
+
+	/* Tests that omit skb_parser */
+	txmsg_omit_skb_parser = 1;
+	ktls = 0;
+	txmsg_ktls_skb = 0;
+	test_exec(cgrp, opt);
+
+	txmsg_ktls_skb_drop = 1;
+	test_exec(cgrp, opt);
+	txmsg_ktls_skb_drop = 0;
+
+	txmsg_ktls_skb_redir = 1;
+	test_exec(cgrp, opt);
+
+	ktls = 1;
+	test_exec(cgrp, opt);
+	txmsg_omit_skb_parser = 0;
 
 	opt->data_test = data;
 	ktls = k;
 }
 
-
 /* Test cork with hung data. This tests poor usage patterns where
  * cork can leave data on the ring if user program is buggy and
  * doesn't flush them somehow. They do take some time however

