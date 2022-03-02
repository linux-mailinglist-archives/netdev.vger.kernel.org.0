Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A5A4CAA3E
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242189AbiCBQcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242163AbiCBQcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:32:43 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3445CD5C2
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:32:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dKP1+q1avn9Z5UOXTBuPgfARmGVE2lJLxSwbty6zUXwnJcWoRQgC3Qyw9WYfyHTzQVcgiF7ZVZOY+vnOlzv8xcI0cX+lOsYFpwsH1CfFVcuCWgEiG7CEH7ntC1O/dmnUgTWQ1rtNc8Kmw2rp8ldB7q882OyVSRnPAQjEmC6rawENC9OCYJe/jH5PJrdEUUmWHkcaKoB2iTn72Ro4DYsjKxdtAdjb7ZvIlZEcE18Z2qnr93reQEC9SlfMwDDfsIcm2sEoNPXOL/aoTzQvKmrJ3xGiIVvQN8mMDpNncSIMfxS8gvqHj8sphWIXFTgu4sXLW7g0VIEPAeeq1zH6UmAEPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZiGt8fndYh6d19TtG42nSQw2AWXWMYNSHSuyQlhVvXQ=;
 b=jhMp58RBhL+DlRHUbF3ztpAzf/dMVIheWghPcWFO2O3SId7mr34cv9F1XBw5QWAvIw/RKm/zj8T6FJ2KsgRHHKdmKvAOoUdL1GGEOwMKEUo5Uc9/8g2aDBo7A2qewctF3BIibonBKBxnvufwehHeY5s5iFQ112PA+XjsLQhDuhvT/z5q1UnP83en7JCpE8TOzqV7nR54fZ9EIdmxIPwIKRx4iIlr4wPOe3Q4yIElynFtUzI4jtMd7esHzsng3B4W9WF2+EsNAWElLS9ubhDJE3WHkyU9HLq1t9cwpiS0h093feGqregkWxnR8/VL5E3JO3ed3g9Q6SAUWvUpgM449Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiGt8fndYh6d19TtG42nSQw2AWXWMYNSHSuyQlhVvXQ=;
 b=MuQnJvLo3TsqJJvho5Qa5Ujo5+xglUjQTv6P5XSerDqf8JHbihlUQtsuMOUvz/f2rSIULCK4LOxiRjkMFwjwRng2OB6zIZTG7Z7/vnikHL8jzdxnLo2mnCFMgr2316J4PqBkSGLDFRs05nJhIAsPOBE1TBkGG030TPPKLbIea8SWsuWPpsUSt3I2qCUjJ0NLO+bVHnNczs0A29dKDBdhIHtcBFmsWbfTiOsWkVRrf8GFuEspwe0H12z6+MctyWpM1OB1wBb9GVcwyOskRrP1bCEDdkdUH6hW64yRp7mi6cdkRwUO/EiXmHdWbzUd4dEEdks19uzDxrvZBgqqGPm5+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CY4PR12MB1942.namprd12.prod.outlook.com (2603:10b6:903:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 2 Mar
 2022 16:31:58 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:31:58 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, roopa@nvidia.com, razor@blackwall.org,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 01/14] net: rtnetlink: Namespace functions related to IFLA_OFFLOAD_XSTATS_*
