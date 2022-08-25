Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6665A1A94
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241961AbiHYUvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241549AbiHYUvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:51:21 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7553AAE215;
        Thu, 25 Aug 2022 13:51:20 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-11d2dcc31dbso18342909fac.7;
        Thu, 25 Aug 2022 13:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=epCHlROSXyJ4Cq6Z6MvNiSbnRgepy11g4mcIN7dnFpQ=;
        b=UYN9K5bkL6liIaUx27zpPW8bdiRvVeal/y4WmsXLpfmsF3f6jOtLE3h32V2BrCb+Pg
         Thd0AmKfQs87wD53p+Rtn60syjgLZb1K+dHiad3edxfHtfkALW1UlYMEetulLR3yj+WJ
         O6pSPRi9BUkFI75OqghR8sGvIhTnBXx+iVLp2pJQlIeNZt5Ic5Zb1jwNAhKdyS4/sy3J
         V+B6w9huzzyPwLSI0aKlWz04+4y6OO5oJHPrf1TrRc43wkQLv3X2Upw0dIEOj5dvJ3sF
         eV+W8IihZkSZDaqEtKtYoqJ0yHYCkmDPLqw4ZJ88HpNkj0MagGH07vmnV/eINiS8Qlm2
         FoCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=epCHlROSXyJ4Cq6Z6MvNiSbnRgepy11g4mcIN7dnFpQ=;
        b=R10uH802OXEFxAs3Mh9ajcLCOiO8zhVbAEt+F+49lmJYQDqlSy2YfNynY5dRkGm1PA
         PrG9XQ5+y/l2A1/x2eZ3+0nVB3TnFUPwgxdaEGoe7tF6tmTDb+sS2Llw4vr/vyMFFu6Z
         WLK5xEnV+apz5gr0w3a5/LVu3ZKezEna4I4smmXC/Wypz/B4u46J152I1vDx8fZBzLEM
         rXlqWg5WDaixqjHhUXCQpK1Q2er7Yz83Dw41M1Xn21Y1NlZ9v//iFL6o7kMtagsBK3br
         ILe/3YVztOS5CtC42l5nuopUblzY10XVKLBYrgR+dkvx0AlRILYkOpMMG4yxpLb6FEL6
         X2oA==
X-Gm-Message-State: ACgBeo29Ld0qlTrRecI/8ikgMRBf6Hz5Fe6U6vXLiHuLUpf18oRhIe+p
        JreUGsNvBv1RN3cTckTvPBo=
X-Google-Smtp-Source: AA6agR61zI8Sp8HfZRh3j14UVsml6LygU5b916fiywt/4sIQoBP4gUzqb4QH5U6z3YJWi11Zr7IkqA==
X-Received: by 2002:a05:6870:249c:b0:10c:7f4d:71ab with SMTP id s28-20020a056870249c00b0010c7f4d71abmr383455oaq.15.1661460679591;
        Thu, 25 Aug 2022 13:51:19 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id 66-20020a9d0bc8000000b0061c1a0b4677sm70853oth.12.2022.08.25.13.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 13:51:19 -0700 (PDT)
Date:   Thu, 25 Aug 2022 13:49:06 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sander Vanheule <sander@svanheule.net>
Subject: Re: [PATCH v3 1/9] cpumask: Make cpumask_full() check for nr_cpu_ids
 bits
Message-ID: <YwfgQmtbr6IrPrXb@yury-laptop>
References: <20220825181210.284283-1-vschneid@redhat.com>
 <20220825181210.284283-2-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825181210.284283-2-vschneid@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Sander Vanheule

