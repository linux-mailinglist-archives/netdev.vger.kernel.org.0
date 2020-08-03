Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7411239D21
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 02:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgHCAtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 20:49:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:49476 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbgHCAtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 20:49:05 -0400
Received: by mail-io1-f69.google.com with SMTP id 189so1268608iov.16
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 17:49:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=zjMjCpZHpZC9oX4mSp6lGsDleX+rgZUM4Hc+zQq53tE=;
        b=Byc8AMsgJCpGnhv0OO6p5FRvjbKj60BuEwi8GEwiVC39rTARv3Rc8auoKO+X7bNWMB
         PQ4jX2vsTuYJBrWoIwfOCWmdpa6chQ87IhY0ubOu/ZzjwId4+ZNA5u2FpkATwQGAvwe7
         /q2YvVgGYHCyi3YIdjO2PsdvWsYTWS1ASe1YsigNnuR0ZADhuTs1kUJNgyi/6kI1Bisb
         Lv/uBpNuQqUPNn3y+B52f+uxxwi8fnM6i0II2lMm6pYxu3qbY4J+F01CKJRpywnxXQmq
         nCXiHClEaUgRGvcYMKdP0lNGBLhMFRBZQvSJ7PfuNcNdQZJxV5Vni9Dco8gbDwceuQRC
         ZLtg==
X-Gm-Message-State: AOAM532TBm8Txnr2nCMjTSao3mO9/CEtmzwD2qkrNvkatb662MhdstL3
        9U7mzTty/mHQ24lnOumbBKI5XjWZeUeLnZb8OaOEdkuSZDTi
X-Google-Smtp-Source: ABdhPJx51fMhfJaafxHzZAN2jjWSIrSl/b5CFIul4+GGQOi4s1mKok/hTo4u9c3s4cBgSHZ/wcwXjrq3H3VFwrd210mpw03EVfqe
MIME-Version: 1.0
X-Received: by 2002:a05:6602:15d0:: with SMTP id f16mr168098iow.45.1596415744953;
 Sun, 02 Aug 2020 17:49:04 -0700 (PDT)
Date:   Sun, 02 Aug 2020 17:49:04 -0700
In-Reply-To: <000000000000ab11c505abeb19f5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000064571305abee81ea@google.com>
Subject: Re: KASAN: use-after-free Write in __sco_sock_close
From:   syzbot <syzbot+077eca30d3cb7c02b273@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        johan.hedberg@gmail.com, kaber@trash.net, kadlec@blackhole.kfki.hu,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        marcel@holtmann.org, mchehab@kernel.org, mchehab@s-opensource.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 43ea43b9d8b27b7acd443ec59319faa3cdb8a616
Author: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date:   Wed Oct 12 11:21:43 2016 +0000

    [media] radio-bcm2048: don't ignore errors

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1036e6a4900000
start commit:   ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1236e6a4900000
console output: https://syzkaller.appspot.com/x/log.txt?x=1436e6a4900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
dashboard link: https://syzkaller.appspot.com/bug?extid=077eca30d3cb7c02b273
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12cf1904900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d52e14900000

Reported-by: syzbot+077eca30d3cb7c02b273@syzkaller.appspotmail.com
Fixes: 43ea43b9d8b2 ("[media] radio-bcm2048: don't ignore errors")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
