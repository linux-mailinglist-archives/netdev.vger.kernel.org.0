Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C3D51EC20
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 10:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiEHIMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 04:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiEHIMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 04:12:51 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96D2E03E
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 01:09:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l56Ndu95YBXR9q+z/Lz0pppZz8QVFBzQNfOMWWwN+qm81bXAkj2ch9RLxJuQghDak6GRwiNJUjOAzAcjJauHiSGxjNoizpPQ/uh6ILDKT5Spxt3kTJqzAbRi/GpqSBLxVHUIjVrMXS10439xo7aacG7lgnEDT6q3ANakuDu0YXBdlhoDOAedHU7E4MgfvsVs8CnQAuA3re+P1fXpx2+U8m+OD6Yd+4tyHppQo8OUDIjxaLZ19rq5JjOEbH45lxQxMGyGoFTALi2J+w08aYNwphrBNCNZxfg8AQkIUJiRhDEemfKp6i+ZM0xeQU96nxEHh3VVmYvVz729CKc8cH9zXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tntKqlavkRkJmAZEhdZG1guHYyNIWE7QMdA5gIHN8QU=;
 b=MSbOYDx0xR7J3DVEAnOeH3EW7Vmqbm58lgxXV5fAOokxFG6ywK/2yieowT8fi/ULQ6B/IzQn22hkynWPeJqEQW1mtJmNOGG+DdZ8LebI5aAdtjvqMDY27rHudbZ3FdfDOREimlbv1AIUtINrksJKNH+hI7zn7So8OoeNeNmiiBOS3X8wtYKsHS9jnFzxuFtzjDrcz+JP1BcLiNfAAXNFfU33JxDdqkLc2ie2mJT9SETrk2vnCAtxFh9vs/taJkpPsww4ErvxmwFPjd1XUfHqnMHo10Pa8KjvmxnvePkA+yqj8ecDAU8wHGnSfzrbNwcnJcr/sf27Jp72AcfwD1pWSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tntKqlavkRkJmAZEhdZG1guHYyNIWE7QMdA5gIHN8QU=;
 b=gQwHaLONIfsB7eQk0uBzH81/8ivImviWu1zjcZxPJgeft+amoufJQR6azoow6VTP3V3eF+/URgVVHWzlsTtAE/5ULA67etZYMuOlZrvEdn3S1YeIY4NPgOKLB/GCGtRQ8Fnn2Zlo69X2jXqXaVkU3k5UKpS0WE5Nsj/EbiSpiUa834JlegbO+Zh7JWcvOFWBc0I+W3E8bSAh+FeZfKnMNHiwhpmiwzjXWgUkJsyxPvog7tSOiHHtF6ZkfUhV0WuEUqFg7fq5hrQdv3fpMKAezje/WcJgfBjSF9yMmhR/omaQutZ9O3X2PBv0v7wwC8wMCcqWwOraWaxuMujtAlPXuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6096.namprd12.prod.outlook.com (2603:10b6:8:9b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.22; Sun, 8 May 2022 08:09:01 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 08:09:01 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/10] mlxsw: spectrum_router: Add a dedicated notifier block
