Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F75B6BEE3C
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjCQQ2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjCQQ2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:28:49 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB0510A9C;
        Fri, 17 Mar 2023 09:28:42 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x13so22656491edd.1;
        Fri, 17 Mar 2023 09:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679070521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=74EL4TBuCVmFpQQhUt5n0awpVLMK7sULp4bcds7EKs8=;
        b=R/Hut9Ov688CKlFGwrRiv8D+eLnunyvxfuh5/DECp28ocLpGJ1/bRqNXXPnwmRq3C7
         71s13dmz9Az1l3Fp0qVGUMDFOHJydzyv2HBs/ukQ2NkQI7MxvqlSz2Aoyc7K5z5UlYUu
         128gnrW3jmTgy3JXJHMty1DqddSs9M4ohuWlG8DQLAZdVaJX96j6CRuECKDp3z7MsNBj
         VchMJG8Nfgd/3+7VCuYt/+qDmKfA8nonMjj67aP9c2WxHPauXS07xFtA6onm2NDHZ980
         lYZ0VDhzfNa+xCrsnNiClDLFokX7IZQnNqW3LgaNAQpbabqurt/YCR22eUmLHzEVfK7X
         Uukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679070521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=74EL4TBuCVmFpQQhUt5n0awpVLMK7sULp4bcds7EKs8=;
        b=c/6EpspeIjfI/leSvuzKRS8N8fYJzRoc8e9+CkuGSWXo7MnJSVvoKQSl7kXWEoeEK0
         PtokdNeOJ7/dMLHyiuhHevLY2TyDqdTqTF3ugfbYAWi8K24jzNsokeXrBWtVfhlo+39P
         H2yeYOL3d141TtkzaiA7ltNLahaSGa7mXaXHCHyf4+CLaCx8r0t44nSMW5r156JG9DPs
         q22OngJcpe6iaZH6r389cyFlffy9QFAm96ukM6saHlU+y56FcHmJ5P/uZjHqsKDk5bD3
         BmGqd+ikpy7wnJqMZbERTkcPtaaCYa7LzS5SUXxHAvcW3GnA+NayUUThKgaO0EfQ++/B
         faXQ==
X-Gm-Message-State: AO0yUKWB09pX1r4MXxvPC2M88+ioZZKgENTrQmDxTIa1M7DluGdMyEM6
        LJuT12T9cFpRrPyZiUDeMvGC4HfGNweemo6aB8A=
X-Google-Smtp-Source: AK7set8HkhIwAhKduIxQa3C3vFwR7I5DA0meAYnsoM+1foV2+YzjrnpGgSMtCLVvXY0yZvhqHoiMWkx7QMPHumvkuiE=
X-Received: by 2002:a17:906:c7ca:b0:922:26ae:c68c with SMTP id
 dc10-20020a170906c7ca00b0092226aec68cmr75967ejb.5.1679070520950; Fri, 17 Mar
 2023 09:28:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
 <20230315223607.50803-2-alexei.starovoitov@gmail.com> <CAEf4BzaSMB6oKBO2VXvz4cVE9wXqYq+vyD=EOe3YJ3a-L==WCg@mail.gmail.com>
 <CAADnVQLud8-+pexQo8rscVM2d8K2dsYU1rJbFGK2ZZygdAgkQA@mail.gmail.com>
 <CAEf4Bzat4dFCP40cMbDwPK-LyPKJtO1d0M44m9EbNajU9UgxFw@mail.gmail.com> <20230317013909.ckwsrcvvuisdars5@dhcp-172-26-102-232.dhcp.thefacebook.com>
In-Reply-To: <20230317013909.ckwsrcvvuisdars5@dhcp-172-26-102-232.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Mar 2023 09:28:28 -0700
Message-ID: <CAEf4BzbqOcnOjYOV-rEAGEK+D9-rvPNH+6XCQXTkAyqZJLfcCg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Allow ld_imm64 instruction to point to kfunc.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        David Vernet <void@manifault.com>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 6:39=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Mar 16, 2023 at 04:06:02PM -0700, Andrii Nakryiko wrote:
> >
> > /* pass function pointer through asm otherwise compiler assumes that
> > any function !=3D 0 */
> >
> > comment was referring to compiler assuming that function !=3D 0 for
> > __weak symbol? I definitely didn't read it this way. And "compiler
> > assumes that function !=3D 0" seems a bit too strong of a statement,
> > because at least Clang doesn't.
>
> Correct. Instead of 'any function' it should be 'any non-weak function'.

ok, your new macro implementation seems to prevent usage of non-weak
ksyms, which is great

>
> >
> > But for macro, it's not kfunc-specific (and macro itself has no way to
> > check that you are actually passing kfunc ksym), so even if it was a
> > macro, it would be better to call it something more generic like
> > bpf_ksym_exists() (though that will work for .kconfig, yet will be
> > inappropriately named).
>
> Rigth. bpf_ksym_exists() is what I proposed couple emails ago in my reply=
 to Ed.
>

I don't see it, maybe some email was dropped. But sounds good.

> > The asm bit, though, seems to be a premature thing that can hide real
> > compiler issues, so I'm still hesitant to add it. It should work today
> > with modern compilers, so I'd test and validate this.
>
> We're using asm in lots of place to avoid fighting with compiler.
> This is just one of them, but I found a different way to prevent
> silent optimizations. I'll go with:
>
> #define bpf_ksym_exists(sym) \
>        ({ _Static_assert(!__builtin_constant_p(!!sym), #sym " should be m=
arked as __weak"); !!sym; })
>
> It will address the silent dead code elimination issue and
> will detect missing weak immediately at build time.

Yep, I like this protection against using non-weak ksym with this
check. It's very helpful, thanks!

>
> Just going with:
>
> if (bpf_rcu_read_lock) // comment about weak
>    bpf_rcu_read_lock();
> else
>   ..
>
> and forgetting to use __weak in bpf_rcu_read_lock() declaration will make=
 it
> "work" on current kernels. The compiler will optimize 'if' and 'else' out=
 and
> libbpf will happily find that kfunc in the kernel.
> While the program will fail to load on kernels without this kfunc much la=
ter with:
> libbpf: extern (func ksym) 'bpf_rcu_read_lock': not found in kernel or mo=
dule BTFs.
>

Yep. Good testing is still important, of course.

> Which is the opposite of what that block of bpf code wanted to achieve.

I like the new bpf_ksym_exists() implementation, now I think it adds
value, instead of hiding an issue.

>
> > > It works, but how many people know that unknown weak resolves to zero=
 ?
> > > I didn't know until yesterday.
> >
> > I was explicit about this from the very beginning of BPF CO-RE work.
> > ksyms were added later, but semantics was consistent between .kconfig
> > and .ksym. Documentation can't be ever good enough and discoverable
> > enough (like [0]), of course, but let's do our best to make it as
> ...
> >   [0] https://nakryiko.com/posts/bpf-core-reference-guide/#kconfig-exte=
rn-variables
>
> I read it long ago, but reading is one thing and remembering small detail=
s is another.

That's understandable, no worries. I'm just saying that this is
officially supported semantics, so if compilers somehow break this,
I'd like to rely on BPF selftests to detect this early, thanks to BPF
CI's use of nightly Clang builds (and eventually hopefully we'll also
use GCC-BPF nightlies).
