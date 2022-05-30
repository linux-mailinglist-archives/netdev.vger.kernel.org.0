Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4F05376B4
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 10:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbiE3It0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbiE3ItR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:49:17 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2124.outbound.protection.outlook.com [40.107.93.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5628172216
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 01:49:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZinSrbsBMM7gBMgCL5/d6bGjef4Qi8RFwpi1OVlGoq+V+yTR9+U/PdOxHgPG3j4rY64BPIJMmL/vW1IsN7RNqKr0V1TXbPFI9bQyBQ1KY8+95en8I7EfeKSFxGC61stAX7xGDb2b6uINE2ZfzhZMZf9raam5/l81w3m8TZzRd5iptAn+PqxQl8CrdbFaYa718Mpf6pjZ532GuohyvYq92aobY0uzRIopmIBi8v4qYedwdgx4gaMHwYLxLBJxbbfur7f2+S4iLoxmiH+C0XzzPI8zxt50BCvOmtl0W3TSjJ3mspv7rciRo7VGu4DNJ1asm5ZeeyMDdbY5qKLTXjC8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SA4igGewvUtbRZCpczATOOZQyiN1EcaRzhPWS4YwTCI=;
 b=GU6a6bGdWvCvrZB9TCaLZI4njd+UYXExhKqftp5WNGTAcdZiUa8VYDZJaCkSyBnlvdjLODBCOsrjg21ZDIV2C0eSsFfurklqZhiNJmCcXt0WMgwF/18wddqyzDAfzahPo4bt0MTTbomhly3ubpDYkbUk1y2pXGrHuL3rFwyjHTozkdhxr5n7H0oeEkotiZUz/d2NBPDIWBChpvIbpv/lGcXdt4HJm+dcWfygOgQ7GsMfiI9r6YYcHd5oznDcHXNOpTMTH/D1CrA1FvW5JnTH9fFkrN1di0JnEKmO92KtVjswF13BmYg6dQXDs5BPzhzp3/unhfVX+i6wiee0uo0nLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SA4igGewvUtbRZCpczATOOZQyiN1EcaRzhPWS4YwTCI=;
 b=IMYgy8Kc8BlbuOES22LJteCkF1ROCVb+Bpg0P2PQMizW0eEOXsYqwJzz19oYZUZqqIojdbojJeqU5KRPKVIR0+ODc54A7qszIwhwhhifCz1asRKC8bFTGmQb+PD1tVpQ+U46UOeSi5vckuMG7iTRRMp88dwQXGo3my8rBIaNe+g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR1301MB1976.namprd13.prod.outlook.com (2603:10b6:910:45::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.11; Mon, 30 May
 2022 08:49:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%7]) with mapi id 15.20.5314.011; Mon, 30 May 2022
 08:49:13 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: correct the output of `ethtool --show-fec <intf>`
