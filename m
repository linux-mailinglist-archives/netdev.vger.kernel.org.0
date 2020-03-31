Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8966B199FE2
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 22:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbgCaUTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 16:19:24 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39973 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbgCaUTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 16:19:24 -0400
Received: by mail-qk1-f193.google.com with SMTP id l25so24589220qki.7;
        Tue, 31 Mar 2020 13:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=98Mx8YlzWs3km5z9jniJzK/L6x7AMsrTVCjYMPgwsgE=;
        b=gh7K28ge0u97KTF16N79lO15lt3QEe20KjZ5+zoRuJPDcHhP6r7GY9IIHWgC6tiXFe
         Cz42kJKYAFv8LIOLQ+YsoSEGAl6O4ovVOY3ZdGsQfOaDet8gJXkjEy/GEx9hqWmoasOo
         tJf3z6r2vZwsJ5JizupmIShSdLI5jluAMvsqyw4AZrxSAM2kFZEc0P3WIoiP4AUl/WzB
         znrbZHGfji4tLG7XtfBdVKyF/mZ0PI7p8g+FCLoeuIQf+4Aral90hUpli7LkuOpSvphI
         TTa5WvO7CeMeTZRwAfgVM1TRuGcIeoeiw7pyZNfl/R/WCw1MKwdDujzacFRVgJAvn7RB
         Zing==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=98Mx8YlzWs3km5z9jniJzK/L6x7AMsrTVCjYMPgwsgE=;
        b=K74Wot23GH6cSWNp5vh5XyKV9jT5bVjuUJUFGaVNY2kcrRcSykWAShvaqIGQDh0FOb
         KjEXevYQxv6SGsgkG47nrbVJScrCuYYueEHjnDhwUsWYb53JEtm18bQ7QMmOGKJQAT3N
         vqng/2rm9X7S3wshxFQ+XonUcjASrJ9mPRLjnaTCrC0AOru78h+rvIysimuv68IBypS4
         m43zgZ6tXjKFw6HTmrYCN5+pHwWmtzxr73MRzvv5pPBJRTCjsNYkqs2BhhvHUKO6agOY
         CBxmy4D1gKCFbv4tie+IbqOoxofIxUX/5bXUWJYtxqVTYXyVlzOFlNXEbG1ctF65AkDl
         9PKQ==
X-Gm-Message-State: ANhLgQ3rhZGA97O2r5PtxC6tkhFV5L1iBi2fqpnFHIfeMyL5DaeSQSKK
        sI6clMIv0xexQzkXBxggl6FQqnAWvBy2CKkgEz4=
X-Google-Smtp-Source: ADFU+vt7Dt4LQ1KKKGqZasAlcb0zE7eiWAFu0ec0/2s/vESKTnTcbSffG7CdYkzBUgkFQcl0gfbJqcnt07Vo0nh7Ta4=
X-Received: by 2002:a37:b786:: with SMTP id h128mr5974791qkf.92.1585685962168;
 Tue, 31 Mar 2020 13:19:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk> <20200326195859.u6inotgrm3ubw5bx@ast-mbp>
 <87imiqm27d.fsf@toke.dk> <20200327230047.ois5esl35s63qorj@ast-mbp>
 <87lfnll0eh.fsf@toke.dk> <20200328022609.zfupojim7see5cqx@ast-mbp>
 <87eetcl1e3.fsf@toke.dk> <CAEf4Bzb+GSf8cE_rutiaeZOtAuUick1+RnkCBU=Z+oY_36ArSA@mail.gmail.com>
 <87y2rihruq.fsf@toke.dk> <CAEf4Bza4vKbjkj8kBkrVmayFr2j_nvrORF_YkCoVKibB=SmSYQ@mail.gmail.com>
 <87pncsj0hv.fsf@toke.dk> <86f95d7a-1659-a092-91a2-abe5d58ceda8@iogearbox.net> <87blocin7p.fsf@toke.dk>
