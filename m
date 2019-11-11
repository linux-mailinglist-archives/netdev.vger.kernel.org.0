Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B32F6D6A
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 04:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfKKD5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 22:57:02 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:48140 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbfKKD5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 22:57:02 -0500
Received: by mail-il1-f200.google.com with SMTP id j68so15812918ili.15
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 19:57:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ahqf5JMi9x4MvVhOL42cOCJqrc4gS0aQJVD9aozCigk=;
        b=GgxGLYtabVyzPl8hhUhI4ZerEi3VmfIGSVlcohY7uTKmqB583Au1zUiKOgzryQqpBP
         4rLz4wrPmnx3UEKXzEvZBLQkOY/nQhEYcJClbXEq1154LkIbQfolz7CarP7iT0b6+mSP
         +DqWXZN8l1IJCnSrFA/tmq2KBkf5I5Ob84Hs//+nNk7JQQn/YG4VYTR+wtaW0mE5RXv7
         UJy2uKQUndNFSzKB8jC8Gd4p4HToyubazGvj2Glix56F60Qb3X2NY2CVu1mw1GKXyErA
         EAeG/cXuNg8YFiyOau/K9pEhuIdxJaul1lGSzd8fnO4016dEnGztlApwRd5OC0EdADh4
         wVYg==
X-Gm-Message-State: APjAAAVG6qDzkBv5bp3dTlY/HH5IH3DJK62FTJ05YV57u3tsn4+CDKZW
        LSpwzH7Kg0G5oGBHNX4J2t+s5obZ8+ls4ZioI8i28sulQjq/
X-Google-Smtp-Source: APXvYqxIayoK3rWM7U/FC6CNlkGPnuolY7jUbXULvgiXcBHeAhVQj+4RetmukhTi4OYUOkBjLlTShjAPyzdnLzWMGXOucgeE3et/
MIME-Version: 1.0
X-Received: by 2002:a02:3903:: with SMTP id l3mr22649703jaa.72.1573444621272;
 Sun, 10 Nov 2019 19:57:01 -0800 (PST)
Date:   Sun, 10 Nov 2019 19:57:01 -0800
In-Reply-To: <00000000000082c66d059705e442@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b98cf305970a1fd3@google.com>
Subject: Re: KASAN: use-after-free Read in j1939_session_get_by_addr_locked
From:   syzbot <syzbot+ca172a0ac477ac90f045@syzkaller.appspotmail.com>
To:     bst@pengutronix.de, davem@davemloft.net,
        dev.kurt@vandijck-laurijssen.be, ecathinds@gmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rempel-privat.de,
        lkp@intel.com, maxime.jayat@mobile-devices.fr, mkl@pengutronix.de,
        netdev@vger.kernel.org, o.rempel@pengutronix.de, robin@protonic.nl,
        socketcan@hartkopp.net, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 9d71dd0c70099914fcd063135da3c580865e924c
Author: The j1939 authors <linux-can@vger.kernel.org>
Date:   Mon Oct 8 09:48:36 2018 +0000

     can: add support of SAE J1939 protocol

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11bc06d6e00000
start commit:   00aff683 Merge tag 'for-5.4-rc6-tag' of git://git.kernel.o..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13bc06d6e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15bc06d6e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5e2eca3f31f9bf
dashboard link: https://syzkaller.appspot.com/bug?extid=ca172a0ac477ac90f045
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144150e2e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11aaa9fce00000

Reported-by: syzbot+ca172a0ac477ac90f045@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
