Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A598946C289
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 19:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbhLGSVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 13:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbhLGSVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 13:21:13 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF927C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 10:17:42 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id n17-20020a9d64d1000000b00579cf677301so19141778otl.8
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 10:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=goWJzo72h9TSpuyvB/8iyuCpoF68ya6syYVsWpB80wQ=;
        b=Z57GYRmBvIHCEd7tIUWqOIww3vXYd4p8BIyZp8lnA6V6bEoziceDCeZgCIjsyj08wO
         R9guwSHPcB4jrzGYeHdeLe4dUs2TRtaTO63ienoY9tN4XdsapZd2yLo1YebxF/3fOIHN
         kG+TJJ/0jo/11HKiCAkYZQXYo7P2fZJ1+P31dAqpiJ9np3QPJ7CGbU5/SqbzZeF8Pl5Y
         y02aXBKbxGL9/QqW9jM+dN4WLAxIEd0oH//pmzVb6NPkXpJTfvKz4+fS9fqD4o59ddyY
         sUMFH0kQXPi5za58IpGUzOenra/E/OU47HtzXj6rZvpm8ni64ixngOLj6wQVuYe+1bNS
         +dJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=goWJzo72h9TSpuyvB/8iyuCpoF68ya6syYVsWpB80wQ=;
        b=GLtS7hKRVJKH5iEPGVJWYzXZ194ekD01EOL/MDWM4AgFpldBJpn7uRjoxy3oASji3U
         O8xBLMtLJfv0i15B3Th1z9Ee91QEPmVdCd3DgfMJA0hYedJDPCDmyEAsG0IvcdsF6Cjb
         U07QYeOQ+Hbxgp65S+b5vjbS9TDevkxejjUz782h4T7wnGlUDj8G1pcl0O/uSlkr2ZMx
         sCGLCRtgiNgKPyeqA6mYq1q7OczE5wiWDRAsserP3NKEhXby8oZBe51zEdaG+1PdfNsl
         l7hq43rRFl5Ct6qZOMxKhXpjJnP0Urx3pDVJg3Vxi4PcaI7a8yL+fLLI5OGz7EbNNl1m
         9Btg==
X-Gm-Message-State: AOAM530j6BTjSshXKnV2QjZM1FSE8EvR7EQOh/KtnVNIM3CBAlfWMK2/
        fFXHEt/LjGtYb4Q9T8/F/1ArKUavY4/+P+O+1tU=
X-Google-Smtp-Source: ABdhPJwlVf9QnEx3AI71YJEReube1FRAf7wGmVgVWtMBowq5fgVWEXSUtqRcZVtcVPNLRPNItUni/FvzybhW4OlnZZ0=
X-Received: by 2002:a9d:2ae:: with SMTP id 43mr38484194otl.289.1638901062120;
 Tue, 07 Dec 2021 10:17:42 -0800 (PST)
MIME-Version: 1.0
References: <cover.1638849511.git.lucien.xin@gmail.com> <CANn89iJyiDbGdvm-oNKBBk5r3-0+3h+3ui1pL3rOTrz2BOztmA@mail.gmail.com>
In-Reply-To: <CANn89iJyiDbGdvm-oNKBBk5r3-0+3h+3ui1pL3rOTrz2BOztmA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 7 Dec 2021 13:17:31 -0500
Message-ID: <CADvbK_c-SpsVDgOgUO2YqcT3qS4c9BL=qHYnrEgp2S3tqvR-Zw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] net: add refcnt tracking for some common objects
To:     Eric Dumazet <edumazet@google.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 11:41 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Dec 6, 2021 at 8:02 PM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > This patchset provides a simple lib(obj_cnt) to count the operatings on any
> > objects, and saves them into a gobal hashtable. Each node in this hashtable
> > can be identified with a calltrace and an object pointer. A calltrace could
> > be a function called from somewhere, like dev_hold() called by:
> >
> >     inetdev_init+0xff/0x1c0
> >     inetdev_event+0x4b7/0x600
> >     raw_notifier_call_chain+0x41/0x50
> >     register_netdevice+0x481/0x580
> >
> > and an object pointer would be the dev that this function is accessing:
> >
> >     dev_hold(dev).
> >
> > When this call comes to this object, a node including calltrace + object +
> > counter will be created if it doesn't exist, and the counter in this node
> > will increment if it already exists. Pretty simple.
> >
> > So naturally this lib can be used to track the refcnt of any objects, all
> > it has to do is put obj_cnt_track() to the place where this object is
> > held or put. It will count how many times this call has operated this
> > object after checking if this object and this type(hold/put) accessing
> > are being tracked.
> >
> > After the 1st lib patch, the other patches add the refcnt tracking for
> > netdev, dst, in6_dev and xfrm_state, and each has example how to use
> > in the changelog. The common use is:
> >
> >     # sysctl -w obj_cnt.control="clear" # clear the old result
> >
> >     # sysctl -w obj_cnt.type=0x1     # track type 0x1 operating
> >     # sysctl -w obj_cnt.name=test    # match name == test or
> >     # sysctl -w obj_cnt.index=1      # match index == 1
> >     # sysctl -w obj_cnt.nr_entries=4 # save 4 frames' calltrace
> >
> >     ... (reproduce the issue)
> >
> >     # sysctl -w obj_cnt.control="scan"  # print the new result
> >
> > Note that after seeing Eric's another patchset for refcnt tracking I
> > decided to post this patchset. As in this implemenation, it has some
> > benefits which I think worth sharing:
> >
>
> How can your code coexist with ref_tracker ?
Hi, Eric, Thanks for your checking

