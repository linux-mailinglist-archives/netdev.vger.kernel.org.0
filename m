Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CB6317198
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 21:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbhBJUpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 15:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbhBJUos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 15:44:48 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC440C06178A
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 12:43:47 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id s11so4623750edd.5
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 12:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bAD7uqVBt9z/Yn17SCW6bFz5mIqxunvQE9EQMuF/uro=;
        b=Ui0+I1XqjlmzqGhKevVmLmTbtsIA6Ia2b7as0B0wendmBWiPO6IC8w87wXGtkP70GO
         el28+sUDxWV57jju4raX2UJfYiAN9+wD5b0gCyKfuwr5RoMi/YWkN3XD0Wi5ilVZX4Bp
         MMgNIpzGFJzIAWpbN12/EN2U/206jL6+Z4ijTdvnngTSSBR1DJS+vBO04tuqO/LypJII
         cwPry6dnSAfLXikjMpPjB27q1jfkoGG1qm0b9bY3Ll+W221vjGWs6G3/TuiwHhXRWmQi
         2CgqdGYCLomdhoD7a9i8SDJE8+Avk/RhYb/GV0KF0e3G7TCQPtVTW8IPNnNhPlqjPvBv
         uadQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bAD7uqVBt9z/Yn17SCW6bFz5mIqxunvQE9EQMuF/uro=;
        b=DQuB40YLFgG5DNbIyuKQt4KTuRnbdsvwYajsemhd2y/tuRaqCQ/9kH5/NzkqeK5Nx7
         2AI7Pu//IjohnZokuesk9v9tRDu+zrlNHpQTUoTOGsqfVjUlNzqvCb/UrFR0Sp4aYv/n
         Ow9M9lHU4S/keQWUOH10zgbM41aQQ5P+7TOfP8L9EbP+pmQfZ0wkgqpxMtiORCiz8taN
         9sXsusd6ElJaICeQDthpO52o3PZFWUyIX94AO6Y7iyWh9YbL6omiq/Sk7cjJJUJkoaz9
         NiCHI1TcxW1I1rALr62Fq1OTu03X6a2naMVt3zkrtL+8tnNPiHCtROj+PV6zhmZdF3Fs
         voNw==
X-Gm-Message-State: AOAM5332c7x69oUaMQONzoGCBE+Vi76mi+LUNdlBVJWUWYEIQ0rkwXEr
        w+ghDNlh+O0FMyabcyw0Rtuw/V0cPEPP76ShnAtgcA==
X-Google-Smtp-Source: ABdhPJwESpS9Ov7cD4cHYHYl5/B+/pSgPx/pkkpsibP6zLzO/ttMY8KCj1Jk09wrz9gTL5cE/91AMQ==
X-Received: by 2002:aa7:d149:: with SMTP id r9mr5069247edo.38.1612989826272;
        Wed, 10 Feb 2021 12:43:46 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id l1sm2062655eje.12.2021.02.10.12.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 12:43:45 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, andy@greyhouse.net, j.vosburgh@gmail.com,
        vfalico@gmail.com, kuba@kernel.org, davem@davemloft.net,
        alexander.duyck@gmail.com, idosch@nvidia.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2 3/3] bonding: 3ad: Print an error for unknown speeds
Date:   Wed, 10 Feb 2021 22:43:33 +0200
Message-Id: <20210210204333.729603-4-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210210204333.729603-1-razor@blackwall.org>
References: <20210210204333.729603-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The bond driver needs to be patched to support new ethtool speeds.
Currently it emits a single warning [1] when it encounters an unknown
speed. As evident by the two previous patches, this is not explicit
enough. Instead, promote it to an error.

[1]
bond10: (slave swp1): unknown ethtool speed (200000) for port 1 (set it to 0)

v2:
* Use pr_err_once() instead of WARN_ONCE()

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 drivers/net/bonding/bond_3ad.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 2e670f68626d..6908822d9773 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -327,10 +327,10 @@ static u16 __get_link_speed(struct port *port)
 		default:
 			/* unknown speed value from ethtool. shouldn't happen */
 			if (slave->speed != SPEED_UNKNOWN)
-				pr_warn_once("%s: (slave %s): unknown ethtool speed (%d) for port %d (set it to 0)\n",
-					     slave->bond->dev->name,
-					     slave->dev->name, slave->speed,
-					     port->actor_port_number);
+				pr_err_once("%s: (slave %s): unknown ethtool speed (%d) for port %d (set it to 0)\n",
+					    slave->bond->dev->name,
+					    slave->dev->name, slave->speed,
+					    port->actor_port_number);
 			speed = 0;
 			break;
 		}
-- 
2.29.2

