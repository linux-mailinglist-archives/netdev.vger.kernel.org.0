Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 422FA882D3
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406965AbfHISpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:45:34 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50448 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfHISpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:45:33 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so6645315wml.0
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 11:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P0n5meOT6sPh0BKo7DbVL/aBE233Zl5+u9Q2+WYA0Ko=;
        b=gwJlS74MDdyr/ZpZ/LTP5K7HBwJqCZ+UnWCVtfdHBi4Jw2RZ2WHGEYFfmESnWqMOwb
         mitbemzH9c+0g3b5vmfwyE99Vp9WhVwbSdNjFePL0N38CialB3MN/KU/QArh3JipMW/r
         tKSxKnFcxHX4MOaoWajbZMc9GDj6cXbK2OP8J5ij8ZBIi/K7bP4Xaijy7jgZ1bLa3GJJ
         yxZJvfzjWxijUOyTZKkM3qdzK9WvcgnDOWgL9qrt0a4Aw9s8hGN8Ix2oSYkzZBqVy9ij
         W0GTdyu773lZA7OlTHzF22iqZ8Ud8vnJvJsI1yhcEzHnqvzo4AIJuv6o/KGaCVb0f6rQ
         bJsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P0n5meOT6sPh0BKo7DbVL/aBE233Zl5+u9Q2+WYA0Ko=;
        b=rywkpfIHgXVeKLeENlU+mGfGfB0gA51JNU2+pg8YT++Fxz0zXx2XloEOAayz25mLaU
         osgebt64RAfHaZSagN/Ng1iDllr16AGM86EwlC/NH1yp/OnRt6XJf8N0b+muFw/cKrrg
         0OphgcX3D+/pFTEpYRon7lu8W8IRfCVO5+KZw10akconOSLQZ+lsKMgqI/RhkA5dVzsS
         xfX64j+WFISbZgMayJQCkD9f/zX3sh372aNnqu80HYx+LBkeD3NgB4S8XCqRXDiBMRQt
         0Xb7WORtJVo294CacPeIOJ6AcS4/Nt0O9zMiiiUp4+vaxk1DykdfxS0b4xPNHXEZp/lH
         KddQ==
X-Gm-Message-State: APjAAAVsCNqO1qG9/5KBSxYqYr9NkzkYZNA+MfLx1M2KC944cixqQtx/
        WFXl8p7ZlBnifOI8brIhP3Vw50lv
X-Google-Smtp-Source: APXvYqw6e7rq44n2ImmzSD9Lq7pXcwd+jhyXGaY/Czo2ukZtZSoW4yLnFWsap9SeVHrBF2v+m6ZaSQ==
X-Received: by 2002:a1c:e715:: with SMTP id e21mr12767690wmh.16.1565376331444;
        Fri, 09 Aug 2019 11:45:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:2994:d24a:66a1:e0e5? (p200300EA8F2F32002994D24A66A1E0E5.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:2994:d24a:66a1:e0e5])
        by smtp.googlemail.com with ESMTPSA id c15sm30244561wrb.80.2019.08.09.11.45.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 11:45:30 -0700 (PDT)
Subject: [PATCH net-next v2 3/4] net: phy: add phy_modify_paged_changed
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <755b2bc9-22cb-f529-4188-0f4b6e48efbd@gmail.com>
Message-ID: <741a9493-e9a1-be4e-a2e9-e15294362005@gmail.com>
Date:   Fri, 9 Aug 2019 20:44:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <755b2bc9-22cb-f529-4188-0f4b6e48efbd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper function phy_modify_paged_changed, behavios is the same
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


