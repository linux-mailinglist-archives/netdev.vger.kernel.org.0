Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D365197CB
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345253AbiEDHHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345210AbiEDHHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:07:14 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2081.outbound.protection.outlook.com [40.107.100.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB6022BC6
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:03:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cb4kw4zOYBWGkYeq07fPjrN5LQ9ds9ZI+JdE6itwk2D0ffj2apwBZA7L3Bfkhje+cZXxOE7jN8iwgivdwHx6a6f8wclV5JF+8U9q7owjatfBGqTzRMfJVlFC86d4I6YAoh0M8biiQgyVhkUQbXD9O/ec2KgTXsPsEcs39+Q3S6+JpbJOLzLKG52lrReft3774f5dMBQ/wvKbe5OcMFopOmualk1t+CcXCE93FmdS3KOCJ5MiDHYp5TxncWkzipJPnpU96Jo/flLhh11cTFXFP3kC6MP2BbgbGFizpSQ0OqWQ/w6SwzIwD2CjbErOnRL5w/Oz6TDEf1dcar/06hZ2Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmeF+avkpiJawEnSL9O/aLqnF6V3dRq7+QFa7rD4HtE=;
 b=AWDT/mUXROoFKrVHCLIQ8Y2olyUqGXjEGCGz5AqO3/2186slGN7wxECDCqLFBCiEELIm6wxFVV2T5IPNyRUSjgFw9QZgIoJbCPY+GmPSPAcBbioQMQfZfiEOG2Pc612peWhMsOZf0DB2o1TFS1i5GjKE1O7qIacCWgpWpZRePCVTV8KtP6UBMn1YUi2dcgWjPC7us6oYtE/0b4eNpE5wniSurcAL9qm0IfbY7MMuAe8mGdEhzC2QBxiKD8NB7aThiOLdhPW79q5OdDZaZPcvODjVE9ACSNXuo51B5PMbuKj9iqRSIDZU8xxabpwAHrEtEPOp/5IDz1wm4xdd6RT1XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmeF+avkpiJawEnSL9O/aLqnF6V3dRq7+QFa7rD4HtE=;
 b=R8ieXSQZkSloqbL5jHVWSLtFeExlXL9vAxEAXE0EEEDNJ5SjYNLF35ZAzIOiCRzpOxG0pMdxcLLz/V2kLEx7yJSZYdk8Yqbs/q+fH7J8sE2YH/qZL+QoHNEXEAdBgIoO+ZAUduGRu+N3TCGGqsiBddebzOYj9rYpJ7p7T/RqKJH91Tm++wSTeUYhMPf09OUuo4uClaFnk/mhWEChPGj3ffYPIDlhVgl4LspA3tJMRC8uB8B9+gSKMFVODhWoxCLGNphTXzGqEjA31L4dT5hqAgZW+ca2vK8KSNNEuCHqFEHpRfJItAOCpJX6/mXI545CVrqlaIKSrNo9WZyKhmI3Dg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MN2PR12MB4503.namprd12.prod.outlook.com (2603:10b6:208:264::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 07:03:24 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:03:24 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 11/15] net/mlx5e: Avoid checking offload capability in post_parse action
Date:   Wed,  4 May 2022 00:02:52 -0700
Message-Id: <20220504070256.694458-12-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504070256.694458-1-saeedm@nvidia.com>
References: <20220504070256.694458-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0005.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::18) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8afd539-8c68-4e5d-8631-08da2d9c2e9a
X-MS-TrafficTypeDiagnostic: MN2PR12MB4503:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB45030BC944F4A9E32DB0D8C8B3C39@MN2PR12MB4503.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dtDGmJ6EvAMxyx1+HJTBpe9jFXyR0nh5gsSBW5Pmrx4b6BCi39AGDtID2U8tCa+Bm+7Jt1X9s++7H0EiD/ffSmvTbc++Tt9u3lco5TbH0wZq0KQ3AXGPaNSLi2o4+UB3WX5IRXtZnlOecei+skPh0e5WwYBoKljVNY3EAAqeMx6VRIXhGiHpl6JtBoWfGDzNP6nSYVb3y0B/FFuPwv8fREoNw+5q/XVHOu//xpNTaoBbH56SE/UD+AKe93wWRtSWdXzsSZbVYmbeQsqxSfdd6XRlftwR3UeOlOg0HWzUZDXRZ68//dG0aP21EQ9k7EW8arxBofZd1o9NsAmde6gBH0nIuW26H8W0NJ42qFYpjIzg8Af/DvZZR7nyjfiJRNKjg6XrkBzGczLqxd9OKl8svAIWWBBGOca9aFfjPRFeFsXhENJf8NWNIMJQSDGUaqchN0VsRd4QMQqoc6OzkuPkLblOjNeihM4s+WB313makfJcd89IvTP3h67V4MUpJsWZ1NmLi9KWN0WTdJgsyIMb9kv95UiUYKwJk9CDj7zbSEk5DLHUbev6GSMoJTKmkYf/FFloHUxGBZdPDiEhxlk2qABYHaCmDFaOAD5Zy45uNJQKOViHtfcl1pHW5OTVcPXb/T/YqLAsp/uOkmiJN17mfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(107886003)(6506007)(2906002)(36756003)(8676002)(508600001)(6486002)(38100700002)(66946007)(4326008)(6512007)(66556008)(66476007)(86362001)(8936002)(316002)(5660300002)(186003)(54906003)(1076003)(110136005)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d84ThuNB0zvTsdrDSjBEEr9PALOJDXsh5kRu70B+uTl5wO3ADuDf1k38E8fW?=
 =?us-ascii?Q?xcuxLcgd6D5k7G4bKPy6ySLOAmVQ2g+S6m74XY2jC3jA+RRgjkYG7uIFI0L0?=
 =?us-ascii?Q?MCOnIl8cjATpmqEPv5NPHjXdkDzETqnEiZm4w1IDCg7Dp4/AnmnOhreQL9U/?=
 =?us-ascii?Q?ajTunAgxIAhSwdIJ6c60ikzY/So5iATqKClJXxcW3lDaSsPommdH6hNOkqfH?=
 =?us-ascii?Q?J1/2GiqE/vwe6UxJp4VsGR7lIIEckRIrilZgZzYLmIQJWi1hz/L7FxcMD/Md?=
 =?us-ascii?Q?F5EoJVeylyWv0ToDbCxrotzDbDWIALzqIVEGWKlgdc29JE/W+qrNIA/4RxOQ?=
 =?us-ascii?Q?7JELxTGF1ejd6kT9pqyt70AiNXWcWilwnU6QKOJa8MkdQBFRrmkeu+zxBCN6?=
 =?us-ascii?Q?FpKDq4ZRcXPwQmaW11wpkuHtHcb2Y7kM9wGIb01f+ejeS5h0vyggdH9neunO?=
 =?us-ascii?Q?+4c6JP1o5v9/NXFUuRB6hGy/VzhP0lgL7a/0AKn1baP1UUDXfMXr7pH54XoS?=
 =?us-ascii?Q?xu5Mf6Wl5UlCW6MB32/iuYO3mMr5dX3SPMhugAcxJbtGCjVopdC4GIaNMZxK?=
 =?us-ascii?Q?/49bi/MBSP9R+ZAvnB7wILEs1XQwucJXWGWkxbDYRVvXGvq7Al1wZI6FMssm?=
 =?us-ascii?Q?eOUtKgYb+RmmsyRQPQwcY/T6WBnYmSLeSWKaZE/NJhhWP+ecnY2DLduwVjxN?=
 =?us-ascii?Q?sj+BmmiSSy29Pa9jlqfIyObiV2+wouOv0/KVs6fDpXJ1vjDLuc8LloW1J9mz?=
 =?us-ascii?Q?fMEBy3guHat3v3YBqHZwnlFo6puIrJN/sJpPxXk4/1W8DhfEiz7/701j20i4?=
 =?us-ascii?Q?onuJzKE3hI8PuESB2ar4L3HW5QPGqtzaE8uyp1yAXs9eFi6tkaoTB/wThQyc?=
 =?us-ascii?Q?1eOW99G99ecHVau+ZGwOQmSUdjSZED/Gd/Jsupy0m/Yii2mrgPpnury5pGiw?=
 =?us-ascii?Q?NmFiIONXAy171p0GSAvdCBmlslCJVrTsNZ0wbtibUvjsdcOYPKszoZ2VLXm+?=
 =?us-ascii?Q?7DMbIzf8lDMiG3HaFMWRAF8T84Ol5GNiwm+ySWtjj+OgmqAlgNA7ZEWVZhJ+?=
 =?us-ascii?Q?dxVe8eZBPpAL2JC7SEqlKz8pOqeJjZDGt4LCvP7hpbJZAeXYZ/X/N7Bq/2vo?=
 =?us-ascii?Q?W9ZRdginFEy+Sp3W9yUMq5AmTJOQgFiyiXofzdP4/CPpSGYcNexjNvZl8hYe?=
 =?us-ascii?Q?bL1aufm9vkeMutD/8LZ4x7iIy+GpdfO4kZc4lQaEd3oRDpVtnLqM1c7bGKHy?=
 =?us-ascii?Q?q4lNf1cb/WVbnuWAXccimpnBYydVj+hK9/3D10QCxlf6WLWkrpNrNK9HNnRu?=
 =?us-ascii?Q?naLY1KTqU87um1FNqy/o7UH8PYrQwHNb/qpMNseRLhuZHxrDYPdgQq82mxKh?=
 =?us-ascii?Q?YRTH1XCustZ+xSmuA+4sQdjJnoE7UeIe48aL2vOrWmKArXMvbmTyJ/zWDnnq?=
 =?us-ascii?Q?3H1BRGwpL6mDCRTNMsVyfAgE4qTYrEpxH8FP79FtbJB4MsgKFAKVai+jNxBy?=
 =?us-ascii?Q?+XBM/O/pSvZEHQylITvENs7ThDrM+ZF3V0hqckXJOE+v0WHp984BcvWTOslc?=
 =?us-ascii?Q?1wQ9VyZaJi2LeJ/bxEXpworePdk1mqpA1ctstu7lFkEfJX6VlSMwVNr7lWu/?=
 =?us-ascii?Q?i8Y6mI41zXTJAO73uyhIXqi3UpN2UNGULeIGL3VVurQ71YSsbE4B58XL05HE?=
 =?us-ascii?Q?MDqHFhkUsWAfGeoaHwtPBpvF8GhyuJxPVttbD78oJLq4ttiC3RRHezQP99z4?=
 =?us-ascii?Q?HcxxEWIXKM8noMEoHjbx8B/sbABGAhvTJgwbSA9NWqTJeuEu7UZ/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8afd539-8c68-4e5d-8631-08da2d9c2e9a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:03:24.7623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q7VTl3L2se6HMg7KMl+pgxxPvbDUEqMGh/GP7zOY59VKlEeUB++j4BJmxlWsv2mXRksldNbCZ/lXcvJyM+y3cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4503
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

