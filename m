Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72842AEF8C
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgKKLZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgKKLZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:25:10 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B41BC0613D4
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 03:25:10 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id q5so1231762qkc.12
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 03:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LDZJ0O4Or9c4Ic9XAc5v+5LPGzEs+GV/vIBqZTGLe2I=;
        b=iOIgzSjf1dX0V/DuEkKlSF4UWiqargaVppze8CPvJB8yssfzYaHqvgV4J8s5E0AwSa
         YVvIt7pEjccE9EyAW2cGPjjdAuqTJoj7WbpxvZGLgGn0LO7V5LIIkKqcqHhlU9YbndRs
         PAbGq1p1j/2gfiLSdbwsNcAhHGel8+ljihnB9DP4wzDiNtRjy3+SCl8/mtpQsMVpwIkE
         kO+Fe+pIYKK3KsLG6fQh/yDobgTUwJ7XVFuUyz/eghGACNgwX3q/vdxFPfUyrCbVEbJz
         po6QUScmMhKBZpMTM+9a0xDqdfnBrXkX2uQ6oyf/FXS2fw33bpnJ+6L0BUQAvTZUuirZ
         anXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LDZJ0O4Or9c4Ic9XAc5v+5LPGzEs+GV/vIBqZTGLe2I=;
        b=r0Q/vav2dTiih9qsrXJpMi5UpjDNI1Gr1jb9jNgc8xv9uB6JqTY0KzdoCqViseyXwe
         sn1nxyYQKhXgMChPPw/+4cv2fIT/tx/1zI5+3YVWOvMnX4UahVUx7tqjfUvTjqagjfbW
         3ngrdjsMazF9s9RV8UBw2GC10wS3HwoJbkGwHwlx5VK/SMEe2PAbTOy2qkcazIskSXFa
         09hjQTiMAJi8d2hSREP0lfJrr23uZqPynC/g9MjNZj0VnXFgJkEnmxmNJ0M6ujr6EjvN
         9I9Ga6Lf9do4TmmExuq63XlecFX/cE5KOIYCOU2ispEm2EMMiQ8FxlQKJnKetH8kFf1C
         Swgg==
X-Gm-Message-State: AOAM531B7J85LIr+j4QKf51+lsAX512ikKfvMJnZPrAI28YBSDzyGHzD
        HbV9D4FOk6tm1mJWo/DaOb8H40GQyDEcUXquU2OMHg==
X-Google-Smtp-Source: ABdhPJz8UBi7HBWqBoE6lpC88oE0isKBf09kUhCwWghkAawDbNGWpyMY4xalAZ086OFk8Rpa30NhBSBp7WqlMgb0Vx0=
X-Received: by 2002:a37:7b44:: with SMTP id w65mr24979425qkc.350.1605093909079;
 Wed, 11 Nov 2020 03:25:09 -0800 (PST)
MIME-Version: 1.0
References: <00000000000039638605a991eca7@google.com> <000000000000ce496c05ac2d0857@google.com>
In-Reply-To: <000000000000ce496c05ac2d0857@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 11 Nov 2020 12:24:58 +0100
Message-ID: <CACT4Y+bgt+s5y3ieEWN_j0wnvVqj5m9oxWwuxsX-waxNU3WtiA@mail.gmail.com>
Subject: Re: WARNING in rxrpc_recvmsg
To:     syzbot <syzbot+1a68d5c4e74edea44294@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        marc.dionne@auristor.com, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 5:25 AM syzbot
<syzbot+1a68d5c4e74edea44294@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 65550098c1c4db528400c73acf3e46bfa78d9264
> Author: David Howells <dhowells@redhat.com>
> Date:   Tue Jul 28 23:03:56 2020 +0000
>
>     rxrpc: Fix race between recvmsg and sendmsg on immediate call failure
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10bd3bcc900000
> start commit:   7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7be693511b29b338
> dashboard link: https://syzkaller.appspot.com/bug?extid=1a68d5c4e74edea44294
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a5022f100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=150932a7100000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: rxrpc: Fix race between recvmsg and sendmsg on immediate call failure
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: rxrpc: Fix race between recvmsg and sendmsg on immediate call failure
