Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534984FF9E2
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbiDMPVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236354AbiDMPVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:21:31 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C214E33A14
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 08:19:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnKW6vx4U9rwP2jo/kBPovg01WcXOzyt1YWMVYfATMRzGpffN5FtgiupiPUXK3WiHmRI8HNfskSiv0C/gdC87e30FQCw75TFVj9s5fDXvDOkRqz/TDdrBTgzBmvjusQ7BgMwQ+XrCMb+LP1NX6KF4umR3RWBEICJA15Rbm8jngM3aBsn59E4OlBZ1d9sKZi5x1wQRf3W3AEd5D94rLefKJ2jjVFkJwAA50Gysounl5jLXhgyFdZ0Y38WHhLDxjPvEGcz2VlyNCMAJLjubATdRPlfly/qaY2MfpPHFS3EhChSlv3WQ5OgqKQM+63Pm3tWkCUg/gdLXcCLip+/WFqt4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIQcj/P47cFzkdRNDG2mSPwAMYrEPBEA0r48IvQVPI0=;
 b=dIWG6QZ1s5ZzyOyH90jI7NNOsmNCe8H2Rd9YF3Yb3+BSGrGPfOcYRsQ0Y2X5x6W9o3IuXLUv5zW6by6OV8qQGSN1qJHIOfj46mCxAjRCPd1wRBAzqnKo/bh/FiJ1OattyQjIG7FW/YhqrgaJPfKSukWTYRSVULeUevTq5yid+rI17KdZAZuCIy83mPTAlU6zyBIt+oPx5ug1VTExiNEgbKPBqD/SM/yETW6LC66t0cIFQ2rEkvv+oPfw7Q6yZrBLFwaB0BBnw18m5QzXFtsvQbqxhLq5a+LWsEUqpwpI8QvipJNWXmeim0nMtek7F2DdSbEcaIPH1EtVh97dlIAh9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIQcj/P47cFzkdRNDG2mSPwAMYrEPBEA0r48IvQVPI0=;
 b=f+CAKLDgaTSlWC/UVeMqOYGJIEZppnpVacP8UBKF28QLs+38EbvyGe574VlwaBZz1CXPX9GNVDLXZPBnIclEDWV6+rPYdcSQ3JfCdWwXp86PUHg6buDkwfjXCOKnLOdkK8sfj7+Nu8Wp3yqprHl6/xvktvZ1gtJc+KE3FyIkHKPniNDqLUpzwJP7X7SOxYZzZnmXgf4u7iyJ9rDHaYlx6RZONhmGQkR1uTmrOa11HX7+QxTxwTBsGkv9rrsN5mNn1pzi6tYCAiSAm5QMuck7brNQ0Hll/D6638BjwvLaNnh7PbAcBJdTDsQNlfDzp/C/DNmPuWg7utUuMAxUEpZjBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3885.namprd12.prod.outlook.com (2603:10b6:208:16c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 15:19:08 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 15:19:08 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, vadimp@nvidia.com, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 9/9] mlxsw: core_thermal: Use common define for thermal zone name length
