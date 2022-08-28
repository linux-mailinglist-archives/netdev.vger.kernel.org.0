Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176C25A3E93
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 18:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiH1Qik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 12:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiH1Qij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 12:38:39 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A814A15834;
        Sun, 28 Aug 2022 09:38:37 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id r6so4666104qtx.6;
        Sun, 28 Aug 2022 09:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=83ChJE1rwggeSlg3O8D/w8h+7IVdbhRf3ERXz2m/uGE=;
        b=a90vgfAVsfKU1PPJ8Koo3NtBBCEetOXihdgRvz4VAZoeiwfcq2Zqc38CXgjEWZd25g
         rWlW521LPQC/RgvpZ6fmg2PCDmXs4An1B8n5pvltQJ6JbUAU9Hx9uDbSafPFMye5AscJ
         6YpLaJSOosSFXfjTP5wsBxFOLbIdSB5piK3oqAvCaDRr2zjctL/6AiVsaPItuoc7VoBS
         QDjCmiUAgROsbvpBKzrjazRKN9M5+LC/bnYkjEGRDEg94tGtM/V/Zrqx9V/rXbaa2cJT
         JIIWGan57uzVs/safzElFiLtRB5oc6gbeb7I2rfEOfdmdtUpoN7xos58tqV2yT1gTfoy
         HLrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=83ChJE1rwggeSlg3O8D/w8h+7IVdbhRf3ERXz2m/uGE=;
        b=tlNFLjguKzarpLcWP4bDKWv4P20O7RzGOT7ktCS6ZV/G0vAZr7+XelCgjZn3Y6fXB5
         rs+qWv9O+8BYN73pDyNirWlbvsZLhBX9RN+qG3m3fIfjqGCdbV3ETJi1GVU4Wyv+zw0H
         vChUJKMNg+AZdsR60Q3dQ5cfc+yNnda9+IWnetRp1no4ih0/JAGBjKIoKy369NuWCrHv
         FZasmGLfGCn2Y6ThhJlBLzoRplLDTMNFo/sfr0STrXy57Y58PDVaH21qDpDFJgVsr0+F
         8qfpbMchGnkiWvWSCIk9WM/SSn8eIL8q5fIngw3L4iXNvD1T3kSiV0/BdzInmW0uWTDW
         kZxw==
X-Gm-Message-State: ACgBeo0RRubS2wf+iG05ZXSU4XA4Wr8Up+QXXAIcyHM5OzyZh/zUObG4
        ubFFYG0cYrLVGSyNYve1PAX5csb1bfA=
X-Google-Smtp-Source: AA6agR49AKTcTgsipzL7o18hMvL2Alb7HxkjUhsc8ocxSyjKwePS7SBErZ38TtvAxDErBjX3J1AKDw==
X-Received: by 2002:ac8:7f53:0:b0:343:652:ce62 with SMTP id g19-20020ac87f53000000b003430652ce62mr7016196qtk.514.1661704716616;
        Sun, 28 Aug 2022 09:38:36 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:fec3:5d7c:26ba:6691])
        by smtp.gmail.com with ESMTPSA id s10-20020ac8758a000000b0033fc75c3469sm3652718qtq.27.2022.08.28.09.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 09:38:36 -0700 (PDT)
Date:   Sun, 28 Aug 2022 09:38:35 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Sander Vanheule <sander@svanheule.net>
Cc:     Valentin Schneider <vschneid@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
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
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v3 1/9] cpumask: Make cpumask_full() check for nr_cpu_ids
 bits
Message-ID: <YwuaCxd+0yHA+bxk@yury-laptop>
References: <20220825181210.284283-1-vschneid@redhat.com>
 <20220825181210.284283-2-vschneid@redhat.com>
 <YwfgQmtbr6IrPrXb@yury-laptop>
 <15255a7223fe405808bcedb5ab19bf2108637e08.camel@svanheule.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15255a7223fe405808bcedb5ab19bf2108637e08.camel@svanheule.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 28, 2022 at 10:35:38AM +0200, Sander Vanheule wrote:

 ...

