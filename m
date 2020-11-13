Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5C02B21A6
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 18:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgKMRMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 12:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKMRMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 12:12:43 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4861BC0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 09:12:57 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id p22so8797591wmg.3
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 09:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nuviainc-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G5959Sfd524PERn7u8+EmoPhM992B2ttnFOZpqU0BBg=;
        b=ry0N6uIyWj4xDKKSimmK6/n5GNqb33O5MdaqXM3OniOVfoapkcEGFZvMsEvNnAPSJg
         u+WlFP3v7D/tZhGG9nuLryXRGPmUabu94qikFBI4MFc+xk/HpQr86mfrmKdQFeFgxFqA
         IqWOjL7Lhswni7tDG0xM0dV7N6Cam6BMYHUTTY+TaPN41GZOOwGehsHrNepzFWQyMN8j
         CUlMM0aQ2tlREfEmTuelgzM/3wnMJi92m5a+sQAR07ZulWzLskStBoOIRjCii6Yp9eLq
         4+AdO6B8N2n9U4PH0k/hTQntohFI+bYgo2dCd2Zqvt6ouVpNVSSlsg4FLBUTSPFDRIZ3
         hgaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G5959Sfd524PERn7u8+EmoPhM992B2ttnFOZpqU0BBg=;
        b=gFbbmwFdfMTiL155slyCoyczPPUDT5i84YwIxIjsrASLLfKiPBQCXJOzhXlHB89TGM
         K3/apkBVmQttktdK4TeoGk3/A5RO6fZR2AEhIFxG+bCZGDAHWh+0LG37nMpnwila4lUl
         vuN2pJmHRokBc6461KQHu8dzVdmJ/Xkp+gltGElPNB3LgQyOU7WhGiwsU7bg1UR8Oklr
         hA3MxxAjK75x59uCVCdxPcNZW+IzfOOBV81LvlVIqsyABbZFeAJD9nXz1iZAS+WRN/F8
         Xh32l0JoumKxyR+kVQEBHyFuLQEOEDPIgKyjqG9rn8qL5NIcMroPKx0HS1lwBJgwDrTp
         0pRA==
X-Gm-Message-State: AOAM533t7wxJV8BdOJWxTq/Mv2NfMEs5ZiILfH10P6ArzCaZngG3m8C/
        lY8X5TrK9WT5+0hGQfPVGaPymrKJre+8JypnRNGy+bEkmCZo8/Zs/urDJuM1J/eI6NcdcLZN7aj
        qLFlezS/9wrFi0vXuIMLqSrdJQ7s5u651thxVWQZT8yLjaxXpveK+xIVJHgUcx+WcY8YxYQ==
X-Google-Smtp-Source: ABdhPJxfgtrIuZpD9SyDpA11GvO4lX5ti7IOVNYlZH43Kmwq3GdqbLZzwecXPwSSEsmXc6SPiwv/Hw==
X-Received: by 2002:a1c:7202:: with SMTP id n2mr3392182wmc.38.1605287568711;
        Fri, 13 Nov 2020 09:12:48 -0800 (PST)
Received: from localhost ([82.44.17.50])
        by smtp.gmail.com with ESMTPSA id 60sm8625033wrs.69.2020.11.13.09.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 09:12:47 -0800 (PST)
