Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F99B16AC
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 01:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbfILXbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 19:31:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52814 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbfILXbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 19:31:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8CNSaHI084763;
        Thu, 12 Sep 2019 23:31:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=/9sIj4dvAR1BKS4gbx0wdRTSu2BNoh+AO6pNLf/eWyE=;
 b=NFX53ckkgKQjqkJtCded2I011RBJljXGCVyqvq/oH1fms2D7J7CkJdzbykIvQsvCVSA3
 N5lGyo5J7MGWytyO88XfoyFUQ4EV8nGZpbD3zxpt/M2fITcwbqdauB3QAU2utCuLuQ1R
 bORw1Et2QvH/M5lHy+jHjN7ymRkOCKxsnlcBsynE3XawioI076u6HOgAbWItK/lTJ4mH
 vn+yerpktb1dnn5tQmu+gEnCT1ZiXVId0QuPekrb8elIwjLJhzdkoc8u6Z0pf8P7OB0F
 NcjbJ5yofqleGdmVJVCEctrZYg0ds0t/6dpedLGjtPReM3gIDYLHoUpIjIM5GzJySrFG 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uytd3hffj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Sep 2019 23:31:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8CNSZOj097043;
        Thu, 12 Sep 2019 23:31:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2uytdw25vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Sep 2019 23:31:11 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8CNVBLe104389;
        Thu, 12 Sep 2019 23:31:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uytdw25v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Sep 2019 23:31:11 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8CNV9TZ022624;
        Thu, 12 Sep 2019 23:31:09 GMT
Received: from [10.211.54.129] (/10.211.54.129) by default (Oracle Beehive
 Gateway v4.0) with ESMTP ; Thu, 12 Sep 2019 13:49:57 -0700
USER-AGENT: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Content-Language: en-US
MIME-Version: 1.0
Message-ID: <914b48be-2373-5b38-83f5-e0d917dd139d@oracle.com>
Date:   Thu, 12 Sep 2019 13:49:41 -0700 (PDT)
From:   Gerd Rausch <gerd.rausch@oracle.com>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Subject: [PATCH net] net/rds: Fix 'ib_evt_handler_call' element in
 'rds_ib_stat_names'
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9378 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909120240
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All entries in 'rds_ib_stat_names' are stringified versions
of the corresponding "struct rds_ib_statistics" element
without the "s_"-prefix.

Fix entry 'ib_evt_handler_call' to do the same.

Fixes: f4f943c958a2 ("RDS: IB: ack more receive completions to improve performance")
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
---
 net/rds/ib_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/ib_stats.c b/net/rds/ib_stats.c
index 9252ad126335..ac46d8961b61 100644
--- a/net/rds/ib_stats.c
+++ b/net/rds/ib_stats.c
@@ -42,7 +42,7 @@ DEFINE_PER_CPU_SHARED_ALIGNED(struct rds_ib_statistics, rds_ib_stats);
 static const char *const rds_ib_stat_names[] = {
 	"ib_connect_raced",
 	"ib_listen_closed_stale",
-	"s_ib_evt_handler_call",
+	"ib_evt_handler_call",
 	"ib_tasklet_call",
 	"ib_tx_cq_event",
 	"ib_tx_ring_full",
-- 
2.22.1

