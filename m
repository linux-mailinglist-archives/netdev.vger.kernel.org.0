Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4259A40A94D
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 10:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhINIfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 04:35:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31566 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230491AbhINIfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 04:35:16 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18E5s4Ax010194;
        Tue, 14 Sep 2021 04:33:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CvstZ3t9F1wGF/yIpbcae1gE3SKAZRh50Ee/QIyb/JA=;
 b=OwU/A1yup4cZ+RBUVI/Rl7OztytDGLg9FbH+9B3r69n6VIbS1xpEGkyZPeRblprefpMB
 jyq60ds29grLU/l2rwcUAVKVP2JInOwLsXhkwmO7C1VTGLSxiDcSxD9WUSWCrNPn5oBN
 dgB16ZUPW32Qaw0VW+539n7gwBcYAGpFmVxqS9RrVOUdGO0GmH273AFziYlPChaA27JH
 lwQSZrt9QO3iq11XaybWjA2GXeT1DVxVdfWIoQjRGD4hDrAp71QQdypITHFUJ3utD1WJ
 B/MBAG8WpvRz/BwV3tZInOMWTpovyDmg/f0W2R9pfrlKuf3Ry27IzKKYUc7KufrmFQrx vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b2mvb4m03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 04:33:56 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18E81rCE012425;
        Tue, 14 Sep 2021 04:33:56 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b2mvb4kye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 04:33:55 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18E8XMAG012258;
        Tue, 14 Sep 2021 08:33:54 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3b0kqjh0fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 08:33:54 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18E8XoRW35586474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 08:33:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F32B4C058;
        Tue, 14 Sep 2021 08:33:50 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D42024C04E;
        Tue, 14 Sep 2021 08:33:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Sep 2021 08:33:49 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH net-next 2/4] s390/lcs: remove incorrect kernel doc indicators
Date:   Tue, 14 Sep 2021 10:33:18 +0200
Message-Id: <20210914083320.508996-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210914083320.508996-1-kgraul@linux.ibm.com>
References: <20210914083320.508996-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: q9xAm3MH-0Bs-G_IhmvCmFHJ2mV4Jg8g
X-Proofpoint-GUID: j9GZZftl0Q5sHk6qqFtTJuaTPCtzF2Yh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109140017
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

Many comments above functions start with a kernel doc indicator, but
the comments are not using kernel doc style. Get rid of the warnings
by simply removing the indicator.

E.g.:

drivers/s390/net/lcs.c:2355: warning:
 This comment starts with '/**', but isn't a kernel-doc comment.

Acked-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 drivers/s390/net/lcs.c | 121 +++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 60 deletions(-)

diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index 440219bcaa2b..c18fd48e02b6 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -40,18 +40,18 @@
 #error Cannot compile lcs.c without some net devices switched on.
 #endif
 
-/**
+/*
  * initialization string for output
  */
 
 static char version[] __initdata = "LCS driver";
 
-/**
+/*
   * the root device for lcs group devices
   */
 static struct device *lcs_root_dev;
 
-/**
+/*
  * Some prototypes.
  */
 static void lcs_tasklet(unsigned long);
@@ -62,14 +62,14 @@ static int lcs_send_delipm(struct lcs_card *, struct lcs_ipm_list *);
 #endif /* CONFIG_IP_MULTICAST */
 static int lcs_recovery(void *ptr);
 
-/**
+/*
  * Debug Facility Stuff
  */
 static char debug_buffer[255];
 static debug_info_t *lcs_dbf_setup;
 static debug_info_t *lcs_dbf_trace;
 
-/**
+/*
  *  LCS Debug Facility functions
  */
 static void
@@ -96,7 +96,7 @@ lcs_register_debug_facility(void)
 	return 0;
 }
 
-/**
+/*
  * Allocate io buffers.
  */
 static int
@@ -123,7 +123,7 @@ lcs_alloc_channel(struct lcs_channel *channel)
 	return 0;
 }
 
-/**
+/*
  * Free io buffers.
  */
 static void
@@ -151,7 +151,7 @@ lcs_cleanup_channel(struct lcs_channel *channel)
 	lcs_free_channel(channel);
 }
 
-/**
+/*
  * LCS free memory for card and channels.
  */
 static void
