Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6837D01F
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 23:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730826AbfGaVcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 17:32:01 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:45808 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbfGaVcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 17:32:01 -0400
Received: by mail-io1-f70.google.com with SMTP id e20so76222672ioe.12
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 14:32:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=f0dy6kexOd2FnIvWJ+xs8RuUZn++/g3nMaxpfE04Ep0=;
        b=oQP1722fjxx6BtrprucYZo5AOwVK/upoo1rZCfNPMYk5UOC4ZtVBQYYJ5MPaTIh9Jf
         fcRlwtx01CYSa9D53L1NeasktBS74R0InqRNAVhLPXfw2czCsRaWy/Ui6SIw5l3o2ImG
         Ky4T7F1xXZkXjooQKiIuOasVWQsJS2IfgXtJMZPYQb7UrZjbp+r9uMonqD9vGrE6gXMz
         Htvg6xHPSa7FNolG8WS8D+UJhWxpKlvNwAvYni9IuvT2i00gfgVRGKncJMpDAdi69WMv
         Klz/HCS32y6IadvK7P+jxReTAYDiJU5hAici4xIz6Pfh/mIENasOH3HT/+pY4Kilc9pX
         iSWA==
X-Gm-Message-State: APjAAAXkDFsz7QLCzhiq80VQWhcuVfDhGnkLRNHpnFeW13PNckZPSfyE
        ia9VdplCnEqxNxje+30Xbuo4ygfnOfsFU6ap5w8IeI3uGFED
X-Google-Smtp-Source: APXvYqwVPz+8gD0GBmy3CsE0op/bI4tHp70A9CTOcj/3hT40iRHICuhe/dAtU7/Fw6Klat0pJPM5AyBuP8aWPA3vxEXR67WnoJpp
MIME-Version: 1.0
X-Received: by 2002:a02:914c:: with SMTP id b12mr83757999jag.105.1564608720391;
 Wed, 31 Jul 2019 14:32:00 -0700 (PDT)
Date:   Wed, 31 Jul 2019 14:32:00 -0700
In-Reply-To: <000000000000e42667058e554371@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fdd90c058f00daca@google.com>
Subject: Re: KASAN: use-after-free Read in nr_rx_frame (2)
From:   syzbot <syzbot+701728447042217b67c1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dvyukov@google.com,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ralf@linux-mips.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit c8c8218ec5af5d2598381883acbefbf604e56b5e
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jun 27 21:30:58 2019 +0000

     netrom: fix a memory leak in nr_rx_frame()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=122ddaec600000
start commit:   629f8205 Merge tag 'for-linus-20190730' of git://git.kerne..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=112ddaec600000
console output: https://syzkaller.appspot.com/x/log.txt?x=162ddaec600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e397351d2615e10
dashboard link: https://syzkaller.appspot.com/bug?extid=701728447042217b67c1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a6e008600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11937d92600000

Reported-by: syzbot+701728447042217b67c1@syzkaller.appspotmail.com
Fixes: c8c8218ec5af ("netrom: fix a memory leak in nr_rx_frame()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
