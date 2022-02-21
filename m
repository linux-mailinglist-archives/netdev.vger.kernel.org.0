Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB474BD84D
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 09:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343868AbiBUIkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 03:40:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343972AbiBUIkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 03:40:46 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D202CC3F;
        Mon, 21 Feb 2022 00:40:22 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0V51uqPX_1645432819;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V51uqPX_1645432819)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 21 Feb 2022 16:40:20 +0800
Date:   Mon, 21 Feb 2022 16:40:18 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc:     jgg@ziepe.ca, liangwenpeng@huawei.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        liweihang@huawei.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com>
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 smc_pnet_apply_ib
Message-ID: <YhNP8vU0FueNeDPr@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <000000000000b772b805d8396f14@google.com>
 <2691692.BEx9A2HvPv@leap>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2691692.BEx9A2HvPv@leap>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 07:05:31PM +0100, Fabio M. De Francesco wrote:
> On giovedì 17 febbraio 2022 17:41:22 CET syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    c832962ac972 net: bridge: multicast: notify switchdev driv..
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16b157bc700000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=266de9da75c71a45
> > dashboard link: https://syzkaller.appspot.com/bug?extid=4f322a6d84e991c38775
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com
> > 
> > infiniband syz1: set down
> > infiniband syz1: added lo
> > RDS/IB: syz1: added
> > smc: adding ib device syz1 with port count 1
> > BUG: sleeping function called from invalid context at kernel/locking/mutex.c:577
> > in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 17974, name: syz-executor.3
> > preempt_count: 1, expected: 0
> > RCU nest depth: 0, expected: 0
> > 6 locks held by syz-executor.3/17974:
> >  #0: ffffffff90865838 (&rdma_nl_types[idx].sem){.+.+}-{3:3}, at: rdma_nl_rcv_msg+0x161/0x690 drivers/infiniband/core/netlink.c:164
> >  #1: ffffffff8d04edf0 (link_ops_rwsem){++++}-{3:3}, at: nldev_newlink+0x25d/0x560 drivers/infiniband/core/nldev.c:1707
> >  #2: ffffffff8d03e650 (devices_rwsem){++++}-{3:3}, at: enable_device_and_get+0xfc/0x3b0 drivers/infiniband/core/device.c:1321
> >  #3: ffffffff8d03e510 (clients_rwsem){++++}-{3:3}, at: enable_device_and_get+0x15b/0x3b0 drivers/infiniband/core/device.c:1329
> >  #4: ffff8880482c85c0 (&device->client_data_rwsem){++++}-{3:3}, at: add_client_context+0x3d0/0x5e0 drivers/infiniband/core/device.c:718
> >  #5: ffff8880230a4118 (&pnettable->lock){++++}-{2:2}, at: smc_pnetid_by_table_ib+0x18c/0x470 net/smc/smc_pnet.c:1159
> > Preemption disabled at:
> > [<0000000000000000>] 0x0
> > CPU: 1 PID: 17974 Comm: syz-executor.3 Not tainted 5.17.0-rc3-syzkaller-00170-gc832962ac972 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> >  __might_resched.cold+0x222/0x26b kernel/sched/core.c:9576
> >  __mutex_lock_common kernel/locking/mutex.c:577 [inline]
> >  __mutex_lock+0x9f/0x12f0 kernel/locking/mutex.c:733
> >  smc_pnet_apply_ib+0x28/0x160 net/smc/smc_pnet.c:251
> >  smc_pnetid_by_table_ib+0x2ae/0x470 net/smc/smc_pnet.c:1164
> 
> If I recall it well, read_lock() disables preemption. 
> 
> smc_pnetid_by_table_ib() uses read_lock() and then it calls smc_pnet_apply_ib() 
> which, in turn, calls mutex_lock(&smc_ib_devices.mutex). Therefore the code 
> acquires a mutex while in atomic and we get a SAC bug.
> 
> Actually, even if my argument is correct(?), I don't know if the read_lock() 
> in smc_pnetid_by_table_ib() can be converted to a sleeping lock like a mutex or 
> a semaphore.
 
I think it is okay to use mutex, because this path is not so hot and no
limit to require spinlocks. pnettable is accessed by netlink, syscall
and netdevice notifier.
