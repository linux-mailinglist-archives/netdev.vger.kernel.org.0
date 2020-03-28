Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63F4B1962EE
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 02:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgC1BoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 21:44:18 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44694 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgC1BoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 21:44:17 -0400
Received: by mail-qt1-f193.google.com with SMTP id x16so10302334qts.11;
        Fri, 27 Mar 2020 18:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yLqR5ccg3pJh/4ne8lN2dQj/LaZZzFaSAAZE++j6BeQ=;
        b=E5U9EE865lDaBNo6k62l9tPsbOjYCQAydTLBkI6JgCrsqF+EC4lbFUE0ABeZR86hzl
         oTGoFSQKVtu9XZMS0DOm7AiLu+xBYW/JvZFonlsYKjSrAVyHL3uNdSRGCqTOW2OizVqm
         6teGCoDr8NRK205U/2r7NHPxylWkfgnk54oaAGb29XaI5sWFm7FuFNVdj/nhcPoYlDvC
         yrKNkpAiTdg6TCnDm7KNGn9WpkiqCWx45IBG3YWKtXqVJmWhsx/iB0l11D7D5G+YP00v
         SID8gWmm2Ya1Ny4FFXZaQDogGRYuTNQ/QkNCYlCY+iU/I66718ZWFw7SJJm4T41hPt2j
         r/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yLqR5ccg3pJh/4ne8lN2dQj/LaZZzFaSAAZE++j6BeQ=;
        b=UWBUFRKQjebhpDzH/wLBmO1anx2DS9VeAcDCHG2L/ptR095eMKq5d2YrpLfQmJY17x
         pgkoRd+uX8ShD1nEGGIpSBCsdbVQxCflMyQ+Df3FQ5uydKnWFNxhP6PJxnPDI/wZD1/A
         tiWld2ZGkPniDsGik1k5IqP/+dgFgV896YrRJR7Tpz/XuMvucgZouqrdsRnnXVlwdVZ1
         diUciSEAEc+tCAtscQYhA9gV9OgVq2XbiYbuAEbZMb6WluVuWC1SIg1bRgRuT1GZDTxf
         9iHRKFDRJU2z7OE4jPDuMe70wwoWRhUnHH72vM/QiWPEMr94+e5eiywAfvEDzsG9Uudr
         C5zQ==
X-Gm-Message-State: ANhLgQ0SHSTFwnCcY2NF8SQgsYBb1v/HcKquWQiX9tVwWLQYMbXZCBPH
        OceATw+4StI+HsNCfsG/54Dk13VVdFLSbe3b14Y=
X-Google-Smtp-Source: ADFU+vsdB5ARUIS/cTYhDWQ78PqaPmweChGZgziio1zGA1X3voP48qjVDrU4NvZKcX16E9nJhE7BxXN/WeBUprIYsBw=
X-Received: by 2002:ac8:3f62:: with SMTP id w31mr2155339qtk.171.1585359855313;
 Fri, 27 Mar 2020 18:44:15 -0700 (PDT)
MIME-Version: 1.0
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk> <CAEf4BzaPQ6=h8a6Ngz638AtL4LmBLLVMV+_-YLMR=Ls+drd5HQ@mail.gmail.com>
 <87lfnmm35r.fsf@toke.dk> <CAEf4Bza7zQ+ii4SH=4gJqQdyCp9pm6qGAsBOwa0MG5AEofC2HQ@mail.gmail.com>
 <87wo75l9yj.fsf@toke.dk> <CAEf4Bza8P3yT08NAaqN2EKaaBFumzydbtYQmSvLxZ99=B6_iHw@mail.gmail.com>
 <87o8shl1y4.fsf@toke.dk>
