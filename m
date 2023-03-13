Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F266B7B41
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbjCMO5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbjCMO4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:56:45 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2064.outbound.protection.outlook.com [40.107.96.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B397585B
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 07:56:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqeZO3sxRlLFSYKWiuSfvoLookL0+DyEotFmmVCEpiDnjOnk69TCbUCO1VWr7gOi76hrnAn68tkvKjduBu3pUTZjAKNg3OaNfuCMWwAAuBohuYMI7i2wGmsYLcc/maqWFy2cZxCsM5twRij7gux9y7nbv5igQy+hMs2EK05ZYEx+eCYN/6s2LeLTpA31dAZ9mAcfnQigbbaQA8oOkU1u0M23bms+U3OkAqIKtoNzQp1A66c8Y2uJy2PmsdA00ss+PSvNkE5CzVB40X423iJrMd6CKG1oDYckmaCK++QlphFdCcy4jE8LLbV68MSOyb9CqpcUpYrL0IfZgY1iHK5eJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HH/HNX/O64uh6//8dN+ZMSiPTY1JIq0z4NEtphMDd/4=;
 b=fFNIGv7FvbxczA8QKXwizFwNKEc9aN4k6kpN6Yn9qXcl6IidHHMU6ARj3phzXzyQoWM1aegfqIVQWx8EDS7nKwIQJlQyV7zblzty8xAc5qyFyPDhyQbaK7uvkEtC70tq6vFqYtt+T4wWmq7EcR5qTeabYC9TMCafERTS5GX6fmpfeDBqxDT4bqIvbzAalNfY0x3MT50sl7g171O0it1jaxILLiBvgNQ28JKDcD/AXoIplEyynhRJeDnK5lwAeC7xpPptjh2dx/Lhe5AgDz0fy8EVJ/FcmQxE2Z3/QTiItZqOFg6/vd/bOGTKwqrpw/yxrmq1TcvkSCFScbMGFPAdYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HH/HNX/O64uh6//8dN+ZMSiPTY1JIq0z4NEtphMDd/4=;
 b=uil2jMhQGHbMi1jOW7jqSQRgCv2mWWCKMnsIKfEQL7KPfG9oK6ZY0u+25W/yo0wVOUYdVzopjoxx1ybN//ccmeD4EfTx8ZRU9b+owN7VZZs7t6Bs/CKEGaBe/mG87eIjyxTJAiUC6KhcrVFCyo956ZCXAuE3pI9oO4M9k8rK5/RQsVcD8iWYfhtwkBgSF9sjFz5NlhIIilcAq9vUewQhAXkfMwdkTKnTWHdkM4Qjaf5EzNwkF77CQ8Li72Q/tX2VfqY7ip3CVqv9KksR+sPL8p3AMTffOgVAnGCjWXa19sl74EQ/2/XnL/7HdiNQfGYMPK+b8qyNqbSvjL8kCXUwUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB4550.namprd12.prod.outlook.com (2603:10b6:208:24e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:55:34 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%6]) with mapi id 15.20.6178.022; Mon, 13 Mar 2023
 14:55:34 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/11] rtnetlink: bridge: mcast: Relax group address validation in common code
