Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58392C96CF
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 04:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbfJCCrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 22:47:16 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39409 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfJCCrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 22:47:15 -0400
Received: by mail-qt1-f196.google.com with SMTP id n7so1537758qtb.6;
        Wed, 02 Oct 2019 19:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pwuUcNwfLJmUgbZ/recv15iJIKnaqtwVcxZNVlHAusM=;
        b=SFdiQuMkLMDgzmTsFkdjyQpAJA1OncM+bCGdNgL87KgxsjXwbTswp23HxyfKoNkDJA
         V3fN2i7kUHv0tbr5FhiIHHYf7CzfvEMF+78wtk5X8nK/iyeOLc052vKdK7iipzhDMxMV
         qxXHDiLSpZgUunLTRhucPzHEf0iEuV4/EQzrs+jRymBJ7YREKTMkaKiy/R5fs/kBd4rT
         VrRDRmE2xsFldO/1YVN/tM+TuzbezIqtuaKvel8zPDL2EJGg3tg9mPjAcwBITVeOK/2+
         ZkGHe1nIZ/n9JQ70mgKqyXdG8K8uZesVQTxyXfT0igB4SiPTXM6YqoYNo/PET6I5x2jG
         I76Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pwuUcNwfLJmUgbZ/recv15iJIKnaqtwVcxZNVlHAusM=;
        b=rAP/jRyhclKtUjnFQ9Eqw3ljpI37QusUxsy1apBvCVLUpINYQAEBwgMifvqtuF3Do2
         pNRc/ftDQevGHs4lDi/knALo7hAhDg+pl5tdLjjVOg726XPU9votdc246KZA/SHVtMab
         9hyKpgp4J6ckl2t8bwtxvwMmQtydK/O3FsZn5YYoYzAzdh/HofGRua/vzLgKwmrJFlOb
         CBvXZySTchs2f4DPQT0/enAUS5c5qU/1rtmWp7e5k7Ezj7yR2TbFM9LeYpYHl+HEzMM9
         KlUYMVv4AG9Ut7APqEgLAVd0MwlGKMiTEr818GXukC11McKyVKH6xVDBWtVIln3V0FnQ
         UYAg==
X-Gm-Message-State: APjAAAVknFQnLbsbjSq3xvtJDr7krL7Klc9m3JNiZ5Cu8HaDMwecsgRm
        jh6OSlSZ+B+To1ble8CoCYygDOouh9Av6wBp3B4=
X-Google-Smtp-Source: APXvYqxmyENdypIbJ63XmK5BNaVqUpjtljOeo7js/viCjXq4h0DBsm8b/JwaE5HJrKZHaa02WW3xMNQUYnD8LRC8k3A=
X-Received: by 2002:a0c:d284:: with SMTP id q4mr6318864qvh.228.1570070834025;
 Wed, 02 Oct 2019 19:47:14 -0700 (PDT)
MIME-Version: 1.0
References: <20191002173357.253643-1-sdf@google.com> <20191002173357.253643-2-sdf@google.com>
 <CAEf4BzZuEChOL828F91wLxUr3h2yfAkZvhsyoSx18uSFSxOtqw@mail.gmail.com> <20191003014356.GC3223377@mini-arch>
In-Reply-To: <20191003014356.GC3223377@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Oct 2019 19:47:02 -0700
Message-ID: <CAEf4BzZnWkdFpSUsSBenDDfrvgjGvBxUnJmQRwb7xjNQBaKXdQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf/flow_dissector: add mode to enforce
 global BPF flow dissector
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 6:43 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 10/02, Andrii Nakryiko wrote:
> > On Wed, Oct 2, 2019 at 10:35 AM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > Always use init_net flow dissector BPF program if it's attached and fall
> > > back to the per-net namespace one. Also, deny installing new programs if
> > > there is already one attached to the root namespace.
> > > Users can still detach their BPF programs, but can't attach any
> > > new ones (-EPERM).

