Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8314919470A
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 20:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgCZTG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 15:06:27 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46442 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbgCZTG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 15:06:27 -0400
Received: by mail-qk1-f194.google.com with SMTP id u4so7986265qkj.13;
        Thu, 26 Mar 2020 12:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+QKTPfD9OvgI3lpdwM+CX3iqLbx/PRY3v4Bh5KM/ioo=;
        b=ZvpWjvrLIUs8+iqqQ1JFQo0n/oPor4pTKU/NJt2sddFN5n2CIWIjrdTTumXkHWqgW1
         SZXZ3q2cqDRqXZgtNFOfVmiJfMeD1DL5v3gooZ18OPlNIAYGzfRfgKTZDOFmrgcMAwmw
         utJNQDck91PaVZwv5u4ZrascstVllifDVJ8X3V88ImcAtc4BgcY1k9W1C3w9RHLRqn9P
         z1wRY2wjqfrqkGJlaGiDtMPDIRF8D+1ECs5iabMQvCksLlgmIY1d0EwJ1QCiUPrtpNSl
         pIfDrNz660uxm4xWIDasuZL3qyOA5Y9s2lvrF004XZVZQEBSixWVWIiy6iPXhCpp0peG
         pDeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+QKTPfD9OvgI3lpdwM+CX3iqLbx/PRY3v4Bh5KM/ioo=;
        b=C2/RS/aoG8DWd5hPd5k/CpcW78Dx8ZtCFPe59D8OxDJ8nmYrXezooMb7DOSEsp4NTK
         RRSUGCh7lDA8RE/li9B0OsJCdAHGVtdcb+Qn72TIwK2fdXemY3kPBjQy+tPeJavaqP3J
         CqVuWyd0q2DtUPWhAPY04Mx532IG8kntK4NRhhMy9Cx0NAk51o2muHg9zCs56xW3Vsrw
         CQuwpVFlVqMwrYQ0h2eAGYaGF5A9l1jhekkJJ8bhsQltL4OOnEQSPwlzUsv2XjX1ONDu
         Peg7cmjMRWbq97rZHZmlgKM2l8x/4QSe9WCxeL0bfctp+tpoXW/RMwQbzYW9gvIsUu/d
         G7Kg==
X-Gm-Message-State: ANhLgQ2oaSmIK1HWlwHQzmwtboYvL0zmFDt1HA9X/N6iAYSGOZaWsuBk
        ghAeLg8nIqsxV0wWBuFYEGL9Fri0hYMtmplZ8To6P6L4ulQ=
X-Google-Smtp-Source: ADFU+vs7lVuEnHKctDVtVENnKLGIbMS1lD+LcS4OeHOWzBYvR9Z/cYgv/Wr9uvE4ApvciLZ1yB/SZJCf51cEtBNFlZA=
X-Received: by 2002:a37:e40d:: with SMTP id y13mr9784428qkf.39.1585249585727;
 Thu, 26 Mar 2020 12:06:25 -0700 (PDT)
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
 <87pncznvjy.fsf@toke.dk>
In-Reply-To: <87pncznvjy.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 26 Mar 2020 12:06:13 -0700
Message-ID: <CAEf4BzaPQ6=h8a6Ngz638AtL4LmBLLVMV+_-YLMR=Ls+drd5HQ@mail.gmail.com>
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

On Thu, Mar 26, 2020 at 5:35 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > Now for XDP. It has same flawed model. And even if it seems to you
> > that it's not a big issue, and even if Jakub thinks we are trying to
> > solve non-existing problem, it is a real problem and a real concern
> > from people that have to support XDP in production with many
> > well-meaning developers developing BPF applications independently.
> > Copying what you wrote in another thread:
> >
> >> Setting aside the question of which is the best abstraction to represe=
nt
> >> an attachment, it seems to me that the actual behavioural problem (XDP
> >> programs being overridden by mistake) would be solvable by this patch,
> >> assuming well-behaved userspace applications.
> >
> > ... this is a horrible and unrealistic assumption that we just cannot
> > make and accept. However well-behaved userspace applications are, they
> > are written by people that make mistakes. And rather than blissfully
> > expect that everything will be fine, we want to have enforcements in
> > place that will prevent some buggy application to wreck havoc in
> > production.
>
> Look, I'm not trying to tell you how to managed your internal systems.
> I'm just objecting to your assertion that your deployment model is the
> only one that can possibly work, and the refusal to consider other
> alternatives that comes with it.

