Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB482EC61C
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 23:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbhAFWTa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 Jan 2021 17:19:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25126 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727704AbhAFWT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 17:19:29 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 106MIJQs015842
        for <netdev@vger.kernel.org>; Wed, 6 Jan 2021 14:18:49 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35wnkwg31s-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 14:18:49 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 6 Jan 2021 14:18:43 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id C3C6B6556F31; Wed,  6 Jan 2021 14:18:41 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <willemdebruijn.kernel@gmail.com>, <edumazet@google.com>,
        <dsahern@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [RESEND PATCH net-next v1 01/13] skbuff: remove unused skb_zcopy_abort function
Date:   Wed, 6 Jan 2021 14:18:29 -0800
Message-ID: <20210106221841.1880536-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210106221841.1880536-1-jonathan.lemon@gmail.com>
References: <20210106221841.1880536-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-06_12:2021-01-06,2021-01-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 clxscore=1034 mlxlogscore=459 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

