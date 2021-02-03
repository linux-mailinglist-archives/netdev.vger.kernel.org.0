Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666AF30D3E6
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 08:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhBCHJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 02:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbhBCHJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 02:09:31 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8595DC06178A
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 23:08:14 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id a25so27097446ljn.0
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 23:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uEnUir7NULfyhfcHWwSmbaRoX9scIfA0jMqc4I/U48c=;
        b=ZGZcdabvWHlf+jUXykVA5NeDRmuGmE9m43aL21YQg0bjDhJ4HYcaYfSiJ/B6oTOuZV
         fUcuBwdzAL2yo1899Tu+M+549ZIHW+9NERMmO6HkmjdJCQhA/b+skR5f3F5ODD+5PcpN
         cSwB1ZH0piufRTunWFsHscogA9beB0O62R7YHoeg1RRjivwz8l+3vT6RasYYDeIUSIrz
         kKmdHwGc0OdTMD8ULgB6ElIgOlMTL7mLVAZ3PJ9Hj34qSKd0jC63M9P7Dm9SgK0ID5dZ
         +rbotxaoNamFU7nErbpGshgq8xXrehooO0tpeq8TEeNWfmZFFWZNTMgtW/OnObWCGrhF
         gTgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uEnUir7NULfyhfcHWwSmbaRoX9scIfA0jMqc4I/U48c=;
        b=rrvmAi0ZQAMPDkRAN1AjFqa/WG/Bc6V0u/QgPrZ8/cULmF8kA/biG5JXa/qITACYXG
         DVN5EhHclCMAcMHI7q/Obe64gxQ6cY7KMSBSIvAb/ek19MUeK8ZvGo5PpQ1fbRoF090n
         2IqYdVtpmCzQ6ImvBz+EPJ0pa7f/iaDGnqJw2JYbgzFcGMKurKGm3iqDy+N52mqxyWNA
         fubTBZBgdkJRuMx1j12+vvTCNSMThz+G8oyxPkEF8oaKF9/dHLQxRkCLg5EkRipGzAMN
         CHjj8XtNx98MWS7RZ6CYz6eKKnVHeX9LjdoIfcsO+WZ/rCPO2TKI1doaFUVfjf5k0gqr
         JYjA==
X-Gm-Message-State: AOAM533bH9a3eBoDETG7V0ENuN6rH1RKAxGL0HvQpaUHDa12xlhYTa8y
        4EgFLythDEy5Jy++lH+OkZA0Fg==
X-Google-Smtp-Source: ABdhPJxEQNW/OeCtMmYK85ZJ/2Pjotrwz3oLhbzm5jabpVSK5yeCQzkI2fxVsPdz1/F+CigFDAhFWQ==
X-Received: by 2002:a2e:6c02:: with SMTP id h2mr953711ljc.277.1612336092970;
        Tue, 02 Feb 2021 23:08:12 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id d3sm147367lfg.122.2021.02.02.23.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 23:08:12 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Cc:     Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 6/7] gtp: set device type
Date:   Wed,  3 Feb 2021 08:08:04 +0100
Message-Id: <20210203070805.281321-7-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210203070805.281321-1-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
 <20210203070805.281321-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the devtype to 'gtp' when setting up the link.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Harald Welte <laforge@gnumonks.org>
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

