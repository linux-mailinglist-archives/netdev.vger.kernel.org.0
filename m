Return-Path: <netdev+bounces-1352-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C79C26FD906
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:15:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3DEC1C20CBA
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6532312B6A;
	Wed, 10 May 2023 08:15:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5205E3C25
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:15:51 +0000 (UTC)
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2088.outbound.protection.outlook.com [40.92.107.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D61109;
	Wed, 10 May 2023 01:15:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ro9u7wxV4dVhZ3UE4rjd/9UAtIyySCWZ7l5oxLzn7jzt/fr4zShYUQ5Z0x1r8plHaY4kM0eLrxpPRvjrl7fgf7fIf6Otv5qDApEV0T7p8fObQKSz6vAct2cyLdzPhgxPIfGU7t5a5jMq8W+WZ80Sa3ekoMZBlfdBKul556MDNMGD0FRd0Y4yG6lcUxsTxUFyenEUhYcxlnEMEGQSPi/kBV3TkxpWEUQYsE1CJ21uzwRDhbkPck8ry/9vMvNJRMiSfwjf3klWkTEK6j36hjGO/YUh03htgGULcopBPnYUtWm1o2HsSTvL6MpZmewCN4hor0HP0hMPI5Km8ga9SeqlLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3hEvRxnVuY8OkAsvsamTaF333oxcWYeCMolkQYpT9/8=;
 b=VTUrSoTY/Llwk8GTRKcEWDlwGs3hlr9xZGXluwTWTYJwHsn1dUYKxkbvQIm+xsGhDezQMMQp6mozHlS595cPDCiKVmMw69bk6ggQ5FeqLk8JssALlKZ0yJ1vGvxnsK1riPU9K6bUWcZVPd3fJjSoKBzAaNd2QGUieuZyEYo1XmMDPZelhbYCffSG4vje+fbVE6hXl0pQ9Tx6grTHOBTtY13s7q78SmRM8x1K4NebVFZ4u4JDanYNSveJPCdqtBoiPUDinnqjg4744+NRQ4mcUQED/inF3529HphfXUWmzj/wZtzf8plzWdtVNeq4VOZzj7gqf9DNVCSQVJhBE5tQng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hEvRxnVuY8OkAsvsamTaF333oxcWYeCMolkQYpT9/8=;
 b=gIurOX9ejF91xgWrvwGBxAmwUCU+PdLTiAgRM8ChXsHV8hNNgKrC0AnevDLEcdTNI0D+Nco5IReU3OWM/aRBFxMGbyY8h0OIbynXTaU5acDD+arFnzYK+gNpxDuhWUYib1OFHybK47ZYr57/cLwGGEyLANlLnH9eMnyoM9Ln8MW0HxH5LBoCge2plbaC/X95E1rTfGMP++W7oLuaLKlyUnwhjE/V2rzFNhEcxQVDDyatRUBxu+wTqo8iDi+xdjFA+b3hLu/38FzkAWxGiT81ABMss3uXcHdId0SCx1xD/EtUcCq6J+R4UtUzkjYvYD4PDLoh2FbH3M9oya/dF3oKrw==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by TYZPR01MB5258.apcprd01.prod.exchangelabs.com
 (2603:1096:400:33f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 08:15:44 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821%4]) with mapi id 15.20.6387.018; Wed, 10 May 2023
 08:15:44 +0000
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
Subject: [PATCH v3] net: mdiobus: Add a function to deassert reset
Date: Wed, 10 May 2023 16:15:22 +0800
Message-ID:
 <KL1PR01MB5448A33A549CDAD7D68945B9E6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-TMN: [f8AmAEqqUiimxftPk4FqF8Heq66pso1H]
