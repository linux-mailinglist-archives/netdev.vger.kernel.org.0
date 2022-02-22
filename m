Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA9E4BFFF5
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbiBVRSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiBVRSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:18:03 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6590210BBE3
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:17:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cttvYnd3qUbw6NG8jQg0SKGAqGzTarop29nyHdIkJy0Vi/2bQcz/2s2Q+a75aeF3JyZqTpv3DsM1h1gEd6YUaEf1ISy4T2RYAJrxwe85WaSoxd00O708dKKGjTtQ5I9PgLgXkkzbWi9eJvbkplTP/lrNzIsrZ/y3Lh62yvO3HVf7lmVvWGeNVlATHDPsjJu0nA9pR7/mkzkVg0kPqlOUxn0Gxh397ojmeqyGspjUtbuNkRoa5RU9HfDXgsLzmQQkfWOzSHkmXkhxzybcVaz1nUTOAIOKJJYNTPkEgfLToaYlWmoSTNf6Fw7aWSkgr+onxgPpsNc8iQw14i3Zr231XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XLsntDp9QcCk7GyS/c9rNICdOZ/NiQLSWVM3fQqRHbs=;
 b=V9Z+ttehtfqEcuikGPinsS74a5KMSKOoUdZqtxX0Ie2RBVfY/5xaeWTOPxMmFaLWskXOrcEDXd7mrsnXfNHuHXWWmI/UxO65a+Mb+puZvKWnmGzGnM4VIpiWXfiwQTFFZamG7S5654ZxTUBsi8Gf1veR6dOB0WdCsz4aQo2WJ53F5vf3dYu67roUMmAr5/RqHyucLqLEN5fy9LchAmtNGTwskGt/ms75v+K6NUKpT2L/1cS+HRzdr4tUFzP9dki35+4b8dyK1eJe8Ggd/e+epc2syPNOKcnOqUU8rc+CC4t2S7c/K0O50pB177WOzdi3wXMFVIHT5HjjSa3IbvcPig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLsntDp9QcCk7GyS/c9rNICdOZ/NiQLSWVM3fQqRHbs=;
 b=Csq1B0tnlKl5hAjdK6w8eXlQoifBKcWS15WgGf/SMIFscTDzN+Oh84U7xwcJvbHD4wyq6ya+HIT2f1rVWI9CBenRPHwzQ80ODgFzpgbQl/GmDG2xkRlvoFYJdwAee6lxPRUlg6Cq9kgE59gcGXy0+rjVflAIOTw6XysiObtNdV21KETUWMdFgoQQxhnjS3mLm6GKNwlQ2EjJjlQ/vmjg4H0F9jK09xGByK63ivXxmULuW5N5CHmrB4zuyoGPD/FU4lobx3GuRIJLAwjWmli4l3Q5fWNqf35Xc12HRLCgVNkaHZA5ea8ddm57cpZHe47V2KQ71fxKlN4OLUHe6EdaKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM4PR12MB5214.namprd12.prod.outlook.com (2603:10b6:5:395::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Tue, 22 Feb
 2022 17:17:36 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 17:17:36 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, danieller@nvidia.com, vadimp@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/12] mlxsw: core: Prevent trap group setting if driver does not support EMAD
