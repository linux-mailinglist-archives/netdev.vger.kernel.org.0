Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEA06DAF0F
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbjDGPAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbjDGO7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 10:59:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E2FBDD2;
        Fri,  7 Apr 2023 07:59:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AA9B64FFF;
        Fri,  7 Apr 2023 14:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFBAC433EF;
        Fri,  7 Apr 2023 14:59:37 +0000 (UTC)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oss-drivers@corigine.com
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-hwmon@vger.kernel.org
Subject: [PATCH 5/8] net: phy: marvell: constify pointers to hwmon_channel_info
Date:   Fri,  7 Apr 2023 16:59:08 +0200
Message-Id: <20230407145911.79642-5-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230407145911.79642-1-krzysztof.kozlowski@linaro.org>
References: <20230407145911.79642-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Statically allocated array of pointed to hwmon_channel_info can be made
const for safety.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

This depends on hwmon core patch:
https://lore.kernel.org/all/20230406203103.3011503-2-krzysztof.kozlowski@linaro.org/

Therefore I propose this should also go via hwmon tree.

Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: linux-hwmon@vger.kernel.org
---
 drivers/net/phy/marvell.c    | 2 +-
 drivers/net/phy/marvell10g.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 63a3644d86c9..24853e9a889e 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2735,7 +2735,7 @@ static const struct hwmon_channel_info marvell_hwmon_temp = {
 	.config = marvell_hwmon_temp_config,
 };
 
-static const struct hwmon_channel_info *marvell_hwmon_info[] = {
+static const struct hwmon_channel_info * const marvell_hwmon_info[] = {
 	&marvell_hwmon_chip,
 	&marvell_hwmon_temp,
 	NULL
diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 383a9c9f36e5..55d9d7acc32e 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -243,7 +243,7 @@ static const struct hwmon_channel_info mv3310_hwmon_temp = {
 	.config = mv3310_hwmon_temp_config,
 };
 
-static const struct hwmon_channel_info *mv3310_hwmon_info[] = {
+static const struct hwmon_channel_info * const mv3310_hwmon_info[] = {
 	&mv3310_hwmon_chip,
 	&mv3310_hwmon_temp,
 	NULL,
-- 
2.34.1

