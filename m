Return-Path: <netdev+bounces-11459-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4814A7332A6
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:55:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 026F92817CF
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7067C1ACC4;
	Fri, 16 Jun 2023 13:54:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED3719E4D
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:54:07 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2080.outbound.protection.outlook.com [40.107.6.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2385A359E;
	Fri, 16 Jun 2023 06:54:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZeJK8OzzUc1iwOZOmP4gW8wDhUeluv43ks15bV/y5YRv76H7EEGe+zyDqS/3fBdwDtmaBmXCYFxpkMEf3IUPGV4hw8ZcVDGuvssvZgAFI5GSzxEV6nqxYe7xv6Ep8MhnOUeABtNI+G2LjoOBElX7gB94T5dxr9y2dNObitHlYdeyrDSKIZVbAKrYnqq+e+v1BV1opMUyE4hTk8nCMa9uix2wWweFUcit5NUnJQ7LWDo22rCo0aoGnWEPtbi7JPkM1i0KNzr9xnIDBsuGeUacM4eAct2nbGJc1NPTIVx7ttCjb6FktOgjGlRsQT2vAm8x7bh+o90Z508Ta+BmdvgKJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NbbdNJyu/a4IIJTLO8CBCEtdx6lTEaJTTzc8hSGC+Gg=;
 b=YTlHtoyzIzcHue3Se35G/Pa0vWlo0y8w2gZ/YzP69jZ3quBulzkIlttyWnFCMYmnwQUOf0mDeqbY+BKbaF0TtlKIMfmplLbqt8ZtVjJfyaMyjQCrlT0PAu8xJG9vCMXtq0FVYn9tmOmCP8M6Dgb7ZauzH/RO/sENrze8uECaC0vBHgSZaBqPJ/hrZeynzg7f0YGfKNjJ4/wK18t3zIRkzHSJyprpgeCYjNAU5AOcFD5DepoxWsiPn1bLWnbH+UtbJwBWS3cApTQIfz/eTITX9ZO7FItXHCVq8A/d0bQWOrrLT72dZ910BuQG6j2SC6aTj00rtLgHvLeRXzJQGQJDiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NbbdNJyu/a4IIJTLO8CBCEtdx6lTEaJTTzc8hSGC+Gg=;
 b=AcngkUQdxoZRvMBmn70PmtNsrOzteC5KDxWK56c7frbr6j7Rb3DDjyHA5/YbTJhiDUA6LiPsdQ64codRqn+kY5Nb/JBIZxyFxbPrcXYMOQwIGzWNg7lyv60VRaSJB/z8LUZWx4/So+iIHHaa40Ziabjt1vpnZR/WI1+tYZFf7mQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PA4PR04MB9318.eurprd04.prod.outlook.com (2603:10a6:102:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 13:54:00 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 13:54:00 +0000
From: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	richardcochran@gmail.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sebastian.tobuschat@nxp.com,
	"Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH net-next v1 06/14] net: phy: add 1000baseT1 to phy_basic_t1_features
Date: Fri, 16 Jun 2023 16:53:15 +0300
Message-Id: <20230616135323.98215-7-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::47) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|PA4PR04MB9318:EE_
X-MS-Office365-Filtering-Correlation-Id: 44fed483-df44-4185-cd3d-08db6e7122f1
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+EeJV9ytQ8lcU17lMhRVdyF1E3vv27ycb1b6aP0x9F1Tck6619kOMuhKv7+mut+K3xi+cDfDx7q0rv/eEOieV2rydGepRmT9FO7dcJlTwerpmlLDzddaNkyy5nuMsESUaGDgIFH8FLE06D71iJu9MTCL/EO9PgVVqgXhzuNdMbcfm/sHM0o8u4uzQ8pzIZyFj29CMB2+xSP6jVz6gSlUHqpdkjyyjXo9NGu0OT8lKfFqYLUD5ThEY5GFHAtKrme0IWuY2+rgJ8ldTheWDdJ6205bOfKx1GCxlUZ6wRKaP54nS4lroXEiUA24mzszNanoZR6MqTAw7ZTeMkqGuBhnYfcBhwhlaCMD8NeqTayWVjhgY6SkUeDnbOAvo7otwqGLh1gnYkD6PT0GO4rO9cRpPHyB7VU/YxQfPqZF2tDgjJTxcBYqRhxszG7ezmcE4JLkM/AYFXWTbve099RUi8gQAsNK4GipjpwxZFf+PnMfyY5YQAMn3Aq0NQfWdjhh+OYysCRNPwjjw8eR11CgzePZBOPLRdmQ87Nia+6Es0WJas91L71qftuixK7OrxROSEjXnThHYrL56ro0tWdy10dFb9xdCHfNfRYddDWec3VDFHHsd6miWvk8oa+7WKmaaMHk
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(41300700001)(52116002)(86362001)(66556008)(66946007)(316002)(6486002)(8676002)(8936002)(6666004)(66476007)(4326008)(478600001)(7416002)(6512007)(5660300002)(26005)(83380400001)(6506007)(1076003)(2906002)(186003)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z15iOhjsm1PapvEO7dtl7Qgfu1/t3f+nzZlt1kIxABHh8bLsETto8WqdON/h?=
 =?us-ascii?Q?y0piME1Vflk1MSeuXwdQnoa9yxKkc9kivYXCASFtnNQvkta3DiZ5ogdFY+/c?=
 =?us-ascii?Q?RAhXqlTzevQIQurfANPOhgkLct0AIqD7fFEgXPmJGpCWJjq5ZE+WY/Z8hBtE?=
 =?us-ascii?Q?cb4tjiKhmO5cml0ZzrgHqavXZn12Je1Q4j5BdA9mcSbcNxvAW/KRA8ggyvZn?=
 =?us-ascii?Q?Paed3FYRjuA/S/lWrjDKpnu2jT2abmKWGjiWg9AyprybWvGBr6jM4TlYGvDq?=
 =?us-ascii?Q?hBXEcgbsz6/ku/hivHFIr8k2azuCj+3iA7cE07ai1nGgGWIZ6OhHohv9Wa/l?=
 =?us-ascii?Q?ijh9fyVuTEt7lNwW91jkcCx4Xty6p8o8mgVUU3apq7sZWqEwn2OcNSmKDwGL?=
 =?us-ascii?Q?nP+0XLfd3ak1kSVlF1+nI9iFLWRpuU0Prk+RGFtra2/YQxw/wVDxpA7Hq7Ed?=
 =?us-ascii?Q?3ok1qTL+wEfWsyb+HfbppsWE2phZWctuKeoN76xAtTcmjtR2IWYUeLHVI7Cl?=
 =?us-ascii?Q?QMtXprCcU9g/VHQKk+AJuwTK/qCMnVoVteQnOrYHtyvjAfw34KDuftsdnCvB?=
 =?us-ascii?Q?aN/r2QpHXIa/iSz6xmyRMumBZClgAEzmnfiYcxF+gjMK/Z0n91QYKsX5s1Ca?=
 =?us-ascii?Q?YaSvY0AYM5PCi3lJLKyjtm5HYhB0rmrSUobMqAaEyKgsEBBhTzuvTLLTPXU5?=
 =?us-ascii?Q?Tnw7NbFg6wJ9FxlItN/Mi638DJyVRXcj1WIENUYeiVYMkQR2qF/CGXIuyJ3t?=
 =?us-ascii?Q?tanI8H4JWdanNrFO68NqYbtmcWYyNQkLg/ZaNZDnJSIZhcJD0rY091x0sbid?=
 =?us-ascii?Q?Zuf0VNMTuvZNeXUjzXbHqArRJEp5lYv4oQ0ys/neN7xCkkS5cJP6uL1a+Y+k?=
 =?us-ascii?Q?slzP9DCvRGDwzubXUA9KBmljgIRzywI1/iwvVVgTCIctZQyBCVmaWdgScaK/?=
 =?us-ascii?Q?mj6gVtu8em6zfsHuwbyTOA7t4AaO4Q36/2FCdGUSQ0mFjWNTyaqJnHNpQ5Jb?=
 =?us-ascii?Q?f0ZxghY+L/a9fzZRCXFRZ5zCqa8x/9OWlc4f9qiQJ5/lyXBoEYbgsaVBaM4z?=
 =?us-ascii?Q?1SkOYlke2yfZRKy8Ue1EHZmvrt0v9ooDSuDqTeJDuZW9vY/tSYWkD5SjHAM3?=
 =?us-ascii?Q?7LpV28xc/YOKKZB9QTmJDKJj8lBCfcaAO2sJj7R7tHpS1igJ0Qp9CyxqG/zN?=
 =?us-ascii?Q?EmJOuMsmjtxe2gw1atgja6o8cNScxGnxyX4BvyoLN4nchwJFn51VBC1Ze9oF?=
 =?us-ascii?Q?uJue3qQSik4dxzoFBLV3qwd+hbb4wY3w8pRoJyVHi8IWo5rULox8BRjlqzhC?=
 =?us-ascii?Q?ya/sasuZq9r38QIcxsXXeCOANKpupDHOnNXnA/snZ7+UfIyN7fkEWrBqPfQk?=
 =?us-ascii?Q?hawLcqG2/hWytGSXmh5jNaiIUydDx5hzajV3Pt7wR0oOfjz1KNqScFruYpqI?=
 =?us-ascii?Q?Z2GCF6OX6zFgIUwPlRUdo/b55A2njYv2+Gu94Adbj7bC6iUBUb3WRAQL1eef?=
 =?us-ascii?Q?7z2mlGy8ZOS7iD5Js5CFUeir9uf7UA8Ig1JNxmCM6naCJjvA+3MS9PCqRcTP?=
 =?us-ascii?Q?0ubsnJTHKpAcVRlOE8HwGUQrtFkoZP/9odfgkSeM/+5mVqalSq7rizAn824w?=
 =?us-ascii?Q?CA=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44fed483-df44-4185-cd3d-08db6e7122f1
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 13:54:00.1508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vsY2NgmkldLjtLIh1g1tJ9fyC6vhCYmAFAYN272Owv85UVwkpobHhcMMEFuYBOGLYMmz6d5c0DYwwR751NuYVxSx+k3yYvG5pjcCYr5beM0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add 1000baseT1 bit to phy_basic_t1_features.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/phy_device.c | 3 ++-
 include/linux/phy.h          | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2cad9cc3f6b8..1c7fefeda7a3 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -96,10 +96,11 @@ const int phy_10_100_features_array[4] = {
 };
 EXPORT_SYMBOL_GPL(phy_10_100_features_array);
 
-const int phy_basic_t1_features_array[3] = {
+const int phy_basic_t1_features_array[4] = {
 	ETHTOOL_LINK_MODE_TP_BIT,
 	ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
 	ETHTOOL_LINK_MODE_100baseT1_Full_BIT,
+	ETHTOOL_LINK_MODE_1000baseT1_Full_BIT,
 };
 EXPORT_SYMBOL_GPL(phy_basic_t1_features_array);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 11c1e91563d4..47c2b55d899f 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -70,7 +70,7 @@ extern const int phy_basic_ports_array[3];
 extern const int phy_fibre_port_array[1];
 extern const int phy_all_ports_features_array[7];
 extern const int phy_10_100_features_array[4];
-extern const int phy_basic_t1_features_array[3];
+extern const int phy_basic_t1_features_array[4];
 extern const int phy_basic_t1s_p2mp_features_array[2];
 extern const int phy_gbit_features_array[2];
 extern const int phy_10gbit_features_array[1];
-- 
2.34.1


