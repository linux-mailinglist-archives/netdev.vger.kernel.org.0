Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94368EFC9D
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 12:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730959AbfKELpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 06:45:04 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:43438 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730896AbfKELpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 06:45:03 -0500
Received: by mail-il1-f197.google.com with SMTP id d11so18322925ild.10
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 03:45:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=QCC2Zuft5IrSbuyDgMXl4CHaLN5HBJGcl6ykToE6Ed8=;
        b=XCTT6G+RJ3+Kw9Qv4tTHh3/FQIIkehbaqMBb45064X6aBxzZpAfB3iS8B+esWYNFcm
         e6Hj6Pocw4DhV2VIJSze7SgMx7DrJ9E0Ui9zHNWmUHNmA35wb37qK2lCpbTzyWnC3Hvk
         eEAMz1F5V+bweDS4/5yav3O8SeOyNoCSSiIRk9kQtXJGkWsNJreKQ2YSXtZAdSfOd/S0
         5vNvkHYmUd2J0pThKOw1nugHEVn3M8cm/hOyKZuNBEVEne0XWM5FM2GcKXXo6rUh9imn
         UCq9MkVjwl17eH0lPJ+Gdt2gdxf8NPs4QGJowmSV/0eyh43XCFnA7rmxVP4BYh17BoV6
         Ssqg==
X-Gm-Message-State: APjAAAX2HKLbu1mde/aZSbhx5QeGbRDTbp4iRqzGrI7avzjv8dvVZW6O
        9LG+jvpVyi/sFwBormkYQCV6M2ZYvCFm1CCtYKXp4R8Gnj0m
X-Google-Smtp-Source: APXvYqxODW9NHJW/4EGLldbad5zqA1/v64aLeXSjpLD0OrWyJ+niu+pzFgfeGWWvRMHqE1vxcY6Q2oZjQUQLXqzmYw875vDSNqU9
MIME-Version: 1.0
X-Received: by 2002:a92:d981:: with SMTP id r1mr15781326iln.64.1572954300760;
 Tue, 05 Nov 2019 03:45:00 -0800 (PST)
Date:   Tue, 05 Nov 2019 03:45:00 -0800
In-Reply-To: <000000000000de1eec059692c021@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000058481f059697f6e7@google.com>
Subject: Re: KASAN: use-after-free Write in j1939_sock_pending_del
From:   syzbot <syzbot+07bb74aeafc88ba7d5b4@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11150314e00000
start commit:   a99d8080 Linux 5.4-rc6
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13150314e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15150314e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=896c87b73c6fcda6
dashboard link: https://syzkaller.appspot.com/bug?extid=07bb74aeafc88ba7d5b4
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16fd7044e00000

Reported-by: syzbot+07bb74aeafc88ba7d5b4@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
