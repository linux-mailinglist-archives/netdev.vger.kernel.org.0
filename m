Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17BE64E82D4
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiCZRK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbiCZRKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:10:39 -0400
Received: from stuerz.xyz (stuerz.xyz [IPv6:2001:19f0:5:15da:5400:3ff:fecc:7379])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3CA3585D;
        Sat, 26 Mar 2022 10:08:58 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 35150FB7F8; Sat, 26 Mar 2022 16:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648313978; bh=2uH++cpt44frpysxfSOHHq51GioRGW69bGRAGT0KbXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cq12VylqVwxsnb1TJGM2fG+9lFESXLHbo2EtQ5V3o28QF6KUTpn12/8Vbq1GoSCXw
         HKjZapXjR3b3kUplntdqD20iB0tXU8uGDrLJAZAAE4Y9OR6AN7aedZRRJaks1j2Ptn
         K3x6Zsnv8A7ti0JTYFnerN8JoPx08cRyV00MSeYaxJCJow8JFfWgclRgPZPvDBNUnA
         kfSY2z6a1hbsKhCy+0g0P5u8PAAaEtqVtP84WvIBhcuQ+cvuiXIYBfPB0lUzHuHt1H
         Hh7VoglqtyAu+NBeXIzS+w9LZDDe59/asw1r/M0dulCEUjGOiqvw7dd2SUt41Q+EFP
         6vB0DH1LXS2Tg==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id 98AE0FB7D0;
        Sat, 26 Mar 2022 16:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648313973; bh=2uH++cpt44frpysxfSOHHq51GioRGW69bGRAGT0KbXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cKhwvy4qhsPuBxAq0Y52RSBW8Kxkl55mtNsTt7h2uutsE3Y6bGf2uI+3fV4gjubw8
         GpKwU9W3Gsv+wbbqaJHSG5dn04mPUxOLS6vQZPWYgqSkhFdKYlwRBwMnnmBwqY8C2y
         6crdwbggZyh88T++mcaMq+N7QcoI6KJC9AH/jpS8zlcXylv3kJnUsJ9M6wHwPU2lhK
         5Jy5mDsKEM89BIiyKY4oOsX95B3qpGLhw7sJvKQKpaYWFVH1Z5mqAILb9LQIa5uOep
         +T7X2leuj8NeWwv8be761msNoWYvaNI/CeR3TDGXvIT6mSEVcBf6YLCLmfISYd0yHC
         URoafektSpMIg==
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
Subject: [PATCH 02/22] s3c: Replace comments with C99 initializers
Date:   Sat, 26 Mar 2022 17:58:49 +0100
Message-Id: <20220326165909.506926-2-benni@stuerz.xyz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220326165909.506926-1-benni@stuerz.xyz>
References: <20220326165909.506926-1-benni@stuerz.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This replaces comments with C99's designated
initializers because the kernel supports them now.

Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
---
 arch/arm/mach-s3c/bast-irq.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-s3c/bast-irq.c b/arch/arm/mach-s3c/bast-irq.c
index d299f124e6dc..bd5471f9973b 100644
--- a/arch/arm/mach-s3c/bast-irq.c
+++ b/arch/arm/mach-s3c/bast-irq.c
@@ -29,22 +29,22 @@
  * the irq is not implemented
 */
 static const unsigned char bast_pc104_irqmasks[] = {
-	0,   /* 0 */
-	0,   /* 1 */
-	0,   /* 2 */
-	1,   /* 3 */
-	0,   /* 4 */
-	2,   /* 5 */
-	0,   /* 6 */
-	4,   /* 7 */
-	0,   /* 8 */
-	0,   /* 9 */
-	8,   /* 10 */
-	0,   /* 11 */
-	0,   /* 12 */
-	0,   /* 13 */
-	0,   /* 14 */
-	0,   /* 15 */
+	[0]  = 0,
+	[1]  = 0,
+	[2]  = 0,
+	[3]  = 1,
+	[4]  = 0,
+	[5]  = 2,
+	[6]  = 0,
+	[7]  = 4,
+	[8]  = 0,
+	[9]  = 0,
+	[10] = 8,
+	[11] = 0,
+	[12] = 0,
+	[13] = 0,
+	[14] = 0,
+	[15] = 0,
 };
 
 static const unsigned char bast_pc104_irqs[] = { 3, 5, 7, 10 };
-- 
2.35.1

