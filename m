Return-Path: <netdev+bounces-10732-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB483730052
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:45:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02C2E1C20CE1
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13855BE52;
	Wed, 14 Jun 2023 13:45:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0700AAD4F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:45:39 +0000 (UTC)
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7521FF7;
	Wed, 14 Jun 2023 06:45:38 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-6665f5aa6e6so422017b3a.0;
        Wed, 14 Jun 2023 06:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686750337; x=1689342337;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h9Ew96oWB+C1XdKon0hGd4nuYfEMyvm5iWp1llgF27E=;
        b=g/sDIcKmy0ywZyJz9RQ1v4Nkp7vxxQEfzAQvDLHUAIi5LOLYtPx9WPNK3GqOvDWWPM
         loSk+RdqfCA/E0NzTBByLdODUthsKfEAIVEjpMH4SoRdtlGOEHn7EM3J3F7//H9tiP8a
         o5I0s1jTaeYhNd6Cs5nSiO2QScZXbxXBbrJfARy0QyFWzlqjwy7M+Kd35CxodwL3i2v7
         FN9CLado3sIO8EXZkcu1tfBtfknCWWtRLsdGMClrw+HlOXqJ03D+mfcV1XvNUESjfSMl
         FNUBViqXqzf0EW6SbFe4SS/BqvjQa0qYAySIaRi5j1aeSzR4eUN4B0NkS1wujPbjZA6m
         ngyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686750337; x=1689342337;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h9Ew96oWB+C1XdKon0hGd4nuYfEMyvm5iWp1llgF27E=;
        b=cKyfV+fyUeOHPdrHOAh7vbzw614FC5QUt+kHFvrshWFhjdkbDFrPlxSS+Zr2zcGiPz
         YhekQ2D8rnZFLP2wTzNM1iDD5Yp2Zmsz93BizAUPPr9SMjiJlr7b2jgem5LKGUO2RwDs
         9iY261kKEihzmePOkujPhi0DmBHZFNFCYaZOyZ+PWWJfyxzk/uHvtXt9ZUge+SBC+hEy
         RqSx1HImvRI6e6BgqRDo1BQmI19jRIR2hWFPMcRb9Pn4yzWn5nY3QHT/3aKIzFRebU1n
         eeOLW9VXUp4Xpw+/feGYwXDJlL1jmFivt2EfsXJU/GzzJDkCWFofaetJcditoEdMmjZA
         ubSg==
X-Gm-Message-State: AC+VfDytt6hhQMkbYARUXrENIDn9zkOYiwIwmCUPbAEkmDUTGzSnG+IR
	GZIDzIpZEGGLFn4bAlX2mFENvXKGToaOyDut
X-Google-Smtp-Source: ACHHUZ5RHmjxOPskYOp5inqED+PW2X4o2+sJjCotWuXCSyikuugWkwZFJZt75VN2tloNhjGtted3Pw==
X-Received: by 2002:a05:6a20:8f27:b0:103:883b:10c1 with SMTP id b39-20020a056a208f2700b00103883b10c1mr1604331pzk.41.1686750337201;
        Wed, 14 Jun 2023 06:45:37 -0700 (PDT)
Received: from localhost.localdomain ([103.116.245.58])
        by smtp.gmail.com with ESMTPSA id c2-20020a170902d48200b001aaecc0b6ffsm12223053plg.160.2023.06.14.06.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 06:45:36 -0700 (PDT)
From: Jianhui Zhao <zhaojh329@gmail.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: linux@armlinux.org.uk,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jianhui Zhao <zhaojh329@gmail.com>
Subject: [PATCH V3] net: phy: Add sysfs attribute for PHY c45 identifiers.
Date: Wed, 14 Jun 2023 21:45:22 +0800
Message-Id: <20230614134522.11169-1-zhaojh329@gmail.com>
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
this adds a c45_ids sysfs attribute group contains from mmd0
to mmd31 to MDIO devices.
This attribute group can be useful when debugging problems
related to phy drivers.

Likes this:
/sys/bus/mdio_bus/devices/mdio-bus:05/c45_ids/mmd0
/sys/bus/mdio_bus/devices/mdio-bus:05/c45_ids/mmd1
...
/sys/bus/mdio_bus/devices/mdio-bus:05/c45_ids/mmd31

Signed-off-by: Jianhui Zhao <zhaojh329@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Russell King <linux@armlinux.org.uk>
---
V2 -> V3: Use the most efficient implementation.
V1 -> V2: putting all 32 values in a subdirectory, one file per MMD

 .../ABI/testing/sysfs-class-net-phydev        |  10 ++
 drivers/net/phy/phy_device.c                  | 115 +++++++++++++++++-
 2 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-class-net-phydev b/Documentation/ABI/testing/sysfs-class-net-phydev
index ac722dd5e694..aefddd911b04 100644
--- a/Documentation/ABI/testing/sysfs-class-net-phydev
+++ b/Documentation/ABI/testing/sysfs-class-net-phydev
@@ -63,3 +63,13 @@ Description:
 		only used internally by the kernel and their placement are
 		not meant to be stable across kernel versions. This is intended
 		for facilitating the debugging of PHY drivers.
+
+What:		/sys/class/mdio_bus/<bus>/<device>/c45_ids/mmd<n>
+Date:		November 2023
+KernelVersion:	6.4
+Contact:	netdev@vger.kernel.org
+Description:
+		This attribute group c45_ids contains 32 mmd id attribute from mmd0 to mmd31
+		as reported by the device during bus enumeration, encoded in hexadecimal.
+		This ID is used to match the device with the appropriate
+		driver.
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 17d0d0555a79..b1bbbb42f020 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -602,7 +602,120 @@ static struct attribute *phy_dev_attrs[] = {
 	&dev_attr_phy_dev_flags.attr,
 	NULL,
 };
