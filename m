Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 319C5A4FB0
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 09:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbfIBHXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 03:23:23 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:38403
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729529AbfIBHXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 03:23:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SdVaFkqVNe79w/VIY8FE9iQ+YZExs8vIUgYebAyODjeWWt1qjSpN98isplhtytf29SKWWmzfFvwe0SbycmzPrugyY/EhsJuBzdmlBPs3pUuj2cteud+1kL+hLDMwrkUnuhprN2zk39Wj9BvFQMd1fWJkd9ZGJjZUaq1Td8ktXe4YfSpztqrK4zUk33+9zRskSUXu6WkRR4rVUNS6Lh8RWCoabrPqKhalKIyrR/FF7n2kBCu3gu2HuCYVCGs/g9tzQuo91wQMbFndsHbbbAwjGP3k4tRQFisu4pw9w6YfL8aigtKrPp2siM8rRbVzxI9t4MwwpKkZZiR99aOVuKnxUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Xgfi3tyxCQ59Wt9ws7v8E9CNoFI2rGxHlxq5BD5J30=;
 b=FYeOZdNcNvembrgh+YwLsL/k19uY2Bx+SadMWaI14YsncKLbK2nDzjU4KbvCxPMK8s1jYZBgiT5ADY4VlKyh50ktCzxoHIAqZ+25Aj1G6YtgtdE0PuTQsjIJRg9OWWDfsZRx2dtHPMeIJ1D+Qy2LlWsfnoTQRWVRoTwcvDrU6Wdm700tOPrhlDE9/wXK5bfYUuE9b5OagAktAnhXy1pV9AtXna11YI9vbIfoKpfA1ZUh6KWdNW8iBaOUC8Max7j1p6yFcYwThk92h2a7b8P7CPlxLeJhmYeGuafQ0uRChCYB3IQnV0fiApMcet6KKYQ9FTcJW5NyywqrDAzCb+GP3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Xgfi3tyxCQ59Wt9ws7v8E9CNoFI2rGxHlxq5BD5J30=;
 b=FYfAfOQ9p4SZKKkcCx3RhyqL78aScDHLVeq+Wd1CYWpjfoFISh2aZIUcWnW7JS+5xaRivKEimXBXSx7FGprXIxVLEhaLjNPUE4VW0VKVapVu5jeQvgQIkzPtE4iBchYNAevZpazHnkUbAwAJZd3YSeKSKBkmLSieUnGIeHbwgHI=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2625.eurprd05.prod.outlook.com (10.172.217.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Mon, 2 Sep 2019 07:23:02 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 07:23:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/18] net/mlx5: DR, Expose an internal API to issue RDMA
 operations
Thread-Topic: [net-next 05/18] net/mlx5: DR, Expose an internal API to issue
 RDMA operations
