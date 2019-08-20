Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A3E952E6
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 02:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbfHTA6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 20:58:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55200 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728770AbfHTA6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 20:58:45 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7K0v2HI106481
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 20:58:44 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ug39uxgya-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 20:58:43 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <leonardo@linux.ibm.com>;
        Tue, 20 Aug 2019 01:58:43 +0100
Received: from b01cxnp22033.gho.pok.ibm.com (9.57.198.23)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 20 Aug 2019 01:58:39 +0100
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7K0wcmr48300468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 00:58:38 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D759112062;
        Tue, 20 Aug 2019 00:58:38 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EE3A112065;
        Tue, 20 Aug 2019 00:58:36 +0000 (GMT)
Received: from LeoBras.ibmuc.com (unknown [9.85.170.223])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 20 Aug 2019 00:58:35 +0000 (GMT)
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Leonardo Bras <leonardo@linux.ibm.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if IPv6 is disabled on boot
Date:   Mon, 19 Aug 2019 21:58:21 -0300
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19082000-0052-0000-0000-000003EC65CD
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011620; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000287; SDB=6.01249297; UDB=6.00659489; IPR=6.01030832;
 MB=3.00028239; MTD=3.00000008; XFM=3.00000015; UTC=2019-08-20 00:58:41
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082000-0053-0000-0000-000062268B18
Message-Id: <20190820005821.2644-1-leonardo@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-19_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200005
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If IPv6 is disabled on boot (ipv6.disable=1), but nft_fib_inet ends up
dealing with a IPv6 package, it causes a kernel panic in
fib6_node_lookup_1(), crashing in bad_page_fault.

The panic is caused by trying to deference a very low address (0x38
in ppc64le), due to ipv6.fib6_main_tbl = NULL.
BUG: Kernel NULL pointer dereference at 0x00000038

Fix this behavior by dropping IPv6 packages if !ipv6_mod_enabled().

Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
---
 net/netfilter/nft_fib_inet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_fib_inet.c b/net/netfilter/nft_fib_inet.c
index 465432e0531b..0017afab3c51 100644
--- a/net/netfilter/nft_fib_inet.c
+++ b/net/netfilter/nft_fib_inet.c
@@ -2,6 +2,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/ipv6.h>
 #include <linux/module.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
@@ -28,6 +29,8 @@ static void nft_fib_inet_eval(const struct nft_expr *expr,
 		}
 		break;
 	case NFPROTO_IPV6:
+		if (!ipv6_mod_enabled())
+			break;
 		switch (priv->result) {
 		case NFT_FIB_RESULT_OIF:
 		case NFT_FIB_RESULT_OIFNAME:
-- 
2.20.1

