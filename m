Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6B63EC2C6
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 15:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238448AbhHNNHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 09:07:41 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:56106 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238396AbhHNNHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 09:07:33 -0400
Received: by mail-il1-f198.google.com with SMTP id c16-20020a92cf500000b02902243aec7e27so3653458ilr.22
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 06:07:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=t5YQUGSZE6EI9BhxfatfxY8kQRFsuaqSI5BxeVjzuZ0=;
        b=hQ2ByZotT6RPbSYpMjkTqU6THXMvELk56gORAbslVgF6VdB5cxtfOqIni9Z1GW+Cww
         wFB2FMxPzAH5X+QcgnDrWgGP8uULiDL6vUjdgliSt9Nnm6Zp4NKnz6qtCJdtTl3bT0xZ
         L4VL0D/0BetMnaHtNcsSeJpjoyp17PvSMim6IavWETKCiTT56ZhpHBJ4oFJGPtZSUn6S
         8TJlI5SRwugoC0h00FWHi/JlnExCL+Pk6unfObMYb4LNvkKrX01GdLMK9y2tpkitl5no
         6hfgtClMeAhabU1RU3h9i60i5q49PzrtnWeMYAiFZZoGgDvxKf4oVO1OW3TT0bI6MCmF
         UAhQ==
X-Gm-Message-State: AOAM5300354RbKUnPoCoCUgha9zoHO/ECD3ZpV9rFdICaWQrH819ER+/
        qrFs9UHVzQ1h0ZXudYwAbhgSjbukjLtrMkRr2SUjaj2Ee1wf
X-Google-Smtp-Source: ABdhPJy2AvLguRSMEmfyW87t0JS484ypKZ9GNlz2YX0HW0onFVHA9gtYaOLblHldyW0ZHNRgbBvtlICabAwh4/WuQloazRiOUvWa
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17cf:: with SMTP id z15mr2152427ilu.103.1628946425097;
 Sat, 14 Aug 2021 06:07:05 -0700 (PDT)
Date:   Sat, 14 Aug 2021 06:07:05 -0700
In-Reply-To: <00000000000006e7be05bda1c084@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000006b42305c984a5d3@google.com>
Subject: Re: [syzbot] general protection fault in scatterwalk_copychunks (4)
From:   syzbot <syzbot+66e3ea42c4b176748b9c@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, bp@alien8.de,
        daniel@iogearbox.net, davem@davemloft.net,
        herbert@gondor.apana.org.au, hpa@zytor.com,
        john.fastabend@gmail.com, kuba@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vfedorenko@novek.ru, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 635d9398178659d8ddba79dd061f9451cec0b4d1
Author: Vadim Fedorenko <vfedorenko@novek.ru>
Date:   Wed May 20 08:41:44 2020 +0000

    net/tls: free record only on encryption error

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=144095e6300000
start commit:   f8fbb47c6e86 Merge branch 'for-v5.14' of git://git.kernel...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=164095e6300000
console output: https://syzkaller.appspot.com/x/log.txt?x=124095e6300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=171d57d5a48c8cad
dashboard link: https://syzkaller.appspot.com/bug?extid=66e3ea42c4b176748b9c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13b8db9e300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c21581300000

Reported-by: syzbot+66e3ea42c4b176748b9c@syzkaller.appspotmail.com
Fixes: 635d93981786 ("net/tls: free record only on encryption error")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
