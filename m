Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFE850D7DB
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240833AbiDYDuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240827AbiDYDuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:50:07 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D645B1D0EE
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 20:46:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Obe1gsj7iojCE2JuylW1qGUYMUbaIbNqXEeq0U3WbQzWF2Vcax3UxxZTUMOFmyNaJQibwF4W+8pklXGUxOvko8sAoIil4vcdgXlJzlbZqUT/hPVOsMdJ1HShW5tuyjZAhb0tZQCUC4/TEq5diRqPk0GmRuv6tzwv//gihsYjeeHYuwfPWhvnqYU/huyXQFCVGZcmd/v6xKvhxq18jK4RdlTRm0pe7aHrc3JH5RvJvnY1CmDayeXTtGQjct4y7OcuqdaQeyxqwkhDzERcptmG6PySQhLhaBMlLoeZumfS/N7cgdQrLcX89lBOnuuWxfmzS3CpemropnTcG58azhNTtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bafL/T6A0chCxGjx9gRQqutrDMKvXgfBhJUYg43wkJk=;
 b=kJ0VajN/UQYvliQjpwNoO5OHgGZjGS4H7Q4mmAUIBT69WUqIeZhcSFInDPdqJZ6LFv4kfPWzaQMA2N4uvQSrL9Lh7/yoOv/Zaar/vD/+/RmH/XD/IgolOwyE4bfi6SnTLNXttmEDCEjW1V8U/xaYyxdZeMKq/E2RHLkyBrOcrqyrzQxhnlVE44SuO8xYnm+0bhN5mHAfX/6xVtiqP9C8pCrGFNnz8HqDtHrYbHjWP2NJFe5VHoaMqzA2RW25PzL9tK67OEgnJ7tqc76Zl8LZtsn7ksHM6QwZmNzBQo2AowQF4StHrRXiwxVZO2j5jVjjaD+TBIpKFtAIANqc6PCR9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bafL/T6A0chCxGjx9gRQqutrDMKvXgfBhJUYg43wkJk=;
 b=LoDtARmAEDFUTPRF5uaCJIcAsSe3yDnI4N/+FHq2OlDNlY5rE2Zra5PBU9YTLtpOh/JIp7V/QoFR/gu1L3fm7ylRfL2uZ+6GnRuX7YXcuSm6N9N5bMWSfXjKxpbGufX5xpAUXp9h8qkVKHEQV7B5ZUcolxtwoL52p1bw0gG8r3qnocCgLOoMfkD3KT3ld5wL5DiBUxBACIrGQ23sawdf3BCF6YHoVvCn6u2oJVITmSVhz1XwB4i4VISKy8aEIKPFZSuFDfHogw2S/Wll5cW2kzzbBR74hssTMPBbx6FwaxsrPGYtJvEnNKIDPQ0+Ld4AqDWjq2nOytwfhp2YhAOBWA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MW3PR12MB4521.namprd12.prod.outlook.com (2603:10b6:303:53::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Mon, 25 Apr
 2022 03:46:20 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%6]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 03:46:20 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/11] mlxsw: reg: Extend MDDQ device_info by FW version fields
