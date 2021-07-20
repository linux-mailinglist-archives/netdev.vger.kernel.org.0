Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF443CF4A4
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 08:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbhGTF6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 01:58:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14222 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242481AbhGTF6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 01:58:25 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16K6YB2R057282;
        Tue, 20 Jul 2021 02:39:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=II8HqfHcJsqyFPFOqg98/fpTJ81RgzRN5sceo1k2tf8=;
 b=OfMgqTdSr6qz+NwRTTGOwtOIBXzOigZVw72idiz5/7Dqn3Yn20bBMDJgh8+ZYRvs36z5
 e/GZtYj5twVuY3+BEWR8peyCcqZ3F2OCoOPh5lR0DIXMskY04st0g9K0QxQx0ld6UGM/
 6g+AtPVnQiifGXu5fbypT0+j7sXj95nNdp9i4hn6dpHh83CaSx27XabrplavW6g09APA
 sCBmmtQ6/88wGNp46GcMmyk6og9t5LNl+ojqKYrBoZq9RglpsdsGsqaWZFH+766D+249
 1ptCpJyRSy6/yA6RO08lc3x03/dKbXisz21h1VNx8yfsc35wGekwVaZjUrWcSi6Nsiot PA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39wr5tsvx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 02:39:00 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16K6cwbS024976;
        Tue, 20 Jul 2021 06:38:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 39upu88mhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 06:38:58 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16K6aYjC22610230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 06:36:34 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3291FA405E;
        Tue, 20 Jul 2021 06:38:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCE40A405B;
        Tue, 20 Jul 2021 06:38:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Jul 2021 06:38:54 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 1/3] s390/qeth: remove OSN support
Date:   Tue, 20 Jul 2021 08:38:47 +0200
Message-Id: <20210720063849.2646776-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720063849.2646776-1-jwi@linux.ibm.com>
References: <20210720063849.2646776-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 14SB6gELTVLiKuV12eb5a9wSEC_a23uX
X-Proofpoint-GUID: 14SB6gELTVLiKuV12eb5a9wSEC_a23uX
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-20_04:2021-07-19,2021-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 malwarescore=0 spamscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107200037
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit fb64de1bc36c ("s390/qeth: phase out OSN support") spelled out
why the OSN support in qeth is in a bad shape, and put any remaining
interested parties on notice to speak up before it gets ripped out.

It's 2021 now, so make true on that promise and remove all the
OSN-specific parts from qeth. This also means that we no longer need to
export various parts of the cmd & data path internals to the L2 driver.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 arch/s390/include/asm/ccwgroup.h  |   2 -
 drivers/s390/cio/ccwgroup.c       |  22 ----
 drivers/s390/net/Kconfig          |   9 --
 drivers/s390/net/qeth_core.h      |  44 --------
 drivers/s390/net/qeth_core_main.c | 150 +++++++--------------------
 drivers/s390/net/qeth_core_mpc.c  |   3 -
 drivers/s390/net/qeth_core_mpc.h  |  17 +---
 drivers/s390/net/qeth_core_sys.c  |   5 -
 drivers/s390/net/qeth_ethtool.c   |   7 --
 drivers/s390/net/qeth_l2_main.c   | 164 +++---------------------------
 10 files changed, 48 insertions(+), 375 deletions(-)

diff --git a/arch/s390/include/asm/ccwgroup.h b/arch/s390/include/asm/ccwgroup.h
index 20f169b6db4e..36dbf5043fc0 100644
--- a/arch/s390/include/asm/ccwgroup.h
+++ b/arch/s390/include/asm/ccwgroup.h
@@ -53,8 +53,6 @@ extern int  ccwgroup_driver_register   (struct ccwgroup_driver *cdriver);
 extern void ccwgroup_driver_unregister (struct ccwgroup_driver *cdriver);
 int ccwgroup_create_dev(struct device *root, struct ccwgroup_driver *gdrv,
 			int num_devices, const char *buf);
-struct ccwgroup_device *get_ccwgroupdev_by_busid(struct ccwgroup_driver *gdrv,
-						 char *bus_id);
 
 extern int ccwgroup_set_online(struct ccwgroup_device *gdev);
 extern int ccwgroup_set_offline(struct ccwgroup_device *gdev);
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 9748165e08e9..acbe76a76fb2 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -503,28 +503,6 @@ void ccwgroup_driver_unregister(struct ccwgroup_driver *cdriver)
 }
 EXPORT_SYMBOL(ccwgroup_driver_unregister);
 
