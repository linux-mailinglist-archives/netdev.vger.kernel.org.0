Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53723952BC
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 21:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhE3Tbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 15:31:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53166 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229714AbhE3Tba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 15:31:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622402991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/SflTKgXOGAWsY4kx68BKvwmaKX+dkhH/SEUq3r5MAM=;
        b=DSxzLdJq/JSq236FBvuHSVPOwlFV1CvuC6mYrkV277N5xzMPkSTe1p9UVWKm6SgjqNh2JN
        0xHRPkKGSQ1e6CUgF8NTyPyjZK4KvtrM1KKfmlKFIM/rptN5bpTQMCjat/+J2swnOCFRqX
        D+oCWll23DJ+9PlAzjtN2pRTtgn+oGE=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348--XM9oVZkNNWSlzVarXra-A-1; Sun, 30 May 2021 15:29:50 -0400
X-MC-Unique: -XM9oVZkNNWSlzVarXra-A-1
Received: by mail-ot1-f70.google.com with SMTP id f18-20020a0568303092b02903a7896a597aso1577183ots.12
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 12:29:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/SflTKgXOGAWsY4kx68BKvwmaKX+dkhH/SEUq3r5MAM=;
        b=RvlCSBn/nLKInMmFfNJkcOcmOp1HPIkVbqPm/h0jIkJ/vBIBEB9mt93fFy2rs3195t
         BvR+V4sF1KCJAHII0LGlDTFAl8Xy92+ijl4RO1HAcVCT2zJja6q9tbusrknH1JWAOM9d
         V/gJLOOjGoMBcymXYdHKbko6v6VC2KI+6t3fCwB/HD3H/Me1es+h/ZC2/6ZU4a9W8hci
         7v9Er2Pp33ALMcPlQHd5IxWNxOz4ycH02pbPAM0sz1N37HO334xXtGL0f6yh8NSHDkT2
         TpHJWQeY12ae4x8FHtdrZMS4WVAaPGZ6M2ZiuBvmsUBEL4E9AI6Qf8UM+ebrGiwE2/Wz
         6a8A==
X-Gm-Message-State: AOAM531xL4uCxib8wOVrxvq5RdSlZS//XGiUlTmAGxtAUScMeI1e+jDC
        qLK0Q/narAmJLonf0Pot/AZEHAk1easlBpp4KGchXKKxFo8t0N7FusuSkKNz5Seu38pDvHrbGQ4
        +R85s2ypgr0uCRcnh
X-Received: by 2002:a9d:304:: with SMTP id 4mr230396otv.215.1622402989361;
        Sun, 30 May 2021 12:29:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpGaUKkkTmKhAMteghku4Iz8/Lm8fEjqHiop5DN72MqZ1A8uYv2cDgxuxEXNieK4F9/QuJkw==
X-Received: by 2002:a9d:304:: with SMTP id 4mr230393otv.215.1622402989209;
        Sun, 30 May 2021 12:29:49 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id n186sm2363916oia.1.2021.05.30.12.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 12:29:48 -0700 (PDT)
From:   trix@redhat.com
To:     pgwipeout@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] net: phy: initialize ge and fe variables
Date:   Sun, 30 May 2021 12:29:43 -0700
Message-Id: <20210530192943.2556076-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Static analysis reports this issue
/motorcomm.c:83:2: warning: variable 'ge' is used uninitialized
  whenever switch default is taken [-Wsometimes-uninitialized]
        default: /* leave everything alone in other modes */
        ^~~~~~~
drivers/net/phy/motorcomm.c:87:85: note: uninitialized use
  occurs here
        ret = __phy_modify(phydev, YT8511_PAGE,
	  (YT8511_DELAY_RX | YT8511_DELAY_GE_TX_EN), ge);
                                                     ^~

__phy_modify() calls __mdiobus_modify_changed(.., mask, set)

	new = (ret & ~mask) | set;
	if (new == ret)
		return 0;

	ret = __mdiobus_write(bus, addr, regnum, new);

Since 'ge/set' is or-ed in, it is safe to initialize it to 0

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/phy/motorcomm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index 796b68f4b499..53b2906c54ef 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -50,7 +50,7 @@ static int yt8511_write_page(struct phy_device *phydev, int page)
 
 static int yt8511_config_init(struct phy_device *phydev)
 {
-	unsigned int ge, fe;
+	unsigned int ge = 0, fe = 0;
 	int ret, oldpage;
 
 	/* set clock mode to 125mhz */
-- 
2.26.3

