Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6AD29097B
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 22:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfHPUcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 16:32:39 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35840 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727620AbfHPUci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 16:32:38 -0400
Received: by mail-wr1-f68.google.com with SMTP id r3so2697394wrt.3
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 13:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=upg+bZO2tl76NuL5qRGzzUNcHidJHyMzxJdBLW1vxSA=;
        b=byDNfTIYBSJyv/QXUlb+z8Zt+wxNx1j+e1wWOziiixFQ5HLHeRP9whf8GNPBKrTzX4
         E4DuESKwYMaCJi5/kqC9eKeRadLazx9rA5/bvpTvwa/0u/vt+fnh/gzO5kwZIAe/UUys
         u6sTnF7H9Twsh9hNIx9Oa7pQqK+R19bVhoN+sZpUQI3wu4EBB1SeyTgoJnJfmpRcy81j
         ka70nBUUtHWwfrvppM5iKzk+difTmgPz6V/sFwGUT5izlj7KYIm/q3oa9Wwg5wtNosHC
         i1Nj5CSSgn5fiE5WxxoYaYcvchjF7v0Sf5hf+nfmx7AhU2xmDfo+UTexEaHcv6x7Ym/I
         IoFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=upg+bZO2tl76NuL5qRGzzUNcHidJHyMzxJdBLW1vxSA=;
        b=LDqYO0Zae5LifTuGwG7KNx7yvWN6Ld+iemAH9J8b9r+BxOrxC0lcYNt4kWGX+N+FF5
         Ooum+J02/wKvDrbj4UmY4iETYOnKFIb1FG6ZgfHqKZpvZx1pqF7n7zE9BQNVFfOds2Wr
         VI0MN4XExJ3TJ3mWsgN+ClGNSjr8zwuEHISV/yh5HCgCTYfE7rBvo29XSu32TBSBBaXt
         ISOYbiFNwkf1OAyXYqGwG0WPVIlM6dvZOP7oEYf0EDPwhiJdVKMzuK4qe7yY09FnY/U0
         MsShyyFSfhaxT1wMJZlg2CJpORBPtouInHTDjw2pA1DRaKEWeiffd2LTmw4QJTcEZTUE
         4ccw==
X-Gm-Message-State: APjAAAUOQ3UsiINXE0hDLl4JIyrGsHARA/wJR8KN9Rq1vQDFjGj7pnvY
        OAHxJQ7UBd7UcsPC8D+fdAOE/aDy
X-Google-Smtp-Source: APXvYqybJyUoMp4mWW8bmZbY5bspM2sqepJoluxCLyTUXUpJVZFzc0hK+2bY3N0mqXi3f5lcafCplA==
X-Received: by 2002:adf:8043:: with SMTP id 61mr13025994wrk.115.1565987556561;
        Fri, 16 Aug 2019 13:32:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:4112:e131:7f21:ec09? (p200300EA8F2F32004112E1317F21EC09.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:4112:e131:7f21:ec09])
        by smtp.googlemail.com with ESMTPSA id s19sm5034956wrb.94.2019.08.16.13.32.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 13:32:36 -0700 (PDT)
Subject: [PATCH net-next v2 2/3] net: dsa: remove calls to genphy_config_init
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Kevin Hilman <khilman@baylibre.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <62de47ba-0624-28c0-56a1-e2fc39a36061@gmail.com>
Message-ID: <13a9fa50-4e7d-4cb5-8c2c-0754d8a96542@gmail.com>
Date:   Fri, 16 Aug 2019 22:31:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <62de47ba-0624-28c0-56a1-e2fc39a36061@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supported PHY features are either auto-detected or explicitly set.
In both cases calling genphy_config_init isn't needed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/dsa/port.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index f071acf28..f75301456 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -538,10 +538,6 @@ static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
 		return PTR_ERR(phydev);
 
 	if (enable) {
-		err = genphy_config_init(phydev);
-		if (err < 0)
-			goto err_put_dev;
-
 		err = genphy_resume(phydev);
 		if (err < 0)
 			goto err_put_dev;
@@ -589,7 +585,6 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
 		mode = PHY_INTERFACE_MODE_NA;
 	phydev->interface = mode;
 
-	genphy_config_init(phydev);
 	genphy_read_status(phydev);
 
 	if (ds->ops->adjust_link)
-- 
2.22.1


