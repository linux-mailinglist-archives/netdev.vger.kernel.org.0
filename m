Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920A96D38C1
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 17:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbjDBPSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 11:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjDBPSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 11:18:24 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC277EB45
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 08:18:22 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id i5so108123629eda.0
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 08:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680448701;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X8jy0Uy+SkhXLksCm2m8dgVxEb7428GtIa/wyAURie0=;
        b=Y9fGYbQ5mY2IHImg4ILWpLvtwzlW4jv5lnh5YHj9jmg00ER/RWvEHV8bmB+lr7ZQc/
         Kc9vip4wqYdz9IZjyPzoatU2liAJZSlnPROOmb6NMrRnV7fbyekfyq5qv+VVpy3NLUjX
         69wxX2FdvBLasXV8g4N0AbkQTYsjXJ95aV1xa8CfJjJGXnuoqPe0ewGodd5Y/fb7h5bV
         6KSf7bvrGURWdJL5kbBsSAR4HRVa0BA5AvDPN0ja4Z9pPK903vQRT2To+tLZ1oMpP08b
         U1Y7fIyWcE5S5RmYB5i8fEwoeCRfkQqio7K/CefDWiNJUoKkRiB0UovnQXzN5EAU5LEY
         zXpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680448701;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X8jy0Uy+SkhXLksCm2m8dgVxEb7428GtIa/wyAURie0=;
        b=Ct6E+DU8CvJ6T2Nua+R8tS2pbZOCieg38dqjhG6QJ+VBl3cK6044gqCr620SOQzBOk
         eh07J4DHUp2s9LjCuvJBbYWzYA4EgZ4yJaT9lC9ZyiTYIT5EJ2FtfGRkq5r9crhND5Yw
         ogP+x+sb5+z4r4CZwPLYrYqZ/lln+4HtxTQhf7JixwD3Sfdl+lVHOWjfQzARtBn4xjxd
         DsiRrkCUxkyWWw53yDw3pYniTc/8XF+PP/q/dbDL+oQUTXLP238Y8LwpMm7fVFgUwCkE
         yFKX8kMDqeUHo+KCPHVLgKijVKzHZlhP3vHJSLIdK/3Bhj8yMg7y0QLpFE5SM1IXLiKh
         sgRQ==
X-Gm-Message-State: AAQBX9eI8MAKAJ4gduX6olK2lUnhv3AQxUt0uy+nf/3LRpeCaan3lsqW
        e/wHVHKcvfmXso9qRRsT8iw=
X-Google-Smtp-Source: AKy350aX9WtfJDZnECcbYCR5wUBtkQVaXZy4LmYi9OyYaHW1Wcq0WZU1VtA4cYDGOSDS66EiG9+sVA==
X-Received: by 2002:a17:907:7295:b0:947:9dd3:d750 with SMTP id dt21-20020a170907729500b009479dd3d750mr10294809ejc.64.1680448701188;
        Sun, 02 Apr 2023 08:18:21 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id o2-20020a50c282000000b00501cc88b3adsm3374863edf.46.2023.04.02.08.18.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 08:18:20 -0700 (PDT)
Message-ID: <63c73df8-c1b9-7011-8490-2ab6de79d821@gmail.com>
Date:   Sun, 2 Apr 2023 17:14:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: [PATCH net-next v2 5/7] net: phy: smsc: prepare for making edpd wait
 period configurable
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Healy <cphealy@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
In-Reply-To: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a member edpd_max_wait_ms to the private data structure in preparation
of making the wait period configurable by supporting the edpd phy tunable.

v2:
- rename constant to EDPD_MAX_WAIT_DFLT_MS

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 25b9cd474..659a3ab10 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -33,6 +33,8 @@
 #define SPECIAL_CTRL_STS_AMDIX_ENABLE_	0x4000
 #define SPECIAL_CTRL_STS_AMDIX_STATE_	0x2000
 
+#define EDPD_MAX_WAIT_DFLT_MS		640
+
 struct smsc_hw_stat {
 	const char *string;
 	u8 reg;
@@ -46,6 +48,7 @@ static struct smsc_hw_stat smsc_hw_stats[] = {
 struct smsc_phy_priv {
 	unsigned int edpd_enable:1;
 	unsigned int edpd_mode_set_by_user:1;
+	unsigned int edpd_max_wait_ms;
 };
 
 static int smsc_phy_ack_interrupt(struct phy_device *phydev)
@@ -213,9 +216,13 @@ int lan87xx_read_status(struct phy_device *phydev)
 	if (err)
 		return err;
 
-	if (!phydev->link && priv && priv->edpd_enable) {
+	if (!phydev->link && priv && priv->edpd_enable &&
+	    priv->edpd_max_wait_ms) {
+		unsigned int max_wait = priv->edpd_max_wait_ms * 1000;
+		int rc;
+
 		/* Disable EDPD to wake up PHY */
-		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
+		rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
 		if (rc < 0)
 			return rc;
 
@@ -229,7 +236,7 @@ int lan87xx_read_status(struct phy_device *phydev)
 		 */
 		read_poll_timeout(phy_read, rc,
 				  rc & MII_LAN83C185_ENERGYON || rc < 0,
-				  10000, 640000, true, phydev,
+				  10000, max_wait, true, phydev,
 				  MII_LAN83C185_CTRL_STATUS);
 		if (rc < 0)
 			return rc;
@@ -299,6 +306,7 @@ int smsc_phy_probe(struct phy_device *phydev)
 		return -ENOMEM;
 
 	priv->edpd_enable = true;
+	priv->edpd_max_wait_ms = EDPD_MAX_WAIT_DFLT_MS;
 
 	if (device_property_present(dev, "smsc,disable-energy-detect"))
 		priv->edpd_enable = false;
-- 
2.40.0


