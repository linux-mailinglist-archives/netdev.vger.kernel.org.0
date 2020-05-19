Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4B81D9FAA
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgESSkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgESSkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 14:40:11 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C62C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 11:40:11 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id w4so674417oia.1
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 11:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XJcfG24o7bIyda12GOpq+kKishDdg+xGQYZytdoEctI=;
        b=velK/S7Ew+FS+QtJNdLim7lEMfNFWWZMTuNEFUKDUv5wNw2vpuy+6MWs4I2JNbbWdw
         +3jpXCh+bws1+JjUWRGZXHjFWV9iwSD0M7+5oKUW3eJg4J3IW8M3VaVDN8y6ZwqMlUkD
         qLo8jisBAhSgOqoAAsdN0JXpSGKONyGpH6eEpohaDYUDmHtNTK2tOujCZWlKYAc11rag
         oDM+209I2DHEm81aX33jS3naWWaJhQFy/3HrmzFRdV6XhAGrMc7WS68lETr0k0tMXWAl
         NI+dUnYWN2ApEl8DZ5uUleVEZvbCIEDtncw4LS93wbTulY+MQXsnjgNW3sNRN6lM7cMI
         fvfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XJcfG24o7bIyda12GOpq+kKishDdg+xGQYZytdoEctI=;
        b=Qjj96pZYCjEzPOzzpzi4k0tiRnpzXZUWhf5Z2WTSGLeT5uv/MXw0eUdVJgw0FJew1T
         YwQnGN6+mMZg9nQrQOQ7JhskCyS0Br6Zr6XtoqBUqrFsY70EtmqhZ59wPUX8USPYC5bJ
         lbY4wYftWNZ70nYOs6p9x/OgzF2o76Ih5Achoae6/3JpobwFD6COW/QTA8Mnv4eq3z+l
         PgHY9vDaFgcvJox3H4BtwMFXJlbOajbPrkvd/WPXLwptNZGHagUOp27q6Wh9iPnHwmfp
         CWfJ6Lh7av0mj0D6i2QMsqFzPHtVZmkz65I1bEt57Uv4HEGBqZzll3dkmE/8L0mXjngu
         OffQ==
X-Gm-Message-State: AOAM530lGCwbXffUghf2U0xsg3zWXtWN4Hmi5XvOo4eShQXNZ8EEu0qG
        FkTlTrbGcmcXFUaWiwObjBxd5l9s+JKS1d2GTkk=
X-Google-Smtp-Source: ABdhPJxX4M0aGmTOgJLlzN9Ee6PqIXFUjZhSMrsjuhR+6oGe8Vvx9Z6dlH5iqPLUo9shpDys/LAIqmGpqAyW4JdVhNM=
X-Received: by 2002:aca:c341:: with SMTP id t62mr603694oif.5.1589913610770;
 Tue, 19 May 2020 11:40:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200515114014.3135-1-vladbu@mellanox.com> <CAM_iQpXtqZ-Uy=x_UzTh0N0_LRYGp-bFKyOwTUMNLaiVs=7XKQ@mail.gmail.com>
 <vbf4ksdpwsu.fsf@mellanox.com> <CAM_iQpXdyFqBO=AkmLqVW=dZxQ3SfjKp71BxsKRuyhaoVuMEfg@mail.gmail.com>
 <vbfmu64b88m.fsf@mellanox.com>
In-Reply-To: <vbfmu64b88m.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 19 May 2020 11:39:59 -0700
Message-ID: <CAM_iQpU_BvK0Cgra+-_PUrpwkX3FyLDo6r3sz=phD-dTk278pQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump mode
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 2:10 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>
>
> On Mon 18 May 2020 at 21:46, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > On Sun, May 17, 2020 at 11:44 PM Vlad Buslov <vladbu@mellanox.com> wrote:
> >>
> >>
> >> On Sun 17 May 2020 at 22:13, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >> > On Fri, May 15, 2020 at 4:40 AM Vlad Buslov <vladbu@mellanox.com> wrote:
> >> >>
> >> >> Output rate of current upstream kernel TC filter dump implementation if
> >> >> relatively low (~100k rules/sec depending on configuration). This
> >> >> constraint impacts performance of software switch implementation that
> >> >> rely on TC for their datapath implementation and periodically call TC
> >> >> filter dump to update rules stats. Moreover, TC filter dump output a lot
> >> >> of static data that don't change during the filter lifecycle (filter
> >> >> key, specific action details, etc.) which constitutes significant
> >> >> portion of payload on resulting netlink packets and increases amount of
> >> >> syscalls necessary to dump all filters on particular Qdisc. In order to
> >> >> significantly improve filter dump rate this patch sets implement new
> >> >> mode of TC filter dump operation named "terse dump" mode. In this mode
> >> >> only parameters necessary to identify the filter (handle, action cookie,
> >> >> etc.) and data that can change during filter lifecycle (filter flags,
> >> >> action stats, etc.) are preserved in dump output while everything else
> >> >> is omitted.
> >> >>
> >> >> Userspace API is implemented using new TCA_DUMP_FLAGS tlv with only
> >> >> available flag value TCA_DUMP_FLAGS_TERSE. Internally, new API requires
> >> >> individual classifier support (new tcf_proto_ops->terse_dump()
> >> >> callback). Support for action terse dump is implemented in act API and
> >> >> don't require changing individual action implementations.
> >> >
> >> > Sorry for being late.
> >> >
> >> > Why terse dump needs a new ops if it only dumps a subset of the
> >> > regular dump? That is, why not just pass a boolean flag to regular
> >> > ->dump() implementation?
> >> >
> >> > I guess that might break user-space ABI? At least some netlink
> >> > attributes are not always dumped anyway, so it does not look like
> >> > a problem?
> >> >
> >> > Thanks.
> >>
> >> Hi Cong,
> >>
> >> I considered adding a flag to ->dump() callback but decided against it
> >> for following reasons:
> >>
> >> - It complicates fl_dump() code by adding additional conditionals. Not a
> >>   big problem but it seemed better for me to have a standalone callback
> >>   because with combined implementation it is even hard to deduce what
> >>   does terse dump actually output.
> >
> > This is not a problem, at least you can add a big if in fl_dump(),
> > something like:
> >
> > if (terse) {
> >   // do terse dump
> >   return 0;
> > }
> > // normal dump
>
> That is what I was trying to prevent with my implementation: having big
> "superfunctions" that implement multiple things with branching. Why not
> just have dedicated callbacks that do exactly one thing?

1. Saving one unnecessary ops.
2. Easier to trace the code: all dumpings are in one implementation.

>
> >
> >>
> >> - My initial implementation just called regular dump for classifiers
> >>   that don't support terse dump, but in internal review Jiri insisted
> >>   that cls API should fail if it can't satisfy user's request and having
> >>   dedicated callback allows implementation to return an error if
> >>   classifier doesn't define ->terse_dump(). With flag approach it would
> >>   be not trivial to determine if implementation actually uses the flag.
> >
> > Hmm? For those not support terse dump, we can just do:
> >
> > if (terse)
> >   return -EOPNOTSUPP;
> > // normal dump goes here
> >
> > You just have to pass 'terse' flag to all implementations and let them
> > to decide whether to support it or not.
>
> But why duplicate the same code to all existing cls dump implementations
> instead of having such check nicely implemented in cls API (via callback
> existence or a flag)?

I am confused, your fl_terse_dump() also has duplication with fl_dump()...

Thanks.
