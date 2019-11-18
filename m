Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339C0100447
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 12:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbfKRLfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 06:35:01 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:42961 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfKRLfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 06:35:01 -0500
Received: by mail-il1-f200.google.com with SMTP id n16so16056909ilm.9
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 03:35:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=OKcSBLpcQwVpHujFTv8FpB4Au/9d3T/ERi36eX6lzZI=;
        b=A6wP0yqI2ZjPgxE5BeeLgtbxS0FCo82JHYyyvj9fJmOSlswgND+mAmeMGCckNorcv0
         umf9nyeQpuQCBi0REN5v60jn0cWP5sq6CHGfd0Kg7uVl2rUewgX697g7l27bAZRfYSX6
         diVXiSz9ZYO5yhYZukxbv6uaVfH5scwMSUCHEQ8CbVX+kBGnh7bwtnmLkQXseNakpCI1
         140s8cqrPKunsOyV1t5N6jIIeia1tw5AnL9mmJ8Gi85ZflfDH+FOA/hRh10lsGGHV8kV
         kKFRWDh1thsdkauXfTGiFJbwNWaWY53uhhPY6Zf6ey+NVzNg3fujEfrWg/hrfSd3zj2/
         2/lA==
X-Gm-Message-State: APjAAAURRdsnBP22djFmeJfYjGr7E4TjatL+h2q9vfsvSjR9QAZEYONc
        JZNivA3/+RHpecrLzgvnne7w507KK9vx2Da15cHYqCXhkd1T
X-Google-Smtp-Source: APXvYqz5bu5rJHE/FbEt2tMmodc2aqbhvo8CHiTTuTBIRG4UDMrgh/XnnlvU+UwaeTJy4Ctb4swGcLR3So0ADXtsYuwV/jdtkqg7
MIME-Version: 1.0
X-Received: by 2002:a6b:7307:: with SMTP id e7mr11864167ioh.218.1574076900780;
 Mon, 18 Nov 2019 03:35:00 -0800 (PST)
Date:   Mon, 18 Nov 2019 03:35:00 -0800
In-Reply-To: <0000000000005175bf057617c71d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000085314105979d561b@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in ip6_tnl_parse_tlv_enc_lim
From:   syzbot <syzbot+68dce7caebd8543121de@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, ast@kernel.org, boqun.feng@gmail.com,
        byungchul.park@lge.com, daniel@iogearbox.net, davem@davemloft.net,
        kernel-team@lge.com, kirill@shutemov.name, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@kernel.org,
        netdev@vger.kernel.org, npiggin@gmail.com, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, walken@google.com,
        willy@infradead.org, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit a10b5c564741cd3b6708f085a1fa892b63c2063d
Author: Byungchul Park <byungchul.park@lge.com>
Date:   Mon Aug 14 07:00:51 2017 +0000

     locking/lockdep: Add a comment about crossrelease_hist_end() in  
lockdep_sys_exit()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1026190ce00000
start commit:   3a5af36b Merge tag '4.19-rc3-smb3-cifs' of git://git.samba..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1226190ce00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1426190ce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c4a80625153107e
dashboard link: https://syzkaller.appspot.com/bug?extid=68dce7caebd8543121de
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1068a44e400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=146386c6400000

Reported-by: syzbot+68dce7caebd8543121de@syzkaller.appspotmail.com
Fixes: a10b5c564741 ("locking/lockdep: Add a comment about  
crossrelease_hist_end() in lockdep_sys_exit()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
