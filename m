Return-Path: <netdev+bounces-1121-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DAD56FC424
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FC801C20B56
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17FADDDD8;
	Tue,  9 May 2023 10:44:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0456B7C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:44:35 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2023.outbound.protection.outlook.com [40.92.53.23])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746E05B82;
	Tue,  9 May 2023 03:44:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwI/+lCObVRa2t4u+xtzmcvQyOcgiCKEfNtmAPXecfZEaszTgyyduErQe+fCGVNYBL/JkqBA0FLC3ZbiWZtFyLrIj2d47+ImxF9qi1H+U68OFUTZt2nJvP7BjCab8oWAwmZexxmGCPjeNOhtYLy7kOx2+iwkUsN+DJVJP+kv6Fp9cIPudVSkCZ1P4WkqM5BlOKzFyYyDGbbJ0lzSNx9aDr4Yetba/1P8OXd6FIn66MndjQ85Z3fHbregGOPjgioM6cxO8PUjuiqOMDj9uRg6sXwreDWYE8Pd/EkejJdm10CV1Q2wttxQ/YThly+24c2YJ/GAatDGo3lPDnEll4bXmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZzvVmXnT1+11Bbk64z1aTfRv8WOX0X/ABgp4v2cbPqs=;
 b=KPte4lLsAPlDN48VI86iAXA0HrDPcO95MZWppzZVJmrdiCs9kRaYd4YyHlvJo6iIaVTZzleNz/yMLL6TrhXnFqG6SPwG2tGeD+WyHk/iESZKTNvdHzsuaJ9IWWqzUUARXHjzXN4od3e26HXhda2tI01SVYMpjiJhOmc5VMjk8GMuoovxKLGxnHzFvh1suL80Cmtq+GW1tD3xLh2kXSiEKiI0rDyQ8jZev++4bgkO9PqmNwPqYZyDMgLMjqZoOx6bhClo/iQtPUtm2rM9w4q2bY++fpITP/t24PKZoHAeLTIACNDhrNi5UE0YXXjqZ22ML6koJfd/RcuiuuIV9UXMSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZzvVmXnT1+11Bbk64z1aTfRv8WOX0X/ABgp4v2cbPqs=;
 b=qn+KnsBJ2AK6HmieLPTwst+Co2Gc1xQuAELpbZ6j3dhuE4X8Fe3KezU3tq0hzlXMcGUGl8b6Daa797P1DFp4Yxj5V5+Z5vejsjaks9XnMWnHIFsOBRgb6LgYNuVcARKnek6AmEKGSoeb9fyl68C1L3cg9C0PDe7FWqHeITOBflh0fR6QDcZjcFM3IJwnKCWOkXDAK37lgeb4cyhGw1gPUYFDafiyWxF8tEKNhAtc1vRx4NMq9NSyJ1FBz3fZNgqL30Khpk+OhWWyvWZwSw2EfaOC6ORZ9P9em6XpuD8a95+Vgbto4Gt19JocPl2+HeBSnLO71y+tUirDLF+24EBtiw==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by TYZPR01MB3791.apcprd01.prod.exchangelabs.com
 (2603:1096:400:3a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 10:44:29 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::1ff1:2f4e:bc0:1ba9]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::1ff1:2f4e:bc0:1ba9%3]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 10:44:29 +0000
From: Yan Wang <rk.code@outlook.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux@armlinux.org.uk
Cc: Yan Wang <rk.code@outlook.com>
Subject: [PATCH v1] net: mdiobus: Add a function to deassert reset
Date: Tue,  9 May 2023 18:44:02 +0800
Message-ID:
 <KL1PR01MB5448631F2D6F71021602117FE6769@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-TMN: [QkEH8rhL8Hhmun9bxRi7I3tLjPMxwdqwWbVUHW5mXk0=]
X-ClientProxiedBy: SG2PR04CA0184.apcprd04.prod.outlook.com
 (2603:1096:4:14::22) To KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID: <20230509104402.13498-1-rk.code@outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|TYZPR01MB3791:EE_