X-ClientProxiedBy: SI2PR01CA0015.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::15) To KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID: <20230510081522.16677-1-rk.code@outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|TYZPR01MB5258:EE_
X-MS-Office365-Filtering-Correlation-Id: 970beb9a-7c95-44a8-80bd-08db512ec098
X-MS-Exchange-SLBlob-MailProps:
	Cq7lScuPrnoXjDUq8U81DgqU2Yh/IM/qLFwPWOVjsZzDA1JtHG0MQR0oGrKOkfjCZ/YnrJHRujVH4uo97XNvuxPV6CPGug14IZWzkuxTgJ36nIp5bWMPMUYR6MDB40+Td0WgPo6HrhcTmX1Q1qn3kRjE0qVvcFE24T5g/6Lih07VmPsXc1NZWxEm2U2gah82e/LZn6Yyb0PQhj6ZjyOvk1KtohzjFaeQDOH1n5+2l5oIq7xrjb7Ob/YJs2ecM4Z9LqbMFx5ySqFQ+JtYWtdq68WHYsLwg/WizctY+MbQNqkq49I7uwB+vlPgsnog7byGNMK4itXqbOuNbQLPNMocTXI+QytBKtmS4WzXm7ICyoP+T2b1CQh49k/Tqjz8LnAzy89e+/v7JXp1eGIIIZcVs8c4Uh7ahyEKhXU98og56+ioU6E4LBYDBz9OpIC1GNgCaJ6+c7/jbNHLbtkod5yedfMLclB7HIkqUNahUxW1Q87vO3kzDe+/M0NPUgizUyDAg3C9ZvRvG+7L0xLm24OUi7fmX/XJX7fd8yrjnvY75sf0N5mtG76sTAkjhe/8o8UUzJ6iukHy5UIcIq1zphEKKzfnwPdNRoYUXGvPwaQk7DGX24lVFZ4uK6vsuGxmpUCY4sH/W7Qu7x8jmk0eJy0sH0bQzjEEa9cah38IuqUFhKo1cO/AZcV6KzDXK0iI4hbqoAkEAXMQS3un5gcR8UyKeDgfJlzm3l60au6IGPKqxFnCqOEivQqDSacL6FliUSIhuo8vfJ0HuHE=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qAv4JR3El4+vbwyiitEq2u+NSzivilNfFRc7p81cyrhMHblvRxSa08TZKzk33L2lMLUdXqcaV2vuYdaB3a+m8v/8lnDpebdKwQ5WhilUyJ6g1/alQL4c+P0K6hGi+8vZ2aq/kNMyEJ2UQgqcqzFwvOwzRzxL5kgVjfFDtSZsnSk/6yMtjzCdJ/VIIQTbEjjf213BkwJJNEXR5alwcebmi9WjbVSRjAZANv6eU0TjjzVuhf9M5C11/3TKykvCHYOaLbFVx0dSOcV2RGlsOhA78Dt5KXLwwIcSXNou9CvzKtHU8LEioBv15GuvBQ10jAba4iIASmSE3UgTjAG6BIivklDzJhOho7H7tDEPD5WqfrmfIlsM0CjqmCCEmD+uaCvDOXHcMKPLi4brG1xdVj2C5IVZCW8pGsZt+GYZfDJZRQWPpXrYBZv31wQ5FWgh3vQ1Bsiz+fW1oqL5Ij/t2U8XMu5HqhrviAj+5g+lpUDcP3oMb1D1J3Dh96xudyC8QvWknc8qvy22YIJjdgGH5i1v8auvbGWIO/T9LQqfSM6uVQE8gN5nWLznMVBfaVI/IhgJMNz8rECvpbc3vPm+MDix/MMdTA0y2ve1+jIt5XZUE2Vbqg/UfekNrXrZ4V8d9Skt5nGQDBhaMXleaWayOQ9AgQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YCFHj1QmbVEtWk6tXsb9Z/inJTKeg77VRTzdbA1EFVsJgokNMeiV+qWccITI?=
 =?us-ascii?Q?0xo0xKGISfIuBBpA57fjwND6aX1KJ2oNZz4nuy5lkPQg2C0pOHumvG1a6p41?=
 =?us-ascii?Q?F3Gof10ZAl8e7u+CVnZdB9XDtAfINjFIlnQNeRQZVFIntbI7/2GZ7YUtRbYu?=
 =?us-ascii?Q?CcwNQRhNglrUQEaY70Sf0/uE41CO0KYs76EbBPuNbSUtbH/1NN1IcthJR5IE?=
 =?us-ascii?Q?XzSj64FuZWAo6EmpvTe8Osf3gLynliHZvl5JXXwRP9U6lb7rqWSL3zb8CSpT?=
 =?us-ascii?Q?eek4bAZkK3adtdcYUZWCueiMhsNKfgXD8k/dgdnNZqVm/xFvbjF6hgNvm1Ki?=
 =?us-ascii?Q?sASq4Ryb5EplCQiSk8mkN0IGu6UR9MWtxdZ8vQ3jhvd9A/2lCAW/7I20OHaY?=
 =?us-ascii?Q?LhRrz9T7x/lTEg1m03SJdVvpvZjgshRx8s870TYV0G/doNB6JS2vDHqD6Qi2?=
 =?us-ascii?Q?dnWMkpPNV5ScrJdUyb/lsUNfv6VLuNYZgMH1jS1qhqgQOOqL+3Qr9FglK5zE?=
 =?us-ascii?Q?2p+Cf00uTkbZcKP4G/WZjNcxJ/17QeandenzQcRRKQVrOf2OeDUQ8rMPK2iM?=
 =?us-ascii?Q?zVmdlKv+Q5zH6MCl56ccjeRT5XWrrTBcsS8QxQrbktNtsBblnW6qO/itIQfo?=
 =?us-ascii?Q?JaX9nG9122VbPpLCGeFsTydAylquWBwBWuB2wYl75THFrnFzPNQVTv9uJwSF?=
 =?us-ascii?Q?/0L4dYvOsvrWSb3Wx6WUs2EgXlHs8uSlyd45xMKl9qfARgJYbuU15YVaa8ch?=
 =?us-ascii?Q?lpm/t0sxp397eJSJbCRyrhR4xcy3MZCOZAF2tXLuqa/CPGFKkz/NCp8wEfIp?=
 =?us-ascii?Q?ELqg0WrKZPj3M8xkrgPCOvGZ+DyqpLZEvtFP6CBrvSSb84F89BstRwzj+/Sk?=
 =?us-ascii?Q?7/8uen+HKL4NksSz8TCU8B3sLXYJeksNnpWUjSp1U7FsX5MXFlKMSmqDmYGq?=
 =?us-ascii?Q?eGv3zPGBtRR1fIjGYqscrXBgYJZ3PH/N43LFLTDFVTvJytdkzaB15sxHreTs?=
 =?us-ascii?Q?Ne/LoMXSQOSTNFmcj3qFgyHhKBOvgKiovJKeOZcDSyRwIVT+fmv6WsDUBuWw?=
 =?us-ascii?Q?Cf/CHPXHmhSlEJ4cWx7CiMrBuxNVLDMVGvGYohKzJ+dBfOggtNLHmIhNZTMH?=
 =?us-ascii?Q?D3e0ADWontjjzBAKNqUetuvEwstJoplXNDT+oirpvocEx6bAa0MJN5PDRzI8?=
 =?us-ascii?Q?uj+B2Zk8n0EjcfOas4lueWKZwqd1SAh+27D0zQ=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 970beb9a-7c95-44a8-80bd-08db512ec098
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 08:15:44.7647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR01MB5258
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

