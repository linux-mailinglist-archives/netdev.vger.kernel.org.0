Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E8995AB7
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbfHTJL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:11:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43260 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728771AbfHTJL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 05:11:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7K998QY113686;
        Tue, 20 Aug 2019 09:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2019-08-05; bh=ziI5IPFFuH8/BD0ZL+nvh8R9brI3qWSeYX+UCPMiMps=;
 b=JOowmwSVZ3im0gon8jWryuwjAP6cHSJdHuvF4Wy0Pog9mJIqj2ljseBPlo+ezZtbz58V
 zJBhfKOp1e1p5+taN/BS5QPQMWpUUVBprgIe55gHKn7MxuxPF8PvciDAxykEkoUFNaVn
 MyBlwOiw95AKggdIjU1oeum60TZhNm8tX5aUFnrAj+I14v40JmTa3jyfZXksNnjiR8dI
 ET97JzBk6TeD6OaVCT7j+sQhGmehBA2u8SLgZrnCJK+0AjSH7A3f0/VPwv4pGXkgjKIG
 XkiFPsYd49snNHzPkjQjO2kh230cxHaRR2JIOai4EwoghINURaQCYvXR7kC0k66u1GYa nQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uea7qmygk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 09:11:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7K98eEn075603;
        Tue, 20 Aug 2019 09:11:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ug1g90626-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 09:11:52 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7K9BpSp015498;
        Tue, 20 Aug 2019 09:11:52 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 02:11:51 -0700
Date:   Tue, 20 Aug 2019 12:11:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Catherine Sullivan <csully@google.com>
Cc:     Sagi Shahar <sagis@google.com>, Jon Olson <jonolson@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>,
        Chuhong Yuan <hslester96@gmail.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v2 net] gve: Copy and paste bug in gve_get_stats()
Message-ID: <20190820090739.GB1845@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820090053.GA24410@mwanda>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200097
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a copy and paste error so we have "rx" where "tx" was intended
in the priv->tx[] array.

Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: fix a typo in the subject: buy -> bug (Thanks Walter Harms)

 drivers/net/ethernet/google/gve/gve_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 497298752381..aca95f64bde8 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -50,7 +50,7 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
 				  u64_stats_fetch_begin(&priv->tx[ring].statss);
 				s->tx_packets += priv->tx[ring].pkt_done;
 				s->tx_bytes += priv->tx[ring].bytes_done;
-			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
+			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
 						       start));
 		}
 	}
-- 
2.20.1
