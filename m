Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9CB9195689
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 12:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgC0LqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 07:46:17 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:43085 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726454AbgC0LqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 07:46:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585309575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D+jWPfX+2ounu0Ujnr2T81sRMEOd+W+vaYMJD2AA2V8=;
        b=esEdnNQBblGkUvIJbai5ElnJLxxg2X7qgEhzF+y66NrCUD6RreGOejrrfNbVg7mpFaplnA
        OWGctYHTFGla3vITyeyKTDYoJDz1CijPL0rMu4Pp3eV4/DtfsGGEYDTwnyMW1aKz5rb58a
        LhI7h8d9B4mZhZnGWVkyw4wNDg6VM3s=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-7Z_XeQclN7uEty7ZhLFxRA-1; Fri, 27 Mar 2020 07:46:13 -0400
X-MC-Unique: 7Z_XeQclN7uEty7ZhLFxRA-1
Received: by mail-lj1-f200.google.com with SMTP id d8so1173102ljg.15
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 04:46:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=D+jWPfX+2ounu0Ujnr2T81sRMEOd+W+vaYMJD2AA2V8=;
        b=OgEo8qdSwlKsfK8NZr4wpe06ZRzcc9+zjyj/hj2vt5I495glTM0iV6GEJsnahvyRYo
         1wcZXXXr22lpF1NgU2g8jyFBy1WjWO3WafpHwfSfwb9ISaxT3f17Xdt7hFyXs+2rixfj
         fgjC73WKouB+jf/Jcoj9DIiPbAMZZ1xhTn7WcWVXt4qoMdTMmQUyusTQNfTXrSCc0Qxi
         PhUpKlebOUAaqbI5oidAZNNsbJLjJ8jFWlsbBOJ9QFXknBB2FIckeevzTEhBJLbzNSDx
         +hvpE9zlcYn5iR082ijOYRP+V/DQcPnzor3zyqXN7b4U6X3EY+j58HMoharg/pBNYeYd
         rQ2g==
X-Gm-Message-State: ANhLgQ0vysuIkwORg+7/OwyzUc9P3ZM6qiBlMPuDl5gaAnkmtdLVNgwO
        KoENAFkx5yiXX2tHOC5KKOmmgpc+VuU+CQjmE40+L+VdByRmy8AmCSl0oKu00DJtGMiaf9PA7+t
        gg1pOblXnll9M9oWR
X-Received: by 2002:ac2:5594:: with SMTP id v20mr8986390lfg.2.1585309571907;
        Fri, 27 Mar 2020 04:46:11 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtP/5jmaJh8eGzRsdYdgK3PEsNAjs41z+kMtY1SikDAqPBxMqVlLdtBVXtooELvmevghYHMsw==
X-Received: by 2002:ac2:5594:: with SMTP id v20mr8986361lfg.2.1585309571480;
        Fri, 27 Mar 2020 04:46:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id c23sm636824lfc.69.2020.03.27.04.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 04:46:09 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B808E18158B; Fri, 27 Mar 2020 12:46:08 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <CAEf4BzaPQ6=h8a6Ngz638AtL4LmBLLVMV+_-YLMR=Ls+drd5HQ@mail.gmail.com>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk> <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN> <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN> <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch> <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com> <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com> <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com> <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com> <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com> <87pncznvjy.fsf@toke.dk> <CAEf4BzaPQ6=h8a6Ngz638AtL4LmBLLVMV+_-YLMR=Ls+drd5HQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 27 Mar 2020 12:46:08 +0100
Message-ID: <87lfnmm35r.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Thu, Mar 26, 2020 at 5:35 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > Now for XDP. It has same flawed model. And even if it seems to you
>> > that it's not a big issue, and even if Jakub thinks we are trying to
>> > solve non-existing problem, it is a real problem and a real concern
>> > from people that have to support XDP in production with many
>> > well-meaning developers developing BPF applications independently.
>> > Copying what you wrote in another thread:
>> >
>> >> Setting aside the question of which is the best abstraction to repres=
ent
>> >> an attachment, it seems to me that the actual behavioural problem (XDP
>> >> programs being overridden by mistake) would be solvable by this patch,
>> >> assuming well-behaved userspace applications.
>> >
>> > ... this is a horrible and unrealistic assumption that we just cannot
>> > make and accept. However well-behaved userspace applications are, they
>> > are written by people that make mistakes. And rather than blissfully
>> > expect that everything will be fine, we want to have enforcements in
>> > place that will prevent some buggy application to wreck havoc in
>> > production.
>>
>> Look, I'm not trying to tell you how to managed your internal systems.
>> I'm just objecting to your assertion that your deployment model is the
>> only one that can possibly work, and the refusal to consider other
>> alternatives that comes with it.
>
> Your assumption doesn't work for us. Because of that we need something
> like bpf_link.

