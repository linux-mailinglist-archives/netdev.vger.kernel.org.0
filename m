Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522982AA52F
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 14:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgKGNAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 08:00:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52664 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727264AbgKGNAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 08:00:17 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A7CWDie037642;
        Sat, 7 Nov 2020 08:00:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=4S9S7STXzo4ONPx1Hegv+zajRMe+93GR1pw1fSyStj0=;
 b=G8btCAn5TU/jNes977pbgjLGeCRLbJoKyZJgcHSAYcchX4ZxJ28uTAkbqk1oEmzDUKws
 +SrQsEazEOFA9g8zNSXhfYfywYGVdZT14W4f68S9mowxCgGXU/BgCUQ4cfVCnqX2wCTk
 hQ+zrPO9UOUE8/wPRIgGBFNEAaZjTajpIhycDSNZv1P8SbAek9jnZRlrIhXC+y58Q0yf
 eFR1O7R3TBM1QPhfomEQiXGsjJwYpTqsMjsjp27/D6zsz6jl9vLmpGpY4yuLxh4P7jrD
 cDTY+3JJOi4/f4vnqleSbRYYBYF9ME5+/IFH5CY79F4BjQ2ZOL5YwvDJrPP6VylyXgqR /Q== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34npkyq635-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Nov 2020 08:00:13 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A7CvCCW016083;
        Sat, 7 Nov 2020 13:00:12 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 34nk788ag7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Nov 2020 13:00:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A7D09nF52232700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 7 Nov 2020 13:00:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11E13A4069;
        Sat,  7 Nov 2020 13:00:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF2BCA4065;
        Sat,  7 Nov 2020 13:00:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  7 Nov 2020 13:00:08 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v3 05/15] net/smc: Add diagnostic information to smc ib-device
Date:   Sat,  7 Nov 2020 13:59:48 +0100
Message-Id: <20201107125958.16384-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107125958.16384-1-kgraul@linux.ibm.com>
References: <20201107125958.16384-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-07_07:2020-11-05,2020-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_definite policy=outbound score=100 phishscore=0
 clxscore=1015 mlxscore=100 spamscore=100 lowpriorityscore=0 adultscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 mlxlogscore=-1000
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011070081
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
 net/smc/smc_ib.c   | 45 +++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_ib.h   |  2 ++
 net/smc/smc_pnet.c |  3 +++
 3 files changed, 50 insertions(+)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 1c314dbdc7fa..300cca9296be 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -557,6 +557,50 @@ static void smc_ib_cleanup_per_ibdev(struct smc_ib_device *smcibdev)
 
 static struct ib_client smc_ib_client;
 
+static void smc_copy_netdev_name(struct smc_ib_device *smcibdev, int port)
+{
+	struct ib_device *ibdev = smcibdev->ibdev;
+	struct net_device *ndev;
+
+	if (!ibdev->ops.get_netdev)
+		return;
+	ndev = ibdev->ops.get_netdev(ibdev, port + 1);
+	if (ndev) {
+		snprintf(smcibdev->netdev[port],
+			 sizeof(smcibdev->netdev[port]),
+			 "%s", ndev->name);
+		dev_put(ndev);
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
+		for (i = 0; i < min_t(size_t, port_cnt, SMC_MAX_PORTS); i++) {
+			libdev = smcibdev->ibdev;
+			if (!libdev->ops.get_netdev)
+				continue;
+			lndev = libdev->ops.get_netdev(libdev, i + 1);
+			if (lndev)
+				dev_put(lndev);
+			if (lndev != ndev)
+				continue;
+			snprintf(smcibdev->netdev[i],
+				 sizeof(smcibdev->netdev[i]),
+				 "%s", ndev->name);
+		}
+	}
+	mutex_unlock(&smc_ib_devices.mutex);
+}
+
 /* callback function for ib_register_client() */
 static int smc_ib_add_dev(struct ib_device *ibdev)
 {
@@ -596,6 +640,7 @@ static int smc_ib_add_dev(struct ib_device *ibdev)
 		if (smc_pnetid_by_dev_port(ibdev->dev.parent, i,
 					   smcibdev->pnetid[i]))
 			smc_pnetid_by_table_ib(smcibdev, i + 1);
+		smc_copy_netdev_name(smcibdev, i);
 		pr_warn_ratelimited("smc:    ib device %s port %d has pnetid "
 				    "%.16s%s\n",
 				    smcibdev->ibdev->name, i + 1,
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index 3b85360a473b..5319496adea0 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -55,11 +55,13 @@ struct smc_ib_device {				/* ib-device infos for smc */
 	struct mutex		mutex;		/* protect dev setup+cleanup */
 	atomic_t		lnk_cnt_by_port[SMC_MAX_PORTS];
 						/* number of links per port */
+	char			netdev[SMC_MAX_PORTS][IFNAMSIZ];/* ndev names */
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

