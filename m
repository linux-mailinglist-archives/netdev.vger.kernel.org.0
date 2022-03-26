Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809874E825D
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbiCZRDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbiCZRDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:03:12 -0400
Received: from stuerz.xyz (unknown [45.77.206.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C545170D93;
        Sat, 26 Mar 2022 10:01:18 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 4DA25FBC15; Sat, 26 Mar 2022 17:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314077; bh=F4mFOP6R8mSC+27qiR8caNRLqSuQe2zZwUjAxTCpWKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xg8sAhUbcrHjQslpCBEpkyjUdn56VuM10WXDhvaub55YmwddV8jrxDpzfZyVe3yZo
         QlmdtTsaOietyV0DPj7ab0Rp74UEkocsfhjaKvaVeBvpCk+8U7c1QScPnuhaVExP4X
         laQCdsDMHofwB+7TQ2HA9PoVE59E/5t/zTbGcKcDptM+7QeMCUe92dlvo/q4XNcQkU
         W3GYfZdC/X3DxCE5//Whh/muwcIbf0RB3klnYztGrQlbXdJLNj/vOoCPSmgcL5gxV7
         MUipvDevFObReYEhwHLXtVek1LWz3vzdWZOAwfelAodwolaZwTEHj2h3OTZzkjzJNw
         iUILBuopsokGw==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id A2186FB7CD;
        Sat, 26 Mar 2022 17:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314073; bh=F4mFOP6R8mSC+27qiR8caNRLqSuQe2zZwUjAxTCpWKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lpn1kNOht3IjqkwWrlXCvwxCCuKRTgm9xratBr2om8NH60q2A3PkG7ny40QNucd/c
         TI5QLl5gJY3hgaLe/x2wsXDBNDJ8sD7BM5hPjca1hImMajeyzv97QpcvqYXtaodIwn
         LP32ozhih5w7oBi1imaMTktrGINSREkWcl8znBajxoBVw+kh9bYQXBdB0++rNIqnjk
         /56oT7zPXmWOO1JkR7/z86GemOpPv2MOrbeEd2gs6B4eQE/NQoych/gsIiVj9RsovA
         xRoAwNJStE0bvDErb8jy1vAHc4WALCyAibhfkba1AKMkK5kA2ZNDgcbcDAeFBT4Qns
         573fZe452hA5g==
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
Subject: [PATCH 17/22] cxl: Replace comments with C99 initializers
Date:   Sat, 26 Mar 2022 17:59:04 +0100
Message-Id: <20220326165909.506926-17-benni@stuerz.xyz>
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
 drivers/misc/cxl/hcalls.c | 40 +++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/misc/cxl/hcalls.c b/drivers/misc/cxl/hcalls.c
index aba5e20eeb1f..ed2086d579d3 100644
--- a/drivers/misc/cxl/hcalls.c
+++ b/drivers/misc/cxl/hcalls.c
@@ -86,32 +86,32 @@
 
 
 static char *afu_op_names[] = {
-	"UNKNOWN_OP",		/* 0 undefined */
-	"RESET",		/* 1 */
-	"SUSPEND_PROCESS",	/* 2 */
-	"RESUME_PROCESS",	/* 3 */
-	"READ_ERR_STATE",	/* 4 */
-	"GET_AFU_ERR",		/* 5 */
-	"GET_CONFIG",		/* 6 */
-	"GET_DOWNLOAD_STATE",	/* 7 */
-	"TERMINATE_PROCESS",	/* 8 */
-	"COLLECT_VPD",		/* 9 */
-	"UNKNOWN_OP",		/* 10 undefined */
-	"GET_FUNCTION_ERR_INT",	/* 11 */
-	"ACK_FUNCTION_ERR_INT",	/* 12 */
-	"GET_ERROR_LOG",	/* 13 */
+	[0]  = "UNKNOWN_OP",		         /* undefined */
+	[1]  = "RESET",
+	[2]  = "SUSPEND_PROCESS",
+	[3]  = "RESUME_PROCESS",
+	[4]  = "READ_ERR_STATE",
+	[5]  = "GET_AFU_ERR",
+	[6]  = "GET_CONFIG",
+	[7]  = "GET_DOWNLOAD_STATE",
+	[8]  = "TERMINATE_PROCESS",
+	[9]  = "COLLECT_VPD",
+	[10] = "UNKNOWN_OP",		         /*  undefined */
+	[11] = "GET_FUNCTION_ERR_INT",
+	[12] = "ACK_FUNCTION_ERR_INT",
+	[13] = "GET_ERROR_LOG",
 };
 
 static char *control_adapter_op_names[] = {
-	"UNKNOWN_OP",		/* 0 undefined */
-	"RESET",		/* 1 */
-	"COLLECT_VPD",		/* 2 */
+	[0] = "UNKNOWN_OP",		         /* undefined */
+	[1] = "RESET",
+	[2] = "COLLECT_VPD",
 };
 
 static char *download_op_names[] = {
-	"UNKNOWN_OP",		/* 0 undefined */
-	"DOWNLOAD",		/* 1 */
-	"VALIDATE",		/* 2 */
+	[0] = "UNKNOWN_OP",		         /* undefined */
+	[1] = "DOWNLOAD",
+	[2] = "VALIDATE",
 };
 
 static char *op_str(unsigned int op, char *name_array[], int array_len)
-- 
2.35.1