X-MS-Office365-Filtering-Correlation-Id: 53966928-b058-4510-228e-08db507a5da5
X-MS-Exchange-SLBlob-MailProps:
	wk1EIbWONa0Oqax1UZBelAFl4e8UuTAlrWAh4HybAGN3wBk78lyzTya/GXmt+H4k606e7ka+G+mt+iURW9uDPc34ojFllBkdU0v3KvvUo2Phslh0IEKm2ZlcoX5KbJtB3uars/MkmLXnYb/J0aj+r3JAszSM8RX4RX7iwTuzFRplgZ5ia82rYDx/ofGSWHay9K378ggvVgBgIhvTQC7xjHFq1rPsNgR0LV4QLkoAEtKc1K/XSxXXpUT+3Mea2DL40iK5UIhCOFuEn6y/bYhM5ljHss1ouTfwRRAXWVh6bjJH894tTFabqjgGwU2ro4kxThzE/SCtvriPjE0/LWx5w+QFyN/i4mgoFSmj3ireiBc12EEeSa+GQ2F04cysZFZrKvXM1dB1djzhvQshC2WNwyMgjqufZSzvORpn3D4N6k6cDCFI+nWfYAMWljQweCzB9F5Y2V9vJ/CfpuLHWl4dqRG+UPxzgnFczONLgpoOsHMPdeHPljgcinLZgXhya1dcUK2uSj4w/NHMWz1naP7NvzC5DrsHtMvMkrnJckWZBDTGPs5BKr2vqdokkVfvuVjpYmUcwMEs9y4Xc5FB8VgqpI2oqeCtmxZ1piqDhlJ6OMah+8FvNIAxIRLclbtJCKnajOStgzTiHYcOkFK4ruDu1JICyt0oXXsKvOxOq+XBwZAeNZK8MqIiFeygm83m+InK6x2LRv8zQis1geYo7mfCPPU1NfckpDZPWjqV7mrygS4sk++PXc/Fug==
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZBQ6ecB3I636zxSXErnQSBcQObocjI2gp1fIIizky/Fnf8Njl1NctxH+W4i2weKzLN2khGDL22AM2BxA5RDotTTOrvoXFGieBRtzGA9bIinguaFusU2IGypD6uFfLiCxsehFJFUfKGyQC/bPJbt0zEjqZLc4fLQh5zGc3VHtu6QPvXBxDmKnbqOFAIFwm9MQvPisDh2H79J6vRB1oxEeTVEUBalcPEFI7yIbQSTt23uaK7Wull2ZCYcAGQv8YXwgg0exn6pmyG/52VwGS/4XbpFUAd3rucYE0knvC7girEYuvoxz6L0p+IlGlY1EcrGLi7Y4UQPZRi1SIHbKZBvttw9iHLEqCGreKD9aDVECscxxGSEMOc1EQuq7frPHZaM5Dgiect4V/Fvefh7fedORMhZYSIg+R178htVa01hjoiu+7oIf/RtemHKOG9hHwjInuFEK3pNk0032sO/wwRbk/HSXYczsXfHeO1zrPKjO5wD+bRqAL4G7T0b/L1kH1EhLhAwW63Jxg0DNCZuIMisUejhrBUPMJP6EmMqLOR5H77bGMxQBrH8Zzyicwlhy6a3wr6CE98k/hPiSnohnrCT+Hq0eCX6np5XeDqZnWaUBtKDar7VWRRDw6clhgWRu+qKo
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+GzpecACs/CoD2n5dR71/zzbw2/EWc3G4JLArVhx4VMgsCqoT0WlcSQTGWsw?=
 =?us-ascii?Q?XcBYRNlyQm7C5aT/FBnFti4fIE8sPLpLTeLN9W8DsCc7WkqghqYp3pzk0fNf?=
 =?us-ascii?Q?+xKkMN2iSTtioKJSCY6NgI91WMpCSeTEFFx+SswvitCoFOt6NqMgRU1ArWqr?=
 =?us-ascii?Q?3kGC5Lv77d3iZjcY+K2VbRh52vToTBkcjRfZvshkzFe6YgD9Jz7FRtOZE5/u?=
 =?us-ascii?Q?qRbXoFrEm6soyzg3aEYv5Nm6sMq1CP03MVsqYiNJIh2X+xTnVVTzsHDNciB3?=
 =?us-ascii?Q?Mt3BKqq1PJbHtxv/fvb6UUXfvFF9CrvePj+QXbBq3565yiShV3DXvXyJ3fQo?=
 =?us-ascii?Q?pVF6WzDXM8ruGJR/MyoXKf3zJfjFo82VyBMRxWsrbSkIv6w4Ajx8pzA0whyY?=
 =?us-ascii?Q?C7T4+v+f4gnr+pY0n0FqO3Cwdu8NNtb2yndlBj1sNg6PIEC2PR4Ft0YJfINn?=
 =?us-ascii?Q?tOiFhaWj3vxSYVjgoSjwFtLD/CPghGqyqJ6WB0M5PqP7tqFwaxz43ck8AxUX?=
 =?us-ascii?Q?I5l4Am+wpZZZjGqTra45hFbWd59yvZf3T46Jnp9qQl3I9FoHYSOIbN3heXZP?=
 =?us-ascii?Q?tqSjnq5rPCCODk5Jf8ZYFSvDcg2hYbBJLDCKfoAMJvp5fIT71D2JUrCITOoJ?=
 =?us-ascii?Q?Wj8obi+s0TwJfhllupY2th+1bQN6Z2iEliutRZ/K8CNu9b/2YD7+nPl7zw8A?=
 =?us-ascii?Q?/nq/eVm28zCATsWB3RtlixpOOzMgv5qYocdBzfP6vV7BzXke207U7f1f6sNn?=
 =?us-ascii?Q?N+Oj/x9aare7G/cGJP4ezZrYaBWF9J87VCoOhzOssgaGqm0ulaKTPXfrhiPz?=
 =?us-ascii?Q?mczivkmWCICi4ZLhVGl4Omuk5BY9ZMe/wo5LteHpTJNULuSjdNmyLjjS2hMF?=
 =?us-ascii?Q?0yxZiezIX8vjDrEcsx2VwkXCyYkn+9NwFd738oa9y0a8IcrzfduYaiUATT75?=
 =?us-ascii?Q?ZQB8fJKbN0l2qOwG5b54W9e3ntfHBeOaSwcDFKgoOXz01rtG2h17xAinvplS?=
 =?us-ascii?Q?sa0A99skXBj35KodBKPYvbK1LW7KxtFoDqxzxYzAGrbsGKDSKZOz8Z2O8i6V?=
 =?us-ascii?Q?sR0OCEPy4voixEmYUABivhINbpezZYQZId1Gnn8iBh1Y0FCdbeKTZytNiZz4?=
 =?us-ascii?Q?N0cz8Cf/ZJbdgNqcEcgJwPnGelolBpnZQ9Ulb/vE7e9eilubFTQC8m4LKjdq?=
 =?us-ascii?Q?AxopUacgpBXN55YdIjlm3nWJJtGCC1LXy0XAMA=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53966928-b058-4510-228e-08db507a5da5
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 10:44:29.5690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR01MB3791
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Every PHY chip has a reset pin. the state isn't
sure of the PHY before scanning.

