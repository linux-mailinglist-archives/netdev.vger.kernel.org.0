Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02174107FAE
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 18:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfKWRp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 12:45:57 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42135 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbfKWRp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 12:45:57 -0500
Received: by mail-lj1-f195.google.com with SMTP id n5so10976403ljc.9
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 09:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SE04KiO96QAKd04af8C41I8ob7ktg731LIM1UBRR950=;
        b=FfX4lEAhDPL1mWLOCQYjoSrrVCz/Z2Hc7Z4cJA7Kmr34pWmgK+FgDZj0w0Aq0qd3AD
         bVfhYwwjSp63tX6eX3fZLoYLZb9B3bS8YRtm4ThmyYuuyf/HLap2Z3JnHD2RtVOKmwoT
         QL+bCSrpc0J3NRQsjIvSa3eD+Aa+0PUqDaOpzUwYVXyHfZkGIIcqPdR+CEY1PiWLot5G
         2T8jo3OUH9EaTLioipvnJFeQ/0RTXUhjFcBzRCoxB/cFrEpFb/Lvd/X0F24KXuREV/i+
         LmF8mPrx8UPUQOB1xjwMdULGwHNhsd9Kw36FVngnkBQvdUmYcL/bhxt3kg+qR1t6nizB
         qYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SE04KiO96QAKd04af8C41I8ob7ktg731LIM1UBRR950=;
        b=tYIg6Q9E4Q48kfAlYZkEbkuU6cteTHkIDHZP+Hghxd6RvsDwez3helWoqfkrAqzQwt
         cFMv4qLRAOKMcNP3B+zyHYZVGjelJlah/dZXRRMBhAjA3mRZ1Xu5gJ7AwozBzcCZWPQK
         CXOUUvG0PetOye+QJRk3loMyeDWNZFcTEAYSFBepe5ZiZLHVOX+AJKxxnwK3UKnrQ6Ch
         tVt/IURE0EHgtuJcjN2PzqSVSB66Kk+4P+v2NLn2W/m/y58Gc6e4couyIAz1tn3wEHrS
         pvfvZeQ0vqv3uR4jAGPRijvXkAvemAk4QOnNoWWN9TWAFKWjLsLfboOT5yBvvpYZJ/gM
         t7bA==
X-Gm-Message-State: APjAAAUqAfFlYaSkC9TL4tV8zGLMHXupJFt2cgFtP00OK6Ntk8RC36hu
        IeWflKq9LKWZTFSWKkyEQdT/jQ==
X-Google-Smtp-Source: APXvYqw6NqngDhtrC5YfRNKH7jI/d4YRT9bM0BVyfJaBQPsDh2khbUJTTKrNZvM+34GeTvFRBpDCJA==
X-Received: by 2002:a2e:8695:: with SMTP id l21mr16187870lji.53.1574531153518;
        Sat, 23 Nov 2019 09:45:53 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v21sm1097242ljh.53.2019.11.23.09.45.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 09:45:52 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     ecree@solarflare.com, dahern@digitalocean.com,
        netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH net-next] sfc: fix build without CONFIG_RFS_ACCEL
Date:   Sat, 23 Nov 2019 09:45:42 -0800
Message-Id: <20191123174542.5650-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <964dd1b3-b26a-e5ee-7ac2-b4643206cb5f@solarflare.com>
References: <964dd1b3-b26a-e5ee-7ac2-b4643206cb5f@solarflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rfs members of struct efx_channel are under CONFIG_RFS_ACCEL.
Ethtool stats which access those need to be as well.

Reported-by: kbuild test robot <lkp@intel.com>
Fixes: ca70bd423f10 ("sfc: add statistics for ARFS")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/sfc/ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 6a9347cd67f3..b31032da4bcb 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -90,9 +90,11 @@ static const struct efx_sw_stat_desc efx_sw_stat_desc[] = {
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_bad_drops),
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_tx),
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_redirect),
+#ifdef CONFIG_RFS_ACCEL
 	EFX_ETHTOOL_UINT_CHANNEL_STAT_NO_N(rfs_filter_count),
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rfs_succeeded),
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rfs_failed),
+#endif
 };
 
 #define EFX_ETHTOOL_SW_STAT_COUNT ARRAY_SIZE(efx_sw_stat_desc)
-- 
2.23.0

