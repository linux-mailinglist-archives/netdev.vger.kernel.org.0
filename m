Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BF12DEA16
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 21:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbgLRURT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Dec 2020 15:17:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30942 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727961AbgLRURS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 15:17:18 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BIKBNWr028853
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:16:37 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35g83xqxnv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:16:37 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 18 Dec 2020 12:16:35 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id D66F359FBE6F; Fri, 18 Dec 2020 12:16:33 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH 2/9 v1 RFC] skbuff: remove unused skb_zcopy_abort function
Date:   Fri, 18 Dec 2020 12:16:26 -0800
Message-ID: <20201218201633.2735367-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
References: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_12:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 spamscore=0 clxscore=1034 adultscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=350 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180136
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

skb_zcopy_abort() has no in-tree consumers, remove it.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 69588b304f83..fb6dd6af0f82 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1493,17 +1493,6 @@ static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
 	}
 }
 
-/* Abort a zerocopy operation and revert zckey on error in send syscall */
-static inline void skb_zcopy_abort(struct sk_buff *skb)
-{
-	struct ubuf_info *uarg = skb_zcopy(skb);
-
-	if (uarg) {
-		sock_zerocopy_put_abort(uarg, false);
-		skb_shinfo(skb)->zc_flags &= ~SKBZC_FRAGMENTS;
-	}
-}
-
 static inline void skb_mark_not_on_list(struct sk_buff *skb)
 {
 	skb->next = NULL;
-- 
2.24.1

