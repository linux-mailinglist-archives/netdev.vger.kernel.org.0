Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDD84143164
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 19:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgATSWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 13:22:02 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:48705 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgATSWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 13:22:01 -0500
Received: by mail-il1-f198.google.com with SMTP id u14so296405ilq.15
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 10:22:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=MqDXOoM9vvTcTH3u9+KklRDGAKW3hOgR3ZSR/h+boWo=;
        b=eH7O5fiuA3UpvBAFNu5Lq4JKEVxh6GyUkMQnCv61kGhWLe8p4WT2tgUIPKfIqDf/ox
         CvGh672y1BfvcTrhCKPhgusuNteD8mnXkvzX2yzRpkupjgtilAKjAmpaphkxPoShLomC
         i4E8oIBP+beeuaTadPtsO4wXhQSSkuKAWHZ6pMynzl/Q3u61cyg+ih3OkpF3R+Eu6hv9
         3zL4FEnxTeNf7yTTftnJu0OdUmj6ylA97kFa+PgHUnydlbGooNmZZrYdxeDPndFMGRIW
         zmAHgU0Dx4nLWevvOpdLxBG3/+8P07iZIcdpDi1IP5IDKv8+wlSaRfTgdKwZEhxAJfcN
         JDgw==
X-Gm-Message-State: APjAAAXWM+slKk3GiuLTapTn3eox3OlzJ3z1IA/0tx88kyrA7QDsBR1G
        /tv+Q8nfrmoodt+PItf8VxPhAbGVPEasjDirS582zLPX2VBy
X-Google-Smtp-Source: APXvYqzfQyTnxVv2xv/HZdiNuXYYiHLNeNXNJ6hv0nTAZFxD/xXg/rkalEYxh8LA+d9fc9B6xIMLWxfmsZDaI5AWugpAqhqpGZ/4
MIME-Version: 1.0
X-Received: by 2002:a02:856a:: with SMTP id g97mr227401jai.97.1579544520986;
 Mon, 20 Jan 2020 10:22:00 -0800 (PST)
Date:   Mon, 20 Jan 2020 10:22:00 -0800
In-Reply-To: <00000000000043aa29059c91459e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000149402059c965e75@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ipmac_gc
From:   syzbot <syzbot+c1a1fb435465986efe35@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        gregkh@linuxfoundation.org, info@metux.net, jeremy@azazel.net,
        kadlec@netfilter.org, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        liuyonglong@huawei.com, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, salil.mehta@huawei.com, sbrivio@redhat.com,
        shuliubin@huawei.com, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        yisen.zhuang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 0d581ba311a27762fe1a14e5db5f65d225b3d844
Author: Yonglong Liu <liuyonglong@huawei.com>
Date:   Wed Jul 3 11:12:30 2019 +0000

    net: hns: add support for vlan TSO

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16d5dfaee00000
start commit:   def9d278 Linux 5.5-rc7
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15d5dfaee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11d5dfaee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf8e288883e40aba
dashboard link: https://syzkaller.appspot.com/bug?extid=c1a1fb435465986efe35
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=153ac495e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=153471d1e00000

Reported-by: syzbot+c1a1fb435465986efe35@syzkaller.appspotmail.com
Fixes: 0d581ba311a2 ("net: hns: add support for vlan TSO")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
