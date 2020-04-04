Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAC619E669
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 18:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgDDQQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 12:16:32 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46879 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgDDQQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 12:16:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id j17so12186712wru.13
        for <netdev@vger.kernel.org>; Sat, 04 Apr 2020 09:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NoqR3QYg1lQmdCWyL9woGNuc0FCwR2wbM0Q85ifDMFw=;
        b=omXe+Dri45PlbiptErmbLzs5neiexhDM7FstvqCoTvA2AcHdDDYcCE7pzgxiqqI5L0
         vBA6N7uo+9S3zqJXuGW0FB3N+CVH6d+sLP9lHFCvXvRxkrEGFmBqrA6/SatLJlGmdDBK
         WJoHTaD0+qc4uCn1Mc2gj3uZKyc7YVgxqA24QqAhPVM5cZMV6JhQIl7RWHitHSt49WbM
         V0GJDebdbmF5O534n+Tzn5fO9ayDOB9mAr7/tui6397Wmg0LoKR3pstyaTiNSzsw49Br
         ASWzkfZPJVmIApyRX6A2u9prAl5vYp+32lc39kpYvcHGUzwXDOQN43Fl/M3E0Y72l8aQ
         tL3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NoqR3QYg1lQmdCWyL9woGNuc0FCwR2wbM0Q85ifDMFw=;
        b=PPn/4R6LsAaGMnvs6nTWpszFdbB479/f+Vg6BsPSUe/cvx00cCuFdLxIsawcPKYnnE
         UkEppdPvMGN0CY+N36BB1RrZ1ZY0Nlk9BSNnRRUKtlO0wbGbayhWuWRSPy4LrJvAfaXw
         EqYQ72wV8N7PHJIB8u3P/PMuLHTml7CJ5WU9DXghZpNKDddOBe3Quho7SeDSPzabCwtp
         ksWY67JIJVtYbuUMEywb7PDVyQk05M/NpotvX8tOQB5bcWrQgBtg5Tjiz8G+KfncB9JY
         M9NaowK+1Cfz7TBIxHIqJgCaSMDfMG6aqBNrnqavmb2dAT8hGXhwvfcF44c7n+RfIalm
         2X8A==
X-Gm-Message-State: AGi0Pua6k/sggjK8k4pr0YwjsiZuWIGEiDkMzv51DSPGbibyYK+MzypZ
        h4uTxry4XPJVKpGN9+q3ApRVZ6lQ3iw=
X-Google-Smtp-Source: APiQypKO6LG/LhUq6fz3NwYgkl4ybOI3quvd11TX+7vvaabjj6DPRtlA0tA7fDg0s2Nhkvr9Ajg00w==
X-Received: by 2002:adf:ed4a:: with SMTP id u10mr14613672wro.399.1586016987890;
        Sat, 04 Apr 2020 09:16:27 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h2sm727966wrp.50.2020.04.04.09.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 09:16:27 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com
Subject: [patch iproute2/net-next 4/8] devlink: Add alias "counters_enabled" for "counters" option
Date:   Sat,  4 Apr 2020 18:16:17 +0200
Message-Id: <20200404161621.3452-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200404161621.3452-1-jiri@resnulli.us>
References: <20200404161621.3452-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

To be consistent with netlink attribute name and also with the
"dpipe table show" output, add "counters_enabled" for "counters" in
"dpipe table set" command.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 79a1c3829c31..d40991d52cf6 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1345,7 +1345,8 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_DPIPE_TABLE_NAME;
-		} else if (dl_argv_match(dl, "counters") &&
+		} else if ((dl_argv_match(dl, "counters") ||
+			    dl_argv_match(dl, "counters_enabled")) &&
 			   (o_all & DL_OPT_DPIPE_TABLE_COUNTERS)) {
 			dl_arg_inc(dl);
 			err = dl_argv_bool(dl, &opts->dpipe_counters_enable);
-- 
2.21.1