I find this quite confusing for users, honestly. If there is no root
namespace dissector we'll successfully attach per-net ones and they
will be working fine. That some process will attach root one and all
the previously successfully working ones will suddenly "break" without
users potentially not realizing why. I bet this will be hair-pulling
investigation for someone. Furthermore, if root net dissector is
already attached, all subsequent attachment will now start failing.

I'm not sure what's the better behavior here is, but maybe at least
forcibly detach already attached ones, so when someone goes and tries
to investigate, they will see that their BPF program is not attached
anymore. Printing dmesg warning would be hugely useful here as well.

Alternatively, if there is any per-net dissector attached, we might
disallow root net dissector to be installed. Sort of "too late to the
party" way, but at least not surprising to successfully installed
dissectors.

Thoughts?

> > >
> > > Cc: Petar Penkov <ppenkov@google.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  Documentation/bpf/prog_flow_dissector.rst |  3 +++
> > >  net/core/flow_dissector.c                 | 11 ++++++++++-
> > >  2 files changed, 13 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/Documentation/bpf/prog_flow_dissector.rst b/Documentation/bpf/prog_flow_dissector.rst
> > > index a78bf036cadd..4d86780ab0f1 100644
> > > --- a/Documentation/bpf/prog_flow_dissector.rst
> > > +++ b/Documentation/bpf/prog_flow_dissector.rst
> > > @@ -142,3 +142,6 @@ BPF flow dissector doesn't support exporting all the metadata that in-kernel
> > >  C-based implementation can export. Notable example is single VLAN (802.1Q)
> > >  and double VLAN (802.1AD) tags. Please refer to the ``struct bpf_flow_keys``
> > >  for a set of information that's currently can be exported from the BPF context.
> > > +
> > > +When BPF flow dissector is attached to the root network namespace (machine-wide
> > > +policy), users can't override it in their child network namespaces.
> > > diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> > > index 7c09d87d3269..494e2016fe84 100644
> > > --- a/net/core/flow_dissector.c
> > > +++ b/net/core/flow_dissector.c
> > > @@ -115,6 +115,11 @@ int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
> > >         struct bpf_prog *attached;
> > >         struct net *net;
> > >
> > > +       if (rcu_access_pointer(init_net.flow_dissector_prog)) {
> > > +               /* Can't override root flow dissector program */
> > > +               return -EPERM;
> > > +       }
> >
> > This is racy, shouldn't this be checked after grabbing a lock below?
> What kind of race do you have in mind?

I was thinking about the case of two competing attaches for root
init_net, but it seems like we will double-check again under lock, so
this is fine as is.

>
> Even if I put this check under the mutex, it's still possible that if
> two cpus concurrently start attaching flow dissector programs (i.e. call
> sys_bpf(BPF_PROG_ATTACH)) at the same time (one to root ns, the other
> to non-root ns), the cpu that is attaching to non-root can grab mutex first,
> pass all the checks and attach the prog (higher frequency, tubo boost, etc).
>
> The mutex is there to protect only against concurrent attaches to the
> _same_ netns. For the sake of simplicity we have a global one instead
> of a mutex per net-ns.
>
> So I'd rather not grab the mutex and keep it simple. Even in there is a
> race, in __skb_flow_dissect we always check init_net first.
>
> > > +
> > >         net = current->nsproxy->net_ns;
> > >         mutex_lock(&flow_dissector_mutex);
> > >         attached = rcu_dereference_protected(net->flow_dissector_prog,
> > > @@ -910,7 +915,11 @@ bool __skb_flow_dissect(const struct net *net,
> > >         WARN_ON_ONCE(!net);
> > >         if (net) {
> > >                 rcu_read_lock();
> > > -               attached = rcu_dereference(net->flow_dissector_prog);
> > > +               attached =
> > > +                       rcu_dereference(init_net.flow_dissector_prog);
> > > +
> > > +               if (!attached)
> > > +                       attached = rcu_dereference(net->flow_dissector_prog);
> > >
> > >                 if (attached) {
> > >                         struct bpf_flow_keys flow_keys;
> > > --
> > > 2.23.0.444.g18eeb5a265-goog
> > >
