Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54D44C0006
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbiBVRTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbiBVRTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:19:20 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55FF16EA99
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:18:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bw/5cy+pwPnFwpBooK/Weha3t1S9NzyZ60Tfv01jYvuLc8BT9EwiVGmyDAb2hsS75+PlfeoV2kx4CmWDyIv/U8RjoKC1oOqs9rgfcze7Tiqq7Fr06hzfR5i06k1qHZ/2R+H/zJrwImg9B7J1dpX4bNDp+dHclRx6gd7CIuy8TAKM8x93XvIdbxWZHEzlXnqi7uo9pliYJjPpshjmk7fkMxpu/5zndEBY1n7IM8D0NdOzGcoDjDC0ej5oLVX267GC/Edu+eeH+9NnFSdYug/86KwQY54H/qJ7SrJmABHC1QRtiB6BSg4BF+HABEhaS3CpBZpcCXbwlHnAjyPhhmUL3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nkhIVlWFF+jAWGKUfQHdRaOYtVp2wg/6SfOM2ARXFfQ=;
 b=ZExs2WbqXV5GrEwkt6y2+FFB2rlMCfbaSAfNhqcl5tPtmkA7ikFQPx1nAh7TnYHe1Ug3kUQ/B1rsKi7pKYr0wj0hKVHoPesNe+pnlJGZglBycB5mk+tVyAGIJGoRKmvyKCcWA4rjrmnfjmrEjrp5o9MoR2umvl4wZbBWmD7UvQAO/sAbL25QIBBQ6S10FZGwJMf/SH6cBWhjfbBl7rMjQI6kuZuyYpiOpQe71ttINlgpPR4JpbNYr9MuJ6LItsl62WrwbPr9/+xqGGNSi9cPLqF/cBKAdLH0rJYf/q3RKduOnDw0CFLo3mfNXkelKiT5y/AkAsARqhPRzODYlGav0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nkhIVlWFF+jAWGKUfQHdRaOYtVp2wg/6SfOM2ARXFfQ=;
 b=sy1My0yee6+XQW0A4/f4ycok3RhyYB1syWNO03dg8anlUYgCRlEm4MoABdsgs+wdzqqbB4aj3+V4A9uIMQV9eQwqNF8pIvH3ZyC9BuQvUZRrUaKG+Yi/I8TP9GoTelJPnz7vQWCgFlkezPGmIyiIL5ZwJ98OxH4whfUsWCA5fcnl/4cfuZ4vdW7eNEA6WXNvb1GU0s2MCBMJBLR5VCBHiEshg3b5vxOSsmdLzbCclhrmdGUgdOJ5dIZvemWMWTVCWD/ic1KAoIZ+Vl7mZa/M7CKroFV2oz9Unim3qDVekW3RTwGMe4RXRl5FfGaC06+4aM8JiUDrKWp/lFQrKPOFLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 22 Feb
 2022 17:18:51 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 17:18:51 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, danieller@nvidia.com, vadimp@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/12] mlxsw: core: Add support for OSFP transceiver modules
