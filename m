Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8359C5614E6
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbiF3IYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbiF3IYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:24:01 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0E523C
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:23:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVnoin0gNMVnNxsHY4UePlynRF/qs9WGwfZ1q6WYjqqo47HBsSJTz64F2OEAjv4MxqSL8hwZQDV9kXsH43Z7QwsFZQl1CH0y0/2OLqa0FOfdiAmj/MJPf171ZEbqdW16v01mD8IH66iUU13asHAd9KcTDCEceHMOmzpcFUzH13w2IS6fEd11c37cMIkElWqQeJMlgMgDQI2cGzPvNA1gYzdJ+wUslB7LQA7zZ+3tFWYB9xWjCUXOWjHyPQGnpMxJmIbT67P7kRhrxuZIusownrLswggCmlfEiRl6RqJodKD0WFQmfZI2JFt6KOILpFxVeTiZqn63VVw5pMV/1gmarw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sW174L0DRsQS2zZ6ecQO0O+KkV05i6m6XnpdrIIDWKM=;
 b=UF4jzHTIIPjpx3brOGz2I7RFKAexyYztXs3w98578IHNAWQE45r7ht/TNdo3/1R/+ZQv7wRSw9VxKJuBrBev/lQLM5DcwL5KMOQbQ5FxFplBfP27cjdX1d55ijigDTY1H3gRkPx1/EGHYlBuSXc5j/8+kcnIvIg6ii2nIYFNx7rzpz6QWGYnc6EP2piavDTe+yBAm9kKHNupY92VnumRJCWjIlu/QgwOi07gNYHrHexu0rKOZ6HvCyYHd9jyHYsA0LkTjLcli3M8ZcVO9Vl2d62Xso7ZrOZqvn+5qY3hQuNlh3f1jThEtwOdCylkj+JsOhkpxBhJNwUWLMc3lVAXpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sW174L0DRsQS2zZ6ecQO0O+KkV05i6m6XnpdrIIDWKM=;
 b=kDxX13XOILxw0M/mR79ZkW3iVpBhcl+2WxomatZ1sfeBvtnUAYDUxKAR1vX7Eoe0zScU5Smj1QgH3kAyadfY4O04I7qUiWFRN44TMPWlzgAL0dikqxNjbLtODE6+E68zAFbXD1IfMwn9SYZLnefBIrZfPc2CZTAp4prDj5atNwqDOTTNUONyionNZB99YXkWLmyvNgkpeo+FzJhUIfN2SXqVr++0266bZSzbUIpbeQZvRPV+FE/q7JBWLV5AAh17Ra9FkGZSqz3gNqqw/5Xs1SAuxKRoe5TTk61rTS9fyusM7bIZMuhTqW6AMSTZ7pxdt6RQiUJx6BYxww+t1d08ng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB2880.namprd12.prod.outlook.com (2603:10b6:208:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 08:23:34 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 08:23:34 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/13] mlxsw: Configure ingress RIF classification
