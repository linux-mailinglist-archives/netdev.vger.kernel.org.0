Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985F149DD7F
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238361AbiA0JNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238357AbiA0JNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:13:49 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBA7C061714;
        Thu, 27 Jan 2022 01:13:49 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id h23so1731459pgk.11;
        Thu, 27 Jan 2022 01:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fbpl4iiTcLCx3Uuz7lt489tee85dcatKLG2kCO2VOAg=;
        b=a/DWhTa2w4VjMjRa4YwLmO2s2osYF6Vcl9QHgFj9fj+G1r3clobDDvEx5xjX0HWt2a
         BK/2BOdOyZO2gkBVXFsDEmHNDtPS9FIpxZV28j8vpl42AUEqXJ1g97zcgxmqXE6daJKB
         xXtQY/bJ6vYr1YEtyjlufuwraLZw8I6IZiT7x2En2KNlvlyI9RBUNs5gZo0mKtMr3Z9e
         eDiplrgxYypCDiSqIs+zwmaNkUHWK/7qdYO6+ccikDYaXXapvvEy5sOl46IyW9jnE1DD
         AG7u/lcwBLA1h5gmRtCpDdpgJRdni+oD5fXkQ7nORVkji4R39bJHOB54e9aDr74aZo3H
         gH+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fbpl4iiTcLCx3Uuz7lt489tee85dcatKLG2kCO2VOAg=;
        b=JQILm2NOzXXv+UoI96O+oICxkqId8+8AY9FNIWlBQYiZSnBYGIYm3oCa06MTpm0M2c
         zgW3XU33T/WhN/9Av34XpAdjWqWJbxxqRpOeJPCa2TyoMozl4V89ntWpjiX35s2jg3vr
         CXBzBA3hZDBZ8AaAnaN8cutD5uh176IIWweu9PLAFJlXA/iYhXT2vwfic4VS8aX1l084
         C4yrFkJ1Gp8Rm8LjAVVGJN0wN1b7cvY3hIGWXRqcbuBgUJlFw0VKkVPHN6Wv6XuJP7AW
         FhJnzgG9BjYkpHNB8vMLTI14hOQ8WN5GsHtiqM3q6/Af186sWJ57Ge2U8MjyLM3eH4Ih
         G7Kw==
X-Gm-Message-State: AOAM531jF73hqCODSYyyLoBmeoOYbzyk1+alFi4FAOxK1C1VFna/Lkvs
        ROYEzu04tajHBa543TWdUYQ=
X-Google-Smtp-Source: ABdhPJx2wTIYh9XfY/TQmYXbSc4cKVVOmzqrKeas21uF+gOiRcS8il3FCXy9xXZQK9SgPbOjS6Wojw==
X-Received: by 2002:a63:343:: with SMTP id 64mr2085698pgd.463.1643274828848;
        Thu, 27 Jan 2022 01:13:48 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id j11sm2046338pjf.53.2022.01.27.01.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 01:13:48 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        alobakin@pm.me, pabeni@redhat.com, cong.wang@bytedance.com,
        talalahmad@google.com, haokexin@gmail.com, keescook@chromium.org,
        memxor@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, mengensun@tencent.com
Subject: [PATCH v2 net-next 2/8] net: skb_drop_reason: add document for drop reasons
Date:   Thu, 27 Jan 2022 17:13:02 +0800
Message-Id: <20220127091308.91401-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220127091308.91401-1-imagedong@tencent.com>
References: <20220127091308.91401-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Add document for following existing drop reasons:

SKB_DROP_REASON_NOT_SPECIFIED
SKB_DROP_REASON_NO_SOCKET
SKB_DROP_REASON_PKT_TOO_SMALL
SKB_DROP_REASON_TCP_CSUM
SKB_DROP_REASON_SOCKET_FILTER
SKB_DROP_REASON_UDP_CSUM

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8a636e678902..5c5615a487e7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -314,12 +314,12 @@ struct sk_buff;
  * used to translate the reason to string.
  */
 enum skb_drop_reason {
-	SKB_DROP_REASON_NOT_SPECIFIED,
-	SKB_DROP_REASON_NO_SOCKET,
-	SKB_DROP_REASON_PKT_TOO_SMALL,
-	SKB_DROP_REASON_TCP_CSUM,
-	SKB_DROP_REASON_SOCKET_FILTER,
-	SKB_DROP_REASON_UDP_CSUM,
+	SKB_DROP_REASON_NOT_SPECIFIED,	/* drop reason is not specified */
+	SKB_DROP_REASON_NO_SOCKET,	/* socket not found */
+	SKB_DROP_REASON_PKT_TOO_SMALL,	/* packet size is too small */
+	SKB_DROP_REASON_TCP_CSUM,	/* TCP checksum error */
+	SKB_DROP_REASON_SOCKET_FILTER,	/* dropped by socket filter */
+	SKB_DROP_REASON_UDP_CSUM,	/* UDP checksum error */
 	SKB_DROP_REASON_MAX,
 };
 
-- 
2.34.1

