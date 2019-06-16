Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E9B475FB
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 18:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfFPQvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 12:51:09 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42839 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfFPQvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 12:51:09 -0400
Received: by mail-io1-f66.google.com with SMTP id u19so16163322ior.9;
        Sun, 16 Jun 2019 09:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w6TP4T8h79xYAM6vhz8nFJIILK3DXaaGMEt/QJTcPbQ=;
        b=H/Ap2zml9P/uhQ9c39FdZwPhUy5OJ3CFcICEXN5n08rwBlBq99GyUeVZ7/0qGWH62P
         FhJ9C/KcqugGiH63xv1HkOk+sAUJTZPes9svsENA+3eWs6zknLCo3+HSyxXCHDkHq+jz
         RBQ3aJYLoruRV39M8teyFeoWvDTYT5K/9Dr8rfbIF5DAgb7rzEVXFjmI7vgLTh5YMzys
         f3zyG4gynelNSwMsnzUU57d0purTb8z2WElm/Gwd/b30RAwutB8hVYzLFCJmd1dtbY4E
         C/6YSDpVP0d4aCKo+sA+TdhO1ctVrmTAzL3jc03bsCdFCr3jJkHsDwIryDRveJpq5sQh
         EoZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w6TP4T8h79xYAM6vhz8nFJIILK3DXaaGMEt/QJTcPbQ=;
        b=kobryh8jkBwWNzQg68+IDUINB1tJ2y75lZQiMS9WmzF18ZjINGen2EJwcayPWd0Nkn
         jiRvY5/w9ehV6374Xl9fSwppqoEDhCRRBxv87SYDG21BtxIdWAB7XZ4+t5YraYVo1WUU
         zxOxADcbG4KdqLkozooH3Rm0KTE11ZpJuitu6J6CYHl9FlIvMw7gBBitxBPvTLuKSh6n
         MJQH36zkc4VdMiGmY8BBhd4aPBFTqNoZcCQB46gVfBYjWUV4pbWEOdKTzT/N+qUcZhZT
         SfFaLIpHutJJXZLY4yow8f3LfFLhyUFtaauNHITIEGb/l6f7j0Lax75Q+kwWRQSyADDT
         EYTQ==
X-Gm-Message-State: APjAAAXAQuB7iP6dEMQI8F4eYgNI+wBkzixWXG5DEv49TV/2wt3ECqRc
        Nz3lBcdWmhDZHcgbjFovK7k7PMSX4QadNTDHrn54//7G
X-Google-Smtp-Source: APXvYqw6ovqPfWsKYMv5rJk8TEsX/+POsuRX7K9Rqq2vZ2NhVoFjpVCHooqGJDcaTUiNlbOehYe32FQsVFdLtkBHupQ=
X-Received: by 2002:a5e:8508:: with SMTP id i8mr7822782ioj.108.1560703867606;
 Sun, 16 Jun 2019 09:51:07 -0700 (PDT)
MIME-Version: 1.0
References: <20180429104412.22445-1-christian.brauner@ubuntu.com>
 <20180429104412.22445-3-christian.brauner@ubuntu.com> <CAKdAkRTtffEQfZLnSW9CwzX_oYzHdOE816OvciGadqV7RHaV1Q@mail.gmail.com>
 <875zp5rbpf.fsf@xmission.com>
In-Reply-To: <875zp5rbpf.fsf@xmission.com>
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Sun, 16 Jun 2019 09:50:57 -0700
Message-ID: <CAKdAkRRp49Qwz0CtNA6JsHdMe4Cw9tiD-ppXgqhZMBA23MzBgA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2 v5] netns: restrict uevents
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, avagin@virtuozzo.com,
        ktkhai@virtuozzo.com, "Serge E. Hallyn" <serge@hallyn.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Sun, Jun 16, 2019 at 4:50 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
