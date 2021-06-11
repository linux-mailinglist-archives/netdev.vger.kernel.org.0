Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962EF3A3864
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 02:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhFKAQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 20:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbhFKAQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 20:16:47 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D33C061574;
        Thu, 10 Jun 2021 17:14:36 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id d5-20020a17090ab305b02901675357c371so4777935pjr.1;
        Thu, 10 Jun 2021 17:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6kKK8GvRx3Km5hfKC6h4WhcE1sVd72a9N244SiCTaxc=;
        b=aIsRV7Xz0deSGi9/tu+UnHO63jhyM3AzHQ75FH9hnx3ayttVvxYFd8NQkaIvSiZvWW
         yJfjxuEiGs9Pe97LvF7qBnufi04QnTNr9U4hxPX3pxd83lbDQLd3RIRWhNozTA0quaP+
         ELo9tt1arwk4w76kjQlSB8+2C3ZP0BZEqDkcjCALPAbo7z/Gr/AxExMsyyCXQiYxzjiu
         Zf5FAawJDiK73eRXVr5HDpkVmVWuI1vbuFaYOHB9ThE4FhVjeDBemb/UNRl512l8dlLI
         PecsxBPeleVqHkwZVpj4rXCS8pVRU9PzHbHVnH25OU7+kFwE4qGZruqaQnK4j2YzQvZG
         B43w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6kKK8GvRx3Km5hfKC6h4WhcE1sVd72a9N244SiCTaxc=;
        b=uiblMZFVO8Zm3z65Z0hwmCyzNFCxjAO2hghyRfYUK8Mp7NwnF61M64UYDhLlRSb0yQ
         9uro08ZlHpv88S5mo3yD5wJ9PTBnBEiPBXVqowMez5uUvFb6orkPtvr1eWPBkAixJTC+
         SlKh7LFYsMff6WYP35QLzssWrkCWqC/+gzCAkhW0m22Vq/EI0gs3LUuNcttsqZ5+etaO
         JXN7LKSCtBabI837P4v6fEJxP7iQS9gJeskaFKsKxmC3tUPRQjr5NIZ3zdPc2wLsFU0n
         7zrJU0rTJPnB6SfgrDGo9Vm1I3RPaknwQlosVhxVE6Z5s9xKRN1uXI9+I5N+BfI30Pr4
         3P5A==
X-Gm-Message-State: AOAM530896OaYl3AHHea3JcqLFDkqXA/CMT3M/n2plNuTl4Kn0VIsPAu
        YV0aoTE7bxDiPNi7qCooc+HM79+NnU8RgbCV96GSegrBWioy1A==
X-Google-Smtp-Source: ABdhPJxp9eI7LaA8Rv1tY9uLuQ84ORHgW0K9AJXJjNF6e1pPE9YO2vKgPepj9VvhZbf9ZlDaAekzbaWWvnJzPnY1Syw=
X-Received: by 2002:a17:902:a60a:b029:f0:ad94:70bf with SMTP id
 u10-20020a170902a60ab02900f0ad9470bfmr1234281plq.31.1623370475667; Thu, 10
 Jun 2021 17:14:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210531153410.93150-1-changbin.du@gmail.com> <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAM_iQpUEjBDK44=mD5shkmmoDYhmHQaSZtR34rLRkgd9wSWiQQ@mail.gmail.com>
 <20210602091451.kbdul6nhobilwqvi@wittgenstein> <CAM_iQpUqgeoY_mA6cazUPCWwMK6yw9SaD6DRg-Ja4r6r_zOmLg@mail.gmail.com>
 <20210604095451.nkfgpsibm5nrqt3f@wittgenstein> <CAM_iQpUqp1PRKfS6WcsZ16yjF4jjOrkTHX7Zdhrqo0nrE2VH1Q@mail.gmail.com>
 <20210607090844.mje2xgdkcnqsezlu@wittgenstein>
In-Reply-To: <20210607090844.mje2xgdkcnqsezlu@wittgenstein>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 10 Jun 2021 17:14:24 -0700
Message-ID: <CAM_iQpWTrpSQPuVg4VLjKsOYb8i_evYux0pL_bwrTHK0uXTh0g@mail.gmail.com>
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

On Mon, Jun 7, 2021 at 2:08 AM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Sun, Jun 06, 2021 at 05:37:40PM -0700, Cong Wang wrote:
> > On Fri, Jun 4, 2021 at 2:54 AM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
> > >
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
> >
> > Let me explain it in this more straight way: what is the protocol here
> > for indication of !CONFIG_XXX_NS? Clearly it must be ns->ops==NULL,
> > because all namespaces use the following similar pattern:
> >
> > #ifdef CONFIG_NET_NS
> >         net->ns.ops = &netns_operations;
> > #endif
> >
> > Now you are arguing the protocol is not this, but it is the getter of
> > open_related_ns() returns an error pointer.
>
> I don't understand what this is supposed to tell me.

This tells you whatever you called a bug, it is just a protocol.

You are trying to justify it as bug by interpreting is as a getter
like get_net_ns_by_fd(). None of them makes sense, neither
is this bug, nor it is any similar to get_net_ns_by_fd().


