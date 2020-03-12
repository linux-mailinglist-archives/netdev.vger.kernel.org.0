Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D208B183B46
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 22:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgCLVZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 17:25:30 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34176 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgCLVZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 17:25:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id z15so9438527wrl.1
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 14:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=i4stpvzEqT7xMXHFpKzckbgbOkkwJ1S82NyNrWXkjXk=;
        b=Urtb5I7uHaS3SbDmitRvFBh47M9yToHaWSU6UWTuERgO+sY8stlxxlLCfC0VZRRcBx
         L32EL17xkPnOIpTfUdhPgwu1ESTYj/faxL4qHJ5GJseCbvm+iom39SNM4Q/2f1nrIcb3
         YELi5ihu6MJ6ssJs2oj12VpLcsDbA0Xarhw4JQ/ecj+b/UW3OoxTDzDEgiO5BkgESGzz
         qIRp/eVvLt09+RTtzUc1k/F/c5QH36dni6VBOgICd9toCL+nQCQuXDFm3ax7y+qFvlaX
         yMLQuKK70DzAFnIEk9XdF+x+XRqODjqCnLAkziAG9BG2XnMJuOe/5SdXzNih9QExwAgX
         R7WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=i4stpvzEqT7xMXHFpKzckbgbOkkwJ1S82NyNrWXkjXk=;
        b=h01ZNySMgos0u7hG8Bm0n3TwsHU67ZdNuKxobCcx95isoW7TM4iCO0x82OkFHZyWzf
         ENDjU+u9TffxoGHdBSDumzw4O41II+FwcUhSERx2gRpwTZI0zOiMQucX1YxYVQh4I8mj
         1hAMHXL5QPU7HDdpeDCl0c2ShOtNEAnY8chuMD/AMwaLg3SHbKxiM5FPVMAfmhn+0+JX
         6NLehPw4uNq8vYCAkOWrtLBFspJyYgZsefpbNvvA00QSr4uO2XcGDrZWomW5QBeajwQX
         thFhAAgInH6MhBcP7iWjSKwzsfdLpZTinqc8SdYJ6oIcA/bQEymIbo/7mGw9DwTJhvKm
         eNvQ==
X-Gm-Message-State: ANhLgQ3paf+j9qx1yvD3wKxaSk3mYQpvXB5bDBcDgNEbTaAer7zOp63j
        5Ho3MZqdQpJ+zZFumluQTy5tbQO9
X-Google-Smtp-Source: ADFU+vuTXwKRyFydzoiDiwvpPb/fvJaP3RNsTchN7a1hYztto5HWDLGztK4XglE1Tpv+hOZVd4KMrw==
X-Received: by 2002:adf:ee86:: with SMTP id b6mr12707538wro.282.1584048328258;
        Thu, 12 Mar 2020 14:25:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:176:2e76:c31:fe1? (p200300EA8F29600001762E760C310FE1.dip0.t-ipconnect.de. [2003:ea:8f29:6000:176:2e76:c31:fe1])
        by smtp.googlemail.com with ESMTPSA id d63sm14144628wmd.44.2020.03.12.14.25.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2020 14:25:27 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] net: phy: fix MDIO bus PM PHY resuming
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <8fb49a53-4c9e-feb9-d4c9-e7ee7fd88597@gmail.com>
Date:   Thu, 12 Mar 2020 22:25:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far we have the unfortunate situation that mdio_bus_phy_may_suspend()
is called in suspend AND resume path, assuming that function result is
the same. After the original change this is no longer the case,
resulting in broken resume as reported by Geert.

To fix this call mdio_bus_phy_may_suspend() in the suspend path only,
and let the phy_device store the info whether it was suspended by
MDIO bus PM.

Fixes: 503ba7c69610 ("net: phy: Avoid multiple suspends")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 6 +++++-
 include/linux/phy.h          | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 32a5ceddc..6d6c6a178 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -286,6 +286,8 @@ static int mdio_bus_phy_suspend(struct device *dev)
 	if (!mdio_bus_phy_may_suspend(phydev))
 		return 0;
 
+	phydev->suspended_by_mdio_bus = 1;
+
 	return phy_suspend(phydev);
 }
 
@@ -294,9 +296,11 @@ static int mdio_bus_phy_resume(struct device *dev)
 	struct phy_device *phydev = to_phy_device(dev);
 	int ret;
 
-	if (!mdio_bus_phy_may_suspend(phydev))
+	if (!phydev->suspended_by_mdio_bus)
 		goto no_resume;
 
+	phydev->suspended_by_mdio_bus = 0;
+
 	ret = phy_resume(phydev);
 	if (ret < 0)
 		return ret;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 8b299476b..118de9f5b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -357,6 +357,7 @@ struct macsec_ops;
  * is_gigabit_capable: Set to true if PHY supports 1000Mbps
  * has_fixups: Set to true if this phy has fixups/quirks.
  * suspended: Set to true if this phy has been suspended successfully.
+ * suspended_by_mdio_bus: Set to true if this phy was suspended by MDIO bus.
  * sysfs_links: Internal boolean tracking sysfs symbolic links setup/removal.
  * loopback_enabled: Set true if this phy has been loopbacked successfully.
  * state: state of the PHY for management purposes
@@ -396,6 +397,7 @@ struct phy_device {
 	unsigned is_gigabit_capable:1;
 	unsigned has_fixups:1;
 	unsigned suspended:1;
+	unsigned suspended_by_mdio_bus:1;
 	unsigned sysfs_links:1;
 	unsigned loopback_enabled:1;
 
-- 
2.25.1

