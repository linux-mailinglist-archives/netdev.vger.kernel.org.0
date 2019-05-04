Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6244913890
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 12:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfEDKBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 06:01:13 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53774 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfEDKBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 06:01:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id q15so9899290wmf.3
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 03:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Fj0OlWQ2xjg6R5NPRQ3RfRoha9p6V7WJa7EPibmkW/s=;
        b=WQp6t12rKsgorldgiFWX9Qf4PbjsHTIb/4UlZvd88JyZ67Yo9Im/4hA3E34EmKeHi+
         C0+IP1ZrOsBTja3A36rao00tSpdwlkhtbvjgZXKBX6nMDVpusCbl6tQeG+NXBgrInkKQ
         BcaXNdqrtvtSMB+HmeMfXhk+r9SjjSRWMFMHz+9Nz8S0oc4jfGEyJTlYLdMlzLdq3KsA
         4sdzrYgIeHsT521ZKECnULmYLdo2HvvkMZF6Kcd8b4eC54I+Umfb4F31mkmut5MzKQet
         jO24B0jTzV26I1g0TBaQFOMnYYsVHb8u25Q5oZsaNupbemh8CLdNMN45YWg91v7zHQcf
         o8pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Fj0OlWQ2xjg6R5NPRQ3RfRoha9p6V7WJa7EPibmkW/s=;
        b=bFyeSphpvZkXhCFXhCaLFzvSfRguGOCMg52d3gKXPuSU/iZMmQVI2xxu/c/9Z5dVQ2
         Q8ojqVjk2TNJA2/8r1Cb3Ct/BvyHXsQjCL3nRMuEp7YsQcmeENkMSeJTTVVn4CICRNAE
         iWcc6tyWu/dxg6/hUb39fPkIwAduTewJtEEjF2PK657I85idT5Plbb1lpniodzN87cbb
         p+iO9QbLK4hpYJC+lM7FZ3QFUsll2+s+HUqb8Fv8LHEJLpWKPw5fDQK4s5YZHk8sXCGh
         wNi8IbWLVriQ1GVgVgErKUr4FQ7RdcGmeVTSDwIEAyZIIU9fBvVXBOg4rrIXN9iLg8TL
         S5Ng==
X-Gm-Message-State: APjAAAUloqWBiFp8zvVKatqWZICCeeFbJDGzuWwspFCHF4qyBPVBhKtM
        TQbT26iixWK7LEyHh5CFQe2Ox8wIhUM=
X-Google-Smtp-Source: APXvYqxIzWpXgWdWUReNKF1AHo/sJKcjzpAisgdbUlpZogDJ8PpEIa5G11LqF+D7ypbrJ3Zm+6PseA==
X-Received: by 2002:a7b:c938:: with SMTP id h24mr9078039wml.28.1556964070837;
        Sat, 04 May 2019 03:01:10 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:4cd8:8005:fc98:c429? (p200300EA8BD457004CD88005FC98C429.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:4cd8:8005:fc98:c429])
        by smtp.googlemail.com with ESMTPSA id t24sm10877672wra.58.2019.05.04.03.01.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 03:01:09 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: make use of phy_set_asym_pause
Message-ID: <3d79b143-70e7-2345-dcca-53967339b1d1@gmail.com>
Date:   Sat, 4 May 2019 12:01:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phy_probe() takes care that all supported modes are advertised,
in addition use phy_support_asym_pause() to advertise pause modes.
This way we don't have to deal with phylib internals directly.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index ee16b7782..ad2ebb367 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -6459,8 +6459,7 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
 	if (!tp->supports_gmii)
 		phy_set_max_speed(phydev, SPEED_100);
 
-	/* Ensure to advertise everything, incl. pause */
-	linkmode_copy(phydev->advertising, phydev->supported);
+	phy_support_asym_pause(phydev);
 
 	phy_attached_info(phydev);
 
-- 
2.21.0

