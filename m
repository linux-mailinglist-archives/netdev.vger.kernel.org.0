Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DECD199918
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 17:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730614AbgCaPAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 11:00:23 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23942 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730286AbgCaPAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 11:00:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585666821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=agKZM50VU4m65bqfiwOPnrhNSxoCEL4vSgnYTZvCQBk=;
        b=IZT8Jxp7tbP8skUSg5ufvL+6wXAt+0lfOt0V79k3X9MPdGPQckvbyGYNSiLXlfRmXuigIU
        +i2WNuzIIQ5qhgc8zHDxrFepfmtm4QbHZS5sahsqiNTfrrt4jV3V33JL8EqXsHdQTEXfbb
        3orIC05HtVgz9OeHe28iT3v17JuCaak=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-EK13F2M2PEG2l1ZoqnL8Bg-1; Tue, 31 Mar 2020 11:00:19 -0400
X-MC-Unique: EK13F2M2PEG2l1ZoqnL8Bg-1
Received: by mail-lf1-f69.google.com with SMTP id w191so8976793lff.13
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 08:00:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=agKZM50VU4m65bqfiwOPnrhNSxoCEL4vSgnYTZvCQBk=;
        b=YPKcICMGOZ9aBIpByZ8PEuCQsiRASnHk9Q7xcx8l4XUncCNAe4+5v/qHaL1l+pRF9i
         QxZkqk/ZX7AXaYNjK4NzfIHDOXoCH8miAchk91rgbNRk1+rExq61UmFKQIGj2Jt33mVt
         pMEjGb57EavY8SGW1qjeRwk4bRt3mxyUCxuRDyxGnhC2ezmGlmQGBzmdbx1G6FW1WAPO
         Vec/vjwj25RJ4jqysTusyyOqRSm73U1jdODt+UOgcw9gnolx4oIA2toQ6373a7QnP+8x
         n4bZ8QpgRRZ8vHvJDODzhh8IuF3GWjAuoqSzQaZEgMWOiKC7v+0dh0kMT1tngfDnDXZ3
         R8GA==
X-Gm-Message-State: AGi0Pua1L7EUswNMkzEshE9DJC6JK5NMFsBMCXDc/GgSob2yBzx8L7sL
        GanSorOMqd6Cul7XyXwtn7fGS72HTcJ14rWP+ffEiWwwOLOeMZVNY2mVawTDpqYJT6j5gtbZHFT
        haA0GvtoVI5RxoQTj
X-Received: by 2002:a05:651c:201d:: with SMTP id s29mr10762117ljo.214.1585666814998;
        Tue, 31 Mar 2020 08:00:14 -0700 (PDT)
X-Google-Smtp-Source: APiQypI1+tNZNJeOPz9nFhPOmeObo3bk1RZrrzDW2KZ9m7AUa7IZqv9Zl+hDWn/hktgSSyzohH3vDA==
X-Received: by 2002:a05:651c:201d:: with SMTP id s29mr10762089ljo.214.1585666814624;
        Tue, 31 Mar 2020 08:00:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k4sm6390339lfo.47.2020.03.31.08.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 08:00:12 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B571E18158D; Tue, 31 Mar 2020 17:00:10 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
        dsahern@gmail.com
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <86f95d7a-1659-a092-91a2-abe5d58ceda8@iogearbox.net>
References: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com> <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com> <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com> <87pncznvjy.fsf@toke.dk> <20200326195859.u6inotgrm3ubw5bx@ast-mbp> <87imiqm27d.fsf@toke.dk> <20200327230047.ois5esl35s63qorj@ast-mbp> <87lfnll0eh.fsf@toke.dk> <20200328022609.zfupojim7see5cqx@ast-mbp> <87eetcl1e3.fsf@toke.dk> <CAEf4Bzb+GSf8cE_rutiaeZOtAuUick1+RnkCBU=Z+oY_36ArSA@mail.gmail.com> <87y2rihruq.fsf@toke.dk> <CAEf4Bza4vKbjkj8kBkrVmayFr2j_nvrORF_YkCoVKibB=SmSYQ@mail.gmail.com> <87pncsj0hv.fsf@toke.dk> <86f95d7a-1659-a092-91a2-abe5d58ceda8@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 31 Mar 2020 17:00:10 +0200
Message-ID: <87blocin7p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 3/31/20 12:13 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>=20
>>>>> So you install your libxdp-based firewalls and are happy. Then you
>>>>> decide to install this awesome packet analyzer, which doesn't know
>>>>> about libxdp yet. Suddenly, you get all packets analyzer, but no more
>>>>> firewall, until users somehow notices that it's gone. Or firewall
>>>>> periodically checks that it's still runinng. Both not great, IMO, but
>>>>> might be acceptable for some users, I guess. But imagine all the
>>>>> confusion for user, especially if he doesn't give a damn about XDP and
>>>>> other buzzwords, but only needs a reliable firewall :)
>>>>
>>>> Yes, whereas if the firewall is using bpf_link, then the packet analys=
er
>>>> will be locked out and can't do its thing. Either way you end up with a
>>>> broken application; it's just moving the breakage. In the case of
>>>
>>> Hm... In one case firewall installation reported success and stopped
>>> working afterwards with no notification and user having no clue. In
>>> another, packet analyzer refused to start and reported error to user.
>>> Let's agree to disagree that those are not at all equivalent. To me
>>> silent failure is so much worse, than application failing to start in
>>> the first place.
>
> I sort of agree with both of you that either case is not great. The silent
> override we currently have is not great since it can be evicted at any ti=
me
> but also bpf_link to lock-out other programs at XDP layer is not great ei=
ther
> since there is also huge potential to break existing programs. It's proba=
bly
> best to discuss on an actual proposal to see the concrete semantics, but =
my
> concerns, assuming I didn't misunderstand or got confused on something al=
ong
> the way (if so, please let me know), currently are:

I think you're summarising the issues well, with perhaps one thing
missing: The goal is to enable multi-prog execution, i.e., execute two
programs in sequence. So, when things work correctly the flow should be:

App1, loading prog1:
- get current program from $IFACE
- current program is NULL:
  -> build dispatcher(prog1)
  -> load dispatcher onto $IFACE with UPDATE_IF_NOEXIST flag
  -> success

Then, app2 loading prog2:
- get current program from $IFACE
- current program is dispatcher(prog1):
  -> build new dispatcher(prog1,prog2)
  -> atomically replace old dispatcher with new one
  -> success

As long as app1 and app2 agree on what a dispatcher looks like, and how
to update it, they can cooperatively install themselves in the chain, as
long as there's a way to resolve the race between reading and updating
the state in the kernel.

However, if they *don't* agree on how to build the dispatcher and run in
sequence, they are fundamentally incompatible. Which also means that
multi-prog operation is going to be incompatible with any application
that was written before it was implemented. The only way to avoid that
is to provide the multi-prog support in the kernel, in a way that is
compatible with the old API. I'm not sure if this is even possible; but
I certainly got a very emphatic NACK on any attempt to implement the
support in the kernel when I posted my initial patch back in the fall.

Also, to your point about needing a specific library: I've been saying
"using the same library" because I think that is the most likely way to
get applications to agree. But really, what's needed is more like a
protocol; there could in theory be several independent implementations
that interoperate. However, I don't see a way to make things compatible
with applications that don't follow that protocol; we only get to pick
the failure mode (and those failure modes I think you summarised quite
well).

-Toke

