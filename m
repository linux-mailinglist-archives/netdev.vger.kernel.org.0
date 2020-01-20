Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2571142B6A
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 14:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgATNAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 08:00:02 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:38265 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgATNAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 08:00:01 -0500
Received: by mail-il1-f198.google.com with SMTP id i67so25047793ilf.5
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 05:00:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ccHZGw3XzyeKhK1JvL4mqzYRrPRSlX015G5X9Rh8ai8=;
        b=lYOsLVR1P0IKUfZAg8sDsbqVDlv19q5jAHVc7zNIFMVfo4c1ZzPJHKIWJsLhmSMp/G
         5DsGwQF+636y66Krokr2E7RBSIRtNjWq4PWNNLUhEv7DtZDNglZupiA3ZS5rjb2lYoeH
         /eJNnppGaBtJVI7m3qBJCzfOCTyvqb249PTLiyyVnaKBlwNlvqOLRk1gXa7NaOm/haWn
         6eFsUo2gDd3cPDDQYhbe7gsrdBNNYO3qOfzOCQmMPAkoDpQ9Aksbg5kSnFC8BR3DWgnW
         Q/nNvu/RZUJzfwmIp9QIJtJq89ifEu0w+WbNjVKe4Myqb5u84Zq4oRk6p2DXQskU8AEX
         0ZCQ==
X-Gm-Message-State: APjAAAUerwZ8u/qVY5A7JQ+tX6woqLKXR0ycxyQ33wDMfww0nItYNh68
        gru/zi2jFBDfa640Vwy5gbG1nIVufu5vXOVJS/yIkXD01/zp
X-Google-Smtp-Source: APXvYqzQK4xEJEEsdRXQxcEUPQa8SvkDpzTuytQHbP5WG/fHyScj0aBkpDkh/RGn23ijeRueaCc2L5jXxGCZSUtAxquAIlP3GCeX
MIME-Version: 1.0
X-Received: by 2002:a02:3948:: with SMTP id w8mr42297420jae.124.1579525201269;
 Mon, 20 Jan 2020 05:00:01 -0800 (PST)
Date:   Mon, 20 Jan 2020 05:00:01 -0800
In-Reply-To: <000000000000f649ad059c8ca893@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008916f1059c91de99@google.com>
Subject: Re: KASAN: slab-out-of-bounds Write in bitmap_ip_del
From:   syzbot <syzbot+24d0577de55b8b8f6975@syzkaller.appspotmail.com>
To:     allison@lohutok.net, arvid.brodin@alten.se, coreteam@netfilter.org,
        davem@davemloft.net, dirk.vandermerwe@netronome.com, fw@strlen.de,
        gregkh@linuxfoundation.org, jakub.kicinski@netronome.com,
        jeremy@azazel.net, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 0f93242d96ff5a04fe02c4978e8dddb014235971
Author: Jakub Kicinski <jakub.kicinski@netronome.com>
Date:   Tue Jul 9 02:53:08 2019 +0000

    nfp: tls: ignore queue limits for delete commands

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11f4e966e00000
start commit:   09d4f10a net: sched: act_ctinfo: fix memory leak
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13f4e966e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15f4e966e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=24d0577de55b8b8f6975
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1799c135e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176b8faee00000

Reported-by: syzbot+24d0577de55b8b8f6975@syzkaller.appspotmail.com
Fixes: 0f93242d96ff ("nfp: tls: ignore queue limits for delete commands")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
