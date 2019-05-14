Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4121CE36
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 19:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfENRpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 13:45:34 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44814 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbfENRpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 13:45:34 -0400
Received: by mail-pl1-f194.google.com with SMTP id c5so893168pll.11;
        Tue, 14 May 2019 10:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3HsJI0ZE4YfxIjsYyVLJhaJR0Av19vcbf9yroRq+2Zc=;
        b=LInkkhF85aMGVkWiK6rx6cWHzVq9f7MDAuEm5CR1+9yKNafQd+9WCrP3RO70HwC5j4
         c2a7Gt7oKm1fHJ8M+7dFXSNOUG3iFQiBdpCdCdt7irmO+i6xjvcrB5e8U101DleB6exl
         XgGD3xiux/DeVl8kdf8gSZs0QDaVZl9RsPprka58UpOKJMdXCKbMsRqFzPI5UDsHx0wn
         GS+bhIOhTHb6nynU/AkNoe4RSZ6pfgo9bCZh/tfUTlahXDr76X7wIgYdfazfUbQSirAh
         IEXEetG/IBiisJd4ziWadsstqeGNJig8oQpmsEBVP5kDYGgPq5V500ICwAs5P5BLzZVq
         lbdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3HsJI0ZE4YfxIjsYyVLJhaJR0Av19vcbf9yroRq+2Zc=;
        b=rDzLEKnOrYGldbT7uZH08unTySP7UCHaJx1y9+J2EVioS0YsMmQmkt7N5wHBNkkVSq
         kP+hPiLxQp48HbJNYZILVRexwnkrDteK8trnuELyDiqN1OK+khHMX+REoP/6WJ/RhUrD
         wrBS8Hg+yxd0yHAOHrvmo5VjgMQc9oyrLnAZNc7u87lo/E9fc2JZL8j0OW+qBY1251f7
         MMu3tbaA6X+EIAEkkzTM5jS1Stfe9W66Wd4IxmWRDZcXWdPdHARDwMvTJhHfSlkxxv/Q
         INEf6OtYL20e9Inw5uZH7Squq1cItSvzpzRgEzPjPK6wXiJIy/wSQbRAChpoj9KHkFbg
         91hA==
X-Gm-Message-State: APjAAAWCwwfhchSPjLrgwY7AhS6Iqw0/Zg4V2GSqXyF7ADZmmeBCHW5h
        mSKbnYTgSqAflWgJIbxF52U=
X-Google-Smtp-Source: APXvYqyKnoEdzw5wv4494xuMWRASGuWpp1BeNarDLZaYOXGnCO68olvryhuyPyUaQmkRSFF8taXbgQ==
X-Received: by 2002:a17:902:9a4a:: with SMTP id x10mr38507588plv.113.1557855932607;
        Tue, 14 May 2019 10:45:32 -0700 (PDT)
Received: from ast-mbp ([199.201.64.131])
        by smtp.gmail.com with ESMTPSA id c5sm19665677pgh.86.2019.05.14.10.45.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 10:45:31 -0700 (PDT)
Date:   Tue, 14 May 2019 10:45:25 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf 0/4] bpf: remove __rcu annotations from bpf_prog_array
Message-ID: <20190514174523.myybhjzfhmxdycgf@ast-mbp>
References: <20190508171845.201303-1-sdf@google.com>
 <20190508175644.e4k5o6o3cgn6k5lx@ast-mbp>
 <20190508181223.GH1247@mini-arch>
 <20190513185724.GB24057@mini-arch>
 <CAADnVQLX3EcbW=iVxjsjO38M3Lqw5TfCcZtmbnt1DJwDvp64dA@mail.gmail.com>
 <20190514173002.GB10244@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514173002.GB10244@mini-arch>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 10:30:02AM -0700, Stanislav Fomichev wrote:
