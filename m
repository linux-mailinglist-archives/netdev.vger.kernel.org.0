Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D08A4FBA
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 09:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbfIBHXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 03:23:45 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:51171
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729735AbfIBHXn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 03:23:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijjgC87gl+jaNHK7nmv6GKC1b1JJ3zUrMpAcM+qbZ4WuvrXs8SrvcvMaSPHtmPVVPg5dbNM/B5F8ai2ejJgG4Kf6pdfvOYPZVJWn2hMHzuIEm6UUXG7PjY0Nu1WMH7TxuMzJ4lfYcywq+bthnBl6E8DbxmnBqo3ziCUqlnOnd8RBhREouPGEQDhzO6+f968jD4QzH7mGJDNKb1pj4pJMH7TYYuj7x9Q7rzuppq3ua5C99+FZCdH0GHBvqohmxYjukqqzB7ei3txkh474hcTWL0NClm/Pzgfn/9W6tfzJhnmxhacylpOvxvCPwUELeemnBMc8EwHxg+Z8UngbzZawSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TofLDYzS7b/qNVxQ1zm+m5qTiOxoI3odo29q96a9pJA=;
 b=h7Mv9pXFVU01/dySTpukDTXjbTlkpzSAcdq2I4H4aOP5BjK5PdhHOeg3Bf7ZiW3Xpo4y96iNs+nYwe9XhaEHM6LsSImMYnvffVlr3hta4AcxS9DlyjvAo62sLpg6+1FvIEm6/ZW+W0LkRzds3mRWS6nedfbl9I/xTM7ciRM5U0/9d6rwwKDKOZhrPWCwZOq2c9Ai8NEGWI4NFIMK+VaYyLP0PemcC+QFA3CQu9FvE7gplW8URBBsg54nIXr4RuOAelW26w06RmuDrMKNt9NFL7Ij1FQBCWRhbsJW0bc5zk1H26Ibq6af456o0dbOUZVwfOsMAT9Yychy9xBE5X1Yxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TofLDYzS7b/qNVxQ1zm+m5qTiOxoI3odo29q96a9pJA=;
 b=NjtccAhXUtzCIskn8b49mzROhdSv6xDl6oDx9lzANvgBAaqXJqMAG5hVfjgS1lDcAaUqrnQnbNXezlc6pr6r/jWqt6tPtqRyn1NUG31V9FmvPIVVW2QJMPDXz5CFkTl2Jr1967fprudiZvLqRoGlKN/UN4dqK3A1NokKGOLQ9nQ=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2259.eurprd05.prod.outlook.com (10.165.38.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Mon, 2 Sep 2019 07:23:16 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 07:23:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/18] net/mlx5: DR, Expose steering rule functionality
Thread-Topic: [net-next 11/18] net/mlx5: DR, Expose steering rule
 functionality
