Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9904D2F68D8
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbhANSEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbhANSEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 13:04:31 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56612C061574
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 10:03:51 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id b8so3292811plh.12
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 10:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xLko1VslmKMnXW6fSlw0gc3iSegVp2kttH77MiFr1as=;
        b=ub422Xr+ZYJRsQ2H67pFMJEweQ8oqsnOhJT2maa7xhGM7/oPnffQ2GDpCo9+YLANU9
         v1dZPQgH8jilMJaeiaD+PSdhlGFa/iNBrDt1DEdLd5KW7JN2Y9CA+o27l5LChDSR6zgV
         tSoyREYs2zyC4fuG04GxJ8qpfXidanisbI3LPpMUsFx/15U7wHKP+LVdeWwhfyYPvXL1
         QBNGRw7Kfr/AQKCgHu1otCQ5jY+o950tZd1nEdFDRzRFbXhUBRDrKVM71NcjPRKMrke1
         PSj4hMIRFYI9gMuP9wZIfAd+mej6vZd12B0GLpO6UG1a4rKk0RbAN3/kzGEXUEM09KTV
         j+vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xLko1VslmKMnXW6fSlw0gc3iSegVp2kttH77MiFr1as=;
        b=r8XSWwCjpULjZyB6B7lIhLaPK5QhWnKMXrwCL/g447m+JmyJ0ktqDnebZ52A1+7cEa
         7T1MnkNGHfkxB/zDmJ3V6pfCAPT8e8b+vJ7gZU/ISQCvNCvLvlxipPMtF/i9RYceFl4I
         fCznAHuavGxK8npqICth0MupT9McTTnbK10EHe4caalNP1E3GOB/ENBCqk0kUPnlefMB
         z4/sXlVdSksdn/IP6CWfoDYs7ttSnFlbe2P/dVlKpbHmyzV5DSEv6Y6oIq7Q0WQpL1Yj
         8R82iGAJ8Jg7dho0c6t1oQJP5M3SNRKhxYh55xVvDS8r1XjUtaPPeEPI2up4b75g70Ne
         Ut4w==
X-Gm-Message-State: AOAM530kmdSazBQbj513S7V3GB72FfWOwS6if1Qxq4CeEFPehWN67LzB
        lHn1K3WMHtFuYTeuORBTe54WgKwD9Nd/+Li/mys=
X-Google-Smtp-Source: ABdhPJwbdQtXL0Z+ehOuYcQctddxQNBjYxHB80WhVuDyTUN/OBOqt1OCd42shHjZl9r4j6kfY7iLazlej/nuPQvsyqs=
X-Received: by 2002:a17:902:7242:b029:db:d1ae:46bb with SMTP id
 c2-20020a1709027242b02900dbd1ae46bbmr8462929pll.77.1610647430860; Thu, 14 Jan
 2021 10:03:50 -0800 (PST)
MIME-Version: 1.0
References: <20210114160637.1660597-1-eric.dumazet@gmail.com>
In-Reply-To: <20210114160637.1660597-1-eric.dumazet@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 14 Jan 2021 10:03:39 -0800
Message-ID: <CAM_iQpVspkx5Sao8DxFiJFV0Y80J1RdTSevSbzQ9FuZ-xTVbbg@mail.gmail.com>
Subject: Re: [PATCH net] net_sched: reject silly cell_log in qdisc_get_rtab()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 8:06 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> iproute2 probably never goes beyond 8 for the cell exponent,
> but stick to the max shift exponent for signed 32bit.
>
> UBSAN reported:
> UBSAN: shift-out-of-bounds in net/sched/sch_api.c:389:22
> shift exponent 130 is too large for 32-bit type 'int'
> CPU: 1 PID: 8450 Comm: syz-executor586 Not tainted 5.11.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x183/0x22e lib/dump_stack.c:120
>  ubsan_epilogue lib/ubsan.c:148 [inline]
>  __ubsan_handle_shift_out_of_bounds+0x432/0x4d0 lib/ubsan.c:395
>  __detect_linklayer+0x2a9/0x330 net/sched/sch_api.c:389
>  qdisc_get_rtab+0x2b5/0x410 net/sched/sch_api.c:435
>  cbq_init+0x28f/0x12c0 net/sched/sch_cbq.c:1180
>  qdisc_create+0x801/0x1470 net/sched/sch_api.c:1246
>  tc_modify_qdisc+0x9e3/0x1fc0 net/sched/sch_api.c:1662
>  rtnetlink_rcv_msg+0xb1d/0xe60 net/core/rtnetlink.c:5564
>  netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2494
>  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>  netlink_unicast+0x7de/0x9b0 net/netlink/af_netlink.c:1330
>  netlink_sendmsg+0xaa6/0xe90 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg net/socket.c:672 [inline]
>  ____sys_sendmsg+0x5a2/0x900 net/socket.c:2345
>  ___sys_sendmsg net/socket.c:2399 [inline]
>  __sys_sendmsg+0x319/0x400 net/socket.c:2432
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Acked-by: Cong Wang <cong.wang@bytedance.com>

Thanks.
