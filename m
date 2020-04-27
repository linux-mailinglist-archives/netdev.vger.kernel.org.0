Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622E81B9505
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 04:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgD0CCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 22:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726186AbgD0CCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 22:02:49 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4A1C061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 19:02:48 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id ck5so1015156qvb.11
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 19:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=timesys-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RcteqZvDysSs0cwl3sE+jokTE69dza9uRSn9B2LltWQ=;
        b=1G1e4dCA00hoQt1Hw0ek/4a5nK7ET0Nh8wvpf61QguFDoNCdqWNG8W/kWAK77f0HxA
         cWxxf+egaGejHWexf09B4wQdkGdgq72PPDpG8grP62LbR4gatgiICOPc127GT2etwrLS
         iLlZJTt07CPb2Oidfwt42gI5vhEQaSKjg82KRE7tlFUBdj1i8yk6zJu0aFJDLFzSsRHU
         6SrLUMn8yoc2ANPfgzvk64wqQmkDoFigg/8nAxVrS8v0D8RP0D2WtmUtJxyFJR6n4CFv
         lYOrbhWiQYIo5fJw5zXHriPVdtYB2B95cuOTbiaw9JmPzz8jwwcqKZ5nHTjha74BzYs+
         zhQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RcteqZvDysSs0cwl3sE+jokTE69dza9uRSn9B2LltWQ=;
        b=ILHOlC57HN0+A5NnVmwnPAzK3wjGG74mprbVb4mdCEYaBo+EQEaMx4kP6hiqwwi09s
         go/d4lkhDACu8LckpCxBvDVhmwJ3klFDN06wzzRDRArV/Gcv3oz4WmKINiGOUzBfEqjc
         /DDhQGrPyjedesEHBiXlvG8pzJf44wYmBu4gU1qr1TxG1L1TkW2riQ/QW0iwc0C5tW0L
         jPGop25afF7Q/6LYqu6Fo7/CcP2oHWlaMVowHJrnPr9TrdYh+lHXWDGxhZjwjt0gR6WX
         MawCuLf8IN2NtPeCGCIsD97E8FtX8VYF/2Uj/vNYgPFDNXqpO7QXsG+m/lI+7lEWWwXg
         W//A==
X-Gm-Message-State: AGi0Puaj4knJuGBdJbCCoRHY+6ofD3nFAFrvPJNidvR9EppcALEmdBoo
        u5S6RUs2uiWxCd5zo5XeEuaMEQ==
X-Google-Smtp-Source: APiQypIkc7issTLMrpbXDSQ6Y1/OE643ybFGp6zM1Bzw8c6AsDDf5cTlbPqAvNmzC1DnkFPNw3TIWA==
X-Received: by 2002:a05:6214:593:: with SMTP id bx19mr20297276qvb.2.1587952967865;
        Sun, 26 Apr 2020 19:02:47 -0700 (PDT)
Received: from tony-Gazelle.8.8.8.8 (pool-173-75-1-174.pitbpa.fios.verizon.net. [173.75.1.174])
        by smtp.gmail.com with ESMTPSA id j14sm8745752qkk.92.2020.04.26.19.02.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Apr 2020 19:02:47 -0700 (PDT)
From:   Anthony Felice <tony.felice@timesys.com>
Cc:     Anthony Felice <tony.felice@timesys.com>,
        Akshay Bhat <akshay.bhat@timesys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: tc35815: Fix phydev supported/advertising mask
Date:   Sun, 26 Apr 2020 22:00:59 -0400
Message-Id: <20200427020101.3059-1-tony.felice@timesys.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 3c1bcc8614db ("net: ethernet: Convert phydev advertize and
supported from u32 to link mode") updated ethernet drivers to use a
linkmode bitmap. It mistakenly dropped a bitwise negation in the
tc35815 ethernet driver on a bitmask to set the supported/advertising
flags.

Found by Anthony via code inspection, not tested as I do not have the
required hardware.

Fixes: 3c1bcc8614db ("net: ethernet: Convert phydev advertize and supported from u32 to link mode")
Signed-off-by: Anthony Felice <tony.felice@timesys.com>
Reviewed-by: Akshay Bhat <akshay.bhat@timesys.com>
---
 drivers/net/ethernet/toshiba/tc35815.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
index 3fd43d30b20d..a1066fbb93b5 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -643,7 +643,7 @@ static int tc_mii_probe(struct net_device *dev)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, mask);
 		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, mask);
 	}
-	linkmode_and(phydev->supported, phydev->supported, mask);
+	linkmode_andnot(phydev->supported, phydev->supported, mask);
 	linkmode_copy(phydev->advertising, phydev->supported);
 
 	lp->link = 0;

base-commit: 55b2af1c23eb12663015998079992f79fdfa56c8
-- 
2.26.1

