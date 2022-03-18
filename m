Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F53E4DD7C6
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 11:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbiCRKPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 06:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbiCRKPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 06:15:09 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2122.outbound.protection.outlook.com [40.107.244.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D7DE438A
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 03:13:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVathLf0veImogom/DMsuhVVFH7Qf6+z6gnukOY392hjlH6ipz1ycSJE4Rax2RXPwCXDQBrWm1ePgfzuFvZLUlNLaRXPva8xjn9D6uyMF9xo6EOhrYj86OZfDNGogQ6HIoJ7JkninaTXuw0TiTUJpvK2zYnRZZDQRM2kJ8I5s98olXLAjhjYxDVB5t8wCNwizmMvzqaZd3gRNQijziu8w62nA5ykZh00sEBUngkSFEILDqxfpLGe+2oVPn6WX0t7ZX9CUQdaVgSfCyBIj4G/+QF9ti90ZReEsknYbGWN5IS0qyOO0h+GpS2FO0DKBhwB7Bjqb1y4mFyUEJYbuKqlMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZriSPFFVghuObPtOO1ichRMXSWu/dQVevKAhkZ0ASs=;
 b=YOLlc05gp9IvJw77qdzDoEQCvJwFeiETidnc0l4aZtaQL2PfCcZv2t4cdWwkn1XQiSaHrccDy1liR0FQNdQWf59j6Q38EmWiTD9PAKqkG3g1mr0n/zg1lMiyNdBuydBTxEz5Yj37/YTO0RaQZJp1bB/KAKA/cu91oHGNzd8rHgSKZ8P9nz3ie4p0GXZhnt3rQnWSpaPkBhIwI8g4rniVqRV4IAeA2ENPXhLUGw5afagiKIfNB033GZegHekqpKBkBvqQ1WMbi2wFyV8yUQumauml+nFUS450dsHuQY3l9c9Q/OEK856kXJg1EqI/SknkvBP/RKF+LjPLHNdu7DYx0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZriSPFFVghuObPtOO1ichRMXSWu/dQVevKAhkZ0ASs=;
 b=h7DLLIF2gJpZSdvaTpiLEobq4EUw4/LzmnpOPCWxqzWiT+LNX7twbScZIjVW+fTlHBnkIR94HTCcfRYL9Ad13i/ltoRU39MQMX+KTV7bDY5qUtMNiWCf89Sv71xNHVgrrIHh8WdJIbQ+8x8j16s/1pWRs0keSezayUctyiWQlsg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR1301MB2090.namprd13.prod.outlook.com (2603:10b6:4:33::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.7; Fri, 18 Mar
 2022 10:13:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5081.015; Fri, 18 Mar 2022
 10:13:41 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 07/10] nfp: add per-data path feature mask
Date:   Fri, 18 Mar 2022 11:12:59 +0100
Message-Id: <20220318101302.113419-8-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220318101302.113419-1-simon.horman@corigine.com>
References: <20220318101302.113419-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0114.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 997388f2-b85a-40f0-874c-08da08c7fa28
X-MS-TrafficTypeDiagnostic: DM5PR1301MB2090:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1301MB209079397F83B3A6D0FBCC27E8139@DM5PR1301MB2090.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: obtteXlO8UjdFW1Mf8Ew6kwsd6d5vLjrV9tV7Bk5YRWO9VC3pOkHTihUrVUyJd5MJjz7wwoJpk8rb+wZQQ82qkaJHlgicAPu0+1YYWakfFiCOqVrGqbMBlg0P4rQ72bHOWv3pB/y0UxXDcjXMqz7UXjq4Xnyr+Dplpqdaq4eRIyRRrWgLfjrWstfT6G25wA5psd2qLA4JR2/RCILYvxTPb1jaYSOkiolU1AN5ws3alnK0NPe281Xf++9RYwDyJ6ZdeX4h4V8hFt0NhWhe5Rx/NmWy+RdO+ZcBZX5VWoHd/ouO8IBEF+uxov6fZ4IIc75jxvgvfNItzv9+/+Si7fb3A3TlaQ3MUas2IS16AYtM/aea0mOzfnVbyUplmbQ5gw6US55isWi9YSr3GDOW+Q6JiwkuM19VH9XVbl9aGeZnsE47vO7/GktksuKG8HOo0k35GNL2S22Pz1z+w+zfOPbvcUuefs/3B9cjOAAupiDOWbBeO7mD9n9niN3/asD7eN+puN0q2yqo4+l+70CLJW9JDEvMonsjVmvvS94gnr5rOAU8Whk/SyJCds9fTNb7pk/3vywfmxy6POC10Vit2j09J56JYlwdKOec2shAj02oFg9MpHrvhLj9//mHmssbrbCs37lpTOIZ9PMDbZNIJGq4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(396003)(136003)(366004)(39830400003)(346002)(2616005)(107886003)(2906002)(186003)(1076003)(8676002)(86362001)(6512007)(36756003)(6506007)(52116002)(508600001)(5660300002)(66946007)(66556008)(66476007)(44832011)(4326008)(6486002)(38100700002)(316002)(6666004)(110136005)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fxFZiNsDKDgfQMn6tD8u/KHs2BhX7qMMKtmKHR9hA6jW0gF2WyfEVZJjnS+j?=
 =?us-ascii?Q?7oWocVPBRr3K75W1l+U8QpVhiFDEJDYHas8xUZS+B04bk/J+NyLDPNKNn1vw?=
 =?us-ascii?Q?hH80OkdWZ3ncGOSf6B0gmBcYzaVlmm6JXl9wCxf/8y/XnETHiCfiz5klBARM?=
 =?us-ascii?Q?GEMQ21LacVSlncxFweHpGYe/wA+qOBxQAUmjznf3akQYFVkOcDCl0KMCnHsI?=
 =?us-ascii?Q?KEx/syHo7ePV5XEWGpUFuZhspRWyfs+YSJjbHurxz1ABWjkzAZVJb1PeyIS7?=
 =?us-ascii?Q?RWoCOSuKo75LPaRakmhZdDJt7OR7m0IwdUVEvqs5fl+e+x0+y8WTqES6ipWE?=
 =?us-ascii?Q?ET4tCJq2rX3wdeO5hMBrxTJjqeIn3RJybaG9KNC0OW0b0eBE5ChaB3pghsNv?=
 =?us-ascii?Q?h6/BqhwB9tSbW3qDv6v6SN33PFn48juQzOwESriok1idtg7pn8jMYIPz+CBc?=
 =?us-ascii?Q?8iONQUBEHUunaNDS4lE7pe1SipOR2QKtvtlM/QSqyZgxwx0yKGXQOPYpvIq5?=
 =?us-ascii?Q?DBf+Z1gkhfPSMqdchvcHphh1leekJkZwKpLpqQAHDGhn762st+FSV0nz+c2l?=
 =?us-ascii?Q?Th5TbtRRbqPGYfLAJWlEQJAATqQiFk8Tai4aF3gRMIN4GtCRTFkrLy1/rxp+?=
 =?us-ascii?Q?FrEs79iwnkNubPSs3K0V6ZHwjsS/CwAqgf4e1prkj6sd5sFq0amcI4hHQctp?=
 =?us-ascii?Q?9NUHhX6XlC6Sd+6ialKgzrJY4BGP6p3ax1xOGZAaF74Ge7uOtLXfJhOG5bdf?=
 =?us-ascii?Q?x+X9DosdFB1LVnuKBzEJbQ2eD0gTKF1wU03nvF4IGP9PaKoAcnXxMhV1EiTw?=
 =?us-ascii?Q?2vWVvZd+XTps9P85nW0aCH0qjyl9f7ff/7BVBu+9eX7RL5e5Ao4Dl1zx+MHa?=
 =?us-ascii?Q?ZcBl87vqCP9Jh7yCzeOzWzKm7UN/716zD/as6l+/4jc0Xm+RgY69eDxcet17?=
 =?us-ascii?Q?JyHW3a0QmYEtlY872UaLZNNRuUQOfWIN2bbPAlpWSROAPVTjucPbwwn6q8YT?=
 =?us-ascii?Q?C/N8dy1ZQ8Vuj6ztTDOjo9hXUqv25tYF2q5Qao4YPlwI9UYiRlCfeKDQJtqt?=
 =?us-ascii?Q?CJs+3YamsjklMT9gQ6e2VStSbcNYBT0rPXVh4coxN5MsI4oD2OLnsUdJZt7r?=
 =?us-ascii?Q?YxMXBuIMnUnhj43CMmteeF2EZ6fBFi4v/WTP3azIrpisXx85ZKxJof3GVQAs?=
 =?us-ascii?Q?NPfvPL6yRqVbXa12DTSSir+GZInIGHu3T++Bat0I0hEnAQPoYi98eHJYOPhV?=
 =?us-ascii?Q?mh10H+nJjjC8voiYWBOdtSvDSr8bNCpMWl2yNuXi8zl2wg5Egxw5aGAaHiUT?=
 =?us-ascii?Q?Q5m5j6fqvFq85t63hiNDQr6l3ZpuNarCqi4KniW4WSPFmquF5bI9iAq2jVz7?=
 =?us-ascii?Q?POylG185CDSp7j156wB+N/vNL3tPuG2tjB0gEhRRzXpFHocGQfoDtUpRLUKR?=
 =?us-ascii?Q?U5h2ypRZfigqTs37LMcLb6JgJuctrjmwu0ckUMQ7G3CFrJr+0MG4Irg1g53h?=
 =?us-ascii?Q?IpG0X0OMN0Q+gLkZyn6KKhBLi5oQMKgYF3cVGzRQFKiUTfbFozvy8g2fsg?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 997388f2-b85a-40f0-874c-08da08c7fa28
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 10:13:41.6082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXIy3nS3LSnWlglPb32+tZ+41RlxzEWu3lsowNLfj7Jlgg272Ovz88T/oF5FKhgIgd8zBVBQhp9Q1pXNf6bW0lpW6oo/rcYOC08tTwgP55g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1301MB2090
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

Make sure that features supported only by some of the data paths
are not enabled for all.  Add a mask of supported features into
the data path op structure.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfd3/rings.c   | 15 +++++++++++++++
 .../net/ethernet/netronome/nfp/nfp_net_common.c   |  3 +++
 drivers/net/ethernet/netronome/nfp/nfp_net_dp.h   |  2 ++
 3 files changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
index 3ebbedd8ba64..47604d5e25eb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
@@ -242,9 +242,24 @@ nfp_nfd3_print_tx_descs(struct seq_file *file,
 	}
 }
 
