Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF6EECAD5D
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389724AbfJCRjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:39:14 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46422 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731878AbfJCQBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 12:01:41 -0400
Received: by mail-pg1-f194.google.com with SMTP id a3so2008982pgm.13
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 09:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0y95u07iur6UmavagV9rFmpo+CBc/4QJ5Hj3jr+TpaQ=;
        b=s1xvJejmY+mvKv3vUZxfK4BegMDKrxzh6o96zYo+TFJPWyhqh/Ot6wxgYculZVmYQT
         xJIc8GTHYOmPAZz0mFN+Kz5+Ap0WTrhj/Bnt0xNFe239Ev+qEfQbSW7uxPBG6Nkn8PZb
         bkfuq9fOH7ixdqyGURPW1H1Ts7PAgUvSpdwbhtxvAh5ba2jcAu5jYyZWu/nD9O3o/S2N
         8laQy8QkiETnldqJXYLFDrjq3N5nBa1l9C6cTq0V7ppW2ZJRCTJXnzc9gaxS9ItHN57o
         bSfNNweK596ZCfyQQE9WJnRdCVDwSlcMF79wPJ5HX3BMgCsAfYYyb4DL4EKklm7pKfHg
         RTOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0y95u07iur6UmavagV9rFmpo+CBc/4QJ5Hj3jr+TpaQ=;
        b=iKgSCLinD2uDoGxkd67Y4IYVGjj8Zy5KkUXcSglKQMN++FIlg4NsB4fNJjbcfifgRQ
         hTmphGcX3EbZK2XbntN38zPC/6lpQ17rvJkaO0RaIx18S8etmr+YDqszmHCu1YQDkmxo
         i733k5T7FUaZioDEhQhR4vLkxu1OqUIPshecdVH6yv2asSpMOB0MdqZqinrhpZkzyKPC
         SItJnpDl+gufE0mI90t/FukAbD4qBe3mLlhmkaqB+wGVkkdGL5uimVkDCO59KsyDfwWh
         AHbvJ0LK9qIWK1ZbF5UUIrjc4jgiaAxLbv4pjH6nSQFZGRWOo5XqMLwlxAQPS1gQUz8X
         nYLg==
X-Gm-Message-State: APjAAAUblA6t3OvCH7aK4IcAiJp7qUmW89BbPr3u9oYnGWJ0EclOCPdA
        1JM2ZNeHq4XYD87idCsFN7/hFg==
X-Google-Smtp-Source: APXvYqxw0Oe/KdrL+HBsrGCOAS014MtZt1fEkQBrJMSaimgtYcKAXcMo/8Zx2vDtzP3yG1z1xuIxcg==
X-Received: by 2002:a17:90a:2284:: with SMTP id s4mr11019605pjc.3.1570118500057;
        Thu, 03 Oct 2019 09:01:40 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id 190sm3182704pgi.59.2019.10.03.09.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 09:01:39 -0700 (PDT)
Date:   Thu, 3 Oct 2019 09:01:37 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Petar Penkov <ppenkov@google.com>
Subject: Re: [PATCH bpf-next 1/2] bpf/flow_dissector: add mode to enforce
 global BPF flow dissector
Message-ID: <20191003160137.GD3223377@mini-arch>
References: <20191002173357.253643-1-sdf@google.com>
 <20191002173357.253643-2-sdf@google.com>
 <CAEf4BzZuEChOL828F91wLxUr3h2yfAkZvhsyoSx18uSFSxOtqw@mail.gmail.com>
 <20191003014356.GC3223377@mini-arch>
 <CAEf4BzZnWkdFpSUsSBenDDfrvgjGvBxUnJmQRwb7xjNQBaKXdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZnWkdFpSUsSBenDDfrvgjGvBxUnJmQRwb7xjNQBaKXdQ@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/02, Andrii Nakryiko wrote:
> On Wed, Oct 2, 2019 at 6:43 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 10/02, Andrii Nakryiko wrote:
> > > On Wed, Oct 2, 2019 at 10:35 AM Stanislav Fomichev <sdf@google.com> wrote:
> > > >
> > > > Always use init_net flow dissector BPF program if it's attached and fall
> > > > back to the per-net namespace one. Also, deny installing new programs if
> > > > there is already one attached to the root namespace.
> > > > Users can still detach their BPF programs, but can't attach any
> > > > new ones (-EPERM).
> 
> I find this quite confusing for users, honestly. If there is no root
> namespace dissector we'll successfully attach per-net ones and they
> will be working fine. That some process will attach root one and all
> the previously successfully working ones will suddenly "break" without
> users potentially not realizing why. I bet this will be hair-pulling
> investigation for someone. Furthermore, if root net dissector is
> already attached, all subsequent attachment will now start failing.
The idea is that if sysadmin decides to use system-wide dissector it would
be attached from the init scripts/systemd early in the boot process.
So the users in your example would always get EPERM/EBUSY/EXIST.
I don't really see a realistic use-case where root and non-root
namespaces attach/detach flow dissector programs at non-boot
time (or why non-root containers could have BPF dissector and root
could have C dissector; multi-nic machine?).

