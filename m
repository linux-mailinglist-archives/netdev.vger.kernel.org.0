Return-Path: <netdev+bounces-11473-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C76107333CF
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:40:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BFC62817D9
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75C363D62;
	Fri, 16 Jun 2023 14:40:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A0333FD
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 14:40:38 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5159F3598;
	Fri, 16 Jun 2023 07:40:30 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-6668208bd4eso841366b3a.0;
        Fri, 16 Jun 2023 07:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686926430; x=1689518430;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ECePMHFylJkWTWaDbGM6MAlprGNj5IxPPrQMrQr2/2Q=;
        b=g0O3syPJNPOzCmtaE4H+GYVYjQb4ElntfOK5rBDm3jwR3xnsZq/bCP5/+8hr3UcpEL
         Tkewt82a5az5UvsYyCgBZQLq8ixPVLchRuE2fwPchZeU3RGCQhZZVAaGhrm3lUcvFNV1
         pxDbNMRI9B5Qo8U6jTIrjRESw26heKO0xhqe+PCgStR0b6xq2x0LpZvp7shPi94LC7iM
         MnMByUeP7+lUBRxMKrBHUFw1joq4QIk+c1UA1TFcRxET1tliIPt66mkspixgaPa1k3r8
         MD/cb7tFWLHCVRPGGPr2/IATuPnKo39OMEMD3HErDlsn1xU0diuZ4zQnc4o+4aoOlzw8
         k3HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686926430; x=1689518430;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ECePMHFylJkWTWaDbGM6MAlprGNj5IxPPrQMrQr2/2Q=;
        b=B2zSeYAzzYxgbJ3gNcDPL7i4gLT4kudfVqNaDhegidDD7aOREXsePw5OlIZL0Iy5T3
         ZVIrN6dV2m6PLSCPct1Qz/BvOkH8wTu295tF+ULGHMvM+FPZL8cTbxqsChRBqnt4Z8ts
         F1khjc1RlCBZvI9ch4MvPpdxuUIkgKqGeh9k3u/DGM2alk3YBgj2n4Nyz7zswB0yNvcm
         J5orcBMUT/7WZ1n2ZUoG0OG5sR9wzrnCo/WoJSUfubtRKUdzwii9X+AJ2Qi8xOK/Ojt6
         WaWnJy5YBRBCTxFMl3MeFiNmisrEkS+zn9kbETdypuRL9bLfoz3eEDrmOvxfZNxp/lK4
         RqTg==
X-Gm-Message-State: AC+VfDwn/DW7i24EjwzE6tOkqaYyWfWF3sPgVgeweID4UEBOAPvKBHVU
	fP1/eFGVzBXPZ9KV4J1oLjc=
X-Google-Smtp-Source: ACHHUZ40CGQUnIqfgSCwbPCUZIyqRlk0987ljQYEBf+YAFQAJ51LkdVNYPmhgAL7NnXEogo7N2iy7Q==
X-Received: by 2002:a05:6a00:240f:b0:64b:256:204c with SMTP id z15-20020a056a00240f00b0064b0256204cmr2523397pfh.20.1686926429649;
        Fri, 16 Jun 2023 07:40:29 -0700 (PDT)
Received: from localhost.localdomain ([103.116.245.58])
        by smtp.gmail.com with ESMTPSA id v19-20020a62a513000000b0065da94fe921sm13430528pfm.50.2023.06.16.07.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 07:40:29 -0700 (PDT)
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
Subject: [PATCH V5] net: phy: Add sysfs attribute for PHY c45 identifiers.
Date: Fri, 16 Jun 2023 22:40:17 +0800
Message-Id: <20230616144017.12483-1-zhaojh329@gmail.com>
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
this adds a c45_ids sysfs attribute group contains mmd id
attributes from mmd0 to mmd31 to MDIO devices. Note that only
mmd with valid value will exist. This attribute group can be
useful when debugging problems related to phy drivers.

Likes this:
/sys/bus/mdio_bus/devices/mdio-bus:05/c45_ids/mmd1
/sys/bus/mdio_bus/devices/mdio-bus:05/c45_ids/mmd2
...
/sys/bus/mdio_bus/devices/mdio-bus:05/c45_ids/mmd31

Signed-off-by: Jianhui Zhao <zhaojh329@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Russell King <linux@armlinux.org.uk>
---
V4 -> V5: Remove cast operation and use macro to convert attribute to a phy_c45_devid_attribute.
V3 -> V4: Only mmd with valid value will exist.
V2 -> V3: Use the most efficient implementation.
V1 -> V2: putting all 32 values in a subdirectory, one file per MMD

 .../ABI/testing/sysfs-class-net-phydev        |  10 ++
 drivers/net/phy/phy_device.c                  | 124 +++++++++++++++++-
 2 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-class-net-phydev b/Documentation/ABI/testing/sysfs-class-net-phydev
index ac722dd5e694..58a0a150229d 100644
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
+		This attribute group c45_ids contains mmd id attributes from mmd0 to mmd31
+		as reported by the device during bus enumeration, encoded in hexadecimal.
+		Note that only mmd with valid value will exist. This ID is used to match
+		the device with the appropriate driver.
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 17d0d0555a79..39f663c2ad1a 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -602,7 +602,129 @@ static struct attribute *phy_dev_attrs[] = {
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
+	container_of(ptr, struct phy_c45_devid_attribute, attr.attr)
+
+static ssize_t phy_c45_id_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct phy_c45_devid_attribute *devattr = to_phy_c45_devid_attr(&attr->attr);
+	struct phy_device *phydev = to_phy_device(dev);
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
+static umode_t phy_dev_c45_visible(struct kobject *kobj, struct attribute *attr, int foo)
+{
+	struct phy_c45_devid_attribute *devattr = to_phy_c45_devid_attr(attr);
+	struct phy_device *phydev = to_phy_device(kobj_to_dev(kobj));
+
+	if (!phydev->is_c45 || phydev->c45_ids.device_ids[devattr->index] == 0xffffffff)
+		return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute_group phy_dev_c45_ids_group = {
+	.name = "c45_ids",
+	.attrs = phy_c45_id_attrs,
+	.is_visible = phy_dev_c45_visible
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


