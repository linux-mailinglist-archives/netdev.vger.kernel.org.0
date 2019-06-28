Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0B055A543
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 21:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfF1TjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 15:39:02 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:49199 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfF1TjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 15:39:02 -0400
Received: by mail-io1-f70.google.com with SMTP id x24so7719240ioh.16
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 12:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6MBa60ZEQW0KfIiP0tSSYs5YVeMvKCMq2VKhW00PUqk=;
        b=lIMRxiU4KJa7C2kR1A9/TNyobMjWJX/+jkYLn/ziEO8X04/GUCDERELPCjBA0urQHw
         iSlCCewoL4ErKnSVzHqDCfU6P2qp2i6oQ5767HUp6x1DkoyPbqrTWb4eoBlbbcVUHk/a
         1nwenjlolCbnovM2pwLpZf4BeXrApua972B9LKPKS/sigZ3fpDtYcPYRBAoeQJDnp+lD
         lFhkIOn8yILg024jDI3rYYP3zcd/u/k/5ZQDfDR4qy9ai959IcWwRgl/rW3pT01bTebY
         xhog533ac/1unWojKFl8n2znhT49DHbBwd9BTjdZGK8qm+7TVIEdQUfP8lu3VT1rvDjO
         wHQQ==
X-Gm-Message-State: APjAAAWWLuIxC21j7CsJj0HYZson8pvlowKKa1KaUnX1lAJKzHltbB6v
        d4teyunrURYPhXzXdZnOSu5Z5WfshmMDGuBPbeJX4PRZLecF
X-Google-Smtp-Source: APXvYqyG9FhR3Hf0uDF4YrYl41IirAkp07VFEYWJqDIdjxISRyPh+xrAnO1HB/EouuP8G7Ie0xNGvLv/dNZy32m373iQYOFow0fw
MIME-Version: 1.0
X-Received: by 2002:a5d:97d8:: with SMTP id k24mr9240612ios.84.1561750741066;
 Fri, 28 Jun 2019 12:39:01 -0700 (PDT)
Date:   Fri, 28 Jun 2019 12:39:01 -0700
In-Reply-To: <0000000000001c03bf058baf488a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002628bf058c676e46@google.com>
Subject: Re: BUG: unable to handle kernel paging request in hrtimer_interrupt
From:   syzbot <syzbot+037e18398ba8c655a652@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        dvyukov@google.com, hdanton@sina.com, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit e9db4ef6bf4ca9894bb324c76e01b8f1a16b2650
Author: John Fastabend <john.fastabend@gmail.com>
Date:   Sat Jun 30 13:17:47 2018 +0000

     bpf: sockhash fix omitted bucket lock in sock_close

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14436833a00000
start commit:   29f785ff Merge branch 'fixes' of git://git.kernel.org/pub/..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16436833a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12436833a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e5c77f8090a3b96b
dashboard link: https://syzkaller.appspot.com/bug?extid=037e18398ba8c655a652
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16da8cc9a00000

Reported-by: syzbot+037e18398ba8c655a652@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