On Thu, Aug 25, 2022 at 07:12:02PM +0100, Valentin Schneider wrote:
> Consider a system with 4 CPUs and:
>   CONFIG_NR_CPUS=64
>   CONFIG_CPUMASK_OFFSTACK=n
> 
> In this situation, we have:
>   nr_cpumask_bits == NR_CPUS == 64
>   nr_cpu_ids = 4
> 
> Per smp.c::setup_nr_cpu_ids(), nr_cpu_ids <= NR_CPUS, so we want
> cpumask_full() to check for nr_cpu_ids bits set.
> 
> This issue is currently pointed out by the cpumask KUnit tests:
> 
>   [   14.072028]     # test_cpumask_weight: EXPECTATION FAILED at lib/test_cpumask.c:57
>   [   14.072028]     Expected cpumask_full(((const struct cpumask *)&__cpu_possible_mask)) to be true, but is false
>   [   14.079333]     not ok 1 - test_cpumask_weight
> 
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>

It's really a puzzle, and some of my thoughts are below. So. 

This is a question what for we need nr_cpumask_bits while we already
have nr_cpu_ids. When OFFSTACK is ON, they are obviously the same.
When it's of - the nr_cpumask_bits is an alias to NR_CPUS.

I tried to wire the nr_cpumask_bits to nr_cpu_ids unconditionally, and
it works even when OFFSTACK is OFF, no surprises.

I didn't find any discussions describing what for we need nr_cpumask_bits,
and the code adding it dates to a very long ago.

If I alias nr_cpumask_bits to nr_cpu_ids unconditionally on my VM with
NR_CPUs == 256 and nr_cpu_ids == 4, there's obviously a clear win in
performance, but the Image size gets 2.5K bigger. Probably that's the
reason for what nr_cpumask_bits was needed...

There's also a very old misleading comment in cpumask.h:

 *  If HOTPLUG is enabled, then cpu_possible_mask is forced to have
 *  all NR_CPUS bits set, otherwise it is just the set of CPUs that
 *  ACPI reports present at boot.

It lies, and I checked with x86_64 that cpu_possible_mask is populated
during boot time with 0b1111, if I create a 4-cpu VM. Hence, the
nr_cpu_ids is 4, while NR_CPUS == 256.

Interestingly, there's no a single user of the cpumask_full(),
obviously, because it's broken. This is really a broken dead code.

Now that we have a test that checks sanity of cpumasks, this mess
popped up.

Your fix doesn't look correct, because it fixes one function, and
doesn't touch others. For example, the cpumask subset() may fail
if src1p will have set bits after nr_cpu_ids, while cpumask_full()
will be returning true.

In -next, there is an update from Sander for the cpumask test that
removes this check, and probably if you rebase on top of -next, you
can drop this and 2nd patch of your series.

What about proper fix? I think that a long time ago we didn't have
ACPI tables for possible cpus, and didn't populate cpumask_possible
from that, so the

        #define nr_cpumask_bits NR_CPUS

worked well. Now that we have cpumask_possible partially filled,
we have to always

        #define nr_cpumask_bits nr_cpu_ids

and pay +2.5K price in size even if OFFSTACK is OFF. At least, it wins
at runtime...

Any thoughts?

---
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 5e2b10fb4975..0f044d93ad01 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -41,13 +41,7 @@ typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
 extern unsigned int nr_cpu_ids;
 #endif
 
-#ifdef CONFIG_CPUMASK_OFFSTACK
-/* Assuming NR_CPUS is huge, a runtime limit is more efficient.  Also,
- * not all bits may be allocated. */
 #define nr_cpumask_bits	nr_cpu_ids
-#else
-#define nr_cpumask_bits	((unsigned int)NR_CPUS)
-#endif
 
 /*
  * The following particular system cpumasks and operations manage
@@ -67,10 +61,6 @@ extern unsigned int nr_cpu_ids;
  *  cpu_online_mask is the dynamic subset of cpu_present_mask,
  *  indicating those CPUs available for scheduling.
  *
- *  If HOTPLUG is enabled, then cpu_possible_mask is forced to have
- *  all NR_CPUS bits set, otherwise it is just the set of CPUs that
- *  ACPI reports present at boot.
- *
  *  If HOTPLUG is enabled, then cpu_present_mask varies dynamically,
  *  depending on what ACPI reports as currently plugged in, otherwise
  *  cpu_present_mask is just a copy of cpu_possible_mask.
