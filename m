Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48F0556AE32
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 00:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236853AbiGGWQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 18:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiGGWQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 18:16:49 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EED660687;
        Thu,  7 Jul 2022 15:16:48 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id y8so19089980eda.3;
        Thu, 07 Jul 2022 15:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YO2NZfGOZcYK9gMgoGCZO4NOF4ACb+pYXAD3heFWMCM=;
        b=lbir2vDv5+9Dn4Fj+xYcvRhLKFeVACpu2LPSWUYE4dmqLfFwydJ8zsE0x8lZMZL557
         QbCAcXoBbOKB6tYlVqj154JiyTHFRL2PBz8zpa0SNxd0YM8OoQdQZ6cyfznvxeiAwnoe
         TRkOcC0fQqDkaieKtgItUYFkdGF2PvQiOTaroDv+q7Cw4eq9Brj5uiGe8LyKd80PxkIn
         8fYq5pD58koBnfE9c6X+l/XwanodrTpz4H3iLqIlOSkvvuU+yGSrq6rrpP3+o740jozU
         Gv1LHK1r2bOBTx9SclOax0cTlmBfEIkzxFEmJvh9VtRGIqry54n/5sAA5f+CKSfADjyY
         WRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YO2NZfGOZcYK9gMgoGCZO4NOF4ACb+pYXAD3heFWMCM=;
        b=4vL7L/8zSTMlzVkH2mp697HXtYtmWcAHfjc2ct2kssabVDMSFGKjuPgiLZGfQjvOpJ
         dXPVtVqycXxHvmw4KjWeiFUGdW7ek+7cj0vCWnLJEt8bx/+7Yy0rnMW/jOXgrcbOabJh
         bdzRUr3r2IUwzYW+i6aZ+Lo/HD90v4V4Fi9YcS6GCi6oYJkxXDcuOM/S5UOoX3AZNpSU
         Etb2XLo0zatiP30Ur7eNI5hmQwltF9iguD41Y7C5Ny9r0CVpL4TMBzDCzmNgRzWpfEni
         ANmnCS3r3moqA6yBF+hOBgQa8WKff6KHoE0g1wCK68ccuQ8+VVFWzOevhIOxT3fHwB3P
         iNpw==
X-Gm-Message-State: AJIora8oClkOGzBTfJIUVwbGpDboMRzVSiVSGjg3c1IXTTlKbkxzc6UC
        vnmNv1ePeR3W3UAi6Fo5hUxVG4yD9yqJcGDY
X-Google-Smtp-Source: AGRyM1tXoBBOT+lDTY0PtF0mtq04tmbIrMC4YFIHI+1uPCCW8lhhE7p8llUo/QLXejrbry7huB3Rlw==
X-Received: by 2002:a05:6402:448e:b0:43a:9d20:a4ec with SMTP id er14-20020a056402448e00b0043a9d20a4ecmr413226edb.269.1657232206585;
        Thu, 07 Jul 2022 15:16:46 -0700 (PDT)
Received: from krava ([151.14.22.253])
        by smtp.gmail.com with ESMTPSA id ee34-20020a056402292200b0043a554818afsm10509820edb.42.2022.07.07.15.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 15:16:45 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 8 Jul 2022 00:16:35 +0200
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Martynas Pumputis <m@lambda.lt>,
        Yutaro Hayakawa <yutaro.hayakawa@isovalent.com>
Subject: Re: [PATCH RFC bpf-next 4/4] selftests/bpf: Fix kprobe get_func_ip
 tests for CONFIG_X86_KERNEL_IBT
Message-ID: <YsdbQ4vJheLWOa0a@krava>
References: <20220705190308.1063813-1-jolsa@kernel.org>
 <20220705190308.1063813-5-jolsa@kernel.org>
 <CAEf4BzapX_C16O9woDSXOpbzVsxjYudXW36woRCqU3u75uYiFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzapX_C16O9woDSXOpbzVsxjYudXW36woRCqU3u75uYiFA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 10:29:17PM -0700, Andrii Nakryiko wrote:
> On Tue, Jul 5, 2022 at 12:04 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > The kprobe can be placed anywhere and user must be aware
> > of the underlying instructions. Therefore fixing just
> > the bpf program to 'fix' the address to match the actual
> > function address when CONFIG_X86_KERNEL_IBT is enabled.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/testing/selftests/bpf/progs/get_func_ip_test.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > index a587aeca5ae0..220d56b7c1dc 100644
> > --- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > +++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > @@ -2,6 +2,7 @@
> >  #include <linux/bpf.h>
> >  #include <bpf/bpf_helpers.h>
> >  #include <bpf/bpf_tracing.h>
> > +#include <stdbool.h>
> >
> >  char _license[] SEC("license") = "GPL";
> >
> > @@ -13,6 +14,8 @@ extern const void bpf_modify_return_test __ksym;
> >  extern const void bpf_fentry_test6 __ksym;
> >  extern const void bpf_fentry_test7 __ksym;
> >
> > +extern bool CONFIG_X86_KERNEL_IBT __kconfig __weak;
> > +
> >  __u64 test1_result = 0;
> >  SEC("fentry/bpf_fentry_test1")
> >  int BPF_PROG(test1, int a)
> > @@ -37,7 +40,7 @@ __u64 test3_result = 0;
> >  SEC("kprobe/bpf_fentry_test3")
> >  int test3(struct pt_regs *ctx)
> >  {
> > -       __u64 addr = bpf_get_func_ip(ctx);
> > +       __u64 addr = bpf_get_func_ip(ctx) - (CONFIG_X86_KERNEL_IBT ? 4 : 0);
> 
> so for kprobe bpf_get_func_ip() gets an address with 5 byte
> compensation for `call __fentry__`, but not for endr? Why can't we
> compensate for endbr inside the kernel code as well? I'd imagine we
> either do no compensation (and thus we get &bpf_fentry_test3+5 or
> &bpf_fentry_test3+9, depending on CONFIG_X86_KERNEL_IBT) or full
> compensation (and thus always get &bpf_fentry_test3), but this
> in-between solution seems to be the worst of both worlds?...

hm rigth, I guess we should be able to do that in bpf_get_func_ip,
I'll check

thanks,
jirka

> 
> >
> >         test3_result = (const void *) addr == &bpf_fentry_test3;
> >         return 0;
> > @@ -47,7 +50,7 @@ __u64 test4_result = 0;
> >  SEC("kretprobe/bpf_fentry_test4")
> >  int BPF_KRETPROBE(test4)
> >  {
> > -       __u64 addr = bpf_get_func_ip(ctx);
> > +       __u64 addr = bpf_get_func_ip(ctx) - (CONFIG_X86_KERNEL_IBT ? 4 : 0);
> >
> >         test4_result = (const void *) addr == &bpf_fentry_test4;
> >         return 0;
> > --
> > 2.35.3
> >
