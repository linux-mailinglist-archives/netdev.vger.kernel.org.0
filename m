Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B122A56173E
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbiF3KGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234781AbiF3KGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:06:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B68244A05;
        Thu, 30 Jun 2022 03:06:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 036C5621B9;
        Thu, 30 Jun 2022 10:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DCCC34115;
        Thu, 30 Jun 2022 10:05:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ACkRU+Ds"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656583556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lpetoj7kI9rRA+ZeAoTE77fi6zOrRL2bKq1/FPJ526c=;
        b=ACkRU+DstmTaTG/qZ0irEBLPkULFIDpmiMuCN9oQNUCoD/n8pqTayt4kE4T3q3fKiM6hfE
        1kdRZnJIBzQ8fCYp9BJHZ7IO5rxsJ5v1LZ3Q18QgIcZRPREkUJDOIDkZj3Lq1fTNRQTDM3
        0klFcqdwCZnEM1ZY8LMAJrzSICKkUiQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2d14dac7 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 30 Jun 2022 10:05:55 +0000 (UTC)
Date:   Thu, 30 Jun 2022 12:05:50 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Kalesh Singh <kaleshsingh@google.com>
Cc:     John Stultz <jstultz@google.com>, Christoph Hellwig <hch@lst.de>,
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
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH] remove CONFIG_ANDROID
Message-ID: <Yr11fp13yMRiEphS@zx2c4.com>
References: <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
 <YryNQvWGVwCjJYmB@zx2c4.com>
 <Yryic4YG9X2/DJiX@google.com>
 <Yry6XvOGge2xKx/n@zx2c4.com>
 <CAC_TJve_Jk0+XD7VeSJVvJq4D9ZofnH69B4QZv2LPT4X3KNfeg@mail.gmail.com>
 <YrzaCRl9rwy9DgOC@zx2c4.com>
 <CANDhNCpRzzULaGmEGCbbJgVinA0pJJB-gOP9AY0Hy488n9ZStA@mail.gmail.com>
 <YrztOqBBll66C2/n@zx2c4.com>
 <YrzujZuJyfymC0LP@zx2c4.com>
 <CAC_TJvcNOx1C5csdkMCAPVmX4gLcRWkxKO8Vm=isgjgM-MowwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAC_TJvcNOx1C5csdkMCAPVmX4gLcRWkxKO8Vm=isgjgM-MowwA@mail.gmail.com>
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

On Wed, Jun 29, 2022 at 09:25:32PM -0700, Kalesh Singh wrote:
> On Wed, Jun 29, 2022 at 5:30 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > Hey again,
> >
> > On Thu, Jun 30, 2022 at 2:24 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > 1) Introduce a simple CONFIG_PM_CONTINUOUS_AUTOSLEEPING Kconfig thing
> > >    with lots of discouraging help text.
> > >
> > > 2) Go with the /sys/power tunable and bikeshed the naming of that a bit
> > >    to get it to something that reflects this better, and document it as
> > >    being undesirable except for Android phones.
> >
> > One other quick thought, which I had mentioned earlier to Kalesh:
> >
> > 3) Make the semantics a process holding open a file descriptor, rather
> >    than writing 0/1 into a file. It'd be called /sys/power/
> >    userspace_autosleep_ctrl, or something, and it'd enable this behavior
> >    while it's opened. And maybe down the line somebody will want to add
> >    ioctls to it for a different purpose. This way it's less of a tunable
> >    and more of an indication that there's a userspace app doing/controlling
> >    something.
> >
> > This idea (3) may be a lot of added complexity for basically nothing,
> > but it might fit the usage semantics concerns a bit better than (2). But
> > anyway, just an idea. Any one of those three are fine with me.
> 
> Two concerns John raised:
>   1) Adding new ABI we need to maintain
>   2) Having unclear config options
> 
> Another idea, I think, is to add the Kconfig option as
> CONFIG_SUSPEND_SKIP_RNG_RESEED? Similar to existing
> CONFIG_SUSPEND_SKIP_SYNC and I think it would address those concerns.

I mentioned in my reply to him that this doesn't really work for me:

