Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C7E57952B
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 10:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbiGSIYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 04:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiGSIYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 04:24:19 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158DD2AC72;
        Tue, 19 Jul 2022 01:24:18 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ez10so25702634ejc.13;
        Tue, 19 Jul 2022 01:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/SIPwmw47aoCFUJf+ZzbIX6Q4nMBEnXalKToeS/fWng=;
        b=UPv0gKuMZO+Gc/PXu991fHK9k2kxWWNht/jZ5ygGsGY73ITUi2+nN+o9mACUMtTACu
         UbX0dQSnd5G8qLAuGNx9A9BLqvWQGdGnl5Qv4mtFODOi09MnJFA142MIVChzyC+NumJX
         qhjmz0jLDJLyqhnIxkA6XJqn0ulin2oXQo0S8WnKRilMMFRpAEREQuJScvn6foFRh8WJ
         ZXJa/GElPhpE+YGTQVD9LgMt1IRutsuZonh+kdwM8DNJIG+nyVNcX5tUSqpEtINfCU5j
         xFAZxZrZEh5pY9dVCpK4nA8M2xVJWMhb2r0HrgplO2oHxYUhIsiJFmzWKMX5OOjUXeiY
         PtxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/SIPwmw47aoCFUJf+ZzbIX6Q4nMBEnXalKToeS/fWng=;
        b=BHzn0AHLkfapP1+cb+49nuFjvU5bIZ54xR0yy5NylKF6J0y/vnfwsjOQ5Dee1CYcKt
         fLEDKwfJeTlHtN5a4L1mAYVlPCWiyFTMspcYq6kyUzI16/oio99XSOvHAEXBNikyelvs
         NQZSWP1TGKzGb3Pwj4jwUDvA4UMtssGWpY+EhM9eyDX8eNSiwv6ufBQNa2uxDYPC2aWc
         flINWIA+EpKP6mHgVjoDEKBAAlXZW/j1OxURZidDknifdxzFZoVh7HnYuVtIf91010iV
         1rPXlPL+rItA3buaevLYznqEfCq5MrDzcaz8PXxA8+9XspXN0tw+dBINd6xNpDf5Lg3O
         pBeg==
X-Gm-Message-State: AJIora89u3o0UPC+DHqREgl8uMBxUXz+ZkwBJSQaEl5tmZTBeOG3VxJT
        VSCrUSAljX8Z7dmYCzYyt+4=
X-Google-Smtp-Source: AGRyM1vhnau/Abv5mHDURRwuOnzF3g/SXIcnCCtgO2pBc//7jZW25ou2vaLo5quzRXcgrSPmONnJUg==
X-Received: by 2002:a17:906:cc45:b0:72b:313b:f3ee with SMTP id mm5-20020a170906cc4500b0072b313bf3eemr28477978ejb.362.1658219056611;
        Tue, 19 Jul 2022 01:24:16 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id r18-20020a17090609d200b006feed200464sm6351476eje.131.2022.07.19.01.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 01:24:15 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 19 Jul 2022 10:24:12 +0200
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Martynas Pumputis <m@lambda.lt>,
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
        Yutaro Hayakawa <yutaro.hayakawa@isovalent.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC bpf-next 4/4] selftests/bpf: Fix kprobe get_func_ip
 tests for CONFIG_X86_KERNEL_IBT
Message-ID: <YtZqLDeUAjPHtJ+e@krava>
References: <20220705190308.1063813-1-jolsa@kernel.org>
 <20220705190308.1063813-5-jolsa@kernel.org>
 <CAEf4BzapX_C16O9woDSXOpbzVsxjYudXW36woRCqU3u75uYiFA@mail.gmail.com>
 <YsdbQ4vJheLWOa0a@krava>
 <YtSCbIA+6JtRF/Ch@krava>
 <f6b5dc36-3dbb-433d-01d2-aad8959d0546@lambda.lt>
 <YtVWruugC9LHtah2@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtVWruugC9LHtah2@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 02:48:46PM +0200, Jiri Olsa wrote:
