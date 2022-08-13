Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9B6591C9D
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 22:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiHMUqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 16:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiHMUp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 16:45:59 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BF6B1F2;
        Sat, 13 Aug 2022 13:45:57 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id kb8so7402720ejc.4;
        Sat, 13 Aug 2022 13:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=UOHF02Uytz6VtbFA8RtBMSIPMhJ1idgg73HpstKT3vA=;
        b=GOgMutyqIDl28lCVcssgSMpFMtzyClTj+6RFwYWrnZyvSvdRs0o4cRvaJxbib7L1Ja
         yReuVtoVq7Po0V2pe6ToXsd3OUuqyC8lZNMRK+yV35I7XX/uNxQNHRrc3sMRfzB2oB7l
         fpTaJxr8D1qVn6GaDEv+ZVKa/yvTBrhSiTyPMkiODQM0WshaRKxj+G2MSQ85lNUn/o9d
         YL0TKcNqUmjKJXY+URXfp4WPIrsBtHgO5jOIZ55x2PnwshuYjhpqjY3jaPTuNjNhB9w6
         /FdMSPW/oVQj+QAKeslcbHIBuBybvbAk5Pdpn8IKVJj7lkVpttqrQbuJx+2pY2lxWuPC
         ZQ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=UOHF02Uytz6VtbFA8RtBMSIPMhJ1idgg73HpstKT3vA=;
        b=nIJqwkqgivdjE9d96NZQKgVLNdEe2n3kM5s36fwVgaLpFKBTSTvToj9aeHZUDYNVI0
         tYQx7FqVZfwEfC3/NymXSs7sSFW6qSF5Ot76cdoGEvhWbbSHWxjfDlj9LcB5tUvWc7Rm
         l8n25hxJ6toXbPUg+5XkXovHokf140rWBCbOC7qPOiTetZnjG9+vmpU8HYqrbn84cRvl
         4f2b8o8pFVfF0cNvb59AxSu6mulUUnVeIAbZAyVNx82pnYF2ZJ3cJ8ippBgWZlbxRShm
         8p7wLK7mX7tFS/OBfnfPe8F/8qqb84MHfBp4Y8WRtLQT5SMRo+gderMBuBZgwYR8umjT
         uoGg==
X-Gm-Message-State: ACgBeo0bQdviiGLVFwzexsY44NmhAxkaTQXEPCX+zV6OUtUDCVqYj8p2
        JYOHghPa6ZrUgy4NlQz4/AU=
X-Google-Smtp-Source: AA6agR7y8x+PsZx6ypxdNu+t34348o8Xixgxt1Gmxfb2BSpGMiaPtDPGaC8JOIqY/CQX9UG/1tMU2Q==
X-Received: by 2002:a17:906:cc0c:b0:730:8bbb:69ac with SMTP id ml12-20020a170906cc0c00b007308bbb69acmr6274862ejb.392.1660423555921;
        Sat, 13 Aug 2022 13:45:55 -0700 (PDT)
Received: from localhost.localdomain (5-13-160-72.residential.rdsnet.ro. [5.13.160.72])
        by smtp.gmail.com with ESMTPSA id fx18-20020a170906b75200b007306d3c338dsm2222547ejb.164.2022.08.13.13.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Aug 2022 13:45:55 -0700 (PDT)
From:   Beniamin Sandu <beniaminsandu@gmail.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Beniamin Sandu <beniaminsandu@gmail.com>
Subject: [PATCH] net: sfp: use simplified HWMON_CHANNEL_INFO macro
Date:   Sat, 13 Aug 2022 23:46:58 +0300
Message-Id: <20220813204658.848372-1-beniaminsandu@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes the code look cleaner and easier to read.

Signed-off-by: Beniamin Sandu <beniaminsandu@gmail.com>
---
 drivers/net/phy/sfp.c | 121 +++++++++++++-----------------------------
 1 file changed, 38 insertions(+), 83 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 63f90fe9a4d2..a12f7b599da2 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1195,90 +1195,45 @@ static const struct hwmon_ops sfp_hwmon_ops = {
 	.read_string = sfp_hwmon_read_string,
 };
 
