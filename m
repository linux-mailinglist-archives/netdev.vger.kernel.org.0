Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8AF4FE97A
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 22:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbiDLUiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 16:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbiDLUhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 16:37:50 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A4EFABE6;
        Tue, 12 Apr 2022 13:32:29 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id k23so39570133ejd.3;
        Tue, 12 Apr 2022 13:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=m1dR6jtUuMTJiOEauYrZ+LgWz+ZA4crd9zsyU4t9Jps=;
        b=C8jkE0dJScs5ZfDVUMAGI83DPAYueYpncxIN1ENu5DuHkYvQ9fAArTRGRj0b8ZWZ87
         2SC+M2RWQN4eJa+rXcdScpp/hjgrX/t4r5l8fasRpp/XAGas5mJuLTP7JRJphIXcpOna
         ws9E1finUVliP65HHEAJi1tBBcdKru0m6IGFFVCOBZHY8gPiFC8H8U28PvHKYC0zEaQy
         YPg7gMES0WtfPA6Ig/jfJTIizEetGJZ+9x6z11VArTgg1OXOYDUR4Zo9vdZd9GM32GQD
         G20PPB06YLStneJ3/l3SVv6GkJ6rnyEiNWI/sCZTljqRukcSAfODyR04vGB2FFazZ/IS
         xAFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=m1dR6jtUuMTJiOEauYrZ+LgWz+ZA4crd9zsyU4t9Jps=;
        b=0hnMATVzMetvCuGHvTGPunNU+cMXCDkRPQDR4ppNzlvWuFrb82JY7uB2sjibmpG79s
         0Zusxz1lKzLskJ7Ap/tI+GCrrhd+kxeCN/3POcmT9DDzAwU4DCXS2tWlz334dPlKPpVM
         O/Vzaydp8GI24uiDguf5w2SpfyZGtYVhFAB3zQeYyOwhM8U8DwBWF2UoX3UowQEtg2g6
         56SLDJErxvFkNmzE1Bsy4QeM/p9Gi/8vOiIYAlqhgYR+y3/0qr+Gv1DRUOoKBuKzCWik
         b3ORdS86dO2Nu7tBKKqt3GTgYk88Z17ea44LoatYCmyqZ6XDoAGgkBgDGoT23x85qFfd
         XiHw==
X-Gm-Message-State: AOAM533ttoMGPCYSYE6qMAKBwaJMt8Lcr++w8lVg1aZCYYsgBTnBcAZL
        PZ5EmydDgT9UIljUifZ8LQg=
X-Google-Smtp-Source: ABdhPJzoqgZY1Fzi3tDWeNv95O5vo5WqtkWp4njg1R9WLNFOF0sChdYh4Zv3X10dQEpDaUUp9YkxUQ==
X-Received: by 2002:a17:907:7815:b0:6ce:5242:1280 with SMTP id la21-20020a170907781500b006ce52421280mr36153644ejc.217.1649795293117;
        Tue, 12 Apr 2022 13:28:13 -0700 (PDT)
Received: from krava ([83.240.62.142])
        by smtp.gmail.com with ESMTPSA id r3-20020aa7cb83000000b0041b573e2654sm210558edt.94.2022.04.12.13.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 13:28:12 -0700 (PDT)
Date:   Tue, 12 Apr 2022 22:28:09 +0200
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
Subject: Re: [RFC bpf-next 1/4] kallsyms: Add kallsyms_lookup_names function
Message-ID: <YlXg2SD4871l/uiW@krava>
References: <20220407125224.310255-1-jolsa@kernel.org>
 <20220407125224.310255-2-jolsa@kernel.org>
 <CAEf4BzYffXGFigxywjP391s4G=6VpykxaqD5OYuOR5mBRa1Tmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzYffXGFigxywjP391s4G=6VpykxaqD5OYuOR5mBRa1Tmw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 03:15:23PM -0700, Andrii Nakryiko wrote:

SNIP

> >  static inline int kallsyms_lookup_size_offset(unsigned long addr,
> >                                               unsigned long *symbolsize,
> >                                               unsigned long *offset)
> > diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> > index 79f2eb617a62..a3738ddf9e87 100644
> > --- a/kernel/kallsyms.c
> > +++ b/kernel/kallsyms.c
> > @@ -29,6 +29,8 @@
> >  #include <linux/compiler.h>
> >  #include <linux/module.h>
> >  #include <linux/kernel.h>
> > +#include <linux/bsearch.h>
> > +#include <linux/sort.h>
> >
> >  /*
> >   * These will be re-linked against their real values
> > @@ -572,6 +574,52 @@ int sprint_backtrace_build_id(char *buffer, unsigned long address)
> >         return __sprint_symbol(buffer, address, -1, 1, 1);
> >  }
> >
> > +static int symbols_cmp(const void *a, const void *b)
> 
> isn't this literally strcmp? Or compiler will actually complain about
> const void * vs const char *?

yes..

kernel/kallsyms.c: In function ‘kallsyms_callback’:
kernel/kallsyms.c:597:73: error: passing argument 5 of ‘bsearch’ from incompatible pointer type [-Werror=incompatible-pointer-types]
  597 |         if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), strcmp))
      |                                                                         ^~~~~~
      |                                                                         |
      |                                                                         int (*)(const char *, const char *)


> 
> > +{
> > +       const char **str_a = (const char **) a;
> > +       const char **str_b = (const char **) b;
> > +
> > +       return strcmp(*str_a, *str_b);
> > +}
> > +
> > +struct kallsyms_data {
> > +       unsigned long *addrs;
> > +       const char **syms;
> > +       u32 cnt;
> > +       u32 found;
> > +};
> > +
> > +static int kallsyms_callback(void *data, const char *name,
> > +                            struct module *mod, unsigned long addr)
> > +{
> > +       struct kallsyms_data *args = data;
> > +
> > +       if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
> > +               return 0;
> > +
> > +       addr = ftrace_location(addr);
> > +       if (!addr)
> > +               return 0;
> > +
> > +       args->addrs[args->found++] = addr;
> > +       return args->found == args->cnt ? 1 : 0;
> > +}
> > +
> > +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs)
> > +{
> > +       struct kallsyms_data args;
> > +
> > +       sort(syms, cnt, sizeof(*syms), symbols_cmp, NULL);
> > +
> > +       args.addrs = addrs;
> > +       args.syms = syms;
> > +       args.cnt = cnt;
> > +       args.found = 0;
> > +       kallsyms_on_each_symbol(kallsyms_callback, &args);
> > +
> > +       return args.found == args.cnt ? 0 : -EINVAL;
> 
> ESRCH or ENOENT makes a bit more sense as an error?

ok

jirka

> 
> 
> > +}
> > +
> >  /* To avoid using get_symbol_offset for every symbol, we carry prefix along. */
> >  struct kallsym_iter {
> >         loff_t pos;
> > --
> > 2.35.1
> >