Date:   Sun,  8 May 2022 11:08:15 +0300
Message-Id: <20220508080823.32154-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220508080823.32154-1-idosch@nvidia.com>
References: <20220508080823.32154-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0118.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::34) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: caf50a40-1511-4e40-b2cf-08da30ca02a6
X-MS-TrafficTypeDiagnostic: DS7PR12MB6096:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB6096E89D02BA44446E06568AB2C79@DS7PR12MB6096.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WGse/ExWpgC3xkA7UlsQESkbMl9Sr8ZYa+I38QUKpntQaO1cZeuDxPD63IsK/XuOmI+UtbPNZCqw3727UDdVOpxtTYZumvMgPHY5nzzx7O+89TmyOKHfGyp4RT35X32Dd8+NumK1zr3o0EOUiZHvLtBqZTzyxuZOuX3mbgh4JXOFPNwwjZHbQyjgPFB6PhJh34gkDMWf+sZvtO9odceXsHujb6bxcuNxHrtDj4bgv6Dto4H9yRQJrflG5D+IoefEhvpuY0j2RV+KNFcI+ExBRc2cMf3/a99AfHEwxu558805/CFNgElLJTo3eRgFPyZ7P0KKSozJ5hp9adTD7EifkEQOC2mMzmQLSi7bHuFJoadviorbkyUnt8KvVLHvp9N6N2nCwykO9M9VRUXW5y5NfR09ALyysIg1o6IuNsieJqJPmFH3RCIzjN6/XaLaQuMjSwROT+e1KmI9zmkOYOPzGhFndjVl2iGZRfDGEM3In2wq8VXszp08AgSuHcbAUpqc6Qj2RaPzX8FjV6NCy5czfPERoF3I59eB5QzOWXfvkI2u4Dp90GB+X5Oudh+SlzwhzyCxMSYpHEqO/4hpW5JVPv5oZUT3Rr+v9RkevDw3C3rrs1E9T+Q1Jbr/0J0l5YV9/6V9mrm2xBzVr43bpQn8nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(2616005)(36756003)(316002)(6666004)(83380400001)(66574015)(186003)(107886003)(8936002)(86362001)(4326008)(26005)(66476007)(66556008)(6512007)(8676002)(66946007)(38100700002)(508600001)(2906002)(6486002)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7eyrWYE30pA2hA0/GBOs3NWAR0LuupduXTjszJucfMFmSX0mATFen6ttv1ed?=
 =?us-ascii?Q?uZjzrNJoAZpNymttpsPIcF7EWKr8GYjAqLaZicKJGbaCArLUrtoA3xXZePt6?=
 =?us-ascii?Q?VvT2BpLPgQUPhIr3HixgbHhZ/M8uMlkM/1NX4QYn/ROLjSckHHLpOjybLwWs?=
 =?us-ascii?Q?+MTl4MLn2eLasWRozxpiVL3R3mvdUEXiWcR5AWq8YuVIDm6pglkEw1jhVUb0?=
 =?us-ascii?Q?+rqhOcu5tQpirNMqDmgti6c/CezDAZdcvNCer6/PwYqvbc5yY6Igo0++3EVO?=
 =?us-ascii?Q?0xQdPnozMS2vXXqgyiDjaEFWpEXth0DLqu1+P0BiUsFJShyAkVfgNESwHa4Q?=
 =?us-ascii?Q?j9RYdJiqQhXFntb/5xjL8cqXwQJnM3IwKcNUzXbOABEy08fo5ew4TrFfqmRU?=
 =?us-ascii?Q?0ry/c47BPwr6WP1c8EUzmzRpHA0f76sJGTAGXgdPiABDvCPwA9be32a6ouir?=
 =?us-ascii?Q?E3jGhTLR9QI9fP8Khslp11ec2nDhS9dbl2cUCR8EbHsl7mCBdCCXCax39J7s?=
 =?us-ascii?Q?+XhsVYK//KCTwdxitVtcH2J6ONgu3KxArM1ycsqSUJ7AvSvRdjJA3CjyzhTh?=
 =?us-ascii?Q?2F4uU8rHd0b3CS9wK+N3dI+vGhkFa3Bi3AYLwkrj7J64mF6MlbMF0sokJ1nQ?=
 =?us-ascii?Q?1e/5q5tD5pp2hv+IGJrtn9r+9G9/rxpWIJ15oVLwGLQoBjhQMz03gviIaPru?=
 =?us-ascii?Q?w77InUXfGy2jZvIgHa9EseGkOVqWdatQNBAt+13YwT2SkHFfI7/+RPir887v?=
 =?us-ascii?Q?2NwDeUFR0De9CqIOkjvqUeE5KEHOlVPNkRp3q9AkLOffWPV5LuAY6Nhmt6HG?=
 =?us-ascii?Q?LUxZSa/KwoLsDkaP/1tHFv3nSJEVQPw7Ln6JvPi27tOE2XsjPCNgqG+oFMCK?=
 =?us-ascii?Q?051xKlsFlB8+lkFpOU/WJM7KT4MOSJ96D+pndwujbGVruNElNj4XD8xH/w9t?=
 =?us-ascii?Q?/GarsGKBWqECITr7Pmbm8m0dpUa3L1FIlh9C/jwjKzWyeS7QHoSkQJNy6KLD?=
 =?us-ascii?Q?pZ/S2mIrYLCpXjNsCc0peW/gxs4njeMbDKqWxjmnzxopxcQT0iD3PGBSpJKl?=
 =?us-ascii?Q?S/7RZoUK/MuybtrPo/jMzmX+Y9Zqr5BIzgGA1EaGkaNJNkVBH15Qzo/M+BFB?=
 =?us-ascii?Q?BNWImwtWxaCZ/8DZHsFwPy4Px7sfI+zwZOgZCsWyXfj9EVrOPGAJZbTN0E4g?=
 =?us-ascii?Q?hWA5EQRVx6LSB383xvgC5w5eUM4Hr0MaaITmy8KsCsJTaYZiz8l24PsTkct4?=
 =?us-ascii?Q?X0ld+ZMA1/iznE7wGYXaShg+ikYsNoURq0sU4MiH6CKwddTWejPe+KeFfxyE?=
 =?us-ascii?Q?0B+CavyycIyHD+5NaRXyLzuGudiW2akDo/IuNm6d+/WT57jMXaFAJFNEoCG0?=
 =?us-ascii?Q?bkUUUYgzoJPQRXzQFp3k2ESR5kLA9nOaVNsH6rLe/9GdRqZ3cXYow5vbOzXL?=
 =?us-ascii?Q?8pVFErAjKAkWJ1oLRs+Fx36FAIQbQRVCSnLLltwyCug7L27yJevZPcQzcq6a?=
 =?us-ascii?Q?38jjQzDbbZy0JOma/Qf0wv59wNha2nDwWN0KFmCZLAFSjRI+/hElS88sbWYD?=
 =?us-ascii?Q?c88k8mHhUwLRQQCdqQRNXoOc5nmORvyIewjHeVxVsbL0/fDlTUfxhQMyQe7a?=
 =?us-ascii?Q?yZC9UaYFZj+geS56z3nYDZm4fKS5J5quEPz94GqvOyKkyHoPV8YLZfQz5u4W?=
 =?us-ascii?Q?eXohMi90ofPcSp36KX2+Sy/ntQS7Tsc/iXIIRC2tqDrN+lx7F7togH6V4/66?=
 =?us-ascii?Q?g9o4hrCXWA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caf50a40-1511-4e40-b2cf-08da30ca02a6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 08:09:01.3601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g8rKAqT5inEuJwglCaotl68UU0S09Ns2lOEZDPyE3dwe+0VGFxx6ek9Ev4jzBy0ZloP95qlyMxl/+KPnqezHsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6096
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Currently all netdevice events are handled in the centralized notifier
handler maintained by spectrum.c. Since a number of events are involving
router code, spectrum.c needs to dispatch them to spectrum_router.c. The
spectrum module therefore needs to know more about the router code than it
should have, and there is are several API points through which the two
modules communicate.

