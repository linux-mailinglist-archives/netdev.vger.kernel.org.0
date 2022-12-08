Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449C06472F2
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiLHP3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiLHP3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:29:32 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2046.outbound.protection.outlook.com [40.107.101.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0CD71256
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:29:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FdwvGCNOMw3bpwHv6DQ8DjD/mv/zMATnKUpZZgo52hb027olJ8eEPFVEbBThNGnJMzW2t/pJeQ2yjkouF3zmW+CH2HNjZaEcyyg2uv02Vn2PNmrxrBcsXg9nAC7M9MldUVVt22sugHoAndYrG52YM+kb1gN2cpR+fNf3978C9e9ClXo7dXg8zKwX9po+Y7pMp5mupH8nSTQR0KxKEGagS31Lt8i9ON7uXpFboFdGBEN4NozzuwDsiUg2idJgmCRqc62pHWjikh96CGcgOLCXUqdByykF+X9hQNRdpxLQi9d7TkjTScBTf3y/CUPVtvjeScCUhn26TnJMyGCkALEUyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LXjyfGzARL5VUfAnf+q3Hfg+kM6Y8m4Y6sTv0rjK888=;
 b=cDCiEjgdCE2XV7Cq3sefTTU3A174E/ZYYz/D7r/stJ8bv3m3wTYcLfu0hpxrS9qtqJeSibFhc4bdN9xmQfARN8FQR2JZGbdYid5HRGpUW4la5802hCKjZiGJCF1y+N+8/XK/EKNOSnRFWOHRibubWCt90TKeD8o+Ts8sDC+UTBAwt8QGtBnT78bdYctS04eciPfxJRceAcQqkDxauo8VHOYmNZAYPBNT5V4Hh8X//+tmwuOgzE9URkDbWEkkVNJ0Lj78GBdD4dPDfKYTb/0hQwz0ansepFDVkO86ud9eKX4vuKdXVpNR+EnZxzglfFPP3NIcV0DtqwVUGlzH/huyIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXjyfGzARL5VUfAnf+q3Hfg+kM6Y8m4Y6sTv0rjK888=;
 b=VBVGzCy7BIA7jOUps4YQ4XS65nr+0BX8NE5A44SUgtF0UWm2Ru7oguDEt9UArZ8MCnos7s86eLXH+kPvYH9E1CcCTPaIFtMwNTaIF4KEiQmpNb7QlBfJ+yzwUM6/LpXUu7iUh8dHnnucAPn84LMUzhi8loT2jNSwoqwQ4CJp+ZEwVzKqm1twVPmKEKYYm6LHZRijR0z8z8KTutLgM8ESqI/hqiJNcbdHl21kZDsNA0IKXAQ4yoHA/xRivWkYSzPIbyBlNWefUj9C3JUNqOxfGHKA1f/zJIM0Xkhxr+JYHNOi2SGsf7K6ZoH//tN8S6j0Txt6fSl2u3tCnZCWkr4TMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA0PR12MB8207.namprd12.prod.outlook.com (2603:10b6:208:401::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Thu, 8 Dec
 2022 15:29:30 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 15:29:30 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/14] bridge: mcast: Expose br_multicast_new_group_src()
