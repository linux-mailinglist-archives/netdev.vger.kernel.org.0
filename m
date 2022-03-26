Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86274E8213
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbiCZRC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbiCZRCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:02:22 -0400
Received: from stuerz.xyz (stuerz.xyz [IPv6:2001:19f0:5:15da:5400:3ff:fecc:7379])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357FBE4382;
        Sat, 26 Mar 2022 10:00:44 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 5422BFBBE2; Sat, 26 Mar 2022 17:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314043; bh=nThPDkDF2XLY5J3RiAKQRe1b62vpRwWyWtPgVZyXRO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JsiZ950ZLfkne2NOnvzVj10XXg4Zt4h7oNwdhAGtKWsC46eB/TPcb8wq96t+rUk8v
         L1iiTmLrfN6nfmmKNxsIzXjWqolWkorZ7yhpyvqIH2rh2mnSHy/mKBYhV2Gxyiskoo
         Qw/icbGFvoYdZoHv9dD2wEtRQ5PdpV9GGM1R4qr7CbXCMDtRR6VWP33Dq7j1LYzTb/
         L9Zh4YyljFmY9vaOoaj8iBuXWIypdwcu5bajRj2V6P79HBgGo6L0Iw82lX8956KXFQ
         xhXfkxMyNBX1VyYfTVOuenlmElEGNmfC+PoXKt1F4ZuJrxU4kA8jg2iDvrk2y1WbRN
         WlJ1i2cciLxcw==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id 7E9C4FBBB2;
        Sat, 26 Mar 2022 17:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314039; bh=nThPDkDF2XLY5J3RiAKQRe1b62vpRwWyWtPgVZyXRO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNRlS1xv//eXMRaT7zlFJ8fDp4Tsg2CzMO5ONij0+zqqguTk7QhKI4oCIqXPVryh+
         tVP+rQ/6jMPFT21raOJfu2nhdw0W4orrMWuDhkMZ2JgtVG7WJA4ykvSfr1xZidzFMB
         axWfyOmdByaaaBLNtdPHufNsL3Rabi3BawPkeeFDO2RHZKSZ/XhKY8OxzXg+YhTYWm
         H3oRW50TqfYGA+eq5ZLaryp1Hjp+iw9dn0u+O7WJBbJiq/Yo+72f/A5Zq8O02n9pZ8
         migv038XS1iEQAyL5ExZAJdD/UiEJgyp8C9pGPCvhaZ+7C/9hLic8i2BVTmosbCwnB
         aFryaSvC2NznA==
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
Subject: [PATCH 12/22] alps: Replace comments with C99 initializers
Date:   Sat, 26 Mar 2022 17:58:59 +0100
Message-Id: <20220326165909.506926-12-benni@stuerz.xyz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220326165909.506926-1-benni@stuerz.xyz>
References: <20220326165909.506926-1-benni@stuerz.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This replaces comments with C99's designated
initializers because the kernel supports them now.

Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
---
 drivers/input/mouse/alps.c | 96 +++++++++++++++++++-------------------
 1 file changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 4a6b33bbe7ea..333f18b198eb 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -33,60 +33,60 @@
 #define ALPS_REG_BASE_PINNACLE	0x0000
 
 static const struct alps_nibble_commands alps_v3_nibble_commands[] = {
-	{ PSMOUSE_CMD_SETPOLL,		0x00 }, /* 0 */
-	{ PSMOUSE_CMD_RESET_DIS,	0x00 }, /* 1 */
-	{ PSMOUSE_CMD_SETSCALE21,	0x00 }, /* 2 */
-	{ PSMOUSE_CMD_SETRATE,		0x0a }, /* 3 */
-	{ PSMOUSE_CMD_SETRATE,		0x14 }, /* 4 */
-	{ PSMOUSE_CMD_SETRATE,		0x28 }, /* 5 */
-	{ PSMOUSE_CMD_SETRATE,		0x3c }, /* 6 */
-	{ PSMOUSE_CMD_SETRATE,		0x50 }, /* 7 */
-	{ PSMOUSE_CMD_SETRATE,		0x64 }, /* 8 */
-	{ PSMOUSE_CMD_SETRATE,		0xc8 }, /* 9 */
-	{ ALPS_CMD_NIBBLE_10,		0x00 }, /* a */
-	{ PSMOUSE_CMD_SETRES,		0x00 }, /* b */
-	{ PSMOUSE_CMD_SETRES,		0x01 }, /* c */
-	{ PSMOUSE_CMD_SETRES,		0x02 }, /* d */
-	{ PSMOUSE_CMD_SETRES,		0x03 }, /* e */
-	{ PSMOUSE_CMD_SETSCALE11,	0x00 }, /* f */
+	[0x0] = { PSMOUSE_CMD_SETPOLL,		0x00 },
+	[0x1] = { PSMOUSE_CMD_RESET_DIS,	   0x00 },
+	[0x2] = { PSMOUSE_CMD_SETSCALE21,	0x00 },
+	[0x3] = { PSMOUSE_CMD_SETRATE,		0x0a },
+	[0x4] = { PSMOUSE_CMD_SETRATE,		0x14 },
+	[0x5] = { PSMOUSE_CMD_SETRATE,		0x28 },
+	[0x6] = { PSMOUSE_CMD_SETRATE,		0x3c },
+	[0x7] = { PSMOUSE_CMD_SETRATE,		0x50 },
+	[0x8] = { PSMOUSE_CMD_SETRATE,		0x64 },
+	[0x9] = { PSMOUSE_CMD_SETRATE,		0xc8 },
+	[0xa] = { ALPS_CMD_NIBBLE_10,		   0x00 },
+	[0xb] = { PSMOUSE_CMD_SETRES,		   0x00 },
+	[0xc] = { PSMOUSE_CMD_SETRES,		   0x01 },
+	[0xd] = { PSMOUSE_CMD_SETRES,		   0x02 },
+	[0xe] = { PSMOUSE_CMD_SETRES,		   0x03 },
+	[0xf] = { PSMOUSE_CMD_SETSCALE11,	0x00 },
 };
 
 static const struct alps_nibble_commands alps_v4_nibble_commands[] = {
-	{ PSMOUSE_CMD_ENABLE,		0x00 }, /* 0 */
-	{ PSMOUSE_CMD_RESET_DIS,	0x00 }, /* 1 */
-	{ PSMOUSE_CMD_SETSCALE21,	0x00 }, /* 2 */
-	{ PSMOUSE_CMD_SETRATE,		0x0a }, /* 3 */
-	{ PSMOUSE_CMD_SETRATE,		0x14 }, /* 4 */
-	{ PSMOUSE_CMD_SETRATE,		0x28 }, /* 5 */
-	{ PSMOUSE_CMD_SETRATE,		0x3c }, /* 6 */
-	{ PSMOUSE_CMD_SETRATE,		0x50 }, /* 7 */
-	{ PSMOUSE_CMD_SETRATE,		0x64 }, /* 8 */
-	{ PSMOUSE_CMD_SETRATE,		0xc8 }, /* 9 */
-	{ ALPS_CMD_NIBBLE_10,		0x00 }, /* a */
-	{ PSMOUSE_CMD_SETRES,		0x00 }, /* b */
-	{ PSMOUSE_CMD_SETRES,		0x01 }, /* c */
-	{ PSMOUSE_CMD_SETRES,		0x02 }, /* d */
-	{ PSMOUSE_CMD_SETRES,		0x03 }, /* e */
-	{ PSMOUSE_CMD_SETSCALE11,	0x00 }, /* f */
+	[0x0] = { PSMOUSE_CMD_ENABLE,		   0x00 },
+	[0x1] = { PSMOUSE_CMD_RESET_DIS,	   0x00 },
+	[0x2] = { PSMOUSE_CMD_SETSCALE21,	0x00 },
+	[0x3] = { PSMOUSE_CMD_SETRATE,		0x0a },
+	[0x4] = { PSMOUSE_CMD_SETRATE,		0x14 },
+	[0x5] = { PSMOUSE_CMD_SETRATE,		0x28 },
+	[0x6] = { PSMOUSE_CMD_SETRATE,		0x3c },
+	[0x7] = { PSMOUSE_CMD_SETRATE,		0x50 },
+	[0x8] = { PSMOUSE_CMD_SETRATE,		0x64 },
+	[0x9] = { PSMOUSE_CMD_SETRATE,		0xc8 },
+	[0xa] = { ALPS_CMD_NIBBLE_10,		   0x00 },
+	[0xb] = { PSMOUSE_CMD_SETRES,		   0x00 },
+	[0xc] = { PSMOUSE_CMD_SETRES,		   0x01 },
+	[0xd] = { PSMOUSE_CMD_SETRES,		   0x02 },
+	[0xe] = { PSMOUSE_CMD_SETRES,		   0x03 },
+	[0xf] = { PSMOUSE_CMD_SETSCALE11,	0x00 },
 };
 
 static const struct alps_nibble_commands alps_v6_nibble_commands[] = {
-	{ PSMOUSE_CMD_ENABLE,		0x00 }, /* 0 */
-	{ PSMOUSE_CMD_SETRATE,		0x0a }, /* 1 */
-	{ PSMOUSE_CMD_SETRATE,		0x14 }, /* 2 */
-	{ PSMOUSE_CMD_SETRATE,		0x28 }, /* 3 */
-	{ PSMOUSE_CMD_SETRATE,		0x3c }, /* 4 */
-	{ PSMOUSE_CMD_SETRATE,		0x50 }, /* 5 */
-	{ PSMOUSE_CMD_SETRATE,		0x64 }, /* 6 */
-	{ PSMOUSE_CMD_SETRATE,		0xc8 }, /* 7 */
-	{ PSMOUSE_CMD_GETID,		0x00 }, /* 8 */
-	{ PSMOUSE_CMD_GETINFO,		0x00 }, /* 9 */
-	{ PSMOUSE_CMD_SETRES,		0x00 }, /* a */
-	{ PSMOUSE_CMD_SETRES,		0x01 }, /* b */
-	{ PSMOUSE_CMD_SETRES,		0x02 }, /* c */
-	{ PSMOUSE_CMD_SETRES,		0x03 }, /* d */
-	{ PSMOUSE_CMD_SETSCALE21,	0x00 }, /* e */
-	{ PSMOUSE_CMD_SETSCALE11,	0x00 }, /* f */
+	[0x0] = { PSMOUSE_CMD_ENABLE,		   0x00 },
+	[0x1] = { PSMOUSE_CMD_SETRATE,		0x0a },
+	[0x2] = { PSMOUSE_CMD_SETRATE,		0x14 },
+	[0x3] = { PSMOUSE_CMD_SETRATE,		0x28 },
+	[0x4] = { PSMOUSE_CMD_SETRATE,		0x3c },
+	[0x5] = { PSMOUSE_CMD_SETRATE,		0x50 },
+	[0x6] = { PSMOUSE_CMD_SETRATE,		0x64 },
+	[0x7] = { PSMOUSE_CMD_SETRATE,		0xc8 },
+	[0x8] = { PSMOUSE_CMD_GETID,		   0x00 },
+	[0x9] = { PSMOUSE_CMD_GETINFO,		0x00 },
+	[0xa] = { PSMOUSE_CMD_SETRES,		   0x00 },
+	[0xb] = { PSMOUSE_CMD_SETRES,		   0x01 },
+	[0xc] = { PSMOUSE_CMD_SETRES,		   0x02 },
+	[0xd] = { PSMOUSE_CMD_SETRES,		   0x03 },
+	[0xe] = { PSMOUSE_CMD_SETSCALE21,	0x00 },
+	[0xf] = { PSMOUSE_CMD_SETSCALE11,	0x00 },
 };
 
 
-- 
2.35.1

