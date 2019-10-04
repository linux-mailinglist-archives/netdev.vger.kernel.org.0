Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 326E6CC025
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 18:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390241AbfJDQGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 12:06:23 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38427 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389835AbfJDQGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 12:06:23 -0400
Received: by mail-io1-f66.google.com with SMTP id u8so14696473iom.5
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 09:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=noYmtEiXp6Se+Ab7lb77YGdN8uGfMT5N3y35CjrKBZ8=;
        b=mpmeUlrhHxYKAL/NZ0GZfN8opFIpbyg/RgrVW3mcacTciD51x01AvhW3JwmCSkA75A
         DlvDikw58FGYGNFhOGjqbIFLqqwvGRiGd4m54o217eL+2pzqbFzhy11kRz/zDlc9YZrC
         Jh2tOBtotGX+ZAJBgx0QjDYDRs1IWMAqM7zvEg13XrAvpFgfhJpxMFb3ChIIFXWEj5q8
         OkHfOlzj+VVuZZsJrhpuOftwhQ1a5B/sTSB+VPyZz+o4cl2Ha/DomY7DvUOPrJS9Zff1
         WXPMHR6cvFmXcNjpcRDMa4Nj7jkLdL4BGYSi9vnqgkuVfS+8v7H9DwJXK/TKS3qGprZg
         kHEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=noYmtEiXp6Se+Ab7lb77YGdN8uGfMT5N3y35CjrKBZ8=;
        b=AkDjniFpR6va68/NTNSJZoXpAFYAo3XtkAhNNyN6/Jb9or8oZtrURO+QFroJltDWJX
         MINR45ffCXywq16Gmoeg0EIwJ2Wp2SJZT+BIOgL2ORQp0hQ4Zhu4m6GPy8e53K6NjDHM
         bY35neoX9Qm9LospAkJibe/Fud7NXwjg/c/QvENP4+fP7iKtQUs5BzCWFGr0102og6h3
         DyVonjxQE9n1yNjZ6ZVFiQj4fUX6a4s6rezLy+zIxjGNWbdniuOSG7OO7acEtEnFwy3l
         Ohse3Qt8AMZ9rFJfhi2NiaCRMku+BXNi5uRYH+L+ZiWZrDsUhBkYTfk6A96vk2LmPXOn
         +E9A==
X-Gm-Message-State: APjAAAXYBmdx0oKL7LRmfOZGBy0WLnK8dG9sfDPDsVOLO0RRasZgMHLx
        VesWQBRCPtKbLmJl8qo/hxOAif3v/Dpjl1nCdAvdUg==
X-Google-Smtp-Source: APXvYqyiz0c44+r3urDyi0t/DRxriIljvYpK7E9VcHzdoTwTSAgvEqg6MIuevQIMFSzHPKdrgXUoe4TbQjKwVLwe8go=
X-Received: by 2002:a92:b743:: with SMTP id c3mr16817830ilm.237.1570205181918;
 Fri, 04 Oct 2019 09:06:21 -0700 (PDT)
MIME-Version: 1.0
References: <1570058072-12004-1-git-send-email-john.hurley@netronome.com>
 <vbfk19lokwe.fsf@mellanox.com> <CAK+XE=mjARd+DodNg9Sn4C+gg6dMTmvdNrKtEYhsLGVqtGrysw@mail.gmail.com>
 <vbfimp5oig9.fsf@mellanox.com> <CAK+XE=nrzH8B=2GRcvmgOus67HSh_QXfBsawO_qicp8nSyZ_FA@mail.gmail.com>
 <vbf36g8jyeh.fsf@mellanox.com>
