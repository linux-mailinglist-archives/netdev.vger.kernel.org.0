Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6C454FEC1
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358915AbiFQUeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354878AbiFQUeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:34:02 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2065.outbound.protection.outlook.com [40.107.22.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0125D5DB;
        Fri, 17 Jun 2022 13:33:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0YGyp72V0ATCQ1jWW/XdVwPdTuXgQ+DldbIGu3IpVoSA9VbrIpn1p84T2PEd7lQx+Cs/vIJ8CVej3l3/ehbkEoHfqKj5lqE0UYR5kexB7uw9U3zNJach/btlQOat3HOPnwuTWiCaECNBYfSWlHOfqJAhzuvbjrO/+E8ZlSex3hG22DGWgJcthv975q3Zr069oVhlCkIsaDwJowV46nY8yFA632xIBPqkHvKnnudOe0i6gnRXXVtK7c1Aw5UPhrAOQwnmTuNhuaHz82cwWEC8ONXUS3GZpPVJbC5WiOj2wb2YQQYRSli2OZRpu8Rq4G0C+Kh68YSbbuBbpr4o+E8OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m68xkMFd/AoKjcLPvwuWpU3iQVhr5xuJq4ud4EtZaIU=;
 b=cOaSoZ+KkEH2qcZs3+fq70bVDqSRciijQRG1gPGnVS4q7lidal+GI/ZKmXP0sHcsWZC5x2fi+T3FLy6sDcupkKrOsAh0BXhCpCsDtsu/a2oCubmDv/Oulyopyh2zFCx47UpHoTYDN8LmDbcIpmM+aCgX8UjICAUPmrBcAxavSdg2zZmvWilv52qgGc8Z9QKvpOcnwMfOziLIoGrb1utyk8+2wgvXZJtX3CycKp5RTv75122lFIWwfFN7FZNa4cYN5mAJZf5gBZ0HPK+cMimFGKueFa5KXGok2EPYbDRsMjXmn+c8Qmth5ha619eGDvx1wfIo8kQt2QDmQM3iyXNq/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m68xkMFd/AoKjcLPvwuWpU3iQVhr5xuJq4ud4EtZaIU=;
 b=YzrNtWYIx/yh6FiyRjQv81buZFNWDLb8aURb6m9mDXtmvZtWHT3olU+75uiowueUoQ7A4LtYR6z5B1zxsBvKgkTsDvQ+j4n+Jx/Y1GS7bEyMpkk6KG7hLyjdJG6SNwBoVma8O1QHSbYUEyeSjIzLn+DlIX9dtj1jvhruNM0WYidmIc97J+5mNwYG6yCTQUKOZgGQEMqvua4+r4/OmNB/UFMfuUxXa2sjJ1ohVZJ9ZFTEBrg8Nky7G2hUkUvkZa9P6jck+AtPN1SAw2O/C4g7otRPznXWzwhrhrz99+ZFKvysl0z/6aqPdYziCq1FPnDXa6Ez28Hxi8hC+w/aWFVVbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBAPR03MB6438.eurprd03.prod.outlook.com (2603:10a6:10:19f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:33:47 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:33:47 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next 06/28] net: fman: Store en/disable in mac_device instead of mac_priv_s
Date:   Fri, 17 Jun 2022 16:32:50 -0400
Message-Id: <20220617203312.3799646-7-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30eacf82-b138-4235-5955-08da50a0adfe
X-MS-TrafficTypeDiagnostic: DBAPR03MB6438:EE_
X-Microsoft-Antispam-PRVS: <DBAPR03MB6438CDDDFF251C9031C2EA1696AF9@DBAPR03MB6438.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EtTVloty4EVAQ2jIWW8Hv+/ExScCSMt+linDGUYtBtnQFb2SGQMwsxB4m12XQTEW81VHM65Q7fMzkmLMaMr1BqJ5DGPrmYk7lmU/+6P9HPUV/ydw9UeYluzU8xuo7fJt3GavGr7LLs/JbYAzakYz6xN4DXwDkDJV+fPGgm/og3o/bpPtw9Y0dZ9ojvN+SJQKvLc7ndHoV3nEdoJZNK9gCAVsx21UFNHNauVl/lK2uruRe0nU45DqWiZp+K6UHb9oGW+7ev9OcAp8zkgdBuJA48VSbcol1BstOqS+cVOYil9Ms1TlJO2oxkpYZcR6NycqqV89mZTOZ78siKQTze85QNXdRbsJhtyqK6Fvfow4U3dKWxF5Pv+5DpW9YjvtGqxeH71qP6NBtdgmieO4Q/KbLhKvEyk6Li7VUq34ZmzfTRMSO8+4NH4t6NRXQzyAQelV7JcACUdXwRB5e+T9M2rLPvU/vTugF1y2WrD892hWbwsbRipZ3SL9GkPlKyLN9zC4Ok6OGCYcTIJ50E+dMTHc3xqsYh4UYELK+UYPU4oqObd3d30L0rrMRkgLq/F6UEbna1IXB2cAkUCJu/KZp6y41h6AzaT0NVaswybBf60X9I0Yb4fqFESz5W/Dymm6Hp7ZxWSR4P+l6cWzQV8nzf+gVxxai83+ACdHxXgYoUhYmUgER8sY4eErSG0t2XOdyqy5ioLXFaBRUbbGieRVSgYZ5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(38350700002)(86362001)(7416002)(38100700002)(186003)(2616005)(5660300002)(6512007)(6486002)(52116002)(2906002)(6506007)(110136005)(8936002)(54906003)(498600001)(316002)(1076003)(66946007)(6666004)(36756003)(8676002)(26005)(83380400001)(4326008)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HI9z9PkIh0V6iq/a1hMdhaVBnaK9PmYgHhdEMnk3Ud6rITf9fmGjrMf58iec?=
 =?us-ascii?Q?4Sk7ZOjwuI4LWsMYGQB5L9bJ/D3fI1gaDzOyF1YrNuUQP2S1vUl0h1ZB1S6E?=
 =?us-ascii?Q?ziAr1JkLl4EC5TCcNAE06gRI7gSEFZ30m99Vi6vAPSEYlwIhBbLIojhCn9Xb?=
 =?us-ascii?Q?8S6ixNBrfXhEDYt89tO3WyHbsbiT86tnrN21KJ1KbnP1qZQv2ybUyGwSpbJU?=
 =?us-ascii?Q?xuUTfTLX7T0XdCU4TLlEUWghkhgWzX7QbCxi5hDL7Dlc5UKDLBIZQfEp3ZWm?=
 =?us-ascii?Q?7wLrr8fI1bM282GLNWDI5D/JvUW7FkbWu+J/xz9szVsAa6w3tO0Jt7Nbjl5A?=
 =?us-ascii?Q?5bGd1PeHFQWEa6Prjphj5b6/HXpWt4Qs/MygkLlL73ajJcDzunEjzR5fph0T?=
 =?us-ascii?Q?o4bF/PYyV/xztnS82tmcIk53obrfGyh7dbGnJfgTIK3JqVKn1BkyEhkj1NiQ?=
 =?us-ascii?Q?vACSoxvHpwne3wP0b4qM3e6adfCMPz2YBQvLz/pms49ihCvj+maP2/Rjn3yY?=
 =?us-ascii?Q?POe4iSk63CmrOHXp0Oo/zJxWSTXej3yLq+ftFaAR8WCiwl6tEMgsBrpzdIKj?=
 =?us-ascii?Q?9SpIGMuG1YnTaukG0eNiXZNpayu/k9iQj1GRHn6yoL5e+fjINaVQFXgZ8KXJ?=
 =?us-ascii?Q?fCpyQdQ2aqT5k4FbH9ZeBiKs+qs5l+5s5J2U5+Ohb3KVpTCBbJi9yZWFxnyp?=
 =?us-ascii?Q?syO/gLSYB0T5peiw93MaD/9Zg4jNhZH5WUw/MXXOziZ3/KynTUEnCQ53vEdj?=
 =?us-ascii?Q?8d3CL2clafvv8dVcOr6D3fOWhmiku4UoYXQQUbm70KtPOurPqjIbJxsyQ+67?=
 =?us-ascii?Q?4E7y/o7vBTiV1P3j5gZ/3tb2psi7+FTYYzovPmgoqD3FoUdya5QzRiQB6gVo?=
 =?us-ascii?Q?njoknJ1Ud4YL9myXLsJHa4a25vUEqPDtBUi9COUBzc0FvIXli+uG+/n+3R81?=
 =?us-ascii?Q?dK3CDyZjeNu6VyXcJUIqDdrKShdM8sTtjNQO+ViFx1TghEaa7JUCh4DXAptg?=
 =?us-ascii?Q?HDbCSnbZSJPwE/a5dSi9+UHavX4DbnLbOnlKU+qwmdRqhJuNw/fr7IMT4sSz?=
 =?us-ascii?Q?6rwZRKrmWwKtHBUAJuUitB1VSn/adavfNh806MBqVXn/voiL8hBXopJUxUbA?=
 =?us-ascii?Q?t0Hmt0yvS9ZSlfRyPxUwLShPQdeFccN2d8AuD+Bv6KcqbtTPkhZbeD57Mwyu?=
 =?us-ascii?Q?XaAiA9bBDwmq6GO2QcEuGxKKpFQJtd21QcICJA/lyA2Q/7g4zfeo3F7R2LuH?=
 =?us-ascii?Q?2bnkMVPanuYFAqB2gAPsBPpGJ2spFSxtbt4wDs2O5oAzM42139ead11eZuwW?=
 =?us-ascii?Q?Z7Q2OtUg1vGnwL5xw1EabeJGfyKIFI8vXmcYeywpFu1vypD0/PVR1t7pDCJP?=
 =?us-ascii?Q?83AAlycWfG8pCuwovyFFSU72dYWjeG+U65IxwI61GSJX78y1aNAVlfdnf2oh?=
 =?us-ascii?Q?mTE8VcjEFApuLxAp0hZcu1MAHsiPIcV+FXLwoe5rSUq2Hq3I3nExwHGo4WVc?=
 =?us-ascii?Q?onigYQPFbYMIDtj6BRPF+qhfk8Ge4QJeFm6Tb7UfJJ37bQyqw5LjeizFr3Ub?=
 =?us-ascii?Q?2xj5QO+oQ1gVV/kulAtecWrD8GrIKvwAXwW4MuAcJbK9pkmjLZfFGKH/nwwQ?=
 =?us-ascii?Q?fjnn0cpxotpMWYcjIloa5xvNq+/kpI/VWjw4An5fS8IXkvrDrtm9VBeG3yOM?=
 =?us-ascii?Q?pyU+T4loPsVMI417EHRyiKeYGUSuf+da5KTtSgMmt7bExZV84XpN0B+e51U0?=
 =?us-ascii?Q?ukckz+UvSFdSl6PyATB+HZBDiM0Qja8=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30eacf82-b138-4235-5955-08da50a0adfe
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:33:47.1557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 66fMePz3JmxWsIEZlpfuzOK6ld8aHuDYxVmIzZANlvApXP9HPoDiRnVxH1g6fDZ9ja3M4weOtKw3g7GxKRb4pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6438
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All macs use the same start/stop functions. The actual mac-specific code
lives in enable/disable. Move these functions to an appropriate struct,
and inline the phy enable/disable calls to the caller of start/stop.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
Tested-by: Camelia Groza <camelia.groza@nxp.com>
---

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 11 +++--
 drivers/net/ethernet/freescale/fman/mac.c     | 44 +++----------------
 drivers/net/ethernet/freescale/fman/mac.h     |  4 +-
 3 files changed, 15 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 45634579adb6..a548598b2e2d 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -288,9 +288,11 @@ static int dpaa_stop(struct net_device *net_dev)
 	 */
 	msleep(200);
 
-	err = mac_dev->stop(mac_dev);
+	if (mac_dev->phy_dev)
+		phy_stop(mac_dev->phy_dev);
+	err = mac_dev->disable(mac_dev->fman_mac);
 	if (err < 0)
-		netif_err(priv, ifdown, net_dev, "mac_dev->stop() = %d\n",
+		netif_err(priv, ifdown, net_dev, "mac_dev->disable() = %d\n",
 			  err);
 
 	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++) {
@@ -2942,11 +2944,12 @@ static int dpaa_open(struct net_device *net_dev)
 			goto mac_start_failed;
 	}
 
-	err = priv->mac_dev->start(mac_dev);
+	err = priv->mac_dev->enable(mac_dev->fman_mac);
 	if (err < 0) {
-		netif_err(priv, ifup, net_dev, "mac_dev->start() = %d\n", err);
+		netif_err(priv, ifup, net_dev, "mac_dev->enable() = %d\n", err);
 		goto mac_start_failed;
 	}
+	phy_start(priv->mac_dev->phy_dev);
 
 	netif_tx_start_all_queues(net_dev);
 
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index a8d521760ffc..6a4eaca83700 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -39,9 +39,6 @@ struct mac_priv_s {
 	struct fixed_phy_status		*fixed_link;
 	u16				speed;
 	u16				max_speed;
-
-	int (*enable)(struct fman_mac *mac_dev);
-	int (*disable)(struct fman_mac *mac_dev);
 };
 
 struct mac_address {
@@ -241,29 +238,6 @@ static int memac_initialization(struct mac_device *mac_dev)
 	return err;
 }
 
-static int start(struct mac_device *mac_dev)
-{
-	int	 err;
-	struct phy_device *phy_dev = mac_dev->phy_dev;
-	struct mac_priv_s *priv = mac_dev->priv;
-
-	err = priv->enable(mac_dev->fman_mac);
-	if (!err && phy_dev)
-		phy_start(phy_dev);
-
-	return err;
-}
-
-static int stop(struct mac_device *mac_dev)
-{
-	struct mac_priv_s *priv = mac_dev->priv;
-
-	if (mac_dev->phy_dev)
-		phy_stop(mac_dev->phy_dev);
-
-	return priv->disable(mac_dev->fman_mac);
-}
-
 static int set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
 {
 	struct mac_priv_s	*priv;
@@ -454,11 +428,9 @@ static void setup_dtsec(struct mac_device *mac_dev)
 	mac_dev->set_allmulti		= dtsec_set_allmulti;
 	mac_dev->set_tstamp		= dtsec_set_tstamp;
 	mac_dev->set_multi		= set_multi;
-	mac_dev->start			= start;
-	mac_dev->stop			= stop;
 	mac_dev->adjust_link            = adjust_link_dtsec;
-	mac_dev->priv->enable		= dtsec_enable;
-	mac_dev->priv->disable		= dtsec_disable;
+	mac_dev->enable			= dtsec_enable;
+	mac_dev->disable		= dtsec_disable;
 }
 
 static void setup_tgec(struct mac_device *mac_dev)
@@ -474,11 +446,9 @@ static void setup_tgec(struct mac_device *mac_dev)
 	mac_dev->set_allmulti		= tgec_set_allmulti;
 	mac_dev->set_tstamp		= tgec_set_tstamp;
 	mac_dev->set_multi		= set_multi;
-	mac_dev->start			= start;
-	mac_dev->stop			= stop;
 	mac_dev->adjust_link            = adjust_link_void;
-	mac_dev->priv->enable		= tgec_enable;
-	mac_dev->priv->disable		= tgec_disable;
+	mac_dev->enable			= tgec_enable;
+	mac_dev->disable		= tgec_disable;
 }
 
 static void setup_memac(struct mac_device *mac_dev)
