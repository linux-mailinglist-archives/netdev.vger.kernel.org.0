Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C2C2E7C10
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 20:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgL3TNh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 30 Dec 2020 14:13:37 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1210 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726305AbgL3TNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 14:13:31 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0BUJ7fvm030831
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 11:12:49 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 35p1qtq95j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 11:12:49 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Dec 2020 11:12:48 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 2C1B1610FBB0; Wed, 30 Dec 2020 11:12:44 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <willemdebruijn.kernel@gmail.com>,
        <edumazet@google.com>, <dsahern@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [RFC PATCH v3 01/12] skbuff: remove unused skb_zcopy_abort function
Date:   Wed, 30 Dec 2020 11:12:33 -0800
Message-ID: <20201230191244.610449-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201230191244.610449-1-jonathan.lemon@gmail.com>
References: <20201230191244.610449-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-30_12:2020-12-30,2020-12-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 mlxlogscore=396 adultscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 spamscore=0 clxscore=1034 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012300118
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

skb_zcopy_abort() has no in-tree consumers, remove it.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/skbuff.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 333bcdc39635..3ca8d7c7b30c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1490,17 +1490,6 @@ static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
 	}
 }
 
-/* Abort a zerocopy operation and revert zckey on error in send syscall */
-static inline void skb_zcopy_abort(struct sk_buff *skb)
-{
-	struct ubuf_info *uarg = skb_zcopy(skb);
-
-	if (uarg) {
-		sock_zerocopy_put_abort(uarg, false);
-		skb_shinfo(skb)->tx_flags &= ~SKBTX_ZEROCOPY_FRAG;
-	}
-}
-
 static inline void skb_mark_not_on_list(struct sk_buff *skb)
 {
 	skb->next = NULL;
-- 
2.24.1

