Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5154E8229
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbiCZRDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbiCZRCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:02:48 -0400
Received: from stuerz.xyz (unknown [45.77.206.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6D413E14D;
        Sat, 26 Mar 2022 10:00:57 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 7E2DEFBC01; Sat, 26 Mar 2022 17:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314056; bh=mxL996mePhc5doSrJVmK9wWxYLVsdD05aWSE5jpqwgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/kM4yfwuqLmw3KkaEYW0f9H0EGrDwFEOW59wezrmvV0lSyCvgB3WAT5xEKpIo4J+
         emEFYNwfXF6TrKahijeGP2FA3h++kZXU5+/BVQ5+zmHoyRklXur8kKz5A+Fy5iF2cY
         m1zR1eDGol00B4xwNCEFV9WnEA2gtoTCdTnqNgcwruAK9Vym1Q/rNJw4Jb/QoeuvcW
         cRmw1poJa6Nc9y83+eg9bUDMSym8U98GPO+AasHU2lTaqZfoQZs7WZqO6dccdoQWK4
         Dv504iyYu2bThOTUt6INOIw795O326gSCDL6ri3BRyUEZp6jI5flPhbfHer7WIC+3+
         LROo2c0BLmBGw==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id B5CC6FBBC5;
        Sat, 26 Mar 2022 17:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314053; bh=mxL996mePhc5doSrJVmK9wWxYLVsdD05aWSE5jpqwgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ISm2sICjREB7i6ZY+hcmpK+FAsc4ir5tgtu2b41kIUk8cdnWXYPNctMwWMc+yqGY
         xE89kOsZJ5+h2o+7XWUivQuolcP2KXzXGQb6fd+Y8TS0yuYWbNOSN6btuEooHVjjuj
         8JKZZMBk8tYdjI3JgefS7seEI0GtGtqQx9E0AqC67Np8T82c4FRLR6NZg4I3/yK/j5
         L5uQ4pIe/JOu6y1D2+f9m3W6obafdHos+wMy1+w/a2sknJdP3KnxZG1eeX8AWjzYTg
         8On2/ySm9JPTp33qSK7+6dLyxuQTCUT1vZM6WbotlhOjRkLsDStcjg352nzJOes48/
         aK7RGoHdkjlsg==
From:   =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benni@stuerz.xyz>
To:     andrew@lunn.ch
Cc:     sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux@armlinux.org.uk, linux@simtec.co.uk, krzk@kernel.org,
        alim.akhtar@samsung.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        robert.moore@intel.com, rafael.j.wysocki@intel.com,
        lenb@kernel.org, 3chas3@gmail.com, laforge@gnumonks.org,
        arnd@arndb.de, gregkh@linuxfoundation.org, mchehab@kernel.org,
        tony.luck@intel.com, james.morse@arm.com, rric@kernel.org,
        linus.walleij@linaro.org, brgl@bgdev.pl,
        mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca,
        pali@kernel.org, dmitry.torokhov@gmail.com, isdn@linux-pingi.de,
        benh@kernel.crashing.org, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        nico@fluxnic.net, loic.poulain@linaro.org, kvalo@kernel.org,
        pkshih@realtek.com, bhelgaas@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-input@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org,
        =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benni@stuerz.xyz>
Subject: [PATCH 14/22] mISDN: Replace comments with C99 initializers
Date:   Sat, 26 Mar 2022 17:59:01 +0100
Message-Id: <20220326165909.506926-14-benni@stuerz.xyz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220326165909.506926-1-benni@stuerz.xyz>
References: <20220326165909.506926-1-benni@stuerz.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RDNS_DYNAMIC,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This replaces comments with C99's designated
initializers because the kernel supports them now.

Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 88 +++++++++++++-------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 4f7eaa17fb27..fb6ed4167845 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -5283,50 +5283,50 @@ static void hfc_remove_pci(struct pci_dev *pdev)
 #define VENDOR_PRIM	"PrimuX"
 
 static const struct hm_map hfcm_map[] = {
-	/*0*/	{VENDOR_BN, "HFC-1S Card (mini PCI)", 4, 1, 1, 3, 0, DIP_4S, 0, 0},
-	/*1*/	{VENDOR_BN, "HFC-2S Card", 4, 2, 1, 3, 0, DIP_4S, 0, 0},
-	/*2*/	{VENDOR_BN, "HFC-2S Card (mini PCI)", 4, 2, 1, 3, 0, DIP_4S, 0, 0},
-	/*3*/	{VENDOR_BN, "HFC-4S Card", 4, 4, 1, 2, 0, DIP_4S, 0, 0},
-	/*4*/	{VENDOR_BN, "HFC-4S Card (mini PCI)", 4, 4, 1, 2, 0, 0, 0, 0},
-	/*5*/	{VENDOR_CCD, "HFC-4S Eval (old)", 4, 4, 0, 0, 0, 0, 0, 0},
-	/*6*/	{VENDOR_CCD, "HFC-4S IOB4ST", 4, 4, 1, 2, 0, DIP_4S, 0, 0},
-	/*7*/	{VENDOR_CCD, "HFC-4S", 4, 4, 1, 2, 0, 0, 0, 0},
-	/*8*/	{VENDOR_DIG, "HFC-4S Card", 4, 4, 0, 2, 0, 0, HFC_IO_MODE_REGIO, 0},
-	/*9*/	{VENDOR_CCD, "HFC-4S Swyx 4xS0 SX2 QuadBri", 4, 4, 1, 2, 0, 0, 0, 0},
-	/*10*/	{VENDOR_JH, "HFC-4S (junghanns 2.0)", 4, 4, 1, 2, 0, 0, 0, 0},
-	/*11*/	{VENDOR_PRIM, "HFC-2S Primux Card", 4, 2, 0, 0, 0, 0, 0, 0},
-
-	/*12*/	{VENDOR_BN, "HFC-8S Card", 8, 8, 1, 0, 0, 0, 0, 0},
-	/*13*/	{VENDOR_BN, "HFC-8S Card (+)", 8, 8, 1, 8, 0, DIP_8S,
-		 HFC_IO_MODE_REGIO, 0},
-	/*14*/	{VENDOR_CCD, "HFC-8S Eval (old)", 8, 8, 0, 0, 0, 0, 0, 0},
-	/*15*/	{VENDOR_CCD, "HFC-8S IOB4ST Recording", 8, 8, 1, 0, 0, 0, 0, 0},
-
-	/*16*/	{VENDOR_CCD, "HFC-8S IOB8ST", 8, 8, 1, 0, 0, 0, 0, 0},
-	/*17*/	{VENDOR_CCD, "HFC-8S", 8, 8, 1, 0, 0, 0, 0, 0},
-	/*18*/	{VENDOR_CCD, "HFC-8S", 8, 8, 1, 0, 0, 0, 0, 0},
-
-	/*19*/	{VENDOR_BN, "HFC-E1 Card", 1, 1, 0, 1, 0, DIP_E1, 0, 0},
-	/*20*/	{VENDOR_BN, "HFC-E1 Card (mini PCI)", 1, 1, 0, 1, 0, 0, 0, 0},
-	/*21*/	{VENDOR_BN, "HFC-E1+ Card (Dual)", 1, 1, 0, 1, 0, DIP_E1, 0, 0},
-	/*22*/	{VENDOR_BN, "HFC-E1 Card (Dual)", 1, 1, 0, 1, 0, DIP_E1, 0, 0},
-
-	/*23*/	{VENDOR_CCD, "HFC-E1 Eval (old)", 1, 1, 0, 0, 0, 0, 0, 0},
-	/*24*/	{VENDOR_CCD, "HFC-E1 IOB1E1", 1, 1, 0, 1, 0, 0, 0, 0},
-	/*25*/	{VENDOR_CCD, "HFC-E1", 1, 1, 0, 1, 0, 0, 0, 0},
-
-	/*26*/	{VENDOR_CCD, "HFC-4S Speech Design", 4, 4, 0, 0, 0, 0,
-		 HFC_IO_MODE_PLXSD, 0},
-	/*27*/	{VENDOR_CCD, "HFC-E1 Speech Design", 1, 1, 0, 0, 0, 0,
-		 HFC_IO_MODE_PLXSD, 0},
-	/*28*/	{VENDOR_CCD, "HFC-4S OpenVox", 4, 4, 1, 0, 0, 0, 0, 0},
-	/*29*/	{VENDOR_CCD, "HFC-2S OpenVox", 4, 2, 1, 0, 0, 0, 0, 0},
-	/*30*/	{VENDOR_CCD, "HFC-8S OpenVox", 8, 8, 1, 0, 0, 0, 0, 0},
-	/*31*/	{VENDOR_CCD, "XHFC-4S Speech Design", 5, 4, 0, 0, 0, 0,
-		 HFC_IO_MODE_EMBSD, XHFC_IRQ},
-	/*32*/	{VENDOR_JH, "HFC-8S (junghanns)", 8, 8, 1, 0, 0, 0, 0, 0},
-	/*33*/	{VENDOR_BN, "HFC-2S Beronet Card PCIe", 4, 2, 1, 3, 0, DIP_4S, 0, 0},
-	/*34*/	{VENDOR_BN, "HFC-4S Beronet Card PCIe", 4, 4, 1, 2, 0, DIP_4S, 0, 0},
+	[0]  =	{VENDOR_BN, "HFC-1S Card (mini PCI)", 4, 1, 1, 3, 0, DIP_4S, 0, 0},
+	[1]  =	{VENDOR_BN, "HFC-2S Card", 4, 2, 1, 3, 0, DIP_4S, 0, 0},
+	[2]  =	{VENDOR_BN, "HFC-2S Card (mini PCI)", 4, 2, 1, 3, 0, DIP_4S, 0, 0},
+	[3]  =	{VENDOR_BN, "HFC-4S Card", 4, 4, 1, 2, 0, DIP_4S, 0, 0},
+	[4]  =	{VENDOR_BN, "HFC-4S Card (mini PCI)", 4, 4, 1, 2, 0, 0, 0, 0},
+	[5]  =	{VENDOR_CCD, "HFC-4S Eval (old)", 4, 4, 0, 0, 0, 0, 0, 0},
+	[6]  =	{VENDOR_CCD, "HFC-4S IOB4ST", 4, 4, 1, 2, 0, DIP_4S, 0, 0},
+	[7]  =	{VENDOR_CCD, "HFC-4S", 4, 4, 1, 2, 0, 0, 0, 0},
+	[8]  =	{VENDOR_DIG, "HFC-4S Card", 4, 4, 0, 2, 0, 0, HFC_IO_MODE_REGIO, 0},
+	[9]  =	{VENDOR_CCD, "HFC-4S Swyx 4xS0 SX2 QuadBri", 4, 4, 1, 2, 0, 0, 0, 0},
+	[10] =	{VENDOR_JH, "HFC-4S (junghanns 2.0)", 4, 4, 1, 2, 0, 0, 0, 0},
+	[11] =	{VENDOR_PRIM, "HFC-2S Primux Card", 4, 2, 0, 0, 0, 0, 0, 0},
+
+	[12] =	{VENDOR_BN, "HFC-8S Card", 8, 8, 1, 0, 0, 0, 0, 0},
+	[13] =	{VENDOR_BN, "HFC-8S Card (+)", 8, 8, 1, 8, 0, DIP_8S,
+		       HFC_IO_MODE_REGIO, 0},
+	[14] =	{VENDOR_CCD, "HFC-8S Eval (old)", 8, 8, 0, 0, 0, 0, 0, 0},
+	[15] =	{VENDOR_CCD, "HFC-8S IOB4ST Recording", 8, 8, 1, 0, 0, 0, 0, 0},
+
+	[16] =	{VENDOR_CCD, "HFC-8S IOB8ST", 8, 8, 1, 0, 0, 0, 0, 0},
+	[17] =	{VENDOR_CCD, "HFC-8S", 8, 8, 1, 0, 0, 0, 0, 0},
+	[18] =	{VENDOR_CCD, "HFC-8S", 8, 8, 1, 0, 0, 0, 0, 0},
+
+	[19] =	{VENDOR_BN, "HFC-E1 Card", 1, 1, 0, 1, 0, DIP_E1, 0, 0},
+	[20] =	{VENDOR_BN, "HFC-E1 Card (mini PCI)", 1, 1, 0, 1, 0, 0, 0, 0},
+	[21] =	{VENDOR_BN, "HFC-E1+ Card (Dual)", 1, 1, 0, 1, 0, DIP_E1, 0, 0},
+	[22] =	{VENDOR_BN, "HFC-E1 Card (Dual)", 1, 1, 0, 1, 0, DIP_E1, 0, 0},
+
+	[23] =	{VENDOR_CCD, "HFC-E1 Eval (old)", 1, 1, 0, 0, 0, 0, 0, 0},
+	[24] =	{VENDOR_CCD, "HFC-E1 IOB1E1", 1, 1, 0, 1, 0, 0, 0, 0},
+	[25] =	{VENDOR_CCD, "HFC-E1", 1, 1, 0, 1, 0, 0, 0, 0},
+
+	[26] =	{VENDOR_CCD, "HFC-4S Speech Design", 4, 4, 0, 0, 0, 0,
+		       HFC_IO_MODE_PLXSD, 0},
+	[27] =	{VENDOR_CCD, "HFC-E1 Speech Design", 1, 1, 0, 0, 0, 0,
+		       HFC_IO_MODE_PLXSD, 0},
+	[28] =	{VENDOR_CCD, "HFC-4S OpenVox", 4, 4, 1, 0, 0, 0, 0, 0},
+	[29] =	{VENDOR_CCD, "HFC-2S OpenVox", 4, 2, 1, 0, 0, 0, 0, 0},
+	[30] =	{VENDOR_CCD, "HFC-8S OpenVox", 8, 8, 1, 0, 0, 0, 0, 0},
+	[31] =	{VENDOR_CCD, "XHFC-4S Speech Design", 5, 4, 0, 0, 0, 0,
+		       HFC_IO_MODE_EMBSD, XHFC_IRQ},
+	[32] =	{VENDOR_JH, "HFC-8S (junghanns)", 8, 8, 1, 0, 0, 0, 0, 0},
+	[33] =	{VENDOR_BN, "HFC-2S Beronet Card PCIe", 4, 2, 1, 3, 0, DIP_4S, 0, 0},
+	[34] =	{VENDOR_BN, "HFC-4S Beronet Card PCIe", 4, 4, 1, 2, 0, DIP_4S, 0, 0},
 };
 
 #undef H
-- 
2.35.1

