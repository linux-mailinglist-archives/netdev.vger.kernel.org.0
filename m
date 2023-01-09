Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89B2662723
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjAINc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbjAINcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:32:15 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904D613E90
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:32:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnE8nId9/zrS+MOwtU6Blf75yA2wTO+C+2LzFSDfmFud8olo9bvsrevUkeST7XMJjUf57x8hcj76Nib1N55ncO7+/WtVXWObrMZDJ02ET2HP8UyzrsDUrtBV85/4fSvqdKRRgzLwAFbjtC/iCfyFrt/dPAYmPDc1xh604T8s8xAMWah+/VQuIHMkrSrk+NnH5Zf0oIG1crlL21RPhZxCL0N4aEPxfdbSz7z2QpLL2N8Om5vqzkO71mmZeI4D7LmNR1COCncq3lOvItE5kNiWdiimJvipJsrAYOjL2PcgEnQh3M8tu4CSk1nXUlpm0SWtgq7VggKEAczhF+eCbt9tsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rcbIohC+D8aEOXJjZsgEpRfHCxyY0PkY3RzNlVoReRE=;
 b=LJAPCR58/ZeTzekM5DT7Fr+14XbcQ2mFDoVWznIA8H5kyAop2ct6Oi0N3PN198YIwKDDR3Cd4CJZsBfmlWY7P0jfPC+RAmBcStDX8Pbx1Hb59e/5fwkKFJsANSi7laFey0b6YOw0ZahUGDvEXGfBBDLXkaC4beJoExybYEqMYIp6z734YUf+5UuSjjpcQu6EMyhIAuxxdJdrq1tc/krsrez05gz42gjyH9Ab5BcAkTsDoac9OLLdbqy0IpQM5RI+cJckoMQ5chjbJHAr4YDQBlfQEh1co5GHtqIVwKf1slsWUk6wT89FMiL1dSRS4xmtM5RWOrHh28vNRb4ToNnmWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcbIohC+D8aEOXJjZsgEpRfHCxyY0PkY3RzNlVoReRE=;
 b=ZMKl9obnWmEcwA254jmxznGodyIVk7nlAFyFdusxGH/mEk+n3cvJODDgYqvAbDcIG+1CXfhLCsPtRWQPhxBsmtIVx0XLS1WyEemr6m1mESKVeymA8cWIxLB7hdo9xTAgW2Pk1FGtepxoW5Z0m538scftwaNEaiSux0gil6CP+qScgesX9iS2HbzrVDPExj2ZPJdIFO7ebnc2x7KdOYB9RS7pHwjEF7u0eeBSQAxGubJxuot7wnzshctk8+XJnXlGm7hrdRbDTf82H0W3ZPXZBX2zNO10W4iHe257vJdMcgEC277+QsPdg+HAw/13zHvzGX+1Fc60p4EskeWR2Kl1HA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by CH0PR12MB5074.namprd12.prod.outlook.com (2603:10b6:610:e1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:32:06 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:32:06 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v8 06/25] net/tls,core: export get_netdev_for_sock