Date:   Mon, 30 May 2022 10:48:42 +0200
Message-Id: <20220530084842.21258-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0062.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 324d0948-eedc-40af-e8cc-08da42194575
X-MS-TrafficTypeDiagnostic: CY4PR1301MB1976:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1301MB197691DAA55867454BB36B23E8DD9@CY4PR1301MB1976.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FdPRv0XyrLL0A6Uzc1lmma/QI2x1k1T3mSflxwGOk0b8AFjZHtgNVmpPT9N8FlRsMyT224HD3FYJEw1MIdsLobMaEaGZvuP/Mz8Aj3sfkkeuj9U0UEfdvxkaA/866EHLudkHMpKOMLtx5qEoUs9XyH4rAHB574JYS9YypubpPqK1fr9gn1KzVIJH2CPFO8MnDzDqoz7FqJAjHSe/ELQ7M9I/wISxv6JwM/D948YWyeVgWZgahIAuOFK7RMzsCOw3W7S5JQekfX7cBhxYtAB0oM33sZDil4zhpHtuabJfS2U9Lm4yQ9b0ct2kFWLSd3T8oHaAq+rXZg486FVYotSAO/rHC9sDB4Iu05jL6RWJ3tkBexAO89oTQt3NefHGTk4VS93RIH789N+yyuFZNJmgTStKXr7OzHkiu/0kzHwFfxbMsqtrtSpjRlFMricIxbtAeMjd9BjOY75/Hm/gTgTO8dsQjt1QrdH9nRC/YDH5dVsN9EYN1NeTRZxRGECLbFXpozh5++o6SZxO3Ci78Cgki35JCWJIcVk1LQwPUtXB4MSq5nbepNZThAIEXmEyPZwrD/DgzQyY9wwALDRzse1/YB5g0lNvJaG3PXg1oCvMsP3i9kjdRprrlnLRVyUWzkH0adEl7Kr82pc8Ru3+Xx9jZuzjgGjeLaeBXCrHGCYLKqUyMGUhOyGRYqdSuNnhj8Q3ErcNkpOhq1OUU1+kWWp3VVfHTEgZbyJT4gUOknnYMGu/vgMg0ORpC1Shkpf/WLT161YLuHKzRLmV9ogjKwi0Iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(346002)(376002)(366004)(136003)(396003)(39830400003)(316002)(186003)(52116002)(86362001)(38350700002)(6666004)(2906002)(110136005)(1076003)(107886003)(6486002)(54906003)(26005)(6512007)(8676002)(508600001)(6506007)(83380400001)(5660300002)(44832011)(36756003)(4326008)(66946007)(8936002)(41300700001)(2616005)(38100700002)(66556008)(66476007)(81973001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3OeTL3/H+n+Pf8RMHTf2rL1wkzBuXhGFuPZEjnbDbEiVZLtETZacVa/0T7QO?=
 =?us-ascii?Q?bq77zMVncY8RJBqEkbR+FAimNDZlG9yPclOHTfJlOeeCpR+lGZ1YzrHc+KxJ?=
 =?us-ascii?Q?Oq9aFSv+hVA0qv7l+s0fiZbWWBSkrjGtixvnaYb0b7PiEhr7XwnMwyJVBVFC?=
 =?us-ascii?Q?8qHBe1jbnLfugXDJJWxQ7ab63V1OVP6dq7AEgUBdRsSrWSXjyl8CYbzmc3ui?=
 =?us-ascii?Q?Af/k8gnbYcrT7qPFs+Uotm/r3ug/wQsVHpcS70zFlcpyaWZ6zLXXA5LBYOZ6?=
 =?us-ascii?Q?oI8jQZz52UyYN3jPETWWipWYz+coaddz5sY6K8uZDhzGFDCTsVOXfggu9xd6?=
 =?us-ascii?Q?sy3b/iJOdEbOo3vcEbyEMgYNZkQNU5QcwN6Se97tRPJew3zcTx7t7cfzyhtz?=
 =?us-ascii?Q?JNEWUiH2cbqofFAuz2ID7VzrW8MbbUquCEoeRCFL7lGWbYsOU8GyyCEXs3Zi?=
 =?us-ascii?Q?f1Cy9z7J78IgWWARRDFjS6baCb64Mm9jD+c5C230basGudJPNsteLWD1B1Iv?=
 =?us-ascii?Q?0O4ovKEDc1zS6lx6klmTNUpfkp5dH6qVXXyI67UtWlHaTkJLcc3wZ7ngyNpR?=
 =?us-ascii?Q?ukqprcCYKKWtJySlBVWHBrTQ820UC81nmlDnDorVaSTg4/Z9bJLfW6AmrHFP?=
 =?us-ascii?Q?sQsqJ6fVXa356nxldfBFT/YSNikiKAAR3pTn1qKMdYuSVxzwQGhewM1ao9YV?=
 =?us-ascii?Q?wxmqsgGot9AXpCb7DTf7aeT4V6B2sSbh+1Cha9dJ5lu34xmc7dqUAQi5AcNr?=
 =?us-ascii?Q?TAGCkeMuJQGz800Ttqczeft2iynMWOkaBKSJ0udZUAezO41u5n+5x4ItlzEx?=
 =?us-ascii?Q?H644e5TZevBHMDBZxzoQZopVZ2+z+lfO8Pn5WLUQ6CWN1Sh4PP/DgbPkScFz?=
 =?us-ascii?Q?8m4wC7Ac9zeojIrwWZMWqzC+NT8zUO12fAMnLmMGtPtLIQ/162r9sEp3wzA+?=
 =?us-ascii?Q?OqHIHmdm9CSFMiDrkVgoDpB8AZj7rjdpGLIpSslKwrkB7jqZxbEVeJWq1eNE?=
 =?us-ascii?Q?qCe3U+1l8rBh9EUpI1oa/JN0WBZk1Cag8SUylLW4IaYeUwY2P4e20pmdEaZh?=
 =?us-ascii?Q?0sf1t6vUBlGSFlbJ1MQRtGXT1VZ367dY7zrLQwmoY3/YZqVcF6BP2teCEb6C?=
 =?us-ascii?Q?XwAhvWlPY9OoKEdJBid0f1dHgj1lcXOPOwPPGQqt3EFoWzFgnClMkkEiKAPx?=
 =?us-ascii?Q?4sQUyEXrWuJQAPOHJnNrarIYsbWJR+cON5PYmOa7Y4XIKgXOV2KPi7JJTwyl?=
 =?us-ascii?Q?noq8PkmbOmu25Q+xfyDoAJ5qhuQzvp8YLrXHKI47vRZQg5aGuDIOpViYg3KP?=
 =?us-ascii?Q?Lv/bm1cbQyrEDsoBZ1wmwCHjSYq5YorepMWkilrKxs7VFNN7D+6K59S3ctfk?=
 =?us-ascii?Q?HoHPgj1g3GQaFKydRgOiOPcPY4wkpw4RBbK7I8xKSoE5jLjjQMVh1dwSaU70?=
 =?us-ascii?Q?7MpGkAskhWWq2akkRwrI911s6K3JMcCUjVOQbjVnl2TGKmRyy3ZG28Sx+itA?=
 =?us-ascii?Q?nJRNi28mkLwoN3ZiWK+QfQV8DFrYaeJ7osKJmTp5af8MV7Vc+7JmhbdlqU1W?=
 =?us-ascii?Q?g6XbmfWdBOS77KFGG3H/8Ss5WiAt/iGEa5IiCJvrxruQL4tBJ4oKkc2be9Df?=
 =?us-ascii?Q?nkIi6oje0eRJ9vVIL35hTKmx7FsO5KSl32n6HFLC/e9/Fkp5d8kLOcA6L2DM?=
 =?us-ascii?Q?ujWddmJtp/2JqRyTATcHYPOr26JRPHnHHwMV10HulFIpbwSqo6ZX5xJ3n53I?=
 =?us-ascii?Q?N68r7dT9v3XGDHdJtz5BCESL0WSDUBU=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 324d0948-eedc-40af-e8cc-08da42194575
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2022 08:49:13.6285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GGv8PHXZQaftq2d6kyBBuGrIVg9HNkkqzmmSrFqz2jVjdo9iRs1KnL5lAP/IRMLMTG8uGmklLHCOwVXdpTgomEHQtnC3qi6AjryM4i6gnIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1301MB1976
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

The output  of `Configured FEC encodings` should display user
configured/requested value, rather than the NIC supported modes
list.

Before this patch, the output is:
 # ethtool --show-fec <intf>
 FEC parameters for <intf>:
 Configured FEC encodings: Auto Off RS BaseR
 Active FEC encoding: None

With this patch, the corrected output is:
 # ethtool --show-fec <intf>
 FEC parameters for <intf>:
 Configured FEC encodings: Auto
 Active FEC encoding: None

Fixes: 0d0870938337 ("nfp: implement ethtool FEC mode settings")
Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 4 +++-
 drivers/net/ethernet/netronome/nfp/nfp_port.c        | 1 +
 drivers/net/ethernet/netronome/nfp/nfp_port.h        | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index df0afd271a21..115acd4b963b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -842,8 +842,8 @@ nfp_port_get_fecparam(struct net_device *netdev,
 	if (!nfp_eth_can_support_fec(eth_port))
 		return 0;
 
-	param->fec = nfp_port_fec_nsp_to_ethtool(eth_port->fec_modes_supported);
 	param->active_fec = nfp_port_fec_nsp_to_ethtool(eth_port->fec);
+	param->fec = port->fec_configured;
 
 	return 0;
 }
@@ -873,6 +873,8 @@ nfp_port_set_fecparam(struct net_device *netdev,
 		/* Only refresh if we did something */
 		nfp_net_refresh_port_table(port);
 
+	port->fec_configured = param->fec;
+
 	return err < 0 ? err : 0;
 }
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.c b/drivers/net/ethernet/netronome/nfp/nfp_port.c
index 4f2308570dcf..73f7bc8add7f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.c
@@ -189,6 +189,7 @@ int nfp_port_init_phy_port(struct nfp_pf *pf, struct nfp_app *app,
 
 	port->eth_port = &pf->eth_tbl->ports[id];
 	port->eth_id = pf->eth_tbl->ports[id].index;
+	port->fec_configured = ETHTOOL_FEC_NONE;
 	if (pf->mac_stats_mem)
 		port->eth_stats =
 			pf->mac_stats_mem + port->eth_id * NFP_MAC_STATS_SIZE;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.h b/drivers/net/ethernet/netronome/nfp/nfp_port.h
index d1ebe6c72f7f..fc2dfd2d01be 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.h
@@ -50,6 +50,7 @@ enum nfp_port_flags {
  * @eth_id:	for %NFP_PORT_PHYS_PORT port ID in NFP enumeration scheme
  * @eth_forced:	for %NFP_PORT_PHYS_PORT port is forced UP or DOWN, don't change
  * @eth_port:	for %NFP_PORT_PHYS_PORT translated ETH Table port entry
+ * @fec_configured:	for %NFP_PORT_PHYS_PORT configured FEC encodings
  * @eth_stats:	for %NFP_PORT_PHYS_PORT MAC stats if available
  * @pf_id:	for %NFP_PORT_PF_PORT, %NFP_PORT_VF_PORT ID of the PCI PF (0-3)
  * @vf_id:	for %NFP_PORT_VF_PORT ID of the PCI VF within @pf_id
@@ -75,6 +76,7 @@ struct nfp_port {
 			unsigned int eth_id;
 			bool eth_forced;
 			struct nfp_eth_table_port *eth_port;
+			u32 fec_configured;
 			u8 __iomem *eth_stats;
 		};
 		/* NFP_PORT_PF_PORT, NFP_PORT_VF_PORT */
-- 
2.30.2

