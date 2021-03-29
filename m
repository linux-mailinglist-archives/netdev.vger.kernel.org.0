Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCC034CEF0
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 13:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhC2L2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 07:28:11 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:44315 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbhC2L2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 07:28:06 -0400
Received: by mail-il1-f200.google.com with SMTP id j18so11563852ila.11
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 04:28:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=rQvHuQoW7fvtp2Ftp9kpJnXrU1a0vQLohh1FTEc0jDU=;
        b=jXhQaUh7X5yl/j9jAQvaHki6wwoQJuKO71rPz4k47xIa+KVPFRHnz/LrFsWX/c5tQb
         gqr8bGLJw4dG3mQ/6zWx5fhfms12NFQFBIQS/LTWYv/VHKfDEbvp/8op3752Y9PwVvrA
         Uilpl5LAWWqtBiODnECEzjUgj4ukxFOwN4HonnwsReSBSPBippxuMwZ8hzXRZor1h/Mm
         IVWUpTSfg2O+RE6MeGOxaVUd+Fm8rOsx+TgfqC56pSG2mQWnlKtJOdy8Xfdmd4IeTpOK
         SQXW0T+tGrkSejjSBLQ4g9mJrOBc37U2RWYZGcm5YQrbzk9HlLCc+IG87iYLYJYQG/lb
         CVxQ==
X-Gm-Message-State: AOAM532QM0VwKHjy1hY8wlxTSwMpQ4BAWEknF9IXM8t1W0TY3x/mK+/V
        uRGnGwLmKzTNI1Qlrduh0cUcMpayEwTyBbYaKSGBZ8nsdNE0
X-Google-Smtp-Source: ABdhPJyVGPg1iqr/7NbcMuFQoOzNXIrVaBElCoeGpE0yyT3Q1rRFN8O0BxysKrgcUI8F0NUDr3gsxqYBJV5vkbJE8UoNcZEn92PU
MIME-Version: 1.0
X-Received: by 2002:a05:6638:381c:: with SMTP id i28mr22892618jav.60.1617017285612;
 Mon, 29 Mar 2021 04:28:05 -0700 (PDT)
Date:   Mon, 29 Mar 2021 04:28:05 -0700
In-Reply-To: <000000000000cefea605bea7e8c3@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e7989c05beab2c46@google.com>
Subject: Re: [syzbot] general protection fault in io_commit_cqring (2)
From:   syzbot <syzbot+0e905eb8228070c457a0@syzkaller.appspotmail.com>
To:     alobakin@pm.me, asml.silence@gmail.com, axboe@kernel.dk,
        davem@davemloft.net, gnault@redhat.com, gregkh@linuxfoundation.org,
        io-uring@vger.kernel.org, kuba@kernel.org, linmiaohe@huawei.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit f9d6725bf44a5b9412b5da07e3467100fe2af236
Author: Alexander Lobakin <alobakin@pm.me>
Date:   Sat Feb 13 14:11:50 2021 +0000

    skbuff: use __build_skb_around() in __alloc_skb()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11934b3ad00000
start commit:   81b1d39f Merge tag '5.12-rc4-smb3' of git://git.samba.org/..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13934b3ad00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15934b3ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=daeff30c2474a60f
dashboard link: https://syzkaller.appspot.com/bug?extid=0e905eb8228070c457a0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e0ed06d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1144754ed00000

Reported-by: syzbot+0e905eb8228070c457a0@syzkaller.appspotmail.com
Fixes: f9d6725bf44a ("skbuff: use __build_skb_around() in __alloc_skb()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
