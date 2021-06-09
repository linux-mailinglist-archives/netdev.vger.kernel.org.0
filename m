Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881DC3A1138
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238965AbhFIKgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:36:38 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40932 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238944AbhFIKga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:36:30 -0400
Received: by mail-pl1-f196.google.com with SMTP id e7so12299211plj.7;
        Wed, 09 Jun 2021 03:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UGrS0pb6Mvq5BByOhFrdzVI9hEYbJt4xFRvfL2Dlzyw=;
        b=N1YJlPu6O9AWVBPxsFUNGTfbxwRrakmwjJX9elqkrfn+jJJeadgmrHja/KyA+9LG/x
         bGn7jSR82oCSP0ue8zU/+wcXm63VftNI1bN6qnoqBm4YvYyr9T1bCLxPcx/felVUmvP0
         6soyX6ZVO1SxDxCsaTmLQpEonI8Y2n/CsIg9BPiiA7FhBiYxnaAJCGGQWDg/B0xs83fg
         GnHQHySlyW9sOVk3hA+VIn4z4LfQAVIReqLpevBgFSL43OfivgSTHIjHp0gtV5pYWxi4
         4FXMmK9+bzIBdPOW6lx2sMJkj0N9BS2s0PP3eTSmLm2rUX1IT2y3ZuPmcpRrjkvL/QKm
         vUZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UGrS0pb6Mvq5BByOhFrdzVI9hEYbJt4xFRvfL2Dlzyw=;
        b=iwToza8kH4Pqf39hpb22t37WiRuLrBmoKMXS4CSh+5Z4b3ShfqPHxvtWW/v6OfqZEa
         ZY4MrQzmz2bYzHypxeluqqkc3iZ2Rnm17NSCfdZB/UXi0I6+V7tu1PXJmWdKggc846Ge
         IP+44BvKU/sEccD8ICUcxOnExpY8b+lGz0HsVPHEZrH2O7e4gGNBQU9SYBiU/ixRnoFT
         9fA+t37qo6Sf86jpBA6nEDIinQp1+nKYn38rq0m3jLWTxFEfK3pg/Gbz6yam/W4sLJWP
         YoFiNi2u1hVOFFhLPqEDxv0ASma6Sn0KZl4wdwaFrjxQ4a4YaGLyIH9w31nyFegUUgTU
         ydJA==
X-Gm-Message-State: AOAM533XyUXE5VNlJbHS3AB3KqOzuP57ArHiOfb6WY6sLeBcvSEQZe0j
        X10zjrt91bcdopM28o6cRC8=
X-Google-Smtp-Source: ABdhPJx+7e2x6uvNXaOA9aKCYtCCCzpVu972HGDq8OYATpZIFleFWVrDcGfzHzoVLzMx5jMseMs+7g==
X-Received: by 2002:a17:90a:5406:: with SMTP id z6mr30364988pjh.130.1623234800429;
        Wed, 09 Jun 2021 03:33:20 -0700 (PDT)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id w59sm17495654pjj.13.2021.06.09.03.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:33:20 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     jmaloy@redhat.com
Cc:     ying.xue@windriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH v2 net-next 2/2] net: tipc: replace align() with ALIGN in msg.c
Date:   Wed,  9 Jun 2021 18:32:51 +0800
Message-Id: <20210609103251.534270-3-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210609103251.534270-1-dong.menglong@zte.com.cn>
References: <20210609103251.534270-1-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

The function align() which is defined in msg.c is redundant, replace it
with ALIGN() and introduce a BUF_ALIGN().

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/tipc/msg.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index a5c030ca7065..19a7d8eb8abb 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -49,6 +49,7 @@
 #define BUF_HEADROOM (LL_MAX_HEADER + 48)
 #define BUF_TAILROOM 0
 #endif
+#define BUF_ALIGN(x) ALIGN(x, 4)
 #define FB_MTU (PAGE_SIZE - \
 		SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) - \
 		SKB_DATA_ALIGN(BUF_HEADROOM + BUF_TAILROOM) \
@@ -56,11 +57,6 @@
 
 const int fb_mtu = FB_MTU;
 
-static unsigned int align(unsigned int i)
-{
-	return (i + 3) & ~3u;
-}
-
 /**
  * tipc_buf_acquire - creates a TIPC message buffer
  * @size: message size (including TIPC header)
@@ -489,10 +485,10 @@ static bool tipc_msg_bundle(struct sk_buff *bskb, struct tipc_msg *msg,
 	struct tipc_msg *bmsg = buf_msg(bskb);
 	u32 msz, bsz, offset, pad;
 
-	msz = msg_size(msg);
-	bsz = msg_size(bmsg);
-	offset = align(bsz);
-	pad = offset - bsz;
+	msz	= msg_size(msg);
+	bsz	= msg_size(bmsg);
+	offset	= BUF_ALIGN(bsz);
+	pad	= offset - bsz;
 
 	if (unlikely(skb_tailroom(bskb) < (pad + msz)))
 		return false;
@@ -548,7 +544,7 @@ bool tipc_msg_try_bundle(struct sk_buff *tskb, struct sk_buff **skb, u32 mss,
 
 	/* Make a new bundle of the two messages if possible */
 	tsz = msg_size(buf_msg(tskb));
-	if (unlikely(mss < align(INT_H_SIZE + tsz) + msg_size(msg)))
+	if (unlikely(mss < BUF_ALIGN(INT_H_SIZE + tsz) + msg_size(msg)))
 		return true;
 	if (unlikely(pskb_expand_head(tskb, INT_H_SIZE, mss - tsz - INT_H_SIZE,
 				      GFP_ATOMIC)))
@@ -607,7 +603,7 @@ bool tipc_msg_extract(struct sk_buff *skb, struct sk_buff **iskb, int *pos)
 	if (unlikely(!tipc_msg_validate(iskb)))
 		goto none;
 
-	*pos += align(imsz);
+	*pos += BUF_ALIGN(imsz);
 	return true;
 none:
 	kfree_skb(skb);
-- 
2.32.0

