Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FBF404881
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 12:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhIIKdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 06:33:21 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:36462 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233370AbhIIKdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 06:33:20 -0400
Received: by mail-il1-f197.google.com with SMTP id s15-20020a056e02216f00b002276040aa1dso1595762ilv.3
        for <netdev@vger.kernel.org>; Thu, 09 Sep 2021 03:32:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wYGQ6jwHlyJRKwQ0wASVxdo20+iSeZwpNWcEYrVI0Mg=;
        b=lNlQcTDumvPEBtUPRCfA6WIGlRR90H2iSWkn73LkppPG3zK5r2dI1ZknAXnFJ/UrSW
         g7csLy8awpm+ljW/oD7OxY0+hXZUTZskqrAt5zl+hIa2IDycGKTYahW7BesUIvdaWAQB
         rvBOQIPajpm9uA5geLcPriEJkk9lxs96xFa+gqJfwltxhSWrzWPQ6l4YVPoMyRAVfPlQ
         jdQ0ixdY0YPNtWcBL8njPPAgnKAoa9j8lQAmZHtBMHi6ZVbRGyNnYtAZGab+63hBQzTY
         TLGsfp3JqyRiDN45JOkA/GXPiKtEkrE/rq8f8VHNsI8DA8aHnP1Awg6N3/nJXu8erXm8
         +RLg==
X-Gm-Message-State: AOAM533YsQRZkMDAT+aP+1AFXkTwSBp5vM5QgoETTt2vLYmuk8Ot54b7
        nALveI1m7SSxwcI5f9uR+2aSaEGAXFafFPIQe+sMJhnuzs0r
X-Google-Smtp-Source: ABdhPJyLqRh/TbRtIHt72BPFNapbFg9OeSZoFGu+kZ/Sb6A9wM8KjD+jiurXOZXjz8P6xfgVBECN1lEOE5FmMsE/lX8rlWQ2Uj5i
MIME-Version: 1.0
X-Received: by 2002:a02:ba1a:: with SMTP id z26mr2259499jan.98.1631183531325;
 Thu, 09 Sep 2021 03:32:11 -0700 (PDT)
Date:   Thu, 09 Sep 2021 03:32:11 -0700
In-Reply-To: <0000000000006173bf05cb892427@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f2bcea05cb8d8266@google.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in hash_ipport_create
From:   syzbot <syzbot+a568bbab323b96631e61@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, w@1wt.eu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 7661809d493b426e979f39ab512e3adf41fbcc69
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 14 16:45:49 2021 +0000

    mm: don't allow oversized kvmalloc() calls

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15bb0a93300000
start commit:   626bf91a292e Merge tag 'net-5.15-rc1' of git://git.kernel...
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17bb0a93300000
console output: https://syzkaller.appspot.com/x/log.txt?x=13bb0a93300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=16e23f04679ec35e
dashboard link: https://syzkaller.appspot.com/bug?extid=a568bbab323b96631e61
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=178b5d0d300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16fad1dd300000

Reported-by: syzbot+a568bbab323b96631e61@syzkaller.appspotmail.com
Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
