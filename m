Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2758C1D8024
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 19:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgERR3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 13:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgERR3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 13:29:51 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A59C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 10:29:50 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id v4so8788638qte.3
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 10:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=yDRkuXITvwbZsLP121Qgr9+BCBh5t6FBBOLxutHPm1M=;
        b=fUO47CGQCzu0JRAJjRhzBu4XcsAsZ6PaOV3zT+/rY7reE41Icx1PSu1wOf28PO/Gok
         S90PYoSx7sY0omIopomKhd8vhZ63NxKduTZezxZtg1uWHhTkx4edDJT6vO7BzeExC5p9
         ZfZtWK2scRND3V7XEjH/vIdktGuCwtaOTQxo2YsolV64rUKjGltykuqcuTDP8OC8yYbq
         YsFo6Vzz4do4lFQdzxYQwluq+IQeo2XuDgez7DDGiuXW6BIW4IMEuaBA7dtjpHdhsJ4l
         KLIncWc9FOZfwIULaBFG1K0R2+f2m/Fge6Hs0bXREEACu+O9NYX8AmYfFry+edBQ3kk1
         lXlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yDRkuXITvwbZsLP121Qgr9+BCBh5t6FBBOLxutHPm1M=;
        b=lGA7scC9mO4aR0XFex6b3ubwLjMmAgogXl5e93tEfxfZDk4UzGCBxEJEkSqs3wVgZb
         gaLpHXtJA9zOMB0L4cpp/4bqgTJ+QAHFqUCraCOCjYwBdP5iKaXiD2NunXjmhoLJ/Swe
         aN3zpZC+zJrbK/aZjFYXUZs1/r6rUVwRpO/PAnfY1gpArDmHSiCLwbWaQ516WMnGA5UM
         GUFpM149xEjdziZQ5tfXKr06VpnB0pfb2n40fQruNH7GIf0KvUFh2DCH30+/AShaXW27
         mZf4HBQiXSaW911ScyxOvPFz9kKcYdKbEX5TSZuHibLv0yIfSZWshxdERJlzwc1akT/X
         d7/Q==
X-Gm-Message-State: AOAM531kjHyZ+UysByhoAqAgvFmIczSJqnljADoWBKhHfyZ9wk4mvY2S
        vwYh/Y56JCxg5Lov/YZqCXkh6BhU1OaWgQ==
X-Google-Smtp-Source: ABdhPJwGJ29oLUWaaP8Ik7E5FAf0h5vBeD2jeqPRzQAlf8OX8Iu/eoAagylSWSPlRzGsbSZTH5r3Pg==
X-Received: by 2002:ac8:7587:: with SMTP id s7mr16927129qtq.116.1589822990166;
        Mon, 18 May 2020 10:29:50 -0700 (PDT)
Received: from mojatatu.com ([74.127.203.199])
        by smtp.gmail.com with ESMTPSA id g19sm7450806qke.32.2020.05.18.10.29.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 10:29:49 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     stephen@networkplumber.org
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, kernel@mojatatu.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH iproute2 1/1] tc: action: fix time values output in JSON format
Date:   Mon, 18 May 2020 13:29:18 -0400
Message-Id: <1589822958-30545-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report tcf_t values in seconds, not jiffies, in JSON format as it is now
for stdout.

Fixes: 2704bd625583 ("tc: jsonify actions core")
Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 tc/tc_util.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 12f865cc71bf..118e19da35bb 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -751,17 +751,20 @@ void print_tm(FILE *f, const struct tcf_t *tm)
 	int hz = get_user_hz();
 
 	if (tm->install != 0) {
-		print_uint(PRINT_JSON, "installed", NULL, tm->install);
+		print_uint(PRINT_JSON, "installed", NULL,
+			   (unsigned int)(tm->install/hz));
 		print_uint(PRINT_FP, NULL, " installed %u sec",
 			   (unsigned int)(tm->install/hz));
 	}
 	if (tm->lastuse != 0) {
-		print_uint(PRINT_JSON, "last_used", NULL, tm->lastuse);
+		print_uint(PRINT_JSON, "last_used", NULL,
+			   (unsigned int)(tm->lastuse/hz));
 		print_uint(PRINT_FP, NULL, " used %u sec",
 			   (unsigned int)(tm->lastuse/hz));
 	}
 	if (tm->expires != 0) {
-		print_uint(PRINT_JSON, "expires", NULL, tm->expires);
+		print_uint(PRINT_JSON, "expires", NULL,
+			   (unsigned int)(tm->expires/hz));
 		print_uint(PRINT_FP, NULL, " expires %u sec",
 			   (unsigned int)(tm->expires/hz));
 	}
-- 
2.7.4

