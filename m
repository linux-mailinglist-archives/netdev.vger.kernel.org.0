Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C3850F196
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343558AbiDZHCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 03:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343552AbiDZHB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 03:01:59 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5575E75C;
        Mon, 25 Apr 2022 23:58:52 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id p18so15943464edr.7;
        Mon, 25 Apr 2022 23:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yxsoS2CUH057OgoeUtgShEMwX7cTwqJSCWC/gaZwK0I=;
        b=A1aM1LlAjf1IMw4G9HEuNjbi4D7I+HFmR8T6RmCSJ69tAIQIK+pPMaw3qlazyDPaqE
         Kz1/FIWsRmJwqIulA18lq/IRAg2HcZMT+4ZDvZ+7OtSK+YBJ7OYzVovTc080hDflzJj/
         aF7vu2x/j42V7qesnWKm4/TkwiK4PoSoGsExRByx7nWcm91svjNPUIm8UFrmijglCGbV
         5ygsReqvWjruzoiMp2Ou9gKZgsYttIIp4ysC9+CxDzt38IIBF7x8DTDYWxBwGB2i3b0N
         AATa68aC1trnVFaAUot4sF/7s4l7DVDLMEIOmy0gzkGW/ncRZSQJeOqapwpdFAWzYewT
         IypQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yxsoS2CUH057OgoeUtgShEMwX7cTwqJSCWC/gaZwK0I=;
        b=KmcMR+ibf+b7jp43yBtHdVXC1leMHdn1Rw+cnLalwuvR4xCWA5OqsQELcCU6Vh0Kno
         uw2EeHChlzASMWrf4dGDPWM0eAzAWhTNthKVLBWCRPBtxctGvHq46rp9p+NZfk3+cIUR
         7IZkVkahhvcJMAZS5SZ/3Q3p6KNHvGHWTr3E9rjKt1zGz4dPNBnZQC0bt4URF38fLn/n
         YqyPLaojbRvN8BScDZk2M9qQayegfpHlJyTKAucegli4dBMQJ3romWqOwpY62IKRLZdR
         Uklw83Bbnw+5jBYWrN8jG8DqlNQJAo1amowbnQ6YjAJA7KqSy8/fMW35Xtu137IcRLwg
         lOlA==
X-Gm-Message-State: AOAM531VMltiL03ARDUUaVrZlwAed+d5uPWOQC9+OsRavkxYwaSN6Bau
        F0PEu2pU9IF9Ovcb24AuYaI=
X-Google-Smtp-Source: ABdhPJy9DVgQMKYjhhKIJjro1taMS4ALKtZnjvRiwS92h4P5D0LWE441zR3aEgyOHrbKXjo1t0vdjw==
X-Received: by 2002:a05:6402:485:b0:425:a529:c29e with SMTP id k5-20020a056402048500b00425a529c29emr23024791edv.354.1650956330863;
        Mon, 25 Apr 2022 23:58:50 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id g21-20020a056402115500b00413c824e422sm5529594edw.72.2022.04.25.23.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 23:58:50 -0700 (PDT)
Date:   Tue, 26 Apr 2022 08:58:48 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: Re: [PATCH perf/core 4/5] perf tools: Register perfkprobe libbpf
 section handler
Message-ID: <YmeYKMixL+jvTNq9@krava>
References: <20220422100025.1469207-1-jolsa@kernel.org>
 <20220422100025.1469207-5-jolsa@kernel.org>
 <CAEf4BzaGLRYiQtT4_HV1ntAV0Br2yyRo5sZiebVAt9QJ8WVF5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaGLRYiQtT4_HV1ntAV0Br2yyRo5sZiebVAt9QJ8WVF5g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 11:22:54PM -0700, Andrii Nakryiko wrote:
> On Fri, Apr 22, 2022 at 3:01 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Perf is using section name to declare special kprobe arguments,
> > which no longer works with current libbpf, that either requires
> > certain form of the section name or allows to register custom
> > handler.
> >
> > Adding support for 'perfkprobe/' section name handler to take
> > care of perf kprobe programs.
> >
> > The handler servers two purposes:
> >   - allows perf programs to have special arguments in section name
> >   - allows perf to use pre-load callback where we can attach init
> >     code (zeroing all argument registers) to each perf program
> >
> > The second is essential part of new prologue generation code,
> > that's coming in following patch.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/perf/util/bpf-loader.c | 50 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 50 insertions(+)
> >
> > diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
> > index f8ad581ea247..92dd8cc18edb 100644
> > --- a/tools/perf/util/bpf-loader.c
> > +++ b/tools/perf/util/bpf-loader.c
> > @@ -86,6 +86,7 @@ bpf_perf_object__next(struct bpf_perf_object *prev)
> >              (perf_obj) = (tmp), (tmp) = bpf_perf_object__next(tmp))
> >
> >  static bool libbpf_initialized;
> > +static int libbpf_sec_handler;
> >
> >  static int bpf_perf_object__add(struct bpf_object *obj)
> >  {
> > @@ -99,12 +100,61 @@ static int bpf_perf_object__add(struct bpf_object *obj)
> >         return perf_obj ? 0 : -ENOMEM;
> >  }
> >
> > +static struct bpf_insn prologue_init_insn[] = {
> > +       BPF_MOV64_IMM(BPF_REG_0, 0),
> > +       BPF_MOV64_IMM(BPF_REG_1, 0),
> > +       BPF_MOV64_IMM(BPF_REG_2, 0),
> > +       BPF_MOV64_IMM(BPF_REG_3, 0),
> > +       BPF_MOV64_IMM(BPF_REG_4, 0),
> > +       BPF_MOV64_IMM(BPF_REG_5, 0),
> > +};
> > +
> > +#define LIBBPF_SEC_PREFIX "perfkprobe/"
> 
> libbpf allows to register fallback handler that will handle any SEC()
> definition besides the ones that libbpf handles. Would that work in
> this case instead of adding a custom prefix handler here? See
> prog_tests/custom_sec_handlers.c for example:
> 
> fallback_id = libbpf_register_prog_handler(NULL,
> BPF_PROG_TYPE_SYSCALL, 0, &opts);

nice, I did not see that.. that should be better, no need for the prefix

thanks,
jirka
