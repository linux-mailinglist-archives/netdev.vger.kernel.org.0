Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A3C1CE57
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 19:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfENRxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 13:53:34 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36258 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfENRxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 13:53:34 -0400
Received: by mail-pf1-f196.google.com with SMTP id v80so9529828pfa.3
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 10:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uqj8d9gKpKuk8wcu5BIeKVzbVRkXRmFu+xHwf/KpPew=;
        b=vEWbVQLGRAz/BwefRwwApoHP1dBqgMM9U8rsblKg0GlYZvOm/GDy4W5H0O90den8Bw
         GoPFywba56fKlaTd8EsjAsIZ+Hw0MeMA2AahSQi+jfHg+VXEQAdtk7BDvnjlQ+Ywq0Po
         BL8/MQPuDtsU0X/ZRVqjj7l610/5AzWe7Dy/dICbJh08qMv6gteDpHpks7g9JPepXgGW
         RDYqrrQ3lS11lkAcKP0uzJbuHPGLuKqA088OwLV0lu3efnZ86pWgj2wOZQzsFDbeDHlD
         K6T0vN6RoJBX1TFxbUAhPfo1qOfSfSp2nHaISfdP3vTZa81ZdEehQjUgiVS+YSaYey2u
         vmJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uqj8d9gKpKuk8wcu5BIeKVzbVRkXRmFu+xHwf/KpPew=;
        b=n/ApyJrsGf8LqvLCki/vHbIkxwi2R9YV8JVwbonfNUd+muJHsyTUGwdfvlWW4w5NUA
         eFroGofBIBVCIQPXG5uKz3rQe56d/b5A80Ju+a5VJlwdPa4jaE1BZxQBtVHLGb3kFiu6
         UsxhqlOrFYfQdlvovLFlJfHwOpHX8b4OKHo1RtXhcrULQsoNP+HXlFZWGWeZ7H2o21vY
         Ok8FMqVUtubFbt2IkyfeB3CbNp4A+WU+xqiE9hNkoz9oKCK56bDy+zyOYvFQ37ZdZJzF
         kuJQejjKSYPhY416Cjepr9FW1OTSkLZaYrbZ4cFxCpOf/AG7NNhJv/XkV101U0Iy2YDa
         KY8g==
X-Gm-Message-State: APjAAAVQKYsycmWvu2YHFdeLORjBRLvBtOU+Z3DEuwWNtgawJmerUUGL
        mTBEfvSSxawyiEaBvIrwSANZKg==
X-Google-Smtp-Source: APXvYqw/M5ZhUkJ9WzUho1+RlmZXayp9VzlZ3+P3GyE7VSvD0uX+r1QG8l3dElouF6rKa31ayDLOBg==
X-Received: by 2002:a63:3c14:: with SMTP id j20mr39597681pga.410.1557856413611;
        Tue, 14 May 2019 10:53:33 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id o2sm36398470pgq.1.2019.05.14.10.53.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 10:53:33 -0700 (PDT)
Date:   Tue, 14 May 2019 10:53:32 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf 0/4] bpf: remove __rcu annotations from bpf_prog_array
Message-ID: <20190514175332.GC10244@mini-arch>
References: <20190508171845.201303-1-sdf@google.com>
 <20190508175644.e4k5o6o3cgn6k5lx@ast-mbp>
 <20190508181223.GH1247@mini-arch>
 <20190513185724.GB24057@mini-arch>
 <CAADnVQLX3EcbW=iVxjsjO38M3Lqw5TfCcZtmbnt1DJwDvp64dA@mail.gmail.com>
 <20190514173002.GB10244@mini-arch>
 <20190514174523.myybhjzfhmxdycgf@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514174523.myybhjzfhmxdycgf@ast-mbp>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/14, Alexei Starovoitov wrote:
> On Tue, May 14, 2019 at 10:30:02AM -0700, Stanislav Fomichev wrote:
> > On 05/14, Alexei Starovoitov wrote:
> > > On Mon, May 13, 2019 at 11:57 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > > >
> > > > On 05/08, Stanislav Fomichev wrote:
> > > > > On 05/08, Alexei Starovoitov wrote:
> > > > > > On Wed, May 08, 2019 at 10:18:41AM -0700, Stanislav Fomichev wrote:
> > > > > > > Right now we are not using rcu api correctly: we pass __rcu pointers
> > > > > > > to bpf_prog_array_xyz routines but don't use rcu_dereference on them
> > > > > > > (see bpf_prog_array_delete_safe and bpf_prog_array_copy in particular).
> > > > > > > Instead of sprinkling rcu_dereferences, let's just get rid of those
> > > > > > > __rcu annotations and move rcu handling to a higher level.
> > > > > > >
> > > > > > > It looks like all those routines are called from the rcu update
> > > > > > > side and we can use simple rcu_dereference_protected to get a
> > > > > > > reference that is valid as long as we hold a mutex (i.e. no other
> > > > > > > updater can change the pointer, no need for rcu read section and
> > > > > > > there should not be a use-after-free problem).
> > > > > > >
> > > > > > > To be fair, there is currently no issue with the existing approach
> > > > > > > since the calls are mutex-protected, pointer values don't change,
> > > > > > > __rcu annotations are ignored. But it's still nice to use proper api.
> > > > > > >
> > > > > > > The series fixes the following sparse warnings:
> > > > > >
> > > > > > Absolutely not.
> > > > > > please fix it properly.
> > > > > > Removing annotations is not a fix.
> > > > > I'm fixing it properly by removing the annotations and moving lifetime
> > > > > management to the upper layer. See commits 2-4 where I fix the users, the
> > > > > first patch is just the "preparation".
> > > > >
> > > > > The users are supposed to do:
> > > > >
> > > > > mutex_lock(&x);
> > > > > p = rcu_dereference_protected(prog_array, lockdep_is_held(&x))
> > > > > // ...
> > > > > // call bpf_prog_array helpers while mutex guarantees that
> > > > > // the object referenced by p is valid (i.e. no need for bpf_prog_array
> > > > > // helpers to care about rcu lifetime)
> > > > > // ...
> > > > > mutex_unlock(&x);
> > > > >
> > > > > What am I missing here?
> > > >
> > > > Just to give you my perspective on why current api with __rcu annotations
> > > > is working, but not optimal (even if used from the rcu read section).
> > > >
> > > > Sample code:
> > > >
> > > >         struct bpf_prog_array __rcu *progs = <comes from somewhere>;
> > > >         int n;
> > > >
> > > >         rcu_read_lock();
> > > >         n = bpf_prog_array_length(progs);
> > > >         if (n > 0) {
> > > >           // do something with __rcu progs
> > > >           do_something(progs);
> > > >         }
> > > >         rcu_read_unlock();
> > > >
> > > > Since progs is __rcu annotated, do_something() would need to do
> > > > rcu_dereference again and it might get a different value compared to
> > > > whatever bpf_prog_array_free got while doing its dereference.
> > > 
> > > correct and I believe the code deals with it fine.
> > > cnt could be different between two calls.
> > Yes, currently there is no problem, all users of these apis
> > are fine because they are holding a mutex (and are hence in the rcu update
> > path, i.e. the pointer can't change and they have a consistent view
> > between the calls).
> > 
> > For example, we currently have:
> > 
> > 	int n1, n2;
> > 	mutex_lock(&x);
> > 	n1 = bpf_prog_array_length(progs);
> > 	n2 = bpf_prog_array_length(progs);
> > 	// n1 is guaranteed to be the same as n2 as long as we
> > 	// hold a mutex; single updater only
> > 	...
> > 	mutex_unlock(&x);
> > 
> > Versus:
> > 
> > 	rcu_read_lock();
> > 	n1 = bpf_prog_array_length(progs);
> > 	n2 = bpf_prog_array_length(progs);
> > 	// n1 and n2 can be different; rcu_read_lock is all about
> > 	// lifetime
> > 	...
> > 	rcu_read_unlock();
> > 
> > But, as I said, we don't use those __rcu annotated bpf_prog_array
> > routines in the rcu read section, so we are fine.
> > 
> > (I'm just showing that potentially there might be a problem if we don't move
> > rcu management away from bpf_prog_array routines and if someone
> > decides to call them under rcu_read_lock).
> > 
> > > > A better way is not to deal with rcu inside those helpers and let
> > > > higher layers do that:
> > > >
> > > >         struct bpf_prog_array __rcu *progs = <comes from somewhere>;
> > > >         struct bpf_prog_array *p;
> > > >         int n;
> > > >
> > > >         rcu_read_lock();
> > > >         p = rcu_dereference(p);
> > > >         n = bpf_prog_array_length(p);
> > > >         if (n > 0) {
> > > >           do_something(p); // do_something sees the same p as bpf_prog_array_length
> > > >         }
> > > >         rcu_read_unlock();
> > > >
> > > > What do you think?
> > > 
> > > I'm not sure that generically applicable.
> > > Which piece of code do you have in mind for such refactoring?
> > All existing callers of (take a look at patches 2-4):
> > 
> > * bpf_prog_array_free
> > * bpf_prog_array_length
> > * bpf_prog_array_copy_to_user
> > * bpf_prog_array_delete_safe
> > * bpf_prog_array_copy_info
> > * bpf_prog_array_copy
> > 
> > They are:
> > 
> > * perf event bpf attach/detach/query (under bpf_event_mutex)
> > * cgroup attach/detach/query (management of cgroup_bpf->effective, under
> >   cgroup_mutex)
> > * lirc bpf attach/detach/query (under ir_raw_handler_lock)
> > 
> > Nobody uses these apis in the rcu read section, so we can remove the
> > annotations and use rcu_dereference_protected on the higher layer.
> > 
> > Side bonus is that we can also remove __rcu from cgroup_bpf.inactive
> > (which is just a temp storage and not updated in the rcu fashion) and
> > from old_array in activate_effective_progs (which is an on-stack
> > array and, I guess, only has __rcu annotation to satisfy sparse).
> > 
> > So nothing is changing functionality-wise, but it becomes a bit easier
> > to reason about by being more explicit with rcu api.
> 
> disagree. mutex is necesary.
Oh, for sure, mutex is necessary, I'm not taking away the mutex.

All I'm doing is I'm asking the users of those apis to be more
explicit by using rcu_dereference_protected(progs, lockdep_is_held(mtx)),
which can be read as "I know I'm holding a mutex and I'm in rcu
update section, progs pointer is not going to change. So as long
as I'm holding a mutex, I can call bpf_prog_array helpers and
get consistent result between the calls".

Existing __rcu annotations don't add anything to the safety.
See, for example, bpf_prog_array_copy_to_user and bpf_prog_array_length
which currently do rcu_read_lock/rcu_read_unlock inside. If we expect
the callers to hold a mutex, why do we start rcu-read section inside
and rcu-update section?
