Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0079C615278
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 20:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiKATk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 15:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiKATkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 15:40:13 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238EF1DF31
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 12:40:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUA5t0KGKjHgZZ1JdB5M5gYpavuXOgXeecuf12H7J7MzXTs6YArFJOhpDzr+NOMw/l7jy896TgOQhTny6IQwh69fiNyO7vuHVNPLwpLzhFU+NlI8oR85nfiCaXlAy9G//4u96rVn3EcZBtwN/CKfxqWzB05xpXSIH5vbXFSAI2yCK+SpLSmn8otOOpS+61RihtDse8Mv84j+r0L3Tk1Tet976do3mWSsg7tavHPhtZZIUDmlyZ0sIMUmAAXOTBYX7gjN/2g0Mova+LDVuWgvR0yEY4lbKUCydGiokVxFAYfTgNWnBz6Ic64tv8vvBeAD+tPGDhA13IJQCZaRrxz6zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pGaSEr/7L9lUkxs6XrzZHrET+uK5S6+SyeFDK4Y6VpI=;
 b=PXGBophJRpvXauCDCxuQbvevrkc4CnLhqJhbPZdxRZCXrCThKKXW3p4eVV9/T2e3I1Pjl1FxSfkI6SR5DcJeOAIBHrDEdHBa9kcqJA4MDueGO7W0N2+2jrN6LHCqjnDFCFTtMKrd3rdbJPqgwI+Gbm0nxsDxfHW1Rk3FsV+hDsb252L+VEUI8fD0T8EQ4M2TaU59I3aNfZQrlrxYTBb0r/xzyXmuYsjOFURf+WkyvO4ClZrixnYlv7001/C6OG3c+5RIhM2MyjnP5dHcHq92LEgXNeeIdR9ajYbivAE3lwBmnKmAMHmP4k3A3yAzHrOO6JcpvK9focpgPMjm3rT3lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGaSEr/7L9lUkxs6XrzZHrET+uK5S6+SyeFDK4Y6VpI=;
 b=QA4l5ngZ1N/Vjlnfx9b3VSH4Eu2fTbKJcN88/nqv3upLQw/T/B4myuFT/X/o2CcsX49sBBMEHQhO9udSQlPN81vy03W2yqxI0ZBlHe5G7Fm1tXGo0jzgoFYiCInid9bpbf+UUnIEX9WB/KP6JgtfWV7MEK+9GMIfOgNydebZpP/WrPcur73QUE3bOz7z7K3m47EoK9bUp2NBgSopP7Sc5sXpBvMwZDVf8YGbf+D9YHPauM5SRjvII4eI0RWflWtgteRDdOZXeP5/K/iZXX6GLxmXDDJ2dq6UsISccP2brzfyAaiwnIRx8DNHqK4s74H+3KXCUVFfLM2hqu5uXFSduw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by LV2PR12MB5944.namprd12.prod.outlook.com (2603:10b6:408:14f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Tue, 1 Nov
 2022 19:40:09 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 19:40:08 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/2] bridge: Add MAC Authentication Bypass (MAB) support
Date:   Tue,  1 Nov 2022 21:39:21 +0200
Message-Id: <20221101193922.2125323-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221101193922.2125323-1-idosch@nvidia.com>
References: <20221101193922.2125323-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0190.eurprd07.prod.outlook.com
 (2603:10a6:802:3f::14) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|LV2PR12MB5944:EE_
