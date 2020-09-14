Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31499269493
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgINSNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbgINSNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 14:13:25 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A00C06174A;
        Mon, 14 Sep 2020 11:13:25 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x10so527024ybj.13;
        Mon, 14 Sep 2020 11:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5RBY812FwcyY9Uy7jLUUrntCr77NA38VC45lLE5qUBk=;
        b=n4X707VG7Xaaln/PeUBz97mbNqlY+laydow1ZhwTXXCbYQJEkofSc2FAbQEPaTd1Jj
         9ksIsI4I66wiSjd8ftfJSop4q5znguhEx8SbZcouCJgEZqS5RlwIFQ3xIqoW5IPQH+a8
         Hm6WEBfBE7XpRDUXQcVvw9dLJmHY0vTyyv1k7ZcUWQ86iUeBJoJC+OU+VD5y1XVe/nuQ
         IA49t3Esb58B14MyPZSVTFozvtg80VY6Yh+CwugR2pn2DvGY64nvzOE7cZiAzGUG6bOT
         D1N912z28jSoPGIWiIjtO7thH9n5PJsfTDqVxO6bVC60ZmsBqnBBv74NNqls5cf7FQ9r
         XZ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5RBY812FwcyY9Uy7jLUUrntCr77NA38VC45lLE5qUBk=;
        b=gbaCg9HUYiTDl+Y9lq91OYdY68JaKluRLlmZpq3XUG+wYNWbH6O/vV3CAgVwyaE6kg
         OZm3bSe5wNf9jZzEs8JOwQYKfis0GYUqfLkJTg2RJdH0Hji/CCSErX9/wSUv3zHPR0PH
         wdRHYACcrSDlBV2k/n8Q1g5alCeHwMuRtD3jBlxGm917WnTcD8ZyIPp1u0T3NX9rjSk8
         CSWpqgtsnYy2XaPfom0yaQHSxtbQw+cmH7V09NL6S6Sin69RA0Yqb/437r0N7rFipChk
         bhT97DzVVUe0yCcuOpPi8CcQrBvCY8/x8kZcs5Pc5o/SoIT+apWEJNLgnyNypFOd4+t/
         IEBg==
X-Gm-Message-State: AOAM530+Lf5TB6tTmqT1D0lC7foSf7uaqi09JEmNTNc84dtPC6hTqTxL
        oPAlJXrPA0D2GpH8Z0icL482YK2jAGfuz5ZDcD8=
X-Google-Smtp-Source: ABdhPJwBfqJ5a80mSiPhYdoEi1QThqmJs4bCjx0bOIG/zPB2vxN/HPOwQetlFZszAqfZSUqc+GUnqWFGBf33oAhWq0A=
X-Received: by 2002:a25:c049:: with SMTP id c70mr22749570ybf.403.1600107204350;
 Mon, 14 Sep 2020 11:13:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200914061206.2625395-1-yhs@fb.com> <b942625c-7140-0a57-337e-3a95020cfa99@isovalent.com>
 <1ab672c7-f333-f953-16ec-49e9099b39d7@fb.com> <ca0b4c63-5632-f8a0-9669-975d1119c1e6@fb.com>
 <c8c33847-9ca6-5b81-ef03-02ce382acfb6@isovalent.com> <8601f597-9c7e-a9a5-b375-75191fa93530@fb.com>
 <CAEf4BzYd8Yp_CX52xYmbWg56JjyS__SmBD6Cb3y0M5hvVPYARw@mail.gmail.com> <e98c3f11-fc23-203a-3be0-f4535d8b062c@fb.com>