Date:   Thu, 30 Jun 2022 11:22:47 +0300
Message-Id: <20220630082257.903759-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630082257.903759-1-idosch@nvidia.com>
References: <20220630082257.903759-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0028.eurprd03.prod.outlook.com
 (2603:10a6:803:118::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13547b41-6257-4b43-6010-08da5a71d2f9
X-MS-TrafficTypeDiagnostic: MN2PR12MB2880:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uty+AtH02qtWf4hABFeJsLXwriUnb3P7CeNEhMuBAiwfl/Lwxn1kA7Ob1mE2Ode9T/tZ8+ao1zvli7a0e7C1YuJzjthj0+J+D3zFEkLwxdeP4HZIg4fNeuU68TXYmv5S46l/CBS1YwX7+lZ4s/KZVFA5YdscoSC9Dc+HjWmNWEX7YIUnkCCC75NoCeLqlnLQPL7IxoWf8s2CBMFMS82wzWfO9Q0jRSsfUahsyM5VDSpEsxnUfIPNKifwVyH2lBoB/QYsiJNbTLUzZvnB7sDIVxomvqJeh+/X5FPEMSVT4t4cg/ZEP6bVFriuit3VjnUeYlxekSNCCSu+sKXBJiogVA5wTb2vEFCOakGDljEegbY1hlLgMoe8aeBCloDdbhONXrIf6CrbdEt8QPXTeX5lzKQtPpzVFsWoVuQgw+6uL8UdVBIqwdTNHRSqfIf+ecq1f6apdfYRVGA8XX2+8+5M2052hgrdEsh+I+G0KlBmQ0ncIciCMgYyJJxGFm/VTdGgxbtNYTAEMG6aX+xItc2Pxcu7n/EXSa0BFYve37HmeaG5ElG/Q09Ujb+ru+GNiIn2lG2dh58tDmcY5ANpfw24Bg16uQeSTdYMoB+9+FgohJMrohHRPQdFtUkjmdYfyl7FadqkJVhqbEom4lN3frTZ4Re4YHGIwdEgn1ISZWrmeiaaImV6GwQGLL7i/Ercg16uE2N4jiYk0tdozr1afibCbv5fkoL6ldQ94802tyKnLyRuEQVBXJajLjyXITUZjpyk5nZ8y4dwa8n+i/GAAkuVPrAlj005XDf2tonrGJCPbcNxVTh6Ow3Lm+A/umiL19vY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(86362001)(6486002)(1076003)(36756003)(8676002)(66556008)(66946007)(478600001)(4326008)(66476007)(8936002)(6916009)(186003)(316002)(5660300002)(6666004)(30864003)(38100700002)(6506007)(2906002)(6512007)(2616005)(83380400001)(26005)(41300700001)(107886003)(66574015)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NnWndunmleBn7zcCHl8k23/tZ0cp9V6oOBFrSSbGryPdIIEqX4JVkC+PVoXS?=
 =?us-ascii?Q?A2y08YfykNUbDC904mAJ7L6T1KbLGKUkTSDOID+Za1LDIiUPyNUbynQqCaGL?=
 =?us-ascii?Q?lMN80z3YDHTCIp31nL8f23YDapVV0KPsdMS8rDcVHRCVSAuXpbYtXsqDAN/A?=
 =?us-ascii?Q?faak3RE3BNss/430YlLgGMbehAYt3XBqwAaVbGOLXPU2vjyiEnyGWKpIkoao?=
 =?us-ascii?Q?C3Q9zJXxEj092ecw5VtN8D0BlRLvdKK5SdphQC4PI8TwhpxJkqBoP6YhRv/X?=
 =?us-ascii?Q?RslvN4J08u/ARtkuWm6bOx1OYIZndjW87w40ViJxHte8EkS9pfLGjVB72Mil?=
 =?us-ascii?Q?D7hIqQPqhRgoirW4n99TmrzFQmjgFZZSys8yZjR6hBVqfbvi/cRSyXvDJINc?=
 =?us-ascii?Q?wnO5X2LnrAJVk+o4rQvv9+AxtboEEUrI0LAXVXRryGiFoRt2/VKyjeAtBxgK?=
 =?us-ascii?Q?eGbdK/pBA40juaxphE+IYZJiLP5FnfegzATWF44Qjw5pnAP06YrZM23q3wrk?=
 =?us-ascii?Q?vmnTHWP4hoGsFtJvaAgnxtnac6ux6GX3aTX9Z1FMznELG+fKK2ZLAo1cwx70?=
 =?us-ascii?Q?279ncTh394ti5HoidMZQReD6OI4a6+x0kY5LKDhYwgGPWDFNDrBdAJgt/Z6z?=
 =?us-ascii?Q?jUPHE3C/UwCT7NgOWxIrMTMyvESGW5r7Q/6jOJNBxRFo/K9iNJoKm0GjWNz5?=
 =?us-ascii?Q?+clUi1jD8P35NUTZwGzVESvXASq4JmjLzYPMDHcb8Sn86RhlQs+l57td0ypI?=
 =?us-ascii?Q?uROEnERbm+ex8kV8VSbI0/2NCopYj4TPE3lFxwDrYsf/cwm65hb8NYHzIT17?=
 =?us-ascii?Q?IXw8ZLf6NOap9wGTMDtbHU1mkjQJkObo8KrsG1CufKeFd5MB8y9kTFjFTzf8?=
 =?us-ascii?Q?s8VxGtDrMsbgNme61TF9S5Cjr77IjTT57DvuJ49jQo3D/z6wuI/HFRfbkgOE?=
 =?us-ascii?Q?xz1Wc1zGRICaQA8DjFzdqSW3IDvsyZDGmgKPPrrWx6ejSLKQwxo2Wgxo8ztM?=
 =?us-ascii?Q?CX/HsV/4Lz95qCl2taeC4OoXlGOfNHzlYjt6JtibpMFiBfottV38apsEBfZO?=
 =?us-ascii?Q?Dg/CY81BQ8c84QiXfqEcYcAf2VhdjZR6qXWbbdReFIckXyTYo/Wa+CVI/MCa?=
 =?us-ascii?Q?TQZ2AccTdu6Hk3sOWgY8tWBw3PCQmdnsr2oB2qt/Y6fPbjaC0tDC6x4O0rCa?=
 =?us-ascii?Q?bxwcUVV8lscKIQZ1Ah0vauFY8XFOqH6p02d2T2I+WQSLwGvksDLYzumlp/eO?=
 =?us-ascii?Q?fkso+QdUYqUV+bSle+xopDCc46SudzEkFExsJojrMxp6xkPtI8ulqp2zbL5D?=
 =?us-ascii?Q?9zJSMfIItCjWy6Koq6SrqyAs1vXSEu4upbr5V+Uq9+BtO2WB93FSR3rel9ps?=
 =?us-ascii?Q?Kf+MsXelRpMFGPd9tiHRaacLpBGJcTMWN7H2Fx2tQPhrrBv65P7qwGXSBTWb?=
 =?us-ascii?Q?7FDGu1xswoDYB/uWG1ztAUGuMcrNaOa2wue0iQCTn7TXzxv4eo4LYyF0a5Zy?=
 =?us-ascii?Q?ro4ciiqgEXAy9YxFDgf2XFiS7LCAImLx2CDbw03zgNVQIu+b6e++XJ4MWFoL?=
 =?us-ascii?Q?LI+OnvVz1R40SoGyAmxsD2omSavV5+a/AlFxvYQY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13547b41-6257-4b43-6010-08da5a71d2f9
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 08:23:34.5583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T8YvUNefEw5GrCFtCFROUGaNoRrECnab8F8hPyNeojw2Z4OsfmLy4mv1w/iQdwDjsBnVyU4I5vrPZlO7wAqrGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2880
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Before layer 2 forwarding, the device classifies an incoming packet to
a FID. The classification is done based on one of the following keys:

1. FID
2. VNI (after decapsulation)
3. VID / {Port, VID}

After classification, the FID is known, but also all the attributes of
the FID, such as the router interface (RIF) via which a packet that
needs to be routed will ingress the router block.

In the legacy model, when a RIF was created / destroyed, it was
firmware's responsibility to update it in the previously mentioned FID
classification records. In the unified bridge model, this responsibility
moved to software.

The third classification requires to iterate over the FID's {Port, VID}
list and issue SVFA write with the correct mapping table according to the
port's mode (virtual or not). We never map multiple VLANs to the same FID
using VID->FID mapping, so such a mapping needs to be performed once.

When a new FID classification entry is configured and the FID already has
a RIF, set the RIF as part of SVFA configuration.

The reverse needs to be done when clearing a RIF from a FID. Currently,
clearing is done by issuing mlxsw_sp_fid_rif_set() with a NULL RIF pointer.
Instead, introduce mlxsw_sp_fid_rif_unset().

Note that mlxsw_sp_fid_rif_set() is called after the RIF is fully
operational, so it conforms to the internal requirement regarding
SVFA.irif_v: "Must not be set for a non-enabled RIF".

Do not set the ingress RIF for rFIDs, as the {Port, VID}->rFID entry is
configured by firmware when legacy model is used, a next patch will
handle this configuration for rFIDs and unified bridge model.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  17 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   4 +-
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 173 ++++++++++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  20 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   1 -
 5 files changed, 189 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index b0b5806a22ed..46ed2c1810be 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1658,40 +1658,43 @@ MLXSW_ITEM32(reg, svfa, irif, 0x14, 0, 16);
 
 static inline void __mlxsw_reg_svfa_pack(char *payload,
 					 enum mlxsw_reg_svfa_mt mt, bool valid,
-					 u16 fid)
+					 u16 fid, bool irif_v, u16 irif)
 {
 	MLXSW_REG_ZERO(svfa, payload);
 	mlxsw_reg_svfa_swid_set(payload, 0);
 	mlxsw_reg_svfa_mapping_table_set(payload, mt);
 	mlxsw_reg_svfa_v_set(payload, valid);
 	mlxsw_reg_svfa_fid_set(payload, fid);
+	mlxsw_reg_svfa_irif_v_set(payload, irif_v);
+	mlxsw_reg_svfa_irif_set(payload, irif_v ? irif : 0);
 }
 
 static inline void mlxsw_reg_svfa_port_vid_pack(char *payload, u16 local_port,
-						bool valid, u16 fid, u16 vid)
+						bool valid, u16 fid, u16 vid,
+						bool irif_v, u16 irif)
 {
 	enum mlxsw_reg_svfa_mt mt = MLXSW_REG_SVFA_MT_PORT_VID_TO_FID;
 
-	__mlxsw_reg_svfa_pack(payload, mt, valid, fid);
+	__mlxsw_reg_svfa_pack(payload, mt, valid, fid, irif_v, irif);
 	mlxsw_reg_svfa_local_port_set(payload, local_port);
 	mlxsw_reg_svfa_vid_set(payload, vid);
 }
 
 static inline void mlxsw_reg_svfa_vid_pack(char *payload, bool valid, u16 fid,
-					   u16 vid)
+					   u16 vid, bool irif_v, u16 irif)
 {
 	enum mlxsw_reg_svfa_mt mt = MLXSW_REG_SVFA_MT_VID_TO_FID;
 
-	__mlxsw_reg_svfa_pack(payload, mt, valid, fid);
+	__mlxsw_reg_svfa_pack(payload, mt, valid, fid, irif_v, irif);
 	mlxsw_reg_svfa_vid_set(payload, vid);
 }
 
 static inline void mlxsw_reg_svfa_vni_pack(char *payload, bool valid, u16 fid,
-					   u32 vni)
+					   u32 vni, bool irif_v, u16 irif)
 {
 	enum mlxsw_reg_svfa_mt mt = MLXSW_REG_SVFA_MT_VNI_TO_FID;
 
-	__mlxsw_reg_svfa_pack(payload, mt, valid, fid);
+	__mlxsw_reg_svfa_pack(payload, mt, valid, fid, irif_v, irif);
 	mlxsw_reg_svfa_vni_set(payload, vni);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 8de3bdcdf143..b1810a22a1a6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -737,6 +737,7 @@ union mlxsw_sp_l3addr {
 	struct in6_addr addr6;
 };
 
+u16 mlxsw_sp_rif_index(const struct mlxsw_sp_rif *rif);
 int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 			 struct netlink_ext_ack *extack);
 void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp);