Date:   Mon,  9 Jan 2023 15:30:57 +0200
Message-Id: <20230109133116.20801-7-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::17) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|CH0PR12MB5074:EE_
X-MS-Office365-Filtering-Correlation-Id: c62527c9-b01f-44e0-6995-08daf245e670
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jckgRj0M2BwmT6JOSC5KU5CGD+ffwOZl/ZDbMlWVy64yUKZOF0kAlJR0zHcouAN6bkHnJw1LZnaIsAH3Xff3BvaXJMlOi/rP0bwpZlFJRIJ5yOJAeudOAvyTy/Ugr+NzGJZCb+Sc0RFzpa1QT5+OXP5p9WBb/g6WTKLSZQLd9QKsYSyJuxowTN3slHhhSZx72yfe2tt7Chz1pA2GcyBdJYkz+f8CFOSSjGY/jiag7dyjb4QE6r/6LIcpJ0ZG40RQbDGBkXTwBhA78alANIP0NrqfcdC2uVZLC2rr65yWCk4Wy4rKr6mDJU4Wv5AaZWQHcMe3Pe/bxUxVRxrKEDOeCfilY5P4RkDoXM/flS/XtTVFGMklml/iVSSGHg8Tmnta945IIaYz4PJF7PsIVo3RlaTsCYSUEgIAT1U3Mj1W1IZ49/Gu46R7hrTSskuwcJR5kcYa8alKi16jK1gEf4A28ismC5/B3wztdKaJlQv9loRUL79UizikZrVRQ6pNsSFczpra6XksJtA6X8Wwb1wtTE+sqLWQskgfug7wWcaOrdiOjYhIYucOHcm/zJ7qQjL4QWq0Ve9X75hLKji7xSlU+aA5pm3rDBd6dVLNcrDGhm6RgPB1nYMOkhgufRMfadNHP8XFHO0YcgWDOXUU9Zuaaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199015)(1076003)(316002)(5660300002)(7416002)(26005)(6512007)(186003)(6486002)(478600001)(2616005)(41300700001)(4326008)(66556008)(66946007)(66476007)(8676002)(8936002)(83380400001)(86362001)(36756003)(6666004)(107886003)(6506007)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XdxBZFyR68SaQIRZtN8++Am35awyXJ20alNoFlm0I9IytxeSk7uSc69L2Mev?=
 =?us-ascii?Q?J5xtPIamtWBFtoR8upiQT+UErBzH3vwIbfDZnxo17KiHypPO7yh2tcSxUXni?=
 =?us-ascii?Q?DcXGHsbjKLvUFly/IyZDVAlUmPCYLbe1DuipJ0B3wLN8NVWSRF9OyX7TQ7bI?=
 =?us-ascii?Q?sxse2FlbhPF2tdv8JjGBuRl6ht4hNm4m5ZC7IwuH7SswdB/rAjjIsEvT4+HA?=
 =?us-ascii?Q?UnrZc+7PFsc99/pXxov8KyKm2AUX43uDgCav80HKeInIJ1soBdoKHIuQWGk5?=
 =?us-ascii?Q?LCiAwRq+cybkmP2GzoD53Z6VOJtRm2HJyswoEOufpM5y/DLEtqwbrus7Hnv8?=
 =?us-ascii?Q?vY6zpTqFH63TkmIu405Rfkcf7ViEyEWu2pTsK4u4nXBCzGjpZAcjLpXmdjEB?=
 =?us-ascii?Q?RqufedweOjK0Ck5gHFiZjdaAln+9FThsuHPuZpkjfhhsFz4nYRXnekPXjdg8?=
 =?us-ascii?Q?nhfXbrkiSNrT4QKGG1tRT8qmHkUXw6yIYZ2FkIYx2phY5ZnHp01nRgUmI3Po?=
 =?us-ascii?Q?Az+jPRs4Cy4WST4EvFi5QnYpGug1J83pfAcZXqUfeb8EUYQemkPnD1/n+WJH?=
 =?us-ascii?Q?+asQcWRURpDkHAoQSZi2RuXvv1o/Nad+6P5YeznZSZkz3Gxm8QPAWy9wcD22?=
 =?us-ascii?Q?wJzla79ZVMnIvuUSxnvwDUQHeMxeQ37NHQONCMXYQKf/mGYxu5p6rspv4eZg?=
 =?us-ascii?Q?CFNxHXXTNifv0C926r2Mjs+OyzPOqAqXzkHipGDIM7m8JMB1QH2F/TraYjnj?=
 =?us-ascii?Q?XAuJeURpEeUImzlZQ9J5Er+0zRAaAnNNdZkwySBxIfA4b407mwFJqtF5mWfs?=
 =?us-ascii?Q?J+juu3IiFQJLVPufx+OSsyGQI6PIbMfqrBVGePuw7VD/+Vm+15XmWAtXusjI?=
 =?us-ascii?Q?j51siX9OPjcrhbSjUnrMXZOQXIDv0gm6uti/lmYw6mJp1RsW3xNPBFkiSJnz?=
 =?us-ascii?Q?7roM1bznFRgmxmH86WEEOuxJ6YDbQUjVLVwORTLsTxoGiHlZS0q7dVQlaAAV?=
 =?us-ascii?Q?RvG0c4EZqxT/h1UsgdttA+8jpE+9tGS0nPfe6pWGDzcFOKMtKtUB0Pq8p89e?=
 =?us-ascii?Q?qkIL/mbuWqcPmcw8nI3fbDa4aQXsGjTeVFBxL3VtZuGDOuAe16YYQiWFYz/y?=
 =?us-ascii?Q?UX3i/dDIgI1rILcKtMtJABYzusuE1XGGrr+s48Ke7W7ceB61vyQORgA2AfJT?=
 =?us-ascii?Q?UtrrzOgxBt+KbI7ANuPpVnmZWVzxKVN3SwT0xZz27mLUk2f66M/PCmcwNHWz?=
 =?us-ascii?Q?aFvqA/wKB7oyl7010wYhpf+8CZzl578gFEsbC6uF2IiDoImnkxdDJEH3lWGO?=
 =?us-ascii?Q?ZZlTJWcyQzJYZayBzb6ID4LNkRqdMPQbNylzMgIa87wKCOwsbv/GDOF+Vkd1?=
 =?us-ascii?Q?fduLGEi0m9XVcitfGa8k5V33AohcY0YJ/LcEVkclxvUNMf8IpvhFzlmKbD2X?=
 =?us-ascii?Q?JmvdkZmoKGpq7pMEC6Bh4vDkkvCA5luYzroE9EBj9p8M29w0IFY5unGkKC0p?=
 =?us-ascii?Q?KbciDKslDmD8CXfNyHaFyMQEvMYsDaedFIzldgFsmKR+aiB8Qdj0cv9soXm4?=
 =?us-ascii?Q?LQEKqtbwdRIZLySR39uiCVHDemHTxkp6O4VhrwGG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c62527c9-b01f-44e0-6995-08daf245e670
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:32:06.0231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uuvDajFbCDDZHgbTQ2yfw2vpDJGfYMF/4tWuvZ0WPGQc7m2FkXRuR5d2nCRNANeFmMFW+HV1qhYk3UXKmkFUxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5074
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* remove netdev_sk_get_lowest_dev() from net/core
* move get_netdev_for_sock() from net/tls to net/core