To simplify the notifier handlers, introduce a new notifier into the router
module.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 20 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  1 +
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 9ac4f3c00349..3fcb848836f0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9508,6 +9508,14 @@ int mlxsw_sp_netdevice_vrf_event(struct net_device *l3_dev, unsigned long event,
 	return err;
 }
 
+static int mlxsw_sp_router_netdevice_event(struct notifier_block *nb,
+					   unsigned long event, void *ptr)
+{
+	int err = 0;
+
+	return notifier_from_errno(err);
+}
+
 static int __mlxsw_sp_rif_macvlan_flush(struct net_device *dev,
 					struct netdev_nested_priv *priv)
 {
@@ -10692,8 +10700,18 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_register_fib_notifier;
 
+	mlxsw_sp->router->netdevice_nb.notifier_call =
+		mlxsw_sp_router_netdevice_event;
+	err = register_netdevice_notifier_net(mlxsw_sp_net(mlxsw_sp),
+					      &mlxsw_sp->router->netdevice_nb);
+	if (err)
+		goto err_register_netdev_notifier;
+
 	return 0;
 
+err_register_netdev_notifier:
+	unregister_fib_notifier(mlxsw_sp_net(mlxsw_sp),
+				&mlxsw_sp->router->fib_nb);
 err_register_fib_notifier:
 	unregister_nexthop_notifier(mlxsw_sp_net(mlxsw_sp),
 				    &mlxsw_sp->router->nexthop_nb);
@@ -10741,6 +10759,8 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 
 void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 {
+	unregister_netdevice_notifier_net(mlxsw_sp_net(mlxsw_sp),
+					  &mlxsw_sp->router->netdevice_nb);
 	unregister_fib_notifier(mlxsw_sp_net(mlxsw_sp),
 				&mlxsw_sp->router->fib_nb);
 	unregister_nexthop_notifier(mlxsw_sp_net(mlxsw_sp),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 6e704d807a78..37411b74c3e6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -67,6 +67,7 @@ struct mlxsw_sp_router {
 	struct notifier_block netevent_nb;
 	struct notifier_block inetaddr_nb;
 	struct notifier_block inet6addr_nb;
+	struct notifier_block netdevice_nb;
 	const struct mlxsw_sp_rif_ops **rif_ops_arr;
 	const struct mlxsw_sp_ipip_ops **ipip_ops_arr;
 	struct mlxsw_sp_router_nve_decap nve_decap_config;
-- 
2.35.1