It won't affect ref_tracker, one can even use both at the same time.

>
> >   - it runs fast:
> >     1. it doesn't create nodes for the repeatitive calls to the same
> >        objects, and it saves memory and time.
> >     2. the depth of the calltrace to record is configurable, at most
> >        time small calltrace also saves memory and time, but will not
> >        affect the analysis.
> >     3. kmem_cache used also contributes to the performance.
>
> Points 2/3 can be implemented right away in the ref_tracker infra,
> please send patches.
>
> Quite frankly using a global hash table seems wrong, stack_depot
> already has this logic, why reimplement it ?
> stack_depot is damn fast (no spinlock in fast path)
What this patchset is trying to add is a calltrace+object counter.
I was looking at stack_depot after seeing you patch, stack_depot saves
calltrace only, no object(I guess this is okay, I can save object to
to entries[0] if I want to use it), but also it's not a counter.

I'm not sure if it's allowed to do some change and add a counter to
the node of stack_depot, like when it's found in saving, the counter
increments. That will be perfect for this patchset.

This global spinlock will eventually be used only to protect the new
node's insertion. For the fast path (lookup), rcu_read_lock() will take
care of it. I haven't got time to add it. but this won't be a problem.

>
> Seeing that your patches add chunks in lib/obj_cnt.c, I do not see how
> you can claim this is generic code.
I planned it as a obj operating counter, it can be used for counting any
operatings, not just for the refcnt tracker which is only _put and _hold
operatings.

>
> I don't know, it seems very strange to send this patch series now I
> have done about 60 patches on these issues.
This patch is not to do exactly the same things as your patchset, I think your
patch saves more information into the objects in the kernel memory, it will
be useful for vmcore analysis.

This patchset is working in a different way, it's going to target a
specific object with index or name or pointer matched and some types
of function calls to it, we have to plan in advance after we know
which object (like it's name, index or string to match) is leaked.

>
> And by doing this work, I found already two bugs in our stack.
Great effects!
I can see that you must go over all networking stack for dev operations.

>
> You can be sure syzbot will send us many reports, most syzbot repros
> use a very limited number of objects.
>
> About performance : You use a single spinlock to protect your hash table.
> In my implementation, there is a spinlock per 'directory (eg one
> spinlock per struct net_device, one spinlock per struct net), it is
> more scalable.
I used per net spinlock at first, but I want to make the code more generic,
and not only for the network, then I decided to make it not related to net.

After using rcu_lock in the fast path, I think this single spinlock won't
affect much, besides, this single lock can be replaced by a per hlist lock
on each hlist_head, it will also save some.

>
> My tests have not shown a significant cost of the ref_tracker
> (the major cost comes from stack_trace_save() which you also use)
I added "run fast" in cover, mostly because it won't create many nodes
if dev_hold/put are called many times, it only increments the count if it's
the same call to the same object already existing in the hashtable.

dev could be fine, thinking about tracking dst, when sending packets, dst
can be hold/put too many times, creating nodes for each call is not a good
idea, especially for some leak only occurs once for few months which I've
seen quite a few times in our customer envs.


Other things are:
most net_dev leaks I've met are actually dst leak, some are in6_dev leak,
only tracking net_dev is not enough to address it, do you have plans to
add dst track for dst too? That may be a lot of changes too?

I think adding new members into core structures only for debugging
may not be a good choice, as it will bring troubles to downstream for
the backport because of kABI.

Thanks.
