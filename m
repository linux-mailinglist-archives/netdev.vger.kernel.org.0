Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D0A340D93
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbhCRSzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:55:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45782 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230080AbhCRSzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:55:09 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IIXAWj080770;
        Thu, 18 Mar 2021 14:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lwGgCFhMTNZTMW0zERkEK/3OfiezLRMldWmIVLNfUes=;
 b=lDjhZ4wgqjrTYcY0PrhxrSjqdyLGQ3kIUIRS4Lz7N0bX9pMhdFPNY6NdVaPQb4s1DpMf
 5DvCPwiKyZ8ILMbZ5mSGrc30h+oN51WGCZSLWvxKdSzEhuPyds7118De7O8kZ4fs96Vx
 zZH7Wy40YO235999G64I3zhA+MZwomejUxkr4DiOX4sDBnmiZe+Qjd8UL2Czz6qkuADF
 PJDAqRts+BgvQRwz/nLZxr1lGhb6/lHK0+XtAI1E2gc5NsqOiFqX1BVbXcAgSSZEtolM
 GJt1//Jeii/XR6lpvWsW4kB9rS7dH0Opie0jQznxlqMYrvuGVm7/BW3ZQ6vZbJ80HksC Bg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37byr3qym9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 14:55:06 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12IIqFe0017141;
        Thu, 18 Mar 2021 18:55:04 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 378n18n1d7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 18:55:04 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12IIsiwY37421314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 18:54:44 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62411A405F;
        Thu, 18 Mar 2021 18:55:01 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27D95A4040;
        Thu, 18 Mar 2021 18:55:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 18:55:01 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 3/3] s390/qeth: remove RX VLAN filter stubs in L3 driver
Date:   Thu, 18 Mar 2021 19:54:56 +0100
Message-Id: <20210318185456.2153426-4-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318185456.2153426-1-jwi@linux.ibm.com>
References: <20210318185456.2153426-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_12:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180131
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The callbacks have been slimmed down to a level where they no longer do
any actual work. So stop pretending that we support the
NETIF_F_HW_VLAN_CTAG_FILTER feature.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l3_main.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index dd441eaec66e..35b42275a06c 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1123,24 +1123,6 @@ static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
 	return 0;
 }
 
-static int qeth_l3_vlan_rx_add_vid(struct net_device *dev,
-				   __be16 proto, u16 vid)
-{
-	struct qeth_card *card = dev->ml_priv;
-
-	QETH_CARD_TEXT_(card, 4, "aid:%d", vid);
-	return 0;
-}
-
-static int qeth_l3_vlan_rx_kill_vid(struct net_device *dev,
-				    __be16 proto, u16 vid)
-{
-	struct qeth_card *card = dev->ml_priv;
-
-	QETH_CARD_TEXT_(card, 4, "kid:%d", vid);
-	return 0;
-}
-
 static void qeth_l3_set_promisc_mode(struct qeth_card *card)
 {
 	bool enable = card->dev->flags & IFF_PROMISC;
@@ -1861,8 +1843,6 @@ static const struct net_device_ops qeth_l3_netdev_ops = {
 	.ndo_do_ioctl		= qeth_do_ioctl,
 	.ndo_fix_features	= qeth_fix_features,
 	.ndo_set_features	= qeth_set_features,
-	.ndo_vlan_rx_add_vid	= qeth_l3_vlan_rx_add_vid,
-	.ndo_vlan_rx_kill_vid   = qeth_l3_vlan_rx_kill_vid,
 	.ndo_tx_timeout		= qeth_tx_timeout,
 };
 
@@ -1878,8 +1858,6 @@ static const struct net_device_ops qeth_l3_osa_netdev_ops = {
 	.ndo_do_ioctl		= qeth_do_ioctl,
 	.ndo_fix_features	= qeth_fix_features,
 	.ndo_set_features	= qeth_set_features,
-	.ndo_vlan_rx_add_vid	= qeth_l3_vlan_rx_add_vid,
-	.ndo_vlan_rx_kill_vid   = qeth_l3_vlan_rx_kill_vid,
 	.ndo_tx_timeout		= qeth_tx_timeout,
 	.ndo_neigh_setup	= qeth_l3_neigh_setup,
 };
@@ -1933,8 +1911,7 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 
 	card->dev->needed_headroom = headroom;
 	card->dev->features |=	NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX |
-				NETIF_F_HW_VLAN_CTAG_FILTER;
+				NETIF_F_HW_VLAN_CTAG_RX;
 
 	netif_keep_dst(card->dev);
 	if (card->dev->hw_features & (NETIF_F_TSO | NETIF_F_TSO6))
-- 
2.25.1

