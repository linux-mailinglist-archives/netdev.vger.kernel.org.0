Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79E740A94E
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 10:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhINIfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 04:35:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31558 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230498AbhINIfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 04:35:16 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18E7iUxV022347;
        Tue, 14 Sep 2021 04:33:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DdUJcH2C2xF3PTRRuxu3q8vOmBfCInoXBRtZpTLAY0k=;
 b=GkxHLYiIdJ5IzRCYhYr3faOK9qHT2Rj/0uJpkPOEj8vDm1Qee/qYO8xs+ML1ool676/P
 CV+//wSHAxLe/f/T6lqkJDrCQyaCCOQUpFP066RaNWC7Y+3ACueniGa/F6Xs+GIZKGAU
 pcVZ1GHRrpFEVixY/56vH88U8B9WYKyR1Dmpmu6lQr3fQqBYLWolxSEhJ0BIa9y4Ygoa
 FLKx3rvp02in+dj44ybYQB28RDe0yB4JBekfdbOcX8zPcZH4Txlg0kMTsF06rCZ1Ie0k
 H9DbBsiszs0GtSgHwWAZhGvYk1O9teObUBFEmLms8jIFY/ANXlGwwX5qi6h+SIy7Pefq vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b2mubchrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 04:33:56 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18E6LCQv015426;
        Tue, 14 Sep 2021 04:33:55 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b2mubchqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 04:33:55 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18E8XOdZ005456;
        Tue, 14 Sep 2021 08:33:53 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3b0m39rw5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 08:33:53 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18E8XnwX37945732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 08:33:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA4674C040;
        Tue, 14 Sep 2021 08:33:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69E3D4C046;
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
Subject: [PATCH net-next 1/4] s390/ctcm: remove incorrect kernel doc indicators
Date:   Tue, 14 Sep 2021 10:33:17 +0200
Message-Id: <20210914083320.508996-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210914083320.508996-1-kgraul@linux.ibm.com>
References: <20210914083320.508996-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UDHV9CG_aGmwf7yloj39x8VpCqdyyWXS
X-Proofpoint-GUID: 0aptv5oGLQUqoyVNEDtPv4MTh1_gt-KH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140018
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

Many comments above functions start with a kernel doc indicator, but
the comments are not using kernel doc style. Get rid of the warnings
by simply removing the indicator.

E.g.:

drivers/s390/net/ctcm_main.c:979: warning:
 This comment starts with '/**', but isn't a kernel-doc comment.

Acked-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 drivers/s390/net/ctcm_fsms.c | 60 ++++++++++++++++++------------------
 drivers/s390/net/ctcm_main.c | 38 +++++++++++------------
 drivers/s390/net/ctcm_mpc.c  |  8 ++---
 3 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/s390/net/ctcm_fsms.c b/drivers/s390/net/ctcm_fsms.c
index 06281a0a0552..de2423c72b02 100644
--- a/drivers/s390/net/ctcm_fsms.c
+++ b/drivers/s390/net/ctcm_fsms.c
@@ -182,7 +182,7 @@ static void ctcmpc_chx_attnbusy(fsm_instance *, int, void *);
 static void ctcmpc_chx_resend(fsm_instance *, int, void *);
 static void ctcmpc_chx_send_sweep(fsm_instance *fsm, int event, void *arg);
 
-/**
+/*
  * Check return code of a preceding ccw_device call, halt_IO etc...
  *
  * ch	:	The channel, the error belongs to.
@@ -223,7 +223,7 @@ void ctcm_purge_skb_queue(struct sk_buff_head *q)
 	}
 }
 
-/**
+/*
  * NOP action for statemachines
  */
 static void ctcm_action_nop(fsm_instance *fi, int event, void *arg)
@@ -234,7 +234,7 @@ static void ctcm_action_nop(fsm_instance *fi, int event, void *arg)
  * Actions for channel - statemachines.
  */
 
