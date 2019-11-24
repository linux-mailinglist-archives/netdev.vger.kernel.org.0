Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E959108490
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 20:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfKXTHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 14:07:03 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:38438 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbfKXTHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 14:07:03 -0500
Received: by mail-io1-f71.google.com with SMTP id q4so9357689ion.5
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 11:07:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0iPpdRzq0L7+RSFavqTsQfmCi/uTeccXAim0E/TGr2Q=;
        b=uQV09l+tXqt9xuvSaUdY0Yg+SwWXf+ODa+GD40Y7mqbidvP6/CQ/tgJZUJRjSSd46m
         dIPK7U5EuiLxZ4Uhay5WvZuPoUulBUlEEY/hDaAlWN71+LDlL5LbSJU2dlFyjrJ63ldU
         osUY6ZXOe1qpLXygs3t3tHv46m92k6eoAC0DZ5aqQp2Plnli6soaLKs8LWFPdp7cDN7T
         TuAiXcLXXakpg4iKYaOqKxrf1zxLJX8RTAdcyzER2qEoNVH0BQ9qYU30SB7KRWKhzDpS
         kDZMpN+0ttop7dS0DupzM1Z5499IbalOdxO9BW225BzcBXHq2KAGl4GJygNPVDt3ls+T
         4DGw==
X-Gm-Message-State: APjAAAUCTasfldoYV9Hf+j61K2z2+KJ/2XL3cxccaBYKRpiWwyFz3OvZ
        7Ig4EAhughu6PFLHpTLi6KIomJ4VOUJbQ9OrWA+ThwP49yzH
X-Google-Smtp-Source: APXvYqxzdQLTUAzZHkNrn+IW7dBHAAZnrSGKEzdtkJeRCBqjt/+dvnBg9GSfzUg/aUk4k+sN4UpRfbhAt4p8PcJXTniYzbgEeEFN
MIME-Version: 1.0
X-Received: by 2002:a5d:9153:: with SMTP id y19mr23281646ioq.26.1574622420789;
 Sun, 24 Nov 2019 11:07:00 -0800 (PST)
Date:   Sun, 24 Nov 2019 11:07:00 -0800
In-Reply-To: <000000000000e59aab056e8873ae@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000beff305981c5ac6@google.com>
Subject: Re: KASAN: use-after-free Read in blkdev_get
From:   syzbot <syzbot+eaeb616d85c9a0afec7d@syzkaller.appspotmail.com>
To:     cmetcalf@ezchip.com, coreteam@netfilter.org, davem@davemloft.net,
        dvyukov@google.com, gang.chen.5i5j@gmail.com, kaber@trash.net,
        kadlec@blackhole.kfki.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 77ef8f5177599efd0cedeb52c1950c1bd73fa5e3
Author: Chris Metcalf <cmetcalf@ezchip.com>
Date:   Mon Jan 25 20:05:34 2016 +0000

     tile kgdb: fix bug in copy to gdb regs, and optimize memset

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1131bc0ee00000
start commit:   f5b7769e Revert "debugfs: inode: debugfs_create_dir uses m..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1331bc0ee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1531bc0ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=709f8187af941e84
dashboard link: https://syzkaller.appspot.com/bug?extid=eaeb616d85c9a0afec7d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=177f898f800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147eb85f800000

Reported-by: syzbot+eaeb616d85c9a0afec7d@syzkaller.appspotmail.com
Fixes: 77ef8f517759 ("tile kgdb: fix bug in copy to gdb regs, and optimize  
memset")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
