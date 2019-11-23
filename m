Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF780108116
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 00:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfKWXhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 18:37:05 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:56772 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbfKWXhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 18:37:03 -0500
Received: by mail-io1-f69.google.com with SMTP id u6so7861195ion.23
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 15:37:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=rcXyQARNFeEGX/5R/wh8uboQxfvT9hdMO0gGiQWOSiI=;
        b=ohGkLrfuWesuWQJYvWNSkyYSN8fmpK4SlbDzLcqJI6cEdNFeby/GNvxUOTK/dFbKAy
         LyB6yDhhJPHSGee1fGU+Kuv6DFUROqBW6ndVMx/CSpTJmogsFE2Xy/RsVRi51ZN3fOVD
         b4TlSqfCmjgqXswnpZ/559sbxx+RESNe5EhnTuKhkpMUGHNskr1BNN8XyE/Ukyb4NL3P
         N5LL8HxBlRZYqo3SSIdfzCSoI5sdkmqg4liylE6JnLUEJ20UBmiMJF6zG+7/fb4YE4mo
         C0BjXuks12wXvYZytwOOv2/5k2R2o4QI++irWcq/FPKz/TGnWp2YWy3TKFz8qsj9qmV9
         UIbA==
X-Gm-Message-State: APjAAAW8zRxb16eyJKA7LVmDawtiRkzav6ZVAKu058IP9p3zQ7PAgYEY
        DiRPXj0xDslB0elo9f0bDK2v6QeLKi/xnE6hwK8S9Em2zsus
X-Google-Smtp-Source: APXvYqwj40xk+Xd7ru4QMKddn8/SsIpJKtP1YXxZ615/+EY9PfAFOY8RE0ZRU+3mTx9eSm5J1cqivLB4uhge43PShk8uF8pfq69t
MIME-Version: 1.0
X-Received: by 2002:a92:3904:: with SMTP id g4mr7836256ila.242.1574552221276;
 Sat, 23 Nov 2019 15:37:01 -0800 (PST)
Date:   Sat, 23 Nov 2019 15:37:01 -0800
In-Reply-To: <000000000000f665a30570885589@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d45f7b05980c01ce@google.com>
Subject: Re: KASAN: use-after-free Read in __queue_work (2)
From:   syzbot <syzbot+1c9db6a163a4000d0765@syzkaller.appspotmail.com>
To:     davem@davemloft.net, ericvh@gmail.com,
        linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, rminnich@sandia.gov,
        syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 7594bf37ae9ffc434da425120c576909eb33b0bc
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Mon Jul 17 02:53:08 2017 +0000

     9p: untangle ->poll() mess

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12ad235ee00000
start commit:   ca04b3cc Merge tag 'armsoc-fixes' of git://git.kernel.org/..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=11ad235ee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16ad235ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2ca6c7a31d407f86
dashboard link: https://syzkaller.appspot.com/bug?extid=1c9db6a163a4000d0765
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1473a452400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14087748400000

Reported-by: syzbot+1c9db6a163a4000d0765@syzkaller.appspotmail.com
Fixes: 7594bf37ae9f ("9p: untangle ->poll() mess")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
