Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263855AB9A4
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 22:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiIBUws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 16:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiIBUwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 16:52:46 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CE6D4BD4
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 13:52:44 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id a36so4183668edf.5
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 13:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=/mRXpzrYYF2RNaSr3QgZLz1Gce9SNxFWGeHwVJda9dQ=;
        b=jwadJ0nE7DpcByfjTk+akqw9P/i/p2UH9YpjxvmTpF6VTLyVURc5untxPNN4w/H/rl
         i1d+/cAQE+AQZdH1UM/r5CzQ/ntOxXM6r4HHY0+VNb2wycjoZ4nIz2mEn1la7TQeGwnl
         LMjl8iaqsrYG8sbnXEEqiQf6DZ+B04XLFQBN0bOO333dPqJEW5IvPP/XaH3UiIPyHE1L
         jIuCvGOQ9zxXAqAjfhOxJxAuKvMYD4uJOwhk67X8EGjBIkTHtHuAolAEWQ4OCTBJnu1J
         8JTzyF3gowQnyB+t5aktZ8DTUqz6W25dqF8LhZaPRiz1BJI1KBCu2w7lcQTSHjb8H/rp
         k0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=/mRXpzrYYF2RNaSr3QgZLz1Gce9SNxFWGeHwVJda9dQ=;
        b=5YnRt9VghUkQAvN2m5uc5B+yvc+yp9u+uIXPGVg89PQXdmkfRHYpTZIqXKSxJrzu9S
         T4VAwVGILnY+N1Rcjrpw0Tu5ByoIXwFeehIcToq5MO2dHlWhdKbt/Qine76UZSe3VyqP
         hFIjtENMITthf/xP1mWLRU+aeF4P4bpOrxOyi5Xx221srQ7qp8D/TuIilWpBF6j57PIw
         HOY1QcR8KrJPMowYTGhKWbF8zj/8IKJ6vfoDPohKJFoClVCmSB3a0zyxJxurLMssXF8R
         XOUSefuDR6CxFs54xx9LlEL3i29RZu4yLmP+Nx2r/WTvbFFjiShd+uYteOsnGNQYv4Cc
         CyPA==
X-Gm-Message-State: ACgBeo2A42mSrYQg4jJAgbR66SuBnKtRcgmNGA5ayCOduTWkgouj8o5n
        2oXubTdeprMWd8s1IAVE2v8=
X-Google-Smtp-Source: AA6agR4q82/n9g8JzjXbGCf3l8VYqnismZli3Fvog811hYoB7Rigfqsp5s+I5ZUj7X2P/WxMJNkPXQ==
X-Received: by 2002:a05:6402:5202:b0:448:ab5d:3b89 with SMTP id s2-20020a056402520200b00448ab5d3b89mr19034410edd.343.1662151962872;
        Fri, 02 Sep 2022 13:52:42 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c4c2:4e00:f4b8:68d8:d295:8a3b? (dynamic-2a01-0c23-c4c2-4e00-f4b8-68d8-d295-8a3b.c23.pool.telefonica.de. [2a01:c23:c4c2:4e00:f4b8:68d8:d295:8a3b])
        by smtp.googlemail.com with ESMTPSA id b4-20020a1709062b4400b007317f017e64sm1711617ejg.134.2022.09.02.13.52.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 13:52:42 -0700 (PDT)
Message-ID: <68bd1e34-4251-4306-cc7d-e5ccc578acd9@gmail.com>
Date:   Fri, 2 Sep 2022 22:52:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: use devm_clk_get_optional_enabled() to
 simplify the code
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have devm_clk_get_optional_enabled(), we don't have to
open-code it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 37 ++---------------------
 1 file changed, 3 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a8b0070bb..e6fb6f223 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5122,37 +5122,6 @@ static int rtl_jumbo_max(struct rtl8169_private *tp)
 	}
 }
 
-static void rtl_disable_clk(void *data)
-{
-	clk_disable_unprepare(data);
-}
-
-static int rtl_get_ether_clk(struct rtl8169_private *tp)
-{
-	struct device *d = tp_to_dev(tp);
-	struct clk *clk;
-	int rc;
-
-	clk = devm_clk_get(d, "ether_clk");
-	if (IS_ERR(clk)) {
-		rc = PTR_ERR(clk);
-		if (rc == -ENOENT)
-			/* clk-core allows NULL (for suspend / resume) */
-			rc = 0;
-		else
-			dev_err_probe(d, rc, "failed to get clk\n");
-	} else {
-		tp->clk = clk;
-		rc = clk_prepare_enable(clk);
-		if (rc)
-			dev_err(d, "failed to enable clk: %d\n", rc);
-		else
-			rc = devm_add_action_or_reset(d, rtl_disable_clk, clk);
-	}
-
-	return rc;
-}
-
 static void rtl_init_mac_address(struct rtl8169_private *tp)
 {
 	u8 mac_addr[ETH_ALEN] __aligned(2) = {};
@@ -5216,9 +5185,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENOMEM;
 
 	/* Get the *optional* external "ether_clk" used on some boards */
-	rc = rtl_get_ether_clk(tp);
-	if (rc)
-		return rc;
+	tp->clk = devm_clk_get_optional_enabled(&pdev->dev, "ether_clk");
+	if (IS_ERR(tp->clk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(tp->clk), "failed to get ether_clk\n");
 
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	rc = pcim_enable_device(pdev);
-- 
2.37.3

