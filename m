Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB6349DD3A
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238168AbiA0JDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:03:24 -0500
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:31201
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238178AbiA0JDR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 04:03:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IxmwyIYHWAekciDu154vqV9Ckrf3iwyu+Wipqk3jQGq36gQH6Rs9yYpMKQLZbVI5CFUlYacg2eGg6pLSLDBtgZEcDUZixtHr5gf3c+V5xC+NhJrh1h8l2svylsA5+8eC/1H8pqS8NF9ywWZ74v/5JWi1jkOduJag/UX57oFrS6l6N/oQEtv22jJxQ+bKlyfAD4YmMvtJcj8FzXnLTKjQ0sOo1A5fwayZimwDEFsEzolw8jpVuM6EsG6NKBoo9bkrwuCSQftzwsYK4E2jYXPXTh+8zJRbkblA8AfCM1we1X7ykNgR7c399zlXPipTfcvLvBvD+LrcVRWsd5xLEhKvbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Owhrqpujj+IDO+TYtvw4rn796TVnWYyHPWru+u4aAMw=;
 b=kcBVVFXNjLJx4yZotu9fUjzu5NRU7QWSyJR6tNUQfTrrxdwTdNuVNBqk+eLg4+CTYA3eQ5wSGON3bVyV//Fkc53XF5JrSFiDBfaQLhmUcLqmY1Wm2+RsXehXabaVWNKXXJ1oAz4pQprCUGJ7Qziz7nks3bBQrlPlCGHcDPe/pWVm8ekHrkEYyrd9uKX8U6htxDdYMWArtvNhvYN66PW1jAmnhiFV6oRnyVkz49RU4xMOcnQfTfzAZcfkTf9oUY8elYybxna/o15H0T9SMWVkp+LmuCj1U2kxZg73NI9+UATQ5zTRNJ+HzUkc5egyQWoTb5oeAy/SaKmZ8NWsz9ioFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Owhrqpujj+IDO+TYtvw4rn796TVnWYyHPWru+u4aAMw=;
 b=RuVCucEvbi4BLgi8jIzJhzIySXaZRhPUa9HeDXuL9WKzopRt0AgqxBIXj15JS+3GIohnK7oVBp7H4jAY+KUpFIFLikHhTpmNPYHh5BVCSpTqfyllciwkyl+gWgUXgHH77QSw0VOn7zsI7m3DbjVvHsUOkaxLKz726OP+OwBC93qGhv32q2auyWocgalDnDY6jlCIN94nNh4YI/uglsQINH63twZpPhZeNzCdu4APUqvWwcw9JSq/ovyZppoiEI0B6cFBWv/CIqGKgeVeGs7ws1hrzRnu6JcOczTUPMn5EcsHuY/QhY3MQo7MLmxz1Ij1yikCMlHPTbtIqtzYE81CCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by BN9PR12MB5355.namprd12.prod.outlook.com (2603:10b6:408:104::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Thu, 27 Jan
 2022 09:03:13 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.019; Thu, 27 Jan 2022
 09:03:13 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/7] mlxsw: core: Move basic_trap_groups_set() call out of EMAD init code
Date:   Thu, 27 Jan 2022 11:02:21 +0200
Message-Id: <20220127090226.283442-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220127090226.283442-1-idosch@nvidia.com>
References: <20220127090226.283442-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR03CA0048.eurprd03.prod.outlook.com
 (2603:10a6:803:50::19) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d211f9b-562d-4dc1-b0f3-08d9e173d8f7