In-Reply-To: <87blocin7p.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 Mar 2020 13:19:10 -0700
Message-ID: <CAEf4BzaQANTPcWQu=0m=K9=CEFboBLN36a0B2XeX+qjuPdQ=8w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 8:00 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Daniel Borkmann <daniel@iogearbox.net> writes:
>
> > On 3/31/20 12:13 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >>>>> So you install your libxdp-based firewalls and are happy. Then you
> >>>>> decide to install this awesome packet analyzer, which doesn't know
> >>>>> about libxdp yet. Suddenly, you get all packets analyzer, but no mo=
re
> >>>>> firewall, until users somehow notices that it's gone. Or firewall
> >>>>> periodically checks that it's still runinng. Both not great, IMO, b=
ut
> >>>>> might be acceptable for some users, I guess. But imagine all the
> >>>>> confusion for user, especially if he doesn't give a damn about XDP =
and
> >>>>> other buzzwords, but only needs a reliable firewall :)
> >>>>
> >>>> Yes, whereas if the firewall is using bpf_link, then the packet anal=
yser
> >>>> will be locked out and can't do its thing. Either way you end up wit=
h a
> >>>> broken application; it's just moving the breakage. In the case of
> >>>
> >>> Hm... In one case firewall installation reported success and stopped
> >>> working afterwards with no notification and user having no clue. In
> >>> another, packet analyzer refused to start and reported error to user.
> >>> Let's agree to disagree that those are not at all equivalent. To me
> >>> silent failure is so much worse, than application failing to start in
> >>> the first place.
> >
> > I sort of agree with both of you that either case is not great. The sil=
ent
> > override we currently have is not great since it can be evicted at any =
time
> > but also bpf_link to lock-out other programs at XDP layer is not great =
either
> > since there is also huge potential to break existing programs. It's pro=
bably
> > best to discuss on an actual proposal to see the concrete semantics, bu=
t my
> > concerns, assuming I didn't misunderstand or got confused on something =
along
> > the way (if so, please let me know), currently are:
>
> I think you're summarising the issues well, with perhaps one thing
> missing: The goal is to enable multi-prog execution, i.e., execute two
> programs in sequence. So, when things work correctly the flow should be:
>
> App1, loading prog1:
> - get current program from $IFACE
> - current program is NULL:
>   -> build dispatcher(prog1)
>   -> load dispatcher onto $IFACE with UPDATE_IF_NOEXIST flag
>   -> success
>
> Then, app2 loading prog2:
> - get current program from $IFACE
> - current program is dispatcher(prog1):
>   -> build new dispatcher(prog1,prog2)
>   -> atomically replace old dispatcher with new one
>   -> success
>
> As long as app1 and app2 agree on what a dispatcher looks like, and how
> to update it, they can cooperatively install themselves in the chain, as
> long as there's a way to resolve the race between reading and updating
> the state in the kernel.
>
> However, if they *don't* agree on how to build the dispatcher and run in
> sequence, they are fundamentally incompatible. Which also means that
> multi-prog operation is going to be incompatible with any application
> that was written before it was implemented. The only way to avoid that
> is to provide the multi-prog support in the kernel, in a way that is
> compatible with the old API. I'm not sure if this is even possible; but
> I certainly got a very emphatic NACK on any attempt to implement the
> support in the kernel when I posted my initial patch back in the fall.
>
> Also, to your point about needing a specific library: I've been saying
> "using the same library" because I think that is the most likely way to
> get applications to agree. But really, what's needed is more like a
> protocol; there could in theory be several independent implementations
> that interoperate. However, I don't see a way to make things compatible
> with applications that don't follow that protocol; we only get to pick
> the failure mode (and those failure modes I think you summarised quite
> well).

Well, for once we agree with Toke in this thread (regarding last two
paragraphs) :)

>
> -Toke
>
