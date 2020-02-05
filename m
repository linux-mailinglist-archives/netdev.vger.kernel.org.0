Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6BD153039
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 12:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbgBEL4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 06:56:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53972 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgBEL4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 06:56:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 015BrKnS014316;
        Wed, 5 Feb 2020 11:56:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2019-08-05; bh=sE79fnn4E+4x+0PaTASzGc97LOZkUplSQbzVHPM8lGM=;
 b=ZHIgjTTn2B+flaxB2imnvzGVoeW6bC+fWD/p08pxOUCwRDUu9nHwKidQC9K3YQnVDxkw
 zBV7AOPCrReAYX72UIAPRY8W6NxMoTFy/zAepAQlnW40t0gDSn7q2wp4oiATikx57JwY
 rCwLVoRFIzMgv/M0PG8no5KqXbkOVRsO/uUHJiQ1Hn2rMyFXqSjdLwLF+Df94Bm5UO1V
 faYKZ5NYbgrGNju4+88aoP5wI6mRG7jxjtM55wIeQQr5zVgpy1vd8zlL1AQ2JfKbHJVa
 +SnE64v148Gh5rwdokVdP97ih1+JaHFSSNgg+fhQr1hHrnPRy0lHywXkCZQgjoZKiKF2 0w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xykbp2hp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 11:56:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 015BsJNp081033;
        Wed, 5 Feb 2020 11:54:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xykbrnxyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 11:54:27 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 015BrcmP031577;
        Wed, 5 Feb 2020 11:53:38 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 05 Feb 2020 03:53:38 -0800
Date:   Wed, 5 Feb 2020 14:53:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        "V. Saicharan" <vsaicharan1998@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Sachin D. Patil" <sdp.sachin@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v2 net] net: sched: prevent a use after free
Message-ID: <20200205115330.7x2qgaks7racy5wj@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVrckjFViizKZH+S=8GC_3T5Gm1vTAUeFkpmqJ_A66x1Q@mail.gmail.com>
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050097
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bug is that we call kfree_skb(skb) and then pass "skb" to
qdisc_pkt_len(skb) on the next line, which is a use after free.
Also Cong Wang points out that it's better to delay the actual
frees until we drop the rtnl lock so we should use rtnl_kfree_skbs()
instead of kfree_skb().

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Use rtnl_kfree_skbs() instead of kfree_skb().  From static analysis.
    Not tested, but I have audited the code pretty close and I think
    switing to rtnl_kfree_skbs() is harmless.

 net/sched/sch_fq_pie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index bbd0dea6b6b9..214657eb3dfd 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -349,9 +349,9 @@ static int fq_pie_change(struct Qdisc *sch, struct nlattr *opt,
 	while (sch->q.qlen > sch->limit) {
 		struct sk_buff *skb = fq_pie_qdisc_dequeue(sch);
 
-		kfree_skb(skb);
 		len_dropped += qdisc_pkt_len(skb);
 		num_dropped += 1;
+		rtnl_kfree_skbs(skb, skb);
 	}
 	qdisc_tree_reduce_backlog(sch, num_dropped, len_dropped);
 
-- 
2.11.0

