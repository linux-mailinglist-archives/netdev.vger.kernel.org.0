Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4174BE178
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350418AbiBUKyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 05:54:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346305AbiBUKyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 05:54:04 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BFD5FD3;
        Mon, 21 Feb 2022 02:21:41 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id k3-20020a1ca103000000b0037bdea84f9cso10847624wme.1;
        Mon, 21 Feb 2022 02:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZuFZI0/cIi+w8vK1Gcle4BDyNdUZ1tRStanU+6X4KcI=;
        b=NN6XtIHyVtNOb73dLjbdxFwNKpWIjjSOcnu9VRvCAWBjuO8XQl5P3YG886WO9AQyP9
         QiK+2Cyy+u3snb1kKphOHafTp3I41HJfzj1QIDKhqYgIM7Xnz0dAfapMobvZc8ZorUuN
         vJHkaFuPraS5ygvDAhbYdqhE9J3EWrv8mfDRF0tei92ke6GDpO2KywoMFSFDctBTW0Jd
         kstpF52zR3ohrjVz8bEWm5cjRkdyzzSPZKwDXsQGO/byM+drAm9iHNvSGymFSa/UPXUt
         A7MpxVVsktaJ3eUU9reyL65piCuUNKqeEFojIGRrjyVfA+egYPT6/zjoNrlYEyk/qeOd
         BROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZuFZI0/cIi+w8vK1Gcle4BDyNdUZ1tRStanU+6X4KcI=;
        b=ET3vAfrbQYKtHTuFZHNj11ZqPLXCqE0jZ8lwaFE85YLfByBTqbaOyS7F3OjAFqMv6s
         fkKofmkE5LaZiyY7QZd3rb/wJ/tIShQJ2fMTpl5mkSYEFH4nravAjfIbveTQ0EepgSTF
         ikJxQSmxTKvwo7OIRlilDaMrN82Ejp11zQjjComAWG4frS1V5dlaC5vggbC1023YmAAP
         IaDNnIMSc2D0WkHTMzKyCXoLsVIVOwra/fJypvk1Fi1tOq+hrrZi6ZERMVKRAok4fs4l
         CTQjtJiT42nUm9VcbyONZ4RiaRzAJtm37kLdI+I8QtlFDpwAmhEy2BmqJyHN49cQH4Lb
         dqvQ==
X-Gm-Message-State: AOAM532ooiM2rgp0C+nPKN2pqxDZiUkd1jKgdrzoP2QddY1o8VEFFJdM
        jS3eupjWi0pJ/t273aNi8t8=
X-Google-Smtp-Source: ABdhPJzqhTtl8HBmTE9pWXThiz2vnnAa+XQ9B4E9/E04tPZI39oSpfDUrLce9YbNfS7Y0oLdoEjMpw==
X-Received: by 2002:a7b:c192:0:b0:37b:c6f5:4df0 with SMTP id y18-20020a7bc192000000b0037bc6f54df0mr17220897wmi.79.1645438899695;
        Mon, 21 Feb 2022 02:21:39 -0800 (PST)
Received: from leap.localnet (host-79-27-0-81.retail.telecomitalia.it. [79.27.0.81])
        by smtp.gmail.com with ESMTPSA id y10sm6988272wmi.47.2022.02.21.02.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 02:21:39 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     syzkaller-bugs@googlegroups.com, Tony Lu <tonylu@linux.alibaba.com>
Cc:     jgg@ziepe.ca, liangwenpeng@huawei.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        liweihang@huawei.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com>
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in smc_pnet_apply_ib
Date:   Mon, 21 Feb 2022 11:21:29 +0100
Message-ID: <21388493.EfDdHjke4D@leap>
In-Reply-To: <YhNZAyoqSzIAfF9Y@TonyMac-Alibaba>
References: <000000000000b772b805d8396f14@google.com> <2691692.BEx9A2HvPv@leap> <YhNZAyoqSzIAfF9Y@TonyMac-Alibaba>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On luned=C3=AC 21 febbraio 2022 10:18:59 CET Tony Lu wrote:
> On Thu, Feb 17, 2022 at 07:05:31PM +0100, Fabio M. De Francesco wrote:
> > On gioved=C3=AC 17 febbraio 2022 17:41:22 CET syzbot wrote:
> > > Hello,
> > >=20
> > > syzbot found the following issue on:
> > >=20
> > > HEAD commit:    c832962ac972 net: bridge: multicast: notify switchdev=
 driv..
