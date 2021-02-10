Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9060317194
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 21:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbhBJUoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 15:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbhBJUo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 15:44:26 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD32BC061786
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 12:43:45 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id i8so6537163ejc.7
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 12:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OeANL9KGfWTYkUvP2UaZNdk3ZWSmtbVkLQLdr1Sp3lk=;
        b=ZN32C28tGs5zIM1MFD9NBN3weL0pmKx91IhBo/7/8SjFdi3S04V2D1oQKsxDj3FmkI
         H16XmGAPrDpE1yaRho2+XZw2AHoo3rHkhTz/x2eN95v92uIzVF7mipTVvP9H2JKVVfDQ
         2toc5Z8k2vwx7KZk36EfoXUnqgwslwCdxU0tdRXecApJ8Fcp4f0Ka+nRYfu8vmY38H3D
         UACCxe8UIyzh3GBKBhhSwdZ0nYXiOYYEbxRGbbl9fkdhZ7px9cuYAVU/NKWieBn226Nr
         XO6vfies+dNhC5SS/oD5gqMZc0/f4elV3N+sGFx4DLuOZexJFbH+K+TnqVnuhLBdNqcP
         2u8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OeANL9KGfWTYkUvP2UaZNdk3ZWSmtbVkLQLdr1Sp3lk=;
        b=OXP13y0ruz3s93p7f2qCczVFZ/nnkH9sCFpl8Er90c0LpnuEfAHDE+/nSvfg+aCW6u
         k06r3yX0kbdUbnXgRdjkOxlGzq9vfuqLMyT9L/aoWf0IGe8iZvoZXFrkzZvei6O2QFWj
         6loUOemW1tWtgO0rdqMPdkkN0z98Weo+gpb9yhwk7txmQM9qkUQchRLg+EKN+04cya5r
         gTQiXGtAefNVMONwgP0nPwaORInKXrWpfWF/Q1K0eyIMR7bwr9QTKjlV+6SM4DkQRURT
         uTvhZ8bvuUly/jEtNSEHvnCHrcDc4jz9yfCYGmSh1h0I3+X+upj6HU8S78MitmZpTsJK
         n7wA==
X-Gm-Message-State: AOAM530eRrhyI03FvTH01avfEgDfu7+udqh/p/JSH57yScaVEzl4a6Cq
        vcqlaPBz/wW8EVXRSi3LOQsaFarAYAx2yLtZ9Dnb3Q==
X-Google-Smtp-Source: ABdhPJyUu/rcDepjEFIc3DBkriar9KP1pU1WZ1XVlb4GCNj6ks3l5jja7SXTbMv9hq+46CephYdnlw==
X-Received: by 2002:a17:906:43d7:: with SMTP id j23mr4736075ejn.519.1612989824273;
        Wed, 10 Feb 2021 12:43:44 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id l1sm2062655eje.12.2021.02.10.12.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 12:43:43 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, andy@greyhouse.net, j.vosburgh@gmail.com,
        vfalico@gmail.com, kuba@kernel.org, davem@davemloft.net,
        alexander.duyck@gmail.com, idosch@nvidia.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2 1/3] bonding: 3ad: add support for 200G speed
Date:   Wed, 10 Feb 2021 22:43:31 +0200
Message-Id: <20210210204333.729603-2-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210210204333.729603-1-razor@blackwall.org>
References: <20210210204333.729603-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

In order to be able to use 3ad mode with 200G devices we need to extend
the supported speeds.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: no changes

 drivers/net/bonding/bond_3ad.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index aa001b16765a..390e877419f3 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -73,6 +73,7 @@ enum ad_link_speed_type {
 	AD_LINK_SPEED_50000MBPS,
 	AD_LINK_SPEED_56000MBPS,
 	AD_LINK_SPEED_100000MBPS,
+	AD_LINK_SPEED_200000MBPS,
 };
 
 /* compare MAC addresses */
@@ -245,6 +246,7 @@ static inline int __check_agg_selection_timer(struct port *port)
  *     %AD_LINK_SPEED_50000MBPS
  *     %AD_LINK_SPEED_56000MBPS
  *     %AD_LINK_SPEED_100000MBPS
+ *     %AD_LINK_SPEED_200000MBPS
  */
 static u16 __get_link_speed(struct port *port)
 {
@@ -312,6 +314,10 @@ static u16 __get_link_speed(struct port *port)
 			speed = AD_LINK_SPEED_100000MBPS;
 			break;
 
+		case SPEED_200000:
+			speed = AD_LINK_SPEED_200000MBPS;
+			break;
+
 		default:
 			/* unknown speed value from ethtool. shouldn't happen */
 			if (slave->speed != SPEED_UNKNOWN)
@@ -733,6 +739,9 @@ static u32 __get_agg_bandwidth(struct aggregator *aggregator)
 		case AD_LINK_SPEED_100000MBPS:
 			bandwidth = nports * 100000;
 			break;
+		case AD_LINK_SPEED_200000MBPS:
+			bandwidth = nports * 200000;
+			break;
 		default:
 			bandwidth = 0; /* to silence the compiler */
 		}
-- 
2.29.2

