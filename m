Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B492A4FF9E0
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236394AbiDMPVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbiDMPV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:21:29 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2077.outbound.protection.outlook.com [40.107.96.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374F43524C
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 08:18:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfXXXErMa4QrAkf5WteNoTdjq/z/VhCSFfj0WBAqAtKERiprsiBwSuAatULpiko8NKZ8NuGKrgTIOksrNgMy9HbrGIvzQddDcF9lrEssWmUnOzVy7IuSRjPGh/EUGOb4FlwhLv03egsPWUGj6YmFyU99JYlcugdzkEF34aBQgTccVzs15/g8UhrBG/yIQqsnyVmYk2LFms38OebgLiUH1DF+YsC6wBFDC3h3iR/jWqjFF76oPUTQ1pDNgsggyK6uMIABEmfT1MOUugfWKFu77SlA32ea/m6vCAx9it3TYu/sbHRg46l/F9ThuBj7LkRuv8lw7CCDoQ6FVxndgyYUUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VX5DNTo0AfgyL5Us2wyXIYmQuVE2fa0AE0Zb/Bi34UY=;
 b=QOsQIMUlQtfDpcKV8+08miWmdlDV1lnZtr+a/H+DEPXWc9O9wLyraLhyp1HJIr4rMWHjAz8lVGFRdIxAbgvGfl7J9F4wk2cH8bKnUPV9dLoy2msp8QiYxxNK/lG+eletWXu6BnyiDpAZpLohmlnF675wFl/sf2VrXNnCJ1pGgX/yEIpbOqoN4v/HBCSmeaD8vlvbqFcXk9rdM2ZRIe57yWLeDXW58XvdsVczsLtN/wkUc+sifFsa5HjwdF+rvkg2zJLQTu6m26XKaIQFaKidj13OLXFzvX7zg3Md6+g0R480hRMuX+aIcXG9AXS0mgBza7SD+u0nW4YIQC6Xt8VpEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VX5DNTo0AfgyL5Us2wyXIYmQuVE2fa0AE0Zb/Bi34UY=;
 b=qKz6OoovUOxqUvBqk1pVFeb3lD3BHd1XrRBKmA8Qfh6AC6dZPpE0LHTBtsPzyMWQN7DzavVlLPufA+Ynxqu3gCalzHFndzxy1L/JrMmnafHpId2VCDPCb3IzCXq5sSzqSynZrEcihacMu37Z88JNMpGHOCxlV+5QH7uS9QbssTIRMRijQae5fO/ZC1wIWeZeTUwV1weFMTADjOroGH41k/v4Q1IsV6aCvZ1aPnhqNZ/1gS14s9z230bahGY3pV8f87m0MeK+Ug/gTiUEBVfR1KURDgHE+Ox+9z8ySpXqooJ0/JBBof8NDaUCg/FTkwvbCqmCq45Y5cJmzPpmi3guHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN6PR1201MB2530.namprd12.prod.outlook.com (2603:10b6:404:b0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Wed, 13 Apr
 2022 15:18:55 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 15:18:55 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, vadimp@nvidia.com, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/9] mlxsw: core_thermal: Add line card id prefix to line card thermal zone name
Date:   Wed, 13 Apr 2022 18:17:31 +0300
Message-Id: <20220413151733.2738867-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220413151733.2738867-1-idosch@nvidia.com>
References: <20220413151733.2738867-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0095.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::24) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f765e1c8-2295-4983-7d8c-08da1d60eca3
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2530:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB2530F3D847D336B3496906B3B2EC9@BN6PR1201MB2530.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QqkWfTj6IYMmAoHrDJ5xFa5Q1/UEU1w+xErpWTH5fcgWcA9ZVHURL7Id8ImGQs1i1Jp2xvgWu1lJlwPo3nD39r+gQvBWjGx6+VpUGMFZxrbH07BdPRGyp7ymBfJOxaYr+MtkJ7vDVkcZZ70vGSWeVlCRKR6ibRGBCgzw78zv0cKQtpjSo5Qp0T/2sawBBT52i247sUKlZnQ2+Saq4ByXAwqbz09xPYwfc48SoX1qS8skIDeEGnfpf+ffgSVtYk+Mp97RkCW7jJvKmBkXoAIxHuXIH90q6kVJm4v94MWJikuLBKluvfwNgFk6uHy3vmydwmmER9zLbG3WbWQYX2hurSfqjyBlsP0p5tZNDh9p9rO1BKwXt8tnHqoxdAanlDcFAXzp0/2ly4hbtVQYs9ojLsoOcBX0/9qSe3BWjEVvIL0gQxkkTuP7pbCpSAtQycoE7BQDlLuKeTQKseQV2qwRiZiA4NY/XpZtoD7EJUajmDSVPrlHnDsAf2RN4ZLhP6pULn0zXwQDM/nfGBE/TdYZWMmzbg08Fd23NZ70deWFAY+q1Yz7WxlVPqGhGFZksWsH+/MkL2hz/npYBSB8DsPd1ui3/UAHHUEgdIfHP7cyh+ZDPsXG8ui4WIpR5QMbri4xQSlrzofzsifry8qE+nGr6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(316002)(6666004)(36756003)(2616005)(6916009)(1076003)(6506007)(86362001)(2906002)(186003)(66556008)(6486002)(6512007)(508600001)(4326008)(38100700002)(66476007)(26005)(83380400001)(66946007)(8936002)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t8xf39EmFerk0XUNSqzWt2WnfsR2JXbcZ9XlAh0didggOqd5D3dIwcdNdXQ9?=
 =?us-ascii?Q?EqioiXFJEzPhkohtsxscifYVBTMCIEACa9E7FDc1jYODukGPkhUrJ8Zlk0tc?=
 =?us-ascii?Q?ew1mw7apvchsxpYzNFmpyRAFS7cc0WoAr3Gzyg4Kkm+8Qh84TdyLefzPHc7Q?=
 =?us-ascii?Q?zunvczKth83hcfNxiitRvP3CCPB09Ia6nCQNVg0yzbmmWctmiO40SAVL33eI?=
 =?us-ascii?Q?6wVa20M0oGKqiG9fTWrJhG0sSpqItccbo7Me9BnlW0szoRYRroj06BoE/Py+?=
 =?us-ascii?Q?Fb/KU4AeOpwADCR5jwRz9kIXZAp+VOE9wfJDN3kiZ9Uph6RKplJUAMFQeMmf?=
 =?us-ascii?Q?yOYxun6YF84U3EY6WTZZP/OOa7tJH9FTM35TR8Qk273sXLcUJbmBYQYFtRkR?=
 =?us-ascii?Q?xV69Gw9tCZDrZUlokJbGPdKklu9kBS6AXcKlUJq3V3WR0iizP+SuN4HXj9Nn?=
 =?us-ascii?Q?En1uWeNwZ9yybGdRztV6pozbMPVG9YToRZzBfPeFNSguVtapAaRbpJJXfe8h?=
 =?us-ascii?Q?DIjgdheBhrwz/kMz3/j8gv3KWNTg/5Bo4IT0E956vBGL0yLEMAWtaTijTOAZ?=
 =?us-ascii?Q?y2eYmn8XjMbYqW8mvpIdg8GMYRRR9YXbDRdMzWlMtAqNov9CqdTeMxW6lqtv?=
 =?us-ascii?Q?Ofu+ohrAgJTIZqq8j85pQ6AxRbInaXUOY7B8Qa5WdFBLnW3gqXY8oGVAXWyP?=
 =?us-ascii?Q?NbfQ/e12qarEztLGRzk+9Z/eWuVpM0edUa2TgOGaknTYOS6BzvGcIhbtQ41X?=
 =?us-ascii?Q?nJBgxnVGhP4y3Rf72LzV3pdIWVutqmrDNS1eWqmqxoiU32C3THoya9Ov5XOa?=
 =?us-ascii?Q?t8nHblTLg/Ad8CLZkO89vfzUxYNzQOwq3eT6ZpPTvw+QHo/DhAybiiIw+UzU?=
 =?us-ascii?Q?5SyZzwEm0OXfs16JV3GRWv2lIfUnLPRMBED9DaImeoWJkjolDvgqUNtumrd7?=
 =?us-ascii?Q?Z2jH13n7fZmBgAQThybVar52B/dXqA7evr/9pwEha16+Kwb0RX0dl36yEILH?=
 =?us-ascii?Q?FGU5BauHMzhc+DobD4RLImTQwOFi32xarxJokJQZ9yrd9MJ6QLmu4UQxRq+S?=
 =?us-ascii?Q?JPgeCRoiIONE3Ct3TdFd8Xgug9pqOlwhuAwwbj8YP8IPLJpdyy0e7fqgf7pk?=
 =?us-ascii?Q?EUUhVuUrYld4HGnl25OZtj+KoHBzRPwUtiMc/SlupsTW+wvFb3ZaYq9q738z?=
 =?us-ascii?Q?uYitAc/ivs1X8O4FWqgpPS5FuqZgUgwWhXHpASOPHWkBGGRYoLCOA9lU4a4h?=
 =?us-ascii?Q?oxxbtFbeD8K+dpCwTISM77i5ZWr7ymgnllsVrP0/BQchl96n0jLEWTfJSVQ7?=
 =?us-ascii?Q?UEvXsC1vqW8LC35FSVIHsCmumfpGIw9G/kEr5ZL07AyskQzSqDeKDJNIMLZJ?=
 =?us-ascii?Q?Fm3olAC/TyltfyiVRWH+jwNvB19hUhFcba1rTRd1aDEpj6/EE2MrbUaHZtLP?=
 =?us-ascii?Q?8N3C7uL3Jw+VYquvvR/3jvmG8z6nKYQL3eGTRG9WGMRLAl6egc9OwzQxERTa?=
 =?us-ascii?Q?oE7TmUWTEtbA8PjcZgmSybNNREgcTmes8ScjWaViFosK1TN6XdrTWS4M4Hf0?=
 =?us-ascii?Q?RUfwyTBwAsbY0NWJiclV0UWvnu6JsXjYDDxAAnzspqMTVilRpuBx82Gg1Yt5?=
 =?us-ascii?Q?ftsUNdMQ1ri+LtQbOailzvE4bcOCRRRxU/kJ9MLzsJ/W5Fxie7sCEDej8fph?=
 =?us-ascii?Q?cp136Oz4scVxAsxtnfBKFlraqV+JBNx3oax7zb8u98aB8dBrezUCZUd4mWB4?=
 =?us-ascii?Q?W+4S707bpQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f765e1c8-2295-4983-7d8c-08da1d60eca3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 15:18:55.1643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /lpo/1/szfwp4LRUC4niZh0koQ3BP6N/VfAX8vq1H4/kQF2KBrt49Y4AtFo8y6Cw1nhF8AYRz6Wcyac9V8KUnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2530
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Add prefix "lc#n" to thermal zones associated with the thermal objects
found on line cards.

