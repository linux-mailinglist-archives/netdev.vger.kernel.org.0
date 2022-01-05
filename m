Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254EC485B71
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 23:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244793AbiAEWNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 17:13:37 -0500
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:15430
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244876AbiAEWMh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 17:12:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqAUUyUGcAM2gIA4ojLiY/ferZwWoz4zJnDPqtMRWXIhs7nw0mp6XjY/Yql9l+WJm0AtSe480QwPR5oI5xXL7X+yzv6qYSqo26l8W/xkDDIByJa6fWj8Z3pMR3SMqroW7Zr2CHPu3cjvwFnlTHWS45fMK875LR0iFy6MEZCna0osVCzrVdgwRZaRS9RUpf/UTm1MboCteM9PPf+Ile9uroKSrje0KRpTVr0XYI00fT3dIvZB+4Jt+zuowTpFl9qB3aDAEaDJFCxI4dWF5ctSyUoVNa+++eeM1zZRrcfd7MmJ2n68WnH1IRldfNwz6NXUAhVAr2178IuIfpZVxKCFxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6TEjaMxTOd0rchlaAcFHJq9Ii1Tx6MHVmWMUfI0/Wg=;
 b=goLIEzfDqY+jHBn9u95u9BvLYzUyGD2CsZu9SQYvgcSwNpN4RuB7ka0xAaXFScNHu3B/e/KXQs2rGxuXmQm+OTuuXuxkN4vKYeaPoYJKGHbicA4I4CwEkDtYZyLCdguxqXIAJCoThIvW3C4MkPI3gRoDP4PCfBc7OCkgATGjK2zB9WSmPFYMU9Zlb6n0+/pAEu6h8gcwnNotO/zjTmJyxhT4EdcCChUTlAvorR+veJzXJ/aWgd8udh3k5/tqgWswGuwZ4ZpqbgFhYvVNhV74hB3S/OuTpgeTejVuzD6dvYTS9Dmf6mfdoNNt1gZawcKpSnbIPn9Ys5jJLLBGYvQigA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6TEjaMxTOd0rchlaAcFHJq9Ii1Tx6MHVmWMUfI0/Wg=;
 b=NpFIqnRG6ungynGb3GeIrPDGYy0E9YvhypM2BUi5I637dOKDFKQegfxroVecVUejAHcQFrMh7bWyKNVAVm47uZ3sDCfJHYLVDTA4erFwc2/EAcjpz5YN1hrO0qQGhZmygRqPZ52sQcdjvAuV+m4LV/jt3X/hgWMROtQPTaNx7Kg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6015.eurprd04.prod.outlook.com (2603:10a6:803:d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 22:12:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 22:12:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: don't enumerate dsa_switch and dsa_port bit fields using commas
Date:   Thu,  6 Jan 2022 00:11:49 +0200
Message-Id: <20220105221150.3208247-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P191CA0060.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:7f::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ee78b57-aed8-4141-443d-08d9d09868f5
X-MS-TrafficTypeDiagnostic: VI1PR04MB6015:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB60159B09DE07BE4EF3C6C2E2E04B9@VI1PR04MB6015.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jIEhm9vgCbKa45b3ckbryeXCLzyMmCWiMlOLnPaFpu5gOgojDKTHPX96hGhXYBDt6RGRugLRijSShKft9udh+Q5j+pHNH68Mtt+lQ6kAaTzo3nHd9xIReEG0eLtt5P8wC7zdmqGfn4r2XpOlfZDiht3VlLfahauxPOX566JnC/LaIT2zXYgU/i16OcXS1n1RW4JutaXkkix+UAvOf/wR/RLOk4nJ+U5JzjF25250j506n4sYnfrQKMtUWxyOFjNEjztTCj+8cbTuQWr0uwpqRtS1NmngYoFy66jjWXIK0+JrdxWSNRBRcsN4ABUpv/dKEG/Q7ILgfIWJQX/y2j2IfntWF/KYFWDxxeGGDHEa1dw6ofICJQK4q4M09WhBBsYzuQCIvxfDroh6J2U0Sik6mXPkBTOieDbfU9F5fLGW37WrO4BGjPbiPjY9+V0mTquOP2yE+7CGiLiPflPFrWM7kRQ7oU61kjKDEbBKE7msuYOQt28cpofSR2dRl6rJCImrcg3KvoC5yMfxgpeeh4HGWmetWkw41HPlEOi10RmjYoaIma/MHiONvmSzfI+B0odtNIGVLmjpkQ7GkjSViuDbPjdskQdjDVlZzIrH8RgQhpOlr2z7nE2d8Ggb9bTsxHOBeVCBy5cBxvZbtTam+eGuWdCvqV5hSmliBykNENbx7X6JlqmF3uV2ENrdhIA+NSl18LxTrJkW4uAN0EjTm2PJNt2sWdvym0jlQWYbooSeMZqT3MB/mGzz3NRnJxZIZpXa0gASbZU+UbMph+WOwDocOZsEk4fN917Xfd+TOoJ4cs8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8936002)(8676002)(966005)(6512007)(83380400001)(4326008)(66946007)(6916009)(86362001)(2906002)(5660300002)(508600001)(52116002)(6486002)(1076003)(66476007)(26005)(6506007)(186003)(38100700002)(54906003)(38350700002)(44832011)(66556008)(2616005)(6666004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y8LqclKRbFRv8H9CUU3oyHO1c3Gg/wn/wPNXlB7wJE2EG3cMn6so1VaSR7Pu?=
 =?us-ascii?Q?4o8xnPVIfkOjo8psCecsr8NnfVupP6Es57f1yX1TOWf8++9hysu1gYOg0qII?=
 =?us-ascii?Q?DXjPcQPZ+9syyvY3SM1aenpg2p8Gbx7qcNAcAnyOXj12n3R7bSLcbLxe3nlB?=
 =?us-ascii?Q?+RzOkXhzVVbe9eStktUNRIBGgTAxJAxkWOfDxUiMmYp6gV9+lH9Cj06xXSNM?=
 =?us-ascii?Q?tIrjHbZSrS8kXh/qH7tEFL84AfM5tRQSb796pSx6pPaRqUimNaGZ/0jm5HgQ?=
 =?us-ascii?Q?eA+qPyaUNLbMqwW+SWm48H6s+TmcNw/IO59tM330ExReDAXcWPbXmA1oCpH3?=
 =?us-ascii?Q?txCcZghGQjFElDqeVPf9DmM3x0BtN2mR9qiMVvPoNXxjKb7otBJGKU+kLfcM?=
 =?us-ascii?Q?CwTsSVA4kbOstHjDFPB87auCA1cVLnkUUWXS6bb8aoYhYoxMaApjhMGNGPuO?=
 =?us-ascii?Q?zMTDFuOsZSjIdVRbcs6pzRBOI5gDKjpvMVqvzDXNp9QHVsQ0u8os1dbDwq6e?=
 =?us-ascii?Q?ClUTWagz0awSQqxUIETZA/NKkgM3gIp6p3KipGrh35olQTqow09gGQteC5Pq?=
 =?us-ascii?Q?RHsPBKw4+QG2uWBI9xLbTbSRri/IfeFW0Rb3NKLhbF1LXfmb9T38uNuqtEzk?=
 =?us-ascii?Q?DB7kjeJrPud+lx/NRLH3/VaazSzh6wVAlspb6Ju2+CXYU7mJoT56f8spLgZE?=
 =?us-ascii?Q?yZ1Xg2pcX5zBWh1X0dRtZazkiPfgYUT1cEK5DmeQyBNCg3rAkO2jeDkEBLtw?=
 =?us-ascii?Q?++O/ps5Fu/zQ+ETKDH3MO5ihpONeXnvkLmaJZxsC/BJSSW1w6iioXfhWZ1bl?=
 =?us-ascii?Q?Dmn6ploElgJt1WlQPWMEubDy+tasf8OV4wbmoOVI+7e88srYgRadbQyT1/bR?=
 =?us-ascii?Q?07QoGLJz6aN9Id1t9/eZ9qWoJNZ1/DYwKBems/sYRqi++xzFsXfYRelhTB8J?=
 =?us-ascii?Q?rMO/LjtEbC2Vy+ObgqsWXr8d1FizN+5AyWUEwLH53J1jNuFU70BGYxjImFP+?=
 =?us-ascii?Q?Sv7kpAc2HY+eIzDxLpexTwRLk7zlCiqO7MbpweXN2R5DR2moiKovu/quzcfd?=
 =?us-ascii?Q?chdURz3uq1mg3Qbpa+H8sCfloScF7NhBj8DxZDLPK44sBsSNDRUgwiqGm7p1?=
 =?us-ascii?Q?UD74aoBNcwB5eVtb70I8h17f4JZu1IENItbYzZ6hT3O+Ao05Cw7NQq1XENx/?=
 =?us-ascii?Q?3iJmPLGbSRtIE+TORpKcsEqsxHHkfJ+ni53pk0z8exnSG/V0ZQSamZZYWuYa?=
 =?us-ascii?Q?dhrCZ6kPld2ID+RQgNjJyyjYb3y0NPbJubR+LqmNqg25SEkMHdjb480K6r+f?=
 =?us-ascii?Q?EnlLcmzCciYbcQHvAA2Uj/PJ9QIGRHp14Bc9IOM7USfHcQ/dkGIeT2elVRtR?=
 =?us-ascii?Q?LD4lFrTVyY94v2Z/FI670WLUkMH8X1Om09lTMkLeUjq8eDqrXcaQfsNoIH40?=
 =?us-ascii?Q?7+LUG+/EKI/Rru+DzjOQyDcB6s95k4s+Ud6w9+J2mv17BedAYTSLO0U5vvK8?=
 =?us-ascii?Q?PU+jhmIG6YGqtg84wOXj/qTw73N4kqQlzY0nPoeMCO17kfyQu6gaF4i8zgBB?=
 =?us-ascii?Q?xKNsxD0ftw7wEAvnCDnG2S07EZ6Gj8LfUaVjnrfPT4nzo1+bCoRJF+tLMdq2?=
 =?us-ascii?Q?9clLpVLhi8R20euIuh2WSyI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ee78b57-aed8-4141-443d-08d9d09868f5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 22:12:06.6333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xf1zTlbsEw6deLJ6a08jpzYrqaJg26Rmp0iH7EknStvITh4vb7/FwgkTZz73dn9v2B/nTsQcuQKMmuMSZgi9mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6015
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cosmetic incremental fixup to commits
7787ff776398 ("net: dsa: merge all bools of struct dsa_switch into a single u32")
bde82f389af1 ("net: dsa: merge all bools of struct dsa_port into a single u8")

The desire to make this change was enunciated after posting these
patches here:
https://patchwork.kernel.org/project/netdevbpf/cover/20220105132141.2648876-1-vladimir.oltean@nxp.com/

but due to a slight timing overlap (message posted at 2:28 p.m. UTC,
merge commit is at 2:46 p.m. UTC), that comment was missed and the
changes were applied as-is.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 114 +++++++++++++++++++++++-----------------------
 1 file changed, 56 insertions(+), 58 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 5d0fec6db3ae..63c7f553f938 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -265,14 +265,16 @@ struct dsa_port {
 
 	u8			stp_state;
 
-	u8			vlan_filtering:1,
-				/* Managed by DSA on user ports and by
-				 * drivers on CPU and DSA ports
-				 */
-				learning:1,
-				lag_tx_enabled:1,
-				devlink_port_setup:1,
-				setup:1;
+	u8			vlan_filtering:1;
+
+	/* Managed by DSA on user ports and by drivers on CPU and DSA ports */
+	u8			learning:1;
+
+	u8			lag_tx_enabled:1;
+
+	u8			devlink_port_setup:1;
+
+	u8			setup:1;
 
 	struct device_node	*dn;
 	unsigned int		ageing_time;
@@ -331,56 +333,52 @@ struct dsa_switch {
 	struct dsa_switch_tree	*dst;
 	unsigned int		index;
 
-	u32			setup:1,
-				/* Disallow bridge core from requesting
-				 * different VLAN awareness settings on ports
-				 * if not hardware-supported
-				 */
-				vlan_filtering_is_global:1,
-				/* Keep VLAN filtering enabled on ports not
-				 * offloading any upper
-				 */
-				needs_standalone_vlan_filtering:1,
-				/* Pass .port_vlan_add and .port_vlan_del to
-				 * drivers even for bridges that have
-				 * vlan_filtering=0. All drivers should ideally
-				 * set this (and then the option would get
-				 * removed), but it is unknown whether this
-				 * would break things or not.
-				 */
-				configure_vlan_while_not_filtering:1,
-				/* If the switch driver always programs the CPU
-				 * port as egress tagged despite the VLAN
-				 * configuration indicating otherwise, then
-				 * setting @untag_bridge_pvid will force the
-				 * DSA receive path to pop the bridge's
-				 * default_pvid VLAN tagged frames to offer a
-				 * consistent behavior between a
-				 * vlan_filtering=0 and vlan_filtering=1 bridge
-				 * device.
-				 */
-				untag_bridge_pvid:1,
-				/* Let DSA manage the FDB entries towards the
-				 * CPU, based on the software bridge database.
-				 */
-				assisted_learning_on_cpu_port:1,
-				/* In case vlan_filtering_is_global is set, the
-				 * VLAN awareness state should be retrieved
-				 * from here and not from the per-port
-				 * settings.
-				 */
-				vlan_filtering:1,
-				/* MAC PCS does not provide link state change
-				 * interrupt, and requires polling. Flag passed
-				 * on to PHYLINK.
-				 */
-				pcs_poll:1,
-				/* For switches that only have the MRU
-				 * configurable. To ensure the configured MTU
-				 * is not exceeded, normalization of MRU on all
-				 * bridged interfaces is needed.
-				 */
-				mtu_enforcement_ingress:1;
+	u32			setup:1;
+
+	/* Disallow bridge core from requesting different VLAN awareness
+	 * settings on ports if not hardware-supported
+	 */
+	u32			vlan_filtering_is_global:1;
+
+	/* Keep VLAN filtering enabled on ports not offloading any upper */
+	u32			needs_standalone_vlan_filtering:1;
+
+	/* Pass .port_vlan_add and .port_vlan_del to drivers even for bridges
+	 * that have vlan_filtering=0. All drivers should ideally set this (and
+	 * then the option would get removed), but it is unknown whether this
+	 * would break things or not.
+	 */
+	u32			configure_vlan_while_not_filtering:1;
+
+	/* If the switch driver always programs the CPU port as egress tagged
+	 * despite the VLAN configuration indicating otherwise, then setting
+	 * @untag_bridge_pvid will force the DSA receive path to pop the
+	 * bridge's default_pvid VLAN tagged frames to offer a consistent
+	 * behavior between a vlan_filtering=0 and vlan_filtering=1 bridge
+	 * device.
+	 */
+	u32			untag_bridge_pvid:1;
+
+	/* Let DSA manage the FDB entries towards the
+	 * CPU, based on the software bridge database.
+	 */
+	u32			assisted_learning_on_cpu_port:1;
+
+	/* In case vlan_filtering_is_global is set, the VLAN awareness state
+	 * should be retrieved from here and not from the per-port settings.
+	 */
+	u32			vlan_filtering:1;
+
+	/* MAC PCS does not provide link state change interrupt, and requires
+	 * polling. Flag passed on to PHYLINK.
+	 */
+	u32			pcs_poll:1;
+
+	/* For switches that only have the MRU configurable. To ensure the
+	 * configured MTU is not exceeded, normalization of MRU on all bridged
+	 * interfaces is needed.
+	 */
+	u32			mtu_enforcement_ingress:1;
 
 	/* Listener for switch fabric events */
 	struct notifier_block	nb;
-- 
2.25.1

