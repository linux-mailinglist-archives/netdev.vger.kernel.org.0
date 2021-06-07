Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D2239EA1E
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 01:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhFGXbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 19:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhFGXbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 19:31:53 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F78C061574;
        Mon,  7 Jun 2021 16:29:45 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o17-20020a17090a9f91b029015cef5b3c50so12907846pjp.4;
        Mon, 07 Jun 2021 16:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WVAzmK8H3W9Ri9Nc0aJ9dVosaDkdeeCrZdMPkV9t51c=;
        b=TSwk/OCzSVNhW1q1RK9oYL0/x69CBqintCn+wmoqN/5K1k42H6oe0dXfRF4lJ+V7hj
         JhFoZqBQN1FugeNnXXadvBEq4v06/iTSHQSnEeE74Tz3mWILMrrpY1gRsZcon0d3zuLf
         Z+v39bZ3My8pOjFkoI4IMMx4lSW7qwZdpdaQI1jD9d+65xB6QUa2m72r5gkfdV591AIR
         tX8PeRJeLEpMAhumKISaEcU3ETInCyQ0JCgHxf+sS5qGZVa6EnfdhuLYItdJ+R43I9Zo
         DuM2epq54rWm2auKfH76lWhyvWVlb9UsZdYZMlPdCover6orq5nKoeVntSwunlcFkJJl
         C3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WVAzmK8H3W9Ri9Nc0aJ9dVosaDkdeeCrZdMPkV9t51c=;
        b=HT7mXB+nwE+zSq0kYm2IsUqOfMQCCacTlf2t2tmrGxSnupEDTLp9SQiL15EpU7D1FC
         Ksm4pROi+u88fiwiMQ3RQIB660EFWXV4aDDkC20ZjSxA/GysQqivE6RDH7J1QtdfNBgq
         UfiBiWlIwVpEZ2/mfPxHmQWJIgwColNhcQD+U+alZOX1eWuUpQON0kdEQPIa5XMqU+WI
         AdPOJ8/A0uUTBUtnJZtlgAyDEMk6SVkzNs/CuRNl0ThsZmZMVGmX5hmelY/S5XuBeT+E
         yeUl4do05avk4DjLofDdUrfbQAGsybs1Uo5lM5duT8ccd99ZM0tFdErvXdkf1/fz5age
         XoAg==
X-Gm-Message-State: AOAM530l0MDRv+1DEW0PfZK9jNb6HGXEmmVj4nH1cTQOzD0lC9Gt8glb
        UNIJ2fJeDYQnII2Os6uqWio=
X-Google-Smtp-Source: ABdhPJya5OJVM2Mfsaay/R4SFeWneiJ01QSSkim3v7mHmS6BJwsa27qAY2XoMyRy0/H1AjB1O2Pkzw==
X-Received: by 2002:a17:90a:540d:: with SMTP id z13mr23503575pjh.159.1623108580881;
        Mon, 07 Jun 2021 16:29:40 -0700 (PDT)
Received: from mail.google.com ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id i74sm421694pgc.85.2021.06.07.16.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 16:29:40 -0700 (PDT)
Date:   Tue, 8 Jun 2021 07:29:29 +0800
From:   Changbin Du <changbin.du@gmail.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Changbin Du <changbin.du@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH] nsfs: fix oops when ns->ops is not provided
Message-ID: <20210607232929.2usugccbcospdk5g@mail.google.com>
References: <20210531153410.93150-1-changbin.du@gmail.com>
 <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAM_iQpUEjBDK44=mD5shkmmoDYhmHQaSZtR34rLRkgd9wSWiQQ@mail.gmail.com>
 <20210602091451.kbdul6nhobilwqvi@wittgenstein>
 <CAM_iQpUqgeoY_mA6cazUPCWwMK6yw9SaD6DRg-Ja4r6r_zOmLg@mail.gmail.com>
 <20210604095451.nkfgpsibm5nrqt3f@wittgenstein>
 <20210606224322.yxr47tgdqis35dcl@mail.google.com>
 <20210607091647.pzqyarxbupvnbxyw@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607091647.pzqyarxbupvnbxyw@wittgenstein>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 11:16:47AM +0200, Christian Brauner wrote:
