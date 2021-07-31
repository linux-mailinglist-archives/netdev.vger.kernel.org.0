Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A0A3DC7E0
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 21:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhGaTLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 15:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbhGaTLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 15:11:03 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0175C061798;
        Sat, 31 Jul 2021 12:10:54 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id r5so12779479ilc.13;
        Sat, 31 Jul 2021 12:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=03PtB7i7Y8jswIK8wIaeVs+8jvWKvPEBQvVpB2jKQz4=;
        b=eTEpH2UyNVPu3VI2OqY8iY0ZxtYubDRoUitW6AkHIysbpPvLfaj2NCH5bn6v13YCIA
         G01uA6lEGN7Iva03On+AO4xvzD1dvHpV11S/d0atuRu9MWJzNKRaDsjtBKn3yR37ud10
         XrGSYHFu1gRonP2YL4Ofym474bCj6HbcII2q6nK6Plxt8nFAGXY5w54HTWx0h4KEXu38
         N3iUvT0zuHlx0jhaVffvMwPajE7DOx4jLOFxHmzkg6DkAW/mjgcMafvG32iWXEsHPoV1
         w7wYPs4a0QILaVhMeE10Qf7zg/zWUegb00VqSCmDBnR7xI0lAjRAspEKdBzWpfI16XYm
         7mPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=03PtB7i7Y8jswIK8wIaeVs+8jvWKvPEBQvVpB2jKQz4=;
        b=ThtxZJRNlvCEYxPo5dOi0GqXbPH/6LMJG8RNk+jpjW8m4njncV6V1m089iwCAsJ+jz
         eJQLpqimBBHVlW037SXd+O8EV8E251ZfEtTk++N6/4ae2bz86ZxRTpq91t/sBoWmn97A
         S9EdyGuzHbXVf61Zh3xwuizx3rbViT/et0+0T7flSpKTJNQlLo3LrfPIHVfSOnN0zkvu
         3w3oG8NwMbAJyutkHjvggo5j9niiAm2f5Lxql33KA2y32KoI2LtdcMrd5C2Vf/BARnOL
         2kzOu9xo6s0HQwrAY3CO8G5XpJqwuKe5XLS/KhklRDk3f5X4iRCY6FgiccWSBU/WLHCb
         Gubw==
X-Gm-Message-State: AOAM530exxjyFBn0/QRiRAgRCMFXu27KyRo4Di+w/yAOO1K8HdFVgSDV
        JFS7p8W0WcXMWnmiKLlqL3U=
X-Google-Smtp-Source: ABdhPJyREUPQ4aqHZeaToHQaro8v+j8fwNRUzkQyLj6Mu6CEAiwp5dP0SpxH2wGmNV91eOd9vez5Mw==
X-Received: by 2002:a05:6e02:1c0b:: with SMTP id l11mr2411293ilh.126.1627758654458;
        Sat, 31 Jul 2021 12:10:54 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g1sm2837991ilq.13.2021.07.31.12.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 12:10:54 -0700 (PDT)
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
        Frank Wunderlich <frank-w@public-files.de>
Subject: [RFC net-next v2 3/4] net: dsa: mt7530: set STP state also on filter ID 1
Date:   Sun,  1 Aug 2021 03:10:21 +0800
Message-Id: <20210731191023.1329446-4-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210731191023.1329446-1-dqfext@gmail.com>
References: <20210731191023.1329446-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As filter ID 1 is used, set STP state also on it.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 3 ++-
 drivers/net/dsa/mt7530.h | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 3876e265f844..38d6ce37d692 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1147,7 +1147,8 @@ mt7530_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 		break;
 	}
 
-	mt7530_rmw(priv, MT7530_SSP_P(port), FID_PST_MASK, stp_state);
+	mt7530_rmw(priv, MT7530_SSP_P(port), FID_PST_MASK,
+		   FID_PST(stp_state));
 }
 
 static int
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index a308886fdebc..294ff1cbd9e0 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -181,7 +181,7 @@ enum mt7530_vlan_egress_attr {
 
 /* Register for port STP state control */
 #define MT7530_SSP_P(x)			(0x2000 + ((x) * 0x100))
-#define  FID_PST(x)			((x) & 0x3)
+#define  FID_PST(x)			(((x) & 0x3) * 0x5)
 #define  FID_PST_MASK			FID_PST(0x3)
 
 enum mt7530_stp_state {
-- 
2.25.1

