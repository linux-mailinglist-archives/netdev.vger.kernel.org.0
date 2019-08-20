Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 811F895A8C
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbfHTJBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:01:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58248 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729333AbfHTJBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 05:01:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7K8mkBp093820;
        Tue, 20 Aug 2019 09:01:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=0orkIjBpqh48NdlsP49mFizUjL079Xb5uHu7eTGMzBg=;
 b=OD8CIdWFY+HEukD6Z7lmeZ2StIana52nh/I5mcQhPE7AsNh9IVhEp563fZ9u3MjZaPaJ
 zHoZAIiDAyJ0fqDG7ylapuZE//264DXyWT6oLKd0zfcNqnjmQCWZfp7D1dWDioMS/zqz
 +JL+oY103LxMc1EMVMSRKWrRuDNzXpL1Utn9KNBizqTdC49VqlmfWP8pKGy6ETBmn7J0
 0R9Zd65tIFZcipqdrk0P7WBXyuZYsJ0Tw2i3FGY/liuwp9eam2Q7LABVy2159MDguQ0F
 qbjzj52Cp3tTv/34WubLXMLh0UiVkMu5r6YIOzvVs9oCPqMJdqiHlL7JOvX38kfpxTDE QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uea7qmw8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 09:01:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7K8mZWs035374;
        Tue, 20 Aug 2019 09:01:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2ugd199ypv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 09:01:01 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7K911Rg015890;
        Tue, 20 Aug 2019 09:01:01 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 02:01:00 -0700
Date:   Tue, 20 Aug 2019 12:00:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Catherine Sullivan <csully@google.com>
Cc:     Sagi Shahar <sagis@google.com>, Jon Olson <jonolson@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>,
        Chuhong Yuan <hslester96@gmail.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] gve: Copy and paste buy in gve_get_stats()
Message-ID: <20190820090053.GA24410@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a copy and paste error so we have "rx" where "tx" was intended
in the priv->tx[] array.

Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
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

