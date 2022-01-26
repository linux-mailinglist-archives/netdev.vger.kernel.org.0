Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B225C49C7A1
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240025AbiAZKcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:32:24 -0500
Received: from mail-mw2nam12on2053.outbound.protection.outlook.com ([40.107.244.53]:38710
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240017AbiAZKcV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 05:32:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dBZFz8QlBUkMIFTeX+nAi/Wqe3FmzrOFmjmqNSDhzv5jUKUF3fEKYRAW1XNuGtUYasQFi2LGntJvMS8j/lxLi8kKQ9oE4EvB2PlqS0IdFFb9SnjFlu87se5FxEFC5B9y1PUf5163YYHy3PI3bwQWWDDWlsfQ9Vf2dUzSR+86tKshtGDXTsVU2XIhMrYOIdiMrDRtFe+Ue1okbwbgVPDPcatEYsu53RYybijdt7kK8skxRQPbF+COd4HJQ+que72JPu3T7EPAI3BK4Rcg53oSEJxDIsC/ThBWvN8cyrB2e1WCb84H8t9V64G/jGBIamwhHeV6zzGFWUXTCwmmeoyOPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gxMwLKZe8RZ4OKhxyiu2wixQuuaaP2gVGCtxMgUG+no=;
 b=Z8gxUJqcA67ZsEppC8bp4HR55lF1rB9So2eLMgyDTNzKUfeZNl3zRCfXcNtKC0nXSxZgC/rSinS+/IQuMtcLDPgRhhWCnm2IOE4il31hlAyYk4oq/8BKzPSE3eEKkptXN7Sqdj+ftPLwlnXFRiaH9x/nUkpNMvIfGGBnptj8+jjU8x5sTJmKeK4V3v2pWumSD33u31aMdOriVUzpQ+kPuCZFIDDYF1wk244/CiLZ0JyqIkFcgRSDLl1F7iVS/sS2SMt39kNRRiIymPDecWJY85b8Q61tLom7qXJ0fagV2rVTdlWoEkc1zIvSUNv+LHwRkDX1VTA6fo/ZxF0L3OSbGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxMwLKZe8RZ4OKhxyiu2wixQuuaaP2gVGCtxMgUG+no=;
 b=BaocvN32OKSF7+50SFHG/SbT8R/WoVXiqH9uB+NI2gD/avFsl1B8sI/5d26EAenCAa+WjnZWiIwg9avtbsEjHQDMs1tLZ/MP0hzw6x8GGCJL0HMkwTtBLCKtyCPuph/h3YMXrH4AFZyzyXxluEcX1hsGRn+0mgm0oPqkKQFUaEfhdqaK3zxQNFQZSt8nXMxxTD3FsD8qp2pNmLu5BhX3ydRTXKfrR9XQyw0TdfNTbq+7wxgK50QI2gl1bn0KC12HpaHeVbkXgyc+u7xYlOE8K5IaQCy81Kro7h57GCED7ymMsfA6hi+8pmfywecoArPzZuKhf+50h3tyj9Q1n1hE3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by BN8PR12MB3620.namprd12.prod.outlook.com (2603:10b6:408:49::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Wed, 26 Jan
 2022 10:32:18 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.017; Wed, 26 Jan 2022
 10:32:18 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 9/9] mlxsw: core_env: Forbid module reset on RJ45 ports
Date:   Wed, 26 Jan 2022 12:30:37 +0200
Message-Id: <20220126103037.234986-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220126103037.234986-1-idosch@nvidia.com>
References: <20220126103037.234986-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P189CA0015.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::28) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c40c98e2-f48e-48ab-d503-08d9e0b72063
X-MS-TrafficTypeDiagnostic: BN8PR12MB3620:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB36207562659B0532EDFCA3DCB2209@BN8PR12MB3620.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aPe0y/bbuAFh4SyEOygpK4/PYmhBdzyOmJiJtkYOSZ6+cvSu5VupfVlbSBsxfcV1OMiM60FWVsrHK3DYZW6RdgwIp/Ai8rGP2j/VYUfioXdldWRJyQnDusw10/APXQlZuQLJUWbse/4gvnUYOOVbSknckTbuv0myM2/dC28iPIBh0lqP8Nq6UVU6DfzLQvXbNKMOv1n5sNqLfCVgbHHLtX+EcS0ayYD+WEYTGoF/ak9uM5trgroGU13MJCC+BfY57pVvs5QYVktcw3hjAcG8RQxoCYg3b90f/T2YtE7GitoD2C8/MALq3eOghBTvTCN4aJqgdIVZaeyAj1qeU0uyEzpwcdfStOp/mXX/MnoseotPNAbrIp6VPslQ38PSrrp6aOdoVUiPbg+hbxAe24FyoV5XWyLQ2k26z8yyglUngDn7Ms7He2z0yshS06SpPYUH269BjQvlnOqlMpJG60xhJtWD2B8/h4f656KJrypk/OEIRaMjnQgNQhwVi4cOdDyxBIZHW2Zag+R8EM/ojIUHisykQ83Y6znQMzvdnEIfVrQWJeDKgdCyUr4MevKSCEplt4jUNQ/5nIQ6XQEk20b7xqSo658RoQozctQVTTMO/BaFbkqGXhTb88TMBJ8gMuwodlvCC3J2TUzH9GqjOWllvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(26005)(6512007)(8936002)(316002)(2616005)(508600001)(36756003)(186003)(66476007)(38100700002)(6486002)(107886003)(6506007)(4326008)(6916009)(86362001)(1076003)(66556008)(2906002)(6666004)(66946007)(83380400001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wn4/Quj6oEns9waqSBLJtPkdX2bJ53dzkPx095wxXsrLgYlu8QVUzGOXgwYk?=
 =?us-ascii?Q?N+0tBVbx10bxnxmcLWaSELIzw8G4Dp2gTawPDYRU6k8Fh43HWhEYHoPTbqZB?=
 =?us-ascii?Q?i68szy4h6EC3MIa6p3R777P8KgWzTOZ090gyz/tdWKgD+rTCEBXHb7P9zt3s?=
 =?us-ascii?Q?qia9FUbRNDHc8gnKCTef+LaMGw8tpwEDdd9hLmsksUGI5roG7aOCwzIaugwy?=
 =?us-ascii?Q?VsS0axU9bnN1jR6Jve7h0VuFFozrgYO6FASK83fWHUycHSLMG8lxmUTvuWVJ?=
 =?us-ascii?Q?cM16fJznucaZ4HHt+m9FcAJwLpSO/cqDt8omW0Qno4WAOWEPF7vOhfhKDWaI?=
 =?us-ascii?Q?7ZgaD9o3WgGnHzPRgYK70KUtOZOvE0VJunFSj2q0xujSxvCT+IeKAV1O5gG+?=
 =?us-ascii?Q?fWuswztnxL0hNo3z541OyzHLGFv2OFkuuJZvnaI1ImCRiPiBRZLfqpZpQM24?=
 =?us-ascii?Q?FUQ7tT12xA7rig05LroVfI+R3qzgEqsfsCJ1nWSH274LByrWqor0HMa7ELtW?=
 =?us-ascii?Q?PUELE49Oe7wRNKxozG4ECt6cUaFDGI7iCFTkKZOrymYqWjIl0jpVp0uddkdk?=
 =?us-ascii?Q?9gKFDeBnF47XMvrWLK+S2rq9dA2U7EKt96RdvMWTllo5WofSqnwmx4KChLN6?=
 =?us-ascii?Q?AulN5k7PEtUVFmEJjHKxxKd3FAFGZUx2dnXzYqlY7ZkOHIwfpRIVfVm+SL6L?=
 =?us-ascii?Q?RMUpF4SVsIBp+jON2BUF4vAhvQpn4/HMkqrWFzNDNiE2UiQ5kDFGxdlbbqnf?=
 =?us-ascii?Q?nUlyAUANZalvQFBOXVHKP+xQCdiQtIhmwKdPlQyMkD0elHywHTkWw/cE248D?=
 =?us-ascii?Q?aV9xo9g2OLC7lvN0XpwHMfiFE/AkH/9mSG91PX8si7k/E7aBIpA4bxNHJwl8?=
 =?us-ascii?Q?nfJE2zCGrHwddjYWp8Bq2qotDhFl8XsWhGaWf6dunkVZNdMAbmuYonJPpzFG?=
 =?us-ascii?Q?fyrgcRDxWp2Qcn9xHVCCPFomStoClxTt+sdBB8ECFiuwNLbKheRxQuftOQRX?=
 =?us-ascii?Q?yQr32pK6UrV4PO+hi/B+NhOGH3Js3YLtYKa40y9Ayd1+RXSkFijL4npgHwIw?=
 =?us-ascii?Q?7jy15GdBG+s3uKsl1nzHDcAucpTEWxQDvDt5V5HefaZKb4CphC7ki47oakEA?=
 =?us-ascii?Q?wfEZa2bcyDel5QpayqV/uFluvJNwgxLvmkziX8pk2Ai/ZZ4IqQjP2R76mDer?=
 =?us-ascii?Q?CH56hlAaAVI3bpo/ZNYTlYh3uIHee4oRhiWEvjwcua27ovLg9mhXEQFddCLI?=
 =?us-ascii?Q?p4WOcnb793AOZklvcKZLvuvGrVZKtce1ItnbXCfwnsvr3G463iPyB/5wfurw?=
 =?us-ascii?Q?mZftBBEIPdO22gzia5OARELcBtRMSnjKnI57SmWuZRtcWTXeyjVXykT/2AzL?=
 =?us-ascii?Q?vYxUdIO2S5R8BUJtJhIfdLOi1I8AJBruFPVo1iipcsdx0LHrh2Wxrnai8QLw?=
 =?us-ascii?Q?I2BNeknnLCmJGKLTayLqzUFTejA6CXdtOp2mR0Tx2ChraCMW1FFOdZ3m24of?=
 =?us-ascii?Q?AlUl6pW5bu6Fge+C49pbPygJAepCLf45n7jdQH6bgWc/B1+LkWPUNo667iHm?=
 =?us-ascii?Q?5/V48dQNnGS5Ssi8kY7rf3NHCnxub8tRzDjJZ2XfgF5UHL+0fyqR98RweRMk?=
 =?us-ascii?Q?MYX/+m4lv2Y9QeYpX3ki8sg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c40c98e2-f48e-48ab-d503-08d9e0b72063
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 10:32:17.8092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWRuxUT7WciP85USpbJ4/MeBW8ckqqglFdNVPmMtCWvlRT+hknEYlE8W4oeSaluVaFVdG7Ag36cxHoaDuuCdsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3620
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Transceiver module reset through 'rst' field in PMAOS register is not
supported on RJ45 ports, so module reset should be rejected.

Therefore, before trying to access this field, validate the port module
type that was queried during initialization and return an error to user
space in case the port module type is RJ45 (twisted pair).

Output example:

 # ethtool --reset swp11 phy
 ETHTOOL_RESET 0x40
 Cannot issue ETHTOOL_RESET: Invalid argument
 $ dmesg
 mlxsw_spectrum 0000:03:00.0 swp11: Reset module is not supported on port module type

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index b34de64a4082..4e3de2846205 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -467,6 +467,12 @@ int mlxsw_env_reset_module(struct net_device *netdev,
 
 	mutex_lock(&mlxsw_env->module_info_lock);
 
+	err = __mlxsw_env_validate_module_type(mlxsw_core, module);
+	if (err) {
+		netdev_err(netdev, "Reset module is not supported on port module type\n");
+		goto out;
+	}
+
 	if (mlxsw_env->module_info[module].num_ports_up) {
 		netdev_err(netdev, "Cannot reset module when ports using it are administratively up\n");
 		err = -EINVAL;
-- 
2.33.1

