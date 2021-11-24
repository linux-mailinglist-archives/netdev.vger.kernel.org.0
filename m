Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFEE45BDA9
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 13:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245466AbhKXMj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 07:39:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344152AbhKXMg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 07:36:28 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AOCA8c6026796;
        Wed, 24 Nov 2021 12:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=33NCHA5Mgn6glA9NJeCUkWGJKWSpQ/nZehlka94Sd7o=;
 b=UDCPTaA//iAD+zY2QBHqujYvcurlXQvrFzm3SfSb5WFddYkLfR4dotciXZc4c4KrgCGU
 YsS4hKNvebjLLiW1Gh8pvgLlnUSC/HXWAsMBIFsEk7o6sROqhelfVWc3GWizOFemVATP
 1dBV6OSGYTrMjlHL6Wb6mT3XQeltSsPR63uSR+P8lfItuYBXzQxv+wKXaqNWA4Fteqzo
 b0LpQpRg104o9Boogj619E7td5ZndtqGzqwEaB2jUcSSveYMQkrQlj5QXZzpc+4Ee6C5
 Euw92FZwUGM38E6nJ7LywgT4e1GyKAMVjnsttskRrh8oARBpEMOr0ZzaBw2ib8XYoUI+ TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3chgvfxh6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Nov 2021 12:33:13 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AOBlUvv027484;
        Wed, 24 Nov 2021 12:33:12 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3chgvfxh64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Nov 2021 12:33:12 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AOC7Eou013396;
        Wed, 24 Nov 2021 12:33:10 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3cernb1gyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Nov 2021 12:33:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AOCX6BG30671138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 12:33:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96F1F11C058;
        Wed, 24 Nov 2021 12:33:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55CA111C054;
        Wed, 24 Nov 2021 12:33:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 24 Nov 2021 12:33:06 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Guo DaXing <guodaxing@huawei.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: [PATCH net 1/2] net/smc: Fix NULL pointer dereferencing in smc_vlan_by_tcpsk()
Date:   Wed, 24 Nov 2021 13:32:37 +0100
Message-Id: <20211124123238.471429-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124123238.471429-1-kgraul@linux.ibm.com>
References: <20211124123238.471429-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TM95qxcK3WIMJa6-4iHa05VXaAVQqo1E
X-Proofpoint-ORIG-GUID: sg1P7EWqjvM1NyimymYzxA9Og6vDppB0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-24_04,2021-11-24_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 spamscore=0 impostorscore=0 adultscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111240070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coverity reports a possible NULL dereferencing problem:

in smc_vlan_by_tcpsk():
6. returned_null: netdev_lower_get_next returns NULL (checked 29 out of 30 times).
7. var_assigned: Assigning: ndev = NULL return value from netdev_lower_get_next.
1623                ndev = (struct net_device *)netdev_lower_get_next(ndev, &lower);
CID 1468509 (#1 of 1): Dereference null return value (NULL_RETURNS)
8. dereference: Dereferencing a pointer that might be NULL ndev when calling is_vlan_dev.
1624                if (is_vlan_dev(ndev)) {

Remove the manual implementation and use netdev_walk_all_lower_dev() to
iterate over the lower devices. While on it remove an obsolete function
parameter comment.

Fixes: cb9d43f67754 ("net/smc: determine vlan_id of stacked net_device")
Suggested-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 25ebd30feecd..bb52c8b5f148 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1672,14 +1672,26 @@ static void smc_link_down_work(struct work_struct *work)
 	mutex_unlock(&lgr->llc_conf_mutex);
 }
 
-/* Determine vlan of internal TCP socket.
- * @vlan_id: address to store the determined vlan id into
- */
+static int smc_vlan_by_tcpsk_walk(struct net_device *lower_dev,
+				  struct netdev_nested_priv *priv)
+{
+	unsigned short *vlan_id = (unsigned short *)priv->data;
+
+	if (is_vlan_dev(lower_dev)) {
+		*vlan_id = vlan_dev_vlan_id(lower_dev);
+		return 1;
+	}
+
+	return 0;
+}
+
+/* Determine vlan of internal TCP socket. */
 int smc_vlan_by_tcpsk(struct socket *clcsock, struct smc_init_info *ini)
 {
 	struct dst_entry *dst = sk_dst_get(clcsock->sk);
+	struct netdev_nested_priv priv;
 	struct net_device *ndev;
-	int i, nest_lvl, rc = 0;
+	int rc = 0;
 
 	ini->vlan_id = 0;
 	if (!dst) {
@@ -1697,20 +1709,9 @@ int smc_vlan_by_tcpsk(struct socket *clcsock, struct smc_init_info *ini)
 		goto out_rel;
 	}
 
+	priv.data = (void *)&ini->vlan_id;
 	rtnl_lock();
-	nest_lvl = ndev->lower_level;
-	for (i = 0; i < nest_lvl; i++) {
-		struct list_head *lower = &ndev->adj_list.lower;
-
-		if (list_empty(lower))
-			break;
-		lower = lower->next;
-		ndev = (struct net_device *)netdev_lower_get_next(ndev, &lower);
-		if (is_vlan_dev(ndev)) {
-			ini->vlan_id = vlan_dev_vlan_id(ndev);
-			break;
-		}
-	}
+	netdev_walk_all_lower_dev(ndev, smc_vlan_by_tcpsk_walk, &priv);
 	rtnl_unlock();
 
 out_rel:
-- 
2.32.0

