Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162B1195F6A
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 21:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgC0UHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 16:07:19 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]:33781 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgC0UHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 16:07:18 -0400
Received: by mail-qk1-f169.google.com with SMTP id v7so12259976qkc.0;
        Fri, 27 Mar 2020 13:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=30+LaP+QDzRNwlR11XzGI1qWCK9CvBFUtiQrKwg0dJA=;
        b=jRg6R1b0r2yr1MlBiK2VQSEPBH0mWHrB0Vhqu338QB9xC5RLiyNDC5EIIV0BRhxdl8
         aeUqAVINvQd9+yqGb3LmyH8kDPuPNPMkzE8frPthcfMiTpgAx0toG7h+cDFiooXsUAxJ
         zyuMq08yI6rj4P1QC9od9ohjkPGlBo4fPLPXgKvfe/n9mt5f1RC9uON1Ea+NZTsHpzRB
         CwfqicVTPY4fY+eVt4gsx941uTx0j7190ezJNZuYLFYBST7YgyXBSW+02IMidwi5Koko
         ajhfVA4JR2yABHHBxQdo/if2xt63au7Xt/nQZTbRiir81HmxHcPc6mfV5g6Dw5xODUoZ
         /o/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=30+LaP+QDzRNwlR11XzGI1qWCK9CvBFUtiQrKwg0dJA=;
        b=W+N002dzP7N9istsQ4F3T43ohsGA24kqnXEOu8BjFUaTu7KtfCBIDgZ3qc1nyVpWQQ
         pzLsLU5LfsEU06tapG6DONfsA26IqscJf/m/nC5cm7zYrRSt+Yd2FUXV8NVapLzSEFt8
         974hZX8D8GggdCSb7wDguY/kYykI8pPfpmrSJOGNyBcivqH5bEIPHsrq2n5pGG+fohGt
         p5hw4rvhpyqbduFD4MZvDhLfmbrPv9sozsg2ORx3UJyz7wdq9DQyTYgFukY0126bnN0n
         xVIpYNv+iBSZdFd5b/VxAEpEf2gosKmkZwQd2M8S+YWoVLT1qS8W/nUBqXKH0zsWyui4
         3BJQ==
X-Gm-Message-State: ANhLgQ0Jsevq61F1kiDXV7yjLZeFuo+miRXTWqeO2NpwKIO0wO/kZx8K
        obQY7QML1anlreV94KAp0hGS+Z642uCYKRiucmk=
X-Google-Smtp-Source: ADFU+vt8RvzVdmD97g9R6KlTZe0sl75dA+0hcPx/Q52HBD56Hv3RsArycZgG/nj84Wbb2XHMLWVpbEtGshA3/lmSCoQ=
X-Received: by 2002:a37:992:: with SMTP id 140mr1139611qkj.36.1585339636389;
 Fri, 27 Mar 2020 13:07:16 -0700 (PDT)
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
 <87lfnmm35r.fsf@toke.dk>
In-Reply-To: <87lfnmm35r.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 27 Mar 2020 13:07:04 -0700
Message-ID: <CAEf4Bza7zQ+ii4SH=4gJqQdyCp9pm6qGAsBOwa0MG5AEofC2HQ@mail.gmail.com>
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

