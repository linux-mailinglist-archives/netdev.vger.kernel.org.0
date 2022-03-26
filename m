Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C009A4E82CB
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbiCZRK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbiCZRKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:10:33 -0400
Received: from stuerz.xyz (unknown [45.77.206.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC3834BB2;
        Sat, 26 Mar 2022 10:08:34 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 1BDFDFB7F0; Sat, 26 Mar 2022 17:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314011; bh=l2IWPCqMKAH1wZwiF0dTGCOb58JalsVJpSOVxVm/2R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSyHP6UPnBkUn1Chdy/s4X9uHp781E+8d6F5cRNIsxBl9MYj3z0/VWq/LLj8uvhP6
         G9BpWOZQp8ADyNQweuoAmwt4sIVZDPSixyqGflK99Mgmawkh3LHevbSJKqHDEP/EbA
         RAvRDg7+aqFjdEuSShb5aq799ptd3pR1EcvVIIyc0pkJy0XUJiraUa0jyeI3d9rkH0
         If3fQ4h62IO+SCqhV4hBA6To4f4P/bcAw1KS9JqFzHkHIG8TOyc+SzIcXS/Gn17lLJ
         y/AI3WEnypyXGrYcZrek9bsMo05m7xqXupQY6mo2AsiuvcdWUcmzHOXSKOWfCvtZ4s
         WRaak/odSHv3A==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id 8A2E4FB7F0;
        Sat, 26 Mar 2022 17:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314006; bh=l2IWPCqMKAH1wZwiF0dTGCOb58JalsVJpSOVxVm/2R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlPQwI4EjIDelvb9sF4uDVI7otwpQbfj6RKPYToutjnNxpt0yUwy6L1o6fhnNHML9
         IjOis25yddnKqT80p+JWkf7ie89Xz7ikPFa9eBWuVuoF28nvHT1nR0QaA8QlkLcfNz
         F++j1fFs+aEl1i2sLaj1VYlzUHQmtbV9jYG+n2TIzspceQ9ZiRO/3Me6/w9bom7+gQ
         57DAah7Nc1+01euyOmq0lMuDaWE6c/rM7RVHF+4v9hyADnsn7DtPxXibgKxlwELAkJ
         UBq3OD6Znyd/f15ARdsj2BbQPazIQ/WzcxiztoaGbrmnub0K3If1/KcHDORBXtoROm
         Vx8E2Z8ecrAMw==
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
Subject: [PATCH 07/22] cm4000: Replace comments with C99 initializers
Date:   Sat, 26 Mar 2022 17:58:54 +0100
Message-Id: <20220326165909.506926-7-benni@stuerz.xyz>
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
 drivers/char/pcmcia/cm4000_cs.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index adaec8fd4b16..8082025ab5b7 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -153,18 +153,18 @@ static struct class *cmm_class;
  * violates process/coding-style.rst.  However, I don't really think wrapping it around will
  * make it any clearer to read -HW */
 static unsigned char fi_di_table[10][14] = {
-/*FI     00   01   02   03   04   05   06   07   08   09   10   11   12   13 */
-/*DI */
-/* 0 */ {0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11},
-/* 1 */ {0x01,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x91,0x11,0x11,0x11,0x11},
-/* 2 */ {0x02,0x12,0x22,0x32,0x11,0x11,0x11,0x11,0x11,0x92,0xA2,0xB2,0x11,0x11},
-/* 3 */ {0x03,0x13,0x23,0x33,0x43,0x53,0x63,0x11,0x11,0x93,0xA3,0xB3,0xC3,0xD3},
-/* 4 */ {0x04,0x14,0x24,0x34,0x44,0x54,0x64,0x11,0x11,0x94,0xA4,0xB4,0xC4,0xD4},
-/* 5 */ {0x00,0x15,0x25,0x35,0x45,0x55,0x65,0x11,0x11,0x95,0xA5,0xB5,0xC5,0xD5},
-/* 6 */ {0x06,0x16,0x26,0x36,0x46,0x56,0x66,0x11,0x11,0x96,0xA6,0xB6,0xC6,0xD6},
-/* 7 */ {0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11},
-/* 8 */ {0x08,0x11,0x28,0x38,0x48,0x58,0x68,0x11,0x11,0x98,0xA8,0xB8,0xC8,0xD8},
-/* 9 */ {0x09,0x19,0x29,0x39,0x49,0x59,0x69,0x11,0x11,0x99,0xA9,0xB9,0xC9,0xD9}
+/*  FI     00   01   02   03   04   05   06   07   08   09   10   11   12   13 */
+/*  DI */
+	[0] = {0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11},
+	[1] = {0x01,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x91,0x11,0x11,0x11,0x11},
+	[2] = {0x02,0x12,0x22,0x32,0x11,0x11,0x11,0x11,0x11,0x92,0xA2,0xB2,0x11,0x11},
+	[3] = {0x03,0x13,0x23,0x33,0x43,0x53,0x63,0x11,0x11,0x93,0xA3,0xB3,0xC3,0xD3},
+	[4] = {0x04,0x14,0x24,0x34,0x44,0x54,0x64,0x11,0x11,0x94,0xA4,0xB4,0xC4,0xD4},
+	[5] = {0x00,0x15,0x25,0x35,0x45,0x55,0x65,0x11,0x11,0x95,0xA5,0xB5,0xC5,0xD5},
+	[6] = {0x06,0x16,0x26,0x36,0x46,0x56,0x66,0x11,0x11,0x96,0xA6,0xB6,0xC6,0xD6},
+	[7] = {0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11},
+	[8] = {0x08,0x11,0x28,0x38,0x48,0x58,0x68,0x11,0x11,0x98,0xA8,0xB8,0xC8,0xD8},
+	[9] = {0x09,0x19,0x29,0x39,0x49,0x59,0x69,0x11,0x11,0x99,0xA9,0xB9,0xC9,0xD9}
 };
 
 #ifndef CM4000_DEBUG
-- 
2.35.1

