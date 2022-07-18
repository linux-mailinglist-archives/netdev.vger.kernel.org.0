Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308885782B0
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbiGRMsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiGRMsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:48:53 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13CE274;
        Mon, 18 Jul 2022 05:48:51 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id bp15so21020462ejb.6;
        Mon, 18 Jul 2022 05:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TeGVCUHeLxV7GRevtfvM+qomfGbRC+tXZ9uiMLV6+TY=;
        b=njIbtwRABHwo1EuVlDmBZl5/FfMEVieI0PWSxOowMr14u+vgbwUdzACh1FX0Z5QT3I
         NwlS4Wvt3WPDSo5+c90fkGtVn4fxYFvOoTGGw7mIVewnJvOZndlPGb6yUx/4qwDBmtvc
         FflvOm+utwIey+OP2PLkl90+gv4M/nievVIhkYfVNQFfwaQyG+ATBsmOxPtfGqshXRe+
         Ass+P5pjmix/lZf0A7RnNHFyVYPGm+al2LZKZfcAr6BwogORogjpVRjte0NdvjBtWl2G
         bqcvCu+jgtOnXnl2kj5HFnBiJqhWYE2CvQZFeXqB6JK0b3wy7p8xYDAdR7tWHL6HVKye
         7/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TeGVCUHeLxV7GRevtfvM+qomfGbRC+tXZ9uiMLV6+TY=;
        b=bXZMlvS+5eGxJT2F4qa1YzdJupP/UCfTesTNW9qyHh6MSPmXCsKhLqr1QkY6Q4Lz7r
         2r72wslnO80P68pCbZWV4zcCePp+eS7mBuKy/sBn7JlPcHlSpzb0YOt1bV8LZE67SwPd
         aNq2mopT9NxFkdT9CNTelG2OjlqeEC60fweLs5iIMH5yXH0GPATGJObqbPRBnQX/UGVE
         xQLsLiFqf4UT97Emw9qEONGlK6YzJHrrfZutFGL4w67RfyWHgEkvgkadHnwiXSzBMjM0
         OaJZsCc7uDbAUDRgq+hOm/GHJRqZZEcOtCXdXYIknCDRYPHbElgw14SQHL7yw4wYr5BD
         dyug==
X-Gm-Message-State: AJIora8dtXLQ3/fwdkujGFIlsYqTRpLTWF0zR6H9bx8UlPRT0p5OWwgT
        W/PtbRESJmK9BFbA0qyrPkc=
X-Google-Smtp-Source: AGRyM1v5W3XVAP+3An41B0subOY/ynUHBsIavZ/hmJ7cpd6pECSZfwhJE5T7jKBSQ6hbg4w6JUffTg==
X-Received: by 2002:a17:906:4785:b0:72e:dd6c:1ba1 with SMTP id cw5-20020a170906478500b0072edd6c1ba1mr20369468ejc.712.1658148529973;
        Mon, 18 Jul 2022 05:48:49 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id t18-20020a1709067c1200b006febce7081bsm5436352ejo.163.2022.07.18.05.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 05:48:48 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 18 Jul 2022 14:48:46 +0200
To:     Martynas Pumputis <m@lambda.lt>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Yutaro Hayakawa <yutaro.hayakawa@isovalent.com>
Subject: Re: [PATCH RFC bpf-next 4/4] selftests/bpf: Fix kprobe get_func_ip
 tests for CONFIG_X86_KERNEL_IBT
Message-ID: <YtVWruugC9LHtah2@krava>
References: <20220705190308.1063813-1-jolsa@kernel.org>
 <20220705190308.1063813-5-jolsa@kernel.org>
 <CAEf4BzapX_C16O9woDSXOpbzVsxjYudXW36woRCqU3u75uYiFA@mail.gmail.com>
 <YsdbQ4vJheLWOa0a@krava>
 <YtSCbIA+6JtRF/Ch@krava>
 <f6b5dc36-3dbb-433d-01d2-aad8959d0546@lambda.lt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6b5dc36-3dbb-433d-01d2-aad8959d0546@lambda.lt>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 02:09:54PM +0300, Martynas Pumputis wrote:
