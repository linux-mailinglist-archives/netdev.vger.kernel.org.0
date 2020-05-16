Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B2D1D643C
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 23:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgEPV1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 17:27:06 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:53124 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgEPV1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 17:27:05 -0400
Received: by mail-il1-f197.google.com with SMTP id m7so4457043ill.19
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 14:27:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=f3hko+0TXM3ZTxTzVXQjaXqhvt2WnzZbWWNxH4vk64g=;
        b=PNwz0Xr8Ojt6NvcKzci1zQDxUwN6Hx39SPMi8+/vMu1iUtMEfZ+zpWvSz+f2vuAC47
         5kmHFDhEvrLpC/E0bt5406Eb7i6ubIePybOnUrRgCGPzeb6fnAMJ7CJParN/owre897L
         sZcf41sa7lDedBfzqjcr9oy7bfsA0d4NMAM2AqSzdH7R7Lo6PpuSmUPqY2iDF2S7VH7h
         1SM+JEse6B2BVhp8QdD2E9mN7DFaPk9iIVbucBM67xuyAOOYFtU7yTpK/ba0ghypcY1B
         1XfVf0taI2qvOOukLGMO6dHcEV1DkaWjdmTrFuyPLFnSDfsJuiourWmb2Xr5ltdg8c2m
         CiJQ==
X-Gm-Message-State: AOAM532h95Po1NRVSEGp9fdbGqerTuh9RINgVy9YyJ6CWyxHG3paY6p+
        mvshEWqeWCCVIQ8jjWPo6+297mebpYaCjelmZxdHCOiintZL
X-Google-Smtp-Source: ABdhPJz0cH5oPpV8Crm3N4eRME8yr4YUcg2zWCEKfV1oaXJx6vivQpTeE+zffP6GmIpSFnRS9D7COeZSShOVJTZOtPesbiPzsDog
MIME-Version: 1.0
X-Received: by 2002:a02:860e:: with SMTP id e14mr1019310jai.109.1589664423356;
 Sat, 16 May 2020 14:27:03 -0700 (PDT)
Date:   Sat, 16 May 2020 14:27:03 -0700
In-Reply-To: <0000000000003692760578e651dd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000044329005a5ca97eb@google.com>
Subject: Re: KASAN: use-after-free Write in hci_sock_release
From:   syzbot <syzbot+b364ed862aa07c74bc62@syzkaller.appspotmail.com>
To:     bigeasy@linutronix.de, davem@davemloft.net, dvyukov@google.com,
        jack@suse.cz, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org, mmarek@suse.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit f1e67e355c2aafeddf1eac31335709236996d2fe
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Nov 18 13:28:24 2019 +0000

    fs/buffer: Make BH_Uptodate_Lock bit_spin_lock a regular spinlock_t

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1761ce06100000
start commit:   645ff1e8 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=7308e68273924137
dashboard link: https://syzkaller.appspot.com/bug?extid=b364ed862aa07c74bc62
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=152532bb400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13f73320c00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: fs/buffer: Make BH_Uptodate_Lock bit_spin_lock a regular spinlock_t

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