Your assumption doesn't work for us. Because of that we need something
like bpf_link. Existing attachment API doesn't go away and is still
supported. Feel free to use existing API. As for EXPECTED_FD API you
are adding, it will be up to maintainers to decide, ultimately, I
can't block it, even if I wanted to.

>
> >> You're saying that like we didn't already have the netlink API. We
> >> essentially already have (the equivalent of) LINK_CREATE and LINK_QUER=
Y,
> >> this is just adding LINK_UPDATE. It's a straight-forward fix of an
> >> existing API; essentially you're saying we should keep the old API in =
a
> >> crippled state in order to promote your (proposed) new API.
> >
> > This is the fundamental disagreement that we seem to have. XDP's BPF
> > program attachment is not in any way equivalent to bpf_link. So no,
> > netlink API currently doesn't have anything that's close to bpf_link.
> > Let me try to summarize what bpf_link is and what are its fundamental
> > properties regardless of type of BPF programs.
>
> First of all, thank you for this summary; that is very useful!

Sure, you're welcome.

>
> > 1. bpf_link represents a connection (pairing?) of BPF program and some
> > BPF hook it is attached to. BPF hook could be perf event, cgroup,
> > netdev, etc. It's a completely independent object in itself, along the
> > bpf_map and bpf_prog, which has its own lifetime and kernel
> > representation. To user-space application it is returned as an
> > installed FD, similar to loaded BPF program and BPF map. It is
> > important that it's not just a BPF program, because BPF program can be
> > attached to multiple BPF hooks (e.g., same XDP program can be attached
> > to multiple interface; same kprobe handler can be installed multiple
> > times), which means that having BPF program FD isn't enough to
> > uniquely represent that one specific BPF program attachment and detach
> > it or query it. Having kernel object for this allows to encapsulate
> > all these various details of what is attached were and present to
> > user-space a single handle (FD) to work with.
>
> For XDP there is already a unique handle, it's just implicit: Each
> netdev can have exactly one XDP program loaded. So I don't really see
> how bpf_link adds anything, other than another API for the same thing?

I certainly failed to explain things clearly if you are still asking
this. See point #2, once you attach bpf_link you can't just replace
it. This is what XDP doesn't have right now.

It's a game of picking features/properties in isolation and "we can do
this particular thing this different way with what we have". Please,
try consider all of it together, it's important. Every single aspect
of bpf_link is not that unique, but it's all of them together that
matter.

>
> > 2. Due to having FD associated with bpf_link, it's not possible to
> > talk about "owning" bpf_link. If application created link and never
> > shared its FD with any other application, it is the sole owner of it.
> > But it also means that you can share it, if you need it. Now, once
> > application closes FD or app crashes and kernel automatically closes
> > that FD, bpf_link refcount is decremented. If it was the last or only
> > FD, it will trigger automatica detachment and clean up of that
> > particular BPF program attachment. Note, not a clean up of BPF
> > program, which can still be attached somewhere else: only that
> > particular attachment.
>
> This behaviour is actually one of my reservations against bpf_link for
> XDP: I think that automatically detaching XDP programs when the FD is
> closed is very much the wrong behaviour. An XDP program processes
> packets, and when loading one I very much expect it to keep doing that
> until I explicitly tell it to stop.

As you mentioned earlier, "it's not the only one mode". Just like with
tracing APIs, you can imagine scripts that would adds their
packet-sniffing XDP program temporarily. If they crash, "temporarily"
turns into "permanently, but no one knows". This is bad. And again,
it's a choice, just with a default to auto-cleanup, because it's safe,
even if it requires extra step for applications willing to do
permanent XDP attachment.

