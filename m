Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F55744D63B
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 12:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhKKMAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 07:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbhKKMAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 07:00:10 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0DCC061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 03:57:21 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id m25so4979262qtq.13
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 03:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oNr7NQJ+O6cRi3PNVg0Rien7aCPczIjyLhK3og0497w=;
        b=SvZvJM4picYmt3OYUJGNcpQU2tV+AlNRX+5cmS13dPeqeigRgO81w+0hxBQi8Ow9lc
         1Tmkpy5lv693keV18bkTUXxUTqsj326dbIXQk0jjG7V/E9pZRcf/PRPql5Lq2ZY0og2H
         RGEFZASDMMHpj6yadyu3suncA987YoBxEAvA/qcCxpE38ythp49QRBTOwgsNDpDMD6/N
         beoPi7DmDAEK99eXoj/KT0IZbkhXd9YSj48Z7t5tZacG6XIwEHvmHqFpMmzuoInG9e/Z
         sjj6MlUZ8TSJTa6SVqypqjDmIAd+FH3UygaMOEhKaSsh9D2M3tRM645ZteeXuorlLiq+
         dJPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oNr7NQJ+O6cRi3PNVg0Rien7aCPczIjyLhK3og0497w=;
        b=0OfMw6J0QQy/jCsAkTfe4qkaCXW855eI8UxnkQMz2eaD4DB4Pm6xOLnzNfCDuxJDfM
         fTkv9aSfMflfwXlC43PLC1QdKy1ewK6o2QZbxi6EWggK0EB6rFhOdQdHvnY4nPZfkk4d
         lTv+aILRaj9APKxCjmStTj5oG2hNOz7Yn5xrrqpwSrryt5XC64WvbfjpNOQdPGXkJ+v5
         GHQ0psyp7+Hv/MW9TfWf9UoE7K14FoDICyf9MdZB/4VI9ppc04/Qz5Nm1JFiDemfOI00
         soCt/ftgarJXq6+EffBX9FtP9Z1fnXaIbljsP3JBK4TU4buT/P28qBtIPTkEaUzuWney
         sPTQ==
X-Gm-Message-State: AOAM532zP1qITrBw1g1oPxvtiQ5NHDlaAr02FkLNoaBe0McQAf307WCY
        FXk00SfKzeAX5eQAWfpNfN+s5kZU/kZdWQ==
X-Google-Smtp-Source: ABdhPJyzFUb+m4dP79h+HUaTvIEFfaQHSdqx5vusbZ8mD2K2IUQmpPNzZP+BiVFsEh7BAzI01aFLOQ==
X-Received: by 2002:a05:622a:49:: with SMTP id y9mr6845073qtw.301.1636631840266;
        Thu, 11 Nov 2021 03:57:20 -0800 (PST)
Received: from willemb.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id ay12sm1265713qkb.35.2021.11.11.03.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 03:57:19 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] selftests/net: udpgso_bench_rx: fix port argument
Date:   Thu, 11 Nov 2021 06:57:17 -0500
Message-Id: <20211111115717.1925230-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

The below commit added optional support for passing a bind address.
It configures the sockaddr bind arguments before parsing options and
reconfigures on options -b and -4.

This broke support for passing port (-p) on its own.

Configure sockaddr after parsing all arguments.

Fixes: 3327a9c46352 ("selftests: add functionals test for UDP GRO")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index 76a24052f4b4..6a193425c367 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -293,19 +293,17 @@ static void usage(const char *filepath)
 
 static void parse_opts(int argc, char **argv)
 {
+	const char *bind_addr = NULL;
 	int c;
 
-	/* bind to any by default */
-	setup_sockaddr(PF_INET6, "::", &cfg_bind_addr);
 	while ((c = getopt(argc, argv, "4b:C:Gl:n:p:rR:S:tv")) != -1) {
 		switch (c) {
 		case '4':
 			cfg_family = PF_INET;
 			cfg_alen = sizeof(struct sockaddr_in);
-			setup_sockaddr(PF_INET, "0.0.0.0", &cfg_bind_addr);
 			break;
 		case 'b':
-			setup_sockaddr(cfg_family, optarg, &cfg_bind_addr);
+			bind_addr = optarg;
 			break;
 		case 'C':
 			cfg_connect_timeout_ms = strtoul(optarg, NULL, 0);
@@ -341,6 +339,11 @@ static void parse_opts(int argc, char **argv)
 		}
 	}
 
+	if (!bind_addr)
+		bind_addr = cfg_family == PF_INET6 ? "::" : "0.0.0.0";
+
+	setup_sockaddr(cfg_family, bind_addr, &cfg_bind_addr);
+
 	if (optind != argc)
 		usage(argv[0]);
 
-- 
2.34.0.rc0.344.g81b53c2807-goog

