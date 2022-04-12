Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5624FE508
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 17:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352971AbiDLPqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 11:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349533AbiDLPqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 11:46:24 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858E410E1;
        Tue, 12 Apr 2022 08:44:05 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b15so22873599edn.4;
        Tue, 12 Apr 2022 08:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NXTt21pP00Yb2qQhiXa+16lsp7D3w+nhEqL+5vsS12M=;
        b=Rqp9TqHC8gBsLVoMXbStnEGzZMTPX95+kpVbKAi0Y2GDZEQWzTKb4lFaep0wk3ED5O
         X3gRWYeovPEl/3OD48ulzalDPTBMKZh+JjsqJPfsXrs/cZLDyHyzwog7nYUL2TgfM2bj
         /xi34FyJFLnN4p1QymAmHZfWHtE9NitUul2m55zZbccOFASOc1D0IAFtjleeROWqC91F
         ejm9ivKThag8DFzEBXEbEaMGFaLI/9dGKZkkjr+igq515gt8HqhZos7gH1e8KjBK5Xqt
         H5e5E2dhPs5g4HlkTYENoldIJgZzQQcF1cusoi0tdRX41ol7llIzTotKnMiMIAxLncm9
         zTbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NXTt21pP00Yb2qQhiXa+16lsp7D3w+nhEqL+5vsS12M=;
        b=20fkcKUur4EHaP2rjUBPQEp595Cn+oxmQ0KCqJI5/KcipcYIBbdDlEjOMD9dHCehvp
         YAwXcSxQ72gPn68IHajF3vtWGzG4Zd9EiELqDOzXJySXgrFD+MjYG2YhVurXprZasrKr
         qUCeJimyG3+w6PyGjoi0TcjaCa2sFtDkc2eyRnkyiLIxHkn57bIU0ufMUU/cq0ptFEjO
         7CWnJqoBJ59waU/zA4JJJvyxQZS5L3j1J4zHG4oEHvJVMDchQh6JuWaQFNFOrvwHmI6W
         0dvYsj40/N8iC3gkf0jzruoqyzcGx4vYuFfxxFBA9FR5DRSEa2as8MilnPdGxkjGRL+E
         i80w==
X-Gm-Message-State: AOAM533oc7h89jbM3o2yIU3oD2RyqYIMOpP7u+A3ztzbe1vCbQXqIF+A
        2aSgvpaFDuzLl9inhcTgcmA=
X-Google-Smtp-Source: ABdhPJzaldN29rZURT2NOIMe+NKGjjWzDphXskZr9BXgnSyVxiiayAAXHEV/jpKDrNPsg6k3bxXghw==
X-Received: by 2002:a50:871e:0:b0:41d:77c0:6927 with SMTP id i30-20020a50871e000000b0041d77c06927mr13569863edb.354.1649778243710;
        Tue, 12 Apr 2022 08:44:03 -0700 (PDT)
Received: from krava ([83.240.62.142])
        by smtp.gmail.com with ESMTPSA id z21-20020a1709063a1500b006da6436819dsm13252584eje.173.2022.04.12.08.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 08:44:03 -0700 (PDT)
Date:   Tue, 12 Apr 2022 17:44:00 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 4/4] selftests/bpf: Add attach bench test
Message-ID: <YlWeQIUaqGnbg4K0@krava>
References: <20220407125224.310255-1-jolsa@kernel.org>
 <20220407125224.310255-5-jolsa@kernel.org>
 <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 03:15:40PM -0700, Andrii Nakryiko wrote:

SNIP

