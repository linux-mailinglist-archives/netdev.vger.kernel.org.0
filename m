Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9796B1DF
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 00:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388927AbfGPW33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 18:29:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35580 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388741AbfGPW33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 18:29:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMDcgF192359;
        Tue, 16 Jul 2019 22:29:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=fD3leGdXwkgNZkk6X9CTPoezfJX1ZF5DtRYazqP0ofo=;
 b=wvLNDCwDh+WWe+P7F7uJI7yeAM6wEbcp2zSHllNuzK3B6tKpzx/ZCHNcFrpXiH7YLGmo
 jGT4M/bIQRpoTPaftVChPnQDyEdDsRuWI0oVA7dUA308lQiArHUf2wY6k5o/cI9d1Arg
 qXgPpafR8Ahtn7QGQCJJRov1qedVr220dAqG4NdZHDtbMElpB6r8tT9bzS4R5GAf/Aic
 4HwXt2TBsmg69xP/XNnczinIKApNLtoB39lje2yuGnY7XfyLN0oAxzwfXOcQdRnHbrqo
 Q7stQV4QdXZTBIhBGhRAX7bQ3o3bmkmS4gM8yz3qVGMZDvbZP5SOEug6K9N6ZmyI8YzH UQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2tq78pq5hq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:29:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMCn9i139858;
        Tue, 16 Jul 2019 22:29:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2tq4du65j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jul 2019 22:29:26 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6GMTPqg172412;
        Tue, 16 Jul 2019 22:29:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2tq4du65hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:29:25 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6GMTO4J003858;
        Tue, 16 Jul 2019 22:29:24 GMT
Received: from [10.211.55.164] (/10.211.55.164)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 22:29:24 +0000
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net v3 7/7] net/rds: Initialize ic->i_fastreg_wrs upon
 allocation
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Message-ID: <94bc1575-1772-3619-e8d5-b74463308e0f@oracle.com>
Date:   Tue, 16 Jul 2019 15:29:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160261
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise, if an IB connection is torn down before "rds_ib_setup_qp"
is called, the value of "ic->i_fastreg_wrs" is still at zero
(as it wasn't initialized by "rds_ib_setup_qp").
Consequently "rds_ib_conn_path_shutdown" will spin forever,
waiting for it to go back to "RDS_IB_DEFAULT_FR_WR",
which of course will never happen as there are no
outstanding work requests.

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
---
 net/rds/ib_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 1b6fd6c8b12b..4de0214da63c 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -527,7 +527,6 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	attr.qp_type = IB_QPT_RC;
 	attr.send_cq = ic->i_send_cq;
 	attr.recv_cq = ic->i_recv_cq;
-	atomic_set(&ic->i_fastreg_wrs, RDS_IB_DEFAULT_FR_WR);
 
 	/*
 	 * XXX this can fail if max_*_wr is too large?  Are we supposed
@@ -1139,6 +1138,7 @@ int rds_ib_conn_alloc(struct rds_connection *conn, gfp_t gfp)
 	spin_lock_init(&ic->i_ack_lock);
 #endif
 	atomic_set(&ic->i_signaled_sends, 0);
+	atomic_set(&ic->i_fastreg_wrs, RDS_IB_DEFAULT_FR_WR);
 
 	/*
 	 * rds_ib_conn_shutdown() waits for these to be emptied so they
-- 
2.22.0

