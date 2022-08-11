Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69F758FB9B
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 13:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbiHKLtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 07:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbiHKLtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 07:49:01 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DBF3206C;
        Thu, 11 Aug 2022 04:49:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JX25wAkVhm6/qQ1rQ/iXdmfoKrUdev9LCraIMbE1qjWDQ8Aaq2uFNcLG9IE5TSQJ23Gx6bJxHhVg7HBRZpm4K3r9B8xabNuokM5NmcvODX+68t+EtQqBCjdOhVL8CSy/FUyMmJUmfCYuNwGrvk6WpietD58Meo45+5bmkbT393YXhOvlO2NqmHJvj2mj3c4NWqbKKFqlDJBW4J2gx/08NRxAF5Gns7Mg8CLSqUpU8v6LZuIM6ht60JCeAAO3eXi+I0xhVUZ+FqWH6PWAUfAOtRSBIPd9Dujys/nYhc8h+fNTFOfw0uBm/dXvdOVhTKvgXJ5xSdqxgDamFc54EQ7Xpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50X5CNs9BEzLUoyUIlxso+OeNwN6Avdn42ZoNNz5DvE=;
 b=DTIUTrca5W6qNnC+pmlN+JmgT7HawQaQkjzAOol6aAuvs+9l2rsi2hv0SEGe1hXAorz5+FDVyt8gTqrQ34+eS67Xlv5cVE1RAuETgDyoX7e86D78YoeFIjPLuNHL/8rL88tNnU8H+fHPusku1ZBGZLIo5HF9GaJuq43djpj0kAsnoqJIDt0TlmXlWdFWzsyqsNwe8gVit5uT3vzCIOBKCE/Bxzs7wTN2Asp1XDSx1hPI7+WHlNNyFcYO5qb5Ao2NjD7bpsvuBJHuItqbSqpzpaH4jV7wbG+3jW+l4WwDjEZEZbsG0F5tlQDIvc1GSUAoOeDQaSPa1kc/cBYHUSTefw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50X5CNs9BEzLUoyUIlxso+OeNwN6Avdn42ZoNNz5DvE=;
 b=afYwbGPqB2WIiUU23u1at2pMVYTcXvW2JnwkL60BcH8WY1se8vReMGLA8xcCxh0UKty+hziXXgUT46bCtaJJ0U/bJrRauPLZ59XoDtkmNlxuVbufz+usJ/HaydeoFheRgCi8Wyr7fcCKcQ3QZwUO8HabN7pbilKnqxXrSb2N4ueCHxdovcl1cu0EzMluoRmZrckt9QtqLR2ALCXAxyVYoaliirlMcPX1zJx8ZSwz5FjXNurXiqO+T6C3nmyF1SrOLnXjfccwAT4NZ/lpl+4NCVYrMr0BVTIpEDonXyxLhzRWdRIJphZPT2ZPg6emhZzk+viao8s7j7gWbANRWclDDQ==
