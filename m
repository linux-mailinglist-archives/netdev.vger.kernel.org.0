Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640CC31FFC5
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 21:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhBSUZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 15:25:52 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:36900 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhBSUZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 15:25:49 -0500
Received: by mail-io1-f71.google.com with SMTP id q10so4630005ion.4
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 12:25:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=hjZbSKSdJoVbeXQb2cKTUlfTuBF1xCsCTBC7HaDhAqc=;
        b=HpfTdAsmkJ9wVYUpRspoH/eAVmJd3xerobTNzpHz30BYq19fpf7h9kF+5hKH3hTbXS
         IgE2pCic6Nqnu8r7kD71r7O3U/AH5TWD8bxTdn4xaqOEPDENsG7WrtaGbqt4kZ1ud23i
         vzdJuf6A6m59jUiHTNQDYHp7qPCJ9H5QYPLsiHI1ipTa9LJqMFd3HIhRhRkmXBHel3N+
         tHaOh/DkqTtXPuQFptTfrakuEE4uHW2HS9lo/6AcUSqPHL6CVddSqX7VaOwFJkvXd6ZD
         H59b88EAqn4jRNXtRxxoujbJzZg77z7aYiONjH2qthLEdOrO2km9aO0FQfEfoVLDtvui
         6mjA==
X-Gm-Message-State: AOAM532DS0ky6C5YWlKqGUix5pEuEexOzRXSOF5GDOnl9djFWHv5MoaE
        HNKfuoYkLo5R7fh1xtpk81GymJA5T4Clnjk2+gbpfA1quEQC
X-Google-Smtp-Source: ABdhPJzaNZrVsv/ryRJA4dYhFRa7Wl7b8vkqC9i7fTKA8LG8K0bIRf6d4VRk5Ctco+HNQXG4iijusTwsrvVnvfJWIrj+T4KamXcH
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2d0d:: with SMTP id c13mr5543282iow.51.1613766308788;
 Fri, 19 Feb 2021 12:25:08 -0800 (PST)
Date:   Fri, 19 Feb 2021 12:25:08 -0800
In-Reply-To: <000000000000e29ec405bb8b9251@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000096022805bbb63f35@google.com>
Subject: Re: general protection fault in mptcp_sendmsg_frag
From:   syzbot <syzbot+409b0354a6ba83a86aaf@syzkaller.appspotmail.com>
To:     davem@davemloft.net, fw@strlen.de, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, mptcp@lists.01.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 40947e13997a1cba4e875893ca6e5d5e61a0689d
Author: Florian Westphal <fw@strlen.de>
Date:   Fri Feb 12 23:59:56 2021 +0000

    mptcp: schedule worker when subflow is closed

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1541a434d00000
start commit:   773dc50d Merge branch 'Xilinx-axienet-updates'
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1741a434d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1341a434d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dbc1ca9e55dc1f9f
dashboard link: https://syzkaller.appspot.com/bug?extid=409b0354a6ba83a86aaf
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16548404d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=150c2914d00000

Reported-by: syzbot+409b0354a6ba83a86aaf@syzkaller.appspotmail.com
Fixes: 40947e13997a ("mptcp: schedule worker when subflow is closed")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
