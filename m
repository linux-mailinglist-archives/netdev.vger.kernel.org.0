Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFB1117D83D
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 04:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgCIDJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 23:09:03 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:56939 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgCIDJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 23:09:02 -0400
Received: by mail-il1-f198.google.com with SMTP id b17so6434565iln.23
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 20:09:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=WbPwkzgEPrAuJzlxX3CcbeuVGuo6guJ+1bROjxY+tqA=;
        b=nATJ4ujphQwOg0TJrRv18kuyVdEoZ7ZDak8XXWFISFCEo3xvz9PaSjpdevc3r127Nd
         gqfwP6n1cQqI6tsaYzK/Ye1PWnE9ofeD8BOI2C0xw4euIwID2JAYYVsvHz9e+yUjMGHt
         xNGQywY96g3S1dBWZ+PotnyNlv/WHelaDwmCB8XL2mqYdnU8E+6f+nbhAgXku1afDKeG
         UsOAgtFT0WSPbLo+UXXrTVCwkvSDQKmHPv4Sevna9ocjn4PYuzTLBReokZ+T9yjqR6ii
         vE/tuz9xcZaxzugdKAhlXcq9KAN+wPrhmZoKTA0sYJmWabrv2qp1Nh5d/lMceoaOGtrF
         e+4Q==
X-Gm-Message-State: ANhLgQ2hp2v2HhGIavldaawbk7QoKUKHbNh3CwUYcMMQmt6j/Wa2bqa0
        ww/4uZnJVxb8A2GFRSgWzOI0J00bW1DNrofMKlxW+xzpaSYX
X-Google-Smtp-Source: ADFU+vuLUQs3pQJgI40e0FlWP1Od+6cgMq10RNWRdC+c5ejp2eHk5Lw4iP8+qGXXffXMdih3mGWzBhI08RLSfGUmhMETIsJUodno
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1786:: with SMTP id y6mr2447173iox.62.1583723342108;
 Sun, 08 Mar 2020 20:09:02 -0700 (PDT)
Date:   Sun, 08 Mar 2020 20:09:02 -0700
In-Reply-To: <0000000000006f20e205a01ef5e1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003a9d4f05a063536a@google.com>
Subject: Re: possible deadlock in __static_key_slow_dec
From:   syzbot <syzbot+61ffbb75d30176841f76@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, bristot@redhat.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        simon.horman@netronome.com, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jul 4 00:21:13 2019 +0000

    hsr: implement dellink to clean up resources

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1449a0b1e00000
start commit:   63623fd4 Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1649a0b1e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1249a0b1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d2e033af114153f
dashboard link: https://syzkaller.appspot.com/bug?extid=61ffbb75d30176841f76
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f0efa1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=119cf3b5e00000

Reported-by: syzbot+61ffbb75d30176841f76@syzkaller.appspotmail.com
Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
