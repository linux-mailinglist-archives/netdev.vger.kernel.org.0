Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3012F3ACC88
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhFRNqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhFRNqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:46:18 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6A9C061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 06:44:07 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id d7so8804446edx.0
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 06:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s4QXOg/Oqg6wQFgoGzdfA2mVDfGvYnpoYb80SOtk3Iw=;
        b=jyWWyKe7ohhDOW3qhtVKhMQqd2jYi+Lcnlt4B5XmapC9MXZ7Xq/cgjV+0LZ+nLG7mY
         HNnZs1Ya4mqZUEPDxD/RmAtW0lwLC3UfFpvzomuHeXqz+jAzdvdYKlxVObhYt4v2DY3t
         A+kIr/9os58NduDJbIHMBOehIhWRZDPjPSwe9pdMaTUdBCIq65J9WCasg+LyDiJDsJ6o
         OvlLICUfbPFknex4NzNJtLls+8PJ3HXEygaDC0VBuHoiEn/Mzb1T6VipfKIorU+rKFCR
         0DghqvBUAfP1qIAteuXqN/trBs226whxxl6kGbDv2dDx4f2dSUYuFGEc5Dz3pzBomIJC
         YF3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s4QXOg/Oqg6wQFgoGzdfA2mVDfGvYnpoYb80SOtk3Iw=;
        b=bw2ArH0ZoBhAmU8ZswbpvV7yNsItL07IguyiBslxzpUa6XW2QVbopPCIHyGHka7s7i
         8sC12RwV0opTkrleV+9N4hfmbR35z/b2hq5LLePZ7kQCYAXfY5crWUDLmjDbwTesrHUO
         DtOr3meOtXLGq9N5bldNXSEmQZGXMmC0a1vaqSxcIANV270Ye9n/0GLodx/+4eQZht59
         O9rOA+0llZzdWu2NCUkiNG5CDdSzhfiN9gcZENm9+FRvHIxV+AGGn3Gd2PwULjmQWv3/
         UQaN/aw6ERXeQFefOx++D+JjoaPJ7w9O7b3efRO5hxqp4c1p/j4esIyWcxgesNvNH2cs
         bC6g==
X-Gm-Message-State: AOAM532H0yyJ/WLQbWiQ0QKeWobkxRf9RErs5Xs++OqXM17mUP+QNcja
        W1NWf4NiHTHbL3RE63d0G0c=
X-Google-Smtp-Source: ABdhPJzhd3PD4ZWTxZ60H/By/sRJv8+aGoq/FvDmXZCTlDNiM0B1/mJA1eockmNn5jFnS5LFjlvcQw==
X-Received: by 2002:aa7:dc4c:: with SMTP id g12mr5219515edu.258.1624023846019;
        Fri, 18 Jun 2021 06:44:06 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id n2sm6334347edi.32.2021.06.18.06.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 06:44:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: dsa: sja1105: allow the TTEthernet configuration in the static config for SJA1110
Date:   Fri, 18 Jun 2021 16:44:00 +0300
Message-Id: <20210618134400.2970928-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently sja1105_static_config_check_valid() is coded up to detect
whether TTEthernet is supported based on device ID, and this check was
not updated to cover SJA1110.

However, it is desirable to have as few checks for the device ID as
possible, so the driver core is more generic. So what we can do is look
at the static config table operations implemented by that specific
switch family (populated by sja1105_static_config_init) whether the
schedule table has a non-zero maximum entry count (meaning that it is
supported) or not.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_static_config.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index 1491b72008f3..7a422ef4deb6 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -1052,8 +1052,7 @@ sja1105_static_config_check_valid(const struct sja1105_static_config *config,
 	(tables[blk_idx].entry_count == tables[blk_idx].ops->max_entry_count)
 
 	if (tables[BLK_IDX_SCHEDULE].entry_count) {
-		if (config->device_id != SJA1105T_DEVICE_ID &&
-		    config->device_id != SJA1105QS_DEVICE_ID)
+		if (!tables[BLK_IDX_SCHEDULE].ops->max_entry_count)
 			return SJA1105_TTETHERNET_NOT_SUPPORTED;
 
 		if (tables[BLK_IDX_SCHEDULE_ENTRY_POINTS].entry_count == 0)
-- 
2.25.1

