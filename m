Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B716540D96D
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238933AbhIPMFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238935AbhIPMFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 08:05:31 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A079AC061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 05:04:10 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id x27so17606481lfu.5
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 05:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vp0wcZ10Y649pYBPx5woR6M8cq6oSjBxFQtRydIfEmk=;
        b=cK/hAz5UTf3LS1UMergOtyIx1W5c3TnIgs9+M9ni72EzXGBVSW9r4NQPlvIZNk7cMF
         4YkrPquHS4dcmtpNIX8rXHd24ik86pJNnU0BHNNA3nOqz4cLsgVFyKqxZDlN55iwbCcw
         n57Xr0nEnvdrLV9TRikQjT9FSrBhpHsALsb7ht78CXBEk4+z+ry+pXbvY9/NYScFQrwQ
         Dca4SUg9Wt4DYb5wt8gm2RQc/O6RLJruLwNWcGa0KUbNwVyMyMEaVsfMmCTq4SBKwTEr
         YVN8HsBMPX2nvkDiSblstiF55My9fa1eRP/edtZayyijHwODYHaKZen1zUBP8nCVGYzF
         x4xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vp0wcZ10Y649pYBPx5woR6M8cq6oSjBxFQtRydIfEmk=;
        b=ilon2TbhPKGhXqQCDnttwCfYrxYC2lZ0y9RJlHv6hkM6200+YVRGF0Qqv7eLN8ww/F
         2N/fKdGw0BjRBW21RgneglbhKXPQZFFdIsb6Q/G/S/gnoxcYR4SJ+OmkvghAQtkWaFcf
         1f99XM3Ijy+wGWQNIiA9hvAz8JG8LG4BJyaCpG0Kz90K1XAIOjXpWsuYkKSp/8ZNZ0UV
         N6QSvRl1SsQWKnG3+mlv8scuhrcQz3RIZs9s6KZHEd+6T83QbD4jbhzNJhZgYEmOFRX+
         rJ0hQ1e+QPZ+XS+HtgqwXD34adVtDKVYBQB906/Y7UdriB9NtZEmK2eN43ZvaHA6woXr
         WWSg==
X-Gm-Message-State: AOAM530sAAYyTXvECoa8b+sCJVGinKQzTgbF3J8MHEYLwS9/4XJSIaTb
        voWtL2Tz2hmXmN/1useZPKY=
X-Google-Smtp-Source: ABdhPJyJGurdc+PBoHdRxFM6HrF9LVtcmZXD+EQW13ztDuc9s2B213YoYzb9LMk7GgfZy08yjaP9BQ==
X-Received: by 2002:a2e:2f02:: with SMTP id v2mr3645590ljv.132.1631793848862;
        Thu, 16 Sep 2021 05:04:08 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id h8sm243010lfk.227.2021.09.16.05.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 05:04:08 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next 2/4] net: dsa: b53: Drop BCM5301x workaround for a wrong CPU/IMP port
Date:   Thu, 16 Sep 2021 14:03:52 +0200
Message-Id: <20210916120354.20338-3-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210916120354.20338-1-zajec5@gmail.com>
References: <20210916120354.20338-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

On BCM5301x port 8 requires a fixed link when used.

Years ago when b53 was an OpenWrt downstream driver (with configuration
based on sometimes bugged NVRAM) there was a need for a fixup. In case
of forcing fixed link for (incorrectly specified) port 5 the code had to
actually setup port 8 link.

For upstream b53 driver with setup based on DT there is no need for that
workaround. In DT we have and require correct ports setup.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/dsa/b53/b53_common.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 47a00c5364c7..ca84e32baca0 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1291,12 +1291,6 @@ static void b53_adjust_link(struct dsa_switch *ds, int port,
 				return;
 			}
 		}
-	} else if (is5301x(dev)) {
-		if (port != dev->cpu_port) {
-			b53_force_port_config(dev, dev->cpu_port, 2000,
-					      DUPLEX_FULL, true, true);
-			b53_force_link(dev, dev->cpu_port, 1);
-		}
 	}
 
 	/* Re-negotiate EEE if it was enabled already */
-- 
2.26.2