In-Reply-To: <e98c3f11-fc23-203a-3be0-f4535d8b062c@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Sep 2020 11:13:13 -0700
Message-ID: <CAEf4BzY27sW4hmnD+XV2Ms6+EvP+_o4pu_6sr3p1mqr14rgjfw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: fix build failure
To:     Yonghong Song <yhs@fb.com>
Cc:     Quentin Monnet <quentin@isovalent.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 11:06 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 9/14/20 10:55 AM, Andrii Nakryiko wrote:
> > On Mon, Sep 14, 2020 at 10:46 AM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 9/14/20 10:23 AM, Quentin Monnet wrote:
> >>> On 14/09/2020 17:54, Yonghong Song wrote:
> >>>>
> >>>>
> >>>> On 9/14/20 9:46 AM, Yonghong Song wrote:
> >>>>>
> >>>>>
> >>>>> On 9/14/20 1:16 AM, Quentin Monnet wrote:
> >>>>>> On 14/09/2020 07:12, Yonghong Song wrote:
> >>>>>>> When building bpf selftests like
> >>>>>>>      make -C tools/testing/selftests/bpf -j20
> >>>>>>> I hit the following errors:
> >>>>>>>      ...
> >>>>>>>      GEN
> >>>>>>> /net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documen=
tation/bpftool-gen.8
> >>>>>>>
> >>>>>>>      <stdin>:75: (WARNING/2) Block quote ends without a blank lin=
e;
> >>>>>>> unexpected unindent.
> >>>>>>>      <stdin>:71: (WARNING/2) Literal block ends without a blank l=
ine;
> >>>>>>> unexpected unindent.
> >>>>>>>      <stdin>:85: (WARNING/2) Literal block ends without a blank l=
ine;
> >>>>>>> unexpected unindent.
> >>>>>>>      <stdin>:57: (WARNING/2) Block quote ends without a blank lin=
e;
> >>>>>>> unexpected unindent.
> >>>>>>>      <stdin>:66: (WARNING/2) Literal block ends without a blank l=
ine;
> >>>>>>> unexpected unindent.
> >>>>>>>      <stdin>:109: (WARNING/2) Literal block ends without a blank =
line;
> >>>>>>> unexpected unindent.
> >>>>>>>      <stdin>:175: (WARNING/2) Literal block ends without a blank =
line;
> >>>>>>> unexpected unindent.
> >>>>>>>      <stdin>:273: (WARNING/2) Literal block ends without a blank =
line;
> >>>>>>> unexpected unindent.
> >>>>>>>      make[1]: ***
> >>>>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Docume=
ntation/bpftool-perf.8]
> >>>>>>> Error 12
> >>>>>>>      make[1]: *** Waiting for unfinished jobs....
> >>>>>>>      make[1]: ***
> >>>>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Docume=
ntation/bpftool-iter.8]
> >>>>>>> Error 12
> >>>>>>>      make[1]: ***
> >>>>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Docume=
ntation/bpftool-struct_ops.8]
> >>>>>>> Error 12
> >>>>>>>      ...
> >>>>>>>
> >>>>>>> I am using:
> >>>>>>>      -bash-4.4$ rst2man --version
> >>>>>>>      rst2man (Docutils 0.11 [repository], Python 2.7.5, on linux2=
)
> >>>>>>>      -bash-4.4$
> >>>>>>>
> >>>>>>> Looks like that particular version of rst2man prefers to have a
> >>>>>>> blank line
> >>>>>>> after literal blocks. This patch added block lines in related .rs=
t
> >>>>>>> files
> >>>>>>> and compilation can then pass.
> >>>>>>>
> >>>>>>> Cc: Quentin Monnet <quentin@isovalent.com>
> >>>>>>> Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SE=
E
> >>>>>>> ALSO" sections in man pages")
> >>>>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
> >>>>>>
> >>>>>>
> >>>>>> Hi Yonghong, thanks for the fix! I didn't see those warnings on my
> >>>>>> setup. For the record my rst2man version is:
> >>>>>>
> >>>>>>       rst2man (Docutils 0.16 [release], Python 3.8.2, on linux)
> >>>>>>
> >>>>>> Your patch looks good, but instead of having blank lines at the en=
d of
> >>>>>> most files, could you please check if the following works?
> >>>>>
> >>>>> Thanks for the tip! I looked at the generated output again. My abov=
e
> >>>>> fix can silent the warning, but certainly not correct.
> >>>>>
> >>>>> With the following change, I captured the intermediate result of th=
e
> >>>>> .rst file.
> >>>>>
> >>>>>     ifndef RST2MAN_DEP
> >>>>>            $(error "rst2man not found, but required to generate man=
 pages")
> >>>>>     endif
> >>>>> -       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2=
man
> >>>>> $(RST2MAN_OPTS) > $@
> >>>>> +       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | tee
> >>>>> /tmp/tt | rst2man $(RST2MAN_OPTS) > $@
> >>>>>
> >>>>> With below command,
> >>>>>       make clean && make bpftool-cgroup.8
> >>>>> I can get the new .rst file for bpftool-cgroup.
> >>>>>
> >>>>> At the end of file /tmp/tt (changed bpftool-cgroup.rst), I see
> >>>>>
> >>>>>        ID       AttachType      AttachFlags     Name
> >>>>> \n SEE ALSO\n=3D=3D=3D=3D=3D=3D=3D=3D\n\t**bpf**\ (2),\n\t**bpf-hel=
pers**\
> >>>>> (7),\n\t**bpftool**\ (8),\n\t**bpftool-btf**\
> >>>>> (8),\n\t**bpftool-feature**\ (8),\n\t**bpftool-gen**\
> >>>>> (8),\n\t**bpftool-iter**\ (8),\n\t**bpftool-link**\
> >>>>> (8),\n\t**bpftool-map**\ (8),\n\t**bpftool-net**\
> >>>>> (8),\n\t**bpftool-perf**\ (8),\n\t**bpftool-prog**\
> >>>>> (8),\n\t**bpftool-struct_ops**\ (8)\n
> >>>>>
> >>>>> This sounds correct if we rst2man can successfully transforms '\n'
> >>>>> or '\t' to proper encoding in the man page.
> >>>>>
> >>>>> Unfortunately, with my version of rst2man, I got
> >>>>>
> >>>>> .IP "System Message: WARNING/2 (<stdin>:, line 146)"
> >>>>> Literal block ends without a blank line; unexpected unindent.
> >>>>> .sp
> >>>>> n SEE
> >>>>> ALSOn=3D=3D=3D=3D=3D=3D=3D=3Dnt**bpf**(2),nt**bpf\-helpers**(7),nt*=
*bpftool**(8),nt**bpftool\-btf**(8),nt**bpftool\-feature**(8),nt**bpftool\-=
gen**(8),nt**bpftool\-iter**(8),nt**bpftool\-link**(8),nt**bpftool\-map**(8=
),nt**bpftool\-net**(8),nt**bpftool\-perf**(8),nt**bpftool\-prog**(8),nt**b=
pftool\-struct_ops**(8)n
> >>>>>
> >>>>> .\" Generated by docutils manpage writer.
> >>>>>
> >>>>> The rst2man simply considered \n as 'n'. The same for '\t' and
> >>>>> this caused the issue.
> >>>>>
> >>>>> I did not find a way to fix the problem https://urldefense.proofpoi=
nt.com/v2/url?u=3Dhttps-3A__www.google.com_url-3Fq-3Dhttps-3A__zoom.us_j_94=
864957378-3Fpwd-253DbXFRL1ZaRUxTbDVKcm9uRitpTXgyUT09-26sa-3DD-26source-3Dca=
lendar-26ust-3D1600532408208000-26usg-3DAOvVaw3SJ0i8oz4ZM-2DGRb7hYkrYlyet&d=
=3DDwIDaQ&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DDA8e1B5r073vIqRrFz7MRA&m=3DkEK7ScP=
MF-y-i8dli-or8wWEGREW5V4qPB7UqHqDnkg&s=3DBr0g0MFXxL_pJuDVTOY5UrmvfD2ru_6Uf_=
X_8Nr2Rhk&e=3D .
> >>>>
> >>>> The following change works for me.
> >>>>
> >>>> @@ -44,7 +44,7 @@ $(OUTPUT)%.8: %.rst
> >>>>    ifndef RST2MAN_DEP
> >>>>           $(error "rst2man not found, but required to generate man p=
ages")
> >>>>    endif
> >>>> -       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2m=
an
> >>>> $(RST2MAN_OPTS) > $@
> >>>> +       $(QUIET_GEN)( cat $< ; echo -e $(call see_also,$<) ) | rst2m=
an
> >>>> $(RST2MAN_OPTS) > $@
> >>>>
> >>>>    clean: helpers-clean
> >>>>           $(call QUIET_CLEAN, Documentation)
> >>>> -bash-4.4$
> >>>>
> >>>> I will send revision 2 shortly.
> >>>
> >>> Thanks Yonghong, but this does not work on my setup :/. The version o=
f
> >>> echo which is called on my machine from the Makefile does not seem to
> >>> interpret the "-e" option and writes something like "-e\nSEE ALSO",
> >>> which causes rst2man to complain.
> >>>
> >>> I suspect the portable option here would be printf, even though Andri=
i
> >>> had some concerns that we could pass a format specifier through the f=
ile
> >>> names [0].
> >>>
> >>> Would this work on your setup?
> >>>
> >>>        $(QUIET_GEN)( cat $< ; printf $(call see_also,$<) ) | rst2man.=
..
> >>>
> >>> Would that be acceptable?
> >>
> >> It works for me. Andrii originally suggested `echo -e`, but since `ech=
o
> >> -e` does not work in your environment let us use printf then. I will a=
dd
> >> a comment about '%' in the bpftool man page name.
> >
> > It's amazing how incompatible echo can be. But that aside, I have
> > nothing against printf itself, but:
> >
> > printf "%s" "whatever we want to print out"
> >
> > seems like the way to go, similarly how you'd do it in your C code, no?
>
> This won't really work :-(
>
> -bash-4.4$ printf "%s" "\n\n"
> \n\n-bash-4.4$ printf "\n\n"
>
>
> -bash-4.4$
>
> Looks like "\n" needs to be in format string to make a difference.
>

I just learned that %b was added specifically for that case:

$ printf "%b" "\n\n"


$

>
> >
> >>
> >>>
> >>> [0]
> >>> https://lore.kernel.org/bpf/ca595fd6-e807-ac8e-f15f-68bfc7b7dbc4@isov=
alent.com/T/#m01bb298fd512121edd5e77a26ed5382c0c53939e
> >>>
> >>> Quentin
> >>>
