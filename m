Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F392E13E57D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391111AbgAPRPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:15:01 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43600 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391101AbgAPRO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 12:14:59 -0500
Received: by mail-qk1-f196.google.com with SMTP id t129so19796598qke.10;
        Thu, 16 Jan 2020 09:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qbPesbI6+o4JGTWaTpLZljTSTXaCbDPO7M6CK9Z7jy0=;
        b=DujDkG5W3ILpYM8qyT0dAcZJClk1ACfv/flsghX/egJkq4WsWkCtz+kypqB1mcFslN
         uDXKIvfdULD4F80JGgtROcDeW1eHH825VujncNlxJoLvi91ZMb7rGYi6KoVPXitLX6ty
         u90XUpHcsUCTK0dKYWhkjIb6zzFW7fRHX5we0nzj8d/clbEcl4H3OrL3VGB1gXmxorEK
         KYfP0As9yW35L0kqcdFLDRmRNbtk0tdGhY5Dkni8Pv2sjPewW92s1Vl0SKCEQiEkkYZI
         aQEnAchcYdP+TGnVTg0I81U5jTnEQj3onFKb9erpdMhab2+L4nNJXpnIewRzpj+eFbsQ
         0CLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qbPesbI6+o4JGTWaTpLZljTSTXaCbDPO7M6CK9Z7jy0=;
        b=EdVXhet3OBYS+raDRU+w0vw7BHT6JkYr+Z/760/yxGUPWp1S+vvd9sA40D3i2FaDJr
         0MxD19pPOdSBjmj1cfSVPt2stTGenOZxrUMh2c8YEJGVGN5EFXy9U6uvuhN0SrngvVvl
         ecvly5J14MBF9XeR9gWtYAlMbyljGc+dPULe3aCFfi6BRBribLPv/uthlHKw97X2S3lc
         Wbj0K2lWAdshNLLtxFmCCG5LsQuchA7TbYlVn8yI0DzHo/HuWwP66ifekuVAImQAPJZL
         mm6vDiJzxiNhHmrVr0clRaS6R3+X16Jf8IVU7eLY+j1Tz3hLlNWF/V/JbkLyMtQNLTCz
         C8gg==
X-Gm-Message-State: APjAAAUBNF+Ur4sOO6yAvDQr2mKsdWlAIx5t/V9o9xO97pgKhn8O5pWf
        PVAQKdsZVq6i6QUM1bvwOyYHWonPacr+ITcD+j0=
X-Google-Smtp-Source: APXvYqye2xzTJ5xPc92metlBwExlrGUNWRrkmB/ybM14ARqiI3YrIFXjSAmln3PIxwPT0fU+QKgzeO269EhwuJ8/F3g=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr29954210qkq.437.1579194898228;
 Thu, 16 Jan 2020 09:14:58 -0800 (PST)
MIME-Version: 1.0
References: <157909756858.1192265.6657542187065456112.stgit@toke.dk>
 <157909757089.1192265.9038866294345740126.stgit@toke.dk> <CAEf4BzbqY8zivZy637Xy=iTECzBAYQ7vo=M7TvsLM2Yp12bJpg@mail.gmail.com>
 <87v9pctlvn.fsf@toke.dk> <CAEf4BzZpGe-1S5_iwS8GBw9iiyFJmDUkOaO+2qaftRn_iy5cNA@mail.gmail.com>
 <87a76nu5yo.fsf@toke.dk>
In-Reply-To: <87a76nu5yo.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jan 2020 09:14:47 -0800
Message-ID: <CAEf4BzYLycZb+DBkao-jt+5sGgi3vbmzQ4Ogq9eRXZ+Jvew-ZA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 02/10] tools/bpf/runqslower: Fix override
 option for VMLINUX_BTF
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 1:05 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Wed, Jan 15, 2020 at 2:06 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Wed, Jan 15, 2020 at 6:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >> >>
> >> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >>
> >> >> The runqslower tool refuses to build without a file to read vmlinux=
 BTF
> >> >> from. The build fails with an error message to override the locatio=
n by
> >> >> setting the VMLINUX_BTF variable if autodetection fails. However, t=
he
> >> >> Makefile doesn't actually work with that override - the error messa=
ge is
> >> >> still emitted.
> >> >
> >> > Do you have example command with VMLINUX_BTF override that didn't wo=
rk
> >> > (and what error message was emitted)?
> >>
> >> Before this patch:
> >>
> >> $ cd ~/build/linux/tools/bpf/runqslower
> >> $ make
> >> Makefile:18: *** "Can't detect kernel BTF, use VMLINUX_BTF to specify =
it explicitly".  Stop.
> >>
> >> $ make VMLINUX_BTF=3D~/build/linux/vmlinux
> >> Makefile:18: *** "Can't detect kernel BTF, use VMLINUX_BTF to specify =
it explicitly".  Stop.
> >
> > Ok, so this is strange. Try make clean and run with V=3D1, it might hel=
p
> > to debug this. This could happen if ~/build/linux/vmlinux doesn't
> > exist, but I assume you double-checked that. It works for me just fine
> > (Makefile won't do VMLINUX_BTF :=3D assignment, if it's defined through
> > make invocation, so your change should be a no-op in that regard):
> >
> > $ make clean
> > $ make VMLINUX_BTF=3D~/linux-build/default/vmlinux V=3D1
> > ...
> > .output/sbin/bpftool btf dump file ~/linux-build/default/vmlinux
> > format c > .output/vmlinux.h
> > ...
> >
> > Wonder what your output looks like?
>
> $ make clean
> Makefile:18: *** "Can't detect kernel BTF, use VMLINUX_BTF to specify it =
explicitly".  Stop.
> $ make VMLINUX_BTF=3D~/build/linux/vmlinux V=3D1
> Makefile:18: *** "Can't detect kernel BTF, use VMLINUX_BTF to specify it =
explicitly".  Stop.
>
> Take another look at the relevant part of the makefile:
>
>   ifneq ("$(wildcard /sys/kernel/btf/vmlinux)","")
>   VMLINUX_BTF :=3D /sys/kernel/btf/vmlinux
>   else ifneq ("$(wildcard /boot/vmlinux-$(KERNEL_REL))","")
>   VMLINUX_BTF :=3D /boot/vmlinux-$(KERNEL_REL)
>   else
>   $(error "Can't detect kernel BTF, use VMLINUX_BTF to specify it explici=
tly")
>   endif
>
> That if/else doesn't actually consider the value of VMLINUX_BTF; so the
> override only works if one of the files being considered by the
> auto-detection actually exists... :)

Ah, right, unconditional $(error), completely missed that few times, thanks=
!

>
> -Toke
>
