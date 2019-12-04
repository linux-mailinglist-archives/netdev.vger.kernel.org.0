Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162261130C1
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 18:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbfLDRZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 12:25:01 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:34460 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbfLDRZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 12:25:01 -0500
Received: by mail-il1-f197.google.com with SMTP id l13so275603ils.1
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 09:25:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=7EBHqRzY74ZGF4tFe8/2rCfanQYl+zaLWG2jjw2sqJU=;
        b=QeSWX0AIaGQ73Xpc3oURSL6gC2KLzLHHC+vq85scQRPLQ5mQmTl/d+YOhhdH2vCyHN
         TzfAgQzf7GfIWjgqqXzCAfuKOYTqXNOJDuGi6fULRlGvVO6FkGzW0mpeBzTW1CrqDec2
         APC32zQ6oazyW8WEXg3U0mZ6WgIdEzegh6rAf6eUogf9xC5leBjcXMz2R0HMmyXotggp
         G17Rt+swMKUb/stoM64kHn77ND5BRm1CCgFQc2VMi9e6l/KwUnaL9hBsOZUbCOmqNDn7
         xmh5wOciCEZ2i4UETwPWfoCpvRWnltH1+Qp1qXFxux+eN6Fbj76HlxvUuYHPX6c7rZwZ
         oyAA==
X-Gm-Message-State: APjAAAUEH2/vvBQ4ICPZIVU92CmMYiLmXLIOVa9pSzilzsMgxXMAYId5
        rntsREy+lMvnUAJeRdVakrE/JJ+FYOsdqxAp2Uds1WBXgkMG
X-Google-Smtp-Source: APXvYqwbE8j0A1R4STA165xAE2o2CZhzCyPUxcpg0HmtPL7kxTLcb8QkM0tXoiQbRnp/I+pW3xAbBYhdXQBcSkEqCJmXhPMwQnNb
MIME-Version: 1.0
X-Received: by 2002:a05:6602:187:: with SMTP id m7mr3058050ioo.16.1575480300753;
 Wed, 04 Dec 2019 09:25:00 -0800 (PST)
Date:   Wed, 04 Dec 2019 09:25:00 -0800
In-Reply-To: <000000000000314c120598dc69bd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ad595a0598e417a6@google.com>
Subject: Re: BUG: unable to handle kernel paging request in pcpu_alloc
From:   syzbot <syzbot+82e323920b78d54aaed5@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andriin@fb.com, aryabinin@virtuozzo.com,
        ast@kernel.org, bpf@vger.kernel.org, christophe.leroy@c-s.fr,
        daniel@iogearbox.net, dja@axtens.net, dvyukov@google.com,
        glider@google.com, gor@linux.ibm.com, kafai@fb.com,
        kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 0609ae011deb41c9629b7f5fd626dfa1ac9d16b0
Author: Daniel Axtens <dja@axtens.net>
Date:   Sun Dec 1 01:55:00 2019 +0000

     x86/kasan: support KASAN_VMALLOC

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=166cf97ee00000
start commit:   1ab75b2e Add linux-next specific files for 20191203
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=156cf97ee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=116cf97ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=de1505c727f0ec20
dashboard link: https://syzkaller.appspot.com/bug?extid=82e323920b78d54aaed5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=156ef061e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11641edae00000

Reported-by: syzbot+82e323920b78d54aaed5@syzkaller.appspotmail.com
Fixes: 0609ae011deb ("x86/kasan: support KASAN_VMALLOC")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