Thread-Index: AQHVYV9JsYMzUBjt6kmpK4pzj1yMLw==
Date:   Mon, 2 Sep 2019 07:23:15 +0000
Message-ID: <20190902072213.7683-12-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 0c3306be-903f-4893-bbfc-08d72f766b7e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2259;
x-ms-traffictypediagnostic: AM4PR0501MB2259:|AM4PR0501MB2259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2259FBB0E3445CFF5300C6FEBEBE0@AM4PR0501MB2259.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(64756008)(478600001)(66946007)(66556008)(71190400001)(71200400001)(6916009)(5660300002)(54906003)(6486002)(8676002)(14454004)(81156014)(36756003)(81166006)(76176011)(1076003)(186003)(50226002)(99286004)(25786009)(4326008)(8936002)(316002)(30864003)(102836004)(386003)(6506007)(2906002)(26005)(14444005)(5024004)(3846002)(256004)(6116002)(2616005)(66066001)(86362001)(53936002)(52116002)(53946003)(107886003)(486006)(6436002)(305945005)(7736002)(6512007)(446003)(476003)(66446008)(11346002)(66476007)(579004)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2259;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pAQCRiL8NcSwuGbNXROvKUYSWBVJAOPuKY0pqK8O8Ih4SsivQG3/yjDZRdJKjcA3/NcSVzlNjX0YKEl+B597CazEzNklIcgDdyaQ+ZNPKfRf75uKAHVda/XSzGihhmMIod+HAqTXUeFIK9+wBB7Nix/XROM1SZYJD2qLxYhuUjcJVGCjOIYXTLQ4iLE03u/7AoLfGjVUtcjw+KRiFD60m8/gL0VhP7G+kkYdSFIsjxF/nLdbnuKTYbpmEFepLTOriYMt19K8yGflBfleNlgPqcAALHlARNPc3vUvW8Jp3INdqGwkBfyOLknCsHxkhWxkl10LaPyEQueZmnvUpv9rATCO5Rf3W6EaGQ/vTOgf5y7+OQAqH2wvz/8WeWHmXGt8r9DLd5khNf7voGxg1gfs/Pg6sS+FUszZz3TdKq4D7uI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c3306be-903f-4893-bbfc-08d72f766b7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 07:23:15.9125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dAGeoghlFA8bpHHb5zkLh5LHI2Pgh6JPxL9q/h1QvYrIOX5OjQYOoMyQL0mX3E/Bs5B+paXnIQJ+39NkICBCvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2259
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Rules are the actual objects that tie matchers, header values and
actions. Each rule belongs to a matcher, which can hold multiple rules
sharing the same mask. Each rule is a specific set of values and
actions.
When a packet reaches a matcher it is being matched against the
matcher`s rules. In case of a match over a rule its actions will be
executed. Each rule object contains a set of STEs, where each STE is a
definition of match values and actions defined by the rule.
This file handles the rule operations and processing.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_rule.c     | 1243 +++++++++++++++++
 1 file changed, 1243 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rul=
e.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
new file mode 100644
index 000000000000..3bc3f66b8fa8
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -0,0 +1,1243 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include "dr_types.h"
+
+#define DR_RULE_MAX_STE_CHAIN (DR_RULE_MAX_STES + DR_ACTION_MAX_STES)
+
+struct mlx5dr_rule_action_member {
+	struct mlx5dr_action *action;
+	struct list_head list;
+};
+
+static int dr_rule_append_to_miss_list(struct mlx5dr_ste *new_last_ste,
+				       struct list_head *miss_list,
+				       struct list_head *send_list)
+{
+	struct mlx5dr_ste_send_info *ste_info_last;
+	struct mlx5dr_ste *last_ste;
+
+	/* The new entry will be inserted after the last */
+	last_ste =3D list_entry(miss_list->prev, struct mlx5dr_ste, miss_list_nod=
e);
+	WARN_ON(!last_ste);
+
+	ste_info_last =3D kzalloc(sizeof(*ste_info_last), GFP_KERNEL);
+	if (!ste_info_last)
+		return -ENOMEM;
+
+	mlx5dr_ste_set_miss_addr(last_ste->hw_ste,
+				 mlx5dr_ste_get_icm_addr(new_last_ste));
+	list_add_tail(&new_last_ste->miss_list_node, miss_list);
+
+	mlx5dr_send_fill_and_append_ste_send_info(last_ste, DR_STE_SIZE_REDUCED,
+						  0, last_ste->hw_ste,
+						  ste_info_last, send_list, true);
+
+	return 0;
+}
+
+static struct mlx5dr_ste *
+dr_rule_create_collision_htbl(struct mlx5dr_matcher *matcher,
+			      struct mlx5dr_matcher_rx_tx *nic_matcher,
+			      u8 *hw_ste)
+{
+	struct mlx5dr_domain *dmn =3D matcher->tbl->dmn;
+	struct mlx5dr_ste_htbl *new_htbl;
+	struct mlx5dr_ste *ste;
+
+	/* Create new table for miss entry */
+	new_htbl =3D mlx5dr_ste_htbl_alloc(dmn->ste_icm_pool,
+					 DR_CHUNK_SIZE_1,
+					 MLX5DR_STE_LU_TYPE_DONT_CARE,
+					 0);
+	if (!new_htbl) {
+		mlx5dr_dbg(dmn, "Failed allocating collision table\n");
+		return NULL;
+	}
+
+	/* One and only entry, never grows */
+	ste =3D new_htbl->ste_arr;
+	mlx5dr_ste_set_miss_addr(hw_ste, nic_matcher->e_anchor->chunk->icm_addr);
+	mlx5dr_htbl_get(new_htbl);
+
+	return ste;
+}
+
+static struct mlx5dr_ste *
+dr_rule_create_collision_entry(struct mlx5dr_matcher *matcher,
+			       struct mlx5dr_matcher_rx_tx *nic_matcher,
+			       u8 *hw_ste,
+			       struct mlx5dr_ste *orig_ste)
+{
+	struct mlx5dr_ste *ste;
+
+	ste =3D dr_rule_create_collision_htbl(matcher, nic_matcher, hw_ste);
+	if (!ste) {
+		mlx5dr_dbg(matcher->tbl->dmn, "Failed creating collision entry\n");
+		return NULL;
+	}
+
+	ste->ste_chain_location =3D orig_ste->ste_chain_location;
+
+	/* In collision entry, all members share the same miss_list_head */
+	ste->htbl->miss_list =3D mlx5dr_ste_get_miss_list(orig_ste);
+
+	/* Next table */
+	if (mlx5dr_ste_create_next_htbl(matcher, nic_matcher, ste, hw_ste,
+					DR_CHUNK_SIZE_1)) {
+		mlx5dr_dbg(matcher->tbl->dmn, "Failed allocating table\n");
+		goto free_tbl;
+	}
+
+	return ste;
+
+free_tbl:
+	mlx5dr_ste_free(ste, matcher, nic_matcher);
+	return NULL;
+}
+
+static int
+dr_rule_handle_one_ste_in_update_list(struct mlx5dr_ste_send_info *ste_inf=
o,
+				      struct mlx5dr_domain *dmn)
+{
+	int ret;
+
+	list_del(&ste_info->send_list);
+	ret =3D mlx5dr_send_postsend_ste(dmn, ste_info->ste, ste_info->data,
+				       ste_info->size, ste_info->offset);
+	if (ret)
+		goto out;
+	/* Copy data to ste, only reduced size, the last 16B (mask)
+	 * is already written to the hw.
+	 */
+	memcpy(ste_info->ste->hw_ste, ste_info->data, DR_STE_SIZE_REDUCED);
+
+out:
+	kfree(ste_info);
+	return ret;
+}
+
+static int dr_rule_send_update_list(struct list_head *send_ste_list,
+				    struct mlx5dr_domain *dmn,
+				    bool is_reverse)
+{
+	struct mlx5dr_ste_send_info *ste_info, *tmp_ste_info;
+	int ret;
+
+	if (is_reverse) {
+		list_for_each_entry_safe_reverse(ste_info, tmp_ste_info,
+						 send_ste_list, send_list) {
+			ret =3D dr_rule_handle_one_ste_in_update_list(ste_info,
+								    dmn);
+			if (ret)
+				return ret;
+		}
+	} else {
+		list_for_each_entry_safe(ste_info, tmp_ste_info,
+					 send_ste_list, send_list) {
+			ret =3D dr_rule_handle_one_ste_in_update_list(ste_info,
+								    dmn);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static struct mlx5dr_ste *
+dr_rule_find_ste_in_miss_list(struct list_head *miss_list, u8 *hw_ste)
+{
+	struct mlx5dr_ste *ste;
+
+	if (list_empty(miss_list))
+		return NULL;
+
+	/* Check if hw_ste is present in the list */
+	list_for_each_entry(ste, miss_list, miss_list_node) {
+		if (mlx5dr_ste_equal_tag(ste->hw_ste, hw_ste))
+			return ste;
+	}
+
+	return NULL;
+}
+
+static struct mlx5dr_ste *
+dr_rule_rehash_handle_collision(struct mlx5dr_matcher *matcher,
+				struct mlx5dr_matcher_rx_tx *nic_matcher,
+				struct list_head *update_list,
+				struct mlx5dr_ste *col_ste,
+				u8 *hw_ste)
+{
+	struct mlx5dr_ste *new_ste;
+	int ret;
+
+	new_ste =3D dr_rule_create_collision_htbl(matcher, nic_matcher, hw_ste);
+	if (!new_ste)
+		return NULL;
+
+	/* In collision entry, all members share the same miss_list_head */
+	new_ste->htbl->miss_list =3D mlx5dr_ste_get_miss_list(col_ste);
+
+	/* Update the previous from the list */
+	ret =3D dr_rule_append_to_miss_list(new_ste,
+					  mlx5dr_ste_get_miss_list(col_ste),
+					  update_list);
+	if (ret) {
+		mlx5dr_dbg(matcher->tbl->dmn, "Failed update dup entry\n");
+		goto err_exit;
+	}
+
+	return new_ste;
+
+err_exit:
+	mlx5dr_ste_free(new_ste, matcher, nic_matcher);
+	return NULL;
+}
+
+static void dr_rule_rehash_copy_ste_ctrl(struct mlx5dr_matcher *matcher,
+					 struct mlx5dr_matcher_rx_tx *nic_matcher,
+					 struct mlx5dr_ste *cur_ste,
+					 struct mlx5dr_ste *new_ste)
+{
+	new_ste->next_htbl =3D cur_ste->next_htbl;
+	new_ste->ste_chain_location =3D cur_ste->ste_chain_location;
+
+	if (!mlx5dr_ste_is_last_in_rule(nic_matcher, new_ste->ste_chain_location)=
)
+		new_ste->next_htbl->pointing_ste =3D new_ste;
+
+	/* We need to copy the refcount since this ste
+	 * may have been traversed several times
+	 */
+	refcount_set(&new_ste->refcount, refcount_read(&cur_ste->refcount));
+
+	/* Link old STEs rule_mem list to the new ste */
+	mlx5dr_rule_update_rule_member(cur_ste, new_ste);
+	INIT_LIST_HEAD(&new_ste->rule_list);
+	list_splice_tail_init(&cur_ste->rule_list, &new_ste->rule_list);
+}
+
+static struct mlx5dr_ste *
+dr_rule_rehash_copy_ste(struct mlx5dr_matcher *matcher,
+			struct mlx5dr_matcher_rx_tx *nic_matcher,
+			struct mlx5dr_ste *cur_ste,
+			struct mlx5dr_ste_htbl *new_htbl,
+			struct list_head *update_list)
+{
+	struct mlx5dr_ste_send_info *ste_info;
+	bool use_update_list =3D false;
+	u8 hw_ste[DR_STE_SIZE] =3D {};
+	struct mlx5dr_ste *new_ste;
+	int new_idx;
+	u8 sb_idx;
+
+	/* Copy STE mask from the matcher */
+	sb_idx =3D cur_ste->ste_chain_location - 1;
+	mlx5dr_ste_set_bit_mask(hw_ste, nic_matcher->ste_builder[sb_idx].bit_mask=
);
+
+	/* Copy STE control and tag */
+	memcpy(hw_ste, cur_ste->hw_ste, DR_STE_SIZE_REDUCED);
+	mlx5dr_ste_set_miss_addr(hw_ste, nic_matcher->e_anchor->chunk->icm_addr);
+
+	new_idx =3D mlx5dr_ste_calc_hash_index(hw_ste, new_htbl);
+	new_ste =3D &new_htbl->ste_arr[new_idx];
+
+	if (mlx5dr_ste_not_used_ste(new_ste)) {
+		mlx5dr_htbl_get(new_htbl);
+		list_add_tail(&new_ste->miss_list_node,
+			      mlx5dr_ste_get_miss_list(new_ste));
+	} else {
+		new_ste =3D dr_rule_rehash_handle_collision(matcher,
+							  nic_matcher,
+							  update_list,
+							  new_ste,
+							  hw_ste);
+		if (!new_ste) {
+			mlx5dr_dbg(matcher->tbl->dmn, "Failed adding collision entry, index: %d=
\n",
+				   new_idx);
+			return NULL;
+		}
+		new_htbl->ctrl.num_of_collisions++;
+		use_update_list =3D true;
+	}
+
+	memcpy(new_ste->hw_ste, hw_ste, DR_STE_SIZE_REDUCED);
+
+	new_htbl->ctrl.num_of_valid_entries++;
+
+	if (use_update_list) {
+		ste_info =3D kzalloc(sizeof(*ste_info), GFP_KERNEL);
+		if (!ste_info)
+			goto err_exit;
+
+		mlx5dr_send_fill_and_append_ste_send_info(new_ste, DR_STE_SIZE, 0,
+							  hw_ste, ste_info,
+							  update_list, true);
+	}
+
+	dr_rule_rehash_copy_ste_ctrl(matcher, nic_matcher, cur_ste, new_ste);
+
+	return new_ste;
+
+err_exit:
+	mlx5dr_ste_free(new_ste, matcher, nic_matcher);
+	return NULL;
+}
+
+static int dr_rule_rehash_copy_miss_list(struct mlx5dr_matcher *matcher,
+					 struct mlx5dr_matcher_rx_tx *nic_matcher,
+					 struct list_head *cur_miss_list,
+					 struct mlx5dr_ste_htbl *new_htbl,
+					 struct list_head *update_list)
+{
+	struct mlx5dr_ste *tmp_ste, *cur_ste, *new_ste;
+
+	if (list_empty(cur_miss_list))
+		return 0;
+
+	list_for_each_entry_safe(cur_ste, tmp_ste, cur_miss_list, miss_list_node)=
 {
+		new_ste =3D dr_rule_rehash_copy_ste(matcher,
+						  nic_matcher,
+						  cur_ste,
+						  new_htbl,
+						  update_list);
+		if (!new_ste)
+			goto err_insert;
+
+		list_del(&cur_ste->miss_list_node);
+		mlx5dr_htbl_put(cur_ste->htbl);
+	}
+	return 0;
+
+err_insert:
+	mlx5dr_err(matcher->tbl->dmn, "Fatal error during resize\n");
+	WARN_ON(true);
+	return -EINVAL;
+}
+
+static int dr_rule_rehash_copy_htbl(struct mlx5dr_matcher *matcher,
+				    struct mlx5dr_matcher_rx_tx *nic_matcher,
+				    struct mlx5dr_ste_htbl *cur_htbl,
+				    struct mlx5dr_ste_htbl *new_htbl,
+				    struct list_head *update_list)
+{
+	struct mlx5dr_ste *cur_ste;
+	int cur_entries;
+	int err =3D 0;
+	int i;
+
+	cur_entries =3D mlx5dr_icm_pool_chunk_size_to_entries(cur_htbl->chunk_siz=
e);
+
+	if (cur_entries < 1) {
+		mlx5dr_dbg(matcher->tbl->dmn, "Invalid number of entries\n");
+		return -EINVAL;
+	}
+
+	for (i =3D 0; i < cur_entries; i++) {
+		cur_ste =3D &cur_htbl->ste_arr[i];
+		if (mlx5dr_ste_not_used_ste(cur_ste)) /* Empty, nothing to copy */
+			continue;
+
+		err =3D dr_rule_rehash_copy_miss_list(matcher,
+						    nic_matcher,
+						    mlx5dr_ste_get_miss_list(cur_ste),
+						    new_htbl,
+						    update_list);
+		if (err)
+			goto clean_copy;
+	}
+
+clean_copy:
+	return err;
+}
+
+static struct mlx5dr_ste_htbl *
+dr_rule_rehash_htbl(struct mlx5dr_rule *rule,
+		    struct mlx5dr_rule_rx_tx *nic_rule,
+		    struct mlx5dr_ste_htbl *cur_htbl,
+		    u8 ste_location,
+		    struct list_head *update_list,
+		    enum mlx5dr_icm_chunk_size new_size)
+{
+	struct mlx5dr_ste_send_info *del_ste_info, *tmp_ste_info;
+	struct mlx5dr_matcher *matcher =3D rule->matcher;
+	struct mlx5dr_domain *dmn =3D matcher->tbl->dmn;
+	struct mlx5dr_matcher_rx_tx *nic_matcher;
+	struct mlx5dr_ste_send_info *ste_info;
+	struct mlx5dr_htbl_connect_info info;
+	struct mlx5dr_domain_rx_tx *nic_dmn;
+	u8 formatted_ste[DR_STE_SIZE] =3D {};
+	LIST_HEAD(rehash_table_send_list);
+	struct mlx5dr_ste *ste_to_update;
+	struct mlx5dr_ste_htbl *new_htbl;
+	int err;
+
+	nic_matcher =3D nic_rule->nic_matcher;
+	nic_dmn =3D nic_matcher->nic_tbl->nic_dmn;
+
+	ste_info =3D kzalloc(sizeof(*ste_info), GFP_KERNEL);
+	if (!ste_info)
+		return NULL;
+
+	new_htbl =3D mlx5dr_ste_htbl_alloc(dmn->ste_icm_pool,
+					 new_size,
+					 cur_htbl->lu_type,
+					 cur_htbl->byte_mask);
+	if (!new_htbl) {
+		mlx5dr_err(dmn, "Failed to allocate new hash table\n");
+		goto free_ste_info;
+	}
+
+	/* Write new table to HW */
+	info.type =3D CONNECT_MISS;
+	info.miss_icm_addr =3D nic_matcher->e_anchor->chunk->icm_addr;
+	mlx5dr_ste_set_formatted_ste(dmn->info.caps.gvmi,
+				     nic_dmn,
+				     new_htbl,
+				     formatted_ste,
+				     &info);
+
+	new_htbl->pointing_ste =3D cur_htbl->pointing_ste;
+	new_htbl->pointing_ste->next_htbl =3D new_htbl;
+	err =3D dr_rule_rehash_copy_htbl(matcher,
+				       nic_matcher,
+				       cur_htbl,
+				       new_htbl,
+				       &rehash_table_send_list);
+	if (err)
+		goto free_new_htbl;
+
+	if (mlx5dr_send_postsend_htbl(dmn, new_htbl, formatted_ste,
+				      nic_matcher->ste_builder[ste_location - 1].bit_mask)) {
+		mlx5dr_err(dmn, "Failed writing table to HW\n");
+		goto free_new_htbl;
+	}
+
+	/* Writing to the hw is done in regular order of rehash_table_send_list,
+	 * in order to have the origin data written before the miss address of
+	 * collision entries, if exists.
+	 */
+	if (dr_rule_send_update_list(&rehash_table_send_list, dmn, false)) {
+		mlx5dr_err(dmn, "Failed updating table to HW\n");
+		goto free_ste_list;
+	}
+
+	/* Connect previous hash table to current */
+	if (ste_location =3D=3D 1) {
+		/* The previous table is an anchor, anchors size is always one STE */
+		struct mlx5dr_ste_htbl *prev_htbl =3D cur_htbl->pointing_ste->htbl;
+
+		/* On matcher s_anchor we keep an extra refcount */
+		mlx5dr_htbl_get(new_htbl);
+		mlx5dr_htbl_put(cur_htbl);
+
+		nic_matcher->s_htbl =3D new_htbl;
+
+		/* It is safe to operate dr_ste_set_hit_addr on the hw_ste here
+		 * (48B len) which works only on first 32B
+		 */
+		mlx5dr_ste_set_hit_addr(prev_htbl->ste_arr[0].hw_ste,
+					new_htbl->chunk->icm_addr,
+					new_htbl->chunk->num_of_entries);
+
+		ste_to_update =3D &prev_htbl->ste_arr[0];
+	} else {
+		mlx5dr_ste_set_hit_addr_by_next_htbl(cur_htbl->pointing_ste->hw_ste,
+						     new_htbl);
+		ste_to_update =3D cur_htbl->pointing_ste;
+	}
+
+	mlx5dr_send_fill_and_append_ste_send_info(ste_to_update, DR_STE_SIZE_REDU=
CED,
+						  0, ste_to_update->hw_ste, ste_info,
+						  update_list, false);
+
+	return new_htbl;
+
+free_ste_list:
+	/* Clean all ste_info's from the new table */
+	list_for_each_entry_safe(del_ste_info, tmp_ste_info,
+				 &rehash_table_send_list, send_list) {
+		list_del(&del_ste_info->send_list);
+		kfree(del_ste_info);
+	}
+
+free_new_htbl:
+	mlx5dr_ste_htbl_free(new_htbl);
+free_ste_info:
+	kfree(ste_info);
+	mlx5dr_info(dmn, "Failed creating rehash table\n");
+	return NULL;
+}
+
+static struct mlx5dr_ste_htbl *dr_rule_rehash(struct mlx5dr_rule *rule,
+					      struct mlx5dr_rule_rx_tx *nic_rule,
+					      struct mlx5dr_ste_htbl *cur_htbl,
+					      u8 ste_location,
+					      struct list_head *update_list)
+{
+	struct mlx5dr_domain *dmn =3D rule->matcher->tbl->dmn;
+	enum mlx5dr_icm_chunk_size new_size;
+
+	new_size =3D mlx5dr_icm_next_higher_chunk(cur_htbl->chunk_size);
+	new_size =3D min_t(u32, new_size, dmn->info.max_log_sw_icm_sz);
+
+	if (new_size =3D=3D cur_htbl->chunk_size)
+		return NULL; /* Skip rehash, we already at the max size */
+
+	return dr_rule_rehash_htbl(rule, nic_rule, cur_htbl, ste_location,
+				   update_list, new_size);
+}
+
+static struct mlx5dr_ste *
+dr_rule_handle_collision(struct mlx5dr_matcher *matcher,
+			 struct mlx5dr_matcher_rx_tx *nic_matcher,
+			 struct mlx5dr_ste *ste,
+			 u8 *hw_ste,
+			 struct list_head *miss_list,
+			 struct list_head *send_list)
+{
+	struct mlx5dr_ste_send_info *ste_info;
+	struct mlx5dr_ste *new_ste;
+
+	ste_info =3D kzalloc(sizeof(*ste_info), GFP_KERNEL);
+	if (!ste_info)
+		return NULL;
+
+	new_ste =3D dr_rule_create_collision_entry(matcher, nic_matcher, hw_ste, =
ste);
+	if (!new_ste)
+		goto free_send_info;
+
+	if (dr_rule_append_to_miss_list(new_ste, miss_list, send_list)) {
+		mlx5dr_dbg(matcher->tbl->dmn, "Failed to update prev miss_list\n");
+		goto err_exit;
+	}
+
+	mlx5dr_send_fill_and_append_ste_send_info(new_ste, DR_STE_SIZE, 0, hw_ste=
,
+						  ste_info, send_list, false);
+
+	ste->htbl->ctrl.num_of_collisions++;
+	ste->htbl->ctrl.num_of_valid_entries++;
+
+	return new_ste;
+
+err_exit:
+	mlx5dr_ste_free(new_ste, matcher, nic_matcher);
+free_send_info:
+	kfree(ste_info);
+	return NULL;
+}
+
+static void dr_rule_remove_action_members(struct mlx5dr_rule *rule)
+{
+	struct mlx5dr_rule_action_member *action_mem;
+	struct mlx5dr_rule_action_member *tmp;
+
+	list_for_each_entry_safe(action_mem, tmp, &rule->rule_actions_list, list)=
 {
+		list_del(&action_mem->list);
+		refcount_dec(&action_mem->action->refcount);
+		kvfree(action_mem);
+	}
+}
+
+static int dr_rule_add_action_members(struct mlx5dr_rule *rule,
+				      size_t num_actions,
+				      struct mlx5dr_action *actions[])
+{
+	struct mlx5dr_rule_action_member *action_mem;
+	int i;
+
+	for (i =3D 0; i < num_actions; i++) {
+		action_mem =3D kvzalloc(sizeof(*action_mem), GFP_KERNEL);
+		if (!action_mem)
+			goto free_action_members;
+
+		action_mem->action =3D actions[i];
+		INIT_LIST_HEAD(&action_mem->list);
+		list_add_tail(&action_mem->list, &rule->rule_actions_list);
+		refcount_inc(&action_mem->action->refcount);
+	}
+
+	return 0;
+
+free_action_members:
+	dr_rule_remove_action_members(rule);
+	return -ENOMEM;
+}
+
+/* While the pointer of ste is no longer valid, like while moving ste to b=
e
+ * the first in the miss_list, and to be in the origin table,
+ * all rule-members that are attached to this ste should update their ste =
member
+ * to the new pointer
+ */
+void mlx5dr_rule_update_rule_member(struct mlx5dr_ste *ste,
+				    struct mlx5dr_ste *new_ste)
+{
+	struct mlx5dr_rule_member *rule_mem;
+
+	if (!list_empty(&ste->rule_list))
+		list_for_each_entry(rule_mem, &ste->rule_list, use_ste_list)
+			rule_mem->ste =3D new_ste;
+}
+
+static void dr_rule_clean_rule_members(struct mlx5dr_rule *rule,
+				       struct mlx5dr_rule_rx_tx *nic_rule)
+{
+	struct mlx5dr_rule_member *rule_mem;
+	struct mlx5dr_rule_member *tmp_mem;
+
+	if (list_empty(&nic_rule->rule_members_list))
+		return;
+	list_for_each_entry_safe(rule_mem, tmp_mem, &nic_rule->rule_members_list,=
 list) {
+		list_del(&rule_mem->list);
+		list_del(&rule_mem->use_ste_list);
+		mlx5dr_ste_put(rule_mem->ste, rule->matcher, nic_rule->nic_matcher);
+		kvfree(rule_mem);
+	}
+}
+
+static bool dr_rule_need_enlarge_hash(struct mlx5dr_ste_htbl *htbl,
+				      struct mlx5dr_domain *dmn,
+				      struct mlx5dr_domain_rx_tx *nic_dmn)
+{
+	struct mlx5dr_ste_htbl_ctrl *ctrl =3D &htbl->ctrl;
+
+	if (dmn->info.max_log_sw_icm_sz <=3D htbl->chunk_size)
+		return false;
+
+	if (!ctrl->may_grow)
+		return false;
+
+	if (ctrl->num_of_collisions >=3D ctrl->increase_threshold &&
+	    (ctrl->num_of_valid_entries - ctrl->num_of_collisions) >=3D ctrl->inc=
rease_threshold)
+		return true;
+
+	return false;
+}
+
+static int dr_rule_add_member(struct mlx5dr_rule_rx_tx *nic_rule,
+			      struct mlx5dr_ste *ste)
+{
+	struct mlx5dr_rule_member *rule_mem;
+
+	rule_mem =3D kvzalloc(sizeof(*rule_mem), GFP_KERNEL);
+	if (!rule_mem)
+		return -ENOMEM;
+
+	rule_mem->ste =3D ste;
+	list_add_tail(&rule_mem->list, &nic_rule->rule_members_list);
+
+	list_add_tail(&rule_mem->use_ste_list, &ste->rule_list);
+
+	return 0;
+}
+
+static int dr_rule_handle_action_stes(struct mlx5dr_rule *rule,
+				      struct mlx5dr_rule_rx_tx *nic_rule,
+				      struct list_head *send_ste_list,
+				      struct mlx5dr_ste *last_ste,
+				      u8 *hw_ste_arr,
+				      u32 new_hw_ste_arr_sz)
+{
+	struct mlx5dr_matcher_rx_tx *nic_matcher =3D nic_rule->nic_matcher;
+	struct mlx5dr_ste_send_info *ste_info_arr[DR_ACTION_MAX_STES];
+	u8 num_of_builders =3D nic_matcher->num_of_builders;
+	struct mlx5dr_matcher *matcher =3D rule->matcher;
+	u8 *curr_hw_ste, *prev_hw_ste;
+	struct mlx5dr_ste *action_ste;
+	int i, k, ret;
+
+	/* Two cases:
+	 * 1. num_of_builders is equal to new_hw_ste_arr_sz, the action in the st=
e
+	 * 2. num_of_builders is less then new_hw_ste_arr_sz, new ste was added
+	 *    to support the action.
+	 */
+	if (num_of_builders =3D=3D new_hw_ste_arr_sz)
+		return 0;
+
+	for (i =3D num_of_builders, k =3D 0; i < new_hw_ste_arr_sz; i++, k++) {
+		curr_hw_ste =3D hw_ste_arr + i * DR_STE_SIZE;
+		prev_hw_ste =3D (i =3D=3D 0) ? curr_hw_ste : hw_ste_arr + ((i - 1) * DR_=
STE_SIZE);
+		action_ste =3D dr_rule_create_collision_htbl(matcher,
+							   nic_matcher,
+							   curr_hw_ste);
+		if (!action_ste)
+			return -ENOMEM;
+
+		mlx5dr_ste_get(action_ste);
+
+		/* While free ste we go over the miss list, so add this ste to the list =
*/
+		list_add_tail(&action_ste->miss_list_node,
+			      mlx5dr_ste_get_miss_list(action_ste));
+
+		ste_info_arr[k] =3D kzalloc(sizeof(*ste_info_arr[k]),
+					  GFP_KERNEL);
+		if (!ste_info_arr[k])
+			goto err_exit;
+
+		/* Point current ste to the new action */
+		mlx5dr_ste_set_hit_addr_by_next_htbl(prev_hw_ste, action_ste->htbl);
+		ret =3D dr_rule_add_member(nic_rule, action_ste);
+		if (ret) {
+			mlx5dr_dbg(matcher->tbl->dmn, "Failed adding rule member\n");
+			goto free_ste_info;
+		}
+		mlx5dr_send_fill_and_append_ste_send_info(action_ste, DR_STE_SIZE, 0,
+							  curr_hw_ste,
+							  ste_info_arr[k],
+							  send_ste_list, false);
+	}
+
+	return 0;
+
+free_ste_info:
+	kfree(ste_info_arr[k]);
+err_exit:
+	mlx5dr_ste_put(action_ste, matcher, nic_matcher);
+	return -ENOMEM;
+}
+
+static int dr_rule_handle_empty_entry(struct mlx5dr_matcher *matcher,
+				      struct mlx5dr_matcher_rx_tx *nic_matcher,
+				      struct mlx5dr_ste_htbl *cur_htbl,
+				      struct mlx5dr_ste *ste,
+				      u8 ste_location,
+				      u8 *hw_ste,
+				      struct list_head *miss_list,
+				      struct list_head *send_list)
+{
+	struct mlx5dr_ste_send_info *ste_info;
+
+	/* Take ref on table, only on first time this ste is used */
+	mlx5dr_htbl_get(cur_htbl);
+
+	/* new entry -> new branch */
+	list_add_tail(&ste->miss_list_node, miss_list);
+
+	mlx5dr_ste_set_miss_addr(hw_ste, nic_matcher->e_anchor->chunk->icm_addr);
+
+	ste->ste_chain_location =3D ste_location;
+
+	ste_info =3D kzalloc(sizeof(*ste_info), GFP_KERNEL);
+	if (!ste_info)
+		goto clean_ste_setting;
+
+	if (mlx5dr_ste_create_next_htbl(matcher,
+					nic_matcher,
+					ste,
+					hw_ste,
+					DR_CHUNK_SIZE_1)) {
+		mlx5dr_dbg(matcher->tbl->dmn, "Failed allocating table\n");
+		goto clean_ste_info;
+	}
+
+	cur_htbl->ctrl.num_of_valid_entries++;
+
+	mlx5dr_send_fill_and_append_ste_send_info(ste, DR_STE_SIZE, 0, hw_ste,
+						  ste_info, send_list, false);
+
+	return 0;
+
+clean_ste_info:
+	kfree(ste_info);
+clean_ste_setting:
+	list_del_init(&ste->miss_list_node);
+	mlx5dr_htbl_put(cur_htbl);
+
+	return -ENOMEM;
+}
+
+static struct mlx5dr_ste *
+dr_rule_handle_ste_branch(struct mlx5dr_rule *rule,
+			  struct mlx5dr_rule_rx_tx *nic_rule,
+			  struct list_head *send_ste_list,
+			  struct mlx5dr_ste_htbl *cur_htbl,
+			  u8 *hw_ste,
+			  u8 ste_location,
+			  struct mlx5dr_ste_htbl **put_htbl)
+{
+	struct mlx5dr_matcher *matcher =3D rule->matcher;
+	struct mlx5dr_domain *dmn =3D matcher->tbl->dmn;
+	struct mlx5dr_matcher_rx_tx *nic_matcher;
+	struct mlx5dr_domain_rx_tx *nic_dmn;
+	struct mlx5dr_ste_htbl *new_htbl;
+	struct mlx5dr_ste *matched_ste;
+	struct list_head *miss_list;
+	bool skip_rehash =3D false;
+	struct mlx5dr_ste *ste;
+	int index;
+
+	nic_matcher =3D nic_rule->nic_matcher;
+	nic_dmn =3D nic_matcher->nic_tbl->nic_dmn;
+
+again:
+	index =3D mlx5dr_ste_calc_hash_index(hw_ste, cur_htbl);
+	miss_list =3D &cur_htbl->chunk->miss_list[index];
+	ste =3D &cur_htbl->ste_arr[index];
+
+	if (mlx5dr_ste_not_used_ste(ste)) {
+		if (dr_rule_handle_empty_entry(matcher, nic_matcher, cur_htbl,
+					       ste, ste_location,
+					       hw_ste, miss_list,
+					       send_ste_list))
+			return NULL;
+	} else {
+		/* Hash table index in use, check if this ste is in the miss list */
+		matched_ste =3D dr_rule_find_ste_in_miss_list(miss_list, hw_ste);
+		if (matched_ste) {
+			/* If it is last STE in the chain, and has the same tag
+			 * it means that all the previous stes are the same,
+			 * if so, this rule is duplicated.
+			 */
+			if (mlx5dr_ste_is_last_in_rule(nic_matcher,
+						       matched_ste->ste_chain_location)) {
+				mlx5dr_info(dmn, "Duplicate rule inserted, aborting!!\n");
+				return NULL;
+			}
+			return matched_ste;
+		}
+
+		if (!skip_rehash && dr_rule_need_enlarge_hash(cur_htbl, dmn, nic_dmn)) {
+			/* Hash table index in use, try to resize of the hash */
+			skip_rehash =3D true;
+
+			/* Hold the table till we update.
+			 * Release in dr_rule_create_rule()
+			 */
+			*put_htbl =3D cur_htbl;
+			mlx5dr_htbl_get(cur_htbl);
+
+			new_htbl =3D dr_rule_rehash(rule, nic_rule, cur_htbl,
+						  ste_location, send_ste_list);
+			if (!new_htbl) {
+				mlx5dr_htbl_put(cur_htbl);
+				mlx5dr_info(dmn, "failed creating rehash table, htbl-log_size: %d\n",
+					    cur_htbl->chunk_size);
+			} else {
+				cur_htbl =3D new_htbl;
+			}
+			goto again;
+		} else {
+			/* Hash table index in use, add another collision (miss) */
+			ste =3D dr_rule_handle_collision(matcher,
+						       nic_matcher,
+						       ste,
+						       hw_ste,
+						       miss_list,
+						       send_ste_list);
+			if (!ste) {
+				mlx5dr_dbg(dmn, "failed adding collision entry, index: %d\n",
+					   index);
+				return NULL;
+			}
+		}
+	}
+	return ste;
+}
+
+static bool dr_rule_cmp_value_to_mask(u8 *mask, u8 *value,
+				      u32 s_idx, u32 e_idx)
+{
+	u32 i;
+
+	for (i =3D s_idx; i < e_idx; i++) {
+		if (value[i] & ~mask[i]) {
+			pr_info("Rule parameters contains a value not specified by mask\n");
+			return false;
+		}
+	}
+	return true;
+}
+
+static bool dr_rule_verify(struct mlx5dr_matcher *matcher,
+			   struct mlx5dr_match_parameters *value,
+			   struct mlx5dr_match_param *param)
+{
+	u8 match_criteria =3D matcher->match_criteria;
+	size_t value_size =3D value->match_sz;
+	u8 *mask_p =3D (u8 *)&matcher->mask;
+	u8 *param_p =3D (u8 *)param;
+	u32 s_idx, e_idx;
+
+	if (!value_size ||
+	    (value_size > sizeof(struct mlx5dr_match_param) ||
+	     (value_size % sizeof(u32)))) {
+		mlx5dr_dbg(matcher->tbl->dmn, "Rule parameters length is incorrect\n");
+		return false;
+	}
+
+	mlx5dr_ste_copy_param(matcher->match_criteria, param, value);
+
+	if (match_criteria & DR_MATCHER_CRITERIA_OUTER) {
+		s_idx =3D offsetof(struct mlx5dr_match_param, outer);
+		e_idx =3D min(s_idx + sizeof(param->outer), value_size);
+
+		if (!dr_rule_cmp_value_to_mask(mask_p, param_p, s_idx, e_idx)) {
+			mlx5dr_dbg(matcher->tbl->dmn, "Rule outer parameters contains a value n=
ot specified by mask\n");
+			return false;
+		}
+	}
+
+	if (match_criteria & DR_MATCHER_CRITERIA_MISC) {
+		s_idx =3D offsetof(struct mlx5dr_match_param, misc);
+		e_idx =3D min(s_idx + sizeof(param->misc), value_size);
+
+		if (!dr_rule_cmp_value_to_mask(mask_p, param_p, s_idx, e_idx)) {
+			mlx5dr_dbg(matcher->tbl->dmn, "Rule misc parameters contains a value no=
t specified by mask\n");
+			return false;
+		}
+	}
+
+	if (match_criteria & DR_MATCHER_CRITERIA_INNER) {
+		s_idx =3D offsetof(struct mlx5dr_match_param, inner);
+		e_idx =3D min(s_idx + sizeof(param->inner), value_size);
+
+		if (!dr_rule_cmp_value_to_mask(mask_p, param_p, s_idx, e_idx)) {
+			mlx5dr_dbg(matcher->tbl->dmn, "Rule inner parameters contains a value n=
ot specified by mask\n");
+			return false;
+		}
+	}
+
+	if (match_criteria & DR_MATCHER_CRITERIA_MISC2) {
+		s_idx =3D offsetof(struct mlx5dr_match_param, misc2);
+		e_idx =3D min(s_idx + sizeof(param->misc2), value_size);
+
+		if (!dr_rule_cmp_value_to_mask(mask_p, param_p, s_idx, e_idx)) {
+			mlx5dr_dbg(matcher->tbl->dmn, "Rule misc2 parameters contains a value n=
ot specified by mask\n");
+			return false;
+		}
+	}
+
+	if (match_criteria & DR_MATCHER_CRITERIA_MISC3) {
+		s_idx =3D offsetof(struct mlx5dr_match_param, misc3);
+		e_idx =3D min(s_idx + sizeof(param->misc3), value_size);
+
+		if (!dr_rule_cmp_value_to_mask(mask_p, param_p, s_idx, e_idx)) {
+			mlx5dr_dbg(matcher->tbl->dmn, "Rule misc3 parameters contains a value n=
ot specified by mask\n");
+			return false;
+		}
+	}
+	return true;
+}
+
+static int dr_rule_destroy_rule_nic(struct mlx5dr_rule *rule,
+				    struct mlx5dr_rule_rx_tx *nic_rule)
+{
+	dr_rule_clean_rule_members(rule, nic_rule);
+	return 0;
+}
+
+static int dr_rule_destroy_rule_fdb(struct mlx5dr_rule *rule)
+{
+	dr_rule_destroy_rule_nic(rule, &rule->rx);
+	dr_rule_destroy_rule_nic(rule, &rule->tx);
+	return 0;
+}
+
+static int dr_rule_destroy_rule(struct mlx5dr_rule *rule)
+{
+	struct mlx5dr_domain *dmn =3D rule->matcher->tbl->dmn;
+
+	switch (dmn->type) {
+	case MLX5DR_DOMAIN_TYPE_NIC_RX:
+		dr_rule_destroy_rule_nic(rule, &rule->rx);
+		break;
+	case MLX5DR_DOMAIN_TYPE_NIC_TX:
+		dr_rule_destroy_rule_nic(rule, &rule->tx);
+		break;
+	case MLX5DR_DOMAIN_TYPE_FDB:
+		dr_rule_destroy_rule_fdb(rule);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	dr_rule_remove_action_members(rule);
+	kfree(rule);
+	return 0;
+}
+
+static bool dr_rule_is_ipv6(struct mlx5dr_match_param *param)
+{
+	return (param->outer.ip_version =3D=3D 6 ||
+		param->inner.ip_version =3D=3D 6 ||
+		param->outer.ethertype =3D=3D ETH_P_IPV6 ||
+		param->inner.ethertype =3D=3D ETH_P_IPV6);
+}
+
+static bool dr_rule_skip(enum mlx5dr_domain_type domain,
+			 enum mlx5dr_ste_entry_type ste_type,
+			 struct mlx5dr_match_param *mask,
+			 struct mlx5dr_match_param *value)
+{
+	if (domain !=3D MLX5DR_DOMAIN_TYPE_FDB)
+		return false;
+
+	if (mask->misc.source_port) {
+		if (ste_type =3D=3D MLX5DR_STE_TYPE_RX)
+			if (value->misc.source_port !=3D WIRE_PORT)
+				return true;
+
+		if (ste_type =3D=3D MLX5DR_STE_TYPE_TX)
+			if (value->misc.source_port =3D=3D WIRE_PORT)
+				return true;
+	}
+
+	/* Metadata C can be used to describe the source vport */
+	if (mask->misc2.metadata_reg_c_0) {
+		if (ste_type =3D=3D MLX5DR_STE_TYPE_RX)
+			if ((value->misc2.metadata_reg_c_0 & WIRE_PORT) !=3D WIRE_PORT)
+				return true;
+
+		if (ste_type =3D=3D MLX5DR_STE_TYPE_TX)
+			if ((value->misc2.metadata_reg_c_0 & WIRE_PORT) =3D=3D WIRE_PORT)
+				return true;
+	}
+	return false;
+}
+
+static int
+dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
+			struct mlx5dr_rule_rx_tx *nic_rule,
+			struct mlx5dr_match_param *param,
+			size_t num_actions,
+			struct mlx5dr_action *actions[])
+{
+	struct mlx5dr_ste_send_info *ste_info, *tmp_ste_info;
+	struct mlx5dr_matcher *matcher =3D rule->matcher;
+	struct mlx5dr_domain *dmn =3D matcher->tbl->dmn;
+	struct mlx5dr_matcher_rx_tx *nic_matcher;
+	struct mlx5dr_domain_rx_tx *nic_dmn;
+	struct mlx5dr_ste_htbl *htbl =3D NULL;
+	struct mlx5dr_ste_htbl *cur_htbl;
+	struct mlx5dr_ste *ste =3D NULL;
+	LIST_HEAD(send_ste_list);
+	u8 *hw_ste_arr =3D NULL;
+	u32 new_hw_ste_arr_sz;
+	int ret, i;
+
+	nic_matcher =3D nic_rule->nic_matcher;
+	nic_dmn =3D nic_matcher->nic_tbl->nic_dmn;
+
+	INIT_LIST_HEAD(&nic_rule->rule_members_list);
+
+	if (dr_rule_skip(dmn->type, nic_dmn->ste_type, &matcher->mask, param))
+		return 0;
+
+	ret =3D mlx5dr_matcher_select_builders(matcher,
+					     nic_matcher,
+					     dr_rule_is_ipv6(param));
+	if (ret)
+		goto out_err;
+
+	hw_ste_arr =3D kzalloc(DR_RULE_MAX_STE_CHAIN * DR_STE_SIZE, GFP_KERNEL);
+	if (!hw_ste_arr) {
+		ret =3D -ENOMEM;
+		goto out_err;
+	}
+
+	/* Set the tag values inside the ste array */
+	ret =3D mlx5dr_ste_build_ste_arr(matcher, nic_matcher, param, hw_ste_arr)=
;
+	if (ret)
+		goto free_hw_ste;
+
+	/* Set the actions values/addresses inside the ste array */
+	ret =3D mlx5dr_actions_build_ste_arr(matcher, nic_matcher, actions,
+					   num_actions, hw_ste_arr,
+					   &new_hw_ste_arr_sz);
+	if (ret)
+		goto free_hw_ste;
+
+	cur_htbl =3D nic_matcher->s_htbl;
+
+	/* Go over the array of STEs, and build dr_ste accordingly.
+	 * The loop is over only the builders which are equal or less to the
+	 * number of stes, in case we have actions that lives in other stes.
+	 */
+	for (i =3D 0; i < nic_matcher->num_of_builders; i++) {
+		/* Calculate CRC and keep new ste entry */
+		u8 *cur_hw_ste_ent =3D hw_ste_arr + (i * DR_STE_SIZE);
+
+		ste =3D dr_rule_handle_ste_branch(rule,
+						nic_rule,
+						&send_ste_list,
+						cur_htbl,
+						cur_hw_ste_ent,
+						i + 1,
+						&htbl);
+		if (!ste) {
+			mlx5dr_err(dmn, "Failed creating next branch\n");
+			ret =3D -ENOENT;
+			goto free_rule;
+		}
+
+		cur_htbl =3D ste->next_htbl;
+
+		/* Keep all STEs in the rule struct */
+		ret =3D dr_rule_add_member(nic_rule, ste);
+		if (ret) {
+			mlx5dr_dbg(dmn, "Failed adding rule member index %d\n", i);
+			goto free_ste;
+		}
+
+		mlx5dr_ste_get(ste);
+	}
+
+	/* Connect actions */
+	ret =3D dr_rule_handle_action_stes(rule, nic_rule, &send_ste_list,
+					 ste, hw_ste_arr, new_hw_ste_arr_sz);
+	if (ret) {
+		mlx5dr_dbg(dmn, "Failed apply actions\n");
+		goto free_rule;
+	}
+	ret =3D dr_rule_send_update_list(&send_ste_list, dmn, true);
+	if (ret) {
+		mlx5dr_err(dmn, "Failed sending ste!\n");
+		goto free_rule;
+	}
+
+	if (htbl)
+		mlx5dr_htbl_put(htbl);
+
+	return 0;
+
+free_ste:
+	mlx5dr_ste_put(ste, matcher, nic_matcher);
+free_rule:
+	dr_rule_clean_rule_members(rule, nic_rule);
+	/* Clean all ste_info's */
+	list_for_each_entry_safe(ste_info, tmp_ste_info, &send_ste_list, send_lis=
t) {
+		list_del(&ste_info->send_list);
+		kfree(ste_info);
+	}
+free_hw_ste:
+	kfree(hw_ste_arr);
+out_err:
+	return ret;
+}
+
+static int
+dr_rule_create_rule_fdb(struct mlx5dr_rule *rule,
+			struct mlx5dr_match_param *param,
+			size_t num_actions,
+			struct mlx5dr_action *actions[])
+{
+	struct mlx5dr_match_param copy_param =3D {};
+	int ret;
+
+	/* Copy match_param since they will be consumed during the first
+	 * nic_rule insertion.
+	 */
+	memcpy(&copy_param, param, sizeof(struct mlx5dr_match_param));
+
+	ret =3D dr_rule_create_rule_nic(rule, &rule->rx, param,
+				      num_actions, actions);
+	if (ret)
+		return ret;
+
+	ret =3D dr_rule_create_rule_nic(rule, &rule->tx, &copy_param,
+				      num_actions, actions);
+	if (ret)
+		goto destroy_rule_nic_rx;
+
+	return 0;
+
+destroy_rule_nic_rx:
+	dr_rule_destroy_rule_nic(rule, &rule->rx);
+	return ret;
+}
+
+static struct mlx5dr_rule *
+dr_rule_create_rule(struct mlx5dr_matcher *matcher,
+		    struct mlx5dr_match_parameters *value,
+		    size_t num_actions,
+		    struct mlx5dr_action *actions[])
+{
+	struct mlx5dr_domain *dmn =3D matcher->tbl->dmn;
+	struct mlx5dr_match_param param =3D {};
+	struct mlx5dr_rule *rule;
+	int ret;
+
+	if (!dr_rule_verify(matcher, value, &param))
+		return NULL;
+
+	rule =3D kzalloc(sizeof(*rule), GFP_KERNEL);
+	if (!rule)
+		return NULL;
+
+	rule->matcher =3D matcher;
+	INIT_LIST_HEAD(&rule->rule_actions_list);
+
+	ret =3D dr_rule_add_action_members(rule, num_actions, actions);
+	if (ret)
+		goto free_rule;
+
+	switch (dmn->type) {
+	case MLX5DR_DOMAIN_TYPE_NIC_RX:
+		rule->rx.nic_matcher =3D &matcher->rx;
+		ret =3D dr_rule_create_rule_nic(rule, &rule->rx, &param,
+					      num_actions, actions);
+		break;
+	case MLX5DR_DOMAIN_TYPE_NIC_TX:
+		rule->tx.nic_matcher =3D &matcher->tx;
+		ret =3D dr_rule_create_rule_nic(rule, &rule->tx, &param,
+					      num_actions, actions);
+		break;
+	case MLX5DR_DOMAIN_TYPE_FDB:
+		rule->rx.nic_matcher =3D &matcher->rx;
+		rule->tx.nic_matcher =3D &matcher->tx;
+		ret =3D dr_rule_create_rule_fdb(rule, &param,
+					      num_actions, actions);
+		break;
+	default:
+		ret =3D -EINVAL;
+		break;
+	}
+
+	if (ret)
+		goto remove_action_members;
+
+	return rule;
+
+remove_action_members:
+	dr_rule_remove_action_members(rule);
+free_rule:
+	kfree(rule);
+	mlx5dr_info(dmn, "Failed creating rule\n");
+	return NULL;
+}
+
+struct mlx5dr_rule *mlx5dr_rule_create(struct mlx5dr_matcher *matcher,
+				       struct mlx5dr_match_parameters *value,
+				       size_t num_actions,
+				       struct mlx5dr_action *actions[])
+{
+	struct mlx5dr_rule *rule;
+
+	mutex_lock(&matcher->tbl->dmn->mutex);
+	refcount_inc(&matcher->refcount);
+
+	rule =3D dr_rule_create_rule(matcher, value, num_actions, actions);
+	if (!rule)
+		refcount_dec(&matcher->refcount);
+
+	mutex_unlock(&matcher->tbl->dmn->mutex);
+
+	return rule;
+}
+
+int mlx5dr_rule_destroy(struct mlx5dr_rule *rule)
+{
+	struct mlx5dr_matcher *matcher =3D rule->matcher;
+	struct mlx5dr_table *tbl =3D rule->matcher->tbl;
+	int ret;
+
+	mutex_lock(&tbl->dmn->mutex);
+
+	ret =3D dr_rule_destroy_rule(rule);
+
+	mutex_unlock(&tbl->dmn->mutex);
+
+	if (!ret)
+		refcount_dec(&matcher->refcount);
+	return ret;
+}
--=20
2.21.0

