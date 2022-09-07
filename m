Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA605AFA64
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 05:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiIGDGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 23:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiIGDF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 23:05:58 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35F886B75;
        Tue,  6 Sep 2022 20:05:56 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w2so17800006edc.0;
        Tue, 06 Sep 2022 20:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=lZhl4GKNh72f6ovup18O37psKeuslqnMIGiRFdPU76Q=;
        b=RCD3CfGkzkX2ogxVqAP1o0I0iO4u63lKMab7CUkWxpafhcP/27B/CzHvw89JugQLCE
         oviELWoh5CqMn+DaAkfeKeCSti6hEuOGl47tgpOZDRlMwHTmSRGnCg/5fPFo/rGAWoE9
         AxXKE5FZJ01NTgbgIidsTJaKudhIdVIbNnjrO/aTIDWdHRY/YGg3safFxLdG/HDrNnr1
         IAzuyILjxPMoWV27PelaY/9cHlX4Tf2PvZnoeslJmQIvh+KxqrG2XG6JE5DR7F6Btt5b
         Oo+7Fd1h9WLSlgRA2KvbZm2e8IpZT+DUMiC+XxPMa5zzGKgFK0LvmDrcoxH+z7aGqKkC
         mm6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=lZhl4GKNh72f6ovup18O37psKeuslqnMIGiRFdPU76Q=;
        b=4Wfy97KwE52eaRB+6AduykI03l7D469AVr91IP9TF5yV4Fq65ho8yezpilh8Y2cpP/
         My5dg5Ei0rsCFLO8EOLZKWB28ohYfPCX5GpJh4o4A3xlyEEHAbII4LZ8OlApFyP1Me2h
         CDEFWoMEj33RNVGNZYFNDC+ZsXiYk+etxdxi0tg9J/v1RL/bAU9x3i0tUm6PUswMQpDD
         WIHqLtImxuQCWQ/QX5Pt73Xx5vg5xPMKX/Fqh1wZNm+G5RZlTppVNblc1wqeO22ttHwX
         KliLMxMGGuTdRmyqDoe0aUMkYzGhbSUQ4LvRzwu79YkytshioNNAr6rjyPTV8Y7wC5+9
         5Mmg==
X-Gm-Message-State: ACgBeo063cfJcZVFZPHnFse2pZQJyNepWHlBfXbrS+7dGy9gGprjFdfw
        nAJ2UVx6jCnEpmZUXT7aGKjvom0hPkQkwxfp1x8=
X-Google-Smtp-Source: AA6agR5ZyoPwvG4+3ilgfNPiu54CYFcndyQtTG6z0EA+LSXSC2vH24jLhLuCSEb3R1/8KW2rWqQJYD7UCOjtmPLyMj0=
X-Received: by 2002:a05:6402:28cd:b0:448:3856:41a3 with SMTP id
 ef13-20020a05640228cd00b00448385641a3mr1275640edb.6.1662519955333; Tue, 06
 Sep 2022 20:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220906165131.59f395a9@canb.auug.org.au> <dab10759-c059-2254-116b-8360bc240e57@suse.cz>
 <CAADnVQJTDdA=vpQhrbAbX7oEQ=uaPXwAmjMzpW4Nk2Xi9f2JLA@mail.gmail.com>
In-Reply-To: <CAADnVQJTDdA=vpQhrbAbX7oEQ=uaPXwAmjMzpW4Nk2Xi9f2JLA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 6 Sep 2022 20:05:44 -0700
Message-ID: <CAADnVQKJORAcV75CHE1yG6_+c8qnoOj6gf=zJG9vnWwR5+4SqQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the slab tree
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 6, 2022 at 11:37 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Sep 6, 2022 at 12:53 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> >
> > On 9/6/22 08:51, Stephen Rothwell wrote:
> > > Hi all,
> >
> > Hi,
> >
> > > After merging the slab tree, today's linux-next build (powerpc
> > > ppc64_defconfig) failed like this:
> > >
> > > kernel/bpf/memalloc.c: In function 'bpf_mem_free':
> > > kernel/bpf/memalloc.c:613:33: error: implicit declaration of function '__ksize'; did you mean 'ksize'? [-Werror=implicit-function-declaration]
> > >    613 |         idx = bpf_mem_cache_idx(__ksize(ptr - LLIST_NODE_SZ));
> > >        |                                 ^~~~~~~
> > >        |                                 ksize
> >
> > Could you use ksize() here? I'm guessing you picked __ksize() because
> > kasan_unpoison_element() in mm/mempool.c did, but that's to avoid
> > kasan_unpoison_range() in ksize() as this caller does it differently.
> > AFAICS your function doesn't handle kasan differently, so ksize() should
> > be fine.
>
> Ok. Will change to use ksize().

Just pushed the following commit to address the issue:
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=1e660f7ebe0ff6ac65ee0000280392d878630a67

It will get to net-next soon.