>
> >
> > >
> > > (Pluse they are defined in a central place in net/net_namespace.{c,h}.
> > > That includes the low-level get_net() function and all the others.
> > > get_net_ns() is the only one that's defined out of band. So get_net_ns()
> > > currently is arguably also misplaced.)
> >
> > Of course they do, only struct ns_common is generic. What's your
> > point? Each ns.ops is defined by each namespace too.
>
> All netns helpers should arguably be located in a central place
> including get_net_ns(). There's no need to spread such helpers
> everywhere. This is completely orthogonaly to struct ns_common.

I have no idea why you want to argue on something I don't disagree
with. Actually, the proposal from me only changes fs/nsfs.c, so you
do not even need to worry about file locations at all.

>
> >
> > >
> > > The problem I have with fixing this in nsfs is that it gives the
> > > impression that this is a bug in nsfs whereas it isn't and it
> > > potentially helps tapering over other bugs.
> >
> > Like I keep saying, this is just a protocol, there is no right or
> > wrong here. If the protocol is just ops==NULL, then there is nothing
> > wrong use it.
> >
> > (BTW, we have a lot of places that use ops==NULL as a protocol,
> > they work really well.)
> >
> > >
> > > get_net_ns() is only called for codepaths that call into nsfs via
> > > open_related_ns() and it's the only namespace that does this. But
> >
> > I am pretty sure userns does the same:
> >
> > 197         case NS_GET_USERNS:
> > 198                 return open_related_ns(ns, ns_get_owner);
>
> Maybe I wasn't clear enough, open_related_ns() is the only namespace
> that calls into nsfs via open_related_ns() __outside__ of fs/nsfs.c I
> thought that was pretty clear.

Why it matter which calls open_related_ns() here? The point is
ns_get_owner() and get_net_ns() are defined by each ns, IOW,
outside of fs/nsfs.c.

>
> But also...
>
> #ifdef CONFIG_USER_NS
> struct ns_common *ns_get_owner(struct ns_common *ns);
> #else
> static inline struct ns_common *ns_get_owner(struct ns_common *ns)
> {
>         return ERR_PTR(-EPERM);
> }
> #endif
>
> So ns_get_owner() returns -EPERM when !CONFIG_USER_NS so the callback
> handles the !CONFIG_USER_NS case. And that's what we were saying
> get_net_ns() should do.

Sure, thanks for pointing this out. This is unnecessary too, like I said,
if the protocol is simply ns.ops==NULL. No one says the current code
is perfect, all code can be improved, so using existing code can't justify
it.

>
> >
> >
> > > open_related_ns() is only well defined if CONFIG_<NAMESPACE_TYPE> is
> > > set. For example, none of the procfs namespace f_ops will be set for
> > > !CONFIG_NET_NS. So clearly the socket specific getter here is buggy as
> > > it doesn't account for !CONFIG_NET_NS and it should be fixed.
> >
> > If the protocol is just ops==NULL, then the core part should just check
> > ops==NULL. Pure and simple. I have no idea why you do not admit the
> > fact that every namespace intentionally leaves ops as NULL when its
> > config is disabled.
>
> I'm just going to quote myself:
>
> > > set. For example, none of the procfs namespace f_ops will be set for
> > > !CONFIG_NET_NS.
>
> If a given namespace type isn't selected then it will never appear in
> /proc/<pid>/ns/* which is why the proc_ns_operations aren't defined in
> fs/proc/namespaces.c.
>
> In other words, you can't get a file descriptor for a given namespace
> through proc or rather the nsfs part of proc when that namespace type
> isn't selected.

Who said open_related_ns() should return a fd in such a case?
Clearly it must return an error here.

>
> The open_related_ns() function is a function that is just there to give
> you a namespace fd and it assumes that when it is called that the
> namespace type is selected for or that the callback you're passing it
> handles that case.

Once again, this is just a protocol. Let me compare your protocol
with mine:

1. You want to use the getter as a protocol for indicating a ns is
disabled;

2. I prefer to use ns.ops==NULL as a protocol here.

And let me explain why 2) is better than 1):

a) The final code is less with 2), because all those ugly #ifdef's
are all gone. The getter would not even be called if ns.ops==NULL.

b) The code is more readable. The point of the getter is to increase
refcnt of a specific ns. There is nothing wrong to at least literally
increase the refcnt of init_net. With your approach, it simply says
getting init_net is not supported if !CONFIG_NET_NS, this is just
false.

c) It is slightly faster to error out. open_related_ns() would return
an error even before get_unused_fd_flags(). With your approach,
it defers to the getter, that is, after get_unused_fd_flags().


>
> For example, see you're own example about ns_get_owner() above.
>
> >
> > >
> > > Plus your fix leaks references to init netns without fixing get_net_ns()
> > > too.
> >
> > I thought it is 100% clear that this patch is not from me?
> >
> > Plus, the PoC patch from me actually suggests to change
> > open_related_ns(), not __ns_get_path(). I have no idea why you
> > both miss it.
>
> Turning this around, I'm not sure what your resistance to just doing it
> like ns_get_owner() is doing it is.

I have the same doubt. See above on why.

Thanks.
