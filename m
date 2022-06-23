Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02FD5573C3
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiFWHTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiFWHTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:19:31 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CC145AED
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 00:19:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTYU+whz9sGaJPQ1Mh159Fik6Q0wE7XULa+M2mwrSD/h99P4V2pqjaxy4KCnydr02blUc3l+0wvjza/spyinzFhRDEh0irUlIkjfZ8snvD6nB2aebL3rESRFeU8KBNrHVGQupNG2g+x1P2G+AR4r95SJiSgngo0ARudFfNa6KUVaOdOND5B+yBr327hHEIEiyuvaxQTRqCnTSsayTDaWgmebvS1whKL+99heAQnefpD0pVtM+ZbwxhXCocj/qHuQSMPm7APt+9hqYCuHDFv5xRw8AHKfbeP7u3Ti3maNQ6W1UlSNC/b1T8WHROVdZo2sAGkWwWgqm5c8O69jWIq7ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C4gj1r2bgGngzAO61j+QQ03z4amO9+HcuxPAe5bYOF4=;
 b=VTQY//WnPzu9fJ7QGnohhIhRV1A8NJZjeRLxs/Uy/gJXXDuanPb3MyDfxsl8XGzoLEj0ovRFuuh7JG2pW69bTG1B779eY2Cz2aQdHekNYuNx/iL4vY1Uql1WUXLIL/HA+CxPduaaIl4AJY4n06A7XNcX6w+FRL/hxafRiwqy3myv1HinKIQzepjqTOffqPPYyVaCzxBZBkBNOmAivz1WZHQLotz2YL4nsS5W6ZwerS4d1klhH7uZFrNhSn2GaRbLwhawwhsIa71fvdO65AUNIRLEI5p1CHs0syVJXZUsXekEAkJZLTdvocXnSO0YCUBI0A1C4SJW5N2We6CDvLCwKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C4gj1r2bgGngzAO61j+QQ03z4amO9+HcuxPAe5bYOF4=;
 b=Q27Es2KNbdUcsRlmVrpCF6tH0WdGVeSgOx7aw3jTDU5f8J4nWceKSnJfDC8R5oM6EesJACqYE8AezJ/vQkM4QwAB49iP6YWMwahaCbrjCy6TIbBHfglSAcuP+ZJs3keoUWInlOIcth9nNuC5vNQWB0x16LWDMZDMe1WN1roNYPkgA0xMeRzfah8+8Fr73Osn/OiDyhOi1F2uJLREKEtkl4BtxQ8Bsl032l8n1uVWlgwkgw7JIAK+4WSi9p0YERWRpE206sRWdZd2auIKnWo6EsqnV7k7LoIoJzjhHoBgBNuKGorQefUJhs16vC6XrKBAO84Y77Me2XplRRHODv2g1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Thu, 23 Jun
 2022 07:19:29 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf%7]) with mapi id 15.20.5353.018; Thu, 23 Jun 2022
 07:19:29 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/8] mlxsw: spectrum_fid: Update FID structure prior to device configuration
