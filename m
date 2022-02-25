Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE294C3EE3
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 08:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238091AbiBYHTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 02:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238076AbiBYHTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 02:19:46 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629D82556C0;
        Thu, 24 Feb 2022 23:19:15 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id ay5so1244789plb.1;
        Thu, 24 Feb 2022 23:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E0+eJj0NPmwxnSMx1LXVXrNLUrIv19z+ZDO3nRYWhjc=;
        b=k/pEWWW6X/hqR9vnSIx3bzWbSddiohoBL5Z9bYLhbkMAEaOZCaeLYuPXM7JTemYGBp
         KK8t3lLu7nPAEMe8vez0Q6DfQyHAsLWD6lYrFfb3ixt2+Yh8pyjMVZa8SdNf0YGw6iDr
         7q91IehIq+agA/FMKGdm+7mZUM4wfkwWPtTXj+7DprGCKl7YhCKAgXvvN0cI2SDj5U7k
         BEE7trsIvpkOGWuoWcuqZIJMWQjKmYd4p7VO7hnAkhhQk3TRNr+54+XQUm3MKF6clJWe
         DrBH92PXaYmgeFOwK0UjSk5YBalKm6ULRS4XAUmjOv/NpnAy2+ZDet8KbrCfcSBIm5Lh
         +mmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E0+eJj0NPmwxnSMx1LXVXrNLUrIv19z+ZDO3nRYWhjc=;
        b=eIhJByzknzv3lFMdJ/LjE4T6NAroitMndfMIJuXL8bq2cHTlP78pv01QoLHYVcMOnW
         WVXiKMxBls3srfAccxx9lXVBZGwB6JQfJxY5NsjJ8o8jDTyLuW8FKhQVrHWjajZH8QaT
         201E+j8TfXC2HtKD40zqb1RK4PaxypDGItB2R68YWedYbundLXDekRJmKuyonYm13Rj8
         hL6E3q9w8zWAG9JXYGuQIbRr/lcKSIsGs/FlsrkFDq+N+rDtGUj7rRapscSTMqJteNoF
         uyKKfDnSKQls7FmwXyebUUUlB6ADXmo/L1oeV3NqtDnYgWwMRA6uCeN47dJJRRgV5Ips
         VL/w==
X-Gm-Message-State: AOAM532H5cDTZh4EFTDYorHeMq/Vllxx6Udvc9ZRz80PcHSEyXHhPryA
        04usHnoNdsfGNSLih8VDu9o=
X-Google-Smtp-Source: ABdhPJx/GspNgT1HedneD8W+NwDS4/Mqz7t7PINI35XqkIYVCY0t4kSNPeGXkbyCq36t20SQt48Juw==
X-Received: by 2002:a17:90b:4394:b0:1bc:e369:1f2b with SMTP id in20-20020a17090b439400b001bce3691f2bmr1912128pjb.92.1645773554889;
        Thu, 24 Feb 2022 23:19:14 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.gmail.com with ESMTPSA id k20-20020a056a00135400b004ecc81067b8sm1970825pfu.144.2022.02.24.23.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 23:19:14 -0800 (PST)
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
Subject: [PATCH net-next v2 3/3] net: neigh: add skb drop reasons to arp_error_report()
Date:   Fri, 25 Feb 2022 15:17:39 +0800
Message-Id: <20220225071739.1956657-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220225071739.1956657-1-imagedong@tencent.com>
References: <20220225071739.1956657-1-imagedong@tencent.com>
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

