Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2530D119B73
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbfLJWID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:08:03 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:33417 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729838AbfLJWIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 17:08:02 -0500
Received: by mail-io1-f70.google.com with SMTP id i8so14368991ioi.0
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 14:08:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=GwENJOhReXSoSX4FCZp3Vso0XyIxIAaoh96r/uvXuy4=;
        b=HT1CsRTqLxiUOCSu2xXwWUKD3iJ7ZHSw/uN4IQ3InuvG67RR+A4G3VzY0WQ3WbPJhU
         oavXYA8+HJDt4T3mHsMeI/8HQW/UvYKKhkICO08XlYxnSNsjJ2Sq/Q2qVn6zJp7x80/F
         bNxCdanMae+Rdkb0U/2JQ34dB6Yy9GtWZ+YjArkgOH+1myAUmG93HSMe6Le4Csn5PNEO
         Gs6sULgXO0psQbaI+vV0e+KR/XA2pk16ITKbvCHePFd0ijBH5fXdqHSUvTX3G2F3XNvH
         MT7WIizmN6n+/Hl2ubQPnbnblIm4+jDXlV+ATwWaz2IY6xp7KKE03WVW8X/GuIc5w7BY
         BmWA==
X-Gm-Message-State: APjAAAV9PRTfPJ0IDg5edW/SeoqVg3+dRfnY/2lzQ7bQ6zLBsZZUc9DW
        NxbuxBKd1cMKOfG2SEGZgvqZSwW8gaUpUti5wWRX0byXYzTa
X-Google-Smtp-Source: APXvYqw1nemikCJS5D7M4N4f0bYbahpKkcyiyjQt4kL1XP7Z9X8CJ3ZOIh4k/9LB4ygXcYMr/mw1sHHvGwAuiBpmhzif60YWo58S
MIME-Version: 1.0
X-Received: by 2002:a5d:9f05:: with SMTP id q5mr234717iot.295.1576015681954;
 Tue, 10 Dec 2019 14:08:01 -0800 (PST)
Date:   Tue, 10 Dec 2019 14:08:01 -0800
In-Reply-To: <0000000000005175bf057617c71d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e22b3c059960bebd@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in ip6_tnl_parse_tlv_enc_lim
From:   syzbot <syzbot+68dce7caebd8543121de@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, ast@kernel.org, boqun.feng@gmail.com,
        byungchul.park@lge.com, daniel@iogearbox.net, davem@davemloft.net,
        dledford@redhat.com, jgg@mellanox.com, jgg@ziepe.ca,
        kernel-team@lge.com, kirill@shutemov.name, kuznet@ms2.inr.ac.ru,
        leon@kernel.org, leonro@mellanox.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-rdma@vger.kernel.org, mingo@kernel.org,
        netdev@vger.kernel.org, npiggin@gmail.com, parav@mellanox.com,
        peterz@infradead.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        walken@google.com, willy@infradead.org, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 30471d4b20335d9bd9ae9b2382a1e1e97d18d86d
Author: Leon Romanovsky <leonro@mellanox.com>
Date:   Sun Feb 3 12:55:50 2019 +0000

     RDMA/core: Share driver structure size with core

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16b7bb7ae00000
start commit:   3a5af36b Merge tag '4.19-rc3-smb3-cifs' of git://git.samba..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c4a80625153107e
dashboard link: https://syzkaller.appspot.com/bug?extid=68dce7caebd8543121de
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1068a44e400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=146386c6400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: RDMA/core: Share driver structure size with core

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
