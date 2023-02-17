Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB96E69B202
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 18:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjBQRs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 12:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjBQRsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 12:48:50 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2054.outbound.protection.outlook.com [40.107.102.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5115CF25;
        Fri, 17 Feb 2023 09:48:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpawhIYEgSJSzUH0Ycwxg2oTzP7PCUhW+rxeeZiaE6AJle7HXhNaHGXECb6Ojnbf/R6mtR6qLJ3lsNnLGq2wEixFZNMpoJobvamrrNror9HPqf80U75+PRckDzi+z57Vereyik8lmiaEWQk0ZrQYe47HgPuYWu5ZehA8kIgu4PBcRbjbEkatvjDEs5O9uaWzRjlr6kDs8KBYbHVNlJTAZpZe7ZMEEJ5ku+bTdjCOoBfMWBtIicucSeTTo8eIPYlvJyCURyRTHvTjtn03Bd+Hgk8tlxvNELFGcRe+VhjJwTYMrxbFHR5mhs+8RrO6yQjdS/AMYVpkG58RMqJ1+Gh6pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T0QZjmaZ6X2vpnIMAU5wm0S5VP8c+fE57b3BB9/TXlI=;
 b=SZ4MkfxvDAB1AQTkp9ApzYzyZeTdmpg9v0ggtPhKx7ve9xar36EcaJrM0OAnciZ1NkeoTqYUhC3mlOdpcihDcMY2aglnOcTodVeKL6dX3kEq7S/ovj5xNzOkJ1tolidBvYrh4XZOizFYnOMElpq8WnmwVLfJYOWneR8BO89y8IpU0UwSnQdMgv42S6Mqy5PUt0DAzYtmbEsHsBgWc12XJuuIWHqKTOyFhPl54OH/V0A90BNTCDwyIJv5RC+xZVRPfnMl3tOJmS1PCvqzhjyPub+ybBZBKEG7VIgZ6HBYX2NgUYiKqy8dZfuKEU5SYI/kSSmmsJ4yC1/wyHkDiCQI5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxtesting.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T0QZjmaZ6X2vpnIMAU5wm0S5VP8c+fE57b3BB9/TXlI=;
 b=M6PAQWbPFTTjWvHIFMVF8QbSgOASB28GPiiF33tssCIpTltbAHLpzWCte7L8f07B927OQMyC2FLw5ZfMyxRVqCHjVZ9Jn7m0UblstJgJj4EYg1Tm0rgP1SGBQFwSjYf7BZpMfzLfVh+z1f9VOL+0KrR5etf021LRvod3qURAFfHc/p1CEFgQ72NKz5v+zmYaCCPTYV3cq7DtLumOsiUP5ec+NdtkHn88zyaIOIL7LZ95IsLlRxkLWJ6dJSJmIoh789RxR+rykm9QpiDaWTFWGx/ivusG8/72Almn42LPkfUhsevlTSs+wFFOOTim8tiuUHnLDWZrhVY/TTcV/Dthog==
Received: from DS7PR03CA0334.namprd03.prod.outlook.com (2603:10b6:8:55::11) by
 MN0PR12MB6053.namprd12.prod.outlook.com (2603:10b6:208:3cf::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Fri, 17 Feb
 2023 17:48:47 +0000
Received: from DS1PEPF0000E64B.namprd02.prod.outlook.com
 (2603:10b6:8:55:cafe::ea) by DS7PR03CA0334.outlook.office365.com
 (2603:10b6:8:55::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15 via Frontend
 Transport; Fri, 17 Feb 2023 17:48:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E64B.mail.protection.outlook.com (10.167.18.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.14 via Frontend Transport; Fri, 17 Feb 2023 17:48:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 09:48:34 -0800
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 09:48:32 -0800
References: <20230217140939.487978-1-n.petrova@fintech.ru>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Natalia Petrova <n.petrova@fintech.ru>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>
Subject: Re: [PATCH] mlxsw_spectrum_router: add check for return value of
 'mlxsw_sp_rif_find_by_dev'
Date:   Fri, 17 Feb 2023 18:38:06 +0100
In-Reply-To: <20230217140939.487978-1-n.petrova@fintech.ru>
Message-ID: <877cwgb2tu.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64B:EE_|MN0PR12MB6053:EE_
X-MS-Office365-Filtering-Correlation-Id: d7181e11-6354-468e-20d0-08db110f379a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HkyYnrM8zH0ethu5zxnUKzQn10fYTvGnM1kwsSi/QjEUfDfXcd3jTW4/etAX2GBXW7IDmCG/MXzdFDnWvP3iDGJKhPJ6+Hn5qNmnjKt4ccf4omlhYY7Vdho5NqwbSnm9wdDL+EJMbzsauL9QoeaAvRf5BYF/h6iyFo5tPEzVOzLdp3AT6DeLDl8oJDLQK5n/YUzzYLexQFrEfVwTOwm2CrwG8sewo9rQ1aEZqEZX9vprU46IGD6WxrsSqvtoujBKxqxjJRybZefJfuCwjPdZwwjM1D/o8BgDXogEjPN0TXEGK1v+Pjf1LibvWtnlab14YgVfAb8u9GS7CX+l9oIeat6g4Givo81y36OD9+xPSizDeR9T9F8CgSYhePzTY6yz2zzbblui+sbyRidwNwA7xQrRnR84yXsTwiXAxwd2XLpy5GjGTPByNi3pMM0Ig28ul4V1Vi19hlFWvyEyOPEbpbrDUOHYSfKKwUFEbl3NgaztsL0Uk4tQSHZNmoQjUFv4+HnhBGCpoC1IBcQ3o3iUf7dAoyxlpWEkxG8sznwXNW0uAof+cWX0e20t5CnYfzwhCcKRCaYqTlUS31nV+aepRDjb2kLRdHQg9mNSxri0X06sFEr0nHF617h+WXcU6kLfMXjvy2n0tNOAaYWOVM0p3Y1L2BYLfAItuVA92cgnfkMqJV4PHRWQfW/McSnNSI4l88Gg4F5pIz7ypUxedfI2gg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(8676002)(82740400003)(6916009)(2906002)(82310400005)(70206006)(4326008)(70586007)(478600001)(7636003)(86362001)(16526019)(26005)(186003)(83380400001)(316002)(6666004)(40460700003)(426003)(336012)(36756003)(54906003)(40480700001)(66574015)(356005)(47076005)(2616005)(5660300002)(8936002)(41300700001)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 17:48:45.6680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7181e11-6354-468e-20d0-08db110f379a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6053
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Natalia Petrova <n.petrova@fintech.ru> writes:

> Pointer 'rif' that contains the return value of 'mlxsw_sp_rif_find_by_dev'
> is checked for NULL to avoid possible undefined behavior below caused by
> dereference in 'mlxsw_sp_rif_destroy'.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
> Fixes: e4f3c1c17b6d ("mlxsw: spectrum_router: Implement common RIF core")
> Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> index 2c4443c6b964..4f41b83d7c9e 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> @@ -8658,7 +8658,8 @@ static int mlxsw_sp_inetaddr_bridge_event(struct mlxsw_sp *mlxsw_sp,
>  		break;
>  	case NETDEV_DOWN:
>  		rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, l3_dev);
> -		mlxsw_sp_rif_destroy(rif);
> +		if (rif)
> +			mlxsw_sp_rif_destroy(rif);
>  		break;
>  	}

I don't think this can happen. The corresponding NETDEV_UP is invoked
through address validator chain, so failures to create a RIF would be
vetoed. Furthermore the DOWN event itself is invoked by
mlxsw_sp_inetaddr_event(), where the invocation is contingent on
mlxsw_sp_rif_should_config(). That would be false if there's no RIF.