get_netdev_for_sock() is a utility that is used to obtain
the net_device structure from a connected socket.

Later patches will use this for nvme-tcp DDP and DDP DDGST offloads.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 include/linux/netdevice.h |  3 +--
 net/core/dev.c            | 26 +++++++++++++-------------
 net/tls/tls_device.c      | 16 ----------------
 3 files changed, 14 insertions(+), 31 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index bd270c4bbf97..ba3806a1a11b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3079,8 +3079,7 @@ int init_dummy_netdev(struct net_device *dev);
 struct net_device *netdev_get_xmit_slave(struct net_device *dev,
 					 struct sk_buff *skb,
 					 bool all_slaves);
-struct net_device *netdev_sk_get_lowest_dev(struct net_device *dev,
-					    struct sock *sk);
+struct net_device *get_netdev_for_sock(struct sock *sk);
 struct net_device *dev_get_by_index(struct net *net, int ifindex);
 struct net_device *__dev_get_by_index(struct net *net, int ifindex);
 struct net_device *dev_get_by_index_rcu(struct net *net, int ifindex);
diff --git a/net/core/dev.c b/net/core/dev.c
index cf78f35bc0b9..ea80f77ba003 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8152,27 +8152,27 @@ static struct net_device *netdev_sk_get_lower_dev(struct net_device *dev,
 }
 
 /**
- * netdev_sk_get_lowest_dev - Get the lowest device in chain given device and socket
- * @dev: device
+ * netdev_sk_get_lowest_dev - Get the lowest device in socket
  * @sk: the socket
  *
- * %NULL is returned if no lower device is found.
+ * Assumes that the socket is already connected.
+ * Returns the lower device or %NULL if no lower device is found.
  */
-
-struct net_device *netdev_sk_get_lowest_dev(struct net_device *dev,
-					    struct sock *sk)
+struct net_device *get_netdev_for_sock(struct sock *sk)
 {
-	struct net_device *lower;
+	struct dst_entry *dst = sk_dst_get(sk);
+	struct net_device *dev, *lower;
 
-	lower = netdev_sk_get_lower_dev(dev, sk);
-	while (lower) {
+	if (unlikely(!dst))
+		return NULL;
+	dev = dst->dev;
+	while ((lower = netdev_sk_get_lower_dev(dev, sk)))
 		dev = lower;
-		lower = netdev_sk_get_lower_dev(dev, sk);
-	}
-
+	dev_hold(dev);
+	dst_release(dst);
 	return dev;
 }
-EXPORT_SYMBOL(netdev_sk_get_lowest_dev);
+EXPORT_SYMBOL_GPL(get_netdev_for_sock);
 
 static void netdev_adjacent_add_links(struct net_device *dev)
 {
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 6c593788dc25..3c298dfb77cb 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -120,22 +120,6 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 		tls_device_free_ctx(ctx);
 }
 
-/* We assume that the socket is already connected */
-static struct net_device *get_netdev_for_sock(struct sock *sk)
-{
-	struct dst_entry *dst = sk_dst_get(sk);
-	struct net_device *netdev = NULL;
-
-	if (likely(dst)) {
-		netdev = netdev_sk_get_lowest_dev(dst->dev, sk);
-		dev_hold(netdev);
-	}
-
-	dst_release(dst);
-
-	return netdev;
-}
-
 static void destroy_record(struct tls_record_info *record)
 {
 	int i;
-- 
2.31.1

