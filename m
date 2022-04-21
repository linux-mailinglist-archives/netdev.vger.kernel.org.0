Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2EBA509870
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 09:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385467AbiDUG7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 02:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385464AbiDUG7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 02:59:20 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E791582C;
        Wed, 20 Apr 2022 23:56:31 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id k22so5272546wrd.2;
        Wed, 20 Apr 2022 23:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PMcv2vjMUzwczrQYsKN+kw5OQQ/UjaS2R/dcykc8xFg=;
        b=IshB+dnedMBwSej+YQ79VoKemg7w1sJXget+/jlAu6TnYws///3Jj0sZGQlw8GwxVr
         CORGdZTubBRfiycG8ReL2YX0BCt4EOxpESvpGsGPavKUCR4ysBOl8F2+31NMm8SZsaoT
         RuRxAeH0NELu96+xrOIhKJXvTVRi+EubtgegIFm3xe8RRYQGv0/Yfiai+J8DASissvLB
         0hM7zxYts4QDNmLS+vKKhytArYFpBlfDdZK9EvwWGEPzHRsKNngnl5tl/o6WAlYJa5eA
         gmdvP30t1Pd3HASfFwKFaWiasVZn4NIEl4cKRQvbWBASXmjbZLGWo1NrCWorOxEfTfLn
         ZP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PMcv2vjMUzwczrQYsKN+kw5OQQ/UjaS2R/dcykc8xFg=;
        b=fkgniZ9CMWyqZSKC9lSRySl40XJ6EwYslKAynR2raSKoHcBye75JDJNbSkB5GchpIR
         HTc8McFT4Sw2y0r3TaqOA9d4j4imCe5EAbtV+SY5V/KRH/Zv7uXO9w+MSoqoF3CJrHtl
         v5ja9DLqRti1OYDdvKlOFcobmjXkgB2HEFyGEquz0uHMOfnQmD2xecX5FNOECYuJT67q
         /5rSthju2wX1ubSOdu0UZRLfliYO3Am/XCtomYZJXD6wBJMNlCKVO2UyHFKvKt1iNI3W
         FPPhSCygZwV1bYvQZEL0RrPr1tF+gBQIM8I+D943IkRw+MuBgCW18ieTLAajGi1aQIQ+
         lqIg==
X-Gm-Message-State: AOAM532YejFvYFTNFJwkR3FLaFcSM/308rcECCfpwzTFAZ2zC6jnM84o
        F3GgDQJhoO3zEtGOW+7N/noSsN5NLeU6R82i
X-Google-Smtp-Source: ABdhPJy+U9hILKyrD+kgqCMLYoMz6ua57rn5c3tUrz+cx0GY9GA70N0oNJND5CUv1zl3KOtCSgCDPg==
X-Received: by 2002:a5d:6104:0:b0:20a:b027:dc3f with SMTP id v4-20020a5d6104000000b0020ab027dc3fmr4584122wrt.94.1650524190065;
        Wed, 20 Apr 2022 23:56:30 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id k65-20020a1ca144000000b003929a64ab63sm1264902wme.38.2022.04.20.23.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 23:56:29 -0700 (PDT)
Date:   Thu, 21 Apr 2022 08:56:26 +0200
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
Subject: Re: [PATCHv2 bpf-next 4/4] selftests/bpf: Add attach bench test
Message-ID: <YmEAGhGVhyiHBQ3S@krava>
References: <20220418124834.829064-1-jolsa@kernel.org>
 <20220418124834.829064-5-jolsa@kernel.org>
 <CAEf4BzYuvLgVtxbtz7pjCmtSp0hEKJd0peCnbX0E_-Tqy5g4dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYuvLgVtxbtz7pjCmtSp0hEKJd0peCnbX0E_-Tqy5g4dw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 02:56:53PM -0700, Andrii Nakryiko wrote:

SNIP

> > +#define DEBUGFS "/sys/kernel/debug/tracing/"
> > +
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
> nit: DEBUGFS "constant" just makes it harder to follow the code and
> doesn't add anything, please just use the full path here directly

there's another one DEBUGFS in trace_helpers.c,
we could put it in trace_helpers.h

> 
> > +       if (!f)
> > +               return -EINVAL;
> > +
> > +       map = hashmap__new(symbol_hash, symbol_equal, NULL);
> > +       err = libbpf_get_error(map);
> 
> hashmap__new() is an internal API, so please use IS_ERR() directly
> here. libbpf_get_error() should be used for public libbpf APIs, and
> preferably not in libbpf 1.0 mode

ok

> 
> > +       if (err)
> > +               goto error;
> > +
> > +       while (fgets(buf, sizeof(buf), f)) {
> > +               /* skip modules */
> > +               if (strchr(buf, '['))
> > +                       continue;
> 
> [...]
> 
> > +       attach_delta = (attach_end_ns - attach_start_ns) / 1000000000.0;
> > +       detach_delta = (detach_end_ns - detach_start_ns) / 1000000000.0;
> > +
> > +       fprintf(stderr, "%s: found %lu functions\n", __func__, cnt);
> > +       fprintf(stderr, "%s: attached in %7.3lfs\n", __func__, attach_delta);
> > +       fprintf(stderr, "%s: detached in %7.3lfs\n", __func__, detach_delta);
> 
> 
> why stderr? just do printf() and let test_progs handle output

ok

> 
> 
> > +
> > +cleanup:
> > +       kprobe_multi_empty__destroy(skel);
> > +       if (syms) {
> > +               for (i = 0; i < cnt; i++)
> > +                       free(syms[i]);
> > +               free(syms);
> > +       }
> > +}
> > +
> >  void test_kprobe_multi_test(void)
> >  {
> >         if (!ASSERT_OK(load_kallsyms(), "load_kallsyms"))
> > @@ -320,4 +454,6 @@ void test_kprobe_multi_test(void)
> >                 test_attach_api_syms();
> >         if (test__start_subtest("attach_api_fails"))
> >                 test_attach_api_fails();
> > +       if (test__start_subtest("bench_attach"))
> > +               test_bench_attach();
> >  }
> > diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi_empty.c b/tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
> > new file mode 100644
> > index 000000000000..be9e3d891d46
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
> > @@ -0,0 +1,12 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_tracing.h>
> > +
> > +char _license[] SEC("license") = "GPL";
> > +
> > +SEC("kprobe.multi/*")
> 
> use SEC("kprobe.multi") to make it clear that we are attaching it "manually"?

yep, will do

thanks,
jirka