In-Reply-To: <vbf36g8jyeh.fsf@mellanox.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Fri, 4 Oct 2019 17:06:11 +0100
Message-ID: <CAK+XE==Bfc8V83F7FgtWG9+d+-99BAgAoTR3tSSDV=UHo5PtCA@mail.gmail.com>
Subject: Re: [RFC net-next 0/2] prevent sync issues with hw offload of flower
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 4:58 PM Vlad Buslov <vladbu@mellanox.com> wrote:
>
>
> On Fri 04 Oct 2019 at 18:39, John Hurley <john.hurley@netronome.com> wrote:
> > On Thu, Oct 3, 2019 at 6:19 PM Vlad Buslov <vladbu@mellanox.com> wrote:
> >>
> >>
> >> On Thu 03 Oct 2019 at 19:59, John Hurley <john.hurley@netronome.com> wrote:
> >> > On Thu, Oct 3, 2019 at 5:26 PM Vlad Buslov <vladbu@mellanox.com> wrote:
> >> >>
> >> >>
> >> >> On Thu 03 Oct 2019 at 02:14, John Hurley <john.hurley@netronome.com> wrote:
> >> >> > Hi,
> >> >> >
> >> >> > Putting this out an RFC built on net-next. It fixes some issues
> >> >> > discovered in testing when using the TC API of OvS to generate flower
> >> >> > rules and subsequently offloading them to HW. Rules seen contain the same
> >> >> > match fields or may be rule modifications run as a delete plus an add.
> >> >> > We're seeing race conditions whereby the rules present in kernel flower
> >> >> > are out of sync with those offloaded. Note that there are some issues
> >> >> > that will need fixed in the RFC before it becomes a patch such as
> >> >> > potential races between releasing locks and re-taking them. However, I'm
> >> >> > putting this out for comments or potential alternative solutions.
> >> >> >
> >> >> > The main cause of the races seem to be in the chain table of cls_api. If
> >> >> > a tcf_proto is destroyed then it is removed from its chain. If a new
> >> >> > filter is then added to the same chain with the same priority and protocol
> >> >> > a new tcf_proto will be created - this may happen before the first is
> >> >> > fully removed and the hw offload message sent to the driver. In cls_flower
> >> >> > this means that the fl_ht_insert_unique() function can pass as its
> >> >> > hashtable is associated with the tcf_proto. We are then in a position
> >> >> > where the 'delete' and the 'add' are in a race to get offloaded. We also
> >> >> > noticed that doing an offload add, then checking if a tcf_proto is
> >> >> > concurrently deleting, then remove the offload if it is, can extend the
> >> >> > out of order messages. Drivers do not expect to get duplicate rules.
> >> >> > However, the kernel TC datapath they are not duplicates so we can get out
> >> >> > of sync here.
> >> >> >
> >> >> > The RFC fixes this by adding a pre_destroy hook to cls_api that is called
> >> >> > when a tcf_proto is signaled to be destroyed but before it is removed from
> >> >> > its chain (which is essentially the lock for allowing duplicates in
> >> >> > flower). Flower then uses this new hook to send the hw delete messages
> >> >> > from tcf_proto destroys, preventing them racing with duplicate adds. It
> >> >> > also moves the check for 'deleting' to before the sending the hw add
> >> >> > message.
> >> >> >
> >> >> > John Hurley (2):
> >> >> >   net: sched: add tp_op for pre_destroy
> >> >> >   net: sched: fix tp destroy race conditions in flower
> >> >> >
> >> >> >  include/net/sch_generic.h |  3 +++
> >> >> >  net/sched/cls_api.c       | 29 ++++++++++++++++++++++++-
> >> >> >  net/sched/cls_flower.c    | 55 ++++++++++++++++++++++++++---------------------
> >> >> >  3 files changed, 61 insertions(+), 26 deletions(-)
> >> >>
> >> >> Hi John,
> >> >>
> >> >> Thanks for working on this!
> >> >>
> >> >> Are there any other sources for race conditions described in this
> >> >> letter? When you describe tcf_proto deletion you say "main cause" but
> >> >> don't provide any others. If tcf_proto is the only problematic part,
> >> >
> >> > Hi Vlad,
> >> > Thanks for the input.
> >> > The tcf_proto deletion was the cause from the tests we ran. That's not
> >> > to say there are not more I wasn't seeing in my analysis.
> >> >
> >> >> then it might be worth to look into alternative ways to force concurrent
> >> >> users to wait for proto deletion/destruction to be properly finished.
> >> >> Maybe having some table that maps chain id + prio to completion would be
> >> >> simpler approach? With such infra tcf_proto_create() can wait for
> >> >> previous proto with same prio and chain to be fully destroyed (including
> >> >> offloads) before creating a new one.
> >> >
> >> > I think a problem with this is that the chain removal functions call
> >> > tcf_proto_put() (which calls destroy when ref is 0) so, if other
> >> > concurrent processes (like a dump) have references to the tcf_proto
> >> > then we may not get the hw offload even by the time the chain deletion
> >> > function has finished. We would need to make sure this was tracked -
> >> > say after the tcf_proto_destroy function has completed.
> >> > How would you suggest doing the wait? With a replay flag as happens in
> >> > some other places?
> >> >
> >> > To me it seems the main problem is that the tcf_proto being in a chain
> >> > almost acts like the lock to prevent duplicates filters getting to the
> >> > driver. We need some mechanism to ensure a delete has made it to HW
> >> > before we release this 'lock'.
> >>
> >> Maybe something like:
> >
> > Ok, I'll need to give this more thought.
> > Initially it does sound like overkill.
> >
> >>
> >> 1. Extend block with hash table with key being chain id and prio
> >> combined and value is some structure that contains struct completion
> >> (completed in tcf_proto_destroy() where we sure that all rules were
> >> removed from hw) and a reference counter.
> >>
> >
> > Maybe it could live in each chain rather than block to be more fine grained?
> > Or would this potentially cause a similar issue on deletion of chains?
>
> IMO just having one per block is straightforward enough, unless there is
> a reason to make it per chain.
>
> >
> >> 2. When cls API wants to delete proto instance
> >> (tcf_chain_tp_delete_empty(), chain flush, etc.), new member is added to
> >> table from 1. with chain+prio of proto that is being deleted (atomically
> >> with detaching of proto from chain).
> >>
> >> 3. When inserting new proto, verify that there are no corresponding
> >> entry in hash table with same chain+prio. If there is, increment
> >> reference counter and wait for completion. Release reference counter
> >> when completed.
> >
> > How would the 'wait' work? Loop back via replay flag?
>
> What is "loop back via replay flag"?

