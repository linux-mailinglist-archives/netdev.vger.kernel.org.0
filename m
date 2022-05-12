Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE5B524663
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350659AbiELHD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350662AbiELHDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:03:53 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC33D5BE62
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 00:03:52 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id v11so3989977pff.6
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 00:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GABMqLgwWeu95XjH6vsgTOCkqRPeiyHXoqd4lJXLelU=;
        b=R7BFX2j8pjJphFcOM25mroNVwy8hbcaDkC+IRlAOq/my3lHRSi+5WzbrZ0Ko2uBBjf
         6SzuRqVzThO/tWwIPtyb3fTHsapcvgUY6l65On8SMdJ5bDxfHUlVtlDKnygARKlI7s9R
         yUtSvFkn5XRwIR6c8Dvg3XB3HsQVIpqQkaXn+RYfKwG2HJzx8g/A57Y5oFZKipJJkVED
         J7IS7ux3wRphran0jmiS6IoyhhlGfuQmU+vnMNv/ewdsvdLzuSxt6JAUPBmIJvOvcJqg
         V/+uNMLikgz4mMciBO7mewDNH/mHzNTXJrXcQ7v3XB0npoZg1ejFogacgQExFfdvSMLh
         IpJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GABMqLgwWeu95XjH6vsgTOCkqRPeiyHXoqd4lJXLelU=;
        b=H0FdF4ZR/XNekhCqlaQjzeXVn5+YxcOI5m85VBu62qdus8dMH3FCeruHOoE6m4U3XB
         fIE2w1iUzuisTTgxP9j23eoVRn2Z1fdfqqWS6TdDavxp5Ojc7vDZLc5oFMFpYbXQEmHF
         BvYgRrqVd60/v2+Tlp4zWJqY2fb+mLj56HiHCaWN5LhLNvbp1AjYgVSlxX15F+I64y3y
         DSEHo4dX4BfRSFp6UB+Sla8lrf9zWcKo2Xo58bXNsiVKTP8abLMTr/alYJ1vNSbSVqjH
         tn++FV2a24cJOJx8nA9hv9OHaO6b0/c7Knd8CqNZw/qD5g4Dgoi2EPedRi3MZIEJD4rg
         MpXQ==
X-Gm-Message-State: AOAM530qqJQ9IH0tA1bTFKk1zBcjjctPTI84HjSL0c00mREt1Bqjvd2J
        XqEKlHExtO8zkDg87KcIRu3gyXK7cCKpSjNy1PI=
X-Google-Smtp-Source: ABdhPJwRz3apZeksF+k0qHVHqwmDOi75ntv2t2D1Ebd83j+LBI7DdfGI7sULrBfIWNqXRQeSqP33Ng==
X-Received: by 2002:a05:6a00:124f:b0:510:7d6d:ecb2 with SMTP id u15-20020a056a00124f00b005107d6decb2mr28413882pfi.82.1652339032279;
        Thu, 12 May 2022 00:03:52 -0700 (PDT)
Received: from localhost.localdomain ([49.37.196.1])
        by smtp.gmail.com with ESMTPSA id 9-20020a630009000000b003db072fd9adsm1043731pga.74.2022.05.12.00.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 00:03:51 -0700 (PDT)
From:   Saranya_PL <plsaranya@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Saranya_Panjarathina@dell.com, g_balaji1@dell.com,
        Saranya_PL <plsaranya@gmail.com>
Subject: [PATCH net-next] net: PIM register decapsulation and Forwarding.
Date:   Thu, 12 May 2022 00:01:38 -0700
Message-Id: <20220512070138.19170-1-plsaranya@gmail.com>
X-Mailer: git-send-email 2.20.1
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

PIM register packet is decapsulated but not forwarded in RP

__pim_rcv decapsulates the PIM register packet and reinjects for forwarding
after replacing the skb->dev to reg_dev (vif with VIFF_Register)

Ideally the incoming device should be same as skb->dev where the
original PIM register packet is received. mcache would not have
reg_vif as IIF. Decapsulated packet forwarding is failing
because of IIF mismatch. In RP for this S,G RPF interface would be
skb->dev vif only, so that would be IIF for the cache entry.

Signed-off-by: Saranya_PL <plsaranya@gmail.com>
---
 net/ipv4/ipmr.c  | 2 +-
 net/ipv6/ip6mr.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 13e6329784fb..7b9586335fb7 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -598,7 +598,7 @@ static int __pim_rcv(struct mr_table *mrt, struct sk_buff *skb,
 	skb->protocol = htons(ETH_P_IP);
 	skb->ip_summed = CHECKSUM_NONE;
 
-	skb_tunnel_rx(skb, reg_dev, dev_net(reg_dev));
+	skb_tunnel_rx(skb, skb->dev, dev_net(skb->dev));
 
 	netif_rx(skb);
 
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 4e74bc61a3db..147e29a818ca 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -566,7 +566,7 @@ static int pim6_rcv(struct sk_buff *skb)
 	skb->protocol = htons(ETH_P_IPV6);
 	skb->ip_summed = CHECKSUM_NONE;
 
-	skb_tunnel_rx(skb, reg_dev, dev_net(reg_dev));
+	skb_tunnel_rx(skb, skb->dev, net);
 
 	netif_rx(skb);
 
-- 
2.20.1

