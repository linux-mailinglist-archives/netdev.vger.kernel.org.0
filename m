Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC8052F60F
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 01:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354004AbiETXRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 19:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238696AbiETXR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 19:17:28 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC785DBFE;
        Fri, 20 May 2022 16:17:28 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id z16so262727ilp.5;
        Fri, 20 May 2022 16:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hekv4PeSVxy3W9xeYUymMwFTkMHNpWijYPhHjrvNMUI=;
        b=WH75hysf+lIJsWaAMWYtK3N11JjMncKS4XPr0SkeHmLi5c086CqZUMqXFwpJAn/mX5
         HnZbkMRD8J55TA77KetrwP8nWmAL99eVqP1CpVEbA907mPIL4+OrEaRlxpfHPBG7rzgi
         e9msRuEfTLpcesCmAwATMBrAWQDXVLoQa/pZmCf2nD1yQ5r/aeRoKQnjGNawQb10R2F+
         Qq2qMZDeMpIAlO6E0+KRqrGzadzxogn2+v6YUZpll2qi8EThLK3EJohXtYaHMtq0bzzW
         HcsFghXXhJnOV+KCVLmZr0zfqOE3d9qR1DSXLb9BKPgpz9kx0tQidIWZ3WOT86xGREwm
         sZ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hekv4PeSVxy3W9xeYUymMwFTkMHNpWijYPhHjrvNMUI=;
        b=k/IrCbwwcDj33Rm0ndJ7Sn+0CPb2SPfj6I4zWDmhjoRjNCZqlxc3rScBlcdKIaOcn1
         +USOONxLrHtZy4EcDVYVABPs6hKpe131TiLwEJjXm+Pi9EUtFZKOqzKo7O5ojZftFPFa
         pobSRX5OUWYLtLVC0E4MVP8+kESnfCWTUc9TR01+QI8wmuLdtfOZ+CfmN77GCTj+dvLF
         xANKaht58ov2U9Xu4Hb5lOaZzlRetfS2QB8UC7tuJYJhGKZc7J2arIOG2SQk9yMMhltc
         Kz6fSq91CVs5m8XbZ1+M7dm7n3aBtTpPv6xXZYhafV/Y1SrHsX7+DV3XLFhi1SM84isL
         UIsA==
X-Gm-Message-State: AOAM533xnHZAlP51lh/WXmrk6coOChx0FMyqTi78l9YKebhauwhNjvR7
        o/D83VkdecM8LzAe1pUa4LTsbb7F6ctu7SShheA=
X-Google-Smtp-Source: ABdhPJyb64SU2/KV6+bw6hv/bp9Elt6G8EB8FgV2SGil7iJNDUEwT4twwjpxguzxDX/9p8TnBZ36kx/znvCJ+9LxLcQ=
X-Received: by 2002:a05:6e02:1a6e:b0:2d1:68e9:e8da with SMTP id
 w14-20020a056e021a6e00b002d168e9e8damr5025458ilv.252.1653088647462; Fri, 20
 May 2022 16:17:27 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1652772731.git.esyr@redhat.com> <6ef675aeeea442fa8fc168cd1cb4e4e474f65a3f.1652772731.git.esyr@redhat.com>
 <YoNnAgDsIWef82is@krava> <20220517123050.GA25149@asgard.redhat.com>
 <YoP/eEMqAn3sVFXf@krava> <7c5e64f2-f2cf-61b7-9231-fc267bf0f2d8@fb.com>
 <YoTXiAk1EpZ0rLKE@krava> <20220518123022.GA5425@asgard.redhat.com>
 <CAEf4BzbRYT4ykpxzXKGQ03REoVRKm_q8=oVEVCXfE+4zVDb=8A@mail.gmail.com> <20220519173359.GA7786@asgard.redhat.com>
In-Reply-To: <20220519173359.GA7786@asgard.redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 May 2022 16:16:57 -0700
Message-ID: <CAEf4BzYCU-jz9aks3q4Y+nvjkTyoqnW4CAL6KujioLOoAiJ3YA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/4] bpf_trace: pass array of u64 values in kprobe_multi.addrs
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Yonghong Song <yhs@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
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

On Thu, May 19, 2022 at 10:34 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
>
> On Wed, May 18, 2022 at 04:48:59PM -0700, Andrii Nakryiko wrote:
> > Not sure how you can do that without having extra test_progs variant
> > that's running in compat mode?
>
> I think, all bpf selftests are to be run in compat mode as well,
> now is a good time to enable this as any.
>

It's going to add a noticeable delay to CI runs, which is bad. Until
we have everything set up to run test_progs flavors in parallel,
adding compat flavor is not an option.
