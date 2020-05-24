Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314081E015D
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 20:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387945AbgEXSMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 14:12:08 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:45485 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387924AbgEXSMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 14:12:05 -0400
Received: by mail-il1-f197.google.com with SMTP id g19so13483797ila.12
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 11:12:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1e+UJBuT1k8k9TU3OPyghBUaf947khu0vC7FuIpxkqI=;
        b=PIKu2YAJqqQjqSRZt7Zc3x+X5F8jEuzcHmMrtSwGAgjFSwi3BddjWtFAG71uzYlU0s
         MV93kQ0g/3z1hkfqWNA6mBBTBNKtFVZSiVAcBk75+LlO09e3WZHu/xA8jm10Wjfx3uv3
         jFcP2cb8Fz4A7QttR8zkuH0cCsKWqh8KFasUGuSmNN9vS6gvz8V1SPEPQpx1dRoaMr0o
         iI6gRFbPWSVOI3jj2WW6LC3txCvkCjinug7EZLC0IW6HyzCEWP7NJDn89XBt/cKOg1GZ
         KPNXCZLqHC7n1LgHXlSRgSpK7DMI9gDIXM0B+M9t4jTvKcYWvfLYKvbl1cpfXeeMi/Wh
         QvnA==
X-Gm-Message-State: AOAM530MnaCn/iyD1tKF6y1wgvLUTmpNcnYnt705YGHPGRPhhqdlBaA9
        0rJmnvrHZmiWVMdHKHIta+VN7LsuEbwkG6TPoP5wDlX7hba1
X-Google-Smtp-Source: ABdhPJwF9Bdk/vQYBRg4tVeymnZIBXmTz+Y935KEeBRmKqKCTHUUVdJXl+4iYgIDntbTkoRmisRFgeHNNKsHIPthaCS4+QtcZmr3
MIME-Version: 1.0
X-Received: by 2002:a05:6638:5a2:: with SMTP id b2mr16907058jar.59.1590343923507;
 Sun, 24 May 2020 11:12:03 -0700 (PDT)
Date:   Sun, 24 May 2020 11:12:03 -0700
In-Reply-To: <00000000000054221d05a64b7ed8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a1a76d05a668ccbb@google.com>
Subject: Re: general protection fault in selinux_socket_recvmsg
From:   syzbot <syzbot+c6bfc3db991edc918432@syzkaller.appspotmail.com>
To:     andriin@fb.com, anton@enomsg.org, ast@kernel.org,
        bpf@vger.kernel.org, ccross@android.com, daniel@iogearbox.net,
        davem@davemloft.net, dvyukov@google.com, edumazet@google.com,
        eparis@parisplace.org, john.fastabend@gmail.com, kafai@fb.com,
        keescook@chromium.org, kpsingh@chromium.org, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.01.org, netdev@vger.kernel.org, omosnace@redhat.com,
        pabeni@redhat.com, paul@paul-moore.com,
        penguin-kernel@I-love.SAKURA.ne.jp, selinux@vger.kernel.org,
        songliubraving@fb.com, stephen.smalley.work@gmail.com,
        syzkaller-bugs@googlegroups.com, tony.luck@intel.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 263e1201a2c324b60b15ecda5de9ebf1e7293e31
Author: Paolo Abeni <pabeni@redhat.com>
Date:   Thu Apr 30 13:01:51 2020 +0000

    mptcp: consolidate synack processing.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12a5254a100000
start commit:   051143e1 Merge tag 'apparmor-pr-2020-05-21' of git://git.k..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=11a5254a100000
console output: https://syzkaller.appspot.com/x/log.txt?x=16a5254a100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3368ce0cc5f5ace
dashboard link: https://syzkaller.appspot.com/bug?extid=c6bfc3db991edc918432
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13eeacba100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167163e6100000

Reported-by: syzbot+c6bfc3db991edc918432@syzkaller.appspotmail.com
Fixes: 263e1201a2c3 ("mptcp: consolidate synack processing.")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