Date:   Mon, 13 Mar 2023 16:53:42 +0200
Message-Id: <20230313145349.3557231-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230313145349.3557231-1-idosch@nvidia.com>
References: <20230313145349.3557231-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0601CA0008.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN2PR12MB4550:EE_
X-MS-Office365-Filtering-Correlation-Id: adfc8a70-a844-4a46-9be0-08db23d2ff86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xz4HCU5un9I6ztlAQy9V9w9IoKS3H8B0zu2HWJoCbplypfCy0Q2jbQUscwEkre8FQBInMCxlN489z5aGenOViW+98Cw6tgW/uEROYSX13cuuqujb2ReYyct/n6cPLrSyY1TbrwR0vGMXIJTEgaXTEHaZHQVWoic/4JX3kEmtcbOLdk1YVG1QsFsBT1iyjNvWZpSq20IESFZ2eHB7auXhOAjX7yYZ/Nb3kaVU8s04bxWLQ7uG1Jp63yeAL8sTvgMvI9Z50D4k0BbAgvafQP5gyG1FMm5LnJF0k4NFyzDI3zxNF9Kc5phFvYV8kK0n74/w73n4FpaYE9tnejf4750GQRKfdnfpKO5Mm4TxSsVjFDbPnfLCOAWwR0KPnz3Ug5qh4/JKp4D4p87mat+YAPEYIvnD+vtphVM4k29k95SntBaXw9QqQ+MIoK37XXyPwmQmhA2iPC1fLrI396sjs0aGWYC+KdWuvuPqCrA7l71VpT4IbqK8ryT1aQr/w2t/4IiDOSs+6mhyoVTXsFz7zmTIi8bxB50Ee5e+DJMVRdSIS1fzmc5O0P4hXwWYyWO6y07t7HvBzRfr8h9RZtmejZ0PpdrVOrZU2Q0yWi9Yy5aYy2Z8VR07SQc6Dws9R/mUbIpqdbQLgU6POgxDzMNIdw7DOncAlNGw7FSmM9KiNyB83zTCzMNGfHXk6UT1Z+Xydhut
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(451199018)(38100700002)(2906002)(66946007)(41300700001)(66476007)(66556008)(8676002)(4326008)(316002)(478600001)(86362001)(36756003)(966005)(6486002)(5660300002)(1076003)(6512007)(6506007)(26005)(2616005)(186003)(107886003)(6666004)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EUK5nOpwo9qC8ClxU8iVks/Q87UDI1L7Ff5FFKIpehECGpjVNVQ696FYKzS6?=
 =?us-ascii?Q?HjoP7n/uCJJqRNgSZxa9yaSmpJHM/uOelDaB3u7xOPOVHnzbIrMwQLI4Jkn1?=
 =?us-ascii?Q?Z96oKxxSVIIqbuT5m8iJvl3CJow+0sVKh7JD6yiz4zup3VvW4hVWEu2CjYRr?=
 =?us-ascii?Q?QmBAcVZ9dHCudaO7EkwINLzYycxWIv37y+/KLjPayyJuYR9/Iz9LclbKRZ61?=
 =?us-ascii?Q?NLQUqIEHjW7BaF6aDsnydVBKKV6TMF2+h/uxcih650toA9wzHkOgmMh0oEP/?=
 =?us-ascii?Q?cx65ByCxAOfnAvTKtfDSf3bvhyguwO74v3r33oqpIdNfB7ZNouUJM3a5A0J/?=
 =?us-ascii?Q?rVqlWqhPavKYlEjlY2hKPKdKMbb4E3Ss8arG1ZLUiXpPe7VCPsLWN7GgZWRp?=
 =?us-ascii?Q?8zm3QUycqThZ0yJr18guoxI04FBBJGOFUpNZANKYhlT5SZl0BikGTbvrr0Q+?=
 =?us-ascii?Q?ToqNvtVvKT6mBgVGnDZvbLpE58b6i1vYYGZs2Bdb1PEmChUlhPSvTOFp2u4V?=
 =?us-ascii?Q?BUIbvre+el/QyI4Hih+0XVvNGx3rcsH/x+hsMw5a8YcIiT/YDkZ9EpZEHc9A?=
 =?us-ascii?Q?PErHcosDbhifRzclo9pYjTKYg/adAe7nyJ26MHVJkhqh2IkFuLg33oZkjlL7?=
 =?us-ascii?Q?x7/DwdxbCjTQToy8Y+4kYTIBYJ21zGRAxnC2aAUGr2Eq9zzUb9VFmiWM/0QA?=
 =?us-ascii?Q?OqdOPjcWecR5wGyPgfLrtzk4SQ0FjNvBH5OwEv1dvcwZe5XC4tXtO60el2zI?=
 =?us-ascii?Q?fmHmi9FeNuuyrQ30ncHyLCo+HBcYpyW0VjTtxxTTxC8kchl3EksziOLO2HFm?=
 =?us-ascii?Q?IULAtchtX4SEtmfu57wijOmXpF/jtLxNuYHMdj7cGnKWcbOgUbHNvCW5qfBZ?=
 =?us-ascii?Q?yX5T8LlPOpj54ip35htz0xNAHmCgmZvtx+LMulxvRLGItWb6MtjZKuJEKCUg?=
 =?us-ascii?Q?Z1rUSZRBcaR7fr27UFnfT8Qx3PF9eRXNqsQhKyrnnq9aDW3RqOp9OI2H5Odr?=
 =?us-ascii?Q?ixm8vjrzjySjr9prJxaSWyOoLv77Y9QcKnLN+H6n3IjkJINFyDnn9i5a+iWk?=
 =?us-ascii?Q?t2///PDkM3frU4b1Kr6lvkBS4HpjSfpnECI6vgeAfp4V6THcZldWFYUmOjGn?=
 =?us-ascii?Q?zmDLCkaYB7EOL+/hoyHlQjn39UksUsFY9sYfvGBlaBLI/Xsii35/w48j7dwW?=
 =?us-ascii?Q?LOyWMXJi66iPLnLZTru6A+qNbio7YjahOa9pdk1RwqX6Br1uH+i/G7wGZRyT?=
 =?us-ascii?Q?thavxBY5clXX+lsZXKBkPiH/JppmxLYqby7/3cbi/rvOW8RFX+Oc6zwkde2A?=
 =?us-ascii?Q?DdNzlsPagiVrTLUr6ChUJtf+xIl9DQtc9PGlGEUjYSCjQy1GH0Tg8wBC1Znn?=
 =?us-ascii?Q?dPloGbxPm7BjXD5sjudQNhPT2D93uS7v5zOGhBqfCKje+Cxrbq+DFynGLo35?=
 =?us-ascii?Q?lMBiGIxNE6mHbXUPxrM5nZAdU3NOJTbipr0o2A1uTHmG1HuUI7DnBZmv8TZl?=
 =?us-ascii?Q?IpZelnLoTnzMQ5U72opwK+7UqOKZqovsbOOQp2rZc/AqMN0V0SZZ4kQI61b9?=
 =?us-ascii?Q?5lRpHbi/YPnv1xrhNZyPVwTgRB8plF/X/+917fb5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adfc8a70-a844-4a46-9be0-08db23d2ff86
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 14:55:34.2672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BwuN6+EWFyWh52BbK6H9HH5VAKa2KMUgrrHfjo9e5QMBSSjErZTgz9EylWoodEcxlxyPvB0G2sey7mmJQhqwOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4550
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the upcoming VXLAN MDB implementation, the 0.0.0.0 and :: MDB entries
will act as catchall entries for unregistered IP multicast traffic in a
similar fashion to the 00:00:00:00:00:00 VXLAN FDB entry that is used to
transmit BUM traffic.

