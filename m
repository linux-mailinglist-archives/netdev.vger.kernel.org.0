Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2616446C8D
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 00:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfFNWtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 18:49:42 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40316 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfFNWtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 18:49:42 -0400
Received: by mail-io1-f68.google.com with SMTP id n5so9156293ioc.7;
        Fri, 14 Jun 2019 15:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kbewMGFsf3NG5S/ececI7qiEzOBlHXSz9tPVMeP272g=;
        b=bqyaGulcLlNgacvRyHfISjHg6dWjzEmwltdTXycBch8Y4oCSdOq7s2nUHqFXYTwDoB
         uBqFbc1NnVFS/tR6NRwD/PK3suBu7MwY9MSTw2swwsSzd/1JlzBFhEF0p8pLBvy4z/sE
         BkCkDhTgj+3ozKLHavrVqE693cvR+6G2N+tRH34OhwRZEOZBirPbQzKlvYpTirrlHgSO
         IY2cpLcm27o2iOkem5Nba3n8acmyVTs2bAiiI5hPgwru2TvkM1jQU8dcPX7vwNnAsLs3
         JgtsN/pOH6GoA15YanxcmIPJNCPZy/GoX1gE4hDgE4hu2lLZriJfgb7MWu2nEis0ebak
         w/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kbewMGFsf3NG5S/ececI7qiEzOBlHXSz9tPVMeP272g=;
        b=hY7yNivUnzPnwvNvofxK7fMsxKxvsG+FrKZyYQGT//ZthGIsLgLuqhOdR9N8u5o6x4
         T1fAzjHFx4CJiIzSBTPkJJGcOC9tznNzP4NBM+7VlaDSppWLZOxYW5sgskURyOioS+2d
         cb4XMkYMNKwGkBcJpuOd04SW2ZdaZEFHBNF0hp2ApOid9KEI4qLMp97wpfJR6SoQK59w
         qKZuCpo42f93UDMmeSwcTfLfpwaQokM2RKa/g36YuBZqDY2HRJKYX0w0GEOE7B4lTewk
         YUbduI8MvQBc2bB+KUu0iCik06jhrRTBdUH0pYmdryNpYgJUGkvWm+pyLDuvGnJ9Kgkf
         nMnw==
X-Gm-Message-State: APjAAAUYLgSSyNh32kPa60oh3C5b1OLm9GnTvWg7UkglfK7Wppy7Oeno
        sk11i+pYYnEAGG1jKGrJ3US2hQB8CdDuRmik0pY=
X-Google-Smtp-Source: APXvYqyw/Wjh6jqw3bUrA9vCRsSyj5neH0Fmhh2WLqTNl1s+sdX+cP/PkTIzdmi31EiRVyXkM6kt/hswCisCgAX6XrY=
X-Received: by 2002:a5e:8618:: with SMTP id z24mr63324703ioj.174.1560552581128;
 Fri, 14 Jun 2019 15:49:41 -0700 (PDT)
MIME-Version: 1.0
References: <20180429104412.22445-1-christian.brauner@ubuntu.com> <20180429104412.22445-3-christian.brauner@ubuntu.com>
In-Reply-To: <20180429104412.22445-3-christian.brauner@ubuntu.com>
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Fri, 14 Jun 2019 15:49:30 -0700
Message-ID: <CAKdAkRTtffEQfZLnSW9CwzX_oYzHdOE816OvciGadqV7RHaV1Q@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2 v5] netns: restrict uevents
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
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

Hi Christian,

On Sun, Apr 29, 2018 at 3:45 AM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> commit 07e98962fa77 ("kobject: Send hotplug events in all network namespaces")
>abhishekbh@google.com
> enabled sending hotplug events into all network namespaces back in 2010.
> Over time the set of uevents that get sent into all network namespaces has
> shrunk. We have now reached the point where hotplug events for all devices
> that carry a namespace tag are filtered according to that namespace.
> Specifically, they are filtered whenever the namespace tag of the kobject
> does not match the namespace tag of the netlink socket.
> Currently, only network devices carry namespace tags (i.e. network
> namespace tags). Hence, uevents for network devices only show up in the
> network namespace such devices are created in or moved to.
>
> However, any uevent for a kobject that does not have a namespace tag
> associated with it will not be filtered and we will broadcast it into all
> network namespaces. This behavior stopped making sense when user namespaces
> were introduced.
>
> This patch simplifies and fixes couple of things:
> - Split codepath for sending uevents by kobject namespace tags:
>   1. Untagged kobjects - uevent_net_broadcast_untagged():
>      Untagged kobjects will be broadcast into all uevent sockets recorded
>      in uevent_sock_list, i.e. into all network namespacs owned by the
>      intial user namespace.
>   2. Tagged kobjects - uevent_net_broadcast_tagged():
>      Tagged kobjects will only be broadcast into the network namespace they
>      were tagged with.
>   Handling of tagged kobjects in 2. does not cause any semantic changes.
>   This is just splitting out the filtering logic that was handled by
>   kobj_bcast_filter() before.
>   Handling of untagged kobjects in 1. will cause a semantic change. The
>   reasons why this is needed and ok have been discussed in [1]. Here is a
>   short summary:
>   - Userspace ignores uevents from network namespaces that are not owned by
>     the intial user namespace:
>     Uevents are filtered by userspace in a user namespace because the
>     received uid != 0. Instead the uid associated with the event will be
>     65534 == "nobody" because the global root uid is not mapped.
>     This means we can safely and without introducing regressions modify the
>     kernel to not send uevents into all network namespaces whose owning
>     user namespace is not the initial user namespace because we know that
>     userspace will ignore the message because of the uid anyway.
>     I have a) verified that is is true for every udev implementation out
>     there b) that this behavior has been present in all udev
>     implementations from the very beginning.

Unfortunately udev is not the only consumer of uevents, for example on
Android there is healthd that also consumes uevents, and this
particular change broke Android running in a container on Chrome OS.
Can this be reverted? Or, if we want to keep this, how can containers
that use separate user namespace still listen to uevents?

Thanks.

-- 
Dmitry
