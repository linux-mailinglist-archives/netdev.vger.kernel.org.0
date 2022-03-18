Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3D94DD41C
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 06:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbiCRFQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 01:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbiCRFP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 01:15:58 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BFB17334B;
        Thu, 17 Mar 2022 22:14:40 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id h6so240327ild.4;
        Thu, 17 Mar 2022 22:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9uzyypCS0fU5RhepHZ/z8afzycS2STBlsgHkw71gu4w=;
        b=OnFfktuJlXh8ibkbKObEfLL8t7fQG2VVrUpO3/jyob70JsqkXVmGj+Y0kHaUyVFVXL
         cYdXMKkzVP6VpWHTJC32BAWKLbxqUMfov/5JLKIQCXjfbJzBEbfV+TMVPdlkVdR3mmjT
         ThMG4+c8a3sBzw+PrxUE1aHEfqEZ0IWZHDikYcxXUipa7eXyZvnOZVvQmC5F0ntkfxfy
         oRYqd7ysttWmI0xnimbDVXtrPWVNcSlh+Znmu5A6fuFxRO+wEfQlGAoPz2KAUnegHBGO
         F2+Rl8vkPf6reIKKDx+NFyhTC3lesNM+quvJOxgnICM/bxIe7trNmVGkkks93qhstASB
         bGSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9uzyypCS0fU5RhepHZ/z8afzycS2STBlsgHkw71gu4w=;
        b=TPhYwMzXIvk8oTJ5HW6G3WUk9ljex1IUAXXcrwxW0FFGnwT+dpFGE5KVvXyXVnu/kS
         OldsT27AJjvIgN8BYELdWvTHEIm6Wa4gWxaBOAMF8z+397ypu2xnFJLySX6zCwByKc5z
         F9geEdhmmY/Dl3Y3+K2zMqRMBF6vn6TbthrEUOsnxpOHSW6Q/s2J+H66IPSXO0imn4Kf
         zGq8DCbBQ98+diWW4+DltbY9qcv3jf5maYgKjigagR8d4IsCETdAlebzrIrIoTkqYZCZ
         4hp9drrb9eEJMz/j12SxT8Dk7sL75TrPfh2X7n2HMJzfSh9TNMyZMfn2AmcYvWb74LhS
         ssDg==
X-Gm-Message-State: AOAM530//2BzQlY3ktjvfeeUBSH84Bn5U5kjsxElPtdW9x/8Y3MGjA69
        238BY0Kx4siCFI3X2LU4E/YFGEgWcM3G3Nd21Gg=
X-Google-Smtp-Source: ABdhPJyl6YDnmNyHwxiDVyH09VIlsh1wXp2n43w1sh4q76Jn4RnEN1bct0MYAledCHMDxnTMG+HmEfKKcr+jehfAHMs=
X-Received: by 2002:a05:6e02:16c7:b0:2c7:e458:d863 with SMTP id
 7-20020a056e0216c700b002c7e458d863mr2856791ilx.71.1647580479470; Thu, 17 Mar
 2022 22:14:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220316122419.933957-1-jolsa@kernel.org> <20220316122419.933957-10-jolsa@kernel.org>
 <CAADnVQ+tNLEtbPY+=sZSoBicdSTx1YLgZJwnNuhnBkUcr5xozQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+tNLEtbPY+=sZSoBicdSTx1YLgZJwnNuhnBkUcr5xozQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 17 Mar 2022 22:14:28 -0700
Message-ID: <CAEf4BzZtQaiUxQ-sm_hH2qKPRaqGHyOfEsW96DxtBHRaKLoL3Q@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 09/13] libbpf: Add bpf_program__attach_kprobe_multi_opts
 function
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
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