-/**
+/*
  * Normal data has been send. Free the corresponding
  * skb (it's in io_queue), reset dev->tbusy and
  * revert to idle state.
@@ -322,7 +322,7 @@ static void chx_txdone(fsm_instance *fi, int event, void *arg)
 	ctcm_clear_busy_do(dev);
 }
 
-/**
+/*
  * Initial data is sent.
  * Notify device statemachine that we are up and
  * running.
@@ -344,7 +344,7 @@ void ctcm_chx_txidle(fsm_instance *fi, int event, void *arg)
 	fsm_event(priv->fsm, DEV_EVENT_TXUP, ch->netdev);
 }
 
-/**
+/*
  * Got normal data, check for sanity, queue it up, allocate new buffer
  * trigger bottom half, and initiate next read.
  *
@@ -421,7 +421,7 @@ static void chx_rx(fsm_instance *fi, int event, void *arg)
 		ctcm_ccw_check_rc(ch, rc, "normal RX");
 }
 
-/**
+/*
  * Initialize connection by sending a __u16 of value 0.
  *
  * fi		An instance of a channel statemachine.
@@ -497,7 +497,7 @@ static void chx_firstio(fsm_instance *fi, int event, void *arg)
 	}
 }
 
-/**
+/*
  * Got initial data, check it. If OK,
  * notify device statemachine that we are up and
  * running.
@@ -538,7 +538,7 @@ static void chx_rxidle(fsm_instance *fi, int event, void *arg)
 	}
 }
 
-/**
+/*
  * Set channel into extended mode.
  *
  * fi		An instance of a channel statemachine.
@@ -578,7 +578,7 @@ static void ctcm_chx_setmode(fsm_instance *fi, int event, void *arg)
 		ch->retry = 0;
 }
 
-/**
+/*
  * Setup channel.
  *
  * fi		An instance of a channel statemachine.
@@ -641,7 +641,7 @@ static void ctcm_chx_start(fsm_instance *fi, int event, void *arg)
 	}
 }
 
-/**
+/*
  * Shutdown a channel.
  *
  * fi		An instance of a channel statemachine.
@@ -682,7 +682,7 @@ static void ctcm_chx_haltio(fsm_instance *fi, int event, void *arg)
 	}
 }
 
-/**
+/*
  * Cleanup helper for chx_fail and chx_stopped
  * cleanup channels queue and notify interface statemachine.
  *
@@ -728,7 +728,7 @@ static void ctcm_chx_cleanup(fsm_instance *fi, int state,
 	}
 }
 
-/**
+/*
  * A channel has successfully been halted.
  * Cleanup it's queue and notify interface statemachine.
  *
@@ -741,7 +741,7 @@ static void ctcm_chx_stopped(fsm_instance *fi, int event, void *arg)
 	ctcm_chx_cleanup(fi, CTC_STATE_STOPPED, arg);
 }
 
-/**
+/*
  * A stop command from device statemachine arrived and we are in
  * not operational mode. Set state to stopped.
  *
@@ -754,7 +754,7 @@ static void ctcm_chx_stop(fsm_instance *fi, int event, void *arg)
 	fsm_newstate(fi, CTC_STATE_STOPPED);
 }
 
-/**
+/*
  * A machine check for no path, not operational status or gone device has
  * happened.
  * Cleanup queue and notify interface statemachine.
@@ -768,7 +768,7 @@ static void ctcm_chx_fail(fsm_instance *fi, int event, void *arg)
 	ctcm_chx_cleanup(fi, CTC_STATE_NOTOP, arg);
 }
 
-/**
+/*
  * Handle error during setup of channel.
  *
  * fi		An instance of a channel statemachine.
@@ -817,7 +817,7 @@ static void ctcm_chx_setuperr(fsm_instance *fi, int event, void *arg)
 	}
 }
 
-/**
+/*
  * Restart a channel after an error.
  *
  * fi		An instance of a channel statemachine.
@@ -858,7 +858,7 @@ static void ctcm_chx_restart(fsm_instance *fi, int event, void *arg)
 	}
 }
 
-/**
+/*
  * Handle error during RX initial handshake (exchange of
  * 0-length block header)
  *
@@ -893,7 +893,7 @@ static void ctcm_chx_rxiniterr(fsm_instance *fi, int event, void *arg)
 	}
 }
 
-/**
+/*
  * Notify device statemachine if we gave up initialization
  * of RX channel.
  *
@@ -914,7 +914,7 @@ static void ctcm_chx_rxinitfail(fsm_instance *fi, int event, void *arg)
 	fsm_event(priv->fsm, DEV_EVENT_RXDOWN, dev);
 }
 
-/**
+/*
  * Handle RX Unit check remote reset (remote disconnected)
  *
  * fi		An instance of a channel statemachine.
@@ -946,7 +946,7 @@ static void ctcm_chx_rxdisc(fsm_instance *fi, int event, void *arg)
 	ccw_device_halt(ch2->cdev, 0);
 }
 
-/**
+/*
  * Handle error during TX channel initialization.
  *
  * fi		An instance of a channel statemachine.
@@ -978,7 +978,7 @@ static void ctcm_chx_txiniterr(fsm_instance *fi, int event, void *arg)
 	}
 }
 
-/**
+/*
  * Handle TX timeout by retrying operation.
  *
  * fi		An instance of a channel statemachine.
@@ -1050,7 +1050,7 @@ static void ctcm_chx_txretry(fsm_instance *fi, int event, void *arg)
 	return;
 }
 
-/**
+/*
  * Handle fatal errors during an I/O command.
  *
  * fi		An instance of a channel statemachine.
@@ -1198,7 +1198,7 @@ int ch_fsm_len = ARRAY_SIZE(ch_fsm);
  * Actions for mpc channel statemachine.
  */
 
