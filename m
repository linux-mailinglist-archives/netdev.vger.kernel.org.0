Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519E925C574
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgICPdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 11:33:08 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:45045 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgICPdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 11:33:06 -0400
Received: by mail-io1-f69.google.com with SMTP id l8so2292214ioa.11
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 08:33:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=NOQoaI8MmUjTmRPzTkswBuSyXsa4TobuGT61RtxiEdk=;
        b=eQGY47x1UsB/HqsWImRfIVIjKMZaz+wR1clZIbdFTz/y2iEHGobJEhfa2ijHmrNBur
         86PWBVzwG3vq0+lne/oKq/N/pUYjCGPtujQwoFdTDH9Ddl+uSpWWm52degc3Bz1aaOFa
         uLjahBHfN3In+qa3lxkZi9G0lJv3GPVxRk/dPlw9h9jfeOWMvXXmoVKGnVppIBOXo+bQ
         AtMFMvcKrDzekfhA0wtwo5kXWctCrDzoceCeOpYMxRWRJElYt2xWgXWPPFOW3AyJ5KgB
         rxCOGg8h29xzZptMO60iQbLCJ6TZl7zZFzFsjB2LEyi3onnDnIzWjz+UHZKK08yZwOt0
         nSLQ==
X-Gm-Message-State: AOAM531uZWeQLjXXgtDwEjOcu3X/0poNlMi3T2NPwhkUfeba2coPpd/F
        jVbQyXX3USoGCDpa/YKCxRrhdkbO90qNuw1hIp/ufrikEAh1
X-Google-Smtp-Source: ABdhPJy/G9JyxC5525578EvfqwJfRzuzFC+hyFWJWTSwCgZXoOjSHHNx7mjShsCPPxJCqgHLR1nJSK3dV9yrHHRIfOtDrEoegrlw
MIME-Version: 1.0
X-Received: by 2002:a6b:6016:: with SMTP id r22mr3664364iog.42.1599147186374;
 Thu, 03 Sep 2020 08:33:06 -0700 (PDT)
Date:   Thu, 03 Sep 2020 08:33:06 -0700
In-Reply-To: <00000000000014fd1405ae64d01f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fcd01005ae6a77e7@google.com>
Subject: Re: INFO: task hung in tcf_ife_init
From:   syzbot <syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com>
To:     davem@davemloft.net, eric.dumazet@gmail.com, jhs@mojatatu.com,
        jiri@mellanox.com, jiri@resnulli.us, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vladbu@mellanox.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 4e8ddd7f1758ca4ddd0c1f7cf3e66fce736241d2
Author: Vlad Buslov <vladbu@mellanox.com>
Date:   Thu Jul 5 14:24:30 2018 +0000

    net: sched: don't release reference on action overwrite

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14ae08e9900000
start commit:   1996cf46 net: bcmgenet: fix mask check in bcmgenet_validat..
git tree:       net
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16ae08e9900000
console output: https://syzkaller.appspot.com/x/log.txt?x=12ae08e9900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0437fdd630bee11
dashboard link: https://syzkaller.appspot.com/bug?extid=80e32b5d1f9923f8ace6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=161678e1900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14f826d1900000

Reported-by: syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com
Fixes: 4e8ddd7f1758 ("net: sched: don't release reference on action overwrite")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