But I totally see your point about confusion. See below.

> I'm not sure what's the better behavior here is, but maybe at least
> forcibly detach already attached ones, so when someone goes and tries
> to investigate, they will see that their BPF program is not attached
> anymore. Printing dmesg warning would be hugely useful here as well.
We can do for_each_net and detach non-root ones; that sounds
feasible and may avoid the confusion (at least when you query
non-root ns to see if the prog is still there, you get a valid
indication that it's not).

> Alternatively, if there is any per-net dissector attached, we might
> disallow root net dissector to be installed. Sort of "too late to the
> party" way, but at least not surprising to successfully installed
> dissectors.
We can do this as well.

> Thoughts?
Let me try to implement both of your suggestions and see which one makes
more sense. I'm leaning towards the later (simple check to see if
any non-root ns has the prog attached).

I'll follow up with a v2 if all goes well.

> > > > Cc: Petar Penkov <ppenkov@google.com>
> > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > ---
> > > >  Documentation/bpf/prog_flow_dissector.rst |  3 +++
> > > >  net/core/flow_dissector.c                 | 11 ++++++++++-
> > > >  2 files changed, 13 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/Documentation/bpf/prog_flow_dissector.rst b/Documentation/bpf/prog_flow_dissector.rst
> > > > index a78bf036cadd..4d86780ab0f1 100644
> > > > --- a/Documentation/bpf/prog_flow_dissector.rst
> > > > +++ b/Documentation/bpf/prog_flow_dissector.rst
> > > > @@ -142,3 +142,6 @@ BPF flow dissector doesn't support exporting all the metadata that in-kernel
> > > >  C-based implementation can export. Notable example is single VLAN (802.1Q)
> > > >  and double VLAN (802.1AD) tags. Please refer to the ``struct bpf_flow_keys``
> > > >  for a set of information that's currently can be exported from the BPF context.
> > > > +
> > > > +When BPF flow dissector is attached to the root network namespace (machine-wide
> > > > +policy), users can't override it in their child network namespaces.
> > > > diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> > > > index 7c09d87d3269..494e2016fe84 100644
> > > > --- a/net/core/flow_dissector.c
> > > > +++ b/net/core/flow_dissector.c
> > > > @@ -115,6 +115,11 @@ int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
> > > >         struct bpf_prog *attached;
> > > >         struct net *net;
> > > >
> > > > +       if (rcu_access_pointer(init_net.flow_dissector_prog)) {
> > > > +               /* Can't override root flow dissector program */
> > > > +               return -EPERM;
> > > > +       }
> > >
> > > This is racy, shouldn't this be checked after grabbing a lock below?
> > What kind of race do you have in mind?
> 
> I was thinking about the case of two competing attaches for root
> init_net, but it seems like we will double-check again under lock, so
> this is fine as is.
> 
> >
> > Even if I put this check under the mutex, it's still possible that if
> > two cpus concurrently start attaching flow dissector programs (i.e. call
> > sys_bpf(BPF_PROG_ATTACH)) at the same time (one to root ns, the other
> > to non-root ns), the cpu that is attaching to non-root can grab mutex first,
> > pass all the checks and attach the prog (higher frequency, tubo boost, etc).
> >
> > The mutex is there to protect only against concurrent attaches to the
> > _same_ netns. For the sake of simplicity we have a global one instead
> > of a mutex per net-ns.
> >
> > So I'd rather not grab the mutex and keep it simple. Even in there is a
> > race, in __skb_flow_dissect we always check init_net first.
> >
> > > > +
> > > >         net = current->nsproxy->net_ns;
> > > >         mutex_lock(&flow_dissector_mutex);
> > > >         attached = rcu_dereference_protected(net->flow_dissector_prog,
> > > > @@ -910,7 +915,11 @@ bool __skb_flow_dissect(const struct net *net,
> > > >         WARN_ON_ONCE(!net);
> > > >         if (net) {
> > > >                 rcu_read_lock();
> > > > -               attached = rcu_dereference(net->flow_dissector_prog);
> > > > +               attached =
> > > > +                       rcu_dereference(init_net.flow_dissector_prog);
> > > > +
> > > > +               if (!attached)
> > > > +                       attached = rcu_dereference(net->flow_dissector_prog);
> > > >
> > > >                 if (attached) {
> > > >                         struct bpf_flow_keys flow_keys;
> > > > --
> > > > 2.23.0.444.g18eeb5a265-goog
> > > >