> On Mon, Jul 18, 2022 at 02:09:54PM +0300, Martynas Pumputis wrote:
> > 
> > 
> > On 7/18/22 00:43, Jiri Olsa wrote:
> > > On Fri, Jul 08, 2022 at 12:16:35AM +0200, Jiri Olsa wrote:
> > > > On Tue, Jul 05, 2022 at 10:29:17PM -0700, Andrii Nakryiko wrote:
> > > > > On Tue, Jul 5, 2022 at 12:04 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > > > > > 
> > > > > > The kprobe can be placed anywhere and user must be aware
> > > > > > of the underlying instructions. Therefore fixing just
> > > > > > the bpf program to 'fix' the address to match the actual
> > > > > > function address when CONFIG_X86_KERNEL_IBT is enabled.
> > > > > > 
> > > > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > > > ---
> > > > > >   tools/testing/selftests/bpf/progs/get_func_ip_test.c | 7 +++++--
> > > > > >   1 file changed, 5 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > > diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > > > > > index a587aeca5ae0..220d56b7c1dc 100644
> > > > > > --- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > > > > > +++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > > > > > @@ -2,6 +2,7 @@
> > > > > >   #include <linux/bpf.h>
> > > > > >   #include <bpf/bpf_helpers.h>
> > > > > >   #include <bpf/bpf_tracing.h>
> > > > > > +#include <stdbool.h>
> > > > > > 
> > > > > >   char _license[] SEC("license") = "GPL";
> > > > > > 
> > > > > > @@ -13,6 +14,8 @@ extern const void bpf_modify_return_test __ksym;
> > > > > >   extern const void bpf_fentry_test6 __ksym;
> > > > > >   extern const void bpf_fentry_test7 __ksym;
> > > > > > 
> > > > > > +extern bool CONFIG_X86_KERNEL_IBT __kconfig __weak;
> > > > > > +
> > > > > >   __u64 test1_result = 0;
> > > > > >   SEC("fentry/bpf_fentry_test1")
> > > > > >   int BPF_PROG(test1, int a)
> > > > > > @@ -37,7 +40,7 @@ __u64 test3_result = 0;
> > > > > >   SEC("kprobe/bpf_fentry_test3")
> > > > > >   int test3(struct pt_regs *ctx)
> > > > > >   {
> > > > > > -       __u64 addr = bpf_get_func_ip(ctx);
> > > > > > +       __u64 addr = bpf_get_func_ip(ctx) - (CONFIG_X86_KERNEL_IBT ? 4 : 0);
> > > > > 
> > > > > so for kprobe bpf_get_func_ip() gets an address with 5 byte
> > > > > compensation for `call __fentry__`, but not for endr? Why can't we
> > > > > compensate for endbr inside the kernel code as well? I'd imagine we
> > > > > either do no compensation (and thus we get &bpf_fentry_test3+5 or
> > > > > &bpf_fentry_test3+9, depending on CONFIG_X86_KERNEL_IBT) or full
> > > > > compensation (and thus always get &bpf_fentry_test3), but this
> > > > > in-between solution seems to be the worst of both worlds?...
> > > > 
> > > > hm rigth, I guess we should be able to do that in bpf_get_func_ip,
> > > > I'll check
> > > 
> > > sorry for late follow up..
> > > 
> > > so the problem is that you can place kprobe anywhere in the function
> > > (on instruction boundary) but the IBT adjustment of kprobe address is
> > > made only if it's at the function entry and there's endbr instruction
> > 
> > To add more fun to the issue, not all non-inlined functions get endbr64. For
> > example "skb_release_head_state()" does, while "skb_free_head()" doesn't.
> 
> ah great.. thanks for info, will check

I checked with Peter and yes the endbr does not need to be there

<peterz> IBT is 'Indirect Branch Tracking' ENDBR needs to be at the target for "JMP *%reg" and "CALL *%reg"
<peterz> direct call/jmp don't need anything specal

so we will need to hold the +4 info somewhere for each address
and use that in get_func_ip helper or perhaps we could read
previous instruction and check if the previous instruction is
endbr with check like:

	if (is_endbr(*(u32 *)(addr - 4)))
		addr -= 4

jirka
