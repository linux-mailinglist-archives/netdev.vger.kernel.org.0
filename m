Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFA93FF6B0
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 23:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347912AbhIBV46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 17:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347578AbhIBV4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 17:56:43 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606E9C0612A6;
        Thu,  2 Sep 2021 14:55:41 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id j16so1979705pfc.2;
        Thu, 02 Sep 2021 14:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iwPS3vM5tRHPtHkB7HzB1C1Iavev/cKLScOoPkW3dDw=;
        b=XbEmzVxTNSXnp78fvnsZwoE9JBNFbdSfVRAmMZLCSS7Ke258A8s9BHsJ8bFSJ6qZkR
         RV9A36aQqAoqlNXAyR1T1aVT3GVJ4S4Cp+OmcFjMvhxuNPg+k5m5sY2IV7h3S8c48Rrw
         FIcoB6TtGjrf67V4XJN9MgEjxeOvi2K5+9b8M6NOGMpuVOHreOCkrL7Za+n/fjLn6L33
         oI2QJJd9NDv/cUKxHEZdZ+npUv6pUF3j048q6a1EzFv6INOOr2r4xC20h1gqHTXc+iv6
         p84tcFfld0AatIRb5PFKjj2Mc0GrfBrZc8qqMIfi0OpRI1RzAsXm+lCmMUdCLy5HKOFw
         GyUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iwPS3vM5tRHPtHkB7HzB1C1Iavev/cKLScOoPkW3dDw=;
        b=n93bOCv+FBAIJlmLwGnv0Gu50gLn+wMnsENHCqsp2XfklGuwPgEBxKI+UvFW0OfI49
         5/OEGNUcqe+wo9ho2IyXye5RMmk1kMpyrR+V8oCgLlmvNhEL4jAJZpa6XcIkd9eFabj8
         zgvXd+EGqYwmaX0KI/2MrOsFlHr90cEscmFx0S+Rp4PEEnFWI6NLrLnPIrGClKzBILQ7
         dHZT80bK1kRBr5KYVhkO7dkh7mi7iOhm7ryea4oR/ZnU5j7ngWJFPzu5pk3jNHDGHraK
         olX7zr3Zw6RLyT+3ncm4r63pto2/EJ+9LDZy2Ek1SrPHjJhKDzUbfYtUKbwMkilEhnvH
         xY9w==
X-Gm-Message-State: AOAM530p5Qiugjo8lNWGoId7J9CA8LCD/8ieAjjPlFqhkGHf89Xjgn6o
        8ZWe0jqBl6HIHqx+aPGP75Q=
X-Google-Smtp-Source: ABdhPJywAHe9cixd6pHWWTse7STlH1AqtmqhAFK5fUDt8/yHmFhUds79RYUqlZ9Tpu0ZR9hoT7LQsA==
X-Received: by 2002:a05:6a00:1904:b029:3b9:e4ea:1f22 with SMTP id y4-20020a056a001904b02903b9e4ea1f22mr147476pfi.79.1630619740656;
        Thu, 02 Sep 2021 14:55:40 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:500::5:c1df])
        by smtp.gmail.com with ESMTPSA id p16sm3110457pfw.66.2021.09.02.14.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:55:40 -0700 (PDT)
Date:   Thu, 2 Sep 2021 14:55:38 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH bpf-next v4 18/27] bpf, x64: Store properly return value
 for trampoline with multi func programs
Message-ID: <20210902215538.a75q7bjcgkpjync4@ast-mbp.dhcp.thefacebook.com>
References: <20210826193922.66204-1-jolsa@kernel.org>
 <20210826193922.66204-19-jolsa@kernel.org>
 <CAEf4BzbFxSVzu1xrUyzrgn1jKyR40RJ3UEEsUCkii3u5nN_8wg@mail.gmail.com>
 <YS+ZAbb+h9uAX6EP@krava>
 <CAEf4BzY1XhuZ5huinfTmUZGhrT=wgACOgKbbdEPmnek=nN6YgA@mail.gmail.com>
 <YTDKJ2E1fN0hPDZj@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTDKJ2E1fN0hPDZj@krava>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 02:57:11PM +0200, Jiri Olsa wrote:
