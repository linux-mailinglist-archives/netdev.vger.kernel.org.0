Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58245401174
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 22:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235820AbhIEUFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 16:05:18 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:52037 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbhIEUFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 16:05:10 -0400
Received: by mail-io1-f72.google.com with SMTP id i11-20020a056602134b00b005be82e3028bso3663709iov.18
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 13:04:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=u7MTmHe0EZ9aA9LzZAxZXm6GQj3ww9LG3NsEE4FMIzE=;
        b=jMAvnP0Hk72SawrVJ1eJJ5dwQoGFzcrT2SaoyvmWnc5m4ks7rDHQkNFoczFhFpscnO
         cdu2ltq91pgac3F47CmSVWd8HFpFWVwUTIZL3eG2qVqrUb31bODAY3/8gGbWj5g6cRD/
         PFWMUhVjQGuLfBMGZhwIAKnxl7p4pfC5CwvSVRHrWmuM65mPLUPnvV4BoC2npiFExe89
         90EXzgqCvYRCAw93eBExpZjJxiD2qRoBaSiFotgASsu2zsisnea6byZlcbBI8fEdqLdE
         DSWUpPNYVWr796kC+vgGqFSA39rkgQstMwijsbF1kYyGwupk+w3Zr3aAuMFx5GATYFS+
         dMqQ==
X-Gm-Message-State: AOAM5335FRw5VNRbgKFhZ56zHTB6zuX3HEuC+VupFTVcdVx0FIsxzVwc
        2Y6rdZVGrRqUQx0Nkqs6oM73e/ip2Ux/qVxlcXjsxza5GIFo
X-Google-Smtp-Source: ABdhPJw8uxsAVTc7y/O2Nho+1GgIvGWLtmslQzKpOBn86Tsfrhp/WIPdMKxCklB4s2cNvBUTeZJMFKunrHzUglETpZQX+qZo7Qz/
MIME-Version: 1.0
X-Received: by 2002:a6b:7b4b:: with SMTP id m11mr7043393iop.165.1630872246693;
 Sun, 05 Sep 2021 13:04:06 -0700 (PDT)
Date:   Sun, 05 Sep 2021 13:04:06 -0700
In-Reply-To: <0000000000002c756105cb201ef1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f032a605cb450801@google.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in bpf_check
From:   syzbot <syzbot+f3e749d4c662818ae439@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        daniel@iogearbox.net, davem@davemloft.net, eric.dumazet@gmail.com,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        w@1wt.eu, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 7661809d493b426e979f39ab512e3adf41fbcc69
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 14 16:45:49 2021 +0000

    mm: don't allow oversized kvmalloc() calls

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13136b83300000
start commit:   a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10936b83300000
console output: https://syzkaller.appspot.com/x/log.txt?x=17136b83300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c84ed2c3f57ace
dashboard link: https://syzkaller.appspot.com/bug?extid=f3e749d4c662818ae439
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e4cdf5300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ef3b33300000

Reported-by: syzbot+f3e749d4c662818ae439@syzkaller.appspotmail.com
Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
