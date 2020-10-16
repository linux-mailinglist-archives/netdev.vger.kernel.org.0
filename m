Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E672290CC4
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 22:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393589AbgJPUdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 16:33:07 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:39545 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393322AbgJPUdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 16:33:06 -0400
Received: by mail-io1-f70.google.com with SMTP id s135so2471948ios.6
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 13:33:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ROzsNmPEboimXBnltYvp0yZ0R4DqKoIDM5mz8ldG/wE=;
        b=jHoUofxaU8rMiujZSuHgaJVHFGte0Rzqo7W2eMNpk0aE4W+DaqmZmkGcLtzov7yFsh
         3e//7i1Ry2vyC9lnx2HsAxsMQh0DGoF+Ey+XBjRiwAVKbrIMdOGa3G/NH3f1DeF/y45y
         XnMGLiIwb+dC6NEc/xqviG0Kuz7qpglrYt1pTlACLu7gZkpLvOQr9DwNpQaL9f1DSwl2
         d58oAzdkIcx8CN6LJLjQS6Iu6I4sWWfqFARYsXOvv++2tAn44vR4z2eZusDYfOWXj8J+
         uHvnOMoQH2Nca8pcxHr9DZg/avj/lAcEOlgdFbaYUOS3a2yGw/fI4GX5ergm+U1ToWcO
         ZlFQ==
X-Gm-Message-State: AOAM532Q2mHTqYnkbc7iZDNVP0C59wcZ+vLaGShXUwyb/Bxqw5XoQ2fH
        27ylwcfjLi/S397cFJ4byGzWvu2i7TmXWsnuAb9jnfmkp+YI
X-Google-Smtp-Source: ABdhPJydD4gCS1GOdiO5MwakOGqV4ls4j0FZtILxVgGqBP7Uc/39/66TxdoYwmTOVK/z73ttFcN08POCtPfnQNumYnXoocxDU7jN
MIME-Version: 1.0
X-Received: by 2002:a5e:930d:: with SMTP id k13mr2094900iom.33.1602880385159;
 Fri, 16 Oct 2020 13:33:05 -0700 (PDT)
Date:   Fri, 16 Oct 2020 13:33:05 -0700
In-Reply-To: <000000000000e921b305b18ba0a7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f9990805b1cfab64@google.com>
Subject: Re: BUG: using __this_cpu_read() in preemptible code in trace_hardirqs_on
From:   syzbot <syzbot+53f8ce8bbc07924b6417@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 4d004099a668c41522242aa146a38cc4eb59cb1e
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Oct 2 09:04:21 2020 +0000

    lockdep: Fix lockdep recursion

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=174a766f900000
start commit:   9ff9b0d3 Merge tag 'net-next-5.10' of git://git.kernel.org..
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14ca766f900000
console output: https://syzkaller.appspot.com/x/log.txt?x=10ca766f900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d13c3fa80bc4bcc1
dashboard link: https://syzkaller.appspot.com/bug?extid=53f8ce8bbc07924b6417
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b63310500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1565657f900000

Reported-by: syzbot+53f8ce8bbc07924b6417@syzkaller.appspotmail.com
Fixes: 4d004099a668 ("lockdep: Fix lockdep recursion")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
