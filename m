Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE3F564D90
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbiGDGNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbiGDGNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:13:36 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC97131
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 23:13:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H/TeTQ4NgIJp7mWM3LxNeyLiuSpiM0FfKoJWOmXgP/47IUHAmTi6/65XKn9NU5vxiqlht8nk0TZ58K2L+b32wIguFWGZkAZnOP6QYINPD60X+gDEF5qQ1l2ngNinIvJQR4vTxH7o/JtCVx6VEmi5kiEanBnPTZAaSGxZ8EGIJirJiW0rVBtr3z/QSbzkTnou5aP98VSaHJpn77xB7lqrUIDke+R/V/Tqr6ZJH0cdv7g4oL6BbpzDMibo0HI11/yXyBT//jvFAlOC6AOKDv9vCe2E7FZvHjZxCpH35UPQrzNsUh/w2J6nkaNW/gLh/xKSOssBn8MOSIEqEdpZsWXudQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vUlb8jJrW445v8tpwo6AAq6q4gbjV1nmsS0Wn1DcEkY=;
 b=E0StYhc5G6YuqmNQoeBJIOvDWDOxryAfOX8rwmRHs6R8hehUK2pTZDQw5ZfmfgcUdZwZWr0J9pwIgmK9q6W3nHc84y5lO4LCIbIdASOfYik8HynM+e6hXHuwYdntFDgvW/RsZnnMcMf/TAJYyQmxcT1puOCjk7macJgMW+XnMKiP2eZyphwk7YtlraU8zzg45UhU090wV+StPMvKXLaja+AVjSyztIyQB3N+V8JOnOHaJV7aG2cHQV6f+RlKPK7Qi4bnqk4lB7ySKfWR4c4AsO8czsETVjqG+HuEyzmmfNEix20Jnzm1fFDhA6IzLchFFWKpVJ2hpovSw7SGioKh/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUlb8jJrW445v8tpwo6AAq6q4gbjV1nmsS0Wn1DcEkY=;
 b=cBmwiHflpK1ihjPLbSjc6wcaMyr2rcrHwn+xan/Y63a64zgpYtb+Y3UMRpaxuAFJ3q2YyfAEr8cwhilguo3VNuavV8Sh4rBShB+waC4SCz+V6KhA0++99AgIF9vEe0judUWDLw56XhCxy1cUMvQmu9lqi7s0TYwTFYixArXsdkc5wgf1byfdrfxm+ENRHOyF6w5P40OgluGS6wEpiR5gFA15hdxr2dkeVwofHbDAvu1ajj7D3lgCeC16uygrmKA/07L5W4ZKnloW5UJtM+6obZpt/2k3ko+zFgZA2QJtt6FeUnPN52Blgxl8U55UKAHmgANYsS+Kdc6hY7tozFS2Lw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY4PR12MB1862.namprd12.prod.outlook.com (2603:10b6:903:121::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Mon, 4 Jul
 2022 06:13:34 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 06:13:34 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 07/13] mlxsw: Add support for VLAN RIFs
