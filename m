Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B3C72216
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392334AbfGWWRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:17:01 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:55803 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389430AbfGWWRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:17:01 -0400
Received: by mail-io1-f69.google.com with SMTP id f22so48765890ioh.22
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 15:17:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Wc2GRQ8gP6XwuqazuIoFspLdgI5vGhNFmUdsnDHhoCY=;
        b=F0vqxWMWFtzv9MHHCcxkQIN3mUivXjALV3io83avMPxBzSw3C2OL0ifp6z5bV3Rlwo
         hZLFntcERygpVyeOsGif1qzZOj4lhOak8SsCjLeDkbWQy1pemVgWN7P4KaHfBUf23wKR
         ZiYrokSBBN83l4RXEg0hevm892M5g9nC4MVSAAPim0sJVnvD2vdBddWbnOFZ6erU99OG
         ak8b92+5qdCJBCUG+QCVNm3n5oXb3TiGqbkNNaovyNBupa7Aq+5MDzAiZfcArW8NeEqd
         hSth+7CvjAbNuFpX3Q3qUO5YGXd9oLQusWJpN5Q8tivgsLWSfWE+xgyjy4f/AZGnz93N
         VoLA==
X-Gm-Message-State: APjAAAUOcP83YdFakqiOS4bq/XyaPHAMaevCs6snumxRTDi1JCQlcyiK
        3wx3STlLmzCJo7phq8CCa2tyjMFiXgSdoXuNHCjroX1ouxLH
X-Google-Smtp-Source: APXvYqynAoeiP6otUFVILsXnOFuFz0uSuLj1NQooZi4V+EzbzIGh6v4AwqOrxFa7CDpPfgeCk6q5DDGEZIUetLOW5G1d8Jhge8u1
MIME-Version: 1.0
X-Received: by 2002:a6b:6310:: with SMTP id p16mr73998019iog.118.1563920220602;
 Tue, 23 Jul 2019 15:17:00 -0700 (PDT)
Date:   Tue, 23 Jul 2019 15:17:00 -0700
In-Reply-To: <000000000000ad1dfe058e5b89ab@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000034c84a058e608d45@google.com>
Subject: Re: memory leak in rds_send_probe
From:   syzbot <syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, catalin.marinas@arm.com,
        davem@davemloft.net, dvyukov@google.com, jack@suse.com,
        kirill.shutemov@linux.intel.com, koct9i@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, neilb@suse.de, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, ross.zwisler@linux.intel.com,
        santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, willy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit af49a63e101eb62376cc1d6bd25b97eb8c691d54
Author: Matthew Wilcox <willy@linux.intel.com>
Date:   Sat May 21 00:03:33 2016 +0000

     radix-tree: change naming conventions in radix_tree_shrink

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=176528c8600000
start commit:   c6dd78fc Merge branch 'x86-urgent-for-linus' of git://git...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14e528c8600000
console output: https://syzkaller.appspot.com/x/log.txt?x=10e528c8600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8de7d700ea5ac607
dashboard link: https://syzkaller.appspot.com/bug?extid=5134cdf021c4ed5aaa5f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145df0c8600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170001f4600000

Reported-by: syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com
Fixes: af49a63e101e ("radix-tree: change naming conventions in  
radix_tree_shrink")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