> > > git tree:       net
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D16b157bc7=
00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D266de9da7=
5c71a45
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D4f322a6d84e=
991c38775
> > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Bi=
nutils for Debian) 2.35.2
> > >=20
> > > Unfortunately, I don't have any reproducer for this issue yet.
> > >=20
> > > IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> > > Reported-by: syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com
> > >=20
> > > infiniband syz1: set down
> > > infiniband syz1: added lo
> > > RDS/IB: syz1: added
> > > smc: adding ib device syz1 with port count 1
> > > BUG: sleeping function called from invalid context at kernel/locking/=
mutex.c:577
> > > in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 17974, name: s=
yz-executor.3
> > > preempt_count: 1, expected: 0
> > > RCU nest depth: 0, expected: 0
> > > 6 locks held by syz-executor.3/17974:
> > >  #0: ffffffff90865838 (&rdma_nl_types[idx].sem){.+.+}-{3:3}, at: rdma=
_nl_rcv_msg+0x161/0x690 drivers/infiniband/core/netlink.c:164
> > >  #1: ffffffff8d04edf0 (link_ops_rwsem){++++}-{3:3}, at: nldev_newlink=
+0x25d/0x560 drivers/infiniband/core/nldev.c:1707
> > >  #2: ffffffff8d03e650 (devices_rwsem){++++}-{3:3}, at: enable_device_=
and_get+0xfc/0x3b0 drivers/infiniband/core/device.c:1321
> > >  #3: ffffffff8d03e510 (clients_rwsem){++++}-{3:3}, at: enable_device_=
and_get+0x15b/0x3b0 drivers/infiniband/core/device.c:1329
> > >  #4: ffff8880482c85c0 (&device->client_data_rwsem){++++}-{3:3}, at: a=
dd_client_context+0x3d0/0x5e0 drivers/infiniband/core/device.c:718
> > >  #5: ffff8880230a4118 (&pnettable->lock){++++}-{2:2}, at: smc_pnetid_=
by_table_ib+0x18c/0x470 net/smc/smc_pnet.c:1159
> > > Preemption disabled at:
> > > [<0000000000000000>] 0x0
> > > CPU: 1 PID: 17974 Comm: syz-executor.3 Not tainted 5.17.0-rc3-syzkall=
er-00170-gc832962ac972 #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BI=
OS Google 01/01/2011
> > > Call Trace:
> > >  <TASK>
> > >  __dump_stack lib/dump_stack.c:88 [inline]
> > >  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> > >  __might_resched.cold+0x222/0x26b kernel/sched/core.c:9576
> > >  __mutex_lock_common kernel/locking/mutex.c:577 [inline]
> > >  __mutex_lock+0x9f/0x12f0 kernel/locking/mutex.c:733
> > >  smc_pnet_apply_ib+0x28/0x160 net/smc/smc_pnet.c:251
> > >  smc_pnetid_by_table_ib+0x2ae/0x470 net/smc/smc_pnet.c:1164
> >=20
> > If I recall it well, read_lock() disables preemption.=20
> >=20
> > smc_pnetid_by_table_ib() uses read_lock() and then it calls smc_pnet_ap=
ply_ib()=20
> > which, in turn, calls mutex_lock(&smc_ib_devices.mutex). Therefore the =
code=20
> > acquires a mutex while in atomic and we get a SAC bug.
> >=20
> > Actually, even if my argument is correct(?), I don't know if the read_l=
ock()=20
> > in smc_pnetid_by_table_ib() can be converted to a sleeping lock like a =
mutex or=20
> > a semaphore.
> =20
> Take the email above. I think it is safe to convert read_lock() to
> mutex, which is already used by smc_ib_devices.mutex.

Thanks for your reply.

I have noticed that the "pnettable->lock" rwlock is acquired several times
in different functions of net/smc/smc_pnet.c. smc_pnetid_by_table_ib() is j=
ust one
of many functions that acquire that rwlock.

Therefore, my question is... are you _really_ sure that "pnettable->lock" c=
an be=20
safely converted to a mutex everywhere in net/smc?

I haven't read _all_ the path that lead to {write,read}_lock(&pnettable->lo=
ck) in=20
the net/smc code.

I think that before submitting that patch I should carefully read the code =
and check
_all_ the paths, unless you can confirm that the conversion is safe everywh=
ere. If=20
you can answer my question, I can work on a patch by this evening (CET time=
 zone)=20
and, obviously, give you proper credit.

Thank you,

=46abio M. De Francesco

>=20
> Thank you,
> Tony Lu



