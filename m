Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CC846C704
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 22:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhLGWC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 17:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhLGWCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 17:02:25 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD85C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 13:58:54 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id o4so1134070oia.10
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 13:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oh6V9djUOUD4DkywTEOLgJwJJAvB5yL9knRAxivu/q0=;
        b=D9cAPtiwyEjWsv7RPNRy4AZNdmQcSH211oYObcky8thMxiraUeY0ldayn+gQktW8vz
         T3UzP09PLzZIQd4LfKrPS5g/TNAOzNvXDMQ89pCUf3TkQ3rdUzct4ItMiudw2tJNxUnd
         kQkz8sudMdaoycZN5XUwBCC0prN+CtRUD3UldYgV/5AQyyvkFxSEt9tXhgE0Ow8j1RY3
         Az8wT3Zo/ZC5/HazJ4N+TdSKeKuMxgw+DMvFlV7zKY/GMwV7guj2NAYGcy+3X/Stj5eu
         C0NApiqUA0PGR9PBs3IRn0UKXHdcF1QjwrxewZk44sw0dbcBTQZimLqzUSdpKAJUdptW
         TOmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oh6V9djUOUD4DkywTEOLgJwJJAvB5yL9knRAxivu/q0=;
        b=qf4QwNeZR6tzrqZAksrSZAEOcHAKjBjsX7h7s/ZeVqkXzKoZ71kfn9PtgQF14FwSWy
         b6shABQgCSHudrztKXw/lgrLMKq6avzW/TwLqmZZfqPI2XSt5x1Fbp4L4Mkh2LRdUOvr
         HV6fP7VhvD/TdczryF+TclyKXfSFdcqCzadacRP+fBMVydh8QWjoQkPycI8AUvBuUrP9
         /6x481IrEGNIUhOXv5SMc3Do9APoRizjpTc8r9q2D3VgLkRLyzyBr4ZPL3WY+Oo6EOQ1
         NVhCG2yMZLD5h4sVI2XTW5u7o3czUWdcV9ndClfVp9wEHALLwM5RpypplowsIU4YQv3U
         e5cA==
X-Gm-Message-State: AOAM5306DrR6sK3zccI/TXZr6LlGXCEuyaOW2M3OAy6mFbXUBEnIP244
        Lsw8sGwH9mZcc5u4gzowHaGOd5jnxwyZMZPu57s=
X-Google-Smtp-Source: ABdhPJyhyuIur+/F/us+sSRtHDXM0DYZC+7H7XBd3i3JclHo0QxAtDIo5vmsFpho5deVgiQDlBVv3qKbX50ECmBkAGU=
X-Received: by 2002:a05:6808:10c9:: with SMTP id s9mr7664870ois.23.1638914334231;
 Tue, 07 Dec 2021 13:58:54 -0800 (PST)
MIME-Version: 1.0
References: <cover.1638849511.git.lucien.xin@gmail.com> <CANn89iJyiDbGdvm-oNKBBk5r3-0+3h+3ui1pL3rOTrz2BOztmA@mail.gmail.com>
 <CADvbK_c-SpsVDgOgUO2YqcT3qS4c9BL=qHYnrEgp2S3tqvR-Zw@mail.gmail.com> <CANn89iJE94zTJNKmNivHcy9zK_hyXNnXf2OYH1+HxVNo1m0T=Q@mail.gmail.com>
