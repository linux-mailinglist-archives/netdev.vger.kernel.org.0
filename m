Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CA7579EE7
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238836AbiGSNHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243079AbiGSNHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:07:11 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C78CB9A33;
        Tue, 19 Jul 2022 05:27:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOgi3eobJ7KTKR6vws8f9cb7aOusTBkZLEjgKpLa/ZVWRlxwqb6kQwwPrWi9kAbFknvJRq6I2sZDDkaRc1HMb0XXZBHPQ3LZBujnVhAxEuvCV+e0anMU4eMFDVtZFgiQkhm0tY2t5gDx3GmMlLPbCRo+mlYIN0GQl/SrJQASqoLPmkf78c7wqlA9axWALLlW1oHq3CsqjTmD6kICYUuVV3O/CMC5fFJLlYeDg78mEgtS5ZMYEmohGP0AB15ZgY9cf5+l5FPrJr5Oj/U2D6VEQChHPyAbhDS4qJ40leMv+y++zwkznIjD1P0evixKoofJNSfJdbqUCzZYGhrkqcN/vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bccH/MgNfYcLdd4nb1fYRS/2bFGRRF6+BuJPfySHlUs=;
 b=SVyKGQOyYJhMQRMOIwMGJ2rVDzWffNkVNiHu6WRm08me1mwMW31Ya2tT0NM5s2+HvBbYQyBV1o1i4SOYk4/He8cWuGAvZkc5/+PhBZPRlJO90jXX5aBlIHnWEfncYwTEws2OcN8cqHpFdXjboauZ7kcolCrNyhp/XzOuaMtkDaEOOqTUwVp+tDKDPLqc8S2cFI3AmQLg5zRTyFSs8qkAQsd9ZIKsVDeid8x154Un9WrsY0pQ1Pe3AJt3zIVWPQbTURhjXtSS7nmGVraOcA4imSVLgL3ohs9T9eXot5scN8SD/U/yoZbBfTvZYYulCq857h2fdQ2AGJc/2ctvlSKJGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bccH/MgNfYcLdd4nb1fYRS/2bFGRRF6+BuJPfySHlUs=;
 b=QcSTxHHUpVNETUhAX7ymoaAEW9A7oMna80yMxa7JCi32CNDuhnlhAJ1mED2dWFd5iESgL+y1U2I4FFWhlSJMQRRbemIwKYm7ZeEK2neL4k2M4Kdahq4Aae5GNlOyxN7/KCssSJLjRzkwlMe7wmhtCCKNNOXeDZbvKPjpAcJ7joSGvdN/QVHvTmU5Z3C5cEaJusVtnIaPfh5RHz4MCA5l3gR5xPFg+g6UNyQiIhUiZFDrE9AFRxmkg8ePY1YaJDySzIn1RRBkdGbVO2hNIZB5caYsvjaga3SpLViiWsoaAUAS4Bv9RwuxkZY64styUxkpJrk8dH33j3MdRF70tBRkbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB4911.namprd12.prod.outlook.com (2603:10b6:5:20e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Tue, 19 Jul
 2022 12:26:53 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Tue, 19 Jul 2022
 12:26:53 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        nicolas.dichtel@6wind.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>, stable@vger.kernel.org
Subject: [PATCH net] mlxsw: spectrum_router: Fix IPv4 nexthop gateway indication
Date:   Tue, 19 Jul 2022 15:26:26 +0300
Message-Id: <20220719122626.2276880-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0100.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4925460f-0018-41e2-9e3a-08da6981f6a0
X-MS-TrafficTypeDiagnostic: DM6PR12MB4911:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 84XYg0WuvkJ7GdWkFYbBo05Uqc8ZP94ah6UNIXx1YKeGxnGBtkBjsbcRXve9+1xlGDHVVRCHJ2kpal+5OCr6cn1/N+b2ribngxLvZ535E1vTF6qBv2kEfhWmEdQNEY1iC/+rf7I3vKii92QtwsUA3M7Qrn/7AIlSdu4jC1JmBXMYfuIC+v5bBVgNNj7QScTsmjcXuZVleWflsgbxuT9ICY5N2gzcyVpERi9ZVtPABtaOmb3hGq2tpZOyWjA8pgU3nrRr2JtHs2SdBzS8odtKHxHngpmBF83nqW1sQUf/o3pJF1vrwuXuN3x3tLF9pqltao7+vafnwpDSkafVgjy5vnHm+JYkaGII8pNExoXYUat6LKxvFwnByIaFyuyowMslYZoJZt1y+iQlBeyueQzWblOJtQYTydcMR/TvwVL/CdwwxDoVhwq0nfsC4/rhLslq3758XMToQMW6xwRcF7fAwXLBhwpKIjRtuk5tGIu/3XiMfNbdxiIKMKijpN5gBFjWZOs5r3Ns3BG+5iamigkMwfhBLMrMf4ygd905dvtI+wY8lMmbV1rEUGjm9uEY9ANHnVQkAnkCocAMA8PvaL51O1dGnFATOjGKER8Q1gxylp9oVJXzs6cYLdBx04hZ+1fjFyT3G6Y74TIYUjSglcGrT9jY7Wm3odY+NPq+eYRxpG7dHag2CNRkMN8GzaomU0hPewMrGOYVv4zJGhasZdOi4FQcMtXETaa3dSw5c3RSQ0KCRqz9OfkM2KznHuYjQYsk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(83380400001)(478600001)(66476007)(6512007)(2906002)(6666004)(66574015)(41300700001)(26005)(86362001)(6506007)(1076003)(186003)(8936002)(5660300002)(2616005)(6486002)(6916009)(316002)(38100700002)(36756003)(8676002)(66556008)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rx8jKPSVj/z7AbSZhvxpdQgB/BoWOKBG5lNuIRhpgEce8MiPpszRLaVXhzoB?=
 =?us-ascii?Q?msXyQ5d7zm9M0ST99I9LmRTPUUaj7iMu97wLwxHTDbC8qbnVZxh63BI2E7JQ?=
 =?us-ascii?Q?Ooyh+bzbDDjwZlaQqRVeLXae+zA7ONK7UqO3HYJoLBxxuR4ME9s39o1uDwro?=
 =?us-ascii?Q?G8Yiw44IdBmprFMjJCGW0UngpjckcmtDKD0VfJfvfRG9xpAcr2q+v/7m0AhL?=
 =?us-ascii?Q?hbxP5SpC1zzqurjdYl++94tdgS1dtHFcM7CDGYSMu5T3+ZjTiFzcLHDG6JDL?=
 =?us-ascii?Q?2XaZhXIa0K3GYKNZTFlqPNWusQzBNMCy2uEBEJPmqCw+RLq73nLVijCETKG1?=
 =?us-ascii?Q?OdLfnot6oReGiOjK0W1QO1k0otZM+3SO9LADb2AxH02WrQWObwJekm71lVnw?=
 =?us-ascii?Q?2WThgxwCyH8ztYSWmh8Xvr7vG5qW+RU07c4D9LZ2iBdmb8S/YskVOUHTfuMP?=
 =?us-ascii?Q?ZZXuaBE5w7OEoze92Rt3bE62BQJN+zQ7kS7AuNy8SKKUARrEAyhLK2SMEpLh?=
 =?us-ascii?Q?yvCXlQJcMr6hUoQicR/Skk6SXit6UMowNIlPYqyrmjkOTqMGRaZG+gDC+uGw?=
 =?us-ascii?Q?TVjp2aNDIdOqAdbHG1T1aXMx5Gw+ewwqymx2v4j9Z90BCaUQLSQo6HBdEgNS?=
 =?us-ascii?Q?EwljJSA7hPCRYPIs9vYgvDHlSNoweSyorQizlXK2WEWHGx9oegZcN8p/aBOZ?=
 =?us-ascii?Q?J2eL0M1mc/UBUwic+SzrZG5SXDvroQCY5/F1o7P/vx3um2jim45IOJuqk87S?=
 =?us-ascii?Q?y0pYabXTKP5+fRgI3AERvISfeeBJ1bfBH2h45ZM0bFd4Gxc/QwceLB13Vp7a?=
 =?us-ascii?Q?0wdGKpkDMY/3Iree9st3TrT5MT9riRm/JJ9gXNzlWUvTwtVpW8sBoREY+29U?=
 =?us-ascii?Q?9ccLeIil1lZWNkMcnICfh7AYlYZdUXon/0aAs288SlKfj61ivxntUtSuU+Rw?=
 =?us-ascii?Q?MHRTR0R7Xq81kMqeW/omb9naptOwMGoifbXyk/cjVknURo3YyYXXyUWwqBLK?=
 =?us-ascii?Q?XTyQntg/w7SRIRFuqOY8AWJ22Bcim1zTaBWPpf6anBA/q/3hUtK5C5uMbNZL?=
 =?us-ascii?Q?8Wr+yWDSR2T7Y8STxsBviQPdUsvwSq4zN2JOSwq7c6ag/gzjpZ5CPvcv2l11?=
 =?us-ascii?Q?RocvSHlfFdbJVUMWys4CNaeMKSU2QaiWerI9XbM7FcETtJffu+SG/u/PJP39?=
 =?us-ascii?Q?DNKvKUArLWnqMoHTDub0koCrzK0E/LFjTY8UALT6SebOjuyzPwgTUms5cSpk?=
 =?us-ascii?Q?bFvnc6AXoaFweKwKFpyzve7nXkwNyTnt8pPDpXLreHrVOyXLuMYg+CAEdyWL?=
 =?us-ascii?Q?HkUjJaPeqavZDVZLfAW/pJ+4F3sVpD6p9GTBHhiYqCzOBs4WFXVhtZVxaCuy?=
 =?us-ascii?Q?5STfDqXL2gGmqNZ4dXeKFEbt+ILm+Z4IDov+Md/U8Ki5JI/oJSPBzkEY1x/x?=
 =?us-ascii?Q?nW5NvZjWcTgc0l0qw1GaEXea75qVMZDF4NiHq5XXHvyXIujP8ELxDiZ655Zo?=
 =?us-ascii?Q?Y0CK7y074d7FTopnClOhSfbBNp9kBvC1a/pmrkg2CuKSXxFLLnGwDroyzRvn?=
 =?us-ascii?Q?X/ciVrCy0i4hTm+uPv5PzAh/1SaObIoWNQ0gWbjy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4925460f-0018-41e2-9e3a-08da6981f6a0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 12:26:53.6702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lfe7+oVv0HgljQmt3tLHXTDG8TjIREgiAJ+NMMWR+9CBZu8X0Nlxo0ai2ovS7V7kyyLWcvG/dst65hyLVlRcbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4911
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlxsw needs to distinguish nexthops with a gateway from connected
nexthops in order to write the former to the adjacency table of the
device. The check used to rely on the fact that nexthops with a gateway
have a 'link' scope whereas connected nexthops have a 'host' scope. This
is no longer correct after commit 747c14307214 ("ip: fix dflt addr
selection for connected nexthop").

Fix that by instead checking the address family of the gateway IP. This
is a more direct way and also consistent with the IPv6 counterpart in
mlxsw_sp_rt6_is_gateway().

Cc: stable@vger.kernel.org
Fixes: 747c14307214 ("ip: fix dflt addr selection for connected nexthop")
Fixes: 597cfe4fc339 ("nexthop: Add support for IPv4 nexthops")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
Copied stable since Nicolas' patch has stable copied and I don't want
stable trees to have his patch, but not mine. To make it clear how far
this patch needs to be backported, I have included the same Fixes tag as
him.
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 23d526f13f1c..abc0096a20a9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5292,7 +5292,7 @@ static bool mlxsw_sp_fi_is_gateway(const struct mlxsw_sp *mlxsw_sp,
 {
 	const struct fib_nh *nh = fib_info_nh(fi, 0);
 
-	return nh->fib_nh_scope == RT_SCOPE_LINK ||
+	return nh->fib_nh_gw_family ||
 	       mlxsw_sp_nexthop4_ipip_type(mlxsw_sp, nh, NULL);
 }
 
-- 
2.36.1

