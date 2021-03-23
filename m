Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84B334624A
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 16:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhCWPFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 11:05:41 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:57628 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbhCWPFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 11:05:17 -0400
Received: from marcel-macbook.holtmann.net (p4fefce19.dip0.t-ipconnect.de [79.239.206.25])
        by mail.holtmann.org (Postfix) with ESMTPSA id 1A97FCECE4;
        Tue, 23 Mar 2021 16:12:53 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH v2] Bluetooth: check for zapped sk before connecting
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210323163141.v2.1.I6c4306f6e8ba3ccc9106067d4eb70092f8cb2a49@changeid>
Date:   Tue, 23 Mar 2021 16:05:13 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        syzbot+abfc0f5e668d4099af73@syzkaller.appspotmail.com,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <94F81995-4C43-4788-9EF1-54FB3C905784@holtmann.org>
References: <20210323163141.v2.1.I6c4306f6e8ba3ccc9106067d4eb70092f8cb2a49@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> There is a possibility of receiving a zapped sock on
> l2cap_sock_connect(). This could lead to interesting crashes, one
> such case is tearing down an already tore l2cap_sock as is happened
> with this call trace:
> 
> __dump_stack lib/dump_stack.c:15 [inline]
> dump_stack+0xc4/0x118 lib/dump_stack.c:56
> register_lock_class kernel/locking/lockdep.c:792 [inline]
> register_lock_class+0x239/0x6f6 kernel/locking/lockdep.c:742
> __lock_acquire+0x209/0x1e27 kernel/locking/lockdep.c:3105
> lock_acquire+0x29c/0x2fb kernel/locking/lockdep.c:3599
> __raw_spin_lock_bh include/linux/spinlock_api_smp.h:137 [inline]
> _raw_spin_lock_bh+0x38/0x47 kernel/locking/spinlock.c:175
> spin_lock_bh include/linux/spinlock.h:307 [inline]
> lock_sock_nested+0x44/0xfa net/core/sock.c:2518
> l2cap_sock_teardown_cb+0x88/0x2fb net/bluetooth/l2cap_sock.c:1345
> l2cap_chan_del+0xa3/0x383 net/bluetooth/l2cap_core.c:598
> l2cap_chan_close+0x537/0x5dd net/bluetooth/l2cap_core.c:756
> l2cap_chan_timeout+0x104/0x17e net/bluetooth/l2cap_core.c:429
> process_one_work+0x7e3/0xcb0 kernel/workqueue.c:2064
> worker_thread+0x5a5/0x773 kernel/workqueue.c:2196
> kthread+0x291/0x2a6 kernel/kthread.c:211
> ret_from_fork+0x4e/0x80 arch/x86/entry/entry_64.S:604
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reported-by: syzbot+abfc0f5e668d4099af73@syzkaller.appspotmail.com
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Guenter Roeck <groeck@chromium.org>
> ---
> 
> Changes in v2:
> * Modify locking order for better visibility
> 
> net/bluetooth/l2cap_sock.c | 8 ++++++++
> 1 file changed, 8 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

