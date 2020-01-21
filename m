Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2C7143645
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 05:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgAUElC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 23:41:02 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:55981 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbgAUElB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 23:41:01 -0500
Received: by mail-io1-f71.google.com with SMTP id z21so943953iob.22
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 20:41:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=NCHvuKVSBxRHeizGAyp94YLEyZNHqgNg1esxuxlJg/o=;
        b=UrkTI2zK1xLxpp/qV9HsPPodMllR1VtRueL7Bw3x4khPltj59XoWmUn2MDAWlDt5J3
         sRe5heubX73yBTyO3a34G/C9hfV4eMFzV80lhkmOZLpeokkAFwJ0lk7Wd3Ub0KPKpJvn
         D+fS3nADJhCo4qotU7dTf8QawCp122n/WeILLhfsXgYQFCGgBb4SNYtuMZWEZnR1HKYZ
         vlkI8kLE6k3Uwg2mc7i8LlUFX6hHnVkxldqQPVFQ8GmuQisgU/ocVI0QBTe3LlxN/l7w
         LKZ9+BFq2FtogR/os3ec/1n7uD84F0gRNPURVAWu2mZa2PGZ3fqj0nXGMeBK6H8W8Qhg
         YDdQ==
X-Gm-Message-State: APjAAAXjbV7BAS9TI/gOHZoX5fpnNBS5lYVP79OU9g4ViLsiJej5/XCl
        VcAgpSykgRkmvFhqbnrjYZWzewHt5B2OxeSVAHiZQZlKWu4r
X-Google-Smtp-Source: APXvYqzJrudOM5ZqIhdp6/vUqAJPKgAZHJimMJnIa4tHcx71IDDXqV6DGIP5tIwdhQNRHsKr47nmu6rr4NtsU6zWdZOvYEY4ROX2
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4d2:: with SMTP id f18mr2062010ils.54.1579581661230;
 Mon, 20 Jan 2020 20:41:01 -0800 (PST)
Date:   Mon, 20 Jan 2020 20:41:01 -0800
In-Reply-To: <000000000000bb0378059c865fdf@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cfbeb5059c9f036d@google.com>
Subject: Re: KASAN: use-after-free Read in bitmap_ip_destroy
From:   syzbot <syzbot+8b5f151de2f35100bbc5@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com,
        tanhuazhong@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 354d0fab649d47045517cf7cae03d653a4dcb3b8
Author: Peng Li <lipeng321@huawei.com>
Date:   Thu Jul 4 14:04:26 2019 +0000

    net: hns3: add default value for tc_size and tc_offset

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15cc0685e00000
start commit:   8f8972a3 Merge tag 'mtd/fixes-for-5.5-rc7' of git://git.ke..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17cc0685e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=13cc0685e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbb8fa33f49f9f3
dashboard link: https://syzkaller.appspot.com/bug?extid=8b5f151de2f35100bbc5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e22559e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16056faee00000

Reported-by: syzbot+8b5f151de2f35100bbc5@syzkaller.appspotmail.com
Fixes: 354d0fab649d ("net: hns3: add default value for tc_size and tc_offset")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
