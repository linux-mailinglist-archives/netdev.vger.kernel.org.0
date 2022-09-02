Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC755AAC2B
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 12:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbiIBKQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 06:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbiIBKQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 06:16:21 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45FFA024D
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 03:16:19 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id v7-20020a1cac07000000b003a6062a4f81so3050811wme.1
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 03:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=lIu1VMzuHOf4otgmn5PSYSFBtSwiOzrtNK3zHzV551E=;
        b=ESXd+mUFuCgJ8flokV92U0REiBHOwOVmS0EUCcGrX7avat0KNGPI5W4jdlTPpFgIHs
         LFlJsAvUh4IukHiqTpbmc6fz48G+IlTYajLFlOcd90wAfZawraN9lgs98+Xjg2l4D16p
         68+R5m3dZezAZuID/jwvx/tLzARyx4I5CLtSI++VbO2D3dhQKIF2FwDm4leC2U42MCCL
         guUo5LfuS3a2xNtYQNz1RcLxtNNpVr27RJh9rlR8+n7Pu+gYiN0OP/G9w7H3y7uUizDZ
         XtcNgKqSkpEQBi4yTzOS1MmmRKAIoY77bZHnaDs1GBmNqM4sxYElZNf6umSa9pauGq7j
         BrCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=lIu1VMzuHOf4otgmn5PSYSFBtSwiOzrtNK3zHzV551E=;
        b=tbTxMO/y2MAnlZAZKGm5buAYQQGMh/mzdfpbvhv2JW4QB3xdm2cu0fUra1cAv2BIq8
         Zcy2ha48S3bYTy0F6cwU+JP2aPC7fANFjY4WwflVA1etkeNNOwUmacIDrsfbDfRGs9K7
         xgBX1o11EeGHCCmRj9OZuRdmxeIeVSovm18EGb0exch1Ufi3yQ34bd/OMGSLEuayfyet
         cu0flShWniiav++q/yTM7HqFbP5uUcOCtlLQdebEr9rMHBzvdFAeqvLfiGOOSdZB9+HA
         KkW49wd5zSCkVOcN11pX/Zw3FdInG4K2Wp2I2ylEToMw7hJLdxUrDIIcXb7mbTyFqsUu
         mHuw==
X-Gm-Message-State: ACgBeo2PFyY3j9IJOCSzKrV9e22skaEBtMT5uW0nzm0yI5Eh/GoLgHps
        8i4dMp352CR2wXxmGPW2OT7Mz6drEPMHFA==
X-Google-Smtp-Source: AA6agR60z37ISZkEjTfLiQe/r/8jBFmd0kEd3HH07A9vu/SDAzr4hkuCL5NWJIT1qv9fBteLMfiDiA==
X-Received: by 2002:a7b:c7d8:0:b0:3a6:34d2:1705 with SMTP id z24-20020a7bc7d8000000b003a634d21705mr2269043wmk.206.1662113778106;
        Fri, 02 Sep 2022 03:16:18 -0700 (PDT)
Received: from P-NTS-Evian.home (2a01cb058f8a18001c97b8d1b477d53f.ipv6.abo.wanadoo.fr. [2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f])
        by smtp.gmail.com with ESMTPSA id a8-20020adfeec8000000b00226d1821abesm1140913wrp.56.2022.09.02.03.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 03:16:17 -0700 (PDT)
From:   Romain Naour <romain.naour@smile.fr>
To:     netdev@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, olteanv@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        Romain Naour <romain.naour@skf.com>
Subject: [PATCH v3: net-next 4/4] net: dsa: microchip: add regmap_range for KSZ9896 chip
Date:   Fri,  2 Sep 2022 12:16:10 +0200
Message-Id: <20220902101610.109646-4-romain.naour@smile.fr>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220902101610.109646-1-romain.naour@smile.fr>
References: <20220902101610.109646-1-romain.naour@smile.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Romain Naour <romain.naour@skf.com>

Add register validation for KSZ9896.

Signed-off-by: Romain Naour <romain.naour@skf.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 215 +++++++++++++++++++++++++
 1 file changed, 215 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index a700631130e0..7389837ddd84 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -802,6 +802,219 @@ static const struct regmap_access_table ksz9477_register_set = {
 	.n_yes_ranges = ARRAY_SIZE(ksz9477_valid_regs),
 };
 