I'm not disputing what you need for your use case; you obviously know
better than me. I'm really just saying that your use case is not
everyone's use case.

> Existing attachment API doesn't go away and is still supported. Feel
> free to use existing API.

As far as I'm concerned that's what I'm trying to do. This patch series
is really just fixing a bug in the existing API; to which the response
was "no, that API is fundamentally broken, you have to use bpf_link
instead". And *that* is what I am disputing.

(I do have some reservations about details of bpf_link, see below, but
I'm not actually totally against the whole concept).

>> > 1. bpf_link represents a connection (pairing?) of BPF program and some
>> > BPF hook it is attached to. BPF hook could be perf event, cgroup,
>> > netdev, etc. It's a completely independent object in itself, along the
>> > bpf_map and bpf_prog, which has its own lifetime and kernel
>> > representation. To user-space application it is returned as an
>> > installed FD, similar to loaded BPF program and BPF map. It is
>> > important that it's not just a BPF program, because BPF program can be
>> > attached to multiple BPF hooks (e.g., same XDP program can be attached
>> > to multiple interface; same kprobe handler can be installed multiple
>> > times), which means that having BPF program FD isn't enough to
>> > uniquely represent that one specific BPF program attachment and detach
>> > it or query it. Having kernel object for this allows to encapsulate
>> > all these various details of what is attached were and present to
>> > user-space a single handle (FD) to work with.
>>
>> For XDP there is already a unique handle, it's just implicit: Each
>> netdev can have exactly one XDP program loaded. So I don't really see
>> how bpf_link adds anything, other than another API for the same thing?
>
> I certainly failed to explain things clearly if you are still asking
> this. See point #2, once you attach bpf_link you can't just replace
> it. This is what XDP doesn't have right now.

Those are two different things, though. I get that #2 is a new
capability provided by bpf_link, I was just saying #1 isn't (for XDP).

>> > 2. Due to having FD associated with bpf_link, it's not possible to
>> > talk about "owning" bpf_link. If application created link and never
>> > shared its FD with any other application, it is the sole owner of it.
>> > But it also means that you can share it, if you need it. Now, once
>> > application closes FD or app crashes and kernel automatically closes
>> > that FD, bpf_link refcount is decremented. If it was the last or only
>> > FD, it will trigger automatica detachment and clean up of that
>> > particular BPF program attachment. Note, not a clean up of BPF
>> > program, which can still be attached somewhere else: only that
>> > particular attachment.
>>
>> This behaviour is actually one of my reservations against bpf_link for
>> XDP: I think that automatically detaching XDP programs when the FD is
>> closed is very much the wrong behaviour. An XDP program processes
>> packets, and when loading one I very much expect it to keep doing that
>> until I explicitly tell it to stop.
>
> As you mentioned earlier, "it's not the only one mode". Just like with
> tracing APIs, you can imagine scripts that would adds their
> packet-sniffing XDP program temporarily. If they crash, "temporarily"
> turns into "permanently, but no one knows". This is bad. And again,
> it's a choice, just with a default to auto-cleanup, because it's safe,
> even if it requires extra step for applications willing to do
> permanent XDP attachment.

Well, there are two aspects to this: One is what should be the default -
I'd argue that for XDP the most common case is 'permanent attachment'.
But that can be worked around at the library level, so it's not that
important (just a bit annoying for the library implementer, which just
so happens to be me in this case :)).

The more important problem is that with "attach link + pin", we need two
operations. So with that there is no longer a way to atomically do a
permanent attach. And also there are two pieces of state (the pinned
bpf_link + the attachment of that to the interface).

