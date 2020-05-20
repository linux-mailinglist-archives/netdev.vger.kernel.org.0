Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744481DA6D9
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 03:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgETBAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 21:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgETBAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 21:00:24 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9277C061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 18:00:23 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id s10so1329605iog.7
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 18:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=mLs/n/z++VsFfH85lFX/BEIPBMSMOzlyTpaFM38CfdU=;
        b=T8Fjpr0P65UCpLMV/vkwEhv5xPnDujCCLKB70r/Z1FTNO7burX/rlfbOz0y7P9X4o4
         DfSMaESjHBG8uBliZSpnjNgL+3PsA/R3y5kCfVP8T/1SZo2G0zamnWPA9qwVkI5bZTHB
         an2fHcMTm1tUtP+2VBSF6skEsAiI3334bKYq6bt5hd5/RrLnIKBSPX0l9WYaQ6XNupJ6
         09JUhz9aHDHlSMe8Spt8mzA6xI5VlyPJH2nDzNMlo9AwriwnicHzB09+jTnboUDx9Zr4
         2qH0+u8nhqRFRssopRZ6lnVfQjb1n7fu/RDrJ0jBv8GqaQ+ki8MPmuy39xDnwuOyPDfv
         YkOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mLs/n/z++VsFfH85lFX/BEIPBMSMOzlyTpaFM38CfdU=;
        b=cLD3J5d1ru2gORcnpt7S40xNexZoRQ2HMR0RBuMwJOI5Us38ZhLCIrUuamhY4vH/P4
         aO/0ECqV3PUQMMr35uetz6IUjti99WtcVIJ7tH03ksnuPL+5NvQ0MmhSq6sS2GahMcb/
         i3DpUsv8RXNx0Xh/vl3Xo21+DY6kBkZzAaIfaA6KYKoeTipmrYtHP5LxX1nqrUj06E80
         FsghOpSlo1T42Ln5G/D32gM7BiioEx3TIFnoAaaJ1BLc8h6OmAA+Dl+9jVNml5wMhaMN
         /jje3xFute0Tms+eOJHOFGOv35PjAAvfE4pCfKX5inDOKytzyoFaDlove05LY5pUiEkp
         d+Wg==
X-Gm-Message-State: AOAM530Y2rNNbl1wHu8pmqTbdN/sme7eFI7oz+1KyNhSzEsIR8al8Ib8
        6GlkQy6VEUot50W5Nd+Jd3ErZA==
X-Google-Smtp-Source: ABdhPJycpJQcImXjllyWVBG+t311YnExktTcH6FDyKkFZ6uFj4oSyYFOgvOVmlHK0IbfBjItpXmbCw==
X-Received: by 2002:a6b:3b94:: with SMTP id i142mr1609653ioa.76.1589936423149;
        Tue, 19 May 2020 18:00:23 -0700 (PDT)
Received: from mojatatu.com ([74.127.203.199])
        by smtp.gmail.com with ESMTPSA id f10sm494194ilj.85.2020.05.19.18.00.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 May 2020 18:00:22 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     stephen@networkplumber.org
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, kernel@mojatatu.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH iproute2 v2 1/1] tc: action: fix time values output in JSON format
Date:   Tue, 19 May 2020 20:59:44 -0400
Message-Id: <1589936384-29378-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report tcf_t values in seconds, not jiffies, in JSON format as it is now
for stdout.

v2: use PRINT_ANY, drop the useless casts and fix the style (Stephen Hemminger)

Fixes: 2704bd625583 ("tc: jsonify actions core")
Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 tc/tc_util.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 12f865cc71bf..fd5fcb242b64 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -750,21 +750,17 @@ void print_tm(FILE *f, const struct tcf_t *tm)
 {
 	int hz = get_user_hz();
 
-	if (tm->install != 0) {
-		print_uint(PRINT_JSON, "installed", NULL, tm->install);
-		print_uint(PRINT_FP, NULL, " installed %u sec",
-			   (unsigned int)(tm->install/hz));
-	}
-	if (tm->lastuse != 0) {
-		print_uint(PRINT_JSON, "last_used", NULL, tm->lastuse);
-		print_uint(PRINT_FP, NULL, " used %u sec",
-			   (unsigned int)(tm->lastuse/hz));
-	}
-	if (tm->expires != 0) {
-		print_uint(PRINT_JSON, "expires", NULL, tm->expires);
-		print_uint(PRINT_FP, NULL, " expires %u sec",
-			   (unsigned int)(tm->expires/hz));
-	}
+	if (tm->install != 0)
+		print_uint(PRINT_ANY, "installed", " installed %u sec",
+			   tm->install / hz);
+
+	if (tm->lastuse != 0)
+		print_uint(PRINT_ANY, "last_used", " used %u sec",
+			   tm->lastuse / hz);
+
+	if (tm->expires != 0)
+		print_uint(PRINT_ANY, "expires", " expires %u sec",
+			   tm->expires / hz);
 }
 
 static void print_tcstats_basic_hw(struct rtattr **tbs, char *prefix)
-- 
2.7.4

