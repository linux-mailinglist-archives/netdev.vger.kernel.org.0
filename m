Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05F4686B4B
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbjBAQMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbjBAQMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:12:24 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1ED7783C9
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 08:12:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/w7AbLZ7GxiPxxeCc3z9aEDMto+blQhKlJBXmEyDHLtGfBKKZWbd5Z7zf89SpGshaMzJEh3iem8+FvTJAp6Is7dEEXXHlALyoc6O8xNOwiree5ZCGLKfh6DX6WnlOTpcLL9YtKew7v4iJ+wYbaBSm40+414lWZEWapTLV9+BGeHjsDMRn1wlhIrcnYGwrglTUGHhEURo5DfTFUD3BleZyoLy5+3G+y1jMNyamDnCpkT6zE4bYJQcJdbBzeOg4G+GbmQy/ilkm70RpOJXFrOrDrc9ZAORecCy0lOq6U72lnFTT+iJfQrvgHt4RHZXoGpfXIpXPwad0XrytuyNBTIIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMfHc5isviPAq4o9ckZeUYS1gFA00N0SeOsvV31q0tU=;
 b=aXfU/Zw3X3mwB0dJ7edGiT1qeYzHYMULiFBoEU6T6abeQ0SvPNCge/Iwxy7eprJeFTep3wSUomTfFhnPT0Bx0ZGmEBiNLx4hrW5S04Y2tRPCeWxdKg/1g8iNm6tBUoIdiSjUhTvjbN/zY5Nl+ViifdXHQMTyjdCn2OZRgVm4fwmiJXPu31Wq3gjgAuSO7znQ5HLYpCjdMcvH6Zl8JV8Zp80qWcogU3Y26vRRmt6HPFYSvPwhnDdxuSikTjd20R6lgiXFcuMspFQM16IJTwOwmPf8dHIb3XJGt4l4sjdTq+ID3O6x9S6WarvTpIFROx75wWmp/KwSfp5paFsxhT6WsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMfHc5isviPAq4o9ckZeUYS1gFA00N0SeOsvV31q0tU=;
 b=aNawsVg0DaK0tv6upXTaJ0TlcfpRpIzI6k7NrVjAEh2I5gR2yyYC4l7+lz87N0JjXW0s44XP2Vyu1Wd7rKc5b6exfY33jPbhaHnLffP11+qjOzlSz7qmDf13cXS//nnOPTKS2qHnPp26nlXa7Fkl2PLa9zvkKugrxvevcdOEAhZS3LkRVGXv2f6vF7jjHvvEhRyhrqbe/1QeMnLahImRo8W1+8JidzkjNpgJzbnvkLd549CYxQvzLDSVQqIURsJlayfDJ5o+t1bDlIIoy/04hvoC5x5Ek34sk7kvBao0meC8FGvFN5H8bOpA5H/ndRRH6e3jNvmXRR7fiWbC75t9FA==
Received: from BN0PR08CA0011.namprd08.prod.outlook.com (2603:10b6:408:142::33)
 by SA3PR12MB7878.namprd12.prod.outlook.com (2603:10b6:806:31e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 16:12:12 +0000
Received: from BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::79) by BN0PR08CA0011.outlook.office365.com
 (2603:10b6:408:142::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22 via Frontend
 Transport; Wed, 1 Feb 2023 16:12:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT075.mail.protection.outlook.com (10.13.176.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.25 via Frontend Transport; Wed, 1 Feb 2023 16:12:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:12:02 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:12:01 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 1 Feb 2023 08:11:59 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Oz Shlomo" <ozsh@nvidia.com>
Subject: [PATCH  net-next 6/9] net/mlx5e: TC, add hw counter to branching actions
Date:   Wed, 1 Feb 2023 18:10:35 +0200
Message-ID: <20230201161039.20714-7-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230201161039.20714-1-ozsh@nvidia.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT075:EE_|SA3PR12MB7878:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ecee9eb-bbfd-4816-8aa1-08db046f13a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qP+xw+ruNZvi0yYiFJZT7KJ6pmdrBUR+wqOY2mrFFp/plkDLJu/ZBInIQinKwuDYR3h4S/iuYvNXsA5dkZdDPlEIbNjXxrozPXqG+62suVAIDptFZsqaatxpSxBzs6TiBpnz8RLiO0wh6fGEtTE76xmTq9uFmHP+eO7dDFHhdDpHJfldQHR//B6F+u39bSqUP/jdujmP3a7VDL7BAdvmn2bchhgWC3FjdVf7QBUNiMvvj0wCYUGAw09Bwr/98rgfQCfSOfQvwvJ0Xy7Ltxo30yvk7jxV1fwnsJbSvRmaagYNnWP4kFL+NN4gGx0E8C6ygTmQe/OA8ApDLlmFGpm17tpTjObtIFLEGkAJH0K39FRUg/zxO+VGGbU9T+xrPcFqvmlvz4IeeynltVKUvJln/WvdjdNlk5j9poKPd5J+6OE4948zTZWb+TpCN/dJIzv20yiMoCkPFvj6RUxivciJx9gE8R1BTZfQlSjelnsBOfohz252dwGtfCLw16MBM0bgq5gmgAmmwXvav2qFIDdw5il1mcM8Cs4Gk7aL+L8li1mshQskcI7jhiaQVY7MWQdaleXGJWkkFZktCErVXJpfqfhhJ18P7bsW3EZEh9szDYjLdM+TJC46aCUuC8HLQ6vD0QOEF0D91mZq0xlGltOvpjOqg/UZ5P8i/zp9Diyp8pIW5DtU1SnC0D+Y87/CVwxL3hYAbCAQLHhb9fFDj0kQsQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(376002)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(4326008)(2906002)(5660300002)(1076003)(36756003)(6666004)(107886003)(8936002)(186003)(2616005)(41300700001)(7636003)(70206006)(26005)(70586007)(426003)(47076005)(40460700003)(336012)(478600001)(6916009)(40480700001)(86362001)(8676002)(316002)(82310400005)(54906003)(356005)(82740400003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:12:11.8654
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ecee9eb-bbfd-4816-8aa1-08db046f13a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7878
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently a hw count action is appended to the last action of the action
list. However, a branching action may terminate the action list before
reaching the last action.

Append a count action to a branching action.
In the next patches, filters with branching actions will read this counter
when reporting stats per action.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4e6f5caf8ab6..39f75f7d5c8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3796,6 +3796,7 @@ bool mlx5e_same_hw_devs(struct mlx5e_priv *priv, struct mlx5e_priv *peer_priv)
 	INIT_LIST_HEAD(&attr2->list);
 	parse_attr->filter_dev = attr->parse_attr->filter_dev;
 	attr2->action = 0;
+	attr2->counter = NULL;
 	attr2->flags = 0;
 	attr2->parse_attr = parse_attr;
 	attr2->dest_chain = 0;
@@ -4095,6 +4096,10 @@ struct mlx5_flow_attr *
 		jump_state->jumping_attr = attr->branch_false;
 
 	jump_state->jump_count = jump_count;
+
+	/* branching action requires its own counter */
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+
 	return 0;
 
 err_branch_false:
-- 
1.8.3.1

