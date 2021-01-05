Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3352EB536
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 23:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731670AbhAEWH6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Jan 2021 17:07:58 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38582 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731619AbhAEWH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 17:07:56 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 105LikBa012580
        for <netdev@vger.kernel.org>; Tue, 5 Jan 2021 14:07:14 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35vtuaa0xb-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 14:07:14 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 5 Jan 2021 14:07:11 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 15A3F6489D18; Tue,  5 Jan 2021 14:07:06 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <willemdebruijn.kernel@gmail.com>, <edumazet@google.com>,
        <dsahern@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH net-next v1 01/13] skbuff: remove unused skb_zcopy_abort function
Date:   Tue, 5 Jan 2021 14:06:54 -0800
Message-ID: <20210105220706.998374-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210105220706.998374-1-jonathan.lemon@gmail.com>
References: <20210105220706.998374-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_07:2021-01-05,2021-01-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=434
 malwarescore=0 clxscore=1034 lowpriorityscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101050126
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

