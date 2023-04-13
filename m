Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D972A6E0AE2
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 11:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjDMJ7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 05:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjDMJ7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 05:59:35 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3682A7AB6
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:59:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFnZxQff3uEPF0F+TeJyL0J6VEkFWkKyXeSSigPKVrTAO9YGT86S0lIFAvFY/Erzb6zPzf2AzEPMr86P9Ci/4c+slCDR4IRgVzZFCIaumvPnUqRc932S54zOO4Z6E34y3fd5Gs9duz4yjJrz6GGfPjUiQDWN+sWFlhvzrKHWGDJRI+8ldo1BTJSQDKoyC2pR2TQnoxDxBHjxJUaey0Jvw3mYu3xvCtRuVItaq7HB/x5MZhJI++BymF4OKYWGdiA9TpC0Vkmvf2/RU8tVveSkIjkU7ANw2aTQZ6JX7Cbp5K4CGS8RuRT9FCNNk0+wx6hIkiEmk0ksK2KOKdvPDlZr+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bwfQnYosgyTCzsOoJa7Ffb+0KyzF3LYxZylri88XmIw=;
 b=i9xprIryTitVpFIVcj2rc2AoVvXSZpNMg2wItoOWLjBY+FGyaVwpsOk8R8YPblpSgDmjvIyJKusS0JINDJQ0aGw/SaAi8kb5Y8cxOqc7PC9rx15RCxDFrMQOxbl1DO2a0rZowoL0Gg2zP3fYRvn0kM4/TgKwnYmW6BJQZdfwqY7weSzzN+I03WcTdQQtoJp4QPZUheSY6kzkOHEWYIqcZzavO5PGpNhRfKB8pSwb4xATFSvrtRVp+qbotDM4o5Zu5krkWK/NEpg9NH9DoZeorOQIFDG/qpcImCz13z67XWTYxUU4okyPKK+XYZrHX2W2t7xJYVcqgMuy1TVYDQafHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bwfQnYosgyTCzsOoJa7Ffb+0KyzF3LYxZylri88XmIw=;
 b=l1k7cJXO50PU/tL6BSDZ3UrfuyUiM6cnjtTNjZlJSOZgbyOuKQmv/+KtykcZ90LOtGWO+gl40iDs+y4iG5Q5UpUEuc9D6gLtFZ9mebRe12CIc222eQIkSQKChEAoGUpkwzXyo6D0ZAXgpLXLj8tdfMJgDjYTK93/wDmaUwn4ZjvHh2sVF8l6aTba4b0YCU2+bkubtMliDb43LsiFdbhPZ7ouCbEY0nQd2Bz6t+X8HTQSYgZsTiDiQxwGnxO9r1vwntEc0/nkX5fbGHRyL0TPOjb56p0/hzP4qWUm4S8jQ9yYDzr+Qgx5gGz8w2QDNdvS106YA2oJshJUcZglovO9rg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN9PR12MB5274.namprd12.prod.outlook.com (2603:10b6:408:11f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 09:59:26 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6277.036; Thu, 13 Apr 2023
 09:59:25 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 3/9] bridge: Add internal flags for per-{Port, VLAN} neighbor suppression
Date:   Thu, 13 Apr 2023 12:58:24 +0300
Message-Id: <20230413095830.2182382-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230413095830.2182382-1-idosch@nvidia.com>
References: <20230413095830.2182382-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0107.eurprd09.prod.outlook.com
 (2603:10a6:803:78::30) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BN9PR12MB5274:EE_
