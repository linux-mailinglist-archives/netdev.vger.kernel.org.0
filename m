Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0FD4CEC79
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 18:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiCFR3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 12:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCFR3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 12:29:44 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037CE2613C;
        Sun,  6 Mar 2022 09:28:52 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id i8so19909632wrr.8;
        Sun, 06 Mar 2022 09:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W4/OOhsYIUeVHmDM2SWsQOWi+B+oFhl/nI7c5RX4BKk=;
        b=k/G44Yt5DvmreJLgQI3GuAgC3wsb0j+ZJByjP5drkWfERt+YNmstc2W0TTfGm1HxVS
         3G2VKahdAIEqjtFVK8rujNynCstafulKqH5XtTZLRa2c6jHvSy8v2dPBRKV6QQXkYQ3t
         HKbY5GdjOKvLFJVrFe6Efa+7pU/nGCOYrS7KHCVzgfmswKjplqS6URV2g8GGrcLa9zpj
         R7IQevo1KkJxzjSkaeFTWrL3zhA4t4U08BGo4Gc6FJ0b7JMOQaFifVg2IloQy25BDbNa
         40z9Fq8Ra6Lwt3zV74EBEpiLTaDUjePKwn647y5A4ALQb/qSEJxVN1/E7tOCd2ZcgRPC
         GJfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W4/OOhsYIUeVHmDM2SWsQOWi+B+oFhl/nI7c5RX4BKk=;
        b=pj0MLWLtI54fvuJ6xwrH1x86zH3Rc2ikwlve36eTh8H1dCNfRRZt9bSH1jQlZBC5pu
         39ptICXuOu0PCcskP88zzO+ib2mCKlHnV2K8UnlAtr/8lT9cj88mARKAbbNtdLMlRSFM
         iUM9G4p9olUOBLT5S9by7snOeIEFrbxS9Na2LYPQRz8pRozhpCi/kexSoVA82rkkZODI
         QuxW4ZcFgNmwwuZZm+RvmNcYPGQg7BL/5SyKv+FvqrN1tr0SK0GNPVKJ0cNlWxZsHo/V
         sKmXRYASmOXx0tvpCj1Fc7x76KN2mGwMwV7yiyPz4VJk8FBRbZ6cUSwTZUhOnptlUZEb
         HPBQ==
X-Gm-Message-State: AOAM533P2h4T3ZOCKW3B4UBEiq4H743RfIrIBt9YDZcLzEYHcZSZtlws
        8ksB33O5nLuZb18XCE1aN7o=
X-Google-Smtp-Source: ABdhPJy6IOIefZKEVLH85QOwAx1WyN/ui30/FZc13mqplCcQ42ZblD13664bXrW0hVvc2oia4b/ALg==
X-Received: by 2002:a5d:648f:0:b0:1f0:567b:5619 with SMTP id o15-20020a5d648f000000b001f0567b5619mr5581201wri.66.1646587730449;
        Sun, 06 Mar 2022 09:28:50 -0800 (PST)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id l5-20020a5d6745000000b001f1e4e40e42sm3504346wrw.77.2022.03.06.09.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 09:28:50 -0800 (PST)
Date:   Sun, 6 Mar 2022 18:28:47 +0100
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
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 02/10] bpf: Add multi kprobe link
Message-ID: <YiTvT0nyWLDvFya+@krava>
References: <20220222170600.611515-1-jolsa@kernel.org>
 <20220222170600.611515-3-jolsa@kernel.org>
 <CAEf4BzadsmOTas7BdF-J+de7AqsoccY1o6e0pUBkRuWH+53DiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzadsmOTas7BdF-J+de7AqsoccY1o6e0pUBkRuWH+53DiQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 03:11:01PM -0800, Andrii Nakryiko wrote:

SNIP

> > +static int
> > +kprobe_multi_resolve_syms(const void *usyms, u32 cnt,
> > +                         unsigned long *addrs)
> > +{
> > +       unsigned long addr, size;
> > +       const char **syms;
> > +       int err = -ENOMEM;
> > +       unsigned int i;
> > +       char *func;
> > +
> > +       size = cnt * sizeof(*syms);
> > +       syms = kvzalloc(size, GFP_KERNEL);
> > +       if (!syms)
> > +               return -ENOMEM;
> > +
> > +       func = kmalloc(KSYM_NAME_LEN, GFP_KERNEL);
> > +       if (!func)
> > +               goto error;
> > +
> > +       if (copy_from_user(syms, usyms, size)) {
> > +               err = -EFAULT;
> > +               goto error;
> > +       }
> > +
> > +       for (i = 0; i < cnt; i++) {
> > +               err = strncpy_from_user(func, syms[i], KSYM_NAME_LEN);
> > +               if (err == KSYM_NAME_LEN)
> > +                       err = -E2BIG;
> > +               if (err < 0)
> > +                       goto error;
> > +
> > +               err = -EINVAL;
> > +               if (func[0] == '\0')
> > +                       goto error;
> 
> wouldn't empty string be handled by kallsyms_lookup_name?

it would scan and compare all symbols with empty string,
so it's better to test for it

jirka

> 
> > +               addr = kallsyms_lookup_name(func);
> > +               if (!addr)
> > +                       goto error;
> > +               if (!kallsyms_lookup_size_offset(addr, &size, NULL))
> > +                       size = MCOUNT_INSN_SIZE;
> > +               addr = ftrace_location_range(addr, addr + size - 1);
> > +               if (!addr)
> > +                       goto error;
> > +               addrs[i] = addr;
> > +       }
> > +
> > +       err = 0;
> > +error:
> > +       kvfree(syms);
> > +       kfree(func);
> > +       return err;
> > +}
> > +
> 
> [...]
