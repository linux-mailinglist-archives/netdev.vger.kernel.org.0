Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2C7A4FB1
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 09:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbfIBHX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 03:23:26 -0400
Received: from mail-eopbgr10066.outbound.protection.outlook.com ([40.107.1.66]:47419
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726377AbfIBHXY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 03:23:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+muqtiNCYdOZC64JIQjZ9Fw22XAwEsmtTZkPpxcY08ziofhKW2H/k15+C23Jt5oGn78F1zF8Xj/6EVpUJf0zjHj55ngkOLUk4tdreNOq/GWNRQD/MIROZeCumh/aPdU2g82o1xP67BDFMHVY4Q0WtwPCM4GJeExLBmKa6aAgMVAg1WKCvj0HQ0sgjAFNW5gywm1+qjrOLAV1AKlh7uNwaoyl8tgjb51ifccEVwFbvxiGdHLBe0Usl6BVAA+RPWAQASgHCmhOHnUTJh0m0zheAF8C2SbYAuh+4cYPkNGNtLt5lOlfCFtxKLYkZue/CN+BmuH+tjCxClIDqxMfNMaRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKAkPV2yMtrzxW9d9pLZEqVD1jXmNi9CX30aPvv2YgM=;
 b=fm01K8zbpf7qpyetLv6+ULi5kxV3ur8tuS+MFql9QiKpeNTamWhbEnF0ccpJHvU1Qgk9zktFjF3Tpmswao68SvY557A1CBLgIwkhjTuHGP2xCJqN1NjQ2IqN7PnXbEn311ZlLQhse2FdS/KROWNExWUVnQuNQdvM+xm+HhVtswH4JxdFNvK886HSPl+GtML7amxVcP9tHWkdD+LsJe90oeRLPtdz0uTw7sJR0UqECHRfuEzcHTOaLDn9AJmCzW3crlKkSr5LLZj3GuFgCspCIsurRaOU1Vg5zntslc7blbGaJBuBG5tfFHHrndNoum72zP8rDTqgIjiCZVsc9UircQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKAkPV2yMtrzxW9d9pLZEqVD1jXmNi9CX30aPvv2YgM=;
 b=VmLXbvEKA6z1p7ryPcCXXUyUNY9DAfZrrfqkLrFvtr6+zA23CYulcn2S9BG+1UndJBABPAchbIrMU52N/MT1EkrgscdaypG7oHc0ftItu+bsoLVCqdQdQKGoVWWj9nETCjjGhpB5tJ2cdSf9hgtVzvpaxJh79d1dPPROuYCG40s=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2659.eurprd05.prod.outlook.com (10.172.215.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Mon, 2 Sep 2019 07:23:20 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 07:23:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/18] net/mlx5: DR, Expose APIs for direct rule managing
Thread-Topic: [net-next 13/18] net/mlx5: DR, Expose APIs for direct rule
 managing
Thread-Index: AQHVYV9L7AUSj2vzUE2Kvx4mQyQFfQ==
Date:   Mon, 2 Sep 2019 07:23:19 +0000
Message-ID: <20190902072213.7683-14-saeedm@mellanox.com>
References: <20190902072213.7683-1-saeedm@mellanox.com>
In-Reply-To: <20190902072213.7683-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 866c3466-1f86-4a86-e3e7-08d72f766e30
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2659;
x-ms-traffictypediagnostic: AM4PR0501MB2659:|AM4PR0501MB2659:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2659B5165315190202743948BEBE0@AM4PR0501MB2659.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(199004)(189003)(26005)(6506007)(6486002)(2906002)(36756003)(386003)(2616005)(446003)(102836004)(52116002)(316002)(86362001)(76176011)(6116002)(11346002)(3846002)(256004)(186003)(66066001)(476003)(7736002)(54906003)(107886003)(305945005)(25786009)(4326008)(99286004)(5660300002)(6436002)(53936002)(478600001)(6512007)(71190400001)(71200400001)(1076003)(8936002)(50226002)(486006)(14454004)(6916009)(66446008)(66476007)(66556008)(64756008)(81166006)(66946007)(81156014)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2659;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: asRciY+hIrWa8k1np/WcnJLuyAANMcS+WV06r2JOcb/c1KUFecpk82JyP5ASq26l6LTh4bTpJ4Uguy6Sy0O/K6cgbeyKWfxwsji5qyg1pXfazegvkHHVzzndCFUUzL+DLX2xX40HjujGgGm5xjXI0MVxhXBdnoXIqN7rqnC3vbwBP16QSa6D5ugNpnhCc5MfoHT8+RI5HYG1coUqPjXAovzMpsWr1kvAmhkdEoGEBeoSx2hyq6OaFzm7HzWCxKjshtzh6mz0qpYdPgRY04eYvVmCwDAH+WkC8AisGwdxezPL4TQyEa18Fc224CnW9I/ojYyz/YrWNvFPXywAbq43mL7Zlbs/NEaXuOGnS7Zjz9FY6NNXdfSj1KaifM9bCzn6qgH07YNrcl47zwIB8WzE+mhA1QKg4XaRX72mzRSGO7Q=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 866c3466-1f86-4a86-e3e7-08d72f766e30
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 07:23:20.0407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: il0R+b3l2+slZ86GD7FDBWXeGrjfKy2BlOXDbI4N8C/YPKWtTpq/o03fxuWpD5idN0sE4ghO/v2fIQMUQwZfYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2659
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Expose APIs for direct rule managing to increase insertion rate by
bypassing the firmware.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/mlx5dr.h      | 212 ++++++++++++++++++
 1 file changed, 212 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr=
.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
new file mode 100644
index 000000000000..adda9cbfba45
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -0,0 +1,212 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019, Mellanox Technologies */
+
+#ifndef _MLX5DR_H_
+#define _MLX5DR_H_
+
+struct mlx5dr_domain;
+struct mlx5dr_table;
+struct mlx5dr_matcher;
+struct mlx5dr_rule;
+struct mlx5dr_action;
+
+enum mlx5dr_domain_type {
+	MLX5DR_DOMAIN_TYPE_NIC_RX,
+	MLX5DR_DOMAIN_TYPE_NIC_TX,
+	MLX5DR_DOMAIN_TYPE_FDB,
+};
+
+enum mlx5dr_domain_sync_flags {
+	MLX5DR_DOMAIN_SYNC_FLAGS_SW =3D 1 << 0,
+	MLX5DR_DOMAIN_SYNC_FLAGS_HW =3D 1 << 1,
+};
+
+enum mlx5dr_action_reformat_type {
+	DR_ACTION_REFORMAT_TYP_TNL_L2_TO_L2,
+	DR_ACTION_REFORMAT_TYP_L2_TO_TNL_L2,
+	DR_ACTION_REFORMAT_TYP_TNL_L3_TO_L2,
+	DR_ACTION_REFORMAT_TYP_L2_TO_TNL_L3,
+};
+
+struct mlx5dr_match_parameters {
+	size_t match_sz;
+	u64 *match_buf; /* Device spec format */
+};
+
+#ifdef CONFIG_MLX5_SW_STEERING
+
+struct mlx5dr_domain *
+mlx5dr_domain_create(struct mlx5_core_dev *mdev, enum mlx5dr_domain_type t=
ype);
+
+int mlx5dr_domain_destroy(struct mlx5dr_domain *domain);
+
+int mlx5dr_domain_sync(struct mlx5dr_domain *domain, u32 flags);
+
+void mlx5dr_domain_set_peer(struct mlx5dr_domain *dmn,
+			    struct mlx5dr_domain *peer_dmn);
+
+struct mlx5dr_table *
+mlx5dr_table_create(struct mlx5dr_domain *domain, u32 level);
+
+int mlx5dr_table_destroy(struct mlx5dr_table *table);
+
+u32 mlx5dr_table_get_id(struct mlx5dr_table *table);
+
+struct mlx5dr_matcher *
+mlx5dr_matcher_create(struct mlx5dr_table *table,
+		      u16 priority,
+		      u8 match_criteria_enable,
+		      struct mlx5dr_match_parameters *mask);
+
+int mlx5dr_matcher_destroy(struct mlx5dr_matcher *matcher);
+
+struct mlx5dr_rule *
+mlx5dr_rule_create(struct mlx5dr_matcher *matcher,
+		   struct mlx5dr_match_parameters *value,
+		   size_t num_actions,
+		   struct mlx5dr_action *actions[]);
+
+int mlx5dr_rule_destroy(struct mlx5dr_rule *rule);
+
+int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
+				 struct mlx5dr_action *action);
+
+struct mlx5dr_action *
+mlx5dr_action_create_dest_table(struct mlx5dr_table *table);
+
+struct mlx5dr_action *
+mlx5dr_create_action_dest_flow_fw_table(struct mlx5_flow_table *ft,
+					struct mlx5_core_dev *mdev);
+
+struct mlx5dr_action *
+mlx5dr_action_create_dest_vport(struct mlx5dr_domain *domain,
+				u32 vport, u8 vhca_id_valid,
+				u16 vhca_id);
+
+struct mlx5dr_action *mlx5dr_action_create_drop(void);
+
+struct mlx5dr_action *mlx5dr_action_create_tag(u32 tag_value);
+
+struct mlx5dr_action *
+mlx5dr_action_create_flow_counter(u32 counter_id);
+
+struct mlx5dr_action *
+mlx5dr_action_create_packet_reformat(struct mlx5dr_domain *dmn,
+				     enum mlx5dr_action_reformat_type reformat_type,
+				     size_t data_sz,
+				     void *data);
+
+struct mlx5dr_action *
+mlx5dr_action_create_modify_header(struct mlx5dr_domain *domain,
+				   u32 flags,
+				   size_t actions_sz,
+				   __be64 actions[]);
+
+struct mlx5dr_action *mlx5dr_action_create_pop_vlan(void);
+
+struct mlx5dr_action *
+mlx5dr_action_create_push_vlan(struct mlx5dr_domain *domain, __be32 vlan_h=
dr);
+
+int mlx5dr_action_destroy(struct mlx5dr_action *action);
+
+static inline bool
+mlx5dr_is_supported(struct mlx5_core_dev *dev)
+{
+	return MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner);
+}
+
+#else /* CONFIG_MLX5_SW_STEERING */
+
+static inline struct mlx5dr_domain *
+mlx5dr_domain_create(struct mlx5_core_dev *mdev, enum mlx5dr_domain_type t=
ype) { return NULL; }
+
+static inline int
+mlx5dr_domain_destroy(struct mlx5dr_domain *domain) { return 0; }
+
+static inline int
+mlx5dr_domain_sync(struct mlx5dr_domain *domain, u32 flags) { return 0; }
+
+static inline void
+mlx5dr_domain_set_peer(struct mlx5dr_domain *dmn,
+		       struct mlx5dr_domain *peer_dmn) { }
+
+static inline struct mlx5dr_table *
+mlx5dr_table_create(struct mlx5dr_domain *domain, u32 level) { return NULL=
; }
+
+static inline int
+mlx5dr_table_destroy(struct mlx5dr_table *table) { return 0; }
+
+static inline u32
+mlx5dr_table_get_id(struct mlx5dr_table *table) { return 0; }
+
+static inline struct mlx5dr_matcher *
+mlx5dr_matcher_create(struct mlx5dr_table *table,
+		      u16 priority,
+		      u8 match_criteria_enable,
+		      struct mlx5dr_match_parameters *mask) { return NULL; }
+
+static inline int
+mlx5dr_matcher_destroy(struct mlx5dr_matcher *matcher) { return 0; }
+
+static inline struct mlx5dr_rule *
+mlx5dr_rule_create(struct mlx5dr_matcher *matcher,
+		   struct mlx5dr_match_parameters *value,
+		   size_t num_actions,
+		   struct mlx5dr_action *actions[]) { return NULL; }
+
+static inline int
+mlx5dr_rule_destroy(struct mlx5dr_rule *rule) { return 0; }
+
+static inline int
+mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
+			     struct mlx5dr_action *action) { return 0; }
+
+static inline struct mlx5dr_action *
+mlx5dr_action_create_dest_table(struct mlx5dr_table *table) { return NULL;=
 }
