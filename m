Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24E225C231
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 16:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgICOHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 10:07:51 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:52233 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728941AbgICOGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 10:06:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6A41158057C;
        Thu,  3 Sep 2020 09:42:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 03 Sep 2020 09:42:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=RFAhY7dzcPg3TZeh0yPUry3n5Ji/x3Rc3IqfQAg6s
        qw=; b=pfs0J4khM0uks0f/hoRJQH8ukRAcxrKNCaE+Vpf5ETPrOu8k6Qidi4tkH
        R7ugphOU7OvMIZ3rAyW9BJVunoLMRNWGB6oauni72jWybbM2dYITWTooKCjxsn3j
        eNpbAzRAVzykMSd4WVvfML84qRqASfY243MWuFVko3GoWuYTnZX0fE2S0miZ3ya2
        XmlZA8XpmmIhpuGJlIFvYpcLsIH1FSx9xSbe5QSyrdBvCcPEQ1OpaDQt+x6fsFkO
        ZWF+4cRapxsDa3fnQw7H9UZKkAHSO6hK30g6Nzt1ff7bAQd5fhhNzHKf85NzCjFW
        84SwNTdcglvvM7/0+fNl4go/+7n0w==
X-ME-Sender: <xms:yfJQX5vG-O9IkoG1P26tLD_Rt6Fj4nLe9hVBXX5P-dZlA-3RJDHyBw>
    <xme:yfJQXyfuNXht5j3TMlAx2T0vlgE_5JMq0YjjtZTqwi9jPKfVTPrp0fS6zJYlqYdr0
    PAoHApkHV9dUUc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeguddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfgggtgfesthekredtredtjeenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepkeehleeffefftdfhuefhueeiledtgfffjeffvddutdegfeevhfelffetueej
    tefhnecukfhppeekgedrvddvledrfeeirdejudenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:yfJQX8zIQfimF8CX1GDSqixXxXbCqrsTAl3XKgLqlHu7CUtdn7XEGA>
    <xmx:yfJQXwMzXRfP7eQoGQjDSC-1dB2e0cBZtmnvPEmkzPe3aOyaJ_fmoA>
    <xmx:yfJQX58ui4uPWqeMtb6EIsnMeDW0dbbRdJJsHTb-5zcZKiyQwRn-nQ>
    <xmx:yfJQXyNQo20SvGJlOzf4VDNWXYxAc4Zc1eFCAvehCBB8fvREewr_Ig>
