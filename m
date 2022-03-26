Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFBD24E830D
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbiCZRLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbiCZRKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:10:38 -0400
Received: from stuerz.xyz (stuerz.xyz [IPv6:2001:19f0:5:15da:5400:3ff:fecc:7379])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C9F35844;
        Sat, 26 Mar 2022 10:08:58 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 85B86FBAD8; Sat, 26 Mar 2022 16:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648313990; bh=hqrYFkjwHXr5MkCmTzW0zUtSYcfIlAH4M2viTmK+ce0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzOHGekHcRWuZ4H68rapfZbBmrqB6nsbrdOPjNSxt7h8WkRUT3D2lLjIJFRTIjfB3
         UgMiATq5eTVCXaOy2UZ2vJ94sDqSpZePYoniDGtML1oJyKaOnSog2nTRNdmus4huu1
         dNKNTHK/s44qXlrlWpPs4xe6WlRq0YWiRCCsHRsQRt+Dztdk6urqW44lP7OYdLe1nd
         iApLmLF5sd4XynYeSD7WhPsr05da2DKHrbLaeFnaE6APUcbkLSfnhSQ4vENwGp/qDb
         WIwfu6P9XdEyQtoiou9yk/fZ3gXOw5RrBCJBTphGCihX/Wg4bVDJOMPD5bWY31k1dT
         anoDgWlgp+dAg==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id B4FD6FB7D4;
        Sat, 26 Mar 2022 16:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648313987; bh=hqrYFkjwHXr5MkCmTzW0zUtSYcfIlAH4M2viTmK+ce0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJm8jOOpo7o5bJ/jnyWMMwZCEz0cp1ONDyucFrcaUR3MF3mVAicBbi+RDh7CMUk6b
         AyDPTwmRpd0XtTVVibZYv+GFO17TD/etO65ImQn1AFDB5Rst93WnLmQ26aVc+7IYzp
         +7kCFMqaTfUdoa765GsRs1bJ96ZWZETiepQrT7wGEtCCoxWejua9HAQCyk7dJKJh5O
         wuVo1XTIDTYs6bomi740IDuPOKzsYRmpgM59T/cdggq6jN4J+vjL83NtQNKgUJ1zre
         LWEzOV5Of6i4tJhdHMgudanVzcnBxhgC4dyUDk7gJTZs+N6Hn6Ykq5e3pYup83HrRK
         SBOFExwpFzDQA==
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
Subject: [PATCH 04/22] x86: Replace comments with C99 initializers
Date:   Sat, 26 Mar 2022 17:58:51 +0100
Message-Id: <20220326165909.506926-4-benni@stuerz.xyz>
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
 arch/x86/include/asm/kgdb.h   | 80 +++++++++++++++++------------------
 arch/x86/kernel/cpu/mtrr/if.c | 14 +++---
 2 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/arch/x86/include/asm/kgdb.h b/arch/x86/include/asm/kgdb.h
index aacaf2502bd2..a9161e2f8b63 100644
--- a/arch/x86/include/asm/kgdb.h
+++ b/arch/x86/include/asm/kgdb.h
@@ -25,52 +25,52 @@
  */
 #ifdef CONFIG_X86_32
 enum regnames {
-	GDB_AX,			/* 0 */
-	GDB_CX,			/* 1 */
-	GDB_DX,			/* 2 */
-	GDB_BX,			/* 3 */
-	GDB_SP,			/* 4 */
-	GDB_BP,			/* 5 */
-	GDB_SI,			/* 6 */
-	GDB_DI,			/* 7 */
-	GDB_PC,			/* 8 also known as eip */
-	GDB_PS,			/* 9 also known as eflags */
-	GDB_CS,			/* 10 */
-	GDB_SS,			/* 11 */
-	GDB_DS,			/* 12 */
-	GDB_ES,			/* 13 */
-	GDB_FS,			/* 14 */
-	GDB_GS,			/* 15 */
+	GDB_AX = 0,
+	GDB_CX = 1,
+	GDB_DX = 2,
+	GDB_BX = 3,
+	GDB_SP = 4,
+	GDB_BP = 5,
+	GDB_SI = 6,
+	GDB_DI = 7,
+	GDB_PC = 8,			/* also known as eip */
+	GDB_PS = 9,			/* also known as eflags */
+	GDB_CS = 10,
+	GDB_SS = 11,
+	GDB_DS = 12,
+	GDB_ES = 13,
+	GDB_FS = 14,
+	GDB_GS = 15,
 };
 #define GDB_ORIG_AX		41
 #define DBG_MAX_REG_NUM		16
 #define NUMREGBYTES		((GDB_GS+1)*4)
 #else /* ! CONFIG_X86_32 */
 enum regnames {
-	GDB_AX,			/* 0 */
-	GDB_BX,			/* 1 */
-	GDB_CX,			/* 2 */
-	GDB_DX,			/* 3 */
-	GDB_SI,			/* 4 */
-	GDB_DI,			/* 5 */
-	GDB_BP,			/* 6 */
-	GDB_SP,			/* 7 */
-	GDB_R8,			/* 8 */
-	GDB_R9,			/* 9 */
-	GDB_R10,		/* 10 */
-	GDB_R11,		/* 11 */
-	GDB_R12,		/* 12 */
-	GDB_R13,		/* 13 */
-	GDB_R14,		/* 14 */
-	GDB_R15,		/* 15 */
-	GDB_PC,			/* 16 */
-	GDB_PS,			/* 17 */
-	GDB_CS,			/* 18 */
-	GDB_SS,			/* 19 */
-	GDB_DS,			/* 20 */
-	GDB_ES,			/* 21 */
-	GDB_FS,			/* 22 */
-	GDB_GS,			/* 23 */
+	GDB_AX   =  0,
+	GDB_BX   =  1,
+	GDB_CX   =  2,
+	GDB_DX   =  3,
+	GDB_SI   =  4,
+	GDB_DI   =  5,
+	GDB_BP   =  6,
+	GDB_SP   =  7,
+	GDB_R8   =  8,
+	GDB_R9   =  9,
+	GDB_R10  = 10,
+	GDB_R11  = 11,
+	GDB_R12  = 12,
+	GDB_R13  = 13,
+	GDB_R14  = 14,
+	GDB_R15  = 15,
+	GDB_PC   = 16,			/* also known as eip */
+	GDB_PS   = 17,			/* also known as eflags */
+	GDB_CS   = 18,
+	GDB_SS   = 19,
+	GDB_DS   = 20,
+	GDB_ES   = 21,
+	GDB_FS   = 22,
+	GDB_GS   = 23,
 };
 #define GDB_ORIG_AX		57
 #define DBG_MAX_REG_NUM		24
diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index a5c506f6da7f..7664a672f414 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -18,13 +18,13 @@
 
 static const char *const mtrr_strings[MTRR_NUM_TYPES] =
 {
-	"uncachable",		/* 0 */
-	"write-combining",	/* 1 */
-	"?",			/* 2 */
-	"?",			/* 3 */
-	"write-through",	/* 4 */
-	"write-protect",	/* 5 */
-	"write-back",		/* 6 */
+	[0] = "uncachable",
+	[1] = "write-combining",
+	[2] = "?",
+	[3] = "?",
+	[4] = "write-through",
+	[5] = "write-protect",
+	[6] = "write-back",
 };
 
 const char *mtrr_attrib_to_str(int x)
-- 
2.35.1