> 
> 
> On 7/18/22 00:43, Jiri Olsa wrote:
> > On Fri, Jul 08, 2022 at 12:16:35AM +0200, Jiri Olsa wrote:
> > > On Tue, Jul 05, 2022 at 10:29:17PM -0700, Andrii Nakryiko wrote:
> > > > On Tue, Jul 5, 2022 at 12:04 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > > > > 
> > > > > The kprobe can be placed anywhere and user must be aware
> > > > > of the underlying instructions. Therefore fixing just
> > > > > the bpf program to 'fix' the address to match the actual
> > > > > function address when CONFIG_X86_KERNEL_IBT is enabled.
> > > > > 
> > > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > > ---
> > > > >   tools/testing/selftests/bpf/progs/get_func_ip_test.c | 7 +++++--
> > > > >   1 file changed, 5 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > > > > index a587aeca5ae0..220d56b7c1dc 100644
> > > > > --- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > > > > +++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > > > > @@ -2,6 +2,7 @@
> > > > >   #include <linux/bpf.h>
> > > > >   #include <bpf/bpf_helpers.h>
> > > > >   #include <bpf/bpf_tracing.h>
> > > > > +#include <stdbool.h>
> > > > > 
> > > > >   char _license[] SEC("license") = "GPL";
> > > > > 
> > > > > @@ -13,6 +14,8 @@ extern const void bpf_modify_return_test __ksym;
> > > > >   extern const void bpf_fentry_test6 __ksym;
> > > > >   extern const void bpf_fentry_test7 __ksym;
> > > > > 
> > > > > +extern bool CONFIG_X86_KERNEL_IBT __kconfig __weak;
> > > > > +
> > > > >   __u64 test1_result = 0;
> > > > >   SEC("fentry/bpf_fentry_test1")
> > > > >   int BPF_PROG(test1, int a)
> > > > > @@ -37,7 +40,7 @@ __u64 test3_result = 0;
> > > > >   SEC("kprobe/bpf_fentry_test3")
> > > > >   int test3(struct pt_regs *ctx)
> > > > >   {
> > > > > -       __u64 addr = bpf_get_func_ip(ctx);
> > > > > +       __u64 addr = bpf_get_func_ip(ctx) - (CONFIG_X86_KERNEL_IBT ? 4 : 0);
> > > > 
> > > > so for kprobe bpf_get_func_ip() gets an address with 5 byte
> > > > compensation for `call __fentry__`, but not for endr? Why can't we
> > > > compensate for endbr inside the kernel code as well? I'd imagine we
> > > > either do no compensation (and thus we get &bpf_fentry_test3+5 or
> > > > &bpf_fentry_test3+9, depending on CONFIG_X86_KERNEL_IBT) or full
> > > > compensation (and thus always get &bpf_fentry_test3), but this
> > > > in-between solution seems to be the worst of both worlds?...
> > > 
> > > hm rigth, I guess we should be able to do that in bpf_get_func_ip,
> > > I'll check
> > 
> > sorry for late follow up..
> > 
> > so the problem is that you can place kprobe anywhere in the function
> > (on instruction boundary) but the IBT adjustment of kprobe address is
> > made only if it's at the function entry and there's endbr instruction
> 
> To add more fun to the issue, not all non-inlined functions get endbr64. For
> example "skb_release_head_state()" does, while "skb_free_head()" doesn't.

ah great.. thanks for info, will check

jirka

> 
> > 
> > and that kprobe address is what we return in helper:
> > 
> >    BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
> >    {
> >          struct kprobe *kp = kprobe_running();
> > 
> >          return kp ? (uintptr_t)kp->addr : 0;
> >    }
> > 
> > so the adjustment would work only for address at function entry, but
> > would be wrong for address within the function
> > 
> > perhaps we could add flag to kprobe to indicate the addr adjustment
> > was done and use it in helper
> > 
> > but that's why I thought I'd keep bpf_get_func_ip_kprobe as it and
> > leave it up to user
> > 
> > kprobe_multi and trampolines are different, because they can be
> > only at the function entry, so we can adjust the ip properly
> > 
> > jirka