+static const struct regmap_range ksz9896_valid_regs[] = {
+	regmap_reg_range(0x0000, 0x0003),
+	regmap_reg_range(0x0006, 0x0006),
+	regmap_reg_range(0x0010, 0x001f),
+	regmap_reg_range(0x0100, 0x0100),
+	regmap_reg_range(0x0103, 0x0107),
+	regmap_reg_range(0x010d, 0x010d),
+	regmap_reg_range(0x0110, 0x0113),
+	regmap_reg_range(0x0120, 0x0127),
+	regmap_reg_range(0x0201, 0x0201),
+	regmap_reg_range(0x0210, 0x0213),
+	regmap_reg_range(0x0300, 0x0300),
+	regmap_reg_range(0x0302, 0x030b),
+	regmap_reg_range(0x0310, 0x031b),
+	regmap_reg_range(0x0320, 0x032b),
+	regmap_reg_range(0x0330, 0x0336),
+	regmap_reg_range(0x0338, 0x033b),
+	regmap_reg_range(0x033e, 0x033e),
+	regmap_reg_range(0x0340, 0x035f),
+	regmap_reg_range(0x0370, 0x0370),
+	regmap_reg_range(0x0378, 0x0378),
+	regmap_reg_range(0x037c, 0x037d),
+	regmap_reg_range(0x0390, 0x0393),
+	regmap_reg_range(0x0400, 0x040e),
+	regmap_reg_range(0x0410, 0x042f),
+
+	/* port 1 */
+	regmap_reg_range(0x1000, 0x1001),
+	regmap_reg_range(0x1013, 0x1013),
+	regmap_reg_range(0x1017, 0x1017),
+	regmap_reg_range(0x101b, 0x101b),
+	regmap_reg_range(0x101f, 0x1020),
+	regmap_reg_range(0x1030, 0x1030),
+	regmap_reg_range(0x1100, 0x1115),
+	regmap_reg_range(0x111a, 0x111f),
+	regmap_reg_range(0x1122, 0x1127),
+	regmap_reg_range(0x112a, 0x112b),
+	regmap_reg_range(0x1136, 0x1139),
+	regmap_reg_range(0x113e, 0x113f),
+	regmap_reg_range(0x1400, 0x1401),
+	regmap_reg_range(0x1403, 0x1403),
+	regmap_reg_range(0x1410, 0x1417),
+	regmap_reg_range(0x1420, 0x1423),
+	regmap_reg_range(0x1500, 0x1507),
+	regmap_reg_range(0x1600, 0x1612),
+	regmap_reg_range(0x1800, 0x180f),
+	regmap_reg_range(0x1820, 0x1827),
+	regmap_reg_range(0x1830, 0x1837),
+	regmap_reg_range(0x1840, 0x184b),
+	regmap_reg_range(0x1900, 0x1907),
+	regmap_reg_range(0x1914, 0x1915),
+	regmap_reg_range(0x1a00, 0x1a03),
+	regmap_reg_range(0x1a04, 0x1a07),
+	regmap_reg_range(0x1b00, 0x1b01),
+	regmap_reg_range(0x1b04, 0x1b04),
+
+	/* port 2 */
+	regmap_reg_range(0x2000, 0x2001),
+	regmap_reg_range(0x2013, 0x2013),
+	regmap_reg_range(0x2017, 0x2017),
+	regmap_reg_range(0x201b, 0x201b),
+	regmap_reg_range(0x201f, 0x2020),
+	regmap_reg_range(0x2030, 0x2030),
+	regmap_reg_range(0x2100, 0x2115),
+	regmap_reg_range(0x211a, 0x211f),
+	regmap_reg_range(0x2122, 0x2127),
+	regmap_reg_range(0x212a, 0x212b),
+	regmap_reg_range(0x2136, 0x2139),
+	regmap_reg_range(0x213e, 0x213f),
+	regmap_reg_range(0x2400, 0x2401),
+	regmap_reg_range(0x2403, 0x2403),
+	regmap_reg_range(0x2410, 0x2417),
+	regmap_reg_range(0x2420, 0x2423),
+	regmap_reg_range(0x2500, 0x2507),
+	regmap_reg_range(0x2600, 0x2612),
+	regmap_reg_range(0x2800, 0x280f),
+	regmap_reg_range(0x2820, 0x2827),
+	regmap_reg_range(0x2830, 0x2837),
+	regmap_reg_range(0x2840, 0x284b),
+	regmap_reg_range(0x2900, 0x2907),
+	regmap_reg_range(0x2914, 0x2915),
+	regmap_reg_range(0x2a00, 0x2a03),
+	regmap_reg_range(0x2a04, 0x2a07),
+	regmap_reg_range(0x2b00, 0x2b01),
+	regmap_reg_range(0x2b04, 0x2b04),
+
+	/* port 3 */
+	regmap_reg_range(0x3000, 0x3001),
+	regmap_reg_range(0x3013, 0x3013),
+	regmap_reg_range(0x3017, 0x3017),
+	regmap_reg_range(0x301b, 0x301b),
+	regmap_reg_range(0x301f, 0x3020),
+	regmap_reg_range(0x3030, 0x3030),
+	regmap_reg_range(0x3100, 0x3115),
+	regmap_reg_range(0x311a, 0x311f),
+	regmap_reg_range(0x3122, 0x3127),
+	regmap_reg_range(0x312a, 0x312b),
+	regmap_reg_range(0x3136, 0x3139),
+	regmap_reg_range(0x313e, 0x313f),
+	regmap_reg_range(0x3400, 0x3401),
+	regmap_reg_range(0x3403, 0x3403),
+	regmap_reg_range(0x3410, 0x3417),
+	regmap_reg_range(0x3420, 0x3423),
+	regmap_reg_range(0x3500, 0x3507),
+	regmap_reg_range(0x3600, 0x3612),
+	regmap_reg_range(0x3800, 0x380f),
+	regmap_reg_range(0x3820, 0x3827),
+	regmap_reg_range(0x3830, 0x3837),
+	regmap_reg_range(0x3840, 0x384b),
+	regmap_reg_range(0x3900, 0x3907),
+	regmap_reg_range(0x3914, 0x3915),
+	regmap_reg_range(0x3a00, 0x3a03),
+	regmap_reg_range(0x3a04, 0x3a07),
+	regmap_reg_range(0x3b00, 0x3b01),
+	regmap_reg_range(0x3b04, 0x3b04),
+
+	/* port 4 */
+	regmap_reg_range(0x4000, 0x4001),
+	regmap_reg_range(0x4013, 0x4013),
+	regmap_reg_range(0x4017, 0x4017),
+	regmap_reg_range(0x401b, 0x401b),
+	regmap_reg_range(0x401f, 0x4020),
+	regmap_reg_range(0x4030, 0x4030),
+	regmap_reg_range(0x4100, 0x4115),
+	regmap_reg_range(0x411a, 0x411f),
+	regmap_reg_range(0x4122, 0x4127),
+	regmap_reg_range(0x412a, 0x412b),
+	regmap_reg_range(0x4136, 0x4139),
+	regmap_reg_range(0x413e, 0x413f),
+	regmap_reg_range(0x4400, 0x4401),
+	regmap_reg_range(0x4403, 0x4403),
+	regmap_reg_range(0x4410, 0x4417),
+	regmap_reg_range(0x4420, 0x4423),
+	regmap_reg_range(0x4500, 0x4507),
+	regmap_reg_range(0x4600, 0x4612),
+	regmap_reg_range(0x4800, 0x480f),
+	regmap_reg_range(0x4820, 0x4827),
+	regmap_reg_range(0x4830, 0x4837),
+	regmap_reg_range(0x4840, 0x484b),
+	regmap_reg_range(0x4900, 0x4907),
+	regmap_reg_range(0x4914, 0x4915),
+	regmap_reg_range(0x4a00, 0x4a03),
+	regmap_reg_range(0x4a04, 0x4a07),
+	regmap_reg_range(0x4b00, 0x4b01),
+	regmap_reg_range(0x4b04, 0x4b04),
+
+	/* port 5 */
+	regmap_reg_range(0x5000, 0x5001),
+	regmap_reg_range(0x5013, 0x5013),
+	regmap_reg_range(0x5017, 0x5017),
+	regmap_reg_range(0x501b, 0x501b),
+	regmap_reg_range(0x501f, 0x5020),
+	regmap_reg_range(0x5030, 0x5030),
+	regmap_reg_range(0x5100, 0x5115),
+	regmap_reg_range(0x511a, 0x511f),
+	regmap_reg_range(0x5122, 0x5127),
+	regmap_reg_range(0x512a, 0x512b),
+	regmap_reg_range(0x5136, 0x5139),
+	regmap_reg_range(0x513e, 0x513f),
+	regmap_reg_range(0x5400, 0x5401),
+	regmap_reg_range(0x5403, 0x5403),
+	regmap_reg_range(0x5410, 0x5417),
+	regmap_reg_range(0x5420, 0x5423),
+	regmap_reg_range(0x5500, 0x5507),
+	regmap_reg_range(0x5600, 0x5612),
+	regmap_reg_range(0x5800, 0x580f),
+	regmap_reg_range(0x5820, 0x5827),
+	regmap_reg_range(0x5830, 0x5837),
+	regmap_reg_range(0x5840, 0x584b),
+	regmap_reg_range(0x5900, 0x5907),
+	regmap_reg_range(0x5914, 0x5915),
+	regmap_reg_range(0x5a00, 0x5a03),
+	regmap_reg_range(0x5a04, 0x5a07),
+	regmap_reg_range(0x5b00, 0x5b01),
+	regmap_reg_range(0x5b04, 0x5b04),
+
+	/* port 6 */
+	regmap_reg_range(0x6000, 0x6001),
+	regmap_reg_range(0x6013, 0x6013),
+	regmap_reg_range(0x6017, 0x6017),
+	regmap_reg_range(0x601b, 0x601b),
+	regmap_reg_range(0x601f, 0x6020),
+	regmap_reg_range(0x6030, 0x6030),
+	regmap_reg_range(0x6100, 0x6115),
+	regmap_reg_range(0x611a, 0x611f),
+	regmap_reg_range(0x6122, 0x6127),
+	regmap_reg_range(0x612a, 0x612b),
+	regmap_reg_range(0x6136, 0x6139),
+	regmap_reg_range(0x613e, 0x613f),
+	regmap_reg_range(0x6300, 0x6301),
+	regmap_reg_range(0x6400, 0x6401),
+	regmap_reg_range(0x6403, 0x6403),
+	regmap_reg_range(0x6410, 0x6417),
+	regmap_reg_range(0x6420, 0x6423),
+	regmap_reg_range(0x6500, 0x6507),
+	regmap_reg_range(0x6600, 0x6612),
+	regmap_reg_range(0x6800, 0x680f),
+	regmap_reg_range(0x6820, 0x6827),
+	regmap_reg_range(0x6830, 0x6837),
+	regmap_reg_range(0x6840, 0x684b),
+	regmap_reg_range(0x6900, 0x6907),
+	regmap_reg_range(0x6914, 0x6915),
+	regmap_reg_range(0x6a00, 0x6a03),
+	regmap_reg_range(0x6a04, 0x6a07),
+	regmap_reg_range(0x6b00, 0x6b01),
+	regmap_reg_range(0x6b04, 0x6b04),
+};
+
+static const struct regmap_access_table ksz9896_register_set = {
+	.yes_ranges = ksz9896_valid_regs,
+	.n_yes_ranges = ARRAY_SIZE(ksz9896_valid_regs),
+};
+
 const struct ksz_chip_data ksz_switch_chips[] = {
 	[KSZ8563] = {
 		.chip_id = KSZ8563_CHIP_ID,
@@ -993,6 +1206,8 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.internal_phy	= {true, true, true, true,
 				   true, false},
 		.gbit_capable	= {true, true, true, true, true, true},
+		.wr_table = &ksz9896_register_set,
+		.rd_table = &ksz9896_register_set,
 	},
 
 	[KSZ9897] = {
-- 
2.34.3