Date:   Wed,  2 Mar 2022 18:31:15 +0200
Message-Id: <20220302163128.218798-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220302163128.218798-1-idosch@nvidia.com>
References: <20220302163128.218798-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0171.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::28) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a2c4dd1-660e-4005-c829-08d9fc6a2be4
X-MS-TrafficTypeDiagnostic: CY4PR12MB1942:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB19426E8270997ED096A1BCB8B2039@CY4PR12MB1942.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8fu9PB/DeVXgXzaQ3AL+jSr/1NA/4o4NP7zGZfaganQmiRmXGJu05G2KRCtaDA8MCrvLnEvAqyugjaTfslc+FXnE0n0r58B3tDPJ+lPxrw2ajz4WRVIAe8DcAnkJfnttcsFT1DyEF8/Yqd8yx/nGlylQcNE5HdJzKQPwFO2xZ/9QKzV4TIqWjwHdMEANomaLiJpc1A3TAQX/qbv7u7ptIOqCq1icX1wtfFksvoeGFxCbbDP/J0QkCJ48ja6mAidZxoHwcXR/iiHYatk1z9D9KbOLc3KKWlzlDJrUrIslxLWgkC8EuuIH5MpZu46FMM2zJyXx4e+5J6Z/RUQCjaBCGzJoM4ljnw4a3ZsQNr6H7FLGQcqusm/3Xdv8yo2fuQO+cUdN+NjpqwklcmabYvRHWzLVOXuVvHqDO1yu+0MZWoZf+gwca6GijskOyY7eI1nrtQDQaWHNORI7C/mw2+MoFQN9VFvZPixzifUvbDkhFCNhJxo5Wqm6KAgomENrHtvU4t7sFH2m0f4he15hfMs4Spw5KscW6a1jX68ozGW2wU2zTTbNg+of77YfV8dPOG3xBB0JxYI6/x29D6JZ5iFLipKGg1TehvjNq/s9DYHU8gXDKLDioEkYE0/nl+vzzZISRlZUM+eX/exBd24rVrZ3vQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(36756003)(2616005)(86362001)(26005)(186003)(1076003)(6916009)(316002)(107886003)(4326008)(6666004)(66476007)(6506007)(66946007)(6512007)(66556008)(8676002)(6486002)(508600001)(2906002)(83380400001)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vRbQrIckhzd6WWyOXvGDMaaMnqFzwRtI3cz0F90Mpsh+qyLff6RExN6DILpT?=
 =?us-ascii?Q?cGWSDZU6lqjfqg8Mx/DyvOKdQlzJgxK4FSioQhj7rVwmqZZwzU1FqiBYu83h?=
 =?us-ascii?Q?pclaaTWVlBxcrjHfISTCzGoNfbqWAjX6cwQ1hE0sMNFxbGQxXJiysacx2sA/?=
 =?us-ascii?Q?ciDAkA8YYK6S7ZoDUVKJ7JCAJW9ww+7Tme6tTJaZ23mCt6iCz4KvYQa3ivJm?=
 =?us-ascii?Q?M7lkTRvlxBu6kqwX0rZbITyRidzfJdKOR9PCJmLrq6r8j/QQBJwN5Zf4Wq8u?=
 =?us-ascii?Q?nLAopc5ZWKjLifsGQNbWmQaYDlQc+XX6hx/X3EpLIyNFLjlkj543AgKPYll0?=
 =?us-ascii?Q?rud935BNvJprEbTDVQ96R2+wOlA3O8uuXV3X6FZVmAux7Rfc6wfBWeMbVLal?=
 =?us-ascii?Q?JaR07MLEU22Z1gZfNqKc1cY9gqqxCTgGfmdhbbNSyPsPe7SMJvIiPKLd0npU?=
 =?us-ascii?Q?n0uO6d4lAZLOZPwgg7TR8fORTKCOLQb2EnNto2S1ccItpOJ9MLAdNXHENCWN?=
 =?us-ascii?Q?y2tI8SsLn9vZVYjpmHvNM7mGcKd063A1l/+VFY2DmlK7oYXs9y8uRGorRUrt?=
 =?us-ascii?Q?tU1ieKOA5pjNBB2cjaKxMjWniPS0xP5eF2dkprXVWvU3ZakX0LLNiNuQfxpC?=
 =?us-ascii?Q?iwkiQDCiQyX+ArTrDWJmeavuBERYEqIA8fNt5u9E5O8otdwdnen0VgopxGUw?=
 =?us-ascii?Q?2FCS6vcNpBm8kqEPwBCnHGnu8NP+U23yvyyANyWfpp3owIjWst7FqmknLfAe?=
 =?us-ascii?Q?H0rWXJ7AzxSz+PfYW8SI+QwTrVfcOXE7myEbIn1ZBGGmZOtXvowZO0uWLX4o?=
 =?us-ascii?Q?iAMKdp729AORM6ctfp/Pe7QvNMa5LXIRJR9NJxLr95xhXsmh6UjMWaQtIkTZ?=
 =?us-ascii?Q?x6/tlU5uIBPrUgp8ym4LBuf0mvskKxs3JWut2csFU296kRJSJm3I7d/74MHA?=
 =?us-ascii?Q?bWM4EY8mnLAC6OeOPOFGsOqm94wvv6Lj1LDkGrq5no7pMDlGiPLdOW22ofiJ?=
 =?us-ascii?Q?eZp9ZLOk5Nm2PvSL5Ai0+UN1EhkRiFgOtR5HFfqNUMCoARUMh3eek+dkjME2?=
 =?us-ascii?Q?7BCMQMOZzqZsDLqylMaBJKCx97OD5ezYAiE9WysS2QblnspdR7EO81yBAKY5?=
 =?us-ascii?Q?RStXzwfYDQwFCAmGTIsEPLjspqs0/RM36YOlQG+27C0y1NjCuF+ks/jhPg9k?=
 =?us-ascii?Q?aeUBup8CkjEZf29RCAGQ7tF7Lx5Ku6SMxfCVN196djHPhRc96MTvxMP6rf5y?=
 =?us-ascii?Q?Q7WHbZ93izcCtd2+RoUenWZcNi0mJe30oLkAoiXT4asClQeZ0q/XLt+Jps7N?=
 =?us-ascii?Q?uV3GebgaILrtVbRRmuxi3T5noQaze2t7QByyvsRgJFUaz7szQyQ0OFt3hH8+?=
 =?us-ascii?Q?avXHMoRtt8bGjJKUC8QNt7vF5WiVk43njHzsY1VtwTYeHNVYZHgyNRwW9hpx?=
 =?us-ascii?Q?Zj0cFdZJlbSDHzWo+DkoWeTxcm8lZCoKWioEmza/7kNHh6yH1venioDcZdd/?=
 =?us-ascii?Q?lvleDuuRZYIW3N55m/wo5vfpRJjflU+x1Uw9aF/idtwd83rAdpoSGHwanV0Z?=
 =?us-ascii?Q?wb6cvghpTnET6Y0ggoadlya+MQmti2YECw7jdihE2JeU/5Bz0ZxQOiLm4jBp?=
 =?us-ascii?Q?lfe8KTjb85wJ4gEIh4K1+Bw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a2c4dd1-660e-4005-c829-08d9fc6a2be4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:31:58.4943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ATebPQHG9ALkvZcZiHELmaqZS6WmvyynF9602OhCyfLtdGxHP3gKAV8bpTAfiIKA3fzsh0+2tCxA+6zT/CFFLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1942
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The currently used names rtnl_get_offload_stats() and
rtnl_get_offload_stats_size() do not clearly show the namespace. The former
function additionally seems to have been named this way in accordance with
the NDO name, as opposed to the naming used in the rtnetlink.c file (and
indeed elsewhere in the netlink handling code). As more and
differently-flavored attributes are introduced, a common clear prefix is
needed for all related functions.

