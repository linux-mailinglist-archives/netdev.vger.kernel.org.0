Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627791F9025
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 09:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbgFOHll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 03:41:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55412 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbgFOHlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 03:41:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05F7WWfL195603;
        Mon, 15 Jun 2020 07:40:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=OUuLmfHs5EcUkOW1lLCnwTsrnj+rmiPE0IqQPPuOpdY=;
 b=SsQL9CcutyQF3efgH6p9+TApJUcPKO5z6KAkGssJHBNj0aB+IiHku1ATaNBvdLMh378A
 kEJjLgVFn/MWdqjUzsKacpj8vr4PrzPf1Nz+X0Jfbt1+IazuAGKxWtXwJJEMJFeHK4wD
 07Qg7g47k/PDiirjx0B8xFOL0Br8WOkOgPsQLmnL+C8uxPAdbjrT3TB6K8ADr8nd/2px
 G3LoTsMBKwXgubQQlfhlR0+cvdg7DVZdjJXLb/D/rexfReEQUxnDgXuXN4iFUV36//t7
 23UsZbWrTG1a3YC7iyaisGsvX84tiP/MYjnKLGD+NfNypbzIN8w0BGrpLgZqCplvl6Wd xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31mp7r58g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 15 Jun 2020 07:40:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05F7cc0q020424;
        Mon, 15 Jun 2020 07:40:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31n8cmg6tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 07:40:30 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05F7eTrH007079;
        Mon, 15 Jun 2020 07:40:29 GMT
Received: from ca-dev40.us.oracle.com (/10.129.135.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jun 2020 00:40:28 -0700
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
To:     netdev@vger.kernel.org
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net
Subject: [PATCH net] net/rds: NULL pointer de-reference in rds_ib_add_one()
Date:   Mon, 15 Jun 2020 00:40:25 -0700
Message-Id: <1592206825-3303-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9652 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=1 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006150062
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9652 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 clxscore=1011
 cotscore=-2147483648 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 suspectscore=1 mlxlogscore=999 bulkscore=0 mlxscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006150061
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The parent field of a struct device may be NULL.  The macro
ibdev_to_node() should check for that.

Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
---
 net/rds/ib.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/rds/ib.h b/net/rds/ib.h
index 5ae069d..8dfff43 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -264,7 +264,13 @@ struct rds_ib_device {
 	int			*vector_load;
 };
 
-#define ibdev_to_node(ibdev) dev_to_node((ibdev)->dev.parent)
+static inline int ibdev_to_node(struct ib_device *ibdev)
+{
+	struct device *parent;
+
+	parent = ibdev->dev.parent;
+	return parent ? dev_to_node(parent) : NUMA_NO_NODE;
+}
 #define rdsibdev_to_node(rdsibdev) ibdev_to_node(rdsibdev->dev)
 
 /* bits for i_ack_flags */
-- 
1.8.3.1

