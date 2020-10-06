Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49E7284BF8
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 14:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgJFMsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 08:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgJFMsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 08:48:36 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CAFC0613D3
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 05:48:35 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ds1so1496839pjb.5
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 05:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sQ1ZRFw1JVrb5mdbUnbQ1Xk6xyYpoV5fP4T8uAyz2hw=;
        b=UalqqU/Z4KF3vbZHbjIAfQig+pegJIOxqYiWL3gE2jPszs3jZTgNm72XNKp1ktSBl0
         P0DrPhYxjP92TkK+Tfx4UYVBfVvTOTHUbzfIpsmDtsGUQgPnAwTNyL0jhjDrXIjKmjwS
         25f+VrZAN7jHTdovX7Sm84YxtK/nCdB3vj14lNHA3QFSdyYd5XYXrRc9GhYmJOXaWCDW
         0l+as7z3dms6Lv2sT1SCz0TJqDJUfL8YrQBsu3pBXkmqTsom0EVy23LLx/xm+YEsDpOl
         Vx0HH0Dt104si2kx4f5kc+7p+JWCuVudnHX3f+XCG7amVwTzGlBGKAsNSQYgPCdevAq2
         Ve9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sQ1ZRFw1JVrb5mdbUnbQ1Xk6xyYpoV5fP4T8uAyz2hw=;
        b=O/6xr2Ad0EfesHrpRqBQB8ncKe/BvGw60XiOyvKic+G3A3GbVFgXmCKN0Kcigxhmyf
         CErshuBwMVTQCNzVRLIpvWyrknaHoIqkW3NxsM6bDM/1HT3yee89k7wCX6L3FxsVXQTP
         7qWdri5m9yDBjww4epZBTl/xWK8f3EiNiFFwtoAKneh1bKWL4wZjOKyt/3vB6Fltp7i1
         yhbZO4r9tXDuTSKA07TEkOZaywyZD2OWAFmu2J20+xODOfVGWg6UUUTlzku9wlfY0dcY
         SmLzwGldRqKI6pVnTAV5UHeZaDRx1Tsrva0qjqblEOYHBznr4FTjKZ61YOUWs8qON0qO
         y9EQ==
X-Gm-Message-State: AOAM5311bXefPhDb3XD3xCsu8iWmlJwQP4CqHLTHr/rOsjoT357sUoZd
        wWb5kDLptfVxku7hvR+So6rv/N0HBSFdz72wDp9KWA==
X-Google-Smtp-Source: ABdhPJxuTIkgeLojC1+VzV9TJd68luIqrRj+YDKPNYmX1CJV4VYlVmG35Q89ehXC3dXM9OFSlZ37iW033GsrkAVyMuI=
X-Received: by 2002:a17:90a:6043:: with SMTP id h3mr4137676pjm.41.1601988514966;
 Tue, 06 Oct 2020 05:48:34 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000004831d405b0fc41d2@google.com> <0b0de451147224657e5ac42d755c05447ee530b0.camel@suse.de>
In-Reply-To: <0b0de451147224657e5ac42d755c05447ee530b0.camel@suse.de>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Tue, 6 Oct 2020 14:48:23 +0200
Message-ID: <CAAeHK+xf6dxUcTyP_5+wJ0tZTXgn8TYcyxM9biomiPKSkf3e2g@mail.gmail.com>
Subject: Re: INFO: task hung in hub_port_init
To:     Oliver Neukum <oneukum@suse.de>
Cc:     syzbot <syzbot+74d6ef051d3d2eacf428@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        gustavoars@kernel.org, ingrassia@epigenesys.com,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        niklas.soderlund+renesas@ragnatech.se,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        sergei.shtylyov@cogentembedded.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 6, 2020 at 10:56 AM Oliver Neukum <oneukum@suse.de> wrote:
>
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152bb760500000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=172bb760500000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=132bb760500000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+74d6ef051d3d2eacf428@syzkaller.appspotmail.com
> > Fixes: 6dcf45e51497 ("sh_eth: use correct name for ECMR_MPDE bit")
> >
> > INFO: task kworker/0:0:5 blocked for more than 143 seconds.
> >       Not tainted 5.9.0-rc7-syzkaller #0
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > task:kworker/0:0     state:D stack:27664 pid:    5 ppid:     2 flags:0x00004000
> > Workqueue: usb_hub_wq hub_event
> > Call Trace:
> >  context_switch kernel/sched/core.c:3778 [inline]
> >  __schedule+0xec9/0x2280 kernel/sched/core.c:4527
> >  schedule+0xd0/0x2a0 kernel/sched/core.c:4602
>
> By this time urb_dequeue() has been killed and has returned.
>
> >  usb_kill_urb.part.0+0x197/0x220 drivers/usb/core/urb.c:696
> >  usb_kill_urb+0x7c/0x90 drivers/usb/core/urb.c:691
> >  usb_start_wait_urb+0x24a/0x2b0 drivers/usb/core/message.c:64
> >  usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
> >  usb_control_msg+0x31c/0x4a0 drivers/usb/core/message.c:153
> >  hub_port_init+0x11ae/0x2d80 drivers/usb/core/hub.c:4689
> >  hub_port_connect drivers/usb/core/hub.c:5140 [inline]
> >  hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
> >  port_event drivers/usb/core/hub.c:5494 [inline]
> >
>
> This looks like it should.
>
> Which HC driver are you using for these tests?

Hi Oliver,

This is the USB/IP one, based on what I see in the reproducer.

Thanks!

> It looks like
> the HCD is not acting on urb_dequeue(), rather than a locking
> issue.
