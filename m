Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082FD2869D5
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgJGVIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:08:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60274 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgJGVIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 17:08:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097L4Cs4055252;
        Wed, 7 Oct 2020 21:08:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=g//sBCYth5gJxNzkzjtOhl9eL1n4LCL9IlTHxw7AMZg=;
 b=UNZXgnIzi1kENr5SkIsW2QCKMIg3z7focUgEv4ZxvrawZJvF5+PCW6GwfrwP7QQ1HXp0
 tnc5qxCoL4pIOFUynN2/VoXNco0ef9+NI36mgWlSP45DfnDXZJOunUW2mUhWuNyyVH9w
 IcukxspqJnomDkETTm5HPcsnyxmxJSZQEhAWWgLx2034/0AkWllw1kcwbIAkAJcJk9OM
 2Sm+W1eKvnilMroulUBcAqeKQ2+TZw5IW3N8y+Y9g3W8wR+Dvht0TqAdeUOUoE0K2Nip
 OzGnNIX6t82Q0zkp+WEcaMQ0r75KZoFJUq9f7H7ImiqeTWaRGbriPwIuB+S3qQDOmbRq zA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33xetb4hcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 21:08:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097L6Dxo006327;
        Wed, 7 Oct 2020 21:08:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 33y3802rrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 21:08:07 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 097L86B6014481;
        Wed, 7 Oct 2020 21:08:06 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by userp3030.oracle.com with ESMTP id 33y3802rqu-1;
        Wed, 07 Oct 2020 21:08:06 +0000
From:   Vijayendra Suman <vijayendra.suman@oracle.com>
To:     pabeni@redhat.com
Cc:     a.fatoum@pengutronix.de, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        somasundaram.krishnasamy@oracle.com,
        ramanan.govindarajan@oracle.com,
        Vijayendra Suman <vijayendra.suman@oracle.com>
Subject: Re: [BUG] pfifo_fast may cause out-of-order CAN frame transmission
Date:   Wed,  7 Oct 2020 14:07:44 -0700
Message-Id: <20201007210744.8546-1-vijayendra.suman@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <13e8950e8537e549f6afb6e254ec75a7462ce648.camel@redhat.com>
References: <13e8950e8537e549f6afb6e254ec75a7462ce648.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1011 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=3 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070136
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[PATCH] Patch with Network Performance Improvment qperf:tcp_lat

Check Performed for __QDISC_STATE_DEACTIVATED before checking BYPASS flag 

qperf tcp_lat 65536bytes over an ib_switch 

For 64K packet Performance improvment is around 47 % and performance deviation 
is reduced to 5 % which was 27 % prior to this patch.

As mentioned by Paolo, With  "net: dev: introduce support for sch BYPASS for lockless qdisc" commit
there may be out of order packet issue.
Is there any update to solve out of order packet issue.

qperf Counters for tcp_lat for 60 sec and packet size 64k

With Below Patch
1. 53817 
2. 54100 
3. 57016 
4. 59410 
5. 62017 
6. 54625 
7. 55770 
8. 54015 
9. 54406 
10. 53137

Without Patch [Upstream Stream]
1. 83742 
2. 107320 
3. 82807 
4. 105384 
5. 77406 
6. 132665 
7. 117566 
8. 109279 
9. 94959 
10. 82331 
11. 91614 
12. 104701 
13. 91123 
14. 93908 
15. 200485 

With UnRevert of commit 379349e9bc3b42b8b2f8f7a03f64a97623fff323 
[Revert "net: dev: introduce support for sch BYPASS for lockless qdisc"] 

1. 65550
2. 64285
3. 64110
4. 64300
5. 64645
6. 63928
7. 63574
8. 65024
9. 65153
10. 64281

Signed-off-by: Vijayendra Suman <vijayendra.suman@oracle.com>
---
 net/core/dev.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 40bbb5e43f5d..6cc8e0209b20 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3384,35 +3384,27 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 				 struct net_device *dev,
 				 struct netdev_queue *txq)
 {
 	struct sk_buff *to_free = NULL;
 	bool contended;
-	int rc;
+	int rc = NET_XMIT_SUCCESS;
 
 	qdisc_calculate_pkt_len(skb, q);
 
 	if (q->flags & TCQ_F_NOLOCK) {
-		if ((q->flags & TCQ_F_CAN_BYPASS) && READ_ONCE(q->empty) &&
-		    qdisc_run_begin(q)) {
-			if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED,
-					      &q->state))) {
-				__qdisc_drop(skb, &to_free);
-				rc = NET_XMIT_DROP;
-				goto end_run;
-			}
-			qdisc_bstats_cpu_update(q, skb);
-
-			rc = NET_XMIT_SUCCESS;
+		if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED, &q->state))) {
+			__qdisc_drop(skb, &to_free);
+			rc = NET_XMIT_DROP;
+		} else if ((q->flags & TCQ_F_CAN_BYPASS) && READ_ONCE(q->empty) &&
+				qdisc_run_begin(q)) {
+			qdisc_bstats_update(q, skb);
 			if (sch_direct_xmit(skb, q, dev, txq, NULL, true))
 				__qdisc_run(q);
-
-end_run:
 			qdisc_run_end(q);
 		} else {
 			rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
 			qdisc_run(q);
 		}
-
 		if (unlikely(to_free))
 			kfree_skb_list(to_free);
 		return rc;
-- 
2.27.0

