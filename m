Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538C8284E97
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 17:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgJFPEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 11:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgJFPEd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 11:04:33 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51D5D2078E;
        Tue,  6 Oct 2020 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601996672;
        bh=7jZD/GtUD3QHyHulr4ysB0ecL1g3/Rs1Jq5fu1SCE4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xuxg3fdF/c0uUMoNV1iZ4qLJtLCQGLGa5+6TyyZD6OwsHdIKUTqlogz+audPgWHl8
         zNOrewObKlQZYEk4FqO/uLCOBTZcSn6lVM4Sce7rmrRwosDm6TgKMpG7WVRGgrlaJR
         H34XaPAFQVnOixMPaXpiu2Xz0ieV2QklYBU+31V8=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next v2 3/6] separate FLAGS out in -h
Date:   Tue,  6 Oct 2020 08:04:22 -0700
Message-Id: <20201006150425.2631432-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201006150425.2631432-1-kuba@kernel.org>
References: <20201006150425.2631432-1-kuba@kernel.org>
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

