Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3D20141FFD
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 21:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgASUVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 15:21:01 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:48244 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728709AbgASUVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 15:21:01 -0500
Received: by mail-il1-f198.google.com with SMTP id u14so23662388ilq.15
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 12:21:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=tB8tVCfxWFIVfqWEsKuHgi0liSe9R1RZ+UBErAfoDaU=;
        b=KL6ujWghrMHl+0RxuDk6C4thA8x0tqcFFNr7s/Xd3W9JNaT/QMjcwZXEsbEy+HWSvb
         Go5eg3+EHIYc7MVI35Qzu0vRQophxz/A0lNr6IB/Cix59IZtTrAeiO4xOMNwDXEMxxVx
         JhDx5adm7vyAkFmfX2GSbl9gAjwHOpUjTUrKUPIoD9q9HXSC5J7JKIWj6QJn9WgLW+V0
         8fHTmZgeugel1EKP9sj+2rEncXnqd+0SJ1lTry7vZZQEjWTmpzmbpagXD5UhzgtNJjSw
         PgU8QAgBq2QKlJp3WBHZ6JarW7cJjz7EpE1OoV+lEZPqPw2NhNVFNlFEslDKTPKqk6+q
         QsLg==
X-Gm-Message-State: APjAAAVvINipbeMv/qcIkcJbiT2LuX/KdIWfqmiyWGoaH4qqkzSQ8Y8o
        JFXRxYd3SCw8UA8xOG6OQwQTwLENXSYHrzcekfF0naPv7Buf
X-Google-Smtp-Source: APXvYqyBW0ANY5otx8x2mkJHYLCBShYafFG9L0jcSxJr3/w8Z3m4XgrA+Nba0kwQlcnkDJsAXjzzdqX7oGV/luxPfoRNInuKbPwk
MIME-Version: 1.0
X-Received: by 2002:a6b:b74a:: with SMTP id h71mr15932229iof.212.1579465260652;
 Sun, 19 Jan 2020 12:21:00 -0800 (PST)
Date:   Sun, 19 Jan 2020 12:21:00 -0800
In-Reply-To: <0000000000006d7b1e059c7db653@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cbfd34059c83e917@google.com>
Subject: Re: KASAN: use-after-free Read in bitmap_ip_ext_cleanup
From:   syzbot <syzbot+b554d01b6c7870b17da2@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, florent.fourcot@wifirst.fr, fw@strlen.de,
        jeremy@azazel.net, johannes.berg@intel.com, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        nikolay@cumulusnetworks.com, pablo@netfilter.org,
        roopa@cumulusnetworks.com, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 3d26eb8ad1e9b906433903ce05f775cf038e747f
Author: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date:   Tue Jul 2 12:00:20 2019 +0000

    net: bridge: don't cache ether dest pointer on input

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17bb1cc9e00000
start commit:   9aaa2949 Merge branch '1GbE' of git://git.kernel.org/pub/s..
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=147b1cc9e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=107b1cc9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66d8660c57ff3c98
dashboard link: https://syzkaller.appspot.com/bug?extid=b554d01b6c7870b17da2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15db12a5e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15316faee00000

Reported-by: syzbot+b554d01b6c7870b17da2@syzkaller.appspotmail.com
Fixes: 3d26eb8ad1e9 ("net: bridge: don't cache ether dest pointer on input")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
