Return-Path: <netdev+bounces-10405-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A02D72E5C0
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:30:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 172F91C20CA4
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F732A6F8;
	Tue, 13 Jun 2023 14:30:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2172B15AC1
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:30:40 +0000 (UTC)
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7863F199;
	Tue, 13 Jun 2023 07:30:39 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b01d3bb571so30618285ad.2;
        Tue, 13 Jun 2023 07:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686666639; x=1689258639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=x06uIS9mUjSbGg95vCJuM5yUdjryjDtAV88RHciY3lM=;
        b=KHeSGBuGpQwF1yUpFT4Kjc2BT8mU+sS2Jwmyi01cccNH1ojQck8rxQILpVxLP5VPw3
         icIA1/bBhK0buIBoa3ZXM4LA9JZ27SRwKF1QJy7wPsa82ALBiZZpH/SryVymS6zQOBsB
         m2ErL1V4bu0PK8AipFXeVblxIZB7abJJsFt94IEDsNeSfWhUF0i5xFGhq6SYj+jHDLwe
         akgRgFzbRv7On2c5TUOvNzeV1vOKwHfVSPGy+i1eKJjdkoj5qtTd1Tw/GrD8R+1CtxEY
         3aUXENPZIAvDrPFWhKEagd3Cl5IBtHuBv35CRHDojxxR0ZasISWSAel1M0+n6Ee8SleD
         J4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686666639; x=1689258639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x06uIS9mUjSbGg95vCJuM5yUdjryjDtAV88RHciY3lM=;
        b=Xhr9xuJ3nco+SWur/U+yeTISTVBpmthK95i70/V3tUUL7kjY4581PrU4V2T6QUnZof
         ULVq+ZsNh2CNKuAtO+DcEojJRiD4yInJkokzCtagu3v+7XNxbV2DCUIQSB6JvkmFPe1t
         SaL2RqFn4+LnHuoTn5SGvX2d9DPIduXMb+Q5fyK1APIOKJ6TjTYQU4A/iDHbi11MDTdf
         2V01Pk520EtGwYJwZuhf3n3eAlyz7bJtowzxSwimVffLvsjL9o8zzWmidCrqqqDBw74Q
         ygwgMFOUXOz5hsTfnG53MudmbP8bNRNMQujAhcjSU5YT1aLTdAkrgufxwEYFEiSqsJKz
         Phfg==
X-Gm-Message-State: AC+VfDw9K4FmByJJwjT2Es259Zj6YKzelqbfcyKfgwmuzLG7k0k4WHI9
	WZ81fSL+YH5Z75LNuytHOp4=
X-Google-Smtp-Source: ACHHUZ7R38/EA7491ewajF4B4CQzzPDW0mbr9LBfvQCCyUMoVWy5XTFKId4vj2EN/Q0WhirKC+MoPA==
X-Received: by 2002:a17:903:32c2:b0:1b0:28a7:16d1 with SMTP id i2-20020a17090332c200b001b028a716d1mr10317436plr.10.1686666638722;
        Tue, 13 Jun 2023 07:30:38 -0700 (PDT)
Received: from localhost.localdomain ([103.116.245.58])
        by smtp.gmail.com with ESMTPSA id o4-20020a170902bcc400b001ac897026cesm10324376pls.102.2023.06.13.07.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 07:30:38 -0700 (PDT)
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
Subject: [PATCH V2] net: phy: Add sysfs attribute for PHY c45 identifiers.
Date: Tue, 13 Jun 2023 22:30:25 +0800
Message-Id: <20230613143025.111844-1-zhaojh329@gmail.com>
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
---
V1 -> V2: putting all 32 values in a subdirectory, one file per MMD

 .../ABI/testing/sysfs-class-net-phydev        |  10 ++
 drivers/net/phy/phy_device.c                  | 103 +++++++++++++++++-
 2 files changed, 112 insertions(+), 1 deletion(-)

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
index 17d0d0555a79..c09282818d45 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -602,7 +602,108 @@ static struct attribute *phy_dev_attrs[] = {
 	&dev_attr_phy_dev_flags.attr,
 	NULL,
 };
-ATTRIBUTE_GROUPS(phy_dev);
+
+static const struct attribute_group phy_dev_group = {
+	.attrs = phy_dev_attrs
+};
+
+#define DEVICE_ATTR_C45_ID(i) \
+static ssize_t \
+phy_c45_id##i##_show(struct device *dev, \
+	struct device_attribute *attr, char *buf) \
+{ \
+	struct phy_device *phydev = to_phy_device(dev); \
+\
+	if (!phydev->is_c45) \
+		return 0; \
+\
+	return sprintf(buf, "0x%.8lx\n", \
+		(unsigned long)phydev->c45_ids.device_ids[i]); \
+} \
+static struct device_attribute dev_attr_phy_c45_id##i = { \
+	.attr	= { .name = __stringify(mmd##i), .mode = 0444 }, \
+	.show	= phy_c45_id##i##_show \
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
+	&dev_attr_phy_c45_id0.attr,
+	&dev_attr_phy_c45_id1.attr,
+	&dev_attr_phy_c45_id2.attr,
+	&dev_attr_phy_c45_id3.attr,
+	&dev_attr_phy_c45_id4.attr,
+	&dev_attr_phy_c45_id5.attr,
+	&dev_attr_phy_c45_id6.attr,
+	&dev_attr_phy_c45_id7.attr,
+	&dev_attr_phy_c45_id8.attr,
+	&dev_attr_phy_c45_id9.attr,
+	&dev_attr_phy_c45_id10.attr,
+	&dev_attr_phy_c45_id11.attr,
+	&dev_attr_phy_c45_id12.attr,
+	&dev_attr_phy_c45_id13.attr,
+	&dev_attr_phy_c45_id14.attr,
+	&dev_attr_phy_c45_id15.attr,
+	&dev_attr_phy_c45_id16.attr,
+	&dev_attr_phy_c45_id17.attr,
+	&dev_attr_phy_c45_id18.attr,
+	&dev_attr_phy_c45_id19.attr,
+	&dev_attr_phy_c45_id20.attr,
+	&dev_attr_phy_c45_id21.attr,
+	&dev_attr_phy_c45_id22.attr,
+	&dev_attr_phy_c45_id23.attr,
+	&dev_attr_phy_c45_id24.attr,
+	&dev_attr_phy_c45_id25.attr,
+	&dev_attr_phy_c45_id26.attr,
+	&dev_attr_phy_c45_id27.attr,
+	&dev_attr_phy_c45_id28.attr,
+	&dev_attr_phy_c45_id29.attr,
+	&dev_attr_phy_c45_id30.attr,
+	&dev_attr_phy_c45_id31.attr,
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


