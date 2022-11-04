Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2336761A275
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 21:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiKDUmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 16:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiKDUmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 16:42:04 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6B543AEC;
        Fri,  4 Nov 2022 13:42:02 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-12c8312131fso6790901fac.4;
        Fri, 04 Nov 2022 13:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LPWTHAu4vAKpdYGymfUO7xJHpj+KFNZBd9yee/lAZWg=;
        b=lOkZpKJZGrRdTwW1q1n3PYtNavkFYrwxfV2GFvR6YWuaVKwLPk4VJ5U5ZDx0nuSETe
         4J0qx8jESJCo6y+3k5I/RIDeXo7Y6jSgRRXz2DJFkzXiePACdAOetFhkjtL5bcgp83ac
         L9LEH/9+5kOlP36xHlU1S0A9pTTFCmy4MsC6KZRblm7eTmGH17TdH1F+e+pVpfC6YibP
         OD0bbJB9hlpboqehpl8hGHOw6SotGw7ZzxTK+J5+Bkycl7auUJR59DVXhb+Lm2qdFRIM
         WNNsyFThpDNs5XVQPsJWiyibl8FySITsqyv8EbD5o54HP3A3J+dpKDkJeIuzl/+kIUVP
         0S2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LPWTHAu4vAKpdYGymfUO7xJHpj+KFNZBd9yee/lAZWg=;
        b=k8TZLleNO/RKRCtExwQTIXLgppnsGarZ/66nDXoIdzYrsYV09cf1y+aSNTCTZTLhub
         hdBhTynrSqeG3EpCcWtZLtxeVzK98qyCxa6OWeuQo5TNMxcisDKpBPAHRQYBdnG81I8+
         r4FRQm2tkJY6ANPcV0yvpiKE60LePF8526tVauQ1IKmF5AGhvWv5uDWHgYt6qPUhbcEE
         6psSVCEzx4IIVs/S+s7pfuQvXMnD+RelU254HZk4XFDdn9g9lvxlNw6vcy7d2MJ/RfSj
         S8rTnofSca6f7ymRNCsgGfR9WwBhxGCI9RFl5BBzX3xhslqjAZKRjP41v7NnaGD1LCy0
         wkFw==
X-Gm-Message-State: ACrzQf2D06Zkg7ejgSg9IyG3eQoJjIvt1NCZkNDVUuwzSWUvqY7uOo+p
        kGVrD0kJIEbVpJC9WbsZgAlpD3mASHo=
X-Google-Smtp-Source: AMsMyM4YoEr7WxXxO25Opwv5nzrxjGmv3HfOq/bk78IdaTMObaueZEnFddqxBoG0u+KT3n0Hv+LaGQ==
X-Received: by 2002:a05:6870:9597:b0:13a:f95a:2bc1 with SMTP id k23-20020a056870959700b0013af95a2bc1mr32722633oao.292.1667594521690;
        Fri, 04 Nov 2022 13:42:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a9-20020a544e09000000b00359ad661d3csm43433oiy.30.2022.11.04.13.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 13:42:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 4 Nov 2022 13:41:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, rcu@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-edac@vger.kernel.org,
        cgroups@vger.kernel.org, linux-block@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-pm@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bluetooth@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org,
        linux-input@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-leds@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-ext4@vger.kernel.org, linux-nilfs@vger.kernel.org,
        bridge@lists.linux-foundation.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, lvs-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, alsa-devel@alsa-project.org
Subject: Re: [RFC][PATCH v3 00/33] timers: Use timer_shutdown*() before
 freeing timers
Message-ID: <20221104204159.GA506794@roeck-us.net>
References: <20221104054053.431922658@goodmis.org>
 <20221104192232.GA2520396@roeck-us.net>
 <20221104154209.21b26782@rorschach.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104154209.21b26782@rorschach.local.home>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 03:42:09PM -0400, Steven Rostedt wrote:
> On Fri, 4 Nov 2022 12:22:32 -0700
> Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > Unfortunately the renaming caused some symbol conflicts.
> > 
> > Global definition: timer_shutdown
> > 
> >   File             Line
> > 0 time.c            93 static inline void timer_shutdown(struct clock_event_device *evt)
> > 1 arm_arch_timer.c 690 static __always_inline int timer_shutdown(const int access,
> > 2 timer-fttmr010.c 105 int (*timer_shutdown)(struct clock_event_device *evt);
> > 3 timer-sp804.c    158 static inline void timer_shutdown(struct clock_event_device *evt)
> > 4 timer.h          239 static inline int timer_shutdown(struct timer_list *timer)
> 
> $ git grep '\btimer_shutdown'
> arch/arm/mach-spear/time.c:static inline void timer_shutdown(struct clock_event_device *evt)
> arch/arm/mach-spear/time.c:     timer_shutdown(evt);
> arch/arm/mach-spear/time.c:     timer_shutdown(evt);
> arch/arm/mach-spear/time.c:     timer_shutdown(evt);
> drivers/clocksource/arm_arch_timer.c:static __always_inline int timer_shutdown(const int access,
> drivers/clocksource/arm_arch_timer.c:   return timer_shutdown(ARCH_TIMER_VIRT_ACCESS, clk);
> drivers/clocksource/arm_arch_timer.c:   return timer_shutdown(ARCH_TIMER_PHYS_ACCESS, clk);
> drivers/clocksource/arm_arch_timer.c:   return timer_shutdown(ARCH_TIMER_MEM_VIRT_ACCESS, clk);
> drivers/clocksource/arm_arch_timer.c:   return timer_shutdown(ARCH_TIMER_MEM_PHYS_ACCESS, clk);
> drivers/clocksource/timer-fttmr010.c:   int (*timer_shutdown)(struct clock_event_device *evt);
> drivers/clocksource/timer-fttmr010.c:   fttmr010->timer_shutdown(evt);
> drivers/clocksource/timer-fttmr010.c:   fttmr010->timer_shutdown(evt);
> drivers/clocksource/timer-fttmr010.c:   fttmr010->timer_shutdown(evt);
> drivers/clocksource/timer-fttmr010.c:           fttmr010->timer_shutdown = ast2600_timer_shutdown;
> drivers/clocksource/timer-fttmr010.c:           fttmr010->timer_shutdown = fttmr010_timer_shutdown;
> drivers/clocksource/timer-fttmr010.c:   fttmr010->clkevt.set_state_shutdown = fttmr010->timer_shutdown;
> drivers/clocksource/timer-fttmr010.c:   fttmr010->clkevt.tick_resume = fttmr010->timer_shutdown;
> drivers/clocksource/timer-sp804.c:static inline void timer_shutdown(struct clock_event_device *evt)
> drivers/clocksource/timer-sp804.c:      timer_shutdown(evt);
> drivers/clocksource/timer-sp804.c:      timer_shutdown(evt);
> 
> Honestly, I think these need to be renamed, as "timer_shutdown()"
> should be specific to the timer code, and not individual timers.

Yes, that is what I did locally. I am repeating my test now with that
change made.

Guenter
