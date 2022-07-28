Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC3F583DF5
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237119AbiG1Lq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235297AbiG1LqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:46:20 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0984551A27
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:46:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZCMsVBlCHK3Rj+LtoxktB8Pk7B/sUBEp58qWwyI80Pyg95cOqRfKvFUi8uoc8OpFR3IH51TnC9j38Jwk/G8sGy1bm1gOQ/MMqUezNOJWABsicXB7+Quvn73DFSG/HGqjVHaHOFs4AQla83eLsIYjYnkA4OAd/KFmtoGc2nw03IdzADqdq0H+A83HFw09Lbotda8tJ7HnLc+euN2wtPp3i+3+NcvGhDyrPCDB3U23uwXXpHDM/eOy5UGNGaWB0BkiiDj4l4lvVv03AToJ0QGzIe6MwN5WSG37x6DK+xaXkxUS/XdkreOCdlHJIzYvriB4kRWX7SNi2MBHgnHIO1t1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dPmiHBzb3mD3qGDBaQjjuUoG1Y6oInuMm973BXpg/n4=;
 b=OaxvINCSJQj2qRNwcrJrUE0U31/DKypfvHayScAl8LTvNWnZoYoOYV2o7EqyCw8Zu7ASoYUMRtPoV3RxK20S4GboC/4YYWo2yQWzoHzIIck7YCYhLL9b6WyRYpcm0j8lPAv/la6/rU/N+f0IDEuGCOq/6GWTKBiW9Kvg+UR7JoRGUd0sXf5h6DDvEp242Zq2ctWkvmDmmtshJusgNTQlA/HA6T6uM0048dMqf13xDLFFJpykp/xj034inBfXaZrbMXLIjUsHvKRNt1Onllff19UhVBQrIkgvxz3J0W7Ts+vSlwqxy2AqlbAadQzPP4+YlyHuvQzXZX48YYlp7tttbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPmiHBzb3mD3qGDBaQjjuUoG1Y6oInuMm973BXpg/n4=;
 b=e5GY4CcARLaeCe6U8JKGgUCwpCjcaSRaf6XaLAwNIwWTdhKWwvqgYrBLe5Nt0V16mqoeqQ0p9HdP8hSThRPUCfXkG6YJfNcnJlDYQcA+N6EnQPMDqfbxYbhcsUEA5bQ0OHTjnPzLqyTBUkwJECiCHpB+cABJGrgkMhPYc1qlraNxFx981/g7/bjMUT6HaRbWwbRHJBjSdWMX5EHUgdVGJlb10MwzAuZzrtYo32kOA2THhWN5Jvbm8+bi2sbQISU2k1Re0XiPknKPJnXswo2YPZoPa7FoJ1iwbZqzNnkqsc6XMv+mbD5I/qDZtfP8CPjYeQwW9IyBhDTPL9DfiOU4uw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW3PR12MB4505.namprd12.prod.outlook.com (2603:10b6:303:5a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 28 Jul
 2022 11:46:17 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2d48:7610:5ec2:2d62]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2d48:7610:5ec2:2d62%4]) with mapi id 15.20.5482.011; Thu, 28 Jul 2022
 11:46:17 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, amcohen@nvidia.com, dsahern@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 2/3] netdevsim: fib: Add debugfs knob to simulate route deletion failure
