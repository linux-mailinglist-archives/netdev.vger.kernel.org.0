Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4864A6E7B
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 11:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245546AbiBBKRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 05:17:10 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:50907 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbiBBKRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 05:17:08 -0500
Received: by mail-il1-f198.google.com with SMTP id m9-20020a92cac9000000b002bafb712945so10533182ilq.17
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 02:17:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=T4JU1DoNJxSChrqfuHiopIuSM4M9SJ+2CDXtqoAN2Pk=;
        b=bofKQmU7VGxWpFwwKYo70Y0qvDxYlI0R1Xq8pvO/VTNMHUih8L3dr8DjdB0Q7wahlf
         u+3d+SVPyzO3jkYhAl+ueJkJYreaBbnumQxnCZIZgFaWNkH0BTmjbS0ZCrNi2L4LcbiK
         aJrHtO+ZKSA4iTKasBDjkhIrd0XSN7FpzY9eWfVq2CepbSDM+ohr3MnhafgbXVAHtUnD
         gEYlvJjypW2aVpcKMRlQvUN2CKgleENfroUA+dcqJ+C/y7OmWSzcUAqI+xuoF2tMTPOA
         edRiGNXY7vU2aDTtYUUrytVfkoWXhEXsEvvO/W0ol+Q4L3kBeLmaPIOhyGwAIcYjNa1s
         UItw==
X-Gm-Message-State: AOAM53127CHaYe9N/wH+I8c2T7QculZxv4wkRRaJ34/ByPKZghaqLlyp
        SpgK/NxaWxaCwiF4vVNqII2DB5lXPkL2hTaw460j1/WT/Zg+
X-Google-Smtp-Source: ABdhPJw4KeUmCBVwdZfxRK0hXg1ocwqu6RnrmCRYKKNjNwZR7QIHqD5U3iE9JlZq3uGjGDOB4y0gjrFGMpmgO6wluB+daBCTCT/6
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1561:: with SMTP id k1mr18620390ilu.146.1643797028546;
 Wed, 02 Feb 2022 02:17:08 -0800 (PST)
Date:   Wed, 02 Feb 2022 02:17:08 -0800
In-Reply-To: <0000000000000560cc05d4bce058@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f82ecc05d706513d@google.com>
Subject: Re: [syzbot] general protection fault in hidraw_release
From:   syzbot <syzbot+953a33deaf38c66a915e@syzkaller.appspotmail.com>
To:     benjamin.tissoires@redhat.com, changbin.du@intel.com,
        christian.brauner@ubuntu.com, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        jikos@kernel.org, kuba@kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit e4b8954074f6d0db01c8c97d338a67f9389c042f
Author: Eric Dumazet <edumazet@google.com>
Date:   Tue Dec 7 01:30:37 2021 +0000

    netlink: add net device refcount tracker to struct ethnl_req_info

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15179fa8700000
start commit:   9f7fb8de5d9b Merge tag 'spi-fix-v5.17-rc2' of git://git.ke..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17179fa8700000
console output: https://syzkaller.appspot.com/x/log.txt?x=13179fa8700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3e56c9b92aaaee24
dashboard link: https://syzkaller.appspot.com/bug?extid=953a33deaf38c66a915e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fff530700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=106469f0700000

Reported-by: syzbot+953a33deaf38c66a915e@syzkaller.appspotmail.com
Fixes: e4b8954074f6 ("netlink: add net device refcount tracker to struct ethnl_req_info")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
