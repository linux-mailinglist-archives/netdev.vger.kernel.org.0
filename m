Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6292022B41D
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 19:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgGWRGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 13:06:06 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:56021 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgGWRGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 13:06:05 -0400
Received: by mail-io1-f71.google.com with SMTP id k10so4442383ioh.22
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 10:06:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5CYbMZ9E5A0Mz6J623Xu55BU2Et7NhlNxD6HpaP2/I8=;
        b=eJdkkxgKlJG+7iX5VSYuKsyhNVtGl2gX9GiBfrAVoJ8PAm2J8bHGDAekHfrHNMmfeq
         TR0owyWil81G7eBQvfZ2X8njXYgklmcFI7dRHrR6JI3wUGGs5CK73qLTIIEo2axng01z
         PPeJLFQHv143RW2MWpxnfaHFzWDwG2B9roJynLqzaub16Io93awY4Xj98yE8muQP1iyo
         MkjOqUASm8HHJJzodCLiPx7Tzl/nHZwinkgs+eY0e85G4mppkydfWh3wiflaf0bhO6c7
         IQBzLowGinK7fYG2PL/tooGeBhTs7BLrT7Nj6ZyD61Nv5xfLPreZjcLNG3KkNKVhgLEj
         bsgw==
X-Gm-Message-State: AOAM531mk428/Lc7dAwmltpd2srxcOSLTwzgUj81Sja2o8hr9v8+HSro
        e87TLtlJQsQrPiXhmZpRvcqYJ0sdDza9CSPp33gDYROUxaZf
X-Google-Smtp-Source: ABdhPJxO1HAnLT9DnS+ErjhGrIxE4rnBK+8uSCWAMhvotTHMVQYSX/Tja0D8v90nwLa656ScMblR2RAfY/8cBGRHlC5Im1fJq9o5
MIME-Version: 1.0
X-Received: by 2002:a92:3407:: with SMTP id b7mr5752526ila.66.1595523964723;
 Thu, 23 Jul 2020 10:06:04 -0700 (PDT)
Date:   Thu, 23 Jul 2020 10:06:04 -0700
In-Reply-To: <000000000000b1b74105a91bf53d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000025ed9705ab1edf54@google.com>
Subject: Re: KASAN: use-after-free Read in macvlan_dev_get_iflink
From:   syzbot <syzbot+95eec132c4bd9b1d8430@syzkaller.appspotmail.com>
To:     andriin@fb.com, ap420073@gmail.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 1a33e10e4a95cb109ff1145098175df3113313ef
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun May 3 05:22:19 2020 +0000

    net: partially revert dynamic lockdep key changes

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17663aef100000
start commit:   1590a2e1 Merge tag 'acpi-5.8-rc3' of git://git.kernel.org/..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14e63aef100000
console output: https://syzkaller.appspot.com/x/log.txt?x=10e63aef100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c907630cbdbe5
dashboard link: https://syzkaller.appspot.com/bug?extid=95eec132c4bd9b1d8430
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1559e6e5100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16aadd29100000

Reported-by: syzbot+95eec132c4bd9b1d8430@syzkaller.appspotmail.com
Fixes: 1a33e10e4a95 ("net: partially revert dynamic lockdep key changes")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
