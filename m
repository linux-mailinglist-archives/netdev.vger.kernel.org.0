Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30FD5B3C30
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 17:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbiIIPkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 11:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbiIIPju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 11:39:50 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F44DE3
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 08:39:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTGMX/Yn4AfdP0LQfRTjxD8hzyFABKyel/DyIdlqDHNbdymwFNg9JebJk6xtOuwcYgoVEvOEQisu6h19ks3VcJ1sm2IfF5+X32yld+cK8WBojgHzZzcLUTdKZK3rT8UcJ9cPU/TrFeHwiFePPnyWCoR2YH8AfJgydOPLO7ctduA/IB3cucSINEF8i08iDR5+4Vy8DlX6MpNwD1hx/OteriNPwUZUdOM8kH97Tjc4pzYpN0PhdP8DWfPQdXdCCadThGFqBl75rbx2qXKe9WupGIDJiQpZZEYkk+RsH01FfLoLFCgU5EXWWfKuWi1TDDrC8AuIglyxtQbyD1rqDplsPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TuKzDYgRO4RepWu9Y96nScRLDTSWO2frorNcpwtc780=;
 b=j3NhLetIbWMmJZ+QZI70fWD5SVfUGnXKYqzESN4sIaXTSUFgZOpJGJQUwmRODVzYJcJNi16sXvn2s5FQlovG1db1iWCqKmdxHorHF46/wLkHSof1tqwcOCE2vpT/ked4pOfwm9n8gSWK9ZMxjZZ1VOxv1idMX1qOjjbTdhrflpXvWjvNVU+Uf+84Fxgdz2pOcg4+t882Y1cDOqTt/ecneaHe0Hns2aCNqi8hk9mWRMpyGtM0ctuwZ8ztcf4QypTRxbgUDomOG9UV708Sd7NEDbCfy7djKhzlkEKLKpKfDe/zyOHe078Apxio2ue5PeTBeEO7YUEa9F5Tg2lxcjymaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TuKzDYgRO4RepWu9Y96nScRLDTSWO2frorNcpwtc780=;
 b=FR8dpaOKVppIKr/3s3lWloX5oaPZPsfAuxtm2I6rSDf8dtgqcZGWZFEYSgggyOX90xo/GhqJ//NSx4+DVrX+5ewiGQ1nyBaNvLjlsBehhDYUlPjgfEgNGQUbKkvSODjytP18zOizV3OKflFCZYo6F85e4yTk7EH+UNbJ2xzI+FuQa+pMG2vYb9vrUtG4ihNv1QAHpo6rWxXC59QAa12gonZu0Y10mW3MV1Ur6U9a5vlphWyMve+jrADl2TCByliaXYRC4ca8K4hnwgCVDZXVHdqQ+y+aqnMgjenn077yslFq5SONKI7ekhjrLnpbBNvR9xFQaLSxTnZIWQgtQgVxXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5438.namprd12.prod.outlook.com (2603:10b6:a03:3ba::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.16; Fri, 9 Sep
 2022 15:39:23 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4d61:5da2:6bbb:790]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4d61:5da2:6bbb:790%6]) with mapi id 15.20.5612.016; Fri, 9 Sep 2022
 15:39:23 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, jie2x.zhou@intel.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] netdevsim: Fix hwstats debugfs file permissions