In deployments where inter-subnet multicast forwarding is used, not all
the VTEPs in a tenant domain are members in all the broadcast domains.
It is therefore advantageous to transmit BULL (broadcast, unknown
unicast and link-local multicast) and unregistered IP multicast traffic
on different tunnels. If the same tunnel was used, a VTEP only
interested in IP multicast traffic would also pull all the BULL traffic
and drop it as it is not a member in the originating broadcast domain
[1].

Prepare for this change by allowing the 0.0.0.0 group address in the
common rtnetlink MDB code and forbid it in the bridge driver. A similar
change is not needed for IPv6 because the common code only validates
that the group address is not the all-nodes address.

[1] https://datatracker.ietf.org/doc/html/draft-ietf-bess-evpn-irb-mcast#section-2.6

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c  | 6 ++++++
 net/core/rtnetlink.c | 5 +++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 76636c61db21..7305f5f8215c 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -1246,6 +1246,12 @@ static int br_mdb_config_init(struct br_mdb_config *cfg, struct net_device *dev,
 		}
 	}
 
+	if (cfg->entry->addr.proto == htons(ETH_P_IP) &&
+	    ipv4_is_zeronet(cfg->entry->addr.u.ip4)) {
+		NL_SET_ERR_MSG_MOD(extack, "IPv4 entry group address 0.0.0.0 is not allowed");
+		return -EINVAL;
+	}
+
 	if (tb[MDBA_SET_ENTRY_ATTRS])
 		return br_mdb_config_attrs_init(tb[MDBA_SET_ENTRY_ATTRS], cfg,
 						extack);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f347d9fa78c7..b7b1661d0d56 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -6152,8 +6152,9 @@ static int rtnl_validate_mdb_entry(const struct nlattr *attr,
 	}
 
 	if (entry->addr.proto == htons(ETH_P_IP)) {
-		if (!ipv4_is_multicast(entry->addr.u.ip4)) {
-			NL_SET_ERR_MSG(extack, "IPv4 entry group address is not multicast");
+		if (!ipv4_is_multicast(entry->addr.u.ip4) &&
+		    !ipv4_is_zeronet(entry->addr.u.ip4)) {
+			NL_SET_ERR_MSG(extack, "IPv4 entry group address is not multicast or 0.0.0.0");
 			return -EINVAL;
 		}
 		if (ipv4_is_local_multicast(entry->addr.u.ip4)) {
-- 
2.37.3

