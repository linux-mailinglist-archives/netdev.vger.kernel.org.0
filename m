Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DA21DA0B2
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgESTKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:10:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39594 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727098AbgESTKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:10:25 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04JJ3GU2194613;
        Tue, 19 May 2020 15:10:21 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 313r10ebd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 May 2020 15:10:21 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04JJ5Vgg008384;
        Tue, 19 May 2020 19:10:19 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 313x4xgw8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 May 2020 19:10:19 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04JJAGjc57278832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 19:10:16 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21210A4069;
        Tue, 19 May 2020 19:10:16 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4BB1A405B;
        Tue, 19 May 2020 19:10:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 May 2020 19:10:15 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/5] net/af_iucv: remove pm support
Date:   Tue, 19 May 2020 21:10:09 +0200
Message-Id: <20200519191012.65438-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200519191012.65438-1-jwi@linux.ibm.com>
References: <20200519191012.65438-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-19_08:2020-05-19,2020-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 cotscore=-2147483648
 phishscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015 suspectscore=0
 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005190157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 394216275c7d ("s390: remove broken hibernate / power management support")
removed support for ARCH_HIBERNATION_POSSIBLE from s390.

So drop the unused pm ops from the s390-only af_iucv socket code.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 net/iucv/af_iucv.c | 141 +--------------------------------------------
 1 file changed, 1 insertion(+), 140 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index c4bdcbc84b07..84bd18fea1d6 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -87,7 +87,6 @@ do {									\
 
 static void iucv_sock_kill(struct sock *sk);
 static void iucv_sock_close(struct sock *sk);
-static void iucv_sever_path(struct sock *, int);
 
 static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 	struct packet_type *pt, struct net_device *orig_dev);
@@ -127,110 +126,6 @@ static inline void low_nmcpy(unsigned char *dst, char *src)
        memcpy(&dst[8], src, 8);
 }
 
-static int afiucv_pm_prepare(struct device *dev)
-{
-#ifdef CONFIG_PM_DEBUG
-	printk(KERN_WARNING "afiucv_pm_prepare\n");
-#endif
-	return 0;
-}
-
-static void afiucv_pm_complete(struct device *dev)
-{
-#ifdef CONFIG_PM_DEBUG
-	printk(KERN_WARNING "afiucv_pm_complete\n");
-#endif
-}
-
-/**
- * afiucv_pm_freeze() - Freeze PM callback
- * @dev:	AFIUCV dummy device
- *
- * Sever all established IUCV communication pathes
- */
-static int afiucv_pm_freeze(struct device *dev)
-{
-	struct iucv_sock *iucv;
-	struct sock *sk;
-
-#ifdef CONFIG_PM_DEBUG
-	printk(KERN_WARNING "afiucv_pm_freeze\n");
-#endif
-	read_lock(&iucv_sk_list.lock);
-	sk_for_each(sk, &iucv_sk_list.head) {
-		iucv = iucv_sk(sk);
-		switch (sk->sk_state) {
-		case IUCV_DISCONN:
-		case IUCV_CLOSING:
-		case IUCV_CONNECTED:
-			iucv_sever_path(sk, 0);
-			break;
-		case IUCV_OPEN:
-		case IUCV_BOUND:
-		case IUCV_LISTEN:
-		case IUCV_CLOSED:
-		default:
-			break;
-		}
-		skb_queue_purge(&iucv->send_skb_q);
-		skb_queue_purge(&iucv->backlog_skb_q);
-	}
-	read_unlock(&iucv_sk_list.lock);
-	return 0;
-}
-
-/**
- * afiucv_pm_restore_thaw() - Thaw and restore PM callback
- * @dev:	AFIUCV dummy device
- *
- * socket clean up after freeze
- */
-static int afiucv_pm_restore_thaw(struct device *dev)
-{
-	struct sock *sk;
-
-#ifdef CONFIG_PM_DEBUG
-	printk(KERN_WARNING "afiucv_pm_restore_thaw\n");
-#endif
-	read_lock(&iucv_sk_list.lock);
-	sk_for_each(sk, &iucv_sk_list.head) {
-		switch (sk->sk_state) {
-		case IUCV_CONNECTED:
-			sk->sk_err = EPIPE;
-			sk->sk_state = IUCV_DISCONN;
-			sk->sk_state_change(sk);
-			break;
-		case IUCV_DISCONN:
-		case IUCV_CLOSING:
-		case IUCV_LISTEN:
-		case IUCV_BOUND:
-		case IUCV_OPEN:
-		default:
-			break;
-		}
-	}
-	read_unlock(&iucv_sk_list.lock);
-	return 0;
-}
-
-static const struct dev_pm_ops afiucv_pm_ops = {
-	.prepare = afiucv_pm_prepare,
-	.complete = afiucv_pm_complete,
-	.freeze = afiucv_pm_freeze,
-	.thaw = afiucv_pm_restore_thaw,
-	.restore = afiucv_pm_restore_thaw,
-};
-
-static struct device_driver af_iucv_driver = {
-	.owner = THIS_MODULE,
-	.name = "afiucv",
-	.bus  = NULL,
-	.pm   = &afiucv_pm_ops,
-};
-
-/* dummy device used as trigger for PM functions */
-static struct device *af_iucv_dev;
-
 /**
  * iucv_msg_length() - Returns the length of an iucv message.
  * @msg:	Pointer to struct iucv_message, MUST NOT be NULL
@@ -2409,45 +2304,11 @@ static struct packet_type iucv_packet_type = {
 
 static int afiucv_iucv_init(void)
 {
-	int err;
-
-	err = pr_iucv->iucv_register(&af_iucv_handler, 0);
-	if (err)
-		goto out;
-	/* establish dummy device */
-	af_iucv_driver.bus = pr_iucv->bus;
-	err = driver_register(&af_iucv_driver);
-	if (err)
-		goto out_iucv;
-	af_iucv_dev = kzalloc(sizeof(struct device), GFP_KERNEL);
-	if (!af_iucv_dev) {
-		err = -ENOMEM;
-		goto out_driver;
-	}
-	dev_set_name(af_iucv_dev, "af_iucv");
-	af_iucv_dev->bus = pr_iucv->bus;
-	af_iucv_dev->parent = pr_iucv->root;
-	af_iucv_dev->release = (void (*)(struct device *))kfree;
-	af_iucv_dev->driver = &af_iucv_driver;
-	err = device_register(af_iucv_dev);
-	if (err)
-		goto out_iucv_dev;
-	return 0;
-
-out_iucv_dev:
-	put_device(af_iucv_dev);
-out_driver:
-	driver_unregister(&af_iucv_driver);
-out_iucv:
-	pr_iucv->iucv_unregister(&af_iucv_handler, 0);
-out:
-	return err;
+	return pr_iucv->iucv_register(&af_iucv_handler, 0);
 }
 
 static void afiucv_iucv_exit(void)
 {
-	device_unregister(af_iucv_dev);
-	driver_unregister(&af_iucv_driver);
 	pr_iucv->iucv_unregister(&af_iucv_handler, 0);
 }
 
-- 
2.17.1