| As a general rule, I don't expose knobs like that in wireguard /itself/,
| but wireguard has no problem with adapting to whatever machine properties
| it finds itself on. And besides, this *is* a very definite device
| property, something really particular and peculiar about the machine
| the kernel is running on. It's a concrete thing that the kernel should
| know about. So let's go with your "very clear description idea", above,
| instead.

IOW, we're not going to add a tunable on every possible place this is
used.

Anyway if you don't want a runtime switch, make a compiletime switch
called CONFIG_PM_CONTINUOUS_RAPID_AUTOSLEEPING or whatever, write some
very discouraging help text, and call it a day. And this way you don't
have to worry about ABI and we can change this later on and do the whole
thing as a no-big-deal change that somebody can tweak later without
issue.

The below diff is some boiler plate to help you get started with that
direction. Similar order of operations for this one:

1. You write a patch for Android's base config to enable this option and
   post it on Gerrit.

2. You take the diff below, clean it up or bikeshed the naming a bit or
   do whatever there, and submit it to the kernel, including as a `Link:
   ...` this thread and the Gerrit link.

3. When the patch lands, you submit the Gerrit CL.

4. When both have landed, Christoph moves forward with his
   CONFIG_ANDROID removal.

So really, just pick an option here -- the runtime switch or the
compiletime switch or the crazy fd thing I mentioned -- and run with it.

Jason

diff --git a/drivers/char/random.c b/drivers/char/random.c
index e3dd1dd3dd22..5332236cb1ad 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -756,7 +756,7 @@ static int random_pm_notification(struct notifier_block *nb, unsigned long actio

 	if (crng_ready() && (action == PM_RESTORE_PREPARE ||
 	    (action == PM_POST_SUSPEND &&
-	     !IS_ENABLED(CONFIG_PM_AUTOSLEEP) && !IS_ENABLED(CONFIG_ANDROID)))) {
+	     !IS_ENABLED(CONFIG_PM_AUTOSLEEP) && !IS_ENABLED(CONFIG_PM_RAPID_USERSPACE_AUTOSLEEP)))) {
 		crng_reseed();
 		pr_notice("crng reseeded on system resumption\n");
 	}
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index aa9a7a5970fd..b93171f2e6c9 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -69,7 +69,7 @@ static int wg_pm_notification(struct notifier_block *nb, unsigned long action, v
 	 * its normal operation rather than as a somewhat rare event, then we
 	 * don't actually want to clear keys.
 	 */
-	if (IS_ENABLED(CONFIG_PM_AUTOSLEEP) || IS_ENABLED(CONFIG_ANDROID))
+	if (IS_ENABLED(CONFIG_PM_AUTOSLEEP) || IS_ENABLED(CONFIG_PM_RAPID_USERSPACE_AUTOSLEEP))
 		return 0;

 	if (action != PM_HIBERNATION_PREPARE && action != PM_SUSPEND_PREPARE)
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index a12779650f15..bcbfbeb39d4f 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -150,6 +150,25 @@ config PM_WAKELOCKS
 	Allow user space to create, activate and deactivate wakeup source
 	objects with the help of a sysfs-based interface.

+config PM_RAPID_USERSPACE_AUTOSLEEP
+	bool "Tune for rapid and consistent userspace calls to sleep"
+	depends on PM_SLEEP
+	help
+	Change the behavior of various sleep-sensitive code to deal with
+	userspace autosuspend daemons that put the machine to sleep and wake it
+	up extremely often and for short periods of time.
+
+	This option mostly disables code paths that most users really should
+	keep enabled. In particular, only enable this if:
+
+	- It is very common to be asleep for only 2 seconds before being woken;	and
+	- It is very common to be awake for only 2 seconds before sleeping.
+
+	This likely only applies to Android devices, and not other machines.
+	Therefore, you should say N here, unless you're extremely certain that
+	this is what you want. The option otherwise has bad, undesirable
+	effects, and should not be enabled just for fun.
+
 config PM_WAKELOCKS_LIMIT
 	int "Maximum number of user space wakeup sources (0 = no limit)"
 	range 0 100000