X-MS-Office365-Filtering-Correlation-Id: a6113915-9812-4c1b-f42e-08db3c05c3a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AdnWec5vdHKvzCxdoNhKgpQR/FceCoUvDP2SoWnQgJsmsUoeiCIluHnyfsSco+KmnW/s9EIR5VpciFxfQ1nTV+KyRw4nZ1Oe3h5/9sCsQ8odVzzsXM5vcAKTO4oiUCH0vkvzMYAEDz7BX3mWAF/Q2g3P1juAFYafS2UfKf8Y7wDwSrF7ZL37A+dyPbZMjGceG5jhKaI4zRPx7GD9Ydtx6gk8PNEeaZHtV2ZQ520Z2V0TlvUvneDsdBM+Ps9L1pwoGKzEXpJVZ60UeLQzo5rXd3muP7yEWq8DNsUdkpUlMH0LhKvMwiSrXzp9tX/g5eUQcEO1ZdR+ILYitz6oJ2abQrINK/xymzRRlVBbO23sPae6+WW3+UUawcNoaTRJHXWKTthVNt+707Rh7yyA2pXKDq8gjW0eItKCb5PpaUwTDWPe6y7/wvNGv+vYQepuVw9TbSvAwd6Y6Mex+4a7WIy4i9eupc1nsftpErmYTTrwPGnoeDg5GYuHM78X3CjPUYHID9Gk0rYUh4xtBFT+9niWeo8sUUYI17NnRx4MvylT+NDcMRGOnaY9nvzzLfQfEaQ/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(451199021)(1076003)(4326008)(66946007)(66476007)(66556008)(6506007)(6512007)(36756003)(107886003)(26005)(2906002)(6486002)(2616005)(83380400001)(186003)(86362001)(5660300002)(8936002)(8676002)(38100700002)(478600001)(41300700001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pX/WmhWRvNq0KkUIByFD1sAKqmdYrbaWgNmeV1Bt8F7mDtYLbffO8hgWkQIi?=
 =?us-ascii?Q?Vdw2lQopNZj0iRVR7+nrBOpjzkpxd3833SiqVQboIjXIJWXEGIQjkNUu7gRo?=
 =?us-ascii?Q?SYTllJmxpB7XHA5WY5AfdrXVQop9YD5m+MJcfIFw/JawKLAi+BkWxzxfL+c7?=
 =?us-ascii?Q?sxj7aIKo7Sysjs9TQdiPtjP8jAJfbc8ukLrChQfbUjPInF1j5NNxBmpG0S5e?=
 =?us-ascii?Q?mokmJM3f7Jmv7iORSmXKqDH+F4DPE58j9b6eeeofkVnBb0qteNtQ9R7I1uQ1?=
 =?us-ascii?Q?9G4WAG00vpGt4YYJm9YjcCfhh9uF17jueieN9E6WdbpV0+vzKgmfYIpFamNH?=
 =?us-ascii?Q?soHeKRd8J/nTHngzvpq5MlCzntI2OWggklXPvXkfnIhEKFsjxsc/sm6Q5CLv?=
 =?us-ascii?Q?tou7FA3XO4Zg9DcZT1+gqtu+U0u9I6YX/tFUd+ZfJ41RDFSmrypfXYjydHHh?=
 =?us-ascii?Q?wba/KR8+HuC74oJj/yaQWWoO9m7/3G2XU91rL7xDVt0cGNATVBofOgv6AtX4?=
 =?us-ascii?Q?wlgHIiMmvr1XmDB3JXcUB/a5Zk0yhCX1/z3wqcmY/ivh7reJu2TUfdS5dt0I?=
 =?us-ascii?Q?Zx9oaHlEbJUakBvuu6mQbt7ZEfc/I4bj6y66LrvylkMzhSthYhQFE1Cp7e2P?=
 =?us-ascii?Q?garmLeCFEJxO5QE0UFrtOXZ7VHHoPy6jIN5b/4cNd/a4MCYNFaHFOIQIDSaC?=
 =?us-ascii?Q?S/Xmoezeg+if9V13zf0Mb+ssbjXzZ7SbUot26unvemMVCKMXZFgCF9Ys04V6?=
 =?us-ascii?Q?TDoYK9e60/NtdXJ0535bSQmrvjYZpH28+2g10g1GBtNt4ChLt61zh4vrkN7W?=
 =?us-ascii?Q?omexJzq/09FVfttsak+tqm/t7Tqn4zcxRFHiwyzRVyk9g49HXm5yrPl3winD?=
 =?us-ascii?Q?f0JTzkv3Aa88GZuacAHG38XQKrhHY7icD0WcGUI4EsCB6hg5+X7L1c8+UffV?=
 =?us-ascii?Q?F4djmDqDY1WBh93YHqilXP1/vIt8rcM5+BvbYvtiuPzRLPxFy8TUN6fl9mKi?=
 =?us-ascii?Q?i9KVaMUyBl6Shb9nKv35bgX/RB0Ef+U0u+WNBm4m0v11cp+vT7KdZECzZ7NE?=
 =?us-ascii?Q?dNsWdzCajrQ9vrCqHicyG1mPBnuCunyi9VI3dkHapXtNBPDbs6GMXi2Y4umB?=
 =?us-ascii?Q?XTG3l5YuGCGvJiPjPuEMTjKk8wepX5zk7RqMFs2fYrOx+3AjNdy0aH+2nCQO?=
 =?us-ascii?Q?+aNGp7afGa7kaU+CiOqWTnPM3h8EOO7b2BSt7Ar1PvbPojy/EjXC9hbcYTm0?=
 =?us-ascii?Q?0i+O8GYUPKrYlD8mZqbr4xt3najncD/I8l2rP7nISjO5uqiAdoNzhv4nQsc6?=
 =?us-ascii?Q?Dfc8rxBEEnTPQR4VMRoN/CwpB05lk+cCS7N18wQw6mbqoJEHBHXETmAojnmL?=
 =?us-ascii?Q?KyGVWHAcvmO6Kyd039/ueKt9KoCWQ6WWAiqaN1JzN1s8odS3SKqKRh/Aghk+?=
 =?us-ascii?Q?j9hH5JtPPfoFaIV8R2we8e44lpeue+oEoNZUkTSB9S3lSn3huYJNXBTlszGC?=
 =?us-ascii?Q?FBdfn/FtrU0Rsevu5LbBeQsNiRd/dLiJcWHMZgzajeGu7A3pZ5twXF4x0n0i?=
 =?us-ascii?Q?it8Gba25ZhNSPpyLFP2BcK9EQ2uGULAn91G+JJfg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6113915-9812-4c1b-f42e-08db3c05c3a4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 09:59:25.9296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JaWrzhz2Er3mHGNJgRZ1Py8Vipz/sAUii2e08Vswa0KhTeuC26Yf7a86OEjtYGAT9Z+nHjnVTdDozB/STu73rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5274
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two internal flags that will be used to enable / disable per-{Port,
VLAN} neighbor suppression:

1. 'BR_NEIGH_VLAN_SUPPRESS': A per-port flag used to indicate that
per-{Port, VLAN} neighbor suppression is enabled on the bridge port.
When set, 'BR_NEIGH_SUPPRESS' has no effect.

2. 'BR_VLFLAG_NEIGH_SUPPRESS_ENABLED': A per-VLAN flag used to indicate
that neighbor suppression is enabled on the given VLAN.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/linux/if_bridge.h | 1 +
 net/bridge/br_private.h   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 1668ac4d7adc..3ff96ae31bf6 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -60,6 +60,7 @@ struct br_ip_list {
 #define BR_TX_FWD_OFFLOAD	BIT(20)
 #define BR_PORT_LOCKED		BIT(21)
 #define BR_PORT_MAB		BIT(22)
+#define BR_NEIGH_VLAN_SUPPRESS	BIT(23)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 1ff4d64ab584..b17fc821ecc8 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -178,6 +178,7 @@ enum {
 	BR_VLFLAG_ADDED_BY_SWITCHDEV = BIT(1),
 	BR_VLFLAG_MCAST_ENABLED = BIT(2),
 	BR_VLFLAG_GLOBAL_MCAST_ENABLED = BIT(3),
+	BR_VLFLAG_NEIGH_SUPPRESS_ENABLED = BIT(4),
 };
 
 /**
-- 
2.37.3

