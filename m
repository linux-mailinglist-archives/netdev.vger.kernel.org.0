Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14648690387
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjBIJYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjBIJYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:24:11 -0500
Received: from mr85p00im-zteg06023901.me.com (mr85p00im-zteg06023901.me.com [17.58.23.192])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAE161856
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 01:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1675934301; bh=l5/w8qzS8eROrSTSdYL3TF863UssIMOFYBR22gS7cAY=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=SbAzunJ6FLU016F/cc/EjMNDH/P8jyPB+PyhVT4GTts7KQwLycRHDYA+ptWx45CiP
         gUVOUg3pM0d7mDkMOM3YQZGPjjpLQPk9UZEIs4IeBmsx2lWTQ2TZcR9xmVSu3r2whZ
         p/B3CR2yy+Ut6WG2PaaiotK7Vn+qAXjeU6veSqHfvPcM1ajN1tD7geHvASdAel+urX
         vmbSlwpNI9DLxulWrCzbjSyQPm9q+m5FjNWFnXsyRFTYRxrlzgdMPdWRHVnLobNf+6
         zS8D0mvwv0OR/toDJsk7bOqA5l0jL1yElQ1Ogq6Vb6cvTu0jfsaxslU8T58J113qe1
         poYcwtMXsFudg==
Received: from localhost (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-zteg06023901.me.com (Postfix) with ESMTPSA id D40EE6E0EC8;
        Thu,  9 Feb 2023 09:18:20 +0000 (UTC)
From:   Alain Volmat <avolmat@me.com>
To:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-pm@vger.kernel.org,
        linux-clk@vger.kernel.org, Alain Volmat <avolmat@me.com>
Subject: [PATCH 03/11] irqchip/st: remove stih415/stih416 and stid127 platforms support
Date:   Thu,  9 Feb 2023 10:16:51 +0100
Message-Id: <20230209091659.1409-4-avolmat@me.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209091659.1409-1-avolmat@me.com>
References: <20230209091659.1409-1-avolmat@me.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: pz0XQy9R-Ydn-oBIWTvKFNEJ-fXGsuFC
X-Proofpoint-ORIG-GUID: pz0XQy9R-Ydn-oBIWTvKFNEJ-fXGsuFC
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0 spamscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2302090088
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove support for the already no more supported stih415 and stih416
platforms.  Remove as well the stid127 platform which never made it
up to the kernel.

Signed-off-by: Alain Volmat <avolmat@me.com>
---
 drivers/irqchip/irq-st.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/irqchip/irq-st.c b/drivers/irqchip/irq-st.c
index 1b83512b29c6..819a12297b58 100644
--- a/drivers/irqchip/irq-st.c
+++ b/drivers/irqchip/irq-st.c
@@ -15,10 +15,7 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 
-#define STIH415_SYSCFG_642		0x0a8
-#define STIH416_SYSCFG_7543		0x87c
 #define STIH407_SYSCFG_5102		0x198
-#define STID127_SYSCFG_734		0x088
 
 #define ST_A9_IRQ_MASK			0x001FFFFF
 #define ST_A9_IRQ_MAX_CHANS		2
@@ -44,22 +41,10 @@ struct st_irq_syscfg {
 };
 
 static const struct of_device_id st_irq_syscfg_match[] = {
-	{
-		.compatible = "st,stih415-irq-syscfg",
-		.data = (void *)STIH415_SYSCFG_642,
-	},
-	{
-		.compatible = "st,stih416-irq-syscfg",
-		.data = (void *)STIH416_SYSCFG_7543,
-	},
 	{
 		.compatible = "st,stih407-irq-syscfg",
 		.data = (void *)STIH407_SYSCFG_5102,
 	},
-	{
-		.compatible = "st,stid127-irq-syscfg",
-		.data = (void *)STID127_SYSCFG_734,
-	},
 	{}
 };
 
-- 
2.34.1

