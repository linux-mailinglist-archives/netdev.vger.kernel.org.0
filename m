Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE412F7ABE
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 13:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733283AbhAOMyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 07:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387841AbhAOMyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 07:54:02 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F00C0613C1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:53:21 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id u21so10291175lja.0
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=ZGOlOrCljK0/xwogXu+JogVSqOjOv4nguZxr9nyxEs8=;
        b=Hwz7+Yi0zJBP86wYMTasFzclojT8q/o4kEDTi1KyHlrgOXuksuYip5AKOcpyX4+pG9
         w5px9dfESZEOpi1PaHOVhPDXtjPpHIHmwXeSRwOhE+XH8J0DVvqv43jbfa6LLCxyh8Tq
         +UgaIS6uukQoO9s074hORJXFi4o3GXaawu7CCgOKp6/uAH9w1hffWfN9NwwZ98FeT0cL
         dpS8dvpoc9Je2pbnqAz+p9tkmGr8tEKnEmLvGF97kY8qr3xhGbreyzvgCIsbu6dwSmYH
         GdyFx0GpndSB1ROBdYq+ARLHNBbLfwBOB9sLElevI7jl58EpejK811VOAX5Du6cd2MGa
         7zqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=ZGOlOrCljK0/xwogXu+JogVSqOjOv4nguZxr9nyxEs8=;
        b=V5tgKSd2Jf3L4zYwC60zHB270VhXL1gejydKv70nclOsW99REvGzJw9FbAl7rzg0Kd
         nmTOcoDeLJSOWwj1ontBwQ45WoP2xA4h89NrTdDhQohrHy+2YPR2wmtQtviPtcyX05wu
         uHH2u/VUsOdRsHD5nvVvqtIgYrrOdnNYwBUEAUgL1gBju+iUcECeDh0DnVlFbsYvWpfF
         GI72pcAkPPKdDdJLAi1HwmyMdR4eRSaQlCEz2h5VEKqNTMkaXyUjZ90Dor+SJZUJ7VfJ
         V5sA6dqJ7dg2HF5exa87hm80u1LkqiJo/1mRUqy3MspMbNChEBl3etI02jSoz4I9sUxS
         1z+Q==
X-Gm-Message-State: AOAM5329wifpXcWjMDgYmxliLfgktIdP1Y86qyYaOND7S5T3FtXJzwQL
        3hvmeqLGFwI4XqndMyTjRo7mAA==
X-Google-Smtp-Source: ABdhPJxCZkk4xjpTzn19WV6PZZNYq0zxO0I8gWwX0Hc/+e+MOx7kmn2bnTbPLg4nFyn8e4HEUVPsZg==
X-Received: by 2002:a2e:9250:: with SMTP id v16mr5314049ljg.256.1610715199879;
        Fri, 15 Jan 2021 04:53:19 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u22sm892590lfu.46.2021.01.15.04.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 04:53:19 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 1/2] net: dsa: mv88e6xxx: Provide dummy implementations for trunk setters
Date:   Fri, 15 Jan 2021 13:52:58 +0100
Message-Id: <20210115125259.22542-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210115125259.22542-1-tobias@waldekranz.com>
References: <20210115125259.22542-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for Global 2 registers is build-time optional. In the case
where it was not enabled the build would fail as no "dummy"
implementation of these functions was available.

Fixes: 57e661aae6a8 ("net: dsa: mv88e6xxx: Link aggregation support")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/global2.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index 60febaf4da76..253a79582a1d 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -525,6 +525,18 @@ static inline int mv88e6xxx_g2_trunk_clear(struct mv88e6xxx_chip *chip)
 	return -EOPNOTSUPP;
 }
 
+static inline int mv88e6xxx_g2_trunk_mask_write(struct mv88e6xxx_chip *chip,
+						int num, bool hash, u16 mask)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int mv88e6xxx_g2_trunk_mapping_write(struct mv88e6xxx_chip *chip,
+						   int id, u16 map)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int mv88e6xxx_g2_device_mapping_write(struct mv88e6xxx_chip *chip,
 						    int target, int port)
 {
-- 
2.17.1