Date:   Mon, 25 Apr 2022 06:44:29 +0300
Message-Id: <20220425034431.3161260-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220425034431.3161260-1-idosch@nvidia.com>
References: <20220425034431.3161260-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0085.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::26) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69e36f8c-3436-4c6e-0a08-08da266e28eb
X-MS-TrafficTypeDiagnostic: MW3PR12MB4521:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB4521476E9C59AC259AA7A51EB2F89@MW3PR12MB4521.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S4D+yj6EmO58Ltrq11YUopVCpo2M6gYAE9UK9/lTKxUHGvrZwwj9jLIoL0ftLmGwMn2RGR2bGMX8+lcVoraoB7V9+kg2lKdgaM75Ty4PpbZowWtYdhjx7u0Yo5NTthdhLvfvLv6yKxK83mLVtpBIa/orK5h4tLnnxYPOgx2ye2fh/w5JQtCAEP2MKTz9GEHobLPQb5K399tC8sHWst7gEKd5JoedZtEOOKxk8LfuB7shfqsYcuQvoI7CvhzlAylgB0Uq2ekeiXx7b/G6SqBSJfwgXRJu0Hsisvr6U/1lZnhGnePVpavtzcEvrRRMDyPeRBD9qYuPoMsGgWgxio+6dvR4pnSj8qCNYOHrh+JhRgxpdGOlLBtCnmfxWt+A0ilx9Ati7OatLYbB/vwr22/wdOO6/QrlpFL8C8eQRJmQRPH0SxXnawNwStY5cT2n1V7G0vo/Gv+efUemvIpbysvT7ySliEpGTPvaTa2xIwxvB4tkye/5pJYuwo9jHFAG/O6dmLuX6BshOijLiCzXDi+pT/xKSG/Oa5eRDfS0SqKUpNBSLChGzrKw4+w5VWPXnZhfqBPDy1YE48uns8kdjqsCI0wd1vutu+dIS3yj4c2tFbK385tcKVjL95fXqLlfL9w+PYn1GJUQyTsNd2pdhOk+eQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(4326008)(66556008)(2616005)(66946007)(6512007)(5660300002)(107886003)(8936002)(86362001)(2906002)(1076003)(38100700002)(508600001)(6486002)(316002)(66476007)(8676002)(83380400001)(6916009)(186003)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?79FyOTXtcLh0zlXU9Eo4+DlcgAVhvmHPiyNFiwy9pSVIb9othr/n53Uo+WMf?=
 =?us-ascii?Q?d23Frgy7/zMq9X0sUP7PS2YWESa6Epr+OiAk/oZm/uwQW2qm0snEZe/DTuNk?=
 =?us-ascii?Q?90NgP0bcgUXhpBbh5QooX5AnHUwEbZJ6RiP3Zvzli2crKd7HRNyEg9K1SDXf?=
 =?us-ascii?Q?zbBnz0xDokH1Vl/y1WfTSQ1Gz1RiUYaKsR5Swcrg4Bf9cCHUJySjcRAK5uHs?=
 =?us-ascii?Q?l+pYv+BWwNqGxW4hB7ao2AIoOsYtWzU2guQ9xhpsaajaSyCmjTsWhJlOyVku?=
 =?us-ascii?Q?PRnl8zcYSSFsl/foC9W3FV/4gqWr2+C3EvQptCIXZNTO1NYBNNuawHvcDjZN?=
 =?us-ascii?Q?P4a/8/1cMKGU0Hft6gSptdZvJwcxdRvGE6J55eKgVTnrfsrE+vgrVI7yIET/?=
 =?us-ascii?Q?m8G8UPH+55vI2GvdlaImqdNKnJYJ1xs/0y3C3/sT0ywiQ2aeTQh+Co0Lzpqw?=
 =?us-ascii?Q?+GUeYV5KAVw/N/EuybcRNzCszPkP2JbBsOMRr6XSI7zwUwqksm8i65yBi/AQ?=
 =?us-ascii?Q?i++7XYkhX7nBsTlgZv48bZ0myPYCthWlJvkcu+mM5H+6IlfTIlr0a6i2hU6/?=
 =?us-ascii?Q?Pek426D8pUEFQQFSQsXeTA82Z9vcLCCTHeKGfdufcW79345wMZFBJvgQX9sM?=
 =?us-ascii?Q?x0vc7AAKDQ8/5Zv8w5RU4gh0sOyyHNAbWm36w62r/ZJVvNP049Dtng+4cm5z?=
 =?us-ascii?Q?ST86n/mvRp8sZe+x1lsCIfVEh3lzDEJlHU61lcQfJxDaMlxaqCK5h+xKHP52?=
 =?us-ascii?Q?SDol0jBI9RHdkr+YpPsWxY8iarOjrG6uWNfAAqarkFjimaqax5GGyp/H8Ov8?=
 =?us-ascii?Q?1ZW358wGtqbVVGQ9wbaduI4saBAGaxsQ8JNCGYc5nWTbHOczUgLjxIEr9qCe?=
 =?us-ascii?Q?rf0y6zozwDKRDhg/EvOuZXzxSh783UQzkZ7ZWm6MfJRSWW+7cUWjGRODhw78?=
 =?us-ascii?Q?llmb0tewdQfqUxM+TACRaChoiHiMnv/rTYU3CeU2OUc0JJC4l7E5x/Rorj3X?=
 =?us-ascii?Q?4wfTRlYyUY5wnrfVPT2GGcIuuhGF7rMWj6f7+7R8OXdSWQrc/sJ9fcxbmQHd?=
 =?us-ascii?Q?0ADQSuapjug8sWp6rBrEzhdEP+QpVeuR7BsXu/rbsCDqIKZvrgl2PW99GglH?=
 =?us-ascii?Q?Zyh1ET/aGdkPKI07lQyoakgeoJlLpJwawsbZf48UMldfk7iCZ/OYChcOff5Y?=
 =?us-ascii?Q?XSQWFHyiLNftwOcIDD3Ah5RQLkvtr4XEkFPEHt2Z/IuGYa71K7BkF+c95FaR?=
 =?us-ascii?Q?PDniCRTXRl9Tv3gZspJc5MFSbM1iitbeEXqjy6hyoOUviqJIBHDEF6zSsjI2?=
 =?us-ascii?Q?IvE200lp3q4HOjCQt5trPng1Lqg5egnzGO5/aWvylRdG66PRatcRJVTAiPe5?=
 =?us-ascii?Q?9IrOyQiu6d4wDuQFB1Qi3oI9zDS5ddEQpFNRWyU85C75BruznhvV3KktfkE+?=
 =?us-ascii?Q?nX1ONe6aRThLoXK3IIEIkq4vu8Or10HsUFoOTac8tnKSCwBD6RBvJ6jGJ9Ti?=
 =?us-ascii?Q?NDGv524za4QKV1jBDl/S5k45NjyFjXUC5Z94u7CIl88iduGLFE5kIKYjcDXo?=
 =?us-ascii?Q?erNrmz3zoqIFJVwrcGd/bNGULkQRVXpGbLrv3J3+cBGk4LeWKC5WPvq1ao6G?=
 =?us-ascii?Q?sVVw/cqyvOFh7vubfHXGx7rYz2cpkQT1PVHFdk5mY2mSzoeqWDwFNo0HRmuV?=
 =?us-ascii?Q?zU2qoaXfPV3JoI4eUzIqWc8z1qchojlYUPI01hEn/nvuO3yx8F0niS+INxBp?=
 =?us-ascii?Q?8AmzT5XrAA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e36f8c-3436-4c6e-0a08-08da266e28eb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 03:46:20.2346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ffd2ylnok8VkHatqBzdN82Tz3IySR84LDwSj4fKridHAPkxJt3XapWuME/Sw6syMDM+fnQheGLlOPSVO5v3jsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4521
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

