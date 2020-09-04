Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E15925D472
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 11:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbgIDJRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 05:17:12 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:47617 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729824AbgIDJRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 05:17:09 -0400
Received: by mail-il1-f199.google.com with SMTP id l6so2860504ilm.14
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 02:17:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=A0XXOCOsCKpVbiOmCtSMND7R8pvo4WiohDym5VmGicM=;
        b=G40eY8vKJnz63Z7Jm0CYR6dkIyT5uhYFE8pQk+NiiNcdCp8NRCteWsGnpZ36NJ5Acg
         FY5n7jArMJ+WxROL7IgI6bVFVa9qxaZ8/O2pIqBB7QwBuNwKi/0580gcZE2etIFUUv0P
         7C9DAfaUaXd5m4C15E7S0m6QwotjKdiIqnNCrNTso04wan7n0Bn38CSEtroN7tj4yRiv
         J5+56fXBBuXyQugnxV35QhRxO31ldPge4FGfDY+aqYL2aiKO/lHH7gFSjcPNr3z7lH7p
         OEmZkaREkrmOwCu/5UwLO701vPzdwNQjxjTIsftueUhINO2l2jVdt0CC8RDjQvGir8a+
         1FFg==
X-Gm-Message-State: AOAM530SLG5+OAqqzcZfb1ThxjZNpgfn2OhlXOWY2+PWmgRdcE+ZEPW8
        iQrOBr/e4fG4hfLckVHii4zTKAivJN1PnGZKsekjKsRJZ+ff
X-Google-Smtp-Source: ABdhPJz4l9diDvi6JeZoFv4l/8t/lebVi6lVVRaf0FpautrVybTTmaZYgtTJ+rMvN9/aU+pvBmFLgHlR3xJZ/DGghivcPWtVoGV3
MIME-Version: 1.0
X-Received: by 2002:a92:6606:: with SMTP id a6mr6903338ilc.128.1599211028247;
 Fri, 04 Sep 2020 02:17:08 -0700 (PDT)
Date:   Fri, 04 Sep 2020 02:17:08 -0700
In-Reply-To: <000000000000a358f905ae6b5dc6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000427d4405ae795514@google.com>
Subject: Re: KASAN: use-after-free Read in dump_schedule
From:   syzbot <syzbot+621fd33c0b53d15ee8de@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, leandro.maciel.dorileo@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vedang.patel@intel.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 7b9eba7ba0c1b24df42b70b62d154b284befbccf
Author: Leandro Dorileo <leandro.maciel.dorileo@intel.com>
Date:   Mon Apr 8 17:12:17 2019 +0000

    net/sched: taprio: fix picos_per_byte miscalculation

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15464af9900000
start commit:   fc3abb53 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17464af9900000
console output: https://syzkaller.appspot.com/x/log.txt?x=13464af9900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e1c560d0f4e121c9
dashboard link: https://syzkaller.appspot.com/bug?extid=621fd33c0b53d15ee8de
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1129d0e9900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17fb6a25900000

Reported-by: syzbot+621fd33c0b53d15ee8de@syzkaller.appspotmail.com
Fixes: 7b9eba7ba0c1 ("net/sched: taprio: fix picos_per_byte miscalculation")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
