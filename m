Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD114980C9
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 14:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243032AbiAXNP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 08:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243041AbiAXNPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 08:15:54 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78168C06173D;
        Mon, 24 Jan 2022 05:15:54 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id z131so4335025pgz.12;
        Mon, 24 Jan 2022 05:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sBcUzmR8HipAMmfGTXgE1nbM6mUi+zj9tY3YPqei71A=;
        b=VfujqfnNX0UUJbMS5C3SxFb/ynubohdqoD8vcFVVfMHKgzxhwGiyqmX8YOVXyuwMa9
         gg00dtfqAiGjAHEL23X1ZX3AmyJnPqYlABkdcXRN+PcAt+a+wjdjS2lY1atSopw+4NEF
         U+zDmcsoHIwGcCoyuLAH2Cg0ZaDeEhI+1gkcQ7URBWviL6CZvzIlEQp8q0iP/2jBpyFb
         8PbCctrJ7fqy9xukJ4yoVWMxz+eC+AYW+XbaLVJWPj3Yv6e8q1B3gidhtpvfKkVyQjre
         9+u2f+7rWlvNAZRggAkmjerBHHXiGsVJr5UqG/DjFBpyW5LKWfqRbWn3bVHeZ/jBEuQi
         EBCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sBcUzmR8HipAMmfGTXgE1nbM6mUi+zj9tY3YPqei71A=;
        b=0cSMVsJ7EDgI25IN5qjhTq5144LETYoRN+YjiA1Z2RG7170/nrTOWtCtXUrk+h37ac
         DjN7qS59JYdxzPEPAM9vyXA/MswBiTP1MYGUSoKgFZwnHxsgE27infE8gu1qgzI/+P8g
         bOI4DP+qGjXwv4b7gFsMGzD3GZMw6L9YQtlop+A4Oa06Vz87EsXOtdTWJq98qCIYcQFK
         s++rbo8eAiU2Px5PaZg1PwQUlFkc1Etsl/ezHEx853Mxhk/3x6j3qT2EYwLMIi6PYgGx
         gXVkco2T/MkDBImxU66w/JdIonXMfpQMxSLSKOtIpDzbVU1yD6iluaLuoRrU6GHZCyyM
         kfrg==
X-Gm-Message-State: AOAM532rM3LSYAou9Z2hSOl7wUe4e46kAeTb9iRXwKNJdKTj81n12rhE
        aptX0B1VKICudkNQtT4NwVE=
X-Google-Smtp-Source: ABdhPJwefWMxahNevYpy0VOjiBJ6H0TV8n629KxQMGKFMJdluAO99q9/dJo/wYc9ytZwHtzC8tn1dg==
X-Received: by 2002:a05:6a00:18a6:b0:4ca:38e0:400d with SMTP id x38-20020a056a0018a600b004ca38e0400dmr1147619pfh.22.1643030154055;
        Mon, 24 Jan 2022 05:15:54 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id j11sm16508806pfu.55.2022.01.24.05.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 05:15:53 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, paulb@nvidia.com,
        pabeni@redhat.com, talalahmad@google.com, haokexin@gmail.com,
        keescook@chromium.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com
Subject: [PATCH net-next 1/6] net: netfilter: use kfree_drop_reason() for NF_DROP
Date:   Mon, 24 Jan 2022 21:15:33 +0800
Message-Id: <20220124131538.1453657-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220124131538.1453657-1-imagedong@tencent.com>
References: <20220124131538.1453657-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in nf_hook_slow() when
skb is dropped by reason of NF_DROP.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 1 +
 include/trace/events/skb.h | 1 +
 net/netfilter/core.c       | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bf11e1fbd69b..1bcd690b8ae1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -320,6 +320,7 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_CSUM,
 	SKB_DROP_REASON_TCP_FILTER,
 	SKB_DROP_REASON_UDP_CSUM,
+	SKB_DROP_REASON_NETFILTER_DROP,
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 3e042ca2cedb..beed7bb2bc0e 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -16,6 +16,7 @@
 	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
 	EM(SKB_DROP_REASON_TCP_FILTER, TCP_FILTER)		\
 	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
+	EM(SKB_DROP_REASON_NETFILTER_DROP, NETFILTER_DROP)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 354cb472f386..d1c9dfbb11fa 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -621,7 +621,8 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 		case NF_ACCEPT:
 			break;
 		case NF_DROP:
-			kfree_skb(skb);
+			kfree_skb_reason(skb,
+					 SKB_DROP_REASON_NETFILTER_DROP);
 			ret = NF_DROP_GETERR(verdict);
 			if (ret == 0)
 				ret = -EPERM;
-- 
2.34.1

