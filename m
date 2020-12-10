Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5331B2D6B7B
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732697AbgLJXD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbgLJXDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:03:14 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA91C0613D6
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 15:02:59 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4CsTwK5ZDRzQlRP;
        Fri, 11 Dec 2020 00:02:57 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607641375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mp2xrhTquN7saCfJBt4ZITky6FC7iz4eAjzhcTAMnMU=;
        b=Ep5k3zuz0CLMmiu+kpIWz4e2OEzd+I4PCRBevlVUR1/mnDRr8ZvUXHUZ3kHyNiwcE4VeIH
        xo0vAzhi8P8Qtxeea4J71JPTcYFMb0G8Yx5VdwPhBastE5FnMI0c1u4Y8SqobI55QpFR1N
        1c5fPkBuCtgG6g9ipN7iGKPGYWCeS+ItnaTzOFYpiwYMy/I0yUdT6QZhZ7Jq5nFsRhoC2G
        XmSTp9sMlzKQD0z0CitBYQDIt51zN+JrmujJI3fPligLSPJOBxmGDOiO+H8BKRrTCmt+Cm
        0f0WAxvR4QFnZPn48HoUvp08GDaJaQPy1Mhf3EV35chI7RcllzQ5exS3i+JK+g==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id fQE9gJoJxZYq; Fri, 11 Dec 2020 00:02:54 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 07/10] dcb: Add -i to enable IEC mode
Date:   Fri, 11 Dec 2020 00:02:21 +0100
Message-Id: <4ed1fd0ab7cc906d9a56d4eebeb5dac267c6b219.1607640819.git.me@pmachata.org>
In-Reply-To: <cover.1607640819.git.me@pmachata.org>
References: <cover.1607640819.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.55 / 15.00 / 15.00
X-Rspamd-Queue-Id: C106A17BB
X-Rspamd-UID: c774a8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow switching "dcb" into the ISO/IEC mode of units by passing -i.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 dcb/dcb.c      | 10 +++++++---
 dcb/dcb.h      |  1 +
 man/man8/dcb.8 |  5 +++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index 9332a8b2e3d4..4b4a5b9354c6 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -310,8 +310,8 @@ static void dcb_help(void)
 		"Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"       dcb [ -f | --force ] { -b | --batch } filename [ -N | --Netns ] netnsname\n"
 		"where  OBJECT := ets\n"
-		"       OPTIONS := [ -V | --Version | -j | --json | -p | --pretty\n"
-		"                  | -s | --statistics | -v | --verbose ]\n");
+		"       OPTIONS := [ -V | --Version | -i | --iec | -j | --json\n"
+		"                  | -p | --pretty | -s | --statistics | -v | --verbose]\n");
 }
 
 static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
@@ -345,6 +345,7 @@ int main(int argc, char **argv)
 		{ "Version",		no_argument,		NULL, 'V' },
 		{ "force",		no_argument,		NULL, 'f' },
 		{ "batch",		required_argument,	NULL, 'b' },
+		{ "iec",		no_argument,		NULL, 'i' },
 		{ "json",		no_argument,		NULL, 'j' },
 		{ "pretty",		no_argument,		NULL, 'p' },
 		{ "statistics",		no_argument,		NULL, 's' },
@@ -365,7 +366,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "b:fhjpsvN:V",
+	while ((opt = getopt_long(argc, argv, "b:fhijpsvN:V",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -394,6 +395,9 @@ int main(int argc, char **argv)
 				goto dcb_free;
 			}
 			break;
+		case 'i':
+			dcb->use_iec = true;
+			break;
 		case 'h':
 			dcb_help();
 			return 0;
diff --git a/dcb/dcb.h b/dcb/dcb.h
index b2a13b3065f2..8637efc159b9 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -12,6 +12,7 @@ struct dcb {
 	struct mnl_socket *nl;
 	bool json_output;
 	bool stats;
+	bool use_iec;
 };
 
 int dcb_parse_mapping(const char *what_key, __u32 key, __u32 max_key,
diff --git a/man/man8/dcb.8 b/man/man8/dcb.8
index f853b7baaf33..15b43942585a 100644
--- a/man/man8/dcb.8
+++ b/man/man8/dcb.8
@@ -43,6 +43,11 @@ failure will cause termination of dcb.
 Don't terminate dcb on errors in batch mode. If there were any errors during
 execution of the commands, the application return code will be non zero.
 
+.TP
+.BR "\-i" , " --iec"
+When showing rates, use ISO/IEC 1024-based prefixes (Ki, Mi, Bi) instead of
+the 1000-based ones (K, M, B).
+
 .TP
 .BR "\-j" , " --json"
 Generate JSON output.
-- 
2.25.1

