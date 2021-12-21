Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB4647BDBD
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 10:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhLUJwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 04:52:10 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:54152 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhLUJwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 04:52:09 -0500
Received: by mail-il1-f200.google.com with SMTP id x8-20020a92dc48000000b002b2abc6e1cbso3913083ilq.20
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 01:52:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=gtMOeWgOjqpxf3UJsdLLfE47QPkTrgfO0H8YEz5DRG8=;
        b=AIBAcI6nIKcDMUVZWZ3qBrpQkKQMXnVjDQFuJFhb4XFR2XF4eRH4zljQ6KyO+IBACY
         enmb+6GVFN4MG+mRJO8a+1SRS7Ho7epNKpZF/aAfrCBlrBxFPMtFMYzDorFs9fw6yYEI
         Qxr2Hi7NYDxtShYBae3wqgthiKmNCkWWWrUHhLOB1Bs1vhza2NS3cwgVgcNBOskJDDRb
         FRIhggPdzchFfFKLwi8TENoo7/cP2UCZIrmdAucqkkv1YlPIHIolAen+lK95uydz6kcX
         PAAyL/w93+WJ0PsaMoNmmN16CyoDrCF6xhLSUq3wdC5CbLdYfJOuwJw/Zy29+I84qbQ0
         l/Sg==
X-Gm-Message-State: AOAM531EzLKq08cKpr5X0cFXhrNqrWQ2FfVuA9JkqW+GAMff51r6Set1
        rOYFJB7gOd/y0iY8MOv6PjzQzAhNgfjdSgzb2sxLwEuJnE2D
X-Google-Smtp-Source: ABdhPJx6QiXqNu7Hfc+O/DrzAKwtgSlzMWab3H3rNwlyXnrdxwZcfwS7rfCEn4d1tGHD0uzTYSEiyrI+miyx42y9AEkxASphiUL7
MIME-Version: 1.0
X-Received: by 2002:a6b:a10:: with SMTP id z16mr1105244ioi.204.1640080328753;
 Tue, 21 Dec 2021 01:52:08 -0800 (PST)
Date:   Tue, 21 Dec 2021 01:52:08 -0800
In-Reply-To: <000000000000c70eef05d39f42a5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000066073805d3a4f598@google.com>
Subject: Re: [syzbot] general protection fault in set_task_ioprio
From:   syzbot <syzbot+8836466a79f4175961b0@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, changbin.du@intel.com,
        christian.brauner@ubuntu.com, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        kuba@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit e4b8954074f6d0db01c8c97d338a67f9389c042f
Author: Eric Dumazet <edumazet@google.com>
Date:   Tue Dec 7 01:30:37 2021 +0000

    netlink: add net device refcount tracker to struct ethnl_req_info

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10620fcdb00000
start commit:   07f8c60fe60f Add linux-next specific files for 20211220
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12620fcdb00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14620fcdb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2060504830b9124a
dashboard link: https://syzkaller.appspot.com/bug?extid=8836466a79f4175961b0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12058fcbb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17141adbb00000

Reported-by: syzbot+8836466a79f4175961b0@syzkaller.appspotmail.com
Fixes: e4b8954074f6 ("netlink: add net device refcount tracker to struct ethnl_req_info")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
