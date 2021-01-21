Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E722FE0CF
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732766AbhAUEf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbhAUEHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:07:32 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E88C061786;
        Wed, 20 Jan 2021 20:06:11 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y8so536246plp.8;
        Wed, 20 Jan 2021 20:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MldHeooV548S/KisyAFcmWejup1la3KPj1MTllBMACM=;
        b=V3G7p8W93TegzjRz0ayi9tXhiZmLpHvKxIdIOgM6Og/fnMVZA7XfTnwbYD1iZX8u08
         O9h/YZ8Z/PbjixTe6/rnw8bXCQUJ+LhuryQTzCeRd44BX7hwxh8ImK+3538m45aqU3PL
         IdJUOICQHwO3hoZErBX7KDRyMOiPSdloltD19KJYR9P/FN1IKxCa6wcT4jL8i/rXJfaF
         0pyKOZ+YukoTxWWiM9gW9YGjPuPUzP70QLDeczUqffPSRL8JCP+whSFfbSWopPr02zvw
         /HbbkMCUS7aOzn9Ym1cFUDUX00erCwhcYRJTc+Ur/DEKn/MzfFDKSozpCqeGe6W0kz43
         PVHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MldHeooV548S/KisyAFcmWejup1la3KPj1MTllBMACM=;
        b=cZfQh6Ma76TbYq3vNCqogVC3XzWAZ5xXgfa4sxxUbSt7H+1Y7gmHpKBYRA8DpOnClv
         jr7pusJfFry//OhOu26/9BP4+KNz9/xr58vuoW4TLCu0dgUKbxWhbCBiMxznl54PExGk
         Bb3Dr9hRZD/1czljZgnxrxMzGBKvj9RSL890z16vcKCxF+R0hHlh1zfVqR/Z+Lf4l0GA
         AuEL5IB+OunWlmjsdS3jMII+ouS3bcu/behRr4aye6Ynp7C0aTuYjpXOzRTYzGcc/SRJ
         QFz43hrrYmRG/05kmyEycKECA3tudBg4YFOPWL9dZ+B/tK/snVyV80p2POcZ8gTuCXVb
         udWg==
X-Gm-Message-State: AOAM533vrwPxhbFnAcIvtvwxAx+9eP3Gq2WpkFLu2kpx3wF5D3XUO2P3
        JHLgSHFUO6pGaZ0HpXbb1iii3GrXm58=
X-Google-Smtp-Source: ABdhPJxYrKKvS8CcdxBvOLYgUmGIcQGOzafB9nQX42jQCuZbK6Fi2BKzpOz9H2K2fYDltZFyJSfbWg==
X-Received: by 2002:a17:90b:602:: with SMTP id gb2mr9199252pjb.170.1611201970523;
        Wed, 20 Jan 2021 20:06:10 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id f24sm3808567pjj.5.2021.01.20.20.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:06:09 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Brandon Streiff <brandon.streiff@ni.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Olof Johansson <olof@lixom.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/4] net: mvpp2: Remove unneeded Kconfig dependency.
Date:   Wed, 20 Jan 2021 20:06:01 -0800
Message-Id: <1069fecd4b7e13485839e1c66696c5a6c70f6144.1611198584.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1611198584.git.richardcochran@gmail.com>
References: <cover.1611198584.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mvpp2 is an Ethernet driver, and it implements MAC style time
stamping of PTP frames.  It has no need of the expensive option to
enable PHY time stamping.  Remove the incorrect dependency.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Fixes: 91dd71950bd7 ("net: mvpp2: ptp: add TAI support")
---
 drivers/net/ethernet/marvell/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index 41815b609569..7fe15a3286f4 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -94,7 +94,6 @@ config MVPP2
 
 config MVPP2_PTP
 	bool "Marvell Armada 8K Enable PTP support"
-	depends on NETWORK_PHY_TIMESTAMPING
 	depends on (PTP_1588_CLOCK = y && MVPP2 = y) || \
 		   (PTP_1588_CLOCK && MVPP2 = m)
 
-- 
2.20.1