X-MS-Office365-Filtering-Correlation-Id: 8508b7af-02c0-4dc4-8f12-08dabc40e256
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T2SJb9O9JM9XIiv3amo+H1kalHzNh2rO7I1Xn2Kpe6J7eqm4/Yie7e2C1KlGuaDtIF1JC66yzx3Ddi5Ryn7rJthRXpf48iPphk0pZfi5rk5L6vluSg+JYl+GeVXXYw8AyBH943xJnOq49VIDkBkeRhozdd6SR+4CkNcthhlLOReo4vrHlJPMx/Cw/L0dyx+C4NsGyr6iSqYI4GsFUcGn+WjlR/j1CIaVNd6ipQRpJGvBT9cdHJ9aG6okVYT7hqHwPF3u8RpRzV/dsb+ZwV18AzrOiKOcQ/L4osnapyW7An7C8lGEce4/IuOWYfuv2YB/I3xisIvhGWGNtlcjhBFdslvV9UfRrNKew12lvzQkcfiW6UwmFddL96Amz/n4f+jPdJTwyZDSRrWhugZqN6eAa9fWx0AhBxNMj47/FjplxNrxmnBPEpwf4XItSoVAMketr54YkccqKgGFtIS+UDNtRZ3l5FynVMoqa3lsb/Am9Lx1USN71HUcFzGP6p9esVejP3b0ppDNbSnFju22Ow4hWn3/rH2G113cGuC+K8Ja61M+cW3AaXKzCIbW8/7dcxSv1AO17PxdYAkCmBbcTGJydE4QBrO9SSP4iL8FbIqT/kUNTw+WtCmIERJdzhsw+3sww3pKG2aBzjsQKORlZueVjIhkVQgHonvPEEUbpOHsDFC8ReVOT6iLwSfXupYywZcp7k5x8wZSTa1PxPKftN3b4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(451199015)(478600001)(6666004)(107886003)(6512007)(316002)(26005)(6486002)(38100700002)(6506007)(2616005)(66574015)(186003)(1076003)(36756003)(83380400001)(86362001)(2906002)(66476007)(4326008)(66556008)(66946007)(8676002)(41300700001)(30864003)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MaDkFjq56C2E2YvYGUpKGfbfSFBRmhV4PuSJqupmuuP+/RYNI0PeJa4fKMKC?=
 =?us-ascii?Q?uaITD2SibabKQqy6scDoHGjwJC6fWi5e7M/110dCX6TeEK1hlF/js2KklnHF?=
 =?us-ascii?Q?bMYEglo/4mSdHMHpjv7I9UWMGCHlYoNe/Z5O94l9MuQZopGt8ex7aW0w/PaK?=
 =?us-ascii?Q?rPULMB7mm5ARLDRKjncW1DByUO3jg2WFY7qkk1WjKvmEX/BzLi02P2xJQwk9?=
 =?us-ascii?Q?DaU+tvUzBbeUZjOTccihSx5g4xuXq5Px/4HnjNjirXNpyJVFRrwiODJzvda+?=
 =?us-ascii?Q?f/Lrzn08aiXZFV0GOBVW7DZPNHvnbqR1K/3x04S8Jy48r+OAFo8qVKKhxThP?=
 =?us-ascii?Q?mXaXeZnAB4/nTQ3FmKm4YTQi5j7aK/XjJnSDkyHhC4RGV/XHFipuTExZE3/o?=
 =?us-ascii?Q?Dvjq/NiRESTDjPwcedynm50MMrmAzrGElkcrY74UeadEMFyaFHqgnxmGp51n?=
 =?us-ascii?Q?jiibTikbOmS1q0+jv0bLrfAjoFAcsn+D9XhXFjr6Y1GEMYmD42ApHBFlsn9z?=
 =?us-ascii?Q?rCs+fXWUzLUTm1BFyersX60y0TQ0PexDkrlB/ePGc/tYiz8wK7D073z6snti?=
 =?us-ascii?Q?AcSDCW+CCs5M68XbQ2J9vFXa2mHOB2AZIGSMlMxqeElFzPuuuSogOalTsso0?=
 =?us-ascii?Q?NJjW3OsTw+Lj2YJzXA46PruNA1F1JnZ1HahHHrNen3dAH/OD3SpLu0602LF0?=
 =?us-ascii?Q?Di+TYsxH6/V0MBxqj3bItlvdZLhvLBBaLS1E1nYU6Qzc65uU7wzXupEDxY3y?=
 =?us-ascii?Q?P+i7FYxUalauuzgWT7IXY37UUl2bh9sTuCQVCUscnvLN1qyqwti6ZtCIA1vP?=
 =?us-ascii?Q?5BR7yJMWCCJGelH/nj3q8m22bEJnVkqmhF4Bz0utrv2d2XV9Vo4yj/rVzMDj?=
 =?us-ascii?Q?+bqUzU3Ft9mGaIGmafmh6aRbSZyJpVIj5FW3GuQM4g2srnKRXBZ4fU6J3C8L?=
 =?us-ascii?Q?QYHb7MyuHumREibNFi1CNnTycvDVOlgNe0bma7jRj2Bksq4UC5DPRj7dwWBb?=
 =?us-ascii?Q?fwSR8K3nTykOVjuv/puokv4BX8n3vsmMR/ip6QamZH8yDTrUyRZwT59s5Z5I?=
 =?us-ascii?Q?+kl+erFq7Wi1nnEoo85uoWmgiine+DTZwt0jBxqhBiUBvBUSJNR2XL71+V30?=
 =?us-ascii?Q?xRfpn0Yq0AAgxwRGEitq3qC+bsF7mHvua0f8+QDhMK0Dtb7KVvQir+3d4agc?=
 =?us-ascii?Q?NavB0d6YdAgoXokBrF3mfviN2xYGtwrid8VmiiZ7W9t+9nSD2HZxdvyXj2HK?=
 =?us-ascii?Q?n+o1kx0uyxv09C9ab4ifvpQxN+HivRXYdvRtvA72vgijX/SWWBovbRR9zy5r?=
 =?us-ascii?Q?kkxEyfexbBQDeKpL0osQK71IjlWge+X4cRccFVxlHvJd6/CQUKXgI13vfQb1?=
 =?us-ascii?Q?i9m9hL/JfgBPkXpZG/CBoq1OZ5U+kiMFLCts9soQEzpCdingNm5UoZTqQjJV?=
 =?us-ascii?Q?zPDZIiJGXYMAi2plDncg2Lq/ViZSF/rmPJHXcVivLEbdhedsHb30jsQQZiH6?=
 =?us-ascii?Q?4U64+UbQUHBcOi89AFM12+alfP+I97PZdzT/IjFZeIhH1b/k7SSunu3sPcDE?=
 =?us-ascii?Q?IAgLLdEi2qWOCgEm8ob9TIfRiOVHKLt06wdv1/vh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8508b7af-02c0-4dc4-8f12-08dabc40e256
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 19:40:08.8687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P4MGXmzuxdzH5M66y25JLr7vnrAiCSdTfGnEI8Mn/K8I7IQ6sWuF3kwROo10XFFe6eNYX/QTdAdI1SR56/GF8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5944
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Hans J. Schultz" <netdev@kapio-technology.com>