Date:   Thu, 28 Jul 2022 14:45:34 +0300
Message-Id: <20220728114535.3318119-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220728114535.3318119-1-idosch@nvidia.com>
References: <20220728114535.3318119-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0153.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::31) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98956743-2bf9-4d5b-0de0-08da708ec82c
X-MS-TrafficTypeDiagnostic: MW3PR12MB4505:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: exJc7enDmuYs0wQF7NITGPmpTxKmFvUoT5Ji+kRW8iAlK7HLHaQho1yqykPrhv3c+Uu3I3S/Z0q62v24Kvp/zI216B+U+l2VWzLtw6VihHeZxax+Za4UUoojjhlElmaVa8ZayMdRFE5+FelFqs5G1xn3VNHI/wG5bl+oD5eEOfOHSzklhbnxnEW6FzL2sVmVe/+NaYZJ+y+zWlqfDKpbgH/BmQwx29o780ik0JBnC8Ycq+kcdVivY+CpLH1mqAw5hsAlcTvolFNk89hesSxDbnlqH/HOSWqJXSR9pNbrAc1GX7UJ6xKz1L7nrmB+aPB+iHU44s5XbCN7hLkqm+/QV531cKtL4asLzzCTSqhWGmcHeM6hQQX7AiRqoYIwu7Bw4Rrs6t0nOaHRkZVKBrWn0BwFfw7pL9eE958h+6Ap5wGnQWFWllxC9VbkZ/9AtdbKmPdc8WMtCjgk3fQ0/o3C67Ei3u7pMjlQNM2UwAI+7lJTz52/uCL7zy5adTNPshN0osX1UtQGKWumQtW3iHpcI2LygkFuvZmogqepulxoWWYTOucqRuRmuyjtnzVrdNkZK1chHCXzF4i/m889U83Tq9CF5hr8P7p3N41DgScWnL13YxboFV3H7qjqowv4Ir9dXQjk0Pcfho2hSxzqleJMRKHY7cBE3IUGT06LhQJmtOGMl/2pjAyr58ygxf3us5tF+DJ/CkRMM6aAEu7kG1EBQdgUKrbEkCX0wo+b5jU6ZqfAYjFW2GX770ZaaHQZy5EH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(396003)(366004)(376002)(6512007)(41300700001)(186003)(83380400001)(6506007)(6666004)(8936002)(2906002)(66476007)(478600001)(6486002)(38100700002)(6916009)(5660300002)(107886003)(36756003)(4326008)(316002)(1076003)(26005)(86362001)(66946007)(8676002)(66556008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6ohOpPcdpzkCHRQzY5iVfrWjtc8j8SKNYBzncP/7QRLStmpt0n/gRg5Zv1cX?=
 =?us-ascii?Q?Gq/fpCOBrtj+zwGqH9X2HUt95nEeTorS3S5E7LdC2+jTeNoix1jevonzFwUt?=
 =?us-ascii?Q?LCMMS+dDydrzxWd5vIYFOTEKIdJ+qZsTODxzUOfEFip+zW48vVPgM9CiTGT7?=
 =?us-ascii?Q?CyWczzJG+92odpcRVnVEvjw8SomHvJR+s1DC9KaWe4TkbknVLM++KEfRDLwm?=
 =?us-ascii?Q?zk/4fQEyv/wFV32PTfsWRJeoyoKnZlXMM9aS5zf/aPD05Bb70Y2mTO7H3Uw8?=
 =?us-ascii?Q?vQmhCR+AzKxjXC8T0XC75ilynuHTLTsktU5Le+6iYWOStaODgho9mQbeO9Dz?=
 =?us-ascii?Q?uBmdpqZUuykh1GKO4CJc9TS+tmgiNmx3dYVhfXc3hOMCOWukBUpQWVhr01GI?=
 =?us-ascii?Q?hRrDRnDqHEIR2yiW23RLGndphlDm5y6Rh4z7hYZVaGS9WTIQ4f85+sSxP4dI?=
 =?us-ascii?Q?r1V22UN0g3VfOCHDbMJcxAolPLqOEmZwfFaI4fxnP0+ZGHr+mqsRbPMdAmkl?=
 =?us-ascii?Q?svSYAB0zF9LXtEPX0yQNzfz+dG5FyLjW36Vh6UVV4GdEST0N6mCv1eqzxDzS?=
 =?us-ascii?Q?jyzZY1dA912+HJcT5KjC4EFeJCabW7uELP8faF6MjHNt5k7l0JrRQG7DtNeD?=
 =?us-ascii?Q?9F/czygoSgswCzM7XS021NTrA14LCd3H4AkD0BdDc6NCqjGCvGKcy0hsFNn0?=
 =?us-ascii?Q?ei/I2H/7+Agx1nQ3SkzvM7yPjCTcg6WY1qO9wgc3IcWSsK/lYlZFNg8ccW13?=
 =?us-ascii?Q?MVBwHbPsJPsPKCmRj95pAH/Qr//muX/qczsr72aDA+iJxNuv0gwPMNKmJ0zV?=
 =?us-ascii?Q?5JRUw/YJQykGcfzb5Xj9xs1OjdVN6WRTzvIqbZ+UCg5isZLNZNDa939owJQA?=
 =?us-ascii?Q?SYar2DMiB6veOaCEsPLMcE4hJ5A0m6YzupheRBEG4bd9iQSD4ia3ceydoB+g?=
 =?us-ascii?Q?815NOcVsCrTbxUkPqyWgdpfX6dbKkCXYp2Ah2Z3ehG9sObolwcN21R3AQYmG?=
 =?us-ascii?Q?ZPCDqLcsIeaJ160sNa3CV81HaEYP0617N2zjxvI9UvUutSsFt9kexsAtCZYP?=
 =?us-ascii?Q?xnktfYp89wLPCZY/Fdk+d0zGFa6vfUgJSGhlH9eEG1la/FMfVUJGZrh1ZD/g?=
 =?us-ascii?Q?ObdybWplc0TNFtiuozAJnB2N0kjIbM/HbHN342XEHsBIx66sZ2zcFCsN5MWa?=
 =?us-ascii?Q?BZ4HL/A6KF1pLFcstiVtAhodNKPz6y/MuOg8P35k1B02l7fE3VssF7VXn8li?=
 =?us-ascii?Q?wCVQ/qHmp/i7sWWapGGO6EFM1XQ7U63cznmSGNnlYaOSennB7bNSThTEgDF8?=
 =?us-ascii?Q?jkaC3Bi4pOiDavnWtjKktbh5N75q+1yZje6zQMLyTkqR2SzJoOYSqI7HUwX0?=
 =?us-ascii?Q?fazFJOj3xchlTndIvgvhgSqrfrt/JESvwCq22yXlnJbpSizU6hcHqpLvYr0B?=
 =?us-ascii?Q?/dM0IkiAsbFU48iCp9GIKPhRMFum2zpjwCdf9Bkbbe0dzA9PERfC/T4eot5p?=
 =?us-ascii?Q?P936f/XHGb06JB4SMvgqrYhhHXYR7hihltB9odGfGDd4KDN/1SgpiKI+SDY/?=
 =?us-ascii?Q?aQmfibxLIqKFm6KRV6gfNUlw/AlmAPP6hsbV78EI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98956743-2bf9-4d5b-0de0-08da708ec82c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 11:46:17.3124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: msy7rC9XudQVWT+6y626KtA94b7L6K/UTh5Wa99F6Q0LZOaCW3wPzqbUEyWVlR+OZGaSFbeK30d+Nr3XdW9tTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4505
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patch ("netdevsim: fib: Fix reference count leak on route
deletion failure") fixed a reference count leak that happens on route
deletion failure.

Such failures can only be simulated by injecting slab allocation
failures, which cannot be surgically injected.

In order to be able to specifically test this scenario, add a debugfs
knob that allows user space to fail route deletion requests when
enabled.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 drivers/net/netdevsim/fib.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 57371c697d5c..38a1fde8d886 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -62,6 +62,7 @@ struct nsim_fib_data {
 	bool fail_route_offload;
 	bool fail_res_nexthop_group_replace;
 	bool fail_nexthop_bucket_replace;
+	bool fail_route_delete;
 };
 
 struct nsim_fib_rt_key {
@@ -915,6 +916,10 @@ static int nsim_fib4_prepare_event(struct fib_notifier_info *info,
 		}
 		break;
 	case FIB_EVENT_ENTRY_DEL:
+		if (data->fail_route_delete) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to process route deletion");
+			return -EINVAL;
+		}
 		nsim_fib_account(&data->ipv4.fib, false);
 		break;
 	}
@@ -953,6 +958,11 @@ static int nsim_fib6_prepare_event(struct fib_notifier_info *info,
 		}
 		break;
 	case FIB_EVENT_ENTRY_DEL:
+		if (data->fail_route_delete) {
+			err = -EINVAL;
+			NL_SET_ERR_MSG_MOD(extack, "Failed to process route deletion");
+			goto err_fib6_event_fini;
+		}
 		nsim_fib_account(&data->ipv6.fib, false);
 		break;
 	}
@@ -1526,6 +1536,10 @@ nsim_fib_debugfs_init(struct nsim_fib_data *data, struct nsim_dev *nsim_dev)
 
 	debugfs_create_file("nexthop_bucket_activity", 0200, data->ddir,
 			    data, &nsim_nexthop_bucket_activity_fops);
+
+	data->fail_route_delete = false;
+	debugfs_create_bool("fail_route_delete", 0600, data->ddir,
+			    &data->fail_route_delete);
 	return 0;
 }
 
-- 
2.36.1

