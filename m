Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3A1741DC
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 01:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387873AbfGXXOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 19:14:02 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:50319 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfGXXOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 19:14:01 -0400
Received: by mail-io1-f70.google.com with SMTP id m26so52777906ioh.17
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 16:14:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=kTUfPT7c0ElAMixkntemJj1auET+ylmETk1M6iNdZMM=;
        b=qu00MSbR/BxjGo85wptAug3hSnsJZ2APzy1uysBGLQnwxvBr8N6EN1JlUTKvwhp0hr
         5uQ0FksM00xoKrIiBh/GB5uJhzjp49TqBCpZMDftHRNd5HtCa5HIyimFPP+P/50LgH2e
         snWdoOBobAClH1L1rN6oSte7XkaQYPN+cArC6+nZ3n5pWmiSqBqMF+8yd8Lzjuttuy95
         EavC4YSAOR2SAHfvx7whA0SJ+omJBG/RFn55pnpHs+8GUMsqVY3a9WiAx5QQ+S71UCFL
         K/WQe9+E4OQSx0L/pWTKy26HzliU4m3C9rKJXI3t400iy23MEc7AYH2cC9OpEcvZcRg0
         E3mA==
X-Gm-Message-State: APjAAAUbrM+kYtoNpw2kT87dfh5weLrsIF76AdEGzeQG4TZLrt+yICrb
        Y5Ob4YJoIPiKRVS7L0D+FYDMFGTHmrEzdSJNrJM5eX/mjH9/
X-Google-Smtp-Source: APXvYqw6yDry1o8jGg/0v1gL2svqsUlEFZJu+ska6MMsY9aYOFn/bqoA0H9Yjt85u9KdNPpHAyn19XfZy9a89LpNooy/F/qjzH6x
MIME-Version: 1.0
X-Received: by 2002:a5e:8e42:: with SMTP id r2mr75257057ioo.305.1564010040835;
 Wed, 24 Jul 2019 16:14:00 -0700 (PDT)
Date:   Wed, 24 Jul 2019 16:14:00 -0700
In-Reply-To: <000000000000464b54058e722b54@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e8c654058e7576ef@google.com>
Subject: Re: BUG: spinlock recursion in release_sock
From:   syzbot <syzbot+e67cf584b5e6b35a8ffa@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, aviadye@mellanox.com, borisp@mellanox.com,
        daniel@iogearbox.net, davejwatson@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        john.hurley@netronome.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, simon.horman@netronome.com,
        syzkaller-bugs@googlegroups.com, willemb@google.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 8822e270d697010e6a4fd42a319dbefc33db91e1
Author: John Hurley <john.hurley@netronome.com>
Date:   Sun Jul 7 14:01:54 2019 +0000

     net: core: move push MPLS functionality from OvS to core helper

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13ca5a5c600000
start commit:   9e6dfe80 Add linux-next specific files for 20190724
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=102a5a5c600000
console output: https://syzkaller.appspot.com/x/log.txt?x=17ca5a5c600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6cbb8fc2cf2842d7
dashboard link: https://syzkaller.appspot.com/bug?extid=e67cf584b5e6b35a8ffa
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13680594600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b34144600000

Reported-by: syzbot+e67cf584b5e6b35a8ffa@syzkaller.appspotmail.com
Fixes: 8822e270d697 ("net: core: move push MPLS functionality from OvS to  
core helper")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