@@ -1285,7 +1286,8 @@ void mlxsw_sp_fid_port_vid_unmap(struct mlxsw_sp_fid *fid,
 				 struct mlxsw_sp_port *mlxsw_sp_port, u16 vid);
 u16 mlxsw_sp_fid_index(const struct mlxsw_sp_fid *fid);
 enum mlxsw_sp_fid_type mlxsw_sp_fid_type(const struct mlxsw_sp_fid *fid);
-void mlxsw_sp_fid_rif_set(struct mlxsw_sp_fid *fid, struct mlxsw_sp_rif *rif);
+int mlxsw_sp_fid_rif_set(struct mlxsw_sp_fid *fid, struct mlxsw_sp_rif *rif);
+void mlxsw_sp_fid_rif_unset(struct mlxsw_sp_fid *fid);
 struct mlxsw_sp_rif *mlxsw_sp_fid_rif(const struct mlxsw_sp_fid *fid);
 enum mlxsw_sp_rif_type
 mlxsw_sp_fid_type_rif_type(const struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index ffe8c583865d..a8fecf47eaf5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -404,11 +404,6 @@ enum mlxsw_sp_fid_type mlxsw_sp_fid_type(const struct mlxsw_sp_fid *fid)
 	return fid->fid_family->type;
 }
 