In-Reply-To: <CANn89iJE94zTJNKmNivHcy9zK_hyXNnXf2OYH1+HxVNo1m0T=Q@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 7 Dec 2021 16:58:42 -0500
Message-ID: <CADvbK_f0-MfV4w4aOCO-8h4=82hL3Eh3OKR1g7qoetW56bxPpA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] net: add refcnt tracking for some common objects
To:     Eric Dumazet <edumazet@google.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 7, 2021 at 1:34 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Dec 7, 2021 at 10:17 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Mon, Dec 6, 2021 at 11:41 PM Eric Dumazet <edumazet@google.com> wrot=
e:
> > >
> > > On Mon, Dec 6, 2021 at 8:02 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > >
> > > > This patchset provides a simple lib(obj_cnt) to count the operating=
s on any
> > > > objects, and saves them into a gobal hashtable. Each node in this h=
ashtable
> > > > can be identified with a calltrace and an object pointer. A calltra=
ce could
> > > > be a function called from somewhere, like dev_hold() called by:
> > > >
> > > >     inetdev_init+0xff/0x1c0
> > > >     inetdev_event+0x4b7/0x600
> > > >     raw_notifier_call_chain+0x41/0x50
> > > >     register_netdevice+0x481/0x580
> > > >
> > > > and an object pointer would be the dev that this function is access=
ing:
> > > >
> > > >     dev_hold(dev).
> > > >
> > > > When this call comes to this object, a node including calltrace + o=
bject +
> > > > counter will be created if it doesn't exist, and the counter in thi=
s node
> > > > will increment if it already exists. Pretty simple.
> > > >
> > > > So naturally this lib can be used to track the refcnt of any object=
s, all
> > > > it has to do is put obj_cnt_track() to the place where this object =
is
> > > > held or put. It will count how many times this call has operated th=
is
> > > > object after checking if this object and this type(hold/put) access=
ing
> > > > are being tracked.
> > > >
> > > > After the 1st lib patch, the other patches add the refcnt tracking =
for
> > > > netdev, dst, in6_dev and xfrm_state, and each has example how to us=
e
> > > > in the changelog. The common use is:
> > > >
> > > >     # sysctl -w obj_cnt.control=3D"clear" # clear the old result
> > > >
> > > >     # sysctl -w obj_cnt.type=3D0x1     # track type 0x1 operating
> > > >     # sysctl -w obj_cnt.name=3Dtest    # match name =3D=3D test or
> > > >     # sysctl -w obj_cnt.index=3D1      # match index =3D=3D 1
> > > >     # sysctl -w obj_cnt.nr_entries=3D4 # save 4 frames' calltrace
> > > >
> > > >     ... (reproduce the issue)
> > > >
> > > >     # sysctl -w obj_cnt.control=3D"scan"  # print the new result
> > > >
> > > > Note that after seeing Eric's another patchset for refcnt tracking =
I
> > > > decided to post this patchset. As in this implemenation, it has som=
e
> > > > benefits which I think worth sharing:
> > > >
> > >
> > > How can your code coexist with ref_tracker ?
> > Hi, Eric, Thanks for your checking
> >
> > It won't affect ref_tracker, one can even use both at the same time.
> >
> > >
> > > >   - it runs fast:
> > > >     1. it doesn't create nodes for the repeatitive calls to the sam=
e
> > > >        objects, and it saves memory and time.
> > > >     2. the depth of the calltrace to record is configurable, at mos=
t
> > > >        time small calltrace also saves memory and time, but will no=
t
> > > >        affect the analysis.
> > > >     3. kmem_cache used also contributes to the performance.
> > >
> > > Points 2/3 can be implemented right away in the ref_tracker infra,
> > > please send patches.
> > >
> > > Quite frankly using a global hash table seems wrong, stack_depot
> > > already has this logic, why reimplement it ?
> > > stack_depot is damn fast (no spinlock in fast path)
> > What this patchset is trying to add is a calltrace+object counter.
> > I was looking at stack_depot after seeing you patch, stack_depot saves
> > calltrace only, no object(I guess this is okay, I can save object to
> > to entries[0] if I want to use it), but also it's not a counter.
> >
> > I'm not sure if it's allowed to do some change and add a counter to
> > the node of stack_depot, like when it's found in saving, the counter
> > increments. That will be perfect for this patchset.
> >
> > This global spinlock will eventually be used only to protect the new
> > node's insertion. For the fast path (lookup), rcu_read_lock() will take
> > care of it. I haven't got time to add it. but this won't be a problem.
> >
> > >
> > > Seeing that your patches add chunks in lib/obj_cnt.c, I do not see ho=
w
> > > you can claim this is generic code.
> > I planned it as a obj operating counter, it can be used for counting an=
y
> > operatings, not just for the refcnt tracker which is only _put and _hol=
d
> > operatings.
> >
> > >
> > > I don't know, it seems very strange to send this patch series now I
> > > have done about 60 patches on these issues.
> > This patch is not to do exactly the same things as your patchset, I thi=
nk your
> > patch saves more information into the objects in the kernel memory, it =
will
> > be useful for vmcore analysis.
> >
> > This patchset is working in a different way, it's going to target a
> > specific object with index or name or pointer matched and some types
> > of function calls to it, we have to plan in advance after we know
> > which object (like it's name, index or string to match) is leaked.
> >
> > >
> > > And by doing this work, I found already two bugs in our stack.
> > Great effects!
> > I can see that you must go over all networking stack for dev operations=
.
> >
> > >
> > > You can be sure syzbot will send us many reports, most syzbot repros
> > > use a very limited number of objects.
> > >
> > > About performance : You use a single spinlock to protect your hash ta=
ble.
> > > In my implementation, there is a spinlock per 'directory (eg one
> > > spinlock per struct net_device, one spinlock per struct net), it is
> > > more scalable.
> > I used per net spinlock at first, but I want to make the code more gene=
ric,
> > and not only for the network, then I decided to make it not related to =
net.
> >
> > After using rcu_lock in the fast path, I think this single spinlock won=
't
> > affect much, besides, this single lock can be replaced by a per hlist l=
ock
> > on each hlist_head, it will also save some.
> >
> > >
> > > My tests have not shown a significant cost of the ref_tracker
> > > (the major cost comes from stack_trace_save() which you also use)
> > I added "run fast" in cover, mostly because it won't create many nodes
> > if dev_hold/put are called many times, it only increments the count if =
it's
> > the same call to the same object already existing in the hashtable.
> >
> > dev could be fine, thinking about tracking dst, when sending packets, d=
st
> > can be hold/put too many times, creating nodes for each call is not a g=
ood
> > idea, especially for some leak only occurs once for few months which I'=
ve
> > seen quite a few times in our customer envs.
>
> That is why I chose to not automatically track all dev_hold()/dev_put()
>
> For the ones that are contained in a short function, with clear
> contract, there is
> no need for adding tracking.
>
> But before taking this decision, I am looking at each case, very carefull=
y.
OK, that's quite a lot of effort.
I'm sure you have a strong code review skill on networking code.