@@ -162,7 +162,7 @@ lcs_free_card(struct lcs_card *card)
 	kfree(card);
 }
 
-/**
+/*
  * LCS alloc memory for card and channels
  */
 static struct lcs_card *
@@ -402,7 +402,7 @@ lcs_do_start_thread(struct lcs_card *card, unsigned long thread)
         return rc;
 }
 
-/**
+/*
  * Initialize channels,card and state machines.
  */
 static void
@@ -451,7 +451,8 @@ static void lcs_clear_multicast_list(struct lcs_card *card)
 	spin_unlock_irqrestore(&card->ipm_lock, flags);
 #endif
 }
-/**
+
+/*
  * Cleanup channels,card and state machines.
  */
 static void
@@ -468,7 +469,7 @@ lcs_cleanup_card(struct lcs_card *card)
 	lcs_cleanup_channel(&card->read);
 }
 
-/**
+/*
  * Start channel.
  */
 static int
@@ -517,7 +518,7 @@ lcs_clear_channel(struct lcs_channel *channel)
 }
 
 
-/**
+/*
  * Stop channel.
  */
 static int
@@ -545,7 +546,7 @@ lcs_stop_channel(struct lcs_channel *channel)
 	return 0;
 }
 
-/**
+/*
  * start read and write channel
  */
 static int
@@ -565,7 +566,7 @@ lcs_start_channels(struct lcs_card *card)
 	return rc;
 }
 
-/**
+/*
  * stop read and write channel
  */
 static int
@@ -577,7 +578,7 @@ lcs_stop_channels(struct lcs_card *card)
 	return 0;
 }
 
-/**
+/*
  * Get empty buffer.
  */
 static struct lcs_buffer *
@@ -610,7 +611,7 @@ lcs_get_buffer(struct lcs_channel *channel)
 	return buffer;
 }
 
-/**
+/*
  * Resume channel program if the channel is suspended.
  */
 static int
@@ -636,7 +637,7 @@ __lcs_resume_channel(struct lcs_channel *channel)
 
 }
 
-/**
+/*
  * Make a buffer ready for processing.
  */
 static void __lcs_ready_buffer_bits(struct lcs_channel *channel, int index)
@@ -678,7 +679,7 @@ lcs_ready_buffer(struct lcs_channel *channel, struct lcs_buffer *buffer)
 	return rc;
 }
 
-/**
+/*
  * Mark the buffer as processed. Take care of the suspend bit
  * of the previous buffer. This function is called from
  * interrupt context, so the lock must not be taken.
@@ -712,7 +713,7 @@ __lcs_processed_buffer(struct lcs_channel *channel, struct lcs_buffer *buffer)
 	return __lcs_resume_channel(channel);
 }
 
-/**
+/*
  * Put a processed buffer back to state empty.
  */
 static void
@@ -728,7 +729,7 @@ lcs_release_buffer(struct lcs_channel *channel, struct lcs_buffer *buffer)
 	spin_unlock_irqrestore(get_ccwdev_lock(channel->ccwdev), flags);
 }
 
-/**
+/*
  * Get buffer for a lan command.
  */
 static struct lcs_buffer *
@@ -785,7 +786,7 @@ lcs_alloc_reply(struct lcs_cmd *cmd)
 	return reply;
 }
 
-/**
+/*
  * Notifier function for lancmd replies. Called from read irq.
  */
 static void
@@ -813,7 +814,7 @@ lcs_notify_lancmd_waiters(struct lcs_card *card, struct lcs_cmd *cmd)
 	spin_unlock(&card->lock);
 }
 
-/**
+/*
  * Emit buffer of a lan command.
  */
 static void
@@ -877,7 +878,7 @@ lcs_send_lancmd(struct lcs_card *card, struct lcs_buffer *buffer,
 	return rc ? -EIO : 0;
 }
 
-/**
+/*
  * LCS startup command
  */
 static int
@@ -895,7 +896,7 @@ lcs_send_startup(struct lcs_card *card, __u8 initiator)
 	return lcs_send_lancmd(card, buffer, NULL);
 }
 
-/**
+/*
  * LCS shutdown command
  */
 static int
@@ -912,7 +913,7 @@ lcs_send_shutdown(struct lcs_card *card)
 	return lcs_send_lancmd(card, buffer, NULL);
 }
 
-/**
+/*
  * LCS lanstat command
  */
 static void