On Thu, Mar 17, 2022 at 8:53 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Mar 16, 2022 at 5:26 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > +
> > +struct bpf_link *
> > +bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
> > +                                     const char *pattern,
> > +                                     const struct bpf_kprobe_multi_opts *opts)
> > +{
> > +       LIBBPF_OPTS(bpf_link_create_opts, lopts);
> > +       struct kprobe_multi_resolve res = {
> > +               .pattern = pattern,
> > +       };
> > +       struct bpf_link *link = NULL;
> > +       char errmsg[STRERR_BUFSIZE];
> > +       const unsigned long *addrs;
> > +       int err, link_fd, prog_fd;
> > +       const __u64 *cookies;
> > +       const char **syms;
> > +       bool retprobe;
> > +       size_t cnt;
> > +
> > +       if (!OPTS_VALID(opts, bpf_kprobe_multi_opts))
> > +               return libbpf_err_ptr(-EINVAL);
> > +
> > +       syms    = OPTS_GET(opts, syms, false);
> > +       addrs   = OPTS_GET(opts, addrs, false);
> > +       cnt     = OPTS_GET(opts, cnt, false);
> > +       cookies = OPTS_GET(opts, cookies, false);
> > +
> > +       if (!pattern && !addrs && !syms)
> > +               return libbpf_err_ptr(-EINVAL);
> > +       if (pattern && (addrs || syms || cookies || cnt))
> > +               return libbpf_err_ptr(-EINVAL);
> > +       if (!pattern && !cnt)
> > +               return libbpf_err_ptr(-EINVAL);
> > +       if (addrs && syms)
> > +               return libbpf_err_ptr(-EINVAL);
> > +
> > +       if (pattern) {
> > +               err = libbpf_kallsyms_parse(resolve_kprobe_multi_cb, &res);
> > +               if (err)
> > +                       goto error;
> > +               if (!res.cnt) {
> > +                       err = -ENOENT;
> > +                       goto error;
> > +               }
> > +               addrs = res.addrs;
> > +               cnt = res.cnt;
> > +       }
>
> Thanks Jiri.
> Great stuff and a major milestone!
> I've applied Masami's and your patches to bpf-next.
>
> But the above needs more work.
> Currently test_progs -t kprobe_multi
> takes 4 seconds on lockdep+debug kernel.
> Mainly because of the above loop.
>
>     18.05%  test_progs       [kernel.kallsyms]   [k]
> kallsyms_expand_symbol.constprop.4
>     12.53%  test_progs       libc-2.28.so        [.] _IO_vfscanf
>      6.31%  test_progs       [kernel.kallsyms]   [k] number
>      4.66%  test_progs       [kernel.kallsyms]   [k] format_decode
>      4.65%  test_progs       [kernel.kallsyms]   [k] string_nocheck
>
> Single test_skel_api() subtest takes almost a second.
>
> A cache inside libbpf probably won't help.
> Maybe introduce a bpf iterator for kallsyms?

BPF iterator for kallsyms is a great idea! So many benefits:
  - it should be significantly more efficient *and* simpler than
parsing /proc/kallsyms;
  - there were some upstream patches recording ksym length (i.e.,
function size), don't remember if that ever landed or not, but besides
that the other complication of even exposing that to user space were
concerns about /proc/kallsyms format being an ABI. With the BPF
iterator we can easily provide that symbol size without any breakage.
This would be great!
  - we can allow parameterizing iterator with options like: skip or
include module symbols, specify a set of types of symbols (function,
variable, etc), etc. This would speed everything up in common cases by
not even decompressing irrelevant names.

In short, kallsyms iterator would be an immensely useful for any sort
of tracing tool that deals with kernel stack traces or kallsyms in
general.

But in this particular case, kprobe_multi_resolve_syms()
implementation is extremely suboptimal. I didn't realize during review
that kallsyms_lookup_name() is a linear scan... If that's not going to
be changed to O(log(N)) some time soon, we need to reimplement
kprobe_multi_resolve_syms(), probably.

One way would be to sort user strings lexicographically and then do a
linear scan over all kallsyms, for each symbol perform binary search
over a sorted array of user strings. Stop once all the positions were
"filled in" (we'd need to keep a bitmap or bool[], probably). This way
it's going to be O(MlogN) instead of O(MN) as it is right now.

BTW, Jiri, libbpf.map is supposed to have an alphabetically ordered
list of functions, it would be good to move
bpf_program__attach_kprobe_multi_opts a bit higher before libbpf_*
functions.



>
> On the kernel side kprobe_multi_resolve_syms() looks similarly inefficient.
> I'm not sure whether it would be a bottle neck though.
>
> Orthogonal to this issue please add a new stress test
> to selftest/bpf that attaches to a lot of functions.
