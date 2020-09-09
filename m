Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BAF262C77
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbgIIJtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:49:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59436 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729413AbgIIJtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 05:49:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0899mW1t100048;
        Wed, 9 Sep 2020 09:49:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=tB4+7qqod85cCWo7gq3iXkCyjRmxVFGHTo3ktJFTHXA=;
 b=JYbaL79OI6WJ4Xk0k8tFcd4vl3E+ZVTfN785frqi2eNvwvmUiFx5FkzO+Mr3tIZevbl4
 Tw44lJ50TnTkOl66419sBuVM/DGtKRFXmTLDnEU1BDDPDsgTyKzC+IsNIEKyg2/w/tT9
 n+aXVF9pkmWQD0Xd8IkO4HPWHkTXNidoHPthK01rpk+AVhUUiqs+tAzlTxBDA2SwXMjc
 rsW4tAZxlrMTENdWUKM7+yL4j/T/XPAOYm+5BbVpIebHC75Lvyp3fMwRMSMuyyqOCokS
 WqYTe7VQk+MTLJrQ+pAsT3M73TAqMrLxJoBueQFa0NcLS4lbpYvR9iu2EY3H0a165iDO Qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33c2mm0pe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 09:49:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0899eMqQ175199;
        Wed, 9 Sep 2020 09:47:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33cmkxfqg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 09:47:25 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0899lNn3032418;
        Wed, 9 Sep 2020 09:47:23 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 02:47:22 -0700
Date:   Wed, 9 Sep 2020 12:46:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Krzysztof Halasa <khc@pm.waw.pl>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        security@kernel.org, nan chen <whutchennan@gmail.com>,
        Greg KH <greg@kroah.com>
Subject: [PATCH v2 net] hdlc_ppp: add range checks in ppp_cp_parse_cr()
Message-ID: <20200909094648.GC420136@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMnVd19nWToENW3X7v_PZN4snoXAoLgqKqn=dezXnd=z89zL7Q@mail.gmail.com>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090087
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a couple bugs here:
1) If opt[1] is zero then this results in a forever loop.  If the value
   is less than 2 then it is invalid.
2) It assumes that "len" is more than sizeof(valid_accm) or 6 which can
   result in memory corruption.

In the case of LCP_OPTION_ACCM, then  we should check "opt[1]" instead
of "len" because, if "opt[1]" is less than sizeof(valid_accm) then
"nak_len" gets out of sync and it can lead to memory corruption in the
next iterations through the loop.  In case of LCP_OPTION_MAGIC, the
only valid value for opt[1] is 6, but the code is trying to log invalid
data so we should only discard the data when "len" is less than 6
because that leads to a read overflow.

Reported-by: ChenNan Of Chaitin Security Research Lab  <whutchennan@gmail.com>
Fixes: e022c2f07ae5 ("WAN: new synchronous PPP implementation for generic HDLC.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: check opt[1] < 6 instead of len < 6 for the LCP_OPTION_ACCM case.

 drivers/net/wan/hdlc_ppp.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index 48ced3912576..16f33d1ffbfb 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -383,11 +383,8 @@ static void ppp_cp_parse_cr(struct net_device *dev, u16 pid, u8 id,
 	}
 
 	for (opt = data; len; len -= opt[1], opt += opt[1]) {
-		if (len < 2 || len < opt[1]) {
-			dev->stats.rx_errors++;
-			kfree(out);
-			return; /* bad packet, drop silently */
-		}
+		if (len < 2 || opt[1] < 2 || len < opt[1])
+			goto err_out;
 
 		if (pid == PID_LCP)
 			switch (opt[0]) {
@@ -395,6 +392,8 @@ static void ppp_cp_parse_cr(struct net_device *dev, u16 pid, u8 id,
 				continue; /* MRU always OK and > 1500 bytes? */
 
 			case LCP_OPTION_ACCM: /* async control character map */
+				if (opt[1] < sizeof(valid_accm))
+					goto err_out;
 				if (!memcmp(opt, valid_accm,
 					    sizeof(valid_accm)))
 					continue;
@@ -406,6 +405,8 @@ static void ppp_cp_parse_cr(struct net_device *dev, u16 pid, u8 id,
 				}
 				break;
 			case LCP_OPTION_MAGIC:
+				if (len < 6)
+					goto err_out;
 				if (opt[1] != 6 || (!opt[2] && !opt[3] &&
 						    !opt[4] && !opt[5]))
 					break; /* reject invalid magic number */
@@ -424,6 +425,11 @@ static void ppp_cp_parse_cr(struct net_device *dev, u16 pid, u8 id,
 		ppp_cp_event(dev, pid, RCR_GOOD, CP_CONF_ACK, id, req_len, data);
 
 	kfree(out);
+	return;
+
+err_out:
+	dev->stats.rx_errors++;
+	kfree(out);
 }
 
 static int ppp_rx(struct sk_buff *skb)
-- 
2.28.0

