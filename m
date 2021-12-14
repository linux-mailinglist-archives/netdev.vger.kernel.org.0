Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABA44744DD
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbhLNO0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:26:38 -0500
Received: from mail-mw2nam10on2055.outbound.protection.outlook.com ([40.107.94.55]:45377
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232444AbhLNO0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 09:26:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVfk8kJoA3Wjgt+LI84qhvzA/pVsHUH9u5+zaEXC65uhxj2UNUXxSkXixOghxtUEl3xqgCp2+4dUPV+tySVvdR0yjc05CsOUEFGH34Sdb4XoqyJEeaP+9+E2NeFYLsynCwaMR+vp7uLrSMURHhQ46MpPKNpcpM+GzSMlnO26IjQc7Jvv3cxB3ezvWYAnPljQkMWghvlXbmYNZ2j6WMlOqHtHC5Z4nna5OWJLGYSX69rdTyqXGmyO/5Y8xrj413XlxH1p43TMpoQmRAEL2+Jv6C8ZFs9FtsdzBXz8fExUAsX2SLNt0xUW69mMb9Fy0pXCYazMJ+o7L1G22mXvU/Oh/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSP/DwCcOdy+SH368Pc/Jojf94WmSDoHhr42tlZ7zYs=;
 b=SgZqDbHcOgbQtFdOnzEpyJjxr/rRo9CuIkvhCGHP8TmDLb4V6yxqY+a4gHNAK1H9gheBgx92Zigy53yK/Aa9lgOPmm5+CeBOOHAR6ncz5UM0cdnL53evmlfid+NZ84efyAeba6FUvHdIIEFAlLqUOMzcL1zAGr2CggYBX7hCwgmbK6x1cJiiAM4MNuBeYfTkgzmCLHBWerS4BrAGtHGN1ZOkTyxBR6tpzKtCD4atlowoxPiIOV8XvKN87fEqmGQICurWYJLDjlMkyY6J1OaXSomWHfvbpB53rdWd6PtT1hhHAAjHJRt5SrtVQzk4hosyrJIpohQAHqkO++BBM7eCwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSP/DwCcOdy+SH368Pc/Jojf94WmSDoHhr42tlZ7zYs=;
 b=A5pcT86HneUi3vXpyqx60lfk7WbgybUSE6X1clezE3tgL9stflDEY4PWCMg1jQPNbjz7yELFGXPS2hBIaZLQT1EIu1p530AVLf6WPeL1LT8wD14Ou9vpBkJgmIow2kC67nfgf5zM5CoAzZ4p8ab34spLyuwZzdoj8XLM3cBUVTmxkc0+DwKpYvXoqG9Y62uaRyytnXfuzTX1pP6XuiH26Yh1UWHkuE6PUT6Xy2CzBHyrlXAEDaXakyX78VfPMR1noDvmEjT4TFCaJN9Dzxq3r2He8SNoWJHRTNWY1AipaB38P+KngcAeuzzOsfG8UxYBQNG/VN1HFJ+ZMlQG4S09uw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BYAPR12MB3031.namprd12.prod.outlook.com (2603:10b6:a03:d8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13; Tue, 14 Dec
 2021 14:26:36 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 14:26:36 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/8] mlxsw: Split handling of FDB tunnel entries between address families
Date:   Tue, 14 Dec 2021 16:25:47 +0200
Message-Id: <20211214142551.606542-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214142551.606542-1-idosch@nvidia.com>
References: <20211214142551.606542-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0047.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::35)
 To BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
