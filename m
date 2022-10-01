Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCDF5F1CDE
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 16:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJAOgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 10:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiJAOgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 10:36:14 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F8E5756E
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 07:36:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RrdoN5a7zdfogCC9dfFwSE3TO80Cc4bAmQxv33SHHOpau263ai52g2kQgQvmmfvNLaIuTolKJur+H5+nhc9ImgEIJPwle23wDhGZvddgcguaGL0Nhtv8VHvTkNyaNSuchmmk+dlp5BXwHsendxIu0IR3yXFqIO1680fHssFF+cj1KEzwqcr9uT919kdm8R2TlJSjJabZXSH/PPCKOpMmjbW/y2PCGoZJS4mbPGdDNSKEskNsxDSOfqMY/9iUwzY6yddWdHYCZAqkKSjsM8BpRE/vWcEJP5sZ2uCI0nV2TVke5Pjcybk+XP65qv1x4Cfhhq2+49v+QH1j5ilARZlUfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=08QzoZch35LwKE9DBOVugZB9sZFCM9aZOPYCjN5KVGg=;
 b=WjAut6wXr5m5SjE/VeHTpcHxXAwRNupxDX3/ecpWkbl0JSFp7/qUltC6DwVqGUkQ7kF/aG41OS6/rgiIgu/7B143oJsumEeBUueBe14kZyDipIPxUqycXK7SkO0aRnrLd/d8X2mB83EkEJdHorL/LnxsAZBRSLczSXEfqk4YSz6BFWgpdnfrgbZtvJ1quOgQC+xJO791akh1gL1iZ8DGAz3HNOQV1E9VeXzONwAKjN5AGNsNdhbF7baZo7xv3cFzG9g/z+jTlVex7eEcn16Q6gz1GqHwwOIw4Brn9fp52xIJlSbhfmQjZ90gCyrnjjWvl4WMmR82+cLjkhBblH/PKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=08QzoZch35LwKE9DBOVugZB9sZFCM9aZOPYCjN5KVGg=;
 b=jaNnMFPwlmPNEd/2NkqcmQSrUZBq8Lk9wP47yRBtWmMmcrj3mrXijvUfe525aZ2rDJTY5H/Zv9tCfP1P7/KlKBICTZgzN3zi/tm0EruH9iVC2vYtOqjhKoisul2ngewAxC90RMihbkBb7sR/LJ62UjHGyJuTSPnkS/5sQ4E3npEXLkhGn6leLljro+7im+C+LpXU+bp4ZrU7MokXEgiVHAFGtoUzk1SRPe/lbXrwh6+Qg6NWLI8ILNZQJPrSWjHz/uN3wssOpsSKZfCBqLWFCJCVdSNwpq95iGA69z3M+unjURlB2LabXIcgzOyfD3rot8Ju4peT214LLpur4mYYNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL1PR12MB5286.namprd12.prod.outlook.com (2603:10b6:208:31d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 14:36:05 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::8f0b:1a79:520a:64c5]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::8f0b:1a79:520a:64c5%7]) with mapi id 15.20.5676.024; Sat, 1 Oct 2022
 14:36:05 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        netdev@kapio-technology.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next] iplink_bridge: Add no_linklocal_learn option support
Date:   Sat,  1 Oct 2022 17:35:51 +0300
Message-Id: <20221001143551.1291987-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0901CA0099.eurprd09.prod.outlook.com
 (2603:10a6:800:7e::25) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL1PR12MB5286:EE_