Thread-Index: AQHVYV9B8oXx2eZDRk+ViOoANjIgXA==
Date:   Mon, 2 Sep 2019 07:23:02 +0000
Message-ID: <20190902072213.7683-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: ad27ba44-0b2a-45c6-e398-08d72f766381
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2625;
x-ms-traffictypediagnostic: AM4PR0501MB2625:|AM4PR0501MB2625:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2625D6D33B74EC5D527ABDDFBEBE0@AM4PR0501MB2625.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(199004)(189003)(8676002)(107886003)(14454004)(7736002)(6512007)(1076003)(53946003)(11346002)(64756008)(66556008)(66476007)(66946007)(66446008)(50226002)(26005)(2616005)(36756003)(99286004)(102836004)(478600001)(71200400001)(446003)(6486002)(71190400001)(53936002)(52116002)(305945005)(66066001)(76176011)(3846002)(256004)(186003)(316002)(486006)(4326008)(5024004)(14444005)(54906003)(6916009)(81166006)(6116002)(81156014)(30864003)(86362001)(2906002)(5660300002)(8936002)(25786009)(6506007)(386003)(476003)(6436002)(579004)(559001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2625;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H6WbdWTWtO+Ia0royWvnMYxceMnQ6Bo17MORJDvtdUDpsrWkn+3q1Re6915yZXHyZOQWb6siZmun+aeb8Ujyk+9YDOszVtdquuqSK1rryCOR5OQbFixuwyzd2OS2VbQKNRfk1Lx/i0IrV5t17Hg9T36nREUksm8n27tmHY4nILM5Tdic8U1Eperk0xu6P9VpxRs1lmM+7dSL6FwdPwkWtTaFQaBINdeLQ7YIR875alFufNHxwGq0Pvj0gq/zqnhbP25Q3AVPzSHn7XLjDSeu7b4xFQS0Ht++W9TAqPWFduUX9vGCKr2mVY+3tPwFgmJXzVcCBnc09DdOQJzg3VJIb4jhM5A1B+1spyEaELTBEsXL0zOnM2oRJgyH+4wAwGeSZWISEwY8Hk2HwLTwkT1N7mM0G3jy4blZTfXdu3NaigY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad27ba44-0b2a-45c6-e398-08d72f766381
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 07:23:02.0596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yco4rR3GHVKIl6sWl/wxEfOVa6ExzYJZsqwinWiDCvX9+x64QKLpEAcUL39AcpfpNLQfTPalYZwbAe85AdF23Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2625
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Inserting or deleting a rule is done by RDMA read/write operation to SW
ICM device memory. This file provides the support for executing these
operations. It includes allocating the needed resources and providing an
API for writing steering entries to the memory.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_send.c     | 976 ++++++++++++++++++
 1 file changed, 976 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_sen=
d.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
new file mode 100644
index 000000000000..ef0dea44f3b3
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -0,0 +1,976 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include "dr_types.h"
+
+#define QUEUE_SIZE 128
+#define SIGNAL_PER_DIV_QUEUE 16
+#define TH_NUMS_TO_DRAIN 2
+
+enum { CQ_OK =3D 0, CQ_EMPTY =3D -1, CQ_POLL_ERR =3D -2 };
+
+struct dr_data_seg {
+	u64 addr;
+	u32 length;
+	u32 lkey;
+	unsigned int send_flags;
+};
+
+struct postsend_info {
+	struct dr_data_seg write;
+	struct dr_data_seg read;
+	u64 remote_addr;
+	u32 rkey;
+};
+
+struct dr_qp_rtr_attr {
+	struct mlx5dr_cmd_gid_attr dgid_attr;
+	enum ib_mtu mtu;
+	u32 qp_num;
+	u16 port_num;
+	u8 min_rnr_timer;
+	u8 sgid_index;
+	u16 udp_src_port;
+};
+
+struct dr_qp_rts_attr {
+	u8 timeout;
+	u8 retry_cnt;
+	u8 rnr_retry;
+};
+
+struct dr_qp_init_attr {
+	u32 cqn;
+	u32 pdn;
+	u32 max_send_wr;
+	struct mlx5_uars_page *uar;
+};
+
+static int dr_parse_cqe(struct mlx5dr_cq *dr_cq, struct mlx5_cqe64 *cqe64)
+{
+	unsigned int idx;
+	u8 opcode;
+
+	opcode =3D get_cqe_opcode(cqe64);
+	if (opcode =3D=3D MLX5_CQE_REQ_ERR) {
+		idx =3D be16_to_cpu(cqe64->wqe_counter) &
+			(dr_cq->qp->sq.wqe_cnt - 1);
+		dr_cq->qp->sq.cc =3D dr_cq->qp->sq.wqe_head[idx] + 1;
+	} else if (opcode =3D=3D MLX5_CQE_RESP_ERR) {
+		++dr_cq->qp->sq.cc;
+	} else {
+		idx =3D be16_to_cpu(cqe64->wqe_counter) &
+			(dr_cq->qp->sq.wqe_cnt - 1);
+		dr_cq->qp->sq.cc =3D dr_cq->qp->sq.wqe_head[idx] + 1;
+
+		return CQ_OK;
+	}
+
+	return CQ_POLL_ERR;
+}
+
+static int dr_cq_poll_one(struct mlx5dr_cq *dr_cq)
+{
+	struct mlx5_cqe64 *cqe64;
+	int err;
+
+	cqe64 =3D mlx5_cqwq_get_cqe(&dr_cq->wq);
+	if (!cqe64)
+		return CQ_EMPTY;
+
+	mlx5_cqwq_pop(&dr_cq->wq);
+	err =3D dr_parse_cqe(dr_cq, cqe64);
+	mlx5_cqwq_update_db_record(&dr_cq->wq);
+
+	return err;
+}
+
+static int dr_poll_cq(struct mlx5dr_cq *dr_cq, int ne)
+{
+	int npolled;
+	int err =3D 0;
+
+	for (npolled =3D 0; npolled < ne; ++npolled) {
+		err =3D dr_cq_poll_one(dr_cq);
+		if (err !=3D CQ_OK)
+			break;
+	}
+
+	return err =3D=3D CQ_POLL_ERR ? err : npolled;
+}
+
+static void dr_qp_event(struct mlx5_core_qp *mqp, int event)
+{
+	pr_info("DR QP event %u on QP #%u\n", event, mqp->qpn);
+}
+
+static struct mlx5dr_qp *dr_create_rc_qp(struct mlx5_core_dev *mdev,
+					 struct dr_qp_init_attr *attr)
+{
+	u32 temp_qpc[MLX5_ST_SZ_DW(qpc)] =3D {};
+	struct mlx5_wq_param wqp;
+	struct mlx5dr_qp *dr_qp;
+	int inlen;
+	void *qpc;
+	void *in;
+	int err;
+
+	dr_qp =3D kzalloc(sizeof(*dr_qp), GFP_KERNEL);
+	if (!dr_qp)
+		return NULL;
+
+	wqp.buf_numa_node =3D mdev->priv.numa_node;
+	wqp.db_numa_node =3D mdev->priv.numa_node;
+
+	dr_qp->rq.pc =3D 0;
+	dr_qp->rq.cc =3D 0;
+	dr_qp->rq.wqe_cnt =3D 4;
+	dr_qp->sq.pc =3D 0;
+	dr_qp->sq.cc =3D 0;
+	dr_qp->sq.wqe_cnt =3D roundup_pow_of_two(attr->max_send_wr);
+
+	MLX5_SET(qpc, temp_qpc, log_rq_stride, ilog2(MLX5_SEND_WQE_DS) - 4);
+	MLX5_SET(qpc, temp_qpc, log_rq_size, ilog2(dr_qp->rq.wqe_cnt));
+	MLX5_SET(qpc, temp_qpc, log_sq_size, ilog2(dr_qp->sq.wqe_cnt));
+	err =3D mlx5_wq_qp_create(mdev, &wqp, temp_qpc, &dr_qp->wq,
+				&dr_qp->wq_ctrl);
+	if (err) {
+		mlx5_core_info(mdev, "Can't create QP WQ\n");
+		goto err_wq;
+	}
+
+	dr_qp->sq.wqe_head =3D kcalloc(dr_qp->sq.wqe_cnt,
+				     sizeof(dr_qp->sq.wqe_head[0]),
+				     GFP_KERNEL);
+
+	if (!dr_qp->sq.wqe_head) {
+		mlx5_core_warn(mdev, "Can't allocate wqe head\n");
+		goto err_wqe_head;
+	}
+
+	inlen =3D MLX5_ST_SZ_BYTES(create_qp_in) +
+		MLX5_FLD_SZ_BYTES(create_qp_in, pas[0]) *
+		dr_qp->wq_ctrl.buf.npages;
+	in =3D kvzalloc(inlen, GFP_KERNEL);
+	if (!in) {
+		err =3D -ENOMEM;
+		goto err_in;
+	}
+
+	qpc =3D MLX5_ADDR_OF(create_qp_in, in, qpc);
+	MLX5_SET(qpc, qpc, st, MLX5_QP_ST_RC);
+	MLX5_SET(qpc, qpc, pm_state, MLX5_QP_PM_MIGRATED);
+	MLX5_SET(qpc, qpc, pd, attr->pdn);
+	MLX5_SET(qpc, qpc, uar_page, attr->uar->index);
+	MLX5_SET(qpc, qpc, log_page_size,
+		 dr_qp->wq_ctrl.buf.page_shift - MLX5_ADAPTER_PAGE_SHIFT);
+	MLX5_SET(qpc, qpc, fre, 1);
+	MLX5_SET(qpc, qpc, rlky, 1);
+	MLX5_SET(qpc, qpc, cqn_snd, attr->cqn);
+	MLX5_SET(qpc, qpc, cqn_rcv, attr->cqn);
+	MLX5_SET(qpc, qpc, log_rq_stride, ilog2(MLX5_SEND_WQE_DS) - 4);
+	MLX5_SET(qpc, qpc, log_rq_size, ilog2(dr_qp->rq.wqe_cnt));
+	MLX5_SET(qpc, qpc, rq_type, MLX5_NON_ZERO_RQ);
+	MLX5_SET(qpc, qpc, log_sq_size, ilog2(dr_qp->sq.wqe_cnt));
+	MLX5_SET64(qpc, qpc, dbr_addr, dr_qp->wq_ctrl.db.dma);
+	if (MLX5_CAP_GEN(mdev, cqe_version) =3D=3D 1)
+		MLX5_SET(qpc, qpc, user_index, 0xFFFFFF);
+	mlx5_fill_page_frag_array(&dr_qp->wq_ctrl.buf,
+				  (__be64 *)MLX5_ADDR_OF(create_qp_in,
+							 in, pas));
+
+	err =3D mlx5_core_create_qp(mdev, &dr_qp->mqp, in, inlen);
+	kfree(in);
+
+	if (err) {
+		mlx5_core_warn(mdev, " Can't create QP\n");
+		goto err_in;
+	}
+	dr_qp->mqp.event =3D dr_qp_event;
+	dr_qp->uar =3D attr->uar;
+
+	return dr_qp;
+
+err_in:
+	kfree(dr_qp->sq.wqe_head);
+err_wqe_head:
+	mlx5_wq_destroy(&dr_qp->wq_ctrl);
+err_wq:
+	kfree(dr_qp);
+	return NULL;
+}
+
+static void dr_destroy_qp(struct mlx5_core_dev *mdev,
+			  struct mlx5dr_qp *dr_qp)
+{
+	mlx5_core_destroy_qp(mdev, &dr_qp->mqp);
+	kfree(dr_qp->sq.wqe_head);
+	mlx5_wq_destroy(&dr_qp->wq_ctrl);
+	kfree(dr_qp);
+}
+
+static void dr_cmd_notify_hw(struct mlx5dr_qp *dr_qp, void *ctrl)
+{
+	dma_wmb();
+	*dr_qp->wq.sq.db =3D cpu_to_be32(dr_qp->sq.pc & 0xfffff);
+
+	/* After wmb() the hw aware of new work */
+	wmb();
+
+	mlx5_write64(ctrl, dr_qp->uar->map + MLX5_BF_OFFSET);
+}
+
+static void dr_rdma_segments(struct mlx5dr_qp *dr_qp, u64 remote_addr,
+			     u32 rkey, struct dr_data_seg *data_seg,
+			     u32 opcode, int nreq)
+{
+	struct mlx5_wqe_raddr_seg *wq_raddr;
+	struct mlx5_wqe_ctrl_seg *wq_ctrl;
+	struct mlx5_wqe_data_seg *wq_dseg;
+	unsigned int size;
+	unsigned int idx;
+
+	size =3D sizeof(*wq_ctrl) / 16 + sizeof(*wq_dseg) / 16 +
+		sizeof(*wq_raddr) / 16;
+
+	idx =3D dr_qp->sq.pc & (dr_qp->sq.wqe_cnt - 1);
+
+	wq_ctrl =3D mlx5_wq_cyc_get_wqe(&dr_qp->wq.sq, idx);
+	wq_ctrl->imm =3D 0;
+	wq_ctrl->fm_ce_se =3D (data_seg->send_flags) ?
+		MLX5_WQE_CTRL_CQ_UPDATE : 0;
+	wq_ctrl->opmod_idx_opcode =3D cpu_to_be32(((dr_qp->sq.pc & 0xffff) << 8) =
|
+						opcode);
+	wq_ctrl->qpn_ds =3D cpu_to_be32(size | dr_qp->mqp.qpn << 8);
+	wq_raddr =3D (void *)(wq_ctrl + 1);
+	wq_raddr->raddr =3D cpu_to_be64(remote_addr);
+	wq_raddr->rkey =3D cpu_to_be32(rkey);
+	wq_raddr->reserved =3D 0;
+
+	wq_dseg =3D (void *)(wq_raddr + 1);
+	wq_dseg->byte_count =3D cpu_to_be32(data_seg->length);
+	wq_dseg->lkey =3D cpu_to_be32(data_seg->lkey);
+	wq_dseg->addr =3D cpu_to_be64(data_seg->addr);
+
+	dr_qp->sq.wqe_head[idx] =3D dr_qp->sq.pc++;
+
+	if (nreq)
+		dr_cmd_notify_hw(dr_qp, wq_ctrl);
+}
+
+static void dr_post_send(struct mlx5dr_qp *dr_qp, struct postsend_info *se=
nd_info)
+{
+	dr_rdma_segments(dr_qp, send_info->remote_addr, send_info->rkey,
+			 &send_info->write, MLX5_OPCODE_RDMA_WRITE, 0);
+	dr_rdma_segments(dr_qp, send_info->remote_addr, send_info->rkey,
+			 &send_info->read, MLX5_OPCODE_RDMA_READ, 1);
+}
+
+/**
+ * mlx5dr_send_fill_and_append_ste_send_info: Add data to be sent
+ * with send_list parameters:
+ *
+ *     @ste:       The data that attached to this specific ste
+ *     @size:      of data to write
+ *     @offset:    of the data from start of the hw_ste entry
+ *     @data:      data
+ *     @ste_info:  ste to be sent with send_list
+ *     @send_list: to append into it
+ *     @copy_data: if true indicates that the data should be kept because
+ *                 it's not backuped any where (like in re-hash).
+ *                 if false, it lets the data to be updated after
+ *                 it was added to the list.
+ */
+void mlx5dr_send_fill_and_append_ste_send_info(struct mlx5dr_ste *ste, u16=
 size,
+					       u16 offset, u8 *data,
+					       struct mlx5dr_ste_send_info *ste_info,
+					       struct list_head *send_list,
+					       bool copy_data)
+{
+	ste_info->size =3D size;
+	ste_info->ste =3D ste;
+	ste_info->offset =3D offset;
+
+	if (copy_data) {
+		memcpy(ste_info->data_cont, data, size);
+		ste_info->data =3D ste_info->data_cont;
+	} else {
+		ste_info->data =3D data;
+	}
+
+	list_add_tail(&ste_info->send_list, send_list);
+}
+
+/* The function tries to consume one wc each time, unless the queue is ful=
l, in
+ * that case, which means that the hw is behind the sw in a full queue len
+ * the function will drain the cq till it empty.
+ */
+static int dr_handle_pending_wc(struct mlx5dr_domain *dmn,
+				struct mlx5dr_send_ring *send_ring)
+{
+	bool is_drain =3D false;
+	int ne;
+
+	if (send_ring->pending_wqe < send_ring->signal_th)
+		return 0;
+
+	/* Queue is full start drain it */
+	if (send_ring->pending_wqe >=3D
+	    dmn->send_ring->signal_th * TH_NUMS_TO_DRAIN)
+		is_drain =3D true;
+
+	do {
+		ne =3D dr_poll_cq(send_ring->cq, 1);
+		if (ne < 0)
+			return ne;
+		else if (ne =3D=3D 1)
+			send_ring->pending_wqe -=3D send_ring->signal_th;
+	} while (is_drain && send_ring->pending_wqe);
+
+	return 0;
+}
+
+static void dr_fill_data_segs(struct mlx5dr_send_ring *send_ring,
+			      struct postsend_info *send_info)
+{
+	send_ring->pending_wqe++;
+
+	if (send_ring->pending_wqe % send_ring->signal_th =3D=3D 0)
+		send_info->write.send_flags |=3D IB_SEND_SIGNALED;
+
+	send_ring->pending_wqe++;
+	send_info->read.length =3D send_info->write.length;
+	/* Read into the same write area */
+	send_info->read.addr =3D (uintptr_t)send_info->write.addr;
+	send_info->read.lkey =3D send_ring->mr->mkey.key;
+
+	if (send_ring->pending_wqe % send_ring->signal_th =3D=3D 0)
+		send_info->read.send_flags =3D IB_SEND_SIGNALED;
+	else
+		send_info->read.send_flags =3D 0;
+}
+
+static int dr_postsend_icm_data(struct mlx5dr_domain *dmn,
+				struct postsend_info *send_info)
+{
+	struct mlx5dr_send_ring *send_ring =3D dmn->send_ring;
+	u32 buff_offset;
+	int ret;
+
+	ret =3D dr_handle_pending_wc(dmn, send_ring);
+	if (ret)
+		return ret;
+
+	if (send_info->write.length > dmn->info.max_inline_size) {
+		buff_offset =3D (send_ring->tx_head &
+			       (dmn->send_ring->signal_th - 1)) *
+			send_ring->max_post_send_size;
+		/* Copy to ring mr */
+		memcpy(send_ring->buf + buff_offset,
+		       (void *)(uintptr_t)send_info->write.addr,
+		       send_info->write.length);
+		send_info->write.addr =3D (uintptr_t)send_ring->mr->dma_addr + buff_offs=
et;
+		send_info->write.lkey =3D send_ring->mr->mkey.key;
+	}
+
+	send_ring->tx_head++;
+	dr_fill_data_segs(send_ring, send_info);
+	dr_post_send(send_ring->qp, send_info);
+
+	return 0;
+}
+
+static int dr_get_tbl_copy_details(struct mlx5dr_domain *dmn,
+				   struct mlx5dr_ste_htbl *htbl,
+				   u8 **data,
+				   u32 *byte_size,
+				   int *iterations,
+				   int *num_stes)
+{
+	int alloc_size;
+
+	if (htbl->chunk->byte_size > dmn->send_ring->max_post_send_size) {
+		*iterations =3D htbl->chunk->byte_size /
+			dmn->send_ring->max_post_send_size;
+		*byte_size =3D dmn->send_ring->max_post_send_size;
+		alloc_size =3D *byte_size;
+		*num_stes =3D *byte_size / DR_STE_SIZE;
+	} else {
+		*iterations =3D 1;
+		*num_stes =3D htbl->chunk->num_of_entries;
+		alloc_size =3D *num_stes * DR_STE_SIZE;
+	}
+
+	*data =3D kzalloc(alloc_size, GFP_KERNEL);
+	if (!*data)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/**
+ * mlx5dr_send_postsend_ste: write size bytes into offset from the hw cm.
+ *
+ *     @dmn:    Domain
+ *     @ste:    The ste struct that contains the data (at
+ *              least part of it)
+ *     @data:   The real data to send size data
+ *     @size:   for writing.
+ *     @offset: The offset from the icm mapped data to
+ *              start write to this for write only part of the
+ *              buffer.
+ *
+ * Return: 0 on success.
+ */
+int mlx5dr_send_postsend_ste(struct mlx5dr_domain *dmn, struct mlx5dr_ste =
*ste,
+			     u8 *data, u16 size, u16 offset)
+{
+	struct postsend_info send_info =3D {};
+
+	send_info.write.addr =3D (uintptr_t)data;
+	send_info.write.length =3D size;
+	send_info.write.lkey =3D 0;
+	send_info.remote_addr =3D mlx5dr_ste_get_mr_addr(ste) + offset;
+	send_info.rkey =3D ste->htbl->chunk->rkey;
+
+	return dr_postsend_icm_data(dmn, &send_info);
+}
+
+int mlx5dr_send_postsend_htbl(struct mlx5dr_domain *dmn,
+			      struct mlx5dr_ste_htbl *htbl,
+			      u8 *formatted_ste, u8 *mask)
+{
+	u32 byte_size =3D htbl->chunk->byte_size;
+	int num_stes_per_iter;
+	int iterations;
+	u8 *data;
+	int ret;
+	int i;
+	int j;
+
+	ret =3D dr_get_tbl_copy_details(dmn, htbl, &data, &byte_size,
+				      &iterations, &num_stes_per_iter);
+	if (ret)
+		return ret;
+
+	/* Send the data iteration times */
+	for (i =3D 0; i < iterations; i++) {
+		u32 ste_index =3D i * (byte_size / DR_STE_SIZE);
+		struct postsend_info send_info =3D {};
+
+		/* Copy all ste's on the data buffer
+		 * need to add the bit_mask
+		 */
+		for (j =3D 0; j < num_stes_per_iter; j++) {
+			u8 *hw_ste =3D htbl->ste_arr[ste_index + j].hw_ste;
+			u32 ste_off =3D j * DR_STE_SIZE;
+
+			if (mlx5dr_ste_is_not_valid_entry(hw_ste)) {
+				memcpy(data + ste_off,
+				       formatted_ste, DR_STE_SIZE);
+			} else {
+				/* Copy data */
+				memcpy(data + ste_off,
+				       htbl->ste_arr[ste_index + j].hw_ste,
+				       DR_STE_SIZE_REDUCED);
+				/* Copy bit_mask */
+				memcpy(data + ste_off + DR_STE_SIZE_REDUCED,
+				       mask, DR_STE_SIZE_MASK);
+			}
+		}
+
+		send_info.write.addr =3D (uintptr_t)data;
+		send_info.write.length =3D byte_size;
+		send_info.write.lkey =3D 0;
+		send_info.remote_addr =3D
+			mlx5dr_ste_get_mr_addr(htbl->ste_arr + ste_index);
+		send_info.rkey =3D htbl->chunk->rkey;
+
+		ret =3D dr_postsend_icm_data(dmn, &send_info);
+		if (ret)
+			goto out_free;
+	}
+
+out_free:
+	kfree(data);
+	return ret;
+}
+
+/* Initialize htble with default STEs */
+int mlx5dr_send_postsend_formatted_htbl(struct mlx5dr_domain *dmn,
+					struct mlx5dr_ste_htbl *htbl,
+					u8 *ste_init_data,
+					bool update_hw_ste)
+{
+	u32 byte_size =3D htbl->chunk->byte_size;
+	int iterations;
+	int num_stes;
+	u8 *data;
+	int ret;
+	int i;
+
+	ret =3D dr_get_tbl_copy_details(dmn, htbl, &data, &byte_size,
+				      &iterations, &num_stes);
+	if (ret)
+		return ret;
+
+	for (i =3D 0; i < num_stes; i++) {
+		u8 *copy_dst;
+
+		/* Copy the same ste on the data buffer */
+		copy_dst =3D data + i * DR_STE_SIZE;
+		memcpy(copy_dst, ste_init_data, DR_STE_SIZE);
+
+		if (update_hw_ste) {
+			/* Copy the reduced ste to hash table ste_arr */
+			copy_dst =3D htbl->hw_ste_arr + i * DR_STE_SIZE_REDUCED;
+			memcpy(copy_dst, ste_init_data, DR_STE_SIZE_REDUCED);
+		}
+	}
+
+	/* Send the data iteration times */
+	for (i =3D 0; i < iterations; i++) {
+		u8 ste_index =3D i * (byte_size / DR_STE_SIZE);
+		struct postsend_info send_info =3D {};
+
+		send_info.write.addr =3D (uintptr_t)data;
+		send_info.write.length =3D byte_size;
+		send_info.write.lkey =3D 0;
+		send_info.remote_addr =3D
+			mlx5dr_ste_get_mr_addr(htbl->ste_arr + ste_index);
+		send_info.rkey =3D htbl->chunk->rkey;
+
+		ret =3D dr_postsend_icm_data(dmn, &send_info);
+		if (ret)
+			goto out_free;
+	}
+
+out_free:
+	kfree(data);
+	return ret;
+}
+
+int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
+				struct mlx5dr_action *action)
+{
+	struct postsend_info send_info =3D {};
+	int ret;
+
+	send_info.write.addr =3D (uintptr_t)action->rewrite.data;
+	send_info.write.length =3D action->rewrite.chunk->byte_size;
+	send_info.write.lkey =3D 0;
+	send_info.remote_addr =3D action->rewrite.chunk->mr_addr;
+	send_info.rkey =3D action->rewrite.chunk->rkey;
+
+	mutex_lock(&dmn->mutex);
+	ret =3D dr_postsend_icm_data(dmn, &send_info);
+	mutex_unlock(&dmn->mutex);
+
+	return ret;
+}
+
+static int dr_modify_qp_rst2init(struct mlx5_core_dev *mdev,
+				 struct mlx5dr_qp *dr_qp,
+				 int port)
+{
+	u32 in[MLX5_ST_SZ_DW(rst2init_qp_in)] =3D {};
+	void *qpc;
+
+	qpc =3D MLX5_ADDR_OF(rst2init_qp_in, in, qpc);
+
+	MLX5_SET(qpc, qpc, primary_address_path.vhca_port_num, port);
+	MLX5_SET(qpc, qpc, pm_state, MLX5_QPC_PM_STATE_MIGRATED);
+	MLX5_SET(qpc, qpc, rre, 1);
+	MLX5_SET(qpc, qpc, rwe, 1);
+
+	return mlx5_core_qp_modify(mdev, MLX5_CMD_OP_RST2INIT_QP, 0, qpc,
+				   &dr_qp->mqp);
+}
+
+static int dr_cmd_modify_qp_rtr2rts(struct mlx5_core_dev *mdev,
+				    struct mlx5dr_qp *dr_qp,
+				    struct dr_qp_rts_attr *attr)
+{
+	u32 in[MLX5_ST_SZ_DW(rtr2rts_qp_in)] =3D {};
+	void *qpc;
+
+	qpc  =3D MLX5_ADDR_OF(rtr2rts_qp_in, in, qpc);
+
+	MLX5_SET(rtr2rts_qp_in, in, qpn, dr_qp->mqp.qpn);
+
+	MLX5_SET(qpc, qpc, log_ack_req_freq, 0);
+	MLX5_SET(qpc, qpc, retry_count, attr->retry_cnt);
+	MLX5_SET(qpc, qpc, rnr_retry, attr->rnr_retry);
+
+	return mlx5_core_qp_modify(mdev, MLX5_CMD_OP_RTR2RTS_QP, 0, qpc,
+				   &dr_qp->mqp);
+}
+
+static int dr_cmd_modify_qp_init2rtr(struct mlx5_core_dev *mdev,
+				     struct mlx5dr_qp *dr_qp,
+				     struct dr_qp_rtr_attr *attr)
+{
+	u32 in[MLX5_ST_SZ_DW(init2rtr_qp_in)] =3D {};
+	void *qpc;
+
+	qpc =3D MLX5_ADDR_OF(init2rtr_qp_in, in, qpc);
+
+	MLX5_SET(init2rtr_qp_in, in, qpn, dr_qp->mqp.qpn);
+
+	MLX5_SET(qpc, qpc, mtu, attr->mtu);
+	MLX5_SET(qpc, qpc, log_msg_max, DR_CHUNK_SIZE_MAX - 1);
+	MLX5_SET(qpc, qpc, remote_qpn, attr->qp_num);
+	memcpy(MLX5_ADDR_OF(qpc, qpc, primary_address_path.rmac_47_32),
+	       attr->dgid_attr.mac, sizeof(attr->dgid_attr.mac));
+	memcpy(MLX5_ADDR_OF(qpc, qpc, primary_address_path.rgid_rip),
+	       attr->dgid_attr.gid, sizeof(attr->dgid_attr.gid));
+	MLX5_SET(qpc, qpc, primary_address_path.src_addr_index,
+		 attr->sgid_index);
+
+	if (attr->dgid_attr.roce_ver =3D=3D MLX5_ROCE_VERSION_2)
+		MLX5_SET(qpc, qpc, primary_address_path.udp_sport,
+			 attr->udp_src_port);
+
+	MLX5_SET(qpc, qpc, primary_address_path.vhca_port_num, attr->port_num);
+	MLX5_SET(qpc, qpc, min_rnr_nak, 1);
+
+	return mlx5_core_qp_modify(mdev, MLX5_CMD_OP_INIT2RTR_QP, 0, qpc,
+				   &dr_qp->mqp);
+}
+
+static int dr_prepare_qp_to_rts(struct mlx5dr_domain *dmn)
+{
+	struct mlx5dr_qp *dr_qp =3D dmn->send_ring->qp;
+	struct dr_qp_rts_attr rts_attr =3D {};
+	struct dr_qp_rtr_attr rtr_attr =3D {};
+	enum ib_mtu mtu =3D IB_MTU_1024;
+	u16 gid_index =3D 0;
+	int port =3D 1;
+	int ret;
+
+	/* Init */
+	ret =3D dr_modify_qp_rst2init(dmn->mdev, dr_qp, port);
+	if (ret)
+		return ret;
+
+	/* RTR */
+	ret =3D mlx5dr_cmd_query_gid(dmn->mdev, port, gid_index, &rtr_attr.dgid_a=
ttr);
+	if (ret)
+		return ret;
+
+	rtr_attr.mtu		=3D mtu;
+	rtr_attr.qp_num		=3D dr_qp->mqp.qpn;
+	rtr_attr.min_rnr_timer	=3D 12;
+	rtr_attr.port_num	=3D port;
+	rtr_attr.sgid_index	=3D gid_index;
+	rtr_attr.udp_src_port	=3D dmn->info.caps.roce_min_src_udp;
+
+	ret =3D dr_cmd_modify_qp_init2rtr(dmn->mdev, dr_qp, &rtr_attr);
+	if (ret)
+		return ret;
+
+	/* RTS */
+	rts_attr.timeout	=3D 14;
+	rts_attr.retry_cnt	=3D 7;
+	rts_attr.rnr_retry	=3D 7;
+
+	ret =3D dr_cmd_modify_qp_rtr2rts(dmn->mdev, dr_qp, &rts_attr);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void dr_cq_event(struct mlx5_core_cq *mcq,
+			enum mlx5_event event)
+{
+	pr_info("CQ event %u on CQ #%u\n", event, mcq->cqn);
+}
+
+static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
+				      struct mlx5_uars_page *uar,
+				      size_t ncqe)
+{
+	u32 temp_cqc[MLX5_ST_SZ_DW(cqc)] =3D {};
+	u32 out[MLX5_ST_SZ_DW(create_cq_out)];
+	struct mlx5_wq_param wqp;
+	struct mlx5_cqe64 *cqe;
+	struct mlx5dr_cq *cq;
+	int inlen, err, eqn;
+	unsigned int irqn;
+	void *cqc, *in;
+	__be64 *pas;
+	u32 i;
+
+	cq =3D kzalloc(sizeof(*cq), GFP_KERNEL);
+	if (!cq)
+		return NULL;
+
+	ncqe =3D roundup_pow_of_two(ncqe);
+	MLX5_SET(cqc, temp_cqc, log_cq_size, ilog2(ncqe));
+
+	wqp.buf_numa_node =3D mdev->priv.numa_node;
+	wqp.db_numa_node =3D mdev->priv.numa_node;
+
+	err =3D mlx5_cqwq_create(mdev, &wqp, temp_cqc, &cq->wq,
+			       &cq->wq_ctrl);
+	if (err)
+		goto out;
+
+	for (i =3D 0; i < mlx5_cqwq_get_size(&cq->wq); i++) {
+		cqe =3D mlx5_cqwq_get_wqe(&cq->wq, i);
+		cqe->op_own =3D MLX5_CQE_INVALID << 4 | MLX5_CQE_OWNER_MASK;
+	}
+
+	inlen =3D MLX5_ST_SZ_BYTES(create_cq_in) +
+		sizeof(u64) * cq->wq_ctrl.buf.npages;
+	in =3D kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		goto err_cqwq;
+
+	err =3D mlx5_vector2eqn(mdev, smp_processor_id(), &eqn, &irqn);
+	if (err) {
+		kvfree(in);
+		goto err_cqwq;
+	}
+
+	cqc =3D MLX5_ADDR_OF(create_cq_in, in, cq_context);
+	MLX5_SET(cqc, cqc, log_cq_size, ilog2(ncqe));
+	MLX5_SET(cqc, cqc, c_eqn, eqn);
+	MLX5_SET(cqc, cqc, uar_page, uar->index);
+	MLX5_SET(cqc, cqc, log_page_size, cq->wq_ctrl.buf.page_shift -
+		 MLX5_ADAPTER_PAGE_SHIFT);
+	MLX5_SET64(cqc, cqc, dbr_addr, cq->wq_ctrl.db.dma);
+
+	pas =3D (__be64 *)MLX5_ADDR_OF(create_cq_in, in, pas);
+	mlx5_fill_page_frag_array(&cq->wq_ctrl.buf, pas);
+
+	cq->mcq.event =3D dr_cq_event;
+
+	err =3D mlx5_core_create_cq(mdev, &cq->mcq, in, inlen, out, sizeof(out));
+	kvfree(in);
+
+	if (err)
+		goto err_cqwq;
+
+	cq->mcq.cqe_sz =3D 64;
+	cq->mcq.set_ci_db =3D cq->wq_ctrl.db.db;
+	cq->mcq.arm_db =3D cq->wq_ctrl.db.db + 1;
+	*cq->mcq.set_ci_db =3D 0;
+	*cq->mcq.arm_db =3D 0;
+	cq->mcq.vector =3D 0;
+	cq->mcq.irqn =3D irqn;
+	cq->mcq.uar =3D uar;
+
+	return cq;
+
+err_cqwq:
+	mlx5_wq_destroy(&cq->wq_ctrl);
+out:
+	kfree(cq);
+	return NULL;
+}
+
+static void dr_destroy_cq(struct mlx5_core_dev *mdev, struct mlx5dr_cq *cq=
)
+{
+	mlx5_core_destroy_cq(mdev, &cq->mcq);
+	mlx5_wq_destroy(&cq->wq_ctrl);
+	kfree(cq);
+}
+
+static int
+dr_create_mkey(struct mlx5_core_dev *mdev, u32 pdn, struct mlx5_core_mkey =
*mkey)
+{
+	u32 in[MLX5_ST_SZ_DW(create_mkey_in)] =3D {};
+	void *mkc;
+
+	mkc =3D MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_PA);
+	MLX5_SET(mkc, mkc, a, 1);
+	MLX5_SET(mkc, mkc, rw, 1);
+	MLX5_SET(mkc, mkc, rr, 1);
+	MLX5_SET(mkc, mkc, lw, 1);
+	MLX5_SET(mkc, mkc, lr, 1);
+
+	MLX5_SET(mkc, mkc, pd, pdn);
+	MLX5_SET(mkc, mkc, length64, 1);
+	MLX5_SET(mkc, mkc, qpn, 0xffffff);
+
+	return mlx5_core_create_mkey(mdev, mkey, in, sizeof(in));
+}
+
+static struct mlx5dr_mr *dr_reg_mr(struct mlx5_core_dev *mdev,
+				   u32 pdn, void *buf, size_t size)
+{
+	struct mlx5dr_mr *mr =3D kzalloc(sizeof(*mr), GFP_KERNEL);
+	struct device *dma_device;
+	dma_addr_t dma_addr;
+	int err;
+
+	if (!mr)
+		return NULL;
+
+	dma_device =3D &mdev->pdev->dev;
+	dma_addr =3D dma_map_single(dma_device, buf, size,
+				  DMA_BIDIRECTIONAL);
+	err =3D dma_mapping_error(dma_device, dma_addr);
+	if (err) {
+		mlx5_core_warn(mdev, "Can't dma buf\n");
+		kfree(mr);
+		return NULL;
+	}
+
+	err =3D dr_create_mkey(mdev, pdn, &mr->mkey);
+	if (err) {
+		mlx5_core_warn(mdev, "Can't create mkey\n");
+		dma_unmap_single(dma_device, dma_addr, size,
+				 DMA_BIDIRECTIONAL);
+		kfree(mr);
+		return NULL;
+	}
+
+	mr->dma_addr =3D dma_addr;
+	mr->size =3D size;
+	mr->addr =3D buf;
+
+	return mr;
+}
+
+static void dr_dereg_mr(struct mlx5_core_dev *mdev, struct mlx5dr_mr *mr)
+{
+	mlx5_core_destroy_mkey(mdev, &mr->mkey);
+	dma_unmap_single(&mdev->pdev->dev, mr->dma_addr, mr->size,
+			 DMA_BIDIRECTIONAL);
+	kfree(mr);
+}
+
+int mlx5dr_send_ring_alloc(struct mlx5dr_domain *dmn)
+{
+	struct dr_qp_init_attr init_attr =3D {};
+	int cq_size;
+	int size;
+	int ret;
+
+	dmn->send_ring =3D kzalloc(sizeof(*dmn->send_ring), GFP_KERNEL);
+	if (!dmn->send_ring)
+		return -ENOMEM;
+
+	cq_size =3D QUEUE_SIZE + 1;
+	dmn->send_ring->cq =3D dr_create_cq(dmn->mdev, dmn->uar, cq_size);
+	if (!dmn->send_ring->cq) {
+		ret =3D -ENOMEM;
+		goto free_send_ring;
+	}
+
+	init_attr.cqn =3D dmn->send_ring->cq->mcq.cqn;
+	init_attr.pdn =3D dmn->pdn;
+	init_attr.uar =3D dmn->uar;
+	init_attr.max_send_wr =3D QUEUE_SIZE;
+
+	dmn->send_ring->qp =3D dr_create_rc_qp(dmn->mdev, &init_attr);
+	if (!dmn->send_ring->qp)  {
+		ret =3D -ENOMEM;
+		goto clean_cq;
+	}
+
+	dmn->send_ring->cq->qp =3D dmn->send_ring->qp;
+
+	dmn->info.max_send_wr =3D QUEUE_SIZE;
+	dmn->info.max_inline_size =3D min(dmn->send_ring->qp->max_inline_data,
+					DR_STE_SIZE);
+
+	dmn->send_ring->signal_th =3D dmn->info.max_send_wr /
+		SIGNAL_PER_DIV_QUEUE;
+
+	/* Prepare qp to be used */
+	ret =3D dr_prepare_qp_to_rts(dmn);
+	if (ret)
+		goto clean_qp;
+
+	dmn->send_ring->max_post_send_size =3D
+		mlx5dr_icm_pool_chunk_size_to_byte(DR_CHUNK_SIZE_1K,
+						   DR_ICM_TYPE_STE);
+
+	/* Allocating the max size as a buffer for writing */
+	size =3D dmn->send_ring->signal_th * dmn->send_ring->max_post_send_size;
+	dmn->send_ring->buf =3D kzalloc(size, GFP_KERNEL);
+	if (!dmn->send_ring->buf) {
+		ret =3D -ENOMEM;
+		goto clean_qp;
+	}
+
+	memset(dmn->send_ring->buf, 0, size);
+	dmn->send_ring->buf_size =3D size;
+
+	dmn->send_ring->mr =3D dr_reg_mr(dmn->mdev,
+				       dmn->pdn, dmn->send_ring->buf, size);
+	if (!dmn->send_ring->mr) {
+		ret =3D -ENOMEM;
+		goto free_mem;
+	}
+
+	dmn->send_ring->sync_mr =3D dr_reg_mr(dmn->mdev,
+					    dmn->pdn, dmn->send_ring->sync_buff,
+					    MIN_READ_SYNC);
+	if (!dmn->send_ring->sync_mr) {
+		ret =3D -ENOMEM;
+		goto clean_mr;
+	}
+
+	return 0;
+
+clean_mr:
+	dr_dereg_mr(dmn->mdev, dmn->send_ring->mr);
+free_mem:
+	kfree(dmn->send_ring->buf);
+clean_qp:
+	dr_destroy_qp(dmn->mdev, dmn->send_ring->qp);
+clean_cq:
+	dr_destroy_cq(dmn->mdev, dmn->send_ring->cq);
+free_send_ring:
+	kfree(dmn->send_ring);
+
+	return ret;
+}
+
+void mlx5dr_send_ring_free(struct mlx5dr_domain *dmn,
+			   struct mlx5dr_send_ring *send_ring)
+{
+	dr_destroy_qp(dmn->mdev, send_ring->qp);
+	dr_destroy_cq(dmn->mdev, send_ring->cq);
+	dr_dereg_mr(dmn->mdev, send_ring->sync_mr);
+	dr_dereg_mr(dmn->mdev, send_ring->mr);
+	kfree(send_ring->buf);
+	kfree(send_ring);
+}
+
+int mlx5dr_send_ring_force_drain(struct mlx5dr_domain *dmn)
+{
+	struct mlx5dr_send_ring *send_ring =3D dmn->send_ring;
+	struct postsend_info send_info =3D {};
+	u8 data[DR_STE_SIZE];
+	int num_of_sends_req;
+	int ret;
+	int i;
+
+	/* Sending this amount of requests makes sure we will get drain */
+	num_of_sends_req =3D send_ring->signal_th * TH_NUMS_TO_DRAIN / 2;
+
+	/* Send fake requests forcing the last to be signaled */
+	send_info.write.addr =3D (uintptr_t)data;
+	send_info.write.length =3D DR_STE_SIZE;
+	send_info.write.lkey =3D 0;
+	/* Using the sync_mr in order to write/read */
+	send_info.remote_addr =3D (uintptr_t)send_ring->sync_mr->addr;
+	send_info.rkey =3D send_ring->sync_mr->mkey.key;
+
+	for (i =3D 0; i < num_of_sends_req; i++) {
+		ret =3D dr_postsend_icm_data(dmn, &send_info);
+		if (ret)
+			return ret;
+	}
+
+	ret =3D dr_handle_pending_wc(dmn, send_ring);
+
+	return ret;
+}
--=20
2.21.0

