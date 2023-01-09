Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE835662718
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236987AbjAINcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbjAINcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:32:06 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2079.outbound.protection.outlook.com [40.107.212.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569001DDE3
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:31:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhVc0uwczWSfsA0P8Z8oMHSywGyNUDoiwpFjN2QYBkpZ/JrOO+ClJyJdFk88ucEnlIccFITfYcojftZWHLmF6evQurVdrmRHRI2QYopg1th0aiZqAHiSFsoBef18zpFP71iwtrSgd+mMdrapH8VlnTxCsZwNoth5IYf3DxBYRmvHJrIBmeQlID8SglY+xr/+dT4rc4bVxnoi5ub9nWS2vEp3ayv7ow/1aY7qgX02i0scpzHml+xNA47FDQN9MZ47enTECoFTDFxrY6DjhyvcgUUaEmM6j/prrEqUB+bi0MFMOE38MqVMooIKLsBy2YwNF3vnLh6qVCJDrH0c8HNqYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSbqvpduWPvPFPOdZI4/4XxchUwmeWApE5sppiqjW7M=;
 b=Kb0UsMUPiECSsZrxUqBpzr3oHTANfbwpY4R90MfmD2kAkFrn+c74Hsml8lCSyZ5+iHF2EXLI6ioeWbwGuk2M/1u7mMCf0QMk8vc4buUsrVure+F3ag1X3wdSHsWs7L1rHvVA6u9AAV1UozcriUcs7VKNot8m6csAcODOeRw2TUGrXGBj+5ZcwmkaJraBNvDjV5oES/bZOcMIwv47COpbGMXGxGGKM/6dXDeBrrAD3ViSCt8mvu1YlGAD3avhnHV8P6W8YOHtAyvbBQccRt6HVIJ9UxoWzYRcrg4VUMn07JEctiyquvclO7WvcPEDvXNQtqPZUqRAQfem1slKeeQNpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSbqvpduWPvPFPOdZI4/4XxchUwmeWApE5sppiqjW7M=;
 b=d1MEna3NpTikH6kGBUE/JEMvRK88dFYnBWnDJdzUThErihcUSB/4pnES/cxaMe7eQdtjXDU7lzz33+Ch6rmU8Tq/j1WgR5326fDvDEt9FSGDVUQ80iFEr/SLQpmyKThYDQDI4RTL9Y6DLjJ5lIKvifP5msnaK3QdUHm6f4iZ3bwsOIj9bBbhDQ2uaJ/y9HtcapPbs1+t0TqUh00vEZsnJUdC0tH6JKaeMfDMmEoc3jB3IRNltJJgovj8OcOEULy7x/aFNIcaq5BqeR+HsPT58YEY193/WflAUDTY0j3NkgOLrvucU+5iyk9bcRYXf4EJqeAI2/Z8X58g9Y380VSH0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH7PR12MB7307.namprd12.prod.outlook.com (2603:10b6:510:20b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 9 Jan
 2023 13:31:42 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:31:42 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v8 02/25] net/ethtool: add new stringset ETH_SS_ULP_DDP{,_STATS}
Date:   Mon,  9 Jan 2023 15:30:53 +0200
Message-Id: <20230109133116.20801-3-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0171.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::7) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH7PR12MB7307:EE_
X-MS-Office365-Filtering-Correlation-Id: d240e6f7-b233-4f52-b747-08daf245d83b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uiBSgP0AmG8Vu7MhpzXLhPOvrmZCH6Sdm6hZS5e1ejnu5ipp+Vtp5Rh/WAdzAmJs4SwB69ILqn4KxZxHOrNbXNuTq5jtjqyEcpQGHKIdh+tDc/NTn3wumtG9nMtTcOVUU/E4XefBej89O5MdbCX/cvoEvQkIiXpMk9k+/qCpxGkiABNmYNatcCs+6yPXYzymgelHWpYoVp7Je8r0kxQ+/4iFapS06dTVkP18ipR0xcPBCnorI5sx7PaXfj0BQIf9DzFeetlTIasmEEe5bYh0+XiPD6OYqKBJ3iBN3t9nTrnyDbiLyrYVTUDwhiFrr6KQtxFPqRXYdooeJQKNTshRwQlLBdu5yUjnYCJFvZ6dMsXyjP6HhfDlabwOtgfNz14VkBZfVakQrwO43MF9vYPeyZ5nb7EuUqn33rL9ZfPGQXKon4q+GE+g3etbPoHn6V9/ZFrE8FAoMNYXQKU7iO+GmLGvS6cKqoOGnkZ/FGtEkwCl71AFeVXtI7BeHosX/Ib75xc9rOfBVw3AEwm7YCUQKmYL/svTsk8v9GITP6sJM9RFZmHfSq3U/jY/U9FAPJuZSN+/YQ5JdUj2rFDbY5JrT56AZR8Bu0DqBb23aDiKNIVJSMTk0ySOnQ5T2zP2d1Yo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199015)(4326008)(6506007)(38100700002)(107886003)(6666004)(8936002)(66556008)(5660300002)(86362001)(2616005)(478600001)(26005)(6512007)(41300700001)(6486002)(186003)(36756003)(7416002)(316002)(66476007)(83380400001)(2906002)(1076003)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r7ydNBV9g/OgGjv/IwEqheFAiVAaCu0XKcv4pnoKHP9cwQ8+sepT2a3MRCqv?=
 =?us-ascii?Q?A5KZtFEW5lp4B94djpMPU0yNY9S1VZhtmZt4wY+g17buzTDuxMDcfQGe8GV/?=
 =?us-ascii?Q?eEcxj6EeB9APnd+i/INw3kaS3U0YtyG3tp4QGjXy6XNWJGOas5gQc5O0qxjl?=
 =?us-ascii?Q?JZAKsPhetBSwa6CTkzW7h5MU5bVcqM0xNv8yyvT6HS7x8awZ1Xt3AlQ3rdkG?=
 =?us-ascii?Q?44G47IXzWXqg/aQChb44V0Ib24E3Ge/RJebHXeBDudCGmVY7CvSXLM3grQIW?=
 =?us-ascii?Q?cVDjHQPjMYw08nB7GwDGqZW5lA0NpAXPLh6wWTsQ5gjm6XfMrfENM5WdZ9So?=
 =?us-ascii?Q?DSLfbFo9JQmYm/0L9KjfPJXcSBKFMr+Vgsamkhp7CKTboDz8XUyeJAL1wI8K?=
 =?us-ascii?Q?6iyRfg1RfTHqCOWrcvhuoh/jIZlfroThPNBD7Clt0SKfn/06/pmh4b1hvc/v?=
 =?us-ascii?Q?ZVWCkaeMHhZfCpLgkVLIobV6arJwj7hHe7k8HHpCt731yPvsNU55lE6bqTFY?=
 =?us-ascii?Q?Xr0yL7+lPhWiSxQ0DHwyFmNU2Sp/6kbqpZ8iad9LSA7NZgLGf+kY2uBB17KZ?=
 =?us-ascii?Q?jprrU4QYFP7EDHu2XDJj8kFmRbmhsKvxejtXvR97OA2mefMhR0/7BxMiTlFC?=
 =?us-ascii?Q?Zwy1JqdaV7m6eRCFgEbEIIkiHvJ5g4vi9AKEhqUNJd9wFZq7imIrgsfyiZgx?=
 =?us-ascii?Q?jVBKhnrJ6wBARmuNUAKZCv6QsQQI3JW/18PfO6eOWI759qv3dcuOHhpZHpdu?=
 =?us-ascii?Q?8/W37NW+Rf1t4KGUWDyDid89K0HIbQkvDvY+easO+zp5/7OO0U0DTdNKGOzU?=
 =?us-ascii?Q?ub54souQaRufJjDiDPUykSueJpvktt6Qv/89rMDQ8f8BDmDAMGpKZqu1Tyj5?=
 =?us-ascii?Q?Upy0y8dFcUSgpA6dnkLl5AbuY89toUOwPjgRk/31gnrkKTiK5ivL5X749YeR?=
 =?us-ascii?Q?3dp49BVXLQ7KyJKpnVp7Pnx9ELbCWI0BwLwyCRTE0+UsfaEDlOfRISERRDZL?=
 =?us-ascii?Q?orcNk3bnJUUELGvdKH2e92X7xYTRwNyWyoLWxWKa/gWHzakOTOdNvDJKD3I3?=
 =?us-ascii?Q?neANYTLh8cHQaqNrmSufY0ZugFBKOFB9QUyQ9BLLXUqWobq+DHkx2KQ4xUdT?=
 =?us-ascii?Q?CwU4aEoQyJCNdk0r/ROy0db5AeJAT5wbR+mexzmX7jtCkVKZqJKEwDzd2ZSd?=
 =?us-ascii?Q?oscAyDAluk0p2IOqS7kOhzpFoPalAzPqeg3Zc6WJ/c4NE7/uwyXEDNkn2DLE?=
 =?us-ascii?Q?rLAZwJo8cA9XiVK/0sOHu9hXT0nhm5VT/3uGJHXv/wXa5AzyjAz4ShjEkWAX?=
 =?us-ascii?Q?qq/QH3Wj9QAWmcASx8YBuZa9HubKzshVaXT1ZguMDFfsxt7KHYphukHuXcDP?=
 =?us-ascii?Q?wdUzBiGHHqoD0fU1KmBI3YPXklSrf0DnGVYJemKwkFwX3rek2ykF8aPi2wcA?=
 =?us-ascii?Q?gGvmZxRFu3f8XJWlEtiFzbEyim7KXK5zqWftKdi0gfPos85VLjn53as/o0i+?=
 =?us-ascii?Q?r7WWl9LcIafpz+N1ZKW/yX9+pI5V0ckjfujHEuWc/Bk8bpUO/U3nl/VpIuZV?=
 =?us-ascii?Q?4wBnheq5Z0YYX2TfNTnM/scYn5ukiQ3WrFw0p8Ad?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d240e6f7-b233-4f52-b747-08daf245d83b
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:31:42.1428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GTzNd6lmE/mHbk07WF+BHMgLSPs1PLgcqhFerELQc5AJLxrcKwdCl5QHJwT9IvdwoEJsxlhv6TLFD+udrMPSIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7307
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit exposes ULP DDP capability and statistics names to
userspace via netlink.

