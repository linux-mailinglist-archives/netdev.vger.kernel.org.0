Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C714EBF6C
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 13:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245699AbiC3LDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 07:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245697AbiC3LC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 07:02:57 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85F413EA2;
        Wed, 30 Mar 2022 04:01:12 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bi12so40799490ejb.3;
        Wed, 30 Mar 2022 04:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t5Mlhdl3kPEuQvLJzk9wkE0jtE88f7EwpDApTMzPN+w=;
        b=cBtdMyztePZtLMnu7cT21Wd/Q4Y9FcolVPjq4byNSP6OLiOWYOl47w4/St3uPGvRnz
         rd9K67me6yXjd4ln83Wk68em39K9tgXhp5/Pv7HJWX51AZHKLAt+cS9fEHIu4iBmoQvX
         OJAcwV7RjPLKCG7yl0Sl8MMs0Yc/uapYxl/gvC83Oa0Nni+rsX2XbwwKDVhT0BjfDerX
         lCGNvSoYuDq43uRSVdUTaUpgYowhlaNdbUWdWB1vazos2iymmqt0UulfG0+SsfKZtVb8
         8O4RxDVQdGmnsB3VgeQlCyFG2HUj+5uMRkjJuotaWEmJ2d64j4rcuifgwU0wCo/KnxP/
         3eFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t5Mlhdl3kPEuQvLJzk9wkE0jtE88f7EwpDApTMzPN+w=;
        b=3Vz6uNx/bNhBb7pRMifiqlEGjdAKf0ymsND3cxQcYZqMiGv8zkBgkAQgq2WlcCaFHy
         uRxmYONXSxOei9E+dE/b6UoImTzbp/WbYsrqs1ahPL3I823lCt+5k6v078rjKL+bbtAF
         p/vTperxcbh/lw3z3gaT1hYSfhLAyRLoelhdiG60lQ6lMK86JN39/4QY7iszOzeIRVWp
         p2IWhkMII7CbmSPAYe9o/M3UQsxr5wPcuByzuH7OFLJn82iw7YuTC10CbykHX1kHNhwY
         sYg4XcpMJe6pbv9At4zGozI5tHdrBMAc9k/33S/WVvz4v7+BQHl266tRXZlW9fSkEBi6
         dj0Q==
X-Gm-Message-State: AOAM531UfPzwn0QsYmvdnj55tw74n962a1tOpe4ES3kgf5LokQyx+XEC
        7Y/6DwHFYAfy3PtNjAptBEo=
X-Google-Smtp-Source: ABdhPJz2Upg8dWtUctkZQ1ubNvMej/ScM4VQutPARmh+A28nWJNy5b+syUZ94/h+NEtB17JDvlOPLg==
X-Received: by 2002:a17:907:eab:b0:6dd:e8fe:3dc with SMTP id ho43-20020a1709070eab00b006dde8fe03dcmr38768174ejc.165.1648638071086;
        Wed, 30 Mar 2022 04:01:11 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id kw3-20020a170907770300b006b2511ea97dsm8040569ejc.42.2022.03.30.04.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 04:01:10 -0700 (PDT)
Date:   Wed, 30 Mar 2022 13:01:08 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: pull-request: bpf 2022-03-29
Message-ID: <YkQ35IjOhjUYHsk4@krava>
References: <20220329234924.39053-1-alexei.starovoitov@gmail.com>
 <20220329184123.59cfad63@kernel.org>
 <CAADnVQJNS_U97aqaNxtAhuvZCK6oiDA-tDoAEyDMYnCBbfaZkg@mail.gmail.com>
 <YkQPTlN5VMeRg5zZ@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkQPTlN5VMeRg5zZ@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 10:05:34AM +0200, Jiri Olsa wrote:
> On Tue, Mar 29, 2022 at 06:51:22PM -0700, Alexei Starovoitov wrote:
> > On Tue, Mar 29, 2022 at 6:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Tue, 29 Mar 2022 16:49:24 -0700 Alexei Starovoitov wrote:
> > > > Hi David, hi Jakub,
> > > >
> > > > The following pull-request contains BPF updates for your *net* tree.
> > > >
> > > > We've added 16 non-merge commits during the last 1 day(s) which contain
> > > > a total of 24 files changed, 354 insertions(+), 187 deletions(-).
> > > >
> > > > The main changes are:
> > > >
> > > > 1) x86 specific bits of fprobe/rethook, from Masami and Peter.
> > > >
> > > > 2) ice/xsk fixes, from Maciej and Magnus.
> > > >
> > > > 3) Various small fixes, from Andrii, Yonghong, Geliang and others.
> > >
> > > There are some new sparse warnings here that look semi-legit.
> > > As in harmless but not erroneous.
> > 
> > Both are new warnings and not due to these patches, right?
> > 
> > > kernel/trace/rethook.c:68:9: error: incompatible types in comparison expression (different address spaces):
> > > kernel/trace/rethook.c:68:9:    void ( [noderef] __rcu * )( ... )
> > > kernel/trace/rethook.c:68:9:    void ( * )( ... )
> > >
> > > 66 void rethook_free(struct rethook *rh)
> > > 67 {
> > > 68         rcu_assign_pointer(rh->handler, NULL);
> > > 69
> > > 70         call_rcu(&rh->rcu, rethook_free_rcu);
> > > 71 }
> > >
> > > Looks like this should be a WRITE_ONCE() ?
> > 
> > Masami, please take a look.
> > 
> > > And the __user annotations in bpf_trace.c are still not right,
> > > first arg of kprobe_multi_resolve_syms() should __user:
> > >
> > > kernel/trace/bpf_trace.c:2370:34: warning: incorrect type in argument 2 (different address spaces)
> > > kernel/trace/bpf_trace.c:2370:34:    expected void const [noderef] __user *from
> > > kernel/trace/bpf_trace.c:2370:34:    got void const *usyms
> > > kernel/trace/bpf_trace.c:2376:51: warning: incorrect type in argument 2 (different address spaces)
> > > kernel/trace/bpf_trace.c:2376:51:    expected char const [noderef] __user *src
> > > kernel/trace/bpf_trace.c:2376:51:    got char const *
> > > kernel/trace/bpf_trace.c:2443:49: warning: incorrect type in argument 1 (different address spaces)
> > > kernel/trace/bpf_trace.c:2443:49:    expected void const *usyms
> > > kernel/trace/bpf_trace.c:2443:49:    got void [noderef] __user *[assigned] usyms
> > 
> > This one is known. Still waiting for the fix from Jiri.
> 
> right, I replied that for some reason I can't see these warnings
> with 'make C=2' and latest sparse.. how do you run that?
> 
> if patch below fixes it for you, I can send formal patch quickly

ok, I was on top of bpf-next/master where it's still reverted,
I can hit that on bpf/master, I'll send the fix

jirka
