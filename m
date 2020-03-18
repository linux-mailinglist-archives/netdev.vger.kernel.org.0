Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 569341893D9
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 02:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgCRB7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 21:59:04 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:34824 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgCRB7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 21:59:04 -0400
Received: by mail-il1-f198.google.com with SMTP id c18so695994ils.2
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 18:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0HNo1qd7HDCjZwp/AckavVWsU51cjSgzVKKMqeaV0/Q=;
        b=mKP0T7LmZG9QKtufbCTIOrZ05qM8g4qYLtyJIkFq8C6pkRY15ZhEanf3GjMsfSW38E
         DL13V2XsPySRe2HFWHUe1g5+eBUO0dw2i/6Lw248l8xF0vLghxx43k4aTMYt1syMz363
         KEe1wvPhsLvM7NGRavabax/vE32XSqLqSdPk9iqcKSbNjPhJfnaIHn2emugqiWG7RCsx
         59h0kfH7oPvPAywJmQDdziSbygr/h60v5cjbc2N7qP4mLolkHutJ86MpANDHbJqF2yEx
         lvrdKK7kni+KX8JtZuyLpq60OzCzbNLZQA5EhmXAh834sPIcSsnZZiYpk5oqR6wGLurC
         j0Jg==
X-Gm-Message-State: ANhLgQ0O2yW0zselMEiSEA+VNj2CU7mxzBTmc8l6WWy13y8KqGXJN64J
        HoFYA9Q7vuIbJ3+FbmZv4O9HfxEmR0BnOGll3wGC2CRLt4+N
X-Google-Smtp-Source: ADFU+vsJ30sc+Dzh9VHBJOAI0emX3Sfo1QftuTzYodRR9NKuh9cYqsuC48zEhQnxNxrdJ3ulsDA9CbCBEePqgxPvqlJYkrCy3Jwf
MIME-Version: 1.0
X-Received: by 2002:a5d:8f96:: with SMTP id l22mr1608247iol.19.1584496743564;
 Tue, 17 Mar 2020 18:59:03 -0700 (PDT)
Date:   Tue, 17 Mar 2020 18:59:03 -0700
In-Reply-To: <00000000000088487805a116880c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008c4f0805a11765a0@google.com>
Subject: Re: KASAN: use-after-free Write in tcindex_change
From:   syzbot <syzbot+ba4bcf1563f90386910f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 599be01ee567b61f4471ee8078870847d0a11e8e
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon Feb 3 05:14:35 2020 +0000

    net_sched: fix an OOB access in cls_tcindex

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14dbc973e00000
start commit:   fb33c651 Linux 5.6-rc6
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16dbc973e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12dbc973e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6dfa02302d6db985
dashboard link: https://syzkaller.appspot.com/bug?extid=ba4bcf1563f90386910f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1748dfdde00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16afffdde00000

Reported-by: syzbot+ba4bcf1563f90386910f@syzkaller.appspotmail.com
Fixes: 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
