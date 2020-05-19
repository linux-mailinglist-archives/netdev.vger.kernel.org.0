Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291B51DA08C
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgESTJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:09:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48070 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726059AbgESTJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:09:14 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04JJ2uF1156797;
        Tue, 19 May 2020 15:09:12 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312age0f11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 May 2020 15:09:12 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04JJ6H8W017521;
        Tue, 19 May 2020 19:09:10 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 313xas272n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 May 2020 19:09:10 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04JJ975212976408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 19:09:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E91552050;
        Tue, 19 May 2020 19:09:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id EEFE852051;
        Tue, 19 May 2020 19:09:06 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Subject: [PATCH net-next 2/2] s390/net: remove pm support from iucv drivers
Date:   Tue, 19 May 2020 21:09:04 +0200
Message-Id: <20200519190904.64217-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200519190904.64217-1-jwi@linux.ibm.com>
References: <20200519190904.64217-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-19_08:2020-05-19,2020-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=2 cotscore=-2147483648
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 394216275c7d ("s390: remove broken hibernate / power management support")
removed support for ARCH_HIBERNATION_POSSIBLE on s390.
So drop the unused pm ops from the iucv drivers.

CC: Hendrik Brueckner <brueckner@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/netiucv.c  | 104 +-----------------------------------
 drivers/s390/net/smsgiucv.c |  65 ----------------------
 2 files changed, 1 insertion(+), 168 deletions(-)

diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 5ce2424ca729..260860cf3aa1 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -112,27 +112,10 @@ DECLARE_PER_CPU(char[256], iucv_dbf_txt_buf);
  */
 #define PRINTK_HEADER " iucv: "       /* for debugging */
 
-/* dummy device to make sure netiucv_pm functions are called */
-static struct device *netiucv_dev;
-
-static int netiucv_pm_prepare(struct device *);
-static void netiucv_pm_complete(struct device *);
-static int netiucv_pm_freeze(struct device *);
-static int netiucv_pm_restore_thaw(struct device *);
-
-static const struct dev_pm_ops netiucv_pm_ops = {
-	.prepare = netiucv_pm_prepare,
-	.complete = netiucv_pm_complete,
-	.freeze = netiucv_pm_freeze,
-	.thaw = netiucv_pm_restore_thaw,
-	.restore = netiucv_pm_restore_thaw,
-};
-
 static struct device_driver netiucv_driver = {
 	.owner = THIS_MODULE,
 	.name = "netiucv",
 	.bus  = &iucv_bus,
-	.pm = &netiucv_pm_ops,
 };
 
 static int netiucv_callback_connreq(struct iucv_path *, u8 *, u8 *);
@@ -213,7 +196,6 @@ struct netiucv_priv {
 	fsm_instance            *fsm;
         struct iucv_connection  *conn;
 	struct device           *dev;
-	int			 pm_state;
 };
 
 /**
@@ -1275,72 +1257,6 @@ static int netiucv_close(struct net_device *dev)
 	return 0;
 }
 
-static int netiucv_pm_prepare(struct device *dev)
-{
-	IUCV_DBF_TEXT(trace, 3, __func__);
-	return 0;
-}
-
-static void netiucv_pm_complete(struct device *dev)
-{
-	IUCV_DBF_TEXT(trace, 3, __func__);
-	return;
-}
-
-/**
- * netiucv_pm_freeze() - Freeze PM callback
- * @dev:	netiucv device
- *
- * close open netiucv interfaces
- */
-static int netiucv_pm_freeze(struct device *dev)
-{
-	struct netiucv_priv *priv = dev_get_drvdata(dev);
-	struct net_device *ndev = NULL;
-	int rc = 0;
-
-	IUCV_DBF_TEXT(trace, 3, __func__);
-	if (priv && priv->conn)
-		ndev = priv->conn->netdev;
-	if (!ndev)
-		goto out;
-	netif_device_detach(ndev);
-	priv->pm_state = fsm_getstate(priv->fsm);
-	rc = netiucv_close(ndev);
-out:
-	return rc;
-}
-
-/**
- * netiucv_pm_restore_thaw() - Thaw and restore PM callback
- * @dev:	netiucv device
- *
- * re-open netiucv interfaces closed during freeze
- */
-static int netiucv_pm_restore_thaw(struct device *dev)
-{
-	struct netiucv_priv *priv = dev_get_drvdata(dev);
-	struct net_device *ndev = NULL;
-	int rc = 0;
-
-	IUCV_DBF_TEXT(trace, 3, __func__);
-	if (priv && priv->conn)
-		ndev = priv->conn->netdev;
-	if (!ndev)
-		goto out;
-	switch (priv->pm_state) {
-	case DEV_STATE_RUNNING:
-	case DEV_STATE_STARTWAIT:
-		rc = netiucv_open(ndev);
-		break;
-	default:
-		break;
-	}
-	netif_device_attach(ndev);
-out:
-	return rc;
-}
-
 /**
  * Start transmission of a packet.
  * Called from generic network device layer.
@@ -2156,7 +2072,6 @@ static void __exit netiucv_exit(void)
 		netiucv_unregister_device(dev);
 	}
 
-	device_unregister(netiucv_dev);
 	driver_unregister(&netiucv_driver);
 	iucv_unregister(&netiucv_handler, 1);
 	iucv_unregister_dbf_views();
@@ -2182,27 +2097,10 @@ static int __init netiucv_init(void)
 		IUCV_DBF_TEXT_(setup, 2, "ret %d from driver_register\n", rc);
 		goto out_iucv;
 	}
-	/* establish dummy device */
-	netiucv_dev = kzalloc(sizeof(struct device), GFP_KERNEL);
-	if (!netiucv_dev) {
-		rc = -ENOMEM;
-		goto out_driver;
-	}
-	dev_set_name(netiucv_dev, "netiucv");
-	netiucv_dev->bus = &iucv_bus;
-	netiucv_dev->parent = iucv_root;
-	netiucv_dev->release = (void (*)(struct device *))kfree;
-	netiucv_dev->driver = &netiucv_driver;
-	rc = device_register(netiucv_dev);
-	if (rc) {
-		put_device(netiucv_dev);
-		goto out_driver;
-	}
+
 	netiucv_banner();
 	return rc;
 
