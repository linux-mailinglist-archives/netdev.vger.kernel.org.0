Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC362A3437
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 20:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgKBTef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 14:34:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62002 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726734AbgKBTed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 14:34:33 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A2JXQOh081724;
        Mon, 2 Nov 2020 14:34:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=+TPR0daW9e7jOfEBRkwgpCs1I8h8v7CyKwoTrDgYITQ=;
 b=mexleEgDrrZPmraXEBLco/N20TrR65ii6nd7B9Ysxy/017D0BwLwgjQ4Ff2Kddd82J9K
 gPzphTWyTk8uz1XpqFHUIEIOnK6S+Rb5visUHpDdPecLcP/nwJfmdU6ga548KPo6YNOT
 On20jRGJb09i77cQVjLx2fm0EHwAsMR82te8jM/c7Bh6O5xi6e6wngFAuyT6y8ACIR6+
 KhevqTwh3VCravLhli9VZD9Xg86vxPKmwdW6D1ziNsfjjkQRamKvnoHtXUinA6+8xcWO
 NVMd04eSlJQJ0Yg62nuX8EQdK1QWF04J892Trhju8XtC9lOCurE94ltKwQZF3oJ/0i/e rQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34jmdtqw9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 14:34:31 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A2JX8h9027864;
        Mon, 2 Nov 2020 19:34:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 34h0fcte9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 19:34:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A2JYRG47602690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Nov 2020 19:34:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E61A34C04A;
        Mon,  2 Nov 2020 19:34:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B46094C044;
        Mon,  2 Nov 2020 19:34:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Nov 2020 19:34:26 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next 05/15] net/smc: Add diagnostic information to smc ib-device
Date:   Mon,  2 Nov 2020 20:33:59 +0100
Message-Id: <20201102193409.70901-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201102193409.70901-1-kgraul@linux.ibm.com>
References: <20201102193409.70901-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_13:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 suspectscore=1 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011020149
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

During smc ib-device creation, add network device name to smc
ib-device structure. Register for netdevice name changes and
update ib-device accordingly. This is needed for diagnostic purposes.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_ib.c   | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_ib.h   |  2 ++
 net/smc/smc_pnet.c |  3 +++
 3 files changed, 52 insertions(+)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 1c314dbdc7fa..c4a04e868bf0 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -557,6 +557,52 @@ static void smc_ib_cleanup_per_ibdev(struct smc_ib_device *smcibdev)
 
 static struct ib_client smc_ib_client;
 
+static void smc_copy_netdev_name(struct smc_ib_device *smcibdev, int port)
+{
+	struct ib_device *ibdev = smcibdev->ibdev;
+	struct net_device *ndev;
+
+	if (ibdev->ops.get_netdev) {
+		ndev = ibdev->ops.get_netdev(ibdev, port + 1);
+		if (ndev) {
+			snprintf((char *)&smcibdev->netdev[port],
+				 sizeof(smcibdev->netdev[port]),
+				 "%s", ndev->name);
+			dev_put(ndev);
+		}
+	}
+}
+
+void smc_ib_ndev_name_change(struct net_device *ndev)
+{
+	struct smc_ib_device *smcibdev;
+	struct ib_device *libdev;
+	struct net_device *lndev;
+	u8 port_cnt;
+	int i;
+
+	mutex_lock(&smc_ib_devices.mutex);
+	list_for_each_entry(smcibdev, &smc_ib_devices.list, list) {
+		port_cnt = smcibdev->ibdev->phys_port_cnt;
+		for (i = 0;
+		     i < min_t(size_t, port_cnt, SMC_MAX_PORTS);
+		     i++) {
+			libdev = smcibdev->ibdev;
+			if (libdev->ops.get_netdev) {
+				lndev = libdev->ops.get_netdev(libdev, i + 1);
+				if (lndev)
+					dev_put(lndev);
+				if (lndev == ndev) {
+					snprintf((char *)&smcibdev->netdev[i],
+						 sizeof(smcibdev->netdev[i]),
+						 "%s", ndev->name);
+				}
+			}
+		}
+	}
+	mutex_unlock(&smc_ib_devices.mutex);
+}
+
 /* callback function for ib_register_client() */
 static int smc_ib_add_dev(struct ib_device *ibdev)
 {
@@ -596,6 +642,7 @@ static int smc_ib_add_dev(struct ib_device *ibdev)
 		if (smc_pnetid_by_dev_port(ibdev->dev.parent, i,
 					   smcibdev->pnetid[i]))
 			smc_pnetid_by_table_ib(smcibdev, i + 1);
+		smc_copy_netdev_name(smcibdev, i);
 		pr_warn_ratelimited("smc:    ib device %s port %d has pnetid "
 				    "%.16s%s\n",
 				    smcibdev->ibdev->name, i + 1,
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index 3e6bfeddd53b..b0868146b46b 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -54,11 +54,13 @@ struct smc_ib_device {				/* ib-device infos for smc */
 	wait_queue_head_t	lnks_deleted;	/* wait 4 removal of all links*/
 	struct mutex		mutex;		/* protect dev setup+cleanup */
 	atomic_t		lnk_cnt_by_port[SMC_MAX_PORTS];/*#lnk per port*/
+	u8			netdev[SMC_MAX_PORTS][IFNAMSIZ];/* ndev names */
 };
 
 struct smc_buf_desc;
 struct smc_link;
 
+void smc_ib_ndev_name_change(struct net_device *ndev);
 int smc_ib_register_client(void) __init;
 void smc_ib_unregister_client(void);
 bool smc_ib_port_active(struct smc_ib_device *smcibdev, u8 ibport);
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index f3c18b991d35..b0f40d73afd6 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -828,6 +828,9 @@ static int smc_pnet_netdev_event(struct notifier_block *this,
 	case NETDEV_UNREGISTER:
 		smc_pnet_remove_by_ndev(event_dev);
 		return NOTIFY_OK;
+	case NETDEV_CHANGENAME:
+		smc_ib_ndev_name_change(event_dev);
+		return NOTIFY_OK;
 	case NETDEV_REGISTER:
 		smc_pnet_add_by_ndev(event_dev);
 		return NOTIFY_OK;
-- 
2.17.1

