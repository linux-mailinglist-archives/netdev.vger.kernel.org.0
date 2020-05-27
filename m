Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473D91E3BC7
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 10:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387939AbgE0IRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 04:17:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34484 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387835AbgE0IRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 04:17:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R828PC095552;
        Wed, 27 May 2020 08:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=gugubNejoCMtl+eqY6O431jnnbLH20ChLaQRQ8pFt8M=;
 b=IUVqhVJvWlUd73sw6DN8iKxZkAnC2Os7d+PxH6KrTGEWqJe7EhJDNalxXlUh8bxGHcLn
 fHLKmPMOd2AoaOT2K3iLr6llqjki4XdpY64M3RLWK8xeY6YJav4D/7qInUePSBOcfExZ
 GKuvReRYCkpdkPjzQ3TNbwQQLXEA1vSKnRnYV9GNkMtfehJRAlTe7D99XUF1rp0Bg57Z
 dlpC4ndJFUz/ZX9mLpSZLcNypYcXRXZkLWDSUeSunl8CQbkmqkZ1JWCg/WwJfYVFzE8Q
 H2J7Nof4vYWvRqDoe7Ti9sIz9NimAqmcj512y5cARiPwws/lW948r3STBTi9tCDR7LtY Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 318xe1e1n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 08:17:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R832EI114316;
        Wed, 27 May 2020 08:17:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 317ddqcay1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 08:17:43 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04R8Hhkq011717;
        Wed, 27 May 2020 08:17:43 GMT
Received: from oracle.com (/73.15.177.101)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 May 2020 01:17:43 -0700
From:   rao.shoaib@oracle.com
To:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rao.shoaib@oracle.com
Cc:     Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
Subject: [PATCH net-next] rds: transport module should be auto loaded when transport is set
Date:   Wed, 27 May 2020 01:17:42 -0700
Message-Id: <20200527081742.25718-1-rao.shoaib@oracle.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270062
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 cotscore=-2147483648 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1011 impostorscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270062
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>

This enhancement auto loads transport module when the transport
is set via SO_RDS_TRANSPORT socket option.

Orabug: 31032127

Reviewed-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
Signed-off-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
---
 include/uapi/linux/rds.h |  2 +-
 net/rds/transport.c      | 26 +++++++++++++++++---------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
index cba368e55863..7273c681e6c1 100644
--- a/include/uapi/linux/rds.h
+++ b/include/uapi/linux/rds.h
@@ -64,7 +64,7 @@
 
 /* supported values for SO_RDS_TRANSPORT */
 #define	RDS_TRANS_IB	0
-#define	RDS_TRANS_IWARP	1
+#define	RDS_TRANS_GAP	1
 #define	RDS_TRANS_TCP	2
 #define RDS_TRANS_COUNT	3
 #define	RDS_TRANS_NONE	(~0)
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

