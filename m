Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3D94854F7
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241043AbiAEOqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241016AbiAEOqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:46:02 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC07C061761;
        Wed,  5 Jan 2022 06:46:01 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id n30so50791111eda.13;
        Wed, 05 Jan 2022 06:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tsD8f9xe/yOoJyzdLoBuH5tO2pYgzHZZxGASx3vHHzc=;
        b=DIxyCLkUahoU3M+mxj7Jnpgjin2quX9tiF8LVbOUOS77Ig8gN6twbyS4ggZgDKGwJp
         dwkGGjW3obwD/nXAl0hnZuaSkAyRyIm6Q/zAsh7C6ny1yPDD/7J34wmIkTPHNo1qql1s
         dvzL6xD5oTQdr/sjbmnUrEtAVrxayDvnmxsqHER16jaMiuvuUIwAbXsXOONDIrhJCsIp
         I6kxo1XZvtJQBqbCavTxSwfjdZhQ11o3x9pGestofLnfbtNZ/rakyIqTAxat4QEYdYgw
         KqcYECfGxS0GD0mNf0eQHD9BMdD0AobA1c85F5puEmGmmeVzlMCPxJGnweKzBH8rvv+G
         ryDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tsD8f9xe/yOoJyzdLoBuH5tO2pYgzHZZxGASx3vHHzc=;
        b=mtKsuGnxc4uTtOEnEyCYOkivgzbw8y35mquhDeBk+S1MPtOqeaKY6qTKJ7vxV8ekWM
         VmQEHpYk72E5ikn9Mi7tIr/I9v5/lBdBSF16+MyJ4Rcj7DgI9DQ6p/kghWoQdZL3pitt
         pBrPFazOXXQTNg6jg1kkLjXvxknF46XZAyeNXKy15AaTSUXhJUlYGfka5zKUZTh5B9sT
         /ldOzYOl18+PtPuQ7JdrRauaHVGcqvXGDYCN4HY2TXq/8bgX4/7M1PRpICuPxIYfeR/4
         GNR5IQl/ZJdv/xMLJafsT2wMv7b5T9lUChosiyo8fe51434fmjMfu22w2NZA7G7d8pOZ
         jktA==
X-Gm-Message-State: AOAM5310caH8mf9ePnHPgtnovPqQdT9eVaoBE2Gq+mvLGaOmfIGpO2Eo
        sd268EnRGdYbzqfiGDUOCuHl3ewPHwfSj7yTN/s=
X-Google-Smtp-Source: ABdhPJzqdTl12XqIiJxzbnH7n36IgPGIQLTJWVcS4lHqMHrwIOSL3dEE9I5pAkIRrQootrBZoBpAV7jdyKZtXiGWL6g=
X-Received: by 2002:a05:6402:40cd:: with SMTP id z13mr52996828edb.103.1641393960293;
 Wed, 05 Jan 2022 06:46:00 -0800 (PST)
MIME-Version: 1.0
References: <20220105131849.2559506-1-imagedong@tencent.com>
 <20220105131849.2559506-3-imagedong@tencent.com> <CANn89iLMNK0Yo=5LmcV=NMLmAUEZsb1V__V5bY+ZNh347UE-xg@mail.gmail.com>
In-Reply-To: <CANn89iLMNK0Yo=5LmcV=NMLmAUEZsb1V__V5bY+ZNh347UE-xg@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 5 Jan 2022 22:45:48 +0800
Message-ID: <CADxym3YKfp5=oyJRyM9AVp8GW7+fLuboeW0gs-LagLDy+hfj_g@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 2/2] bpf: selftests: add bind retry for
 post_bind{4, 6}
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 5, 2022 at 9:57 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Jan 5, 2022 at 5:21 AM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > With previous patch, kernel is able to 'put_port' after sys_bind()
> > fails. Add the test for that case: rebind another port after
> > sys_bind() fails. If the bind success, it means previous bind
> > operation is already undoed.
> >
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  tools/testing/selftests/bpf/test_sock.c | 166 +++++++++++++++++++++---
> >  1 file changed, 146 insertions(+), 20 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_sock.c b/tools/testing/selftests/bpf/test_sock.c
> > index e8edd3dd3ec2..68525d68d4e5 100644
> > --- a/tools/testing/selftests/bpf/test_sock.c
> > +++ b/tools/testing/selftests/bpf/test_sock.c
> > @@ -35,12 +35,15 @@ struct sock_test {
> >         /* Endpoint to bind() to */
> >         const char *ip;
> >         unsigned short port;
> > +       unsigned short port_retry;
> >         /* Expected test result */
> >         enum {
> >                 LOAD_REJECT,
> >                 ATTACH_REJECT,
> >                 BIND_REJECT,
> >                 SUCCESS,
> > +               RETRY_SUCCESS,
> > +               RETRY_REJECT
> >         } result;
> >  };
> >
> > @@ -60,6 +63,7 @@ static struct sock_test tests[] = {
> >                 0,
> >                 NULL,
> >                 0,
> > +               0,
> >                 LOAD_REJECT,
> >         },
>
>
> I assume we tried C99 initializers here, and this failed for some reason ?
>

Yeah, C99 initializers should be a good choice here, therefore
I don't need to change every entry here after I add a new field to
'struct sock_test'.

I think C99 initializers should work here, I'll give it a try.

Thanks!
Menglong Dong

> diff --git a/tools/testing/selftests/bpf/test_sock.c
> b/tools/testing/selftests/bpf/test_sock.c
> index e8edd3dd3ec2..b57ce9f3eabf 100644
> --- a/tools/testing/selftests/bpf/test_sock.c
> +++ b/tools/testing/selftests/bpf/test_sock.c
> @@ -54,13 +54,13 @@ static struct sock_test tests[] = {
>                         BPF_MOV64_IMM(BPF_REG_0, 1),
>                         BPF_EXIT_INSN(),
>                 },
> -               BPF_CGROUP_INET4_POST_BIND,
> -               BPF_CGROUP_INET4_POST_BIND,
> -               0,
> -               0,
> -               NULL,
> -               0,
> -               LOAD_REJECT,
> +               .expected_attach_type = BPF_CGROUP_INET4_POST_BIND,
> +               .attach_type = BPF_CGROUP_INET4_POST_BIND,
> +               .domain = 0,
> +               .type = 0,
> +               .ip = NULL,
> +               .port = 0,
> +               .result = LOAD_REJECT,
>         },
>         {
>                 "bind4 load with invalid access: mark",