-/**
- * get_ccwgroupdev_by_busid() - obtain device from a bus id
- * @gdrv: driver the device is owned by
- * @bus_id: bus id of the device to be searched
- *
- * This function searches all devices owned by @gdrv for a device with a bus
- * id matching @bus_id.
- * Returns:
- *  If a match is found, its reference count of the found device is increased
- *  and it is returned; else %NULL is returned.
- */
-struct ccwgroup_device *get_ccwgroupdev_by_busid(struct ccwgroup_driver *gdrv,
-						 char *bus_id)
-{
-	struct device *dev;
-
-	dev = driver_find_device_by_name(&gdrv->driver, bus_id);
-
-	return dev ? to_ccwgroupdev(dev) : NULL;
-}
-EXPORT_SYMBOL_GPL(get_ccwgroupdev_by_busid);
-
 /**
  * ccwgroup_probe_ccwdev() - probe function for slave devices
  * @cdev: ccw device to be probed
diff --git a/drivers/s390/net/Kconfig b/drivers/s390/net/Kconfig
index bf236d474538..cff91b4f1a76 100644
--- a/drivers/s390/net/Kconfig
+++ b/drivers/s390/net/Kconfig
@@ -88,15 +88,6 @@ config QETH_L3
 	  To compile as a module choose M. The module name is qeth_l3.
 	  If unsure, choose Y.
 
-config QETH_OSN
-	def_bool !HAVE_MARCH_Z14_FEATURES
-	prompt "qeth OSN device support"
-	depends on QETH
-	help
-	  This enables the qeth driver to support devices in OSN mode.
-	  This feature will be removed in 2021.
-	  If unsure, choose N.
-
 config QETH_OSX
 	def_bool !HAVE_MARCH_Z15_FEATURES
 	prompt "qeth OSX device support"
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index f4d554ea0c93..6819cc82fc00 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -259,22 +259,10 @@ struct qeth_hdr_layer2 {
 	__u8 reserved2[16];
 } __attribute__ ((packed));
 
-struct qeth_hdr_osn {
-	__u8 id;
-	__u8 reserved;
-	__u16 seq_no;
-	__u16 reserved2;
-	__u16 control_flags;
-	__u16 pdu_length;
-	__u8 reserved3[18];
-	__u32 ccid;
-} __attribute__ ((packed));
-
 struct qeth_hdr {
 	union {
 		struct qeth_hdr_layer2 l2;
 		struct qeth_hdr_layer3 l3;
-		struct qeth_hdr_osn    osn;
 	} hdr;
 } __attribute__ ((packed));
 
@@ -341,7 +329,6 @@ enum qeth_header_ids {
 	QETH_HEADER_TYPE_LAYER3 = 0x01,
 	QETH_HEADER_TYPE_LAYER2 = 0x02,
 	QETH_HEADER_TYPE_L3_TSO	= 0x03,
-	QETH_HEADER_TYPE_OSN    = 0x04,
 	QETH_HEADER_TYPE_L2_TSO	= 0x06,
 	QETH_HEADER_MASK_INVAL	= 0x80,
 };
@@ -779,11 +766,6 @@ enum qeth_threads {
 	QETH_RECOVER_THREAD = 1,
 };
 
-struct qeth_osn_info {
-	int (*assist_cb)(struct net_device *dev, void *data);
-	int (*data_cb)(struct sk_buff *skb);
-};
-
 struct qeth_discipline {
 	const struct device_type *devtype;
 	int (*setup) (struct ccwgroup_device *);
@@ -865,7 +847,6 @@ struct qeth_card {
 	/* QDIO buffer handling */
 	struct qeth_qdio_info qdio;
 	int read_or_write_problem;
-	struct qeth_osn_info osn_info;
 	const struct qeth_discipline *discipline;
 	atomic_t force_alloc_skb;
 	struct service_level qeth_service_level;
@@ -1058,9 +1039,7 @@ int qeth_get_priority_queue(struct qeth_card *card, struct sk_buff *skb);
 extern const struct qeth_discipline qeth_l2_discipline;
 extern const struct qeth_discipline qeth_l3_discipline;
 extern const struct ethtool_ops qeth_ethtool_ops;
-extern const struct ethtool_ops qeth_osn_ethtool_ops;
 extern const struct attribute_group *qeth_dev_groups[];
-extern const struct attribute_group *qeth_osn_dev_groups[];
 extern const struct device_type qeth_generic_devtype;
 
 const char *qeth_get_cardname_short(struct qeth_card *);
@@ -1069,11 +1048,9 @@ int qeth_setup_discipline(struct qeth_card *card, enum qeth_discipline_id disc);
 void qeth_remove_discipline(struct qeth_card *card);
 
 /* exports for qeth discipline device drivers */
-extern struct kmem_cache *qeth_core_header_cache;
 extern struct qeth_dbf_info qeth_dbf[QETH_DBF_INFOS];
 
 struct net_device *qeth_clone_netdev(struct net_device *orig);
-struct qeth_card *qeth_get_card_by_busid(char *bus_id);
 void qeth_set_allowed_threads(struct qeth_card *card, unsigned long threads,
 			      int clear_start_mask);
 int qeth_threads_running(struct qeth_card *, unsigned long);
@@ -1088,9 +1065,6 @@ struct qeth_cmd_buffer *qeth_ipa_alloc_cmd(struct qeth_card *card,
 					   enum qeth_ipa_cmds cmd_code,
 					   enum qeth_prot_versions prot,
 					   unsigned int data_length);
-struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
-				       unsigned int length, unsigned int ccws,
-				       long timeout);
 struct qeth_cmd_buffer *qeth_get_setassparms_cmd(struct qeth_card *card,
 						 enum qeth_ipa_funcs ipa_func,
 						 u16 cmd_code,
@@ -1099,18 +1073,12 @@ struct qeth_cmd_buffer *qeth_get_setassparms_cmd(struct qeth_card *card,
 struct qeth_cmd_buffer *qeth_get_diag_cmd(struct qeth_card *card,
 					  enum qeth_diags_cmds sub_cmd,
 					  unsigned int data_length);
-void qeth_notify_cmd(struct qeth_cmd_buffer *iob, int reason);
-void qeth_put_cmd(struct qeth_cmd_buffer *iob);
 
 int qeth_schedule_recovery(struct qeth_card *card);
 int qeth_poll(struct napi_struct *napi, int budget);
 void qeth_setadp_promisc_mode(struct qeth_card *card, bool enable);
 int qeth_setadpparms_change_macaddr(struct qeth_card *);
 void qeth_tx_timeout(struct net_device *, unsigned int txqueue);
-void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
-			  u16 cmd_length,
-			  bool (*match)(struct qeth_cmd_buffer *iob,
-					struct qeth_cmd_buffer *reply));
 int qeth_query_switch_attributes(struct qeth_card *card,
 				  struct qeth_switch_info *sw_info);
 int qeth_query_card_info(struct qeth_card *card,
@@ -1118,11 +1086,6 @@ int qeth_query_card_info(struct qeth_card *card,
 int qeth_setadpparms_set_access_ctrl(struct qeth_card *card,
 				     enum qeth_ipa_isolation_modes mode);
 
-unsigned int qeth_count_elements(struct sk_buff *skb, unsigned int data_offset);
-int qeth_do_send_packet(struct qeth_card *card, struct qeth_qdio_out_q *queue,
-			struct sk_buff *skb, struct qeth_hdr *hdr,
-			unsigned int offset, unsigned int hd_len,
-			int elements_needed);
 int qeth_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 void qeth_dbf_longtext(debug_info_t *id, int level, char *text, ...);
 int qeth_configure_cq(struct qeth_card *, enum qeth_cq);
@@ -1148,11 +1111,4 @@ int qeth_xmit(struct qeth_card *card, struct sk_buff *skb,
 				  struct qeth_hdr *hdr, struct sk_buff *skb,
 				  __be16 proto, unsigned int data_len));
 
-/* exports for OSN */
-int qeth_osn_assist(struct net_device *, void *, int);
-int qeth_osn_register(unsigned char *read_dev_no, struct net_device **,
-		int (*assist_cb)(struct net_device *, void *),
-		int (*data_cb)(struct sk_buff *));
-void qeth_osn_deregister(struct net_device *);
-
 #endif /* __QETH_CORE_H__ */
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 62f88ccbd03f..19a4bf25bd75 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -57,8 +57,7 @@ struct qeth_dbf_info qeth_dbf[QETH_DBF_INFOS] = {
 };
 EXPORT_SYMBOL_GPL(qeth_dbf);
 
-struct kmem_cache *qeth_core_header_cache;
-EXPORT_SYMBOL_GPL(qeth_core_header_cache);
+static struct kmem_cache *qeth_core_header_cache;
 static struct kmem_cache *qeth_qdio_outbuf_cache;
 
 static struct device *qeth_core_root_dev;
@@ -101,8 +100,6 @@ static const char *qeth_get_cardname(struct qeth_card *card)
 			return " OSD Express";
 		case QETH_CARD_TYPE_IQD:
 			return " HiperSockets";
-		case QETH_CARD_TYPE_OSN:
-			return " OSN QDIO";
 		case QETH_CARD_TYPE_OSM:
 			return " OSM QDIO";
 		case QETH_CARD_TYPE_OSX:
@@ -157,8 +154,6 @@ const char *qeth_get_cardname_short(struct qeth_card *card)
 			}
 		case QETH_CARD_TYPE_IQD:
 			return "HiperSockets";
-		case QETH_CARD_TYPE_OSN:
-			return "OSN";
 		case QETH_CARD_TYPE_OSM:
 			return "OSM_1000";
 		case QETH_CARD_TYPE_OSX:
@@ -431,6 +426,13 @@ static enum iucv_tx_notify qeth_compute_cq_notification(int sbalf15,
 	return n;
 }
 
+static void qeth_put_cmd(struct qeth_cmd_buffer *iob)
+{
+	if (refcount_dec_and_test(&iob->ref_count)) {
+		kfree(iob->data);
+		kfree(iob);
+	}
+}
 static void qeth_setup_ccw(struct ccw1 *ccw, u8 cmd_code, u8 flags, u32 len,
 			   void *data)
 {
@@ -499,12 +501,11 @@ static void qeth_dequeue_cmd(struct qeth_card *card,
 	spin_unlock_irq(&card->lock);
 }
 
-void qeth_notify_cmd(struct qeth_cmd_buffer *iob, int reason)
+static void qeth_notify_cmd(struct qeth_cmd_buffer *iob, int reason)
 {
 	iob->rc = reason;
 	complete(&iob->done);
 }
-EXPORT_SYMBOL_GPL(qeth_notify_cmd);
 
 static void qeth_flush_local_addrs4(struct qeth_card *card)
 {
@@ -781,10 +782,7 @@ static struct qeth_ipa_cmd *qeth_check_ipa_data(struct qeth_card *card,
 	QETH_CARD_TEXT(card, 5, "chkipad");
 
 	if (IS_IPA_REPLY(cmd)) {
-		if (cmd->hdr.command != IPA_CMD_SETCCID &&
-		    cmd->hdr.command != IPA_CMD_DELCCID &&
-		    cmd->hdr.command != IPA_CMD_MODCCID &&
-		    cmd->hdr.command != IPA_CMD_SET_DIAG_ASS)
+		if (cmd->hdr.command != IPA_CMD_SET_DIAG_ASS)
 			qeth_issue_ipa_msg(cmd, cmd->hdr.return_code, card);
 		return cmd;
 	}
@@ -819,8 +817,6 @@ static struct qeth_ipa_cmd *qeth_check_ipa_data(struct qeth_card *card,
 		if (card->discipline->control_event_handler(card, cmd))
 			return cmd;
 		return NULL;
-	case IPA_CMD_MODCCID:
-		return cmd;
 	case IPA_CMD_REGISTER_LOCAL_ADDR:
 		if (cmd->hdr.prot_version == QETH_PROT_IPV4)
 			qeth_add_local_addrs4(card, &cmd->data.local_addrs4);
@@ -877,15 +873,6 @@ static int qeth_check_idx_response(struct qeth_card *card,
 	return 0;
 }
 
-void qeth_put_cmd(struct qeth_cmd_buffer *iob)
-{
-	if (refcount_dec_and_test(&iob->ref_count)) {
-		kfree(iob->data);
-		kfree(iob);
-	}
-}
-EXPORT_SYMBOL_GPL(qeth_put_cmd);
-
 static void qeth_release_buffer_cb(struct qeth_card *card,
 				   struct qeth_cmd_buffer *iob,
 				   unsigned int data_length)
@@ -899,9 +886,9 @@ static void qeth_cancel_cmd(struct qeth_cmd_buffer *iob, int rc)
 	qeth_put_cmd(iob);
 }
 
-struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
-				       unsigned int length, unsigned int ccws,
-				       long timeout)
+static struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
+					      unsigned int length,
+					      unsigned int ccws, long timeout)
 {
 	struct qeth_cmd_buffer *iob;
 
@@ -927,7 +914,6 @@ struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
 	iob->length = length;
 	return iob;
 }
-EXPORT_SYMBOL_GPL(qeth_alloc_cmd);
 
 static void qeth_issue_next_read_cb(struct qeth_card *card,
 				    struct qeth_cmd_buffer *iob,
@@ -958,11 +944,6 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 		cmd = qeth_check_ipa_data(card, cmd);
 		if (!cmd)
 			goto out;
-		if (IS_OSN(card) && card->osn_info.assist_cb &&
-		    cmd->hdr.command != IPA_CMD_STARTLAN) {
-			card->osn_info.assist_cb(card->dev, cmd);
-			goto out;
-		}
 	}
 
 	/* match against pending cmd requests */
@@ -1835,7 +1816,7 @@ static enum qeth_discipline_id qeth_enforce_discipline(struct qeth_card *card)
 {
 	enum qeth_discipline_id disc = QETH_DISCIPLINE_UNDETERMINED;
 
-	if (IS_OSM(card) || IS_OSN(card))
+	if (IS_OSM(card))
 		disc = QETH_DISCIPLINE_LAYER2;
 	else if (IS_VM_NIC(card))
 		disc = IS_IQD(card) ? QETH_DISCIPLINE_LAYER3 :
@@ -1885,7 +1866,6 @@ static void qeth_idx_init(struct qeth_card *card)
 		card->info.func_level =	QETH_IDX_FUNC_LEVEL_IQD;
 		break;
 	case QETH_CARD_TYPE_OSD:
-	case QETH_CARD_TYPE_OSN:
 		card->info.func_level = QETH_IDX_FUNC_LEVEL_OSD;
 		break;
 	default:
@@ -2442,8 +2422,6 @@ static int qeth_ulp_enable_cb(struct qeth_card *card, struct qeth_reply *reply,
 
 static u8 qeth_mpc_select_prot_type(struct qeth_card *card)
 {
-	if (IS_OSN(card))
-		return QETH_PROT_OSN2;
 	return IS_LAYER2(card) ? QETH_PROT_LAYER2 : QETH_PROT_TCPIP;
 }
 
@@ -3000,10 +2978,8 @@ static void qeth_ipa_finalize_cmd(struct qeth_card *card,
 	__ipa_cmd(iob)->hdr.seqno = card->seqno.ipa++;
 }
 
-void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
-			  u16 cmd_length,
-			  bool (*match)(struct qeth_cmd_buffer *iob,
-					struct qeth_cmd_buffer *reply))
+static void qeth_prepare_ipa_cmd(struct qeth_card *card,
+				 struct qeth_cmd_buffer *iob, u16 cmd_length)
 {
 	u8 prot_type = qeth_mpc_select_prot_type(card);
 	u16 total_length = iob->length;
@@ -3011,7 +2987,6 @@ void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 	qeth_setup_ccw(__ccw_from_cmd(iob), CCW_CMD_WRITE, 0, total_length,
 		       iob->data);
 	iob->finalize = qeth_ipa_finalize_cmd;
-	iob->match = match;
 
 	memcpy(iob->data, IPA_PDU_HEADER, IPA_PDU_HEADER_SIZE);
 	memcpy(QETH_IPA_PDU_LEN_TOTAL(iob->data), &total_length, 2);
@@ -3022,7 +2997,6 @@ void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 	       &card->token.ulp_connection_r, QETH_MPC_TOKEN_LENGTH);
 	memcpy(QETH_IPA_PDU_LEN_PDU3(iob->data), &cmd_length, 2);
 }
-EXPORT_SYMBOL_GPL(qeth_prepare_ipa_cmd);
 
 static bool qeth_ipa_match_reply(struct qeth_cmd_buffer *iob,
 				 struct qeth_cmd_buffer *reply)
@@ -3046,7 +3020,8 @@ struct qeth_cmd_buffer *qeth_ipa_alloc_cmd(struct qeth_card *card,
 	if (!iob)
 		return NULL;
 
-	qeth_prepare_ipa_cmd(card, iob, data_length, qeth_ipa_match_reply);
+	qeth_prepare_ipa_cmd(card, iob, data_length);
+	iob->match = qeth_ipa_match_reply;
 
 	hdr = &__ipa_cmd(iob)->hdr;
 	hdr->command = cmd_code;
@@ -3894,7 +3869,8 @@ static int qeth_get_elements_for_frags(struct sk_buff *skb)
  * Returns the number of pages, and thus QDIO buffer elements, needed to map the
  * skb's data (both its linear part and paged fragments).
  */
-unsigned int qeth_count_elements(struct sk_buff *skb, unsigned int data_offset)
+static unsigned int qeth_count_elements(struct sk_buff *skb,
+					unsigned int data_offset)
 {
 	unsigned int elements = qeth_get_elements_for_frags(skb);
 	addr_t end = (addr_t)skb->data + skb_headlen(skb);
@@ -3904,7 +3880,6 @@ unsigned int qeth_count_elements(struct sk_buff *skb, unsigned int data_offset)
 		elements += qeth_get_elements_for_range(start, end);
 	return elements;
 }
-EXPORT_SYMBOL_GPL(qeth_count_elements);
 
 #define QETH_HDR_CACHE_OBJ_SIZE		(sizeof(struct qeth_hdr_tso) + \
 					 MAX_TCP_HEADER)
@@ -4192,10 +4167,11 @@ static int __qeth_xmit(struct qeth_card *card, struct qeth_qdio_out_q *queue,
 	return 0;
 }
 
-int qeth_do_send_packet(struct qeth_card *card, struct qeth_qdio_out_q *queue,
-			struct sk_buff *skb, struct qeth_hdr *hdr,
-			unsigned int offset, unsigned int hd_len,
-			int elements_needed)
+static int qeth_do_send_packet(struct qeth_card *card,
+			       struct qeth_qdio_out_q *queue,
+			       struct sk_buff *skb, struct qeth_hdr *hdr,
+			       unsigned int offset, unsigned int hd_len,
+			       unsigned int elements_needed)
 {
 	unsigned int start_index = queue->next_buf_to_fill;
 	struct qeth_qdio_out_buffer *buffer;
@@ -4275,7 +4251,6 @@ int qeth_do_send_packet(struct qeth_card *card, struct qeth_qdio_out_q *queue,
 		netif_tx_start_queue(txq);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(qeth_do_send_packet);
 
 static void qeth_fill_tso_ext(struct qeth_hdr_tso *hdr,
 			      unsigned int payload_len, struct sk_buff *skb,
@@ -4554,7 +4529,6 @@ static int qeth_mdio_read(struct net_device *dev, int phy_id, int regnum)
 	case MII_BMCR: /* Basic mode control register */
 		rc = BMCR_FULLDPLX;
 		if ((card->info.link_type != QETH_LINK_TYPE_GBIT_ETH) &&
-		    (card->info.link_type != QETH_LINK_TYPE_OSN) &&
 		    (card->info.link_type != QETH_LINK_TYPE_10GBIT_ETH) &&
 		    (card->info.link_type != QETH_LINK_TYPE_25GBIT_ETH))
 			rc |= BMCR_SPEED100;
@@ -5266,10 +5240,6 @@ static struct ccw_device_id qeth_ids[] = {
 					.driver_info = QETH_CARD_TYPE_OSD},
 	{CCW_DEVICE_DEVTYPE(0x1731, 0x05, 0x1732, 0x05),
 					.driver_info = QETH_CARD_TYPE_IQD},
-#ifdef CONFIG_QETH_OSN
-	{CCW_DEVICE_DEVTYPE(0x1731, 0x06, 0x1732, 0x06),
-					.driver_info = QETH_CARD_TYPE_OSN},
-#endif
 	{CCW_DEVICE_DEVTYPE(0x1731, 0x02, 0x1732, 0x03),
 					.driver_info = QETH_CARD_TYPE_OSM},
 #ifdef CONFIG_QETH_OSX
@@ -5628,14 +5598,6 @@ static void qeth_receive_skb(struct qeth_card *card, struct sk_buff *skb,
 	bool is_cso;
 
 	switch (hdr->hdr.l2.id) {
-	case QETH_HEADER_TYPE_OSN:
-		skb_push(skb, sizeof(*hdr));
-		skb_copy_to_linear_data(skb, hdr, sizeof(*hdr));
-		QETH_CARD_STAT_ADD(card, rx_bytes, skb->len);
-		QETH_CARD_STAT_INC(card, rx_packets);
-
-		card->osn_info.data_cb(skb);
-		return;
 #if IS_ENABLED(CONFIG_QETH_L3)
 	case QETH_HEADER_TYPE_LAYER3:
 		qeth_l3_rebuild_skb(card, skb, hdr);
@@ -5750,16 +5712,6 @@ static int qeth_extract_skb(struct qeth_card *card,
 			linear_len = sizeof(struct iphdr);
 		headroom = ETH_HLEN;
 		break;
-	case QETH_HEADER_TYPE_OSN:
-		skb_len = hdr->hdr.osn.pdu_length;
-		if (!IS_OSN(card)) {
-			QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
-			goto walk_packet;
-		}
-
-		linear_len = skb_len;
-		headroom = sizeof(struct qeth_hdr);
-		break;
 	default:
 		if (hdr->hdr.l2.id & QETH_HEADER_MASK_INVAL)
 			QETH_CARD_STAT_INC(card, rx_frame_errors);
@@ -5777,8 +5729,7 @@ static int qeth_extract_skb(struct qeth_card *card,
 
 	use_rx_sg = (card->options.cq == QETH_CQ_ENABLED) ||
 		    (skb_len > READ_ONCE(priv->rx_copybreak) &&
-		     !atomic_read(&card->force_alloc_skb) &&
-		     !IS_OSN(card));
+		     !atomic_read(&card->force_alloc_skb));
 
 	if (use_rx_sg) {
 		/* QETH_CQ_ENABLED only: */
@@ -6340,10 +6291,6 @@ const struct device_type qeth_generic_devtype = {
 };
 EXPORT_SYMBOL_GPL(qeth_generic_devtype);
 
-static const struct device_type qeth_osn_devtype = {
-	.name = "qeth_osn",
-};
-
 #define DBF_NAME_LEN	20
 
 struct qeth_dbf_entry {
@@ -6425,10 +6372,6 @@ static struct net_device *qeth_alloc_netdev(struct qeth_card *card)
 	case QETH_CARD_TYPE_OSM:
 		dev = alloc_etherdev(sizeof(*priv));
 		break;
-	case QETH_CARD_TYPE_OSN:
-		dev = alloc_netdev(sizeof(*priv), "osn%d", NET_NAME_UNKNOWN,
-				   ether_setup);
-		break;
 	default:
 		dev = alloc_etherdev_mqs(sizeof(*priv), QETH_MAX_OUT_QUEUES, 1);
 	}
@@ -6442,23 +6385,19 @@ static struct net_device *qeth_alloc_netdev(struct qeth_card *card)
 
 	dev->ml_priv = card;
 	dev->watchdog_timeo = QETH_TX_TIMEOUT;
-	dev->min_mtu = IS_OSN(card) ? 64 : 576;
+	dev->min_mtu = 576;
 	 /* initialized when device first goes online: */
 	dev->max_mtu = 0;
 	dev->mtu = 0;
 	SET_NETDEV_DEV(dev, &card->gdev->dev);
 	netif_carrier_off(dev);
 
-	if (IS_OSN(card)) {
-		dev->ethtool_ops = &qeth_osn_ethtool_ops;
-	} else {
-		dev->ethtool_ops = &qeth_ethtool_ops;
-		dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-		dev->hw_features |= NETIF_F_SG;
-		dev->vlan_features |= NETIF_F_SG;
-		if (IS_IQD(card))
-			dev->features |= NETIF_F_SG;
-	}
+	dev->ethtool_ops = &qeth_ethtool_ops;
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+	dev->hw_features |= NETIF_F_SG;
+	dev->vlan_features |= NETIF_F_SG;
+	if (IS_IQD(card))
+		dev->features |= NETIF_F_SG;
 
 	return dev;
 }
@@ -6521,10 +6460,7 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 	if (rc)
 		goto err_chp_desc;
 
-	if (IS_OSN(card))
-		gdev->dev.groups = qeth_osn_dev_groups;
-	else
-		gdev->dev.groups = qeth_dev_groups;
+	gdev->dev.groups = qeth_dev_groups;
 
 	enforced_disc = qeth_enforce_discipline(card);
 	switch (enforced_disc) {
@@ -6538,8 +6474,7 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 		if (rc)
 			goto err_setup_disc;
 
-		gdev->dev.type = IS_OSN(card) ? &qeth_osn_devtype :
-						card->discipline->devtype;
+		gdev->dev.type = card->discipline->devtype;
 		break;
 	}
 
@@ -6657,21 +6592,6 @@ static struct ccwgroup_driver qeth_core_ccwgroup_driver = {
 	.shutdown = qeth_core_shutdown,
 };
 
-struct qeth_card *qeth_get_card_by_busid(char *bus_id)
-{
-	struct ccwgroup_device *gdev;
-	struct qeth_card *card;
-
-	gdev = get_ccwgroupdev_by_busid(&qeth_core_ccwgroup_driver, bus_id);
-	if (!gdev)
-		return NULL;
-
-	card = dev_get_drvdata(&gdev->dev);
-	put_device(&gdev->dev);
-	return card;
-}
-EXPORT_SYMBOL_GPL(qeth_get_card_by_busid);
-
 int qeth_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	struct qeth_card *card = dev->ml_priv;
diff --git a/drivers/s390/net/qeth_core_mpc.c b/drivers/s390/net/qeth_core_mpc.c
index 68c2588b9dcc..d9266f7d8187 100644
--- a/drivers/s390/net/qeth_core_mpc.c
+++ b/drivers/s390/net/qeth_core_mpc.c
@@ -232,9 +232,6 @@ static const struct ipa_cmd_names qeth_ipa_cmd_names[] = {
 	{IPA_CMD_DELVLAN,	"delvlan"},
 	{IPA_CMD_VNICC,		"vnic_characteristics"},
 	{IPA_CMD_SETBRIDGEPORT_OSA,	"set_bridge_port(osa)"},
-	{IPA_CMD_SETCCID,	"setccid"},
-	{IPA_CMD_DELCCID,	"delccid"},
-	{IPA_CMD_MODCCID,	"modccid"},
 	{IPA_CMD_SETIP,		"setip"},
 	{IPA_CMD_QIPASSIST,	"qipassist"},
 	{IPA_CMD_SETASSPARMS,	"setassparms"},
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index e4bde7daf083..a0dbe8b77924 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -34,8 +34,6 @@ extern const unsigned char IPA_PDU_HEADER[];
 /*****************************************************************************/
 #define IPA_CMD_INITIATOR_HOST  0x00
 #define IPA_CMD_INITIATOR_OSA   0x01
-#define IPA_CMD_INITIATOR_HOST_REPLY  0x80
-#define IPA_CMD_INITIATOR_OSA_REPLY   0x81
 #define IPA_CMD_PRIM_VERSION_NO 0x01
 
 struct qeth_ipa_caps {
@@ -66,7 +64,6 @@ static inline bool qeth_ipa_caps_enabled(struct qeth_ipa_caps *caps, u32 mask)
 enum qeth_card_types {
 	QETH_CARD_TYPE_OSD     = 1,
 	QETH_CARD_TYPE_IQD     = 5,
-	QETH_CARD_TYPE_OSN     = 6,
 	QETH_CARD_TYPE_OSM     = 3,
 	QETH_CARD_TYPE_OSX     = 2,
 };
@@ -75,12 +72,6 @@ enum qeth_card_types {
 #define IS_OSD(card)	((card)->info.type == QETH_CARD_TYPE_OSD)
 #define IS_OSM(card)	((card)->info.type == QETH_CARD_TYPE_OSM)
 
-#ifdef CONFIG_QETH_OSN
-#define IS_OSN(card)	((card)->info.type == QETH_CARD_TYPE_OSN)
-#else
-#define IS_OSN(card)	false
-#endif
-
 #ifdef CONFIG_QETH_OSX
 #define IS_OSX(card)	((card)->info.type == QETH_CARD_TYPE_OSX)
 #else
@@ -95,7 +86,6 @@ enum qeth_link_types {
 	QETH_LINK_TYPE_FAST_ETH     = 0x01,
 	QETH_LINK_TYPE_HSTR         = 0x02,
 	QETH_LINK_TYPE_GBIT_ETH     = 0x03,
-	QETH_LINK_TYPE_OSN          = 0x04,
 	QETH_LINK_TYPE_10GBIT_ETH   = 0x10,
 	QETH_LINK_TYPE_25GBIT_ETH   = 0x12,
 	QETH_LINK_TYPE_LANE_ETH100  = 0x81,
@@ -126,9 +116,6 @@ enum qeth_ipa_cmds {
 	IPA_CMD_DELVLAN			= 0x26,
 	IPA_CMD_VNICC			= 0x2a,
 	IPA_CMD_SETBRIDGEPORT_OSA	= 0x2b,
-	IPA_CMD_SETCCID			= 0x41,
-	IPA_CMD_DELCCID			= 0x42,
-	IPA_CMD_MODCCID			= 0x43,
 	IPA_CMD_SETIP			= 0xb1,
 	IPA_CMD_QIPASSIST		= 0xb2,
 	IPA_CMD_SETASSPARMS		= 0xb3,
@@ -879,8 +866,7 @@ extern const char *qeth_get_ipa_msg(enum qeth_ipa_return_codes rc);
 extern const char *qeth_get_ipa_cmd_name(enum qeth_ipa_cmds cmd);
 
 /* Helper functions */
-#define IS_IPA_REPLY(cmd) ((cmd->hdr.initiator == IPA_CMD_INITIATOR_HOST) || \
-			   (cmd->hdr.initiator == IPA_CMD_INITIATOR_OSA_REPLY))
+#define IS_IPA_REPLY(cmd) ((cmd)->hdr.initiator == IPA_CMD_INITIATOR_HOST)
 
 /*****************************************************************************/
 /* END OF   IP Assist related definitions                                    */
@@ -922,7 +908,6 @@ extern const unsigned char ULP_ENABLE[];
 /* Layer 2 definitions */
 #define QETH_PROT_LAYER2 0x08
 #define QETH_PROT_TCPIP  0x03
-#define QETH_PROT_OSN2   0x0a
 #define QETH_ULP_ENABLE_PROT_TYPE(buffer) (buffer + 0x50)
 #define QETH_IPA_CMD_PROT_TYPE(buffer) (buffer + 0x19)
 
diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index 5815114da468..406be169173c 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -671,11 +671,6 @@ static const struct attribute_group qeth_dev_group = {
 	.attrs = qeth_dev_attrs,
 };
 
-const struct attribute_group *qeth_osn_dev_groups[] = {
-	&qeth_dev_group,
-	NULL,
-};
-
 const struct attribute_group *qeth_dev_groups[] = {
 	&qeth_dev_group,
 	&qeth_dev_extended_group,
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index 2c4cb300a8fc..3937986f159a 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -469,10 +469,3 @@ const struct ethtool_ops qeth_ethtool_ops = {
 	.set_per_queue_coalesce = qeth_set_per_queue_coalesce,
 	.get_link_ksettings = qeth_get_link_ksettings,
 };
-
-const struct ethtool_ops qeth_osn_ethtool_ops = {
-	.get_strings = qeth_get_strings,
-	.get_ethtool_stats = qeth_get_ethtool_stats,
-	.get_sset_count = qeth_get_sset_count,
-	.get_drvinfo = qeth_get_drvinfo,
-};
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 2abf86c104d5..c00cc6ea721f 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -309,17 +309,16 @@ static int qeth_l2_request_initial_mac(struct qeth_card *card)
 		/* fall back to alternative mechanism: */
 	}
 
-	if (!IS_OSN(card)) {
-		rc = qeth_setadpparms_change_macaddr(card);
-		if (!rc)
-			goto out;
-		QETH_DBF_MESSAGE(2, "READ_MAC Assist failed on device %x: %#x\n",
-				 CARD_DEVID(card), rc);
-		QETH_CARD_TEXT_(card, 2, "1err%04x", rc);
-		/* fall back once more: */
-	}
+	rc = qeth_setadpparms_change_macaddr(card);
+	if (!rc)
+		goto out;
+	QETH_DBF_MESSAGE(2, "READ_MAC Assist failed on device %x: %#x\n",
+			 CARD_DEVID(card), rc);
+	QETH_CARD_TEXT_(card, 2, "1err%04x", rc);
 
-	/* some devices don't support a custom MAC address: */
+	/* Fall back once more, but some devices don't support a custom MAC
+	 * address:
+	 */
 	if (IS_OSM(card) || IS_OSX(card))
 		return (rc) ? rc : -EADDRNOTAVAIL;
 	eth_hw_addr_random(card->dev);
@@ -334,7 +333,7 @@ static void qeth_l2_register_dev_addr(struct qeth_card *card)
 	if (!is_valid_ether_addr(card->dev->dev_addr))
 		qeth_l2_request_initial_mac(card);
 
-	if (!IS_OSN(card) && !qeth_l2_send_setmac(card, card->dev->dev_addr))
+	if (!qeth_l2_send_setmac(card, card->dev->dev_addr))
 		card->info.dev_addr_is_registered = 1;
 	else
 		card->info.dev_addr_is_registered = 0;
@@ -496,44 +495,6 @@ static void qeth_l2_rx_mode_work(struct work_struct *work)
 	qeth_l2_set_promisc_mode(card);
 }
 
-static int qeth_l2_xmit_osn(struct qeth_card *card, struct sk_buff *skb,
-			    struct qeth_qdio_out_q *queue)
-{
-	gfp_t gfp = GFP_ATOMIC | (skb_pfmemalloc(skb) ? __GFP_MEMALLOC : 0);
-	struct qeth_hdr *hdr = (struct qeth_hdr *)skb->data;
-	addr_t end = (addr_t)(skb->data + sizeof(*hdr));
-	addr_t start = (addr_t)skb->data;
-	unsigned int elements = 0;
-	unsigned int hd_len = 0;
-	int rc;
-
-	if (skb->protocol == htons(ETH_P_IPV6))
-		return -EPROTONOSUPPORT;
-
-	if (qeth_get_elements_for_range(start, end) > 1) {
-		/* Misaligned HW header, move it to its own buffer element. */
-		hdr = kmem_cache_alloc(qeth_core_header_cache, gfp);
-		if (!hdr)
-			return -ENOMEM;
-		hd_len = sizeof(*hdr);
-		skb_copy_from_linear_data(skb, (char *)hdr, hd_len);
-		elements++;
-	}
-
-	elements += qeth_count_elements(skb, hd_len);
-	if (elements > queue->max_elements) {
-		rc = -E2BIG;
-		goto out;
-	}
-
-	rc = qeth_do_send_packet(card, queue, skb, hdr, hd_len, hd_len,
-				 elements);
-out:
-	if (rc && hd_len)
-		kmem_cache_free(qeth_core_header_cache, hdr);
-	return rc;
-}
-
 static netdev_tx_t qeth_l2_hard_start_xmit(struct sk_buff *skb,
 					   struct net_device *dev)
 {
@@ -548,12 +509,8 @@ static netdev_tx_t qeth_l2_hard_start_xmit(struct sk_buff *skb,
 		txq = qeth_iqd_translate_txq(dev, txq);
 	queue = card->qdio.out_qs[txq];
 
-	if (IS_OSN(card))
-		rc = qeth_l2_xmit_osn(card, skb, queue);
-	else
-		rc = qeth_xmit(card, skb, queue, vlan_get_protocol(skb),
-			       qeth_l2_fill_header);
-
+	rc = qeth_xmit(card, skb, queue, vlan_get_protocol(skb),
+		       qeth_l2_fill_header);
 	if (!rc)
 		return NETDEV_TX_OK;
 
@@ -890,23 +847,8 @@ static const struct net_device_ops qeth_l2_netdev_ops = {
 	.ndo_bridge_setlink	= qeth_l2_bridge_setlink,
 };
 
-static const struct net_device_ops qeth_osn_netdev_ops = {
-	.ndo_open		= qeth_open,
-	.ndo_stop		= qeth_stop,
-	.ndo_get_stats64	= qeth_get_stats64,
-	.ndo_start_xmit		= qeth_l2_hard_start_xmit,
-	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_tx_timeout		= qeth_tx_timeout,
-};
-
 static int qeth_l2_setup_netdev(struct qeth_card *card)
 {
-	if (IS_OSN(card)) {
-		card->dev->netdev_ops = &qeth_osn_netdev_ops;
-		card->dev->flags |= IFF_NOARP;
-		goto add_napi;
-	}
-
 	card->dev->needed_headroom = sizeof(struct qeth_hdr);
 	card->dev->netdev_ops = &qeth_l2_netdev_ops;
 	card->dev->priv_flags |= IFF_UNICAST_FLT;
@@ -952,7 +894,6 @@ static int qeth_l2_setup_netdev(struct qeth_card *card)
 				       PAGE_SIZE * (QDIO_MAX_ELEMENTS_PER_BUFFER - 1));
 	}
 
-add_napi:
 	netif_napi_add(card->dev, &card->napi, qeth_poll, QETH_NAPI_WEIGHT);
 	return register_netdev(card->dev);
 }
@@ -1044,84 +985,6 @@ static void qeth_l2_enable_brport_features(struct qeth_card *card)
 	}
 }
 
-#ifdef CONFIG_QETH_OSN
-static void qeth_osn_assist_cb(struct qeth_card *card,
-			       struct qeth_cmd_buffer *iob,
-			       unsigned int data_length)
-{
-	qeth_notify_cmd(iob, 0);
-	qeth_put_cmd(iob);
-}
-
-int qeth_osn_assist(struct net_device *dev, void *data, int data_len)
-{
-	struct qeth_cmd_buffer *iob;
-	struct qeth_card *card;
-
-	if (data_len < 0)
-		return -EINVAL;
-	if (!dev)
-		return -ENODEV;
-	card = dev->ml_priv;
-	if (!card)
-		return -ENODEV;
-	QETH_CARD_TEXT(card, 2, "osnsdmc");
-	if (!qeth_card_hw_is_reachable(card))
-		return -ENODEV;
-
-	iob = qeth_alloc_cmd(&card->write, IPA_PDU_HEADER_SIZE + data_len, 1,
-			     QETH_IPA_TIMEOUT);
-	if (!iob)
-		return -ENOMEM;
-
-	qeth_prepare_ipa_cmd(card, iob, (u16) data_len, NULL);
-
-	memcpy(__ipa_cmd(iob), data, data_len);
-	iob->callback = qeth_osn_assist_cb;
-	return qeth_send_ipa_cmd(card, iob, NULL, NULL);
-}
-EXPORT_SYMBOL(qeth_osn_assist);
-
-int qeth_osn_register(unsigned char *read_dev_no, struct net_device **dev,
-		  int (*assist_cb)(struct net_device *, void *),
-		  int (*data_cb)(struct sk_buff *))
-{
-	struct qeth_card *card;
-	char bus_id[16];
-	u16 devno;
-
-	memcpy(&devno, read_dev_no, 2);
-	sprintf(bus_id, "0.0.%04x", devno);
-	card = qeth_get_card_by_busid(bus_id);
-	if (!card || !IS_OSN(card))
-		return -ENODEV;
-	*dev = card->dev;
-
-	QETH_CARD_TEXT(card, 2, "osnreg");
-	if ((assist_cb == NULL) || (data_cb == NULL))
-		return -EINVAL;
-	card->osn_info.assist_cb = assist_cb;
-	card->osn_info.data_cb = data_cb;
-	return 0;
-}
-EXPORT_SYMBOL(qeth_osn_register);
-
-void qeth_osn_deregister(struct net_device *dev)
-{
-	struct qeth_card *card;
-
-	if (!dev)
-		return;
-	card = dev->ml_priv;
-	if (!card)
-		return;
-	QETH_CARD_TEXT(card, 2, "osndereg");
-	card->osn_info.assist_cb = NULL;
-	card->osn_info.data_cb = NULL;
-}
-EXPORT_SYMBOL(qeth_osn_deregister);
-#endif
-
 /* SETBRIDGEPORT support, async notifications */
 
 enum qeth_an_event_type {anev_reg_unreg, anev_abort, anev_reset};
@@ -2190,9 +2053,6 @@ static int qeth_l2_probe_device(struct ccwgroup_device *gdev)
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
 	int rc;
 
-	if (IS_OSN(card))
-		dev_notice(&gdev->dev, "OSN support will be dropped in 2021\n");
-
 	qeth_l2_vnicc_set_defaults(card);
 	mutex_init(&card->sbp_lock);
 
-- 
2.25.1