-static u32 sfp_hwmon_chip_config[] = {
-	HWMON_C_REGISTER_TZ,
-	0,
-};
-
-static const struct hwmon_channel_info sfp_hwmon_chip = {
-	.type = hwmon_chip,
-	.config = sfp_hwmon_chip_config,
-};
-
-static u32 sfp_hwmon_temp_config[] = {
-	HWMON_T_INPUT |
-	HWMON_T_MAX | HWMON_T_MIN |
-	HWMON_T_MAX_ALARM | HWMON_T_MIN_ALARM |
-	HWMON_T_CRIT | HWMON_T_LCRIT |
-	HWMON_T_CRIT_ALARM | HWMON_T_LCRIT_ALARM |
-	HWMON_T_LABEL,
-	0,
-};
-
-static const struct hwmon_channel_info sfp_hwmon_temp_channel_info = {
-	.type = hwmon_temp,
-	.config = sfp_hwmon_temp_config,
-};
-
-static u32 sfp_hwmon_vcc_config[] = {
-	HWMON_I_INPUT |
-	HWMON_I_MAX | HWMON_I_MIN |
-	HWMON_I_MAX_ALARM | HWMON_I_MIN_ALARM |
-	HWMON_I_CRIT | HWMON_I_LCRIT |
-	HWMON_I_CRIT_ALARM | HWMON_I_LCRIT_ALARM |
-	HWMON_I_LABEL,
-	0,
-};
-
-static const struct hwmon_channel_info sfp_hwmon_vcc_channel_info = {
-	.type = hwmon_in,
-	.config = sfp_hwmon_vcc_config,
-};
-
-static u32 sfp_hwmon_bias_config[] = {
-	HWMON_C_INPUT |
-	HWMON_C_MAX | HWMON_C_MIN |
-	HWMON_C_MAX_ALARM | HWMON_C_MIN_ALARM |
-	HWMON_C_CRIT | HWMON_C_LCRIT |
-	HWMON_C_CRIT_ALARM | HWMON_C_LCRIT_ALARM |
-	HWMON_C_LABEL,
-	0,
-};
-
-static const struct hwmon_channel_info sfp_hwmon_bias_channel_info = {
-	.type = hwmon_curr,
-	.config = sfp_hwmon_bias_config,
-};
-
-static u32 sfp_hwmon_power_config[] = {
-	/* Transmit power */
-	HWMON_P_INPUT |
-	HWMON_P_MAX | HWMON_P_MIN |
-	HWMON_P_MAX_ALARM | HWMON_P_MIN_ALARM |
-	HWMON_P_CRIT | HWMON_P_LCRIT |
-	HWMON_P_CRIT_ALARM | HWMON_P_LCRIT_ALARM |
-	HWMON_P_LABEL,
-	/* Receive power */
-	HWMON_P_INPUT |
-	HWMON_P_MAX | HWMON_P_MIN |
-	HWMON_P_MAX_ALARM | HWMON_P_MIN_ALARM |
-	HWMON_P_CRIT | HWMON_P_LCRIT |
-	HWMON_P_CRIT_ALARM | HWMON_P_LCRIT_ALARM |
-	HWMON_P_LABEL,
-	0,
-};
-
-static const struct hwmon_channel_info sfp_hwmon_power_channel_info = {
-	.type = hwmon_power,
-	.config = sfp_hwmon_power_config,
-};
-
 static const struct hwmon_channel_info *sfp_hwmon_info[] = {
-	&sfp_hwmon_chip,
-	&sfp_hwmon_vcc_channel_info,
-	&sfp_hwmon_temp_channel_info,
-	&sfp_hwmon_bias_channel_info,
-	&sfp_hwmon_power_channel_info,
+	HWMON_CHANNEL_INFO(chip,
+			   HWMON_C_REGISTER_TZ),
+	HWMON_CHANNEL_INFO(in,
+			   HWMON_I_INPUT |
+			   HWMON_I_MAX | HWMON_I_MIN |
+			   HWMON_I_MAX_ALARM | HWMON_I_MIN_ALARM |
+			   HWMON_I_CRIT | HWMON_I_LCRIT |
+			   HWMON_I_CRIT_ALARM | HWMON_I_LCRIT_ALARM |
+			   HWMON_I_LABEL),
+	HWMON_CHANNEL_INFO(temp,
+			   HWMON_T_INPUT |
+			   HWMON_T_MAX | HWMON_T_MIN |
+			   HWMON_T_MAX_ALARM | HWMON_T_MIN_ALARM |
+			   HWMON_T_CRIT | HWMON_T_LCRIT |
+			   HWMON_T_CRIT_ALARM | HWMON_T_LCRIT_ALARM |
+			   HWMON_T_LABEL),
+	HWMON_CHANNEL_INFO(curr,
+			   HWMON_C_INPUT |
+			   HWMON_C_MAX | HWMON_C_MIN |
+			   HWMON_C_MAX_ALARM | HWMON_C_MIN_ALARM |
+			   HWMON_C_CRIT | HWMON_C_LCRIT |
+			   HWMON_C_CRIT_ALARM | HWMON_C_LCRIT_ALARM |
+			   HWMON_C_LABEL),
+	HWMON_CHANNEL_INFO(power,
+			   /* Transmit power */
+			   HWMON_P_INPUT |
+			   HWMON_P_MAX | HWMON_P_MIN |
+			   HWMON_P_MAX_ALARM | HWMON_P_MIN_ALARM |
+			   HWMON_P_CRIT | HWMON_P_LCRIT |
+			   HWMON_P_CRIT_ALARM | HWMON_P_LCRIT_ALARM |
+			   HWMON_P_LABEL,
+			   /* Receive power */
+			   HWMON_P_INPUT |
+			   HWMON_P_MAX | HWMON_P_MIN |
+			   HWMON_P_MAX_ALARM | HWMON_P_MIN_ALARM |
+			   HWMON_P_CRIT | HWMON_P_LCRIT |
+			   HWMON_P_CRIT_ALARM | HWMON_P_LCRIT_ALARM |
+			   HWMON_P_LABEL),
 	NULL,
 };
 
-- 
2.25.1