-ATTRIBUTE_GROUPS(phy_dev);
+
+static const struct attribute_group phy_dev_group = {
+	.attrs = phy_dev_attrs
+};
+
+struct phy_c45_devid_attribute {
+	struct device_attribute attr;
+	int index;
+};
+
+#define to_phy_c45_devid_attr(ptr) \
+	container_of(ptr, struct phy_c45_devid_attribute, attr)
+
+static ssize_t phy_c45_id_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct phy_c45_devid_attribute *devattr = to_phy_c45_devid_attr(attr);
+	struct phy_device *phydev = to_phy_device(dev);
+
+	if (!phydev->is_c45)
+		return 0;
+
+	return sprintf(buf, "0x%.8lx\n",
+		(unsigned long)phydev->c45_ids.device_ids[devattr->index]);
+}
+
+#define DEVICE_ATTR_C45_ID(i) \
+static struct phy_c45_devid_attribute dev_attr_phy_c45_id##i = { \
+	.attr = { \
+		.attr = { .name = __stringify(mmd##i), .mode = 0444 }, \
+		.show = phy_c45_id_show \
+	}, \
+	.index = i, \
+}
+
+DEVICE_ATTR_C45_ID(0);
+DEVICE_ATTR_C45_ID(1);
+DEVICE_ATTR_C45_ID(2);
+DEVICE_ATTR_C45_ID(3);
+DEVICE_ATTR_C45_ID(4);
+DEVICE_ATTR_C45_ID(5);
+DEVICE_ATTR_C45_ID(6);
+DEVICE_ATTR_C45_ID(7);
+DEVICE_ATTR_C45_ID(8);
+DEVICE_ATTR_C45_ID(9);
+DEVICE_ATTR_C45_ID(10);
+DEVICE_ATTR_C45_ID(11);
+DEVICE_ATTR_C45_ID(12);
+DEVICE_ATTR_C45_ID(13);
+DEVICE_ATTR_C45_ID(14);
+DEVICE_ATTR_C45_ID(15);
+DEVICE_ATTR_C45_ID(16);
+DEVICE_ATTR_C45_ID(17);
+DEVICE_ATTR_C45_ID(18);
+DEVICE_ATTR_C45_ID(19);
+DEVICE_ATTR_C45_ID(20);
+DEVICE_ATTR_C45_ID(21);
+DEVICE_ATTR_C45_ID(22);
+DEVICE_ATTR_C45_ID(23);
+DEVICE_ATTR_C45_ID(24);
+DEVICE_ATTR_C45_ID(25);
+DEVICE_ATTR_C45_ID(26);
+DEVICE_ATTR_C45_ID(27);
+DEVICE_ATTR_C45_ID(28);
+DEVICE_ATTR_C45_ID(29);
+DEVICE_ATTR_C45_ID(30);
+DEVICE_ATTR_C45_ID(31);
+
+static struct attribute *phy_c45_id_attrs[] = {
+	&dev_attr_phy_c45_id0.attr.attr,
+	&dev_attr_phy_c45_id1.attr.attr,
+	&dev_attr_phy_c45_id2.attr.attr,
+	&dev_attr_phy_c45_id3.attr.attr,
+	&dev_attr_phy_c45_id4.attr.attr,
+	&dev_attr_phy_c45_id5.attr.attr,
+	&dev_attr_phy_c45_id6.attr.attr,
+	&dev_attr_phy_c45_id7.attr.attr,
+	&dev_attr_phy_c45_id8.attr.attr,
+	&dev_attr_phy_c45_id9.attr.attr,
+	&dev_attr_phy_c45_id10.attr.attr,
+	&dev_attr_phy_c45_id11.attr.attr,
+	&dev_attr_phy_c45_id12.attr.attr,
+	&dev_attr_phy_c45_id13.attr.attr,
+	&dev_attr_phy_c45_id14.attr.attr,
+	&dev_attr_phy_c45_id15.attr.attr,
+	&dev_attr_phy_c45_id16.attr.attr,
+	&dev_attr_phy_c45_id17.attr.attr,
+	&dev_attr_phy_c45_id18.attr.attr,
+	&dev_attr_phy_c45_id19.attr.attr,
+	&dev_attr_phy_c45_id20.attr.attr,
+	&dev_attr_phy_c45_id21.attr.attr,
+	&dev_attr_phy_c45_id22.attr.attr,
+	&dev_attr_phy_c45_id23.attr.attr,
+	&dev_attr_phy_c45_id24.attr.attr,
+	&dev_attr_phy_c45_id25.attr.attr,
+	&dev_attr_phy_c45_id26.attr.attr,
+	&dev_attr_phy_c45_id27.attr.attr,
+	&dev_attr_phy_c45_id28.attr.attr,
+	&dev_attr_phy_c45_id29.attr.attr,
+	&dev_attr_phy_c45_id30.attr.attr,
+	&dev_attr_phy_c45_id31.attr.attr,
+	NULL,
+};
+
+static const struct attribute_group phy_dev_c45_ids_group = {
+	.name = "c45_ids",
+	.attrs = phy_c45_id_attrs
+};
+
+static const struct attribute_group *phy_dev_groups[] = {
+	&phy_dev_group,
+	&phy_dev_c45_ids_group,
+	NULL,
+};
 
 static const struct device_type mdio_bus_phy_type = {
 	.name = "PHY",
-- 
2.34.1


