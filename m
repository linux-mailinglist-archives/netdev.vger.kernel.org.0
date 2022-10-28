Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE22611A20
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 20:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiJ1Scp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 14:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiJ1Sco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 14:32:44 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2516229E6A
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 11:32:43 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id d25so9216535lfb.7
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 11:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uSchnuu68CQB7wr3dqHCPJUJQ+hPuPPf+Zr7tDwlWWI=;
        b=RGTH5Qx6zdcXPAf5Lb4Oc0qWr6gSvRFrhXZ+MSzqkFbCwfze1Fla500TRG0ee9KiJ9
         yeHk4L901cvbnAoz2wnhVadPcMA6028/xSSOojbWZLEtjglFNp/J1IE3BdUUGyrXgWcK
         fhY0XXwmRKHxiS46RSoihRAINeuIIY7fdP+3eh7qQMuqZ7JFKBu5FW1v0Wf2umNE8Knb
         mPSBHyxY9XQJY0zW3FfLKWqb9MY0H5dFQEGfWLN9C/IZVuS/pTE3v/WVPhvUeJUghMua
         mBMbp8XEEw3fK4FaEZuDJ3d7bgdUTXi3I0s64sYqtQZp4jP3Ur+4JVybGc1mN47UC6qe
         IS4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uSchnuu68CQB7wr3dqHCPJUJQ+hPuPPf+Zr7tDwlWWI=;
        b=z0uuzuwVFWy2vslzm3/C4dCjHPIAl/jNkZUVO1BFudFg1rjrY8IiVU7bI9JT1UC0bz
         xoU7kBmNKuuaI9ogMEOt/sDtQtX3MADNh81sL7mzsF3aM5eHPK4vqRns4Vnoup3tvT6D
         0I+PMy+dy7KIdOjXhMDWAIrW4m9FUcTtqe3O+EwSH9XQJakRC0mLRs4w53nOgVsbOApk
         GpMv2jaRDEF2HS9NCq0UudfBHshDfkBz5ZieH1EO1O9vVIImtm3z53uuQ+LzctPgfVlS
         hjtjS6ga5uvjHP/XBeBlGNr+bnlPmWQC3JzwXQ452SzCvsNecCk/IpkWcBfI13gdjq4k
         kCqA==
X-Gm-Message-State: ACrzQf23Kxc4obc/k6obBSZ5yY+trSLhBUHXOnEeM26eBBMjaR/IEJ4q
        0CkIo/7OP+AB2MDi1T3BtXZEASn1eKyvig==
X-Google-Smtp-Source: AMsMyM5ntVfS1HvnjBvJWE2t8UImNP/fTsoAShOHIANSAE8T8/qMMzIAzkTLiujg6DZjeMec0seJvA==
X-Received: by 2002:a19:9106:0:b0:4ab:a0dc:ac3e with SMTP id t6-20020a199106000000b004aba0dcac3emr244298lfd.395.1666981961824;
        Fri, 28 Oct 2022 11:32:41 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:5e0d:c276:399c:5839])
        by smtp.gmail.com with ESMTPSA id k2-20020a2eb742000000b0026dc7b59d8esm739161ljo.22.2022.10.28.11.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 11:32:41 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sergei Antonov <saproj@gmail.com>
Subject: [PATCH 1/3] net: ftmac100: prepare data path for receiving single segment packets > 1514
Date:   Fri, 28 Oct 2022 21:32:18 +0300
Message-Id: <20221028183220.155948-1-saproj@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Eliminate one check in the data path and move it elsewhere, to where our
real limitation is. We'll want to start processing "too long" frames in
the driver (currently there is a hardware MAC setting which drops
theses).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
 drivers/net/ethernet/faraday/ftmac100.c | 29 ++++++++++---------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index d95d78230828..8013f85fc148 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -218,11 +218,6 @@ static bool ftmac100_rxdes_crc_error(struct ftmac100_rxdes *rxdes)
 	return rxdes->rxdes0 & cpu_to_le32(FTMAC100_RXDES0_CRC_ERR);
 }
 
-static bool ftmac100_rxdes_frame_too_long(struct ftmac100_rxdes *rxdes)
-{
-	return rxdes->rxdes0 & cpu_to_le32(FTMAC100_RXDES0_FTL);
-}
-
 static bool ftmac100_rxdes_runt(struct ftmac100_rxdes *rxdes)
 {
 	return rxdes->rxdes0 & cpu_to_le32(FTMAC100_RXDES0_RUNT);
@@ -337,13 +332,7 @@ static bool ftmac100_rx_packet_error(struct ftmac100 *priv,
 		error = true;
 	}
 
-	if (unlikely(ftmac100_rxdes_frame_too_long(rxdes))) {
-		if (net_ratelimit())
-			netdev_info(netdev, "rx frame too long\n");
-
-		netdev->stats.rx_length_errors++;
-		error = true;
-	} else if (unlikely(ftmac100_rxdes_runt(rxdes))) {
+	if (unlikely(ftmac100_rxdes_runt(rxdes))) {
 		if (net_ratelimit())
 			netdev_info(netdev, "rx runt\n");
 
@@ -356,6 +345,11 @@ static bool ftmac100_rx_packet_error(struct ftmac100 *priv,
 		netdev->stats.rx_length_errors++;
 		error = true;
 	}
+	/*
+	 * FTMAC100_RXDES0_FTL is not an error, it just indicates that the
+	 * frame is longer than 1518 octets. Receiving these is possible when
+	 * we told the hardware not to drop them, via FTMAC100_MACCR_RX_FTL.
+	 */
 
 	return error;
 }
@@ -400,12 +394,13 @@ static bool ftmac100_rx_packet(struct ftmac100 *priv, int *processed)
 		return true;
 	}
 
-	/*
-	 * It is impossible to get multi-segment packets
-	 * because we always provide big enough receive buffers.
-	 */
+	/* We don't support multi-segment packets for now, so drop them. */
 	ret = ftmac100_rxdes_last_segment(rxdes);
-	BUG_ON(!ret);
+	if (unlikely(!ret)) {
+		netdev->stats.rx_length_errors++;
+		ftmac100_rx_drop_packet(priv);
+		return true;
+	}
 
 	/* start processing */
 	skb = netdev_alloc_skb_ip_align(netdev, 128);
-- 
2.34.1