>
> > Hi Christian,
> >
> > On Sun, Apr 29, 2018 at 3:45 AM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
> >>
> >> commit 07e98962fa77 ("kobject: Send hotplug events in all network namespaces")
> >>abhishekbh@google.com
> >> enabled sending hotplug events into all network namespaces back in 2010.
> >> Over time the set of uevents that get sent into all network namespaces has
> >> shrunk. We have now reached the point where hotplug events for all devices
> >> that carry a namespace tag are filtered according to that namespace.
> >> Specifically, they are filtered whenever the namespace tag of the kobject
> >> does not match the namespace tag of the netlink socket.
> >> Currently, only network devices carry namespace tags (i.e. network
> >> namespace tags). Hence, uevents for network devices only show up in the
> >> network namespace such devices are created in or moved to.
> >>
> >> However, any uevent for a kobject that does not have a namespace tag
> >> associated with it will not be filtered and we will broadcast it into all
> >> network namespaces. This behavior stopped making sense when user namespaces
> >> were introduced.
> >>
> >> This patch simplifies and fixes couple of things:
> >> - Split codepath for sending uevents by kobject namespace tags:
> >>   1. Untagged kobjects - uevent_net_broadcast_untagged():
> >>      Untagged kobjects will be broadcast into all uevent sockets recorded
> >>      in uevent_sock_list, i.e. into all network namespacs owned by the
> >>      intial user namespace.
> >>   2. Tagged kobjects - uevent_net_broadcast_tagged():
> >>      Tagged kobjects will only be broadcast into the network namespace they
> >>      were tagged with.
> >>   Handling of tagged kobjects in 2. does not cause any semantic changes.
> >>   This is just splitting out the filtering logic that was handled by
> >>   kobj_bcast_filter() before.
> >>   Handling of untagged kobjects in 1. will cause a semantic change. The
> >>   reasons why this is needed and ok have been discussed in [1]. Here is a
> >>   short summary:
> >>   - Userspace ignores uevents from network namespaces that are not owned by
> >>     the intial user namespace:
> >>     Uevents are filtered by userspace in a user namespace because the
> >>     received uid != 0. Instead the uid associated with the event will be
> >>     65534 == "nobody" because the global root uid is not mapped.
> >>     This means we can safely and without introducing regressions modify the
> >>     kernel to not send uevents into all network namespaces whose owning
> >>     user namespace is not the initial user namespace because we know that
> >>     userspace will ignore the message because of the uid anyway.
> >>     I have a) verified that is is true for every udev implementation out
> >>     there b) that this behavior has been present in all udev
> >>     implementations from the very beginning.
> >
> > Unfortunately udev is not the only consumer of uevents, for example on
> > Android there is healthd that also consumes uevents, and this
> > particular change broke Android running in a container on Chrome OS.
> > Can this be reverted? Or, if we want to keep this, how can containers
> > that use separate user namespace still listen to uevents?
>
> The code has been in the main tree for over a year so at a minimum
> reverting this has the real chance of causing a regression for
> folks like lxc.
>
> I don't think Android running in a container on Chrome OS was even
> available when this change was merged.  So I don't think this falls
> under the ordinary no regression rules.
>
> I may be wrong but I think this is a case of developing new code on an
> old kernel and developing a dependence on a bug that had already been
> fixed in newer kernels.

No, this is not quite the case. We have been shipping Android on
Chrome OS since 2016, the concept of running Android in a container
definitely predates these series of patches.

> I know Christian did his best to reach out to
> everyone when this change came through, so only getting a bug report
> over a year after the code was merged is concerning.

This only proves that it is hard to change userspace-visible behavior
as one can't really know who might be using the interfaces and for
what reason. Again, udev is not the only consumer of uevents; as fat
as I know Android does not use udev and there are other users of
uevents as well. For example, libusb can be compiled to listen to
uevents directly.

>
> That said uevents should be completely useless in a user namespace
> except as letting you know something happened.  Is that what healthd
> is using them for?

Yes, that is one of the use cases. Appearance of AC power supply can
be used to adjust system behavior, for example.

Thanks.

-- 
Dmitry