> > +static int get_syms(char ***symsp, size_t *cntp)
> > +{
> > +       size_t cap = 0, cnt = 0, i;
> > +       char *name, **syms = NULL;
> > +       struct hashmap *map;
> > +       char buf[256];
> > +       FILE *f;
> > +       int err;
> > +
> > +       /*
> > +        * The available_filter_functions contains many duplicates,
> > +        * but other than that all symbols are usable in kprobe multi
> > +        * interface.
> > +        * Filtering out duplicates by using hashmap__add, which won't
> > +        * add existing entry.
> > +        */
> > +       f = fopen(DEBUGFS "available_filter_functions", "r");
> 
> I'm really curious how did you manage to attach to everything in
> available_filter_functions because when I'm trying to do that I fail.

the new code makes the differece ;-) so the main problem I could not
use available_filter_functions functions before were cases like:

  # cat available_filter_functions | grep sys_ni_syscall
  sys_ni_syscall
  sys_ni_syscall
  sys_ni_syscall
  sys_ni_syscall
  sys_ni_syscall
  sys_ni_syscall
  sys_ni_syscall
  sys_ni_syscall
  sys_ni_syscall
  sys_ni_syscall
  sys_ni_syscall
  sys_ni_syscall
  sys_ni_syscall
  sys_ni_syscall
  sys_ni_syscall

which when you try to resolve you'll find just one address:

  # cat /proc/kallsyms | egrep 'T sys_ni_syscall'
  ffffffff81170020 T sys_ni_syscall

this is caused by entries like:
    __SYSCALL(156, sys_ni_syscall)

when generating syscalls for given arch

this is handled by the new code by removing duplicates when
reading available_filter_functions



another case is the other way round, like with:

  # cat /proc/kallsyms | grep 't t_next'
  ffffffff8125c3f0 t t_next
  ffffffff8126a320 t t_next
  ffffffff81275de0 t t_next
  ffffffff8127efd0 t t_next
  ffffffff814d6660 t t_next

that has just one 'ftrace-able' instance:

  # cat available_filter_functions | grep '^t_next$'
  t_next

and this is handled by calling ftrace_location on address when
resolving symbols, to ensure each reasolved symbol lives in ftrace 

> available_filter_functions has a bunch of functions that should not be
> attachable (e.g., notrace functions). Look just at __bpf_tramp_exit:
> 
>   void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);
> 
> So first, curious what I am doing wrong or rather why it succeeds in
> your case ;)
> 
> But second, just wanted to plea to "fix" available_filter_functions to
> not list stuff that should not be attachable. Can you please take a
> look and checks what's going on there and why do we have notrace
> functions (and what else should *NOT* be there)?

yes, seems like a bug ;-) it's in available_filter_functions
but it does not have 'call __fentry__' at the entry..

I was going to check on that, because you brought that up before,
but did not get to it yet

> 
> 
> > +       if (!f)
> > +               return -EINVAL;
> > +
> > +       map = hashmap__new(symbol_hash, symbol_equal, NULL);
> > +       err = libbpf_get_error(map);
> > +       if (err)
> > +               goto error;
> > +
> 
> [...]
> 
> > +
> > +       attach_delta_ns = (attach_end_ns - attach_start_ns) / 1000000000.0;
> > +       detach_delta_ns = (detach_end_ns - detach_start_ns) / 1000000000.0;
> > +
> > +       fprintf(stderr, "%s: found %lu functions\n", __func__, cnt);
> > +       fprintf(stderr, "%s: attached in %7.3lfs\n", __func__, attach_delta_ns);
> > +       fprintf(stderr, "%s: detached in %7.3lfs\n", __func__, detach_delta_ns);
> > +
> > +       if (attach_delta_ns > 2.0)
> > +               PRINT_FAIL("attach time above 2 seconds\n");
> > +       if (detach_delta_ns > 2.0)
> > +               PRINT_FAIL("detach time above 2 seconds\n");
> 
> see my reply on the cover letter, any such "2 second" assumption are
> guaranteed to bite us. We've dealt with a lot of timing issues due to
> CI being slower and more unpredictable in terms of performance, I'd
> like to avoid dealing with one more case like that.

right, I'll remove the check

thanks,
jirka
