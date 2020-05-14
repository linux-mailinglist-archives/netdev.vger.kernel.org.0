Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C0F1D405B
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 23:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgENVoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 17:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgENVoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 17:44:21 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698A6C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 14:44:21 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id z72so25457204wmc.2
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 14:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YQthHKHtUYw3zPBQtdVFZ7cqaUh3o/bODa7pB4edv5E=;
        b=qBVz8bXLh9ryyFXE6baF7A0ON84Lyu4m8o+sc2bLYxowagILd/wNQgwK8vtOGJ28/c
         MoCe7JA6iGP1umRN/QtSDjRWdAr3sRrBNOpadtFKCSIBVs/GQhfsCNQ2ZGJhnAPO7opu
         WiheKvmo1X/dVx1DC8V2d0w8Tm23VaAW+vzO7sWbK9y1wqv1AdmvMEyQgF01bnGUffxo
         NzqMcPDkJj2vKCT/3dzX9la6UMuL3jKiq3E1YnYYVSRMddzjr8AqMgLK6HN0Iq7i6owD
         RsAMNpU2fuig+HHNYQKwBg9RDbgotfni0BQoTBeq+hv0sESHBw3UUywZ6Pk6FUBl+adP
         /Nxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YQthHKHtUYw3zPBQtdVFZ7cqaUh3o/bODa7pB4edv5E=;
        b=o8RCDjF24y23fPjAzYzHt1/pl6tPINLjpaO5R13nLEeO8noMWwJTP6GeeTcuaz63q5
         +0v4l3x9TOaSFQo3ioRu+AcWLc0HO6H9EA0er+9IKCfPpSbTJh/dKxGdFmZQNiAGsZBy
         I7Ex2B5vEieeVGE08PcwQgwvxdqL8TD57PIiqzS3RdQyB+T9J8FoBSm4R/KDEzOZmeZI
         9j5KW1icuXzztKwSkFSHABvUDh6MVSTol54bvUasWiE1pYOGhd6+RRs1+Jdzt16CGeKt
         5qrXLOUzyLl19w7CFoqmQr5aq76QZIqA2hDKP0cEqumraW8PJ3Sh2la+J1SUBSz9Jack
         tOSg==
X-Gm-Message-State: AOAM530tz2LHk9TIF1gg+cNn4X/UyTdwYhWIv3gQ+qtBUlwmc2Kn6TKH
        LbbhN8B+UyUFsoSHYww0Qlcl3jNR
X-Google-Smtp-Source: ABdhPJx1lKR+eJD3QFSZ1G+guDAnPdo5GBdVjBQ7fhh/6ckB9Gi24k2IMUfZK/jQsPr7j4SIgQ7+bg==
X-Received: by 2002:a1c:5988:: with SMTP id n130mr362025wmb.187.1589492659883;
        Thu, 14 May 2020 14:44:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:44a3:4c94:7927:e2e6? (p200300EA8F28520044A34C947927E2E6.dip0.t-ipconnect.de. [2003:ea:8f28:5200:44a3:4c94:7927:e2e6])
        by smtp.googlemail.com with ESMTPSA id q17sm563230wmk.36.2020.05.14.14.44.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 14:44:19 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: r8169: remove not needed checks in rtl8169_set_eee
Message-ID: <1f4a9d3c-3c56-499b-1c69-c12031dd0adf@gmail.com>
Date:   Thu, 14 May 2020 23:39:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After 9de5d235b60a ("net: phy: fix aneg restart in phy_ethtool_set_eee")
we don't need the check for aneg being enabled any longer, and as
discussed with Russell configuring the EEE advertisement should be
supported even if we're in a half-duplex mode currently.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b030993a7..6c9a50958 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1919,12 +1919,6 @@ static int rtl8169_set_eee(struct net_device *dev, struct ethtool_eee *data)
 		goto out;
 	}
 
-	if (dev->phydev->autoneg == AUTONEG_DISABLE ||
-	    dev->phydev->duplex != DUPLEX_FULL) {
-		ret = -EPROTONOSUPPORT;
-		goto out;
-	}
-
 	ret = phy_ethtool_set_eee(tp->phydev, data);
 
 	if (!ret)
-- 
2.26.2