X-MS-Office365-Filtering-Correlation-Id: a3eed6f5-89f3-4f95-d79e-08daa3ba45b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yf3+V9/IlyQnGua95q0V2Je6Ps0dp7RkDoXZVBYTnNrxvOaKEUX8oAlBJyB5MTcBzyAJj2+i6OEZ0vr9vWCTRjZ9G5DCPHgdRNyCWO1GjWqp7WibTbn1/PPG16ojkt9TMF3Ktm5DciBnarHnEUPrGEBZ37Q+SShTkdgSNR6z8EbMtKCfjVmd9thbFyPQkjhgBngwAbBd/HrIXCjo6MGl2em2ZAEmKCMscgd86MwrucBe3s9zbx2U4X4AqKl/1hL/gn4/17lSV7ZLbdpev9YV+9y0J5TfwIM5sh0low8iGk7xVyNrZLevp0EYqDrwpdGEXmLexiI0Qy+5IVOv5rRyVOCeiM0EbwJ4KAsozeIeOt6E/j+LZZlUNKxzTvFuobMKuXIXhragm1SFx7rinI7q/mKHD+R549CSS5oNUkIvY32mXH1+ep78ecOjR1D9hvNJNa1sI4nx79Z0gnpgC9PsDxzCkowaJwNkrRB9A6B8VIv7zVTBWU3YPb/APX0mwDXdCG77bRE3zedQ+bSypAZc5O5FEXQo8PZmH58anxVkaDLxKkm2iT9xQOSmX00HKIX7ppcSzGq5S7lCjN8gfBFZ9jMbhZHx/9s9ObvlZWKIBb2BXNq7hHi/bIwiSeoO5eUk0FVUYutjlDHt9E9+Z6xCWldHZOCFHTAhl4CMpDFNya3dMxkE7qLsFmJ8MqRYKAjf5uHInfWoBuO3dAXmXQNGcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(451199015)(478600001)(6486002)(83380400001)(6506007)(41300700001)(6512007)(8936002)(107886003)(6666004)(36756003)(66556008)(4326008)(5660300002)(66946007)(66476007)(1076003)(316002)(6916009)(8676002)(186003)(2906002)(2616005)(86362001)(26005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2zlZW9KK8fIdtg5iqe+U3b9Kmuwft38oEuJOvip5GJ8eKmvz0CpVqDrMPvZ6?=
 =?us-ascii?Q?6+fGmjS71gYTKSkuHT8/RSSPbo0Oum9HP+5qIvNs6h3hWBQBOjiZy/SE+QTL?=
 =?us-ascii?Q?pD228p69vo60hlM20KrJXESeZVae81g7ZlxKhK9p8h0pmCmvwGrgIHCblt20?=
 =?us-ascii?Q?lc6IMvKdAu+buWx5tfHlBtiKLHsKxFutMIRH902rckX43lKx3T4kyqpKnc1j?=
 =?us-ascii?Q?HI0/Evx2Qmz5Iz/OeQ62rNyeWc4TkbbVtC8Dyu2Twb0QyBD1Sii3ZqlFaL7q?=
 =?us-ascii?Q?Z86WpmP0OTm29WXCZK9SnN9f+uJo4J37EJj+enp2nyNJRxPtLAXnxICd9JKk?=
 =?us-ascii?Q?ikC82jrQJNAt4ADu02xUBWYbzBnw8ruzzp7wpMwPFEMTD+CwD8l71i41nOKt?=
 =?us-ascii?Q?RiDgA3NPEy1SQBrEsX2xmPnn67ArAv5Yhfh+27puBpqW/wA/+tKF/fSnFq82?=
 =?us-ascii?Q?fpQnZ8aDJuk62wjOq+Zcffo/AlHIHBJfdx6PfdeNByvwnqXTWt7HtIdINMzs?=
 =?us-ascii?Q?TAejTs0zcYivBJJpmPpquV9XN7W1/EVvbaQ3NimwpqGISLcKKdf98rrmV0fN?=
 =?us-ascii?Q?w11Oi6SV2JwsUk8W5DAnweM33b68Z2EBDD6eLodFXkx8fIDiOvnsOUChGioZ?=
 =?us-ascii?Q?Lhw8tp/1EHEzLJFm8uixN8sG8r2whyHWAMGy+oOBa2ImcD6IaZP0TfRzRZ6j?=
 =?us-ascii?Q?+de6DAyizxVddTjZGslCTpQo65+jRqR36481UYzSmR2RT3SL/GGPrkQqxHnH?=
 =?us-ascii?Q?EtX38ERBm+51IDN6mgI9chU1UakXBTB4buqN33LRcsWWCtyVniQCF8UF6/pU?=
 =?us-ascii?Q?9N1b3c+MZiyXEgXRG+y24RBPhJaUdMliRN26gMoVl2o9bfpOOD0RKc2+oAes?=
 =?us-ascii?Q?HxpKyN5YM/T4GG7HZAvS013gXwlGfcA7KCvNpWudiKCF3vU/floYNdiDwGwb?=
 =?us-ascii?Q?qoga0RwaEeTLGtQ79NqMTLXv7AQrjMmpI6saOyGRkCYQQVoGoi3PxjvutETX?=
 =?us-ascii?Q?Y0AmZFM9HCHQg2sV2qCIojOZaXdUe8jiE8hHcCXcppGtcgL6MP+etjGWejpm?=
 =?us-ascii?Q?0WtPOg1X5VXQXsNSL+tmLkDh1OvobGsLuCpPOQfBCr34wIkxB6amv8j8ptbF?=
 =?us-ascii?Q?Zff2EVPhWn9cf0T14Krr1XtGLWSz2djOARbXT3Eb+tOmFYX6oH10vri2hdFo?=
 =?us-ascii?Q?KBqRQ7lVDPNX/khmQeM6O961YNEhDQAR/PCEzBMO9YEvyhpFy4yRcuZkNJN7?=
 =?us-ascii?Q?7+Qj72U3AyuSyCQ9kDiV8JWE00OwN0QYgYXk+Xpwdwlcn/K7RgjwNDl/BKJf?=
 =?us-ascii?Q?bdjLgKkdzJOEUOiu3uRPtTyqrdoTJ7qS75jpfuQOikqxP/jVPVeTibQe12PG?=
 =?us-ascii?Q?+mahs+Rorn7dIiQOnKX4h2ROPcDSEdYT7TAMbHqK763gLDqzKoubdECqu/X+?=
 =?us-ascii?Q?5n/OF+RXJNCLf3ftTeF+MvDS5YtNyGXR7G6MjZKbU7h/jwezHAKagKZSDJvK?=
 =?us-ascii?Q?9IiVN/IHqCpwAWVhLlGMS/PMa7/5JyEjvA+leOgnVEHxDBxQLCej6GJe39/g?=
 =?us-ascii?Q?3myIO2Vy35EWBH6qBF1rwI6oP+T0l1hhXSp6Thcw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3eed6f5-89f3-4f95-d79e-08daa3ba45b0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 14:36:05.6544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F3CTx/c/FDEdNjGwuDOvWCcsH3kKxkFkmQk2J4l3+Mbkn8dO5KRca4bBqHbJLaN0unfp4AGeH3JE/ovY9kN1+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5286
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel commit 70e4272b4c81 ("net: bridge: add no_linklocal_learn bool
option") added the no_linklocal_learn bridge option that can be set via
sysfs or netlink.

Add iproute2 support, allowing it to query and set the option via
netlink.

The option is useful, for example, in scenarios where we want the bridge
to be able to refresh dynamic FDB entries that were added by user space
and are pointing to locked bridge ports, but do not want the bridge to
populate its FDB from EAPOL frames used for authentication.

Example:

 $ ip -j -d link show dev br0 | jq ".[][\"linkinfo\"][\"info_data\"][\"no_linklocal_learn\"]"
 0
 $ cat /sys/class/net/br0/bridge/no_linklocal_learn
 0

 # ip link set dev br0 type bridge no_linklocal_learn 1

 $ ip -j -d link show dev br0 | jq ".[][\"linkinfo\"][\"info_data\"][\"no_linklocal_learn\"]"
 1
 $ cat /sys/class/net/br0/bridge/no_linklocal_learn
 1

 # ip link set dev br0 type bridge no_linklocal_learn 0

 $ ip -j -d link show dev br0 | jq ".[][\"linkinfo\"][\"info_data\"][\"no_linklocal_learn\"]"
 0
 $ cat /sys/class/net/br0/bridge/no_linklocal_learn
 0

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/iplink_bridge.c    | 19 +++++++++++++++++++
 man/man8/ip-link.8.in | 10 ++++++++++
 2 files changed, 29 insertions(+)

diff --git a/ip/iplink_bridge.c b/ip/iplink_bridge.c
index 0f950d3772f9..750d55fcfb4f 100644
--- a/ip/iplink_bridge.c
+++ b/ip/iplink_bridge.c
@@ -37,6 +37,7 @@ static void print_explain(FILE *f)
 		"		  [ priority PRIORITY ]\n"
 		"		  [ group_fwd_mask MASK ]\n"
 		"		  [ group_address ADDRESS ]\n"
+		"		  [ no_linklocal_learn NO_LINKLOCAL_LEARN ]\n"
 		"		  [ vlan_filtering VLAN_FILTERING ]\n"
 		"		  [ vlan_protocol VLAN_PROTOCOL ]\n"
 		"		  [ vlan_default_pvid VLAN_DEFAULT_PVID ]\n"
@@ -159,6 +160,18 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
 			if (len < 0)
 				return -1;
 			addattr_l(n, 1024, IFLA_BR_GROUP_ADDR, llabuf, len);
+		} else if (matches(*argv, "no_linklocal_learn") == 0) {
+			__u32 no_ll_learn_bit = 1 << BR_BOOLOPT_NO_LL_LEARN;
+			__u8 no_ll_learn;
+
+			NEXT_ARG();
+			if (get_u8(&no_ll_learn, *argv, 0))
+				invarg("invalid no_linklocal_learn", *argv);
+			bm.optmask |= 1 << BR_BOOLOPT_NO_LL_LEARN;
+			if (no_ll_learn)
+				bm.optval |= no_ll_learn_bit;
+			else
+				bm.optval &= ~no_ll_learn_bit;
 		} else if (matches(*argv, "fdb_flush") == 0) {
 			addattr(n, 1024, IFLA_BR_FDB_FLUSH);
 		} else if (matches(*argv, "vlan_default_pvid") == 0) {
@@ -578,9 +591,15 @@ static void bridge_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 	if (tb[IFLA_BR_MULTI_BOOLOPT]) {
 		__u32 mcvl_bit = 1 << BR_BOOLOPT_MCAST_VLAN_SNOOPING;
+		__u32 no_ll_learn_bit = 1 << BR_BOOLOPT_NO_LL_LEARN;
 		struct br_boolopt_multi *bm;
 
 		bm = RTA_DATA(tb[IFLA_BR_MULTI_BOOLOPT]);
+		if (bm->optmask & no_ll_learn_bit)
+			print_uint(PRINT_ANY,
+				   "no_linklocal_learn",
+				   "no_linklocal_learn %u ",
+				    !!(bm->optval & no_ll_learn_bit));
 		if (bm->optmask & mcvl_bit)
 			print_uint(PRINT_ANY,
 				   "mcast_vlan_snooping",
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index fc9d62fc5767..da62dbd237e7 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1572,6 +1572,8 @@ the following additional arguments are supported:
 ] [
 .BI priority " PRIORITY "
 ] [
+.BI no_linklocal_learn " NO_LINKLOCAL_LEARN "
+] [
 .BI vlan_filtering " VLAN_FILTERING "
 ] [
 .BI vlan_protocol " VLAN_PROTOCOL "
@@ -1675,6 +1677,14 @@ bridge election.
 .I PRIORITY
 is a 16bit unsigned integer.
 
+.BI no_linklocal_learn " NO_LINKLOCAL_LEARN "
+- turn link-local learning on
+.RI ( NO_LINKLOCAL_LEARN " == 0) "
+or off
+.RI ( NO_LINKLOCAL_LEARN " > 0). "
+When disabled, the bridge will not learn from link-local frames (default:
+enabled).
+
 .BI vlan_filtering " VLAN_FILTERING "
 - turn VLAN filtering on
 .RI ( VLAN_FILTERING " > 0) "
-- 
2.37.1

