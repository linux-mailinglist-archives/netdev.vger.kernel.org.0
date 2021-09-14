Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6175A40A94F
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 10:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhINIfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 04:35:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12702 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhINIfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 04:35:16 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18E8A2rS003272;
        Tue, 14 Sep 2021 04:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=a2LqfpH+xxzpouUPyT0W26xNBOqlYnM8ffBvr69OmOY=;
 b=qe4VPgmxMB4xvHabw7/ePE2sEdl+iPptmO1pKRUaPlByoEkFxEDrHDSirRZJAKpw8xkM
 Yd2uUcbO8dHMsEypEqxGjmPjPRiT36gAKcTFhDa7N0ugEs2So2itFpn8HybHU71YtICn
 poaHIFp2fj3Z6Y0ZVXgux9CK8UDWI86iQpqEOIR714n03dLdDq15mq+XgTh13ctG+mbX
 mJJu4VYlzUcgAilS6ELbGsahQe9qU4geGgV+ConQ8PxKagT1apsVrmJU/JjhROF2T2Hc
 Ta/H5nfYQatTYBJsg7TnGwCurFbmI9UAGOn5VhE2eQu/UCq4fZ4A0PolnsgEyYui7cEI 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2n91v90x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 04:33:58 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18E7d8rl004568;
        Tue, 14 Sep 2021 04:33:58 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2n91v90a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 04:33:57 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18E8XVnd003349;
        Tue, 14 Sep 2021 08:33:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3b0m39qysk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 08:33:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18E8XosF43188714
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 08:33:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA1C14C050;
        Tue, 14 Sep 2021 08:33:50 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CDED4C05C;
        Tue, 14 Sep 2021 08:33:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Sep 2021 08:33:50 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH net-next 3/4] s390/netiucv: remove incorrect kernel doc indicators
Date:   Tue, 14 Sep 2021 10:33:19 +0200
Message-Id: <20210914083320.508996-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210914083320.508996-1-kgraul@linux.ibm.com>
References: <20210914083320.508996-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jQBhUyHMU3KW5Vovg9YN0MVyASal9aAh
X-Proofpoint-GUID: KI0MxkxdfV-hid1u4XOED6BbGlb0YhsF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 adultscore=0 mlxscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

Many comments above functions start with a kernel doc indicator, but
the comments are not using kernel doc style. Get rid of the warnings
by simply removing the indicator.

E.g.:

drivers/s390/net/netiucv.c:1852: warning:
 This comment starts with '/**', but isn't a kernel-doc comment.

Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 drivers/s390/net/fsm.c     |   2 +-
 drivers/s390/net/netiucv.c | 104 ++++++++++++++++++-------------------
 2 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/s390/net/fsm.c b/drivers/s390/net/fsm.c
index eb07862bd36a..98c4864932d2 100644
--- a/drivers/s390/net/fsm.c
+++ b/drivers/s390/net/fsm.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/**
+/*
  * A generic FSM based on fsm used in isdn4linux
  *
  */
diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 5a0c2f07a3a2..981e7b1c6b96 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -58,7 +58,7 @@ MODULE_AUTHOR
     ("(C) 2001 IBM Corporation by Fritz Elfert (felfert@millenux.com)");
 MODULE_DESCRIPTION ("Linux for S/390 IUCV network driver");
 
-/**
+/*
  * Debug Facility stuff
  */
 #define IUCV_DBF_SETUP_NAME "iucv_setup"
@@ -107,7 +107,7 @@ DECLARE_PER_CPU(char[256], iucv_dbf_txt_buf);
 		debug_sprintf_event(iucv_dbf_trace, level, text ); \
 	} while (0)
 
-/**
+/*
  * some more debug stuff
  */
 #define PRINTK_HEADER " iucv: "       /* for debugging */
@@ -118,7 +118,7 @@ static struct device_driver netiucv_driver = {
 	.bus  = &iucv_bus,
 };
 