>
> >
> >
> > Other things are:
> > most net_dev leaks I've met are actually dst leak, some are in6_dev lea=
k,
> > only tracking net_dev is not enough to address it, do you have plans to
> > add dst track for dst too? That may be a lot of changes too?
>
> Yes, the plan is to add trackers when we think there is a high
> probability of having leaks.
>
> I think you missed the one major point of the exercise :
>
> By carefully doing the pairing, we can spot bugs already, even without
> turning the CONFIG_ options.
>
> Once this (patient) work done, it is done, the infra will catch future
> bugs right away.
It seems to me the phase of your patches' development is more fun.
For this patchset, it's the analysis part, we will do the pairing with the
results, and check which _hold and _put didn't come in pairs.

But I believe that refcnt track for netdev only is not enough, you might
eventually see the leak be caused by a missing dst_destroy() call, for
example.

>
> >
> > I think adding new members into core structures only for debugging
> > may not be a good choice, as it will bring troubles to downstream for
> > the backport because of kABI.
>
> The main point of this stuff, is to allow syzbot to simply turn on a
> few CONFIG options and let
> it discover past/new issues. No special sysctls magics.
I see, collecting data for syzbot, that's one thing I didn't know.

>
> I see you added introspection, to list all active references, I think
> this could be added on a per object
> basis, to help developers have ways to better understand the kernel behav=
ior.
Printing the =E2=80=98counting' results will save a lot of time to address =
the leaks.
Tracking multiple types at the same time will allow to address the problem
by reproducing the issue only once.

>
> Again, I think there is no reason your work can not complement mine.
> They serve different purposes.
Yep, this implementation is used more by developers to address known proble=
ms,
not by bot to look for new problems.

Thanks.