> On 05/14, Alexei Starovoitov wrote:
> > On Mon, May 13, 2019 at 11:57 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 05/08, Stanislav Fomichev wrote:
> > > > On 05/08, Alexei Starovoitov wrote:
> > > > > On Wed, May 08, 2019 at 10:18:41AM -0700, Stanislav Fomichev wrote:
> > > > > > Right now we are not using rcu api correctly: we pass __rcu pointers
> > > > > > to bpf_prog_array_xyz routines but don't use rcu_dereference on them
> > > > > > (see bpf_prog_array_delete_safe and bpf_prog_array_copy in particular).
> > > > > > Instead of sprinkling rcu_dereferences, let's just get rid of those
> > > > > > __rcu annotations and move rcu handling to a higher level.
> > > > > >
> > > > > > It looks like all those routines are called from the rcu update
> > > > > > side and we can use simple rcu_dereference_protected to get a
> > > > > > reference that is valid as long as we hold a mutex (i.e. no other
> > > > > > updater can change the pointer, no need for rcu read section and
> > > > > > there should not be a use-after-free problem).
> > > > > >
> > > > > > To be fair, there is currently no issue with the existing approach
> > > > > > since the calls are mutex-protected, pointer values don't change,
> > > > > > __rcu annotations are ignored. But it's still nice to use proper api.
> > > > > >
> > > > > > The series fixes the following sparse warnings:
> > > > >
> > > > > Absolutely not.
> > > > > please fix it properly.
> > > > > Removing annotations is not a fix.
> > > > I'm fixing it properly by removing the annotations and moving lifetime
> > > > management to the upper layer. See commits 2-4 where I fix the users, the
> > > > first patch is just the "preparation".
> > > >
> > > > The users are supposed to do:
> > > >
> > > > mutex_lock(&x);
> > > > p = rcu_dereference_protected(prog_array, lockdep_is_held(&x))
> > > > // ...
> > > > // call bpf_prog_array helpers while mutex guarantees that
> > > > // the object referenced by p is valid (i.e. no need for bpf_prog_array
> > > > // helpers to care about rcu lifetime)
> > > > // ...
> > > > mutex_unlock(&x);
> > > >
> > > > What am I missing here?
> > >
> > > Just to give you my perspective on why current api with __rcu annotations
> > > is working, but not optimal (even if used from the rcu read section).
> > >
> > > Sample code:
> > >
> > >         struct bpf_prog_array __rcu *progs = <comes from somewhere>;
> > >         int n;
> > >
> > >         rcu_read_lock();
> > >         n = bpf_prog_array_length(progs);
> > >         if (n > 0) {
> > >           // do something with __rcu progs
> > >           do_something(progs);
> > >         }
> > >         rcu_read_unlock();
> > >
> > > Since progs is __rcu annotated, do_something() would need to do
> > > rcu_dereference again and it might get a different value compared to
> > > whatever bpf_prog_array_free got while doing its dereference.
> > 
> > correct and I believe the code deals with it fine.
> > cnt could be different between two calls.
> Yes, currently there is no problem, all users of these apis
> are fine because they are holding a mutex (and are hence in the rcu update
> path, i.e. the pointer can't change and they have a consistent view
> between the calls).
> 
> For example, we currently have:
> 
> 	int n1, n2;
> 	mutex_lock(&x);
> 	n1 = bpf_prog_array_length(progs);
> 	n2 = bpf_prog_array_length(progs);
> 	// n1 is guaranteed to be the same as n2 as long as we
> 	// hold a mutex; single updater only
> 	...
> 	mutex_unlock(&x);
> 
> Versus:
> 
> 	rcu_read_lock();
> 	n1 = bpf_prog_array_length(progs);
> 	n2 = bpf_prog_array_length(progs);
> 	// n1 and n2 can be different; rcu_read_lock is all about
> 	// lifetime
> 	...
> 	rcu_read_unlock();
> 
> But, as I said, we don't use those __rcu annotated bpf_prog_array
> routines in the rcu read section, so we are fine.
> 
> (I'm just showing that potentially there might be a problem if we don't move
> rcu management away from bpf_prog_array routines and if someone
> decides to call them under rcu_read_lock).
> 
> > > A better way is not to deal with rcu inside those helpers and let
> > > higher layers do that:
> > >
> > >         struct bpf_prog_array __rcu *progs = <comes from somewhere>;
> > >         struct bpf_prog_array *p;
> > >         int n;
> > >
> > >         rcu_read_lock();
> > >         p = rcu_dereference(p);
> > >         n = bpf_prog_array_length(p);
> > >         if (n > 0) {
> > >           do_something(p); // do_something sees the same p as bpf_prog_array_length
> > >         }
> > >         rcu_read_unlock();
> > >
> > > What do you think?
> > 
> > I'm not sure that generically applicable.
> > Which piece of code do you have in mind for such refactoring?
> All existing callers of (take a look at patches 2-4):
> 
> * bpf_prog_array_free
> * bpf_prog_array_length
> * bpf_prog_array_copy_to_user
> * bpf_prog_array_delete_safe
> * bpf_prog_array_copy_info
> * bpf_prog_array_copy
> 
> They are:
> 
> * perf event bpf attach/detach/query (under bpf_event_mutex)
> * cgroup attach/detach/query (management of cgroup_bpf->effective, under
>   cgroup_mutex)
> * lirc bpf attach/detach/query (under ir_raw_handler_lock)
> 
> Nobody uses these apis in the rcu read section, so we can remove the
> annotations and use rcu_dereference_protected on the higher layer.
> 
> Side bonus is that we can also remove __rcu from cgroup_bpf.inactive
> (which is just a temp storage and not updated in the rcu fashion) and
> from old_array in activate_effective_progs (which is an on-stack
> array and, I guess, only has __rcu annotation to satisfy sparse).
> 
> So nothing is changing functionality-wise, but it becomes a bit easier
> to reason about by being more explicit with rcu api.

disagree. mutex is necesary.

