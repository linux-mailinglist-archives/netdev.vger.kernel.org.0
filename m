Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315B72D7593
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405924AbgLKM1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405452AbgLKM1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:27:38 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870DFC06179C
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:20 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id h19so13024831lfc.12
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u+zB4aisBlYMRxDkDUv0BdgHZ/QQl8spoPtF5xMzNTQ=;
        b=s74/kpkqpRYIOuTw1+yWS+F3OaDRn/04LLTjGHo/46LVCKqL0ek5NET9q96m6gLDM2
         6AQqdnjCZETRhtPl+LmQzSvVHqrduERFZoqnznoR8NAafZBq/BurgfWuPMCRV8+9odjO
         m7QWbVg+2mTTOgTI2uXzSSfztbHQHmZn6TLTfZPOEvXtdBCdCkGvlD6glqKiCb27Qvb9
         MzVcdvRfYvjk/JXA2LeU0lCNK47VKmrRg0dY+kEegGMAG/xk5H3HtM1E0uWg4t7OPnMQ
         bK/rb8H/+wU+fuTANx5bBXzdy3RJfy68oDe+TM1vtHMxKmE9kj0Z19P9yjB4zmUJliFY
         9jbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u+zB4aisBlYMRxDkDUv0BdgHZ/QQl8spoPtF5xMzNTQ=;
        b=oypdX0YZIxoXv9y28pArEz0kg+t7ljYPzhJ4uQde3bNKY/Ufj15U0Gokn1a5eqlD9r
         lVRRCs/3uGbj3qdsCOxiO7lW0F6+NQWuefylGdFUgavWlNXh4rvDVYZffeLJLabFMBoZ
         8ZFuWuPh6eLXYERdt5SuFD1GTJZDA/ngt0RIJmrqtUglKg959EQuOyWsb1wtTMpQLdsS
         MwrFzHv5DP/1BWUVmwTbs4/Cq7RhHzypNyNACJ5FUkhafQfuhtLf+cyu/N7DDUAvV2sh
         N+csLYnmIhSGYNu9gKtRvDL71NKEmZbmY2MgrAaZvEZ4KRdnorqiRfvMHg1aGsXTpjhm
         OvSg==
X-Gm-Message-State: AOAM531yGRmbygq3X8yKNl0OMhqAfTrkprS86tSt9MOQWAFkkjsE3Ylm
        cJ9gYaB1VI1Wt1IC5MhN4ADbx0XSLSITtg==
X-Google-Smtp-Source: ABdhPJwQtpBtzvnpFjXft3O19GhThHsmHVHfbl7zvGmuPSdTWvQtPn6nBOOwY/BqsVuJDl7PN63Hdw==
X-Received: by 2002:a19:f101:: with SMTP id p1mr2365670lfh.54.1607689578967;
        Fri, 11 Dec 2020 04:26:18 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id s8sm335818lfi.21.2020.12.11.04.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 04:26:18 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 05/12] gtp: set device type
Date:   Fri, 11 Dec 2020 13:26:05 +0100
Message-Id: <20201211122612.869225-6-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201211122612.869225-1-jonas@norrbonn.se>
References: <20201211122612.869225-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the devtype to 'gtp' when setting up the link.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 04d9de385549..a1bb02818977 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -610,6 +610,10 @@ static const struct net_device_ops gtp_netdev_ops = {
 	.ndo_get_stats64	= dev_get_tstats64,
 };
 
+static const struct device_type gtp_type = {
+	.name = "gtp",
+};
+
 static void gtp_link_setup(struct net_device *dev)
 {
 	unsigned int max_gtp_header_len = sizeof(struct iphdr) +
@@ -618,6 +622,7 @@ static void gtp_link_setup(struct net_device *dev)
 
 	dev->netdev_ops		= &gtp_netdev_ops;
 	dev->needs_free_netdev	= true;
+	SET_NETDEV_DEVTYPE(dev, &gtp_type);
 
 	dev->hard_header_len = 0;
 	dev->addr_len = 0;
-- 
2.27.0