Received: from BN9PR03CA0426.namprd03.prod.outlook.com (2603:10b6:408:113::11)
 by PH8PR12MB6867.namprd12.prod.outlook.com (2603:10b6:510:1ca::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Thu, 11 Aug
 2022 11:48:58 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::61) by BN9PR03CA0426.outlook.office365.com
 (2603:10b6:408:113::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.12 via Frontend
 Transport; Thu, 11 Aug 2022 11:48:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Thu, 11 Aug 2022 11:48:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 11 Aug
 2022 11:48:56 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 11 Aug
 2022 04:48:53 -0700
References: <f4afce5ab0318617f3866b85274be52542d59b32.1660211614.git.petrm@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        "Ido Schimmel" <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net] mlxsw: minimal: Fix deadlock in ports creation
Date:   Thu, 11 Aug 2022 13:44:17 +0200
In-Reply-To: <f4afce5ab0318617f3866b85274be52542d59b32.1660211614.git.petrm@nvidia.com>
Message-ID: <87wnbf57bw.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15e1a9ff-109b-4885-73c4-08da7b8f79d8
X-MS-TrafficTypeDiagnostic: PH8PR12MB6867:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rH9at42wWu8sLLEko1OGLwim1Z85h1j2Ym/PnWZU2FH01RvGXsbU5BYjcltIrMuPS4mkXWXtrqaoNnHX5C8R9xnmCyXOfzHqNesUbGDjtQivjQ32MPSd1uwCq7wxhKUqiU6H8Bm2iDO9ayCs9p57e8L2io456aK5Dc7ip3EF+e9xXirvqudwmXh9yV700Sg4Ad6fag1PW6MGn8shxtoCvYEQwmClBDaIdozli9qTOwkCq9AZ3dfnbaJRWJHyCK9uIuptsV1s0BDu2/UCxjgnW/bWyEqFjqSy/9FWLhsIfEFaIqokRqwqZyCWmY6xWXpVh8whXlvdHLi7D0Samj0b/E9B1TbAQMjmM6OqNSdiHTJEp7FAzgpeRno9NgSHEmPZ+kebgRqpTP8WxMdPldrBQOyQ0oxy0JXl4VKVBxYlZBKCUTNRCAzcPGtdNN2QkNkLI4AQNBhLmcVOXgF9jtdAWOsJn9AWo2yTzZRz/O/EivdWIp08cDVATP59O6C834V0DzABZWyGOd6MKTsbsEr99ZvH1L1Uk4OhFgVCucpUoKgSPSgVtQZMs91xXXHT8eUtradai3fJDYT9AUmv4cB2xIJMNBQvX+FoHPyUpoMbN1LJBp0weSHixZijxXFecIUAUa+MAi0GWObLRsnf0/VcOUYxJI4b9kclzkhXZ/cDk1qB+PFKbIsETMzt9Tuxhxk9dVGHqJjR7EIq8ZtDLZ5myJQ87CwtyBZluiFw5t0YWuCYHBd4/TtUk8XLV3x00ounTi+RZ2z0tT/HXP26fGLJfR+j4GN0I3AtD3HomoSK+K/e3GJUNVQm+cGHftAGErMa1xwJ7qPvQyfCiTIRw1AA2Q==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(396003)(376002)(346002)(40470700004)(36840700001)(46966006)(83380400001)(6862004)(2616005)(86362001)(70206006)(8936002)(70586007)(16526019)(6200100001)(316002)(4326008)(426003)(186003)(107886003)(37006003)(40460700003)(54906003)(36860700001)(47076005)(336012)(8676002)(36756003)(40480700001)(356005)(82740400003)(81166007)(26005)(41300700001)(478600001)(5660300002)(6666004)(2906002)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 11:48:57.9239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15e1a9ff-109b-4885-73c4-08da7b8f79d8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6867
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC'ing Jiri, which I forgot to do.

Petr Machata <petrm@nvidia.com> writes:

> From: Vadim Pasternak <vadimp@nvidia.com>
>
> Drop devl_lock() / devl_unlock() from ports creation and removal flows
> since the devlink instance lock is now taken by mlxsw_core.
>
> Fixes: 72a4c8c94efa ("mlxsw: convert driver to use unlocked devlink API during init/fini")
> Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/minimal.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
> index d9bf584234a6..bb1cd4bae82e 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
> @@ -328,7 +328,6 @@ static void mlxsw_m_port_module_unmap(struct mlxsw_m *mlxsw_m, u8 module)
>  static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
>  {
>  	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_m->core);
> -	struct devlink *devlink = priv_to_devlink(mlxsw_m->core);
>  	u8 last_module = max_ports;
>  	int i;
>  	int err;
> @@ -357,7 +356,6 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
>  	}
>  
>  	/* Create port objects for each valid entry */
> -	devl_lock(devlink);
>  	for (i = 0; i < mlxsw_m->max_ports; i++) {
>  		if (mlxsw_m->module_to_port[i] > 0) {
>  			err = mlxsw_m_port_create(mlxsw_m,
> @@ -367,7 +365,6 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
>  				goto err_module_to_port_create;
>  		}
>  	}
> -	devl_unlock(devlink);
>  
>  	return 0;
>  
> @@ -377,7 +374,6 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
>  			mlxsw_m_port_remove(mlxsw_m,
>  					    mlxsw_m->module_to_port[i]);
>  	}
> -	devl_unlock(devlink);
>  	i = max_ports;
>  err_module_to_port_map:
>  	for (i--; i > 0; i--)
> @@ -390,10 +386,8 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
>  
>  static void mlxsw_m_ports_remove(struct mlxsw_m *mlxsw_m)
>  {
> -	struct devlink *devlink = priv_to_devlink(mlxsw_m->core);
>  	int i;
>  
> -	devl_lock(devlink);
>  	for (i = 0; i < mlxsw_m->max_ports; i++) {
>  		if (mlxsw_m->module_to_port[i] > 0) {
>  			mlxsw_m_port_remove(mlxsw_m,
> @@ -401,7 +395,6 @@ static void mlxsw_m_ports_remove(struct mlxsw_m *mlxsw_m)
>  			mlxsw_m_port_module_unmap(mlxsw_m, i);
>  		}
>  	}
> -	devl_unlock(devlink);
>  
>  	kfree(mlxsw_m->module_to_port);
>  	kfree(mlxsw_m->ports);

