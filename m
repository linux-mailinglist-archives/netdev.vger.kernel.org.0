Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 378C2186B5E
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 13:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbgCPMtF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 Mar 2020 08:49:05 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:43421 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730979AbgCPMtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 08:49:04 -0400
Received: by mail-io1-f70.google.com with SMTP id b21so6019904iot.10
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 05:49:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=bbgjCSG0GMx48AI+Nh/K6rSe5vletqIPxakfsmtyduw=;
        b=sbJ/JuuqO7wdfZe74O7NjKguRPZUMggAO1mVPsfO8px3M0T/xDG/beG4YTKyZWpwkB
         UMh+e99+uPgrKEAxTjYaELpSJEHLfYxynJvAXlLedZIH10CisxnyhHQ1b0lvUcw8wZZC
         3jdeQkB/77z6f1dYBJC7ezFO1kJyLVH/pJzpBaK/V36vC5mwtgF3/CqTHhI1CC/buQzZ
         jskoz6w+qr56tPP0rS+AobBxnxTaiunnyAYP+Me1bBuo2bSlZdNG6k0NQEYRve5MS1mF
         rJEvZ2lzE5HPWtz+pqfvXCBedtAdV8zkGLGn7eBlKpmwK9XOrzmText1u1rHqCHzAZY/
         WekA==
X-Gm-Message-State: ANhLgQ0wipcS0GvU3odmEI34EeHxP83EhaDnhgv2rLdqP/T3Xfzc2fUb
        9IMBTB0y2S4gxHiz0Ecb3F8nHUor8OZQR0I5fvZLg7cRaVcu
X-Google-Smtp-Source: ADFU+vue7B9fHGoWNVwlgwrWGWkXeorIo9SBr4w0t4qGXj0x5F7298EMNFAO00Xn0od3oIodZxvMr/pdtB+0Ajok3FT03wHErLf5
MIME-Version: 1.0
X-Received: by 2002:a92:d789:: with SMTP id d9mr455830iln.301.1584362942791;
 Mon, 16 Mar 2020 05:49:02 -0700 (PDT)
Date:   Mon, 16 Mar 2020 05:49:02 -0700
In-Reply-To: <00000000000043aa29059c91459e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000066871f05a0f83e9d@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ipmac_gc
From:   syzbot <syzbot+c1a1fb435465986efe35@syzkaller.appspotmail.com>
To:     a@unstable.cc, allison@lohutok.net,
        b.a.t.m.a.n@lists.open-mesh.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, gregkh@linuxfoundation.org,
        info@metux.net, jeremy@azazel.net, kadlec@blackhole.kfki.hu,
        kadlec@netfilter.org, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        liuyonglong@huawei.com, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, salil.mehta@huawei.com, sbrivio@redhat.com,
        shuliubin@huawei.com, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        yisen.zhuang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 32c72165dbd0e246e69d16a3ad348a4851afd415
Author: Kadlecsik József <kadlec@blackhole.kfki.hu>
Date:   Sun Jan 19 21:06:49 2020 +0000

    netfilter: ipset: use bitmap infrastructure completely

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1074c2a9e00000
start commit:   d96d875e Merge tag 'fixes_for_v5.5-rc8' of git://git.kerne..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf8e288883e40aba
dashboard link: https://syzkaller.appspot.com/bug?extid=c1a1fb435465986efe35
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e36185e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=104a7a11e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
