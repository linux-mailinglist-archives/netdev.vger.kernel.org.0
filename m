Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEEA292029
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 23:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgJRVcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 17:32:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728067AbgJRVcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 17:32:00 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6F4C222C4;
        Sun, 18 Oct 2020 21:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603056720;
        bh=7jZD/GtUD3QHyHulr4ysB0ecL1g3/Rs1Jq5fu1SCE4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbRy3H6/e/LVXz81X8LzkgdSK7zzsQVM6gdTT27O817hwJ+Z3iY8+t352KV/3/e45
         SzctHeRtI4sPoRuiS4de40P6VDWT6/gDw/8xwRXkLWVP8Ozmq7uBcC+Z3XOBR97hD6
         YAXya7+eSxQosOTRV7I2JFED1pIYlR6FlPRT5n3c=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool v3 3/7] separate FLAGS out in -h
Date:   Sun, 18 Oct 2020 14:31:47 -0700
Message-Id: <20201018213151.3450437-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201018213151.3450437-1-kuba@kernel.org>
References: <20201018213151.3450437-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Help output is quite crowded already with every command
being prefixed by --debug and --json options, and we're
about to add a third one.

Add an indirection.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 ethtool.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 2a7de97c51bb..403616bb7fa0 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6015,10 +6015,10 @@ static int show_usage(struct cmd_context *ctx __maybe_unused)
 	fprintf(stdout, PACKAGE " version " VERSION "\n");
 	fprintf(stdout,
 		"Usage:\n"
-		"        ethtool [ --debug MASK ][ --json ] DEVNAME\t"
+		"        ethtool [ FLAGS ] DEVNAME\t"
 		"Display standard information about device\n");
 	for (i = 0; args[i].opts; i++) {
-		fputs("        ethtool [ --debug MASK ][ --json ] ", stdout);
+		fputs("        ethtool [ FLAGS ] ", stdout);
 		fprintf(stdout, "%s %s\t%s\n",
 			args[i].opts,
 			args[i].no_dev ? "\t" : "DEVNAME",
@@ -6027,7 +6027,10 @@ static int show_usage(struct cmd_context *ctx __maybe_unused)
 			fputs(args[i].xhelp, stdout);
 	}
 	nl_monitor_usage();
-	fprintf(stdout, "Not all options support JSON output\n");
+	fprintf(stdout, "\n");
+	fprintf(stdout, "FLAGS:\n");
+	fprintf(stdout, "	--debug MASK	turn on debugging messages\n");
+	fprintf(stdout, "	--json		enable JSON output format (not supported by all commands)\n");
 
 	return 0;
 }
-- 
2.26.2