Date:   Thu, 23 Jun 2022 10:17:31 +0300
Message-Id: <20220623071737.318238-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623071737.318238-1-idosch@nvidia.com>
References: <20220623071737.318238-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0030.eurprd07.prod.outlook.com
 (2603:10a6:800:90::16) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b9ea96c-9641-4912-9d05-08da54e8b616
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB251848442B2B95E8A1C48775B2B59@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Immyn14dRUlYvlfXe7WcpTI5A0rN7kWb3rMFmWVzntHrWiPDJfnspF4r+mAGaVObw2xQ/Di2/xrd63vFG7xz+UcWOvZqG34Nu/3gRGylQp6p8PZHowbgxXWoN5YEqSXyByorm9ocJ0ETDjLUxkVAd7Hz1kLgYlKu46tEsJDN2Y0HRcIxPhivivjozBpRAQRbmIx7/ZVJOoWZiJKniFEArQ96yX5hbn36W/A8OqbvYkcQO0BlJAY6EHmrZAH3lsLPtgbey+ftMe1ppAEHsNgjp3eeA4s3yh5rSKSsoHhGyCgJ/p41TbFIzEXgCMDvo6w9E690KSeUd6qOV5vWAxOabQbX88WGdP3muWYnZSXtu3pj2l1nAYKGRID8DXPynM1yoEJ7Bo52iQWp54xHXtDHHyqMuLaIH4KsclVFJqtg4BvDSeRY9gQzgBxpkxZ0VxcvBDD9sBKPc0t3u6NGdPS6XcV+4MoPn9o6V/ormyEzeT4PTY1YpmgfXu5SYQa9r+meqHWxABVFvQ2Z7pUU7puwrIUHTfAFiriwOhmmqB94oWsKcPx57k3RKrSH0ZM1aj4KxFuqV3PfTz7+Uv2HNQkinhNr3jt4ZMi/fh1HlnTPXMOdF5eVA+4qPik9kdeWJh7MNPQjNuBAggsPG2G5+9j7u9c4zkKPfbjDq/g08/Q+hP07ebAK+gbYnSr1WuGnxsdT4tNzdl6A5RvEwd4SOwxssg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(4326008)(8936002)(66476007)(8676002)(86362001)(1076003)(6666004)(6506007)(66556008)(6512007)(66946007)(107886003)(186003)(6916009)(83380400001)(2616005)(5660300002)(36756003)(41300700001)(38100700002)(26005)(316002)(6486002)(478600001)(15650500001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vCgb08RxZE37btbD1z3ArCWEpqV9yaBPKKgbRMhCar3W3ONUJ05L0MhHojSW?=
 =?us-ascii?Q?ioPV6tRVJPcqD06aCd8suPCaXcOsyjwrtSqjUO0MMpDPGuzE1LBlBHctGlu4?=
 =?us-ascii?Q?CoFPAkBWaUYPr6ePbE0p1TrjN84mHf3HsJFgyVA8L7uV1fy1pf7AB5hTcf3g?=
 =?us-ascii?Q?A/ibW5yh7R+1OUGqAm4oGUE4zTlJGvGj8M31EsvIt9Z8YrffLQPosgJ/KJ/B?=
 =?us-ascii?Q?jIsDplwfuRsf7AjbiK7tJyIjRw+xcDvX+gztR9o0j01UnBSd1I4iwFvE6W2a?=
 =?us-ascii?Q?Y9WxKgtGMqHP8Wl3h3Aw2rTSCPUmnlr85aklNYVVWGAOLvxxxqK4n4a4bpCh?=
 =?us-ascii?Q?bd+F69q4A1TBAs4d9dzZqkT78TcJrA6IQPt9xdeNdr/ehMrlqxIfvVlb/Vf6?=
 =?us-ascii?Q?z50QJKokKiSKBwNVDymZSPzm7QyEDdXtUuC1baokAnkPC2pXAyNL1hfcO8z4?=
 =?us-ascii?Q?0jRTj8sApqEKuDtICH9kCL/qLdn/QxqjcMBcYzJRpDRzlL7YwqK2apaZfku2?=
 =?us-ascii?Q?mNm+jsGoKdMMkvD7wA3m2zCxjNULp3Z+RAONYBJYLNpHaQ9EZtiqFjTFXcub?=
 =?us-ascii?Q?Ky02/wp02g/wRLXSYgb84XMIyA0dlAZAWxUEqzy5PcNj7d45DiGaSOp4V4CT?=
 =?us-ascii?Q?+ip9HuPwT4Sx8+Sgb6y2maUjYiAfCzH6OgaFbi/2hCZ/+qOKldWRjh6oSJy8?=
 =?us-ascii?Q?ux9b4apbHyvL4tsAs7e0f43CG1Xv4UUPZZqpdsS+zNxqRJUnQhlsKmwv1guN?=
 =?us-ascii?Q?AfDifwNHQrPnl2BRUISv8diBRinHSnsWJQOufELLOsMkYLSMPsWHQd/Xtpuz?=
 =?us-ascii?Q?g1I8K5I+dpfbdMkUPoPkNx9GSeZVsUYnexKdoWS9d6W+e/hlUdreJIbXe/HJ?=
 =?us-ascii?Q?dFJ8a2H/sjeNICrKZnSIwl2IIrot1MGBXdw+ty3KpP6MeDtZ5NMqlYHOH0K7?=
 =?us-ascii?Q?OYW1+HdW1qNZMcQHYWmO0OMzGk8yba9YwYFiQXODmRzDQx0NCeA43ddjR9AY?=
 =?us-ascii?Q?pyavXVyhl0K2VWCC2JcutJq5YOzLTpR9E8CnMMWr3oMAQsZqXS1kUzva6nmM?=
 =?us-ascii?Q?iC7USHAi5D+6ErrDtdChIoajldCKhDjDUdjgQ9o0Zh4afSSGsHn2SRDQdbLw?=
 =?us-ascii?Q?e2Lpm2kKrzKL+RepQUmXIWa4Ws728kwpGFCrNj5iM9FJPp78SRvbJ7yMKrlM?=
 =?us-ascii?Q?uCgCHymUcYzwkQhCCuqBehH5fKrfRnzc1ElZ2hHIVfNXhepqDE4btNJFk9kp?=
 =?us-ascii?Q?Ikp8MFBBJBXGjNFAqX0/lNr+dLsO8ka/ZHwDWpVLDPQ8rI2xw7eCmv6DZN5q?=
 =?us-ascii?Q?NByiUhGDdzTov3l4oC0dMePsUyQrbzyV32MogMLH5wPGD6O72++/ybFh9Sww?=
 =?us-ascii?Q?noEa69PwioHGYawon94Hzsm0HAAwAvFJzmUaJSiwJxxxpy6Brh66Fy79HXS4?=
 =?us-ascii?Q?F6iVaV5BuSDjtZfmx+7Tbf2EkZDurN8qpGP6jkAR4uoC/F+hMlyEvLVzlY+2?=
 =?us-ascii?Q?TDjHsU4eoqONXM2blvhHN7lYMxzh1fAtMrOPbs8ivWpIz/86yZivOULEJafw?=
 =?us-ascii?Q?E/nbAe7dLQRay0WxaCXH/sQ4Rxf1XRQJ6V6NFwVCj0X0NRgZnLrs/T1q63Uv?=
 =?us-ascii?Q?H3r79jks2uuL/flFYf9nwEKq6K1LYLDD7cQFjndV6HbpURYwPvXVaYlH++rU?=
 =?us-ascii?Q?KIX152JZ7BiEqHbx/cWkxYi6Q+sCF9nwOJqhYNEwdenzJTxji65jeF3sCTAA?=
 =?us-ascii?Q?ZFu6WEi4jA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b9ea96c-9641-4912-9d05-08da54e8b616
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:19:29.2302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IZ7fAml2J4ZSvgstQIRrNcQPeFdidv9edrT+0RoWJs4PsAnKdqVnKXXEB5YYS8sM4ne1jjd7ESxGZX6fehuU7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, the only FID attributes that are edited after FID creation
are its VNI and NVE tunnel flood pointer. This is achieved by eventually
invoking mlxsw_sp_fid_vni_op() with an updated set of arguments.

In the future, more FID attributes will need to be edited, such as the
ingress RIF configured on top of the FID.

Therefore, it makes sense to encapsulate all the FID edit logic in one
function that will perform the edit based on an updated FID structure.

To that end, update the FID structure before invoking the various edit
operations that eventually call into mlxsw_sp_fid_vni_op(). Use the
updated structure as the sole argument of the edit operations.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 48 +++++++++----------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 18a96db3ba29..ac39be25d57f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -89,10 +89,9 @@ struct mlxsw_sp_fid_ops {
 			    struct mlxsw_sp_port *port, u16 vid);
 	void (*port_vid_unmap)(struct mlxsw_sp_fid *fid,
 			       struct mlxsw_sp_port *port, u16 vid);
-	int (*vni_set)(struct mlxsw_sp_fid *fid, __be32 vni);
+	int (*vni_set)(struct mlxsw_sp_fid *fid);
 	void (*vni_clear)(struct mlxsw_sp_fid *fid);
-	int (*nve_flood_index_set)(struct mlxsw_sp_fid *fid,
-				   u32 nve_flood_index);
+	int (*nve_flood_index_set)(struct mlxsw_sp_fid *fid);
 	void (*nve_flood_index_clear)(struct mlxsw_sp_fid *fid);
 	void (*fdb_clear_offload)(const struct mlxsw_sp_fid *fid,
 				  const struct net_device *nve_dev);
@@ -211,14 +210,17 @@ int mlxsw_sp_fid_nve_flood_index_set(struct mlxsw_sp_fid *fid,
 	if (WARN_ON(fid->nve_flood_index_valid))
 		return -EINVAL;
 
-	err = ops->nve_flood_index_set(fid, nve_flood_index);
-	if (err)
-		return err;
-
 	fid->nve_flood_index = nve_flood_index;
 	fid->nve_flood_index_valid = true;
+	err = ops->nve_flood_index_set(fid);
+	if (err)
+		goto err_nve_flood_index_set;
 
 	return 0;
+
+err_nve_flood_index_set:
+	fid->nve_flood_index_valid = false;
+	return err;
 }
 
 void mlxsw_sp_fid_nve_flood_index_clear(struct mlxsw_sp_fid *fid)
@@ -258,15 +260,15 @@ int mlxsw_sp_fid_vni_set(struct mlxsw_sp_fid *fid, enum mlxsw_sp_nve_type type,
 	if (err)
 		return err;
 
-	err = ops->vni_set(fid, vni);
+	fid->vni_valid = true;
+	err = ops->vni_set(fid);
 	if (err)
 		goto err_vni_set;
 
-	fid->vni_valid = true;
-
 	return 0;
 
 err_vni_set:
+	fid->vni_valid = false;
 	rhashtable_remove_fast(&mlxsw_sp->fid_core->vni_ht, &fid->vni_ht_node,
 			       mlxsw_sp_fid_vni_ht_params);
 	return err;
@@ -662,12 +664,12 @@ mlxsw_sp_fid_8021d_port_vid_unmap(struct mlxsw_sp_fid *fid,
 				    mlxsw_sp_port->local_port, vid, false);
 }
 
-static int mlxsw_sp_fid_8021d_vni_set(struct mlxsw_sp_fid *fid, __be32 vni)
+static int mlxsw_sp_fid_8021d_vni_set(struct mlxsw_sp_fid *fid)
 {
 	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
 
 	return mlxsw_sp_fid_vni_op(fid_family->mlxsw_sp, fid->fid_index,
-				   fid->fid_offset, vni, true,
+				   fid->fid_offset, fid->vni, fid->vni_valid,
 				   fid->nve_flood_index,
 				   fid->nve_flood_index_valid);
 }
@@ -677,18 +679,18 @@ static void mlxsw_sp_fid_8021d_vni_clear(struct mlxsw_sp_fid *fid)
 	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
 
 	mlxsw_sp_fid_vni_op(fid_family->mlxsw_sp, fid->fid_index,
-			    fid->fid_offset, 0, false, fid->nve_flood_index,
-			    fid->nve_flood_index_valid);
+			    fid->fid_offset, 0, fid->vni_valid,
+			    fid->nve_flood_index, fid->nve_flood_index_valid);
 }
 
