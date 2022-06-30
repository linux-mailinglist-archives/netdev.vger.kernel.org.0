Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2689E5614F9
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbiF3IZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbiF3IYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:24:22 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF59102
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:24:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EexBIlMR6jgzXCfstdETmZ6ap4EkuaUoYbAx6fHR2bxcUFPpXHzW/stgBk5z3ZlMm1LH/jxIes3dCKxvSVZDTR8kYB8aPEcBOiAMX/cx/vMRDOu1Oakilx3tNUJUktpl9N+pi8etCJcBqJNNncGiZMGjqjmKmeCnQV3bcLeYNtkFry4295ci7/6iNdl7uAnTcE/C4S6AHmfkUdsU38/B8Dc8fe47NSk7Kzfy8Ou099FFIrZn4Rj154VTJmniwVBmYSnLjfL9mt8OlB9/wGBbyludoOX81+WxZQMujH+ZIZ8YWm+gOCHgTXSs6QbkxMXH/JqwekuAjKx3cOLVcUuEsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pAY9bdJrKQVa9FYFtogwrVTSIUhBUBzO15JNbcf5CuY=;
 b=E2zfIOu5iwqdS0TLTqt6G2kmLZFqAsNSpdXWnoH26kZ7VacUp3ILUjLAgRUwcDnWnyxggnirIWRO7JhfQuaDRtzJnjx2j3q1tJm60vtKtdliH4XWfGsI3g+SF55Yqs0SkSyKhHAwXcSAgvZOfywTbaL/OhXI1UVzLI+cmgkAkdTYRi2d3saB3uxoVK2yF6xcMN/+1MW2rKRh4tTDZ2jYE7T5AKTByYksuD2JNeeBO5pKEQhM2FLA/nH2JBOqBMRHumfFLzufOYFzrpn6VZHcKtvp2VsAj8KzpBiWrFuBkxR9KuR5nlAbPnHxsN3KH6GYu08sH3dqr0fHiiJhup3HiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pAY9bdJrKQVa9FYFtogwrVTSIUhBUBzO15JNbcf5CuY=;
 b=ovemy9lxqT9jYwHRUa95mbpYYAuADGPee/u16qDLyr0teRtbBlfO5YOzdMtpvpDp88/q0q4WuM+6cJPNphsPIbvW4Kie1PBeV94WbbMSoLsM6zmtoA28KRnumN25e5I7UpkYeAF2FVa3ETPrbvIi9uWq/evyNlMcge/w68zcSDr0GWJ8q4drqVMe6devKVnjIbNPVH/PB2eMzo7mjJ2gztfzQL/52z7LDSKQy9xYXWtrK1iubinxCAynhFIZwaavXUYT6MPrx7QYSgS6gGGgdRfL8zRPGmDBuYVXSyNrt0XsYIDA9CC5KIDHJae0xXPpEDAXCR7TkZIvh57O6xGwgg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB2880.namprd12.prod.outlook.com (2603:10b6:208:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 08:24:20 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 08:24:20 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/13] mlxsw: Add ubridge to config profile
