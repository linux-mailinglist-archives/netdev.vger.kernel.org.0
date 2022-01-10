Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9069A489A38
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbiAJNnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:43:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233136AbiAJNnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:43:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641822199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZE/0PMrZWO2x1/w3+hWWU/7F65/qXMf+4hY3YrWAdwo=;
        b=gedU7/lCEV5KRacQZvFXcblNAo/UXBPDR+naPHwvLWSpP9xAPHHj8k93PxKDR4ZFzHcd/r
        ARhymAL6H3WiqO0EOb/sQQoXMVYKR94wpMmmIewH9ixcqk4QeSIzkmyHktrJYMLO8WFIST
        L+u7gGNQ7XT8SQlRjyqA1NdhsD1n3H4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-3EHD-tYCMGaDWlHkVyT-Hg-1; Mon, 10 Jan 2022 08:43:18 -0500
X-MC-Unique: 3EHD-tYCMGaDWlHkVyT-Hg-1
Received: by mail-wm1-f69.google.com with SMTP id az9-20020a05600c600900b0034692565ca8so7903813wmb.9
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 05:43:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZE/0PMrZWO2x1/w3+hWWU/7F65/qXMf+4hY3YrWAdwo=;
        b=7FYjOvkWmaj53+HtcjPw9p7xu6Aag7BaFS+/neklK4YWtWUIeckH3GOmFpriXHenCP
         AtPGxMaCZKJZfzS83vIAUaOUaUvQmGepUBED9nlzxCWuU98kxo/UjE/X99cYwwhkzZad
         taZOg6ZfYXFQGKFgqUDgq/ak1OR+siDe87s+csj/xMohzW2oNdutj1bhYeW46ZEAIaW7
         XHrhMGRxVqiOPVCPiW0iXAGKTqlpOl+LSMPHlzWK07lGNjTIk19oQ8uUG4w6O15cmcSR
         WfgbxgLMrhwecJ/0JxpQJLOqbHW3UJ4k2KX35qxiajeM7kgRZouoEpIzfz1KjECbarO4
         7IEA==
X-Gm-Message-State: AOAM531FBpX1ZGsB25QaklaU1Z/OJCShhok5aI9XQIVVc2JFxUWrzXRE
        D7GKuu3XP0kr4hqAbb4YVEbQkNeyedoLyQjc8RO24Ghr21/jFXeqD+UQIm/XpEB4psKKjj0ELmV
        1y8+cHi/rg5HjgifH
X-Received: by 2002:a05:600c:1d95:: with SMTP id p21mr9565494wms.9.1641822196640;
        Mon, 10 Jan 2022 05:43:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwgHin43f7vvFbvDBL3j7iDsg0f0CMJ5VDZDD69+y7eb6JgK4s7rE4/RSKkrSdGwUpu2PSM4A==
X-Received: by 2002:a05:600c:1d95:: with SMTP id p21mr9565487wms.9.1641822196500;
        Mon, 10 Jan 2022 05:43:16 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id m39sm6720316wms.33.2022.01.10.05.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 05:43:16 -0800 (PST)
Date:   Mon, 10 Jan 2022 14:43:14 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: [PATCH v2 net 4/4] mlx5: Don't accidentally set RTO_ONLINK before
 mlx5e_route_lookup_ipv4_get()
Message-ID: <71c755ca1949c8b6963fb8391737d787e1e83aa4.1641821242.git.gnault@redhat.com>
References: <cover.1641821242.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1641821242.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mask the ECN bits before calling mlx5e_route_lookup_ipv4_get(). The
tunnel key might have the last ECN bit set. This interferes with the
route lookup process as ip_route_output_key_hash() interpretes this bit
specially (to restrict the route scope).

Found by code inspection, compile tested only.

Fixes: c7b9038d8af6 ("net/mlx5e: TC preparation refactoring for routing update event")
Fixes: 9a941117fb76 ("net/mlx5e: Maximize ip tunnel key usage on the TC offloading path")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index a5e450973225..bc5f1dcb75e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
 /* Copyright (c) 2018 Mellanox Technologies. */
 
+#include <net/inet_ecn.h>
 #include <net/vxlan.h>
 #include <net/gre.h>
 #include <net/geneve.h>
@@ -235,7 +236,7 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 	int err;
 
 	/* add the IP fields */
-	attr.fl.fl4.flowi4_tos = tun_key->tos;
+	attr.fl.fl4.flowi4_tos = tun_key->tos & ~INET_ECN_MASK;
 	attr.fl.fl4.daddr = tun_key->u.ipv4.dst;
 	attr.fl.fl4.saddr = tun_key->u.ipv4.src;
 	attr.ttl = tun_key->ttl;
@@ -350,7 +351,7 @@ int mlx5e_tc_tun_update_header_ipv4(struct mlx5e_priv *priv,
 	int err;
 
 	/* add the IP fields */
-	attr.fl.fl4.flowi4_tos = tun_key->tos;
+	attr.fl.fl4.flowi4_tos = tun_key->tos & ~INET_ECN_MASK;
 	attr.fl.fl4.daddr = tun_key->u.ipv4.dst;
 	attr.fl.fl4.saddr = tun_key->u.ipv4.src;
 	attr.ttl = tun_key->ttl;
-- 
2.21.3

