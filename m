Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0178D5197C3
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345188AbiEDHGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbiEDHGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:06:51 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5687421817
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:03:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UF0uhUFt1D86GAGtccRGOmrpMFRxvV9h9RD2TTsXqeoY1qcNGayopPS6Nu/pix1Dx76beghjrprn/WO8FIrqacU2zuvo8Bvv1gkZYlCA/CyGOJv8mvAVf+8KsbwNB38QwF3EIdLTranu0jcW5L2G5kVVpwCbecCnOqWSC03Cvz851iejw0ZWciETHp1iGECmF8Nd3hwvHTWApREgA/MOxVC3cwy/NyIXl+z7H6ie6ACvS0E3icrTQpnCatan+hI5RKnc3HIgTomH180K1IEwezK2sQbtKPJO9aUFSXDkPLeRLOg9gB/lZIe9HUXCiKjIzQvS5whWhnWVYgtRdEE2DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4rI825sAQRT27SgfpHtAoYQ6e8x2GyNHMWdtJyVMbpc=;
 b=gH6b8qJyPv3jINhEIotnmTU8yvTwIPYnBxMknxAGmCzxXzQUViLWDY1EPv7cD9GUBTi4pHODpWzNqZtMFyWqQ2DuD5rDqHnUQzHnV8LCI3NeE1KGnmkbnEgeAq4GNODW5LmeJfQu8UOZSL88Vy4gak8exHYfN3roTPgYg4N7T+iyaKnsFWGt0i1LYpECGnYZNFXTbUjtFQfPd1KkFd6GNgL9aXdhIWQ4AtffZSSSRgollZxG+oX4Z1w1rx87sHbFjAc8m3pV+y4fyCk8g/RYPJ/gcQydoGD2Gbpv7wN4+GlcAwQp+jLPS+bCqS4vEWgahDWSv60ahMpuJCiNhFdlgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4rI825sAQRT27SgfpHtAoYQ6e8x2GyNHMWdtJyVMbpc=;
 b=XW19UHy7yQZagN+IOUd4GrGiuVXrN6sVnY3fq1i3m1C9VI6Y/9iRxWDYVYC+Y4e7idQSIS9PkgpBkA6lShnJRqGR1wvGWPr9WogPmFo/GZnBS70Ccsq4mM+qQ177qXJbe2ixG9USf6dRh3U7ob2XI5pwH2ErEkyBtL4aej+OPRoOzx8BDAHXWqfaduTy1WkLmMiBSNej5sSxE1Q5H/3naI2OFBapsqsbF/hhFx21akQERAWOk/9s+nOEdpVE3ID2yRwYe0HkIkDSUd7u06gsnC4NQim4dIhJMaxQsbohJL39AREl5tN8WaADequKWYtLdRdjq4KpR/Nb1g5fOfjmdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by PH7PR12MB6586.namprd12.prod.outlook.com (2603:10b6:510:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.28; Wed, 4 May
 2022 07:03:13 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:03:13 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/15] net/mlx5e: Fix wrong source vport matching on tunnel rule
