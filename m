Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB91177D91
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 05:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfG1DqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 23:46:02 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:43963 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfG1DqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 23:46:01 -0400
Received: by mail-io1-f71.google.com with SMTP id q26so63506774ioi.10
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 20:46:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=o2kzyTbMhQL/kAorHcC+7ID+BqHWTQyphajjOBsUUz8=;
        b=qb29aP58L4PEiQk1BSV9RrhMRQ8lpgGM0Y6UNYv1mOGKnBMKgHVwVesoBMp4o5epfs
         a4M0ECbVquXCOIATpoAT0r2C9wdRzoXr0YQWCAqndYxWPNOIgPHeA922IlXOMn0uI7kx
         XVmfn3tPDP4UM9CMgH9Jq+57GG1Hu8gqCr1fHGYZMUXODrW83vgRWFU9LtKbH6iWo6n6
         el3O+xfxYgI/w0bfsJ2W82BLAOKPwoaOPWssWMknHiIFZ+QYDPC7EbWVbnZWWjJkbKye
         WZEfE+CmqAY/uJi52AzxbxMnnYxVKFIM5p0YSkdpQ9CKdc3ZW1YKSD4RqLkQ5KxgAgJD
         PfSQ==
X-Gm-Message-State: APjAAAU3OPbcESFsTZqhM7ItK+K1gxhczgpbP8hibIAARWBlnZIatus7
        qfN4oATx+V6+7KpoAo017Jvl+CucCtmKhWJgs2eLzczrMhvA
X-Google-Smtp-Source: APXvYqxXM+e7HkG1ndOj4S4xy8tLRGbSOz7rHomFcVxe9opbIqsbCOX/jEqUOK4tXAcI7y8l03aMdveo9Zu26OKpCrjDuyQnBW0q
MIME-Version: 1.0
X-Received: by 2002:a02:878a:: with SMTP id t10mr33742269jai.112.1564285560945;
 Sat, 27 Jul 2019 20:46:00 -0700 (PDT)
Date:   Sat, 27 Jul 2019 20:46:00 -0700
In-Reply-To: <0000000000002b4896058e7abf78@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000300996058eb59dd7@google.com>
Subject: Re: general protection fault in tls_trim_both_msgs
From:   syzbot <syzbot+0e0fedcad708d12d3032@syzkaller.appspotmail.com>
To:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, corbet@lwn.net, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        kafai@fb.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 32857cf57f920cdc03b5095f08febec94cf9c36b
Author: John Fastabend <john.fastabend@gmail.com>
Date:   Fri Jul 19 17:29:18 2019 +0000

     net/tls: fix transition through disconnect with close

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=155064d8600000
start commit:   fde50b96 Add linux-next specific files for 20190726
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=175064d8600000
console output: https://syzkaller.appspot.com/x/log.txt?x=135064d8600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b58274564b354c1
dashboard link: https://syzkaller.appspot.com/bug?extid=0e0fedcad708d12d3032
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14779d64600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1587c842600000

Reported-by: syzbot+0e0fedcad708d12d3032@syzkaller.appspotmail.com
Fixes: 32857cf57f92 ("net/tls: fix transition through disconnect with  
close")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
