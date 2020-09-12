Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C109267A8C
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 14:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgILM7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 08:59:21 -0400
Received: from mail-il1-f208.google.com ([209.85.166.208]:51520 "EHLO
        mail-il1-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgILM7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 08:59:08 -0400
Received: by mail-il1-f208.google.com with SMTP id i80so9140619ild.18
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 05:59:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=WYtWFHRSU717tB4AOlbQFrWP5bISa+QXam+Bz0rRjMY=;
        b=PtLI4nkvzgm4fYB7Bnh93eGvTi1Q5wOotPUUEVLlb3OxCExoOLL+IHGsvxA7rXChoh
         Jhk5+Cb6dKEnXIXNyKjJCOHzFblStzALfQZzUy6xBDFYCEyynGxDDXwyJbLYn7u8hFtS
         nYzM3e282FhAp9Z/cUaH30P/87Kcz39HeSTCcOvN1r4NFrfHYC5nUi2FCUucpsLCGP7+
         Incvrysorr3FGBUv3CUCnB3JFrezkTOiJYzlWCO5S23SEVhFZCFuCw0UiYY7V5YcERVs
         g31miZaHfxeXJnpV/GoVQY6fJF4gjvjBwAwyyiLeyCWxS3s8n7Z7WBniHyoh2jWIuMdp
         0DpA==
X-Gm-Message-State: AOAM531hxuaEbFBrofqpfxGhylc61FI7PGS6zAJ4WZ716v4ck+egjbNc
        Jsfasv//qCRRN6QEOHfd8Iq50e5b/OwIZ0yUph1FQaqOfOY6
X-Google-Smtp-Source: ABdhPJwLcoK9/BOVvUqW1qoKASa59qg2Z8rU3mVu/ovDZnFvptvji8E0w4KbtYZRK0MK1BCQIgrBtsl0DqKZRNCFZ2x3MA/XMcfx
MIME-Version: 1.0
X-Received: by 2002:a5d:995a:: with SMTP id v26mr5175295ios.176.1599915547769;
 Sat, 12 Sep 2020 05:59:07 -0700 (PDT)
Date:   Sat, 12 Sep 2020 05:59:07 -0700
In-Reply-To: <0000000000004991e705ac9d1a83@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e5419905af1d5d2b@google.com>
Subject: Re: inconsistent lock state in sco_conn_del
From:   syzbot <syzbot+65684128cd7c35bc66a1@syzkaller.appspotmail.com>
To:     cgroups@vger.kernel.org, davem@davemloft.net, hannes@cmpxchg.org,
        johan.hedberg@gmail.com, keescook@chromium.org, kennyyu@fb.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com,
        luto@amacapital.net, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tj@kernel.org, wad@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 135b8b37bd91cc82f83e98fca109b80375f5317e
Author: Kenny Yu <kennyyu@fb.com>
Date:   Tue Jun 21 18:04:36 2016 +0000

    cgroup: Add pids controller event when fork fails because of pid limit

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12f6d80d900000
start commit:   e8878ab8 Merge tag 'spi-fix-v5.9-rc4' of git://git.kernel...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11f6d80d900000
console output: https://syzkaller.appspot.com/x/log.txt?x=16f6d80d900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c61610091f4ca8c4
dashboard link: https://syzkaller.appspot.com/bug?extid=65684128cd7c35bc66a1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=121ef0fd900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c3a853900000

Reported-by: syzbot+65684128cd7c35bc66a1@syzkaller.appspotmail.com
Fixes: 135b8b37bd91 ("cgroup: Add pids controller event when fork fails because of pid limit")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
