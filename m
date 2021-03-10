Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE55334B3F
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 23:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhCJWNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 17:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbhCJWMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 17:12:50 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F3BC061574;
        Wed, 10 Mar 2021 14:12:49 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 16so11583342pfn.5;
        Wed, 10 Mar 2021 14:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8T32QTH1yWolqsovx8D+tK2naeopNTlCRVMubzQO1RM=;
        b=VmfjgtBnv7qRT4p4OjHzo8Jf53zCLviWLqjlsk/EeXd9NCKJ090h4d4vRszWAV3Wn0
         fveJCJknPHh5lOB03hZutBytWMpBoNLGdzf22AJzMYgIB6NiWys2+Oh/z5cSvhJ9B9BM
         EeHYi75BmoLlan4P/CWMzv68jH9kxNKDDv3dOzumqZ78vmuu6gWtlHXB2ApvHuX5j8KK
         R9YxagMusqv0CfK4PojdzaEaGzHuD2UJyucFK54imC1kXOunkUx8waZPU1srEH01JTNd
         QbtUrj8Zjz7062T1ejWdaHhw6OrVStLpUbsA1/vhBsNq6QJUMHIefHwyTUbp3k4lTRB+
         bYQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8T32QTH1yWolqsovx8D+tK2naeopNTlCRVMubzQO1RM=;
        b=f146PPdSyxJQiGaUa5KxFZOv9XaY7y1nGMSUqh1g9x4Q8q/fLunuitOxaEZqQYH1qG
         7I/le1/QJQSNZOeKp25Jz4nWHvYwZXrcx8OPlrVfhNqLFkGsyu4n9e1a0vT/6EYwkfX8
         5cUm0xcXBQ/4bzeOWXxS+sdz0aQfYlywCxvCR2yfN8hhvxcHEUmdpRRBb/J3iOn6gBGG
         qNCRU7iNe/9N5ovOx0IjVL0XwHAgSLCcNtrgHwzJvvPZ/Jn6VvEh/tkoY4m6Cq6gkPqJ
         G7708PB7IO+DPW0bUJSrEGoEAZBVfs/OBRkg/YViLP9a25b2ymK/q8W+5ohgT+pErZI7
         26rg==
X-Gm-Message-State: AOAM531oH6klzY4hksGl4StCwpxJ7J7oQRB+hVzzpv/7fZ8CeTyJ9mOV
        j61wrhPpol39tjGAfst7yyYoqND4CBk=
X-Google-Smtp-Source: ABdhPJxA3aeiZp7oWsoyyghX4gqfLAA1odDI7q/EYNunNaKd4ahJh+X5vlqLsBLRTeu0JtnJR8Tlhw==
X-Received: by 2002:a63:1312:: with SMTP id i18mr4560866pgl.108.1615414368977;
        Wed, 10 Mar 2021 14:12:48 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gk12sm310638pjb.44.2021.03.10.14.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:12:48 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: phy: Expose phydev::dev_flags through sysfs
Date:   Wed, 10 Mar 2021 14:12:43 -0800
Message-Id: <20210310221244.2968469-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phydev::dev_flags contains a bitmask of configuration bits requested by
the consumer of a PHY device (Ethernet MAC or switch) towards the PHY
driver. Since these flags are often used for requesting LED or other
type of configuration being able to quickly audit them without
instrumenting the kernel is useful.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/ABI/testing/sysfs-class-net-phydev | 12 ++++++++++++
 drivers/net/phy/phy_device.c                     | 11 +++++++++++
 2 files changed, 23 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-net-phydev b/Documentation/ABI/testing/sysfs-class-net-phydev
index 40ced0ea4316..ac722dd5e694 100644
--- a/Documentation/ABI/testing/sysfs-class-net-phydev
+++ b/Documentation/ABI/testing/sysfs-class-net-phydev
@@ -51,3 +51,15 @@ Description:
 		Boolean value indicating whether the PHY device is used in
 		standalone mode, without a net_device associated, by PHYLINK.
 		Attribute created only when this is the case.
+
+What:		/sys/class/mdio_bus/<bus>/<device>/phy_dev_flags
+Date:		March 2021
+KernelVersion:	5.13
+Contact:	netdev@vger.kernel.org
+Description:
+		32-bit hexadecimal number representing a bit mask of the
+		configuration bits passed from the consumer of the PHY
+		(Ethernet MAC, switch, etc.) to the PHY driver. The flags are
+		only used internally by the kernel and their placement are
+		not meant to be stable across kernel versions. This is intended
+		for facilitating the debugging of PHY drivers.
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index cc38e326405a..a009d1769b08 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -512,10 +512,21 @@ phy_has_fixups_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(phy_has_fixups);
 
+static ssize_t phy_dev_flags_show(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	struct phy_device *phydev = to_phy_device(dev);
+
+	return sprintf(buf, "0x%08x\n", phydev->dev_flags);
+}
+static DEVICE_ATTR_RO(phy_dev_flags);
+
 static struct attribute *phy_dev_attrs[] = {
 	&dev_attr_phy_id.attr,
 	&dev_attr_phy_interface.attr,
 	&dev_attr_phy_has_fixups.attr,
+	&dev_attr_phy_dev_flags.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(phy_dev);
-- 
2.25.1

