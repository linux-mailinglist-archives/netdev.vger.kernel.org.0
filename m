Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF9986A65
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404220AbfHHTGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:06:06 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35553 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404196AbfHHTGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:06:05 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so3450320wmg.0
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 12:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pLjq7tcw8/4nBJQdbmQJ5+XoWodmMFM3mT3baREFlGA=;
        b=P79wy+BNdOM9RPF4YXITf3f6zpiKTEqenIBO6pAFYyd8qyYm5JGZm8ttM/5InmfXaC
         61CYAf7gwyBiRlbyGXHWMSPImYY5Ob/+J36g3qpjjxvf8nG67BZMdaqpV62wVvPg6Wqn
         zfVFP8dwccHWVwBxHhBQ1H1Vlbq7iAd7uYCnLrZfQ/VUpJQhkwtL0DwXbEZLPy+vAYNq
         hpwzC/6iXTqVqlUMzlp75hCf14A+r0nF+Ixi9tVRwMKs3PlNDYQVnDQ5mQW9d8mKCJ7b
         cC7J6aNy1H/21LulqWfWlyHXRDy+FTRHdNdXv9TYxkvJGg1JmUAIPMBzdUIDDhBwOhPS
         OcDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pLjq7tcw8/4nBJQdbmQJ5+XoWodmMFM3mT3baREFlGA=;
        b=ing0HlosN19r5uV29rK9tQLtMcR0lsohUH7I0pq0TkTfisv3SoZnOny5O7xzoNBQpK
         JXnT6Xoy2YnGh9qTugLnBfWGI6oaWxCQ+BLbrcVpeeaqSFt8gHwzbW6pI7f8ykOuyeox
         ojCOTAFwwMfFYonfFUUl3SO2xgmo/R4E+u+b1r+IgWxG3v6IJhOWmEWJ7VlX604+RUTq
         GBLpymTTh5LHuW1If1hq2jF9tnnjW7lx43gJBwpJesC1Do99+tUhvkJfapnumOWA7FXt
         RRHxN55NOHFUR9B9RJhdw8YqMa29UleJ1g4zu4J2gkQ7EFIe4NFBMU4mtIyonqQ7Sq/8
         IXgg==
X-Gm-Message-State: APjAAAUQUqc05i6UrIDCjGJ/60hmLWpK64eGtudWNamFRb+r9hVAjtDE
        MX+TpHPMJrhEk6D2J7XXzaPKXv/n
X-Google-Smtp-Source: APXvYqwYLGk1JTKylRnpExNrKhBcLDHeIUH+lTaoW1gDen/S6xsolKkJJWDTGHEnvEnjhzNr16lAjA==
X-Received: by 2002:a7b:cb08:: with SMTP id u8mr5996833wmj.167.1565291163436;
        Thu, 08 Aug 2019 12:06:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf? (p200300EA8F2F3200EC8A8637BF5F7FAF.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf])
        by smtp.googlemail.com with ESMTPSA id w13sm12679575wre.44.2019.08.08.12.06.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 12:06:02 -0700 (PDT)
Subject: [PATCH net-next 2/3] net: phy: add phy_modify_paged_changed
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ddbf28b9-f32e-7399-10a6-27b79ca0aaf9@gmail.com>
Message-ID: <b1495134-92d9-02ad-1901-9a2cd6775996@gmail.com>
Date:   Thu, 8 Aug 2019 21:04:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ddbf28b9-f32e-7399-10a6-27b79ca0aaf9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper function phy_modify_paged_changed, behavior is the same
as for phy_modify_changed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy-core.c | 29 ++++++++++++++++++++++++-----
 include/linux/phy.h        |  2 ++
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 16667fbac..9ae3abb2d 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -783,24 +783,43 @@ int phy_write_paged(struct phy_device *phydev, int page, u32 regnum, u16 val)
 EXPORT_SYMBOL(phy_write_paged);
 
 /**
- * phy_modify_paged() - Convenience function for modifying a paged register
+ * phy_modify_paged_changed() - Function for modifying a paged register
  * @phydev: a pointer to a &struct phy_device
  * @page: the page for the phy
  * @regnum: register number
  * @mask: bit mask of bits to clear
  * @set: bit mask of bits to set
  *
- * Same rules as for phy_read() and phy_write().
+ * Returns negative errno, 0 if there was no change, and 1 in case of change
  */
-int phy_modify_paged(struct phy_device *phydev, int page, u32 regnum,
-		     u16 mask, u16 set)
+int phy_modify_paged_changed(struct phy_device *phydev, int page, u32 regnum,
+			     u16 mask, u16 set)
 {
 	int ret = 0, oldpage;
 
 	oldpage = phy_select_page(phydev, page);
 	if (oldpage >= 0)
-		ret = __phy_modify(phydev, regnum, mask, set);
+		ret = __phy_modify_changed(phydev, regnum, mask, set);
 
 	return phy_restore_page(phydev, oldpage, ret);
 }
+EXPORT_SYMBOL(phy_modify_paged_changed);
+
+/**
+ * phy_modify_paged() - Convenience function for modifying a paged register
+ * @phydev: a pointer to a &struct phy_device
+ * @page: the page for the phy
+ * @regnum: register number
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ *
+ * Same rules as for phy_read() and phy_write().
+ */
+int phy_modify_paged(struct phy_device *phydev, int page, u32 regnum,
+		     u16 mask, u16 set)
+{
+	int ret = phy_modify_paged_changed(phydev, page, regnum, mask, set);
+
+	return ret < 0 ? ret : 0;
+}
 EXPORT_SYMBOL(phy_modify_paged);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 7117825ee..781f4810c 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -984,6 +984,8 @@ int phy_select_page(struct phy_device *phydev, int page);
 int phy_restore_page(struct phy_device *phydev, int oldpage, int ret);
 int phy_read_paged(struct phy_device *phydev, int page, u32 regnum);
 int phy_write_paged(struct phy_device *phydev, int page, u32 regnum, u16 val);
+int phy_modify_paged_changed(struct phy_device *phydev, int page, u32 regnum,
+			     u16 mask, u16 set);
 int phy_modify_paged(struct phy_device *phydev, int page, u32 regnum,
 		     u16 mask, u16 set);
 
-- 
2.22.0


