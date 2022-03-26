Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114904E822D
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbiCZRDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbiCZRCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:02:55 -0400
Received: from stuerz.xyz (stuerz.xyz [IPv6:2001:19f0:5:15da:5400:3ff:fecc:7379])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4085813703E;
        Sat, 26 Mar 2022 10:01:04 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 7F144FBBFB; Sat, 26 Mar 2022 17:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314063; bh=jxDxg/1YvnjqAgGyMWNqdP+FITcJYQ18irrEetjPgmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yyf9ypCkuN0gE9D/zKVZ4zSs7TXMokrtWDmieAH1ns2DEIIen7tOalVlh9gLv7WzA
         PMGMLIKHSzxn8rxi8VavVse9cFcGxawJNCybH+KUFDGrgE+EOQHXYQ8zGm+DFJtZQR
         fcFunVKtGvtN09bKHubjohuu9ruA4fEH9/fZ0eWI2h5RWVjkOmNBhLNB86mzpLcteE
         anHnzcelgeLCsjIfo9bik/JTDbXag6Tnf0JfpN2Z/SNXo/Bvu1VLxz2JWlD5Ti8Sb4
         djcNfUMs3WbmEGGL6mZ89FhQLyr/afAFGmNzuV1QxFkqQqSdsQI8CmMbJZT13dZrCX
         PZSDG8WdCv9qQ==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id 5A410FBB90;
        Sat, 26 Mar 2022 17:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314059; bh=jxDxg/1YvnjqAgGyMWNqdP+FITcJYQ18irrEetjPgmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXpt+IhLwa3r7XX0620zIigtIlnPC5xjiq95/LVELm23jTciuM25sR08Ztrd40v1r
         46H/DjtI8rIQ2xi/gRAXwCvmPTq6/DbQ1rpy7fj0Vuao1qVFTdpDhTfnVBw9EdYmjk
         CunLFGlQwefmtYfgcNTZCLxoR31e/3Nty30QSTIV0qkb0iUAhnfvj9R8Sdm1+LEwIG
         Xqdg9YreMxCBjbYZckXfJoJbis0+cq5CSGojri7tQBzI4CXGBtmS6vThgpZ6eoTh00
         t9YPO3gJZp4QQ42EGkIJWAH3PiQIlzfb6tGFFiGErqjnRnuTRqgCAMCxupvZXNeFnU
         MH0256oFmRaQw==
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
Subject: [PATCH 15/22] macintosh: Replace comments with C99 initializers
Date:   Sat, 26 Mar 2022 17:59:02 +0100
Message-Id: <20220326165909.506926-15-benni@stuerz.xyz>
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
 drivers/macintosh/adbhid.c | 256 ++++++++++++++++++-------------------
 1 file changed, 128 insertions(+), 128 deletions(-)