-/**
+/*
  * Normal data has been send. Free the corresponding
  * skb (it's in io_queue), reset dev->tbusy and
  * revert to idle state.
@@ -1361,7 +1361,7 @@ static void ctcmpc_chx_txdone(fsm_instance *fi, int event, void *arg)
 	return;
 }
 
-/**
+/*
  * Got normal data, check for sanity, queue it up, allocate new buffer
  * trigger bottom half, and initiate next read.
  *
@@ -1464,7 +1464,7 @@ static void ctcmpc_chx_rx(fsm_instance *fi, int event, void *arg)
 
 }
 
-/**
+/*
  * Initialize connection by sending a __u16 of value 0.
  *
  * fi		An instance of a channel statemachine.
@@ -1516,7 +1516,7 @@ static void ctcmpc_chx_firstio(fsm_instance *fi, int event, void *arg)
 	return;
 }
 
-/**
+/*
  * Got initial data, check it. If OK,
  * notify device statemachine that we are up and
  * running.
@@ -2043,7 +2043,7 @@ int mpc_ch_fsm_len = ARRAY_SIZE(ctcmpc_ch_fsm);
  * Actions for interface - statemachine.
  */
 
-/**
+/*
  * Startup channels by sending CTC_EVENT_START to each channel.
  *
  * fi		An instance of an interface statemachine.
@@ -2068,7 +2068,7 @@ static void dev_action_start(fsm_instance *fi, int event, void *arg)
 	}
 }
 
-/**
+/*
  * Shutdown channels by sending CTC_EVENT_STOP to each channel.
  *
  * fi		An instance of an interface statemachine.
@@ -2122,7 +2122,7 @@ static void dev_action_restart(fsm_instance *fi, int event, void *arg)
 			DEV_EVENT_START, dev);
 }
 
-/**
+/*
  * Called from channel statemachine
  * when a channel is up and running.
  *
@@ -2183,7 +2183,7 @@ static void dev_action_chup(fsm_instance *fi, int event, void *arg)
 	}
 }
 
-/**
+/*
  * Called from device statemachine
  * when a channel has been shutdown.
  *
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index fd705429708e..5ea7eeb07002 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -55,7 +55,7 @@
 
 /* Some common global variables */
 
-/**
+/*
  * The root device for ctcm group devices
  */
 static struct device *ctcm_root_dev;
@@ -65,7 +65,7 @@ static struct device *ctcm_root_dev;
  */
 struct channel *channels;
 
-/**
+/*
  * Unpack a just received skb and hand it over to
  * upper layers.
  *
@@ -180,7 +180,7 @@ void ctcm_unpack_skb(struct channel *ch, struct sk_buff *pskb)
 	}
 }
 
-/**
+/*
  * Release a specific channel in the channel list.
  *
  *  ch		Pointer to channel struct to be released.
@@ -192,7 +192,7 @@ static void channel_free(struct channel *ch)
 	fsm_newstate(ch->fsm, CTC_STATE_IDLE);
 }
 
-/**
+/*
  * Remove a specific channel in the channel list.
  *
  *  ch		Pointer to channel struct to be released.
@@ -240,7 +240,7 @@ static void channel_remove(struct channel *ch)
 			chid, ok ? "OK" : "failed");
 }
 
-/**
+/*
  * Get a specific channel from the channel list.
  *
  *  type	Type of channel we are interested in.
@@ -300,7 +300,7 @@ static long ctcm_check_irb_error(struct ccw_device *cdev, struct irb *irb)
 }
 
 
-/**
+/*
  * Check sense of a unit check.
  *
  *  ch		The channel, the sense code belongs to.
@@ -414,7 +414,7 @@ int ctcm_ch_alloc_buffer(struct channel *ch)
  * Interface API for upper network layers
  */
 