Add FW version fields to MDDQ device_info.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/core_linecards.c  |  3 ++-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 27 ++++++++++++++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index b5f5b31bd31e..42fe93ac629d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -160,7 +160,8 @@ static int mlxsw_linecard_devices_attach(struct mlxsw_linecard *linecard)
 			return err;
 		mlxsw_reg_mddq_device_info_unpack(mddq_pl, &msg_seq,
 						  &data_valid, &flash_owner,
-						  &device_index);
+						  &device_index, NULL,
+						  NULL, NULL);
 		if (!data_valid)
 			break;
 		err = mlxsw_linecard_device_attach(mlxsw_core, linecard,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 521c1b195a3e..04c4d7a4bd83 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11782,6 +11782,24 @@ MLXSW_ITEM32(reg, mddq, device_info_flash_owner, 0x10, 30, 1);
  */
 MLXSW_ITEM32(reg, mddq, device_info_device_index, 0x10, 0, 8);
 
+/* reg_mddq_device_info_fw_major
+ * Major FW version number.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, device_info_fw_major, 0x14, 16, 16);
+
+/* reg_mddq_device_info_fw_minor
+ * Minor FW version number.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, device_info_fw_minor, 0x18, 16, 16);
+
+/* reg_mddq_device_info_fw_sub_minor
+ * Sub-minor FW version number.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, device_info_fw_sub_minor, 0x18, 0, 16);
+
 static inline void
 mlxsw_reg_mddq_device_info_pack(char *payload, u8 slot_index,
 				u8 request_msg_seq)
@@ -11794,13 +11812,20 @@ mlxsw_reg_mddq_device_info_pack(char *payload, u8 slot_index,
 static inline void
 mlxsw_reg_mddq_device_info_unpack(const char *payload, u8 *p_response_msg_seq,
 				  bool *p_data_valid, bool *p_flash_owner,
-				  u8 *p_device_index)
+				  u8 *p_device_index, u16 *p_fw_major,
+				  u16 *p_fw_minor, u16 *p_fw_sub_minor)
 {
 	*p_response_msg_seq = mlxsw_reg_mddq_response_msg_seq_get(payload);
 	*p_data_valid = mlxsw_reg_mddq_data_valid_get(payload);
 	if (p_flash_owner)
 		*p_flash_owner = mlxsw_reg_mddq_device_info_flash_owner_get(payload);
 	*p_device_index = mlxsw_reg_mddq_device_info_device_index_get(payload);
+	if (p_fw_major)
+		*p_fw_major = mlxsw_reg_mddq_device_info_fw_major_get(payload);
+	if (p_fw_minor)
+		*p_fw_minor = mlxsw_reg_mddq_device_info_fw_minor_get(payload);
+	if (p_fw_sub_minor)
+		*p_fw_sub_minor = mlxsw_reg_mddq_device_info_fw_sub_minor_get(payload);
 }
 
 #define MLXSW_REG_MDDQ_SLOT_ASCII_NAME_LEN 20
-- 
2.33.1