-void mlxsw_sp_fid_rif_set(struct mlxsw_sp_fid *fid, struct mlxsw_sp_rif *rif)
-{
-	fid->rif = rif;
-}
-
 struct mlxsw_sp_rif *mlxsw_sp_fid_rif(const struct mlxsw_sp_fid *fid)
 {
 	return fid->rif;
@@ -465,7 +460,8 @@ static int mlxsw_sp_fid_op(const struct mlxsw_sp_fid *fid, bool valid)
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfmr), sfmr_pl);
 }
 
-static int mlxsw_sp_fid_edit_op(const struct mlxsw_sp_fid *fid)
+static int mlxsw_sp_fid_edit_op(const struct mlxsw_sp_fid *fid,
+				const struct mlxsw_sp_rif *rif)
 {
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	enum mlxsw_reg_bridge_type bridge_type = 0;
@@ -484,32 +480,176 @@ static int mlxsw_sp_fid_edit_op(const struct mlxsw_sp_fid *fid)
 	mlxsw_reg_sfmr_vni_set(sfmr_pl, be32_to_cpu(fid->vni));
 	mlxsw_reg_sfmr_vtfp_set(sfmr_pl, fid->nve_flood_index_valid);
 	mlxsw_reg_sfmr_nve_tunnel_flood_ptr_set(sfmr_pl, fid->nve_flood_index);
+
+	if (mlxsw_sp->ubridge && rif) {
+		mlxsw_reg_sfmr_irif_v_set(sfmr_pl, true);
+		mlxsw_reg_sfmr_irif_set(sfmr_pl, mlxsw_sp_rif_index(rif));
+	}
+
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfmr), sfmr_pl);
 }
 
 static int mlxsw_sp_fid_vni_to_fid_map(const struct mlxsw_sp_fid *fid,
+				       const struct mlxsw_sp_rif *rif,
 				       bool valid)
 {
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	char svfa_pl[MLXSW_REG_SVFA_LEN];
+	bool irif_valid;
+	u16 irif_index;
+
+	irif_valid = !!rif;
+	irif_index = rif ? mlxsw_sp_rif_index(rif) : 0;
 
 	mlxsw_reg_svfa_vni_pack(svfa_pl, valid, fid->fid_index,
-				be32_to_cpu(fid->vni));
+				be32_to_cpu(fid->vni), irif_valid, irif_index);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(svfa), svfa_pl);
+}
+
+static int mlxsw_sp_fid_to_fid_rif_update(const struct mlxsw_sp_fid *fid,
+					  const struct mlxsw_sp_rif *rif)
+{
+	return mlxsw_sp_fid_edit_op(fid, rif);
+}
+
+static int mlxsw_sp_fid_vni_to_fid_rif_update(const struct mlxsw_sp_fid *fid,
+					      const struct mlxsw_sp_rif *rif)
+{
+	if (!fid->vni_valid)
+		return 0;
+
+	return mlxsw_sp_fid_vni_to_fid_map(fid, rif, fid->vni_valid);
+}
+
+static int
+mlxsw_sp_fid_port_vid_to_fid_rif_update_one(const struct mlxsw_sp_fid *fid,
+					    struct mlxsw_sp_fid_port_vid *pv,
+					    bool irif_valid, u16 irif_index)
+{
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	char svfa_pl[MLXSW_REG_SVFA_LEN];
+
+	mlxsw_reg_svfa_port_vid_pack(svfa_pl, pv->local_port, true,
+				     fid->fid_index, pv->vid, irif_valid,
+				     irif_index);
+
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(svfa), svfa_pl);
 }
 
