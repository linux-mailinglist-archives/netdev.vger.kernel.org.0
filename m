Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C29F3F3605
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 23:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240652AbhHTV35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 17:29:57 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:55277 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237534AbhHTV3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 17:29:53 -0400
Received: by mail-il1-f200.google.com with SMTP id r6-20020a92c506000000b002246015b2a4so6102726ilg.21
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 14:29:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=irP4+a4MqOno9gjzxCYV4LkdM8U6+CH4E7PsJC0/pm4=;
        b=sjxJHi5XOsSQXs0MnU61d3vN5BIXBylWzi6Sl64gIJ+Mlfw+0V+cBeRNts5g5dpBy2
         8JVvS/0nFSdR1mgYahP/KE2mGU4gdZ4n/52qX1eEIhKGCWEQOd3QyauQut8jALZ4GAkT
         vlpQnZplkHi5bZCTBwONBMWI6g7Pypf0IBFE7Yt3H2DXp6LPAfeDZ8WxN4rp79AU8Mv3
         La9PNSr6D/KKGJpDF7STuDeIsODjyoSxFNbg0dPpeQj6ZVA6q4k0F5Pv2QgmLLelH7kP
         8Q4tqd/aSYt4g6V44Jcc3sffXHF7xq9KCGKsqs4tsHCCyE+rODxwK/AAZB/unDomujZn
         QF/A==
X-Gm-Message-State: AOAM5330PgA0CZxb/yjutY41tO6PvR9vHZncwk0uDJLG0txI2Iv73/p1
        gGr+noe+IawG22OJ1g2GppqyelvvwzZS7gHPP0OS9a1jKgEH
X-Google-Smtp-Source: ABdhPJzwQnqnBvNJw3VYBFYSQJOZJNIfjhdUk4XZi5YP/GetgfyT4o7ZYLOJzWzalZHwhX6L41qpYmxt/NbXjWGg30XqrAwCrd24
MIME-Version: 1.0
X-Received: by 2002:a92:7108:: with SMTP id m8mr10061663ilc.238.1629494954973;
 Fri, 20 Aug 2021 14:29:14 -0700 (PDT)
Date:   Fri, 20 Aug 2021 14:29:14 -0700
In-Reply-To: <0000000000000845ce05c9222d57@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f460a305ca045b3e@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in nf_tables_dump_sets
From:   syzbot <syzbot+8cc940a9689599e10587@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 6001a930ce0378b62210d4f83583fc88a903d89d
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Feb 15 11:28:07 2021 +0000

    netfilter: nftables: introduce table ownership

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12d34475300000
start commit:   f9be84db09d2 net: bonding: bond_alb: Remove the dependency..
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11d34475300000
console output: https://syzkaller.appspot.com/x/log.txt?x=16d34475300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8075b2614f3db143
dashboard link: https://syzkaller.appspot.com/bug?extid=8cc940a9689599e10587
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fbb98e300000

Reported-by: syzbot+8cc940a9689599e10587@syzkaller.appspotmail.com
Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
