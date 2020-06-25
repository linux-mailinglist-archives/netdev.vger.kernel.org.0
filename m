Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7645F20A6FD
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405056AbgFYUqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:46:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47120 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404043AbgFYUqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 16:46:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PKfx8j042744;
        Thu, 25 Jun 2020 20:46:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=+XkLfccnSzqprq+IQB5YlUb4Ac+r8oDSMdVtrNIQ3hQ=;
 b=FlHmXiWed3t68th3dcw1mlKWGRDsV/4DrE41dib+PupVgvVk0aMY5ghMEw4ymPXqzx2/
 BflLBg0te87yxs2eBwvsknt3C0NLvZSHXib6FleAYdc+rSIm8x7sFDQyN78qjheuTE/j
 6yBr5hvYE1HWIqW057nOUJjPEMgy5BNoDqcvEBPpqFlGf9ajpAM9ylaHw3iwLGEPTZYQ
 wrnjiw8H1wacOIyGtlBHvsJMfBpCeC3CIFjVSdGC3dwDQjzOLMge9fB11SUFiJL9wQNn
 8JuP/9junoKMilzUrNWtdKdzkdGazCTIrlpM8DylUJJDPOpqeV6kd10RZ3hHR3WzQl85 aQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31uusu2s8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 20:46:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PKiGAY063303;
        Thu, 25 Jun 2020 20:46:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31uur9k1wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 20:46:08 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PKk7wS014167;
        Thu, 25 Jun 2020 20:46:07 GMT
Received: from oracle.com (/10.159.159.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 20:46:06 +0000
From:   rao.shoaib@oracle.com
To:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     Rao Shoaib <rao.shoaib@oracle.com>, davem@davemloft.net,
        leon@kernel.org, ka-cheong.poon@oracle.com,
        haakon.bugge@oracle.com, somasundaram.krishnasamy@oracle.com
Subject: [PATCH v2] rds: transport module should be auto loaded when transport is set
Date:   Thu, 25 Jun 2020 13:46:00 -0700
Message-Id: <20200625204600.24174-1-rao.shoaib@oracle.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250121
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>

This enhancement auto loads transport module when the transport
is set via SO_RDS_TRANSPORT socket option.

Reviewed-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
Signed-off-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
---
 include/uapi/linux/rds.h |  4 +++-
 net/rds/transport.c      | 26 +++++++++++++++++---------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
index cba368e55863..c21edb966c19 100644
--- a/include/uapi/linux/rds.h
+++ b/include/uapi/linux/rds.h
@@ -64,10 +64,12 @@
 
 /* supported values for SO_RDS_TRANSPORT */
 #define	RDS_TRANS_IB	0
-#define	RDS_TRANS_IWARP	1
+#define	RDS_TRANS_GAP	1
 #define	RDS_TRANS_TCP	2
 #define RDS_TRANS_COUNT	3
 #define	RDS_TRANS_NONE	(~0)
+/* don't use RDS_TRANS_IWARP - it is deprecated */
+#define RDS_TRANS_IWARP RDS_TRANS_GAP
 
 /* IOCTLS commands for SOL_RDS */
 #define SIOCRDSSETTOS		(SIOCPROTOPRIVATE)
diff --git a/net/rds/transport.c b/net/rds/transport.c
index 46f709a4b577..f8001ec80867 100644
--- a/net/rds/transport.c
+++ b/net/rds/transport.c
@@ -38,6 +38,12 @@
 #include "rds.h"
 #include "loop.h"
 
+static char * const rds_trans_modules[] = {
+	[RDS_TRANS_IB] = "rds_rdma",
+	[RDS_TRANS_GAP] = NULL,
+	[RDS_TRANS_TCP] = "rds_tcp",
+};
+
 static struct rds_transport *transports[RDS_TRANS_COUNT];
 static DECLARE_RWSEM(rds_trans_sem);
 
@@ -110,18 +116,20 @@ struct rds_transport *rds_trans_get(int t_type)
 {
 	struct rds_transport *ret = NULL;
 	struct rds_transport *trans;
-	unsigned int i;
 
 	down_read(&rds_trans_sem);
-	for (i = 0; i < RDS_TRANS_COUNT; i++) {
-		trans = transports[i];
-
-		if (trans && trans->t_type == t_type &&
-		    (!trans->t_owner || try_module_get(trans->t_owner))) {
-			ret = trans;
-			break;
-		}
+	trans = transports[t_type];
+	if (!trans) {
+		up_read(&rds_trans_sem);
+		if (rds_trans_modules[t_type])
+			request_module(rds_trans_modules[t_type]);
+		down_read(&rds_trans_sem);
+		trans = transports[t_type];
 	}
+	if (trans && trans->t_type == t_type &&
+	    (!trans->t_owner || try_module_get(trans->t_owner)))
+		ret = trans;
+
 	up_read(&rds_trans_sem);
 
 	return ret;
-- 
2.16.6

