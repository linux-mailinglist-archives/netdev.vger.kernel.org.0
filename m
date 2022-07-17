Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DC9577878
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 23:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbiGQVnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 17:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiGQVnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 17:43:19 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35373BC9E;
        Sun, 17 Jul 2022 14:43:18 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id z23so18222736eju.8;
        Sun, 17 Jul 2022 14:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JW1OfylC66Hp9nA9HQaGYHfkZ+Nw3LPS1bSYaq4nMP0=;
        b=M0d3xJ5Czbs9IA5+40C9BHKdH0HXEfgJDtwZ6Y1SloXOWcm0kpI7q9qD83hjvsgwk6
         pA0Xmcn42RGhFzZ1nn2aHyPhiIs2tCuE82wiqq/6DWV7WtgIm4CNkBhKDyIoBB3OqTb8
         7w/6gxdR5UQdzNiK/veI6aSX9qTUZk0PYhLJxUJFNlRR6Wh++CKvTDCP9mXlWtsFc75E
         3/d/nvWYVjF3UnOipsgcKUKVZjVOzKxlnRviQJQl/dvkJJpA10qYY4u4z0YzN7x1gnL4
         vvA00Te+QOXlZskfYzIsNgLE++0NnAjcnhJ/IOINqqSGkgg9Nnmc+SLDAUa6uamozeZj
         1crA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JW1OfylC66Hp9nA9HQaGYHfkZ+Nw3LPS1bSYaq4nMP0=;
        b=cO2vXDDtTiBZYAd8g3I5DHej3rzsD5OhfDhNdPtUPweVVKhIpH6Bt+6W24F5LBgkjx
         rMAiLlh08wo/5POJK/1kM/Iwv6GEeRoFE6SnFe7iUPRvWs6k5wfBQ4cL7rMaGOH1tv0O
         gQmU34JQGxP4hm99rTe8kt5yg1tWK+sQUWV16fI9GLb8y2VGe7foE8gmcC56s39s9kkF
         qzJpzwM8OqyKWDz+CKDGrcUa3DhgCeXvI/YRq3+hZbibaFX/k1PknCWvEeuEJHmTq11y
         3yQp4VAreqKyUSpY6RiaOA+sr0lqPmV9LqjQunLkvbSyYzTxKozfRna222b35vX0rIK3
         aTwQ==
X-Gm-Message-State: AJIora/Adjw4Ro+IvAj2ihkPlRFAvmaM3SCAHW9cCL4Ioc+wJjcieQiU
        9cEaCe8sGRzkblds0eYtKm0=
X-Google-Smtp-Source: AGRyM1tZcj9DBcDkMitCC14fjrMGK0pAtQzbt1WO6zdpn9cXiyuWGQSiYQlBgFcmAzr8u+C2tKoz8A==
X-Received: by 2002:a17:906:9b14:b0:72b:97ac:c30c with SMTP id eo20-20020a1709069b1400b0072b97acc30cmr23500919ejc.588.1658094196613;
        Sun, 17 Jul 2022 14:43:16 -0700 (PDT)
Received: from krava ([83.240.63.148])
        by smtp.gmail.com with ESMTPSA id eq22-20020a056402299600b0043a7134b381sm7254823edb.11.2022.07.17.14.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 14:43:12 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Sun, 17 Jul 2022 23:43:08 +0200
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <YtSCbIA+6JtRF/Ch@krava>
References: <20220705190308.1063813-1-jolsa@kernel.org>
 <20220705190308.1063813-5-jolsa@kernel.org>
 <CAEf4BzapX_C16O9woDSXOpbzVsxjYudXW36woRCqU3u75uYiFA@mail.gmail.com>
 <YsdbQ4vJheLWOa0a@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsdbQ4vJheLWOa0a@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 12:16:35AM +0200, Jiri Olsa wrote:
> On Tue, Jul 05, 2022 at 10:29:17PM -0700, Andrii Nakryiko wrote:
> > On Tue, Jul 5, 2022 at 12:04 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > The kprobe can be placed anywhere and user must be aware
> > > of the underlying instructions. Therefore fixing just
> > > the bpf program to 'fix' the address to match the actual
> > > function address when CONFIG_X86_KERNEL_IBT is enabled.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  tools/testing/selftests/bpf/progs/get_func_ip_test.c | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > > index a587aeca5ae0..220d56b7c1dc 100644
> > > --- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > > +++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > > @@ -2,6 +2,7 @@
> > >  #include <linux/bpf.h>
> > >  #include <bpf/bpf_helpers.h>
> > >  #include <bpf/bpf_tracing.h>
> > > +#include <stdbool.h>
> > >
> > >  char _license[] SEC("license") = "GPL";
> > >
> > > @@ -13,6 +14,8 @@ extern const void bpf_modify_return_test __ksym;
> > >  extern const void bpf_fentry_test6 __ksym;
> > >  extern const void bpf_fentry_test7 __ksym;
> > >
> > > +extern bool CONFIG_X86_KERNEL_IBT __kconfig __weak;
> > > +
> > >  __u64 test1_result = 0;
> > >  SEC("fentry/bpf_fentry_test1")
> > >  int BPF_PROG(test1, int a)
> > > @@ -37,7 +40,7 @@ __u64 test3_result = 0;
> > >  SEC("kprobe/bpf_fentry_test3")
> > >  int test3(struct pt_regs *ctx)
> > >  {
> > > -       __u64 addr = bpf_get_func_ip(ctx);
> > > +       __u64 addr = bpf_get_func_ip(ctx) - (CONFIG_X86_KERNEL_IBT ? 4 : 0);
> > 
> > so for kprobe bpf_get_func_ip() gets an address with 5 byte
> > compensation for `call __fentry__`, but not for endr? Why can't we
> > compensate for endbr inside the kernel code as well? I'd imagine we
> > either do no compensation (and thus we get &bpf_fentry_test3+5 or
> > &bpf_fentry_test3+9, depending on CONFIG_X86_KERNEL_IBT) or full
> > compensation (and thus always get &bpf_fentry_test3), but this
> > in-between solution seems to be the worst of both worlds?...
> 
> hm rigth, I guess we should be able to do that in bpf_get_func_ip,
> I'll check

sorry for late follow up..

so the problem is that you can place kprobe anywhere in the function
(on instruction boundary) but the IBT adjustment of kprobe address is
made only if it's at the function entry and there's endbr instruction

and that kprobe address is what we return in helper:

  BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
  {
        struct kprobe *kp = kprobe_running();

        return kp ? (uintptr_t)kp->addr : 0;
  }

so the adjustment would work only for address at function entry, but
would be wrong for address within the function

perhaps we could add flag to kprobe to indicate the addr adjustment
was done and use it in helper

but that's why I thought I'd keep bpf_get_func_ip_kprobe as it and
leave it up to user

kprobe_multi and trampolines are different, because they can be
only at the function entry, so we can adjust the ip properly

jirka