It is resetting, Scanning phy ID will fail, so
deassert reset for the chip ,normal operation.

Release the reset pin, because it needs to be
registered to the created phy device.

Signed-off-by: Yan Wang <rk.code@outlook.com>

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1183ef5e203e..8fdf1293f447 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -11,6 +11,7 @@
 #include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/pse-pd/pse.h>
+#include <linux/of_gpio.h>
 
 MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
 MODULE_LICENSE("GPL");
@@ -57,6 +58,32 @@ fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
 	return register_mii_timestamper(arg.np, arg.args[0]);
 }
 
+static void fwnode_mdiobus_deassert_reset_phy(struct fwnode_handle *fwnode)
+{
+	struct device_node *np;
+	int reset;
+	int rc;
+
+	np = to_of_node(fwnode);
+	if (!np)
+		return;
+	reset = of_get_named_gpio(np, "reset-gpios", 0);
+	if (gpio_is_valid(reset)) {
+		rc = gpio_request(reset, NULL);
+		if (rc < 0) {
+			pr_err("The currunt state of the reset pin is %s ",
+				rc == -EBUSY ? "busy" : "error");
+		} else {
+			gpio_direction_output(reset, 0);
+			usleep_range(1000, 2000);
+			gpio_direction_output(reset, 1);
+			/*Release the reset pin,it needs to be registeredwith the PHY.*/
+			gpio_free(reset);
+		}
+	}
+
+}
+
 int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 				       struct phy_device *phy,
 				       struct fwnode_handle *child, u32 addr)
@@ -129,6 +156,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 		goto clean_pse;
 	}
 
+	fwnode_mdiobus_deassert_reset_phy(child);
+
 	is_c45 = fwnode_device_is_compatible(child, "ethernet-phy-ieee802.3-c45");
 	if (is_c45 || fwnode_get_phy_id(child, &phy_id))
 		phy = get_phy_device(bus, addr, is_c45);
-- 
2.17.1


