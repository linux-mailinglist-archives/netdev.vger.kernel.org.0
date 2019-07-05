Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F064D6068C
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 15:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbfGENYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 09:24:39 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42942 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbfGENYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 09:24:38 -0400
Received: by mail-io1-f68.google.com with SMTP id u19so19082102ior.9
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 06:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=wP9NlDr6bD2aoiL7N4bfYIJ/HvdrRGHcleGNGuB8Lwo=;
        b=nBNukwLBUd5AQhriWQmUXLkxZbfqi6PZ4W3zlMZkZG/1YOHx7j4znzzYNMVhLCYk3A
         ud+0nMr53C/I3MkH4eic+fx740oYIWYW6lTwugV//iXUd3Ftl+NpHzT5RXoO1K00AzUR
         3L5mbruThN+Et7gXXFdd7ATCYHy21DXF3WDwfdPqym8yPbidBs8jZcRWOKpEIc1QOQLv
         4oU69IY5aobjQEhkFK/TyPgGhI/cfHQV81VEB4tdyGynxlEdomG068JRJwm6sPjlo5zJ
         NUnp0H1Z5IhnPiEfC168MlrWYaXg3sTEOXtTCrW6Ad7qT56KRyucMW+6lY17LEFmOA9V
         Srkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=wP9NlDr6bD2aoiL7N4bfYIJ/HvdrRGHcleGNGuB8Lwo=;
        b=hCbK0TDc+d6mNjVxUFJiMczYdbYODJstOJtftGWvF2ZGkmuleBWto+HPMRkDFqwUHW
         r2OXxHxjIvCJC5P9F3XeVk7bOmsYFFcTrw3ecIZT8iITDk8YhbONNLRlls0Dnis2++8D
         HNvp+56jMbYxGivHUu0UE8rOni4hykDnMMVVJC8MOMm/iB1Y92buYndT7YlJUrSXJ8vy
         4LuuBp92NPzssv41t5YFjWQKZnn29yhvniG3FA1pLK4umGpHMjc7DmYFqm2U7t35sygi
         Tdd+oJvxsFkP2gf6mlNu4nKAMDwMsETDoRfA6tmsqX0SZHmhy5vBHFcc06ZN96HBeIk/
         gwMA==
X-Gm-Message-State: APjAAAWO3dYUv1x1R0+6IsB906suz0rPrf9jT4sDiMDB9sevgfOXA2CE
        3ALeatbFBp0uxxk4yRK1Flsj3DtoiUgu6owYFd6wxA==
X-Google-Smtp-Source: APXvYqwOfWMpuGkg9RKdi1dW9m3N/UTu38SQFu4df6Dl5WRhRKX6+Q2277z0Av7zSHTMO8XgkKHfaRS0fHak0CXooIs=
X-Received: by 2002:a5d:80d6:: with SMTP id h22mr4158590ior.231.1562333077745;
 Fri, 05 Jul 2019 06:24:37 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d3f34b058c3d5a4f@google.com> <20190626184251.GE3116@mit.edu>
 <20190626210351.GF3116@mit.edu> <20190626224709.GH3116@mit.edu>
In-Reply-To: <20190626224709.GH3116@mit.edu>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 5 Jul 2019 15:24:26 +0200
Message-ID: <CACT4Y+YTpUErjEmjrqki-tJ0Lyx0c53MQDGVS4CixfmcAnuY=A@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in ext4_write_checks
To:     "Theodore Ts'o" <tytso@mit.edu>,
        syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        David Miller <davem@davemloft.net>, eladr@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 12:47 AM Theodore Ts'o <tytso@mit.edu> wrote:
>
> More details about what is going on.  First, it requires root, because
> one of that is required is using sched_setattr (which is enough to
> shoot yourself in the foot):
>
> sched_setattr(0, {size=0, sched_policy=0x6 /* SCHED_??? */, sched_flags=0, sched_nice=0, sched_priority=0, sched_runtime=2251799813724439, sched_deadline=4611686018427453437, sched_period=0}, 0) = 0
>
> This is setting the scheduler policy to be SCHED_DEADLINE, with a
> runtime parameter of 2251799.813724439 seconds (or 26 days) and a
> deadline of 4611686018.427453437 seconds (or 146 *years*).  This means
> a particular kernel thread can run for up to 26 **days** before it is
> scheduled away, and if a kernel reads gets woken up or sent a signal,
> no worries, it will wake up roughly seven times the interval that Rip
> Van Winkle spent snoozing in a cave in the Catskill Mountains (in
> Washington Irving's short story).
>
> We then kick off a half-dozen threads all running:
>
>    sendfile(fd, fd, &pos, 0x8080fffffffe);
>
> (and since count is a ridiculously large number, this gets cut down to):
>
>    sendfile(fd, fd, &pos, 2147479552);
>
> Is it any wonder that we are seeing RCU stalls?   :-)

+Peter, Ingo for sched_setattr and +Paul for rcu

First of all: is it a semi-intended result of a root (CAP_SYS_NICE)
doing local DoS abusing sched_setattr? It would perfectly reasonable
to starve other processes, but I am not sure about rcu. In the end the
high prio process can use rcu itself, and then it will simply blow
system memory by stalling rcu. So it seems that rcu stalls should not
happen as a result of weird sched_setattr values. If that is the case,
what needs to be fixed? sched_setattr? rcu? sendfile?

If this is semi-intended, the only option I see is to disable
something in syzkaller: sched_setattr entirely, or drop CAP_SYS_NICE,
or ...? Any preference either way?
