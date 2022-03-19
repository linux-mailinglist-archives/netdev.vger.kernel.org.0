Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FF84DE782
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 12:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiCSLGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 07:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbiCSLGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 07:06:48 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738023EAB2
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 04:05:26 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 25so14179942ljv.10
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 04:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=4kNmRlPkw8/mO6HnlzwVCIgo9lfZqqDVHZ+GWqNU5W8=;
        b=nQPEsRhTSLTR+ngO7wqJMPZUA5zz1c5a3GZie5rSYXYz7FUGwispb5doRsDkCzqNNB
         f77sCgiJJQOeuiw/eFOY5ui7vi8Zyp7oLOLEnPA4OchnuAokbzAkytWIY4uoDG7U0XdP
         FeBbS9YGKHFbuqifiDSK0ONIPw5jVY1jWMxvPU0JWLStuSAjmNEaPAJuXqTiX3QurMuN
         5mSvoDxtbr9Mzeq5ROvxGgAlplzY/fRZb1S7yzR2vK/J8TFB08Bnq0a3qIZhme25LoEG
         8GvR2xG6DZQwrBG30FwfM91GP0PYHE+xcOqrPqaOqfd6v2vEvWEVeXrlrQCXpJGJQw8d
         HnHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=4kNmRlPkw8/mO6HnlzwVCIgo9lfZqqDVHZ+GWqNU5W8=;
        b=LFWGw4qBSEsLF7jmiRTWKli0H83idMN0KK7XrLxVB0GRvt6wV8aYXoZWaK3VPN+03b
         DjXzgNsJZPA0eLQeWRw85cyfd81evu516W07NtNtUKxSHpq8tsGpcuKFEFwEIq0tL9M+
         8DAXwvkAGKfwhJSEd7myFGhc75uY6NGK5z6NEcuzxjrzFZ7JNWCDZybw41hozX24JPR+
         homw2UjfWAtJUziXILYvxrZMe1FP8BhodTHhtFnMjV/09KUKWcpQSpNofihLn4/v0Iu4
         1ZLNcci1k40tmX4DTapqRY4gvuHdmRHWpSAtcweevBFCEHtIRkziPy/C41mPkHSSZ6pR
         2ipA==
X-Gm-Message-State: AOAM532MQMhb2Uje8+PUhUZ4PH44OXgGZl0Ir59sdhzjAz6RvHCeGCU+
        Bl+xcP9t6sbu8LE13ykbSnsURw==
X-Google-Smtp-Source: ABdhPJxHl9y5FDztpZe+Lj5EIC3j785BJvnzbyaLi/OOwWQCI4lL5Ttj5qq7E0B5rF/++kcmib5mzg==
X-Received: by 2002:a2e:a552:0:b0:249:3f52:9fec with SMTP id e18-20020a2ea552000000b002493f529fecmr8737794ljn.341.1647687924617;
        Sat, 19 Mar 2022 04:05:24 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id q2-20020a196e42000000b00448b80621d8sm1265562lfk.7.2022.03.19.04.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 04:05:24 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: dsa: mv88e6xxx: Fill in STU support for all supported chips
Date:   Sat, 19 Mar 2022 12:03:45 +0100
Message-Id: <20220319110345.555270-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some chips using the split VTU/STU design will not accept VTU entries
who's SID points to an invalid STU entry. Therefore, mark all those
chips with either the mv88e6352_g1_stu_* or mv88e6390_g1_stu_* ops as
appropriate.

Notably, chips for the Opal Plus (6085/6097) era seem to use a
different implementation than those from Agate (6352) and onwards,
even though their external interface is the same. The former happily
accepts VTU entries referencing invalid STU entries, while the latter
does not.

This fixes an issue where the driver would fail to probe switch trees
that contained chips of the Agate/Topaz generation which did not
declare STU support, as loaded VTU entries would be read back as
invalid.

