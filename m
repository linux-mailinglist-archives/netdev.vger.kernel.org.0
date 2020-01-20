Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFCE143466
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 00:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgATXQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 18:16:01 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:50908 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgATXQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 18:16:01 -0500
Received: by mail-io1-f70.google.com with SMTP id e13so570116iob.17
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 15:16:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=y3GTXWLuk9NLOUo9vngxj+QH9Vmo0/vEpcLHw8rmxOE=;
        b=qYzNZbUwYl7DH03m2A/O42XqQcVAhMMKQquDFphsbqke63j7aZmysJ1UQ2yiIg4Opx
         6baNuekWG/z5rZv4d4y0BZxxgi+R6DCkRqO7TAffcKtFP+XuwE33zDEd9jtjyH7MTb8H
         Elv9f5nOyPxUOUhUMKcuEKTZuje+LYuDK7XCWYCt5htWoHepna1v2t1Z42x3lkDXmXwj
         RQ+oQDk8fl1txl4/cr62lenTGa3CZUaSQ5WUV7g8vQJgxREL8Y0Wcyf5xE0rjujYXw2k
         qtVOLJU9tvTq2IKgd2oOj9QQU7R2uZPzA9xSzGCrzRLrjdBcuSgsxZdNGPea38Ks+EYL
         czmw==
X-Gm-Message-State: APjAAAW58mvah4lo+4w/b0n7YEz/QP6XESVJ73YYC1WUjEhtyy0svNOl
        NfYwcg97ZiCzyW1nfFD5rIdi8KGZp1QhVEiEI4xjMYB1mdzq
X-Google-Smtp-Source: APXvYqwTQzxbm8PYHQsYDQTufEheVPhobojoxo91G/kDDsKtigITdXJIOhyQnk0UJj6rRXnzx2pnx/MUqigsEvuGYyTl0a8JeDIb
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:f0f:: with SMTP id x15mr1213167ilj.298.1579562160891;
 Mon, 20 Jan 2020 15:16:00 -0800 (PST)
Date:   Mon, 20 Jan 2020 15:16:00 -0800
In-Reply-To: <000000000000c7999e059c86eebe@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000802f87059c9a7984@google.com>
Subject: Re: KASAN: use-after-free Read in bitmap_ipmac_ext_cleanup
From:   syzbot <syzbot+33fc3ad6fa11675e1a7e@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, po-hsu.lin@canonical.com,
        skhan@linuxfoundation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit ff95bf28c23490584b9d75913a520bb7bb1f2ecb
Author: Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Mon Jul 1 04:40:31 2019 +0000

    selftests/net: skip psock_tpacket test if KALLSYMS was not enabled

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17e2e966e00000
start commit:   8f8972a3 Merge tag 'mtd/fixes-for-5.5-rc7' of git://git.ke..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1412e966e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1012e966e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=33fc3ad6fa11675e1a7e
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15982cc9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11be38d6e00000

Reported-by: syzbot+33fc3ad6fa11675e1a7e@syzkaller.appspotmail.com
Fixes: ff95bf28c234 ("selftests/net: skip psock_tpacket test if KALLSYMS was not enabled")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
