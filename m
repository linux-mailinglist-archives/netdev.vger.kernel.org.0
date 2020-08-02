Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEF52355D6
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 09:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgHBHnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 03:43:07 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:42715 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgHBHnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 03:43:06 -0400
Received: by mail-il1-f199.google.com with SMTP id c12so11677725iln.9
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 00:43:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=eqE7M2+jLX9Z2b2ijRlZEwnniJaj49l3REpKdM5etlE=;
        b=G5IzwKpuP+8afxdSQiNs45uBIUl1T87wZLjdHshtrQwmsD+vu72bmXfgy9KMJ+ZuRa
         /GyrNmbfsEr9Dx0HO1fm88X3EV98MZy7BBAYDlebYG1Lx3VGlBESxZ5blGRaDbLB9cGx
         ZeERG9e+213D5ZwbrFJfyYCFDN04WFiUF38uMWLV6VqBfvNV0C7h0llZ8cqRgKTZe4z2
         rSc0VGyakA/Q2nu9iKtmXMwfl2nxMVUNuUgZYObU8SY47Z7fwA+JlFnN+Ac6ozt+Rcxl
         +src95jIsJ82BtSDRfzKJELqVS2UMyggqNFdJMUUculhNkb1sbGmf9OgcO/7m6am1iio
         2jdg==
X-Gm-Message-State: AOAM53216EK5NOdpcDh+fvcGzF0SpB0/w0kNo0uUaqVVi/c9ChuPJXo3
        1pM2OECK7P7SVDSwZxL5pRGyP8eRoDmNCspxj1N6HOi2/7/y
X-Google-Smtp-Source: ABdhPJwPGH2yiYhjXOJM0c9EdW/Wpe7YJ1kZV2DXqRnNQjYhM6BG3LXmVT5ZL1XYU6JMC/FZ7hlVZVJTAwLiRQixN1DQMDrTFguA
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2647:: with SMTP id n7mr1328983jat.61.1596354185896;
 Sun, 02 Aug 2020 00:43:05 -0700 (PDT)
Date:   Sun, 02 Aug 2020 00:43:05 -0700
In-Reply-To: <000000000000ea90600598c9b089@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002fa64705abe02c21@google.com>
Subject: Re: possible deadlock in __dev_queue_xmit (3)
From:   syzbot <syzbot+3b165dac15094065651e@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 1a33e10e4a95cb109ff1145098175df3113313ef
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun May 3 05:22:19 2020 +0000

    net: partially revert dynamic lockdep key changes

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10434970900000
start commit:   d8b9faec Merge tag 'drm-fixes-2020-07-31' of git://anongit..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12434970900000
console output: https://syzkaller.appspot.com/x/log.txt?x=14434970900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c0cfcf935bcc94d2
dashboard link: https://syzkaller.appspot.com/bug?extid=3b165dac15094065651e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=163e2c92900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=143f2bb8900000

Reported-by: syzbot+3b165dac15094065651e@syzkaller.appspotmail.com
Fixes: 1a33e10e4a95 ("net: partially revert dynamic lockdep key changes")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