> On Mon, Jun 07, 2021 at 06:43:41AM +0800, Changbin Du wrote:
> > On Fri, Jun 04, 2021 at 11:54:51AM +0200, Christian Brauner wrote:
> > > On Thu, Jun 03, 2021 at 03:52:29PM -0700, Cong Wang wrote:
> > > > On Wed, Jun 2, 2021 at 2:14 AM Christian Brauner
> > > > <christian.brauner@ubuntu.com> wrote:
> > > > > But the point is that ns->ops should never be accessed when that
> > > > > namespace type is disabled. Or in other words, the bug is that something
> > > > > in netns makes use of namespace features when they are disabled. If we
> > > > > handle ->ops being NULL we might be tapering over a real bug somewhere.
> > > > 
> > > > It is merely a protocol between fs/nsfs.c and other namespace users,
> > > > so there is certainly no right or wrong here, the only question is which
> > > > one is better.
> > > > 
> > > > >
> > > > > Jakub's proposal in the other mail makes sense and falls in line with
> > > > > how the rest of the netns getters are implemented. For example
> > > > > get_net_ns_fd_fd():
> > > > 
> > > > It does not make any sense to me. get_net_ns() merely increases
> > > > the netns refcount, which is certainly fine for init_net too, no matter
> > > > CONFIG_NET_NS is enabled or disabled. Returning EOPNOTSUPP
> > > > there is literally saying we do not support increasing init_net refcount,
> > > > which is of course false.
> > > > 
> > > > > struct net *get_net_ns_by_fd(int fd)
> > > > > {
> > > > >         return ERR_PTR(-EINVAL);
> > > > > }
> > > > 
> > > > There is a huge difference between just increasing netns refcount
> > > > and retrieving it by fd, right? I have no idea why you bring this up,
> > > > calling them getters is missing their difference.
> > > 
> > > This argument doesn't hold up. All netns helpers ultimately increase the
> > > reference count of the net namespace they find. And if any of them
> > > perform operations where they are called in environments wherey they
> > > need CONFIG_NET_NS they handle this case at compile time.
> > > 
> > > (Pluse they are defined in a central place in net/net_namespace.{c,h}.
> > > That includes the low-level get_net() function and all the others.
> > > get_net_ns() is the only one that's defined out of band. So get_net_ns()
> > > currently is arguably also misplaced.)
> > > 
> > Ihe get_net_ns() was a static helper function and then sb made it exported
> > but didn't move it. See commit d8d211a2a0 ('net: Make extern and export get_net_ns()').
> > 
> > > The problem I have with fixing this in nsfs is that it gives the
> > > impression that this is a bug in nsfs whereas it isn't and it
> > > potentially helps tapering over other bugs.
> > > 
> > > get_net_ns() is only called for codepaths that call into nsfs via
> > > open_related_ns() and it's the only namespace that does this. But
> > > open_related_ns() is only well defined if CONFIG_<NAMESPACE_TYPE> is
> > > set. For example, none of the procfs namespace f_ops will be set for
> > > !CONFIG_NET_NS. So clearly the socket specific getter here is buggy as
> > > it doesn't account for !CONFIG_NET_NS and it should be fixed.
> > I agree with Cong that a pure getter returns a generic error is a bit weird.
> > And get_net_ns() is to get the ns_common which always exists indepent of
> > CONFIG_NET_NS. For get_net_ns_by_fd(), I think it is a 'findder + getter'.
> > 
> > So maybe we can rollback to patch V1 to fix all code called into
> > open_related_ns()?
> > https://lore.kernel.org/netdev/CAM_iQpWwApLVg39rUkyXxnhsiP0SZf=0ft6vsq=VxFtJ2SumAQ@mail.gmail.com/T/
> > 
> > --- a/net/socket.c
> > +++ b/net/socket.c
> > @@ -1149,11 +1149,15 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
> >  			mutex_unlock(&vlan_ioctl_mutex);
> >  			break;
> >  		case SIOCGSKNS:
> > +#ifdef CONFIG_NET_NS
> >  			err = -EPERM;
> >  			if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
> >  				break;
> >  
> >  			err = open_related_ns(&net->ns, get_net_ns);
> > +#else
> > +			err = -ENOTSUPP;
> > +#endif
> 
> If Jakub is fine with it I don't really care much but then you need to
> fix the other places in tun.c as well.
> I'm just not sure what's so special about get_net_ns() that it can't
> simply get an ifdef !CONFIG_NET_NS section.
> But it seems that there's magic semantics deeply hidden in this helper
> that btw only exists for open_related_ns() that makes this necessary:
> 
> drivers/net/tun.c:              return open_related_ns(&net->ns, get_net_ns);
> drivers/net/tun.c:              ret = open_related_ns(&net->ns, get_net_ns);
> include/linux/socket.h:extern struct ns_common *get_net_ns(struct ns_common *ns);
> net/socket.c: * get_net_ns - increment the refcount of the network namespace
> net/socket.c:struct ns_common *get_net_ns(struct ns_common *ns)
> net/socket.c:EXPORT_SYMBOL_GPL(get_net_ns);
> net/socket.c:                   err = open_related_ns(&net->ns, get_net_ns);
> tools/perf/trace/beauty/include/linux/socket.h:extern struct ns_common *get_net_ns(struct ns_common *ns);
>
Yes, all these must be fixed, too. I can do that if Jakub agrees.

> > 
> > > 
> > > Plus your fix leaks references to init netns without fixing get_net_ns()
> > > too.
> > > You succeed to increase the refcount of init netns in get_net_ns() but
> > > then you return in __ns_get_path() because ns->ops aren't set before
> > > ns->ops->put() can be called.  But you also _can't_ call it since it's
> > > not set because !CONFIG_NET_NS. So everytime you call any of those
> > > ioctls you increas the refcount of init net ns without decrementing it
> > > on failure. So the fix is buggy as it is too and would suggest you to
> > > fixup get_net_ns() too.
> > Yes, it is a problem. Can be put a BUG_ON() in nsfs so that such bug (calling
> > into nsfs without ops) can be catched early?
> 
> Maybe place a WARN_ON() in there.
> 
How about below change? We need to avoid oops if we can.
-- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -62,6 +62,10 @@ static int __ns_get_path(struct path *path, struct ns_common *ns)
        struct inode *inode;
        unsigned long d;

+       /* In case the namespace is not actually enabled. */
+       if (WARN_ON(!ns->ops))
+               return -EINVAL;
+
        rcu_read_lock();

> Christian

-- 
Cheers,
Changbin Du
