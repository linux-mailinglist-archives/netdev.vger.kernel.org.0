Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E703DEE02
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbhHCMlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236131AbhHCMlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 08:41:08 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F15C0617A3;
        Tue,  3 Aug 2021 05:40:55 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j18-20020a17090aeb12b029017737e6c349so2787991pjz.0;
        Tue, 03 Aug 2021 05:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w7Kn6QXEQelFeTJ7+s8dsrUhrZSrqjRMDTa6894wxts=;
        b=BvH79tKxT+NJ46lxOpJ274QfCECXsRyYzb2ZSo1cZj+WIVl03lsEbe9ERzMM0qz978
         dJuZx6U0MV27iFEllkqn5XGMgtEYcyQhGUiqU1M8I6SqqAuYfSrI+TRQnpziyRJNVhhV
         Wp4O20eq8LfUYXWHIaNvopHWaZsFURti6KuVJmJoSrkF+bpvVpv9yGiUg54YLTMfLnR+
         qVXxKLXUG4Msr3wMowoGKN8SlIrrfoS6VtO50LHf/iN1tUEn5/QA6Hk4VDcf8LUvecl6
         PI/Mwimzj40c6bFOqckTw8McfFMMDSSEIf/FAVaMrVXNvlIy64n8tS4dkezRsl1lc5on
         QGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w7Kn6QXEQelFeTJ7+s8dsrUhrZSrqjRMDTa6894wxts=;
        b=UcBwzqSi4ShFZOUZY6Ff5do8MkfMWjwHK2+FtNT5IUurKpOsFPhrLCYYmJFvCbTUde
         cun4etgmLyVN1tFJQYfRyNu6/hEMDQ9hiL1XnOXspGBDqjqDruTA7bzMyud5Y+7g4Afq
         wBnwzcfoOc3u6arXiM9GKBezrAE/N+JViITRgS/Po7kv7L0nh0QMPCF5sK/TRr758Pbd
         ubUDvdy9OA9yvqAu4GQ3dakyZ/dZNz80dU1Ggzy0NnSYWEo2xQk+5bA7wYmCXmdWYz1m
         t7zw0Lk1rBHn3wXqCL01rnvT/Sm/t8RhdRf5LeBstIPjGIfxiIJ0wP4EBd1kOQ9ThhHJ
         kctg==
X-Gm-Message-State: AOAM533w+QONE1yRwXDfcuDSiBt2D2teJ/8vvS+hw9IPDEUe1Gwy1qQA
        b0cI8JBXng3JQKp/pJRKhfI=
X-Google-Smtp-Source: ABdhPJxp9gFg7/j3CDtrOHNrsfB9FqVBSArVmrXgyH3SowyPhAc2Fu3mBv6qHFQ34Iwgo+eYhe7SHA==
X-Received: by 2002:a17:902:7b8b:b029:12b:8d3e:70e7 with SMTP id w11-20020a1709027b8bb029012b8d3e70e7mr18389531pll.76.1627994455018;
        Tue, 03 Aug 2021 05:40:55 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g25sm15747499pfk.138.2021.08.03.05.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 05:40:54 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Eric Woudstra <ericwouds@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next 4/4] net: dsa: mt7530: always install FDB entries with IVL and FID 1
Date:   Tue,  3 Aug 2021 20:40:22 +0800
Message-Id: <20210803124022.2912298-5-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803124022.2912298-1-dqfext@gmail.com>
References: <20210803124022.2912298-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 7e777021780e ("mt7530 mt7530_fdb_write only set ivl
bit vid larger than 1").

Before this series, the default value of all ports' PVID is 1, which is
copied into the FDB entry, even if the ports are VLAN unaware. So
`bridge fdb show` will show entries like `dev swp0 vlan 1 self` even on
a VLAN-unaware bridge.

The blamed commit does not solve that issue completely, instead it may
cause a new issue that FDB is inaccessible in a VLAN-aware bridge with
PVID 1.

This series sets PVID to 0 on VLAN-unaware ports, so `bridge fdb show`
will no longer print `vlan 1` on VLAN-unaware bridges, and that special
case in fdb_write is not required anymore.

Set FDB entries' filter ID to 1 to match the VLAN table.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
RFC -> v1: Detailed commit message. Also set FDB entries' FID to 1.

 drivers/net/dsa/mt7530.c | 4 ++--
 drivers/net/dsa/mt7530.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 8d84d7ddad38..ac2b45e472bd 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -366,8 +366,8 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
 	int i;
 
 	reg[1] |= vid & CVID_MASK;
-	if (vid > 1)
-		reg[1] |= ATA2_IVL;
+	reg[1] |= ATA2_IVL;
+	reg[1] |= ATA2_FID(1);
 	reg[2] |= (aging & AGE_TIMER_MASK) << AGE_TIMER;
 	reg[2] |= (port_mask & PORT_MAP_MASK) << PORT_MAP;
 	/* STATIC_ENT indicate that entry is static wouldn't
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 53b7bb1f5368..73b0e0eb8f2f 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -80,6 +80,7 @@ enum mt753x_bpdu_port_fw {
 #define  STATIC_ENT			3
 #define MT7530_ATA2			0x78
 #define  ATA2_IVL			BIT(15)
+#define  ATA2_FID(x)			(((x) & 0x7) << 12)
 
 /* Register for address table write data */
 #define MT7530_ATWD			0x7c
-- 
2.25.1

