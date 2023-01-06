Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4257165FF26
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbjAFKuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbjAFKuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:50:12 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62F26DB90;
        Fri,  6 Jan 2023 02:50:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCsXCaTezccF6IQVVbfOXclXEwrZiBPNhkIjG/uWYcapLsHQhTpBZ15vurLU7PPb9Ara/baPJ67Fjqzr4IY1phq6kkPzE/9QhtzJfioW05AB5BFnTX4VsR3kzDm7Uq7zfxxS7kHjeKV9x7oTmvb0zDPs/6G66V4VC+2dZpdiIO57tfwst2nt8ss5SvyaVmnAYKTNJq06tvdTSeWyA3X1QJIOY2wMHJAjlLDiqp79wC1ZVTQISvmHgXL0pibjpwz+YVM1a1F6yz2Cfwk9Iybhdfz0Uxj4Y6i3WvP1nnMY4yxpTEPNP3W5NhhrmGJGf+KIyxiQS65K0Ea2G54GuInCdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmEr51dntcW86NOg88qhP6Bj9oQPDw5kgjs3j5g2VHE=;
 b=GYdnAbmK5s2lKZRtBNblOY0zjJGE2CWvxqZK0m1QUfr2vNS6qBe2ts69a4dKqouT/naWlqVQIwzQ2v11V749W46GuxMGUS0TRBT91PGOZdLg/EG+Yro4xZIHx6JdDa1XoEkUMkKHa/16tosN9KGlati33dykN/GXdiQS89GCEh+yXmJbmkUSZQmanG4PXaqjNjja+ozGXYAPNAr//5wb8+IqY5yWePQtxCCANO3+nWZdF8csfunQS3H+fJMwtA/8mm+gX5w3XniD5kgCIYnbMGOB3MywbpXiA4DFBY7j3KZrM9XKNFFemcY/vZkZ0sS8YVl+p1BzLXi+INtLIreM3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmEr51dntcW86NOg88qhP6Bj9oQPDw5kgjs3j5g2VHE=;
 b=M0Qw8U1B5aH+Cy1ljjuepvhWiQUmdPjxDELByriigH8R7nsPpnKdlZz6LkBC/LeFIwSmIQsXVSaTSEByuI7kjGqUkdEuOqJxhpfkf/ehHS5CIm1O8CTR9qR5AsFgIYfvXaQ8ZWfMCU83HOKrnYCgp6jEzS4C3JEyUHMvn0vEwHxgvciboKlNengJ9QB0oRJ0c3pTEKYTN1CKfezKYv7hHjQahSFuNZDNtOxbyieEvGG9/mWlTjT0JjubgNfZYWV28lvri+Da09WJbx8fuUCeJ+E4pAnS7MoNOBStYd9tXQPzvDfb+eXSj3MBXeFgcC/hveKJr6Nx7Np4BQYomC745A==
Received: from DS7PR03CA0197.namprd03.prod.outlook.com (2603:10b6:5:3b6::22)
 by CY5PR12MB6371.namprd12.prod.outlook.com (2603:10b6:930:f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 10:50:08 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::ac) by DS7PR03CA0197.outlook.office365.com
 (2603:10b6:5:3b6::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Fri, 6 Jan 2023 10:50:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.17 via Frontend Transport; Fri, 6 Jan 2023 10:50:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 6 Jan 2023
 02:49:58 -0800
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 6 Jan 2023
 02:49:55 -0800
References: <20230105232224.never.150-kees@kernel.org>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Kees Cook <keescook@chromium.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH] mlxsw: spectrum_router: Replace 0-length array with
 flexible array