Date:   Tue, 22 Feb 2022 19:16:52 +0200
Message-Id: <20220222171703.499645-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220222171703.499645-1-idosch@nvidia.com>
References: <20220222171703.499645-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0145.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::23) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5a7790e-56f9-4c23-b73e-08d9f6273889
X-MS-TrafficTypeDiagnostic: DM4PR12MB5214:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB521462E96BB7E06A7978D99AB23B9@DM4PR12MB5214.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: voaCgE+CXJUH7byuRQUYxoU/ktrMj551soHK2iq6rYD13IAhdT3V2ngZcevJ2M8cLoxsx/ykCYahj7uuZCzq4k7Wqvu8+bouA3aQY1OMQRx22fhCp6aDy9UvvIsM5zV+qTKKOfAHukszdYw9lPXoNvjCMqmgU7Px1NDWiMIuUuSxY3x6xrNz0fSsvIAcZGtdsDExmVx5tSCe3X78jKpH8G9ucijC2SAPDS7Kq+o+RSHzcQfy/01aDV3k0Zejfk0B0TS60DIPANgPM7hZuVJP2TqQDqmSpekjrgUGh78WUWzRxVhkBoBHcU5m/rF3VO+mmIQVRB7Cf2k/M9jm3yyeNIQllUgXkoNKs4EW2ZT3L+ynx/UfT9R64KzGqVCQ22SDu8eAxG7HB7GOw4ju2DcDjvu0zH6kVZfkl5CZPnCgqvM32YoFLvu+ugJysbemgJffFFqonebxFPY48CwcXMwSVocyOHJzJFt2tt8LlVmtCuJlekv5LyBJX7RQHL2zwk6eJSQZCxtgny/KmsOO2NO/yQcevZ5sYQapuriK4fcW8kUI9ma54VXy/soGnZIyLgEk4ATMxV8Rw5anPrGbW0sfpRlFQpj38I5AMnFmboTDLpj1wUt+cJpInUVFXtIeHYrpIZadEg1DiTl2UNOxIbmzbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(316002)(66556008)(107886003)(2906002)(2616005)(5660300002)(1076003)(8676002)(66476007)(6506007)(36756003)(6512007)(6486002)(508600001)(38100700002)(8936002)(66946007)(86362001)(26005)(4326008)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ss4c94A7RJgYRcsboOheplJCN3V/dk9jNAPzwavX5zbWInD0s1Zwy/HHcgev?=
 =?us-ascii?Q?mZQ5xf4AnGv0BnCgRPlrywU90eLG6THJBgOQ3Sz6Kds/XVn3djHkwzpgI4MJ?=
 =?us-ascii?Q?YVCI9mEKsQqzPVf5vvkCxljFZ2t5MzEMiDIBJMXcf5c8Z676XfNQJ6VbNuiI?=
 =?us-ascii?Q?piwtMaDK/H/+NTEnYV3qFXNBKFXYXWwhzmoncG/DCL73zxQzTz7sk5eWTh/J?=
 =?us-ascii?Q?OdHsBUwIcyqF7MvEE1SQf7lcMtIp8MZADE2R1V4yZ8LM9Iqc95xveco4AWo0?=
 =?us-ascii?Q?GwiD34tHB2stiR+8EViSOhtHU0SxebE5QLwzG+/DzQ/vZPjUtSL5wIJTcME6?=
 =?us-ascii?Q?9wVdLIT2QRfnFrg3bDxCs9lv50LjujJGTCed9E+p8/O37eDgNWXBJXdmV3Iz?=
 =?us-ascii?Q?+fzCABv6868Ujw4Q1LiM+34u3spSGCba0R8qsIPGMbdkB/eXkjg2+8ehZZGA?=
 =?us-ascii?Q?K8ZNQA4SydhqPUo5zVPiA+epDOJK2gsFvPQP8eixelTf0sh2EsB3z3lmWZgm?=
 =?us-ascii?Q?4uR66o9vDUJs79T4OtqsxrtWAasZtqAW3XQNVS+7S+cPJy/nu5PYhsOvjNMI?=
 =?us-ascii?Q?wlhswA8NhXeljR5l+dExYPnT5l4xbgkKrOvkJeQmkX1HS70FihX8LxiFOJS1?=
 =?us-ascii?Q?ewXnKlay25p20Tu4bkQVYolcnptLbU/Cma/U4nNXoynCg0/9GZWqMY9deF70?=
 =?us-ascii?Q?SKCrZI7g+TUGmk9v3ipLA7yxm51hqgNj3Mrt98R/WSnu+DOtsXzPmf5m2eSv?=
 =?us-ascii?Q?DJzhQk0w1KZXgpFpg6u1ckm6rY9pJtcEb5vA9gnyQKGnNMIptaaF0npcJotX?=
 =?us-ascii?Q?5LKZnZKtTKlVmZCoCY5AKhWMqMaxYzK2FhU7OmjCkoSLVUsJ9w93GzawdJcR?=
 =?us-ascii?Q?WtrvBu4HwpFJ64z5AVOpgJrSfSMYEIC8KrkcjLKtcFn3AYi1F1Dt0K0muli7?=
 =?us-ascii?Q?5OWRgZx8Q7Mr25Taq529iEZzuae5rFe+t9YEPPSPKLrYnwUzXiBbmL0/jw6F?=
 =?us-ascii?Q?j80izNhAY+E0VMQ5hOClVvHf31wA6F7wggTmgIAuirdFfoT40YX4ccvtxGWx?=
 =?us-ascii?Q?+kP2eSFrP7FmykMqjlRCKyYdwEWILo4aBZimbUsUkQ+1SSPxl0dLx9K/uhJh?=
 =?us-ascii?Q?KEutlNBN2FJkNLbCLwJPQCuSfNfjmfM5jcKZqDzRaFR3vQAcMDhkawk0Q2pU?=
 =?us-ascii?Q?ihraPqDwmUWv7dJK7RN8XZyVrvyvr9lMAQJH8srrebvFm398LAxUIC6SyEsc?=
 =?us-ascii?Q?+URztZ+VAly1KLOh51qjQ/eJBqoH2EzYCPkzQEtNiKC9MDLxpImHSyiUEMw/?=
 =?us-ascii?Q?yknSflov5HUkoNnL6s80e0b0VYgn+DFduofvqpfhAVG1W8HqIDenugqe6fjI?=
 =?us-ascii?Q?OYfUK8wzW9DehJpXQ7FgC/VlzzyavdnBOTT2tr26mmER1m5wlAZBuQIloygf?=
 =?us-ascii?Q?z/ZXdDV9bs1jxs0xWoG5kQ00lzaEdNVG93+ZCEx9bmL6S+owuF4e5uC4BVcp?=
 =?us-ascii?Q?QiqNmOSPN08NpSUe+TZVUtddpcb3FE7TDjvVNjAtKSmhjfUeBbR9EKV9hSpf?=
 =?us-ascii?Q?bJqf2cpfwvzNkLr3a/rJCDcpu8HnETsKH2hHTTuu1mWiuD2p47HkTzPPD/1w?=
 =?us-ascii?Q?T/EChhvGdAcuesQhHCqOeVI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5a7790e-56f9-4c23-b73e-08d9f6273889
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 17:17:36.3887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PRIV0vqu0LqDnLy3JO3UaAvca1AaGccz3Td7NoZj3MTXwXYpwIKpMSyUc4jzvXh3FEKbiPjIWmxBHI+rhUlTTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5214
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

