Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA00960C96B
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbiJYKHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiJYKHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:07:00 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E230F18DA97
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:00:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZRYzM0kOoVrQPbqNCeyGVIzQekSk4BqmVGdV+E4uqB28Mv3ODo0bmRLMZPvFqTg6hARIfTr2puaociKrdlS3YgvAWJfB0lvVIb34lSqplfiFbSoyQNCdDNiJoA2ct6VKTUhIsT0Uy/yf0bbKfQhsT8FGdxOVrkfpnKwn5R7hWE33GbWDqU1+1ngc/VnBDzjvEVyRoz/lmwYV3K7BiXIuyFb377rOtnl4WBDa+qRms+VbUGS+1jw+2gGh0uNS+Btg27ro7VvuQN3eTYhbh/oE91XyMj24hy4nMqx9zlt1rdEA1nZWxX2QIF/jrq8LEOvB+tsnK2V98HuHHmY2lqYQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCxCKxjI0yYAncPB5mB/XoPRlCAhjX4Mbvpxq5EQdBM=;
 b=YmbSU9W667XqWGX1G0TU5ntJFIktR0ioU5UBTgVxwfTXIlBi7DW1Vie1WxGi/gWmlcA8hMnuwiEOeX64ZboK1zSex0u1iqWbV21Unax6AxZ72EQvGSzxFO+/ngsTdErerjDdX+rHtG1bjSP3YvRuTOx5H/YMlXhDYzdsND5JhcBWW6VSzhQU+KpAgmXHMo4pJl8x6Ah2AAQmxxmaUUYr2v6+DJ4Mwgod7bcwLadgDqoK7XTo2Que1TPDelEbynlxPqwPOLzQAfac2QpZiWGz2N5FgU3xa0KVpYfmM2z8de0AtJA32A/ba2UKCbscEg4Le8ewkLdwA6kV4hEHP/9ZSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCxCKxjI0yYAncPB5mB/XoPRlCAhjX4Mbvpxq5EQdBM=;
 b=cP+e+A/t2VEnnpoSX1Pha7n2BpqXUE8yT9hTHdiKC/ZKq9DL2YxyCkjQAT55akK+nqO74zopp1Km+qMIEOoCmKVasbU+TPdEGJfVazkQeotgE1MbuBGoTeHwsJH/4VCepbDaaNJwnJoK4eI28HptBQIL+noESsjQkzZO9QY1391TobCSTn3LaY07AtLxeIjGRdZkKWlXDLu1HJPnDkV0IgwwyXu4v7LuB5jw1j6HHb/S5elZD9JKR6d6zyRfztnTIb2VuMg/CvulerwI4IJFP6xvUCzZ+6puyKuXbZogUokbxwfl/beVNSTlRYeXArq018TKzSH+GL4P55jOaq62JA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL0PR12MB4929.namprd12.prod.outlook.com (2603:10b6:208:1c4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 10:00:54 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:00:54 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 01/16] bridge: Add MAC Authentication Bypass (MAB) support