X-MS-TrafficTypeDiagnostic: BN9PR12MB5355:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB53555CF0C8B35FF7A639E6B1B2219@BN9PR12MB5355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:85;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0OirGOmj+QXZj00A41N6xHO/5LJbb41C4DMJkCsXobNpGo4CUQe22ikpbMVaPLsxwygcSMWScdFWSuQm4vRh6+OCIiP8wQ1Yqr8LUxUJpuL88K74HRwF7Pp8+zW+01F6zuTnOX7l/SEMI1MwVHLVOTXO8JcW9h51h7Z6/F8u84xhJ36JcKHvdaANTcQNucrmjOkdWUW8ews/K6OGWb0N2D26NI1TO9q88+k+dAWEPIygOvpDWtIU2TeiX+fw59EzE9k+Jrq32SGgPp7aBrVj+MnGTgTaooSn5O8tR0FV5f7CczsJtv0JnoC5D7RZzWRADYnuTmf/uUB1+D4p94lVPW8C5nSkCoFXhz5dvh65aueIO+yQBFHxbUGJfN1IMIp5mqXIeftO2hhrkzeYGpa4fA5fCtHM+VkHt6YYZMhzQBIMzeMSbYAX1W1YJJ/xSshEajvu+ZUc5LLn1g/ArQJd0wmO7xZVyHg2eNU0bB/843y6r++X8cdoJ1aQaoSBzmr7XlkVjjsh3EDHgtjDmdAXHo3ki+AwyJN5v9u7RkGhS+GYQYOddoyVQkHd4Ew8q6rbuP23ZdMDiMRdbsCwgxXXlX06j6oGzC6eSftMC6PJuBTsKBeTSJxyQaJ8UBELISPTsCepDXRL7rBQet1/LbYP/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(2616005)(6916009)(4326008)(8676002)(316002)(6486002)(66946007)(26005)(186003)(86362001)(1076003)(66476007)(107886003)(508600001)(8936002)(6666004)(66556008)(5660300002)(83380400001)(6506007)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XMi02Ddj5nCJOXkCJ8wfmOXB9IDek9qBASJYiJTJsTGIS3lcBK2YKkiQlVcu?=
 =?us-ascii?Q?4mw2SAUcAUZONLKzJe4GS+JZW3DDlyqRmpCFsU98ipkKLeaSQ7rhnxavqUti?=
 =?us-ascii?Q?dhv0dFCT9fXC8V+aAQLDs5KfRwGf2SjlCjCPV53B+asMUzcmmKfRqoO54H3c?=
 =?us-ascii?Q?hBkHfQopBGZGH3xS5nr6bHEnck1l56XBzMvNfmfjDzKilPTDtHQWTwyH9FR9?=
 =?us-ascii?Q?g5ll0EVFCXobV1lODvqOwePwLSBfwI+NMHG0uG3tjTYeP3FHLBfbvloOzVpM?=
 =?us-ascii?Q?PT5sHPjP9zd4RBIw5cdKeJA0BKLzeXU1RZLGibc1fFUjlcyVc8mE6LDoF2aV?=
 =?us-ascii?Q?xew2VNQY/Ba2MdG4RLAQs4LGh4oKifaVQKTgPqN0kgNM3p+3gckEONLi93SH?=
 =?us-ascii?Q?Eo7ZA+vSgqcco3Cko2HIWrx/wlvroaUMAhFFJJ/BnET+UnkCRN9OAMYDiDjX?=
 =?us-ascii?Q?c4lrkHmRugTbiH8M4Qqxkalg6GH8VlmFu8+DePVOIXmbJhQnTlfVOENQhDTe?=
 =?us-ascii?Q?mCMq6h6VJ5bQsC4nEZPEc6+Sfrg0naiDtFKDaFdl/mOvgESdcA/qjAHw6bWg?=
 =?us-ascii?Q?AZP+g4ImSVrAqZAkaHlFBQ6nenKtPR/Ll3uSeFPvm/fmvF82Wbko+RN5JjyA?=
 =?us-ascii?Q?t3wjo+bV8xuxFavqVMN7TO39bLL9HsA/6Sjst0v8tyExoNrItTks0YwbkWUj?=
 =?us-ascii?Q?lhetnvfnQACoGKsxQIW/+PmQj1THjCJyjUbiHmdF1nDKHzNIxktt1h3Akb8N?=
 =?us-ascii?Q?+hyoyGj1Ce+1nDt1/8Y1oWk3oWerYxJRTkOWiguJSAx8sOeWb6db/j61axmA?=
 =?us-ascii?Q?0RHGjc2VsLpGTd1fOXHHhZPpi8kbUfNZZW4fmHF/AW4/uF6bNCM+l7xLzO0a?=
 =?us-ascii?Q?kuJ3OhA1Eh7qDiYO4elWUm9POf3LP9lKcoyGCoQHnr/0cApFaxK3MkGCvXrV?=
 =?us-ascii?Q?wZkT12O+EpywCJ8bvOFzBJnvn9DEmP8LkbFeZfGlbCvabERSr90Sqn/Ya3IJ?=
 =?us-ascii?Q?hhHKNdasm14ky3OojD7MyY5e40R8h8S9UcltMRPJDASIZor+ZZz1gtdvXKl1?=
 =?us-ascii?Q?7NNQuJwbVUf8yijULP6SF3t0RDeiO0wSzT85NiaNjdPO/5YqrcPIFe3ejocF?=
 =?us-ascii?Q?Wlv+8NJtZ/A7dGPVkMnPa/v/7ak4OiZKulRo7O8/RC6GLxAA+emfOBEq7wDz?=
 =?us-ascii?Q?GQ5t0QCssnj2hK7AqkOs8t6IL0/8ILAbz33jDoG49aUkd18FvXZqMMLYn9i3?=
 =?us-ascii?Q?57qvVELofEiDFlxP3Rwt1ZBcnfzhoIwhffvRyxNWj4etsY9XbYrBv+yLsuOB?=
 =?us-ascii?Q?usdvWYRaS49W4M++unTKVn8po67r1kQjeE9kFFyx3EaRQfEy6BieZ+FQhW+q?=
 =?us-ascii?Q?agAT/SDi3C+11MtAh4FffZb5hQx2xHVn+1JAj7aR5Ln8mnqM6F22/B0Q4K5j?=
 =?us-ascii?Q?S+1YvBT5lUWdI3Nghp2QEcFzHWOZyECj9FshSgQ0s+KLwm7g0MaYV1Gq0SQD?=
 =?us-ascii?Q?6Z/9JsBJFpSVF25+SCbTCm0TbdiRsF44Sx7dfBIEecuGaqbQzjtQGwY/goUB?=
 =?us-ascii?Q?sV41UthcfoXn6SrRsoyMcH9IIwKuqei2oFjNYtEGhQwy4mLTwo6KFOkNUpIQ?=
 =?us-ascii?Q?8Ou1M1xYPU0r+5U/LB4wJ3A=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d211f9b-562d-4dc1-b0f3-08d9e173d8f7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 09:03:12.9579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2jR61SQZqykPO4RrzwG9CkNMXuKDJmsyNHrPJVhyu9Cd5RwUVXB8OEcK8B8OnOKFZgxx/+lmIuxYPaCeGmQEMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5355
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The call inits the EMAD group, but other groups as well. Therefore, move
it out of EMAD init code and call it before.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 866b9357939b..c9fb7425866c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -212,6 +212,11 @@ struct mlxsw_event_listener_item {
 	void *priv;
 };
 
