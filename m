Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8899039D265
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 02:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhFGAk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 20:40:57 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:33653 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhFGAkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 20:40:55 -0400
Received: by mail-pg1-f178.google.com with SMTP id e20so593954pgg.0;
        Sun, 06 Jun 2021 17:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BhyIEJR3nChTbrHZqmUAy7TeMp1NR81AY1C+mI8Wo5w=;
        b=CWYiO1KP83T0IsRKn1QMS3LzHYuzKeraoS+zY+9stRMeqTU/QawI/cXPX1GsYiaNwM
         ErNvLOOIG5GbvdDV5e/V3fpHpp/tWIAfbeFb1g5wWAue492QId7XvxdUXKa6GE6Tdh/x
         20Xyn9yAOB+rTnqGf9uvrxjwhAquFLuIPtCF/FNSx1aVgV5a5zF9CyZC10xbGTeFjyJr
         6XXl51cVBaxYirDF4wY0whtEZf3XSLpyAG+iPRpmpdk5hrPH43bDlByAse3ofRX05GCr
         Gt4whNUx3OnUIw2Cgyi4XITOMLI9ayVVgnnbrl7ciVqzgZ1roUYtOJmUsuCDEo8r0nOF
         UMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BhyIEJR3nChTbrHZqmUAy7TeMp1NR81AY1C+mI8Wo5w=;
        b=bnskK6KR2BfguykN1IAlK6VGdpT511wdqpwrmmeo/Qja006gaIb/EWZvX3baxOqk9s
         kfacGIFFRmFNoAyutSwYHEBpUvDhEQY63cfdkbDDIVQ3hNab0FxSi0UcKTvdc+fKa5OF
         PLuIw6uYby/+/Xt6MyLJwrw076tmRa8RG2sLNDx+SdOK5hjKg6n5WYhenAWc3vlyq5z2
         IlIRqnff4mzdaT7O0ArshZq6gA2oKdarj/b3coXnHpVy4FdrkZvOVb+kUjBCOgXjsd5y
         R0ltCBcIRUzDbzj5P+6oQk5gPBZO+DfsS/ZFKBCwYu07Nf4ZbXX8ry0tZQvKvj0v8ICs
         7tUQ==
X-Gm-Message-State: AOAM531ujpkje3I0JhATOUKB6XOS6PyhDVswA83GgPzGP0yLY/Wl15bE
        /TvKVlfCNjrOMFu8Ixnz4+bYGIiVfj+LQhTOEclfywHrgGChtw==
X-Google-Smtp-Source: ABdhPJzuvBMg7egK8k5L+PkFrO+ZvQzvq6MygAgiCjcVVvRSQOFNzHTdxJdTiCpuUvBHM3A/EiXdnN3tgJJkKfGqsag=
X-Received: by 2002:a62:31c7:0:b029:2e9:2c05:52d3 with SMTP id
 x190-20020a6231c70000b02902e92c0552d3mr14607993pfx.78.1623026271508; Sun, 06
 Jun 2021 17:37:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210531153410.93150-1-changbin.du@gmail.com> <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAM_iQpUEjBDK44=mD5shkmmoDYhmHQaSZtR34rLRkgd9wSWiQQ@mail.gmail.com>
 <20210602091451.kbdul6nhobilwqvi@wittgenstein> <CAM_iQpUqgeoY_mA6cazUPCWwMK6yw9SaD6DRg-Ja4r6r_zOmLg@mail.gmail.com>
 <20210604095451.nkfgpsibm5nrqt3f@wittgenstein>
