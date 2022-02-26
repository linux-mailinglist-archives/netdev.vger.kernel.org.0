Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193D84C53AA
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 05:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiBZEUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 23:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiBZEUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 23:20:20 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940E222011A;
        Fri, 25 Feb 2022 20:19:46 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id u16so6389049pfg.12;
        Fri, 25 Feb 2022 20:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E0+eJj0NPmwxnSMx1LXVXrNLUrIv19z+ZDO3nRYWhjc=;
        b=oI1ZrcyJTTa6Nsp+GTnXBkoaItgt5KmP8JGfnhwj1ltlFXvp+0b+ADel2Sz5KmTRpO
         6D8+HH7LlBoivftVgjHlA+7cyUE866z/MiQ0lF3NpbslKh0olBH54i0ZNaJBxCdQcCGm
         jHjrLn5vrrUyBsg6nMBQnq+q7y84nyCq/daaTKXkqRO8mNxuEeGF83MXPtnWveWM1+E6
         62R6cr3hJ5VMX2tiN27mw7nUbhVQkPdFeQIOvtozo1KdRfMbucLrjcfTfqozV1o+R4WI
         04tOAr0I/3q125ARozgG01uRLZES7u/0+ViwWhV6GWiLPrqkjbX+yfQz1dWJeBhd+mrl
         ibKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E0+eJj0NPmwxnSMx1LXVXrNLUrIv19z+ZDO3nRYWhjc=;
        b=HdWV9i9y8uGEqrFgiIG4qbAPlMIezYpKCO9gJSNI4DbuLHftC3Xp/nkgkaC7EEjeNl
         sYbDtvAQ+Dn1BRDNpj4XaWVA3Kon8eVmb04cGs/n+0dLKxnGrzad2bP7gMgdC1dp+mqL
         Y072aXLGpRzHCED6EmhMph5+02OSqhPHzHgz6f31UzWySULnWZtbf3MHvHF/369myUyu
         uHaFmtVMVWAuHeD00KaddN2XjF1fNBmQeN4wG6J+xv0uuqAiPbgEiiyiePkV0/ld3ElM
         kKy4eJ99N3MGMOntYxPmDRdgwk3cSW7jM4coCONiZc27kDddY9yRVRFj/1liDw1ueIin
         Cigg==
X-Gm-Message-State: AOAM5336GS6oMaR+qMi8uUWqDNaOSt4n/wh9yOthJgUBuJTZmmA1c7yV
        N68N7pIqlKsisI1HgD3Rp8s=
X-Google-Smtp-Source: ABdhPJwuBBwQtLfdsMQxH7b6WoLbDmCiZjOVW9m3/Tik/YGwbxhMycXlzRIpTusE4+vqx0W+vGdWnQ==
X-Received: by 2002:a63:e01:0:b0:374:2525:7690 with SMTP id d1-20020a630e01000000b0037425257690mr8838609pgl.37.1645849186064;
        Fri, 25 Feb 2022 20:19:46 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id k22-20020aa788d6000000b004f1335c8889sm4896193pff.7.2022.02.25.20.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 20:19:45 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, cong.wang@bytedance.com,
        paulb@nvidia.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        flyingpeng@tencent.com, mengensun@tencent.com,
        daniel@iogearbox.net, yajun.deng@linux.dev, roopa@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 3/3] net: neigh: add skb drop reasons to arp_error_report()
Date:   Sat, 26 Feb 2022 12:18:31 +0800
Message-Id: <20220226041831.2058437-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220226041831.2058437-1-imagedong@tencent.com>
References: <20220226041831.2058437-1-imagedong@tencent.com>
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

When neighbour become invalid or destroyed, neigh_invalidate() will be
called. neigh->ops->error_report() will be called if the neighbour's
state is NUD_FAILED, and seems here is the only use of error_report().
So we can tell that the reason of skb drops in arp_error_report() is
SKB_DROP_REASON_NEIGH_FAILED.

Replace kfree_skb() used in arp_error_report() with kfree_skb_reason().

Reviewed-by: Mengen Sun <mengensun@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/arp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 4db0325f6e1a..8e4ca4738c43 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -293,7 +293,7 @@ static int arp_constructor(struct neighbour *neigh)
 static void arp_error_report(struct neighbour *neigh, struct sk_buff *skb)
 {
 	dst_link_failure(skb);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_FAILED);
 }
 
 /* Create and send an arp packet. */
-- 
2.35.1