+
+static inline struct mlx5dr_action *
+mlx5dr_create_action_dest_flow_fw_table(struct mlx5_flow_table *ft,
+					struct mlx5_core_dev *mdev) { return NULL; }
+
+static inline struct mlx5dr_action *
+mlx5dr_action_create_dest_vport(struct mlx5dr_domain *domain,
+				u32 vport, u8 vhca_id_valid,
+				u16 vhca_id) { return NULL; }
+
+static inline struct mlx5dr_action *
+mlx5dr_action_create_drop(void) { return NULL; }
+
+static inline struct mlx5dr_action *
+mlx5dr_action_create_tag(u32 tag_value) { return NULL; }
+
+static inline struct mlx5dr_action *
+mlx5dr_action_create_flow_counter(u32 counter_id) { return NULL; }
+
+static inline struct mlx5dr_action *
+mlx5dr_action_create_packet_reformat(struct mlx5dr_domain *dmn,
+				     enum mlx5dr_action_reformat_type reformat_type,
+				     size_t data_sz,
+				     void *data) { return NULL; }
+
+static inline struct mlx5dr_action *
+mlx5dr_action_create_modify_header(struct mlx5dr_domain *domain,
+				   u32 flags,
+				   size_t actions_sz,
+				   __be64 actions[]) { return NULL; }
+
+static inline struct mlx5dr_action *
+mlx5dr_action_create_pop_vlan(void) { return NULL; }
+
+static inline struct mlx5dr_action *
+mlx5dr_action_create_push_vlan(struct mlx5dr_domain *domain,
+			       __be32 vlan_hdr) { return NULL; }
+
+static inline int
+mlx5dr_action_destroy(struct mlx5dr_action *action) { return 0; }
+
+static inline bool
+mlx5dr_is_supported(struct mlx5_core_dev *dev) { return false; }
+
+#endif /* CONFIG_MLX5_SW_STEERING */
+
+#endif /* _MLX5DR_H_ */
--=20
2.21.0

