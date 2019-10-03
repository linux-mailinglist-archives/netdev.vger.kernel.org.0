Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2FBCA499
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 18:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391048AbfJCQ0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 12:26:16 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46694 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391036AbfJCQ0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 12:26:13 -0400
Received: by mail-qk1-f196.google.com with SMTP id 201so2921020qkd.13;
        Thu, 03 Oct 2019 09:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gWZARSKE9Hs8ejVDU8F9j6kzF6nURfHgt28p7CfZCis=;
        b=gojKMXqQ8H09C/Lm1LD6NxBIiEL2Eku8OwO821U5Q2C5iCi/u9VCW9oC/9UOvL477S
         FLE/pDjx5G7XBkCq0mgjtlw8gdWdBbe36ZAvjcN1E+KYeeNDsVFpOiC3avXyv51i5Wqh
         bB5U/HhvE/KnDjk0nkJNtt+SOgWBsFH3P2tPf5TJaYoDaONIQL+GC5QLbnthRD1uL1Py
         WOJFj71KuW24aDhgIf+PfL6x/PTl5Xi5k+VLmYcx+/Ea1B/ElcMfZ6KkIg9dsP6BY+Ff
         rcHgatkaRY9E525M5LgIdxtxCK8wV5rNlcoO1vWxdUj4JLraKP83p7l9sjmRUx4AnSR2
         ZgkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gWZARSKE9Hs8ejVDU8F9j6kzF6nURfHgt28p7CfZCis=;
        b=jOuHSRyhzFRzEMuhpw/eAojw/gzFgCdKfZYneiFJtU5nRvDWuX5yi7rXU5M4i597r3
         Di/vvQ+gBrX2SXcqNFN4qP/cxhX70Xbf9djepxmY7PeL2KdJtVhdu+78URMFpiTfw2H4
         AJs15gCezxksZWBEvAJWbfn9T9BGpy0F6Ddd31JTxJ7h35T4a8bpgSsZGXUkSS7wKgLm
         kzdlgoA3eokstTn89NsVRkFwMQxi9KQbt/Wv37MUF/VxqFlwm+8G1SYan3Z9Hh5tdRTW
         c95EMXBnZ+64xygpQdWQ8Cra3QZZzjQxdd1I0D5dPRtJHCc1JnzJLEyJhi4ejHDUy03I
         MNfw==
X-Gm-Message-State: APjAAAXAw56jUo7eq00iLm1i36QSEzyHze+ArBAPn0Sg6asOUcvy7Cj1
        1uk8qp9RiB2Qw492F80XZEdxZ0JnQEwZt3sn7S8STS6cjag=
X-Google-Smtp-Source: APXvYqzBTUSSdMQrWweIM+YBFr2x7j0L5LSu3Pl8hJccyySIXLOzU2ak7lrRNAqY+vMiuN0CO/lmmAEO5yyrME1KgUI=
X-Received: by 2002:ae9:eb93:: with SMTP id b141mr5359628qkg.36.1570119972286;
 Thu, 03 Oct 2019 09:26:12 -0700 (PDT)
MIME-Version: 1.0
References: <20191002173357.253643-1-sdf@google.com> <20191002173357.253643-2-sdf@google.com>
 <CAEf4BzZuEChOL828F91wLxUr3h2yfAkZvhsyoSx18uSFSxOtqw@mail.gmail.com>
 <20191003014356.GC3223377@mini-arch> <CAEf4BzZnWkdFpSUsSBenDDfrvgjGvBxUnJmQRwb7xjNQBaKXdQ@mail.gmail.com>
 <20191003160137.GD3223377@mini-arch>
In-Reply-To: <20191003160137.GD3223377@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Oct 2019 09:26:01 -0700
Message-ID: <CAEf4BzYbJZz7AwW_N=Q2b-V8ZQCJVTHeUaGo6Ji848aB_z8nXA@mail.gmail.com>
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