Date:   Fri,  9 Sep 2022 18:38:30 +0300
Message-Id: <20220909153830.3732504-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0162.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ0PR12MB5438:EE_
X-MS-Office365-Filtering-Correlation-Id: 684e7841-d036-4727-094c-08da92797828
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AwOUmfvjLiwDcmQx+p2sEmm4Di5lM/megr/PSMPl5lwjg0Lszmo2JxPIKYTWS4+YCp/Q4duIBTduNz0nPa/2K79wcyorLj6rloZrzeH/ypUVnOwe/I91ZoaWfPU7GMFR5nRvGsgyNMO/x0j8V4i6wKKOFzLWO3IvdkwWKLT3eCRN+LaIN5gUjRUfy66c+yS9APmJ0kD5V9mVFrdvafhkQHLIvsYD5n40l5dNUbSSiKff6Kc/pRVhQf5dJzT9UQeJxmLnIX/UozOzl0fNswhXEKUB9NJcz7Khhz2NBkWsDKP4rnto8v2CX8OiNp9d5Os1dIoBY49MH/C+MCiuY5Oni2sk2tT5vx7z+5YUwBob/m3Yzymwvy/2QrAi5i4u+biC9PbHBJOilTlKSOY25O2RfpUbDBjAxSFNaV/eDEtT7w0aRRZt0Agod9GsMvdHaX5JHZXTkxucajJRxjcb5G3UarQEFiLq/phH7Fcgg8hoGAh15tYEbi1lpwEWeE57muCOL3uRtev6G9RNxzY/0tjScylznNiUdL0AHtv7SS+SwdP4NdepaGCw/b2PCREulWNCjYSgCe+2k6/9hLv2oEP78A/eGbMJJqbWyhG0dr6ayvHGHMCyzrGdavATIqaN5r7Yu8udHon9QvTcrptJyGDyiveioFCgciRBKw/mlwRTgrfob2IhidwYaP5Li92kwgG/Lo5gqRZ8aJokN4tTvSCXvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(366004)(396003)(39860400002)(376002)(36756003)(38100700002)(41300700001)(66946007)(66476007)(8676002)(4326008)(66556008)(5660300002)(6506007)(6666004)(107886003)(8936002)(6486002)(478600001)(6916009)(83380400001)(186003)(2906002)(2616005)(26005)(6512007)(1076003)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?28GOo0+cY3EHzsDJQ+Tt3I73yC+H1FeB2pNxmCpeI01kkz1ySG7yFNuSZEYG?=
 =?us-ascii?Q?f/yEns2yu+T71MeQj2yQMxgFX4bQbxxjFmiGTQapde7LnNEm46Roqa9CfWYG?=
 =?us-ascii?Q?Z25sKMoms8q8c4NzuLAK9mLCb48tdg/+mUbyJwHPX1M4+931DT8Pja8I1+MM?=
 =?us-ascii?Q?uklPonaV5O6yfvAGc1MaTW02q37pPHb5mcTTpq9IEGKWll9kj77IH35fEOpC?=
 =?us-ascii?Q?JM1EWnXcjjceUnIjdFXqSEBHFw/KyDu862TNjJOGjhzTsSaOcMbw9fU6i7g4?=
 =?us-ascii?Q?+YjzVAd1QSZhGOoqdxEjTenyRtQlQWuJXeSIrhd+Q7zbjB9iHG58tktNLrZV?=
 =?us-ascii?Q?MRZgwEBcajG4xzxSuWHgYY56WSJcNf70NQTPFkS67KmvPnWV8yuO7mmEwmjq?=
 =?us-ascii?Q?K8MwtYkpgcWuGoL6h1H0GcAoFqh68y0xEKFWnAA5MULdBcTXrKfg0RszELrQ?=
 =?us-ascii?Q?d54t+pr2WSZ4lDHOOrT0GJlv+kj7SFJHrXwX7k/bXtfhg/CSkauAJLuT93M6?=
 =?us-ascii?Q?AYhKZbvk80i7bWAkNeEppJ1dahuiChKjGpsk71N80vbm2ftZxqkQUMaw953e?=
 =?us-ascii?Q?0COllbieuqWttoWE4Du356gIaQ4rZ5eObN0CbgaJCwkg2aGpE0J7CHVCyd95?=
 =?us-ascii?Q?pjxEX4tsV7KbjQ8/5ggcRS8O2Gf9+xlv6ZplaHPcWUOqtBaq7K6oC3BVhZSH?=
 =?us-ascii?Q?0k9HjqCWJwMGCseKX7tWVcPfIZaU9AfARMkjWRIsE8XqaV3rxQKdhxW4HjRe?=
 =?us-ascii?Q?+fSTUY64QJ2m2TjGcAPJUC1slyo725ASyb/UyX1ZLqTqnHzM6xajANmDiN5h?=
 =?us-ascii?Q?CLCAOTnaUw8jPSUOFx+VrRCFZ6YYugF6vJ7PDV1k1IZb15jKamNsBaSbtiKq?=
 =?us-ascii?Q?mUgwbzrC2jyJK1yLSSe3br5Pz8fGbQBwSfnWH/XCmVaLLFvI3u7YvzGalxra?=
 =?us-ascii?Q?VvJyEuTqPBs5Wb4tdA3UP4IaZT4bb1WPd21DyNFisQ0+oZE6/lTTKyiC23ZD?=
 =?us-ascii?Q?P+iTXhVQhFMaWq5h984ihNVU1hKYTweb7lXzEWvU/OxunGyAY9GZYIgwm1Ys?=
 =?us-ascii?Q?Wc/YeqQj01s+rpqOY9D1vfrLPrx3o7G6OnJ7dhwzH/iRe1vZi4mF31G+om15?=
 =?us-ascii?Q?S4Qe4Pk831FTRTFkRWGBAIe/zLfcSJSSRngM+msefen69SiYNwvcBUYEp7He?=
 =?us-ascii?Q?VCN8tyvHnj5nDAI1RUxVsI+3hQ/LF7ehxmCrrF64LLqpT0Gm/iLQSVS0bt2P?=
 =?us-ascii?Q?KHLBZipob4DWiH/LlsaT+ftVMg13Y8TxP8KNgtYOIw9lU5zOTsjZUJlxUFNa?=
 =?us-ascii?Q?76NLBJI9o3KB0KXh/DesaH7NdnkICnG9Wf6Nkqkc/vuUpUQQSWIEGzMGw1UG?=
 =?us-ascii?Q?JiXswp7kvwuE5CJ21+wAA1aKKGS9W8xXYyBYkiy1tfgcgRQJRUKAhBrVlwhM?=
 =?us-ascii?Q?/V6tr5GG+jX9guVbtruHxLhKhg9Hi+5zip9uz+TvsDQGtuBM+tzGmK+7+h/i?=
 =?us-ascii?Q?Lf0fZMSkty8BCvd3G4LRCDdqIct8UNVz9D1XDftozRAqIFJxUrNRuxDhHWXi?=
 =?us-ascii?Q?jVpON0QIfIT7NyIEunXOTY8I6WFV5ILarwhyM1wN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 684e7841-d036-4727-094c-08da92797828
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 15:39:23.6089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y5pI8L+RDD1Op/CHk2dboXtrKc5wWc2FIpBTFUkRZ2YFO1nxBhPpg3dsL1gEli2DqFRJoM6NlqoKpI5isB5yVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5438
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hwstats debugfs files are only writeable, but they are created with
read and write permissions, causing certain selftests to fail [1].

