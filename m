Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82BA919E665
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 18:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgDDQQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 12:16:28 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:52708 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgDDQQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 12:16:28 -0400
Received: by mail-wm1-f47.google.com with SMTP id t203so1822708wmt.2
        for <netdev@vger.kernel.org>; Sat, 04 Apr 2020 09:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YjiBNyKgfLHiKSO6d+c0hBMZBKWqIYLBDHPl0PufnuQ=;
        b=y0sOPaN2aaHoKiP1SqrADEJwmEudrjYF1P3fLrk1kToi81sHTgSEQdjm5aUm0TlqWA
         A6QKL/d0cBPXvvj40IifKIA7BqwWEnDsJVxNdJ124qSIhyDKC9JGcIPTl24iPoVc/jor
         selN/WkXt2zD+Hbd9xZIAMI/kAyJ+haShXVGN2Rfkzq39BoPWCYAvUwgNTUQkzYd9Ywn
         Bd8rHXNL9rSHN3B5GGDXuHqU7Y8+cOCTa0uq5uoOCuu0uLzxQ7rnh8QdQI0yVZb7RUhK
         I06GbA0JZbB0wNe3Psyjy8loIj5wEB21KB5txRg/UDe5j6YWs6e/6jwi/CJ/NtYIb9n3
         wpEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YjiBNyKgfLHiKSO6d+c0hBMZBKWqIYLBDHPl0PufnuQ=;
        b=fkIfXOr61vClihftBeFNsCBYcs8Vti8ZWY3cu0Mo5SmYhO6MlM83EAli9+6kW6zTy/
         J3ObKpnEh8oPPDGBduV9DIcNfraN39JhfjLGF6pHBu/NBr0qMoMBA7pZB70YC8ujJTxy
         1JO4tTEnhXP/6EcfrobQxiO4qMa1bFjxi+GWzQYRgsitJQiDtf4Nbacx88XwR7NCAmt3
         fJuaaf6KRJaLivCoYJbAvqfnAlh33icdfCbdg0PKjzhpZU9a+oYB1LVXg/e/8bHBGg+3
         ZT/jcBGQm8NyofrC9EAgtAK9bn6mHDzbqBqseCBMQ+E9qAM4GpqsNKH/RILUQBrKw9Hw
         Etog==
X-Gm-Message-State: AGi0PuZdMf9Ohv/q5Klng/8z2p8JeXH+8t0qu7uBTJe0MA+jaA/IlqUR
        6EROPr+7voiv2ROGPr3Q+i6LhH/AjAE=
X-Google-Smtp-Source: APiQypK/JO0Hzdzt9lPXKK3jTY2+/+ym4kwXIypX/lbvMGVsjXm2qMZTqyA7XoNPMKpJLwWe+VDK8A==
X-Received: by 2002:a7b:cb59:: with SMTP id v25mr14836628wmj.13.1586016985489;
        Sat, 04 Apr 2020 09:16:25 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b12sm3384118wmi.43.2020.04.04.09.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 09:16:25 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com
Subject: [patch iproute2/net-next 2/8] devlink: Fix help and man of "devlink health set" command
Date:   Sat,  4 Apr 2020 18:16:15 +0200
Message-Id: <20200404161621.3452-3-jiri@resnulli.us>
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

Fix the help and man page of "devlink health set" command to be aligned
with the rest of helps and man pages.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c         |  4 +++-
 man/man8/devlink-health.8 | 30 ++++++++++++++++--------------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 0109d30cba41..559b6cec2fae 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -6901,7 +6901,9 @@ static void cmd_health_help(void)
 	pr_err("       devlink health diagnose DEV reporter REPORTER_NAME\n");
 	pr_err("       devlink health dump show DEV reporter REPORTER_NAME\n");
 	pr_err("       devlink health dump clear DEV reporter REPORTER_NAME\n");
-	pr_err("       devlink health set DEV reporter REPORTER_NAME { grace_period | auto_recover } { msec | boolean }\n");
+	pr_err("       devlink health set DEV reporter REPORTER_NAME\n");
+	pr_err("                          [ grace_period MSEC ]\n");
+	pr_err("                          [ auto_recover { true | false } ]\n");
 }
 
 static int cmd_health(struct dl *dl)
diff --git a/man/man8/devlink-health.8 b/man/man8/devlink-health.8
index 7ed0ae4534dc..70a86cf0acdc 100644
--- a/man/man8/devlink-health.8
+++ b/man/man8/devlink-health.8
@@ -52,13 +52,13 @@ devlink-health \- devlink health reporting and recovery
 .RI "" DEV ""
 .B reporter
 .RI "" REPORTER ""
-.RI " { "
-.B grace_period | auto_recover
-.RI " } { "
-.RI "" msec ""
-.RI "|"
-.RI "" boolean ""
-.RI " } "
+.RI "[ "
+.BI "grace_period " MSEC "
+.RI "]"
+.RI "[ "
+.BR auto_recover " { " true " | " false " } "
+.RI "]"
+
 .ti -8
 .B devlink health help
 
@@ -130,15 +130,9 @@ the next "devlink health dump show" command.
 .I "REPORTER"
 - specifies the reporter's name registered on the devlink device.
 
-.SS devlink health set - Enable the user to configure:
-.PD 0
-1) grace_period [msec] - Time interval between consecutive auto recoveries.
-.P
-2) auto_recover [true/false] - Indicates whether the devlink should execute automatic recover on error.
-.P
+.SS devlink health set - Configure health reporter.
 Please note that this command is not supported on a reporter which
 doesn't support a recovery method.
-.PD
 
 .PP
 .I "DEV"
@@ -148,6 +142,14 @@ doesn't support a recovery method.
 .I "REPORTER"
 - specifies the reporter's name registered on the devlink device.
 
+.TP
+.BI grace_period " MSEC "
+Time interval between consecutive auto recoveries.
+
+.TP
+.BR auto_recover " { " true " | " false " } "
+Indicates whether the devlink should execute automatic recover on error.
+
 .SH "EXAMPLES"
 .PP
 devlink health show
-- 
2.21.1