diff --git a/drivers/macintosh/adbhid.c b/drivers/macintosh/adbhid.c
index 994ba5cb3678..6e44623cf084 100644
--- a/drivers/macintosh/adbhid.c
+++ b/drivers/macintosh/adbhid.c
@@ -77,134 +77,134 @@ static struct notifier_block adbhid_adb_notifier = {
 #define ADB_KEY_POWER		0x7f
 
 static const u16 adb_to_linux_keycodes[128] = {
-	/* 0x00 */ KEY_A, 		/*  30 */
-	/* 0x01 */ KEY_S, 		/*  31 */
-	/* 0x02 */ KEY_D,		/*  32 */
-	/* 0x03 */ KEY_F,		/*  33 */
-	/* 0x04 */ KEY_H,		/*  35 */
-	/* 0x05 */ KEY_G,		/*  34 */
-	/* 0x06 */ KEY_Z,		/*  44 */
-	/* 0x07 */ KEY_X,		/*  45 */
-	/* 0x08 */ KEY_C,		/*  46 */
-	/* 0x09 */ KEY_V,		/*  47 */
-	/* 0x0a */ KEY_102ND,		/*  86 */
-	/* 0x0b */ KEY_B,		/*  48 */
-	/* 0x0c */ KEY_Q,		/*  16 */
-	/* 0x0d */ KEY_W,		/*  17 */
-	/* 0x0e */ KEY_E,		/*  18 */
-	/* 0x0f */ KEY_R,		/*  19 */
-	/* 0x10 */ KEY_Y,		/*  21 */
-	/* 0x11 */ KEY_T,		/*  20 */
-	/* 0x12 */ KEY_1,		/*   2 */
-	/* 0x13 */ KEY_2,		/*   3 */
-	/* 0x14 */ KEY_3,		/*   4 */
-	/* 0x15 */ KEY_4,		/*   5 */
-	/* 0x16 */ KEY_6,		/*   7 */
-	/* 0x17 */ KEY_5,		/*   6 */
-	/* 0x18 */ KEY_EQUAL,		/*  13 */
-	/* 0x19 */ KEY_9,		/*  10 */
-	/* 0x1a */ KEY_7,		/*   8 */
-	/* 0x1b */ KEY_MINUS,		/*  12 */
-	/* 0x1c */ KEY_8,		/*   9 */
-	/* 0x1d */ KEY_0,		/*  11 */
-	/* 0x1e */ KEY_RIGHTBRACE,	/*  27 */
-	/* 0x1f */ KEY_O,		/*  24 */
-	/* 0x20 */ KEY_U,		/*  22 */
-	/* 0x21 */ KEY_LEFTBRACE,	/*  26 */
-	/* 0x22 */ KEY_I,		/*  23 */
-	/* 0x23 */ KEY_P,		/*  25 */
-	/* 0x24 */ KEY_ENTER,		/*  28 */
-	/* 0x25 */ KEY_L,		/*  38 */
-	/* 0x26 */ KEY_J,		/*  36 */
-	/* 0x27 */ KEY_APOSTROPHE,	/*  40 */
-	/* 0x28 */ KEY_K,		/*  37 */
-	/* 0x29 */ KEY_SEMICOLON,	/*  39 */
-	/* 0x2a */ KEY_BACKSLASH,	/*  43 */
-	/* 0x2b */ KEY_COMMA,		/*  51 */
-	/* 0x2c */ KEY_SLASH,		/*  53 */
-	/* 0x2d */ KEY_N,		/*  49 */
-	/* 0x2e */ KEY_M,		/*  50 */
-	/* 0x2f */ KEY_DOT,		/*  52 */
-	/* 0x30 */ KEY_TAB,		/*  15 */
-	/* 0x31 */ KEY_SPACE,		/*  57 */
-	/* 0x32 */ KEY_GRAVE,		/*  41 */
-	/* 0x33 */ KEY_BACKSPACE,	/*  14 */
-	/* 0x34 */ KEY_KPENTER,		/*  96 */
-	/* 0x35 */ KEY_ESC,		/*   1 */
-	/* 0x36 */ KEY_LEFTCTRL,	/*  29 */
-	/* 0x37 */ KEY_LEFTMETA,	/* 125 */
-	/* 0x38 */ KEY_LEFTSHIFT,	/*  42 */
-	/* 0x39 */ KEY_CAPSLOCK,	/*  58 */
-	/* 0x3a */ KEY_LEFTALT,		/*  56 */
-	/* 0x3b */ KEY_LEFT,		/* 105 */
-	/* 0x3c */ KEY_RIGHT,		/* 106 */
-	/* 0x3d */ KEY_DOWN,		/* 108 */
-	/* 0x3e */ KEY_UP,		/* 103 */
-	/* 0x3f */ KEY_FN,		/* 0x1d0 */
-	/* 0x40 */ 0,
-	/* 0x41 */ KEY_KPDOT,		/*  83 */
-	/* 0x42 */ 0,
-	/* 0x43 */ KEY_KPASTERISK,	/*  55 */
-	/* 0x44 */ 0,
-	/* 0x45 */ KEY_KPPLUS,		/*  78 */
-	/* 0x46 */ 0,
-	/* 0x47 */ KEY_NUMLOCK,		/*  69 */
-	/* 0x48 */ 0,
-	/* 0x49 */ 0,
-	/* 0x4a */ 0,
-	/* 0x4b */ KEY_KPSLASH,		/*  98 */
-	/* 0x4c */ KEY_KPENTER,		/*  96 */
-	/* 0x4d */ 0,
-	/* 0x4e */ KEY_KPMINUS,		/*  74 */
-	/* 0x4f */ 0,
-	/* 0x50 */ 0,
-	/* 0x51 */ KEY_KPEQUAL,		/* 117 */
-	/* 0x52 */ KEY_KP0,		/*  82 */
-	/* 0x53 */ KEY_KP1,		/*  79 */
-	/* 0x54 */ KEY_KP2,		/*  80 */
-	/* 0x55 */ KEY_KP3,		/*  81 */
-	/* 0x56 */ KEY_KP4,		/*  75 */
-	/* 0x57 */ KEY_KP5,		/*  76 */
-	/* 0x58 */ KEY_KP6,		/*  77 */
-	/* 0x59 */ KEY_KP7,		/*  71 */
-	/* 0x5a */ 0,
-	/* 0x5b */ KEY_KP8,		/*  72 */
-	/* 0x5c */ KEY_KP9,		/*  73 */
-	/* 0x5d */ KEY_YEN,		/* 124 */
-	/* 0x5e */ KEY_RO,		/*  89 */
-	/* 0x5f */ KEY_KPCOMMA,		/* 121 */
-	/* 0x60 */ KEY_F5,		/*  63 */
-	/* 0x61 */ KEY_F6,		/*  64 */
-	/* 0x62 */ KEY_F7,		/*  65 */
-	/* 0x63 */ KEY_F3,		/*  61 */
-	/* 0x64 */ KEY_F8,		/*  66 */
-	/* 0x65 */ KEY_F9,		/*  67 */
-	/* 0x66 */ KEY_HANJA,		/* 123 */
-	/* 0x67 */ KEY_F11,		/*  87 */
-	/* 0x68 */ KEY_HANGEUL,		/* 122 */
-	/* 0x69 */ KEY_SYSRQ,		/*  99 */
-	/* 0x6a */ 0,
-	/* 0x6b */ KEY_SCROLLLOCK,	/*  70 */
-	/* 0x6c */ 0,
-	/* 0x6d */ KEY_F10,		/*  68 */
-	/* 0x6e */ KEY_COMPOSE,		/* 127 */
-	/* 0x6f */ KEY_F12,		/*  88 */
-	/* 0x70 */ 0,
-	/* 0x71 */ KEY_PAUSE,		/* 119 */
-	/* 0x72 */ KEY_INSERT,		/* 110 */
-	/* 0x73 */ KEY_HOME,		/* 102 */
-	/* 0x74 */ KEY_PAGEUP,		/* 104 */
-	/* 0x75 */ KEY_DELETE,		/* 111 */
-	/* 0x76 */ KEY_F4,		/*  62 */
-	/* 0x77 */ KEY_END,		/* 107 */
-	/* 0x78 */ KEY_F2,		/*  60 */
-	/* 0x79 */ KEY_PAGEDOWN,	/* 109 */
-	/* 0x7a */ KEY_F1,		/*  59 */
-	/* 0x7b */ KEY_RIGHTSHIFT,	/*  54 */
-	/* 0x7c */ KEY_RIGHTALT,	/* 100 */
-	/* 0x7d */ KEY_RIGHTCTRL,	/*  97 */
-	/* 0x7e */ KEY_RIGHTMETA,	/* 126 */
-	/* 0x7f */ KEY_POWER,		/* 116 */
+	[0x00] = KEY_A,		      /*  30 */
+	[0x01] = KEY_S,		      /*  31 */
+	[0x02] = KEY_D,		      /*  32 */
+	[0x03] = KEY_F,		      /*  33 */
+	[0x04] = KEY_H,		      /*  35 */
+	[0x05] = KEY_G,		      /*  34 */
+	[0x06] = KEY_Z,		      /*  44 */
+	[0x07] = KEY_X,		      /*  45 */
+	[0x08] = KEY_C,		      /*  46 */
+	[0x09] = KEY_V,		      /*  47 */
+	[0x0a] = KEY_102ND,		   /*  86 */
+	[0x0b] = KEY_B,		      /*  48 */
+	[0x0c] = KEY_Q,		      /*  16 */
+	[0x0d] = KEY_W,		      /*  17 */
+	[0x0e] = KEY_E,		      /*  18 */
+	[0x0f] = KEY_R,		      /*  19 */
+	[0x10] = KEY_Y,		      /*  21 */
+	[0x11] = KEY_T,		      /*  20 */
+	[0x12] = KEY_1,		      /*   2 */
+	[0x13] = KEY_2,		      /*   3 */
+	[0x14] = KEY_3,		      /*   4 */
+	[0x15] = KEY_4,		      /*   5 */
+	[0x16] = KEY_6,		      /*   7 */
+	[0x17] = KEY_5,		      /*   6 */
+	[0x18] = KEY_EQUAL,		   /*  13 */
+	[0x19] = KEY_9,		      /*  10 */
+	[0x1a] = KEY_7,		      /*   8 */
+	[0x1b] = KEY_MINUS,		   /*  12 */
+	[0x1c] = KEY_8,		      /*   9 */
+	[0x1d] = KEY_0,		      /*  11 */
+	[0x1e] = KEY_RIGHTBRACE,	/*  27 */
+	[0x1f] = KEY_O,		      /*  24 */
+	[0x20] = KEY_U,		      /*  22 */
+	[0x21] = KEY_LEFTBRACE,	   /*  26 */
+	[0x22] = KEY_I,		      /*  23 */
+	[0x23] = KEY_P,		      /*  25 */
+	[0x24] = KEY_ENTER,		   /*  28 */
+	[0x25] = KEY_L,		      /*  38 */
+	[0x26] = KEY_J,		      /*  36 */
+	[0x27] = KEY_APOSTROPHE,	/*  40 */
+	[0x28] = KEY_K,		      /*  37 */
+	[0x29] = KEY_SEMICOLON,	   /*  39 */
+	[0x2a] = KEY_BACKSLASH,	   /*  43 */
+	[0x2b] = KEY_COMMA,		   /*  51 */
+	[0x2c] = KEY_SLASH,		   /*  53 */
+	[0x2d] = KEY_N,		      /*  49 */
+	[0x2e] = KEY_M,		      /*  50 */
+	[0x2f] = KEY_DOT,		      /*  52 */
+	[0x30] = KEY_TAB,		      /*  15 */
+	[0x31] = KEY_SPACE,		   /*  57 */
+	[0x32] = KEY_GRAVE,		   /*  41 */
+	[0x33] = KEY_BACKSPACE,	   /*  14 */
+	[0x34] = KEY_KPENTER,		/*  96 */
+	[0x35] = KEY_ESC,		      /*   1 */
+	[0x36] = KEY_LEFTCTRL,	   /*  29 */
+	[0x37] = KEY_LEFTMETA,	   /* 125 */
+	[0x38] = KEY_LEFTSHIFT,	   /*  42 */
+	[0x39] = KEY_CAPSLOCK,	   /*  58 */
+	[0x3a] = KEY_LEFTALT,		/*  56 */
+	[0x3b] = KEY_LEFT,		   /* 105 */
+	[0x3c] = KEY_RIGHT,		   /* 106 */
+	[0x3d] = KEY_DOWN,		   /* 108 */
+	[0x3e] = KEY_UP,		      /* 103 */
+	[0x3f] = KEY_FN,		      /* 0x1d0 */
+	[0x40] = 0,
+	[0x41] = KEY_KPDOT,		   /*  83 */
+	[0x42] = 0,
+	[0x43] = KEY_KPASTERISK,	/*  55 */
+	[0x44] = 0,
+	[0x45] = KEY_KPPLUS,		   /*  78 */
+	[0x46] = 0,
+	[0x47] = KEY_NUMLOCK,		/*  69 */
+	[0x48] = 0,
+	[0x49] = 0,
+	[0x4a] = 0,
+	[0x4b] = KEY_KPSLASH,		/*  98 */
+	[0x4c] = KEY_KPENTER,		/*  96 */
+	[0x4d] = 0,
+	[0x4e] = KEY_KPMINUS,		/*  74 */
+	[0x4f] = 0,
+	[0x50] = 0,
+	[0x51] = KEY_KPEQUAL,		/* 117 */
+	[0x52] = KEY_KP0,		      /*  82 */
+	[0x53] = KEY_KP1,		      /*  79 */
+	[0x54] = KEY_KP2,		      /*  80 */
+	[0x55] = KEY_KP3,		      /*  81 */
+	[0x56] = KEY_KP4,		      /*  75 */
+	[0x57] = KEY_KP5,		      /*  76 */
+	[0x58] = KEY_KP6,		      /*  77 */
+	[0x59] = KEY_KP7,		      /*  71 */
+	[0x5a] = 0,
+	[0x5b] = KEY_KP8,		      /*  72 */
+	[0x5c] = KEY_KP9,		      /*  73 */
+	[0x5d] = KEY_YEN,		      /* 124 */
+	[0x5e] = KEY_RO,		      /*  89 */
+	[0x5f] = KEY_KPCOMMA,		/* 121 */
+	[0x60] = KEY_F5,		      /*  63 */
+	[0x61] = KEY_F6,		      /*  64 */
+	[0x62] = KEY_F7,		      /*  65 */
+	[0x63] = KEY_F3,		      /*  61 */
+	[0x64] = KEY_F8,		      /*  66 */
+	[0x65] = KEY_F9,		      /*  67 */
+	[0x66] = KEY_HANJA,		   /* 123 */
+	[0x67] = KEY_F11,		      /*  87 */
+	[0x68] = KEY_HANGEUL,		/* 122 */
+	[0x69] = KEY_SYSRQ,		   /*  99 */
+	[0x6a] = 0,
+	[0x6b] = KEY_SCROLLLOCK,	/*  70 */
+	[0x6c] = 0,
+	[0x6d] = KEY_F10,		      /*  68 */
+	[0x6e] = KEY_COMPOSE,		/* 127 */
+	[0x6f] = KEY_F12,		      /*  88 */
+	[0x70] = 0,
+	[0x71] = KEY_PAUSE,		   /* 119 */
+	[0x72] = KEY_INSERT,		   /* 110 */
+	[0x73] = KEY_HOME,		   /* 102 */
+	[0x74] = KEY_PAGEUP,		   /* 104 */
+	[0x75] = KEY_DELETE,		   /* 111 */
+	[0x76] = KEY_F4,		      /*  62 */
+	[0x77] = KEY_END,		      /* 107 */
+	[0x78] = KEY_F2,		      /*  60 */
+	[0x79] = KEY_PAGEDOWN,	   /* 109 */
+	[0x7a] = KEY_F1,		      /*  59 */
+	[0x7b] = KEY_RIGHTSHIFT,	/*  54 */
+	[0x7c] = KEY_RIGHTALT,	   /* 100 */
+	[0x7d] = KEY_RIGHTCTRL,	   /*  97 */
+	[0x7e] = KEY_RIGHTMETA,	   /* 126 */
+	[0x7f] = KEY_POWER,		   /* 116 */
 };
 
 struct adbhid {
-- 
2.35.1