MIME-Version: 1.0
Received: from localhost (2a0d:6fc2:5560:e600:ddf8:d1fa:667a:53e3) by MR2P264CA0047.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::35) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 14:26:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea9d8c30-8282-46df-7829-08d9bf0dbc60
X-MS-TrafficTypeDiagnostic: BYAPR12MB3031:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB30312FE875EF541FA62FCCCCB2759@BYAPR12MB3031.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DzBlLhMUluKKwafko2corUfaB5Cy5oNUSxeKGMey8Al1HYxTkREy3lKEU52XkEphfnQSc0sWZSC4kSPlXR9l7WiNuKzQTr1nwPpisQYTPZbjDaWBQIk5gKo+H46ULSUGZRW0vu7gzFhJwEV17wizsqBdlO6Pl1Qyb/zWmAKBRJ+e5gRlhnIQ1fXsjByN+SapoHskm0cs4CTtXel+OkVNGH7Ddc3IHmSV0egij7o6oduBtn+VPu4RlrWTSxfCXrqGwQAU2vw91k+rgg0JQwpDixGxtbXFAwTN3+meW3Fq62uKKPkTrrhcnvkXaVFLbrHGIMypTLLn9Gf1tSLr0ImUZTFHXx9UOODCt7mUrr8vkmSsZ8HCd3c4YAKIyWSwrkcjUivP6ewfARkg/9tnNQTkOz/Vc5Y8tksPt9zXoB78lrqely963iJbd1H5ZnS2hLxOVnf46UTyHh4J/bOkr2Z/BiTElFYm5HflR3A2iFJI4JtWNWLLE2ZErFGSwVrSiwpEpo7o/UOY1OkAYzQ7LR7wDcCHainw/19alJTplXN7OAAAonH4XD/FDh05JcDFd3IlwQhI3ZiVkkNfj+UdN3KHHV/KjvAzowq0PcQG+DhC9tpqECEwXnVfBzzE4PEM0Tg9FBf+JVgq02B5b6tgmXjXJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(66946007)(6496006)(508600001)(8936002)(83380400001)(107886003)(2906002)(66476007)(66556008)(86362001)(186003)(38100700002)(316002)(4326008)(8676002)(2616005)(1076003)(5660300002)(6486002)(36756003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dkfof1zfop9b2bFRQmFP7AQcq8+mGFYqBgp7wTEV+yN0P+9BL+3KJamEX2nV?=
 =?us-ascii?Q?BQTSZiKvbTWERoSD6sSZy0jBox1N0DgtBmE4X6kc0xEeq2fcuo+n0JnLzqB0?=
 =?us-ascii?Q?/YlD8HQRrETu9aIjf44ON0aDxG4EJwp3xdyFhMwbVKaycq+MoaxfYozaA4tb?=
 =?us-ascii?Q?lENQJll7bqwTs5NO0rFe4UIXPs9t5RyX8wsexJHm5L7Ej0kZZv8iBmBxH7zi?=
 =?us-ascii?Q?FX1yN7ShjxMClPD7MRxpEtmzd1Wy2DJPvyVJYw7TbZm7eC32rx0/GM4HuHM5?=
 =?us-ascii?Q?LWhDFrZY+a2kgXnDxip5wrs5MkDxBCMVtw2xR6hVmWRWP6iHHcTk53UljfPP?=
 =?us-ascii?Q?Zj8sy1A1q3Z10jLim5XQ1jP5BOBYKZ/4+Y13Vx8WZDuX7Fmx7j9o/FyWu2mC?=
 =?us-ascii?Q?jwy9GJaXVWGuzTi3xDRb4Ye8tlDPQvT2lBcffsVWZ2vCE9KzQyM9ibMuZUP+?=
 =?us-ascii?Q?O7mE12JL1A3z401OJCC4o+4SA93vnKDS1AUguyyJyNE5QRuKvJJ7oJJGPG3f?=
 =?us-ascii?Q?YYIR0IPn8DnrB70dUOORLxJkK5dti7owNrtk4LmsrP11KZCkR8on+GX6x5hs?=
 =?us-ascii?Q?V2zejX/vx5SksD5dOFUaew5VgFi57NJWuaB1pJ28khKmSkLyt9lSrS/SxJo2?=
 =?us-ascii?Q?h/vUnuyuAo1pkxLC0bEt7X0tBGR1u3+DHyosDbFfSqDxNsLD9TMvtdou4Bdj?=
 =?us-ascii?Q?7eX/HOW4yM5YxxjXN2l3JlZu+jMw/LsAqj54DtYFL7mnALJi5RluYCCaNapP?=
 =?us-ascii?Q?+6ZIa/VugR9R2nqHqxpgg8CWzUOGvEIv4rpkUhASYTKImbqpzVZhaB4tjPpx?=
 =?us-ascii?Q?e6R/FRo4t/syDdESoLAjkEd1KsqP7AiNhHzTupawNstitVA0l0+fLwSbgfRC?=
 =?us-ascii?Q?Ev3I0E2jvxiW6ZBhGtcw3x1RlTt3jHgnosPDM/DAnmrSLPWdTncvRzlMNfrI?=
 =?us-ascii?Q?AC25835iMX3/5hVOfEm4FeQIS+t5c7jlY8cG6uhS8h7SVXTblRr9D90AQD3D?=
 =?us-ascii?Q?AXM7g/Ti4nsNIxmPm0Eg5dxe2mrhew7tvTpIG48UKZe4eLPLSmgb4/g+Gujm?=
 =?us-ascii?Q?qMrRfXYHR7iu1fHzKocNE8p9Ym64GsuQ50eC3Rl9NBzwv6huPW3Tm/zgTRow?=
 =?us-ascii?Q?qmQo01k6emVcgq59kdRmm/hE+JNv5hzn7bPy+FVcIZTdbED6GrU0WjfLbrX2?=
 =?us-ascii?Q?UIEL2fYZRJhC5Jkku8LZ1JOp5UXJ3ypBP15HbIpWd79YNLletGH8ChGrx9+b?=
 =?us-ascii?Q?2m0lvXoZ2LteSu3BWpeKj+LoyBJYIpqiQ2O1riSgTnCo4Bwwrli1RUTyC8vu?=
 =?us-ascii?Q?3zpFeJD8vcV8BL+azajJPjxbNisQNpeKqIS5zRfzxPuAKp1g1X5FYA5+WZdM?=
 =?us-ascii?Q?6rKwCqXeMATS2MSPD4ByKO+PjOWqw4jwzW1XTwshmrTD7tqRPzcfNUfhVIfs?=
 =?us-ascii?Q?le3kAYSRIm2X8eS7bjNs8/gKVrAUzij7f7DkdoeNBRejYNipE6+p8IlajAaW?=
 =?us-ascii?Q?U+nI+TBwts/2Kidlr4a7dfLP8HHOZKW+wgpmT1Zal7B2bK1R6gYVFQvsGMzr?=
 =?us-ascii?Q?4MB4i7zEivru9Cz6jsG8c4gTRbV2ZlrGtQIKVQ253nulzAYYsh2kl1KjZxKd?=
 =?us-ascii?Q?tCX14Yn2NrQ1ta29Nzx+FBmCVi5KHOVgKUQMzh5zNjD4evfcqs0i5OqxYhUJ?=
 =?us-ascii?Q?x4w3ESD290ZzYjaPPGDZqY11TBY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea9d8c30-8282-46df-7829-08d9bf0dbc60
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 14:26:36.7429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OUGPp6doNInq4y2cEgmND/kFbvS+fJxSQE5v0rnHrxmUEmWDSfqL9xxv7hp77v4FzNKnaRutEajw+aP/1hPXDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, the function which adds/removes unicast tunnel FDB entries is
shared between IPv4 and IPv6, while for IPv6 it warns because there is
no support for it.

The code for IPv6 will be more complicated because it needs to
allocate/release a KVDL pointer for the underlay IPv6 address.

As a preparation for IPv6 underlay support, split the code according to
address family.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 17 +++++--
 .../mellanox/mlxsw/spectrum_switchdev.c       | 45 ++++++++++---------
 2 files changed, 38 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 5eaba2abf212..50226dae9d4e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -504,19 +504,30 @@ static inline void
 mlxsw_reg_sfd_uc_tunnel_pack(char *payload, int rec_index,
 			     enum mlxsw_reg_sfd_rec_policy policy,
 			     const char *mac, u16 fid,
-			     enum mlxsw_reg_sfd_rec_action action, u32 uip,
+			     enum mlxsw_reg_sfd_rec_action action,
 			     enum mlxsw_reg_sfd_uc_tunnel_protocol proto)
 {
 	mlxsw_reg_sfd_rec_pack(payload, rec_index,
 			       MLXSW_REG_SFD_REC_TYPE_UNICAST_TUNNEL, mac,
 			       action);
 	mlxsw_reg_sfd_rec_policy_set(payload, rec_index, policy);
-	mlxsw_reg_sfd_uc_tunnel_uip_msb_set(payload, rec_index, uip >> 24);
-	mlxsw_reg_sfd_uc_tunnel_uip_lsb_set(payload, rec_index, uip);
 	mlxsw_reg_sfd_uc_tunnel_fid_set(payload, rec_index, fid);
 	mlxsw_reg_sfd_uc_tunnel_protocol_set(payload, rec_index, proto);
 }
 
+static inline void
+mlxsw_reg_sfd_uc_tunnel_pack4(char *payload, int rec_index,
+			      enum mlxsw_reg_sfd_rec_policy policy,
+			      const char *mac, u16 fid,
+			      enum mlxsw_reg_sfd_rec_action action, u32 uip)
+{
+	mlxsw_reg_sfd_uc_tunnel_uip_msb_set(payload, rec_index, uip >> 24);
+	mlxsw_reg_sfd_uc_tunnel_uip_lsb_set(payload, rec_index, uip);
+	mlxsw_reg_sfd_uc_tunnel_pack(payload, rec_index, policy, mac, fid,
+				     action,
+				     MLXSW_REG_SFD_UC_TUNNEL_PROTOCOL_IPV4);
+}
+
 enum mlxsw_reg_tunnel_port {
 	MLXSW_REG_TUNNEL_PORT_NVE,
 	MLXSW_REG_TUNNEL_PORT_VPLS,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index c5fd69a6bedd..53473647870d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1290,38 +1290,24 @@ static enum mlxsw_reg_sfd_op mlxsw_sp_sfd_op(bool adding)
 			MLXSW_REG_SFD_OP_WRITE_REMOVE;
 }
 
-static int mlxsw_sp_port_fdb_tunnel_uc_op(struct mlxsw_sp *mlxsw_sp,
-					  const char *mac, u16 fid,
-					  enum mlxsw_sp_l3proto proto,
-					  const union mlxsw_sp_l3addr *addr,
-					  bool adding, bool dynamic)
+static int
+mlxsw_sp_port_fdb_tun_uc_op4(struct mlxsw_sp *mlxsw_sp, bool dynamic,
+			     const char *mac, u16 fid, __be32 addr, bool adding)
 {
-	enum mlxsw_reg_sfd_uc_tunnel_protocol sfd_proto;
 	char *sfd_pl;
 	u8 num_rec;
 	u32 uip;
 	int err;
 
-	switch (proto) {
-	case MLXSW_SP_L3_PROTO_IPV4:
-		uip = be32_to_cpu(addr->addr4);
-		sfd_proto = MLXSW_REG_SFD_UC_TUNNEL_PROTOCOL_IPV4;
-		break;
-	case MLXSW_SP_L3_PROTO_IPV6:
-	default:
-		WARN_ON(1);
-		return -EOPNOTSUPP;
-	}
-
 	sfd_pl = kmalloc(MLXSW_REG_SFD_LEN, GFP_KERNEL);
 	if (!sfd_pl)
 		return -ENOMEM;
 
+	uip = be32_to_cpu(addr);
 	mlxsw_reg_sfd_pack(sfd_pl, mlxsw_sp_sfd_op(adding), 0);
-	mlxsw_reg_sfd_uc_tunnel_pack(sfd_pl, 0,
-				     mlxsw_sp_sfd_rec_policy(dynamic), mac, fid,
-				     MLXSW_REG_SFD_REC_ACTION_NOP, uip,
-				     sfd_proto);
+	mlxsw_reg_sfd_uc_tunnel_pack4(sfd_pl, 0,
+				      mlxsw_sp_sfd_rec_policy(dynamic), mac,
+				      fid, MLXSW_REG_SFD_REC_ACTION_NOP, uip);
 	num_rec = mlxsw_reg_sfd_num_rec_get(sfd_pl);
 	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfd), sfd_pl);
 	if (err)
@@ -1335,6 +1321,23 @@ static int mlxsw_sp_port_fdb_tunnel_uc_op(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
+static int mlxsw_sp_port_fdb_tunnel_uc_op(struct mlxsw_sp *mlxsw_sp,
+					  const char *mac, u16 fid,
+					  enum mlxsw_sp_l3proto proto,
+					  const union mlxsw_sp_l3addr *addr,
+					  bool adding, bool dynamic)
+{
+	switch (proto) {
+	case MLXSW_SP_L3_PROTO_IPV4:
+		return mlxsw_sp_port_fdb_tun_uc_op4(mlxsw_sp, dynamic, mac, fid,
+						    addr->addr4, adding);
+	case MLXSW_SP_L3_PROTO_IPV6:
+	default:
+		WARN_ON(1);
+		return -EOPNOTSUPP;
+	}
+}
+
 static int __mlxsw_sp_port_fdb_uc_op(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 				     const char *mac, u16 fid, bool adding,
 				     enum mlxsw_reg_sfd_rec_action action,
-- 
2.31.1