>> > 3. This derives from the concept of ownership of bpf_link. Once
>> > bpf_link is attached, no other application that doesn't own that
>> > bpf_link can replace, detach or modify the link. For some cases it
>> > doesn't matter. E.g., for tracing, all attachment to the same fentry
>> > trampoline are completely independent. But for other cases this is
>> > crucial property. E.g., when you attach BPF program in an exclusive
>> > (single) mode, it means that particular cgroup and any of its children
>> > cgroups can have any more BPF programs attached. This is important for
>> > container management systems to enforce invariants and correct
>> > functioning of the system. Right now it's very easy to violate that -
>> > you just go and attach your own BPF program, and previous BPF program
>> > gets automatically detached without original application that put it
>> > there knowing about this. Chaos ensues after that and real people have
>> > to deal with this. Which is why existing
>> > BPF_PROG_ATTACH/BPF_PROG_DETACH API is inadequate and we are adding
>> > bpf_link support.
>>
>> I can totally see how having an option to enforce a policy such as
>> locking out others from installing cgroup BPF programs is useful. But
>> such an option is just that: policy. So building this policy in as a
>> fundamental property of the API seems like a bad idea; that is
>> effectively enforcing policy in the kernel, isn't it?
>
> I hope we won't go into a dictionary definition of what "policy" means
> here :). For me it's about guarantee that kernel gives to user-space.
> bpf_link doesn't care about dictating policies. If you don't want this
> guarantee - don't use bpf_link, use direct program attachment. As
> simple as that. Policy is implemented by user-space application by
> using APIs with just the right guarantees.

Yes, but the user-space application shouldn't get to choose the policy -
the system administrator should. So an application should be able to
*request* this behaviour, but it should be a policy decision whether to
allow it. If the "locking" behaviour is built-in to the API, that
separation becomes impossible.

>> > Those same folks have similar concern with XDP. In the world where
>> > container management installs "root" XDP program which other user
>> > applications can plug into (libxdp use case, right?), it's crucial to
>> > ensure that this root XDP program is not accidentally overwritten by
>> > some well-meaning, but not overly cautious developer experimenting in
>> > his own container with XDP programs. This is where bpf_link ownership
>> > plays a huge role. Tupperware agent (FB's container management agent)
>> > would install root XDP program and will hold onto this bpf_link
>> > without sharing it with other applications. That will guarantee that
>> > the system will be stable and can't be compromised.
>>
>> See this is where we get into "deployment-model specific territory". I
>> mean, sure, in the "central management daemon" model, it makes sense
>> that no other applications can replace the XDP program. But, erm, we
>> already have a mechanism to ensure that: Just don't grant those
>> applications CAP_NET_ADMIN? So again, bpf_link doesn't really seem to
>> add anything other than a different way to do the same thing?
>
> Because there are still applications that need CAP_NET_ADMIN in order
> to function (for other reasons than attaching XDP), so it's impossible
> to enforce with for everyone.

But if you grant an application CAP_NET_ADMIN, it can wreak all sorts of
havoc (the most obvious being just issuing 'ip link down' on the iface).
So you're implicitly trusting it to be well-behaved, so why does this
particular act of misbehaviour need a special kernel enforcement
mechanism?

>> Additionally, in the case where there is *not* a central management
>> daemon (i.e., what I'm implementing with libxdp), this would be the flow
>> implemented by the library without bpf_link:
>>
>> 1. Query kernel for current BPF prog loaded on $IFACE
>> 2. Sanity-check that this program is a dispatcher program installed by
>>    libxdp
>> 3. Create a new dispatcher program with whatever changes we want to do
>>    (such as adding another component program).
>> 4. Atomically replace the old program with the new one using the netlink
>>    API in this patch series.
>>
>> Whereas with bpf_link, it would be:
>>
>> 1. Find the pinned bpf_link for $IFACE (e.g., load from
>>    /sys/fs/bpf/iface-links/$IFNAME).
>
> But now you can hide this mount point from containerized
> root/CAP_NET_ADMIN application, can't you? See the difference? One
> might think about bpf_link as a fine-grained capability in this sense.

Yes, that may be a feature. But it may also be an anti-feature (I can't
move an iface to a new namespace that doesn't have the original bpffs
*without* preventing that namespace from replacing the XDP program).
Also, why are we re-inventing an ad-hoc capability mechanism?

-Toke

