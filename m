Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3572154201F
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349492AbiFHARK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390694AbiFGWzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 18:55:10 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7902FCB48;
        Tue,  7 Jun 2022 12:56:02 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id n10so37357004ejk.5;
        Tue, 07 Jun 2022 12:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AzG944M7Q+QdZRVrg3uoX9H8fss9xlzIVhvRVcj+Xxk=;
        b=qCdJLf0gqFOVWjVnO8oDc3EOsx2BPC/bihsg/OyUd2KQS4jOTfaPb8xU99cRETstKT
         hGPDO78M9DqKlNlKA5oivoZGj7FkgiIua7m7moHiIYp2qudjKPD4KpgwYde/OGXs1YKj
         hzYEbbebe1tlRf1F55bZc9ceDc97W19sSXHgV43Jy2lVk05PfnCQxqGb2ht9So+5nZPJ
         Txnt8W0kYDnEidiKjV4AP1R4BhDaLQkWtloPowW4S1+c5UfdPgK4lJoGn/CRAlEeFuEG
         vMJGpYsq3kdowizns7xYdkCACj0J6Hxv8Q8aonGz35/iA/C9axz8qmuzivFjRY7ImMJ/
         dYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AzG944M7Q+QdZRVrg3uoX9H8fss9xlzIVhvRVcj+Xxk=;
        b=bD6lfEPceOJQeL3JcMK4ejFnrHPbazFzjVPCjwyche3TeXTTltXc2Obq2sCaexOIrx
         m/99Ko3gsyCO2CamWoF2ejOCcig9ajgH9YcPiplMascroz951jePAQEM6RtX+mU4GwkA
         zuONv/Ph6lIFhMosUw96xrBE1o3euX/VUf4679DWcxwNWwhfF3hyggSk3zBe0IyguuWv
         0XC9lfVKFJj+62O0qhaSvVfuRiBubCO0biDaOK27Tj3Orw5dV0e2qZF0TBj12Ft8xl6H
         G8GLWuCLOg3ncWBT0Gv1M83dkC7wbrKtsA4ad9JSBuptpqAv2EIWnHZQSf/s0HUlkB0H
         WJbA==
X-Gm-Message-State: AOAM531mbC6WiKxeHGhikA1EOx9VwnUm1H97ZZ7/LKyg81W/2r1mNc93
        b5jy/5ve3AB+eXHjqABE0eY=
X-Google-Smtp-Source: ABdhPJxLB07Hd+oSB65fjGf3cd4TpJKDXbD7y52i3IOIXwqAKUeDpW6fl+UDsMFPzoG+hpPZK78p2Q==
X-Received: by 2002:a17:907:162c:b0:6fe:d93d:21a3 with SMTP id hb44-20020a170907162c00b006fed93d21a3mr28316492ejc.596.1654631760907;
        Tue, 07 Jun 2022 12:56:00 -0700 (PDT)
Received: from krava ([83.240.60.46])
        by smtp.gmail.com with ESMTPSA id f27-20020a17090624db00b006f3ef214dcdsm8177827ejb.51.2022.06.07.12.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 12:56:00 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 7 Jun 2022 21:55:58 +0200
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCHv2 bpf 3/3] bpf: Force cookies array to follow symbols
 sorting
Message-ID: <Yp+tTsqPOuVdjpba@krava>
References: <20220606184731.437300-1-jolsa@kernel.org>
 <20220606184731.437300-4-jolsa@kernel.org>
 <CAADnVQJA54Ra8+tV0e0KwSXAg93JRoiefDXWR-Lqatya5YWKpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJA54Ra8+tV0e0KwSXAg93JRoiefDXWR-Lqatya5YWKpg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 11:40:47AM -0700, Alexei Starovoitov wrote:
> On Mon, Jun 6, 2022 at 11:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > When user specifies symbols and cookies for kprobe_multi link
> > interface it's very likely the cookies will be misplaced and
> > returned to wrong functions (via get_attach_cookie helper).
> >
> > The reason is that to resolve the provided functions we sort
> > them before passing them to ftrace_lookup_symbols, but we do
> > not do the same sort on the cookie values.
> >
> > Fixing this by using sort_r function with custom swap callback
> > that swaps cookie values as well.
> >
> > Fixes: 0236fec57a15 ("bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link")
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> It looks good, but something in this patch is causing a regression:
> ./test_progs -t kprobe_multi
> test_kprobe_multi_test:PASS:load_kallsyms 0 nsec
> #80/1    kprobe_multi_test/skel_api:OK
> #80/2    kprobe_multi_test/link_api_addrs:OK
> #80/3    kprobe_multi_test/link_api_syms:OK
> #80/4    kprobe_multi_test/attach_api_pattern:OK
> #80/5    kprobe_multi_test/attach_api_addrs:OK
> #80/6    kprobe_multi_test/attach_api_syms:OK
> #80/7    kprobe_multi_test/attach_api_fails:OK
> test_bench_attach:PASS:get_syms 0 nsec
> test_bench_attach:PASS:kprobe_multi_empty__open_and_load 0 nsec
> libbpf: prog 'test_kprobe_empty': failed to attach: No such process
> test_bench_attach:FAIL:bpf_program__attach_kprobe_multi_opts
> unexpected error: -3
> #80/8    kprobe_multi_test/bench_attach:FAIL
> #80      kprobe_multi_test:FAIL

looks like kallsyms search failed to find some symbol,
but I can't reproduce with:

  ./vmtest.sh -- ./test_progs -t kprobe_multi

can you share .config you used?

thanks,
jirka

> 
> CI is unfortunately green, because we don't run it there:
> #80/1 kprobe_multi_test/skel_api:OK
> #80/2 kprobe_multi_test/link_api_addrs:OK
> #80/3 kprobe_multi_test/link_api_syms:OK
> #80/4 kprobe_multi_test/attach_api_pattern:OK
> #80/5 kprobe_multi_test/attach_api_addrs:OK
> #80/6 kprobe_multi_test/attach_api_syms:OK
> #80/7 kprobe_multi_test/attach_api_fails:OK
> #80 kprobe_multi_test:OK