+static int mlxsw_sp_fid_vid_to_fid_rif_set(const struct mlxsw_sp_fid *fid,
+					   const struct mlxsw_sp_rif *rif)
+{
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	struct mlxsw_sp_fid_port_vid *pv;
+	u16 irif_index;
+	int err;
+
+	irif_index = mlxsw_sp_rif_index(rif);
+
+	list_for_each_entry(pv, &fid->port_vid_list, list) {
+		/* If port is not in virtual mode, then it does not have any
+		 * {Port, VID}->FID mappings that need to be updated with the
+		 * ingress RIF.
+		 */
+		if (!mlxsw_sp->fid_core->port_fid_mappings[pv->local_port])
+			continue;
+
+		err = mlxsw_sp_fid_port_vid_to_fid_rif_update_one(fid, pv,
+								  true,
+								  irif_index);
+		if (err)
+			goto err_port_vid_to_fid_rif_update_one;
+	}
+
+	return 0;
+
+err_port_vid_to_fid_rif_update_one:
+	list_for_each_entry_continue_reverse(pv, &fid->port_vid_list, list) {
+		if (!mlxsw_sp->fid_core->port_fid_mappings[pv->local_port])
+			continue;
+
+		mlxsw_sp_fid_port_vid_to_fid_rif_update_one(fid, pv, false, 0);
+	}
+
+	return err;
+}
+
+static void mlxsw_sp_fid_vid_to_fid_rif_unset(const struct mlxsw_sp_fid *fid)
+{
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	struct mlxsw_sp_fid_port_vid *pv;
+
+	list_for_each_entry(pv, &fid->port_vid_list, list) {
+		/* If port is not in virtual mode, then it does not have any
+		 * {Port, VID}->FID mappings that need to be updated.
+		 */
+		if (!mlxsw_sp->fid_core->port_fid_mappings[pv->local_port])
+			continue;
+
+		mlxsw_sp_fid_port_vid_to_fid_rif_update_one(fid, pv, false, 0);
+	}
+}
+
+int mlxsw_sp_fid_rif_set(struct mlxsw_sp_fid *fid, struct mlxsw_sp_rif *rif)
+{
+	int err;
+
+	if (!fid->fid_family->mlxsw_sp->ubridge) {
+		fid->rif = rif;
+		return 0;
+	}
+
+	err = mlxsw_sp_fid_to_fid_rif_update(fid, rif);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_fid_vni_to_fid_rif_update(fid, rif);
+	if (err)
+		goto err_vni_to_fid_rif_update;
+
+	err = mlxsw_sp_fid_vid_to_fid_rif_set(fid, rif);
+	if (err)
+		goto err_vid_to_fid_rif_set;
+
+	fid->rif = rif;
+	return 0;
+
+err_vid_to_fid_rif_set:
+	mlxsw_sp_fid_vni_to_fid_rif_update(fid, NULL);
+err_vni_to_fid_rif_update:
+	mlxsw_sp_fid_to_fid_rif_update(fid, NULL);
+	return err;
+}
+
+void mlxsw_sp_fid_rif_unset(struct mlxsw_sp_fid *fid)
+{
+	if (!fid->fid_family->mlxsw_sp->ubridge) {
+		fid->rif = NULL;
+		return;
+	}
+
+	if (!fid->rif)
+		return;
+
+	fid->rif = NULL;
+	mlxsw_sp_fid_vid_to_fid_rif_unset(fid);
+	mlxsw_sp_fid_vni_to_fid_rif_update(fid, NULL);
+	mlxsw_sp_fid_to_fid_rif_update(fid, NULL);
+}
+
 static int mlxsw_sp_fid_vni_op(const struct mlxsw_sp_fid *fid)
 {
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	int err;
 
 	if (mlxsw_sp->ubridge) {
-		err = mlxsw_sp_fid_vni_to_fid_map(fid, fid->vni_valid);
+		err = mlxsw_sp_fid_vni_to_fid_map(fid, fid->rif,
+						  fid->vni_valid);
 		if (err)
 			return err;
 	}
 
-	err = mlxsw_sp_fid_edit_op(fid);
+	err = mlxsw_sp_fid_edit_op(fid, fid->rif);
 	if (err)
 		goto err_fid_edit_op;
 
@@ -517,7 +657,7 @@ static int mlxsw_sp_fid_vni_op(const struct mlxsw_sp_fid *fid)
 
 err_fid_edit_op:
 	if (mlxsw_sp->ubridge)
-		mlxsw_sp_fid_vni_to_fid_map(fid, !fid->vni_valid);
+		mlxsw_sp_fid_vni_to_fid_map(fid, fid->rif, !fid->vni_valid);
 	return err;
 }
 
