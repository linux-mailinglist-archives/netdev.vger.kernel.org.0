Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51623365410
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 10:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhDTI13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 04:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhDTI1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 04:27:24 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DE9C061763
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 01:26:52 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id 20so15321173pll.7
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 01:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5zq9B3EYDFbItsI1htl3pZImVcLMnN3rRtR9X5rN4LI=;
        b=vRu9X+N8oA/eu/Tk966J1e8B8dAbIeLQdA0IGmAcbGr4L3qTc40QpHsyIaAKakbG1d
         RcWLtaUyxtporCkeXZpG0ecrzX9p7tn9XV/lc+lErCsid0h5IO66fKk48OLOsd80CKie
         ImCFMfirVDdc0hbNiyCPZpbxmXlVAYyNyr89mrOHWmbSm+Iyh3eaU89WId1zn6Mua8Bb
         XYp/Cqy4ZoDoHJSygNp0VH+KyqvA7Uj9mYR7TXMZTmHYL/xiLFMXo+9eDTIdyppgDxok
         GjTVbV5TQZXlH9Fb9MIuePnnxJ25VxVyRvi8ySwFU22OAT4XsKzNTZ8tBbJCuOM4rdwG
         g2Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5zq9B3EYDFbItsI1htl3pZImVcLMnN3rRtR9X5rN4LI=;
        b=js9RNKnvapRz3dcq2BMHUjIEkpv2ILdcFELU49TVzc3koqe8mV/ymt+qF8NB3pP/n6
         inEffRwowSSKK503WgsviSokfLJ53LnU9oV2hQskmOmWH/llwoALRiJC0zvGIvX2FkIT
         MQplb97dtfyDIorspBteSedl245p988K2UIRco0M0mtB+d82bekgclPrYuCa2L6o5Zrb
         d1UWkgfY5lO9hv9Nx2eY0xl1hfcr150fvNaUVrNiCfD6ne1n3jO93TZwq0pYgXUmNsCz
         neqDoqC/plIE0qMBwfc0DbYEU/ZPJ8X6M80+0ozbXl296gAnmhZ2K2nKY8W3Cc0ZfGEZ
         pIfA==
X-Gm-Message-State: AOAM5314QSsym30L09SkempVXzlt3F6KOXrtucbfPS5sMC4dXYY2NUF5
        0/TRBwQgpbnt/kCEHYSNkLzZjbIghC3ePQ==
X-Google-Smtp-Source: ABdhPJzv//oPqJFks491W79fzUGsdVLbJ/kgoNg8wrAgx9IfycZrGL5IPL2QyCfPosJxJjSbF0bZ5g==
X-Received: by 2002:a17:90a:e005:: with SMTP id u5mr3492723pjy.201.1618907211880;
        Tue, 20 Apr 2021 01:26:51 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:2558:351:ae01:f5f3])
        by smtp.gmail.com with ESMTPSA id e13sm14838232pgt.91.2021.04.20.01.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 01:26:51 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH iproute2 v2] ip: drop 2-char command assumption
Date:   Tue, 20 Apr 2021 01:26:36 -0700
Message-Id: <20210420082636.1210305-1-Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <9008a711-be95-caf7-5c56-dad5450e8f5c@gmail.com>
References: <9008a711-be95-caf7-5c56-dad5450e8f5c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'ip' utility hardcodes the assumption of being a 2-char command, where
any follow-on characters are passed as an argument:

  $ ./ip-full help
  Object "-full" is unknown, try "ip help".

This confusing behaviour isn't seen with 'tc' for example, and was added in
a 2005 commit without documentation. It was noticed during testing of 'ip'
variants built/packaged with different feature sets (e.g. w/o BPF support).

Mitigate the problem by redoing the command without the 2-char assumption
if the follow-on characters fail to parse as a valid command.

Fixes: 351efcde4e62 ("Update header files to 2.6.14")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
v2: (feedback from David Ahern)
  * work around problem but remain compatible with 2-char assumption

---
 ip/ip.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/ip/ip.c b/ip/ip.c
index 4cf09fc3..8e4c6eb5 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -125,7 +125,7 @@ static const struct cmd {
 	{ 0 }
 };
 
-static int do_cmd(const char *argv0, int argc, char **argv)
+static int do_cmd(const char *argv0, int argc, char **argv, bool final)
 {
 	const struct cmd *c;
 
@@ -134,7 +134,8 @@ static int do_cmd(const char *argv0, int argc, char **argv)
 			return -(c->func(argc-1, argv+1));
 	}
 
-	fprintf(stderr, "Object \"%s\" is unknown, try \"ip help\".\n", argv0);
+	if (final)
+		fprintf(stderr, "Object \"%s\" is unknown, try \"ip help\".\n", argv0);
 	return EXIT_FAILURE;
 }
 
@@ -143,7 +144,7 @@ static int ip_batch_cmd(int argc, char *argv[], void *data)
 	const int *orig_family = data;
 
 	preferred_family = *orig_family;
-	return do_cmd(argv[0], argc, argv);
+	return do_cmd(argv[0], argc, argv, true);
 }
 
 static int batch(const char *name)
@@ -313,11 +314,14 @@ int main(int argc, char **argv)
 
 	rtnl_set_strict_dump(&rth);
 
-	if (strlen(basename) > 2)
-		return do_cmd(basename+2, argc, argv);
+	if (strlen(basename) > 2) {
+		int ret = do_cmd(basename+2, argc, argv, false);
+		if (ret != EXIT_FAILURE)
+			return ret;
+	}
 
 	if (argc > 1)
-		return do_cmd(argv[1], argc-1, argv+1);
+		return do_cmd(argv[1], argc-1, argv+1, true);
 
 	rtnl_close(&rth);
 	usage();
-- 
2.25.1

