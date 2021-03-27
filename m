Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C7034B7EC
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 16:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhC0PTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 11:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhC0PTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 11:19:20 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EF0C0613B1;
        Sat, 27 Mar 2021 08:19:19 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 15so10868027ljj.0;
        Sat, 27 Mar 2021 08:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3nfaLcfvMwThD5Igi3QFoIdDn7FNudL9M+Vh7hiOmrk=;
        b=AzFAeYM8A8Dovwg96WQrnrrRON+5Qt+zy2GIt1lNc6QuTt+wecZpEBTGY3NCDiQapq
         6OD1okrvqen9EdIFeD7tY99IO/aQaT//OR2oL85CDX5SMJdXUvsI1Cfkl5xvXMSj7luu
         +evytWD6UeMFhj11pHYYCSY8+yPHozKwPgK0ImtWCX9jK4OshCrZmBiw/XLuFnogmoV6
         TXfSyX0Cgb6diM9upg8ZCaF61Jvqep17rNBFufjbRVXmIL0dAHPVzF/JwzL6mBqsN9Sr
         QTdD4mE9Ns0HgWbJqCAcRoJlKho9vUn9jgk88Z+Ebq0IklrVLEdaQwNJfpwf/YJpiLqm
         6Gag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3nfaLcfvMwThD5Igi3QFoIdDn7FNudL9M+Vh7hiOmrk=;
        b=d4sy42TkANsKdgvgME3QVdrJUsYbvS+lbZ5OsIChkQI875AFJbIqcVpOspeWyA1uh3
         qZH/V7qdRNPScYhZ1x0hF3OUOuEA/nYq3S5c+ni/5Dru5iyAMu/1mMpIM0RUgbNbY/44
         LN70ukiBeyB8nDXcRkN4lO14MghDZ0qz0lHuZBx+uSV8RO64mB1pNEte3y6x4A229+rN
         O0AqhCArhZLkktzXrcsbCcrX2uTA/cbE4pHZDcRXfBeR7AX0yO+FHPM6UF/KvLFPcKO3
         /6lGjf4Dtf5jvv61kP+Gs1+/SfyF5IDeChYTFmdy8FoRkXS1FqZ/dueMNGq6ZVlhBPdw
         /jmA==
X-Gm-Message-State: AOAM530ptqmv8LZ1wEAJOAYByzwDJ5aUd3nkCSjb4zyzBOVBFExsW3O7
        4+uWiF6hJH5Tr0qvSozaEyVdOUsmu0dkapM++iI=
X-Google-Smtp-Source: ABdhPJy63BovyFWUJnSqBVb0vWcgYhq5W1RXGYmt0KvG2Hv8I1ZBgzIHzK5m/eq2Pafzgy8+CNWl9uCmpe3aNo4qT54=
X-Received: by 2002:a2e:3608:: with SMTP id d8mr12475794lja.21.1616858358350;
 Sat, 27 Mar 2021 08:19:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210326124030.1138964-1-Jianlin.Lv@arm.com> <CAADnVQ+W79=L=jb0hcOa4E067_PnWbnWHdxqyw-9+Nz9wKkOCA@mail.gmail.com>
 <AM6PR08MB3589CCA99AEF14F9B610A70E98609@AM6PR08MB3589.eurprd08.prod.outlook.com>
In-Reply-To: <AM6PR08MB3589CCA99AEF14F9B610A70E98609@AM6PR08MB3589.eurprd08.prod.outlook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 27 Mar 2021 08:19:07 -0700
Message-ID: <CAADnVQJsG-c+AdpwS6xTCwZq4-uVoPH7FZ8CV_XCA-+QaCKA8g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: trace jit code when enable BPF_JIT_ALWAYS_ON
To:     Jianlin Lv <Jianlin.Lv@arm.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrey Ignatov <rdna@fb.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Mahesh Bandewar <maheshb@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "iecedge@gmail.com" <iecedge@gmail.com>, nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 27, 2021 at 1:19 AM Jianlin Lv <Jianlin.Lv@arm.com> wrote:
>
> > On Fri, Mar 26, 2021 at 5:40 AM Jianlin Lv <Jianlin.Lv@arm.com> wrote:
> > >
> > > When CONFIG_BPF_JIT_ALWAYS_ON is enabled, the value of
> > bpf_jit_enable
> > > in /proc/sys is limited to SYSCTL_ONE. This is not convenient for deb=
ugging.
> > > This patch modifies the value of extra2 (max) to 2 that support
> > > developers to emit traces on kernel log.
> > >
> > > Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
> > > ---
> > >  net/core/sysctl_net_core.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> > > index d84c8a1b280e..aa16883ac445 100644
> > > --- a/net/core/sysctl_net_core.c
> > > +++ b/net/core/sysctl_net_core.c
> > > @@ -386,7 +386,7 @@ static struct ctl_table net_core_table[] =3D {
> > >                 .proc_handler   =3D proc_dointvec_minmax_bpf_enable,
> > >  # ifdef CONFIG_BPF_JIT_ALWAYS_ON
> > >                 .extra1         =3D SYSCTL_ONE,
> > > -               .extra2         =3D SYSCTL_ONE,
> > > +               .extra2         =3D &two,
> >
> > "bpftool prog dump jited" is much better way to examine JITed dumps.
> > I'd rather remove bpf_jit_enable=3D2 altogether.
>
> In my case, I introduced a bug when I made some adjustments to the arm64
> jit macro A64_MOV(), which caused the SP register to be replaced by the
> XZR register when building prologue, and the wrong value was stored in fp=
,
> which triggered a crash.
>
> This bug is likely to cause the instruction to access the BPF stack in
> jited prog to trigger a crash.
> I tried to use bpftool to debug, but bpftool crashed when I executed the
> "bpftool prog show" command.
> The syslog shown that bpftool is loading and running some bpf prog.
> because of the bug in the JIT compiler, the bpftool execution failed.

Right 'bpftool prog show' command is loading a bpf iterator prog,
but you didn't need to use it to dump JITed code.
"bpftool prog dump jited name my_prog"
would have dumped it even when JIT is all buggy.

> bpf_jit_disasm saved me, it helped me dump the jited image:
>
> echo 2> /proc/sys/net/core/bpf_jit_enable
> modprobe test_bpf test_name=3D"SPILL_FILL"
> ./bpf_jit_disasm -o
>
> So keeping bpf_jit_enable=3D2 is still very meaningful for developers who
> try to modify the JIT compiler.

sure and such JIT developers can compile the kernel
without BPF_JIT_ALWAYS_ON just like you did.
They can also insert printk, etc.
bpf_jit_enable=3D2 was done long ago when there was no other way
to see JITed code. Now we have proper apis.
That =3D2 mode can and should be removed.

> IMPORTANT NOTICE: The contents of this email and any attachments are conf=
idential and may also be privileged. If you are not the intended recipient,=
 please notify the sender immediately and do not disclose the contents to a=
ny other person, use it for any purpose, or store or copy the information i=
n any medium. Thank you.

please fix your email server/client/whatever. No patches will ever be
accepted with
such disclaimer.
