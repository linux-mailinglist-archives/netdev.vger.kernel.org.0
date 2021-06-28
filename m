Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB6D3B5932
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 08:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhF1Gjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 02:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbhF1Gjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 02:39:49 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB97C061766;
        Sun, 27 Jun 2021 23:37:24 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id g192so13286107pfb.6;
        Sun, 27 Jun 2021 23:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/1Rwnm8wm01ORDHn/DlKmW7MPMS9lQBNMJF6mJ4+ZYk=;
        b=KVqO1gHWaal3aKJHWEstTDg4vQt6826B6Hwx6rjufZiY85YOUfD3rEi5/SavY+VPEt
         +uT1JSO6XYN2qPcoyln9ed+PN2j1RZwhxt8Rr09uFXVhDpTlB0RN4+jiZUz7pfVzJtdv
         6jt1roYfxOv2/lTdLn6TwAP1KNP6vGBA2jZrofq2sXqcu1MUniGuR2eun1ob+s17/Isf
         Jjnwq6PzbuV6LxLcw7czRLMbUag5JGxqg3kcoQOHaH2s8sSO816sHyz50HWdsaYiqrbQ
         PeWRx2PEEsD21xJp5M5hd/FR+o5v1p9ctuOSqxewbMWM1l44fYi3Phw0DxrOTBZyznzc
         PGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/1Rwnm8wm01ORDHn/DlKmW7MPMS9lQBNMJF6mJ4+ZYk=;
        b=ekhlyq+n9lWwZJV1MgaJpqcZ9WpuYEsXsWGnT8+HvOb6mVTrd2N+zcVzrGqpRwWJkt
         kD8N2Q5N59ozAml51SxDSg4LoKPGS56d0ANm+G4BbQFQuy0EeapFDnhbtuQBrYdtYX/a
         YTRlUTwF2C3As/YiS/bMPshTQ5Sy6Z4IQg/yGxSQPxnuIKBsaytC1ZeaizIuk1hIA2vo
         QHx1fNrfCPrwZ+JIDXW4rQUzweOA5iULY1q/+jr20Wed+H1MHB7qK3emo6Zb7h25W6h3
         QivIexLGTmBKcYmBSVL3FD5wHysICfLOGWur8x0l/+NIa1kbOl2yAbifOY2DJjxiwG23
         RKKg==
X-Gm-Message-State: AOAM533Zz+205AvamGH7xOFGX3RSXYWheBgOPEsfdockedd8HIH7dLpW
        G99FijHSPqeWGJkGT31gSnQ=
X-Google-Smtp-Source: ABdhPJyBq3fnHYoXqq8L2x6SuggRUM0f9dD8GWRf6urPQc5QvPkLoJzZndjECPAnJIjZ9+oY97vv/Q==
X-Received: by 2002:aa7:8390:0:b029:305:983b:42ad with SMTP id u16-20020aa783900000b0290305983b42admr23734574pfm.0.1624862244408;
        Sun, 27 Jun 2021 23:37:24 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id y21sm2980379pfb.120.2021.06.27.23.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 23:37:24 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     jmaloy@redhat.com
Cc:     ying.xue@windriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, lxin@redhat.com,
        hoang.h.le@dektech.com.au, Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH v6 net-next 2/2] net: tipc: replace align() with ALIGN in msg.c
Date:   Sun, 27 Jun 2021 23:37:45 -0700
Message-Id: <20210628063745.3935-3-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628063745.3935-1-dong.menglong@zte.com.cn>
References: <20210628063745.3935-1-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

The function align() which is defined in msg.c is redundant, replace it
with ALIGN() and introduce a BUF_ALIGN().

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/msg.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 7053c22e393e..5c9fd4791c4b 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -41,6 +41,7 @@
 #include "name_table.h"
 #include "crypto.h"
 
+#define BUF_ALIGN(x) ALIGN(x, 4)
 #define MAX_FORWARD_SIZE 1024
 #ifdef CONFIG_TIPC_CRYPTO
 #define BUF_HEADROOM ALIGN(((LL_MAX_HEADER + 48) + EHDR_MAX_SIZE), 16)
@@ -53,11 +54,6 @@
 const int one_page_mtu = PAGE_SIZE - SKB_DATA_ALIGN(BUF_OVERHEAD) -
 			 SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
-static unsigned int align(unsigned int i)
-{
-	return (i + 3) & ~3u;
-}
-
 /**
  * tipc_buf_acquire - creates a TIPC message buffer
  * @size: message size (including TIPC header)
@@ -489,7 +485,7 @@ static bool tipc_msg_bundle(struct sk_buff *bskb, struct tipc_msg *msg,
 
 	msz = msg_size(msg);
 	bsz = msg_size(bmsg);
-	offset = align(bsz);
+	offset = BUF_ALIGN(bsz);
 	pad = offset - bsz;
 
 	if (unlikely(skb_tailroom(bskb) < (pad + msz)))
@@ -546,7 +542,7 @@ bool tipc_msg_try_bundle(struct sk_buff *tskb, struct sk_buff **skb, u32 mss,
 
 	/* Make a new bundle of the two messages if possible */
 	tsz = msg_size(buf_msg(tskb));
-	if (unlikely(mss < align(INT_H_SIZE + tsz) + msg_size(msg)))
+	if (unlikely(mss < BUF_ALIGN(INT_H_SIZE + tsz) + msg_size(msg)))
 		return true;
 	if (unlikely(pskb_expand_head(tskb, INT_H_SIZE, mss - tsz - INT_H_SIZE,
 				      GFP_ATOMIC)))
@@ -605,7 +601,7 @@ bool tipc_msg_extract(struct sk_buff *skb, struct sk_buff **iskb, int *pos)
 	if (unlikely(!tipc_msg_validate(iskb)))
 		goto none;
 
-	*pos += align(imsz);
+	*pos += BUF_ALIGN(imsz);
 	return true;
 none:
 	kfree_skb(skb);
-- 
2.32.0

