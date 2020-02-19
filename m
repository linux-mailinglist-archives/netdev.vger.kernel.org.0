Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5E3163ACA
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgBSDGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:06:43 -0500
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:65095
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728202AbgBSDGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:06:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BzsgPzPXHxD3T8Uo5LpVhftFyg/yRWS4LOQi+CtrBdDZZ+njk9gzEmlOaMqAUaCgEp4UChOnRy/ts2QEvMF3ESKIT/0SpwcdYm0m9NnYMbN/O9NupN01xo9Ro5/2rComLwAjnl6aa0HT9GeRKIdDiVn1EPZamrCH/aRRzYfbn0I1BbFgk3X/AG8nfgrg7wzkVO1KQPblavNHtBxwVj2FMHek9bKtyYqRwtpghDUdKhQ28yYqV3yOQAVnc9i624gwPqfg3V699MIY7QCFiHHZUXil94CEf50s4hgdxnP51Rs+DjYRkyUZWjZxb8NJrej9JIffz1oEuPzr2lFrJt7+1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVbttkziMmv8E3YVJRA56WxKfP3Mo04GmWp5eRjoT4s=;
 b=i/KZQhv7xPFf24wz0hudKuUOQ9mhY8K3sh0/o7QLhJVXPJdTbgTcszXzL1c82HoE2g12c8kLYzMigz3SAbGOtKWyGPC3US2OqYFwLcnEy1HyS0ThIISoRsuGlEl5PlkW7JIfexa0RWkOhI2WWIQWyoCu68GVQHnEdUtcvkx/5UPwhVSfWS7scJ71+//9vgR1/9iZS9EF3KBLgzJ5TANJVViySoamVW2z/20GGseUYj95MP5VoefgLTjpPbsXPW/aJ6gGEApoxLVtzFnGo2bCiSfC7PiXdSzBlukTSlpAOE1xFzyMTWEAVtvbruD9S/j9fYvji6ltK2kCcBSVnODgpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVbttkziMmv8E3YVJRA56WxKfP3Mo04GmWp5eRjoT4s=;
 b=qNYXmzIO4RVnyV1KLBdk6nxMb3RTYhsVprDVNEawyJ7Y8hfcPvcKx/0DoYG05kByWleHAf5F39RbFzXH7riEnht9i9UzQdEG5hE+iJVRzmbEvU+N5SNiy8QyPvAOy4QNORY2v5MJ8+PjGBikkdzCrUfjNw8Uyb+2Y5IkouUmSS4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5853.eurprd05.prod.outlook.com (20.178.125.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Wed, 19 Feb 2020 03:06:39 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:06:39 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0089.namprd05.prod.outlook.com (2603:10b6:a03:e0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.6 via Frontend Transport; Wed, 19 Feb 2020 03:06:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 7/7] net/mlx5: DR, Handle reformat capability over sw-steering
 tables
Thread-Topic: [net 7/7] net/mlx5: DR, Handle reformat capability over
 sw-steering tables
Thread-Index: AQHV5tGaMDCbcNkRsEuBOtwhe/DgtA==
Date:   Wed, 19 Feb 2020 03:06:39 +0000
Message-ID: <20200219030548.13215-8-saeedm@mellanox.com>
References: <20200219030548.13215-1-saeedm@mellanox.com>
In-Reply-To: <20200219030548.13215-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0089.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 79c756c8-48ac-407a-3c89-08d7b4e8bce3
x-ms-traffictypediagnostic: VI1PR05MB5853:|VI1PR05MB5853:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB585361AD5F18DF4918297F69BE100@VI1PR05MB5853.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(189003)(199004)(956004)(2616005)(5660300002)(26005)(16526019)(81166006)(52116002)(4326008)(110136005)(316002)(6506007)(186003)(81156014)(2906002)(8936002)(66476007)(8676002)(54906003)(1076003)(64756008)(6512007)(71200400001)(478600001)(66556008)(66446008)(86362001)(36756003)(6486002)(107886003)(66946007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5853;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wpb/FajH86NH0e4XgLtM8qDsRJF8uRLIYNrWxiycXGybEhUJx6jZ6iquLHtgJrW+yn1Cen0ZBK3F4eimFrqLhzQJ3KnYy6Q2it/JAPAmLebZBqgCnjpgONdWvzDnKzlWlHC/a3L6LS4c0vQyh7cSa/qNd8ZU2zuR7XfaLSFnMVAJ9CSTLxTKKLXxAtRvEdIUNMqhE+aoLifT5PtPoSybjfiGpuRpQHAD1osGc9o+/bo3zAJFsFoEQP57erM44spz+PeaoIW9Jl5FUxTTDl0WBUxKT3tVrja6YgLN1X/VJhwihvhDx9V6aMNXObUFb6VE4RgHzwFWt4XU68QBZj/d86Ciaj4werGuAkvvlRIztmHFmVPrOlce0ooW+F7To39nb8qWOpK53XhRKo+nGAd5K9hLQRpFx69iyVx9/ZSKu4LdKJoCtiBe7koPxz6ISs5NsSpzczlyckLPvUgMsDP/7wWfk91zdH7pxyPrpxw1ypoZm+iRuSAvMD981qTzcYzHorDJ14GjqGI8dnOvL13GDGH8tzZVKubDuxpujL9Ptqg=
x-ms-exchange-antispam-messagedata: orM1QIJU3F6HH3SiBU4fLAc3GuRVpkimOmVKTXVq8/ojKNLY4VFJklQrTIYokn6jiGBwABWKgmlGdWH50Q+SBaq48vo10HtHf5W40iWDOoCpYCgRJOyO1zAgTyNNP3vpqPjYaCo6RSSgzdGwiBsoRQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79c756c8-48ac-407a-3c89-08d7b4e8bce3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:06:39.5013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R1wa5GptNU9OA9H5Brjw4Wc4GwYcHx1YfIIKMBVrj3gf7/8PymkvcCWJ9p1lTpF91SeGzAMoaAGqH+YFTWoOng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5853
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

On flow table creation, send the relevant flags according to what the FW
currently supports.
When FW doesn't support reformat option over SW-steering managed table,
the driver shouldn't pass this.

Fixes: 988fd6b32d07 ("net/mlx5: DR, Pass table flags at creation to lower l=
ayer")
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c | 9 +++++++--
 include/linux/mlx5/mlx5_ifc.h                            | 5 ++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 3abfc8125926..c2027192e21e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -66,15 +66,20 @@ static int mlx5_cmd_dr_create_flow_table(struct mlx5_fl=
ow_root_namespace *ns,
 					 struct mlx5_flow_table *next_ft)
 {
 	struct mlx5dr_table *tbl;
+	u32 flags;
 	int err;
=20
 	if (mlx5_dr_is_fw_table(ft->flags))
 		return mlx5_fs_cmd_get_fw_cmds()->create_flow_table(ns, ft,
 								    log_size,
 								    next_ft);
+	flags =3D ft->flags;
+	/* turn off encap/decap if not supported for sw-str by fw */
+	if (!MLX5_CAP_FLOWTABLE(ns->dev, sw_owner_reformat_supported))
+		flags =3D ft->flags & ~(MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
+				      MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
=20
-	tbl =3D mlx5dr_table_create(ns->fs_dr_domain.dr_domain,
-				  ft->level, ft->flags);
+	tbl =3D mlx5dr_table_create(ns->fs_dr_domain.dr_domain, ft->level, flags)=
;
 	if (!tbl) {
 		mlx5_core_err(ns->dev, "Failed creating dr flow_table\n");
 		return -EINVAL;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ff8c9d527bb4..bfdf41537cf1 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -688,7 +688,10 @@ struct mlx5_ifc_flow_table_nic_cap_bits {
 	u8         nic_rx_multi_path_tirs[0x1];
 	u8         nic_rx_multi_path_tirs_fts[0x1];
 	u8         allow_sniffer_and_nic_rx_shared_tir[0x1];
-	u8	   reserved_at_3[0x1d];
+	u8	   reserved_at_3[0x4];
+	u8	   sw_owner_reformat_supported[0x1];
+	u8	   reserved_at_8[0x18];
+
 	u8	   encap_general_header[0x1];
 	u8	   reserved_at_21[0xa];
 	u8	   log_max_packet_reformat_context[0x5];
--=20
2.24.1

