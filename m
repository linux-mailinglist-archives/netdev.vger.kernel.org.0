Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8DE401212
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 01:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhIEXWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 19:22:14 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:33493 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbhIEXWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 19:22:13 -0400
Received: by mail-io1-f70.google.com with SMTP id g2-20020a6b7602000000b005be59530196so3996695iom.0
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 16:21:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=t6KGl5qGZOKwjA8wYNjhxOdRHpEUEUmyOHtgq+CbC7c=;
        b=C6ERjY2NzoB4nnaw2LpNEpe5a+msJb0sEwke5kD1BGlkdPnYw4rbG2phvQSO4tH4zi
         irC3TFD3y8ewhujLheOBAtJpZEO0+fExzqvmngNA7Sn92xn62AhWmHIHy53Z9Gqrg9FD
         Ac7W+mfJA/2rXDjFKgyQneKXS54xQ2CceUZ+uj2NiA+1h2jdUxHm4oFRIuQ99p79QWbb
         x9hT5Hxeetyry/r9cKDGwKwwp7QECXfCybjLk4LgX8aWMxp/T6gYMxvbnwuRBJ4OsXKy
         z6d68kbbV5LOtxCInUUWDY1ZAxJQ2vn9Yji4//sORgTiZ5O5sysvZpBwfwDx1hsksy8L
         fmZg==
X-Gm-Message-State: AOAM531a2SFZu8j7L9uDQV5eR+plYVtmC5T+aJNRdMzkowRrN1+5kMu1
        UYv79IUZYlH1ySJTeh3Awx0Fa6729xuOvbL3Y8HWj0HLjxA6
X-Google-Smtp-Source: ABdhPJwd3TYEWNuMTgpkZAvirmsn+/SrAn8Wwh9OqmKijRfViKorf/rzRe7Kmqs3U6G0U4D5VgDmmChYa9ZQ83uEoiOkJtAR2DKB
MIME-Version: 1.0
X-Received: by 2002:a05:6602:38e:: with SMTP id f14mr7782287iov.62.1630884069876;
 Sun, 05 Sep 2021 16:21:09 -0700 (PDT)
Date:   Sun, 05 Sep 2021 16:21:09 -0700
In-Reply-To: <000000000000ea2f2605cb1ff6f6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a7a8de05cb47c9b2@google.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in hash_ip_create
From:   syzbot <syzbot+3493b1873fb3ea827986@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, chaitanya.kulkarni@wdc.com,
        coreteam@netfilter.org, davem@davemloft.net,
        eric.dumazet@gmail.com, fw@strlen.de, hch@lst.de,
        ira.weiny@intel.com, johan.hedberg@gmail.com, kadlec@netfilter.org,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, martin.petersen@oracle.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit e6e7471706dc42cbe0e01278540c0730138d43e5
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Jul 27 05:56:34 2021 +0000

    bvec: add a bvec_kmap_local helper

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17468471300000
start commit:   a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14c68471300000
console output: https://syzkaller.appspot.com/x/log.txt?x=10c68471300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7860a0536ececf0c
dashboard link: https://syzkaller.appspot.com/bug?extid=3493b1873fb3ea827986
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11602f35300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e8fbf5300000

Reported-by: syzbot+3493b1873fb3ea827986@syzkaller.appspotmail.com
Fixes: e6e7471706dc ("bvec: add a bvec_kmap_local helper")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