Date:   Thu, 30 Jun 2022 11:22:54 +0300
Message-Id: <20220630082257.903759-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630082257.903759-1-idosch@nvidia.com>
References: <20220630082257.903759-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0047.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::36) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4df046d3-01a9-4026-e3d2-08da5a71ee40
X-MS-TrafficTypeDiagnostic: MN2PR12MB2880:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LJDysGl6ZOX6/srwWLv+3VUPwEhUxu20Cuz0vzh29y19W5hTfxX32zvHet2H08mSaW9Jo8iG+lbTNMKB4xLvfUg3tpRsR4tkLWSk9VhB/f7y+/e8kNk0Ot/FUEBrXEWd5R24sLrn3mFiqQ0p1JyAgjHhKfeTEumjS2mQHnPXlueZbOdlCDiOd7JJiQav2lhfZMOSc7kMnS5aTlEHfwkqXox23d0KUslzDMa0nXX4sVKXG5hmuNtf+nvJv15C7DdvJ5vb257sxeqlRfS3sN7rnfUDYZX9Kf5Fze1Fh5OpZbyQ6UuX6y02I4REg/wENt5Ors/8oO/hltb4w3dsfqfC+8CL29WbtQz4C203JknsWrwrmYLMIJA5Fdl18UbSOOawjgyTf2DA2nfgvSuqycIHmR076gwv0ztZFlrmo2bHLZmgbsUVrlFt8K2Yu0f+rht2DJleA+OdJD/loZelRHlfFTO0vdrX8RoAnba6ARE9yVsEIJJoSY9d/TNMQbfE+ws2UrR94vWp3AtALFxGr/DoceWn/h2nwljtgmsNV+KvuNr/hA6VaC6m3u6eqCfTawOjGt2Xhef7LZRT3SYMQ7WidMQ1gZo0xrLQB/0XAyJsBLIDZ094SMMUTKtOXIZyRsT9DpxsvjqEWIlzqOZn6uvyaJA7AoxSNutopJSlIUIxygpH27BBH+AeYSK/byuzInutC859Tp/7BUJAbaRNLFcmb/xN5xZPEpd4C3kUzEpUCxm8iLnnL3QCinZMIXAF/AS2/oOZH7u+l1q0yjUsbVaqGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(86362001)(6486002)(1076003)(36756003)(8676002)(66556008)(66946007)(478600001)(4326008)(66476007)(8936002)(6916009)(186003)(316002)(5660300002)(6666004)(38100700002)(6506007)(2906002)(6512007)(2616005)(83380400001)(26005)(41300700001)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r5uT2uQ7haIpMs632+OJgnWAhcQuMeol2hoSCf9oQOvymDCemuIlX1fARGRs?=
 =?us-ascii?Q?m8qH2NnsslcvcawoTMoD+kwPNnmrl5XWiDWucPN1l+ZKIHbpNhn8WfuhpbH0?=
 =?us-ascii?Q?P6rfsz+UTKWyZT1Fgiqrx+PuKjlF3KjnkC78qlG0AxUpcWwNRIyVeVfCEc7N?=
 =?us-ascii?Q?zcPRL+hcBgWwxUBQApOzY3YJ0/GEg5sV1VYqvvn/iz1hTkZYkhYkj5Kofww+?=
 =?us-ascii?Q?NNd9UQmEf3iJDhxANeWt1Pk5ZVk0A0oEUBPoiK58MimGRfSI94NPsRovZsaK?=
 =?us-ascii?Q?/dUsaO8ioJqaookxwdKSjrF1jh8nNo352Ucs2ADJxmrGusdSJj0yWMtCAt/u?=
 =?us-ascii?Q?R8nWughGlwuNwjk4e4NBjwFsCgXGRQPjyaLnHhJJyjA/62LA11VCgv67zt9k?=
 =?us-ascii?Q?bDtpZEm7jsFRzuxTr0d59yIci7HOR/BQ5CNrBq4Z52BBGQ6AGAsirw0hHR34?=
 =?us-ascii?Q?FH0DCw8vj5R8rkrGMJaiTEYcFlv+u8W2/GKgB8H186Xh9RhGR1BhuC6Mz2Dn?=
 =?us-ascii?Q?DglG1zG+ndvgBzYcdUmSc98eZ+LOpeN1OJHkjhX/CWrwKuIvz6XSID1bSE+I?=
 =?us-ascii?Q?0RRamQLYn0674P0O3RtbnLIAKzYVpxkp6RlxFF2fVZQKiJYmcVC3gwCRjaJC?=
 =?us-ascii?Q?fKB9XbwAEpMMsxFpHxX2mrzKyBCeZcJdIaxtnchB6YOFzj0o6GkEIwJi/5yv?=
 =?us-ascii?Q?GTf5W5HpIgpNm3X3F6opnpIVxLfndznfC9PNXhSXg3P5K6p2JH0edvMRTD5H?=
 =?us-ascii?Q?x41hz9sbRMJ2JW+SfDj25zOkvJgYHzOatcToZJurGFCjneMLejIv7fR3D9vr?=
 =?us-ascii?Q?iNVpOwHzLTZTDoRVzuOmOi96T9YDurdEYyY9pjfX2amMTk+B6PiY4dkI5rn6?=
 =?us-ascii?Q?NUDR9sPjqLW/gTxqBcJWI9+XN3NVkHLoSwUMPFIyr2EYX9xKGYlZl+3FWhKs?=
 =?us-ascii?Q?ge199qDntiKD8OVUXRm6Xi7RuqDtDHsFxOyeZvb9VJ33EEqhr0qT6X/iYFN5?=
 =?us-ascii?Q?PLEIokXFC/xSPGZxq81iSX5QfFEO5fIM1EMoCCWD2Fy8kETxcUJGUiCUKuFv?=
 =?us-ascii?Q?szhHRO6rCaCIeimO92rdT22NscWYd+TKI5XR7LuVHFkPgiONLnXD0RHL/s2W?=
 =?us-ascii?Q?Ox4nGTKg29PA+xptT4mnnSEz67bw0b9jDADmuB2RTzZwCm18gft8vkQG3Zm8?=
 =?us-ascii?Q?XZ1tx/Xir9YNTCY/nkVMe5js2JqgjtcPYR1CZNS19lWc5aUAWslhJexQN6du?=
 =?us-ascii?Q?N2LLmenDxff3NNS2NcIzYSdhsv/6STuI25P5tfw0+/ie4Qt8Utuol141y8QH?=
 =?us-ascii?Q?HJLKGTYqvWMPOe2MRmPiwZErEXs1TR7iQ3uhd1xjfhRHUriyDOp9lKgfc8c1?=
 =?us-ascii?Q?czPdHJf8UQurWiJ1syTu133bLud2HmZxxeMDdFmlGS2i6XziIe6jsENxgkXU?=
 =?us-ascii?Q?eTmtjsveOSO9Lv1GgQJSG9eUX+V+Ygm3eJeKNFctgfi7ZNFW1yVIt6bQYRNA?=
 =?us-ascii?Q?Ag8qtiDDvDXXCzAOh+X5xr8H3eUhqqLLIk6TNQzGVhoPhCmQiD3Tp1d5ZdXe?=
 =?us-ascii?Q?X7jncvRj5SyMGDYNGi6LSzAF2x08B7y/8MkheMKV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df046d3-01a9-4026-e3d2-08da5a71ee40
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 08:24:20.2800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UIF+KxV3JXh/2+OUCOG58WVPo1N9eAa/QZ9gFPbW3R5ZtvQCSzUEwr7YjzfhbMdMZ9INv5ZoVOuh6uIMscpXRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2880
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The unified bridge model is enabled via the CONFIG_PROFILE command
during driver initialization. Add the definition of the relevant fields
to the command's payload in preparation for unified bridge enablement.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/cmd.h  | 13 +++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h |  2 ++
 drivers/net/ethernet/mellanox/mlxsw/pci.c  |  5 +++++
 3 files changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/cmd.h b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
