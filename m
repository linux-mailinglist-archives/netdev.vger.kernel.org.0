Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 475AAAC6CD
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 15:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394613AbfIGNqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 09:46:12 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38232 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728809AbfIGNqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 09:46:11 -0400
Received: by mail-pf1-f196.google.com with SMTP id h195so6409424pfe.5
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 06:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hGN0VAJqy9BvobpRo2wGKqQ/hJyK8BQ2uEBPH7WP5Vk=;
        b=uxEf21KqjNVant8AhZF//n8CUwwLXEHf9Aysyc4X6bAC6dgo4JDa10d2rRW4BxU41x
         3DI7y3TqPlTHWvkvVqjaOrtF41DHtPbFnDN4/TQyxs6e5MQtIqrFVApOAsrJYDN5GHTg
         ofj1Av6/kHAHPtvMJMGQYqA4JTFm4/cVeQAv2n7/gWhLpd2cFT2Dywgbcn2ON6Dn92Vm
         N8TuPahuFxDXIX1MVUTNfhErbIPFwB43Tlz0v5BlAFCBEcjhfBpGZkPPdcAoPL8OTQiw
         4bpGQgdkHwtHoSFtU0shfHH2iCO7tzYvX1Xfr82vA6tDrJoAQGGWk+dN2P/LTSU6wkM/
         T2Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hGN0VAJqy9BvobpRo2wGKqQ/hJyK8BQ2uEBPH7WP5Vk=;
        b=NmtK2AwGhwNKkeuNDyajhv3LHaMWSYVqe1SQEO42Ws+f/Wco6zF20aaBT72sKtyP54
         A2Rv2MoE8z05rab8EGM4y9ovpdS5xDxlzzZgBFEUL4i6r1QMMkAYXaKaiUApoiyK5eak
         4c0oIcwTN6OQryBPTAX7GKnVV/IUJQakLt/ppo6TSF/wkisjdy90WqMKOqAnwqd2www/
         nvLJndHH2AkZnXxIIvIOKIGGQrIvK3zCNImFzVdrRQ3ufavp75YJ6M5uETQ6xXROpgtI
         lzfMbVJAcuYKyrilL5ZYuxlk01VTwmJ32RRuoEyitKpXFXRzbLbSl1BOFMqhTwA4vjun
         7Bqg==
X-Gm-Message-State: APjAAAXtW8b7zsdS6bh41tc3O5efHdwImza/lOknuSVtgVoY6Wg+SK27
        4EGKaDG77HFoH0bbVKsdqxE=
X-Google-Smtp-Source: APXvYqzwepncP+fM2zDj5s9hKozh91s/Iu+BATtSwcJY3WhJ/Wd3s/m49OJzWpjZOg8qHoWx6/nDMw==
X-Received: by 2002:a65:5786:: with SMTP id b6mr12499019pgr.236.1567863971051;
        Sat, 07 Sep 2019 06:46:11 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id o35sm7462091pgm.29.2019.09.07.06.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 06:46:10 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        hare@suse.de, varun@chelsio.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com, jay.vosburgh@canonical.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 03/11] bonding: fix unexpected IFF_BONDING bit unset
Date:   Sat,  7 Sep 2019 22:46:00 +0900
Message-Id: <20190907134600.32152-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IFF_BONDING means bonding master or bonding slave device.
->ndo_add_slave() sets IFF_BONDING flag and ->ndo_del_slave() unsets
IFF_BONDING flag.

bond0<--bond1

Both bond0 and bond1 are bonding device and these should keep having
IFF_BONDING flag until they are removed.
But bond1 would lose IFF_BONDING at ->ndo_del_slave() because that routine
do not check whether the slave device is the bonding type or not.
This patch adds the interface type check routine before removing
IFF_BONDING flag.

Test commands:
    ip link add bond0 type bond
    ip link add bond1 type bond
    ip link set bond1 master bond0
    ip link set bond1 nomaster
    ip link del bond1 type bond
    ip link add bond1 type bond

Splat looks like:
[  149.201107] proc_dir_entry 'bonding/bond1' already registered
[  149.208013] WARNING: CPU: 1 PID: 1308 at fs/proc/generic.c:361 proc_register+0x2a9/0x3e0
[  149.208866] Modules linked in: bonding veth openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv4 ip_tables6
[  149.208866] CPU: 1 PID: 1308 Comm: ip Not tainted 5.3.0-rc7+ #322
[  149.208866] RIP: 0010:proc_register+0x2a9/0x3e0
[  149.208866] Code: 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 39 01 00 00 48 8b 04 24 48 89 ea 48 c7 c7 a0 a0 13 89 48 8b b0 0
[  149.208866] RSP: 0018:ffff88810df9f098 EFLAGS: 00010286
[  149.208866] RAX: dffffc0000000008 RBX: ffff8880b5d3aa50 RCX: ffffffff87cdec92
[  149.208866] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff888116bf6a8c
[  149.208866] RBP: ffff8880b5d3acd3 R08: ffffed1022d7ff71 R09: ffffed1022d7ff71
[  149.208866] R10: 0000000000000001 R11: ffffed1022d7ff70 R12: ffff8880b5d3abe8
[  149.208866] R13: ffff8880b5d3acd2 R14: dffffc0000000000 R15: ffffed1016ba759a
[  149.208866] FS:  00007f4bd1f650c0(0000) GS:ffff888116a00000(0000) knlGS:0000000000000000
[  149.208866] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  149.208866] CR2: 000055e7ca686118 CR3: 0000000106fd4000 CR4: 00000000001006e0
[  149.208866] Call Trace:
[  149.208866]  proc_create_seq_private+0xb3/0xf0
[  149.208866]  bond_create_proc_entry+0x1b3/0x3f0 [bonding]
[  149.208866]  bond_netdev_event+0x433/0x970 [bonding]
[  149.208866]  ? __module_text_address+0x13/0x140
[  149.208866]  notifier_call_chain+0x90/0x160
[  149.208866]  register_netdevice+0x9b3/0xd70
[  149.208866]  ? alloc_netdev_mqs+0x854/0xc10
[  149.208866]  ? netdev_change_features+0xa0/0xa0
[  149.208866]  ? rtnl_create_link+0x2ed/0xad0
[  149.208866]  bond_newlink+0x2a/0x60 [bonding]
[  149.208866]  __rtnl_newlink+0xb75/0x1180
[  ... ]

Fixes: 0b680e753724 ("[PATCH] bonding: Add priv_flag to avoid event mishandling")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2: do not add a new priv_flag.

 drivers/net/bonding/bond_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 931d9d935686..0db12fcfc953 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1816,7 +1816,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	slave_disable_netpoll(new_slave);
 
 err_close:
-	slave_dev->priv_flags &= ~IFF_BONDING;
+	if (!netif_is_bond_master(slave_dev))
+		slave_dev->priv_flags &= ~IFF_BONDING;
 	dev_close(slave_dev);
 
 err_restore_mac:
@@ -2017,7 +2018,8 @@ static int __bond_release_one(struct net_device *bond_dev,
 	else
 		dev_set_mtu(slave_dev, slave->original_mtu);
 
-	slave_dev->priv_flags &= ~IFF_BONDING;
+	if (!netif_is_bond_master(slave_dev))
+		slave_dev->priv_flags &= ~IFF_BONDING;
 
 	bond_free_slave(slave);
 
-- 
2.17.1