Fixes: 49c98c1dc7d9 ("net: dsa: mv88e6xxx: Disentangle STU from VTU")
Reported-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 48 ++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b36393ba6d49..34af6f46141f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4064,6 +4064,8 @@ static const struct mv88e6xxx_ops mv88e6085_ops = {
 	.rmu_disable = mv88e6085_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6352_g1_stu_getnext,
+	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
@@ -4184,6 +4186,8 @@ static const struct mv88e6xxx_ops mv88e6123_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6352_g1_stu_getnext,
+	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
@@ -4273,6 +4277,8 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6352_g1_stu_getnext,
+	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
 	/* Check status register pause & lpa register */
@@ -4329,6 +4335,8 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6352_g1_stu_getnext,
+	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
 	.avb_ops = &mv88e6165_avb_ops,
 	.ptp_ops = &mv88e6165_ptp_ops,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
@@ -4365,6 +4373,8 @@ static const struct mv88e6xxx_ops mv88e6165_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6352_g1_stu_getnext,
+	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
 	.avb_ops = &mv88e6165_avb_ops,
 	.ptp_ops = &mv88e6165_ptp_ops,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
@@ -4409,6 +4419,8 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6352_g1_stu_getnext,
+	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
 };
 
@@ -4455,6 +4467,8 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6352_g1_stu_getnext,
+	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
 	.serdes_pcs_get_state = mv88e6352_serdes_pcs_get_state,
 	.serdes_pcs_config = mv88e6352_serdes_pcs_config,
@@ -4506,6 +4520,8 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6352_g1_stu_getnext,
+	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
 };
 
@@ -4552,6 +4568,8 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6352_g1_stu_getnext,
+	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
 	.serdes_pcs_get_state = mv88e6352_serdes_pcs_get_state,
 	.serdes_pcs_config = mv88e6352_serdes_pcs_config,
@@ -4651,6 +4669,8 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6390_g1_stu_getnext,
+	.stu_loadpurge = mv88e6390_g1_stu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
 	/* Check status register pause & lpa register */
@@ -4712,6 +4732,8 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6390_g1_stu_getnext,
+	.stu_loadpurge = mv88e6390_g1_stu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390x_serdes_get_lane,
 	/* Check status register pause & lpa register */
@@ -4771,6 +4793,8 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6390_g1_stu_getnext,
+	.stu_loadpurge = mv88e6390_g1_stu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
 	/* Check status register pause & lpa register */
@@ -4833,6 +4857,8 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6352_g1_stu_getnext,
+	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
 	.serdes_pcs_get_state = mv88e6352_serdes_pcs_get_state,
 	.serdes_pcs_config = mv88e6352_serdes_pcs_config,
@@ -4933,6 +4959,8 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6390_g1_stu_getnext,
+	.stu_loadpurge = mv88e6390_g1_stu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
 	/* Check status register pause & lpa register */
@@ -5084,6 +5112,8 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6352_g1_stu_getnext,
+	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
 	/* Check status register pause & lpa register */
@@ -5144,6 +5174,8 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6352_g1_stu_getnext,
+	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
 };
 
@@ -5186,6 +5218,8 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6352_g1_stu_getnext,
+	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
@@ -5466,6 +5500,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 10,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
+		.max_sid = 63,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5532,6 +5567,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 3,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
+		.max_sid = 63,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5576,6 +5612,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.num_gpio = 11,
 		.max_vid = 4095,
+		.max_sid = 63,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x10,
 		.global1_addr = 0x1b,
@@ -5599,6 +5636,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 6,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
+		.max_sid = 63,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5623,6 +5661,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 6,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
+		.max_sid = 63,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5646,6 +5685,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
+		.max_sid = 63,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5670,6 +5710,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.num_gpio = 15,
 		.max_vid = 4095,
+		.max_sid = 63,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5693,6 +5734,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
+		.max_sid = 63,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5717,6 +5759,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.num_gpio = 15,
 		.max_vid = 4095,
+		.max_sid = 63,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5906,6 +5949,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.num_gpio = 15,
 		.max_vid = 4095,
+		.max_sid = 63,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5951,6 +5995,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 9,
 		.num_gpio = 16,
 		.max_vid = 8191,
+		.max_sid = 63,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6024,6 +6069,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 6,
 		.num_gpio = 11,
 		.max_vid = 4095,
+		.max_sid = 63,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x10,
 		.global1_addr = 0x1b,
@@ -6048,6 +6094,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
+		.max_sid = 63,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6071,6 +6118,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
+		.max_sid = 63,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
-- 
2.25.1

