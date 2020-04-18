Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0181AF480
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 22:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgDRUJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 16:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727927AbgDRUJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 16:09:57 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12F5C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 13:09:56 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j2so7127445wrs.9
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 13:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6xIlCxithx9aR1RH2+NH0SEWizYqqvloK4SxhutK8S4=;
        b=UMIGJs6HpsMiM2R/jnuxGzd6AnbQfUqfHQTs9QniUqDGHNMtJSXtMJufoEwsAIahZp
         BRxIwQwVjqBqXdHFLMPoTERDJb/w2cwfdArcjPSpHhlihz4fY2d85Sk0A9Hfn39mt8qO
         6zdFDnLoASRxa3QuvS8E673ywaynvqs8cvXeDTowufA0qhyubCZIWdUhkVvmV3xb7r1H
         uReifVnnWCAkP72ud4TpxjByPn1uHB8wIJQaK3kyrL/BxFuv0YOyqP6I1k794/oO/Bfs
         XX+Zh+huRJZhPS0pv3mfqkKRx6C8zSczSQM7+PX5tOy79zja6Bs02w9h3lKoDGFNMHHz
         IuWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6xIlCxithx9aR1RH2+NH0SEWizYqqvloK4SxhutK8S4=;
        b=NNuXFdWTcreOYC3hzS4oYTYTf5q2VkPeO1K/NZ6r/xk7DOb6lb7GWG8Y5HlBx46Rvu
         YYTPH0LJRy1FEymAGysFNUBBEs7ft5i1OUm6+96bS+V/2K3mVGwBVfCaczKeY4QcCvtj
         mIEUpcG1Rv2FiG+AwLdEm4H5Qn/X8AaDhNMUXJK00FFBeqOf9804vdHuk9Qvr0o1LIzr
         0NRYiO6XKsTyfeSV7zbU2GTWpLUPtiG96R5cHfIQ8kIFh9XHwid7Fu3XtbtyUV8e24PS
         P3+HGI5+PnySHREBGqdBdbX4yzJqnTUEa7XWxCnq2Hd71RINCIJr8AZUzyoY1C9DdrBZ
         Q7Pw==
X-Gm-Message-State: AGi0PuYgnEzojglH0NIsj/rie70yiOSyLxjJ87d4qajdMfEP3v7jA7PX
        kq3tJRLHj2WzT/cEEwUXM6TLMG6e
X-Google-Smtp-Source: APiQypJPGvFvbnY9MLd5TuO1AsUqsRKk8o8tdB5bcC7ecFo1h3lpYpGj5JhdV54ysT8CeAHizYc2wg==
X-Received: by 2002:adf:ab09:: with SMTP id q9mr3176004wrc.240.1587240595256;
        Sat, 18 Apr 2020 13:09:55 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:939:e10c:14c5:fe9f? (p200300EA8F2960000939E10C14C5FE9F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:939:e10c:14c5:fe9f])
        by smtp.googlemail.com with ESMTPSA id h3sm31682864wrm.73.2020.04.18.13.09.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 13:09:54 -0700 (PDT)
Subject: [PATCH net-next 1/2] net: phy: realtek: add delay to resume path of
 certain internal PHY's
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c4e18f15-7c37-13a2-4e26-1203da318f67@gmail.com>
Message-ID: <77a1f6da-0089-71bc-38bf-3180aaaeca36@gmail.com>
Date:   Sat, 18 Apr 2020 22:08:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c4e18f15-7c37-13a2-4e26-1203da318f67@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Internal PHY's from RTL8168h up may not be instantly ready after calling
genphy_resume(). So far r8169 network driver adds the needed delay, but
better handle this in the PHY driver. The network driver may miss other
places where the PHY is resumed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/realtek.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 2d99e9de6..c7229d022 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -11,6 +11,7 @@
 #include <linux/bitops.h>
 #include <linux/phy.h>
 #include <linux/module.h>
+#include <linux/delay.h>
 
 #define RTL821x_PHYSR				0x11
 #define RTL821x_PHYSR_DUPLEX			BIT(13)
@@ -526,6 +527,16 @@ static int rtl8125_match_phy_device(struct phy_device *phydev)
 	       rtlgen_supports_2_5gbps(phydev);
 }
 
+static int rtlgen_resume(struct phy_device *phydev)
+{
+	int ret = genphy_resume(phydev);
+
+	/* Internal PHY's from RTL8168h up may not be instantly ready */
+	msleep(20);
+
+	return ret;
+}
+
 static struct phy_driver realtek_drvs[] = {
 	{
 		PHY_ID_MATCH_EXACT(0x00008201),
@@ -609,7 +620,7 @@ static struct phy_driver realtek_drvs[] = {
 		.match_phy_device = rtlgen_match_phy_device,
 		.read_status	= rtlgen_read_status,
 		.suspend	= genphy_suspend,
-		.resume		= genphy_resume,
+		.resume		= rtlgen_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
 		.read_mmd	= rtlgen_read_mmd,
@@ -621,7 +632,7 @@ static struct phy_driver realtek_drvs[] = {
 		.config_aneg	= rtl8125_config_aneg,
 		.read_status	= rtl8125_read_status,
 		.suspend	= genphy_suspend,
-		.resume		= genphy_resume,
+		.resume		= rtlgen_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
 		.read_mmd	= rtl8125_read_mmd,
-- 
2.26.1