> > 
> > Let's say we have 5 kernel functions: a, b, c, d, e. Say a, b, c all
> > have 1 input args, and d and e have 2.
> > 
> > Now let's say we attach just normal fentry program A to function a.
> > Also we attach normal fexit program E to func e.
> > 
> > We'll have A  attached to a with trampoline T1. We'll also have E
> > attached to e with trampoline T2. Right?
> > 
> > And now we try to attach generic fentry (fentry.multi in your
> > terminology) prog X to all 5 of them. If A and E weren't attached,
> > we'd need two generic trampolines, one for a, b, c (because 1 input
> > argument) and another for d,e (because 2 input arguments). But because
> > we already have A and B attached, we'll end up needing 4:
> > 
> > T1 (1 arg)  for func a calling progs A and X
> > T2 (2 args) for func e calling progs E and X
> > T3 (1 arg)  for func b and c calling X
> > T4 (2 args) for func d calling X
> 
> so current code would group T3/T4 together, but if we keep
> them separated, then we won't need to use new model and
> cut off some of the code, ok

We've brainstormed this idea further with Andrii.
(thankfully we could do it in-person now ;) which saved a ton of time)

It seems the following should work:
5 kernel functions: a(int), b(long), c(void*), d(int, int), e(long, long).
fentry prog A is attached to 'a'.
fexit prog E is attached to 'e'.
multi-prog X wants to attach to all of them.
It can be achieved with 4 trampolines.

The trampolines called from funcs 'a' and 'e' can be patched to
call A+X and E+X programs correspondingly.
The multi program X needs to be able to access return values
and arguments of all functions it was attached to.
We can achieve that by always generating a trampoline (both multi and normal)
with extra constant stored in the stack. This constant is the number of
arguments served by this trampoline.
The trampoline 'a' will store nr_args=1.
The tramopline 'e' will store nr_args=2.
We need two multi trampolines.
The multi tramopline X1 that will serve 'b' and 'c' and store nr_args=1
and multi-tramopline X2 that will serve 'd' and store nr_args=2
into hidden stack location (like ctx[-2]).

The multi prog X can look like:
int BPF_PROG(x, __u64 arg1, __u64 arg2, __u64 ret)
in such case it will read correct args and ret when called from 'd' and 'e'
and only correct arg1 when called from 'a', 'b', 'c'.

To always correctly access arguments and the return value
the program can use two new helpers: bpf_arg(ctx, N) and bpf_ret_value(ctx).
Both will be fully inlined helpers similar to bpf_get_func_ip().
u64 bpf_arg(ctx, int n)
{
  u64 nr_args = ctx[-2]; /* that's the place where _all_ trampoline will store nr_args */
  if (n > nr_args)
    return 0;
  return ctx[n];
}
u64 bpf_ret_value(ctx)
{
  u64 nr_args = ctx[-2];
  return ctx[nr_args];
}

These helpers will be the only recommended way to access args and ret value
in multi progs.
The nice advantage is that normal fentry/fexit progs can use them too.

We can rearrange ctx[-1] /* func_ip */ and ctx[-2] /* nr_args */
if it makes things easier.

If multi prog knows that it is attaching to 100 kernel functions
and all of them have 2 arguments it can still do
int BPF_PROG(x, __u64 arg1, __u64 arg2, __u64 ret)
{ // access arg1, arg2, ret directly
and it will work correctly.

We can make it really strict in the verifier and disallow such
direct access to args from the multi prog and only allow
access via bpf_arg/bpf_ret_value helpers, but I think it's overkill.
Reading garbage values from stack isn't great, but it's not a safety issue.
It means that the verifier will allow something like 16 u64-s args
in multi program. It cannot allow large number, since ctx[1024]
might become a safety issue, while ctx[4] could be a garbage
or a valid value depending on the call site.

Thoughts?
