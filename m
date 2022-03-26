Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55524E82F3
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbiCZRKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbiCZRKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:10:33 -0400
Received: from stuerz.xyz (unknown [45.77.206.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA4734B96;
        Sat, 26 Mar 2022 10:08:33 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 15FDCFB7E4; Sat, 26 Mar 2022 16:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648313971; bh=h8kNuGjX/tVaFYP7mTBrGXI49VfH81tUX/xpUFBsyPo=;
        h=From:To:Cc:Subject:Date:From;
        b=quzw4Veqn1t75q8i+SwY92Od0H4kbj+Jplj+Hrb9t/pLmlKsT6TJwKYv9o17XTzCA
         3n4+kjK3LG/omELSm+sodJ7uUl4FaExNJQFo4XQbw2amIsW408Doe+3AErNNJZpImZ
         lx7AVbydSYoFr2bJYXUKmyssrinBABDWXfDrQufUX+8e9VArBlaTIJ/bN2K5xyVq+w
         0p7uHbBGHtyMHQgqTwLQnNn16UdQEjGi85LRaznlxiosXx3mrR8DCIsPHQcZtPldiM
         dmTbc/27NaJUevsVWuBjG4Qlevt2k5gOfZ0u7u+jCoIZM3SSZM+fmuEdmLFHsnsnPg
         mGpj42WHbwZ4g==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id 06801FB7CA;
        Sat, 26 Mar 2022 16:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648313967; bh=h8kNuGjX/tVaFYP7mTBrGXI49VfH81tUX/xpUFBsyPo=;
        h=From:To:Cc:Subject:Date:From;
        b=vaoJWTFzm8MRCBX+7S85u4Wohc5rAbjDG2T7E8DUltJLkf/krkoSBna4S3pqS99En
         P3y6O3CiGyfogbGETepdGKzgpDN0QtHf35//97zogTn2Hce6o6WZ17BRWG3tApzQGf
         aNIkiZhaEmddVF8juLhl42fQ5bbgbuzhcq0ukey1NN8t0guq0sCG3i6sPdM3bYC1U6
         aU6BRZFuKP75AmwaGReNRozzsPCzJxq44tCraR+Ll6KCKwir1BEUti16KlHrTphFJy
         +nuQ/wPjFpAX6QV3asHxC7dOJgBXo+wgnEZXWOiibQ9bZKvgZVBmA4ga1hsVtcewJL
         xOc6w0OY3ukmA==
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
Subject: [PATCH 01/22] orion5x: Replace comments with C99 initializers
Date:   Sat, 26 Mar 2022 17:58:48 +0100
Message-Id: <20220326165909.506926-1-benni@stuerz.xyz>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,PDS_OTHER_BAD_TLD,RDNS_DYNAMIC,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This replaces comments with C99's designated
initializers because the kernel supports them now.

Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
---
 arch/arm/mach-orion5x/dns323-setup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-orion5x/dns323-setup.c b/arch/arm/mach-orion5x/dns323-setup.c
index 87cb47220e82..d762248c6512 100644
--- a/arch/arm/mach-orion5x/dns323-setup.c
+++ b/arch/arm/mach-orion5x/dns323-setup.c
@@ -61,9 +61,9 @@
 
 /* Exposed to userspace, do not change */
 enum {
-	DNS323_REV_A1,	/* 0 */
-	DNS323_REV_B1,	/* 1 */
-	DNS323_REV_C1,	/* 2 */
+	DNS323_REV_A1 = 0,
+	DNS323_REV_B1 = 1,
+	DNS323_REV_C1 = 2,
 };
 
 
-- 
2.35.1

