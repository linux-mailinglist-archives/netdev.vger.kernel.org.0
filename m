Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 331E164B4D
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 19:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbfGJRPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 13:15:01 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42936 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbfGJRPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 13:15:01 -0400
Received: by mail-qt1-f196.google.com with SMTP id h18so3234253qtm.9;
        Wed, 10 Jul 2019 10:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NGFf4K44Omo/6HI08zoSuEdBbUNOOcIcpFAEbLt9qBU=;
        b=fGPgkuwJDjEuEvCjixaNo+34b9/RV8W4QGKsthza0kY8Sxcuyw8TaASVzuT3NuO0Az
         mqGH1TfBBoLlQaWhnshJA2dGOfD43l6sQVLPxzsLVvQrxxDt3S2/kTTOWYTQ23gtFhy8
         t7COieABAlXVA9PKZaTmB7TseVu1dckRLBiykpeTbC/WYhxxIKCPuVl2ZxtUmmfRO1SE
         xPcpiY4f8rXSxORfEaQwaBRl2KCXCYsG2ElSWpwHmZI47ppN/sB1YKVxJvYgkxMJtzPX
         cUoFDxMLoDs+4rWsMaAFyLnrndpXsccM3E2dzfck8bE/P2NYSaU7vVFq9lUAmc7jtoI5
         gzlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NGFf4K44Omo/6HI08zoSuEdBbUNOOcIcpFAEbLt9qBU=;
        b=tHnN8ZSiD9SWoO97k0jXyz9LhwncpykJbMPBo0xMQtwEB1gkj++efKAsD6HxEnU7R3
         cF2Ge2rklMLL8hMeS/BlLKw9GQIjggso9lT7wkXdCX14kXiJhNS20+Z65uy0S5uCT3gW
         NYS67j/2jeBPPahufAIj+M41JfykTZ7asH8fmaB9RzfAV2tBBK/m6EAdmHDxXLPipZTJ
         MuPMu7duhg3jRJZtjvt0z1IIuSww+z55mB0ppbZz8N6hNU4mAnBrRHgO8TpMyIO7gmlO
         +hwS4rH9j9efFbSjqrzzmlPxdSw9GiHePegumWigXRJbEpCJzFNHp05J6bm87cy0V6r1
         /1TQ==
X-Gm-Message-State: APjAAAXnkDBo88052nu6S0F1zpMdL5QZ9rRM16eiFQvqCqZ0npl0qAXQ
        ME/HfVavwapFHfxjQnC+9Fi+P+VYhI6mWW1I2eOVCGTS174=
X-Google-Smtp-Source: APXvYqxgd7jhSCCuhS5ldmjECRxUE0y2ZfQCibWQL1GdDq8XaVcOVujVJTx6ks6Rr6faquIuBxzKZzImi8qx7dzK5A4=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr24333344qta.171.1562778900040;
 Wed, 10 Jul 2019 10:15:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190709151809.37539-1-iii@linux.ibm.com> <20190709151809.37539-4-iii@linux.ibm.com>
 <CAEf4BzY0kO2si_ajouYNfsauaWdHkj042++bLaHe1W_G885i=g@mail.gmail.com> <1F8BDE1D-08C9-4C71-A281-92804455F5EF@linux.ibm.com>