-static int mlxsw_sp_fid_8021d_nve_flood_index_set(struct mlxsw_sp_fid *fid,
-						  u32 nve_flood_index)
+static int mlxsw_sp_fid_8021d_nve_flood_index_set(struct mlxsw_sp_fid *fid)
 {
 	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
 
 	return mlxsw_sp_fid_vni_op(fid_family->mlxsw_sp, fid->fid_index,
 				   fid->fid_offset, fid->vni, fid->vni_valid,
-				   nve_flood_index, true);
+				   fid->nve_flood_index,
+				   fid->nve_flood_index_valid);
 }
 
 static void mlxsw_sp_fid_8021d_nve_flood_index_clear(struct mlxsw_sp_fid *fid)
@@ -697,7 +699,7 @@ static void mlxsw_sp_fid_8021d_nve_flood_index_clear(struct mlxsw_sp_fid *fid)
 
 	mlxsw_sp_fid_vni_op(fid_family->mlxsw_sp, fid->fid_index,
 			    fid->fid_offset, fid->vni, fid->vni_valid, 0,
-			    false);
+			    fid->nve_flood_index_valid);
 }
 
 static void
@@ -880,7 +882,7 @@ mlxsw_sp_fid_rfid_port_vid_unmap(struct mlxsw_sp_fid *fid,
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 }
 
