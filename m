Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830E26899B0
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbjBCN2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbjBCN2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:28:16 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2070.outbound.protection.outlook.com [40.107.101.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35D572B4
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:28:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SoeZwSj9DGxjOGFmoHddNWDv/TLam3wlnOVBRMWzdljSMffj522+3lUYnGF7oO6FxGREsGuqJ+kLQ25V4FEJtv0w7isppuIspg/0rQNiTzAWd7L1vvKl1SvtlRidmldF5riy7Tkhx4g6HLTJeVXevJOfvihdTiIYciZpkqgcus7uHBRP5yLeL2/UeVFTWqgkvhCTTCwZxOhNT51sh2PVpsPlgO96NaZ1/BdMLDwbpgq8oqXt01LP+2j8e0LRFD/4KPSsbH7m/HVc0XeM+fyWIzQatp974F6OuzCMicCh7jnDcVh3WhBVEVUx4BJQi8Jvt7g8W4FBJj/qibPdFXqW4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8FrsDo8NfvwL+9EU4nc34cZYG3UsMNfdMkg1y0h85BU=;
 b=gOeiV97xCjZItWCyx6G+RUbhdCBgFGxdox9A5i1DUCuw4alNLrUmf38qdFrr70AZCxFzNpDBm6tJTAcsMEo7fSGJUygaLjv/5hvMIeYkUAaCNTmUfHzPUWMMsOxQHFqq1+DudkVP+R1eS5MxSacyAMpl8n6Th6rCAf7V2CM52aFwX9+DtJVYHwfLWN2GxUqPB+c3BiXuxhM78TUuXPjOoCe11jrHW/UVHzwe1sAqK7o4S7y45GqskLfQdk2Tvt0u+J5JuJuCHNQEmzfJ4QwNn+4p2Q5Zki1EAee/NluGV65ijbM4nqzGk5XLOfb9vmjjUTXSKnubeifDiUOmggK/aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FrsDo8NfvwL+9EU4nc34cZYG3UsMNfdMkg1y0h85BU=;
 b=RF+DQj0o+HSXuKAEZqJU5cslT3HcJtbBx4JEr5AIBKwFmfUPpKer9gY6wAOiGTLx0KIjLgO7fgIMJVSlmC5L9ZbKSTr4gvOO3fqSupEYEhXrAoNvIagJIg9iasXIfA+YRtSL4xiwWwwiUP6ERhzuhnVus/Kt3gsJApS7XGLqYaBuNDBD4l3e/p1RosxwGn37p9QPShGQ2XkU7fh2Kx7+/L5hr9SOFBN1gt47Sfp/1kzqCLQOEChuwKnMFOKBl4Tm0y+QPFQ/x69glDDPcDR3AkOcCsVKmgn6iLMYYVtlZbqJwMhAV93u7FMKjM13F6Rn9VWCKYdEVa7mhV+AnVX4+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by IA1PR12MB6577.namprd12.prod.outlook.com (2603:10b6:208:3a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Fri, 3 Feb
 2023 13:27:56 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:27:56 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 06/25] net/tls,core: export get_netdev_for_sock
Date:   Fri,  3 Feb 2023 15:26:46 +0200
Message-Id: <20230203132705.627232-7-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0072.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::9) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|IA1PR12MB6577:EE_
X-MS-Office365-Filtering-Correlation-Id: 068f66c5-717e-4478-5cea-08db05ea7634
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RV46eg7Xw6II8mK7WZNrcMotx3Dk/1qz7WsxCdikDqDoqHqLoe19GuRgKlI72Sta5RhqVPnLeCw5VcfNhcUhLLEA+27pM6CwZka0Dfh36UFa1UhUbpm2onDg3OjMzo2AVpYq2yfuv19xYP1495W4puNflQqSwWnR1Z/VX5Ldd4OppF5bXRJ2VFFDgSD1JbFfGZgkjyjnFGUFNnLp9s+eAtCzjdLS24xyROEIwaWwMX0cjOhhsmEDVxo9LZnVi7ZUzrpVAZEpEY2aO84fuO9gX65VBwPotnf2p142Xo/5tisT0Zs8ZHKyEn2xamets6ygFXDRfpE771ixuczrPYMeL1pWCPWkoLSM4YmFuHAQKvA9hvb8v1e8A559HfDXlMVVusP+OYGgrfhEqC1AbcSUSaWFm3fhkp4IdsHQDljZ+6MATvViMJJNWnfoHMSlY2Wqv/frN+SmIubpjQHch/oE/cvpt6+YjPB/T2cQz+HPdAOnO1RPFpsvQz7YOH/opM2afD1xL3FkwDSB8sm7SHBErfrIamjVkULZSkC7U188VPbqrGiFD1XUzWkE6YzluASNeKfVmDwOVFalYrxrY9cNhR5NQ8WOyzip3Tkqqh1gbB0qh2MK8s+2Q8XTOx2J5kEKS64Thgc6HVAPhyCq9bf1Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199018)(2906002)(36756003)(83380400001)(2616005)(316002)(6666004)(107886003)(6486002)(186003)(478600001)(8936002)(8676002)(66556008)(66946007)(6506007)(66476007)(6512007)(26005)(5660300002)(41300700001)(7416002)(1076003)(86362001)(4326008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vllAiGQQzQkS0A19ME8l89xwofuIUTOr6fSksicJ9niFbbCrlfZIsX0RBH4r?=
 =?us-ascii?Q?RwiEzyIJcDvc+InF7wcTe8Y/T9Oo1KvjzuOoYwF//W6HJYAn68siNGwVQgyy?=
 =?us-ascii?Q?jib9pph/1HAP7hxjLOFD4zSIho+LfA2ZdfAwrdl03z/PAbMdM0tgKMCBaqnF?=
 =?us-ascii?Q?R6ZcpRgaUOd58GCOEPuNTI8ht2JcCKCRt+XeW8Jo9OQa0cf/+Fp1tO4TyPLb?=
 =?us-ascii?Q?q7Rgfjf0tBBlwL6KTbshtR7vjYJne968/bhLIQPuXaaWJeiGmdnGmRwEkimB?=
 =?us-ascii?Q?Dk1/pAjbcIv1vP7hj9H7Os06Db2sn7QjriPa6CNpHymttm6bgTNyznXemsGX?=
 =?us-ascii?Q?Jsd+bbsk/8/M4uswh7j8Vtjd8ya3IrSEDJKau67LlvX1gu8cHBXbP5s47QEh?=
 =?us-ascii?Q?J1JYd0z3uPopwKtEQDC55TT00rmOeSwqYSWv45NAeQRho7LENv6inEjnZ/Ms?=
 =?us-ascii?Q?t3ATM9/Il1yr3SkRvNuWM9xLEPBN3R0dDeCm98liZo9GLJE/ZS4p7SEeMXJA?=
 =?us-ascii?Q?d4O8LXBWNL2esZeLweHipVa6OTfQ2NE4EASj4QXUxFwJETL5SBb+GPNYktnt?=
 =?us-ascii?Q?LrM3EbRyhF57CRA/8dCKobQZpuDg98fzZf9P6DseTmqeXlG6dO2NueR9jj1z?=
 =?us-ascii?Q?snE0Chq9lzvfYz3ZLVZN78HYkFqKjQpoSK9oyBjuX6Yq9rf8VqvHRRD9Aj05?=
 =?us-ascii?Q?JWsCtd+Y307s6OUAZRzFOuumrqPX/fB6X4lSW8ZfEWd/sKAPKSDxjnjrpbqZ?=
 =?us-ascii?Q?070roNHz7ZlMKWQuSvMScyvML1cZ09ATj+A88Vj6bKc84CGE9UoknI6wvJlR?=
 =?us-ascii?Q?bCtCIp+R5WKdlFocR6ILyfadOQ/g+vhmg8hWg/EiDkQK61EjvA184zkEaP7B?=
 =?us-ascii?Q?4YJOPhRqZdW37Vf0pWDoHHVuc8Ws5mOhuTnsAkX0UVQITUGiu66BQed9EFyo?=
 =?us-ascii?Q?ee7ibjuoN+StAt+Hpeww82GJfhoSzX0zDQzDjNlsohbhHKC7mP0mp2O82/Lr?=
 =?us-ascii?Q?U9AbaGBo+CkCMKpaJR3Buakw36fMoxlL7zIWndH+Z2Y1daNvSKE9Tis045WR?=
 =?us-ascii?Q?421vThiluCxZezzzm6vhOknUWul40LwNoAE57UMQA9JEPVRTaIWdb0CBYS2+?=
 =?us-ascii?Q?86IpROzRLCohZHwWaa7/bBf8tHst0X/rBiOL6yaWYRhRgFTG4MtTjO4LZkr3?=
 =?us-ascii?Q?YyjzHZ+j5130QHqW5mF5/254r3zEWqzNbasufnAbky6v+9YzJpKAcO2bNtAu?=
 =?us-ascii?Q?CwISd5S6a0vvv9VwKUcCiEWUFEnTWIBEhxyHeb8vNGwGXHnUhQ0jnB3hzghC?=
 =?us-ascii?Q?SMFPclJ/Es9KJBECd/zfnkw372TNO1i59ekJZB482cAITUbcJ9E4PTlwD/Dt?=
 =?us-ascii?Q?OBtK9JBQcadnNju+ZjlSsTABDrYcZLECA2sQuWqgK+M44d8MG03KhER0IHNX?=
 =?us-ascii?Q?GAf0POm9481K6fO/6po+gucD7JymPCvVIMjd/xNf146+BEFjp5PZhtOo8ueb?=
 =?us-ascii?Q?GN9e+Uufs+LWbmIHGuXXHL3KNO5vfdt/l7VNqXm9V1FVjbpNRCcH+Tzq/58L?=
 =?us-ascii?Q?h6MyhXVRExNsevk5p/LoW1y7ME6rKhySNou2DMaM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 068f66c5-717e-4478-5cea-08db05ea7634
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:27:56.8248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t0yf8ocQMyceeddajfGC/+YiMdwPnWINWToQeOtD4DcSgVG/WYyANjjHl2l+v91+s7xgYuLlCr1BCHgMONqw9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6577
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
index 8861a2f04e00..25a868281594 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3096,8 +3096,7 @@ int init_dummy_netdev(struct net_device *dev);
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
index bb42150a38ec..2360b70ea0b1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8153,27 +8153,27 @@ static struct net_device *netdev_sk_get_lower_dev(struct net_device *dev,
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

