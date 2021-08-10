Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE5A3E7C60
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 17:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243240AbhHJPfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 11:35:12 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:44017 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243246AbhHJPfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 11:35:00 -0400
Received: by mail-io1-f71.google.com with SMTP id 123-20020a6b14810000b029058718ca54cfso10827006iou.10
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ezvPuPtMzOuRLqecX2VTZ2ztz0IyxYGYWNq3bM8LvCs=;
        b=sgWXHqBT3UUoo14ZOiagUeSme3+xDCtxNuam7VIBKGvXGQ0j4y/R8JPuJyx8wx1u3H
         +b8yBHRfR2Ifw7Gw1erjwU332i6RJD0F+OO4Q6t+Yix/jXRKg4yk6g2YdTCgyM7RuGAg
         Cn4hDCJzK7DlFgm9y5Zhbk3F+9PXQQcSs78SuyLrCS4sy/sN3bqVERiAONslPXqVnSdR
         yga+tpH8o3ZFgX2Oiv5Alva0Twtv1RNFW9SSH1U7TN2R5tsIq4prP+ezmn2kF6UlombV
         CDQSywXfrR79nKA9vYeF9QFh8oTQrpLL3TYDWo3WyOWV6Crbgmp0DplnPkJLOJmWjJDG
         SmYQ==
X-Gm-Message-State: AOAM531xB0xIlODucSfyQBV7dev9YnBtfjo9s0KSIsOPPYTKLY7eXJ3j
        kUEuqmgj7wQ2yYfk2T0wCmpy0iw/h6Uqp8mZ3sCsJpIVim1d
X-Google-Smtp-Source: ABdhPJxUNwqzmK5BP4xy5zYm2dHKjVhr9kXAul5tmQWBzbKn7f/vtTtKsjuaPj76egcfQsjLcONIB+8s6JEZ9u6yEHxs1CkpszEd
MIME-Version: 1.0
X-Received: by 2002:a5d:9ac1:: with SMTP id x1mr16641ion.191.1628609652476;
 Tue, 10 Aug 2021 08:34:12 -0700 (PDT)
Date:   Tue, 10 Aug 2021 08:34:12 -0700
In-Reply-To: <0000000000007faf7505c91bb19d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d04e9b05c9363bf1@google.com>
Subject: Re: [syzbot] general protection fault in hwsim_new_edge_nl
From:   syzbot <syzbot+fafb46da3f65fdbacd16@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, alex.aring@gmail.com, bp@alien8.de,
        davem@davemloft.net, frederic@kernel.org, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kuba@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, mark.rutland@arm.com,
        masahiroy@kernel.org, mingo@redhat.com, mudongliangabcd@gmail.com,
        netdev@vger.kernel.org, npiggin@gmail.com, pbonzini@redhat.com,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rostedt@goodmis.org, seanjc@google.com, sedat.dilek@gmail.com,
        stefan@datenfreihafen.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vitor@massaru.org, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 997acaf6b4b59c6a9c259740312a69ea549cc684
Author: Mark Rutland <mark.rutland@arm.com>
Date:   Mon Jan 11 15:37:07 2021 +0000

    lockdep: report broken irq restoration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13927981300000
start commit:   d09c548dbf3b net: sched: act_mirred: Reset ct info when mi..
git tree:       net
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10527981300000
console output: https://syzkaller.appspot.com/x/log.txt?x=17927981300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=343fd21f6f4da2d6
dashboard link: https://syzkaller.appspot.com/bug?extid=fafb46da3f65fdbacd16
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=152ee39e300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15946ff1300000

Reported-by: syzbot+fafb46da3f65fdbacd16@syzkaller.appspotmail.com
Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
