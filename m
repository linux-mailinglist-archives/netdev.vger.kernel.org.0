Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9E8225833
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 09:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgGTHII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 03:08:08 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:39235 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgGTHIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 03:08:06 -0400
Received: by mail-io1-f72.google.com with SMTP id r19so10680610iod.6
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 00:08:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=hf+kwcKJaoB2O2XzZ62VTTEDTpLPt+1+yZptVyrXu3Y=;
        b=qF2ujNmay7zEaVrus3TpMWHNu0TOsQdNJNd8JRoDPB4cHJEDkQni88COJJaGFjiIPF
         Ht7KLwycBC+XqkfTYQu8qPiJy8PhjeEeCTFPAQOwHMNHZAticu2SP8WrGKq2PQUkuRTp
         9a0KXVK4U2HQ2a4gVffTDSGb2X2XNrjbNs4rU4oAuA/lVvOvlI9Z2GtRK/Xq5LSJcIBM
         xheGU7WgpSN79Da+zYIih7OP+5HPsd9itMElN1FwhY9QikC4kNt8KIKrRGDBgU45q4V4
         xc5k2hNEFeeW6Ox6HoBZBG7sG0PzhqQrMiTgsYPA5aSDuKWpPZkV8mXaOEwT9SKQc+2y
         z1Xg==
X-Gm-Message-State: AOAM533AEE4T6fJItVGlLIb1rRgF6r+jBW8g+htVMwjeIo8vxtKuMMUa
        9hfHlUKf+nBWyLxlIq7dAHVKAF0zj/unSc31qZ80XB1vS7oe
X-Google-Smtp-Source: ABdhPJxo/yL9uQtzaZRRNF+0FqYGONLLfW8cud6VWFvmxM1Yav75gunkUZy2TqikI8tHCMeJFCpPmRIsXPeM+7wwYZcGZeKzh4Ah
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2601:: with SMTP id m1mr17777548jat.141.1595228885931;
 Mon, 20 Jul 2020 00:08:05 -0700 (PDT)
Date:   Mon, 20 Jul 2020 00:08:05 -0700
In-Reply-To: <0000000000005d946305a9f5d206@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000014dc1805aada2bea@google.com>
Subject: Re: INFO: rcu detected stall in sock_close (3)
From:   syzbot <syzbot+4168fa4c45be33afa73c@syzkaller.appspotmail.com>
To:     Markus.Elfring@web.de, davem@davemloft.net, fweisbec@gmail.com,
        hdanton@sina.com, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, tipc-discussion@lists.sourceforge.net,
        tuong.t.lien@dektech.com.au, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 5e9eeccc58f3e6bcc99b929670665d2ce047e9c9
Author: Tuong Lien <tuong.t.lien@dektech.com.au>
Date:   Wed Jun 3 05:06:01 2020 +0000

    tipc: fix NULL pointer dereference in streaming

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16c5517d100000
start commit:   7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15c5517d100000
console output: https://syzkaller.appspot.com/x/log.txt?x=11c5517d100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=183dd243398ba7ec
dashboard link: https://syzkaller.appspot.com/bug?extid=4168fa4c45be33afa73c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=112223b7100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=154793a3100000

Reported-by: syzbot+4168fa4c45be33afa73c@syzkaller.appspotmail.com
Fixes: 5e9eeccc58f3 ("tipc: fix NULL pointer dereference in streaming")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