Avoid trap group setting if driver is not capable of EMAD support.
For example, "mlxsw_minimal" driver works over I2C bus, overs which
EMADs cannot be sent.
Validation is performed by testing feature 'MLXSW_BUS_F_TXRX'.

Fixes: 74e0494d35ac ("mlxsw: core: Move basic_trap_groups_set() call out of EMAD init code")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index f45df5fbdcc0..1c6c1ea107a1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -223,6 +223,9 @@ static int mlxsw_core_trap_groups_set(struct mlxsw_core *mlxsw_core)
 	int err;
 	int i;
 
+	if (!(mlxsw_core->bus->features & MLXSW_BUS_F_TXRX))
+		return 0;
+
 	for (i = 0; i < ARRAY_SIZE(mlxsw_core_trap_groups); i++) {
 		mlxsw_reg_htgt_pack(htgt_pl, mlxsw_core_trap_groups[i],
 				    MLXSW_REG_HTGT_INVALID_POLICER,
@@ -2522,6 +2525,9 @@ int mlxsw_core_trap_register(struct mlxsw_core *mlxsw_core,
 	char hpkt_pl[MLXSW_REG_HPKT_LEN];
 	int err;
 
+	if (!(mlxsw_core->bus->features & MLXSW_BUS_F_TXRX))
+		return 0;
+
 	err = mlxsw_core_listener_register(mlxsw_core, listener, priv,
 					   listener->enabled_on_register);
 	if (err)
@@ -2551,6 +2557,9 @@ void mlxsw_core_trap_unregister(struct mlxsw_core *mlxsw_core,
 {
 	char hpkt_pl[MLXSW_REG_HPKT_LEN];
 
+	if (!(mlxsw_core->bus->features & MLXSW_BUS_F_TXRX))
+		return;
+
 	if (!listener->is_event) {
 		mlxsw_reg_hpkt_pack(hpkt_pl, listener->dis_action,
 				    listener->trap_id, listener->dis_trap_group,
-- 
2.33.1

