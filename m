Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E2297C4B
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbfHUOQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:16:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21768 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726371AbfHUOQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 10:16:17 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7LEDbM1121404
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 10:16:15 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uh61tcur0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 10:16:15 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <leonardo@linux.ibm.com>;
        Wed, 21 Aug 2019 15:16:14 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 21 Aug 2019 15:16:11 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7LEGAlr39977240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 14:16:10 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFEC4AC064;
        Wed, 21 Aug 2019 14:16:10 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 724A6AC05F;
        Wed, 21 Aug 2019 14:16:07 +0000 (GMT)
Received: from LeoBras.ibmuc.com (unknown [9.85.171.79])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 21 Aug 2019 14:16:07 +0000 (GMT)
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Leonardo Bras <leonardo@linux.ibm.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH v2 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if IPv6 is disabled on boot
Date:   Wed, 21 Aug 2019 11:15:06 -0300
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19082114-0072-0000-0000-000004541531
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011629; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000287; SDB=6.01250020; UDB=6.00659932; IPR=6.01031574;
 MB=3.00028261; MTD=3.00000008; XFM=3.00000015; UTC=2019-08-21 14:16:14
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082114-0073-0000-0000-00004CC5379D
Message-Id: <20190821141505.2394-1-leonardo@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-21_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908210156
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
Changes from v1:
- Move drop logic from nft_fib_inet_eval() to nft_fib6_eval{,_type}
so it can affect other usages of these functions. 

 net/ipv6/netfilter/nft_fib_ipv6.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 7ece86afd079..75acc417e2ff 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -125,6 +125,11 @@ void nft_fib6_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 	u32 *dest = &regs->data[priv->dreg];
 	struct ipv6hdr *iph, _iph;
 
+	if (!ipv6_mod_enabled()) {
+		regs->verdict.code = NF_DROP;
+		return;
+	}
+
 	iph = skb_header_pointer(pkt->skb, noff, sizeof(_iph), &_iph);
 	if (!iph) {
 		regs->verdict.code = NFT_BREAK;
@@ -150,6 +155,11 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct rt6_info *rt;
 	int lookup_flags;
 
+	if (!ipv6_mod_enabled()) {
+		regs->verdict.code = NF_DROP;
+		return;
+	}
+
 	if (priv->flags & NFTA_FIB_F_IIF)
 		oif = nft_in(pkt);
 	else if (priv->flags & NFTA_FIB_F_OIF)
-- 
2.20.1

