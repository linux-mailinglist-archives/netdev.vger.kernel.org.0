Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A733A493D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhFKTIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:08:41 -0400
Received: from mail-il1-f172.google.com ([209.85.166.172]:39780 "EHLO
        mail-il1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhFKTIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:08:36 -0400
Received: by mail-il1-f172.google.com with SMTP id j14so3304346ila.6
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DkdobZLTpAD7sZOMj4GkrrzOua/xsro4YIT+dik7/Ds=;
        b=ZUDQ4fWalntmuoOOcLIhCQopK+ZdcXhpdPCYSNHYpAn1QF1RzoI27kDENKLMKQw91N
         3B/JDELX8q8LVVeyCgYf7yxDHUQ0yDIqhXoAWoYbO5ScOSd94l3+GoVTxmGR31p1ycTI
         TTCrDOWOaen9tPNLONlh8X6p+pL+l+8A7NmNfOtuzaheQN6XSFs2sIrRHsbXDuiSnS0E
         d0L5LBZWHPJj+2qj5BlN1y1veEBULm2OPgVbcYvT9anpB804cIzhJakoErCW/PZunnEp
         k/LQZN4mJ1J8lKulpGRbZUFP5HFJLyCePD3gjmUZcAz0zQD/MdjvZuNe1lFW8VFQg1Wx
         ZuLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DkdobZLTpAD7sZOMj4GkrrzOua/xsro4YIT+dik7/Ds=;
        b=pO2zdIeqeEmbatnWrYF0diZwwUUKaBJ5ANkEhxThaRTT6QuJw1fq2Bcpvk+QFk0lSX
         aXBAfKFZjkhOh4QZ+Nid5ljtboNFzLJqHwxEM4gzTRVs50aQP9HDGVpmcDO7CoZaCZ/o
         e7hUgaeWon5silOy9UjMpI8MwDZOnCgyvQDhB/AiFB8WtekqPF9g3zKGuv43EhDUsjN1
         7YCShyxoE4O7POUOS80eU4vL84y3W2BgZye4T6LKg4xJmuMgsZ2g7GckunczrJmkV7/y
         iWM2aCHb5CQt5mBO9G+eHI8jLvjtj+b0AUXvNTbp5tNRVf7q0pXunxMisvhYFQDmTiI7
         Ring==
X-Gm-Message-State: AOAM531rUNT7WrPiJyY+29l3k1tpWH0rOWX4dfGg/+QgAx28x74F0we8
        yxm9hkCEBMsoRpdlEeCFhlWkzQ==
X-Google-Smtp-Source: ABdhPJzu4FiXU1nqeV5PjlVrZmqoXrVw0A2S6+YiqWHi8l0T/WHBIYbSCNMGGdCHpcojoq+NV1pkpQ==
X-Received: by 2002:a92:7312:: with SMTP id o18mr4074395ilc.289.1623438337341;
        Fri, 11 Jun 2021 12:05:37 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p9sm3936566ilc.63.2021.06.11.12.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:05:37 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/8] net: qualcomm: rmnet: get rid of some local variables
Date:   Fri, 11 Jun 2021 14:05:24 -0500
Message-Id: <20210611190529.3085813-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210611190529.3085813-1-elder@linaro.org>
References: <20210611190529.3085813-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value passed as an argument to rmnet_map_ipv4_ul_csum_header()
is always an IPv4 header.  Rather than using a local variable, just
have the type of the argument reflect the proper type.

In rmnet_map_ipv6_ul_csum_header() things are defined a little
differently, but make the same basic change there.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index b8e504ac7fb1e..ca07b87d7ed71 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -195,15 +195,14 @@ static void rmnet_map_complement_ipv4_txporthdr_csum_field(void *iphdr)
 }
 
 static void
-rmnet_map_ipv4_ul_csum_header(void *iphdr,
+rmnet_map_ipv4_ul_csum_header(struct iphdr *iphdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	struct iphdr *ip4h = iphdr;
 	u16 val;
 
 	val = MAP_CSUM_UL_ENABLED_FLAG;
-	if (ip4h->protocol == IPPROTO_UDP)
+	if (iphdr->protocol == IPPROTO_UDP)
 		val |= MAP_CSUM_UL_UDP_FLAG;
 	val |= skb->csum_offset & MAP_CSUM_UL_OFFSET_MASK;
 
@@ -231,15 +230,14 @@ static void rmnet_map_complement_ipv6_txporthdr_csum_field(void *ip6hdr)
 }
 
 static void
-rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
+rmnet_map_ipv6_ul_csum_header(struct ipv6hdr *ipv6hdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	struct ipv6hdr *ip6h = ip6hdr;
 	u16 val;
 
 	val = MAP_CSUM_UL_ENABLED_FLAG;
-	if (ip6h->nexthdr == IPPROTO_UDP)
+	if (ipv6hdr->nexthdr == IPPROTO_UDP)
 		val |= MAP_CSUM_UL_UDP_FLAG;
 	val |= skb->csum_offset & MAP_CSUM_UL_OFFSET_MASK;
 
@@ -248,7 +246,7 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
 
 	skb->ip_summed = CHECKSUM_NONE;
 
-	rmnet_map_complement_ipv6_txporthdr_csum_field(ip6hdr);
+	rmnet_map_complement_ipv6_txporthdr_csum_field(ipv6hdr);
 }
 #endif
 
-- 
2.27.0