Date:   Tue, 22 Feb 2022 19:17:03 +0200
Message-Id: <20220222171703.499645-13-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220222171703.499645-1-idosch@nvidia.com>
References: <20220222171703.499645-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0047.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::15) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c06cda21-0c44-4a3c-a07e-08d9f627655a
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB426260087FB53E97D974B07CB23B9@CH2PR12MB4262.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AbyVgER0BklPpgxbEPWtYXn9d6bEqplAuCxGiR9l+tMQdQwk04n9+7YEn8s1IbYrDr/uT5xAkQzkvL5wcf78Rjx4tMjLvouaDZoAzooLbS1Dp3qYqBrHmvs3Wblt8h9YUP4PgwCv/ebe5Ob86fhdiB+TASVkjTTuRO3hYKEVDhFN3aJSCw17qSq0JSBUGBqRXk5rHdOWmTGV7cSiMHS0mDcThSCiPj6H52kFs7py6sYSWotFsd1X6z4pAb3XZ6fiqnB+fekTqf5uPY81nZ7jvQY0AqZCmvg8IlnvER7LUSVQlfQ8xyukeEd1Uy3DYCWuDJKmZA7z6kpEbYYNQUBbgak1JFJUZ7k/C6GbCpnJSvpQMazAHO3NOlCNpOmabOvvS2TpxfManLkFK3ZRKZQyoiFVS6jor1bRP8+LVWTd0PESw1O77zBzxD9zgr4LiTzU3jQV4kzmcIDvX4ZKBdzLJL8qa4KwmKujEd/qhgG8rQmtjrSiiAANOPodwutH+HMKiknC35EF9fAky3AcsTxJT+5gEcO0WxFo64Gm1YOVyK4AuNSKQcloxjMPdoMAA5CNHIfluj5RwCCH5lGNKMlxx6Kfrdnt9IIdUsjrpdr+N7wLzEYuhhxOwjnmxeY8iYqA9ZbvyoSuk7wqc94fA6REOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(6916009)(66476007)(83380400001)(508600001)(4326008)(36756003)(8676002)(6666004)(6506007)(6486002)(5660300002)(186003)(107886003)(26005)(1076003)(86362001)(316002)(2906002)(8936002)(38100700002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MpZUsGW99XeCGcN/7rwjt6tuMmquZCXbCHY0f3Lr9XxiQPfc57AquxeCg+OD?=
 =?us-ascii?Q?GeRg8xyFz3JmCGaFAnvB5uKGsVgS5IsviATi/xDIv3UGGV0Vwy3nx3JACDku?=
 =?us-ascii?Q?JFfmrwcnmQjsgVFUxHLCU8NUsARnTcunQXEN9SZLO9Ov29Iyq77x88bLXVSr?=
 =?us-ascii?Q?PhSrZM7B1k4TQ8XZVqEcTAcJVKKhG/aJCoxwOlJQ5ghy42d7GBn+cf2ldnP+?=
 =?us-ascii?Q?Zby6rOcbEOOjAciW2KmwTKZ5P240RpniG5rO2su+xWacxzuV3+Z8iWIkw877?=
 =?us-ascii?Q?zibJQCCUh8VDCThCAHCY9P1a/ZDZRwl3rAdOWjzvXNADSXoGvDlhVVynOeNQ?=
 =?us-ascii?Q?xalQOzTgzkv7+yA8kZWsXoXPuMKK3CGDgfoox4YTH7CWNSgW4CUuogpzcZ6W?=
 =?us-ascii?Q?druE6f4FuYp77YdIycfX6uclUa49UA+tc/UoGyZT09ouUO/vcH9+NAjTq1+j?=
 =?us-ascii?Q?UvG4rwL9FJDe5BOOooTYmq32W3GyUyLT/AkjPJiMyJQvzUCQhVCGGznu1pLy?=
 =?us-ascii?Q?AlVKOf/UKNyR8x+AUIpVLZEU36qauMz71UWKEOS2qTsfzLayC4o2vgZyq/Eo?=
 =?us-ascii?Q?ojwCWDZqfeZV1DnEzi3fEYDJXcpnmq6y92LgTamWd5qoCI8aIlZDe15c0GE9?=
 =?us-ascii?Q?4KzdviDC2VS6/uzUXtTLq9hObtneMJHdCTJEBYu28+5dFn3pW+QS1Tx/0zuz?=
 =?us-ascii?Q?qNM1pPbzxAGmfTnaHIo1nKGWn66hL5FcfIbMMs/MJ0cFnJT+Bv6fimYAzrL0?=
 =?us-ascii?Q?OdMsyHYHsifHI0oq41xl9ua2dlJntx5S4jaVAZCjDPGo6EKxaRH74ft6bt+A?=
 =?us-ascii?Q?QULxqA+mZKMDtldCfOYFP1/b2WluwQQwWuUUToSDZAeIhgN6Nws2OVB2vZYX?=
 =?us-ascii?Q?GQ/HrXjwE+UameFReqPlumUQZ4P3q8R8hCNIY727jL/bTdXvEzxTSa9stXs1?=
 =?us-ascii?Q?37j3NHwOvEo0Zbai/XD/WC4RaUPBHhePMxQnkQKp/JU7bZKeaR6zFaKBzHHy?=
 =?us-ascii?Q?SvBSma3N98+HIkNh3hGqhu8J3wrWcQ5GDbg/Vys+7Dgq8tUT7SHZX1hAJYT4?=
 =?us-ascii?Q?Hj2cmG7ZTRpc0G0Ly0Y2BwO5Mx/8uTQX3Fo87RAgnW1nDWLa53N/9E3SAWEA?=
 =?us-ascii?Q?Tx36c9bPFoQW8Td+myXJo26sjtF9RS7G8yOUq3v+20EbQlg+I61oJW8EwNP1?=
 =?us-ascii?Q?io5PeeGWLpkgKsYOwjE61FVJtY+zG6W9zhjDaTCloReP8/jY4qLrOwyL9wvG?=
 =?us-ascii?Q?/awrA0bcDADOcV2MifNIrlFoBIHOqEkeMv3sSEMx5P31KD7OfH7SHAlSKZn9?=
 =?us-ascii?Q?0xnbgnkJEPMtpGhpcmW7MlAM46ELqNxfCEwZmIjyoyzen7jL3+ETRJqIRneM?=
 =?us-ascii?Q?ZcLhLLkqTgtrrO77UqDkBDgUNrw8nbNQfYYBRIMsKQ8ktrrtqRItAtPc9LT2?=
 =?us-ascii?Q?Yn0p/RDF4vDOsm+8aTxKyWLQNyjotEWohRRhLHe1imlG11tRE/jxPigBstGh?=
 =?us-ascii?Q?4OaEk0wVeZzWwLKcv3MsjU6qvYbJmeRP4ACLSxz7AC0sr0FaezGh8V/l/jpv?=
 =?us-ascii?Q?ZvoFa4Bg+tSbxO9fbZeDF9rXRrvEoeAipPgLd7CcK/fMBpYXaSYfOPLr2+Ef?=
 =?us-ascii?Q?6uh0WE0tQRsVav+s69NXRYw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c06cda21-0c44-4a3c-a07e-08d9f627655a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 17:18:51.5324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HYCUzpSNp2ULWhgEUbc/sY+YKD85jfbpJlDIRtc6yo3l6gnhfo98jrUm7eq9jDoZZqkXQHbOjydozp6VZ5ZwNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4262
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

The driver can already dump the EEPROM contents of QSFP-DD transceiver
modules via its ethtool_ops::get_module_info() and
ethtool_ops::get_module_eeprom() callbacks.

Add support for OSFP transceiver modules by adding their SFF-8024
Identifier Value (0x19).

This is required for future NVIDIA Spectrum-4 based systems that will be
equipped with OSFP transceivers.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 2 ++
 drivers/net/ethernet/mellanox/mlxsw/reg.h      | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 70e283d22783..29a74b8bd5b5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -87,6 +87,7 @@ mlxsw_env_validate_cable_ident(struct mlxsw_core *core, int id, bool *qsfp,
 		*qsfp = true;
 		break;
 	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_QSFP_DD:
+	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_OSFP:
 		*qsfp = true;
 		*cmis = true;
 		break;
@@ -303,6 +304,7 @@ int mlxsw_env_get_module_info(struct net_device *netdev,
 			modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN / 2;
 		break;
 	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_QSFP_DD:
+	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_OSFP:
 		/* Use SFF_8636 as base type. ethtool should recognize specific
 		 * type through the identifier value.
 		 */
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 1f0ddb8458a0..dce21daaf330 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10037,6 +10037,7 @@ enum mlxsw_reg_mcia_eeprom_module_info_id {
 	MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_QSFP_PLUS	= 0x0D,
 	MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_QSFP28	= 0x11,
 	MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_QSFP_DD	= 0x18,
+	MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_OSFP	= 0x19,
 };
 
 enum mlxsw_reg_mcia_eeprom_module_info {
-- 
2.33.1

