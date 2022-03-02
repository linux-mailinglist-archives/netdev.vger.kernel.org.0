Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015F74CAA4A
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242288AbiCBQdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242506AbiCBQdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:33:22 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9792191
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:32:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxSmWyJKYDZxboNmPLaClrVJUbaEfjZkImtw3cL0hdNgc0kx2f0FoQA1pHS8gzLM6OCEWrsKGG3bG2PZaNA3VQ/Sv2DqM8qG13w6liIGdJpVlew/BWw4DcadGtqNEVUxbkiYPb3mFU2K92L2Kjsqc2eHJX1xNJJfsKE4FIBG+cdM4OjzixfnienIVOqOUXOoFeGirj1QFcHD01tFkE+3Z6mTti+PMoKDA6DCWQp+/BlFb73Hrnw7yQd4ZDkuiiB8V6ejsqOPz3ON/BkqYfokrGtGQiUsDhzGD2FQSrwwGp9mxOPRM2CUpxg/JFE4QwoxZqU4qifrKIOyI0UM+CmcOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uypNV7VZLUKScYpCApHFh6bts3FMc9rCq4/iJyLDu6o=;
 b=bvZsgzm8mFe1wHkWM7iz+qrurII1J0Z5uG/Yo7WRZjqFKMoJ7BCOKJCs8B3PI/3cdoHANaQ7wD4h6JIITGK9ev0MMB4g32xyykV9F5FfD8jXUmrm+NgJapo2/spYFXgLsZQWQMFDor/tKvf4Cwv09V7ZQlVL1mpA/lnPWUmYuipA3aOSZcHWfhMf8rGK97i0+atrA8tNeRQMiliyXJx68fbjTJJ1ISx5ep+ymAnFXq33UKLuIwu5OVWfSg+KFM1AC6B0+VFhPC0g/qfpbis2EmcpXiytQEwF05x02EB57gK0KP6f8QavvsYnIeZETzC2ukYhkdhjFIAlLXvObYhPDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uypNV7VZLUKScYpCApHFh6bts3FMc9rCq4/iJyLDu6o=;
 b=W/b+bv3cbXvWbm5vN7HMBEyMoR3lZrUHJVQ3yPWY3NL/8K7NDwMj9hpPYtqdZ2mykouBT4p3aNJTLSAJ1mwjjtclrYrfBXntM2yOlA5xX3IN22OvZ01OILCo27bDXjg33x8UM82oXLwEPv2L9IcWYTOpGT7skzu62ACwVoKrYT9VTDlZSTIEV9U5IY/RY00ie40BNGKeLhih1kMhnd1tEzwj5I5/VNjP2OL+W8jaemsL0bPi/CNOpfzpyGAFY6yHOoIvYs7KZglWe4B3dOyHpg3wyb2ZXL2e3zy2D9UB2m9QnSfI/Oz4QG3dEUpPLWkjZnbJtNqmz/gbIPoBj2vVSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CY4PR12MB1942.namprd12.prod.outlook.com (2603:10b6:903:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 2 Mar
 2022 16:32:24 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:32:24 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, roopa@nvidia.com, razor@blackwall.org,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 05/14] net: rtnetlink: rtnl_fill_statsinfo(): Permit non-EMSGSIZE error returns
Date:   Wed,  2 Mar 2022 18:31:19 +0200
Message-Id: <20220302163128.218798-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220302163128.218798-1-idosch@nvidia.com>
References: <20220302163128.218798-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0009.eurprd05.prod.outlook.com
 (2603:10a6:800:92::19) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6af9a791-67c9-482b-b397-08d9fc6a3b9f