@@ -494,11 +464,9 @@ static void setup_memac(struct mac_device *mac_dev)
 	mac_dev->set_allmulti		= memac_set_allmulti;
 	mac_dev->set_tstamp		= memac_set_tstamp;
 	mac_dev->set_multi		= set_multi;
-	mac_dev->start			= start;
-	mac_dev->stop			= stop;
 	mac_dev->adjust_link            = adjust_link_memac;
-	mac_dev->priv->enable		= memac_enable;
-	mac_dev->priv->disable		= memac_disable;
+	mac_dev->enable			= memac_enable;
+	mac_dev->disable		= memac_disable;
 }
 
 #define DTSEC_SUPPORTED \
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index 909faf5fa2fe..95f67b4efb61 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -36,8 +36,8 @@ struct mac_device {
 	bool allmulti;
 
 	int (*init)(struct mac_device *mac_dev);
-	int (*start)(struct mac_device *mac_dev);
-	int (*stop)(struct mac_device *mac_dev);
+	int (*enable)(struct fman_mac *mac_dev);
+	int (*disable)(struct fman_mac *mac_dev);
 	void (*adjust_link)(struct mac_device *mac_dev);
 	int (*set_promisc)(struct fman_mac *mac_dev, bool enable);
 	int (*change_addr)(struct fman_mac *mac_dev, const enet_addr_t *enet_addr);
-- 
2.35.1.1320.gc452695387.dirty