> > It's really a puzzle, and some of my thoughts are below. So. 
> > 
> > This is a question what for we need nr_cpumask_bits while we already
> > have nr_cpu_ids. When OFFSTACK is ON, they are obviously the same.
> > When it's of - the nr_cpumask_bits is an alias to NR_CPUS.
> > 
> > I tried to wire the nr_cpumask_bits to nr_cpu_ids unconditionally, and
> > it works even when OFFSTACK is OFF, no surprises.
> > 
> > I didn't find any discussions describing what for we need nr_cpumask_bits,
> > and the code adding it dates to a very long ago.
> > 
> > If I alias nr_cpumask_bits to nr_cpu_ids unconditionally on my VM with
> > NR_CPUs == 256 and nr_cpu_ids == 4, there's obviously a clear win in
> > performance, but the Image size gets 2.5K bigger. Probably that's the
> > reason for what nr_cpumask_bits was needed...
> 
> I think it makes sense to have a compile-time-constant value for nr_cpumask_bits
> in some cases. For example on embedded platforms, where every opportunity to
> save a few kB should be used, or cases where NR_CPUS <= BITS_PER_LONG.
> 
> > 
> > There's also a very old misleading comment in cpumask.h:
> > 
> >  *  If HOTPLUG is enabled, then cpu_possible_mask is forced to have
> >  *  all NR_CPUS bits set, otherwise it is just the set of CPUs that
> >  *  ACPI reports present at boot.
> > 
> > It lies, and I checked with x86_64 that cpu_possible_mask is populated
> > during boot time with 0b1111, if I create a 4-cpu VM. Hence, the
> > nr_cpu_ids is 4, while NR_CPUS == 256.
> > 
> > Interestingly, there's no a single user of the cpumask_full(),
> > obviously, because it's broken. This is really a broken dead code.
> > 
> > Now that we have a test that checks sanity of cpumasks, this mess
> > popped up.
> > 
> > Your fix doesn't look correct, because it fixes one function, and
> > doesn't touch others. For example, the cpumask subset() may fail
> > if src1p will have set bits after nr_cpu_ids, while cpumask_full()
> > will be returning true.
> 
> It appears the documentation for cpumask_full() is also incorrect, because it
> claims to check if all CPUs < nr_cpu_ids are set. Meanwhile, the implementation
> checks if all CPUs < nr_cpumask_bits are set.
> 
> cpumask_weight() has a similar issue, and maybe also other cpumask_*() functions
> (I didn't check in detail yet).
> 
> > 
> > In -next, there is an update from Sander for the cpumask test that
> > removes this check, and probably if you rebase on top of -next, you
> > can drop this and 2nd patch of your series.
> > 
> > What about proper fix? I think that a long time ago we didn't have
> > ACPI tables for possible cpus, and didn't populate cpumask_possible
> > from that, so the
> > 
> >         #define nr_cpumask_bits NR_CPUS
> > 
> > worked well. Now that we have cpumask_possible partially filled,
> > we have to always
> > 
> >         #define nr_cpumask_bits nr_cpu_ids
> > 
> > and pay +2.5K price in size even if OFFSTACK is OFF. At least, it wins
> > at runtime...
> > 
> > Any thoughts?
> 
> It looks like both nr_cpumask_bits and nr_cpu_ids are used in a number of places
> outside of lib/cpumask.c. Documentation for cpumask_*() functions almost always
> refers to nr_cpu_ids as a highest valid value.
> 
> Perhaps nr_cpumask_bits should become an variable for internal cpumask usage,
> and external users should only use nr_cpu_ids? The changes in 6.0 are my first
> real interaction with cpumask, so it's possible that there are things I'm
> missing here.
> 
> That being said, some of the cpumask tests compare results to nr_cpumask_bits,
> so those should then probably be fixed to compare against nr_cpu_ids instead.

Aha, and it kills me how we have such a mess in a very core subsystem.

We have 3 problems here:
 - mess with nr_cpumask_bits and nr_cpu_ids;
 - ineffectiveness of cpumask routines when nr_cpumask_bits > nr_cpu_ids;
 - runtime nature of nr_cpu_ids, even for those embedded systems with
   taught memory constraints. So that if we just drop nr_cpumask_bits,
   it will add 2.5K to the Image.

I think that dropping nr_cpumask_bits is our only choice, and to avoid
Image bloating for embedded users, we can hint the kernel that NR_CPUS
is an exact number, so that it will skip setting it in runtime.

I added a EXACT_NR_CPUS option for this, which works like this:

  #if (NR_CPUS == 1) || defined(CONFIG_EXACT_NR_CPUS)
  #define nr_cpu_ids      ((unsigned int)NR_CPUS)
  #else
  extern unsigned int nr_cpu_ids;
  #endif

  /* Deprecated */ 
  #define nr_cpumask_bits nr_cpu_ids

I tried it with arm64 4-CPU build. When the EXACT_NR_CPUS is enabled,
the difference is:
  add/remove: 3/4 grow/shrink: 46/729 up/down: 652/-46952 (-46300)
  Total: Before=25670945, After=25624645, chg -0.18%

Looks quite impressive to me. I'll send a patch soon.

Thanks,
Yury
