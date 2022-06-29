Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98112560CEE
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 01:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiF2XCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 19:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiF2XCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 19:02:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776022FC;
        Wed, 29 Jun 2022 16:02:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DFDF60C36;
        Wed, 29 Jun 2022 23:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DC6C34114;
        Wed, 29 Jun 2022 23:02:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="l+ewml9c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656543758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BnH/fZpE1CBOFeTtwvdjNDqJ/A3OCloL7Jwk1Vbb23I=;
        b=l+ewml9cTlsbWyF3eonUi0i6uZRQ8SAfZKjwxATqkYw9hwGpMJLB0kLeRTG32SJd+KLbu4
        ptJNjXXp8ugdeJCrB3KYAyVzt5L+kIWNivm32cij5HYqo77Np34SbTWi1sBQvfpMUUP8kY
        caKsVdu1WPme5YHsJdHESWhQZXZ56b4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1131b43d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 29 Jun 2022 23:02:38 +0000 (UTC)
Date:   Thu, 30 Jun 2022 01:02:33 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Kalesh Singh <kaleshsingh@google.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, rcu <rcu@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, sultan@kerneltoast.com,
        android-kernel-team <android-kernel-team@google.com>,
        John Stultz <jstultz@google.com>,
        Saravana Kannan <saravanak@google.com>, rafael@kernel.org
Subject: Re: [PATCH] remove CONFIG_ANDROID
Message-ID: <YrzaCRl9rwy9DgOC@zx2c4.com>
References: <20220629161020.GA24891@lst.de>
 <Yrx6EVHtroXeEZGp@zx2c4.com>
 <20220629161527.GA24978@lst.de>
 <Yrx8/Fyx15CTi2zq@zx2c4.com>
 <20220629163007.GA25279@lst.de>
 <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
 <YryNQvWGVwCjJYmB@zx2c4.com>
 <Yryic4YG9X2/DJiX@google.com>
 <Yry6XvOGge2xKx/n@zx2c4.com>
 <CAC_TJve_Jk0+XD7VeSJVvJq4D9ZofnH69B4QZv2LPT4X3KNfeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAC_TJve_Jk0+XD7VeSJVvJq4D9ZofnH69B4QZv2LPT4X3KNfeg@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalesh,

On Wed, Jun 29, 2022 at 03:26:33PM -0700, Kalesh Singh wrote:
> Thanks for taking a look. I'm concerned holding the sys/power/state
> open would have unintentional side effects. Adding the
> /sys/power/userspace_autosuspender seems more appropriate. We don't
> have a use case for the refcounting, so would prefer the simpler
> writing '0' / '1' to toggle semantics.

Alright. So I've cooked you up some code that you can submit, since I
assume based on Christoph's bristliness that he won't do so. The below
adds /sys/power/pm_userspace_autosleeper, which you can write a 0 or a 1
into, and fixes up wireguard and random.c to use it. The code is
untested, but should generally be the correct thing, I think.

So in order of operations:

1. You write a patch for SystemSuspend.cpp and post it on Gerrit.

2. You take the diff below, clean it up or bikeshed the naming a bit or
   do whatever there, and submit it to Rafael's PM tree, including as a
   `Link: ...` this thread and the Gerrit link.

3. When/if Rafael accepts the patch, you submit the Gerrit CL.

4. When both have landed, Christoph moves forward with his
   CONFIG_ANDROID removal.

Does that seem like a reasonable way forward?

Jason

diff --git a/drivers/char/random.c b/drivers/char/random.c
index e3dd1dd3dd22..c25e3be10d9c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -756,7 +756,7 @@ static int random_pm_notification(struct notifier_block *nb, unsigned long actio
 
 	if (crng_ready() && (action == PM_RESTORE_PREPARE ||
 	    (action == PM_POST_SUSPEND &&
-	     !IS_ENABLED(CONFIG_PM_AUTOSLEEP) && !IS_ENABLED(CONFIG_ANDROID)))) {
+	     !IS_ENABLED(CONFIG_PM_AUTOSLEEP) && !pm_userspace_autosleeper_enabled))) {
 		crng_reseed();
 		pr_notice("crng reseeded on system resumption\n");
 	}
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index aa9a7a5970fd..1983e0fadb6e 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -69,7 +69,7 @@ static int wg_pm_notification(struct notifier_block *nb, unsigned long action, v
 	 * its normal operation rather than as a somewhat rare event, then we
 	 * don't actually want to clear keys.
 	 */
-	if (IS_ENABLED(CONFIG_PM_AUTOSLEEP) || IS_ENABLED(CONFIG_ANDROID))
+	if (IS_ENABLED(CONFIG_PM_AUTOSLEEP) || pm_userspace_autosleeper_enabled)
 		return 0;
 
 	if (action != PM_HIBERNATION_PREPARE && action != PM_SUSPEND_PREPARE)
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 70f2921e2e70..0acff26f87b4 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -498,6 +498,7 @@ extern void ksys_sync_helper(void);
 /* drivers/base/power/wakeup.c */
 extern bool events_check_enabled;
 extern suspend_state_t pm_suspend_target_state;
+extern bool pm_userspace_autosleeper_enabled;
 
 extern bool pm_wakeup_pending(void);
 extern void pm_system_wakeup(void);
@@ -537,6 +538,8 @@ static inline void pm_system_irq_wakeup(unsigned int irq_number) {}
 static inline void lock_system_sleep(void) {}
 static inline void unlock_system_sleep(void) {}
 
+#define pm_userspace_autosleeper_enabled (false)
+
 #endif /* !CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_PM_SLEEP_DEBUG
diff --git a/kernel/power/main.c b/kernel/power/main.c
index e3694034b753..08f32a281010 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -120,6 +120,23 @@ static ssize_t pm_async_store(struct kobject *kobj, struct kobj_attribute *attr,
 
 power_attr(pm_async);
 
+bool pm_userspace_autosleeper_enabled;
+
+static ssize_t pm_userspace_autosleeper_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", pm_userspace_autosleeper_enabled);
+}
+
+static ssize_t pm_userspace_autosleeper_store(struct kobject *kobj,
+				    struct kobj_attribute *attr,
+				    const char *buf, size_t n)
+{
+	return kstrtobool(buf, &pm_userspace_autosleeper_enabled);
+}
+
+power_attr(pm_userspace_autosleeper);
+
 #ifdef CONFIG_SUSPEND
 static ssize_t mem_sleep_show(struct kobject *kobj, struct kobj_attribute *attr,
 			      char *buf)
@@ -869,6 +886,7 @@ static struct attribute * g[] = {
 #ifdef CONFIG_PM_SLEEP
 	&pm_async_attr.attr,
 	&wakeup_count_attr.attr,
+	&pm_userspace_autosleeper.attr,
 #ifdef CONFIG_SUSPEND
 	&mem_sleep_attr.attr,
 	&sync_on_suspend_attr.attr,

