Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CC12D3B5C
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 07:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgLIGTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 01:19:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27960 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727248AbgLIGS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 01:18:59 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B96CEEI003098;
        Wed, 9 Dec 2020 01:18:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Hz9gTquuKb3ajrCO3XkOvA6lNzISLdwW/yC9WKSbZls=;
 b=ZHUF7O0tq7+jCkHR33NLPy5G8K9t5cxWeo8HIm0rUwMAPJBEuEw6Gs1wg2o6+f72tpyk
 sqdNaJqQybxgAPpEhbWK/m1ehgOSLxcl6dSHn78Q8/vXMy3IR4yyHS5tTuVa1GdBNPvU
 LN//8PYju/wGpBhnX8V7GiH+j+0iZWwlc2voa9foNp2lDNVzRLFYqskabk9cOg5KwLvO
 5RxhixkI3ges32K/MNSe1Ahm9iOaN7SjVPVqlwuyvWIqSovCVg9mcXyusVQp22eqV6xt
 Ck5s43JjmXEBloG+8xFFp+FH3Ai53yF1LRPMLy4s1uZezD2Hb9i1QtbScHGJbSyjrOKL Pw== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 359wwkthfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 01:18:17 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B96C7RF008861;
        Wed, 9 Dec 2020 06:18:16 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 3581u9vnjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 06:18:16 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B96IEsB12321492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 06:18:14 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C91BB6A051;
        Wed,  9 Dec 2020 06:18:14 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 432F26A047;
        Wed,  9 Dec 2020 06:18:14 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.139.133])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 06:18:14 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH net-next 3/3] use __netdev_notify_peers in hyperv
Date:   Wed,  9 Dec 2020 00:18:11 -0600
Message-Id: <20201209061811.48524-4-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201209061811.48524-1-ljp@linux.ibm.com>
References: <20201209061811.48524-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_03:2020-12-08,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=1 phishscore=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090037
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Start to use the lockless version of netdev_notify_peers.

Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/hyperv/netvsc_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index d17bbc75f5e7..4e3dac7bb944 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2130,10 +2130,10 @@ static void netvsc_link_change(struct work_struct *w)
 		break;
 	}
 
-	rtnl_unlock();
-
 	if (notify)
-		netdev_notify_peers(net);
+		__netdev_notify_peers(net);
+
+	rtnl_unlock();
 
 	/* link_watch only sends one notification with current state per
 	 * second, handle next reconfig event in 2 seconds.
-- 
2.23.0

