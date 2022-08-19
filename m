Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A5E599948
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 11:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347988AbiHSJ6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 05:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348345AbiHSJ6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 05:58:02 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56CEF4CAF;
        Fri, 19 Aug 2022 02:57:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PcaJuQG0XkQzFIY9mgl+8irI75pfe809eopZlTey9vP7P/oR23/E8U/YKVytoUaqfTkK5SNWRZ+xSU/2s4E2gviwhz1ygQGhjuKBel3x/TOQLazYn8pvpnVw+EfQ+0koIZQlB54JYMgrvp1L0fCQAknEDc3iauRYZCVvUJ3qigHdOM1X/+l2joWd3US3jO2gFOEyM+kVWT6O01FT0bUi2EKd79aPZd0DVwulVrB0+zhZJsprgQ0KxrZ5UcdIjce36xM0LFEWywdeSaFbyKxVdgxEZ93p5BEo1IGqISPXBhVlXEWeZdhOBEzo3/J44ehuyRgmxPVVI4MhlIek+4pb3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6XHmpPXHXsN5X8FzVkM1VXaPsNM7xF7KPABsKSyEVD4=;
 b=k10dqk9iSbgC8ccrwAh6i/Wmy7FYwifHm6J93MhwvOFaTIZfqWHWCtcn2tzPdLCeKMBhB8v5lFz2FT9pYH0wylchKtlcErIFXSUSQmZhGXOdGKlFzL8Zv5zYmXAXfmh6jGHsGEjVv9YkBguWIZ475YMWKsphrwkYHDmOyiS7A0G7ZXj1kNIvfKfDllqhXsbDp6wmpoDCiryBn4Q7g0esz35l7dIuXnpSMoi/QAqVdWw0GH01hWZDv1Jh2pLLiOm7iqJ9mpV4GMHKEG8RjtFTpRY9dKwpazUW5HBWGKF0kzqfOFL2r91TpRBPUp1EEa3cyxwMtdPwzXJJiYzkFEfauQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XHmpPXHXsN5X8FzVkM1VXaPsNM7xF7KPABsKSyEVD4=;
 b=NBUetO0dqeW17KPo4n7HaVHQ6ux8MnZH5zxzZz6OQnNnuEQhWR20eCEZWqJlUUNJ6ws8vb32NT18Oa+RDeZYM0wCgr7KGdL59KOl26x4YtVexRHtdUJ2paH0iyS2BXgchPPu5sJM2AWUH2+09XU5HcglMEtF+UW5tVuIDkRgw5R2K5HWG4y8FuYsiGx37cNy7s3vPwCviMPDBAljvdNSB7SldUW75YqRxNnoleGoNTFi/ZbT5fY+vuWGFg0n+udy+GckRhzpU4hjK0BCMxFWHkWUCldcHifNY5p5e6erRWvDxBB/FvmddfHlPLQUW4tL1Rio8B/6CWNYXKAtmSTLSQ==
