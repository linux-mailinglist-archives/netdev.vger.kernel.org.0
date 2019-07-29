Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5E87871D
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 10:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfG2IQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 04:16:01 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:49327 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfG2IQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 04:16:01 -0400
Received: by mail-io1-f69.google.com with SMTP id x24so66751100ioh.16
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 01:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0rPakemNyIs9fbLrhB6s/ulRRU21c/3n0kSBtdCA0Eo=;
        b=IcYpWzCPaSCbDtTXXRo2gJ2grVIOvYzUncidGpBF6KU2/s6BG2F9q6JMUe3f92H5po
         9qJcsBf3bzT4jpjIAx0SFmN3lhdjHBlpO/HyOYDZXd0CANqYXtsah1jtXnCEd0qLXxmI
         2Wd4yPJ+56q+HgV3AVCi3XYbj1TbPGd0bRJCnwHff5vnK5ZLjXlYLC78zoA12FypqGU8
         BpkE69WP04JG4nSFoboR7irG9JUIe13AjxV7lGMmMbErH2MIyfa+db3c5SZbKwHvxWll
         vg1XzrgLAdLke79J0DAa1ERrDCZXctf7SNMj/gf3bxfyko2oR/nVltM9htjVSfcm2BHA
         1xoA==
X-Gm-Message-State: APjAAAUEE2LLVsttL09PyUUCOu+r774td2iJjvAufeAFk5TbnprKadm3
        UdEf19B6xWgBw4xQ6wJ9G4O3sWjp7hx/igpdILpPCn6ksW/5
X-Google-Smtp-Source: APXvYqxSkxuHca0jLTiQmdMdnlp+TfywXlCfVmn/nxBSNrXe+PgHcKdxjXDq/A4yJcJjcL3n5aaCmQIspC/xzgAeN42nGa5pW21x
MIME-Version: 1.0
X-Received: by 2002:a5d:994b:: with SMTP id v11mr53971532ios.165.1564388160200;
 Mon, 29 Jul 2019 01:16:00 -0700 (PDT)
Date:   Mon, 29 Jul 2019 01:16:00 -0700
In-Reply-To: <0000000000005718ef058b3a0fcf@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000094699a058ecd8017@google.com>
Subject: Re: memory leak in __nf_hook_entries_try_shrink
From:   syzbot <syzbot+c51f73e78e7e2ce3a31e@syzkaller.appspotmail.com>
To:     catalin.marinas@arm.com, coreteam@netfilter.org,
        davem@davemloft.net, deller@gmx.de, fw@strlen.de,
        jejb@parisc-linux.org, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-parisc@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit fc79168a7c75423047d60a033dc4844955ccae0b
Author: Helge Deller <deller@gmx.de>
Date:   Wed Apr 13 20:44:54 2016 +0000

     parisc: Add syscall tracepoint support

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16ad2cd8600000
start commit:   b076173a Merge tag 'selinux-pr-20190612' of git://git.kern..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15ad2cd8600000
console output: https://syzkaller.appspot.com/x/log.txt?x=11ad2cd8600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb38d33cd06d8d48
dashboard link: https://syzkaller.appspot.com/bug?extid=c51f73e78e7e2ce3a31e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=105a958ea00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=103c758ea00000

Reported-by: syzbot+c51f73e78e7e2ce3a31e@syzkaller.appspotmail.com
Fixes: fc79168a7c75 ("parisc: Add syscall tracepoint support")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
