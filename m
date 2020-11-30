Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D302C8BFC
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgK3SDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbgK3SDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:03:39 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1376CC0613D4
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 10:02:53 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id t37so10535324pga.7
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 10:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+KnM4rylz+5JwN8e2LD/Oqgwh76AHtfh1H1sva0UHVg=;
        b=u1KoQyd3tUhYzE94pnCh3hGRa3bI8yAM5cTH0eDsK5GMQopZ4S39Ca8DSIE8BJ0Q61
         s2xyzoLzu9y+LiBUAeCAsFO7gXiVtn9kCy9XpyS8S7S11ZsVn0Vr50tsh8WEiUJOzHkv
         hTmVmKKhRMjz0qp23axgJ9zFPV8RvCCAr9PFjWWdqLxhT4RehQxFcjXXDemSTt/gfquj
         hTVXSrcWjzFbmqpD7Te4GzF64ENcQD1ZKY/L1vilGSjobSFagqf54Sofn/EKBvJOFLbr
         qpwk8RujMTlQEihs0WM8mjLylAIkci8UxUomUwIAjRh4Ve5FL88LaGR4Hu4X9WmsYmcJ
         cJVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+KnM4rylz+5JwN8e2LD/Oqgwh76AHtfh1H1sva0UHVg=;
        b=gzQXbLVOp10CivxwEKMQcinQdm56zsp9PXAKKTzxnOk+oFGcpri8CgyV6kIfTWR7Vc
         UtgZSHUxP4o45GsbvQ8y1bIvuLbgyhCzzd2sJSiG17MhI4bzzj8CizAC4qh4PiOPclGT
         82pdWO0DWkdZ7CukzyTxBaKyH7+KUlqjOr5MD3BY3cUdAHIPe6VlBj2WiHChIXiM6eNs
         DJyS6lnX8YEpYvVaeUEhLCytya99M3JMMSRu/NSa4DKrg4l6aKbjGnd2jS0GswbCLa+5
         BW9lwS/aw1G6b/RK80B4DyJfxOujvveoMN3914TpbZ69duod47eANK2hwc8vNg7XKpdp
         CsaA==
X-Gm-Message-State: AOAM532qoVvpqVqNbhqBZjFIEorMqkPIEP2EdMU5e9YDB9qaDdvuumhQ
        3hD97QRrUnrpuUBxP9TTANImmKkklIiu1Ks3CT2vvA==
X-Google-Smtp-Source: ABdhPJy16oGd1bpoVV1qk31yKXrKAyRUPjykBfaOCbpMCZiyksP5brGc1PuMzuKMTYMnc/AYZnLzXah5RQTl0REqkc0=
X-Received: by 2002:a63:f1b:: with SMTP id e27mr8455904pgl.12.1606759372462;
 Mon, 30 Nov 2020 10:02:52 -0800 (PST)
MIME-Version: 1.0
References: <000000000000b8a70905b54ef5ca@google.com> <000000000000d0f2fb05b552b3f3@google.com>
In-Reply-To: <000000000000d0f2fb05b552b3f3@google.com>
From:   Axel Rasmussen <axelrasmussen@google.com>
Date:   Mon, 30 Nov 2020 10:02:16 -0800
Message-ID: <CAJHvVcgshQpsHc7LbT9rj4VPCc0bL7Y3c_tGE0c5mUP5Q+8JjA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Write in kernfs_path_from_node_locked
To:     syzbot <syzbot+19e6dd9943972fa1c58a@syzkaller.appspotmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, dsahern@kernel.org,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, liuhangbin@gmail.com,
        netdev@vger.kernel.org, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com, tj@kernel.org,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I spent some time looking into this:

I think there are actually two bugs here. The write-after-free in
kernfs_path_from_node_locked has an entirely different call trace
(towards the end of this log:
https://syzkaller.appspot.com/text?tag=CrashLog&x=16b1e0e9500000)
compared to the NULL pointer dereference in neigh_periodic_work crash.

For the neigh_periodic_work crash, I struggle to see how this is
related to 0f818c4bc1. It looks like what happens is at some point (I
haven't spotted where) we free struct neighbour->lock, and then later
when the workqueue calls into us we try to acquire it. I don't see any
connection between this code and 0f818c4bc1. The lock in question
isn't mmap_lock, but rather a separate lock owned by the struct
neighbour.



For the kernfs_path_from_node_locked crash, that one *does* look
related to 0f818c4bc1. I'll continue debugging and send a patch.

On Mon, Nov 30, 2020 at 5:08 AM syzbot
<syzbot+19e6dd9943972fa1c58a@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this issue to:
>
> commit 0f818c4bc1f3dc0d6d0ea916e0ab30cf5e75f4c0
> Author: Axel Rasmussen <axelrasmussen@google.com>
> Date:   Tue Nov 24 05:37:42 2020 +0000
>
>     mm: mmap_lock: add tracepoints around lock acquisition
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1626291d500000
> start commit:   6174f052 Add linux-next specific files for 20201127
> git tree:       linux-next
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1526291d500000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1126291d500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=79c69cf2521bef9c
> dashboard link: https://syzkaller.appspot.com/bug?extid=19e6dd9943972fa1c58a
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c3351d500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14c28809500000
>
> Reported-by: syzbot+19e6dd9943972fa1c58a@syzkaller.appspotmail.com
> Fixes: 0f818c4bc1f3 ("mm: mmap_lock: add tracepoints around lock acquisition")
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
