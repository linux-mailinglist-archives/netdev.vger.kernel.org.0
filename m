Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CA82E85EE
	for <lists+netdev@lfdr.de>; Sat,  2 Jan 2021 00:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbhAAX1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jan 2021 18:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbhAAX1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jan 2021 18:27:34 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34FDC0613ED
        for <netdev@vger.kernel.org>; Fri,  1 Jan 2021 15:26:53 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4D71PG6rjNzQlKL;
        Sat,  2 Jan 2021 00:26:26 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1609543585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zCHY+iNV/zG2h4FeSKcpBhT5LjiorSyP0zYyDtzm+1k=;
        b=zBGmvKi54H9kKFDZSxyJO/utVZUBWTx0+fzgyjTeX/Pm+xJIgDNxRpyp+98Fa1pyrmSVo3
        QJvooFIKocTXierTLKnyu9DEqMQuHCRug7Ng0uIyG1bLw6M6EcMDsUV+/GGm1G0XX02JKn
        aH89+dyiKiJ/WNRVdZRwHlxOAWE6Z7yyjSNHdbMjO2SH7qm+fcVBRd7Jh2sqE6vRhfSt0z
        stg3QrBiPK2PKKG1VY6Mnmn95akY1zjsZFzCsLXzbbikaxy9V24+qLDYal+yqtRDyhxqG+
        dOlpjKvzaJYxhBhVyfHDjwq0SYdLsfiU/3d/M892Rm+i4TJUsBwur37shlmX9Q==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id bQFvrk3rXucq; Sat,  2 Jan 2021 00:26:23 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2 3/3] dcb: Change --Netns/-N to --netns/-n
Date:   Sat,  2 Jan 2021 00:25:52 +0100
Message-Id: <5288d48567203a91e26df6ea94b59d1eb253c222.1609543363.git.me@pmachata.org>
In-Reply-To: <cover.1609543363.git.me@pmachata.org>
References: <cover.1609543363.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.25 / 15.00 / 15.00
X-Rspamd-Queue-Id: DD4CF1831
X-Rspamd-UID: 15f3b7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This to keep compatible with the major tools, ip and tc. Also
document the option in the man page, which was neglected.

Signed-off-by: Petr Machata <me@pmachata.org>
---
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