On Fri, Mar 27, 2020 at 4:46 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Thu, Mar 26, 2020 at 5:35 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > Now for XDP. It has same flawed model. And even if it seems to you
> >> > that it's not a big issue, and even if Jakub thinks we are trying to
> >> > solve non-existing problem, it is a real problem and a real concern
> >> > from people that have to support XDP in production with many
> >> > well-meaning developers developing BPF applications independently.
> >> > Copying what you wrote in another thread:
> >> >
> >> >> Setting aside the question of which is the best abstraction to repr=
esent
> >> >> an attachment, it seems to me that the actual behavioural problem (=
XDP
> >> >> programs being overridden by mistake) would be solvable by this pat=
ch,
> >> >> assuming well-behaved userspace applications.
> >> >
> >> > ... this is a horrible and unrealistic assumption that we just canno=
t
> >> > make and accept. However well-behaved userspace applications are, th=
ey
> >> > are written by people that make mistakes. And rather than blissfully
> >> > expect that everything will be fine, we want to have enforcements in
> >> > place that will prevent some buggy application to wreck havoc in
> >> > production.
> >>
> >> Look, I'm not trying to tell you how to managed your internal systems.
> >> I'm just objecting to your assertion that your deployment model is the
> >> only one that can possibly work, and the refusal to consider other
> >> alternatives that comes with it.
> >
> > Your assumption doesn't work for us. Because of that we need something
> > like bpf_link.
>
> I'm not disputing what you need for your use case; you obviously know
> better than me. I'm really just saying that your use case is not
> everyone's use case.
>
> > Existing attachment API doesn't go away and is still supported. Feel
> > free to use existing API.
>
> As far as I'm concerned that's what I'm trying to do. This patch series
> is really just fixing a bug in the existing API; to which the response
> was "no, that API is fundamentally broken, you have to use bpf_link
> instead". And *that* is what I am disputing.
>
> (I do have some reservations about details of bpf_link, see below, but
> I'm not actually totally against the whole concept).
>
> >> > 1. bpf_link represents a connection (pairing?) of BPF program and so=
me
> >> > BPF hook it is attached to. BPF hook could be perf event, cgroup,
> >> > netdev, etc. It's a completely independent object in itself, along t=
he
> >> > bpf_map and bpf_prog, which has its own lifetime and kernel
> >> > representation. To user-space application it is returned as an
> >> > installed FD, similar to loaded BPF program and BPF map. It is
> >> > important that it's not just a BPF program, because BPF program can =
be
> >> > attached to multiple BPF hooks (e.g., same XDP program can be attach=
ed
> >> > to multiple interface; same kprobe handler can be installed multiple
> >> > times), which means that having BPF program FD isn't enough to
> >> > uniquely represent that one specific BPF program attachment and deta=
ch
> >> > it or query it. Having kernel object for this allows to encapsulate
> >> > all these various details of what is attached were and present to
> >> > user-space a single handle (FD) to work with.
> >>
> >> For XDP there is already a unique handle, it's just implicit: Each
> >> netdev can have exactly one XDP program loaded. So I don't really see
> >> how bpf_link adds anything, other than another API for the same thing?
> >
> > I certainly failed to explain things clearly if you are still asking
> > this. See point #2, once you attach bpf_link you can't just replace
> > it. This is what XDP doesn't have right now.
>
> Those are two different things, though. I get that #2 is a new
> capability provided by bpf_link, I was just saying #1 isn't (for XDP).

bpf_link is combination of those different things... Independently
they are either impossible or insufficient. I'm not sure how that
doesn't answer your question:

> So I don't really see
> how bpf_link adds anything, other than another API for the same thing?

Please stop dodging. Just like with "rest of the kernel", but really
"just networking" from before.

>
> >> > 2. Due to having FD associated with bpf_link, it's not possible to
> >> > talk about "owning" bpf_link. If application created link and never
> >> > shared its FD with any other application, it is the sole owner of it=
.
> >> > But it also means that you can share it, if you need it. Now, once
> >> > application closes FD or app crashes and kernel automatically closes
> >> > that FD, bpf_link refcount is decremented. If it was the last or onl=
y
> >> > FD, it will trigger automatica detachment and clean up of that
> >> > particular BPF program attachment. Note, not a clean up of BPF
> >> > program, which can still be attached somewhere else: only that
> >> > particular attachment.
> >>
> >> This behaviour is actually one of my reservations against bpf_link for
> >> XDP: I think that automatically detaching XDP programs when the FD is
> >> closed is very much the wrong behaviour. An XDP program processes
> >> packets, and when loading one I very much expect it to keep doing that
> >> until I explicitly tell it to stop.
> >
> > As you mentioned earlier, "it's not the only one mode". Just like with
> > tracing APIs, you can imagine scripts that would adds their
> > packet-sniffing XDP program temporarily. If they crash, "temporarily"
> > turns into "permanently, but no one knows". This is bad. And again,
> > it's a choice, just with a default to auto-cleanup, because it's safe,
> > even if it requires extra step for applications willing to do
> > permanent XDP attachment.
>
> Well, there are two aspects to this: One is what should be the default -
> I'd argue that for XDP the most common case is 'permanent attachment'.
> But that can be worked around at the library level, so it's not that
> important (just a bit annoying for the library implementer, which just
> so happens to be me in this case :)).

Permanent attachment used to be common case for tracing until it
wasn't. Same is going to happen with cgroups. So not sure that's
strong argument, plus it's a matter of opinion, I don't think we can
have hard data on what's the most common use case. But my reasons are
due to safety, not popularity. Current default is not safe.

>
> The more important problem is that with "attach link + pin", we need two
> operations. So with that there is no longer a way to atomically do a
> permanent attach. And also there are two pieces of state (the pinned
> bpf_link + the attachment of that to the interface).

What does it mean "atomically do a permanent attach" and why is that
important? If your application attaches XDP and then crashes before it
can pin it, then it will be detached and cleaned up, which should
happen for every buggy program or if the environment is not set up
correctly (e.g., BPF FS is not mounted). Fix the program, if it can't
proceed without crashing to pinning. How is this important problem?

