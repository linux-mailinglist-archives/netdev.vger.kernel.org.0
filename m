Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B4D66E265
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjAQPiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjAQPgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:36:52 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA03B42DCE
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:36:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjhbDOnDTLRSN7yu0rWzj4DJ+Y4nfAwwUsh5kUl+pUFKmxrQLCNxU6VdzDSnb0lephzc8t+rkIHB4CKSTiGrN0DPF4o+tsNfc6MuBUUPKW5cjzpiY96rH+mYkzVLfeSMh8uYxrI4eRQzb9w0Yh6OzPDpw5xBOReIwsU+2TRCIQFsdTkfH1KvwPmYI+1vkymeXo4zxvj1nR+UDrxiDnehqCqg0VB6nVSSAsJzIx+uTOyeyTRjBrwizMaQwypeHZlsoT5Pw+zSJrHzkS5pO41GZRqlGdTKfThCdTSUg5dCM2TEbVS7KXfKpz4SfiERc9CdfjSHKHdfGyrn/OyugAhA3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TIQQDwfvTLbhjQ8M+d1TIOnF4KhjsVuH8GlTEeV6/Cs=;
 b=KGqDhzUgdJVyASoA2Sf+blOeRG1HqMoVmkYNPEKyFBJPuNr/lzrhILb6WZ+rH+oBZZtirWpFuwjEx9bMpEbCjdhBzCn2/o+JtBkoOnZkvplQjGydlU9hMQp531WVZItLyUdK3jNqSq2Ab7EcV5ssZDgb23tQXTlWlgstE/ZhNVW1p3U+R67U67TlhNDiXs+6HJtZ2Ikq2QcZaTzkBM48M65Soj6dsf1DSNEnRpPcnl0O0781IvH9wueW58yjiA6NoBA7yt00WVtSl0QdnNSBPTnH8ergJvS2hO/OaFJAvA7rcMhNuhVk0UPgS4Tzak+prnxKG02Uflq9tWAn9SdYkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIQQDwfvTLbhjQ8M+d1TIOnF4KhjsVuH8GlTEeV6/Cs=;
 b=XWD9ohqJ4BhRpZ/8rGp2dMc9kb2IclvQZPUJJc2mRu4UsNv710jcozihhwm3nmdoozJA6RYXE2OXl/6AEljFgyFWjTpTOBjzA6wSw/y8sVyfyHkKJjrWus8tu8Rekgvq+XGWxaBwaWrzRazQNLhczRtXLG/Yvp+NlaXIf6mZ7g0+8ruZTu6tgdIEX6hqenwditpKdNttIgZ8HDEBYnfUyqveMriQSAOYR+0hmiV4bwBL0+5fo3Rbfo7Mlda8oPZxXA+rhUU7b01PS+uu6bPO0APbB0lGCL5g8KtzfQYXwrsIuFpSZSQVSaYMHcKw1djKEz6ORq1ypmcAcSOOsPJWDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH8PR12MB6889.namprd12.prod.outlook.com (2603:10b6:510:1c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 15:36:42 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:36:41 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v9 06/25] net/tls,core: export get_netdev_for_sock
