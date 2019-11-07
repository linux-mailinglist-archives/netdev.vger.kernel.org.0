Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20875F3048
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389661AbfKGNoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:44:09 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:32797 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388681AbfKGNmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:42:06 -0500
Received: by mail-il1-f198.google.com with SMTP id z14so2675280ill.0
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:42:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=JSje/AH07oDcPbgdMNB1SmnapsrACftv+UWeFURGS+o=;
        b=GOHjPIISdNEW7tXxOHnoVpErgBQMaD6EvUFGnBcqQcGxyCq1bT8uTefZqd/EIn15Br
         W1Rcu0huL8K/O6ixpBGb+kAOAMQjiXZ0ts9sYwgglvScVvLpIaMTpMCTHWxfNqEKJFXT
         hCiN6ft7iC1bLHKt1NLBUmR5Nxayw7bwUyhvNMPxhb+B492wEDV+oy9jCmzoB2rCr7Q9
         1vHu6YJFrdh2uoH0/EHlubtcPxyF3VVomgP9l/LHWCj1I+EICajf26q1QV9RbHLNV/+i
         nFtr4a4jY7dDYkcvXtJ4KV+ihCGIw3ogDGasFcQ1JCEVUXdXFlrXzk0ILozy266TYg84
         /yUg==
X-Gm-Message-State: APjAAAVh4ottJdK/vqW5Rg0NBnQZmoI8t9K91qs2nwDi63zYQisERanq
        ebFShnz7wt4M8pUIHde1m8Z6HDKj8b74dVIfImYlky+cqw/I
X-Google-Smtp-Source: APXvYqxG4legBrqYPkWuqZIqpTsAoWCTwM+LFBpOJApTr736BPZhw6No/JLjYsmAogQRUvC2OoKv/gRcI5B3aQxGny7hDWkav0p7
MIME-Version: 1.0
X-Received: by 2002:a6b:6f09:: with SMTP id k9mr3513083ioc.91.1573134125408;
 Thu, 07 Nov 2019 05:42:05 -0800 (PST)
Date:   Thu, 07 Nov 2019 05:42:05 -0800
In-Reply-To: <000000000000afbebb0570be9bf3@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000baac070596c1d4ae@google.com>
Subject: Re: KASAN: use-after-free Read in p9_fd_poll
From:   syzbot <syzbot+0442e6e2f7e1e33b1037@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net,
        dominique.martinet@cea.fr, ericvh@gmail.com, jiangyiwen@huwei.com,
        linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, rminnich@sandia.gov,
        syzkaller-bugs@googlegroups.com, tomasbortoli@gmail.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 430ac66eb4c5b5c4eb846b78ebf65747510b30f1
Author: Tomas Bortoli <tomasbortoli@gmail.com>
Date:   Fri Jul 20 09:27:30 2018 +0000

     net/9p/trans_fd.c: fix race-condition by flushing workqueue before the  
kfree()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1646690c600000
start commit:   d72e90f3 Linux 4.18-rc6
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=68af3495408deac5
dashboard link: https://syzkaller.appspot.com/bug?extid=0442e6e2f7e1e33b1037
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1569b51c400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e7a978400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: net/9p/trans_fd.c: fix race-condition by flushing workqueue  
before the kfree()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
