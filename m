Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445B518E922
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 14:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgCVN3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 09:29:04 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:45855 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgCVN3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 09:29:03 -0400
Received: by mail-il1-f199.google.com with SMTP id p15so5842733ils.12
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 06:29:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=jmLK9Nx0sV4n9spz6FizKEO/UiXLat+guCFQpWcvF0A=;
        b=M3MUIiHWfqSlGwOY5U8LO2BIdUe1wxaaWvzYzYM6Lod5PE3oYLWsTpbyjUmZubNUnZ
         0JQHXwhNz+cn0PQGqP13AFHQ7txq7WcAM8UGLx2cSN5QOwyPJCphWUyBlM5TZwBPFYyI
         SCMVu7YYbsZhlkgbqGXQyteCg/cTAnNb2npkIQngoM814wcLhjDAwttwf4lQL48+6DkU
         p/hz5kOg6CqqD1nfbfQ1zy3Ik80Ro73ODVNC4PnKBBl1xA9pMCT+Eu/HSD7RqfYev4ve
         tw9upPh52EfE2ic/Q4g6EqP7kWdvGJ3syfaF1X8Vy5LOT+BuYn9nP5dl1F7XuwAx4kVg
         TpYQ==
X-Gm-Message-State: ANhLgQ3+gh6sXzZo3nIdo5erj7cfgxdjjFrCHa2UfCKOQrEG7zmEG53Z
        Rie95c6QQ3EEuSBWAJ9HjfOf19LeNTijEPnR0pAKn4N4Rd5+
X-Google-Smtp-Source: ADFU+vuxGqce5HdcWsT4uwnV72WS992615JlGUhT5JCgdY61XjgcaVQW8M8Cui/rAj31oWjxi4kC07HBUM/mm6t6pOUvYSxhRcSr
MIME-Version: 1.0
X-Received: by 2002:a05:6638:398:: with SMTP id y24mr5155770jap.125.1584883742893;
 Sun, 22 Mar 2020 06:29:02 -0700 (PDT)
Date:   Sun, 22 Mar 2020 06:29:02 -0700
In-Reply-To: <000000000000277a0405a16bd5c9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008172fe05a17180aa@google.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in handle_external_interrupt_irqoff
From:   syzbot <syzbot+3f29ca2efb056a761e38@syzkaller.appspotmail.com>
To:     bp@alien8.de, clang-built-linux@googlegroups.com,
        davem@davemloft.net, dhowells@redhat.com, dvyukov@google.com,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kuba@kernel.org, kvm@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit f71dbf2fb28489a79bde0dca1c8adfb9cdb20a6b
Author: David Howells <dhowells@redhat.com>
Date:   Thu Jan 30 21:50:36 2020 +0000

    rxrpc: Fix insufficient receive notification generation

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1483bb19e00000
start commit:   b74b991f Merge tag 'block-5.6-20200320' of git://git.kerne..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1683bb19e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1283bb19e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6dfa02302d6db985
dashboard link: https://syzkaller.appspot.com/bug?extid=3f29ca2efb056a761e38
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1199c0c5e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15097373e00000

Reported-by: syzbot+3f29ca2efb056a761e38@syzkaller.appspotmail.com
Fixes: f71dbf2fb284 ("rxrpc: Fix insufficient receive notification generation")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
