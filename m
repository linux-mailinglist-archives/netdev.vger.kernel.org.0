Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A331115E43
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 20:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfLGTpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 14:45:01 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:45708 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfLGTpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 14:45:01 -0500
Received: by mail-io1-f70.google.com with SMTP id m18so7488340ioj.12
        for <netdev@vger.kernel.org>; Sat, 07 Dec 2019 11:45:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wS16iwY4SHAgS9TQBNqZiLR/a6ESQzbpzGaub4GpqpA=;
        b=JTf5Ej+BNRlOm6VjbssSTQR8HeeSAY/RVWZ3nW89qoPpnz3QDfpSoJwbs9bJjNmUV8
         ekmbZnSu1ikJB4zr4k/y6xUgxxLMgb7ekxrBWfKLE6j202Mp0WoUzQU/kXi4obxt1b7Q
         oiGoowM3ZTmXq1R3X4Iros+KXNt5nerfgyoV5Pa4S1JrnUcphy9LZKgNqwJxIlpdZefi
         PgVnicRpweTqQwR4DfPFvrJ2oWnIuT4RoPwlE8Msga8BHkEOCn2Xa5INQ8J6+w7NRZXp
         7YimiMTToVcwsJcyflcU09Z0mySCOIbO/VhlCztnjciOymCuAls2DL/df9SQr1JpDyKb
         Ef4Q==
X-Gm-Message-State: APjAAAVqvDY0qnTGIPAdVYX+WGjt5gHqqkAmNexmSrOYb1xX8PJxQD7j
        Pd+frmYE3GBSwj7bGMUCQuwN8ZDAF0yMhz7vJDRhFAQu5al/
X-Google-Smtp-Source: APXvYqxMOz34v4xow1dYjI+bbaCYsdOSN0ZdxyIPBJDZ8r/SQQJ0i2OUsyFKZ5sPLHCufzkzxsAmqoemLoiPMD9bsX8FJt+NfxS0
MIME-Version: 1.0
X-Received: by 2002:a6b:f60e:: with SMTP id n14mr14826689ioh.147.1575747900539;
 Sat, 07 Dec 2019 11:45:00 -0800 (PST)
Date:   Sat, 07 Dec 2019 11:45:00 -0800
In-Reply-To: <000000000000f665a30570885589@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000de09e70599226583@google.com>
Subject: Re: KASAN: use-after-free Read in __queue_work (2)
From:   syzbot <syzbot+1c9db6a163a4000d0765@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net,
        dominique.martinet@cea.fr, ericvh@gmail.com, jiangyiwen@huwei.com,
        linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, rminnich@sandia.gov,
        syzkaller-bugs@googlegroups.com, tomasbortoli@gmail.com,
        v9fs-developer@lists.sourceforge.net, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 430ac66eb4c5b5c4eb846b78ebf65747510b30f1
Author: Tomas Bortoli <tomasbortoli@gmail.com>
Date:   Fri Jul 20 09:27:30 2018 +0000

     net/9p/trans_fd.c: fix race-condition by flushing workqueue before the  
kfree()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15661282e00000
start commit:   ca04b3cc Merge tag 'armsoc-fixes' of git://git.kernel.org/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=2ca6c7a31d407f86
dashboard link: https://syzkaller.appspot.com/bug?extid=1c9db6a163a4000d0765
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1473a452400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14087748400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: net/9p/trans_fd.c: fix race-condition by flushing workqueue  
before the kfree()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