From:   Jamie Iles <jamie@nuviainc.com>
To:     netdev@vger.kernel.org
Cc:     Jamie Iles <jamie@nuviainc.com>, Qiushi Wu <wu000273@umn.edu>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCHv2] bonding: wait for sysfs kobject destruction before freeing struct slave
Date:   Fri, 13 Nov 2020 17:12:44 +0000
Message-Id: <20201113171244.15676-1-jamie@nuviainc.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <d4b96330-4ee1-6393-1096-03a06abd3889@gmail.com>
References: <d4b96330-4ee1-6393-1096-03a06abd3889@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzkaller found that with CONFIG_DEBUG_KOBJECT_RELEASE=y, releasing a
struct slave device could result in the following splat:

  kobject: 'bonding_slave' (00000000cecdd4fe): kobject_release, parent 0000000074ceb2b2 (delayed 1000)
  bond0 (unregistering): (slave bond_slave_1): Releasing backup interface
  ------------[ cut here ]------------
  ODEBUG: free active (active state 0) object type: timer_list hint: workqueue_select_cpu_near kernel/workqueue.c:1549 [inline]
  ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x98 kernel/workqueue.c:1600
  WARNING: CPU: 1 PID: 842 at lib/debugobjects.c:485 debug_print_object+0x180/0x240 lib/debugobjects.c:485
  Kernel panic - not syncing: panic_on_warn set ...
  CPU: 1 PID: 842 Comm: kworker/u4:4 Tainted: G S                5.9.0-rc8+ #96
  Hardware name: linux,dummy-virt (DT)
  Workqueue: netns cleanup_net
  Call trace:
   dump_backtrace+0x0/0x4d8 include/linux/bitmap.h:239
   show_stack+0x34/0x48 arch/arm64/kernel/traps.c:142
   __dump_stack lib/dump_stack.c:77 [inline]
   dump_stack+0x174/0x1f8 lib/dump_stack.c:118
   panic+0x360/0x7a0 kernel/panic.c:231
   __warn+0x244/0x2ec kernel/panic.c:600
   report_bug+0x240/0x398 lib/bug.c:198
   bug_handler+0x50/0xc0 arch/arm64/kernel/traps.c:974
   call_break_hook+0x160/0x1d8 arch/arm64/kernel/debug-monitors.c:322
   brk_handler+0x30/0xc0 arch/arm64/kernel/debug-monitors.c:329
   do_debug_exception+0x184/0x340 arch/arm64/mm/fault.c:864
   el1_dbg+0x48/0xb0 arch/arm64/kernel/entry-common.c:65
   el1_sync_handler+0x170/0x1c8 arch/arm64/kernel/entry-common.c:93
   el1_sync+0x80/0x100 arch/arm64/kernel/entry.S:594
   debug_print_object+0x180/0x240 lib/debugobjects.c:485
   __debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
   debug_check_no_obj_freed+0x200/0x430 lib/debugobjects.c:998
   slab_free_hook mm/slub.c:1536 [inline]
   slab_free_freelist_hook+0x190/0x210 mm/slub.c:1577
   slab_free mm/slub.c:3138 [inline]
   kfree+0x13c/0x460 mm/slub.c:4119
   bond_free_slave+0x8c/0xf8 drivers/net/bonding/bond_main.c:1492
   __bond_release_one+0xe0c/0xec8 drivers/net/bonding/bond_main.c:2190
   bond_slave_netdev_event drivers/net/bonding/bond_main.c:3309 [inline]
   bond_netdev_event+0x8f0/0xa70 drivers/net/bonding/bond_main.c:3420
   notifier_call_chain+0xf0/0x200 kernel/notifier.c:83
   __raw_notifier_call_chain kernel/notifier.c:361 [inline]
   raw_notifier_call_chain+0x44/0x58 kernel/notifier.c:368
   call_netdevice_notifiers_info+0xbc/0x150 net/core/dev.c:2033
   call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
   call_netdevice_notifiers net/core/dev.c:2059 [inline]
   rollback_registered_many+0x6a4/0xec0 net/core/dev.c:9347
   unregister_netdevice_many.part.0+0x2c/0x1c0 net/core/dev.c:10509
   unregister_netdevice_many net/core/dev.c:10508 [inline]
   default_device_exit_batch+0x294/0x338 net/core/dev.c:10992
   ops_exit_list.isra.0+0xec/0x150 net/core/net_namespace.c:189
   cleanup_net+0x44c/0x888 net/core/net_namespace.c:603
   process_one_work+0x96c/0x18c0 kernel/workqueue.c:2269
   worker_thread+0x3f0/0xc30 kernel/workqueue.c:2415
   kthread+0x390/0x498 kernel/kthread.c:292
   ret_from_fork+0x10/0x18 arch/arm64/kernel/entry.S:925

This is a potential use-after-free if the sysfs nodes are being accessed
whilst removing the struct slave, so wait for the object destruction to
complete before freeing the struct slave itself.

Fixes: 07699f9a7c8d ("bonding: add sysfs /slave dir for bond slave devices.")
Fixes: a068aab42258 ("bonding: Fix reference count leak in bond_sysfs_slave_add.")
Cc: Qiushi Wu <wu000273@umn.edu>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Jamie Iles <jamie@nuviainc.com>
---
v2:
 - use a kref for managing the slave lifecycle rather than waiting on a 
   completion and blocking

 drivers/net/bonding/bond_main.c        | 19 ++++++++++++++---
 drivers/net/bonding/bond_sysfs_slave.c | 28 ++++++++++++++++++--------
 include/net/bonding.h                  |  4 ++++
 3 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 84ecbc6fa0ff..66e56642e6c2 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1478,11 +1478,14 @@ static struct slave *bond_alloc_slave(struct bonding *bond)
 	}
 	INIT_DELAYED_WORK(&slave->notify_work, bond_netdev_notify_work);
 
