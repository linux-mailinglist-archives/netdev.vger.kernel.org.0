Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4822EAAAA
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 13:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbhAEM0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 07:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729183AbhAEM0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 07:26:05 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981BAC0617B9
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 04:24:41 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id q18so36043197wrn.1
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 04:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vUG4KrkwS/48VCqb3gPEYEavBv7WJyPV6SrQz/KaLAM=;
        b=JguxiQSaUv6GGwqarkI4f+dXsBJW3n0KkyJDT3BnbU1VaRJXjiAGj0JuAujNpX7oJp
         4+1wushqPCLsluacp/kpfkNPv0w1FjcYLdcO9VFhA0A04eKqBcNKVgjJRbAMw0v0ac1r
         7VpQqn/J1idqy6nzVKnjdQyJn89kLUBslkXVS6NZtFBkz86LQi1Fp8u6dw+GW35RLzBs
         uhy9Fktpf7b/oXCfl2vEqDcKR2gmxfyVngJgf6WU3F0uFyKOn0pYpNnZ8reEhaeVXuB+
         wQ8YJRPOu6Lv4BWQ+LVyl7fBWbVJQU7f7qe5NwHyza9IBEb7CmWpD+Y3Yy4VbUgQryBy
         FK/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vUG4KrkwS/48VCqb3gPEYEavBv7WJyPV6SrQz/KaLAM=;
        b=XA2VQ53WYCHINywnMnwPAwZDGoJNhzl5qoPg9f2rxUoU5gdCpOusV0s1WJVkG2ULqr
         etGV+rHqgymHyEynL71AqBwG3Azi6gtpT8rLWkf9YqLaPOguzbN8+0UeYck9a+WPl5QB
         W52oh/rnJ9hPdLKf8ZWcpQo2J1/KgcI3dqHZr5M5qXS5cSe4CblggO638ymXvsrdhINX
         TSTd9ueyXGIoZ30kwNhCFuDsyEXIopCUORysgkO00ROh+Q+8/gWbRKRzronHMoa3XVpF
         77r7BREHgbJWBwY1ssuT2rM4b9QbwltfsXxPSStDXX84POEb7GxXfYfQzehMOhS0gx7w
         bjzg==
X-Gm-Message-State: AOAM530/uPgCNuJW0C66ZMx6SFToCttXbaOP6SSTQd6x2vZVpvrlDZ3J
        Z52GcYJEYjx5fQt084sdztAjgQ==
X-Google-Smtp-Source: ABdhPJxyHqkDMckR34D6J0/zEz5z+4AYLnYjJYaIBFFxajHjIK8UpmQDSJm/1GZJWoM1KCiS6UmSig==
X-Received: by 2002:adf:b519:: with SMTP id a25mr72616195wrd.263.1609849480376;
        Tue, 05 Jan 2021 04:24:40 -0800 (PST)
Received: from f2.redhat.com (bzq-79-183-72-147.red.bezeqint.net. [79.183.72.147])
        by smtp.gmail.com with ESMTPSA id 138sm4242281wma.41.2021.01.05.04.24.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Jan 2021 04:24:39 -0800 (PST)
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     yan@daynix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 7/7] tun: report new tun feature IFF_HASH
Date:   Tue,  5 Jan 2021 14:24:16 +0200
Message-Id: <20210105122416.16492-8-yuri.benditovich@daynix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105122416.16492-1-yuri.benditovich@daynix.com>
References: <20210105122416.16492-1-yuri.benditovich@daynix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IFF_HASH feature indicates that the tun supports
TUNSETHASHPOPULATION ioctl and can propagate the hash
data to the virtio-net packet.

Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
---
 drivers/net/tun.c           | 2 +-
 include/uapi/linux/if_tun.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 214feb0b16fb..b46aa8941a9d 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -88,7 +88,7 @@ static void tun_default_link_ksettings(struct net_device *dev,
 #define TUN_VNET_LE     0x80000000
 #define TUN_VNET_BE     0x40000000
 
-#define TUN_FEATURES (IFF_NO_PI | IFF_ONE_QUEUE | IFF_VNET_HDR | \
+#define TUN_FEATURES (IFF_NO_PI | IFF_ONE_QUEUE | IFF_VNET_HDR | IFF_HASH |\
 		      IFF_MULTI_QUEUE | IFF_NAPI | IFF_NAPI_FRAGS)
 
 #define GOODCOPY_LEN 128
diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
index 0fd43533da26..116b84ede3a0 100644
--- a/include/uapi/linux/if_tun.h
+++ b/include/uapi/linux/if_tun.h
@@ -73,6 +73,7 @@
 #define IFF_ONE_QUEUE	0x2000
 #define IFF_VNET_HDR	0x4000
 #define IFF_TUN_EXCL	0x8000
+#define IFF_HASH	0x0080
 #define IFF_MULTI_QUEUE 0x0100
 #define IFF_ATTACH_QUEUE 0x0200
 #define IFF_DETACH_QUEUE 0x0400
-- 
2.17.1