In order to support future ULP DDP capabilities and statistics without
having to change the netlink protocol (and userspace ethtool) we add
new string sets to let userspace dynamically fetch what the kernel
supports. This also allows drivers to return their own statistics.

* ETH_SS_ULP_DDP stores names of ULP DDP capabilities
* ETH_SS_ULP_DDP_STATS stores names of ULP DDP statistics. Different
  drivers can report different stats, so make this a per-device string
  set.

These stringsets will be used in later commits when implementing the
new ULP DDP GET/SET netlink messages.

We keep the convention of strset.c of having the static_assert()
right after the array declaration, despite the checkpatch warning.

Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 include/uapi/linux/ethtool.h | 4 ++++
 net/ethtool/common.c         | 7 +++++++
 net/ethtool/common.h         | 1 +
 net/ethtool/strset.c         | 9 +++++++++
 4 files changed, 21 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 3135fa0ba9a4..c7bd00976309 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -681,6 +681,8 @@ enum ethtool_link_ext_substate_module {
  * @ETH_SS_STATS_ETH_MAC: names of IEEE 802.3 MAC statistics
  * @ETH_SS_STATS_ETH_CTRL: names of IEEE 802.3 MAC Control statistics
  * @ETH_SS_STATS_RMON: names of RMON statistics
+ * @ETH_SS_ULP_DDP: names of ULP DDP capabilities
+ * @ETH_SS_ULP_DDP_STATS: per-device names of ULP DDP statistics
  *
  * @ETH_SS_COUNT: number of defined string sets
  */
@@ -706,6 +708,8 @@ enum ethtool_stringset {
 	ETH_SS_STATS_ETH_MAC,
 	ETH_SS_STATS_ETH_CTRL,
 	ETH_SS_STATS_RMON,
+	ETH_SS_ULP_DDP,
+	ETH_SS_ULP_DDP_STATS,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 6f399afc2ff2..5ecaaa25cc98 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -5,6 +5,7 @@
 #include <linux/phy.h>
 #include <linux/rtnetlink.h>
 #include <linux/ptp_clock_kernel.h>
+#include <net/ulp_ddp_caps.h>
 
 #include "common.h"
 
@@ -457,6 +458,12 @@ const char udp_tunnel_type_names[][ETH_GSTRING_LEN] = {
 static_assert(ARRAY_SIZE(udp_tunnel_type_names) ==
 	      __ETHTOOL_UDP_TUNNEL_TYPE_CNT);
 
+const char ulp_ddp_names[][ETH_GSTRING_LEN] = {
+	[ULP_DDP_C_NVME_TCP_BIT]		= "nvme-tcp-ddp",
+	[ULP_DDP_C_NVME_TCP_DDGST_RX_BIT]	= "nvme-tcp-ddgst-rx-offload",
+};
+static_assert(ARRAY_SIZE(ulp_ddp_names) == ULP_DDP_C_COUNT);
+
 /* return false if legacy contained non-0 deprecated fields
  * maxtxpkt/maxrxpkt. rest of ksettings always updated
  */
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index b1b9db810eca..3d4bb3fb43db 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -36,6 +36,7 @@ extern const char sof_timestamping_names[][ETH_GSTRING_LEN];
 extern const char ts_tx_type_names[][ETH_GSTRING_LEN];
 extern const char ts_rx_filter_names[][ETH_GSTRING_LEN];
 extern const char udp_tunnel_type_names[][ETH_GSTRING_LEN];
+extern const char ulp_ddp_names[][ETH_GSTRING_LEN];
 
 int __ethtool_get_link(struct net_device *dev);
 
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 3f7de54d85fb..3928b5548713 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -2,6 +2,7 @@
 
 #include <linux/ethtool.h>
 #include <linux/phy.h>
+#include <net/ulp_ddp_caps.h>
 #include "netlink.h"
 #include "common.h"
 
@@ -105,6 +106,14 @@ static const struct strset_info info_template[] = {
 		.count		= __ETHTOOL_A_STATS_RMON_CNT,
 		.strings	= stats_rmon_names,
 	},
+	[ETH_SS_ULP_DDP] = {
+		.per_dev	= false,
+		.count		= ULP_DDP_C_COUNT,
+		.strings	= ulp_ddp_names,
+	},
+	[ETH_SS_ULP_DDP_STATS] = {
+		.per_dev	= true,
+	},
 };
 
 struct strset_req_info {
-- 
2.31.1