Date:   Tue, 25 Oct 2022 13:00:09 +0300
Message-Id: <20221025100024.1287157-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025100024.1287157-1-idosch@nvidia.com>
References: <20221025100024.1287157-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0250.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::23) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL0PR12MB4929:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a3a452c-4b50-4f1e-ed4b-08dab66fce42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EjBGOl0fvZjXRVKYqn17jxZvQ0T3U5c4wSZZKMroK3bFDH4D7Pwj51xUKEPG5cBpCSi0AUMXxT0/FfQJxupnarGi8s1aL8tOowzLndM6P6s0uODki0txRFcA3eaRST0Ow8gNE91wcQ2dvBqblguxxiNjcLafMR7uDiP5xfqyUmjCYScYxvHeIbQnlAxaW5mSRGKqTu1EDwdZ+8W/E/oN24r+aep3UTpHkP7xqDukLiJvs/WGv0G85Fml2Uug2QPStWSZJW1EASg++RWqoU0tvS6g7Pl41pNZZZWzBcwPvVYovYknPw4STpG7et2PZPaov/pW4GH/xuVzPPvGw9bdnZBsh4iO4WLySe+cSxhHl60GjMeNe8L5BD/oWp2xIhlIxMGsEGpwW05tQAoRiJF2KtJeqTP0DEbQKy3h+SOaiU1pKyC0kNadM3ZftLh36l81+dou+16B57zUambqm+Uf3gqR7d+4jYPuP6do5J79rYNAYKYfa3icOP5rhomcrZWBp2ho3MnFuDXOZlohJsVsYmdrgW0GCP9tHPW+bgk1JzV7OKQ8BMCR20IESHVnjJjfndgsN+aWjv0wZXNb7Sgmj4prSzSZhOWs65xFYdjF/X/KZ15sU03s+IjxDTVKhgvaJ1IyudW/hlWbJI5up1drOexrKsOJWa9UcT2rWu/PfdUn6zHAHEsIV0kEuURNSiO6AiCSxHJfYIrsGBsSTX4WeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(86362001)(36756003)(38100700002)(2906002)(66574015)(5660300002)(8936002)(7416002)(83380400001)(30864003)(1076003)(107886003)(6666004)(26005)(6512007)(2616005)(186003)(6506007)(478600001)(8676002)(66476007)(41300700001)(66946007)(66556008)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rPLePhoeEYgVA+r2zxNj5qI0DWOgOFhmYsfoxyNyrDtGkT8bnRxtX9W+mk3k?=
 =?us-ascii?Q?SWtuXXeHn8BYQfCcZHGq/lpbpOJlESbJjGvay6tGhyqx49dnf+7ISWjCUZDn?=
 =?us-ascii?Q?c1eMd1cvqDAT/y3HCA7OF4iLh2XKpIcwgxHPI6BKj+bY3K16Mh5j14LKTXsr?=
 =?us-ascii?Q?aBMelTOmdPH3UQoPn6JAHJnAXnYYPCLmhBwRyUWxtE9VBmurQBYPuH4YkPxn?=
 =?us-ascii?Q?cTyUYnqbXeaRGlNy+f01wjudKHKmb8x6fOjuzQnsBFBw2c9Ql7DveBxTDSJD?=
 =?us-ascii?Q?39ViH61tIfC5N6HUeGKM8lkp4126g9KoR2bO93Lx76UVeJjQ2MUqPjR0hLgx?=
 =?us-ascii?Q?0fmsSlZkyMAHrlbW04PZoenr45klsQmUi40P6VQlndSK79rGGIHyQhMq7DsE?=
 =?us-ascii?Q?Av9pL2A0ku0HRelFdjDzuZoi+guOlrkzbVl9v0wEV/eFDMBTBz/G/6nSv130?=
 =?us-ascii?Q?CboVa3krcqpGziELWUC3eh2JhM1e6QaXUFUbWvZQXQzAt7oH5ufaRpWsJ91j?=
 =?us-ascii?Q?lawB4uHujITnBRgYyCmUYhRKypK9oxbLdABtiRuRtwx/nr+dLzBGXPpKokyA?=
 =?us-ascii?Q?WrDgmodkramhZLHeuHWHlgLDZLwRuTfW29VUBJulpacIvmqAR3GDG2TexVvT?=
 =?us-ascii?Q?x1at31x2nl9/BA8Df9roJEdyEncyRODJMTGCvcL5dr7sfLnLcD8tbpM39T3c?=
 =?us-ascii?Q?JmeYWGYtdptm9rfxdA2Il9/O2IU1fxkvKV0y924VzPIdw7n4a5GRMjfaOmII?=
 =?us-ascii?Q?2ZFiiZUxSCqEnKzcYmM0oaLC5hL1IgrQYEn2LjlqQ1wnMrH8TSNAkYjZF8dF?=
 =?us-ascii?Q?eRa6ctwiCcICN7RObhP4vcxUjof1pqu5+hXDxjWNEayOSz+meWulun00b+GJ?=
 =?us-ascii?Q?FE33bbPHZMkAjevFiVm+zmvsLqWRSj3vRvsTf/YlSpfv0PJhRr7x9DZT6AKa?=
 =?us-ascii?Q?prXRtWJ0yz7bV1OSs6YGrPJXxWmHzxAmYFJscoKLOa+WnpUmpDr2N3PkmDqJ?=
 =?us-ascii?Q?npm1kzGdSoUKCGHncIeSqA48Rs5R0j9GJKjempbpyjkIF3UAUxQtmS4oDRrV?=
 =?us-ascii?Q?cO0kpeIFotFm4JR5irRGQhys/iLs+kwLAbh/9BS25l/465ZSiaO+Rgv/S2Dt?=
 =?us-ascii?Q?yoSOBYmhiB4jtZmI8HEY5vJYt9DyjWh0ZsrcMBZu0HP5P9/UR4xku2CxyJ8Z?=
 =?us-ascii?Q?o7Ik2JwPZufzRYlYgOA05wNlzNarb3aLstMRFqqjsazwLtz0niTgmkcGwn7E?=
 =?us-ascii?Q?Of7zGPci3n6Mo9rOXzg+XyJeV7kN6/CxEVnAcYCfgU/Pgm9BvN1lgEyLlXwg?=
 =?us-ascii?Q?sFlodnI39pv9K6XrE59iQAaqeZLxg64YpSc+FTCu2RefKN4JUuZe71qVvW91?=
 =?us-ascii?Q?R2IQihGlByL+c4YgTGT1bfgA1tMRhZJiYJGz56KeIoC5xlaw+4IpdrZLdxkO?=
 =?us-ascii?Q?VVQsao+61fZ0at75MfF531O+Oq+FDcs45jfrcYtI54zG4vwrPctkCYJ1gYcj?=
 =?us-ascii?Q?m0+xv7cZeHefq22UITCZcX0PKoCrN0lYzKUI4Zbg0ZLILH6uQXp+tM/jZRyI?=
 =?us-ascii?Q?0UkgOhm6v9m2W100plN+NDR3+9m3O3dIqbL1bkbd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a3a452c-4b50-4f1e-ed4b-08dab66fce42
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:00:54.6651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IZTOvXZigskeR9s6Zkq3EfIxgIN7Bk0a2BOpj4ZSjSC4RCZb+Mnfwh20rxswqDQbsZZj597Rr8dTnL6wgtWBCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4929
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
learning process with the following differences:

1. Learned FDB entries are installed with a new "locked" flag indicating
   that the entry cannot be used to authenticate the device. The flag
   cannot be set by user space, but user space can clear the flag by
   replacing the entry, thereby authenticating the device.

2. FDB entries cannot roam to locked ports to prevent unauthenticated
   devices from disrupting traffic destined to already authenticated
   devices.

Enable this behavior using a new bridge port option called "mab". It can
only be enabled on a bridge port that is both locked and has learning
enabled. A new option is added because there are pure 802.1X deployments
that are not interested in notifications about "locked" FDB entries.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    Changes made by me:
    
     * Reword commit message.
     * Reword comment regarding 'NTF_EXT_LOCKED'.
     * Use extack in br_fdb_add().
     * Forbid MAB when learning is disabled.

 include/linux/if_bridge.h      |  1 +
 include/uapi/linux/if_link.h   |  1 +
 include/uapi/linux/neighbour.h |  8 +++++++-
 net/bridge/br_fdb.c            | 24 ++++++++++++++++++++++++
 net/bridge/br_input.c          | 15 +++++++++++++--
 net/bridge/br_netlink.c        | 13 ++++++++++++-
 net/bridge/br_private.h        |  3 ++-
 net/core/rtnetlink.c           |  5 +++++
 8 files changed, 65 insertions(+), 5 deletions(-)

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
index 68b3e850bcb9..068fced7693c 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -109,9 +109,20 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 		struct net_bridge_fdb_entry *fdb_src =
 			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
 
-		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
-		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
+		if (!fdb_src) {
+			unsigned long flags = 0;
+
+			if (p->flags & BR_PORT_MAB) {
+				__set_bit(BR_FDB_LOCKED, &flags);
+				br_fdb_update(br, p, eth_hdr(skb)->h_source,
+					      vid, flags);
+			}
 			goto drop;
+		} else if (READ_ONCE(fdb_src->dst) != p ||
+			   test_bit(BR_FDB_LOCAL, &fdb_src->flags) ||
+			   test_bit(BR_FDB_LOCKED, &fdb_src->flags)) {
+			goto drop;
+		}
 	}
 
 	nbp_switchdev_frame_mark(p, skb);
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 5aeb3646e74c..bbc82c70b091 100644
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
@@ -943,6 +946,14 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 	br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_SUPPRESS, BR_NEIGH_SUPPRESS);
 	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
 	br_set_port_flag(p, tb, IFLA_BRPORT_LOCKED, BR_PORT_LOCKED);
+	br_set_port_flag(p, tb, IFLA_BRPORT_MAB, BR_PORT_MAB);
+
+	if ((p->flags & BR_PORT_MAB) &&
+	    (!(p->flags & BR_PORT_LOCKED) || !(p->flags & BR_LEARNING))) {
+		NL_SET_ERR_MSG(extack, "MAB can only be enabled on a locked port with learning enabled");
+		p->flags = old_flags;
+		return -EINVAL;
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
index 74864dc46a7e..d6e4d2854edb 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4045,6 +4045,11 @@ int ndo_dflt_fdb_add(struct ndmsg *ndm,
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