@@ -939,7 +940,7 @@ lcs_send_lanstat(struct lcs_card *card)
 	return lcs_send_lancmd(card, buffer, __lcs_lanstat_cb);
 }
 
-/**
+/*
  * send stoplan command
  */
 static int
@@ -958,7 +959,7 @@ lcs_send_stoplan(struct lcs_card *card, __u8 initiator)
 	return lcs_send_lancmd(card, buffer, NULL);
 }
 
-/**
+/*
  * send startlan command
  */
 static void
@@ -986,7 +987,7 @@ lcs_send_startlan(struct lcs_card *card, __u8 initiator)
 }
 
 #ifdef CONFIG_IP_MULTICAST
-/**
+/*
  * send setipm command (Multicast)
  */
 static int
@@ -1010,7 +1011,7 @@ lcs_send_setipm(struct lcs_card *card,struct lcs_ipm_list *ipm_list)
 	return lcs_send_lancmd(card, buffer, NULL);
 }
 
-/**
+/*
  * send delipm command (Multicast)
  */
 static int
@@ -1034,7 +1035,7 @@ lcs_send_delipm(struct lcs_card *card,struct lcs_ipm_list *ipm_list)
 	return lcs_send_lancmd(card, buffer, NULL);
 }
 
-/**
+/*
  * check if multicast is supported by LCS
  */
 static void
@@ -1074,7 +1075,7 @@ lcs_check_multicast_support(struct lcs_card *card)
 	return -EOPNOTSUPP;
 }
 
-/**
+/*
  * set or del multicast address on LCS card
  */
 static void
@@ -1129,7 +1130,7 @@ lcs_fix_multicast_list(struct lcs_card *card)
 	spin_unlock_irqrestore(&card->ipm_lock, flags);
 }
 
-/**
+/*
  * get mac address for the relevant Multicast address
  */
 static void
@@ -1139,7 +1140,7 @@ lcs_get_mac_for_ipm(__be32 ipm, char *mac, struct net_device *dev)
 	ip_eth_mc_map(ipm, mac);
 }
 
-/**
+/*
  * function called by net device to handle multicast address relevant things
  */
 static void lcs_remove_mc_addresses(struct lcs_card *card,
@@ -1260,7 +1261,7 @@ lcs_register_mc_addresses(void *data)
 }
 #endif /* CONFIG_IP_MULTICAST */
 
-/**
+/*
  * function called by net device to
  * handle multicast address relevant things
  */
@@ -1355,7 +1356,7 @@ lcs_schedule_recovery(struct lcs_card *card)
 		schedule_work(&card->kernel_thread_starter);
 }
 
-/**
+/*
  * IRQ Handler for LCS channels
  */
 static void
@@ -1439,7 +1440,7 @@ lcs_irq(struct ccw_device *cdev, unsigned long intparm, struct irb *irb)
 	tasklet_schedule(&channel->irq_tasklet);
 }
 
-/**
+/*
  * Tasklet for IRQ handler
  */
 static void
@@ -1476,7 +1477,7 @@ lcs_tasklet(unsigned long data)
 	wake_up(&channel->wait_q);
 }
 
-/**
+/*
  * Finish current tx buffer and make it ready for transmit.
  */
 static void
@@ -1490,7 +1491,7 @@ __lcs_emit_txbuffer(struct lcs_card *card)
 	card->tx_emitted++;
 }
 
-/**
+/*
  * Callback for finished tx buffers.
  */
 static void
@@ -1515,7 +1516,7 @@ lcs_txbuffer_cb(struct lcs_channel *channel, struct lcs_buffer *buffer)
 	spin_unlock(&card->lock);
 }
 
-/**
+/*
  * Packet transmit function called by network stack
  */
 static int
@@ -1593,7 +1594,7 @@ lcs_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return rc;
 }
 
-/**
+/*
  * send startlan and lanstat command to make LCS device ready
  */
 static int
@@ -1648,7 +1649,7 @@ lcs_startlan(struct lcs_card *card)
 	return rc;
 }
 
-/**
+/*
  * LCS detect function
  * setup channels and make them I/O ready
  */
@@ -1680,7 +1681,7 @@ lcs_detect(struct lcs_card *card)
 	return rc;
 }
 
-/**
+/*
  * LCS Stop card
  */
 static int
