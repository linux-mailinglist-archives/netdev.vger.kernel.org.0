Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC46F2187C0
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 14:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgGHMin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 08:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728759AbgGHMin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 08:38:43 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362D0C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 05:38:43 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id y13so26791700lfe.9
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 05:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9K491pjAVTaEkQoJPXxghkK4ZlmEPmiOFy+MXkAoO8U=;
        b=Oebwi5hWEBTTfWktH8Gk2GjwoQG5In9VfMu1QpslQsMHbpFozB1WCe3hI1BVzmOzSi
         TIdpJ6dFzOxjMeUYYvP0wvkfEt4JMlHCdnSrpvMclD16LetX5JGwD97pBqISW0IdEVr7
         wBLhoON7v2b0pe1dtTtQaO4RG1UTc6alk4llore4J75vCCsVDtSQBz4MkxtO5rU61MD1
         BoKePb0GU6v3tSQBXyD/eem960dSQm5DTuzHhArhh0AKu/cInJvDvJFrcco8aAays+tO
         31Co63lPY5WyiJn3zyd/KWhd2MI7RTjlr7gDcgjlbKJ+6LxBNzhp+uEhmGSya8tSNbA8
         0FYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9K491pjAVTaEkQoJPXxghkK4ZlmEPmiOFy+MXkAoO8U=;
        b=DtMEHxwhO8CrRltG0CDG8zQBBb7g8idcJQlhSy2f2Ww1RAcZyjvqaulAAg63cUX7So
         ulPBIi79n0IRur2WpLjS+YP74VaUkAXl88GOfo7ZTG38ewVZzhcgkWkhKs7c0vHHG9Io
         wauM6ojqF0z7PbllMoWXUl/QX6Z8Sz125vdgRbDQ4ggQ21N32Vx1OyWd419is9rU4RJl
         QEEQSFEITycuA9B+4cvYVnlx+59cqR+J5Dqnv+vUb0X+N5ridrPfSBmGSbw3rsugGLlV
         3kEjGTwtiSnAw6LWfqI3CdZUzGDEleeWDjypm2M0BXQXH2tPuFnbGiZ/XGzVO2hoi0Ot
         bGfw==
X-Gm-Message-State: AOAM5308kTCsjXmyF3fWpjlBTmAYKlC+UVkJqmHx6x6lzwIk+c6Z3sq1
        vJ9VKG/sVV1ltmln4qIwngkEkR5ZRjQ=
X-Google-Smtp-Source: ABdhPJyWH6VvPLwoPCqee1Jz1D4iN/Ikletz5SnsbZX0bTeTG5KSwH046ak5XqNpHElF5bUYMnssWw==
X-Received: by 2002:ac2:4a83:: with SMTP id l3mr36783014lfp.92.1594211921522;
        Wed, 08 Jul 2020 05:38:41 -0700 (PDT)
Received: from dau-pc-work.sunlink.ru ([87.244.6.228])
        by smtp.googlemail.com with ESMTPSA id k6sm10329188lfm.89.2020.07.08.05.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:38:41 -0700 (PDT)
From:   Anton Danilov <littlesmilingcloud@gmail.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org,
        Anton Danilov <littlesmilingcloud@gmail.com>
Subject: [PATCH iproute2] nstat: case-insensitive pattern matching
Date:   Wed,  8 Jul 2020 15:38:02 +0300
Message-Id: <20200708123801.878-1-littlesmilingcloud@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The option 'nocase' allows ignore case in the pattern matching.

Examples:
    nstat --nocase *drop*
    nstat -azi icmp*

Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
---
 man/man8/rtacct.8 |  8 +++++++-
 misc/nstat.c      | 14 ++++++++++----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/man/man8/rtacct.8 b/man/man8/rtacct.8
index ccdbf6ca..cb6ac912 100644
--- a/man/man8/rtacct.8
+++ b/man/man8/rtacct.8
@@ -4,7 +4,7 @@
 nstat, rtacct - network statistics tools.
 
 .SH SYNOPSIS
-Usage: nstat [ -h?vVzrnasd:t:jp ] [ PATTERN [ PATTERN ] ]
+Usage: nstat [ -h?vVzrnasd:t:jpi ] [ PATTERN [ PATTERN ] ]
 .br
 Usage: rtacct [ -h?vVzrnasd:t: ] [ ListOfRealms ]
 
@@ -14,6 +14,9 @@ and
 .B rtacct
 are simple tools to monitor kernel snmp counters and network interface statistics.
 
+.B nstat
+can filter kernel snmp counters by name with one or several specified wildcards.
+
 .SH OPTIONS
 .B \-h, \-\-help
 Print help
@@ -44,6 +47,9 @@ When combined with
 .BR \-\-json ,
 pretty print the output.
 .TP
+.B \-i, \-\-nocase
+Ignore case in pattern matching.
+.TP
 .B \-d, \-\-scan <INTERVAL>
 Run in daemon mode collecting statistics. <INTERVAL> is interval between measurements in seconds.
 .TP
diff --git a/misc/nstat.c b/misc/nstat.c
index 425e75ef..243caebe 100644
--- a/misc/nstat.c
+++ b/misc/nstat.c
@@ -43,6 +43,7 @@ int time_constant;
 double W;
 char **patterns;
 int npatterns;
+int nocase;
 
 char info_source[128];
 int source_mismatch;
@@ -114,7 +115,7 @@ static int match(const char *id)
 		return 1;
 
 	for (i = 0; i < npatterns; i++) {
-		if (!fnmatch(patterns[i], id, 0))
+		if (!fnmatch(patterns[i], id, nocase ? FNM_CASEFOLD : 0))
 			return 1;
 	}
 	return 0;
@@ -551,6 +552,7 @@ static void usage(void)
 		"   -h, --help		this message\n"
 		"   -a, --ignore	ignore history\n"
 		"   -d, --scan=SECS	sample every statistics every SECS\n"
+		"   -i, --nocase	ignore case in pattern matching\n"
 		"   -j, --json		format output in JSON\n"
 		"   -n, --nooutput	do history only\n"
 		"   -p, --pretty	pretty print\n"
@@ -566,11 +568,12 @@ static const struct option longopts[] = {
 	{ "help", 0, 0, 'h' },
 	{ "ignore",  0,  0, 'a' },
 	{ "scan", 1, 0, 'd'},
-	{ "nooutput", 0, 0, 'n' },
+	{ "nocase", 0, 0, 'i' },
 	{ "json", 0, 0, 'j' },
+	{ "nooutput", 0, 0, 'n' },
+	{ "pretty", 0, 0, 'p' },
 	{ "reset", 0, 0, 'r' },
 	{ "noupdate", 0, 0, 's' },
-	{ "pretty", 0, 0, 'p' },
 	{ "interval", 1, 0, 't' },
 	{ "version", 0, 0, 'V' },
 	{ "zeros", 0, 0, 'z' },
@@ -585,7 +588,7 @@ int main(int argc, char *argv[])
 	int ch;
 	int fd;
 
-	while ((ch = getopt_long(argc, argv, "h?vVzrnasd:t:jp",
+	while ((ch = getopt_long(argc, argv, "h?vVzrnasd:t:jpi",
 				 longopts, NULL)) != EOF) {
 		switch (ch) {
 		case 'z':
@@ -619,6 +622,9 @@ int main(int argc, char *argv[])
 		case 'p':
 			pretty = 1;
 			break;
+		case 'i':
+			nocase = 1;
+			break;
 		case 'v':
 		case 'V':
 			printf("nstat utility, iproute2-ss%s\n", SNAPSHOT);
-- 
2.26.2