In-Reply-To: <87o8shl1y4.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 27 Mar 2020 18:44:03 -0700
Message-ID: <CAEf4BzbK_pn6ox6JZLTjb7FYrpWGZrSqCApEY9xbWiFwwLKaGw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 6:10 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Fri, Mar 27, 2020 at 3:17 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > Please stop dodging. Just like with "rest of the kernel", but really
> >> > "just networking" from before.
> >>
> >> Look, if we can't have this conversation without throwing around
> >> accusations of bad faith, I think it is best we just take Ed's advice
> >> and leave it until after the merge window.
> >>
> >
> > Toke, if me pointing out that you are dodging original discussion and
> > pivoting offends you,
>
> It does, because I'm not. See below.
>
> > But if you are still with me, let's look at this particular part of
> > discussion:
> >
> >>> >> For XDP there is already a unique handle, it's just implicit: Each
> >>> >> netdev can have exactly one XDP program loaded. So I don't really =
see
> >>> >> how bpf_link adds anything, other than another API for the same th=
ing?
> >>> >
> >>> > I certainly failed to explain things clearly if you are still askin=
g
> >>> > this. See point #2, once you attach bpf_link you can't just replace
> >>> > it. This is what XDP doesn't have right now.
> >>>
> >>> Those are two different things, though. I get that #2 is a new
> >>> capability provided by bpf_link, I was just saying #1 isn't (for XDP)=
.
> >>
> >> bpf_link is combination of those different things... Independently
> >> they are either impossible or insufficient. I'm not sure how that
> >> doesn't answer your question:
> >>
> >>> So I don't really see
> >>> how bpf_link adds anything, other than another API for the same thing=
?
> >>
> >> Please stop dodging. Just like with "rest of the kernel", but really
> >> "just networking" from before.
> >
> > You said "So I don't really see how bpf_link adds anything, other than
> > another API for the same thing?". I explained that bpf_link is not the
> > same thing that exists already, thus it's not another API for the same
> > thing. You picked one property of bpf_link and claimed it's the same
> > as what XDP has right now. "I get that #2 is a new capability provided
> > by bpf_link, I was just saying #1 isn't (for XDP)". So should I read
> > that as if you are agreeing and your original objection is rescinded?
> > If yes, then good, this part is concluded and I'm sorry if I
> > misinterpreted your answer.
>
> Yes, I do believe that was a misinterpretation. Basically, by my
> paraphrasing, our argument goes something like this:
>
> What you said was: "bpf_link adds three things: 1. unique attachment
> identifier, 2. auto-detach and 3. preventing others from overriding it".
>
> And I replied: "1. already exists for XDP, 2. I don't think is the right
> behaviour for XDP, and 3. I don't see the point of - hence I don't
> believe bpf_link adds anything useful for my use case"
>
> I was not trying to cherry-pick any of the properties, and I do
> understand that 2. and 3. are new properties; I just disagree about how
> useful they are (and thus whether they are worth introducing another API
> for).
>

I appreciate you summarizing. It makes everything clearer. I also
don't have much to add after so many rounds.

> > But if not, then you again are picking one properly and just saying
> > "but XDP has it" without considering all of bpf_link properties as a
> > whole. In that case I do think you are arguing not in good faith.
>
> I really don't see how you could read my emails and come to that
> conclusion. But obviously you did, so I'll take that into consideration
> and see if I can express myself clearer in the future. But know this: I
> never deliberately argue in bad faith; so even if it seems like I am,
> please extend me the courtesy of assuming that this is due to either a
> misunderstanding or an honest difference in opinion. I will try to do
> the same for you.

I guess me citing your previous replies and pointing out to
inconsistencies (at least from my interpretation of them) should have
been a signal ;) But I do assume good faith to the extent possible,
which is why we are still here at almost 80 emails in.

>
> > Simple as that. I also hope I don't have to go all the way back to
> > "rest of the kernel", pivoted to "just networking" w.r.t.
> > subsystem-specific configuration/attachment APIs to explain another
> > reference.
>
> Again, I was not trying to "pivot", or attempting to use rhetorical
> tricks to "win" or anything like that. I was making an observation about
> how it's natural that when two subsystems interact, it's quite natural
> that there will be clashes between their different "traditions". And
> that how you view the subsystems' relationship with each other obviously
> affects your opinion of what the right thing to do is in such a
> situation. I never meant to imply anything concrete about BPF in
> anything other than a networking context. And again, I don't understand
> how you could read that out of what I wrote, but I'll take the fact that
> you did into consideration in the future.

Because "rest of the kernel" meant "cgroup subsystem" as well, which
was clearly not true case w.r.t. BPF. But alright, water under the
bridge, let's just not use generalizations too much going forward.

> > P.S. I don't know how merge window has anything to do with this whole
> > discussion, honestly...
>
> Nothing apart from the merge window being a conveniently delimited
> period of time to step away from things and focus on something else.
>
> -Toke
>
