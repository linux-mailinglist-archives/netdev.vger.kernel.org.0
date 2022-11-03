Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D32618BC5
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 23:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiKCWqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 18:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiKCWqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 18:46:54 -0400
Received: from mx0b-003ede02.pphosted.com (mx0b-003ede02.pphosted.com [205.220.181.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959376429
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 15:46:53 -0700 (PDT)
Received: from pps.filterd (m0286618.ppops.net [127.0.0.1])
        by mx0b-003ede02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A3MkqdL030394
        for <netdev@vger.kernel.org>; Thu, 3 Nov 2022 15:46:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=getcruise.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=ppemail; bh=sVRvJGC5sqfEU9QZsnMrtFLb8qHeVXrcogKO2S26elc=;
 b=e417fwl08gleF8laXRckpIak7JgIEoxf8SRYn7re0PnyECuMD5K9sMuYxoj5Y0I0y3ia
 O0bd/LTLy57bjMnSajlyVwTy1qjf8d2ioCo/oNngSqHd1sijTjVQX0QpMBhkdCV4XTp/
 yTjOiSj2oIX9pemx7WLZ0YV8YpyOAHWe8lbp6BlyfUbbyS0ZJ6ZjnbZayxxi2tRvC81Q
 NfVl20W3QVsfeQiokeukkD7Z4xGoC1otqA2RF5GcUJOLtDKiDTME9R71B4usgD+BXe/m
 l7wrs0GZxb1PQVSjgR0W/1hkSjrRRuTcwtEBUan6lpTYIBa3pJVs/5K5thzK/yDjNwaL ig== 
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        by mx0b-003ede02.pphosted.com (PPS) with ESMTPS id 3kh1vwhe6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 15:46:52 -0700
Received: by mail-pl1-f197.google.com with SMTP id t3-20020a170902e84300b00186ab03043dso2186373plg.20
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 15:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=getcruise.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sVRvJGC5sqfEU9QZsnMrtFLb8qHeVXrcogKO2S26elc=;
        b=d8vNySAns775Y5vlpQ9BAqKXmMmw5Rd/++77lMlVDGHLko9chcCuI4F/xBzN4ugNB1
         R5Z12nHI6aoZO1klxUYm7kfEVrs8GIGER55Wy/izmkurKbmxHaVqa0u/PqG+EapaLXsf
         9jMKNcBfS34e1s8NOeUAzjX4MBuL7xR+VynQ5UWfqQM9Ntz1cNlHXs3kjWs4c+IBIKjg
         z/zfCIJtH+d/nPQ7n+B49V9+07vE1C1sZzTmu+hCCiOnnE5uafjPQgEddYeNODb2TgJn
         JEDMJx29MKfCzQZxjxZWZfKFc5EoZcLrBFLDvWS7x3yvdmg860BKuC+z1Ye+01dQ6SeT
         lRZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sVRvJGC5sqfEU9QZsnMrtFLb8qHeVXrcogKO2S26elc=;
        b=QvObNthe6Q97I2cDXc0PdWNckhXx6klUeT1OKYmAMFb5kRIeI8ds3QcEGVQMhjH0fo
         U0+9j1aibJbHsP8Oze+VVVYz3D81Roj5JfaOdchOEAxPnfmRjQ5C6ZuUETn0GY+xNFNe
         /Ob3KWu0SS78sW7ME6lbY9Cn7dXBm75IRyDROPn99DxC1riW2v83JchZEMF8HFWew22X
         /xK5BxcmJWOePUXlTt8q3ecHJIUA5CyinA59llJMgotCoCFoURknRGjUPA6FV1r8zQ2R
         dUOJiR11WjtZZ/xkk7omiTn34ugS0A9hwPZjksgSHQVGEtz+793TFpXeVO65KTCAbhpR
         C4Xg==
X-Gm-Message-State: ACrzQf1Z/JS/yZyuvwWc2kPQvN1AoCBJt0J3GEVI0KlgzCA1IqWs91cq
        udJ2BcoGEOO6Kn+T/J676t/3Huai7LAXETp12Hq3GlxPtZ3jdRFhoSbUMPS15xWnv7jiEjdlvmh
        8Vx9Ls5o9ibHrRHw=
X-Received: by 2002:a17:90a:ca13:b0:213:b85a:3bdb with SMTP id x19-20020a17090aca1300b00213b85a3bdbmr29368300pjt.97.1667515611447;
        Thu, 03 Nov 2022 15:46:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7TqjNmXDLkrEaa7CvwsAzH3YBoAkgB7TIg2KbN6E40Y4/gtA1Oa05aE4lEPo3NhAQo8vJ1vA==
X-Received: by 2002:a17:90a:ca13:b0:213:b85a:3bdb with SMTP id x19-20020a17090aca1300b00213b85a3bdbmr29368271pjt.97.1667515611102;
        Thu, 03 Nov 2022 15:46:51 -0700 (PDT)
Received: from 4VPLMR2-DT.corp.robot.car ([199.73.125.241])
        by smtp.gmail.com with ESMTPSA id x188-20020a6331c5000000b0043941566481sm1250977pgx.39.2022.11.03.15.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 15:46:50 -0700 (PDT)
From:   Andy Ren <andy.ren@getcruise.com>
To:     netdev@vger.kernel.org
Cc:     richardbgobert@gmail.com, davem@davemloft.net,
        wsa+renesas@sang-engineering.com, edumazet@google.com,
        petrm@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, andrew@lunn.ch, dsahern@gmail.com,
        sthemmin@microsoft.com, idosch@idosch.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        roman.gushchin@linux.dev, Andy Ren <andy.ren@getcruise.com>
Subject: [PATCH net-next] net/core: Allow live renaming when an interface is up
Date:   Thu,  3 Nov 2022 15:46:44 -0700
Message-Id: <20221103224644.3806447-1-andy.ren@getcruise.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: JtSX1PzA2a4ML4xNLEjsL28kxD9gGlKZ
X-Proofpoint-GUID: JtSX1PzA2a4ML4xNLEjsL28kxD9gGlKZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 adultscore=0 mlxlogscore=674 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211030156
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows a network interface to be renamed when the interface
is up.

Live renaming was added as a failover in the past, and there has been no
arising issues of user space breaking. Furthermore, it seems that this
flag was added because in the past, IOCTL was used for renaming, which
would not notify the user space. Nowadays, it appears that the user
space receives notifications regardless of the state of the network
device (e.g. rtnetlink_event()). The listeners for NETDEV_CHANGENAME
also do not strictly ensure that the netdev is up or not.

Hence, this patch seeks to remove the live renaming flag and checks due
to the aforementioned reasons.

The changes are of following:
- Remove IFF_LIVE_RENAME_OK flag declarations
- Remove check in dev_change_name that checks whether device is up and
if IFF_LIVE_RENAME_OK is set by the network device's priv_flags
- Remove references of IFF_LIVE_RENAME_OK in the failover module

Signed-off-by: Andy Ren <andy.ren@getcruise.com>
---
 include/linux/netdevice.h | 3 ---
 net/core/dev.c            | 4 ----
 net/core/failover.c       | 6 +++---
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4b5052db978f..e2ff45aa17f5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1655,7 +1655,6 @@ struct net_device_ops {
  * @IFF_FAILOVER: device is a failover master device
  * @IFF_FAILOVER_SLAVE: device is lower dev of a failover master device
  * @IFF_L3MDEV_RX_HANDLER: only invoke the rx handler of L3 master device
- * @IFF_LIVE_RENAME_OK: rename is allowed while device is up and running
  * @IFF_TX_SKB_NO_LINEAR: device/driver is capable of xmitting frames with
  *	skb_headlen(skb) == 0 (data starts from frag0)
  * @IFF_CHANGE_PROTO_DOWN: device supports setting carrier via IFLA_PROTO_DOWN
@@ -1691,7 +1690,6 @@ enum netdev_priv_flags {
 	IFF_FAILOVER			= 1<<27,
 	IFF_FAILOVER_SLAVE		= 1<<28,
 	IFF_L3MDEV_RX_HANDLER		= 1<<29,
-	IFF_LIVE_RENAME_OK		= 1<<30,
 	IFF_TX_SKB_NO_LINEAR		= BIT_ULL(31),
 	IFF_CHANGE_PROTO_DOWN		= BIT_ULL(32),
 };
@@ -1726,7 +1724,6 @@ enum netdev_priv_flags {
 #define IFF_FAILOVER			IFF_FAILOVER
 #define IFF_FAILOVER_SLAVE		IFF_FAILOVER_SLAVE
 #define IFF_L3MDEV_RX_HANDLER		IFF_L3MDEV_RX_HANDLER
-#define IFF_LIVE_RENAME_OK		IFF_LIVE_RENAME_OK
 #define IFF_TX_SKB_NO_LINEAR		IFF_TX_SKB_NO_LINEAR
 
 /* Specifies the type of the struct net_device::ml_priv pointer */
diff --git a/net/core/dev.c b/net/core/dev.c
index 2e4f1c97b59e..dd373b86b3d2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1175,10 +1175,6 @@ int dev_change_name(struct net_device *dev, const char *newname)
 	 * they are supposed to operate on master interface
 	 * directly.
 	 */
-	if (dev->flags & IFF_UP &&
-	    likely(!(dev->priv_flags & IFF_LIVE_RENAME_OK)))
-		return -EBUSY;
-
 	down_write(&devnet_rename_sem);
 
 	if (strncmp(newname, dev->name, IFNAMSIZ) == 0) {
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