index 8a89c2773294..666d6b6e4dbf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
@@ -633,6 +633,12 @@ MLXSW_ITEM32(cmd_mbox, config_profile,
  */
 MLXSW_ITEM32(cmd_mbox, config_profile, set_ar_sec, 0x0C, 15, 1);
 
+/* cmd_mbox_config_set_ubridge
+ * Capability bit. Setting a bit to 1 configures the profile
+ * according to the mailbox contents.
+ */
+MLXSW_ITEM32(cmd_mbox, config_profile, set_ubridge, 0x0C, 22, 1);
+
 /* cmd_mbox_config_set_kvd_linear_size
  * Capability bit. Setting a bit to 1 configures the profile
  * according to the mailbox contents.
@@ -792,6 +798,13 @@ MLXSW_ITEM32(cmd_mbox, config_profile, adaptive_routing_group_cap, 0x4C, 0, 16);
  */
 MLXSW_ITEM32(cmd_mbox, config_profile, arn, 0x50, 31, 1);
 
+/* cmd_mbox_config_profile_ubridge
+ * Unified Bridge
+ * 0 - non unified bridge
+ * 1 - unified bridge
+ */
+MLXSW_ITEM32(cmd_mbox, config_profile, ubridge, 0x50, 4, 1);
+
 /* cmd_mbox_config_kvd_linear_size
  * KVD Linear Size
  * Valid for Spectrum only
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index d1e8b8b8d0c1..a3491ef2aa7e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -295,6 +295,7 @@ struct mlxsw_config_profile {
 		used_max_pkey:1,
 		used_ar_sec:1,
 		used_adaptive_routing_group_cap:1,
+		used_ubridge:1,
 		used_kvd_sizes:1;
 	u8	max_vepa_channels;
 	u16	max_mid;
@@ -314,6 +315,7 @@ struct mlxsw_config_profile {
 	u8	ar_sec;
 	u16	adaptive_routing_group_cap;
 	u8	arn;
+	u8	ubridge;
 	u32	kvd_linear_size;
 	u8	kvd_hash_single_parts;
 	u8	kvd_hash_double_parts;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 4687dabaaf09..41f0f68bc911 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1235,6 +1235,11 @@ static int mlxsw_pci_config_profile(struct mlxsw_pci *mlxsw_pci, char *mbox,
 		mlxsw_cmd_mbox_config_profile_adaptive_routing_group_cap_set(
 			mbox, profile->adaptive_routing_group_cap);
 	}
+	if (profile->used_ubridge) {
+		mlxsw_cmd_mbox_config_profile_set_ubridge_set(mbox, 1);
+		mlxsw_cmd_mbox_config_profile_ubridge_set(mbox,
+							  profile->ubridge);
+	}
 	if (profile->used_kvd_sizes && MLXSW_RES_VALID(res, KVD_SIZE)) {
 		err = mlxsw_pci_profile_get_kvd_sizes(mlxsw_pci, profile, res);
 		if (err)
-- 
2.36.1

