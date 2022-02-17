Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0607F4BA7A9
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243978AbiBQSFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:05:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240373AbiBQSFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:05:51 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3F3291F9A;
        Thu, 17 Feb 2022 10:05:36 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id l12-20020a7bc34c000000b003467c58cbdfso6815238wmj.2;
        Thu, 17 Feb 2022 10:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cwhqG4PjSxyhdk9byzTdeRpRASQMOOB/h+pJH2F1Kq8=;
        b=mI91NydIzkJr/9KH744xMRolPpdWlzjEtP/2fNTiN8HHiXv84ojx5RPXGw/NqDtnAW
         ZCKplfo4rI1K+8ISmP8YnOI8qSJXpC4zBiaRDO4iHqSMG8K9o0ZvNY+1KPbOZ/2oJyej
         CbD5wuPYVSGfPAMbwFbKZ+NILx5iQsqMJ82MchbGTOy/XWHgu63T2ZdM4BvcFc7uSTpY
         fGh6m+U2U/hXez1sUdlByHIDuhBKtkWsdeuacMAg4cAnf4YRzzEBJe9Zm2j6s8wzKTy6
         odjxg1SG0edDnPl109MAwVmkIIRBcHwcOBX1KTYO0cH9A1F91bbSn1YYJx0QrS0zbOG4
         UPnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cwhqG4PjSxyhdk9byzTdeRpRASQMOOB/h+pJH2F1Kq8=;
        b=mgG6jrlgrFxB5DSc4qxXUOfd0b6fzC0rIC/m/m+CADQhYJzoj1V5VdyatgPFI2X+U9
         7ksDuBSw2R0FowDj0uvpKCiXK3XTnd6HYHygPkv1F1G7yRU9KZmUusux7clOer/5rMZj
         Nhyl6qPVkFWGrvgC1Mx8rKJxQIQGU4HJj5GiSM/lv2Ffh4HxkMOjy9oaOnNeOvah9ITu
         gzH1GWWPuLGRNSSLPcLK73/yktQMqee2HemH1k0WkojIP5gc0v0qOpXcpvJMHu5/ZH2P
         HPYEPRpL9YuzGkDGjq4Bquh6hBRhTG70vnFIcWtTlRnBsZcktiMggku1rAzD+nCPcIyg
         8IuQ==
X-Gm-Message-State: AOAM5316ghVGIgmIoNQ1Vb5Em8QZOpWOBeV6T8kXj6wznDsLCy2Kn+w3
        rT+zicIetX4tkIl4cXnO+DE=
X-Google-Smtp-Source: ABdhPJwn1QIrnHyMXL8TMdqKzqGKaJNhuLDgBAUXEvdBpoyu0KVG2M0M6Ms35TmBdJetxJ2PhOTReA==
X-Received: by 2002:a05:600c:19ce:b0:37c:6fe:68b6 with SMTP id u14-20020a05600c19ce00b0037c06fe68b6mr7074209wmq.90.1645121135151;
        Thu, 17 Feb 2022 10:05:35 -0800 (PST)
Received: from leap.localnet (host-79-27-0-81.retail.telecomitalia.it. [79.27.0.81])
        by smtp.gmail.com with ESMTPSA id d6sm38754441wrs.85.2022.02.17.10.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 10:05:34 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     jgg@ziepe.ca, liangwenpeng@huawei.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        liweihang@huawei.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Cc:     syzbot <syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com>
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in smc_pnet_apply_ib
Date:   Thu, 17 Feb 2022 19:05:31 +0100
Message-ID: <2691692.BEx9A2HvPv@leap>
In-Reply-To: <000000000000b772b805d8396f14@google.com>
References: <000000000000b772b805d8396f14@google.com>
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

On gioved=C3=AC 17 febbraio 2022 17:41:22 CET syzbot wrote:
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    c832962ac972 net: bridge: multicast: notify switchdev dri=
v..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D16b157bc700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D266de9da75c71=
a45
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D4f322a6d84e991c=
38775
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binuti=
ls for Debian) 2.35.2
>=20
> Unfortunately, I don't have any reproducer for this issue yet.
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com
>=20
> infiniband syz1: set down
> infiniband syz1: added lo
> RDS/IB: syz1: added
> smc: adding ib device syz1 with port count 1
> BUG: sleeping function called from invalid context at kernel/locking/mute=
x.c:577
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 17974, name: syz-e=
xecutor.3
> preempt_count: 1, expected: 0
> RCU nest depth: 0, expected: 0
> 6 locks held by syz-executor.3/17974:
>  #0: ffffffff90865838 (&rdma_nl_types[idx].sem){.+.+}-{3:3}, at: rdma_nl_=
rcv_msg+0x161/0x690 drivers/infiniband/core/netlink.c:164
>  #1: ffffffff8d04edf0 (link_ops_rwsem){++++}-{3:3}, at: nldev_newlink+0x2=
5d/0x560 drivers/infiniband/core/nldev.c:1707
>  #2: ffffffff8d03e650 (devices_rwsem){++++}-{3:3}, at: enable_device_and_=
get+0xfc/0x3b0 drivers/infiniband/core/device.c:1321
>  #3: ffffffff8d03e510 (clients_rwsem){++++}-{3:3}, at: enable_device_and_=
get+0x15b/0x3b0 drivers/infiniband/core/device.c:1329
>  #4: ffff8880482c85c0 (&device->client_data_rwsem){++++}-{3:3}, at: add_c=
lient_context+0x3d0/0x5e0 drivers/infiniband/core/device.c:718
>  #5: ffff8880230a4118 (&pnettable->lock){++++}-{2:2}, at: smc_pnetid_by_t=
able_ib+0x18c/0x470 net/smc/smc_pnet.c:1159
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 1 PID: 17974 Comm: syz-executor.3 Not tainted 5.17.0-rc3-syzkaller-0=
0170-gc832962ac972 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  __might_resched.cold+0x222/0x26b kernel/sched/core.c:9576
>  __mutex_lock_common kernel/locking/mutex.c:577 [inline]
>  __mutex_lock+0x9f/0x12f0 kernel/locking/mutex.c:733
>  smc_pnet_apply_ib+0x28/0x160 net/smc/smc_pnet.c:251
>  smc_pnetid_by_table_ib+0x2ae/0x470 net/smc/smc_pnet.c:1164

If I recall it well, read_lock() disables preemption.=20

smc_pnetid_by_table_ib() uses read_lock() and then it calls smc_pnet_apply_=
ib()=20
which, in turn, calls mutex_lock(&smc_ib_devices.mutex). Therefore the code=
=20
acquires a mutex while in atomic and we get a SAC bug.

Actually, even if my argument is correct(?), I don't know if the read_lock(=
)=20
in smc_pnetid_by_table_ib() can be converted to a sleeping lock like a mute=
x or=20
a semaphore.

Any comment?=20

Thanks,

=46abio M. De Francesco



