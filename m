Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A5F3DF213
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhHCQFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhHCQE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:04:56 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFE7C06175F;
        Tue,  3 Aug 2021 09:04:44 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id e21so24292406pla.5;
        Tue, 03 Aug 2021 09:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8uiSeD2OkBp9zNpUDtNBLvudtMpehXughyaF6cE7kWE=;
        b=HI/RNgsTbqZEYCiV99s2NdnzjSSL+jfEFNFwt9FPZJ+Ru6ksZeQK6DBubeeiqi8Nul
         RmjCDvqRoFbmQfnMP5QlNwwFCceSlVwmwDF45xDsL5gR77eoei+zQMAFwg8umjkmZ7Hp
         zb4gX8VrzX0VQ1V8m1tnb0+3e10Nyt7N5WxyY8RzdQZFBtg0HMFSYKA6JRaP30Xx0VKU
         ZhYFitTn78WccAQOmO9Bp/vm4B1nspHMVV2m19O2sKs6Vn5sOuYoI3o0D3YuPrxGA0Tw
         6MR2MQUmgaBq63GbpLiDQFYCEFxWj05lL12rhWQVKFz1cbvbieAg0cn+0rHw1RZE73AG
         3hZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8uiSeD2OkBp9zNpUDtNBLvudtMpehXughyaF6cE7kWE=;
        b=PrjXKhHy6bITMFSBnBo8sQ3KlFj6zXKlzL3rH2sOQE12dKw6eXEphMjX1h+kAYybcu
         nA2bTY+bLUeD4i0xrLCtFMYqws02E1Bz4b/xOxMXT6XUvgW01yty4VcmMBpIM9wVDouL
         lUYOF0pwmbBw0OMRnnwewbCGo3ndkL61IWOdQoKxVrrXWynPRGRplAY8+VZxGxgUH3w6
         vJxRRqz7g0pJi1GsUCDvd7VZ/gO9n/eMkQ+n39Pf6dVD3td1MCSw+wlJq2tA3HIfzJwE
         559TzqMs/dMcH+/X+WM+y7UVJ9ePZoa9VU7x+En+7fRipOxfHcPaJqlj2K1r3lLOqX4J
         J14Q==
X-Gm-Message-State: AOAM530snQ1ftrsSYCJKo1Zv7VCx9x4lkh9LBb+AoRo/0gs5lFu1dyvB
        C/Q0vd9J6sPMSS45FDu7X8U=
X-Google-Smtp-Source: ABdhPJw+fGGwGF0JHyEBaBOf/DvOOVRTxWlUrlvdTntEmvDFQ41cynm/vgr3kcX399C4DfTcv1ip5A==
X-Received: by 2002:a17:90b:344d:: with SMTP id lj13mr4940643pjb.24.1628006683927;
        Tue, 03 Aug 2021 09:04:43 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id y6sm14390653pjr.48.2021.08.03.09.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:04:43 -0700 (PDT)
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
Subject: [PATCH net-next v2 4/4] net: dsa: mt7530: always install FDB entries with IVL and FID 1
Date:   Wed,  4 Aug 2021 00:04:04 +0800
Message-Id: <20210803160405.3025624-5-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803160405.3025624-1-dqfext@gmail.com>
References: <20210803160405.3025624-1-dqfext@gmail.com>
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
v1 -> v2: use FID enum instead of hardcoding.

 drivers/net/dsa/mt7530.c | 4 ++--
 drivers/net/dsa/mt7530.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9b39ccd9dd4c..385e169080d9 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -366,8 +366,8 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
 	int i;
 
 	reg[1] |= vid & CVID_MASK;
-	if (vid > 1)
-		reg[1] |= ATA2_IVL;
+	reg[1] |= ATA2_IVL;
+	reg[1] |= ATA2_FID(FID_BRIDGED);
 	reg[2] |= (aging & AGE_TIMER_MASK) << AGE_TIMER;
 	reg[2] |= (port_mask & PORT_MAP_MASK) << PORT_MAP;
 	/* STATIC_ENT indicate that entry is static wouldn't
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 5b70ccef9459..4a91d80f51bb 100644
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

