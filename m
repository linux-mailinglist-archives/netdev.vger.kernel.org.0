Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83DD1EE70D
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 16:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgFDO4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 10:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729107AbgFDO4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 10:56:43 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABC5C08C5C4
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 07:56:43 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 185so3540537pgb.10
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 07:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B0VRWP1UqHBzaSQ/0VAH8ROzdZmpnLpk8DQEvJRbm6g=;
        b=S90pbrXYQvAWuisADwIVqFJze1Gn3O7VI3b7ci34HlxsFIiSm55Agl3HtXdIfOtlj1
         kFuWBlQoujZfnla0pnjl4P9hL71UlfgA047f6CDtcKWtqp78Vi3ktMNpDFcArsvn0Aa4
         7gBNWjkF+L6ja8DfU5D6aFyeEosVd+IcgieMM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B0VRWP1UqHBzaSQ/0VAH8ROzdZmpnLpk8DQEvJRbm6g=;
        b=Qd6LuZg8AuBtsbAnDVms87J3hyFmBx/g+6+7rIZayjtfWUs1eND6z5+nhjnm9/8ec7
         zcHSRVhUJYXztcVep1dsdRPnzRMZELm4r0rmGdiC0X4by9RB/JHKZuSwgeckbih9eBEe
         721yMc+PwbXXP2df+2GGtGZRkh8ZTqW56HjBOUTbmmtFWp72olUY27XdFi9mCketEBji
         sGDeTJW3rzG7Q30s4EE/4d8YGm/VSXgrqwX8JCT7VHJpD/PSzCDjYuMH6bgEt0xBTjfq
         RY5V5hRRaNTmt5UeY6nUetnu8kDhUfS0tevtL4whlarCui1lCsX3URZxzgqrZY3Y4GNi
         SDGA==
X-Gm-Message-State: AOAM533a9u11ZR4cEUfxyhDQoG0etX2lpR+wtYeWqRCkWW3T6RhKFiKf
        xGlIeOD9HWpxQhqSoeojnFMLcA==
X-Google-Smtp-Source: ABdhPJwHMeBMoXoJ1oKRiY6CcT/MXQQ3/6BvMK96dAo5+DFFc+3InZktMIE/4pit2W9doT6CJHJfvw==
X-Received: by 2002:a63:de18:: with SMTP id f24mr4660948pgg.415.1591282602661;
        Thu, 04 Jun 2020 07:56:42 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y10sm4390985pgi.54.2020.06.04.07.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 07:56:41 -0700 (PDT)
Date:   Thu, 4 Jun 2020 07:56:40 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-spi@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH 01/10] x86/mm/numa: Remove uninitialized_var() usage
Message-ID: <202006040745.525ECD1@keescook>
References: <20200603233203.1695403-2-keescook@chromium.org>
 <874krr8dps.fsf@nanos.tec.linutronix.de>
 <CANiq72kLqvriYmMkdD3yU+xJwbn-68Eiu-fTNtC+Lb+1ZRM75g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72kLqvriYmMkdD3yU+xJwbn-68Eiu-fTNtC+Lb+1ZRM75g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 01:41:07PM +0200, Miguel Ojeda wrote:
> On Thu, Jun 4, 2020 at 9:58 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > but if we ever lose the 1 then the above will silently compile the code
> > within the IS_ENABLED() section out.
> 
> Yeah, I believe `IS_ENABLED()` is only meant for Kconfig symbols, not
> macro defs in general. A better option would be `__is_defined()` which
> works for defined-to-nothing too.

Er? That's not what it looked like to me:

#define IS_BUILTIN(option) __is_defined(option)
#define IS_ENABLED(option) __or(IS_BUILTIN(option), IS_MODULE(option))

But just to be sure, I just tested in with a real build:

[    3.242160] IS_ENABLED(TEST_UNDEF) false
[    3.242691] __is_defined(TEST_UNDEF) false
[    3.243240] IS_ENABLED(TEST_VALUE_EMPTY) false
[    3.243794] __is_defined(TEST_VALUE_EMPTY) false
[    3.244353] IS_ENABLED(TEST_VALUE_1) true
[    3.244848] __is_defined(TEST_VALUE_1) true

and nope, it only works with a defined value present.

diff --git a/init/main.c b/init/main.c
index 03371976d387..378a9e54b6dc 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1406,6 +1406,34 @@ static int __ref kernel_init(void *unused)
 	 */
 	pti_finalize();
 
+#undef TEST_UNDEF
+	if (IS_ENABLED(TEST_UNDEF))
+		pr_info("IS_ENABLED(TEST_UNDEF) true\n");
+	else
+		pr_info("IS_ENABLED(TEST_UNDEF) false\n");
+	if (__is_defined(TEST_UNDEF))
+		pr_info("__is_defined(TEST_UNDEF) true\n");
+	else
+		pr_info("__is_defined(TEST_UNDEF) false\n");
+#define TEST_VALUE_EMPTY
+	if (IS_ENABLED(TEST_VALUE_EMPTY))
+		pr_info("IS_ENABLED(TEST_VALUE_EMPTY) true\n");
+	else
+		pr_info("IS_ENABLED(TEST_VALUE_EMPTY) false\n");
+	if (__is_defined(TEST_VALUE_EMPTY))
+		pr_info("__is_defined(TEST_VALUE_EMPTY) true\n");
+	else
+		pr_info("__is_defined(TEST_VALUE_EMPTY) false\n");
+#define TEST_VALUE_1 1
+	if (IS_ENABLED(TEST_VALUE_1))
+		pr_info("IS_ENABLED(TEST_VALUE_1) true\n");
+	else
+		pr_info("IS_ENABLED(TEST_VALUE_1) false\n");
+	if (__is_defined(TEST_VALUE_1))
+		pr_info("__is_defined(TEST_VALUE_1) true\n");
+	else
+		pr_info("__is_defined(TEST_VALUE_1) false\n");
+
 	system_state = SYSTEM_RUNNING;
 	numa_default_policy();
 

which means a few other __is_defined() users are not correct too...

-- 
Kees Cook
