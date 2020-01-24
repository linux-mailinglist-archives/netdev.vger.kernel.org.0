Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F168149062
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgAXVqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:46:43 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:40024 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgAXVqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 16:46:43 -0500
Received: by mail-vs1-f67.google.com with SMTP id g23so2204402vsr.7;
        Fri, 24 Jan 2020 13:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g3h2PEx4+zDWu+bpgwa6Sz7xp4HsSCXJ98H8aWiqsgM=;
        b=RqvWeCLdCw2FoUuIskKQ4LvirnreC1No2TSRs+tmH8KbJ8eTapGuoM8242oRQFmKgG
         6tbsvTJOgpqNeDxr3/NFUVUgg08RAIiU4JM3PeBCXsubgI1rKVP4GnjmtZzRUDQNjpYJ
         M+Dc3mYDkw3GXbaaPoe40GfGE7hSFfGFC5IssVFfI7fGS2whxHU5gwnyeona67ARJkyn
         8eA1Lpn5uvkbFqEeHbbYeU4Y2vgt/HJKE+uPTFqy9huQPvGfBxL4Urzs11hjsbJeMw9j
         oENeLA0i119Al0o22k7U2zs6HmzAOewkVre8ZFOzbrZkF5eHHp/3IQ/l83Gz6qj9QHYd
         rHGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g3h2PEx4+zDWu+bpgwa6Sz7xp4HsSCXJ98H8aWiqsgM=;
        b=OWm3+Y1iiSZAsGCITtCXNXdgUi8ngR0HqxIGj2qjQNbu0+kW7INQeuqpmAS3JQlOCy
         STYVpTqTM7trGb9Czm8Xt0rbsycezs4tB9b19xovjJpvJKvZ1OjHH2A4L5T0Ak0lHhgK
         TbFbtQdBBtOdPGMSYq1pJ780/Fkc4r1QkTHTCoKxxF8KktiJUXut0KgAu1QOl5zkRIu+
         mTwOGZ5+z8EifZ+3wn3XLvGMll8pKS7cXxJzEOzzvxraotXZro4C4t0+Zoo4+FCzE0RN
         9e8aAMeb4ETh3onQJBY7UFoePn85pauOGKmaMtDRaP6MpDxWMtHQ7PviMy+9tZzqrys8
         WHYw==
X-Gm-Message-State: APjAAAXo8B9KrKE6mt0tcI3aHXwZjsL5XuNFfjFAJmJcF9qdWO5pJo6F
        O7TT/fIWWxMuE4BRZscR5OZmbeXYlm7neDJIPcM=
X-Google-Smtp-Source: APXvYqybUKBqM+Z2q1dDqANuOtLqMce/BxZwh6/KzeEUrB6bJK+7DKVz5X0npfZtLeh/HvTHrBEz2GFe7qi62k1mNJw=
X-Received: by 2002:a67:15c7:: with SMTP id 190mr3732308vsv.178.1579902401726;
 Fri, 24 Jan 2020 13:46:41 -0800 (PST)
MIME-Version: 1.0
References: <20200118000128.15746-1-matthew.cover@stackpath.com>
 <20200121202038.26490-1-matthew.cover@stackpath.com> <CAGyo_hpVm7q3ghW+je23xs3ja_COP_BMZoE_=phwGRzjSTih8w@mail.gmail.com>
 <CAOftzPi74gg=g8VK-43KmA7qqpiSYnJVoYUFDtPDwum10KHc2Q@mail.gmail.com>
In-Reply-To: <CAOftzPi74gg=g8VK-43KmA7qqpiSYnJVoYUFDtPDwum10KHc2Q@mail.gmail.com>
From:   Matt Cover <werekraken@gmail.com>
Date:   Fri, 24 Jan 2020 14:46:30 -0700
Message-ID: <CAGyo_hprQRLLUUnt9G4SJnbgLSdN=HTDDGFBsPYMDC5bGmTPYA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] bpf: add bpf_ct_lookup_{tcp,udp}() helpers
To:     Joe Stringer <joe@wand.net.nz>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Matthew Cover <matthew.cover@stackpath.com>,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 12:11 PM Joe Stringer <joe@wand.net.nz> wrote:

Joe, thank you for taking the time to respond. And thank you for your
efforts on the sk helpers; I both use them and borrowed heavily from
them in coding this submission.

>
> On Tue, Jan 21, 2020 at 12:36 PM Matt Cover <werekraken@gmail.com> wrote:
> >
> > On Tue, Jan 21, 2020 at 1:20 PM Matthew Cover <werekraken@gmail.com> wrote:
> > >
> > > Allow looking up an nf_conn. This allows eBPF programs to leverage
> > > nf_conntrack state for similar purposes to socket state use cases,
> > > as provided by the socket lookup helpers. This is particularly
> > > useful when nf_conntrack state is locally available, but socket
> > > state is not.
>
> I think there's an important distinction between accessing sockets and
> accessing the connection tracker: Sockets are inherently tied to local
> processes. They consume resources regardless of what kind of fancy
> networking behaviour you desire out of the stack. Connection-tracking
> on the other hand only consumes resources if you enable features that
> explicitly require that functionality. This raises some interesting
> questions.