It is possible to mount multiple sub-devices on the mido bus.
The hardware power-on does not necessarily reset these devices.
The device may be in an uncertain state, causing the device's ID
to not be scanned.

So, before adding a reset to the scan, make sure the device is in
normal working mode.

I found that the subsequent drive registers the reset pin into the
structure of the sub-device to prevent conflicts, so release the
reset pin.

Signed-off-by: Yan Wang <rk.code@outlook.com>
---
v3:
  - fixed commit message
v2: https://lore.kernel.org/all/KL1PR01MB54482416A8BE0D80EA27223CE6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
  - fixed commit message
  - Using gpiod_ replace gpio_
v1: https://lore.kernel.org/all/KL1PR01MB5448631F2D6F71021602117FE6769@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
  - Incorrect description of commit message.
  - The gpio-api too old
---
 drivers/net/mdio/fwnode_mdio.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1183ef5e203e..6695848b8ef2 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -57,6 +57,20 @@ fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
 	return register_mii_timestamper(arg.np, arg.args[0]);
 }
 
+static void fwnode_mdiobus_pre_enable_phy(struct fwnode_handle *fwnode)
+{
+	struct gpio_desc *reset;
+
+	reset = fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_HIGH, NULL);
+	if (IS_ERR(reset) && PTR_ERR(reset) != -EPROBE_DEFER)
+		return;
+
+	usleep_range(100, 200);
+	gpiod_set_value_cansleep(reset, 0);
+	/*Release the reset pin,it needs to be registered with the PHY.*/
+	gpiod_put(reset);
+}
+
 int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 				       struct phy_device *phy,
 				       struct fwnode_handle *child, u32 addr)
@@ -119,6 +133,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	u32 phy_id;
 	int rc;
 
+	fwnode_mdiobus_pre_enable_phy(child);
+
 	psec = fwnode_find_pse_control(child);
 	if (IS_ERR(psec))
 		return PTR_ERR(psec);
-- 
2.17.1