+static int mlxsw_core_trap_groups_set(struct mlxsw_core *mlxsw_core)
+{
+	return mlxsw_core->driver->basic_trap_groups_set(mlxsw_core);
+}
+
 /******************
  * EMAD processing
  ******************/
@@ -777,16 +782,10 @@ static int mlxsw_emad_init(struct mlxsw_core *mlxsw_core)
 	if (err)
 		goto err_trap_register;
 
-	err = mlxsw_core->driver->basic_trap_groups_set(mlxsw_core);
-	if (err)
-		goto err_emad_trap_set;
 	mlxsw_core->emad.use_emad = true;
 
 	return 0;
 
-err_emad_trap_set:
-	mlxsw_core_trap_unregister(mlxsw_core, &mlxsw_emad_rx_listener,
-				   mlxsw_core);
 err_trap_register:
 	destroy_workqueue(mlxsw_core->emad_wq);
 	return err;
@@ -2122,6 +2121,10 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 		}
 	}
 
+	err = mlxsw_core_trap_groups_set(mlxsw_core);
+	if (err)
+		goto err_trap_groups_set;
+
 	err = mlxsw_emad_init(mlxsw_core);
 	if (err)
 		goto err_emad_init;
@@ -2181,6 +2184,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 err_register_params:
 	mlxsw_emad_fini(mlxsw_core);
 err_emad_init:
+err_trap_groups_set:
 	kfree(mlxsw_core->lag.mapping);
 err_alloc_lag_mapping:
 	mlxsw_ports_fini(mlxsw_core, reload);
-- 
2.33.1

