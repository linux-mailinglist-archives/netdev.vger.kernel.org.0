Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F581A17A3
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 00:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgDGWBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 18:01:53 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42396 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgDGWBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 18:01:53 -0400
Received: by mail-wr1-f68.google.com with SMTP id h15so5597205wrx.9
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 15:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BeHdxYqCIXxSKMEoie+6S2t9E8EUA/cFfxnXslB4sRE=;
        b=STfmwp2VsiVDatfl0DMqwTxieOqbOlOvzoL0LXIHmrE6pcFjNhQfFncolsud2D+7Zt
         y6PpGQqZn9RhwSeNT7IoYO70QzaTACxDAccXzSHktRExujv/zKE0Dz+QScVNVNd920Hr
         z+CNwH9+OJRkvzJyB2nCCvjbcBYdxoxDVhklluCmLUtFAkyhn4X2OqfdiJPvoh1n6WMS
         DB4kLXVc5q9mSpoBvTbd9+RdF0PgyF2YtcJiGJwqFC2Fssk7OzpUUVduCsOaftzd3ber
         I0jf8nQOpSh9ApcYDBin0gdZPn35hIgqVRY0x6RI2BHUQCdSb3jfd4VfeTOZyP6j0GmE
         PJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=BeHdxYqCIXxSKMEoie+6S2t9E8EUA/cFfxnXslB4sRE=;
        b=EiAVejjX40Nq3VGmZp2kFGETVpz01UZn7o7OvlnVMP88zq3tEN13Sg9G9zy3hfFkGz
         E2Z1khJdtgFB+cMTbYMJCeyIm8xZKp70jEjRhM4xfXtNeE2QJSEMrkfP4sjbJWOsVY7k
         yoiCLqMfy4ola+gbxhU4A4q8a7gW3GQh0vnekyn8FygVCwMtSwmDBL6nucf+6EBy0A3O
         ZPOdtx5gS4A2bKG39ckLHNzGKB7SGeP62vrk5bzFX8k1JIYoUkyxyjBaW7WWyN3/V2h+
         iHWNC6s2cD9qSSuj+s5weba28LZCpGk9NWABAwTeRXMxI7PX1gO2b8fURXXrHRYvtNVa
         UZWw==
X-Gm-Message-State: AGi0PuYfTmzw1xqD4R8/34w7MLineBumEAxK0hK8ion31M38uy5LeKbZ
        gpr/YHBtRdpnih80HNGPCAxlC7To
X-Google-Smtp-Source: APiQypIAcrAY8eH43z+wUMLaiUHJZ6ThumSbYrDUEBOUrLSEMqx5ulwxe2svGx0voYLLDRaJl3/r9w==
X-Received: by 2002:adf:db0a:: with SMTP id s10mr4871681wri.361.1586296910646;
        Tue, 07 Apr 2020 15:01:50 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:21d6:ac8b:719c:fbba? (p200300EA8F29600021D6AC8B719CFBBA.dip0.t-ipconnect.de. [2003:ea:8f29:6000:21d6:ac8b:719c:fbba])
        by smtp.googlemail.com with ESMTPSA id b199sm4688544wme.23.2020.04.07.15.01.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 15:01:50 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 5.4 net] net: phy: realtek: fix handling of
 RTL8105e-integrated PHY
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <71c9463f-9f4c-b3da-91c6-a216a819208d@gmail.com>
Date:   Wed, 8 Apr 2020 00:01:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the referenced fix it turned out that one particular RTL8168
chip version (RTL8105e) does not work on 5.4 because no dedicated PHY
driver exists. Adding this PHY driver was done for fixing a different
issue for versions from 5.5 already. I re-send the same change for 5.4
because the commit message differs.

Fixes: 2e8c339b4946 ("r8169: fix PHY driver check on platforms w/o module softdeps")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
Please apply on 5.4 only.
---
 drivers/net/phy/realtek.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index c76df51dd..879ca37c8 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -456,6 +456,15 @@ static struct phy_driver realtek_drvs[] = {
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
+	}, {
+		PHY_ID_MATCH_MODEL(0x001cc880),
+		.name		= "RTL8208 Fast Ethernet",
+		.read_mmd	= genphy_read_mmd_unsupported,
+		.write_mmd	= genphy_write_mmd_unsupported,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.read_page	= rtl821x_read_page,
+		.write_page	= rtl821x_write_page,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc910),
 		.name		= "RTL8211 Gigabit Ethernet",
-- 
2.26.0

