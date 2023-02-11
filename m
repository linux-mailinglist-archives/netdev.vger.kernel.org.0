Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD5369325F
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 17:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjBKQWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 11:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjBKQWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 11:22:02 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE67320D37
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 08:22:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpdATbIQxrsvjMDzA6OcnWvSRHUwikO08l0HxvTeXuPGoTbC7fxh2QumAb9DcLMju59YG9xrkEr9wbl3XCkcj3diNRGPrgc3Lr6NPHVweonkSVUpHmnncyPoHIZVgPQmzJHEJP/a5h7dpH0R/SioEZZ7ZCu9bZU0axJ5PAx7EqBFhPvOI+T1a6zuvkxAzfNS5R5Mcmvq7EJcd7zkGPxNdBz6r9BSOBKaXBfJIc+UbJYtEw57vKrm7QWrCub1ceLqxZkra9zPlVWhIJ1j105AQgH7DdLyc0JV1UgDVfhOLbeC6od1TvvZgUgg22mgPNX0D5z2MkxO/3pVAEgI5LugEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQ4/++HOgrbXOfrh0oNfp8C5bosafCgJUefWBq49CsQ=;
 b=oMIlbONPYsl3jOy+l9P3EQFMHGhuInDL3FlM75RbHh3OuUz4bccWdxgQ2vj8lj1N1bc8JLYibblo0n6N1KvICKkv3jyScz6Bd4zGvkCaOlBdhtRnZv6yxWPzeh1ttYuDFVShz5YYc9mEZ53LInOERwK2A6P3Rd+2o/0bqVSAK+lbErIZSL1JP8ECKDy50L/yrc64STqpoYY6tsqsxyfLPCTJyos2rXC6HKGmbr1lAnxZPCSqN8tXRtZH+ni7Ezq3UOJ+6d4+t0AMppJjal08rfLkX3mj5Q7ECuoTFB2MGNoOTlEdcflzzI3Syr+MJU4IFujlsiV3f5IvvVLifJpxCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQ4/++HOgrbXOfrh0oNfp8C5bosafCgJUefWBq49CsQ=;
 b=q4sR7k8rEo41ipByc+PKEpPyS4Z2bOSo+al+tj1pdS3PD6k3DD66PaMcu9Q9co0ByitoiU8iNb/fqScl8FHYjFNns33IAT4rQ3dsHCztN52sSD9M6GaoOkaB5/j0VVc3GyzeRwXAzbtYUiuko3gk89KzWLmQ8ByuekaC+27IpOuUhUHCXQpLDy/Hq/hQcejDbcFw+GLNE9jhC+67yMcpXObjMqiAqoBwh0z/JzkeURd/LpTRPvBGAvItzbYyMOWvlg1b6WRQwQqlcOyfzhf4/b4BvchLoxy0V1she1XHgAVBT4Ldgz58ZDzFFJNGq5clRD8bOx47boMZr0mdxPW3HQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA0PR12MB4493.namprd12.prod.outlook.com (2603:10b6:806:72::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Sat, 11 Feb
 2023 16:21:59 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6086.021; Sat, 11 Feb 2023
 16:21:58 +0000
Date:   Sat, 11 Feb 2023 18:21:45 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com,
        Maksym Yaremchuk <maksymy@nvidia.com>
Subject: Re: [PATCH net] mlxsw: spectrum: Fix incorrect parsing depth after
 reload
Message-ID: <Y+fAmU5RuHrY28Vy@shredder>
References: <6abc3c92f72af737cb3bba18e610adaa897ced21.1675942338.git.petrm@nvidia.com>
 <20230210193350.239f707f@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210193350.239f707f@kernel.org>
X-ClientProxiedBy: VE1PR03CA0046.eurprd03.prod.outlook.com
 (2603:10a6:803:118::35) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA0PR12MB4493:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fe6d9df-1fac-4457-d888-08db0c4c1962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ANUwq2CM91r2smJLdQkf35/R2mYhisZxk/jfClZQwDV0oMmZB0xPNCU+otL94QYSy+/kQ30La/b1T4sgMehRXKjTLRC9vn4NVBYTejkZO3x27bRFRVJGF2qzYLSP9Rhp5N4ori6OnolIqENZRENs8X3TVKOjCWyIF9LCttiuqkKSqVoykE9dvVgGiP2/NE6fNnQI2yzFQclEDBUdPW6yiPdC94qWleGp61HX64B6riVqIG9aLgiuFc1hDZKwQgBfL1bVoq8JiPAhDkYIahfyBLHr00r5VYDAuotVNcO3uskBGvi23OxOBIdsLcwy9Z01ZDTJ/vqg90R7Wfk1olXXsTUTrhS5CKLlz1Dj6Hu2Fkv9BaPY1N6l2DTJfXYeU5bQ+ISV3qCGIjX3KyuyT258UsTavhZNx/Ar45eZp/e8xxg2e4ZQgKvs7INfM6YrGXtsALojrLCyRWvfaGbuNEX7Nthk8mcA7wNRSQDgbZ5IndFHSHXndP+ui5bASONYlWWzkHacciWTobwJLzE9X1ekt4gr3kZ9R5u7eYT38Ovre3N1rG2iKy4hv2dxng61dA4M3NF7fqtvT3OnmvcbA4qJkSawVh3jGInYf2f60TmJZljPNY8/T3zT8J+Jf2JOilzY86I6WRyUlCEFr8oZof+g7Ab6oG/OrNra4kSZtT/cR7yZ0cFE5/mu4k/lFiy959tb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(451199018)(33716001)(9686003)(6512007)(6666004)(107886003)(38100700002)(54906003)(316002)(5660300002)(6486002)(478600001)(86362001)(66574015)(186003)(26005)(6506007)(83380400001)(8936002)(66476007)(2906002)(4326008)(6916009)(8676002)(66946007)(66556008)(41300700001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nXpmNUDZ0E1GKQStebWVVB8Hwu0H745e4/jKmwis+C4/cwofvMal3ayMVMrV?=
 =?us-ascii?Q?I3ExEAGxMi8jhM4C8VXWm3hmc2/xzOFgItRTPaYX7dyAFwFWbBZKTOOVvlSd?=
 =?us-ascii?Q?eQXY2ZbicYo99AmlMKoAYtVqsIBDk37Gf0UZk0eklXVPcvGpmM/rLDZgLvm5?=
 =?us-ascii?Q?4AX76OQL+x6xWy/exMoZgH2B1iHtfmSWxr03UCqiH/x/uIJ5ZSR03oAfas/E?=
 =?us-ascii?Q?gQaSdjgme3jU3sYW4M2IX1pUlU21x1ArPI6gVlwIilzgdPk4OMIONjHYYg9p?=
 =?us-ascii?Q?gg0cRfF4OgsVAMzQmh3o8WqZFWSNlCHNNyj3yZQ7aVUYtb/s3CWImk2W+Hpt?=
 =?us-ascii?Q?Z9SX2uSD9zxCsYzxqRQSycG7iM1i0F2XP8qIprdMaezJwH0t6Q3i2t3MOPUA?=
 =?us-ascii?Q?9SFxQppUjlopTox32o0w8Rh7xsA3pT8AaWpV/hT4xiUU8+2LmlEmpfOBZv3I?=
 =?us-ascii?Q?fEnyTS3onAfAnjzmoRe+Fb4ASX5VIHuj3USB9ZSVM1F5Cy3mI4ftwgvUC5Al?=
 =?us-ascii?Q?U2NSCqW7QIex4j7jlTlXS04iyJN0ZpKAZfBguOwkNrbEIpI4etlT3C6mz4A/?=
 =?us-ascii?Q?vGP5bta1TGa0Kdb0UfssKuj++nEKi+Z0nd14KmDqkeu9X309sCUx3ddMcbSq?=
 =?us-ascii?Q?RTag1hZEKgjyqpcaeQtxs6IqRRh1ftegsRzUP4J8rxyKxvmzKwk57qTrqyN6?=
 =?us-ascii?Q?GO9XtbX6/o75ymnC8sBL/1ZTObzdFLk0OgURaK3GcHBINgYxHX82+wE3NqGy?=
 =?us-ascii?Q?loypxEoG3KyDL1XHsQj/Lgs3r4u5VAxv3ILLaLkZM7Yjm3S3n2NYavxaF2hz?=
 =?us-ascii?Q?73MgTvcT9whqNvtVIn1du2e/5f+PE3P4udqcXYz4BXgDM2B/TZ8yTjkB9GuG?=
 =?us-ascii?Q?zJd1a78HrSsUmwBeKxr3HeZ3e9T+k5+At/ZWKCLxvbi0aqqYW70ntxCpguBB?=
 =?us-ascii?Q?ujm3hHFY6RrJUi5+uH5pj3vqF9dtHlGh13uQS37LrKtBMyyjKtlSn9kylZu1?=
 =?us-ascii?Q?kqf7ctdozByshYurFYGBNLK+SrOMv80BY9F86AWLlRt4QJxWZFHmzKOD7UzP?=
 =?us-ascii?Q?G0e8ITfs7jSMFOZc6dkEIYpanBEb6tTyTp0bTaXnP3/90dFTm8n9Oqv/6cvt?=
 =?us-ascii?Q?bOL1fEimnrYq3/7iOMKfDA/agnItv1hVFwQIXKUKVGDUJ1pYTof8sGqi2b7v?=
 =?us-ascii?Q?uu9l1DOlWMdtoUA0hEmyDbm7TaIgvf6Ol50qDkuV2YtqipzQB2QbILQU2HSe?=
 =?us-ascii?Q?yjoXtXxdgwUvmNPR2Qy2D2xEFkW6icPZXTFpHLgBr4LSQkWdFAYEsjKAcpJo?=
 =?us-ascii?Q?dplvs3K0jSrTWATUyZAwx1MtweX0ZstagJK3FDdUgIO5rTauQR9SPcT8Dg7j?=
 =?us-ascii?Q?G+3oQ4wbumpU+NsiHCRyKNio/bbMl5hxZaKWUC0rhgdbP7qmg/jK52vvPp3/?=
 =?us-ascii?Q?LLSVr3KZbZtz5Ck/bwynQg9xwQjpkU6cwU4aS8a5J8NmsvuqVnXexal49eDn?=
 =?us-ascii?Q?zCGYTRDi96KYQX06EXbeQfRuho62r56bKdlr1VfbdJ9lyNqAs4OJwGZvDbB0?=
 =?us-ascii?Q?2sx8ozBriu02IzXNr6BH7ig9pkFAL3t2bgDFX5CK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fe6d9df-1fac-4457-d888-08db0c4c1962
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 16:21:58.8044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EApSMdVd7cz9iH+o0Nro4WhvOvyWlMN2vU8b2z9QJTYwEHvLHkBhSWdk/bIzoe8w1bCvkca/QdI1Ls1gq+/ILA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4493
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 07:33:50PM -0800, Jakub Kicinski wrote:
> On Thu, 9 Feb 2023 12:40:24 +0100 Petr Machata wrote:
> > Spectrum ASICs have a configurable limit on how deep into the packet
> > they parse. By default, the limit is 96 bytes.
> > 
> > There are several cases where this parsing depth is not enough and there
> > is a need to increase it. For example, timestamping of PTP packets and a
> > FIB multipath hash policy that requires hashing on inner fields. The
> > driver therefore maintains a reference count that reflects the number of
> > consumers that require an increased parsing depth.
> > 
> > During reload_down() the parsing depth reference count does not
> > necessarily drop to zero, but the parsing depth itself is restored to
> > the default during reload_up() when the firmware is reset. It is
> > therefore possible to end up in situations where the driver thinks that
> > the parsing depth was increased (reference count is non-zero), when it
> > is not.
> 
> Sounds quite odd TBH, something doesn't get de-registered during _down()
> but is registered again during _up()?

It's not really de-registered / registered. The FIB multipath hash
policy isn't changed when devlink reload is issued, so the driver
doesn't bother decrementing the parsing depth reference count. The diff
below does decrement the reference count on reload_down(). Tested it
without the current fix and it seems to work. If you prefer, I can send
a v2 with this diff squashed into the current fix.

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index c862a8b977c4..876e47dcd398 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2945,6 +2945,7 @@ static void mlxsw_sp_parsing_init(struct mlxsw_sp *mlxsw_sp)
 static void mlxsw_sp_parsing_fini(struct mlxsw_sp *mlxsw_sp)
 {
 	mutex_destroy(&mlxsw_sp->parsing.lock);
+	WARN_ON_ONCE(refcount_read(&mlxsw_sp->parsing.parsing_depth_ref));
 }
 
 struct mlxsw_sp_ipv6_addr_node {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 8f3d2d2b7595..0b32292548c0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -10521,6 +10521,14 @@ static int mlxsw_sp_mp_hash_init(struct mlxsw_sp *mlxsw_sp)
 }
 #endif
 
+static void mlxsw_sp_mp_hash_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	bool old_inc_parsing_depth = mlxsw_sp->router->inc_parsing_depth;
+
+	mlxsw_sp_mp_hash_parsing_depth_adjust(mlxsw_sp, old_inc_parsing_depth,
+					      false);
+}
+
 static int mlxsw_sp_dscp_init(struct mlxsw_sp *mlxsw_sp)
 {
 	char rdpm_pl[MLXSW_REG_RDPM_LEN];
@@ -10764,6 +10772,7 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 err_register_inetaddr_notifier:
 	mlxsw_core_flush_owq();
 err_dscp_init:
+	mlxsw_sp_mp_hash_fini(mlxsw_sp);
 err_mp_hash_init:
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 err_neigh_init:
@@ -10807,6 +10816,7 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	unregister_inet6addr_notifier(&router->inet6addr_nb);
 	unregister_inetaddr_notifier(&router->inetaddr_nb);
 	mlxsw_core_flush_owq();
+	mlxsw_sp_mp_hash_fini(mlxsw_sp);
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 	mlxsw_sp_lb_rif_fini(mlxsw_sp);
 	mlxsw_sp_vrs_fini(mlxsw_sp);
