Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE5F4E82F4
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbiCZRLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbiCZRKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:10:33 -0400
Received: from stuerz.xyz (stuerz.xyz [IPv6:2001:19f0:5:15da:5400:3ff:fecc:7379])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9E134B8C;
        Sat, 26 Mar 2022 10:08:33 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 4334DFBAD9; Sat, 26 Mar 2022 16:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648313984; bh=ZCCwstaS3e/RzElmSk6N8DZfvChsgUHfiTuyAGHFjIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPrzs+/yoGLnF5i8FE3eP1X0LDAI6HjUCl2gNtzUox5BXq2E1eLaG0a2oQDUzahaT
         0gGMlEffJt46pJtPLai9sWEfLeEJc0ZkiLQjl90z5wXqO39WLPgg9P+0nGqQNlR+VE
         nN7gNlVMnnHiadIwoB2jopKAwOZtVz0o85E4m/s4GSh1J5gAC64U4qmHByU3ZdIsMl
         IQbRWXqcM6M7A5NNiREXc9fr7WuFT0PCxZW7As8ThOCY/cbVQwoBBfePDkYKijEZRF
         iwxxu2W006Baw3aUGRDQonw5DwZWwCTof+YKKK+wmLsQVqfDYizYB9X3tcxZjF3fCS
         k/mkV/dFzcSbw==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id 2881DFB7D1;
        Sat, 26 Mar 2022 16:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648313980; bh=ZCCwstaS3e/RzElmSk6N8DZfvChsgUHfiTuyAGHFjIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xIsbMOdfU0Q/V/noYBJTvzmENKQwr3xdCDopx+KQ13tTLqAWk3SM6OL4hiv3VVsu4
         LZ2+4qV891SizwSAbA9RFdif7Xad8663beBH5K2j13NhHE07xQeDfsOgSqxr/C+za+
         MSb5j7oij2Jd7DfXjOZjPMiCw0Ou7lQ4TQyPva2bjbz9+bFlJyFVO1bNqQWmVvfeza
         iheYS8PB8/Na2CaDqA8T7AYheNWnter0biMGLVSYWwaNejld2sHcJuTOq8NLUVbkAH
         b42QbHz9DPMRS79rba+4qCccBHmJTdFEI0D+LYmCJFkFlO8Nbwc3qJr+SwfiHZOfvp
         PvjA7XiPr1hCQ==
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
Subject: [PATCH 03/22] ia64: Replace comments with C99 initializers
Date:   Sat, 26 Mar 2022 17:58:50 +0100
Message-Id: <20220326165909.506926-3-benni@stuerz.xyz>
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
 arch/ia64/kernel/kprobes.c | 64 +++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/ia64/kernel/kprobes.c b/arch/ia64/kernel/kprobes.c
index 1a7bab1c5d7c..2d6a9388201e 100644
--- a/arch/ia64/kernel/kprobes.c
+++ b/arch/ia64/kernel/kprobes.c
@@ -29,38 +29,38 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
 
 enum instruction_type {A, I, M, F, B, L, X, u};
 static enum instruction_type bundle_encoding[32][3] = {
-  { M, I, I },				/* 00 */
-  { M, I, I },				/* 01 */
-  { M, I, I },				/* 02 */
-  { M, I, I },				/* 03 */
-  { M, L, X },				/* 04 */
-  { M, L, X },				/* 05 */
-  { u, u, u },  			/* 06 */
-  { u, u, u },  			/* 07 */
-  { M, M, I },				/* 08 */
-  { M, M, I },				/* 09 */
-  { M, M, I },				/* 0A */
-  { M, M, I },				/* 0B */
-  { M, F, I },				/* 0C */
-  { M, F, I },				/* 0D */
-  { M, M, F },				/* 0E */
-  { M, M, F },				/* 0F */
-  { M, I, B },				/* 10 */
-  { M, I, B },				/* 11 */
-  { M, B, B },				/* 12 */
-  { M, B, B },				/* 13 */
-  { u, u, u },  			/* 14 */
-  { u, u, u },  			/* 15 */
-  { B, B, B },				/* 16 */
-  { B, B, B },				/* 17 */
-  { M, M, B },				/* 18 */
-  { M, M, B },				/* 19 */
-  { u, u, u },  			/* 1A */
-  { u, u, u },  			/* 1B */
-  { M, F, B },				/* 1C */
-  { M, F, B },				/* 1D */
-  { u, u, u },  			/* 1E */
-  { u, u, u },  			/* 1F */
+	[0x00] = { M, I, I },
+	[0x01] = { M, I, I },
+	[0x02] = { M, I, I },
+	[0x03] = { M, I, I },
+	[0x04] = { M, L, X },
+	[0x05] = { M, L, X },
+	[0x06] = { u, u, u },
+	[0x07] = { u, u, u },
+	[0x08] = { M, M, I },
+	[0x09] = { M, M, I },
+	[0x0A] = { M, M, I },
+	[0x0B] = { M, M, I },
+	[0x0C] = { M, F, I },
+	[0x0D] = { M, F, I },
+	[0x0E] = { M, M, F },
+	[0x0F] = { M, M, F },
+	[0x10] = { M, I, B },
+	[0x11] = { M, I, B },
+	[0x12] = { M, B, B },
+	[0x13] = { M, B, B },
+	[0x14] = { u, u, u },
+	[0x15] = { u, u, u },
+	[0x16] = { B, B, B },
+	[0x17] = { B, B, B },
+	[0x18] = { M, M, B },
+	[0x19] = { M, M, B },
+	[0x1A] = { u, u, u },
+	[0x1B] = { u, u, u },
+	[0x1C] = { M, F, B },
+	[0x1D] = { M, F, B },
+	[0x1E] = { u, u, u },
+	[0x1F] = { u, u, u },
 };
 
 /* Insert a long branch code */
-- 
2.35.1

