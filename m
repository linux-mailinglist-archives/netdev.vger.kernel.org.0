Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC5955FE31
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 13:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbiF2LFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 07:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiF2LEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 07:04:50 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2083.outbound.protection.outlook.com [40.107.96.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8AD3EAB6;
        Wed, 29 Jun 2022 04:04:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KG/HlAFgBVSO81r4RAEIaBsOSVXXEqvgdYBf3wLORLhToDcNCG8RXcPUfQaGBtFGg9YdNxSFiBIhUnf0cvT/ztUoMYwfMD27ZTmA8gY+OTfQDUQREMsqqBxkswydckD9h/ILIZrbtXOM7XkLo9Cg1Ohd03QdhuVs8Qbr4gt8aLYiIWucDjGm6nLlD2KLh9E4AmPSZZYz9kgwN9VDzZXWgy3EHSW6hN2Fic2NbIrLiHIlzjNpQXOjWAcNhD1pzHn/GW0TNsOiU6qXNgXRLHg96+deFjKhfGOq+DFRGy6I8yGVv8zBP0JVOHTlgB3DSMLI8dPA7c/d/KCv4Tt4KDfMYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GgdE9XfdeBve+eaEIl3rV7/s8n7VxcuuvfnIAUfzth4=;
 b=iY8o4v5/eahdP0zeoGfHZDFfbn0you02fthvDe7J56+tT6GELZOoPVBWDeiD5EVbbqHdzUARnZW8BDMxX43l1IzR++orvQ67gJWLk6MwptzSNVTn6Q7HOovL3/pHiNTauDBlKwFjPf+yoNAyaNhcKlbndzNSt8SgwlNYp9BxUILEu9JKcAEgMXdE7y9LbpQaLr7jbOPwnrQnK+VRhCZUn0bYfDGvEPJEa3kKZccT6pk9Ihb+i/QTY80AbNV9PP5CoJkSAi5FRx1POIQtGJYOMjMteFUHAY9khQZpSJVBaV/f+4vFR14Jw4uNu+kRpP+VMH7Ns18uBXU85z51DItIAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GgdE9XfdeBve+eaEIl3rV7/s8n7VxcuuvfnIAUfzth4=;
 b=Hv//udbTxkCw2RhykCXIIg/Xicn1NQqR/97siuzvamqk+Wh2IVtsaNFU7s7tIkrcS8GaokCB5+wiNbv5oCttUFiG9WIEtwdDedU8DpfaNIOC5cr9Stkq48xVnEuhMx5r1Xp1iB5PhVTiWuXjfHBwTBZml+nJzKot2zp7I4AVPksfPOTLNa+Wm+BFImTDJ2eX8qTooVG7mKe4I2iBKqd6rdlXUjR29k/OfggtYEHwfLpaqBpG3/LVEVsCeWD3ei8pFI38+N5qV8aU+Vrq6Lp9IvP2Bbq/Z7ZykHAG/RlCPtbAke8DPsqTscoO/vuuO8W4huxHF+TEbM+ayQXlE44iIQ==
Received: from DM6PR02CA0045.namprd02.prod.outlook.com (2603:10b6:5:177::22)
 by DM5PR1201MB0188.namprd12.prod.outlook.com (2603:10b6:4:56::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Wed, 29 Jun
 2022 11:04:42 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::c7) by DM6PR02CA0045.outlook.office365.com
 (2603:10b6:5:177::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17 via Frontend
 Transport; Wed, 29 Jun 2022 11:04:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Wed, 29 Jun 2022 11:04:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 29 Jun
 2022 11:04:41 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 29 Jun
 2022 04:04:39 -0700
References: <20220628140313.74984-1-u.kleine-koenig@pengutronix.de>
 <20220628140313.74984-7-u.kleine-koenig@pengutronix.de>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, Wolfram Sang <wsa@kernel.org>
Subject: Re: [PATCH 6/6] i2c: Make remove callback return void
Date:   Wed, 29 Jun 2022 12:53:52 +0200
In-Reply-To: <20220628140313.74984-7-u.kleine-koenig@pengutronix.de>
Message-ID: <87h743vigq.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ee88403-f68c-4600-59ab-08da59bf2afd
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0188:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hgN6OQjKC5cv8nEOpqT7LIDj6x4trabnFy24t696y38zqsxziEJtS3mc8x+eLnqDNEgQvjkeDn/QWqQjrLNlL7j+bYTFgUZMgCwAnD0pfAbC0KuMRS52Ze6rJMH7POlqiyJWvswc5goQ3hRLlQpT92tL6ybrIy9Ag4Dh2UQ0gm4Ol1AeLEA82eYMaS3QA5HV3V7ccOqg1CYYcgTuJ3gtt65pSNw3zN+H7+KwjTrRYFvEH5TKJ0kK4nFSfpRrTH03eFADKKoi47JinOXSWLe2GhTodQBtMElGYVK/XTY9PV0eqQJoOaugJS34xmxad2BGpRWFwyBLJuQRpiMKJ0Ie4DWi/O5yxJSO7P3BBbcsYO3sv86vefOSQSfyAmgBE4fGet5+i6+70szpj/BufeviiYfoWwluurFjcH2ccZODXLd0nDmHraKA8jtUt6++B7nznsm9I55zKWcyTOjpsNp2ZV1sQbIXlafeQURmyLGZg2b14wv0rJMW80tgDLvG6NpU83648QzyVg+Se4QLG/JRHU3p+jJVM9tMOgFhJqTjXlxoJvcBxhjgPSz8y5I0xERvOD4gDClhMFVqfvq2K+43JjeyedxdoNbP77i3+So8KkZOE55989JxwiIWed8UrA1izzeyEpKBsjQ72yGBdNhajVh6KLJOCTFV6e5den4B+85AY2gU/owt9T5+rEZNv3l+6bmGMMNDeY5X6/G0EmEfVJ6rAXe0obHoOe4toJExNduzDb7AxiiAgrGR32pmprJO+PFLrMVnYvYtpbc3+ZsAKJQbHdyWvnuENn6rXPBOpArw8f1EAKYPtCEnDtrgyEGThO8jqwmHfTP80ly/7+fvmA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(346002)(39860400002)(46966006)(36840700001)(40470700004)(4326008)(70206006)(478600001)(82310400005)(40480700001)(8676002)(6916009)(41300700001)(54906003)(2906002)(26005)(6666004)(70586007)(316002)(40460700003)(86362001)(336012)(36756003)(426003)(83380400001)(47076005)(2616005)(186003)(66574015)(81166007)(36860700001)(4744005)(356005)(5660300002)(8936002)(82740400003)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 11:04:41.9968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee88403-f68c-4600-59ab-08da59bf2afd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0188
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de> writes:

>  drivers/net/ethernet/mellanox/mlxsw/i2c.c                 | 4 +---

> diff --git a/drivers/net/ethernet/mellanox/mlxsw/i2c.c b/drivers/net/ethe=
rnet/mellanox/mlxsw/i2c.c
> index ce843ea91464..50b7121a5e3c 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/i2c.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
> @@ -656,14 +656,12 @@ static int mlxsw_i2c_probe(struct i2c_client *clien=
t,
>  	return err;
>  }
>=20=20
> -static int mlxsw_i2c_remove(struct i2c_client *client)
> +static void mlxsw_i2c_remove(struct i2c_client *client)
>  {
>  	struct mlxsw_i2c *mlxsw_i2c =3D i2c_get_clientdata(client);
>=20=20
>  	mlxsw_core_bus_device_unregister(mlxsw_i2c->core, false);
>  	mutex_destroy(&mlxsw_i2c->cmd.lock);
> -
> -	return 0;
>  }
>=20=20
>  int mlxsw_i2c_driver_register(struct i2c_driver *i2c_driver)

For mlxsw:
Reviewed-by: Petr Machata <petrm@nvidia.com>
