Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5545622B5
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 21:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbiF3TMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 15:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236363AbiF3TMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 15:12:48 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1965B28E30
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 12:12:47 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id c10-20020a251c0a000000b00669b463d2e1so51993ybc.11
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 12:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ThcqTcL2EK/v16TPbcx9ACYtX+c6g+PxYAfz/JDcQGs=;
        b=UENhzz+jbEW4l84h8cZMmbOEXYbTwlSXV9VQ8f7rFL0Ztfrqrt5eiMNs9BlnxqiFU1
         kccRNaD4buDLdaXHk8Zo69mr23KsOw5ADWsI0Lf3MnR7O7pR8Jl0ZPC0/DpJc5mfr/63
         cmsnoRfEOdO9sBVUnpj4a4H8QONTMtoBbLQNfpdJ3NZlTQLV8dzxRGxWWewQdQBi4f5R
         plkwj4+Qc4EQgC+HMXYGghTW27hTCxF1JdKHS1ab8tKMcshcTnDg5FwHIB4xOHFI6lIT
         8NkGaAdeVB6UYyjsAafc0Hel3SfbBDnGNdDVbAE/eE4OGZQMdFii3kMiE22vMS7RgV+r
         Gf5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ThcqTcL2EK/v16TPbcx9ACYtX+c6g+PxYAfz/JDcQGs=;
        b=OimSNSb2VdK2kAy/zQQQyN1aor3JO6yEsHvmdm4hqTGHj3nktCj1GT4av4l0lqp6sw
         wtQL3+HsqQ8o/y2uoYMgt4WkfSO2bu5NHV2Du/0TtzXP2dEAzZJzj8DznilJ/WH5E4w5
         edmhLgNprEE62NxlgzBXviH9HGYKb6ROzZSFDkAZH3xnl9cG7S4rQsDB1eD67mh+ygD9
         Z5RvbFI4cTuq0NC34zl33t+DwxW5Lh0cRypcuqorkOM7SmgrnO7bzAdEirM+C52OvJ2j
         +/FSeCaTsMec4/u/w5yvZXUS21+RbGpvis6XtIfA7p4WDI57/wtr7Rjs9B9RQ1Y37jMy
         v5aA==
X-Gm-Message-State: AJIora9GFDeZHZAxmPZexyj9aERgjyx0VVjcXhByso94vegyK1SNnsuT
        uxlW2K/g9+4Qkm34G5S7J6TPQBk+PDMUNfIcNQ==
X-Google-Smtp-Source: AGRyM1t3Ww7PWb3WFVXoxeowZvFh7zUW/ka0FXdujSxX4keyA44O4mR1BtFfGbDknmo/m4f02C8i2nkEO9Lj5x07PQ==
X-Received: from kaleshsingh.mtv.corp.google.com ([2620:15c:211:200:5fd:1939:78ea:dfb2])
 (user=kaleshsingh job=sendgmr) by 2002:a25:9388:0:b0:66d:1fd9:6f73 with SMTP
 id a8-20020a259388000000b0066d1fd96f73mr10731114ybm.147.1656616366313; Thu,
 30 Jun 2022 12:12:46 -0700 (PDT)
Date:   Thu, 30 Jun 2022 19:12:29 +0000
Message-Id: <20220630191230.235306-1-kaleshsingh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] pm/sleep: Add PM_USERSPACE_AUTOSLEEP Kconfig
From:   Kalesh Singh <kaleshsingh@google.com>
To:     Jason@zx2c4.com, jstultz@google.com, paulmck@kernel.org,
        rostedt@goodmis.org, rafael@kernel.org, hch@infradead.org
Cc:     saravanak@google.com, tjmercier@google.com, surenb@google.com,
        kernel-team@android.com, Kalesh Singh <kaleshsingh@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Systems that initiate frequent suspend/resume from userspace
can make the kernel aware by enabling PM_USERSPACE_AUTOSLEEP
config.

This allows for certain sleep-sensitive code (wireguard/rng) to
decide on what preparatory work should be performed (or not) in
their pm_notification callbacks.

This patch was prompted by the discussion at [1] which attempts
to remove CONFIG_ANDROID that currently guards these code paths.

[1] https://lore.kernel.org/r/20220629150102.1582425-1-hch@lst.de/

Suggested-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 drivers/char/random.c          |  4 ++--
 drivers/net/wireguard/device.c |  3 ++-
 kernel/power/Kconfig           | 20 ++++++++++++++++++++
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index e3dd1dd3dd22..8c90f535d149 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -755,8 +755,8 @@ static int random_pm_notification(struct notifier_block *nb, unsigned long actio
 	spin_unlock_irqrestore(&input_pool.lock, flags);
 
 	if (crng_ready() && (action == PM_RESTORE_PREPARE ||
-	    (action == PM_POST_SUSPEND &&
-	     !IS_ENABLED(CONFIG_PM_AUTOSLEEP) && !IS_ENABLED(CONFIG_ANDROID)))) {
+	    (action == PM_POST_SUSPEND && !IS_ENABLED(CONFIG_PM_AUTOSLEEP) &&
+	     !IS_ENABLED(CONFIG_PM_USERSPACE_AUTOSLEEP)))) {
 		crng_reseed();
 		pr_notice("crng reseeded on system resumption\n");
 	}
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index aa9a7a5970fd..d58e9f818d3b 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -69,7 +69,8 @@ static int wg_pm_notification(struct notifier_block *nb, unsigned long action, v
 	 * its normal operation rather than as a somewhat rare event, then we
 	 * don't actually want to clear keys.
 	 */
-	if (IS_ENABLED(CONFIG_PM_AUTOSLEEP) || IS_ENABLED(CONFIG_ANDROID))
+	if (IS_ENABLED(CONFIG_PM_AUTOSLEEP) ||
+	    IS_ENABLED(CONFIG_PM_USERSPACE_AUTOSLEEP))
 		return 0;
 
 	if (action != PM_HIBERNATION_PREPARE && action != PM_SUSPEND_PREPARE)
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index a12779650f15..60a1d3051cc7 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -143,6 +143,26 @@ config PM_AUTOSLEEP
 	Allow the kernel to trigger a system transition into a global sleep
 	state automatically whenever there are no active wakeup sources.
 
+config PM_USERSPACE_AUTOSLEEP
+	bool "Userspace opportunistic sleep"
+	depends on PM_SLEEP
+	help
+	Notify kernel of aggressive userspace autosleep power management policy.
+
+	This option changes the behavior of various sleep-sensitive code to deal
+	with frequent userspace-initiated transitions into a global sleep state.
+
+	Saying Y here, disables code paths that most users really should keep
+	enabled. In particular, only enable this if it is very common to be
+	asleep/awake for very short periods of time (<= 2 seconds).
+
+	Only platforms, such as Android, that implement opportunistic sleep from
+	a userspace power manager service should enable this option; and not
+	other machines. Therefore, you should say N here, unless you are
+	extremely certain that this is what you want. The option otherwise has
+	bad, undesirable effects, and should not be enabled just for fun.
+
+
 config PM_WAKELOCKS
 	bool "User space wakeup sources interface"
 	depends on PM_SLEEP

base-commit: 03c765b0e3b4cb5063276b086c76f7a612856a9a
-- 
2.37.0.rc0.161.g10f37bed90-goog