Date:   Mon,  4 Jul 2022 09:11:33 +0300
Message-Id: <20220704061139.1208770-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704061139.1208770-1-idosch@nvidia.com>
References: <20220704061139.1208770-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0011.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::24) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6baa4e7d-e9f6-4670-33bb-08da5d845344
X-MS-TrafficTypeDiagnostic: CY4PR12MB1862:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: leC3Sy/R+D8VmU+6Evjbw3kbDUhl9uJUk+EBQbyEh6QOSH8pzOtYKvD/3DM5WGyFn5SpVs3MoqX/l5sl89WqWqx12Poybk/wLqOGD6CwT4/BT5otWBIVXc+9DMIgQ1o5Fh/2UJh5YgmK7kKSw3UXkkz2knIbPkwvVMCa3oCJBw/tufwBDiQ7EK+L6F9HBoEWbQl+SfQx97vnYDwhcXx7i+2/LLrITsKH6MY0zesXSZRLOu6nnnj9CptNXIogS2I7Vt3p/pXv1vi0xCl6FEzengoPaieK0lvvPaqK+CWcjucwC7gwfGFdtN5bSnlcgYixNTMcxzQpUNQ6HuRvGSXtY++9AiAm4dW0wlNA8KeOpxJgywupksIPa57ol2GnH28eAAZvdS9x6r5XQsrxHJcmfD/u9K9YhUWRAdUUdM2PwIWUOJqpWltC5ISps/b+LPNquqt8PjvgZ4XcjcsgDNW0bPttncJGHQEKZjy/tJuyqMzC+0GSuNJGaEnGfL7WqmvDidMphAiE3MOFJEz3ci77HJR7vKcOlIGJhx08AaPXsLv050xOTlTX0D/5PLKq+d2OsclIGY7Ml4UF9YYuMYFIr4Bzodti+RAibDMlnmDGkklLcpPJqGL3tldWffptuYU3eptspCLJcZOY+i8SKccG38i9a58gYj0omaI6PYE5rDzzOSoC3hKgvpn1U8gDMJBvKPz3gmynhEKN6PvR3plOXLFnwzu7pdlgGrkaQZ0P5gD3x2ihdwg1LRmzHrDQQaiyGlXD0AjWUVs+BdFyj1l1JA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(2616005)(38100700002)(66946007)(4326008)(8676002)(66476007)(66556008)(478600001)(6486002)(316002)(6916009)(26005)(6512007)(86362001)(41300700001)(6506007)(8936002)(36756003)(66574015)(2906002)(5660300002)(1076003)(107886003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tN6w4GqQGbyfMomkksCDdCtcGLvDO7xlR51S5bJ+2tC0XrIhyPL6OPUIAClK?=
 =?us-ascii?Q?juhFOdzvOM5qIgmQ0Tuq5RyKLVgfkhBS1DXP0eMiKQTVTAo23vx4lB00Tust?=
 =?us-ascii?Q?sDKEpQ8aurFYBmXVTqNZxcxYdkvaCz+wuejUVSUrULK/qhLMrS1X7htMc67v?=
 =?us-ascii?Q?L/ybzbZX1en9GhDMJ7MhMwyaw49nyJ08qoUdx1mUqJMcfDOplwCX8GeCTJdz?=
 =?us-ascii?Q?IBg2JNdtaWHKECd+0KRM/bYMTtguz+zqpygwPJAo/voUo1HsfTY13iffgYYX?=
 =?us-ascii?Q?+9Ll9s+vHojq4QWcMYjoG8GCq5C+2TK3/3N/37eGkMtqIdBdgepcToc86bg7?=
 =?us-ascii?Q?tIF4KExFYSr8IrT37XK3utozPlVEodSz7k4QlISU53QoUWdKAZeqjesLVHqH?=
 =?us-ascii?Q?jjMME1e6ZlVCPLIhKsZXMrm9kbEwUbT2n/Rlx1y0SEjTN3tlZSHdh3FojpgZ?=
 =?us-ascii?Q?Hr2aRLbdaC1vf9SAGzF9IU0OxmyXFCsYjFpHqru/GhlO/GiMC0KAk8L+/Kqh?=
 =?us-ascii?Q?+HXMRQt+VSxHlL+lykxTDUJnyHGvTgGAE9D5jKOQuSeX1R7+WAWXDUUk2Vl3?=
 =?us-ascii?Q?HshCg2tce+moS9vehKtuHdLPBQgDdXQI+O+hGJyqCF4Mi2SDrAUSvqDWXDEb?=
 =?us-ascii?Q?lg5PFMX5td6ZhfmtpkC03NmpIQwYZBTfw/549WaxEJRVH3NJjvA24fpnqkI/?=
 =?us-ascii?Q?oS40N02jkD/N+bJV9Q0jcNZ7Sq/RmKvGdaNf2Ree9Tuh+WnrTVKSz6XDV/Pf?=
 =?us-ascii?Q?URIMY6nedMh41VcJLTePl8al3jiBLjM1jTpUaS7Jl8raayH56UU/ytUYq6Dg?=
 =?us-ascii?Q?YzE+vmg3e0FBlS1XC/qgvdTAcRxWtyecxu0MhJrqwGEBfes3BafvTkfvDQ41?=
 =?us-ascii?Q?dWBxCMMk27X8rSLABs2lH61x8FjRDtIJ1rGWLrASk21THYzBPMyde35RrCu6?=
 =?us-ascii?Q?X6Ks3aoc3ff+qC2kinCZTeyZ6sAFnvTud7P/REf7ca9P2/fL+LLyQkhLDGwX?=
 =?us-ascii?Q?ZcXKzJhp02XfXV2Tgt91zXMd6VGSM2bECM3TknC6/AeH3uctGz4Kdz3MSIwz?=
 =?us-ascii?Q?am154SuC/Lbc91HT2IHqy2hGgcfDYYn1vGVk+MEd1dMohAAFRJ7ZewPRIkQY?=
 =?us-ascii?Q?lxc0tX9zlfeoUP5PyWR4Scvd/g5XJqOH07qV/VnnqMZuL1HzX1B5vVjaTLv8?=
 =?us-ascii?Q?qnHQhNNc21S7iU90CFeGRm4/klkM2lvMAjCMxLZ0VEKBekz00hIZaz9hE8mR?=
 =?us-ascii?Q?MIOwmmTW7wci4orfvvhRh8ppc8I57Ip6Z1C9elQyyl848jVL+LQow6JY06eQ?=
 =?us-ascii?Q?aD14YIJ0Yp/EoAPGaL1ki+ZfzpG7N7r/U/7dOYy9sPoCsp8wy1I0/QaB3sUc?=
 =?us-ascii?Q?euj3PZ374GmOyLAqrJRwtO+/FV5XSpon/b9FSXb3GAt5NPn8B6dXvFm3TVLq?=
 =?us-ascii?Q?3MaL8dweVxpm5wg1xs0UMdlOMmubnbZrFByRBvl5UD8WE5xEJKc1KkHSy104?=
 =?us-ascii?Q?ssC6kwaj+JnO3rEonK2XEkx2jpj5bxGMQZiJRQRivUCVpQTDunL48lBf4VeS?=
 =?us-ascii?Q?PUjNBSD1AFm0YrEvAxfJ4CKgllzz0iMQWTZPGQ8f?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6baa4e7d-e9f6-4670-33bb-08da5d845344
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 06:13:34.1328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jaoL+V1Wya3TS0Gf4r+LnuYfxzwDioZMzFDwV9PCVxRf0XoPyNNpqMIs4cfGFCSbFD6MKfAUJec90oUhr/Z9EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1862
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Router interfaces (RIFs) constructed on top of VLAN-aware bridges are of
'VLAN' type, whereas RIFs constructed on top of VLAN-unaware bridges are of
'FID' type.

Currently 802.1Q FIDs are emulated using 802.1D FIDs, therefore VLAN RIFs
are emulated using FID RIFs. As part of converting the driver to use
unified bridge model, 802.1Q FIDs and VLAN RIFs will be used.

The egress FID is required for VLAN RIFs in Spectrum-2 and above, but not
in Spectrum-1, as in Spectrum-1 the mapping for VLAN RIFs is VID->FID,
while in other ASICs it is FID->FID. The reason for the change is that it
is more scalable to reuse the FID->FID entry than creating multiple
{Port, VID}->FID entries for the router port. Use the existing operation
structure to separate the configuration between different ASICs.

Add support for VLAN RIFs, most of the configurations are same to FID
RIFs.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   1 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 119 ++++++++++++++++++
 2 files changed, 120 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index b1810a22a1a6..c67bc562b13e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -85,6 +85,7 @@ struct mlxsw_sp_upper {
 enum mlxsw_sp_rif_type {
 	MLXSW_SP_RIF_TYPE_SUBPORT,
 	MLXSW_SP_RIF_TYPE_VLAN_EMU,
+	MLXSW_SP_RIF_TYPE_VLAN,
 	MLXSW_SP_RIF_TYPE_FID,
 	MLXSW_SP_RIF_TYPE_IPIP_LB, /* IP-in-IP loopback. */
 	MLXSW_SP_RIF_TYPE_MAX,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index eec4fb0561e9..7186f6a33685 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9573,6 +9573,123 @@ static const struct mlxsw_sp_rif_ops mlxsw_sp_rif_vlan_emu_ops = {
 	.fdb_del		= mlxsw_sp_rif_vlan_fdb_del,
 };
 
+static int mlxsw_sp_rif_vlan_op(struct mlxsw_sp_rif *rif, u16 vid, u16 efid,
+				bool enable)
+{
+	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
+	char ritr_pl[MLXSW_REG_RITR_LEN];
+
+	mlxsw_reg_ritr_vlan_if_pack(ritr_pl, enable, rif->rif_index, rif->vr_id,
+				    rif->dev->mtu, rif->dev->dev_addr,
+				    rif->mac_profile_id, vid, efid);
+
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ritr), ritr_pl);
+}
+
+static int mlxsw_sp_rif_vlan_configure(struct mlxsw_sp_rif *rif, u16 efid,
+				       struct netlink_ext_ack *extack)
+{
+	u16 vid = mlxsw_sp_fid_8021q_vid(rif->fid);
+	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
+	u8 mac_profile;
+	int err;
+
+	err = mlxsw_sp_rif_mac_profile_get(mlxsw_sp, rif->addr,
+					   &mac_profile, extack);
+	if (err)
+		return err;
+	rif->mac_profile_id = mac_profile;
+
+	err = mlxsw_sp_rif_vlan_op(rif, vid, efid, true);
+	if (err)
+		goto err_rif_vlan_fid_op;
+
+	err = mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_MC,
+				     mlxsw_sp_router_port(mlxsw_sp), true);
+	if (err)
+		goto err_fid_mc_flood_set;
+
+	err = mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_BC,
+				     mlxsw_sp_router_port(mlxsw_sp), true);
+	if (err)
+		goto err_fid_bc_flood_set;
+
+	err = mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+				  mlxsw_sp_fid_index(rif->fid), true);
+	if (err)
+		goto err_rif_fdb_op;
+
+	err = mlxsw_sp_fid_rif_set(rif->fid, rif);
+	if (err)
+		goto err_fid_rif_set;
+
+	return 0;
+
+err_fid_rif_set:
+	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+			    mlxsw_sp_fid_index(rif->fid), false);
+err_rif_fdb_op:
+	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_BC,
+			       mlxsw_sp_router_port(mlxsw_sp), false);
+err_fid_bc_flood_set:
+	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_MC,
+			       mlxsw_sp_router_port(mlxsw_sp), false);
+err_fid_mc_flood_set:
+	mlxsw_sp_rif_vlan_op(rif, vid, 0, false);
+err_rif_vlan_fid_op:
+	mlxsw_sp_rif_mac_profile_put(mlxsw_sp, mac_profile);
+	return err;
+}
+
+static void mlxsw_sp_rif_vlan_deconfigure(struct mlxsw_sp_rif *rif)
+{
+	u16 vid = mlxsw_sp_fid_8021q_vid(rif->fid);
+	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
+
+	mlxsw_sp_fid_rif_unset(rif->fid);
+	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+			    mlxsw_sp_fid_index(rif->fid), false);
+	mlxsw_sp_rif_macvlan_flush(rif);
+	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_BC,
+			       mlxsw_sp_router_port(mlxsw_sp), false);
+	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_MC,
+			       mlxsw_sp_router_port(mlxsw_sp), false);
+	mlxsw_sp_rif_vlan_op(rif, vid, 0, false);
+	mlxsw_sp_rif_mac_profile_put(rif->mlxsw_sp, rif->mac_profile_id);
+}
+
+static int mlxsw_sp1_rif_vlan_configure(struct mlxsw_sp_rif *rif,
+					struct netlink_ext_ack *extack)
+{
+	return mlxsw_sp_rif_vlan_configure(rif, 0, extack);
+}
+
+static const struct mlxsw_sp_rif_ops mlxsw_sp1_rif_vlan_ops = {
+	.type			= MLXSW_SP_RIF_TYPE_VLAN,
+	.rif_size		= sizeof(struct mlxsw_sp_rif),
+	.configure		= mlxsw_sp1_rif_vlan_configure,
+	.deconfigure		= mlxsw_sp_rif_vlan_deconfigure,
+	.fid_get		= mlxsw_sp_rif_vlan_fid_get,
+	.fdb_del		= mlxsw_sp_rif_vlan_fdb_del,
+};
+
+static int mlxsw_sp2_rif_vlan_configure(struct mlxsw_sp_rif *rif,
+					struct netlink_ext_ack *extack)
+{
+	u16 efid = mlxsw_sp_fid_index(rif->fid);
+
+	return mlxsw_sp_rif_vlan_configure(rif, efid, extack);
+}
+
+static const struct mlxsw_sp_rif_ops mlxsw_sp2_rif_vlan_ops = {
+	.type			= MLXSW_SP_RIF_TYPE_VLAN,
+	.rif_size		= sizeof(struct mlxsw_sp_rif),
+	.configure		= mlxsw_sp2_rif_vlan_configure,
+	.deconfigure		= mlxsw_sp_rif_vlan_deconfigure,
+	.fid_get		= mlxsw_sp_rif_vlan_fid_get,
+	.fdb_del		= mlxsw_sp_rif_vlan_fdb_del,
+};
+
 static struct mlxsw_sp_rif_ipip_lb *
 mlxsw_sp_rif_ipip_lb_rif(struct mlxsw_sp_rif *rif)
 {
@@ -9644,6 +9761,7 @@ static const struct mlxsw_sp_rif_ops mlxsw_sp1_rif_ipip_lb_ops = {
 static const struct mlxsw_sp_rif_ops *mlxsw_sp1_rif_ops_arr[] = {
 	[MLXSW_SP_RIF_TYPE_SUBPORT]	= &mlxsw_sp_rif_subport_ops,
 	[MLXSW_SP_RIF_TYPE_VLAN_EMU]	= &mlxsw_sp_rif_vlan_emu_ops,
+	[MLXSW_SP_RIF_TYPE_VLAN]	= &mlxsw_sp1_rif_vlan_ops,
 	[MLXSW_SP_RIF_TYPE_FID]		= &mlxsw_sp_rif_fid_ops,
 	[MLXSW_SP_RIF_TYPE_IPIP_LB]	= &mlxsw_sp1_rif_ipip_lb_ops,
 };
@@ -9832,6 +9950,7 @@ static const struct mlxsw_sp_rif_ops mlxsw_sp2_rif_ipip_lb_ops = {
 static const struct mlxsw_sp_rif_ops *mlxsw_sp2_rif_ops_arr[] = {
 	[MLXSW_SP_RIF_TYPE_SUBPORT]	= &mlxsw_sp_rif_subport_ops,
 	[MLXSW_SP_RIF_TYPE_VLAN_EMU]	= &mlxsw_sp_rif_vlan_emu_ops,
+	[MLXSW_SP_RIF_TYPE_VLAN]	= &mlxsw_sp2_rif_vlan_ops,
 	[MLXSW_SP_RIF_TYPE_FID]		= &mlxsw_sp_rif_fid_ops,
 	[MLXSW_SP_RIF_TYPE_IPIP_LB]	= &mlxsw_sp2_rif_ipip_lb_ops,
 };
-- 
2.36.1