Date:   Thu,  8 Dec 2022 17:28:30 +0200
Message-Id: <20221208152839.1016350-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221208152839.1016350-1-idosch@nvidia.com>
References: <20221208152839.1016350-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0181.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::11) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA0PR12MB8207:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bf8f0e1-b179-4f11-f69d-08dad930ffef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KmnwTEpBiCkbkvJ8JRgua4ngbv4S8YnskuAYefrMxo4c4ocVQ0R1fl4RSzuD7bqDZj3RRifRCtt7rPkpZefu588Nd2ErQmG04eHlVRtVNloTClnnn4WqCdyjA3iaZI0pbyZ0UjCKP2UqV9OaCurerduCXYG5u4cgt8XW+8HLsZ5dP6Y75A5bMiIcufjstxsiOplXHo2hCDdZbJuJM5GGEELlMidR4T9ziaEUk26AA4Umxha8qRqvGfv60tEMyuhHNN6wJwdHBbRXQbSFINwqRBH+3OF9XoXXe7jGVF8N65FL2BVapLOXG7U7SjoLFusgomcLI1Cdjikhqd02xgg7FrZKEtSU06LYFIuVQJ14FmltbBVb5fVVMHObr6WZjqNVp37SwkDD8IB72vk9vCvIQgViUEUoap3yu2y6yE8yGIKh3MF+S1aHpbBYWsJs1EpbuE04UHcONbzh6mNBivynLP0jsBnX9uTEXuqFwHxuyCEf0Lch1EF9ip0tABZ+/RK8Oy15gz1C4v1aN2YQ3GQogrf0fZxmGAjCppD4oM21N9TdwdT1Kcl52BtXVHQzYsQTh1aIn8iaI5UF/y6+7RWwwMVURVZFjPamHYGQkF71NVo1sLEqk5ce/et/7XSzxKCb66n87AK61hJp9vLj4M1F9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(451199015)(2906002)(83380400001)(41300700001)(36756003)(1076003)(186003)(86362001)(5660300002)(38100700002)(8936002)(316002)(6486002)(6512007)(478600001)(26005)(66476007)(2616005)(6506007)(107886003)(4326008)(66946007)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AyGP0XyWyM4G6nq936jDMGYXQUnEWZPZBW0DRXcbB55TNBiO6ZG9kMDDE5mj?=
 =?us-ascii?Q?eYPJ+g210mbz3EBLmwk8vAJnSdLjLoner2nyxxsFwQv3sp6P2zfwzBZGOb0g?=
 =?us-ascii?Q?tCIWPn7/AMG48xgHIgYxMAf9C6CLWQaEjwcE5Nw6B5vvZYUxCjYhW8392z69?=
 =?us-ascii?Q?7MqW0NQswZsiaMA9RCtYRbaNlzdlJ6kpKFbN70IG7OIUr/Jhl7k1t354JkNS?=
 =?us-ascii?Q?wYi6DUGigG9utoAYFb/38RlHyZuSEyAdCMOddND8XgI6Rs9T2CGeoC8NDdNW?=
 =?us-ascii?Q?mtiamPQv3V8Sl3k5BW58qTmZuHxfOwg5UHMcJ/4qn4l11RA6PFX1rWgM/SyG?=
 =?us-ascii?Q?46GOr+P+yuQ5JUXYlBUKwo/tSCh+Pccg9e7NbUWi6ke17RFppzsuC98lpfuW?=
 =?us-ascii?Q?IrDVznfcX38jQgWP/sr2Ma32u/UuyZ+bRS3tWvEjL62We5pVmtxPWaCL+5Yz?=
 =?us-ascii?Q?BPc6OkIL2KLLBWNeQE4Pave/JSwaRUhO/dV+WkbQAW17es5+Rvcbsi3627H0?=
 =?us-ascii?Q?g+b6l4p3989H6ikSmCTSKDCs812guD1S03J4MURxhwL9U6PICx+dMrjWC/Ta?=
 =?us-ascii?Q?fvZ6EJN8dqU1LbecMhiTXEbFbuTTboSHL3jqPs/KP0m4d61/JMxQCeg+H4ik?=
 =?us-ascii?Q?XztSoDBunLWy7HQ4JV2hvBIRoDuCWWukWQsTjymkJn/yI7vcsihoUwcwUoZf?=
 =?us-ascii?Q?/Pz0Y4QUJdh3PA3APVOdt0IR/zDQDzcNItaAzwamu76FaDYw3LkoxR4zYZer?=
 =?us-ascii?Q?YAycgbtdm0Hr3mXCfchcwzLeLNIQe+BP5USKZ4TEm+59ODC3ZZZYLXQPP1mq?=
 =?us-ascii?Q?IlOb4o9jB1AuuMy/C6uzc1W5NRLqNn3u7D7FZkjcPE5xnj3HkDZ3M442YW6r?=
 =?us-ascii?Q?UhZfOT0Jh/i1hsDBntWmFSdFa15nZNU2odb3eJiDjxNycmn1V0N2thtiDKVT?=
 =?us-ascii?Q?sDJITYAGMZxlQR1UMirA6OPcmd0IcpjK8BoUMGj0XX/wUh3yvyiWMI69k/IX?=
 =?us-ascii?Q?9aGWcJMKNN4IrYMT1dC+WPrL1nq1UCZmGJB13mw4/Hwv9Wp+RI280m2q5Sq/?=
 =?us-ascii?Q?Vjdx73ZCgQZCAc+Y8jVQS7M4fiFMvpw/ExwZFX9PRqUH6MNnxd815fSOnhHZ?=
 =?us-ascii?Q?OQC5oIMmgAXx7HY6bDbr8QkR43PylcjV0kYmETVbH+hKUOqCxaNNrlCUtqhL?=
 =?us-ascii?Q?oH8RgnqpnIiDdq1f8/eBiqqv4JLOgbqQJmA/60pKtBAFkHYLElWMYT1RBeay?=
 =?us-ascii?Q?OcqqfcriB1Yva25nb31UwlfbpTP4GCtPpcwwgxv1EFJ+wIZ4Njw3D+vwFD1G?=
 =?us-ascii?Q?ns4T7Xnnl+Ffe7IlLXH7BdYuKKzP6vZOAMW6bieWkRJoDd81sT8gbaMTXkaZ?=
 =?us-ascii?Q?OeZnuftnEQjFB6T2zgxT7rigelmdRBpeqUuHE1n5MswhoDiKoUnco9whHDks?=
 =?us-ascii?Q?Vs6ef9oHwMBZ2dCaMltHpYntDuOhVab7jX9m88kx7R72OvRpIiSPjtnJAEZ5?=
 =?us-ascii?Q?8FHgrPvvrxm7dzWzASNExhZFytbzY+L4znGTIDI5xqkp18hh9FpQAq42uVAj?=
 =?us-ascii?Q?725w/aOcNxSPzIbj6lp+q28ZLkZRSsM9qiQ0KvRJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bf8f0e1-b179-4f11-f69d-08dad930ffef
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 15:29:30.3638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sX35jGhO0TKJDqlVlPFa36/tAWbsQk3UohSPrBOeCEqCCs0rkHXP1ZNxJZAsLDt1Qp2ezf1+VYGxNtoHzpNvDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8207
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, new group source entries are only created in response to
received Membership Reports. Subsequent patches are going to allow user
space to install (*, G) entries with a source list.

