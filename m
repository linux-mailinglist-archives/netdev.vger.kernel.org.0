Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D2D1A6BA
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 07:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfEKFo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 01:44:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36385 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfEKFo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 01:44:58 -0400
Received: by mail-wr1-f66.google.com with SMTP id o4so9894152wra.3
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 22:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Zk+RhgfYFLoxJJTssSaqDGIuzBBb22lnPAtxJ/+urKY=;
        b=g//5UevowWQl/giYNmOq3MaSb4GKUsESJF9CV9WNhePXuqhcCj3YSqlJ7XS62EJdg2
         yjM6kLmEqP2cFh2vmt25vTKUPesdDUO0bWNtqb3Zw0lwSOpldPXJaAEahjdL8BL5C+h8
         BAOGgmQIyfM45dKIZCWBT5Uw1+0V2J9sy/3flnKotNUB4TxFiOJznsee2njWsJiHszhn
         Mr9K0PhCPsnKISGvEopTzWUqBE2IBN9SEIt6IEBU1VcH1//hZiETS+Ei1yr1Bi/lF7L9
         12r5CjL8cvQtjw394jw8BUQFNpSo6rF1o3ygcX3hk8i39Wyno7QENaW/OgVUMvt5mAwd
         w6QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Zk+RhgfYFLoxJJTssSaqDGIuzBBb22lnPAtxJ/+urKY=;
        b=g4VROGzhnKa+XVrdbwBljcBCuz7f3z2bk8HTclLnfH6tE/9jbLkSpAt75qQMhD1W/Z
         NyP3qlCzy2c2ZsSXy5ly9HsCYjwDByxe0YDjNKbtZlnvoKkC/U5xl+InAcsFpGm4WBTn
         X9JGNMrFP8GhdJFdVU59o88ChfhMIq66w6jQ+2Sibh3HAeZNxuWxXMsx2oYgbpVaIWv9
         8id34eYYAqba2BOVsao/Pc7KUof/5jCihhqejhMXx37Hwvf4uUipWCE8LM9v7FObk/ZU
         2iP/OUc/Swsj7J02rkJx3A/XSaiS1dwxCWQ25IcRhbWnVHszr4Ui2qLS6LRpFurK+sDV
         rVww==
X-Gm-Message-State: APjAAAX1DFai9+vGLBUiSO+/Hlp7VJ9a8RSjOP8oQYqeRmnKr4EbRP/n
        iKCqz59qgN9nB/alsk+EJA91lqkuGtQ=
X-Google-Smtp-Source: APXvYqxiQ2xux6GygpiVzrHrMvlnUNqArguaheAp7mYqmlBZB44eeT2LISZcyNomYTX1rVlhzxD1jA==
X-Received: by 2002:a5d:4a87:: with SMTP id o7mr9985237wrq.207.1557553496464;
        Fri, 10 May 2019 22:44:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:b0bf:edb1:2b4b:6ef1? (p200300EA8BD45700B0BFEDB12B4B6EF1.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:b0bf:edb1:2b4b:6ef1])
        by smtp.googlemail.com with ESMTPSA id t6sm7120917wmt.8.2019.05.10.22.44.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 22:44:55 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] net: phy: realtek: fix double page ops in generic Realtek
 driver
Message-ID: <c2c9f3c6-81c4-7c27-8989-10331bb69dc6@gmail.com>
Date:   Sat, 11 May 2019 07:44:48 +0200
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

When adding missing callbacks I missed that one had them set already.
Interesting that the compiler didn't complain.

Fixes: daf3ddbe11a2 ("net: phy: realtek: add missing page operations")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/realtek.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 29ce07312..4988ccea6 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -332,8 +332,6 @@ static struct phy_driver realtek_drvs[] = {
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
-		.read_page	= rtl821x_read_page,
-		.write_page	= rtl821x_write_page,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc961),
 		.name		= "RTL8366RB Gigabit Ethernet",
-- 
2.21.0