Hosts that support 802.1X authentication are able to authenticate
themselves by exchanging EAPOL frames with an authenticator (Ethernet
bridge, in this case) and an authentication server. Access to the
network is only granted by the authenticator to successfully
authenticated hosts.

The above is implemented in the bridge using the "locked" bridge port
option. When enabled, link-local frames (e.g., EAPOL) can be locally
received by the bridge, but all other frames are dropped unless the host
is authenticated. That is, unless the user space control plane installed
an FDB entry according to which the source address of the frame is
located behind the locked ingress port. The entry can be dynamic, in
which case learning needs to be enabled so that the entry will be
refreshed by incoming traffic.

There are deployments in which not all the devices connected to the
authenticator (the bridge) support 802.1X. Such devices can include
printers and cameras. One option to support such deployments is to
unlock the bridge ports connecting these devices, but a slightly more
secure option is to use MAB. When MAB is enabled, the MAC address of the
connected device is used as the user name and password for the
authentication.

For MAB to work, the user space control plane needs to be notified about
MAC addresses that are trying to gain access so that they will be
compared against an allow list. This can be implemented via the regular
learning process with the sole difference that learned FDB entries are
installed with a new "locked" flag indicating that the entry cannot be
used to authenticate the device. The flag cannot be set by user space,
but user space can clear the flag by replacing the entry, thereby
authenticating the device.

Locked FDB entries implement the following semantics with regards to
roaming, aging and forwarding:

1. Roaming: Locked FDB entries can roam to unlocked (authorized) ports,
   in which case the "locked" flag is cleared. FDB entries cannot roam
   to locked ports regardless of MAB being enabled or not. Therefore,
   locked FDB entries are only created if an FDB entry with the given {MAC,
   VID} does not already exist. This behavior prevents unauthenticated
   devices from disrupting traffic destined to already authenticated
   devices.

