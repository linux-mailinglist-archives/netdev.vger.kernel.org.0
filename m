Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9183D8429
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 01:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390171AbfJOXCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 19:02:40 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33985 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730039AbfJOXCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 19:02:40 -0400
Received: by mail-lj1-f196.google.com with SMTP id j19so21985536lja.1;
        Tue, 15 Oct 2019 16:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hcb/bZQTaR5GnCi6JvfQ7lb1sQENu+NNpWafTLnRSQE=;
        b=cuws7SfHUs6NGC2DyQ0NTemOvuVWfyGdTaV8cBd2c9Gkke7u3z2XoQzytH8/oL63vN
         KE1M8bZgCdsDHArOkWAsrhrMwEgkQKzOjJqfj3FUBXAxgnOiguVtajMrDDTVVYdtki6V
         NSEtAVdfwML+cLm0WWyhwGwZGBoxiSuefLWh/yvP/Y1/sR340i5OrrikccJII0QUl+CE
         EUqtRCKWMDiyubvy1o7kQHzhU1BFo8jQwqKmZyJU77ASBUyY4DyRCjNUl+lKjrS+IAli
         wxOlkAx+qmzph12NY2OEctKJWjn7UZmrH0ID8ZszyEySEAJK0JPAlFwVTsL5IfZlzTAb
         3uIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hcb/bZQTaR5GnCi6JvfQ7lb1sQENu+NNpWafTLnRSQE=;
        b=qj5s2qu78M0LHKy/RDEtgyB+nOd7HK2E1FpDlUsZOeLlC7CuSUDV/xf0IiFMwbeLpe
         csDOUm6XiQHNSPyyccSfX8ADDM/XwuCq02fBMPaoPsq0riRjYBV8fcMkf14RMvKPQZtz
         GGfnS1xhTveHzqluvruwk3QSy9kabjjCk7PpORdtX8qC1357nvuhRMJsD0IP0sXiyK+3
         f9T62F8M9goRi/9xsXUvuqFh8XqqIse04ferq6Q22soTdeq33wee11zlSJ1tWdD3PUnb
         03EdFOmSME3C6vDVX++OeUqlCGirpd0Tkev3mquI8ehMpZNaf+IFidlzd6IiYKd+EJvN
         AeHw==
X-Gm-Message-State: APjAAAVykpHmt4ly2fbaG4zlvUAQf+AhHvSjN3VwMqBJTIB7FyMYNXFE
        KTlCOJhr97oMPfqA2WgEnTH4esSwdPJMiLuvPHI=
X-Google-Smtp-Source: APXvYqyLGlCLftMhwpYpvYhf5HJ0wW+IyzgLNA5EHN9g/Qf3tWJhoaH5eYKJnrwgLDM9yq+/63O6tgqf0wbmJQOh+hg=
X-Received: by 2002:a2e:9b12:: with SMTP id u18mr24575859lji.142.1571180558099;
 Tue, 15 Oct 2019 16:02:38 -0700 (PDT)
MIME-Version: 1.0
References: <20191009160907.10981-1-christian.brauner@ubuntu.com>
 <CAADnVQJxUwD3u+tK1xsU2thpRWiAbERGx8mMoXKOCfNZrETMuw@mail.gmail.com>
 <20191010092647.cpxh7neqgabq36gt@wittgenstein> <CAADnVQJ6t+HQBRhN3mZrz4qhzGybsY2g-26mc2kQARkbLxqzTA@mail.gmail.com>
 <20191015225555.jprg5xmnbg45os3y@wittgenstein>
In-Reply-To: <20191015225555.jprg5xmnbg45os3y@wittgenstein>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 15 Oct 2019 16:02:25 -0700
Message-ID: <CAADnVQ+PDTTBT5GEZQhnoF0Ni8JVbRD5A+zWRH6DO45Kc-Zn=Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] bpf: switch to new usercopy helpers
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 3:55 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Tue, Oct 15, 2019 at 03:45:54PM -0700, Alexei Starovoitov wrote:
> > On Thu, Oct 10, 2019 at 2:26 AM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
> > >
> > > On Wed, Oct 09, 2019 at 04:06:18PM -0700, Alexei Starovoitov wrote:
> > > > On Wed, Oct 9, 2019 at 9:09 AM Christian Brauner
> > > > <christian.brauner@ubuntu.com> wrote:
> > > > >
> > > > > Hey everyone,
> > > > >
> > > > > In v5.4-rc2 we added two new helpers check_zeroed_user() and
> > > > > copy_struct_from_user() including selftests (cf. [1]). It is a generic
> > > > > interface designed to copy a struct from userspace. The helpers will be
> > > > > especially useful for structs versioned by size of which we have quite a
> > > > > few.
> > > > >
> > > > > The most obvious benefit is that this helper lets us get rid of
> > > > > duplicate code. We've already switched over sched_setattr(), perf_event_open(),
> > > > > and clone3(). More importantly it will also help to ensure that users
> > > > > implementing versioning-by-size end up with the same core semantics.
> > > > >
> > > > > This point is especially crucial since we have at least one case where
> > > > > versioning-by-size is used but with slighly different semantics:
> > > > > sched_setattr(), perf_event_open(), and clone3() all do do similar
> > > > > checks to copy_struct_from_user() while rt_sigprocmask(2) always rejects
> > > > > differently-sized struct arguments.
> > > > >
> > > > > This little series switches over bpf codepaths that have hand-rolled
> > > > > implementations of these helpers.
> > > >
> > > > check_zeroed_user() is not in bpf-next.
> > > > we will let this set sit in patchworks for some time until bpf-next
> > > > is merged back into net-next and we fast forward it.
> > > > Then we can apply it (assuming no conflicts).
> > >
> > > Sounds good to me. Just ping me when you need me to resend rebase onto
> > > bpf-next.
> >
> > -rc1 is now in bpf-next.
> > I took a look at patches and they look good overall.
> >
> > In patches 2 and 3 the zero init via "= {};"
> > should be unnecessary anymore due to
> > copy_struct_from_user() logic, right?
>
> Right, I can remove them.
>
> >
> > Could you also convert all other case in kernel/bpf/,
> > so bpf_check_uarg_tail_zero() can be removed ?
> > Otherwise the half-way conversion will look odd.
>
> Hm, I thought I did that and concluded that bpf_check_uarg_tail_zero()
> can't be removed because sometimes it is called to verify whether a
> given struct is zeroed but nothing is actually copied from userspace but
> rather to userspace. See for example
> v5.4-rc3:kernel/bpf/syscall.c:bpf_map_get_info_by_fd()
> All call sites where something is actually copied from userspace I've
> switched to copy_struct_from_user().

I see. You're right.
Could you update the comment in bpf_check_uarg_tail_zero()
to clarify that copy_struct_from_user() should be used whenever
possible instead ?