-/**
+/*
  * Per connection profiling data
  */
 struct connection_profile {
@@ -133,7 +133,7 @@ struct connection_profile {
 	unsigned long tx_max_pending;
 };
 
-/**
+/*
  * Representation of one iucv connection
  */
 struct iucv_connection {
@@ -154,13 +154,13 @@ struct iucv_connection {
 	char			  userdata[17];
 };
 
-/**
+/*
  * Linked list of all connection structs.
  */
 static LIST_HEAD(iucv_connection_list);
 static DEFINE_RWLOCK(iucv_connection_rwlock);
 
-/**
+/*
  * Representation of event-data for the
  * connection state machine.
  */
@@ -169,7 +169,7 @@ struct iucv_event {
 	void                   *data;
 };
 
-/**
+/*
  * Private part of the network device structure
  */
 struct netiucv_priv {
@@ -180,7 +180,7 @@ struct netiucv_priv {
 	struct device           *dev;
 };
 
-/**
+/*
  * Link level header for a packet.
  */
 struct ll_header {
@@ -195,7 +195,7 @@ struct ll_header {
 #define NETIUCV_QUEUELEN_DEFAULT 50
 #define NETIUCV_TIMEOUT_5SEC     5000
 
-/**
+/*
  * Compatibility macros for busy handling
  * of network devices.
  */
@@ -223,7 +223,7 @@ static u8 iucvMagic_ebcdic[16] = {
 	0xF0, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
 };
 
-/**
+/*
  * Convert an iucv userId to its printable
  * form (strip whitespace at end).
  *
@@ -262,7 +262,7 @@ static char *netiucv_printuser(struct iucv_connection *conn)
 		return netiucv_printname(conn->userid, 8);
 }
 
-/**
+/*
  * States of the interface statemachine.
  */
 enum dev_states {
@@ -270,7 +270,7 @@ enum dev_states {
 	DEV_STATE_STARTWAIT,
 	DEV_STATE_STOPWAIT,
 	DEV_STATE_RUNNING,
-	/**
+	/*
 	 * MUST be always the last element!!
 	 */
 	NR_DEV_STATES
@@ -283,7 +283,7 @@ static const char *dev_state_names[] = {
 	"Running",
 };
 
-/**
+/*
  * Events of the interface statemachine.
  */
 enum dev_events {
@@ -291,7 +291,7 @@ enum dev_events {
 	DEV_EVENT_STOP,
 	DEV_EVENT_CONUP,
 	DEV_EVENT_CONDOWN,
-	/**
+	/*
 	 * MUST be always the last element!!
 	 */
 	NR_DEV_EVENTS
@@ -304,11 +304,11 @@ static const char *dev_event_names[] = {
 	"Connection down",
 };
 
-/**
+/*
  * Events of the connection statemachine
  */
 enum conn_events {
-	/**
+	/*
 	 * Events, representing callbacks from
 	 * lowlevel iucv layer)
 	 */
@@ -320,23 +320,23 @@ enum conn_events {
 	CONN_EVENT_RX,
 	CONN_EVENT_TXDONE,
 
-	/**
+	/*
 	 * Events, representing errors return codes from
 	 * calls to lowlevel iucv layer
 	 */
 
-	/**
+	/*
 	 * Event, representing timer expiry.
 	 */
 	CONN_EVENT_TIMER,
 
-	/**
+	/*
 	 * Events, representing commands from upper levels.
 	 */
 	CONN_EVENT_START,
 	CONN_EVENT_STOP,
 
-	/**
+	/*
 	 * MUST be always the last element!!
 	 */
 	NR_CONN_EVENTS,
@@ -357,55 +357,55 @@ static const char *conn_event_names[] = {
 	"Stop",
 };
 
-/**
+/*
  * States of the connection statemachine.
  */
 enum conn_states {
-	/**
+	/*
 	 * Connection not assigned to any device,
 	 * initial state, invalid
 	 */
 	CONN_STATE_INVALID,
 
-	/**
+	/*
 	 * Userid assigned but not operating
 	 */
 	CONN_STATE_STOPPED,
 
-	/**
+	/*
 	 * Connection registered,
 	 * no connection request sent yet,
 	 * no connection request received
 	 */
 	CONN_STATE_STARTWAIT,
 
-	/**
+	/*
 	 * Connection registered and connection request sent,
 	 * no acknowledge and no connection request received yet.
 	 */
 	CONN_STATE_SETUPWAIT,
 
-	/**
+	/*
 	 * Connection up and running idle
 	 */
 	CONN_STATE_IDLE,
 
-	/**
+	/*
 	 * Data sent, awaiting CONN_EVENT_TXDONE
 	 */
 	CONN_STATE_TX,
 
-	/**
+	/*
 	 * Error during registration.
 	 */
 	CONN_STATE_REGERR,
 
-	/**
+	/*
 	 * Error during registration.
 	 */
 	CONN_STATE_CONNERR,
 
-	/**
+	/*
 	 * MUST be always the last element!!
 	 */
 	NR_CONN_STATES,
@@ -424,7 +424,7 @@ static const char *conn_state_names[] = {
 };
 
 
-/**
+/*
  * Debug Facility Stuff
  */
 static debug_info_t *iucv_dbf_setup = NULL;
@@ -556,7 +556,7 @@ static void netiucv_callback_connres(struct iucv_path *path, u8 *ipuser)
 	fsm_event(conn->fsm, CONN_EVENT_CONN_RES, conn);
 }
 
-/**
+/*
  * NOP action for statemachines
  */
 static void netiucv_action_nop(fsm_instance *fi, int event, void *arg)
@@ -567,7 +567,7 @@ static void netiucv_action_nop(fsm_instance *fi, int event, void *arg)
  * Actions of the connection statemachine
  */
 
-/**
+/*
  * netiucv_unpack_skb
  * @conn: The connection where this skb has been received.
  * @pskb: The received skb.
@@ -993,7 +993,7 @@ static const int CONN_FSM_LEN = sizeof(conn_fsm) / sizeof(fsm_node);
  * Actions for interface - statemachine.
  */
 
-/**
+/*
  * dev_action_start
  * @fi: An instance of an interface statemachine.
  * @event: The event, just happened.
@@ -1012,7 +1012,7 @@ static void dev_action_start(fsm_instance *fi, int event, void *arg)
 	fsm_event(privptr->conn->fsm, CONN_EVENT_START, privptr->conn);
 }
 
-/**
+/*
  * Shutdown connection by sending CONN_EVENT_STOP to it.
  *
  * @param fi    An instance of an interface statemachine.
@@ -1034,7 +1034,7 @@ dev_action_stop(fsm_instance *fi, int event, void *arg)
 	fsm_event(privptr->conn->fsm, CONN_EVENT_STOP, &ev);
 }
 
-/**
+/*
  * Called from connection statemachine
  * when a connection is up and running.
  *
@@ -1067,7 +1067,7 @@ dev_action_connup(fsm_instance *fi, int event, void *arg)
 	}
 }
 
-/**
+/*
  * Called from connection statemachine
  * when a connection has been shutdown.
  *
@@ -1107,7 +1107,7 @@ static const fsm_node dev_fsm[] = {
 
 static const int DEV_FSM_LEN = sizeof(dev_fsm) / sizeof(fsm_node);
 
-/**
+/*
  * Transmit a packet.
  * This is a helper function for netiucv_tx().
  *
@@ -1144,7 +1144,7 @@ static int netiucv_transmit_skb(struct iucv_connection *conn,
 		spin_unlock_irqrestore(&conn->collect_lock, saveflags);
 	} else {
 		struct sk_buff *nskb = skb;
-		/**
+		/*
 		 * Copy the skb to a new allocated skb in lowmem only if the
 		 * data is located above 2G in memory or tailroom is < 2.
 		 */
@@ -1164,7 +1164,7 @@ static int netiucv_transmit_skb(struct iucv_connection *conn,
 			}
 			copied = 1;
 		}
-		/**
+		/*
 		 * skb now is below 2G and has enough room. Add headers.
 		 */
 		header.next = nskb->len + NETIUCV_HDRLEN;
@@ -1194,7 +1194,7 @@ static int netiucv_transmit_skb(struct iucv_connection *conn,
 			if (copied)
 				dev_kfree_skb(nskb);
 			else {
-				/**
+				/*
 				 * Remove our headers. They get added
 				 * again on retransmit.
 				 */
@@ -1217,7 +1217,7 @@ static int netiucv_transmit_skb(struct iucv_connection *conn,
  * Interface API for upper network layers
  */
 
-/**
+/*
  * Open an interface.
  * Called from generic network layer when ifconfig up is run.
  *
@@ -1233,7 +1233,7 @@ static int netiucv_open(struct net_device *dev)
 	return 0;
 }
 
-/**
+/*
  * Close an interface.
  * Called from generic network layer when ifconfig down is run.
  *
@@ -1249,7 +1249,7 @@ static int netiucv_close(struct net_device *dev)
 	return 0;
 }
 
-/**
+/*
  * Start transmission of a packet.
  * Called from generic network device layer.
  *
@@ -1266,7 +1266,7 @@ static int netiucv_tx(struct sk_buff *skb, struct net_device *dev)
 	int rc;
 
 	IUCV_DBF_TEXT(trace, 4, __func__);
-	/**
+	/*
 	 * Some sanity checks ...
 	 */
 	if (skb == NULL) {
@@ -1282,7 +1282,7 @@ static int netiucv_tx(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_OK;
 	}
 
-	/**
+	/*
 	 * If connection is not running, try to restart it
 	 * and throw away packet.
 	 */
@@ -1304,7 +1304,7 @@ static int netiucv_tx(struct sk_buff *skb, struct net_device *dev)
 	return rc ? NETDEV_TX_BUSY : NETDEV_TX_OK;
 }
 
-/**
+/*
  * netiucv_stats
  * @dev: Pointer to interface struct.
  *
@@ -1745,7 +1745,7 @@ static void netiucv_unregister_device(struct device *dev)
 	device_unregister(dev);
 }
 
-/**
+/*
  * Allocate and initialize a new connection structure.
  * Add it to the list of netiucv connections;
  */
@@ -1802,7 +1802,7 @@ static struct iucv_connection *netiucv_new_connection(struct net_device *dev,
 	return NULL;
 }
 
-/**
+/*
  * Release a connection structure and remove it from the
  * list of netiucv connections.
  */
@@ -1826,7 +1826,7 @@ static void netiucv_remove_connection(struct iucv_connection *conn)
 	kfree_skb(conn->tx_buff);
 }
 
-/**
+/*
  * Release everything of a net device.
  */
 static void netiucv_free_netdevice(struct net_device *dev)
@@ -1848,7 +1848,7 @@ static void netiucv_free_netdevice(struct net_device *dev)
 	}
 }
 
-/**
+/*
  * Initialize a net device. (Called from kernel in alloc_netdev())
  */
 static const struct net_device_ops netiucv_netdev_ops = {
@@ -1873,7 +1873,7 @@ static void netiucv_setup_netdevice(struct net_device *dev)
 	dev->netdev_ops		 = &netiucv_netdev_ops;
 }
 
-/**
+/*
  * Allocate and initialize everything of a net device.
  */
 static struct net_device *netiucv_init_netdevice(char *username, char *userdata)
-- 
2.25.1