2. Aging: Locked FDB entries age and refresh by incoming traffic like
   regular entries.

3. Forwarding: Locked FDB entries forward traffic like regular entries.
   If user space detects an unauthorized MAC behind a locked port and
   wishes to prevent traffic with this MAC DA from reaching the host, it
   can do so using tc or a different mechanism.

Enable the above behavior using a new bridge port option called "mab".
It can only be enabled on a bridge port that is both locked and has
learning enabled. Locked FDB entries are flushed from the port once MAB
is disabled. A new option is added because there are pure 802.1X
deployments that are not interested in notifications about locked FDB
entries.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v1:
    * Extend commit message.
    * Adjust extack message.
    * Flush locked FDB entries when MAB is disabled.
    * Refresh locked FDB entries.
    * Add comments in br_handle_frame_finish().
    
    Changes made by me:
    * Reword commit message.
    * Reword comment regarding 'NTF_EXT_LOCKED'.
    * Use extack in br_fdb_add().
    * Forbid MAB when learning is disabled.

 include/linux/if_bridge.h      |  1 +
 include/uapi/linux/if_link.h   |  1 +
 include/uapi/linux/neighbour.h |  8 +++++++-
 net/bridge/br_fdb.c            | 24 ++++++++++++++++++++++++
 net/bridge/br_input.c          | 21 +++++++++++++++++++--
 net/bridge/br_netlink.c        | 21 ++++++++++++++++++++-
 net/bridge/br_private.h        |  3 ++-
 net/core/rtnetlink.c           |  5 +++++
 8 files changed, 79 insertions(+), 5 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index d62ef428e3aa..1668ac4d7adc 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -59,6 +59,7 @@ struct br_ip_list {
 #define BR_MRP_LOST_IN_CONT	BIT(19)
 #define BR_TX_FWD_OFFLOAD	BIT(20)
 #define BR_PORT_LOCKED		BIT(21)
+#define BR_PORT_MAB		BIT(22)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5e7a1041df3a..d92b3f79eba3 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -561,6 +561,7 @@ enum {
 	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
 	IFLA_BRPORT_LOCKED,
+	IFLA_BRPORT_MAB,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index a998bf761635..5e67a7eaf4a7 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -52,7 +52,8 @@ enum {
 #define NTF_STICKY	(1 << 6)
 #define NTF_ROUTER	(1 << 7)
 /* Extended flags under NDA_FLAGS_EXT: */
-#define NTF_EXT_MANAGED	(1 << 0)
+#define NTF_EXT_MANAGED		(1 << 0)
+#define NTF_EXT_LOCKED		(1 << 1)
 
 /*
  *	Neighbor Cache Entry States.
@@ -86,6 +87,11 @@ enum {
  * NTF_EXT_MANAGED flagged neigbor entries are managed by the kernel on behalf
  * of a user space control plane, and automatically refreshed so that (if
  * possible) they remain in NUD_REACHABLE state.
+ *
+ * NTF_EXT_LOCKED flagged bridge FDB entries are entries generated by the
+ * bridge in response to a host trying to communicate via a locked bridge port
+ * with MAB enabled. Their purpose is to notify user space that a host requires
+ * authentication.
  */
 
 struct nda_cacheinfo {
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index e7f4fccb6adb..3b83af4458b8 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -105,6 +105,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 	struct nda_cacheinfo ci;
 	struct nlmsghdr *nlh;
 	struct ndmsg *ndm;
+	u32 ext_flags = 0;
 
 	nlh = nlmsg_put(skb, portid, seq, type, sizeof(*ndm), flags);
 	if (nlh == NULL)
@@ -125,11 +126,16 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 		ndm->ndm_flags |= NTF_EXT_LEARNED;
 	if (test_bit(BR_FDB_STICKY, &fdb->flags))
 		ndm->ndm_flags |= NTF_STICKY;
+	if (test_bit(BR_FDB_LOCKED, &fdb->flags))
+		ext_flags |= NTF_EXT_LOCKED;
 
 	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
 		goto nla_put_failure;
 	if (nla_put_u32(skb, NDA_MASTER, br->dev->ifindex))
 		goto nla_put_failure;
+	if (nla_put_u32(skb, NDA_FLAGS_EXT, ext_flags))
+		goto nla_put_failure;
+
 	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
 	ci.ndm_confirmed = 0;
 	ci.ndm_updated	 = jiffies_to_clock_t(now - fdb->updated);
@@ -171,6 +177,7 @@ static inline size_t fdb_nlmsg_size(void)
 	return NLMSG_ALIGN(sizeof(struct ndmsg))
 		+ nla_total_size(ETH_ALEN) /* NDA_LLADDR */
 		+ nla_total_size(sizeof(u32)) /* NDA_MASTER */
+		+ nla_total_size(sizeof(u32)) /* NDA_FLAGS_EXT */
 		+ nla_total_size(sizeof(u16)) /* NDA_VLAN */
 		+ nla_total_size(sizeof(struct nda_cacheinfo))
 		+ nla_total_size(0) /* NDA_FDB_EXT_ATTRS */
@@ -879,6 +886,11 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 						      &fdb->flags)))
 					clear_bit(BR_FDB_ADDED_BY_EXT_LEARN,
 						  &fdb->flags);