Date:   Wed, 13 Apr 2022 18:17:33 +0300
Message-Id: <20220413151733.2738867-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220413151733.2738867-1-idosch@nvidia.com>
References: <20220413151733.2738867-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0198.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::19) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e3d1ca4-2844-4896-2b46-08da1d60f47e
X-MS-TrafficTypeDiagnostic: MN2PR12MB3885:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB388599E995449597522B2A4EB2EC9@MN2PR12MB3885.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xcdxYjXJiF0w3uvoYePRt96b4+nt5mkSNlhG2dwLDHhrU/BfsypNzUKyxw5HzkvsYop4ttIujZA7FFGTggRFcHjiqXITJQsP+B8NsYTqkrO94u6bs+nTbVsG+gARfc2oAEZl1ume3ezN9QvGm2nRAmbZ+8QMKn1tKRXwMKV80AcgqzuvO5uRQlLg8F4U8hDyFhnS3a+DXktVB8uBrAQQPTXLGQ2Pm/LYzhscFXcUL56n2kGG5FTUzvfjZ/QkIVDtPq/mU1U4PVWiANBxBotNGF9V8OnQZK+LM/Gylv629zQSHNy94rjHT4bUYeuS+kQ05PeB4noooavWvWc2Pv34niBxtALLTOgrFP6nglEOlYuiPayQ5y+UZYSLRzauxR4nz1+Cr4lgvlyMwgMEx+CBdThuB1LU47nqK2dPsDXPMrl/eUOuyNzncYE+Ap4+C5QuJCfaynWL77aze5qzw0kVb5WnDObc98hK/t+entK4jgcaYx85Trzt3N9oXe4XqdDx1s37GC5pZJlZc+jqh/fdeng6QKqyu/jcIL8P+LPkvUASeeGesKf8RY9hRk5b2vLXd/79k7KpE7uboc8sxhwdgWU37tLm4r7DGzJUfabHnvbvLztOnXVQ1MCJ+hIKZ7iIry5FOhsOEc3WX7/SRxHDQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(66556008)(66946007)(36756003)(2906002)(316002)(6916009)(4326008)(8676002)(83380400001)(86362001)(508600001)(38100700002)(5660300002)(8936002)(26005)(6506007)(186003)(6666004)(2616005)(107886003)(6512007)(1076003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jcbqwcBZyXHxW22GUHOmtuce976EQh7uaBjMx4UKeCJ6EFIpP3eXyqUPTyhq?=
 =?us-ascii?Q?VZate+fnPq3FvRUA2n9hhoFABxwUnXXnd7JVxaCiDlg8XcbAu9gqkkfnZ3YP?=
 =?us-ascii?Q?uIb9oTG3/NabQMAV4zBBsK6Sxb24Oud7ULwidTtK1wsXEMWP9CSto5fNmX0J?=
 =?us-ascii?Q?pBcrPivoKWSdTxfT1mbhGL60ehw1u8sBcpMbQARatarXV6oqwCFnkSAeEJ4Z?=
 =?us-ascii?Q?JjhdEM/djkGdz7WVXeUbfe0w59NDKDowxEOx0HXNsO1n+iiMTxbL5vnx3y8x?=
 =?us-ascii?Q?StECVETAg5KBNCI+6cjy0V5O+oXyQckVqJDphNS0eiMkZC9AsMoSYx9TDmNw?=
 =?us-ascii?Q?edAQIbhF1Uag2GoMd2yKlWGnbzGGBwvBNic8MqIOELqKRbBn/GOI6ajZ9P2d?=
 =?us-ascii?Q?UOPQi2RV11PQVu8FkvXMirHu86VeYAHOtg2bfFdDOJUgEAnYIBqJcU6Wd0vC?=
 =?us-ascii?Q?9gR7SZfgenYuOxsWUCbKa5QH9p1m0EGR1fDYoL+/Hs/7kziihh/qjjHOA45r?=
 =?us-ascii?Q?pa6daLmO/bb9ByfQb0N3UX4L0/feKRTJTmy25JM2MQSHJo1vQuGWAHhXsaTh?=
 =?us-ascii?Q?YyA1Tsn14U49yKH/A0PlxHuQ8Pr8m2mQB9lkfHZsRcVVQ0xuyGRmY4fWKEll?=
 =?us-ascii?Q?HdhCFkLq4BSqmecbOYTyza0MjQ4y9fcfa6SGWSTM4rbH/sH6zk3/bmZEtTB9?=
 =?us-ascii?Q?7PzSA16GDnWUbPnvOn8nmNw+8yV+ioOrgaBRvrrprfzFGJmJtLjg5YTmFFuz?=
 =?us-ascii?Q?nriVaNgSt1g3r3SXr75n2KBK3t3p/wqebotM5p5J7AqUINJqtfpelCpvdebb?=
 =?us-ascii?Q?snd03+YjVznuGxG/705B/9ExPJX8KnaeEZAs7QiZ4jQbTxzt92pfBmz0g0sM?=
 =?us-ascii?Q?k7sLL7md/CKkaC42uvEeAZoQBcHtGAPCA4vTuBPyHaLMLeTIQF+WsCPw8Gfh?=
 =?us-ascii?Q?KCqX+qDDGh2/TS+PJyTzS6snL3K5p6/VuXRKfkqQXdraLGW2H7DgPmallXWq?=
 =?us-ascii?Q?HDs8dk2JwldoX+bym+bo8eJ522u323tx2tjSPLA30RQGqmhZ55CovQAmgMcs?=
 =?us-ascii?Q?8lwYU2684U3f/t50D0EUQFcbKPH9iV5JR/IHYzEx1jDzH6JNtjzl3icwX3p0?=
 =?us-ascii?Q?Y8AQp98c8Y0swtoeeMPLYBO0GqrF1vJYn1C5Pc/FmbS9ErAls9VBE9pQVej5?=
 =?us-ascii?Q?ifzNNuPBuF5Ma78+dtV+xjYoTtT9RMuJWEACdeAascEYYqDD8hQczo5UMI+W?=
 =?us-ascii?Q?S+etZSJBlNZHNCqGZsMgfniC3a4NQJ1Swwd8XrPZI/UHEyRoIfO7k7TNsFYz?=
 =?us-ascii?Q?AOV+CekUSuOmff/+LntNgbqX5VWok0u86TYM9lAt3psl+f8gMev946AsvY4f?=
 =?us-ascii?Q?kKkNF/GUU4mP+4CHZUBcPAHVQMP555ij6o2GCPR5Ta2GbSPFFmdUFq/GNuk/?=
 =?us-ascii?Q?c1RgPLydSpEKMjBhdA8n87Qu4FdUcrKC7QD/5yhGwfDvf1AaV3cr2f/9myhe?=
 =?us-ascii?Q?ZKtL77AQyui+p5yRQEJW3/DEZkkbxHD9ymToMPsb4rcGYEGq5cGY9Q75aHC4?=
 =?us-ascii?Q?dLitceyFagAh/XWIVD3wkkVlxMjCkD0P/yzPDQN5JYcHUCLTc7XQFn5G53hA?=
 =?us-ascii?Q?whn5L2bV4+b8MQ8jVwhycH8HvZHEsA9rlwhC/4A1oiAOiE4RyDL327OGaUzN?=
 =?us-ascii?Q?YDh6lGqnCzh8ej4xYIFUYXcAfizpLhQEt2rhSWeusXp6lHzhd+3LfSd+hYPi?=
 =?us-ascii?Q?ihjbz1mfdQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e3d1ca4-2844-4896-2b46-08da1d60f47e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 15:19:08.3102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GaO+V5xhFGlmrxDGG7fIvZ5u7Mj/UF41m2ADjlUTgK0OR+plwkKoP1FagQk4gjuhG/n1bhOfJewH+UVovThA+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3885
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

Replace internal define 'MLXSW_THERMAL_ZONE_MAX_NAME' by common
'THERMAL_NAME_LENGTH'.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 49ea32457703..e8ce26a1d483 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -21,7 +21,6 @@
 #define MLXSW_THERMAL_ASIC_TEMP_HOT	105000	/* 105C */
 #define MLXSW_THERMAL_HYSTERESIS_TEMP	5000	/* 5C */
 #define MLXSW_THERMAL_MODULE_TEMP_SHIFT	(MLXSW_THERMAL_HYSTERESIS_TEMP * 2)
-#define MLXSW_THERMAL_ZONE_MAX_NAME	16
 #define MLXSW_THERMAL_TEMP_SCORE_MAX	GENMASK(31, 0)
 #define MLXSW_THERMAL_MAX_STATE	10
 #define MLXSW_THERMAL_MIN_STATE	2
@@ -681,7 +680,7 @@ static const struct thermal_cooling_device_ops mlxsw_cooling_ops = {
 static int
 mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
 {
-	char tz_name[MLXSW_THERMAL_ZONE_MAX_NAME];
+	char tz_name[THERMAL_NAME_LENGTH];
 	int err;
 
 	if (module_tz->slot_index)
@@ -820,7 +819,7 @@ mlxsw_thermal_modules_fini(struct mlxsw_thermal *thermal,
 static int
 mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
 {
-	char tz_name[MLXSW_THERMAL_ZONE_MAX_NAME];
+	char tz_name[THERMAL_NAME_LENGTH];
 	int ret;
 
 	if (gearbox_tz->slot_index)
-- 
2.33.1

