Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86434E4816
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 22:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbiCVVJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 17:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiCVVJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 17:09:13 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42C16151
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:07:43 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id l7-20020a05600c1d0700b0038c99618859so4103726wms.2
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dOjiq8Aqyi8KntJHZ/EWB00zgN02oNcNdxQFPgwQW6w=;
        b=J8LYC5pkKNpKe6OeijsMM3+GJo69vUpHBF6B+YmEgYZwKj+P2IVAIwh11IL/InqTrm
         FqlYlYMawYfYzRPBTmy1hoiCJACJpw0G7bCF4lkVXnnH2DeA7P5QFk/oFirbPVHh7oeV
         XXT9CTJEwqx/2ZxPGnVYxl0g0YMWvneV89PDuyv82xRfTpPQPPfZSvyCwDdG2VPgjYJ5
         5btcR7J+UpnPLWx961Ikj9EdD74FmmpRkQvhkmzeltMNT+/yGjaswxeqGztJfMnvJzVt
         yUgopuYu/XbQa2wVd+Xx7DmRDEUVvkOVIo6XqfTey9XxlS3pwG6+ujQvDFF45Kbs6vNy
         T26w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dOjiq8Aqyi8KntJHZ/EWB00zgN02oNcNdxQFPgwQW6w=;
        b=xHDHHjP1bdHuOAHUQ0OHXzEODqVGAYPZuH56nY1h+hNaJ2QjDPim/BBMjF73esdo2y
         QvIcYrX4JRE80LpJBFOjNzDvZ8VzTmUbQZp2EZ3RNd6Tm3TpNg8Bub6XRX5oMbb+haK4
         FcIvUh0zK0pj97/yKkmTvqBDk0Cf5Td3ZKZaG+dp0Ut+fUkLa0lDG1jx6nNuhxYFzfxB
         44BYQFCH/zrOa8McMZDbxrBonQIKjs7JfGnrAFAUTnC9N/kGXRnIfyiRWbirqEW/5ktR
         MFxVW+RyDbgsaipIcc+eArKp2GLuHdzVGNcyIglXVtdnC6RBwHPjBZ1dCkJv4ODvn/Yw
         4ROA==
X-Gm-Message-State: AOAM533yTvidnMvSvlG0J5VAwUYFxtHR2niPAMK7H+hta/0F+nJDSMal
        POK/ujASjmiYnwKCxUL/as5xCQ==
X-Google-Smtp-Source: ABdhPJzenh++JnlXb5IWu7bsEZ6UrSl/D0L/fwAWeYNr26lfBnCM0vd2Xx+ZjAGBI3Z3KPJ6VA/QOw==
X-Received: by 2002:a05:600c:4f92:b0:38a:1d7:c01c with SMTP id n18-20020a05600c4f9200b0038a01d7c01cmr5764372wmq.164.1647983262489;
        Tue, 22 Mar 2022 14:07:42 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id c7-20020a5d4f07000000b00203db8f13c6sm16281805wru.75.2022.03.22.14.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 14:07:42 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v1 2/6] ptp: Request cycles for TX timestamp
Date:   Tue, 22 Mar 2022 22:07:18 +0100
Message-Id: <20220322210722.6405-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220322210722.6405-1-gerhard@engleder-embedded.com>
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The free running time of physical clocks called cycles shall be used for
hardware timestamps to enable synchronisation.

Introduce new flag SKBTX_HW_TSTAMP_USE_CYCLES, which signals driver to
provide a TX timestamp based on cycles if cycles are supported.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 include/linux/skbuff.h |  3 +++
 net/core/skbuff.c      |  2 ++
 net/socket.c           | 10 +++++++++-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 26538ceb4b01..f494ddbfc826 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -578,6 +578,9 @@ enum {
 	/* device driver is going to provide hardware time stamp */
 	SKBTX_IN_PROGRESS = 1 << 2,
 
+	/* generate hardware time stamp based on cycles if supported */
+	SKBTX_HW_TSTAMP_USE_CYCLES = 1 << 3,
+
 	/* generate wifi status information (where possible) */
 	SKBTX_WIFI_STATUS = 1 << 4,
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 10bde7c6db44..c0f8f1341c3f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4847,6 +4847,8 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
 		skb_shinfo(skb)->tx_flags |= skb_shinfo(orig_skb)->tx_flags &
 					     SKBTX_ANY_TSTAMP;
 		skb_shinfo(skb)->tskey = skb_shinfo(orig_skb)->tskey;
+	} else {
+		skb_shinfo(skb)->tx_flags &= ~SKBTX_HW_TSTAMP_USE_CYCLES;
 	}
 
 	if (hwtstamps)
diff --git a/net/socket.c b/net/socket.c
index 982eecad464c..1acebcb19e8f 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -683,9 +683,17 @@ void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags)
 {
 	u8 flags = *tx_flags;
 
-	if (tsflags & SOF_TIMESTAMPING_TX_HARDWARE)
+	if (tsflags & SOF_TIMESTAMPING_TX_HARDWARE) {
 		flags |= SKBTX_HW_TSTAMP;
 
+		/* PTP hardware clocks can provide a free running time called
+		 * cycles as base for virtual clocks. Tell driver to use cycles
+		 * for timestamp if socket is bound to virtual clock.
+		 */
+		if (tsflags & SOF_TIMESTAMPING_BIND_PHC)
+			flags |= SKBTX_HW_TSTAMP_USE_CYCLES;
+	}
+
 	if (tsflags & SOF_TIMESTAMPING_TX_SOFTWARE)
 		flags |= SKBTX_SW_TSTAMP;
 
-- 
2.20.1