Date:   Fri, 6 Jan 2023 11:02:11 +0100
In-Reply-To: <20230105232224.never.150-kees@kernel.org>
Message-ID: <87v8lk7x9r.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT051:EE_|CY5PR12MB6371:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aada06d-ff46-45a4-6feb-08daefd3c702
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GS4f+jiwEy9S8m8cITNUiq9G1ZE7s7eS5/2dw8r8t9y+9D1n/R6XNbT8IvOhsc04Y3H/y1RJecGinq22Kn1IA3aBBnh8cY9fuRU7bW/j25HXllETlZesj+xFgW6eJyaLn68w4N65nc405ZsTO6tMUMbQO1Dt/gAYezSiqyWsrvwlmKI1Ehi2hQ/Fv6b+/DslEUwoqcfjzLTYUqnBb9P4+1Gge7NorUM81kscjyUPGqdEIfQ5IPFaDlmqNH/mpn1zFPajnxjBTK2TUJBjVo6Dv5zg6gqf9Ckd81KEF6of7eAo3n6dvtb0m3WkO5EEaCPcNaqEo2D49KtsZR939KVEKjq7miiJovpTOJEBwpO3Kb2TcqF1erbh/nUt8v/B6RpnHTh4Tm49uIX8DyilM0zisYBu6Zze0Efq4G+iiKQ2XfJmku/DaDJEX2mMEURC9/FoVB8PIXXopFbdSwRyaFafKdTcCFfzwFLDQRqJxwY0dziWkWhwEAxLaVv2+1I7Ow9vkEP5ic6N/ctEI2rTzdAOSUCGEwIE9yVffbtmSz0HwMbdyqy0E50gUlcenR0eLK6zr3HigPTRhy7EJilKBnDP7Uj5uHR9PSyo1kf4ft5BWmJ54GP6mEyehO7nBuB76SFBla+45gazuQeH8X/EgTn/Hyh1JJQWGgVYg3R1Okpg7NMwwINL0U5RIvtrXw7qY7B9J2zSj92dJ9pS58v0VifykL0XmOGjVmcdmITUxuhRw+zW/yM9ZuHyOLgnVGqY0mB/k9Mq9fNc9DwX5x6XFrY0j/0lMlVDvuq4GKzGXHRBA9o=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199015)(36840700001)(40470700004)(46966006)(47076005)(66574015)(2616005)(82310400005)(26005)(16526019)(186003)(83380400001)(6666004)(426003)(336012)(40480700001)(40460700003)(86362001)(36756003)(36860700001)(82740400003)(356005)(7636003)(41300700001)(4326008)(8676002)(8936002)(2906002)(5660300002)(966005)(316002)(478600001)(70206006)(54906003)(70586007)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 10:50:08.0903
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aada06d-ff46-45a4-6feb-08daefd3c702
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6371
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Kees Cook <keescook@chromium.org> writes:

> Zero-length arrays are deprecated[1]. Replace struct
> mlxsw_sp_nexthop_group_info's "nexthops" 0-length array with a flexible
> array. Detected with GCC 13, using -fstrict-flex-arrays=3:
>
> drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c: In function 'mlxsw_sp_nexthop_group_hash_obj':
> drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:3278:38: warning: array subscript i is outside array bounds of 'struct mlxsw_sp_nexthop[0]' [-Warray-bounds=]
>  3278 |                         val ^= jhash(&nh->ifindex, sizeof(nh->ifindex), seed);
>       |                                      ^~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:2954:33: note: while referencing 'nexthops'
>  2954 |         struct mlxsw_sp_nexthop nexthops[0];
>       |                                 ^~~~~~~~
>
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
>
> Cc: Ido Schimmel <idosch@nvidia.com>
> Cc: Petr Machata <petrm@nvidia.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> index c22c3ac4e2a1..09e32778b012 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> @@ -2951,7 +2951,7 @@ struct mlxsw_sp_nexthop_group_info {
>  	   gateway:1, /* routes using the group use a gateway */
>  	   is_resilient:1;
>  	struct list_head list; /* member in nh_res_grp_list */
> -	struct mlxsw_sp_nexthop nexthops[0];
> +	struct mlxsw_sp_nexthop nexthops[];
>  #define nh_rif	nexthops[0].rif
>  };

Thanks. I'll pass this through our nightly and report back.