-static int mlxsw_sp_fid_rfid_vni_set(struct mlxsw_sp_fid *fid, __be32 vni)
+static int mlxsw_sp_fid_rfid_vni_set(struct mlxsw_sp_fid *fid)
 {
 	return -EOPNOTSUPP;
 }
@@ -890,8 +892,7 @@ static void mlxsw_sp_fid_rfid_vni_clear(struct mlxsw_sp_fid *fid)
 	WARN_ON_ONCE(1);
 }
 
-static int mlxsw_sp_fid_rfid_nve_flood_index_set(struct mlxsw_sp_fid *fid,
-						 u32 nve_flood_index)
+static int mlxsw_sp_fid_rfid_nve_flood_index_set(struct mlxsw_sp_fid *fid)
 {
 	return -EOPNOTSUPP;
 }
@@ -959,7 +960,7 @@ static bool mlxsw_sp_fid_dummy_compare(const struct mlxsw_sp_fid *fid,
 	return true;
 }
 
-static int mlxsw_sp_fid_dummy_vni_set(struct mlxsw_sp_fid *fid, __be32 vni)
+static int mlxsw_sp_fid_dummy_vni_set(struct mlxsw_sp_fid *fid)
 {
 	return -EOPNOTSUPP;
 }
@@ -969,8 +970,7 @@ static void mlxsw_sp_fid_dummy_vni_clear(struct mlxsw_sp_fid *fid)
 	WARN_ON_ONCE(1);
 }
 
-static int mlxsw_sp_fid_dummy_nve_flood_index_set(struct mlxsw_sp_fid *fid,
-						  u32 nve_flood_index)
+static int mlxsw_sp_fid_dummy_nve_flood_index_set(struct mlxsw_sp_fid *fid)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.36.1

