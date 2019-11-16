Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2B7FF5DC
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 22:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbfKPV6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 16:58:01 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:38707 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727611AbfKPV6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 16:58:01 -0500
Received: by mail-il1-f199.google.com with SMTP id f6so12519164ilg.5
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 13:58:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=FivOluRux2/DVAkTpjJWtSvpnnKGD4Lb0eJIgMOZqFE=;
        b=OoGIMc45MwAtP0NSepY1Mlhlt8Nm1AsXBt3gfj4vfnkOx/cczrSDoE+27ZbZvuzAlh
         /UvYjpzS3XwpzngkDaOPgh/NbFyPTyVb4bchXbUFiBhCBcTC3ApHxZDEeGjitFGfET5H
         9m7vwpLlNf1tfAD+J+JHKJCqa/t2pZS022RpfuWeZJu48A0Im3iUmwXfZSQe0gvaPiP2
         DZ6uB2fAKJl8p/gOsHtWtrxuWT0Q7dyRkqpS+sDBLlKi6/ogOJ2MIraUy73S8GraZLCg
         tBqI6wIupeCE/isTvJg6m0m1br09VtBIw4dLsH24KGxaI5WmLByTOXmlJ96crl3iioqv
         p+Fw==
X-Gm-Message-State: APjAAAW20FubptMl1eIurgWe3Lmni0hBfmgrJ4YIXtBWxlhEzbILx+r/
        uZBl3x9/d3ZOuUIvMad5A5KPkVUDZ7mp2fY1Ynj0+Yu/8vbe
X-Google-Smtp-Source: APXvYqyBClsLcSrM3dmH+CTnYr4efRlSIxtAlH+yao3jUBN/eeOlTRZsa2EivhAtWsDIyW2jCsP5hnuY0bzWexF2Lwoo7rY/12fX
MIME-Version: 1.0
X-Received: by 2002:a92:5fc2:: with SMTP id i63mr7652353ill.218.1573941480648;
 Sat, 16 Nov 2019 13:58:00 -0800 (PST)
Date:   Sat, 16 Nov 2019 13:58:00 -0800
In-Reply-To: <000000000000029056057cd141cb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d9f8a805977dce36@google.com>
Subject: Re: possible deadlock in neigh_change_state
From:   syzbot <syzbot+6a3c02010a025ac7b7cf@syzkaller.appspotmail.com>
To:     christian@brauner.io, corbet@lwn.net, davem@davemloft.net,
        dsahern@gmail.com, dvyukov@google.com, ebiggers@kernel.org,
        edumazet@google.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com, syzkaller-bugs@googlegroups.com,
        w.bumiller@proxmox.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 58956317c8de52009d1a38a721474c24aef74fe7
Author: David Ahern <dsahern@gmail.com>
Date:   Fri Dec 7 20:24:57 2018 +0000

     neighbor: Improve garbage collection

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1328a1e2e00000
start commit:   addb0679 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10a8a1e2e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1728a1e2e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9655b05acfc97ff
dashboard link: https://syzkaller.appspot.com/bug?extid=6a3c02010a025ac7b7cf
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13317705400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177bb01b400000

Reported-by: syzbot+6a3c02010a025ac7b7cf@syzkaller.appspotmail.com
Fixes: 58956317c8de ("neighbor: Improve garbage collection")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