Ok, bad description :)
I was referring the EAGAIN error returns used in other places post RTNL removal.
e.g. https://elixir.bootlin.com/linux/v5.4-rc1/source/net/sched/cls_flower.c#L1606

> Anyway, I was suggesting to use struct completion from completion.h,
> which has following functions in its API:
>

thanks for the pointer.

> /**
>  * wait_for_completion: - waits for completion of a task
>  * @x:  holds the state of this particular completion
>  *
>  * This waits to be signaled for completion of a specific task. It is NOT
>  * interruptible and there is no timeout.
>  *
>  * See also similar routines (i.e. wait_for_completion_timeout()) with timeout
>  * and interrupt capability. Also see complete().
>  */
> void __sched wait_for_completion(struct completion *x)
>
> /**
>  * complete_all: - signals all threads waiting on this completion
>  * @x:  holds the state of this particular completion
>  *
>  * This will wake up all threads waiting on this particular completion event.
>  *
>  * If this function wakes up a task, it executes a full memory barrier before
>  * accessing the task state.
>  *
>  * Since complete_all() sets the completion of @x permanently to done
>  * to allow multiple waiters to finish, a call to reinit_completion()
>  * must be used on @x if @x is to be used again. The code must make
>  * sure that all waiters have woken and finished before reinitializing
>  * @x. Also note that the function completion_done() can not be used
>  * to know if there are still waiters after complete_all() has been called.
>  */
> void complete_all(struct completion *x)
>
>
> > It feels a bit like we are adding a lot more complexity to this and
> > almost hacking something in to work around a (relatively) newly
> > introduced problem.
>
> I'm not insisting on any particular approach, just suggesting something
> which in my opinion is easier to implement than reshuffling locking in
> flower and directly targets the problem you described in cover letter -
> new filters can be inserted while concurrent destruction of tp with same
> chain id and prio is in progress.
>
> >
> >>
> >> >
> >> >>
> >> >> Regards,
> >> >> Vlad
