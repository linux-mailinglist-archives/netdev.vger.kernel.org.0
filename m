Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE13C14E8FF
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 07:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgAaG5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 01:57:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43546 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgAaG5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 01:57:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00V6sLVf081667;
        Fri, 31 Jan 2020 06:57:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=tiB4iq2Q8i2SRPr5AGcPm2GpvYmtOgewas625ubrIEk=;
 b=RpxuJWwR6mcIF3f/8LYbzt0xCyuxrP28iIObRiNxaPOIMhVCKgHq2PG9hQtarfeFrxWV
 oSGJ6UF+gwiav5ES1sQX6pGRnVWifn8ULUCeMgn/u5kylg91sKt7Ja3Qphx5ZkyXO5/H
 ch+7c/xODwYZgIYrce2fbpQ7325YylLQdcfm+QRIqar4DtMLDcEhZMMuGHFmG+U5vps2
 0kI7PmEOoNDHRAJy//guCcoSSQWwxisPtnNP64OjylUgJC0LU4t2NhUlziVqErZsCfxP
 7eNQUydZY5eovz7YgJyHa+OfENndryd9vWZlYB0iC0WMG2fZOs+AKDyK4ONiKvxNcMlt rQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xrd3urfuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 06:57:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00V6rarj118647;
        Fri, 31 Jan 2020 06:57:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xva6pwdqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 06:57:00 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00V6uuJ5015354;
        Fri, 31 Jan 2020 06:56:57 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jan 2020 22:56:56 -0800
Date:   Fri, 31 Jan 2020 09:56:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        "V. Saicharan" <vsaicharan1998@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: sched: prevent a use after free
Message-ID: <20200131065647.joonbg3wzcw26x3b@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=896
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001310061
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=960 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001310061
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code calls kfree_skb(skb); and then re-uses "skb" on the next line.
Let's re-order these lines to solve the problem.

Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/sched/sch_fq_pie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index bbd0dea6b6b9..78472e0773e9 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -349,9 +349,9 @@ static int fq_pie_change(struct Qdisc *sch, struct nlattr *opt,
 	while (sch->q.qlen > sch->limit) {
 		struct sk_buff *skb = fq_pie_qdisc_dequeue(sch);
 
-		kfree_skb(skb);
 		len_dropped += qdisc_pkt_len(skb);
 		num_dropped += 1;
+		kfree_skb(skb);
 	}
 	qdisc_tree_reduce_backlog(sch, num_dropped, len_dropped);
 
-- 
2.11.0