+	kref_init(&slave->ref);
+
 	return slave;
 }
 
-static void bond_free_slave(struct slave *slave)
+static void __bond_free_slave(struct kref *ref)
 {
+	struct slave *slave = container_of(ref, struct slave, ref);
 	struct bonding *bond = bond_get_bond_by_slave(slave);
 
 	cancel_delayed_work_sync(&slave->notify_work);
@@ -1492,6 +1495,16 @@ static void bond_free_slave(struct slave *slave)
 	kfree(slave);
 }
 
+void bond_slave_put_ref(struct slave *slave)
+{
+	kref_put(&slave->ref, __bond_free_slave);
+}
+
+void bond_slave_get_ref(struct slave *slave)
+{
+	kref_get(&slave->ref);
+}
+
 static void bond_fill_ifbond(struct bonding *bond, struct ifbond *info)
 {
 	info->bond_mode = BOND_MODE(bond);
@@ -2007,7 +2020,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	dev_set_mtu(slave_dev, new_slave->original_mtu);
 
 err_free:
-	bond_free_slave(new_slave);
+	bond_slave_put_ref(new_slave);
 
 err_undo_flags:
 	/* Enslave of first slave has failed and we need to fix master's mac */
@@ -2187,7 +2200,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 	if (!netif_is_bond_master(slave_dev))
 		slave_dev->priv_flags &= ~IFF_BONDING;
 
-	bond_free_slave(slave);
+	bond_slave_put_ref(slave);
 
 	return 0;
 }
diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
index 9b8346638f69..5f8aac715ee8 100644
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -136,7 +136,15 @@ static const struct sysfs_ops slave_sysfs_ops = {
 	.show = slave_show,
 };
 
+static void slave_release(struct kobject *kobj)
+{
+	struct slave *slave = to_slave(kobj);
+
+	bond_slave_put_ref(slave);
+}
+
 static struct kobj_type slave_ktype = {
+	.release = slave_release,
 #ifdef CONFIG_SYSFS
 	.sysfs_ops = &slave_sysfs_ops,
 #endif
@@ -147,22 +155,26 @@ int bond_sysfs_slave_add(struct slave *slave)
 	const struct slave_attribute **a;
 	int err;
 
+	bond_slave_get_ref(slave);
+
 	err = kobject_init_and_add(&slave->kobj, &slave_ktype,
 				   &(slave->dev->dev.kobj), "bonding_slave");
-	if (err) {
-		kobject_put(&slave->kobj);
-		return err;
-	}
+	if (err)
+		goto out_put_slave;
 
 	for (a = slave_attrs; *a; ++a) {
 		err = sysfs_create_file(&slave->kobj, &((*a)->attr));
-		if (err) {
-			kobject_put(&slave->kobj);
-			return err;
-		}
+		if (err)
+			goto out_put_slave;
 	}
 
 	return 0;
+
+out_put_slave:
+	kobject_put(&slave->kobj);
+	bond_slave_put_ref(slave);
+
+	return err;
 }
 
 void bond_sysfs_slave_del(struct slave *slave)
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 7d132cc1e584..e286ff4e0882 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -25,6 +25,7 @@
 #include <linux/etherdevice.h>
 #include <linux/reciprocal_div.h>
 #include <linux/if_link.h>
+#include <linux/kref.h>
 
 #include <net/bond_3ad.h>
 #include <net/bond_alb.h>
@@ -157,6 +158,7 @@ struct bond_parm_tbl {
 struct slave {
 	struct net_device *dev; /* first - useful for panic debug */
 	struct bonding *bond; /* our master */
+	struct kref ref;
 	int    delay;
 	/* all three in jiffies */
 	unsigned long last_link_up;
@@ -649,6 +651,8 @@ struct bond_vlan_tag *bond_verify_device_path(struct net_device *start_dev,
 int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave);
 void bond_slave_arr_work_rearm(struct bonding *bond, unsigned long delay);
 void bond_work_init_all(struct bonding *bond);
+void bond_slave_get_ref(struct slave *slave);
+void bond_slave_put_ref(struct slave *slave);
 
 #ifdef CONFIG_PROC_FS
 void bond_create_proc_entry(struct bonding *bond);
-- 
2.27.0

