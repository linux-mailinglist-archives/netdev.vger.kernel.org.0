Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479594FFE5A
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 21:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237882AbiDMTE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 15:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235870AbiDMTE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 15:04:56 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5297E3AA54;
        Wed, 13 Apr 2022 12:02:34 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id q11so2973588iod.6;
        Wed, 13 Apr 2022 12:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T6JBHLaRp43fUH1pYwkxzxzf65MlchD3sRrszybzOkc=;
        b=H46B3T4GmtvtRPKjAK5YgWvKtDxBv3aGmQPMgT7NpGK5ue1g+RK90/8js64F+NBuNN
         Y+DkeoOJ4vp87A6HeVp1J27qGcuTqkiAnOFrAyjwUw00IGfEK36s5rg/kwJLp+vsZ24p
         5FBPlPmMTE6JoPut3fXJ4WFqgtms2egMM7EGsL0qvRPpvWQGqWgjM2QbZifgoo+KxO7/
         vk6s61oL8ki7AShLN3lfrgfKPkCi4hX71Y9Sl3rwRHk8Ap3DWvS3CgVXkMyiS7UGc7BP
         az8O9OValgCsAqVqrpPfbOYGvvUN6qcLfw1wcJEXYIVlb+DXEtgJT8ZDSK95jp9jUZgx
         1V4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T6JBHLaRp43fUH1pYwkxzxzf65MlchD3sRrszybzOkc=;
        b=170nUIQLyHXdCDTkw3qE9jj1fR4A5vVJnjW+mIQFyFtfdZ1wGh4wOSfL/QakOl5WHk
         htWYIYMzCefyfGJjK2eVh+0SZvKPspWPSbbpwZIQqjscpvqKImCass0FLUh4PlIUq2md
         kHGIcYKhRRQBF5heKm5VNOXH2hyt72VVLgl/MehW4SAa1Xo6XP5h1RUw9W4/phwelI9O
         fLMq9ar09u2OpT0jpde90d+ScuQXbPv8vBrvlaKIznTvFn8T2OUjegciCABcsNQSbZ51
         QoSp/L497Qs3Jxzjj4HkR9XwY7BV1FPpjXkdfKUiIj/Bx5gEpbQVgggheXoEnUbRLdGo
         fdqg==
X-Gm-Message-State: AOAM531hqkpc1cE49N/ZFuxaReSsAYBhL0XxQJ9WsIOPtsI0vPQSe08g
        oAzgFqFHUb1Q9p+5+k2xaSqz1NkuC8RupF8paps=
X-Google-Smtp-Source: ABdhPJzTZRsB/jnz6Ppm+ksntTMFxjWE/fGG9w4L3FDRmI4tqWAMZAWvFv1c78nN3Fdfv9k2JL2xdcmKS5T6bOjkihM=
X-Received: by 2002:a05:6638:2642:b0:323:756f:42a7 with SMTP id
 n2-20020a056638264200b00323756f42a7mr21893821jat.145.1649876553767; Wed, 13
 Apr 2022 12:02:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220407125224.310255-1-jolsa@kernel.org> <20220407125224.310255-5-jolsa@kernel.org>
 <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com>
 <20220412094923.0abe90955e5db486b7bca279@kernel.org> <20220413124419.002abd87@rorschach.local.home>
 <CAEf4BzaA+vr6V24dG7JCHHmedp2TcJv4ZnuKB=zXzuOpi-QYFg@mail.gmail.com> <20220413125906.1689c3e2@rorschach.local.home>
In-Reply-To: <20220413125906.1689c3e2@rorschach.local.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Apr 2022 12:02:22 -0700
Message-ID: <CAEf4BzY0_39BMyFWH1VdqLAWUSuy4GSWPogqUNi-F0YkrhQ5=w@mail.gmail.com>
Subject: Re: [RFC bpf-next 4/4] selftests/bpf: Add attach bench test
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
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

On Wed, Apr 13, 2022 at 9:59 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 13 Apr 2022 09:45:52 -0700
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > > Did you only use the "notrace" on the prototype? I see the semicolon at
> > > the end of your comment. It only affects the actual function itself,
> > > not the prototype.
> >
> > notrace is both on declaration and on definition, see kernel/bpf/trampoline.c:
>
> OK. Note, it only needs to be on the function, the prototype doesn't do
> anything. But that shouldn't be the issue.
>
> >
> > void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr)
> > {
> >         percpu_ref_put(&tr->pcref);
> > }
> >
>
> What compiler are you using? as this seems to be a compiler bug.
> Because it's not ftrace that picks what functions to trace, but the
> compiler itself.

I build my local kernel with

$ gcc --version
gcc (GCC) 11.1.1 20210623 (Red Hat 11.1.1-6)


But we have the same issue in our production kernels which are most
probably built with some other version of GCC, but I don't know which
one.


>
> -- Steve
>
>
