Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86975615682
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 01:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiKBAZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 20:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiKBAZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 20:25:36 -0400
Received: from mx0a-003ede02.pphosted.com (mx0a-003ede02.pphosted.com [205.220.169.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144F960FB
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 17:25:34 -0700 (PDT)
Received: from pps.filterd (m0286615.ppops.net [127.0.0.1])
        by mx0b-003ede02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A20PYtj017734
        for <netdev@vger.kernel.org>; Tue, 1 Nov 2022 17:25:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=getcruise.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=ppemail; bh=HNeH6fQKWa/SXTqsQ3ku21U4ths4w0Cni02GfQkvwJU=;
 b=FE8RKg2bNnCCSEFEk3OlkHJjN1j1IGYZSGSzi2TfDF5gM2yBTz/QzMWGS4fzGqW4dhW8
 36S26gPwrUw/VYuLaPIUP+sOQjQwAggWQgIU7Z7WTaSyepHZzajyBljVo1RSAQtLYx7j
 EL2ruIwpE/uWh5EXtaJOTjaYdMqb6/vaBfPffzfu3Tn6vA9tsJhthLE3S7If2tE7Dkwm
 dshOPa47bnTTtAPR93JeIPkNtWm/ItGd5pgE25u0fcqTXWIbEcQsT6krI9KPQ7XOWdzF
 e0nJYJ1gxecsi07PTBByHvaeZhxkdgWzg3vWv5D2a6+DSsvzLqcC2p0BL1Em7d1xfo7E Yw== 
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
        by mx0b-003ede02.pphosted.com (PPS) with ESMTPS id 3kh0ckrwu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 17:25:34 -0700
Received: by mail-pg1-f199.google.com with SMTP id 186-20020a6301c3000000b0046fa202f720so4827004pgb.20
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 17:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=getcruise.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HNeH6fQKWa/SXTqsQ3ku21U4ths4w0Cni02GfQkvwJU=;
        b=gZMI7qdmcGdQieYwM6F86KvCUS5dNynbkKH1Hqmbl0z5g0i8Yv83PyUoGB+4LIPIkc
         lPIg3ew2iLvBySJ7Jlt1XSpu4FNrd5qwG57XDkz3EOLkesy55IP5Qb+0VpO3tslKEZXU
         RUjxe7FFjE+OjZp8OWFVkKSLqeWsEX6lrmExhM5KRTIPDPbe4pg7OAt3OAhlWsqNGhRk
         9hZt7wportbubjzEbSUoVqTJAIVNA2dzX5EhKJQgv9hQMSfYb3m+j1ekt7I2vmGcX09a
         19L/3Wg5UPLqkpeuGJplhecfnNdnpItPBq51BdDpRc/WhV3ETUBfS7L3B9TFNwSNBBJ0
         PB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HNeH6fQKWa/SXTqsQ3ku21U4ths4w0Cni02GfQkvwJU=;
        b=f/WnD+eJk7AAChY0MfHnFQi91N5QjGnYcbbKsUQ1jgzCJUV1aQQ8bH/dKKmr3JDcrO
         NIrQVTAM0Y363lsnDRNfO7J55RotO5Rpyxxz2kzJ77erRmSIZlYJPJadN/Qa/m5QJsgM
         dMNcnBMULoHLKCp85CbJkFKJvizThwSKXVx3p3o9FcZONIRYsN105Id68r569FceeNLe
         yRQq4RFN/u2RcBFCkEZ5lsLSGL40djSPtkNepDi93ACioUFFCZqraqftgZuzHqMiTQRu
         AltKMxE69icMDjbuCoxu8dOU9U5NjfsxeftA90b787w00D7VawzhFqwFqJd4XfTdeaeP
         S90A==
X-Gm-Message-State: ACrzQf25WvuQEvuouOC9kI0Kj0db0gu1xYLqkcBiba2di7CBtOBPF824
        kvJVzfC2kNCs9VMsWZ0PrUytrghx2sbUeTb47+f3ohO6XbZqBkCkNtYle4N3UHDBSXcTg/MJ9vM
        VhHp1/y3TiaRov7c=
X-Received: by 2002:a17:902:6bc5:b0:183:4bef:1b20 with SMTP id m5-20020a1709026bc500b001834bef1b20mr21661899plt.158.1667348733576;
        Tue, 01 Nov 2022 17:25:33 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7/YWdmRuUsmso5eR0Fo7r6dQnDUFcvn5En4f2d0BIxI8IYV1nnrOD0fnF5ySDdIKGo+FLgDg==
X-Received: by 2002:a17:902:6bc5:b0:183:4bef:1b20 with SMTP id m5-20020a1709026bc500b001834bef1b20mr21661869plt.158.1667348733233;
        Tue, 01 Nov 2022 17:25:33 -0700 (PDT)
Received: from 4VPLMR2-DT.corp.robot.car ([199.73.125.241])
        by smtp.gmail.com with ESMTPSA id x20-20020a17090a531400b001fe39bda429sm98272pjh.38.2022.11.01.17.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 17:25:32 -0700 (PDT)
From:   Andy Ren <andy.ren@getcruise.com>
To:     netdev@vger.kernel.org
Cc:     richardbgobert@gmail.com, davem@davemloft.net,
        wsa+renesas@sang-engineering.com, edumazet@google.com,
        petrm@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, roman.gushchin@linux.dev,
        Andy Ren <andy.ren@getcruise.com>
Subject: [PATCH net-next v2] netconsole: Enable live renaming for network interfaces used by netconsole
Date:   Tue,  1 Nov 2022 17:24:20 -0700
Message-Id: <20221102002420.2613004-1-andy.ren@getcruise.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Kf5tJ6lPMFYhqi22mVKVJ4USYgaZGLn7
X-Proofpoint-ORIG-GUID: Kf5tJ6lPMFYhqi22mVKVJ4USYgaZGLn7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-01_11,2022-11-01_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 clxscore=1015 mlxlogscore=999 phishscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211010163
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables support for live renaming of network interfaces
initialized by netconsole.

This resolves an issue seen when netconsole is configured to boot as a
built-in kernel module with a kernel boot argument. As stated in the
kernel man page - As a built-in, netconsole initializes immediately
after NIC cards and will bring up the specified interface as soon as
possible. Consequently, the renaming of specified interfaces will fail
and return EBUSY. This is because by default, the kernel disallows live
renaming unless the device explicitly sets a priv_flags bit
(e.g: IFF_LIVE_RENAME_OK or IFF_LIVE_ADDR_CHANGE), and so renaming after
a network interface is up returns EBUSY.

The changes to the kernel are as of following:

- Addition of a iface_live_renaming boolean flag to the netpoll struct,
used to enable/disable interface live renaming. False by default
- Changes to check for the aforementioned flag in network and ethernet
driver interface renaming code
- Adds a new optional "*" parameter to the netconsole configuration
string that enables interface live renaming when included
(e.g. netconsole=+*....). When this optional parameter is included,
"iface_live_renaming" is set to true

Signed-off-by: Andy Ren <andy.ren@getcruise.com>
---
 Documentation/networking/netconsole.rst |  7 ++++---
 drivers/net/netconsole.c                |  5 +++++
 include/linux/netpoll.h                 |  3 +++
 net/core/dev.c                          |  3 ++-
 net/core/netpoll.c                      | 15 +++++++++++++++
 net/ethernet/eth.c                      |  5 ++++-
 6 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/netconsole.rst b/Documentation/networking/netconsole.rst
index 1f5c4a04027c..01a45f38ce3f 100644
--- a/Documentation/networking/netconsole.rst
+++ b/Documentation/networking/netconsole.rst
@@ -34,10 +34,11 @@ Sender and receiver configuration:
 It takes a string configuration parameter "netconsole" in the
 following format::
 
- netconsole=[+][src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr]
+ netconsole=[+][*][src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr]
 
    where
 	+             if present, enable extended console support
+	*             if present, allow runtime network interface renaming
 	src-port      source for UDP packets (defaults to 6665)
 	src-ip        source IP to use (interface address)
 	dev           network interface (eth0)
@@ -47,7 +48,7 @@ following format::
 
 Examples::
 
- linux netconsole=4444@10.0.0.1/eth1,9353@10.0.0.2/12:34:56:78:9a:bc
+ linux netconsole=*4444@10.0.0.1/eth1,9353@10.0.0.2/12:34:56:78:9a:bc
 
 or::
 
@@ -158,7 +159,7 @@ If '+' is prefixed to the configuration line or "extended" config file
 is set to 1, extended console support is enabled. An example boot
 param follows::
 
- linux netconsole=+4444@10.0.0.1/eth1,9353@10.0.0.2/12:34:56:78:9a:bc
+ linux netconsole=+*4444@10.0.0.1/eth1,9353@10.0.0.2/12:34:56:78:9a:bc
 
 Log messages are transmitted with extended metadata header in the
 following format which is the same as /dev/kmsg::
diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index bdff9ac5056d..dea5b783744f 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -188,6 +188,11 @@ static struct netconsole_target *alloc_param_target(char *target_config)
 		target_config++;
 	}
 
+	if (*target_config == '*') {
+		nt->np.iface_live_renaming = true;
+		target_config++;
+	}
+
 	/* Parse parameters and setup netpoll */
 	err = netpoll_parse_options(&nt->np, target_config);
 	if (err)
diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
index bd19c4b91e31..f2ebdabf0959 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -32,6 +32,7 @@ struct netpoll {
 	bool ipv6;
 	u16 local_port, remote_port;
 	u8 remote_mac[ETH_ALEN];
+	bool iface_live_renaming;
 };
 
 struct netpoll_info {
@@ -51,9 +52,11 @@ struct netpoll_info {
 void netpoll_poll_dev(struct net_device *dev);
 void netpoll_poll_disable(struct net_device *dev);
 void netpoll_poll_enable(struct net_device *dev);
+bool netpoll_live_renaming_enabled(struct net_device *dev);
 #else
 static inline void netpoll_poll_disable(struct net_device *dev) { return; }
 static inline void netpoll_poll_enable(struct net_device *dev) { return; }
+static inline bool netpoll_live_renaming_enabled(struct net_device *dev) { return false; }
 #endif
 
 void netpoll_send_udp(struct netpoll *np, const char *msg, int len);
diff --git a/net/core/dev.c b/net/core/dev.c
index 2e4f1c97b59e..90e6870d38d0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1176,7 +1176,8 @@ int dev_change_name(struct net_device *dev, const char *newname)
 	 * directly.
 	 */
 	if (dev->flags & IFF_UP &&
-	    likely(!(dev->priv_flags & IFF_LIVE_RENAME_OK)))
+	    likely(!(dev->priv_flags & IFF_LIVE_RENAME_OK) &&
+		   !netpoll_live_renaming_enabled(dev)))
 		return -EBUSY;
 
 	down_write(&devnet_rename_sem);
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 9be762e1d042..a22319676667 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -224,6 +224,21 @@ void netpoll_poll_enable(struct net_device *dev)
 }
 EXPORT_SYMBOL(netpoll_poll_enable);
 
+bool netpoll_live_renaming_enabled(struct net_device *dev)
+{
+	struct netpoll_info *ni;
+	bool live_renaming_enabled = false;
+
+	rcu_read_lock();
+	ni = rcu_dereference(dev->npinfo);
+	if (ni && ni->netpoll->iface_live_renaming)
+		live_renaming_enabled = true;
+	rcu_read_unlock();
+
+	return live_renaming_enabled;
+}
+EXPORT_SYMBOL(netpoll_live_renaming_enabled);
+
 static void refill_skbs(void)
 {
 	struct sk_buff *skb;
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index e02daa74e833..bb341acfcf05 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -62,6 +62,7 @@
 #include <net/gro.h>
 #include <linux/uaccess.h>
 #include <net/pkt_sched.h>
+#include <linux/netpoll.h>
 
 /**
  * eth_header - create the Ethernet header
@@ -288,8 +289,10 @@ int eth_prepare_mac_addr_change(struct net_device *dev, void *p)
 {
 	struct sockaddr *addr = p;
 
-	if (!(dev->priv_flags & IFF_LIVE_ADDR_CHANGE) && netif_running(dev))
+	if (!(dev->priv_flags & IFF_LIVE_ADDR_CHANGE) && netif_running(dev) &&
+	    !netpoll_live_renaming_enabled(dev))
 		return -EBUSY;
+
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 	return 0;
-- 
2.38.1

