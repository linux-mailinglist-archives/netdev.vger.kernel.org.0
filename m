Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EAA48599A
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243783AbiAET4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:56:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33742 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243777AbiAET4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 14:56:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641412593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZE/0PMrZWO2x1/w3+hWWU/7F65/qXMf+4hY3YrWAdwo=;
        b=YvbRid5UtmkOcXh5Axr72nidN9AzCA5motqXA0GtD510uXY7pc8n+mOVLJDT//HDbgGA09
        GAP+IfokhMqeRNhkRtXnGR9aw4LCYOyBSofX/tWgzQWNFTVdT5OHHhE8dTILJ4URgY2Iwb
        NSogkQtw0Pvx23adHz55h5EUkoECXRU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-3NgIsbSwOBSETfPKdasbpQ-1; Wed, 05 Jan 2022 14:56:32 -0500
X-MC-Unique: 3NgIsbSwOBSETfPKdasbpQ-1
Received: by mail-wm1-f70.google.com with SMTP id n3-20020a05600c3b8300b00345c3fc40b0so2301253wms.3
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 11:56:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZE/0PMrZWO2x1/w3+hWWU/7F65/qXMf+4hY3YrWAdwo=;
        b=xTRoaICtCBKbN9ZQQEKUmiK6509jlteoM6O1ghQVxK+jkDB3c0AdKzW4ecSBCjYs/4
         3UeyRHG8QcmAeLN7azXTz4ivGU52oS8kR5JMPyUZ1FnAp3hQz6pmwjjDuiiZkdx/TP1X
         aiUyi6gRvg+mQ1N+tMV32ffzG58XKv14TFnCiWzT2O2uSp3t2ziEnkgPqhf3mz+pzgFQ
         xYf2N/wi6jjFjf8SJZWDSIbUu60hGNGheu+wM0kZnb63+NdtQntOzl8hyt32RiVo24EQ
         Y/fY/Cw1L/HpfePt25rppBSgIV873l/dIvhdRZGuegit8IWal0rSck6dZqeX1QipvKDQ
         DHow==
X-Gm-Message-State: AOAM530mRipcs3nubeTadVKMjmfKHVPdnyZeOsUYhwenCYw7tiz6XC/7
        H160MoH3FlBAg2S+I9pOyTMltDTk90rSFkN4mcMeg6YSaw7+Qpe4d3I4uVWZxI53EnY3S6birIQ
        98JITANnDvfUNy9yZ
X-Received: by 2002:a05:6000:1366:: with SMTP id q6mr1884188wrz.551.1641412590723;
        Wed, 05 Jan 2022 11:56:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy4Gcm5HZyFcGx6Uo3mDJoaiWkckllmSvcL5zCVS3l1YkcLkxIs8yLB7NJleBzjW/x/XTIUzA==
X-Received: by 2002:a05:6000:1366:: with SMTP id q6mr1884180wrz.551.1641412590590;
        Wed, 05 Jan 2022 11:56:30 -0800 (PST)
Received: from pc-1.home (2a01cb058d24940001d1c23ad2b4ba61.ipv6.abo.wanadoo.fr. [2a01:cb05:8d24:9400:1d1:c23a:d2b4:ba61])
        by smtp.gmail.com with ESMTPSA id i12sm42424859wrp.96.2022.01.05.11.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 11:56:29 -0800 (PST)
Date:   Wed, 5 Jan 2022 20:56:28 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: [PATCH net 4/4] mlx5: Don't accidentally set RTO_ONLINK before
 mlx5e_route_lookup_ipv4_get()
Message-ID: <a0ba792bbbf088882a55507c932f1abec915c3b6.1641407336.git.gnault@redhat.com>
References: <cover.1641407336.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1641407336.git.gnault@redhat.com>
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