Fix by creating the files with write permission only.

[1]
 # ./test_offload.py
 Test destruction of generic XDP...
 Traceback (most recent call last):
   File "/home/idosch/code/linux/tools/testing/selftests/bpf/./test_offload.py", line 810, in <module>
     simdev = NetdevSimDev()
 [...]
 Exception: Command failed: cat /sys/kernel/debug/netdevsim/netdevsim0//ports/0/dev/hwstats/l3/disable_ifindex

 cat: /sys/kernel/debug/netdevsim/netdevsim0//ports/0/dev/hwstats/l3/disable_ifindex: Invalid argument

Fixes: 1a6d7ae7d63c ("netdevsim: Introduce support for L3 offload xstats")
Reported-by: Jie2x Zhou <jie2x.zhou@intel.com>
Tested-by: Jie2x Zhou <jie2x.zhou@intel.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/netdevsim/hwstats.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/hwstats.c b/drivers/net/netdevsim/hwstats.c
index 605a38e16db0..0e58aa7f0374 100644
--- a/drivers/net/netdevsim/hwstats.c
+++ b/drivers/net/netdevsim/hwstats.c
@@ -433,11 +433,11 @@ int nsim_dev_hwstats_init(struct nsim_dev *nsim_dev)
 		goto err_remove_hwstats_recursive;
 	}
 
-	debugfs_create_file("enable_ifindex", 0600, hwstats->l3_ddir, hwstats,
+	debugfs_create_file("enable_ifindex", 0200, hwstats->l3_ddir, hwstats,
 			    &nsim_dev_hwstats_l3_enable_fops.fops);
-	debugfs_create_file("disable_ifindex", 0600, hwstats->l3_ddir, hwstats,
+	debugfs_create_file("disable_ifindex", 0200, hwstats->l3_ddir, hwstats,
 			    &nsim_dev_hwstats_l3_disable_fops.fops);
-	debugfs_create_file("fail_next_enable", 0600, hwstats->l3_ddir, hwstats,
+	debugfs_create_file("fail_next_enable", 0200, hwstats->l3_ddir, hwstats,
 			    &nsim_dev_hwstats_l3_fail_fops.fops);
 
 	INIT_DELAYED_WORK(&hwstats->traffic_dw,
-- 
2.37.1