-out_driver:
-	driver_unregister(&netiucv_driver);
 out_iucv:
 	iucv_unregister(&netiucv_handler, 1);
 out_dbf:
diff --git a/drivers/s390/net/smsgiucv.c b/drivers/s390/net/smsgiucv.c
index 066b5c3aaae6..c84ec2fbf99b 100644
--- a/drivers/s390/net/smsgiucv.c
+++ b/drivers/s390/net/smsgiucv.c
@@ -29,12 +29,9 @@ MODULE_AUTHOR
 MODULE_DESCRIPTION ("Linux for S/390 IUCV special message driver");
 
 static struct iucv_path *smsg_path;
-/* dummy device used as trigger for PM functions */
-static struct device *smsg_dev;
 
 static DEFINE_SPINLOCK(smsg_list_lock);
 static LIST_HEAD(smsg_list);
-static int iucv_path_connected;
 
 static int smsg_path_pending(struct iucv_path *, u8 *, u8 *);
 static void smsg_message_pending(struct iucv_path *, struct iucv_message *);
@@ -124,60 +121,15 @@ void smsg_unregister_callback(const char *prefix,
 	kfree(cb);
 }
 
-static int smsg_pm_freeze(struct device *dev)
-{
-#ifdef CONFIG_PM_DEBUG
-	printk(KERN_WARNING "smsg_pm_freeze\n");
-#endif
-	if (smsg_path && iucv_path_connected) {
-		iucv_path_sever(smsg_path, NULL);
-		iucv_path_connected = 0;
-	}
-	return 0;
-}
-
-static int smsg_pm_restore_thaw(struct device *dev)
-{
-	int rc;
-
-#ifdef CONFIG_PM_DEBUG
-	printk(KERN_WARNING "smsg_pm_restore_thaw\n");
-#endif
-	if (smsg_path && !iucv_path_connected) {
-		memset(smsg_path, 0, sizeof(*smsg_path));
-		smsg_path->msglim = 255;
-		smsg_path->flags = 0;
-		rc = iucv_path_connect(smsg_path, &smsg_handler, "*MSG    ",
-				       NULL, NULL, NULL);
-#ifdef CONFIG_PM_DEBUG
-		if (rc)
-			printk(KERN_ERR
-			       "iucv_path_connect returned with rc %i\n", rc);
-#endif
-		if (!rc)
-			iucv_path_connected = 1;
-		cpcmd("SET SMSG IUCV", NULL, 0, NULL);
-	}
-	return 0;
-}
-
-static const struct dev_pm_ops smsg_pm_ops = {
-	.freeze = smsg_pm_freeze,
-	.thaw = smsg_pm_restore_thaw,
-	.restore = smsg_pm_restore_thaw,
-};
-
 static struct device_driver smsg_driver = {
 	.owner = THIS_MODULE,
 	.name = SMSGIUCV_DRV_NAME,
 	.bus  = &iucv_bus,
-	.pm = &smsg_pm_ops,
 };
 
 static void __exit smsg_exit(void)
 {
 	cpcmd("SET SMSG OFF", NULL, 0, NULL);
-	device_unregister(smsg_dev);
 	iucv_unregister(&smsg_handler, 1);
 	driver_unregister(&smsg_driver);
 }
@@ -205,27 +157,10 @@ static int __init smsg_init(void)
 			       NULL, NULL, NULL);
 	if (rc)
 		goto out_free_path;
-	else
-		iucv_path_connected = 1;
-	smsg_dev = kzalloc(sizeof(struct device), GFP_KERNEL);
-	if (!smsg_dev) {
-		rc = -ENOMEM;
-		goto out_free_path;
-	}
-	dev_set_name(smsg_dev, "smsg_iucv");
-	smsg_dev->bus = &iucv_bus;
-	smsg_dev->parent = iucv_root;
-	smsg_dev->release = (void (*)(struct device *))kfree;
-	smsg_dev->driver = &smsg_driver;
-	rc = device_register(smsg_dev);
-	if (rc)
-		goto out_put;
 
 	cpcmd("SET SMSG IUCV", NULL, 0, NULL);
 	return 0;
 
-out_put:
-	put_device(smsg_dev);
 out_free_path:
 	iucv_path_free(smsg_path);
 	smsg_path = NULL;
-- 
2.17.1

