Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFFF4AA764
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 08:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357817AbiBEHsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 02:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376747AbiBEHr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 02:47:59 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF94C061346;
        Fri,  4 Feb 2022 23:47:58 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id d1so7042146plh.10;
        Fri, 04 Feb 2022 23:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7aNq4Io0f+ovfgZjS8ukIPYbhQ5JQpnNQv4Yb+umENQ=;
        b=eiVvXZA3R6xizP9DOVtbqcGyWkGtZEHLMkyIcROJqAE6BILikZC+V4f4VYUZwyWKBw
         Og8C80WEohXu5tnKHfnR725eD51pFiQzRABc3XoX4BpBUXLLh5XVaEDxpo8vL8U5u4nW
         eYSGcYPT4pw+fv8O3nvpXvvgyL3JmU9kXRw/jyBLWtv7MKNSsmf5ICVZN3iQjwnmfeXV
         DkwGJDzcj5D9fkJEz4XjiE3fAOArk/tKyoriJRHV7UG08wNMN2bk2+r92FjerRdkRj9J
         jXyXSmmw1i0y6uep3N/1PHSaZviw/bL0IKYeqxiLFcu/HYCSUBwcyCfKl4WCjNgSM938
         WK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7aNq4Io0f+ovfgZjS8ukIPYbhQ5JQpnNQv4Yb+umENQ=;
        b=OetL/GMxU+vw/sytpeoIH5oUQ6D7jwx4RwgOqdflnKopJvuRk7eWkW1ojDjScj+e2G
         3hwB+8aSF+zed70ukxlMUe2YdpWKIL08P5Ix3kM5tBpXEZG9lfTv2ySLPNoZMPSKIRHW
         3bd2mD11ZY6Xx3+xqaoD+mr8TdGeL64DoAFQkGpybWkv08+zSA9JOFVGU/VYcT20kU3n
         YhvHxAn0zSe7xrxOg4ZClCZJSlRA3bW03InIQLQ99Q1rRtgUdA7pIlJbbh/hy+ruAxOQ
         N65PV7WjXr5Zf0UeWUoVR2FcratE0TX/MYVbjEhbo+6akFP8xCxSjzy3ZR/HRtPHVu/h
         LKXg==
X-Gm-Message-State: AOAM532Ei+Sg6FBBxVM3GT0aU34DWnDt28flzt+FKi3EzrSx7/MMb/+q
        GOhEu52sOTlC4fSwaD/zUsk=
X-Google-Smtp-Source: ABdhPJxugEhSn86ivfT4KVWRB1svVRQJryEMEu3bemq6VMcKwPL3JLcdVmNzSICLUjcPFie1yBYMBA==
X-Received: by 2002:a17:90a:f198:: with SMTP id bv24mr7534005pjb.32.1644047278189;
        Fri, 04 Feb 2022 23:47:58 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id p21sm5165844pfh.89.2022.02.04.23.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 23:47:57 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, edumazet@google.com, alobakin@pm.me, ast@kernel.org,
        imagedong@tencent.com, pabeni@redhat.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        paulb@nvidia.com, cong.wang@bytedance.com, mengensun@tencent.com
Subject: [PATCH v4 net-next 1/7] net: skb_drop_reason: add document for drop reasons
Date:   Sat,  5 Feb 2022 15:47:33 +0800
Message-Id: <20220205074739.543606-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220205074739.543606-1-imagedong@tencent.com>
References: <20220205074739.543606-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 include/linux/skbuff.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a27bcc4f7e9a..f04e3a1f4455 100644
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

