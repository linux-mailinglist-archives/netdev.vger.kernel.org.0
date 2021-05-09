Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27BA377854
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 21:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhEITxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 15:53:13 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:51754 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhEITxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 15:53:12 -0400
Received: by mail-il1-f199.google.com with SMTP id b1-20020a92dcc10000b02901b79d339165so4331207ilr.18
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 12:52:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=001ucYqBcq5hHetM/YG6b6qU6lfZlfM5MsOotoGLw6s=;
        b=ayQi8XOOvp70kDe0TyxKQ1RsYZZD26xP1MBLrNmq5gLowN/grbx7qwzGZKnzOj+Mqj
         ONbKfLr/GqAcd3gnQftf4nfg4fYpdyhPla1PLnGDgkxUc9Wj1m/4anm+ClEI08X/R8DZ
         K6wr1vxboueNMBqarAfSDeieWH+cut314XrqfjIlLpvkXNhRt3ZX049MXx4xLtPq9YWe
         6K3UmMppaG4g83tvhyVXORL2btLOvtqQKT4wddq8CwoeFdBnD7nXUQyrK0/m7FMDJpRI
         QQIUnnVYQuj/bAsr4VB35OWV0V7M49Wfreu7WbaY/ntedWF4UZ2Obi5VkHbQ7TPcusgy
         XnZQ==
X-Gm-Message-State: AOAM531yGj/A4npbOlTUpsnSgya64CrPir1zgjfyGyvqwhX1bBZaE0SF
        ytd56TfykjbYB0EIAakHAnnpcTx4dmjGp2D+uyLl/+CmAv/l
X-Google-Smtp-Source: ABdhPJzed5HQDQb/w0WLy/sSJ5scMD00J53TAphMc4LFvXlIfruUmkRJV2bYpKP9zlVDzT0+x6AdHe2Mir7a8+KTzmCONeHtZ8K+
MIME-Version: 1.0
X-Received: by 2002:a92:510:: with SMTP id q16mr5942373ile.41.1620589927542;
 Sun, 09 May 2021 12:52:07 -0700 (PDT)
Date:   Sun, 09 May 2021 12:52:07 -0700
In-Reply-To: <000000000000cc615405c13e4dfe@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f532ab05c1eafe35@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in nfc_llcp_put_ssap
From:   syzbot <syzbot+e4689b43d2ed2ed63611@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, bp@alien8.de, davem@davemloft.net,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kuba@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, masahiroy@kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, pbonzini@redhat.com, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rostedt@goodmis.org, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, will@kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 997acaf6b4b59c6a9c259740312a69ea549cc684
Author: Mark Rutland <mark.rutland@arm.com>
Date:   Mon Jan 11 15:37:07 2021 +0000

    lockdep: report broken irq restoration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14af741dd00000
start commit:   95aafe91 net: ethernet: ixp4xx: Support device tree probing
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16af741dd00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12af741dd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7668018815a66138
dashboard link: https://syzkaller.appspot.com/bug?extid=e4689b43d2ed2ed63611
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15ed2663d00000

Reported-by: syzbot+e4689b43d2ed2ed63611@syzkaller.appspotmail.com
Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
