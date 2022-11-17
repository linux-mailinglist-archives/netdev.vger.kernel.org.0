Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E5362DD9A
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 15:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239969AbiKQOKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 09:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234880AbiKQOKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 09:10:44 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE8263BB0;
        Thu, 17 Nov 2022 06:10:43 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id j12so1720670plj.5;
        Thu, 17 Nov 2022 06:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZjZfNJSztqnn5VEU7B/rhp6hd5F3Z1vSOdOLkmK7kWc=;
        b=mx+QNYoZMiT/SjOoNhLkfdEZuoTwwQozSQlq6C8ykIrmH12/fVqX3z5m6Iv+Uqg9bF
         F3EHUhNaKmhpbaeeY4fu97h+uQu/Q6wVoRLdnd4A260Sf5oVKLKrupHZ5lwyuDfP1rVC
         5miFNUggU9Y4rg5DkCMhY+gkbCeCwH5iqJmBzn9rdXTubljFQOCA4fLHB7f/og812zsb
         OTPiRW6nVAS7k8/YzGQgustfkrz4VLskgdlh4c1UTLA92JMK1it2GbGafIYQ2K3e8WRG
         9V3xg9qVOJ07TAFwhq9GCMGGpNrE1ozpCkYE0+npJkUh5nxkhYB/LbI5M81y4XTq7rbV
         Psxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZjZfNJSztqnn5VEU7B/rhp6hd5F3Z1vSOdOLkmK7kWc=;
        b=oZ7Oe8FHuPDui8z6mBFIawl38c4vVR3pcmgAYYdJqjFXXJPhWVw/cARV95v/1pdCRp
         qc0V5tZ2e7bccIx7hPMD+xd3s2jReblE3/GF29M+0xTXjjJPWYr9ryckhOYyQZTjYg80
         9ldzCHU0N5DKLrl5cx+dMGMtxgHXQlCLjatF/rDVkPF8tuB1D+3AH8/a/sKcj04fXr6a
         o7gnurxyVHc+u1BglhmRelAJAc+EJ3AUTI9gIE3IdNe+uEpKdfPpvhpC8qSq6lN/X1+E
         qmiPGun39KaQoP6kOMhz721OYdV0VdhZ7LXLh3LNvI+AIhGtpGmK9G2v/ED42T1757Iz
         ZGXQ==
X-Gm-Message-State: ANoB5pnwDr/9MlVT7GRVyINZz/nTPrL7FGqBe1On70+KfKsLIO56bZvE
        +r4cLwVKgWwFKw+buxI8A0NGL+6JyEU=
X-Google-Smtp-Source: AA0mqf7vlYFqatgtTtPWPlx7rqXLJkIUXYwiAeEmzJlutKAlXYc1etM5WQohWEXRUCwP7wGG03zsuw==
X-Received: by 2002:a17:903:234d:b0:187:3d00:7ca4 with SMTP id c13-20020a170903234d00b001873d007ca4mr2910482plh.135.1668694242256;
        Thu, 17 Nov 2022 06:10:42 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k38-20020a635a66000000b0046ece12f042sm1032729pgm.15.2022.11.17.06.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 06:10:41 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 17 Nov 2022 06:10:39 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [patch 00/15] timers: Provide timer_shutdown[_sync]()
Message-ID: <20221117141039.GA664755@roeck-us.net>
References: <20221115195802.415956561@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115195802.415956561@linutronix.de>
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

On Tue, Nov 15, 2022 at 09:28:32PM +0100, Thomas Gleixner wrote:
> Tearing down timers can be tedious when there are circular dependencies to
> other things which need to be torn down. A prime example is timer and
> workqueue where the timer schedules work and the work arms the timer.
> 
> Steven and the Google Chromebook team ran into such an issue in the
> Bluetooth HCI code.
> 
> Steven suggested to create a new function del_timer_free() which marks the
> timer as shutdown. Rearm attempts of shutdown timers are discarded and he
> wanted to emit a warning for that case:
> 
>    https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home
> 
> This resulted in a lengthy discussion and suggestions how this should be
> implemented. The patch series went through several iterations and during
> the review of the last version it turned out that this approach is
> suboptimal:
> 
>    https://lore.kernel.org/all/20221110064101.429013735@goodmis.org
> 
> The warning is not really helpful because it's entirely unclear how it
> should be acted upon. The only way to address such a case is to add 'if
> (in_shutdown)' conditionals all over the place. This is error prone and in
> most cases of teardown like the HCI one which started this discussion not
> required all.
> 
> What needs to prevented is that pending work which is drained via
> destroy_workqueue() does not rearm the previously shutdown timer. Nothing
> in that shutdown sequence relies on the timer being functional.
> 
> The conclusion was that the semantics of timer_shutdown_sync() should be:
> 
>     - timer is not enqueued
>     - timer callback is not running
>     - timer cannot be rearmed
> 
> Preventing the rearming of shutdown timers is done by discarding rearm
> attempts silently.
> 
> As Steven is short of cycles, I made some spare cycles available and
> reworked the patch series to follow the new semantics and plugged the races
> which were discovered during review.
> 
> The patches have been split up into small pieces to make review easier and
> I took the liberty to throw a bunch of overdue cleanups into the picture
> instead of proliferating the existing state further.
> 
> The last patch in the series addresses the HCI teardown issue for real.
> 

I applied the series to the top of v6.1-rc5, and also applied the result of
running the coccinelle script to auto-convert simple cases. Running this
set of patches through my testbed showed no build errors, runtime
failures, or warnings. I also backported the series to chromeos-5.15,
again applied the coccinelle generated patches, and ran it through a
regression test. No failures either.

With that, for the series,

Tested-by: Guenter Roeck <linux@roeck-us.net>

Let me know if I should send individual tags for each patch in the series.

Thanks,
Guenter
