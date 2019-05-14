Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 574291CDFD
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 19:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfENRaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 13:30:05 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40185 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfENRaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 13:30:04 -0400
Received: by mail-pg1-f193.google.com with SMTP id d31so8961867pgl.7
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 10:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KtqzIcfvyjWfCppcmwgXKJrfBqEm0TfW3CNu9uOKaGo=;
        b=lJDQc3gp0wheeLyWKlN+gq1oLh2K/CjohmsgdhHgGWsRbDnGOe4/OptMAaBX77RQls
         M8zlnFz9vv3fdx4NzybAU8WsGBddg8so4E1+oMWi9L1oIK/ugv+ESZ71XGIFdUN1JEcu
         O2P2ga6riZVmVf9Au5cSwdgHchao3OuYq+Yoq2dpjILmFPoQ2khW7hk0hNnamOMhPhz3
         c2EkoEDB2r6XFNsDZf2i5+fYxc13oHHpHC++XUdpZ6lxpl0kebkVMixvK7gb9GkHOcW3
         tycuIm0viyO+tlDN03xPnc+CnASO8Oi+kc9/n5mQ4wNduNLrSJAOScmDqsX/nt1JiIJQ
         u3RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KtqzIcfvyjWfCppcmwgXKJrfBqEm0TfW3CNu9uOKaGo=;
        b=J37gh5MrIYNMnZ5fbSfFDdBwbOl5DcoFPFFsMaQHGdwPNHxCJz7JSt4IHzqvz4Wehk
         qAEDB/TU+1vzogcGFVC0BWsMwth+Gmp849K4OpX7UTfAQv6mgQdBSxSxBYnr+6zDBn2f
         qPKS3Yh6wUAoZn8qZTKPq4Rj26GHx1XFAJX3UlLcPKQWnyPlhGuOzD1RO4SgS94xmeC6
         dqMe+aSjN+uSHUrUSqBl296mRzBkUHdDcvGGn5Appwcy27IkzqJPNOXcONdI/AB9H1Vm
         gt/CM5BBEem8JnOybTglB+hjBW4CL4WzgPEG1taRJRUPaMZnbjSm6R/0pPY8ZXHBiCwN
         rMCA==
X-Gm-Message-State: APjAAAV76VxukHsYilJPr3ak+sRA1KhYV9mGl7WKMC4uR4apiglM50Wu
        CI6bwP/3tYlOXA2xR91XFjgqAg==
X-Google-Smtp-Source: APXvYqzrkE3oHPekEFXbvKa+hG7Kj9SLxzKXWGb2ShUyiiVwn9f0gKnw56HTj6sVRKOYvUzeQhNG4w==
X-Received: by 2002:a62:3381:: with SMTP id z123mr43451690pfz.42.1557855003726;
        Tue, 14 May 2019 10:30:03 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id s134sm29297456pfc.110.2019.05.14.10.30.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 10:30:03 -0700 (PDT)
Date:   Tue, 14 May 2019 10:30:02 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf 0/4] bpf: remove __rcu annotations from bpf_prog_array
Message-ID: <20190514173002.GB10244@mini-arch>
References: <20190508171845.201303-1-sdf@google.com>
 <20190508175644.e4k5o6o3cgn6k5lx@ast-mbp>
 <20190508181223.GH1247@mini-arch>
 <20190513185724.GB24057@mini-arch>
 <CAADnVQLX3EcbW=iVxjsjO38M3Lqw5TfCcZtmbnt1DJwDvp64dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLX3EcbW=iVxjsjO38M3Lqw5TfCcZtmbnt1DJwDvp64dA@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/14, Alexei Starovoitov wrote:
> On Mon, May 13, 2019 at 11:57 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 05/08, Stanislav Fomichev wrote:
> > > On 05/08, Alexei Starovoitov wrote:
> > > > On Wed, May 08, 2019 at 10:18:41AM -0700, Stanislav Fomichev wrote:
> > > > > Right now we are not using rcu api correctly: we pass __rcu pointers
> > > > > to bpf_prog_array_xyz routines but don't use rcu_dereference on them
> > > > > (see bpf_prog_array_delete_safe and bpf_prog_array_copy in particular).
> > > > > Instead of sprinkling rcu_dereferences, let's just get rid of those
> > > > > __rcu annotations and move rcu handling to a higher level.
> > > > >
> > > > > It looks like all those routines are called from the rcu update
> > > > > side and we can use simple rcu_dereference_protected to get a
> > > > > reference that is valid as long as we hold a mutex (i.e. no other
> > > > > updater can change the pointer, no need for rcu read section and
> > > > > there should not be a use-after-free problem).
> > > > >
> > > > > To be fair, there is currently no issue with the existing approach
> > > > > since the calls are mutex-protected, pointer values don't change,
> > > > > __rcu annotations are ignored. But it's still nice to use proper api.
> > > > >
> > > > > The series fixes the following sparse warnings:
> > > >
> > > > Absolutely not.
> > > > please fix it properly.
> > > > Removing annotations is not a fix.
> > > I'm fixing it properly by removing the annotations and moving lifetime
> > > management to the upper layer. See commits 2-4 where I fix the users, the
> > > first patch is just the "preparation".
> > >
> > > The users are supposed to do:
> > >
> > > mutex_lock(&x);
> > > p = rcu_dereference_protected(prog_array, lockdep_is_held(&x))
> > > // ...
> > > // call bpf_prog_array helpers while mutex guarantees that
> > > // the object referenced by p is valid (i.e. no need for bpf_prog_array
> > > // helpers to care about rcu lifetime)
> > > // ...
> > > mutex_unlock(&x);
> > >
> > > What am I missing here?
> >
> > Just to give you my perspective on why current api with __rcu annotations
> > is working, but not optimal (even if used from the rcu read section).
> >
> > Sample code:
> >
> >         struct bpf_prog_array __rcu *progs = <comes from somewhere>;
> >         int n;
> >
> >         rcu_read_lock();
> >         n = bpf_prog_array_length(progs);
> >         if (n > 0) {
> >           // do something with __rcu progs
> >           do_something(progs);
> >         }
> >         rcu_read_unlock();
> >
> > Since progs is __rcu annotated, do_something() would need to do
> > rcu_dereference again and it might get a different value compared to
> > whatever bpf_prog_array_free got while doing its dereference.
> 
> correct and I believe the code deals with it fine.
> cnt could be different between two calls.
Yes, currently there is no problem, all users of these apis
are fine because they are holding a mutex (and are hence in the rcu update
path, i.e. the pointer can't change and they have a consistent view
between the calls).

For example, we currently have:

	int n1, n2;
	mutex_lock(&x);
	n1 = bpf_prog_array_length(progs);
	n2 = bpf_prog_array_length(progs);
	// n1 is guaranteed to be the same as n2 as long as we
	// hold a mutex; single updater only
	...
	mutex_unlock(&x);

Versus:

	rcu_read_lock();
	n1 = bpf_prog_array_length(progs);
	n2 = bpf_prog_array_length(progs);
	// n1 and n2 can be different; rcu_read_lock is all about
	// lifetime
	...
	rcu_read_unlock();

But, as I said, we don't use those __rcu annotated bpf_prog_array
routines in the rcu read section, so we are fine.

(I'm just showing that potentially there might be a problem if we don't move
rcu management away from bpf_prog_array routines and if someone
decides to call them under rcu_read_lock).

> > A better way is not to deal with rcu inside those helpers and let
> > higher layers do that:
> >
> >         struct bpf_prog_array __rcu *progs = <comes from somewhere>;
> >         struct bpf_prog_array *p;
> >         int n;
> >
> >         rcu_read_lock();
> >         p = rcu_dereference(p);
> >         n = bpf_prog_array_length(p);
> >         if (n > 0) {
> >           do_something(p); // do_something sees the same p as bpf_prog_array_length
> >         }
> >         rcu_read_unlock();
> >
> > What do you think?
> 
> I'm not sure that generically applicable.
> Which piece of code do you have in mind for such refactoring?
All existing callers of (take a look at patches 2-4):

* bpf_prog_array_free
* bpf_prog_array_length
* bpf_prog_array_copy_to_user
* bpf_prog_array_delete_safe
* bpf_prog_array_copy_info
* bpf_prog_array_copy

They are:

* perf event bpf attach/detach/query (under bpf_event_mutex)
* cgroup attach/detach/query (management of cgroup_bpf->effective, under
  cgroup_mutex)
* lirc bpf attach/detach/query (under ir_raw_handler_lock)

Nobody uses these apis in the rcu read section, so we can remove the
annotations and use rcu_dereference_protected on the higher layer.

Side bonus is that we can also remove __rcu from cgroup_bpf.inactive
(which is just a temp storage and not updated in the rcu fashion) and
from old_array in activate_effective_progs (which is an on-stack
array and, I guess, only has __rcu annotation to satisfy sparse).

So nothing is changing functionality-wise, but it becomes a bit easier
to reason about by being more explicit with rcu api.