+#define NFP_NFD3_CFG_CTRL_SUPPORTED					\
+	(NFP_NET_CFG_CTRL_ENABLE | NFP_NET_CFG_CTRL_PROMISC |		\
+	 NFP_NET_CFG_CTRL_L2BC | NFP_NET_CFG_CTRL_L2MC |		\
+	 NFP_NET_CFG_CTRL_RXCSUM | NFP_NET_CFG_CTRL_TXCSUM |		\
+	 NFP_NET_CFG_CTRL_RXVLAN | NFP_NET_CFG_CTRL_TXVLAN |		\
+	 NFP_NET_CFG_CTRL_GATHER | NFP_NET_CFG_CTRL_LSO |		\
+	 NFP_NET_CFG_CTRL_CTAG_FILTER | NFP_NET_CFG_CTRL_CMSG_DATA |	\
+	 NFP_NET_CFG_CTRL_RINGCFG | NFP_NET_CFG_CTRL_RSS |		\
+	 NFP_NET_CFG_CTRL_IRQMOD | NFP_NET_CFG_CTRL_TXRWB |		\
+	 NFP_NET_CFG_CTRL_VXLAN | NFP_NET_CFG_CTRL_NVGRE |		\
+	 NFP_NET_CFG_CTRL_BPF | NFP_NET_CFG_CTRL_LSO2 |			\
+	 NFP_NET_CFG_CTRL_RSS2 | NFP_NET_CFG_CTRL_CSUM_COMPLETE |	\
+	 NFP_NET_CFG_CTRL_LIVE_ADDR)
+
 const struct nfp_dp_ops nfp_nfd3_ops = {
 	.version		= NFP_NFD_VER_NFD3,
 	.tx_min_desc_per_pkt	= 1,
+	.cap_mask		= NFP_NFD3_CFG_CTRL_SUPPORTED,
 	.poll			= nfp_nfd3_poll,
 	.xsk_poll		= nfp_nfd3_xsk_poll,
 	.ctrl_poll		= nfp_nfd3_ctrl_poll,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 5cac5563028c..331253149f50 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2303,6 +2303,9 @@ static int nfp_net_read_caps(struct nfp_net *nn)
 		nn->dp.rx_offset = NFP_NET_RX_OFFSET;
 	}
 
+	/* Mask out NFD-version-specific features */
+	nn->cap &= nn->dp.ops->cap_mask;
+
 	/* For control vNICs mask out the capabilities app doesn't want. */
 	if (!nn->dp.netdev)
 		nn->cap &= nn->app->type->ctrl_cap_mask;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
index 99579722aacf..237ca1d9c886 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
@@ -115,6 +115,7 @@ enum nfp_nfd_version {
  * struct nfp_dp_ops - Hooks to wrap different implementation of different dp
  * @version:			Indicate dp type
  * @tx_min_desc_per_pkt:	Minimal TX descs needed for each packet
+ * @cap_mask:			Mask of supported features
  * @poll:			Napi poll for normal rx/tx
  * @xsk_poll:			Napi poll when xsk is enabled
  * @ctrl_poll:			Tasklet poll for ctrl rx/tx
@@ -131,6 +132,7 @@ enum nfp_nfd_version {
 struct nfp_dp_ops {
 	enum nfp_nfd_version version;
 	unsigned int tx_min_desc_per_pkt;
+	u32 cap_mask;
 
 	int (*poll)(struct napi_struct *napi, int budget);
 	int (*xsk_poll)(struct napi_struct *napi, int budget);
-- 
2.30.2