During TC action parsing, the can_offload callback is called
before calling the action's main parsing callback.

Later on, the can_offload callback is called again before handling
the action's post_parse callback if exists.

Since the main parsing callback might have changed and set parsing
params for the rule, following can_offload checks might fail because
some parsing params were already set.

Specifically, the ct action main parsing sets the ct param in the
parsing status structure and when the second can_offload for ct action
is called, before handling the ct post parsing, it will return an error
since it checks this ct param to indicate multiple ct actions which are
not supported.

Therefore, the can_offload call is removed from the post parsing
handling to prevent such cases.
This is allowed since the first can_offload call will ensure that the
action can be offloaded and the fact the code reached the post parsing
handling already means that the action can be offloaded.

Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index af37a8d247a1..2755c25ba324 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -145,8 +145,7 @@ mlx5e_tc_act_post_parse(struct mlx5e_tc_act_parse_state *parse_state,
 
 	flow_action_for_each(i, act, flow_action) {
 		tc_act = mlx5e_tc_act_get(act->id, ns_type);
-		if (!tc_act || !tc_act->post_parse ||
-		    !tc_act->can_offload(parse_state, act, i, attr))
+		if (!tc_act || !tc_act->post_parse)
 			continue;
 
 		err = tc_act->post_parse(parse_state, priv, attr);
-- 
2.35.1