Received: from shredder.mtl.com (igld-84-229-36-71.inter.net.il [84.229.36.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id B923A328005A;
        Thu,  3 Sep 2020 09:42:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, petrm@nvidia.com, vadimp@nvidia.com,
        andrew@lunn.ch, mlxsw@nvidia.com, Amit Cohen <amitc@mellanox.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/3] mlxsw: core_hwmon: Extend hwmon interface with critical and emergency alarms
Date:   Thu,  3 Sep 2020 16:41:46 +0300
Message-Id: <20200903134146.2166437-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200903134146.2166437-1-idosch@idosch.org>
References: <20200903134146.2166437-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add new attributes to hwmon object for exposing critical and emergency
alarms.

In case that current temperature is higher than emergency threshold,
EMERGENCY alarm will be reported in sensors utility:

$ sensors
...
front panel 025:  +55.0°C  (crit = +35.0°C, emerg = +40.0°C) ALARM(EMERGENCY)

In case that current temperature is higher than critical threshold,
CRIT alarm will be reported in sensors utility:

$ sensors
...
front panel 025:  +54.0°C  (crit = +35.0°C, emerg = +80.0°C) ALARM(CRIT)

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Acked-by: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  | 71 ++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index f1b0c176eaeb..8232bc0f5c03 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -17,7 +17,7 @@
 #define MLXSW_HWMON_GEARBOXES_MAX_COUNT 32
 
 #define MLXSW_HWMON_ATTR_PER_SENSOR 3
-#define MLXSW_HWMON_ATTR_PER_MODULE 5
+#define MLXSW_HWMON_ATTR_PER_MODULE 7
 #define MLXSW_HWMON_ATTR_PER_GEARBOX 4
 
 #define MLXSW_HWMON_ATTR_COUNT (MLXSW_HWMON_SENSORS_MAX_COUNT * MLXSW_HWMON_ATTR_PER_SENSOR + \
@@ -388,6 +388,53 @@ mlxsw_hwmon_gbox_temp_label_show(struct device *dev,
 	return sprintf(buf, "gearbox %03u\n", index);
 }
 
+static ssize_t mlxsw_hwmon_temp_critical_alarm_show(struct device *dev,
+						    struct device_attribute *attr,
+						    char *buf)
+{
+	int err, temp, emergency_temp, critic_temp;
+
+	err = mlxsw_hwmon_module_temp_get(dev, attr, &temp);
+	if (err)
+		return err;
+
+	if (temp <= 0)
+		return sprintf(buf, "%d\n", false);
+
+	err = mlxsw_hwmon_module_temp_emergency_get(dev, attr, &emergency_temp);
+	if (err)
+		return err;
+
+	if (temp >= emergency_temp)
+		return sprintf(buf, "%d\n", false);
+
+	err = mlxsw_hwmon_module_temp_critical_get(dev, attr, &critic_temp);
+	if (err)
+		return err;
+
+	return sprintf(buf, "%d\n", temp >= critic_temp);
+}
+
+static ssize_t mlxsw_hwmon_temp_emergency_alarm_show(struct device *dev,
+						     struct device_attribute *attr,
+						     char *buf)
+{
+	int err, temp, emergency_temp;
+
+	err = mlxsw_hwmon_module_temp_get(dev, attr, &temp);
+	if (err)
+		return err;
+
+	if (temp <= 0)
+		return sprintf(buf, "%d\n", false);
+
+	err = mlxsw_hwmon_module_temp_emergency_get(dev, attr, &emergency_temp);
+	if (err)
+		return err;
+
+	return sprintf(buf, "%d\n", temp >= emergency_temp);
+}
+
 enum mlxsw_hwmon_attr_type {
 	MLXSW_HWMON_ATTR_TYPE_TEMP,
 	MLXSW_HWMON_ATTR_TYPE_TEMP_MAX,
@@ -401,6 +448,8 @@ enum mlxsw_hwmon_attr_type {
 	MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE_EMERG,
 	MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE_LABEL,
 	MLXSW_HWMON_ATTR_TYPE_TEMP_GBOX_LABEL,
+	MLXSW_HWMON_ATTR_TYPE_TEMP_CRIT_ALARM,
+	MLXSW_HWMON_ATTR_TYPE_TEMP_EMERGENCY_ALARM,
 };
 
 static void mlxsw_hwmon_attr_add(struct mlxsw_hwmon *mlxsw_hwmon,
@@ -491,6 +540,20 @@ static void mlxsw_hwmon_attr_add(struct mlxsw_hwmon *mlxsw_hwmon,
 		snprintf(mlxsw_hwmon_attr->name, sizeof(mlxsw_hwmon_attr->name),
 			 "temp%u_label", num + 1);
 		break;
+	case MLXSW_HWMON_ATTR_TYPE_TEMP_CRIT_ALARM:
+		mlxsw_hwmon_attr->dev_attr.show =
+			mlxsw_hwmon_temp_critical_alarm_show;
+		mlxsw_hwmon_attr->dev_attr.attr.mode = 0444;
+		snprintf(mlxsw_hwmon_attr->name, sizeof(mlxsw_hwmon_attr->name),
+			 "temp%u_crit_alarm", num + 1);
+		break;
+	case MLXSW_HWMON_ATTR_TYPE_TEMP_EMERGENCY_ALARM:
+		mlxsw_hwmon_attr->dev_attr.show =
+			mlxsw_hwmon_temp_emergency_alarm_show;
+		mlxsw_hwmon_attr->dev_attr.attr.mode = 0444;
+		snprintf(mlxsw_hwmon_attr->name, sizeof(mlxsw_hwmon_attr->name),
+			 "temp%u_emergency_alarm", num + 1);
+		break;
 	default:
 		WARN_ON(1);
 	}
@@ -613,6 +676,12 @@ static int mlxsw_hwmon_module_init(struct mlxsw_hwmon *mlxsw_hwmon)
 		mlxsw_hwmon_attr_add(mlxsw_hwmon,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE_LABEL,
 				     i, i);
+		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+				     MLXSW_HWMON_ATTR_TYPE_TEMP_CRIT_ALARM,
+				     i, i);
+		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+				     MLXSW_HWMON_ATTR_TYPE_TEMP_EMERGENCY_ALARM,
+				     i, i);
 	}
 
 	return 0;
-- 
2.26.2