>
> > 3. This derives from the concept of ownership of bpf_link. Once
> > bpf_link is attached, no other application that doesn't own that
> > bpf_link can replace, detach or modify the link. For some cases it
> > doesn't matter. E.g., for tracing, all attachment to the same fentry
> > trampoline are completely independent. But for other cases this is
> > crucial property. E.g., when you attach BPF program in an exclusive
> > (single) mode, it means that particular cgroup and any of its children
> > cgroups can have any more BPF programs attached. This is important for
> > container management systems to enforce invariants and correct
> > functioning of the system. Right now it's very easy to violate that -
> > you just go and attach your own BPF program, and previous BPF program
> > gets automatically detached without original application that put it
> > there knowing about this. Chaos ensues after that and real people have
> > to deal with this. Which is why existing
> > BPF_PROG_ATTACH/BPF_PROG_DETACH API is inadequate and we are adding
> > bpf_link support.
>
> I can totally see how having an option to enforce a policy such as
> locking out others from installing cgroup BPF programs is useful. But
> such an option is just that: policy. So building this policy in as a
> fundamental property of the API seems like a bad idea; that is
> effectively enforcing policy in the kernel, isn't it?

I hope we won't go into a dictionary definition of what "policy" means
here :). For me it's about guarantee that kernel gives to user-space.
bpf_link doesn't care about dictating policies. If you don't want this
guarantee - don't use bpf_link, use direct program attachment. As
simple as that. Policy is implemented by user-space application by
using APIs with just the right guarantees.

>
> > Those same folks have similar concern with XDP. In the world where
> > container management installs "root" XDP program which other user
> > applications can plug into (libxdp use case, right?), it's crucial to
> > ensure that this root XDP program is not accidentally overwritten by
> > some well-meaning, but not overly cautious developer experimenting in
> > his own container with XDP programs. This is where bpf_link ownership
> > plays a huge role. Tupperware agent (FB's container management agent)
> > would install root XDP program and will hold onto this bpf_link
> > without sharing it with other applications. That will guarantee that
> > the system will be stable and can't be compromised.
>
> See this is where we get into "deployment-model specific territory". I
> mean, sure, in the "central management daemon" model, it makes sense
> that no other applications can replace the XDP program. But, erm, we
> already have a mechanism to ensure that: Just don't grant those
> applications CAP_NET_ADMIN? So again, bpf_link doesn't really seem to
> add anything other than a different way to do the same thing?

Because there are still applications that need CAP_NET_ADMIN in order
to function (for other reasons than attaching XDP), so it's impossible
to enforce with for everyone.

>
> Additionally, in the case where there is *not* a central management
> daemon (i.e., what I'm implementing with libxdp), this would be the flow
> implemented by the library without bpf_link:
>
> 1. Query kernel for current BPF prog loaded on $IFACE
> 2. Sanity-check that this program is a dispatcher program installed by
>    libxdp
> 3. Create a new dispatcher program with whatever changes we want to do
>    (such as adding another component program).
> 4. Atomically replace the old program with the new one using the netlink
>    API in this patch series.
>
> Whereas with bpf_link, it would be:
>
> 1. Find the pinned bpf_link for $IFACE (e.g., load from
>    /sys/fs/bpf/iface-links/$IFNAME).

But now you can hide this mount point from containerized
root/CAP_NET_ADMIN application, can't you? See the difference? One
might think about bpf_link as a fine-grained capability in this sense.


> 2. Query kernel for current BPF prog linked to $LINK
> 3. Sanity-check that this program is a dispatcher program installed by
>    libxdp
> 4. Create a new dispatcher program with whatever changes we want to do
>    (such as adding another component program).
> 5. Atomically replace the old program with the new one using the
>    LINK_UPDATE bpf() API.
>
>
> So all this does is add an additional step, and another dependency on
> bpffs. And crucially, I really don't see how the "bpf_link is the only
> thing that is not fundamentally broken" argument holds up.
>
> -Toke
>
