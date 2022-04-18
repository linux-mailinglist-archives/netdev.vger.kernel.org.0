Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7208A504CCC
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236823AbiDRGqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236571AbiDRGqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:46:35 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2055.outbound.protection.outlook.com [40.107.101.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998E219015
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:43:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDQkjWbZj8ljw7wVm4PJATas0J17qn2euSC8C0keEzF6I95ccroI22DL3TrscoZkVY1fQMEfAPsTR+9W3xyTxVE4RNelf7eshr2QnY2oqc1cmjqo/a0bSihYLin4tzB/DWaFWGS9MA7Hy4sp33YiHjlFq1PY8Da++XgxlhadculnhmPHHQ7P/YVXIZJBQvL0SQb2wR3H9OtPX5ELIpPcfjzJfMcpRVrdJiG9PgUkH8YkDtoJhE1v0fM6YlI4kVIsyiY4AAuxy1kmYCNVpVsomMR47t0amwfOrg0ojUpm5wSUG68c4HXJCU6v0Ezcyn5VOykqUnu5g/mdyktEO0pjBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YuiD8/n+sj6HvAxrCRzBcsetFw/v/cn0RuraUZEDX5E=;
 b=I2IOxJe28G+uAr51AccIZtnCPJROcSk7d1JrkGNrMlW+L6mRidwyqAn4t/M/KobTWMKCrmP1qke4RSQRYQTB7U+F7nPPNAcdaqBveXJDIgUdVNDAPS9Fjq56Upl2MHf/8GS9LIF45n6kWcMZbqBUe0kQIa7PbtqC6fNpcd6knsy+8yMA3r8Qg6fuVyDPPmrszcRT8501OOpyXRqKDH0nkNf4hbyvRype1JS3062ygF6MpZbJIhhPvWbIv4icCOnk9IRLFxwKrq5RvlClPBVVhIXdc0I0Od8H2uWupRqpXdMs0J2bQtbvnbZ1aMoADaoRNxt9cxvnAne9cpO38jPUXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuiD8/n+sj6HvAxrCRzBcsetFw/v/cn0RuraUZEDX5E=;
 b=PC+LKIBcHB2DOn3IxfpainvoiP5OUhtR0k0X/XddfYltfXBeizdQhlCX4PBLU39n1hPTNavmCwlVY+N1XGbB1JlLyDd9PcI0c7s5FNsSaZ65oduyoa+q4YIUQPQop3ZBnlJtr2Q262KY1PXCZtG5TF0/lBLJlaMoallJAOUhBEL9KzQY1YliSPfqQHcP4n45XzGbTnjDfDqo/3nXP9rt8YAaHp1/Fkvowffkg7Cu2k2f6IsgwhF1F8vqMrZvgiomNSaJlkmeHSWMDYeDmbxlCFU7Wxra0DxuzAZ9KHxIEwXYYJYRa+VOvulaYws0aexYTn1tISDIs9tEt80gbwHohg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by PH0PR12MB5420.namprd12.prod.outlook.com (2603:10b6:510:e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:43:54 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:43:54 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/17] mlxsw: spectrum: Allow lane to start from non-zero index
Date:   Mon, 18 Apr 2022 09:42:29 +0300
Message-Id: <20220418064241.2925668-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0256.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::9) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f7f0d3c-5fd8-4ecf-2b7e-08da2106ce40
X-MS-TrafficTypeDiagnostic: PH0PR12MB5420:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB54203C161575E47EAF36FA96B2F39@PH0PR12MB5420.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1SAgXy19RKs+YQ/zZTdn3wBsfgxkDqiFlJFbDshT0f0dg/ISgW3EhRvHw5pukT+Es3/AzWjZzwKddZaNV+EEsjG4HDw807X5JjjcvMdoCZC5hyH32jijeqkX5ifmqrxPM+8iuf7k9rVWCk6Y8b2iwPI7eVmcimXpe9iNmWKSL5ssddu5TS3NH+z84L1ikDacpOSDHM4AZO20TWP5IEbh2Zta8wZyWBIry8iluietdO7dBlgUt7L5bj9ixN6WaX3RpmND+F/mo5omI0VpaEycwe3afrQ9T8y0vFAVjTJjTGu+51TFX3HDQN4wVBensYVpg9/4/ACqirw5ZdH40GGsE9FF1gd2Nv46OBNoWVTxHL4ZkL6YLcPcAcI+gSF8J3lzT00tZmaKrRS3uI02ANJQcOAkW/m3Ib4n3qb5fHFLXeCjROrr/30MLgs1ln0qhvpIXEas0hTR4YWf5Ksa8gbVdYV/e8GAlnlVWKepDeyFC8XqJCplRmGnmXwvy1vFOSseuEstEbSw7ncvHPprUQrf9JQc9J5UEq+5edQAB0lDuJ9fPMHyh251Q/x39AdEmRL8J4JDiTx8Lpn9Z4NNI6godtv4pZZX2CNhHV8B8kdhgb61SQC/1i3vlojdyvmQjx1Ka1R+VF1rtUd57beG4OLTXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6486002)(508600001)(1076003)(2906002)(6512007)(6506007)(86362001)(6666004)(36756003)(186003)(26005)(83380400001)(66946007)(38100700002)(5660300002)(66556008)(66476007)(107886003)(2616005)(4326008)(8676002)(6916009)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EIs/RWxQXWel/Ki2TF+YwsOVJ4CMvyyIudB67rvoGD5sQbl0p9FSu0EEzC3G?=
 =?us-ascii?Q?BJ7QuMAF1FjDQHm5/G4uY+XANiDRfzgLSRatq+OsJwiJ2LgkphNU7IFuVDj0?=
 =?us-ascii?Q?OHbzbekrYscu/AAP89Qq9BFgj5+1OVvcMNGvYSIA5W9gXl/1EPYWDOod4stk?=
 =?us-ascii?Q?J55+jOhmcUIf6VyQRvqEeeAIJjp655QoFWkJTgI5GpTbzqNnK7hfIvDsSrUC?=
 =?us-ascii?Q?iRKAfPWav6jgjGaK6q8ojcLhcG4+1R164bSD0u5ccY5jjPGhTOq0MGMJPI0l?=
 =?us-ascii?Q?pD89l1eqeXb9SFayzLxLaYI4mwZxIg8HSTHz2tKqyJHxdnwg2fW8OUHZwFtj?=
 =?us-ascii?Q?Hj9SkGiEsbw8KNq03uAFl2GoZomLJtjcBXIHu2uwWvEkLOmk6MXR6kjgvv+N?=
 =?us-ascii?Q?BLg16h49CxcBMrilJsA4oUMPhVCqRKRSVEEaINn2ZjeLsScUvtmfkTBWJ8US?=
 =?us-ascii?Q?S2Hdpsnw3k+ZxtY0PY8/pH3iZg1yYkrp74wD7dnBQqvLddyIevvXQBCLYjc9?=
 =?us-ascii?Q?hPlF+Pr2l3c9vJ8gNj+h4KbZClayH7VLpA0pfyuosQZy5GKmI2KY6VmoCigG?=
 =?us-ascii?Q?Fj3BvKQJEbbxbCwgjMhgYcO805YsKd5MIx2UnKZRlTHIuH7Tq/BPGfaRWyDB?=
 =?us-ascii?Q?G1N/W9YjmVTW/SyRj9OeAce0LXbDt8VvzFUkvMV3zyjpq57RnLb+V2S05nEW?=
 =?us-ascii?Q?T3ysdlmdfyTgvmjYpE6MP9dOCoYGEzHpfVyUy86P2xY6SmiOkerdn3rR0HDn?=
 =?us-ascii?Q?6HcTO0YgprUBi4G8ms63qiuSiBhiVKzU1FqHsVYfJ5tWDu6tg4Azf43/dTHj?=
 =?us-ascii?Q?OcJGH9XUyAlSgdOdCMOzbxGuamdeKkuFRwEV4V902dU2jMOva4JFsDCFWDiI?=
 =?us-ascii?Q?qHY1oWPJtFC7Enlrdk/XI0jKjzEVMC4ZZhHdr0lYfJ3rg72G/UOWgk6L9iRW?=
 =?us-ascii?Q?iDP28RUsxZTPV0FoMuKE+o3Ha5wgRf6t9mOYSFoD0gR+dqrZUzWkSwitdqYi?=
 =?us-ascii?Q?Xy+iJ+nKwAmfx2UnQtTdoktWECUesrJ2kzLoR1axD3uZvF2hSCtgMzg+BQwJ?=
 =?us-ascii?Q?2I5SxNXrKQAvrkODhqg8MECtIvpNYBJjTSkNKH2Vkk3N+28jZo0uoMWWlw6c?=
 =?us-ascii?Q?R5nkArIlaHgLR5ZT+Lbx3FtjPL6bo17Jl0IXLsUOpHcItJ7XTLaKt4qb1sm0?=
 =?us-ascii?Q?AK2Da1J/KG3oxqM7g7QtgGtyQMa/E9QRMLFTvgejXaihe2W0sDW1l2RCYNG0?=
 =?us-ascii?Q?Db5i9H9eo7JAUeoarGCew9VR0KXIFDz8SgJK+7MOJR4ep5n/dp6/uxkUQtYi?=
 =?us-ascii?Q?o0PObcdLLQgKmjqtWL47QUUTncyxVFfhB9Jnt2L3lU/WpIgYldqaIC5p26Lp?=
 =?us-ascii?Q?UfQPBHOdbC0K5eZNUTAo1c6ZduL6h5dKfSuZQo/Asq0t6WfwDlJGPPizjupF?=
 =?us-ascii?Q?Dcx4w+B1JHYmHdSOPDcge6DsKAbMJMmrYCPkwt6IKK2PUj6Q/VDoX9lg0QbT?=
 =?us-ascii?Q?oGjEoxpXcwHx0vFthPausf7R88tFMAQpg58m3YSraABvlk8AFVAcI3WMyOCT?=
 =?us-ascii?Q?UECf7Q9Z5UX0iisthJSeyAf5lvvPw7++Gl4LmR9sAy0i9gqmR5kuwS2VFXIT?=
 =?us-ascii?Q?4x3pmY1o+iK98I9hJjfz6p6mQCvywwPiyElPiKHO6OC6b4TKYMIIWQf7pGXE?=
 =?us-ascii?Q?4iuv+kAlrMy7pbjChFj68xwXqFAidjZeBWk9iUdcc20KuxuDN6pp/LAqBLax?=
 =?us-ascii?Q?aOUbYxZ+ug=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7f0d3c-5fd8-4ecf-2b7e-08da2106ce40
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:43:54.1428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16b9IsOE1fQuGGYdypipnytGwmcDsL1h1aD8fbDOXD1Xkq1qHge7sCOH0zpey4O1RQXdcN0w9Nl71UwrvkJb1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5420
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