@@ -526,9 +666,16 @@ static int __mlxsw_sp_fid_port_vid_map(const struct mlxsw_sp_fid *fid,
 {
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	char svfa_pl[MLXSW_REG_SVFA_LEN];
+	bool irif_valid = false;
+	u16 irif_index = 0;
+
+	if (mlxsw_sp->ubridge && fid->rif) {
+		irif_valid = true;
+		irif_index = mlxsw_sp_rif_index(fid->rif);
+	}
 
 	mlxsw_reg_svfa_port_vid_pack(svfa_pl, local_port, valid, fid->fid_index,
-				     vid);
+				     vid, irif_valid, irif_index);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(svfa), svfa_pl);
 }
 
@@ -768,12 +915,12 @@ static void mlxsw_sp_fid_8021d_vni_clear(struct mlxsw_sp_fid *fid)
 
 static int mlxsw_sp_fid_8021d_nve_flood_index_set(struct mlxsw_sp_fid *fid)
 {
-	return mlxsw_sp_fid_edit_op(fid);
+	return mlxsw_sp_fid_edit_op(fid, fid->rif);
 }
 
 static void mlxsw_sp_fid_8021d_nve_flood_index_clear(struct mlxsw_sp_fid *fid)
 {
-	mlxsw_sp_fid_edit_op(fid);
+	mlxsw_sp_fid_edit_op(fid, fid->rif);
 }
 
 static void
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 63652460c40d..4a34138985bf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9351,9 +9351,15 @@ static int mlxsw_sp_rif_subport_configure(struct mlxsw_sp_rif *rif,
 	if (err)
 		goto err_rif_fdb_op;
 
-	mlxsw_sp_fid_rif_set(rif->fid, rif);
+	err = mlxsw_sp_fid_rif_set(rif->fid, rif);
+	if (err)
+		goto err_fid_rif_set;
+
 	return 0;
 
+err_fid_rif_set:
+	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+			    mlxsw_sp_fid_index(rif->fid), false);
 err_rif_fdb_op:
 	mlxsw_sp_rif_subport_op(rif, false);
 err_rif_subport_op:
