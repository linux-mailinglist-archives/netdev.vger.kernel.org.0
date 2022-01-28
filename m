Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D4549F45F
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 08:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346825AbiA1Hdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 02:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346819AbiA1Hdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 02:33:52 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF774C061714;
        Thu, 27 Jan 2022 23:33:51 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id l24-20020a17090aec1800b001b55738f633so6747551pjy.1;
        Thu, 27 Jan 2022 23:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fbpl4iiTcLCx3Uuz7lt489tee85dcatKLG2kCO2VOAg=;
        b=Hnx5mSacFF1TfYpEmVBkDNCwrSnX9GxO9njbZxylQ0sYgbQX+YuZ2k2VWhtjWAY2qn
         8JJNdDXVQkgUGG7KpYdltzD0esaYKh+Zaxz9f8UQOpDTl+TCWJZOMdSzJnEmGV91rfAK
         MaX0W/j8pxJ1uEH3cFToBNE41H4FAujbBNuDeI9E5QVfRLWNJVYndjblv0/M2OR82PDr
         YDKYnIj0gfqq4S4x4i/RcnptIGYx+6Gz1fPK0HmLXIZ1ziEOCcefPwhdbRdh24BfYcm2
         8PCleyws2JEqbwJYY4xIcnKgMm3HtpLCeC7/xc5Y1ITJTaiHvkfNEAy+WlpHF16KxBkF
         n3fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fbpl4iiTcLCx3Uuz7lt489tee85dcatKLG2kCO2VOAg=;
        b=CcZp9TIN2NllAwWze5P40UL4KbH4Xr1Iyg+A905fdNQ1UH6gHhyaXqqIcRqheBqimZ
         yYCqMaO52brbJFTawjCUgsBNVNyg6pa8C1gXihP8d+fLBRY6kZvSIjQQzeij5c2toZkZ
         wVUzlPhNssJsYdS0ncLQDsZN8KhQadiQu+VO3JlmgU61jNKUtb0iefiQRXia8sr83wg4
         Mvr3on64X0UHs+9396bluAg4T2i4UVelrd4x/bTLk7FoaPE4y/ity2jexEXGGA5c36og
         3vAAs8JPxmOGLAG6Zo7gtPqAKRlm9YdFP3e9VxkTF527Aft4WnDsye3bKZ3g9DHXjbgo
         Nqgg==
X-Gm-Message-State: AOAM530vxLaRTsrqyY06pFXOpqqJkaw1zVKBEz+WMx9ceLIoWLtG8CTi
        TAo069Enkl1oYSz72JB3rXs=
X-Google-Smtp-Source: ABdhPJyXggEqjtjWfpxOYUYLfiM4yWGWbSYQF/CGzP4gk7mbpgmIO+j/2Y8YVlYQ2OxO69eTN9l1PA==
X-Received: by 2002:a17:902:ecd2:: with SMTP id a18mr7179069plh.84.1643355231584;
        Thu, 27 Jan 2022 23:33:51 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id q17sm8548846pfu.160.2022.01.27.23.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 23:33:50 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, imagedong@tencent.com, edumazet@google.com,
        alobakin@pm.me, paulb@nvidia.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com, mengensun@tencent.com
Subject: [PATCH v3 net-next 1/7] net: skb_drop_reason: add document for drop reasons
Date:   Fri, 28 Jan 2022 15:33:13 +0800
Message-Id: <20220128073319.1017084-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220128073319.1017084-1-imagedong@tencent.com>
References: <20220128073319.1017084-1-imagedong@tencent.com>
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