So far, the lane index always started from zero. That is not true for
modular systems with gearbox-equipped linecards. Loose the check so the
lanes can start from non-zero index.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 684910ca7cf4..120880fad7f8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -486,6 +486,7 @@ mlxsw_sp_port_module_info_get(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 {
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
 	bool separate_rxtx;
+	u8 first_lane;
 	u8 module;
 	u8 width;
 	int err;
@@ -498,6 +499,7 @@ mlxsw_sp_port_module_info_get(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 	module = mlxsw_reg_pmlp_module_get(pmlp_pl, 0);
 	width = mlxsw_reg_pmlp_width_get(pmlp_pl);
 	separate_rxtx = mlxsw_reg_pmlp_rxtx_get(pmlp_pl);
+	first_lane = mlxsw_reg_pmlp_tx_lane_get(pmlp_pl, 0);
 
 	if (width && !is_power_of_2(width)) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Unsupported module config: width value is not power of 2\n",
@@ -518,7 +520,7 @@ mlxsw_sp_port_module_info_get(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 				local_port);
 			return -EINVAL;
 		}
-		if (mlxsw_reg_pmlp_tx_lane_get(pmlp_pl, i) != i) {
+		if (mlxsw_reg_pmlp_tx_lane_get(pmlp_pl, i) != i + first_lane) {
 			dev_err(mlxsw_sp->bus_info->dev, "Port %d: Unsupported module config: TX and RX lane numbers are not sequential\n",
 				local_port);
 			return -EINVAL;
-- 
2.33.1