X-MS-TrafficTypeDiagnostic: CY4PR12MB1942:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1942FE446D3ABAFB867306E1B2039@CY4PR12MB1942.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wXBA2KRF+kUHibiYNwv7NOfP5bjQKMXBGFNqU7X2g9WQAwZqu0PWTy2Nkgd/pACfLumAQR8ZL6Rhv2+c2FCO8D7L01RW+gSO0K+0dPvKLJVv8tyCpG/b60nY+2MZJSKzhgTrk5RvynD+upEaewQiUmOhW8g+W4vRUfFIchjRXyUTv6cHfKLsueS3Y0MCYqULrwSzzDRQ6wdVa3iz8ehiMyoDw2IFz8eYDggCp7LcsL+XymQ0WbTsK17b1DDqq6l4IDIyok6bDkfT4pO7piEvAFqVlz3xugkdVSxLLj+/KjAXYxp0IVqQchdHUP01imJc6qP4MobHUzD0J9qpgpsR5P8Uw+Uuu4due8MhR6iMNphn0xCSm+3SC2Q/KayOHGaRQYaTi8eP1DClOYjULsZmcVL3CjApDW44OWB3evxKAp8z7Bmp199TjBZAsJKSttmT/lZFAvf6acgpJHIJK2lU3L3dmw0WsO3Tkg5KH2dU7xFiwZtMR5vQDHUo0HsHdqak1jkF2pYjCAORGSh1c7sYLoSyVTQ8c9/n8+jtFZBQ1PGOPmtZ9ijfMshXWm8HdEY5jRIZEjF50Go7X6fSUXCny3tDV2egZYMLgr3Qxx/wDTJEMylBqEQez5abBxqs76e6ddP5JU9wbc5r5tvAa2PPDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(36756003)(2616005)(86362001)(26005)(186003)(1076003)(6916009)(316002)(107886003)(4326008)(6666004)(66476007)(6506007)(66946007)(6512007)(66556008)(8676002)(6486002)(508600001)(2906002)(83380400001)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GBFcEtX15rpC3eSZ+BFkTITOAmR0TUuO5ZaKCUvlRGPEDQnRLqIgMnhqr+tm?=
 =?us-ascii?Q?NBNDhe2pEk8d6zB97+DsobSXvZfwM2exn6LdsqBTWhPjSG/qoHS6XF13P6Ok?=
 =?us-ascii?Q?msly2RbDwrVdlca2NrkIF+a0cfgKVkHMpDgXHLfr6ImeA9DXlyU9OxM/4lvC?=
 =?us-ascii?Q?oNhFwfnGz92dNdvD64R+obz6QoN6ZZpazm+/mUN1ttcE7oaOnrQugOJ2Ij8U?=
 =?us-ascii?Q?fL6xOQDmGKNr/9SvDzF2i6nygPZQ3yhVFe11WiU2p3HNxdIwj4Odc4m34YFx?=
 =?us-ascii?Q?CNXgjGGMIwNUX0Z6lcaItShI3X2axSCaH6AgcmhJs8tMAxd47J18q+WdAwI5?=
 =?us-ascii?Q?rUt331lajJ54TbUmfQOZsThWXy7hdmikxB9N2gPNYoGS1S8q+lsskiQAxyQT?=
 =?us-ascii?Q?L009yMXNpxvsyCaLfZS5slfUMd9hen5X8NqSfkICxGfadPCp3ID29I5SK0AQ?=
 =?us-ascii?Q?eH4cN2sEWuXhPpd0Bq1wuEEqhXTb6cPU9oDpipMAxRKr5IZ191k/K7HorrGM?=
 =?us-ascii?Q?qzk2icS8kl0+VCZLadykDko0O8ZhLqjhwMhxOkkU+GPGjt0AcS8W2j4klCWS?=
 =?us-ascii?Q?HF8iXCpOR+LU6B6RtIm94yw8oskgRcGZ+fEQ93XcVqPrhz6wMrncscK70O+1?=
 =?us-ascii?Q?TEElvIeKkHgEHKf5N+agUUv9c3yaubB1xBdODDin1wfwHzafY5Hhp3Ba5lvO?=
 =?us-ascii?Q?TSB111vohI0MN3jgrq2L6+8zFHFzfLizd0kHb/ke2XZ3fNQswttGPTmQbear?=
 =?us-ascii?Q?fg+jIPKaxmqJE58wSoMGQq1ttEBFW4WmLdT6CsapIZohYaDB8GPhXa9V0Nsy?=
 =?us-ascii?Q?yZEQjmY1wS2IoGq2jJA3i3u8yCGx8INvFH1ikTeAxdfbnSExGYAX17X0+jW2?=
 =?us-ascii?Q?ND9nIKpQFLNJo+MogjIWXHJJLn2j2rMlnoIV1fSPi22tAS11xko9FcFV3v48?=
 =?us-ascii?Q?nnu7NXXs55lZMNio4Acsc5pYM8HlM1NLzgOm0l6JxXAZAK4jaSoEJTZjtq0F?=
 =?us-ascii?Q?xcu5z/CfEtvesyqd8cT/Uo9MCkoSKPZUHL4Tj0FuYMfKypcBvnh1mZkq9iix?=
 =?us-ascii?Q?IYyauw0gj6AiespMlnZCNzTsppeymNBeN/xc3KvKYvD9vO1XTFebaiRucfLY?=
 =?us-ascii?Q?gjF5WNqbx6GvJgLRveipJmNyA2kmVLBq/7YwEq2SparyPxp5wOYe10nVHkto?=
 =?us-ascii?Q?iJnBsdNSfTrq75Omxbc9k6SBmPyJFHWfEs2kN0F7q1SPHDAg/CVN5f+5JnBu?=
 =?us-ascii?Q?S7WTMdAB9OU86XUs2pWYY/fxGd+rh+gBFUrmRJe41cXYQK4wCdqoNZFyAFYi?=
 =?us-ascii?Q?M3fVGpQHK6JIe2+mNdhDlR6KK9UY39I/CoNv3VJHFVrZpSrDqfCSIGcfCc6Q?=
 =?us-ascii?Q?CESTwLNiBsCtPfl3wOGMe+ZxjeiqHzvneKt3+izrrjDHXbj/f0ikjQa/75bX?=
 =?us-ascii?Q?ycYOahYhseGB7C0Nh7kcE2UJxenITXcSquDFF2kGMXZ+RqlHZUdIBxWqI4Q4?=
 =?us-ascii?Q?bk1eX6ZaWltiRrsw/JUS3DpyekY1r05Z7r0h+Mv21+3f/norSFbM6OarAU5G?=
 =?us-ascii?Q?x8TxKOuN6BnMLhzTm55jHgHSVGxXsjL91O8lX6hmd71dLWvcXHBDtqE0cXyi?=
 =?us-ascii?Q?hN2MZoQ8xP2ApQ1CcgiwXDk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af9a791-67c9-482b-b397-08d9fc6a3b9f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:32:24.7486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xe2If2tiXEAM+xhcBKWWomtSjTb7d5vxAcgKaWfv1HcYmZxRsIKG5YqiKOpkBASoX3q+0+1c+s8f+15tf6ak1Q==
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