+				/* Clear locked flag when roaming to an
+				 * unlocked port.
+				 */
+				if (unlikely(test_bit(BR_FDB_LOCKED, &fdb->flags)))
+					clear_bit(BR_FDB_LOCKED, &fdb->flags);
 			}
 
 			if (unlikely(test_bit(BR_FDB_ADDED_BY_USER, &flags)))
@@ -1082,6 +1094,9 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 		modified = true;
 	}
 
+	if (test_and_clear_bit(BR_FDB_LOCKED, &fdb->flags))
+		modified = true;
+
 	if (fdb_handle_notify(fdb, notify))
 		modified = true;
 
@@ -1150,6 +1165,7 @@ int br_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	struct net_bridge_port *p = NULL;
 	struct net_bridge_vlan *v;
 	struct net_bridge *br = NULL;
+	u32 ext_flags = 0;
 	int err = 0;
 
 	trace_br_fdb_add(ndm, dev, addr, vid, nlh_flags);
@@ -1178,6 +1194,14 @@ int br_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 		vg = nbp_vlan_group(p);
 	}
 
+	if (tb[NDA_FLAGS_EXT])
+		ext_flags = nla_get_u32(tb[NDA_FLAGS_EXT]);
+
+	if (ext_flags & NTF_EXT_LOCKED) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot add FDB entry with \"locked\" flag set");
+		return -EINVAL;
+	}
+
 	if (tb[NDA_FDB_EXT_ATTRS]) {
 		attr = tb[NDA_FDB_EXT_ATTRS];
 		err = nla_parse_nested(nfea_tb, NFEA_MAX, attr,
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 68b3e850bcb9..d04d2205ad4e 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -109,9 +109,26 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 		struct net_bridge_fdb_entry *fdb_src =
 			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
 
-		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
-		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
+		if (!fdb_src) {
+			/* FDB miss. Create locked FDB entry if MAB is enabled
+			 * and drop the packet.
+			 */
+			if (p->flags & BR_PORT_MAB)
+				br_fdb_update(br, p, eth_hdr(skb)->h_source,
+					      vid, BIT(BR_FDB_LOCKED));
 			goto drop;
+		} else if (READ_ONCE(fdb_src->dst) != p ||
+			   test_bit(BR_FDB_LOCAL, &fdb_src->flags)) {
+			/* FDB mismatch. Drop the packet without roaming. */
+			goto drop;
+		} else if test_bit(BR_FDB_LOCKED, &fdb_src->flags) {
+			/* FDB match, but entry is locked. Refresh it and drop
+			 * the packet.
+			 */
+			br_fdb_update(br, p, eth_hdr(skb)->h_source, vid,
+				      BIT(BR_FDB_LOCKED));
+			goto drop;
+		}
 	}
 
 	nbp_switchdev_frame_mark(p, skb);
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 5aeb3646e74c..722fcfb857fc 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -188,6 +188,7 @@ static inline size_t br_port_info_size(void)
 		+ nla_total_size(1)	/* IFLA_BRPORT_NEIGH_SUPPRESS */
 		+ nla_total_size(1)	/* IFLA_BRPORT_ISOLATED */
 		+ nla_total_size(1)	/* IFLA_BRPORT_LOCKED */
+		+ nla_total_size(1)	/* IFLA_BRPORT_MAB */
 		+ nla_total_size(sizeof(struct ifla_bridge_id))	/* IFLA_BRPORT_ROOT_ID */
 		+ nla_total_size(sizeof(struct ifla_bridge_id))	/* IFLA_BRPORT_BRIDGE_ID */
 		+ nla_total_size(sizeof(u16))	/* IFLA_BRPORT_DESIGNATED_PORT */
@@ -274,7 +275,8 @@ static int br_port_fill_attrs(struct sk_buff *skb,
 	    nla_put_u8(skb, IFLA_BRPORT_MRP_IN_OPEN,
 		       !!(p->flags & BR_MRP_LOST_IN_CONT)) ||
 	    nla_put_u8(skb, IFLA_BRPORT_ISOLATED, !!(p->flags & BR_ISOLATED)) ||
-	    nla_put_u8(skb, IFLA_BRPORT_LOCKED, !!(p->flags & BR_PORT_LOCKED)))
+	    nla_put_u8(skb, IFLA_BRPORT_LOCKED, !!(p->flags & BR_PORT_LOCKED)) ||
+	    nla_put_u8(skb, IFLA_BRPORT_MAB, !!(p->flags & BR_PORT_MAB)))
 		return -EMSGSIZE;
 
 	timerval = br_timer_value(&p->message_age_timer);