For example thermal zone for module #9 located at line card #7 will
have type:
mlxsw-lc7-module9.
And thermal zone for gearbox #3 located at line card #5 will have type:
mlxsw-lc5-gearbox3.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_thermal.c   | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 6d186cc74df3..23ff214367d3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -685,8 +685,12 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
 	char tz_name[MLXSW_THERMAL_ZONE_MAX_NAME];
 	int err;
 
-	snprintf(tz_name, sizeof(tz_name), "mlxsw-module%d",
-		 module_tz->module + 1);
+	if (module_tz->slot_index)
+		snprintf(tz_name, sizeof(tz_name), "mlxsw-lc%d-module%d",
+			 module_tz->slot_index, module_tz->module + 1);
+	else
+		snprintf(tz_name, sizeof(tz_name), "mlxsw-module%d",
+			 module_tz->module + 1);
 	module_tz->tzdev = thermal_zone_device_register(tz_name,
 							MLXSW_THERMAL_NUM_TRIPS,
 							MLXSW_THERMAL_TRIP_MASK,
@@ -820,8 +824,12 @@ mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
 	char tz_name[MLXSW_THERMAL_ZONE_MAX_NAME];
 	int ret;
 
-	snprintf(tz_name, sizeof(tz_name), "mlxsw-gearbox%d",
-		 gearbox_tz->module + 1);
+	if (gearbox_tz->slot_index)
+		snprintf(tz_name, sizeof(tz_name), "mlxsw-lc%d-gearbox%d",
+			 gearbox_tz->slot_index, gearbox_tz->module + 1);
+	else
+		snprintf(tz_name, sizeof(tz_name), "mlxsw-gearbox%d",
+			 gearbox_tz->module + 1);
 	gearbox_tz->tzdev = thermal_zone_device_register(tz_name,
 						MLXSW_THERMAL_NUM_TRIPS,
 						MLXSW_THERMAL_TRIP_MASK,
-- 
2.33.1