Rename the functions to follow the rtnl_offload_xstats_* naming scheme.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/core/rtnetlink.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 20a9e1686453..c484bf27f0b4 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5059,8 +5059,8 @@ static int rtnl_get_offload_stats_attr_size(int attr_id)
 	return 0;
 }
 
-static int rtnl_get_offload_stats(struct sk_buff *skb, struct net_device *dev,
-				  int *prividx)
+static int rtnl_offload_xstats_fill(struct sk_buff *skb, struct net_device *dev,
+				    int *prividx)
 {
 	struct nlattr *attr = NULL;
 	int attr_id, size;
@@ -5109,7 +5109,7 @@ static int rtnl_get_offload_stats(struct sk_buff *skb, struct net_device *dev,
 	return err;
 }
 
-static int rtnl_get_offload_stats_size(const struct net_device *dev)
+static int rtnl_offload_xstats_get_size(const struct net_device *dev)
 {
 	int nla_size = 0;
 	int attr_id;
@@ -5219,7 +5219,7 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 		if (!attr)
 			goto nla_put_failure;
 
-		err = rtnl_get_offload_stats(skb, dev, prividx);
+		err = rtnl_offload_xstats_fill(skb, dev, prividx);
 		if (err == -ENODATA)
 			nla_nest_cancel(skb, attr);
 		else
@@ -5323,7 +5323,7 @@ static size_t if_nlmsg_stats_size(const struct net_device *dev,
 	}
 
 	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_OFFLOAD_XSTATS, 0))
-		size += rtnl_get_offload_stats_size(dev);
+		size += rtnl_offload_xstats_get_size(dev);
 
 	if (stats_attr_valid(filter_mask, IFLA_STATS_AF_SPEC, 0)) {
 		struct rtnl_af_ops *af_ops;
-- 
2.33.1