@@ -876,6 +878,7 @@ static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
 	[IFLA_BRPORT_NEIGH_SUPPRESS] = { .type = NLA_U8 },
 	[IFLA_BRPORT_ISOLATED]	= { .type = NLA_U8 },
 	[IFLA_BRPORT_LOCKED] = { .type = NLA_U8 },
+	[IFLA_BRPORT_MAB] = { .type = NLA_U8 },
 	[IFLA_BRPORT_BACKUP_PORT] = { .type = NLA_U32 },
 	[IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT] = { .type = NLA_U32 },
 };
@@ -943,6 +946,22 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 	br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_SUPPRESS, BR_NEIGH_SUPPRESS);
 	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
 	br_set_port_flag(p, tb, IFLA_BRPORT_LOCKED, BR_PORT_LOCKED);
+	br_set_port_flag(p, tb, IFLA_BRPORT_MAB, BR_PORT_MAB);
+
+	if ((p->flags & BR_PORT_MAB) &&
+	    (!(p->flags & BR_PORT_LOCKED) || !(p->flags & BR_LEARNING))) {
+		NL_SET_ERR_MSG(extack, "Bridge port must be locked and have learning enabled when MAB is enabled");
+		p->flags = old_flags;
+		return -EINVAL;
+	} else if (!(p->flags & BR_PORT_MAB) && (old_flags & BR_PORT_MAB)) {
+		struct net_bridge_fdb_flush_desc desc = {
+			.flags = BIT(BR_FDB_LOCKED),
+			.flags_mask = BIT(BR_FDB_LOCKED),
+			.port_ifindex = p->dev->ifindex,
+		};
+
+		br_fdb_flush(p->br, &desc);
+	}
 
 	changed_mask = old_flags ^ p->flags;
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 06e5f6faa431..4ce8b8e5ae0b 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -251,7 +251,8 @@ enum {
 	BR_FDB_ADDED_BY_EXT_LEARN,
 	BR_FDB_OFFLOADED,
 	BR_FDB_NOTIFY,
-	BR_FDB_NOTIFY_INACTIVE
+	BR_FDB_NOTIFY_INACTIVE,
+	BR_FDB_LOCKED,
 };
 
 struct net_bridge_fdb_key {
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index d2f27548fc0b..b64fffeb3844 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4051,6 +4051,11 @@ int ndo_dflt_fdb_add(struct ndmsg *ndm,
 		return err;
 	}
 
+	if (tb[NDA_FLAGS_EXT]) {
+		netdev_info(dev, "invalid flags given to default FDB implementation\n");
+		return err;
+	}
+
 	if (vid) {
 		netdev_info(dev, "vlans aren't supported yet for dev_uc|mc_add()\n");
 		return err;
-- 
2.37.3

