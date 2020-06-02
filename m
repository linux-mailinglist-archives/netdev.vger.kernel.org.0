Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBE41EBA6D
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 13:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgFBLbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 07:31:55 -0400
Received: from mail-eopbgr20080.outbound.protection.outlook.com ([40.107.2.80]:10724
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725900AbgFBLbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 07:31:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixwUQuaYyQ9Wl9GeixGy4gm4WtM3W509f7lx/SV1V4JNkGYD3yHsF+rhUtVG6LYtJAIv50vm0ySNYHGpw8GSFHKLjsYOCa/7PNKkJS06S69TndKgc3gPs3pZ/f3FRsVXTwfX59F9NJIIpS7u1+KYFQyGKF1Ew33j/LtpcL2tC481QMHtSwWCA2AYDRRPMjDzQ+9+9VvIJDmPymXxKfAPiDDOu4xdKu3Nw/zyYOTUjvOVgY18CJDP78Y3H7ZoI2kKh80YqF1EBeJj7UIiywo9moafZoLgOEUbcaPXw2HamABmPfxns7Tq3eqSvliv7mo5+AAa0YwdVjo6yMQH83XI+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DW1TxQKxoK4ca0LxvCGMNtZK9qzhybCN9p+LSQRewc=;
 b=CoKytHWKY5PDS0mljSOHrARxOwPJGp3aIeKu1zwHMjc8vulPFRsn5pulqxbPDe7d4G8cDRHmXUSEIkPAFkwr/aoZ+avAfTKZ2KH7p4uDHgHfT7+rR2wAEvdzROscJyH2qYqCD/JxscHexILQN+Gzs+wWZmTyNDI44aLSnWHpU7dZ50Ly5idpwe8taKqMywY7lgixncb9s0yBSucWaOc9jyqkgg6ETAu3HN1U189Vi5rKi9GWJGkaOJ37ZiL3Iz8L1BUlrvoPsWFTWjOOWpl+9kAwjaqZw2ObOoEFpc1ePeTBle3LGTd1wWbcbkSjG8ABrolQ1B0qsefwwtLhbqkZvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DW1TxQKxoK4ca0LxvCGMNtZK9qzhybCN9p+LSQRewc=;
 b=dScWAwVEN0RMHa9zudX7dKkfph0BkfNF9CcOpJz3ibu7zerYO2hLvdjO7Zu6uuSMyQnNuyB5cxRg9JKosXGGm+XCuwrSqhHKyp6F3KYc13Wq2UAHMXWVL8A69wifqoMiWjYHRnPc132gRH6TpS6klepCuzYTyJYS0Vl/0iDC/Og=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB4129.eurprd05.prod.outlook.com (2603:10a6:208:64::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Tue, 2 Jun
 2020 11:31:48 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182%6]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 11:31:48 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, michael.chan@broadcom.com, kuba@kernel.org,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [RFC PATCH net-next 2/8] devlink: Move switch_port attribute of devlink_port_attrs to devlink_port
Date:   Tue,  2 Jun 2020 14:31:13 +0300
Message-Id: <20200602113119.36665-3-danieller@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200602113119.36665-1-danieller@mellanox.com>
References: <20200602113119.36665-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21 via Frontend Transport; Tue, 2 Jun 2020 11:31:46 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 50cab3e2-7393-4714-3359-08d806e88908
X-MS-TrafficTypeDiagnostic: AM0PR05MB4129:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB4129CE9378E54B1B532C67FAD58B0@AM0PR05MB4129.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FrSQh91qDZLXhv7LrmIN3TOHgXvokf7vm5INjNfpMlhyt9cyd0uu8wsLl52yp80d2OFTOVtWscrwx83G9C8eQl7EHpbaeGwbh/Rqj6V9krdOkmb3+s7Kw3I2jUpYn38f4E+5mF1e6iksfxdO9JdUWANRuOm1sJRmWhXfyoVspa2J+Msa6aAWk6rNnmyf1TQdfWIMcpwo/l7+thJEOX89wYQddYj+tlye8qZpZBfzM7/zMnK7qQv01E73GTTAlvlAwA+excoeIRw2hDrco7dqIrKzpaIdl0tQonimNOm0LzH8O+x8KgOYv4D272t8KhZ57IFnEtepOEQNnJUrGtNu6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(4326008)(7416002)(6506007)(478600001)(6916009)(52116002)(6486002)(2906002)(36756003)(5660300002)(316002)(6666004)(1076003)(26005)(86362001)(83380400001)(66946007)(66556008)(66476007)(16526019)(186003)(107886003)(8936002)(6512007)(2616005)(956004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ywht0PA696wPgfREqEEjFrBIQpGsCzl0Iby/aaKxZBUecu4IH5I5Z63FCHuiQKszCuHtY4lBgwrOR6537NKMeVclqNKVR9Oh6jfQSJauuYAs9skyeR3RfQOUrCkFKNdkPpnYkxBbSjCCh/p7z2R14laBG4yWVi06fDNvqoXSU1T9tNiF0T+SfG2Z2QLxf2NEn39y8GwaLOB2sbbQsnRf59a7Nvj7vxPIfIW3zDUBpCAbUpA1q4KzB/pj0kwzVJ+BfQqgFXMtyPHvUS+uHU88sr5J+axoPFLP9Icv03ne+Nf8fnzeWZ7ZFM/X9fXLdEuZiy47FSabkUP0jDjymRoMsjwmZeC14waegt27wNonUOVvNi45gYeHqdqxiOZnBgsk0il2Kfwm6VopozQywD2Kc3clX7kLwqy0GOxRkGpwWUBf0er5qUxK1R+eQj7AfluAyBWfXHkoDIZQUFpuVTMt551lTcfO1M0gvj/QbiNXmn8/SFvwCkApEUF6v5qubipN
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50cab3e2-7393-4714-3359-08d806e88908
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 11:31:48.0396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0PlDsy0afYzsnrSsCO0XmFhCfk/QKHfeTL6y5x05KEHwhVvtivxicHRXHWy43mNAVXXMj+coFY6fPSPZm7i/Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The struct devlink_port_attrs holds the attributes of devlink_port.

Similarly to the previous patch, 'switch_port' attribute is another
exception.

Move 'switch_port' to be devlink_port's field.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h | 6 +++---
 net/core/devlink.c    | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 3e4efd51d5c5..4d840997690a 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -65,8 +65,7 @@ struct devlink_port_pci_vf_attrs {
 };
 
 struct devlink_port_attrs {
-	u8 split:1,
-	   switch_port:1;
+	u8 split:1;
 	enum devlink_port_flavour flavour;
 	struct netdev_phys_item_id switch_id;
 	union {
@@ -89,7 +88,8 @@ struct devlink_port {
 	enum devlink_port_type desired_type;
 	void *type_dev;
 	struct devlink_port_attrs attrs;
-	u8 attrs_set:1;
+	u8 attrs_set:1,
+	   switch_port:1;
 	struct delayed_work type_warn_dw;
 };
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e5e594d15d3e..c4507fd9fc11 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7388,13 +7388,13 @@ static int __devlink_port_attrs_set(struct devlink_port *devlink_port,
 	devlink_port->attrs_set = true;
 	attrs->flavour = flavour;
 	if (switch_id) {
-		attrs->switch_port = true;
+		devlink_port->switch_port = true;
 		if (WARN_ON(switch_id_len > MAX_PHYS_ITEM_ID_LEN))
 			switch_id_len = MAX_PHYS_ITEM_ID_LEN;
 		memcpy(attrs->switch_id.id, switch_id, switch_id_len);
 		attrs->switch_id.id_len = switch_id_len;
 	} else {
-		attrs->switch_port = false;
+		devlink_port->switch_port = false;
 	}
 	return 0;
 }
@@ -9328,7 +9328,7 @@ int devlink_compat_switch_id_get(struct net_device *dev,
 	 * any devlink lock as only permanent values are accessed.
 	 */
 	devlink_port = netdev_to_devlink_port(dev);
-	if (!devlink_port || !devlink_port->attrs.switch_port)
+	if (!devlink_port || !devlink_port->switch_port)
 		return -EOPNOTSUPP;
 
 	memcpy(ppid, &devlink_port->attrs.switch_id, sizeof(*ppid));
-- 
2.20.1

