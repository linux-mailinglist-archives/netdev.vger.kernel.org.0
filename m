Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6DD62A213
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 20:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbiKOTjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 14:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbiKOTj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 14:39:28 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6DA22B03;
        Tue, 15 Nov 2022 11:39:17 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id 136so14272481pga.1;
        Tue, 15 Nov 2022 11:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qH8eATSNEhYowGeu9g4jqYSSjClFtVibr4y+PP4MUWk=;
        b=hunhRnw215mH9phbmkHXWMhwIpSa13+JUliaS9yh+6opvI0yiN3bfJHo9QPHXmLTSg
         A3dbzCDcRZ4GIe2fbD3HrvdyKvU5gEom8uTlvqj1+50bVo1Vt12uT4ZM+kd2zUihPhNC
         etqAe4/2ndqj7fm4f2LTf06uVNywGMAvMRGi+QkFOqigpYh8upcB622irX0cjcaqbO6V
         GlEhT1O7/61cGLljTketNpZoMXd0wlaOa+s4btc2LHTlSgg6pHHOSLqQSEs3lzcqstwS
         mjCDT2tAksFLzoY8dVZTppHVHwmuL5395r1TfhOWiKLAHa8Y/tin0hMozVHf2L8QjSf3
         XKAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qH8eATSNEhYowGeu9g4jqYSSjClFtVibr4y+PP4MUWk=;
        b=SNoufT5L88hr74O6LEo0ZXWZP7Fs1oIFua8W3EA9SyZbbqqFwfOsaTdUS9Vs5SR+kc
         UGcXyrSP8+JM5QxljlnoX4N+XUNw02PeYqVD3UZY6O1yqKCm9zAJRo6rMfkPebJszwuS
         R3J6N6Al6KaE/tTTqVa+oIoSpRIjT2flSC4f9bABskTHvKrMyaOKPRr8Rrad573ct7ip
         glNbUhv0KtwUoO5mKtaNSHj3BGCtqg3bwNX5nYyLO+m6MC/7zW9unyGH0E8Y9Gd8l7NP
         LSbTJdLOATmiFuUNQOhQE+LTZGztIgMQfhJfaRzYWeH8pUfCbNjQAOLH7l0kjEB1jfHV
         J9Rw==
X-Gm-Message-State: ANoB5plvYNldM/fXc2RpTd8yGCVufHwnMKGF5ttwu4CPEeNZbOQtrXmR
        Ec0cBiVxk4mxWoSrfB5EUL8=
X-Google-Smtp-Source: AA0mqf4PIu0/zji++l195rCB9xgAKknUTVz1ZR8oTSR6Bjco75JgI/dVPE41kOyMxvWgcICgziIHRg==
X-Received: by 2002:a65:5908:0:b0:474:4380:cce8 with SMTP id f8-20020a655908000000b004744380cce8mr16989430pgu.557.1668541156622;
        Tue, 15 Nov 2022 11:39:16 -0800 (PST)
Received: from localhost ([14.96.13.220])
        by smtp.gmail.com with ESMTPSA id 124-20020a630482000000b004608b721dfesm8157930pge.38.2022.11.15.11.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 11:39:16 -0800 (PST)
Date:   Wed, 16 Nov 2022 01:09:11 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 3/3] bpf: Use 64-bit return value for
 bpf_prog_run
Message-ID: <20221115193911.u6prvskdzr5jevni@apollo>
References: <20221108140601.149971-1-toke@redhat.com>
 <20221108140601.149971-4-toke@redhat.com>
 <CAADnVQJjxdUAE6NHNtbbqVj3p3=8KsKrvRb3ShdYb9CcfVY8Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQJjxdUAE6NHNtbbqVj3p3=8KsKrvRb3ShdYb9CcfVY8Ow@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 10:39:04PM IST, Alexei Starovoitov wrote:
> On Tue, Nov 8, 2022 at 6:07 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >
> > From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> >
> > BPF ABI always uses 64-bit return value, but so far __bpf_prog_run and
> > higher level wrappers always truncated the return value to 32-bit. We
> > want to be able to introduce a new BPF program type that returns a
> > PTR_TO_BTF_ID or NULL from the BPF program to the caller context in the
> > kernel. To be able to use this returned pointer value, the bpf_prog_run
> > invocation needs to be able to return a 64-bit value, so update the
> > definitions to allow this.
>
> ...
>
> > -static __always_inline u32 __bpf_prog_run(const struct bpf_prog *prog,
> > +static __always_inline u64 __bpf_prog_run(const struct bpf_prog *prog,
> >                                           const void *ctx,
> >                                           bpf_dispatcher_fn dfunc)
> >  {
> > -       u32 ret;
> > +       u64 ret;
> >
> >         cant_migrate();
> >         if (static_branch_unlikely(&bpf_stats_enabled_key)) {
> > @@ -602,7 +602,7 @@ static __always_inline u32 __bpf_prog_run(const struct bpf_prog *prog,
> >         return ret;
> >  }
> >
> > -static __always_inline u32 bpf_prog_run(const struct bpf_prog *prog, const void *ctx)
> > +static __always_inline u64 bpf_prog_run(const struct bpf_prog *prog, const void *ctx)
> >  {
> >         return __bpf_prog_run(prog, ctx, bpf_dispatcher_nop_func);
> >  }
>
> I suspect 32-bit archs with JITs are partially broken with this change.
> As long as progs want to return pointers it's ok, but actual
> 64-bit values will be return garbage in upper 32-bit, since 32-bit
> JITs won't populate the upper bits.
> I don't think changing u32->long retval is a good idea either,
> since BPF ISA has to be stable regardless of underlying arch.
> The u32->u64 transition is good long term, but let's add
> full 64-bit tests to lib/test_bpf and fix JITs.
>

I will resubmit with these tests and revisiting the 32-bit JITs (but it will
take some time, since my backlog is full).
