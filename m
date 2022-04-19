Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7040B50764C
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 19:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244868AbiDSRSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 13:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244899AbiDSRR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 13:17:58 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9AB2F03C
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:15:14 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id i27so34279378ejd.9
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AtjXOsHlK9eyHHkvm9QZjO06qTJJZ3Wd/uhXMxNSjLQ=;
        b=WtrunEWglTej8VZdgqxkla1eqEadaDz0xI0/AKNfx5d158HIi5q2+afNKGmBBF80WT
         cxfEKsUlrBh3xk/0AqPudv2veVZs7T8DOPnkaYbfizndS0ZNa6YzkcmxnmWsPjdRqzMs
         u42ll784Gr4lwNprj7lX817Yx0pC9hi/VbwpCRGp+Whd5bAC8CwQePxGXeA/jFNVcyWT
         85Oy3b8DecyvM6yImpSU6et3gEFX4XBhWepJ8Wnq6iEWsu2s5eOJhiZDvbreRhyE48FY
         BwCeqJpu2nTsFPLSAFERCbh5l4mU8qUDKa79ijKHEywjutYa5eMki+eEAYYUxDVe0SX2
         BOpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AtjXOsHlK9eyHHkvm9QZjO06qTJJZ3Wd/uhXMxNSjLQ=;
        b=ueD7Ek/lyJSz+LX/Ma2m/Va3DLYHklTwNAy4JytmGGRJyE8rYgXepHvoNQJFXX3Uzj
         pMMuSAuYR5l/AodnrZPmNGfbcVIvA57QJNqZyHXlpzHZMirBJSmD5szMZXV1haAWvR55
         Mpx4+6eJWdpV6/UzdwDxNUBxLd9DjXCWBccwbtVKb0YGr1pGzws4V1IczdKVGagvkDqR
         No6cNvhjgdvJC3yp6RskY3q6GPIFoCRaXsVlfqa0vZKOCKA61La6SfA26ZvdIR1lc7zd
         cPD+SDUDRqYlr10kRVraUp5dyRZ0h2sVMqS0JEabZLLrKdf891/p6n50qxEmdOAsvEku
         VL1w==
X-Gm-Message-State: AOAM532IMQK93BlY+oUVA5l3GtS4/R7HavQ7BYSn1z+zYAOvrgkNE1/d
        j/dgEeGqHIbjS1B1Rq4vfZa0WY4xTPd4qcUsAPw=
X-Google-Smtp-Source: ABdhPJzQgGE6m5EpLLU+yLgU3S1In2DXps7613asuJRZ8bHRW3aPNGYgYBBuBF0fd4OFYbj3o2wzjA==
X-Received: by 2002:a17:906:7304:b0:6da:9243:865 with SMTP id di4-20020a170906730400b006da92430865mr14272724ejc.665.1650388513377;
        Tue, 19 Apr 2022 10:15:13 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id h9-20020aa7c949000000b0041b4d8ae50csm8594054edt.34.2022.04.19.10.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 10:15:12 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com
Subject: [patch iproute2-main] devlink: fix "devlink health dump" command without arg
Date:   Tue, 19 Apr 2022 19:15:11 +0200
Message-Id: <20220419171511.1147781-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Fix bug when user calls "devlink health dump" without "show" or "clear":
$ devlink health dump
Command "(null)" not found

Put the dump command into a separate helper as it is usual in the rest
of the code. Also, treat no cmd as "show", as it is common for other
devlink objects.

Fixes: 041e6e651a8e ("devlink: Add devlink health dump show command")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index da9f97788bcf..aab739f7f437 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -8526,6 +8526,23 @@ static void cmd_health_help(void)
 	pr_err("                          [ auto_dump    { true | false } ]\n");
 }
 
+static int cmd_health_dump(struct dl *dl)
+{
+	if (dl_argv_match(dl, "help")) {
+		cmd_health_help();
+		return 0;
+	} else if (dl_argv_match(dl, "show") ||
+		   dl_argv_match(dl, "list") || dl_no_arg(dl)) {
+		dl_arg_inc(dl);
+		return cmd_health_dump_show(dl);
+	} else if (dl_argv_match(dl, "clear")) {
+		dl_arg_inc(dl);
+		return cmd_health_dump_clear(dl);
+	}
+	pr_err("Command \"%s\" not found\n", dl_argv(dl));
+	return -ENOENT;
+}
+
 static int cmd_health(struct dl *dl)
 {
 	if (dl_argv_match(dl, "help")) {
@@ -8546,13 +8563,7 @@ static int cmd_health(struct dl *dl)
 		return cmd_health_test(dl);
 	} else if (dl_argv_match(dl, "dump")) {
 		dl_arg_inc(dl);
-		if (dl_argv_match(dl, "show")) {
-			dl_arg_inc(dl);
-			return cmd_health_dump_show(dl);
-		} else if (dl_argv_match(dl, "clear")) {
-			dl_arg_inc(dl);
-			return cmd_health_dump_clear(dl);
-		}
+		return cmd_health_dump(dl);
 	} else if (dl_argv_match(dl, "set")) {
 		dl_arg_inc(dl);
 		return cmd_health_set_params(dl);
-- 
2.35.1

