Return-Path: <netdev+bounces-9912-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2187E72B27B
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 17:28:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 180941C209D1
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 15:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA591C126;
	Sun, 11 Jun 2023 15:27:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC0B441D
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 15:27:59 +0000 (UTC)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538B8BB;
	Sun, 11 Jun 2023 08:27:58 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b3af7e3925so6336475ad.3;
        Sun, 11 Jun 2023 08:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686497278; x=1689089278;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5kQfP1vR+iNZv7Ccy+cJ3m/nHFj40SdIcUd+PRQBe40=;
        b=kPUE580V59xbmMI7Lk5YAG8EyLp8BwZpcKgLGuKaylDXXFDDW3WzkgU1GHkWJ3LJ/E
         JDSWnNjhnEwWEFRAgdc6saWcKqob0GiawIYIJ4PgR41CFHhZLvKMTvsXdMrxnvxxH1f2
         uV1SINhkQIeVcOqNPBbojg2sGpJC+loZ7pxbqekAByjPfb7UZR2/4JsyiSAA8bixVnDA
         leUfOL2l7QUb6s/frcp11ALAHpmiZQ6cJeViAuYBBa2fjQek0H9Fce6s9AoM9rPGb616
         h67QZ1v0qgeomMlfM15f4wN87Y7Km6LB6J7F/MgYsY0o2u90EMez6gj3nObktuJSdkBG
         eB2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686497278; x=1689089278;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5kQfP1vR+iNZv7Ccy+cJ3m/nHFj40SdIcUd+PRQBe40=;
        b=HAqtZ2wq0XNgOzAdNdIBNDqJYTg8X/XeQXfj9QCq53N2jHZJcgJcQJN9IzYkXbjAmj
         zuKiRB6Cyu0M9yFv5VOXGscBuRqrF0gJzRskjP6B44E+tOCwkux8DrU16Ce3498TXj9f
         7vT5ASPeDZLqoEyALmvETl1uE1BSp5QIvFjiguxMklkkr8K6XCj6QaABgwsNS/IsPZ7H
         ow3qamm2wxH3CcXiVIplR90h26EGSWuR804e1qy1ft/FTfdogdLKNO3DzzWcmudipIpg
         VDqXGtzsqUb/H53aP+Strqh3VbIt0oBDdRdXVYGXD4SzVGa3FaYQm+rn3dwu4GJz4a4v
         xaBA==
X-Gm-Message-State: AC+VfDxabb5GmBIR5ZuJIfh6+dT7m6MI9o9R4sRWbIltBxSrMUxnDBWQ
	M7Xdm3vU/rsiBDDm7qrwW5A=
X-Google-Smtp-Source: ACHHUZ40+Uhg5AFhq9FxNLtMKJPwNwzvEnc6LsCVSD+HDfv3WMcSSPoxpgD0edviBmeeN595ZReMqQ==
X-Received: by 2002:a17:902:da81:b0:1ae:6cf0:94eb with SMTP id j1-20020a170902da8100b001ae6cf094ebmr5456659plx.5.1686497277705;
        Sun, 11 Jun 2023 08:27:57 -0700 (PDT)
Received: from localhost.localdomain ([103.116.245.58])
        by smtp.gmail.com with ESMTPSA id k1-20020a170902694100b00199203a4fa3sm6473909plt.203.2023.06.11.08.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 08:27:57 -0700 (PDT)
From: Jianhui Zhao <zhaojh329@gmail.com>
To: andrew@lunn.ch
Cc: hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jianhui Zhao <zhaojh329@gmail.com>
Subject: [PATCH] net: phy: Add sysfs attribute for PHY c45 identifiers.
Date: Sun, 11 Jun 2023 23:27:43 +0800
Message-Id: <20230611152743.2158-1-zhaojh329@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

If a phydevice use c45, its phy_id property is always 0, so
this adds a phy_c45_ids sysfs attribute to MDIO devices. This
attribute can be useful when debugging problems related to
phy drivers.

Signed-off-by: Jianhui Zhao <zhaojh329@gmail.com>
---
 drivers/net/phy/phy_device.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 17d0d0555a79..521228792840 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -560,6 +560,29 @@ phy_id_show(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR_RO(phy_id);
 
+static ssize_t
+phy_c45_ids_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct phy_device *phydev = to_phy_device(dev);
+	const int num_ids = ARRAY_SIZE(phydev->c45_ids.device_ids);
+	int ret = 0;
+	int i;
+
+	if (!phydev->is_c45)
+		return 0;
+
+	for (i = 1; i < num_ids; i++) {
+		if (phydev->c45_ids.device_ids[i] == 0xffffffff)
+			continue;
+
+		ret += sprintf(buf + ret, "%d: 0x%.8lx\n", i,
+			(unsigned long)phydev->c45_ids.device_ids[i]);
+	}
+
+	return ret;
+}
+static DEVICE_ATTR_RO(phy_c45_ids);
+
 static ssize_t
 phy_interface_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -597,6 +620,7 @@ static DEVICE_ATTR_RO(phy_dev_flags);
 
 static struct attribute *phy_dev_attrs[] = {
 	&dev_attr_phy_id.attr,
+	&dev_attr_phy_c45_ids.attr,
 	&dev_attr_phy_interface.attr,
 	&dev_attr_phy_has_fixups.attr,
 	&dev_attr_phy_dev_flags.attr,
-- 
2.34.1