Date:   Tue, 17 Jan 2023 17:35:16 +0200
Message-Id: <20230117153535.1945554-7-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0198.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::18) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH8PR12MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: 803e3a51-05e1-4d4e-9182-08daf8a0a1a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qTwOr5gg9sXYE5wS93cx9oi8GeDBF4TacfYOnAZ9id3K2hQzt0o9DUdBD/9nhhjfQ/t5MITWdT+pelvd6mU7yTJgqsiZOSiZ4jV+/g7DyXPBA7edk+HxMoKkNcwVSnQpEdkB7YUbQ7zMtwWLt403Txrlj9FIkXCaaOHtdhdDzrL39ukIr+5gathBnocx/dqZ2DYeOfDbxFVGaJSPgRWr4Y2jiPpq5QpD/7tVo82AKlmvI8M5qMB+cDk5klhdSY+L+v03sTLyeyP2By//Iw8BPqmlZLKfh4hfcpLDHEX2SFFCU273btv4LrVDODq5gJWKWQyk2jQTeDSpxzRUqAQu8kg00VUV14qTz9Az6MO3xLQtjm0gn8rIddpXM046kOYwVxTwlqtXB3cNrsy2I5xBwzledMTpMIDfuZgASdnMD7xQR2PHBTeAgMqpTACsklWMkQL2i07GgeZL9tDKVp0ALpROW2a/4bFbA6Ki+HGsMxp6U80FVWC10EyspobOWnzyrseyxt4MgpxyKM6qXhzpHeJ3T7po5E3SIYTghQ5eFzIIk36ggM0gmr7gg22dQXXUpfEznjpcmUijQpchKWk3BybFxia5wutwSOh/6k3c/HBktTUdwuAWJU88awdWhT0tDSuuEkRIPp7f+OnBphfcPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199015)(2906002)(66946007)(26005)(4326008)(36756003)(8676002)(66476007)(66556008)(41300700001)(186003)(6512007)(1076003)(6666004)(107886003)(6506007)(2616005)(83380400001)(86362001)(316002)(38100700002)(6486002)(478600001)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ihXsTunTP1jvaiQoKXoao76YSssYaoi+h1l9V11+pwoomS1OiZgGJYCwUeWs?=
 =?us-ascii?Q?1z8JbZ6Zq8RxTs/l9G9zizbVR/gJ6TOoKfcs2+gKgbrlPYB1FVPjC/xxSFT/?=
 =?us-ascii?Q?V/M19WCJuoUy4MH7SsPgtot6KkQd2zcBKN1b5xgyURh4I104pmk2gKyFfCU0?=
 =?us-ascii?Q?iXEu09NX4BupFEd37kBx8YYr0/Ow2shoFZmww8nv9D8gDvq2xYpgHwWvoZB5?=
 =?us-ascii?Q?aALa30kPLwfrLJZCHmlAvBDQNdmKDxo2EVuPaIuE7ywzyDlr7NRJw91XVP+U?=
 =?us-ascii?Q?Q8H2tJ1LLE4cEaycsUNsET0igY6wqMqO6rm77nMdpUhfEPB740ZxL2tdS9CS?=
 =?us-ascii?Q?ToJ3p9KuH2kZtPPR3XvLY5WC21wuasK0fM6DmkxW3Wgx6XMzpWwQpm2uOOhd?=
 =?us-ascii?Q?oqOcKb6AeopTgEiA0MUa6Gq4yQJx1Nlpj8AzKZzE3v3eOIU7MJZ05kYRXNoB?=
 =?us-ascii?Q?6cVYVYKTGtY/6cjhrNyBpt6aSowMMc7UPylMRLsnSlH+a/4oJG+x5TvLzXYZ?=
 =?us-ascii?Q?AvLIY+2PhBVqFoQ+c3G9/RLIfXiSn2LR0HgBt0C7cYpHEwGAX2/TXkXNaabi?=
 =?us-ascii?Q?gtM7LGdt4V47ZQaQXkjRNttBdMQ955dFPl3Bzsvl/SWLIxGL9z0vthwm5Ctl?=
 =?us-ascii?Q?bsPjFdYsY7NJK/aiFs/grUHRL2IsUKICd1ofl2RfG2//koKpZ2SrnpET936a?=
 =?us-ascii?Q?tbZ0QjHxZkEFU9zCncVu2CMqMe0o6BkgNMxoBpxUX9c5Euy66+qvOioMKbo/?=
 =?us-ascii?Q?l8UeSW5FxCLCOJAUfk+GSzqNDJofO7Y7N3Q1jOzqo5BtfYG/bg/8R5x6TLd/?=
 =?us-ascii?Q?us4DRNmQcTDRCzBZ6hHiBzjt6KSqc4b2MMp4lBiqU1J8NUOZ+vRtwQJR+X/I?=
 =?us-ascii?Q?K2DcH9Ba0MfeQThfgZOgOpagfbMS7JBAMzla88SJTwcC55AicWVx6cdXDzOB?=
 =?us-ascii?Q?l+bpi5MNkhSIU/oYPxniqVDB1cPSghbrwUZTNupVYl1f4VcbN6qjc2Tt0GBO?=
 =?us-ascii?Q?OopUo33usuuR6KZvMmoySaJQDXCPfoY1IRxrrQ0cqc/DIRu3lEtxPnie7tUp?=
 =?us-ascii?Q?6YGRpNPU6EJSgwuWH8bxdboemXMsk5sWjLV5nmEsMsunxa3BHFLNCAf/T+dd?=
 =?us-ascii?Q?HLQefXumRYXvfKKzli2fpmO9IgimR1s+iKJSRJTRFj+LEZOOwgAbq25JKZ4b?=
 =?us-ascii?Q?11iadBPq4j9X8IT4nKjcuGOlVd2LOQxlRJKWGubK+ucuXp6aSjcGBmikxida?=
 =?us-ascii?Q?3n8S6++EopGPdyhAgU1MJfPMhMjZnAtdMPBp1qa+6qDp8bRPawNOsGv6BhV4?=
 =?us-ascii?Q?SG2YjzIOXRcmll4Ruj4xwHuHPZT25VC3afpv7Q62kVN/g8XB8SA6vb61XTmb?=
 =?us-ascii?Q?rmUpyx1pJioyN9w6cNCcxItl5mNmgXkUkotEpdye1s3KLd1RwajFgd7DOZ3v?=
 =?us-ascii?Q?0p8tJBJEGVVy2qibhv/qEU+0GuiF1T8+YpWF9HcqfnTgvNCwLpbY8r0HEk7I?=
 =?us-ascii?Q?GaDeCo6pnljonMKNSTO9+rtKUIxPi7ajJwrs98Ukm1pw+ZpgghKzj4yhWYL3?=
 =?us-ascii?Q?VVSa8qXRwV90YRG+zFdssnV/szT8DxvJqAbAIfKh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 803e3a51-05e1-4d4e-9182-08daf8a0a1a3
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:36:41.8060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XQXg+Qqmp1MgTl0plRFOehI5S1cW8yNt3/e0xcBym6IpwtvVa8QM+WTpd1dAiaV26SHTqfuTFLn3lbg/c7shjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6889
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
index 289cfdade177..19aaf0531fc5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3082,8 +3082,7 @@ int init_dummy_netdev(struct net_device *dev);
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
index cf78f35bc0b9..bd29e056045c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8152,27 +8152,27 @@ static struct net_device *netdev_sk_get_lower_dev(struct net_device *dev,
 }
 
 /**
- * netdev_sk_get_lowest_dev - Get the lowest device in chain given device and socket
- * @dev: device
+ * get_netdev_for_sock - Get the lowest device in socket
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

