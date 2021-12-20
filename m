Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5569D47A40A
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 05:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237262AbhLTEPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 23:15:08 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:50094 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbhLTEPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 23:15:07 -0500
Received: by mail-il1-f199.google.com with SMTP id x8-20020a056e021bc800b002ab9d7a0f3eso4426391ilv.16
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 20:15:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=dA41sw2aNHV4UHGeC8RSbb14+HrrLILYaej89YpH4eE=;
        b=7s66z++HunmkciGqcntdft8XfFokYGn+fs4Uaz85o2PRaZHUJrYbWa2kxRyQ4xSh6r
         qArDYnX+4RDtPdKprZUYBlcnaCWAT2kgNxSaM8uM9Pv8tAXkWHbCMv+fyzX2VjwNVNy+
         CHbDE+pSl4Ncbk3t+BRxH480k27byOgJamno6C6XYSYDB1FC+NqvGuL0/rNtlwhS8IX5
         nIKwzetaMaoWcHTnff0mxw0yUGjUKKu8tiHwhyFkJkpOC74GHUfGFUYACykCc7jTQkSB
         1J0pNuP18gMCJBz7/RPNsLAAldD/P4GxloUfmOKynheJbnIQZDYFOHeQ/1ip5DlvEax/
         TOLg==
X-Gm-Message-State: AOAM531u4sxZ4+IuCHJgT7SMygYG8f3sS7oUaBTT6IMCzanj6BoCpg8R
        40AMqiRunWajSXEFjQVKD5Vr7MEfB/MDSvOFL+jAsbpzijVg
X-Google-Smtp-Source: ABdhPJyXcmpph7Uxs90eXgZ4J6O5bHwJHb0SeCJqzeX4nFnzR45jGIA0ziodV3xPBXpgT54fSJAUrsGi/SHKY0zsV96A9223mP06
MIME-Version: 1.0
X-Received: by 2002:a05:6638:22c8:: with SMTP id j8mr8937412jat.21.1639973707134;
 Sun, 19 Dec 2021 20:15:07 -0800 (PST)
Date:   Sun, 19 Dec 2021 20:15:07 -0800
In-Reply-To: <0000000000007ea16705d0cfbb53@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000413eba05d38c22c2@google.com>
Subject: Re: [syzbot] kernel BUG in pskb_expand_head
From:   syzbot <syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com>
To:     anthony.l.nguyen@intel.com, changbin.du@intel.com,
        christian.brauner@ubuntu.com, davem@davemloft.net,
        edumazet@google.com, eric.dumazet@gmail.com, hawk@kernel.org,
        hkallweit1@gmail.com, intel-wired-lan-owner@osuosl.org,
        intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com,
        kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com, yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit e4b8954074f6d0db01c8c97d338a67f9389c042f
Author: Eric Dumazet <edumazet@google.com>
Date:   Tue Dec 7 01:30:37 2021 +0000

    netlink: add net device refcount tracker to struct ethnl_req_info

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=109e6fcbb00000
start commit:   434ed2138994 Merge branch 'tc-action-offload'
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=129e6fcbb00000
console output: https://syzkaller.appspot.com/x/log.txt?x=149e6fcbb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7488eea316146357
dashboard link: https://syzkaller.appspot.com/bug?extid=4c63f36709a642f801c5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14141ca3b00000

Reported-by: syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
Fixes: e4b8954074f6 ("netlink: add net device refcount tracker to struct ethnl_req_info")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