@@ -9365,7 +9371,7 @@ static void mlxsw_sp_rif_subport_deconfigure(struct mlxsw_sp_rif *rif)
 {
 	struct mlxsw_sp_fid *fid = rif->fid;
 
-	mlxsw_sp_fid_rif_set(fid, NULL);
+	mlxsw_sp_fid_rif_unset(fid);
 	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
 			    mlxsw_sp_fid_index(fid), false);
 	mlxsw_sp_rif_macvlan_flush(rif);
@@ -9442,9 +9448,15 @@ static int mlxsw_sp_rif_fid_configure(struct mlxsw_sp_rif *rif,
 	if (err)
 		goto err_rif_fdb_op;
 
-	mlxsw_sp_fid_rif_set(rif->fid, rif);
+	err = mlxsw_sp_fid_rif_set(rif->fid, rif);
+	if (err)
+		goto err_fid_rif_set;
+
 	return 0;
 
+err_fid_rif_set:
+	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+			    mlxsw_sp_fid_index(rif->fid), false);
 err_rif_fdb_op:
 	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_BC,
 			       mlxsw_sp_router_port(mlxsw_sp), false);
@@ -9464,7 +9476,7 @@ static void mlxsw_sp_rif_fid_deconfigure(struct mlxsw_sp_rif *rif)
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	struct mlxsw_sp_fid *fid = rif->fid;
 
-	mlxsw_sp_fid_rif_set(fid, NULL);
+	mlxsw_sp_fid_rif_unset(fid);
 	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
 			    mlxsw_sp_fid_index(fid), false);
 	mlxsw_sp_rif_macvlan_flush(rif);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index b5c83ec7a87f..c5dfb972b433 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -82,7 +82,6 @@ struct mlxsw_sp_ipip_entry;
 
 struct mlxsw_sp_rif *mlxsw_sp_rif_by_index(const struct mlxsw_sp *mlxsw_sp,
 					   u16 rif_index);
-u16 mlxsw_sp_rif_index(const struct mlxsw_sp_rif *rif);
 u16 mlxsw_sp_ipip_lb_rif_index(const struct mlxsw_sp_rif_ipip_lb *rif);
 u16 mlxsw_sp_ipip_lb_ul_vr_id(const struct mlxsw_sp_rif_ipip_lb *rif);
 u16 mlxsw_sp_ipip_lb_ul_rif_id(const struct mlxsw_sp_rif_ipip_lb *lb_rif);
-- 
2.36.1

