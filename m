Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D499926B5E4
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgIOXxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727150AbgIOXxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 19:53:02 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E8CA21D7F;
        Tue, 15 Sep 2020 23:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600213981;
        bh=rI0fa3jWEPGCQ/FYbvwzEmcsFt/IgkMuG6lhrLVEHpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hdNmIEEKdaHEki7GJ/biXuFCgblo6+yyzVEnQMBQmaQAErga23jMH7UVpGoODuYmG
         K3vq3KE2RHPh81/1vc5eRvh2Xe6uSNyV91AAce8t1sRImU0HTLPtS8gIQ6ko4sPd9/
         nd3C0wmqYy/riGCbputAlpxJFQbmVl1BmxjSIf3c=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next 3/5] separate FLAGS out in -h
Date:   Tue, 15 Sep 2020 16:52:57 -0700
Message-Id: <20200915235259.457050-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915235259.457050-1-kuba@kernel.org>
References: <20200915235259.457050-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
index 23ecfcfd069c..ae5310e9e306 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5947,10 +5947,10 @@ static int show_usage(struct cmd_context *ctx __maybe_unused)
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
@@ -5959,7 +5959,10 @@ static int show_usage(struct cmd_context *ctx __maybe_unused)
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

