Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3286656873
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 09:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiL0Idb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 03:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiL0Id3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 03:33:29 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5572A6470
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 00:33:27 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso16686975pjt.0
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 00:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cJHx4NOHvRf/XIDu7SdTGqUE9RfpKHxNuq88IOpL9o8=;
        b=IdLGQ3GzzdJk4fE1sZJKE4/QPqdoSDGQ1+hAdNsamwouqh7fVA59ni08NkUDEZlq3K
         fWqeFXBQDh9lHLfXNvWuJs04thU9MR96xQJALtJzNuNMPz+VkqKKExJhl6xY2ZQML76z
         XU7MzOLDeekm9aIZ7QNU397kw6T+4cN55vbxw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cJHx4NOHvRf/XIDu7SdTGqUE9RfpKHxNuq88IOpL9o8=;
        b=FfWGpnQoxSS+4XrUEUrA4SnlzxsUOHw0brgmmzEfXg2HVXQQkXPtJwGdzkL1zN8TT1
         YrdicZb2s5fhW77gtJp3u7QF3ZlF6i0yrYGwEImCAkQ0egRon1sEZAbw85RBwYDqa0m0
         xisP0sq3xcgH+tmv2zv/hYjv/7vGocKdAW6GcaK53OVoyVGO96nbxQcKcLDMKVFcqYkT
         GgFofx+rkFebv8eDIt7pE8Vy+zflIYWD1Yj+yTUiNsPJbbpIVtmjRT4QQZQ7QjP0aVj6
         fmMI7lIY+4xC+i49AnYgD7lrdumyKSlSO6xuFhHqLmWq2yvEgGWls/z6k5gw4GT2dHd3
         I67A==
X-Gm-Message-State: AFqh2kr8ujGOyiaJoeC32AgeyAdos2cdLr2yiEDDUvSXgJFcrIeeqREy
        IukV62s4qljeovFn9k69wslCng==
X-Google-Smtp-Source: AMrXdXs92rQ4Z5gPuVFRgc9X51B9sxIz8j3YWugvgnJ0VTzF7HfdnSt89k/fR9jLBMy36kCY8Nfdog==
X-Received: by 2002:a17:903:134c:b0:189:e909:32e3 with SMTP id jl12-20020a170903134c00b00189e90932e3mr24805166plb.40.1672130006606;
        Tue, 27 Dec 2022 00:33:26 -0800 (PST)
Received: from 82a1e6c4c19b (lma3293270.lnk.telstra.net. [60.231.90.117])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b00189988a1a9esm8493363ple.135.2022.12.27.00.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 00:33:25 -0800 (PST)
Date:   Tue, 27 Dec 2022 08:33:17 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 0/4] net/sched: retpoline wrappers for tc
Message-ID: <20221227083317.GA1025927@82a1e6c4c19b>
References: <20221206135513.1904815-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206135513.1904815-1-pctammela@mojatatu.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pedro,

Compiling kernel 6.2-rc1 fails on x86_64 when CONFIG_NET_CLS or
CONFIG_NET_CLS_ACT is not set, when CONFIG_RETPOLINE=y is set.

Does tc_wrapper RETPOLINE need a dependency on NET_CLS/NET_CLS_ACT
to be added? Or a default?

net/sched/sch_api.c: In function 'pktsched_init':
net/sched/sch_api.c:2306:9: error: implicit declaration of function
'tc_wrapper_init' [-Werror=implicit-function-declaration]
 2306 |         tc_wrapper_init();
      |         ^~~~~~~~~~~~~~~
cc1: some warnings being treated as errors
make[3]: *** [scripts/Makefile.build:252: net/sched/sch_api.o] Error 1
make[2]: *** [scripts/Makefile.build:504: net/sched] Error 2
make[1]: *** [scripts/Makefile.build:504: net] Error 2

below is the relevent lines from the .config file.

$ grep -e RETPOLINE -e NET_CLS projects/Generic/linux/linux.x86_64.conf 
CONFIG_RETPOLINE=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_CLS_BPF is not set
# CONFIG_NET_CLS_FLOWER is not set
# CONFIG_NET_CLS_MATCHALL is not set
# CONFIG_NET_CLS_ACT is not set

On Tue, Dec 06, 2022 at 10:55:09AM -0300, Pedro Tammela wrote:
> In tc all qdics, classifiers and actions can be compiled as modules.
> This results today in indirect calls in all transitions in the tc hierarchy.
> Due to CONFIG_RETPOLINE, CPUs with mitigations=on might pay an extra cost on
> indirect calls. For newer Intel cpus with IBRS the extra cost is
> nonexistent, but AMD Zen cpus and older x86 cpus still go through the
> retpoline thunk.
> 
> Known built-in symbols can be optimized into direct calls, thus
> avoiding the retpoline thunk. So far, tc has not been leveraging this
> build information and leaving out a performance optimization for some
> CPUs. In this series we wire up 'tcf_classify()' and 'tcf_action_exec()'
> with direct calls when known modules are compiled as built-in as an
> opt-in optimization.
> 
> We measured these changes in one AMD Zen 4 cpu (Retpoline), one AMD Zen 3 cpu (Retpoline),
> one Intel 10th Gen CPU (IBRS), one Intel 3rd Gen cpu (Retpoline) and one
> Intel Xeon CPU (IBRS) using pktgen with 64b udp packets. Our test setup is a
> dummy device with clsact and matchall in a kernel compiled with every
> tc module as built-in.  We observed a 3-8% speed up on the retpoline CPUs,
> when going through 1 tc filter, and a 60-100% speed up when going through 100 filters.
> For the IBRS cpus we observed a 1-2% degradation in both scenarios, we believe
> the extra branches check introduced a small overhead therefore we added
> a static key that bypasses the wrapper on kernels not using the retpoline mitigation,
> but compiled with CONFIG_RETPOLINE.

...
