Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFDA50ABA2
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 00:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391850AbiDUWsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 18:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383069AbiDUWsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 18:48:18 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E77C4552A;
        Thu, 21 Apr 2022 15:45:27 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id hf18so4392245qtb.0;
        Thu, 21 Apr 2022 15:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Avzb9cPznIodZfUy9syBNKrwQrszHEnglyfet/YgVsc=;
        b=JAKqUSyQ//H2HGk1D1Uz4/fNWeCFHlMXaS4F2SznucIZZY9cksMSToyNDoypUzpxNH
         GNOrp1wkR6lpzZutDFVGWRMPcY0HsXYsR0lttjn8OARMFErUNog6JC/kR0En/taRgXS3
         DVMExq8xhuTgb58ELb3NBLEdUM9evw85yOv8gdPzT3NjLAmzCRdHBTmn2EbEAX+Cvcfc
         5hPRcmAUMio8/PNeTRBA+vgCnbmFzf98SqZj/TKWMLhKAhaj+aM0e9fa8e5PXWcI2JGw
         vUPuQ3QBpSb00023UwbV+es3e7Lu6RY/VoccMxSqfwAmDaYlC1ykLJAmz1OmtsMrVT4h
         iIgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Avzb9cPznIodZfUy9syBNKrwQrszHEnglyfet/YgVsc=;
        b=jXyG48y5HlqkmfxNtJvUzVm4umNDbKlMvvsaPic2qmxz4aos367eBo9K1Uw1/MEKft
         GOkd4MGKJ6U3ltktyrAO5NLIl2GsvjXhjA2bY6QFZZGkwjaFlOqFiR7swQFKAWSjMWTG
         g82mUeX2scf0p68kfO4Fal97k8p0lwQPtWmyAI64e97Nd6dCFmGzPc5dYr92CEWPDZhp
         3llZlHDnBFSpEwbort7pkJ8wbkBLYMXixPei6USWK7OyiSnXEtsps+BnsWJ+mbCGFlHk
         BczY9vNWl6ZmNSbKTCi9APK7eiURjQ9D8OBWPLwoQPjcRygciD2vylIHGGk6zem5Dpf1
         RXZQ==
X-Gm-Message-State: AOAM531BCOls2iiWripbmEq+fMkElLvUXDJyEWhUWfgTOyj2nvh/a6xi
        tTekIdWP4NC4D5ZwYVw+0g==
X-Google-Smtp-Source: ABdhPJz1DMMf+A8vueHnenV7mmSzpnr3Fl/F2nXEDYp5Wig7ajZ3KKZppvGQDl/fxIa+sxsdtJ2hSg==
X-Received: by 2002:ac8:5855:0:b0:2f3:3eb4:51ee with SMTP id h21-20020ac85855000000b002f33eb451eemr1252301qth.644.1650581126629;
        Thu, 21 Apr 2022 15:45:26 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id x13-20020a05620a258d00b0069c7468e123sm129831qko.122.2022.04.21.15.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 15:45:26 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net-next 2/2] ip6_gre: Make IP6GRE and IP6GRETAP devices always NETIF_F_LLTX
Date:   Thu, 21 Apr 2022 15:45:02 -0700
Message-Id: <f3d8ad04d0652fcbd95d3b22490123815cf66ba7.1650580763.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1650580763.git.peilin.ye@bytedance.com>
References: <cover.1650580763.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Recently we made o_seqno atomic_t.  Stop special-casing TUNNEL_SEQ, and
always mark IP6GRE[TAP] devices as NETIF_F_LLTX, since we no longer need
the TX lock (&txq->_xmit_lock).

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/ipv6/ip6_gre.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 5136959b3dc5..4e37f7c29900 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -382,11 +382,6 @@ static struct ip6_tnl *ip6gre_tunnel_locate(struct net *net,
 		goto failed_free;
 
 	ip6gre_tnl_link_config(nt, 1);
-
-	/* Can use a lockless transmit, unless we generate output sequences */
-	if (!(nt->parms.o_flags & TUNNEL_SEQ))
-		dev->features |= NETIF_F_LLTX;
-
 	ip6gre_tunnel_link(ign, nt);
 	return nt;
 
@@ -1445,26 +1440,23 @@ static void ip6gre_tunnel_setup(struct net_device *dev)
 static void ip6gre_tnl_init_features(struct net_device *dev)
 {
 	struct ip6_tnl *nt = netdev_priv(dev);
+	__be16 flags;
 
-	dev->features		|= GRE6_FEATURES;
+	dev->features		|= GRE6_FEATURES | NETIF_F_LLTX;
 	dev->hw_features	|= GRE6_FEATURES;
 
-	if (!(nt->parms.o_flags & TUNNEL_SEQ)) {
-		/* TCP offload with GRE SEQ is not supported, nor
-		 * can we support 2 levels of outer headers requiring
-		 * an update.
-		 */
-		if (!(nt->parms.o_flags & TUNNEL_CSUM) ||
-		    nt->encap.type == TUNNEL_ENCAP_NONE) {
-			dev->features    |= NETIF_F_GSO_SOFTWARE;
-			dev->hw_features |= NETIF_F_GSO_SOFTWARE;
-		}
+	flags = nt->parms.o_flags;
 
-		/* Can use a lockless transmit, unless we generate
-		 * output sequences
-		 */
-		dev->features |= NETIF_F_LLTX;
-	}
+	/* TCP offload with GRE SEQ is not supported, nor can we support 2
+	 * levels of outer headers requiring an update.
+	 */
+	if (flags & TUNNEL_SEQ)
+		return;
+	if (flags & TUNNEL_CSUM && nt->encap.type != TUNNEL_ENCAP_NONE)
+		return;
+
+	dev->features |= NETIF_F_GSO_SOFTWARE;
+	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 }
 
 static int ip6gre_tunnel_init_common(struct net_device *dev)
-- 
2.20.1

