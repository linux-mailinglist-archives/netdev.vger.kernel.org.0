Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4283C50D7CE
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241010AbiDYDtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240984AbiDYDsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:48:52 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11FA19024
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 20:45:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/NVcFTKUgJowGfTFDHKwaEyU1grNqxJk9mheowePwGVEN06H4EDy+ikah6UxIFNXSaki904aTmNUWXEinPLZzKB4gLODGVMA0dJrNtmx9SvFGnKqRTcQdRG/9Dzd4QAOcasyv4ReJFQR2FyKDjM3V33F0WdK9iIhT7upeoM00u0MO7mkbu+DeuyHHqoFW24ddAlCJnadVWJfPP0uZIZlp7n7KNblxPJfMiCRy/Emp9AmsQaOR8hu99o0+cIDHNT5FmUuhyN6dhaS6eCQi4STVwAXMVu05zgZHlUIQ5rmOT15iW57hqt5tOsfxuG53eV5Zv7WK3868fLxCK391XL5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iPZK+r4l1krYXRnt4SBgIhRUTlfLb/IHVCbc3m/CHsU=;
 b=AkCzCb1unJh54FQWH36JNCZTaJlDUXlJMPHe3Zq3q4l96PN9ZrY6RqNzeunL5BI1xsuOcpeL4C/O1hS86i19MQN36yg1RZmuQN5GtrDVYOv/A2kzX9j0qFuNSE3KpnSiD3EmZQ4CgF36WnepKFQo67wgR0M4/DRxSzWBzhN/3hNNuEa4aHVT73Rya4ezwJK7Dl8rsJwgqaC9Ezp/DWyZUG4Xqo3M7izLtl0mFrWoxXGf+6ABgLwBpIMV4pVGE9GaWhIWJrURXBFr/G5LQzCUEC4u4HOC4Hy1sVYVta5zJAuxtg3BJ364DLL056IjnufggmmbBWpMp1vV/+yyCiXZ7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPZK+r4l1krYXRnt4SBgIhRUTlfLb/IHVCbc3m/CHsU=;
 b=sxN3IMhDvD+x4YHLVV/Xs3Lm5g1aE1jvSqSIgS270J5ZK9nkSXGuJQy4jFtAP5ZrbZzvGG57IF/4cQ5lXU1iVxwTdwG5SCXmbkAonUmom1835u/oHPofK/NgQrnvkf6saT4t/a+Hr2tgWv2qKvnTsMLjUC+xAVGbX+Iqq/AntTSUGRDK4zQ5HvF7teNPmG8z6+oypD+stmwLl1c+rAJRFMgeiumQs9Cj4bzdvkTUkYdoF3z7Jg9BZRd0k3n4xLsVTTa+z72sdjxnYiOtJayuukQct6/Yt5KynZ/mnj11eJPaheJEfrP9SZCiVy0wVZt3MN7dni1tuFbQqPCygUOH9w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MWHPR1201MB0255.namprd12.prod.outlook.com (2603:10b6:301:4f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 03:45:48 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%6]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 03:45:48 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/11] mlxsw: reg: Extend MDDQ by device_info