Sockets require local config to exist; a service must be listening.
nf_conntrack entries require local config to exist. To me, this is
not so different.

In addition to the nf_conntrack helpers, I'm hoping to add helpers for
lookups to the ipvs connection table via ip_vs_conn_in_get(). From my
perspective, this is again similar. The connection is locally
known/owned, but there is no socket. The state lives elsewhere in the
kernel, but already exists.

There is no need to pay the memory cost for native bpf ct in these
cases (i.e. when nf_conntrack is already in use or when the flow
traverses ipvs rather than terminating at a socket).

>
> The kernel disables nf_conntrack by default to alleviate the costs
> associated with it[0]. In the case of this proposal, the BPF program
> itself is trying to use nf_conntrack, so does that mean that the
> kernel should auto-enable nf_conntrack hooks for the current namespace
> (or all namespaces, given that the helper provides access into other
> namespaces as well) whenever a BPF program is loaded that uses this
> helper?

I see no reason to auto-enable nf_conntrack. When nf_conntrack is
not present, unloaded, or not configured the helpers return NULL.
This is similar to the sk helpers when no service is listening on
<daddr>:<dport>.

>
> Related side note: What if you wanted to migitate the performance
> penalty of turning on nf_conntrack by programmatically choosing
> whether to populate the ct table? Do we then need to define an
> interface that allows a BPF program to tell nf_conntrack whether or
> not to track a given connection?

This certainly could be of interest for certain use cases. Adding
such functionality is neither included nor precluded by this
submission.

Writing to an existing nf_conn could be added to this helper in the
future. Then, as an example, an XDP program could populate ct->mark
and a restore mark rule could be used to apply the mark to the skb.
This is conceptually similar to the XDP/tc interaction example.

https://github.com/xdp-project/xdp-tutorial/tree/master/advanced01-xdp-tc-interact

Adding new entries would be another helper if desired. Again, there
is nothing I see in this submission to preclude the addition of such
a helper, it simply isn't part of my current use case.

>
> More importantly, nf_conntrack has a particular view in mind of what a
> connection is and the metadata that can be associated with a
> connection. On the other hand, one of the big pulls for building
> networking functionality in BPF is to allow flexibility. Over time,
> more complex use cases will arise that demand additional metadata to
> be stored with their connections. Cilium's connection tracking entries
> provides a glimpse of this[1]. I'm sure that the OVS-BPF project would
> have similar demands. Longer term, do we encourage such projects to
> migrate to this implementation, proposing metadata extensions that are
> programmable from BPF?

Presumably, such a push would require a helper to add new ct entries
which I see as beyond the scope of this submission. However, I would
imagine that, as long as a metadata extensions approach wasn't overly
cumbersome to use, the performance of the two ct solutions would be
the deciding factor.

>
> Taking the metadata question further, there is not only the metadata
> that arbitrary BPF programs wish to associate with nf_conntrack. There
> is also the various extensions that nf_conntrack itself has which
> could be interesting for users that depend on that state. Would we
> draw a line before providing access into those aspects of nf_conntrack
> from BPF?

I'm planning to add a bpf_tcp_nf_conn() helper which gives access to
members of ip_ct_tcp. This is similar to bpf_tcp_sock() in my mind.
Are these the types of extensions you mean?

>
> Beyond metadata, there is the question of write access to
> nf_conntrack. Presumably if a read helper like this is added to the
> BPF API, it is only balanced to also add create, update and delete
> operations? No doubt if someone wants to build NAT or firewall
> functionality in BPF using nf_conntrack, they will want this. Does
> this take us on the track of eventually exporting the entire
> nf_conntrack module (or even nf_nat) internal kernel APIs as external
> BPF API?

I touched on create and update above. Delete, like create, would
almost certainly be a separate helper. This submission is not
intended to put us on that track. I do not believe it hinders an
effort such as that either. Are you worried that adding nf_conn to
bpf is a slippery slope?

>
> If the BPF API is going to provide a connection tracker, I feel that
> it should aim to solve connection tracking for various potential
> users. This takes us from not just what this patch does, but to the
> full vision of where this API goes with a connection tracker
> implementation that could be reused by e.g. OVS-BPF or Cilium. At this
> point, I'm not convinced why such an implementation should exist in
> the BPF API rather than as a common library that can be forked and
> tweaked for anyone's uses.
>
> What do you see as the split of responsibility between BPF and other
> subsystems long-term for your use case that motivates relying upon
> nf_conntrack always running?

I do not see this as relying on nf_conntrack always running; I see
it as not always relying that flow/connection ownership is determined
by socket presence/state. Sockets, nf_conns, and ip_vs_conns are all
of interest for different workloads.

>
> [0] https://github.com/torvalds/linux/commit/4d3a57f23dec59f0a2362e63540b2d01b37afe0a
> [1] https://github.com/cilium/cilium/blob/v1.6.5/bpf/lib/common.h#L510
