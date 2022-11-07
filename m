Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133D261FBB1
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 18:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbiKGRnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 12:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbiKGRm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 12:42:59 -0500
Received: from mx0b-003ede02.pphosted.com (mx0b-003ede02.pphosted.com [205.220.181.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0480121816
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 09:42:56 -0800 (PST)
Received: from pps.filterd (m0286621.ppops.net [127.0.0.1])
        by mx0b-003ede02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A79A7QA019921
        for <netdev@vger.kernel.org>; Mon, 7 Nov 2022 09:42:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=getcruise.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=ppemail; bh=EKZW+OM0YYzxIQ5sUbXqtVvs9Qv6OwNWnQDM6JO7I7I=;
 b=h1CFx+qC2SlJ+ColhkHHN1aqwaNUZZHjqKeBrdDZQ8ubbaHqOEPbH7uppLNkA1qS+G1U
 eBMHuiAwUsE0+ZqPHaep4801a4F+RkIBT/8cbfAdJ91sWPS5cbtphe34GI04TlhDKbL8
 AnH4USafe47viow6pQhFjkznkjLK6Twv8jlKr4x9wtN/6zDuI1jVQt9m9/tBU/Ye8rp/
 ny5awc28GWVXgX/SLwxzTh8XEysDz4dc6bkls9jb4G42KKW37rL3/tD4FmJFRDWBuNBN
 00gHpyvOltVrPSk80W2vItFAgzhAW5NnDsao9/pJm3JC7sLniMi3Ly4qodOYR2V6dWXp GA== 
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        by mx0b-003ede02.pphosted.com (PPS) with ESMTPS id 3knpwfht3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 09:42:55 -0800
Received: by mail-pl1-f199.google.com with SMTP id b18-20020a170903229200b00186e357f3b9so9457560plh.6
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 09:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=getcruise.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EKZW+OM0YYzxIQ5sUbXqtVvs9Qv6OwNWnQDM6JO7I7I=;
        b=i2+VxAsn3kUgmIUwbHwzyDITUZY6YYCDyUdzRWSYNzpPfElyfbicZAUTYTgZrifyhO
         M4rhyyuPIqxfC3iNFRFEJ4YoMXx2PCC/CeHiHmwZ9uXhBYCn+zTyI1MO/rF1tOSfVm9V
         anbLkmPdapTEUPxUVke1MlY8o9Cm+UFc5SI6xu716POrkrlKZiXy0ULlWRm42vxNUuZk
         m6PPvvc/QRKeAhwJA5Tsh7EorPgNUTmEbSQUB51hnTILn4zrMBq5z7S5NWUkOkUyiqxp
         Rl6CCy3F+qKrzv4xq9FpK5n9aLh7Mr1TdnIursF6tO/PoHedEnmtCFXSpZicPc48z1X9
         ciRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EKZW+OM0YYzxIQ5sUbXqtVvs9Qv6OwNWnQDM6JO7I7I=;
        b=BQLkpjeG75DaP2LFoGKGkOsLPuSgPd5264Ro/7mHSxCjgvoG3daE5zZoBNQK0rqfHT
         kWLMljieSThHPPiVBbjw9ARHiBZtmoEyTqlHcl8atFXZRaZzTUQbM6Uk9X7wp+jJHelC
         0eWkwNC+GgMAXeUpvA0m3JgaYFaxzKDZCmfL1zhSVKQUrdAdK2ZFt4detrwQWk+M3cLg
         bIEQBks/QMVKP8BkhksQC+k7VOGSV+M5jreKx2Cm54QQ2ctptoYDgcUZ4K1xDKT1ugJM
         3a9cfMvmezouodgjucd350BkIrl6c1zjfWpgHZxsPWBJzYznOpRDP5AwG8mvUpcc7B7r
         Ks2w==
X-Gm-Message-State: ACrzQf3A7CBLSnrMq6dTh5pU+Rgn84sAYkCgf9+YLuXAC6Ai/0G3A9XM
        ED6JdgxD0F5n8FlU7qaOYMxu05sJxWQ993LJ7IttIg73pVxjkiXNGf+2EVi7P9DSbXqc5MT/O3m
        ELS503M9vDlRiM+Q=
X-Received: by 2002:a17:90b:1c8d:b0:203:cc25:4eb5 with SMTP id oo13-20020a17090b1c8d00b00203cc254eb5mr52879041pjb.132.1667842974181;
        Mon, 07 Nov 2022 09:42:54 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5nYWRanWLVyNGIsYCZVe4KUdR09guccyr+xLtnOFC9P2dlbCS7RA+fHkHbpYO9YMYerhZLDA==
X-Received: by 2002:a17:90b:1c8d:b0:203:cc25:4eb5 with SMTP id oo13-20020a17090b1c8d00b00203cc254eb5mr52879010pjb.132.1667842973895;
        Mon, 07 Nov 2022 09:42:53 -0800 (PST)
Received: from 4VPLMR2-DT.corp.robot.car ([199.73.125.241])
        by smtp.gmail.com with ESMTPSA id l9-20020a17090a384900b001f94d25bfabsm6397792pjf.28.2022.11.07.09.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 09:42:53 -0800 (PST)
From:   Andy Ren <andy.ren@getcruise.com>
To:     netdev@vger.kernel.org
Cc:     richardbgobert@gmail.com, davem@davemloft.net,
        wsa+renesas@sang-engineering.com, edumazet@google.com,
        petrm@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, andrew@lunn.ch, dsahern@gmail.com,
        sthemmin@microsoft.com, idosch@idosch.org,
        sridhar.samudrala@intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, roman.gushchin@linux.dev,
        Andy Ren <andy.ren@getcruise.com>
Subject: [PATCH net-next v3] net/core: Allow live renaming when an interface is up
Date:   Mon,  7 Nov 2022 09:42:42 -0800
Message-Id: <20221107174242.1947286-1-andy.ren@getcruise.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: iQmOVfv3MubPRbY9fKyJW4B0vUBzyOf7
X-Proofpoint-GUID: iQmOVfv3MubPRbY9fKyJW4B0vUBzyOf7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_08,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 impostorscore=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070141
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow a network interface to be renamed when the interface
is up.

As described in the netconsole documentation [1], when netconsole is
used as a built-in, it will bring up the specified interface as soon as
possible. As a result, user space will not be able to rename the
interface since the kernel disallows renaming of interfaces that are
administratively up unless the 'IFF_LIVE_RENAME_OK' private flag was set
by the kernel.

The original solution [2] to this problem was to add a new parameter to
the netconsole configuration parameters that allows renaming of
the interface used by netconsole while it is administratively up.
However, during the discussion that followed, it became apparent that we
have no reason to keep the current restriction and instead we should
allow user space to rename interfaces regardless of their administrative
state:

1. The restriction was put in place over 20 years ago when renaming was
only possible via IOCTL and before rtnetlink started notifying user
space about such changes like it does today.

2. The 'IFF_LIVE_RENAME_OK' flag was added over 3 years ago in version
5.2 and no regressions were reported.

3. In-kernel listeners to 'NETDEV_CHANGENAME' do not seem to care about
the administrative state of interface.

Therefore, allow user space to rename running interfaces by removing the
restriction and the associated 'IFF_LIVE_RENAME_OK' flag. Help in
possible triage by emitting a message to the kernel log that an
interface was renamed while UP.

[1] https://www.kernel.org/doc/Documentation/networking/netconsole.rst
[2] https://lore.kernel.org/netdev/20221102002420.2613004-1-andy.ren@getcruise.com/

Signed-off-by: Andy Ren <andy.ren@getcruise.com>
---

Notes:
    Changes from v1->v2
    - Added placeholder comment in place of removed IFF_LIVE_RENAME_OK flag
    - Added extra logging hints to indicate whether a network interface was
    renamed while UP
    
    Changes from v2->v3
    - Patch description changes

 include/linux/netdevice.h |  4 +---
 net/core/dev.c            | 19 ++-----------------
 net/core/failover.c       |  6 +++---
 3 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d45713a06568..4be87b89e481 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1650,7 +1650,6 @@ struct net_device_ops {
  * @IFF_FAILOVER: device is a failover master device
  * @IFF_FAILOVER_SLAVE: device is lower dev of a failover master device
  * @IFF_L3MDEV_RX_HANDLER: only invoke the rx handler of L3 master device
- * @IFF_LIVE_RENAME_OK: rename is allowed while device is up and running
  * @IFF_TX_SKB_NO_LINEAR: device/driver is capable of xmitting frames with
  *	skb_headlen(skb) == 0 (data starts from frag0)
  * @IFF_CHANGE_PROTO_DOWN: device supports setting carrier via IFLA_PROTO_DOWN
@@ -1686,7 +1685,7 @@ enum netdev_priv_flags {
 	IFF_FAILOVER			= 1<<27,
 	IFF_FAILOVER_SLAVE		= 1<<28,
 	IFF_L3MDEV_RX_HANDLER		= 1<<29,
-	IFF_LIVE_RENAME_OK		= 1<<30,
+	/* was IFF_LIVE_RENAME_OK */
 	IFF_TX_SKB_NO_LINEAR		= BIT_ULL(31),
 	IFF_CHANGE_PROTO_DOWN		= BIT_ULL(32),
 };
@@ -1721,7 +1720,6 @@ enum netdev_priv_flags {
 #define IFF_FAILOVER			IFF_FAILOVER
 #define IFF_FAILOVER_SLAVE		IFF_FAILOVER_SLAVE
 #define IFF_L3MDEV_RX_HANDLER		IFF_L3MDEV_RX_HANDLER
-#define IFF_LIVE_RENAME_OK		IFF_LIVE_RENAME_OK
 #define IFF_TX_SKB_NO_LINEAR		IFF_TX_SKB_NO_LINEAR
 
 /* Specifies the type of the struct net_device::ml_priv pointer */
diff --git a/net/core/dev.c b/net/core/dev.c
index 3bacee3bee78..707de6b841d0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1163,22 +1163,6 @@ int dev_change_name(struct net_device *dev, const char *newname)
 
 	net = dev_net(dev);
 
-	/* Some auto-enslaved devices e.g. failover slaves are
-	 * special, as userspace might rename the device after
-	 * the interface had been brought up and running since
-	 * the point kernel initiated auto-enslavement. Allow
-	 * live name change even when these slave devices are
-	 * up and running.
-	 *
-	 * Typically, users of these auto-enslaving devices
-	 * don't actually care about slave name change, as
-	 * they are supposed to operate on master interface
-	 * directly.
-	 */
-	if (dev->flags & IFF_UP &&
-	    likely(!(dev->priv_flags & IFF_LIVE_RENAME_OK)))
-		return -EBUSY;
-
 	down_write(&devnet_rename_sem);
 
 	if (strncmp(newname, dev->name, IFNAMSIZ) == 0) {
@@ -1195,7 +1179,8 @@ int dev_change_name(struct net_device *dev, const char *newname)
 	}
 
 	if (oldname[0] && !strchr(oldname, '%'))
-		netdev_info(dev, "renamed from %s\n", oldname);
+		netdev_info(dev, "renamed from %s%s\n", oldname,
+			    dev->flags & IFF_UP ? " (while UP)" : "");
 
 	old_assign_type = dev->name_assign_type;
 	dev->name_assign_type = NET_NAME_RENAMED;
diff --git a/net/core/failover.c b/net/core/failover.c
index 864d2d83eff4..655411c4ca51 100644
--- a/net/core/failover.c
+++ b/net/core/failover.c
@@ -80,14 +80,14 @@ static int failover_slave_register(struct net_device *slave_dev)
 		goto err_upper_link;
 	}
 
-	slave_dev->priv_flags |= (IFF_FAILOVER_SLAVE | IFF_LIVE_RENAME_OK);
+	slave_dev->priv_flags |= IFF_FAILOVER_SLAVE;
 
 	if (fops && fops->slave_register &&
 	    !fops->slave_register(slave_dev, failover_dev))
 		return NOTIFY_OK;
 
 	netdev_upper_dev_unlink(slave_dev, failover_dev);
-	slave_dev->priv_flags &= ~(IFF_FAILOVER_SLAVE | IFF_LIVE_RENAME_OK);
+	slave_dev->priv_flags &= ~IFF_FAILOVER_SLAVE;
 err_upper_link:
 	netdev_rx_handler_unregister(slave_dev);
 done:
@@ -121,7 +121,7 @@ int failover_slave_unregister(struct net_device *slave_dev)
 
 	netdev_rx_handler_unregister(slave_dev);
 	netdev_upper_dev_unlink(slave_dev, failover_dev);
-	slave_dev->priv_flags &= ~(IFF_FAILOVER_SLAVE | IFF_LIVE_RENAME_OK);
+	slave_dev->priv_flags &= ~IFF_FAILOVER_SLAVE;
 
 	if (fops && fops->slave_unregister &&
 	    !fops->slave_unregister(slave_dev, failover_dev))
-- 
2.38.1