Obtaining stats for the IFLA_STATS_LINK_OFFLOAD_XSTATS nest involves a HW
access, and can fail for more reasons than just netlink message size
exhaustion. Therefore do not always return -EMSGSIZE on the failure path,
but respect the error code provided by the callee. Set the error explicitly
where it is reasonable to assume -EMSGSIZE as the failure reason.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/core/rtnetlink.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 594aba321f42..4db1d6c01a7d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5177,8 +5177,10 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 		attr = nla_reserve_64bit(skb, IFLA_STATS_LINK_64,
 					 sizeof(struct rtnl_link_stats64),
 					 IFLA_STATS_UNSPEC);
-		if (!attr)
+		if (!attr) {
+			err = -EMSGSIZE;
 			goto nla_put_failure;
+		}
 
 		sp = nla_data(attr);
 		dev_get_stats(dev, sp);
@@ -5191,8 +5193,10 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 			*idxattr = IFLA_STATS_LINK_XSTATS;
 			attr = nla_nest_start_noflag(skb,
 						     IFLA_STATS_LINK_XSTATS);
-			if (!attr)
+			if (!attr) {
+				err = -EMSGSIZE;
 				goto nla_put_failure;
+			}
 
 			err = ops->fill_linkxstats(skb, dev, prividx, *idxattr);
 			nla_nest_end(skb, attr);
@@ -5214,8 +5218,10 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 			*idxattr = IFLA_STATS_LINK_XSTATS_SLAVE;
 			attr = nla_nest_start_noflag(skb,
 						     IFLA_STATS_LINK_XSTATS_SLAVE);
-			if (!attr)
+			if (!attr) {
+				err = -EMSGSIZE;
 				goto nla_put_failure;
+			}
 
 			err = ops->fill_linkxstats(skb, dev, prividx, *idxattr);
 			nla_nest_end(skb, attr);
@@ -5233,8 +5239,10 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 		*idxattr = IFLA_STATS_LINK_OFFLOAD_XSTATS;
 		attr = nla_nest_start_noflag(skb,
 					     IFLA_STATS_LINK_OFFLOAD_XSTATS);
-		if (!attr)
+		if (!attr) {
+			err = -EMSGSIZE;
 			goto nla_put_failure;
+		}
 
 		err = rtnl_offload_xstats_fill(skb, dev, prividx,
 					       off_filter_mask, extack);
@@ -5253,8 +5261,10 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 
 		*idxattr = IFLA_STATS_AF_SPEC;
 		attr = nla_nest_start_noflag(skb, IFLA_STATS_AF_SPEC);
-		if (!attr)
+		if (!attr) {
+			err = -EMSGSIZE;
 			goto nla_put_failure;
+		}
 
 		rcu_read_lock();
 		list_for_each_entry_rcu(af_ops, &rtnl_af_ops, list) {
@@ -5298,7 +5308,7 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 	else
 		nlmsg_end(skb, nlh);
 
-	return -EMSGSIZE;
+	return err;
 }
 
 static size_t if_nlmsg_stats_size(const struct net_device *dev,
-- 
2.33.1