As a preparatory step, expose br_multicast_new_group_src() so that it
could later be invoked from the MDB code (i.e., br_mdb.c) that handles
RTM_NEWMDB messages.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_multicast.c | 2 +-
 net/bridge/br_private.h   | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index db4c3900ae95..b2bc23fdcee5 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1232,7 +1232,7 @@ br_multicast_find_group_src(struct net_bridge_port_group *pg, struct br_ip *ip)
 	return NULL;
 }
 
-static struct net_bridge_group_src *
+struct net_bridge_group_src *
 br_multicast_new_group_src(struct net_bridge_port_group *pg, struct br_ip *src_ip)
 {
 	struct net_bridge_group_src *grp_src;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 3997e16c15fc..183de6c57d72 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -974,6 +974,9 @@ void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
 				       struct net_bridge_port_group *sg);
 struct net_bridge_group_src *
 br_multicast_find_group_src(struct net_bridge_port_group *pg, struct br_ip *ip);
+struct net_bridge_group_src *
+br_multicast_new_group_src(struct net_bridge_port_group *pg,
+			   struct br_ip *src_ip);
 void br_multicast_del_group_src(struct net_bridge_group_src *src,
 				bool fastleave);
 void br_multicast_ctx_init(struct net_bridge *br,
-- 
2.37.3