>
> >> > 3. This derives from the concept of ownership of bpf_link. Once
> >> > bpf_link is attached, no other application that doesn't own that
> >> > bpf_link can replace, detach or modify the link. For some cases it
> >> > doesn't matter. E.g., for tracing, all attachment to the same fentry
> >> > trampoline are completely independent. But for other cases this is
> >> > crucial property. E.g., when you attach BPF program in an exclusive
> >> > (single) mode, it means that particular cgroup and any of its childr=
en
> >> > cgroups can have any more BPF programs attached. This is important f=
or
> >> > container management systems to enforce invariants and correct
> >> > functioning of the system. Right now it's very easy to violate that =
-
> >> > you just go and attach your own BPF program, and previous BPF progra=
m
> >> > gets automatically detached without original application that put it
> >> > there knowing about this. Chaos ensues after that and real people ha=
ve
> >> > to deal with this. Which is why existing
> >> > BPF_PROG_ATTACH/BPF_PROG_DETACH API is inadequate and we are adding
> >> > bpf_link support.
> >>
> >> I can totally see how having an option to enforce a policy such as
> >> locking out others from installing cgroup BPF programs is useful. But
> >> such an option is just that: policy. So building this policy in as a
> >> fundamental property of the API seems like a bad idea; that is
> >> effectively enforcing policy in the kernel, isn't it?
> >
> > I hope we won't go into a dictionary definition of what "policy" means
> > here :). For me it's about guarantee that kernel gives to user-space.
> > bpf_link doesn't care about dictating policies. If you don't want this
> > guarantee - don't use bpf_link, use direct program attachment. As
> > simple as that. Policy is implemented by user-space application by
> > using APIs with just the right guarantees.
>
> Yes, but the user-space application shouldn't get to choose the policy -
> the system administrator should. So an application should be able to
> *request* this behaviour, but it should be a policy decision whether to
> allow it. If the "locking" behaviour is built-in to the API, that
> separation becomes impossible.

This doesn't make any sense. If kernel said that it successfully
attached my program then application has all the rights to believe it
is attached. And won't be arbitrarily replaced by some other
application. This is not policy, this is fundamental guarantees.

Imagine that one application opens file and then seeks to some
position. Then another application runs, opens same file and seeks to
another position. Suddenly first application's file position gets
reset because of independent second application. That's not policy,
that's broken API.

Also, all this talk about well-behaved cooperation applications we
had. If that was reliable way to do things, kernels would just
implement cooperative multi-tasking and be done with it.

>
> >> > Those same folks have similar concern with XDP. In the world where
> >> > container management installs "root" XDP program which other user
> >> > applications can plug into (libxdp use case, right?), it's crucial t=
o
> >> > ensure that this root XDP program is not accidentally overwritten by
> >> > some well-meaning, but not overly cautious developer experimenting i=
n
> >> > his own container with XDP programs. This is where bpf_link ownershi=
p
> >> > plays a huge role. Tupperware agent (FB's container management agent=
)
> >> > would install root XDP program and will hold onto this bpf_link
> >> > without sharing it with other applications. That will guarantee that
> >> > the system will be stable and can't be compromised.
> >>
> >> See this is where we get into "deployment-model specific territory". I
> >> mean, sure, in the "central management daemon" model, it makes sense
> >> that no other applications can replace the XDP program. But, erm, we
> >> already have a mechanism to ensure that: Just don't grant those
> >> applications CAP_NET_ADMIN? So again, bpf_link doesn't really seem to
> >> add anything other than a different way to do the same thing?
> >
> > Because there are still applications that need CAP_NET_ADMIN in order
> > to function (for other reasons than attaching XDP), so it's impossible
> > to enforce with for everyone.
>
> But if you grant an application CAP_NET_ADMIN, it can wreak all sorts of
> havoc (the most obvious being just issuing 'ip link down' on the iface).
> So you're implicitly trusting it to be well-behaved, so why does this
> particular act of misbehaviour need a special kernel enforcement
> mechanism?

Well-behaved in the sense of not bringing system down, yes. But not
well-behaved in the sense of aware of all other BPF XDP users. It's
impossible to coordinate with 100% guarantee in a real-world big
company environment.

>
> >> Additionally, in the case where there is *not* a central management
> >> daemon (i.e., what I'm implementing with libxdp), this would be the fl=
ow
> >> implemented by the library without bpf_link:
> >>
> >> 1. Query kernel for current BPF prog loaded on $IFACE
> >> 2. Sanity-check that this program is a dispatcher program installed by
> >>    libxdp
> >> 3. Create a new dispatcher program with whatever changes we want to do
> >>    (such as adding another component program).
> >> 4. Atomically replace the old program with the new one using the netli=
nk
> >>    API in this patch series.
> >>
> >> Whereas with bpf_link, it would be:
> >>
> >> 1. Find the pinned bpf_link for $IFACE (e.g., load from
> >>    /sys/fs/bpf/iface-links/$IFNAME).
> >
> > But now you can hide this mount point from containerized
> > root/CAP_NET_ADMIN application, can't you? See the difference? One
> > might think about bpf_link as a fine-grained capability in this sense.
>
> Yes, that may be a feature. But it may also be an anti-feature (I can't
> move an iface to a new namespace that doesn't have the original bpffs
> *without* preventing that namespace from replacing the XDP program).

There are other ways to share bpf_link FD, if sharing BPF FS is not an opti=
on.

> Also, why are we re-inventing an ad-hoc capability mechanism?

We are not, it's an analogy. Also, as far as I understand, existing
capabilities are all that fine grained to express any of this?

>
> -Toke
>
