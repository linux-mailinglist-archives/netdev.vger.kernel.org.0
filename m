Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2C82E8BD1
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 11:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbhACK7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 05:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbhACK7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 05:59:07 -0500
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BCFC0613D3
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 02:58:26 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4D7whl5fXHzQlMX;
        Sun,  3 Jan 2021 11:57:59 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1609671478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f/RDR7PYKviXfSPtd0FG0sDUnFJf0Nkgl6dRp3Xk8Nc=;
        b=wLbbpCk32elrkKTwC5Ad58MQ5lDX05Z++Ak0Q4PhT3dLx25bzye6DELHudRJPIMNWDJ3gR
        SJRQboZBZrsf8rVhheRDn8sjf/B8XgKbc9Dhnch6zjsJ6+xfv6ymDgHOeTxvVNZAFtEbeD
        D0bZ8nPHX08Pvz0DIvQtrQ/3NrmV+5+X2vvlv3zd44hN5H4te25WFVNS9DJrpk2YlVkV++
        qdKE5sGAJdBUL84ewoH4+T+k2D3wANrX5S6H1/yIbwknq1mv3jqR2oxoyRe/XOO8dACMqG
        khGK7dif3tE+sntpwzTuveCYaE1WNkgH6dMFOF+LqOgYyy3BrwzfftuYKbKkHA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id lgI6SNGOzuNq; Sun,  3 Jan 2021 11:57:57 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2 v2 3/3] dcb: Change --Netns/-N to --netns/-n
Date:   Sun,  3 Jan 2021 11:57:24 +0100
Message-Id: <3fd48002172b185a34cc80cdd79de44fc31ea8fa.1609671168.git.me@pmachata.org>
In-Reply-To: <cover.1609671168.git.me@pmachata.org>
References: <cover.1609671168.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.46 / 15.00 / 15.00
X-Rspamd-Queue-Id: D6271184F
X-Rspamd-UID: 60142d
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This to keep compatible with the major tools, ip and tc. Also
document the option in the man page, which was neglected.

Fixes: 67033d1c1c8a ("Add skeleton of a new tool, dcb")
Signed-off-by: Petr Machata <me@pmachata.org>
---

Notes:
    v2:
    - Add Fixes: tag.

 dcb/dcb.c      | 8 ++++----
 man/man8/dcb.8 | 7 +++++++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index 0e3c87484f2a..6640deef5688 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -332,7 +332,7 @@ static void dcb_help(void)
 {
 	fprintf(stderr,
 		"Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
-		"       dcb [ -f | --force ] { -b | --batch } filename [ -N | --Netns ] netnsname\n"
+		"       dcb [ -f | --force ] { -b | --batch } filename [ -n | --netns ] netnsname\n"
 		"where  OBJECT := { buffer | ets | maxrate | pfc }\n"
 		"       OPTIONS := [ -V | --Version | -i | --iec | -j | --json\n"
 		"                  | -p | --pretty | -s | --statistics | -v | --verbose]\n");
@@ -379,7 +379,7 @@ int main(int argc, char **argv)
 		{ "json",		no_argument,		NULL, 'j' },
 		{ "pretty",		no_argument,		NULL, 'p' },
 		{ "statistics",		no_argument,		NULL, 's' },
-		{ "Netns",		required_argument,	NULL, 'N' },
+		{ "netns",		required_argument,	NULL, 'n' },
 		{ "help",		no_argument,		NULL, 'h' },
 		{ NULL, 0, NULL, 0 }
 	};
@@ -396,7 +396,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "b:fhijpsvN:V",
+	while ((opt = getopt_long(argc, argv, "b:fhijn:psvV",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -419,7 +419,7 @@ int main(int argc, char **argv)
 		case 's':
 			dcb->stats = true;
 			break;
-		case 'N':
+		case 'n':
 			if (netns_switch(optarg)) {
 				ret = EXIT_FAILURE;
 				goto dcb_free;
diff --git a/man/man8/dcb.8 b/man/man8/dcb.8
index 5964f25d386d..7293bb303577 100644
--- a/man/man8/dcb.8
+++ b/man/man8/dcb.8
@@ -27,6 +27,13 @@ dcb \- show / manipulate DCB (Data Center Bridging) settings
 
 .SH OPTIONS
 
+.TP
+.BR "\-n" , " \--netns " <NETNS>
+switches
+.B dcb
+to the specified network namespace
+.IR NETNS .
+
 .TP
 .BR "\-V" , " --Version"
 Print the version of the
-- 
2.26.2