-/**
+/*
  * Open an interface.
  * Called from generic network layer when ifconfig up is run.
  *
@@ -432,7 +432,7 @@ int ctcm_open(struct net_device *dev)
 	return 0;
 }
 
-/**
+/*
  * Close an interface.
  * Called from generic network layer when ifconfig down is run.
  *
@@ -451,7 +451,7 @@ int ctcm_close(struct net_device *dev)
 }
 
 
-/**
+/*
  * Transmit a packet.
  * This is a helper function for ctcm_tx().
  *
@@ -822,7 +822,7 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 	return rc;
 }
 
-/**
+/*
  * Start transmission of a packet.
  * Called from generic network device layer.
  *
@@ -975,7 +975,7 @@ static int ctcmpc_tx(struct sk_buff *skb, struct net_device *dev)
 }
 
 
-/**
+/*
  * Sets MTU of an interface.
  *
  *  dev		Pointer to interface struct.
@@ -1007,7 +1007,7 @@ static int ctcm_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-/**
+/*
  * Returns interface statistics of a device.
  *
  *  dev		Pointer to interface struct.
@@ -1144,7 +1144,7 @@ static struct net_device *ctcm_init_netdevice(struct ctcm_priv *priv)
 	return dev;
 }
 
-/**
+/*
  * Main IRQ handler.
  *
  *  cdev	The ccw_device the interrupt is for.
@@ -1257,7 +1257,7 @@ static const struct device_type ctcm_devtype = {
 	.groups = ctcm_attr_groups,
 };
 
-/**
+/*
  * Add ctcm specific attributes.
  * Add ctcm private data.
  *
@@ -1293,7 +1293,7 @@ static int ctcm_probe_device(struct ccwgroup_device *cgdev)
 	return 0;
 }
 
-/**
+/*
  * Add a new channel to the list of channels.
  * Keeps the channel list sorted.
  *
@@ -1343,7 +1343,7 @@ static int add_channel(struct ccw_device *cdev, enum ctcm_channel_types type,
 	snprintf(ch->id, CTCM_ID_SIZE, "ch-%s", dev_name(&cdev->dev));
 	ch->type = type;
 
-	/**
+	/*
 	 * "static" ccws are used in the following way:
 	 *
 	 * ccw[0..2] (Channel program for generic I/O):
@@ -1471,7 +1471,7 @@ static enum ctcm_channel_types get_channel_type(struct ccw_device_id *id)
 	return type;
 }
 
-/**
+/*
  *
  * Setup an interface.
  *
@@ -1595,7 +1595,7 @@ static int ctcm_new_device(struct ccwgroup_device *cgdev)
 	return result;
 }
 
-/**
+/*
  * Shutdown an interface.
  *
  *  cgdev	Device to be shut down.
@@ -1738,7 +1738,7 @@ static void print_banner(void)
 	pr_info("CTCM driver initialized\n");
 }
 
-/**
+/*
  * Initialize module.
  * This is called just after the module is loaded.
  *
diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index f0436f555c62..88abfb5e8045 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -1016,7 +1016,7 @@ void mpc_channel_action(struct channel *ch, int direction, int action)
 	CTCM_PR_DEBUG("exit %s: ch=0x%p id=%s\n", __func__, ch, ch->id);
 }
 
-/**
+/*
  * Unpack a just received skb and hand it over to
  * upper layers.
  * special MPC version of unpack_skb.
@@ -1211,7 +1211,7 @@ static void ctcmpc_unpack_skb(struct channel *ch, struct sk_buff *pskb)
 			__func__, dev->name, ch, ch->id);
 }
 
-/**
+/*
  * tasklet helper for mpc's skb unpacking.
  *
  * ch		The channel to work on.
@@ -1320,7 +1320,7 @@ struct mpc_group *ctcmpc_init_mpc_group(struct ctcm_priv *priv)
  * CTCM_PROTO_MPC only
  */
 
-/**
+/*
  * NOP action for statemachines
  */
 static void mpc_action_nop(fsm_instance *fi, int event, void *arg)
@@ -1426,7 +1426,7 @@ static void mpc_action_go_inop(fsm_instance *fi, int event, void *arg)
 	}
 }
 
-/**
+/*
  * Handle mpc group  action timeout.
  * MPC Group Station FSM action
  * CTCM_PROTO_MPC only
-- 
2.25.1

