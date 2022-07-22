Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC5557D9A0
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiGVEdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGVEdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:33:05 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2D420BF0;
        Thu, 21 Jul 2022 21:33:04 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id mf4so6621576ejc.3;
        Thu, 21 Jul 2022 21:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cwp96O0kcNZr6s+SOBQm6JoJj2aG9ZnMW3RaxW46bzE=;
        b=hmT1EeBYX5jwG7p+GkvNCOpAkS6jlWFIt4XWpMnJ1xSHWxl3xzLVeyyJVamFfgRc8V
         v8eSiEAV9f79SyPsp2ls0x2eEv6gNMUr9yNKxPrTOmLCTk60X7XT8YXqbyn3+KY7n4C/
         UpMc2QWOrWQs05tsT/cFj1Kyr1/vTx5XxzXHbsUCmaSfqxn2XjQbq0zYWax7cbOa441m
         W2NlmZtw3val1Aw/KxXsl0koAlNlCpPb5AgmMuskvvVj22yClUck5dxX+h7xCxTAp3YN
         kclCz19IM5XPDRFIkJREWrVvFFW8QZHbnj+znO5cH5+vdM+WdJVYfRMdaq3RwzYgfHWg
         XKQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cwp96O0kcNZr6s+SOBQm6JoJj2aG9ZnMW3RaxW46bzE=;
        b=rBAtL5UCcRBzQHuXYk22QF3UTHwFYu+T9vyZtHkqvPDj4FMvfWIfokzKFLWEKsYnVw
         7FA4izmb4BJEd19sUXC1xAYObn1kmGdXm9A7+RwQk5yh9NaV5latBrf2frS9KHL567p/
         /Q6lZ17U9WqpoN17nh8Rq8damKIPnafKBoZPoEzDs/txxBA7CrbouzvDStEhSFPgyf70
         kdomBcISbkZBOjVW0bOoZgHtXUW1S2Ms8OfIq5EefY7khDbtxljD2IjqzG+qnePJ33Vz
         BuZ65mlWHzS9jHkPtI6mzdk5wUtFvxyYZdi00LuxbTnJDsX5rMWnE1hbJO1l5DjtV7cd
         tppA==
X-Gm-Message-State: AJIora/HVUcJXCCmddmC8etxIlwXSxyhQRYBEOcvF9BtuSp8nCOZ4zR1
        J6cq98oXOsNh8fycNiAuVOXk2jkWHc2cDGTXiwM=
X-Google-Smtp-Source: AGRyM1t7sn8S6Nbmvy8GHB69pcj46jwZweqWes4L3Vu3qILQRc45qxrO0U0Q1XkEkWqdca1K/3MUTTXJE0hJzfb11gU=
X-Received: by 2002:a17:907:3f07:b0:72b:54b2:f57f with SMTP id
 hq7-20020a1709073f0700b0072b54b2f57fmr1558382ejc.502.1658464382934; Thu, 21
 Jul 2022 21:33:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220720114652.3020467-1-asavkov@redhat.com> <20220720114652.3020467-2-asavkov@redhat.com>
 <CAADnVQ+mt1iEsXUGBeL-dgXRoRwPxoz+G=aRcZTkhx2AA10R-A@mail.gmail.com> <YtolJfvSGjSSwbc3@sparkplug.usersys.redhat.com>
In-Reply-To: <YtolJfvSGjSSwbc3@sparkplug.usersys.redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 21 Jul 2022 21:32:51 -0700
Message-ID: <CAADnVQLyCc7reM1By+TYBaNGh1SBpVqyNyT+WJXOooCqX_w2GA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: add BPF_F_DESTRUCTIVE flag for BPF_PROG_LOAD
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 9:18 PM Artem Savkov <asavkov@redhat.com> wrote:
>
> On Thu, Jul 21, 2022 at 07:02:07AM -0700, Alexei Starovoitov wrote:
> > On Wed, Jul 20, 2022 at 4:47 AM Artem Savkov <asavkov@redhat.com> wrote:
> > >
> > > +/* If BPF_F_DESTRUCTIVE is used in BPF_PROG_LOAD command, the loaded program
> > > + * will be able to perform destructive operations such as calling bpf_panic()
> > > + * helper.
> > > + */
> > > +#define BPF_F_DESTRUCTIVE      (1U << 6)
> >
> > I don't understand what value this flag provides.
> >
> > bpf prog won't be using kexec accidentally.
> > Requiring user space to also pass this flag seems pointless.
>
> bpf program likely won't. But I think it is not uncommon for people to
> run bpftrace scripts they fetched off the internet to run them without
> fully reading the code. So the idea was to provide intermediate tools
> like that with a common way to confirm user's intent without
> implementing their own guards around dangerous calls.
> If that is not a good enough of a reason to add the flag I can drop it.

The intent makes sense, but bpftrace will set the flag silently.
Since bpftrace compiles the prog it knows what helpers are being
called, so it will have to pass that extra flag automatically anyway.
You can argue that bpftrace needs to require a mandatory cmdline flag
from users to run such scripts, but even if you convince the bpftrace
community to do that everybody else might just ignore that request.
Any tool (even libbpf) can scan the insns and provide flags.

Long ago we added the 'kern_version' field to the prog_load command.
The intent was to tie bpf prog with kernel version.
Soon enough people started querying the kernel and put that
version in there ignoring SEC("version") that bpf prog had.
It took years to clean that up.
BPF_F_DESTRUCTIVE flag looks similar to me.
Good intent, but unlikely to achieve the goal.

Do you have other ideas to achieve the goal:
'cannot run destructive prog by accident' ?

If we had an UI it would be a question 'are you sure? please type: yes'.

I hate to propose the following, since it will delay your patch
for a long time, but maybe we should only allow signed bpf programs
to be destructive?