In-Reply-To: <20210604095451.nkfgpsibm5nrqt3f@wittgenstein>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 6 Jun 2021 17:37:40 -0700
Message-ID: <CAM_iQpUqp1PRKfS6WcsZ16yjF4jjOrkTHX7Zdhrqo0nrE2VH1Q@mail.gmail.com>
Subject: Re: [PATCH] nsfs: fix oops when ns->ops is not provided
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Changbin Du <changbin.du@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 4, 2021 at 2:54 AM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Thu, Jun 03, 2021 at 03:52:29PM -0700, Cong Wang wrote:
> > On Wed, Jun 2, 2021 at 2:14 AM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
> > > But the point is that ns->ops should never be accessed when that
> > > namespace type is disabled. Or in other words, the bug is that something
> > > in netns makes use of namespace features when they are disabled. If we
> > > handle ->ops being NULL we might be tapering over a real bug somewhere.
> >
> > It is merely a protocol between fs/nsfs.c and other namespace users,
> > so there is certainly no right or wrong here, the only question is which
> > one is better.
> >
> > >
> > > Jakub's proposal in the other mail makes sense and falls in line with
> > > how the rest of the netns getters are implemented. For example
> > > get_net_ns_fd_fd():
> >
> > It does not make any sense to me. get_net_ns() merely increases
> > the netns refcount, which is certainly fine for init_net too, no matter
> > CONFIG_NET_NS is enabled or disabled. Returning EOPNOTSUPP
> > there is literally saying we do not support increasing init_net refcount,
> > which is of course false.
> >
> > > struct net *get_net_ns_by_fd(int fd)
> > > {
> > >         return ERR_PTR(-EINVAL);
> > > }
> >
> > There is a huge difference between just increasing netns refcount
> > and retrieving it by fd, right? I have no idea why you bring this up,
> > calling them getters is missing their difference.
>
> This argument doesn't hold up. All netns helpers ultimately increase the
> reference count of the net namespace they find. And if any of them
> perform operations where they are called in environments wherey they
> need CONFIG_NET_NS they handle this case at compile time.

Let me explain it in this more straight way: what is the protocol here
for indication of !CONFIG_XXX_NS? Clearly it must be ns->ops==NULL,
because all namespaces use the following similar pattern:

#ifdef CONFIG_NET_NS
        net->ns.ops = &netns_operations;
#endif

Now you are arguing the protocol is not this, but it is the getter of
open_related_ns() returns an error pointer.

>
> (Pluse they are defined in a central place in net/net_namespace.{c,h}.
> That includes the low-level get_net() function and all the others.
> get_net_ns() is the only one that's defined out of band. So get_net_ns()
> currently is arguably also misplaced.)

Of course they do, only struct ns_common is generic. What's your
point? Each ns.ops is defined by each namespace too.

>
> The problem I have with fixing this in nsfs is that it gives the
> impression that this is a bug in nsfs whereas it isn't and it
> potentially helps tapering over other bugs.

Like I keep saying, this is just a protocol, there is no right or
wrong here. If the protocol is just ops==NULL, then there is nothing
wrong use it.

(BTW, we have a lot of places that use ops==NULL as a protocol,
they work really well.)

>
> get_net_ns() is only called for codepaths that call into nsfs via
> open_related_ns() and it's the only namespace that does this. But

I am pretty sure userns does the same:

197         case NS_GET_USERNS:
198                 return open_related_ns(ns, ns_get_owner);


> open_related_ns() is only well defined if CONFIG_<NAMESPACE_TYPE> is
> set. For example, none of the procfs namespace f_ops will be set for
> !CONFIG_NET_NS. So clearly the socket specific getter here is buggy as
> it doesn't account for !CONFIG_NET_NS and it should be fixed.

If the protocol is just ops==NULL, then the core part should just check
ops==NULL. Pure and simple. I have no idea why you do not admit the
fact that every namespace intentionally leaves ops as NULL when its
config is disabled.

>
> Plus your fix leaks references to init netns without fixing get_net_ns()
> too.

I thought it is 100% clear that this patch is not from me?

Plus, the PoC patch from me actually suggests to change
open_related_ns(), not __ns_get_path(). I have no idea why you
both miss it.

Thanks.