Received: from DS7PR03CA0139.namprd03.prod.outlook.com (2603:10b6:5:3b4::24)
 by SJ1PR12MB6364.namprd12.prod.outlook.com (2603:10b6:a03:452::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Fri, 19 Aug
 2022 09:57:30 +0000
Received: from DM6NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::ae) by DS7PR03CA0139.outlook.office365.com
 (2603:10b6:5:3b4::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.14 via Frontend
 Transport; Fri, 19 Aug 2022 09:57:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT101.mail.protection.outlook.com (10.13.172.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Fri, 19 Aug 2022 09:57:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 19 Aug
 2022 09:57:28 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 19 Aug
 2022 02:57:23 -0700
References: <20220818210050.7108-1-wsa+renesas@sang-engineering.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: move from strlcpy with unused retval to strscpy
Date:   Fri, 19 Aug 2022 11:45:57 +0200
In-Reply-To: <20220818210050.7108-1-wsa+renesas@sang-engineering.com>
Message-ID: <87czcwmu82.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7593c910-40af-434f-9dc7-08da81c93a7f
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6364:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wWuakk+IshSPWBii1Sdot7s0Q6Yc0QDjPqCNv7fq9RrOF42257I+EzcRZcy83Dr1nsT08UKmucDmUNuiJy7wYN4KIpj/saB3vA0ENvh3o7c8/ulwiXHkcd/01MAJNdtEpBIi0Y97tKTFgeq4B7Hf4ZxGM/bWUimh5TX9cb0eTcQG0Fey7N/NcBETGG2WzSEu0ugNXI2ntH8DL2yZtx/B75OHhhvrnphPXiojAOSh6NNL79c5Uw5xhtCeisQhc/NKR7NtXuIm7dXJKQ6BkzjN6sw+5IcEhAuFrtqeU71cWHzUg1Jabm3xKkEbzdlKLWn+E4ogFoklOe5altxo9SUjkjaVgkvuCUbbnKRpb2OGQDZEAwALuhKwfo11Oq+R/e52FU40cNwDdcJYqfAtJ40RPPVSQ8IQzv4Rttv7t7QKnZ3t0+DGO4hjST2MpQaK8DCceLO14tmSfDDrgVXhuwYqttP5GzG6SpgSe49CObzNbmCf75WPgMQjrcDXFRBjArxbvYI4hz2VAxnVZdEakozwpQuheIpdKb2PcQuXkypYwK4t5A+ERG9OoFiIKElu7LbN7laddm6YDWDJ9S82IPFFbrb/oPYjC9CtxjJ73Id2tZwhDAWRPMMJfwCp6k2RViHX5yn0SZs71cp7voj99JtMDOpfBckO8QhYSEQH1Fvy+KyZF1rveXkoo+RBgx6ndiPl7IjfIF1wXC1BuY2UQdkz4MZ7OAit1yy2pPO+QWEetOyN59SbHwv+92xbsMFvjEboTdVMEFmT9AemK1CaKlSXYGSDP5S83pmYFmk94dBrF50CfJGAyszbHXIUXEm9nsO3j3dXIFwTsyD0oBqeALO7kw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(136003)(346002)(46966006)(36840700001)(40470700004)(8676002)(26005)(478600001)(4326008)(86362001)(40460700003)(6666004)(336012)(36860700001)(41300700001)(186003)(2616005)(47076005)(426003)(16526019)(2906002)(8936002)(36756003)(5660300002)(70206006)(356005)(82740400003)(82310400005)(316002)(54906003)(81166007)(40480700001)(70586007)(156123004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 09:57:29.4948
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7593c910-40af-434f-9dc7-08da81c93a7f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6364
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Wolfram Sang <wsa+renesas@sang-engineering.com> writes:

>  drivers/net/ethernet/mellanox/mlxsw/core.c       |  2 +-
>  drivers/net/ethernet/mellanox/mlxsw/minimal.c    |  4 ++--
>  .../ethernet/mellanox/mlxsw/spectrum_ethtool.c   |  6 +++---

Reviewed-by: Petr Machata <petrm@nvidia.com> # For drivers/net/ethernet/mellanox/mlxsw

> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
> index 75553eb2c7f2..7331635607f7 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
> @@ -633,7 +633,7 @@ static void mlxsw_emad_process_string_tlv(const struct sk_buff *skb,
>  		return;
>  
>  	string = mlxsw_emad_string_tlv_string_data(string_tlv);
> -	strlcpy(trans->emad_err_string, string,
> +	strscpy(trans->emad_err_string, string,
>  		MLXSW_EMAD_STRING_TLV_STRING_LEN);
>  }
>  
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
> index bb1cd4bae82e..e3c045a82ae2 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
> @@ -94,14 +94,14 @@ static void mlxsw_m_module_get_drvinfo(struct net_device *dev,
>  	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(dev);
>  	struct mlxsw_m *mlxsw_m = mlxsw_m_port->mlxsw_m;
>  
> -	strlcpy(drvinfo->driver, mlxsw_m->bus_info->device_kind,
> +	strscpy(drvinfo->driver, mlxsw_m->bus_info->device_kind,
>  		sizeof(drvinfo->driver));
>  	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
>  		 "%d.%d.%d",
>  		 mlxsw_m->bus_info->fw_rev.major,
>  		 mlxsw_m->bus_info->fw_rev.minor,
>  		 mlxsw_m->bus_info->fw_rev.subminor);
> -	strlcpy(drvinfo->bus_info, mlxsw_m->bus_info->device_name,
> +	strscpy(drvinfo->bus_info, mlxsw_m->bus_info->device_name,
>  		sizeof(drvinfo->bus_info));
>  }
>  
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
> index 915dffb85a1c..dcd79d7e2af4 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
> @@ -14,16 +14,16 @@ static void mlxsw_sp_port_get_drvinfo(struct net_device *dev,
>  	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
>  	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
>  
> -	strlcpy(drvinfo->driver, mlxsw_sp->bus_info->device_kind,
> +	strscpy(drvinfo->driver, mlxsw_sp->bus_info->device_kind,
>  		sizeof(drvinfo->driver));
> -	strlcpy(drvinfo->version, mlxsw_sp_driver_version,
> +	strscpy(drvinfo->version, mlxsw_sp_driver_version,
>  		sizeof(drvinfo->version));
>  	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
>  		 "%d.%d.%d",
>  		 mlxsw_sp->bus_info->fw_rev.major,
>  		 mlxsw_sp->bus_info->fw_rev.minor,
>  		 mlxsw_sp->bus_info->fw_rev.subminor);
> -	strlcpy(drvinfo->bus_info, mlxsw_sp->bus_info->device_name,
> +	strscpy(drvinfo->bus_info, mlxsw_sp->bus_info->device_name,
>  		sizeof(drvinfo->bus_info));
>  }