Date:   Wed,  4 May 2022 00:02:42 -0700
Message-Id: <20220504070256.694458-2-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504070256.694458-1-saeedm@nvidia.com>
References: <20220504070256.694458-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::33) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e02f2f6-fee1-46a2-b63f-08da2d9c2791
X-MS-TrafficTypeDiagnostic: PH7PR12MB6586:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB65867AF803D3C93D45CFCBACB3C39@PH7PR12MB6586.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ok0fyAU4BhwgWuevGfIvveejyDWEUSZMREgt73Gtey7eLzNeGnS5D1d+11iG+jlqj3RIGEtflRDvkT4DGpDxwDPYOPnpKgm7HYne7PqKc5pakI2UOEJESBAfH8gW8Y04yYk7FX7Thbm9DqIPPDK7p8Y2KlvFvGQ/VPeXA1CyYhOkCkeTMan0e/WqWmaM5caMXndKqAtfjwNIESLLuaT4Yidej1RuEi/HmMOiAJRvINBko2YxgvzGARV41Ns/y2AFIMLZpxsIL0iviChk1lgoU/2hhOpU40MZQlJeYspHWE/j4eu8LcLJXnB4Ob106bk0WuxVp+B8faRsr8kSxc2/qZ0DbbMYh6C7ebW986RKXJOdw5qXKwg8jgumnqiLQPQWvG6gefTEoWa5dguiE5s8g1UPsazwI6sfEh7G6RT/E8jvG00Q5OShzf9Xy4i7Bo56pzu6eGU1dieqfjNcGPaOMahmCIVFQ38fbbSvNYIkOWoi4vvnZTB1b2MAHa+39LPWcQeviOBTqdZ2wh4stLALo27yt2hCcIeWAweXigYOBk9wWUir1WnrhnsU7MmraiBiAY88/axziaCMlY6x8WZ1a0RIgSNjHQvXI5J6jm+hSu0Ca9K/dbnc5p7ThsLOGbYPrADk1FPe80ArVWfR6pHHJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(86362001)(83380400001)(36756003)(1076003)(107886003)(186003)(66556008)(66946007)(4326008)(66476007)(8676002)(2616005)(2906002)(8936002)(6512007)(6486002)(38100700002)(5660300002)(110136005)(54906003)(6506007)(508600001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5+4+OVqiYn8Nm6YkpPCfH+p/saO5HR/F9XF1aifsitMbePJHaAjbTgOj9Nmn?=
 =?us-ascii?Q?O4yYxgFwE+QpG55LjU39fL9dhsYF3ERmkOh3mKYqJfhjIvJZbOVEdaw6GhSv?=
 =?us-ascii?Q?4bUdzW17u2X28QspzVKbZhiE130ZNzxbE69XOWHQDYo2m14CDGmqq721s+t3?=
 =?us-ascii?Q?+1qrOFZyRt8r0ThYBwo0/FOLv1U9JK+21M4mZvH1ISJFkJtPJhJcxH4Lk/QA?=
 =?us-ascii?Q?JBpVWAlTNTgUocTKu83qS86dxVEGRMo02zc7e9gkfJn9FaF5h/kbZgyXK6Bu?=
 =?us-ascii?Q?oMK4x8oMxNND8Yfjd49dRPkhDRigmU6wTWmL9G94dZrRQljeSlv5RP0NPVtS?=
 =?us-ascii?Q?V3UuPJq91EBRfO8vAiK2e2lyO3SPtMoKjTJu4fD8Duic5svTpX/P6AYpQvhT?=
 =?us-ascii?Q?IdlE4Xe4EIkj5aeR6uMGSZagyDKLBV1jw+wOl5zVJIH9VHzitEEtSCOXPHcC?=
 =?us-ascii?Q?XRN7q7W5vVYbLG0+rsiine4EXZy4VocsxJzD3oxoPTY4MqXdz/Aib2AhyRVF?=
 =?us-ascii?Q?5Jz7ZYClKBguFf92MitGa+1z/Ajn1KaHGqeyruTbScbmOnVU2KPlAJDATaDE?=
 =?us-ascii?Q?dd+wjAueigaU/ikl4DjebhmKwDKk2zWQt7O7HrpiuJDQLMSeQfo8JpFZboHy?=
 =?us-ascii?Q?DfHqVuEITOBmEOopodQjN3MTflLMeZ51cJi8XkgulVdhkc3jmrA15vgg0Kyj?=
 =?us-ascii?Q?DiR+u/Jc6H1q4JacIuCoEaMGJ5AlTDaqGdgImgU865ccXk6IfaoE5//qWABg?=
 =?us-ascii?Q?VNIZgf2C5BF7hizXBk1fehVyYeBpvsXk75qnd3kgnNu7ua0z0WEzx9M/HL+I?=
 =?us-ascii?Q?Q1E1AIu9pVegsxAEtgkw7VATHnQJZyr1Ld0f6SAlPVO4OE4S5J15SzA4TUxB?=
 =?us-ascii?Q?DPHzc/pnCrUdMYAQp6sIVSNxEp6h/d6LeXyaER759VzRZZ7TutFOlnmMpsar?=
 =?us-ascii?Q?qzv2axThAmQcLSWqIIyAPSchwzOCeDFcL+exyjzesQn3MPnijpAqBBABkQjF?=
 =?us-ascii?Q?fUWKZTjCcdfT8L2OJYkwDhfaPRRIbMhDLK1KhwnvmQ1nsGLUwMUvkfqSZ+xZ?=
 =?us-ascii?Q?wmx0N+Moxx3o5cL4ahedao89VicQaw9xjUp6DTHP3D//0SlgDcCOfkr7n5kX?=
 =?us-ascii?Q?14ExJTBs/8POnoRiyKruzBVwGF1ibuyeCFSse37ADK/MUIWTNFckpl7d4ceE?=
 =?us-ascii?Q?C684ixo9i65RKbU+so2sYEhqgDu5BEUJAIHT5JrBYS1jk9EZlDcQhk+xX1jb?=
 =?us-ascii?Q?wYvIf6ortf8nSliB1mSLJ2P6okh6KnFugwy3sRyE9ZG4dhPjhD7tv5atEwbn?=
 =?us-ascii?Q?WI2in9ZH5Rzs5ZnvtV3xt9dwWL18oYlfviB1QLApQCL3tB6Ho6alIHHAXmeu?=
 =?us-ascii?Q?jEvugTv/Pcc+aUNehNq4CdPWTS1+E/LBaF6aru2VJiWYS1snXzChh0UaOkSD?=
 =?us-ascii?Q?+d99HxY+eMpFLNFP9JC7vhQqaH7WKFEjV9Vpm9TfBXvZXUbtirXiabGGLVLu?=
 =?us-ascii?Q?5aZZ97ivkoBs4gNhtITKh/ntgegq4//UqpKLWaKLlkby6FII2gLaAwS7Ywxz?=
 =?us-ascii?Q?d1yNX14OzP63eEqpmSgjH/0dFKZzPxz7YwkcLt2ofPm3xiwwD4TklKfpqzhl?=
 =?us-ascii?Q?0GJalkRUcgq94LUPX986sUEVwE9olHBbhoCFG75eIYwh6sS083arBmC75HpB?=
 =?us-ascii?Q?+HDhWD097RBBHO9/fSAjr14aFjjz7opaAG6pxKr/oGUAWWAd0JmtC2TKmasX?=
 =?us-ascii?Q?ofUOBTqhK6VaWW6GHlJoXOtGM+XTgz7a3bgrXNBhnU4t3bDjkuwR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e02f2f6-fee1-46a2-b63f-08da2d9c2791
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:03:12.9605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKme3mC8hHtnTQ9Uu+WIqINgTi1+WJcMz6Ra35Vi79vTccWZrxG32Vglkdi8hutf3wr1lscB7uyXL/RrMgX0yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6586
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

When OVS internal port is the vtep device, the first decap
rule is matching on the internal port's vport metadata value
and then changes the metadata to be the uplink's value.

Therefore, following rules on the tunnel, in chain > 0, should
avoid matching on internal port metadata and use the uplink
vport metadata instead.

Select the uplink's metadata value for the source vport match
in case the rule is in chain greater than zero, even if the tunnel
route device is internal port.

Fixes: 166f431ec6be ("net/mlx5e: Add indirect tc offload of ovs internal port")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3f63df127091..3b151332e2f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -139,7 +139,7 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 		if (mlx5_esw_indir_table_decap_vport(attr))
 			vport = mlx5_esw_indir_table_decap_vport(attr);
 
-		if (esw_attr->int_port)
+		if (attr && !attr->chain && esw_attr->int_port)
 			metadata =
 				mlx5e_tc_int_port_get_metadata_for_match(esw_attr->int_port);
 		else
-- 
2.35.1