On Thu, Oct 3, 2019 at 9:01 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 10/02, Andrii Nakryiko wrote:
> > On Wed, Oct 2, 2019 at 6:43 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 10/02, Andrii Nakryiko wrote:
> > > > On Wed, Oct 2, 2019 at 10:35 AM Stanislav Fomichev <sdf@google.com> wrote:
> > > > >
> > > > > Always use init_net flow dissector BPF program if it's attached and fall
> > > > > back to the per-net namespace one. Also, deny installing new programs if
> > > > > there is already one attached to the root namespace.
> > > > > Users can still detach their BPF programs, but can't attach any
> > > > > new ones (-EPERM).
> >
> > I find this quite confusing for users, honestly. If there is no root
> > namespace dissector we'll successfully attach per-net ones and they
> > will be working fine. That some process will attach root one and all
> > the previously successfully working ones will suddenly "break" without
> > users potentially not realizing why. I bet this will be hair-pulling
> > investigation for someone. Furthermore, if root net dissector is
> > already attached, all subsequent attachment will now start failing.
> The idea is that if sysadmin decides to use system-wide dissector it would
> be attached from the init scripts/systemd early in the boot process.
> So the users in your example would always get EPERM/EBUSY/EXIST.
> I don't really see a realistic use-case where root and non-root
> namespaces attach/detach flow dissector programs at non-boot
> time (or why non-root containers could have BPF dissector and root
> could have C dissector; multi-nic machine?).
>
> But I totally see your point about confusion. See below.
>
> > I'm not sure what's the better behavior here is, but maybe at least
> > forcibly detach already attached ones, so when someone goes and tries
> > to investigate, they will see that their BPF program is not attached
> > anymore. Printing dmesg warning would be hugely useful here as well.
> We can do for_each_net and detach non-root ones; that sounds
> feasible and may avoid the confusion (at least when you query
> non-root ns to see if the prog is still there, you get a valid
> indication that it's not).
>
> > Alternatively, if there is any per-net dissector attached, we might
> > disallow root net dissector to be installed. Sort of "too late to the
> > party" way, but at least not surprising to successfully installed
> > dissectors.
> We can do this as well.
>
> > Thoughts?
> Let me try to implement both of your suggestions and see which one makes
> more sense. I'm leaning towards the later (simple check to see if
> any non-root ns has the prog attached).
>
> I'll follow up with a v2 if all goes well.

Thanks! I don't have strong opinion on either, see what makes most
sense from an actual user perspective.

>
> > > > > Cc: Petar Penkov <ppenkov@google.com>
> > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > ---
> > > > >  Documentation/bpf/prog_flow_dissector.rst |  3 +++
> > > > >  net/core/flow_dissector.c                 | 11 ++++++++++-
> > > > >  2 files changed, 13 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/Documentation/bpf/prog_flow_dissector.rst b/Documentation/bpf/prog_flow_dissector.rst
> > > > > index a78bf036cadd..4d86780ab0f1 100644
> > > > > --- a/Documentation/bpf/prog_flow_dissector.rst
> > > > > +++ b/Documentation/bpf/prog_flow_dissector.rst
> > > > > @@ -142,3 +142,6 @@ BPF flow dissector doesn't support exporting all the metadata that in-kernel
> > > > >  C-based implementation can export. Notable example is single VLAN (802.1Q)
> > > > >  and double VLAN (802.1AD) tags. Please refer to the ``struct bpf_flow_keys``
> > > > >  for a set of information that's currently can be exported from the BPF context.
> > > > > +
> > > > > +When BPF flow dissector is attached to the root network namespace (machine-wide
> > > > > +policy), users can't override it in their child network namespaces.
> > > > > diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> > > > > index 7c09d87d3269..494e2016fe84 100644
> > > > > --- a/net/core/flow_dissector.c
> > > > > +++ b/net/core/flow_dissector.c
> > > > > @@ -115,6 +115,11 @@ int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
> > > > >         struct bpf_prog *attached;
> > > > >         struct net *net;
> > > > >
> > > > > +       if (rcu_access_pointer(init_net.flow_dissector_prog)) {
> > > > > +               /* Can't override root flow dissector program */
> > > > > +               return -EPERM;
> > > > > +       }
> > > >
> > > > This is racy, shouldn't this be checked after grabbing a lock below?
> > > What kind of race do you have in mind?
> >
> > I was thinking about the case of two competing attaches for root
> > init_net, but it seems like we will double-check again under lock, so
> > this is fine as is.
> >
> > >
> > > Even if I put this check under the mutex, it's still possible that if
> > > two cpus concurrently start attaching flow dissector programs (i.e. call
> > > sys_bpf(BPF_PROG_ATTACH)) at the same time (one to root ns, the other
> > > to non-root ns), the cpu that is attaching to non-root can grab mutex first,
> > > pass all the checks and attach the prog (higher frequency, tubo boost, etc).
> > >
> > > The mutex is there to protect only against concurrent attaches to the
> > > _same_ netns. For the sake of simplicity we have a global one instead
> > > of a mutex per net-ns.
> > >
> > > So I'd rather not grab the mutex and keep it simple. Even in there is a
> > > race, in __skb_flow_dissect we always check init_net first.
> > >
> > > > > +
> > > > >         net = current->nsproxy->net_ns;
> > > > >         mutex_lock(&flow_dissector_mutex);
> > > > >         attached = rcu_dereference_protected(net->flow_dissector_prog,
> > > > > @@ -910,7 +915,11 @@ bool __skb_flow_dissect(const struct net *net,
> > > > >         WARN_ON_ONCE(!net);
> > > > >         if (net) {
> > > > >                 rcu_read_lock();
> > > > > -               attached = rcu_dereference(net->flow_dissector_prog);
> > > > > +               attached =
> > > > > +                       rcu_dereference(init_net.flow_dissector_prog);
> > > > > +
> > > > > +               if (!attached)
> > > > > +                       attached = rcu_dereference(net->flow_dissector_prog);
> > > > >
> > > > >                 if (attached) {
> > > > >                         struct bpf_flow_keys flow_keys;
> > > > > --
> > > > > 2.23.0.444.g18eeb5a265-goog
> > > > >