In-Reply-To: <1F8BDE1D-08C9-4C71-A281-92804455F5EF@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 10:14:48 -0700
Message-ID: <CAEf4BzaG=V0xCp3-O4nciZW+=3BXGd4cLm9fwGykESGKEgZmAg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 3/4] selftests/bpf: make PT_REGS_* work in userspace
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Y Song <ys114321@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        david.daney@cavium.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 4:47 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> > Am 09.07.2019 um 19:48 schrieb Andrii Nakryiko <andrii.nakryiko@gmail.c=
om>:
> >
> > On Tue, Jul 9, 2019 at 8:19 AM Ilya Leoshkevich <iii@linux.ibm.com> wro=
te:
> >>
> >> Right now, on certain architectures, these macros are usable only with
> >> kernel headers. This patch makes it possible to use them with userspac=
e
> >> headers and, as a consequence, not only in BPF samples, but also in BP=
F
> >> selftests.
> >>
> >> On s390, provide the forward declaration of struct pt_regs and cast it
> >> to user_pt_regs in PT_REGS_* macros. This is necessary, because instea=
d
> >> of the full struct pt_regs, s390 exposes only its first member
> >> user_pt_regs to userspace, and bpf_helpers.h is used with both userspa=
ce
> >> (in selftests) and kernel (in samples) headers. It was added in commit
> >> 466698e654e8 ("s390/bpf: correct broken uapi for
> >> BPF_PROG_TYPE_PERF_EVENT program type").
> >>
> >> Ditto on arm64.
> >>
> >> On x86, provide userspace versions of PT_REGS_* macros. Unlike s390 an=
d
> >> arm64, x86 provides struct pt_regs to both userspace and kernel, howev=
er,
> >> with different member names.
> >>
> >> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> >> ---
> >
> > Just curious, what did you use as a reference for which register
> > corresponds to which PARM, RET, etc for different archs? I've tried to
> > look it up the other day, and it wasn't as straightforward to find as
> > I hoped for, so maybe I'm missing something obvious.
>
> For this particular change I did not have to look it up, because it all
> was already in the code, I just needed to adapt it to userspace headers.
> Normally I would google for =E2=80=9Eabi supplement=E2=80=9C to find this=
 information.
> A lazy way would be to simply ask the (cross-)compiler:
>
> cat <<HERE | aarch64-linux-gnu-gcc -x c -O3 -S - -o -
> int f(int a, int b, int c, int d, int e, int f, int g, int h, int i, int =
j);
> int g() { return -f(1, 2, 3, 4, 5, 6, 7, 8, 9, 10); }
> HERE

Thanks for this trick! :)

>
> I=E2=80=99ve just double checked the supported arches, and noticed that:
>
> #define PT_REGS_PARM5(x) ((x)->uregs[4])
> for bpf_target_arm (arm-linux-gnueabihf) looks wrong:
> the 5th parameter should be passed on stack. This observation matches
> [1].
>
> #define PT_REGS_RC(x) ((x)->regs[1])
> for bpf_target_mips (mips64el-linux-gnuabi64) also looks wrong:
> the return value should be in register 2. This observation matches [2].

Now I'm glad I asked :)

>
> Since I=E2=80=99m not an expert on those architectures, my conclusions co=
uld be
> incorrect (e.g. becase a different ABI is normally used in practice).
> Adrian and David, could you please correct me if I=E2=80=99m wrong?
>
> [1] http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042f/IHI0042F_aa=
pcs.pdf
> [2] ftp://www.linux-mips.org/pub/linux/mips/doc/ABI/psABI_mips3.0.pdf
>
> >> tools/testing/selftests/bpf/bpf_helpers.h | 61 +++++++++++++++--------
> >> 1 file changed, 41 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing=
/selftests/bpf/bpf_helpers.h
> >> index 73071a94769a..212ec564e5c3 100644
> >> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> >> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> >> @@ -358,6 +358,7 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32=
 len_diff, __u32 mode,
> >>
> >> #if defined(bpf_target_x86)
> >>
> >> +#ifdef __KERNEL__
> >> #define PT_REGS_PARM1(x) ((x)->di)
> >> #define PT_REGS_PARM2(x) ((x)->si)
> >> #define PT_REGS_PARM3(x) ((x)->dx)
> >> @@ -368,19 +369,35 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s=
32 len_diff, __u32 mode,
> >> #define PT_REGS_RC(x) ((x)->ax)
> >> #define PT_REGS_SP(x) ((x)->sp)
> >> #define PT_REGS_IP(x) ((x)->ip)
> >> +#else
> >> +#define PT_REGS_PARM1(x) ((x)->rdi)
> >> +#define PT_REGS_PARM2(x) ((x)->rsi)
> >> +#define PT_REGS_PARM3(x) ((x)->rdx)
> >> +#define PT_REGS_PARM4(x) ((x)->rcx)
> >> +#define PT_REGS_PARM5(x) ((x)->r8)
> >> +#define PT_REGS_RET(x) ((x)->rsp)
> >> +#define PT_REGS_FP(x) ((x)->rbp)
> >> +#define PT_REGS_RC(x) ((x)->rax)
> >> +#define PT_REGS_SP(x) ((x)->rsp)
> >> +#define PT_REGS_IP(x) ((x)->rip)
> >
> > Will this also work for 32-bit x86?
>
> Thanks, this is a good catch: this builds, but makes 64-bit accesses, as =
if it used the 64-bit
> variant of pt_regs. I will fix this.

Sounds good, thanks!