Date:   Mon, 25 Apr 2022 06:44:24 +0300
Message-Id: <20220425034431.3161260-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220425034431.3161260-1-idosch@nvidia.com>
References: <20220425034431.3161260-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0248.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::15) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f053c2d-4098-411d-f275-08da266e15c1
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0255:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB025589679C8B31F94EB94573B2F89@MWHPR1201MB0255.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qUBQVP74MYPT2VOHQ/kkBEETFR7V5Do+Vo9HPtef94+QuXY4OVqPrFpQwtpKuAsGKnyZqHLjBvcSOXn6i4NMYWamKpzBzyVgbPW+kxuMPjHDomqEAM6+i/iy1EnCZRs4IMELs9NHNbRCE3RncQx0bCIXHt/eLj9gNLvYQe6p/QSlaw40V3aNBEtMobSkitXpy2H0hH1O/BBHHr3d0qw30F6FlvXeAf06niGL9S70Ck6LLSnGgTewkLCO6PCEBQwwpwugxl5bGoeHq6P958ZdeKgNpKTUSUlGc/dnTCIQLg5z1+5T+KfxP9HtBqL3pPlT1UgfqecDksHHcaqZFdjJbdXTGlYHhuJa3hUXCx5hSI9BinK52+eSyMrv0/QpU11/+g9d1cMW+edEP40jXya/FDBedRy+HRUVzZVopo8bXkDMGCgZYj1RtNm3+4BxW9OOtUINMbwqzu9fa6V5KBdoOgnW8Ka8jkfuyG2NVTCs2aJ/vmOsYzIi/WP7Ckp3NEbMk+nvrhg/zq72imfrc3AEplBlq2BrG+bRJiA15gWCBR7Gky72xTkC6E3rolRh9OdW6urbIqubUFkS5UKnRj6hnjCHIwuKOGWR0jjTW5adaZXgCk0/gzM/5/ShGfOKIgkxBwJtnJImtZxCY+8K8FktaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(316002)(6486002)(508600001)(8676002)(66556008)(66476007)(86362001)(6916009)(38100700002)(66946007)(5660300002)(6666004)(6506007)(2906002)(36756003)(6512007)(83380400001)(26005)(186003)(8936002)(2616005)(1076003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yn/klp+0Rp68UhuP24C9p5lqEgYbtK+nBmzupie00jAU5XE9FN8Nk947UjOT?=
 =?us-ascii?Q?eohZpcMVIVSG/V8vHCRv4KsER+3y9llUyKme5jJulWv0WKrAXdMJfLmc3wNG?=
 =?us-ascii?Q?qHNAOG4ohev24m8U21wm0GAwIbou/LLaSQH0l9xwLN9sCWVpLuyafMe54z83?=
 =?us-ascii?Q?AT7ixWIazQ/5o7fRSOR3SEII6l7DCd/PlKFCrEbQwRETyVx3+OHRTIk5GZmi?=
 =?us-ascii?Q?R1ua8uoOt75pv6mCQueURuUVY9APVqUWzxz9tJunhCrKQi16C/lu6g2qL1mh?=
 =?us-ascii?Q?pWQPiFZqndnVxT6SprxFNPJ+67hiO/vRYFE0eC6JM5DSWwcih329Y6fn8bQq?=
 =?us-ascii?Q?QS16eCCJvUEcQr8xxvVhmY9fYn3+43BqxC4UWPzYp87/dETTItXmRpx28MYB?=
 =?us-ascii?Q?ASuNGY5K7zLfQ0tjM36ijUw7aRm0Wc470ocGZXfebH9fDoFQe7c+vwHNJpSR?=
 =?us-ascii?Q?+5FnAOmhS3OQLz92EENUnsHpscmHHiAzN0MOK/IrDLMk5YvQxR+/zJ3yAk+u?=
 =?us-ascii?Q?tSFa4vor+ysPc7pGPTWn9HDsQYfI0jD/BdYmy6g0Sf9HiFzA0vFr0zEdwSYr?=
 =?us-ascii?Q?yPCdyTns7SdsVC56P0hlCRkChMUfh6p2oWLPqhooWsxJaa11xNzqMy+io9mY?=
 =?us-ascii?Q?im9DQU9vy3J4cCT/4K7TbfdPxbfT9VDh2nutkxNk63Pt0SrAHh5zCnQhixxe?=
 =?us-ascii?Q?SopVYB9EhoJpNjqSucCITIuAVfmjVyjrgRCoDovY/ewga/a1tZbH1faTTB1w?=
 =?us-ascii?Q?iaaIQ63NLSlZtajrmv8aDSA3NbLIJSyef3yeaZ+NtWuJ36PJpg7P7dMjV68c?=
 =?us-ascii?Q?s3iBmGfSdlzv+Yr1GTzo8Qa2VOCduiSXwzgXq+mNvUAH9UsliEYLl1q/04xx?=
 =?us-ascii?Q?xKq6KZBqj0eGMjodlev6srzjsKswJAQxFmNk2widWIL57vJVnxnKF6qqT1EE?=
 =?us-ascii?Q?oldahky9am5s6nnVr596vEr4okre5y0oFhvRY6lR8oGRFWCIe3BGUvQW8RDX?=
 =?us-ascii?Q?D/b5uJy+18r53nX53P6CVpq5Bq7/E3PIzJFS9i0Y5skLbfVxB95i8p1/oPuf?=
 =?us-ascii?Q?lsrfSAKJTweqcjOWVmcr4rgVt+EdhPnUI1zSDwvJtm+FuidIogyDZ+8UE+Ah?=
 =?us-ascii?Q?7NfhughUSKbTUqCNnGnZOc5YHW4LJpFowyUVCYAWdc9/hAuXQkKuQoYbKbmQ?=
 =?us-ascii?Q?Ah+ym38Blk/0Fm/+ZB12/82fX8x+Df25oJp84KCByrSz/m3V4yYrRRl9z6Uq?=
 =?us-ascii?Q?ZrU0B2T9TsudEXYF6BhT0Ell510nfGGoKDlOdq+nxQbmZy+hQOrq9atpIzSz?=
 =?us-ascii?Q?Axv98LYXeHIqTYl426eGyqsJxidguhitxnVvAh1bYABUvC2eLxkIjcQ0t0nN?=
 =?us-ascii?Q?5LYl4bXdJUpU2RPmdIfqyxXXJXrsvi32mZp5w9hArS3TyUX/1qTE8v/8lWRE?=
 =?us-ascii?Q?rsUMiQBxOX6N+ZBPhPGh7L/ZV1jFZR6MK/nbbHnE91+n+MAOeEKzcPJZ+UFF?=
 =?us-ascii?Q?NTvr1dKyAMyqKsudhtEx75YfBhu7apr82AcF2uZMN1bpQBnORM0sNzd9i4hL?=
 =?us-ascii?Q?+mXWMHu4wNpkTFTR0qZhMHwaHOReg8bYqCXijfCwXraRt95Md5JZkigXqPYf?=
 =?us-ascii?Q?+Higd0CLfq/pMfuIpXQ+WtbeOWfpmcqmcaiZCxRVZscEDfDZvnc3VhyuQawC?=
 =?us-ascii?Q?IjDrFM2Ec8uows1rx2pztYs8IlxuzfjD08M4qqRyuHr83z/1Tpf65fMTe8gV?=
 =?us-ascii?Q?D53StcnGdA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f053c2d-4098-411d-f275-08da266e15c1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 03:45:48.0730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GWjDEAs61Kcn2XB0dozGH4eMDKmMRp9IWgC1cqaRHTStlBm6oz1hxsQ8Pk+e9MpCzT+qSLdMsmzxZchS1HIy3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0255
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Extend existing MDDQ register by possibility to query information about
devices residing on a line card.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 62 ++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 23589d3b160a..521c1b195a3e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11643,7 +11643,11 @@ MLXSW_ITEM32(reg, mddq, sie, 0x00, 31, 1);
 
 enum mlxsw_reg_mddq_query_type {
 	MLXSW_REG_MDDQ_QUERY_TYPE_SLOT_INFO = 1,
-	MLXSW_REG_MDDQ_QUERY_TYPE_SLOT_NAME = 3,
+	MLXSW_REG_MDDQ_QUERY_TYPE_DEVICE_INFO, /* If there are no devices
+						* on the slot, data_valid
+						* will be '0'.
+						*/
+	MLXSW_REG_MDDQ_QUERY_TYPE_SLOT_NAME,
 };
 
 /* reg_mddq_query_type
@@ -11657,6 +11661,28 @@ MLXSW_ITEM32(reg, mddq, query_type, 0x00, 16, 8);
  */
 MLXSW_ITEM32(reg, mddq, slot_index, 0x00, 0, 4);
 
+/* reg_mddq_response_msg_seq
+ * Response message sequential number. For a specific request, the response
+ * message sequential number is the following one. In addition, the last
+ * message should be 0.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, response_msg_seq, 0x04, 16, 8);
+
+/* reg_mddq_request_msg_seq
+ * Request message sequential number.
+ * The first message number should be 0.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mddq, request_msg_seq, 0x04, 0, 8);
+
+/* reg_mddq_data_valid
+ * If set, the data in the data field is valid and contain the information
+ * for the queried index.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, data_valid, 0x08, 31, 1);
+
 /* reg_mddq_slot_info_provisioned
  * If set, the INI file is applied and the card is provisioned.
  * Access: RO
@@ -11743,6 +11769,40 @@ mlxsw_reg_mddq_slot_info_unpack(const char *payload, u8 *p_slot_index,
 	*p_card_type = mlxsw_reg_mddq_slot_info_card_type_get(payload);
 }
 
+/* reg_mddq_device_info_flash_owner
+ * If set, the device is the flash owner. Otherwise, a shared flash
+ * is used by this device (another device is the flash owner).
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, device_info_flash_owner, 0x10, 30, 1);
+
+/* reg_mddq_device_info_device_index
+ * Device index. The first device should number 0.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, device_info_device_index, 0x10, 0, 8);
+
+static inline void
+mlxsw_reg_mddq_device_info_pack(char *payload, u8 slot_index,
+				u8 request_msg_seq)
+{
+	__mlxsw_reg_mddq_pack(payload, slot_index,
+			      MLXSW_REG_MDDQ_QUERY_TYPE_DEVICE_INFO);
+	mlxsw_reg_mddq_request_msg_seq_set(payload, request_msg_seq);
+}
+
+static inline void
+mlxsw_reg_mddq_device_info_unpack(const char *payload, u8 *p_response_msg_seq,
+				  bool *p_data_valid, bool *p_flash_owner,
+				  u8 *p_device_index)
+{
+	*p_response_msg_seq = mlxsw_reg_mddq_response_msg_seq_get(payload);
+	*p_data_valid = mlxsw_reg_mddq_data_valid_get(payload);
+	if (p_flash_owner)
+		*p_flash_owner = mlxsw_reg_mddq_device_info_flash_owner_get(payload);
+	*p_device_index = mlxsw_reg_mddq_device_info_device_index_get(payload);
+}
+
 #define MLXSW_REG_MDDQ_SLOT_ASCII_NAME_LEN 20
 
 /* reg_mddq_slot_ascii_name
-- 
2.33.1