@@ -1705,7 +1706,7 @@ lcs_stopcard(struct lcs_card *card)
 	return rc;
 }
 
-/**
+/*
  * Kernel Thread helper functions for LGW initiated commands
  */
 static void
@@ -1721,7 +1722,7 @@ lcs_start_kernel_thread(struct work_struct *work)
 #endif
 }
 
-/**
+/*
  * Process control frames.
  */
 static void
@@ -1748,7 +1749,7 @@ lcs_get_control(struct lcs_card *card, struct lcs_cmd *cmd)
 		lcs_notify_lancmd_waiters(card, cmd);
 }
 
-/**
+/*
  * Unpack network packet.
  */
 static void
@@ -1779,7 +1780,7 @@ lcs_get_skb(struct lcs_card *card, char *skb_data, unsigned int skb_len)
 	netif_rx(skb);
 }
 
-/**
+/*
  * LCS main routine to get packets and lancmd replies from the buffers
  */
 static void
@@ -1829,7 +1830,7 @@ lcs_get_frames_cb(struct lcs_channel *channel, struct lcs_buffer *buffer)
 	lcs_ready_buffer(&card->read, buffer);
 }
 
-/**
+/*
  * get network statistics for ifconfig and other user programs
  */
 static struct net_device_stats *
@@ -1842,7 +1843,7 @@ lcs_getstats(struct net_device *dev)
 	return &card->stats;
 }
 
-/**
+/*
  * stop lcs device
  * This function will be called by user doing ifconfig xxx down
  */
@@ -1866,7 +1867,7 @@ lcs_stop_device(struct net_device *dev)
 	return rc;
 }
 
-/**
+/*
  * start lcs device and make it runnable
  * This function will be called by user doing ifconfig xxx up
  */
@@ -1892,7 +1893,7 @@ lcs_open_device(struct net_device *dev)
 	return rc;
 }
 
-/**
+/*
  * show function for portno called by cat or similar things
  */
 static ssize_t
@@ -1908,7 +1909,7 @@ lcs_portno_show (struct device *dev, struct device_attribute *attr, char *buf)
         return sprintf(buf, "%d\n", card->portno);
 }
 
-/**
+/*
  * store the value which is piped to file portno
  */
 static ssize_t
@@ -2033,7 +2034,7 @@ static const struct device_type lcs_devtype = {
 	.groups = lcs_attr_groups,
 };
 
-/**
+/*
  * lcs_probe_device is called on establishing a new ccwgroup_device.
  */
 static int
@@ -2077,7 +2078,7 @@ lcs_register_netdev(struct ccwgroup_device *ccwgdev)
 	return register_netdev(card->dev);
 }
 
-/**
+/*
  * lcs_new_device will be called by setting the group device online.
  */
 static const struct net_device_ops lcs_netdev_ops = {
@@ -2199,7 +2200,7 @@ lcs_new_device(struct ccwgroup_device *ccwgdev)
 	return -ENODEV;
 }
 
-/**
+/*
  * lcs_shutdown_device, called when setting the group device offline.
  */
 static int
@@ -2240,7 +2241,7 @@ lcs_shutdown_device(struct ccwgroup_device *ccwgdev)
 	return __lcs_shutdown_device(ccwgdev, 0);
 }
 
-/**
+/*
  * drive lcs recovery after startup and startlan initiated by Lan Gateway
  */
 static int
@@ -2271,7 +2272,7 @@ lcs_recovery(void *ptr)
 	return 0;
 }
 
-/**
+/*
  * lcs_remove_device, free buffers and card
  */
 static void
@@ -2315,7 +2316,7 @@ static struct ccw_driver lcs_ccw_driver = {
 	.int_class = IRQIO_LCS,
 };
 
-/**
+/*
  * LCS ccwgroup driver registration
  */
 static struct ccwgroup_driver lcs_group_driver = {
@@ -2351,7 +2352,7 @@ static const struct attribute_group *lcs_drv_attr_groups[] = {
 	NULL,
 };
 
-/**
+/*
  *  LCS Module/Kernel initialization function
  */
 static int
@@ -2389,7 +2390,7 @@ __init lcs_init_module(void)
 }
 
 
-/**
+/*
  *  LCS module cleanup function
  */
 static void
-- 
2.25.1

