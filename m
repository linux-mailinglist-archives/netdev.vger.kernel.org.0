Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0688A149E78
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 05:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgA0EBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 23:01:07 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:41879 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgA0EBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 23:01:04 -0500
Received: by mail-io1-f69.google.com with SMTP id z201so4784487iof.8
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 20:01:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=VgaYY37/arJ//cWZJnlZvZwtZBPazlQXq/CIao1WfmQ=;
        b=N/0uuFJHEUN9qTnESYI3r4JWsxr9I7Pf6h//YGU0MkA6zLME7ZlAdiz8a8FbYblqTu
         UU80c197i/Azb+iXPgPXmMmGO+GEPmbQa/oRt+GDUV92bJ3rpoYQF9okT/j7YPanweQz
         DMQIltFc57PuzTiYtH4TGBcBwuCD5iZ7+QPl9LslZLvIyJsoV9NwT+M7cyRkqBnBTr2F
         y1MMMPchWNGmbm7VXWU7xZkoK2fXp4Y7SD/5C3z1ZlY/uhlvUnjY5fl4PcANkLmcKxGT
         rqb9twRXsvxLg46H2ry9lqSbd+G9E/aNGE9xLrlg3tdbGwl/QsCsnDJYLh2LRXZTpl7/
         KksQ==
X-Gm-Message-State: APjAAAVJOvO/uMMvCsFqMQvysSIuBtGWC15vnWNJFB3zA+yuC8CQIVjx
        hSjK9f8RyJV/qJplMCz+FUVmQDTnoOq5REfS4s80eHMQgHhX
X-Google-Smtp-Source: APXvYqysxyvWoFV1hsXw8Jkg2vzZtt8Wscf4J2wj8nn/VWMlh9MEbn8dzfvU/rqOy4eKy13jsOByr26t5WOoeFH66a7eL6jBTpI/
MIME-Version: 1.0
X-Received: by 2002:a02:864b:: with SMTP id e69mr11540998jai.83.1580097663218;
 Sun, 26 Jan 2020 20:01:03 -0800 (PST)
Date:   Sun, 26 Jan 2020 20:01:03 -0800
In-Reply-To: <000000000000dd68d0059c74a1db@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ed3a48059d17277e@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ip_add
From:   syzbot <syzbot+f3e96783d74ee8ea9aa3@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, allison@lohutok.net,
        aryabinin@virtuozzo.com, coreteam@netfilter.org,
        davem@davemloft.net, elver@google.com, fw@strlen.de,
        gregkh@linuxfoundation.org, info@metux.net, jeremy@azazel.net,
        kadlec@netfilter.org, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 751ad98d5f881df91ba47e013b82422912381e8e
Author: Marco Elver <elver@google.com>
Date:   Fri Jul 12 03:54:00 2019 +0000

    asm-generic, x86: add bitops instrumentation for KASAN

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1287db66e00000
start commit:   244dc268 Merge tag 'drm-fixes-2020-01-19' of git://anongit..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1187db66e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1687db66e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=f3e96783d74ee8ea9aa3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1104c495e00000

Reported-by: syzbot+f3e96783d74ee8ea9aa3@syzkaller.appspotmail.com
Fixes: 751ad98d5f88 ("asm-generic, x86: add bitops instrumentation for KASAN")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
