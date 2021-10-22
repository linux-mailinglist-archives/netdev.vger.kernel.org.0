Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC7943808E
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhJVXX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231134AbhJVXX1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 19:23:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CCA461038;
        Fri, 22 Oct 2021 23:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634944869;
        bh=90WgwJ2/Q8UZPeqLyAPiPwa+ctjWED0jnKnnZUXmxaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnE26ypb/cF3trkGr2MldcsaFQeECYOZpuvn7g2d1TKkA/UlE3iVwbVul10//8bGh
         MjKUt582MnvyfAZx6O6k2JFTTn1t0lCYoluNytmX4NNgBgY9R4dzITMz2VFoj8q8VH
         06mOVntzzuC4n4ONhYNv6diYw8RC9veDSzAG3mSchkxDEk7+Jr3bFGmEKH/SmlHwEO
         J/sHuOxno2ymg8TCObX90CauwlllNGJgzBU4xqQKfnIH7K3JtXneihzgWKc4rhkzdr
         e8tkulK8RbhUf1dCaar0IqJMiSctpp++2G4umVUbBnP7f+NPVbHeJI91vxYG+rtg5n
         DWkqaHqcxQtow==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/8] net: core: constify mac addrs in selftests
Date:   Fri, 22 Oct 2021 16:20:56 -0700
Message-Id: <20211022232103.2715312-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022232103.2715312-1-kuba@kernel.org>
References: <20211022232103.2715312-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get it ready for constant netdev->dev_addr.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/selftests.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/selftests.c b/net/core/selftests.c
index 9077fa969892..acb1ee97bbd3 100644
--- a/net/core/selftests.c
+++ b/net/core/selftests.c
@@ -15,8 +15,8 @@
 #include <net/udp.h>
 
 struct net_packet_attrs {
-	unsigned char *src;
-	unsigned char *dst;
+	const unsigned char *src;
+	const unsigned char *dst;
 	u32 ip_src;
 	u32 ip_dst;
 	bool tcp;
@@ -173,8 +173,8 @@ static int net_test_loopback_validate(struct sk_buff *skb,
 				      struct net_device *orig_ndev)
 {
 	struct net_test_priv *tpriv = pt->af_packet_priv;
-	unsigned char *src = tpriv->packet->src;
-	unsigned char *dst = tpriv->packet->dst;
+	const unsigned char *src = tpriv->packet->src;
+	const unsigned char *dst = tpriv->packet->dst;
 	struct netsfhdr *shdr;
 	struct ethhdr *ehdr;
 	struct udphdr *uhdr;
-- 
2.31.1

