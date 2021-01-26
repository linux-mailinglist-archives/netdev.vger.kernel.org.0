Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15C33050C8
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238630AbhA0E1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:27:06 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2359 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388680AbhAZXZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:25:24 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a4bb0003>; Tue, 26 Jan 2021 15:24:43 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:24:42 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/14] net/mlx5: Rename events notifier header
Date:   Tue, 26 Jan 2021 15:24:10 -0800
Message-ID: <20210126232419.175836-6-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126232419.175836-1-saeedm@nvidia.com>
References: <20210126232419.175836-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611703483; bh=d4oqF4UikK2LhVhLcq1lsEBvCG9/aBRlk3isWU25Cfw=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=l73vL674WhBiUSiojsv+e2jQx5fQ0kYsf7JvpYlOA1Ii1RzfvVRcMPrB7uzLFFfKU
         rRY1SpsmAUpfTInzAEuyjyWnqZ5WCdHOhYP2dPrrbd2TQyHLpadGZP8IPmddcbPqzw
         LsIgg2XfDdmxTx+Mh2YNyIY4dfP1cFGCN3xKNFPhJ3IBs+oPYkcN/x/lHaapVhwYRB
         HMj+Vs8qDCubK+M5SWW6SCqliYHy/WVqxm7fwBg9JkMktjnN/7tOi4G3gtU8wtm8m3
         30Z6UkKXiQ6XpeMae7AIEP3ld+G8unxA0Hd3E6tORlVTMetMbON5CdYo3A3QEjVxkP
         4vEUrfNZvBKuA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Change the naming of events notifier head to clarify that it handles
only firmware events. Coming patches in the set, add event notifier for
software events.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/events.c  | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net=
/ethernet/mellanox/mlx5/core/events.c
index 3ce17c3d7a00..054c0bc36d24 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -23,7 +23,7 @@ static int temp_warn(struct notifier_block *, unsigned lo=
ng, void *);
 static int port_module(struct notifier_block *, unsigned long, void *);
 static int pcie_core(struct notifier_block *, unsigned long, void *);
=20
-/* handler which forwards the event to events->nh, driver notifiers */
+/* handler which forwards the event to events->fw_nh, driver notifiers */
 static int forward_event(struct notifier_block *, unsigned long, void *);
=20
 static struct mlx5_nb events_nbs_ref[] =3D {
@@ -55,8 +55,8 @@ struct mlx5_events {
 	struct mlx5_core_dev *dev;
 	struct workqueue_struct *wq;
 	struct mlx5_event_nb  notifiers[ARRAY_SIZE(events_nbs_ref)];
-	/* driver notifier chain */
-	struct atomic_notifier_head nh;
+	/* driver notifier chain for fw events */
+	struct atomic_notifier_head fw_nh;
 	/* port module events stats */
 	struct mlx5_pme_stats pme_stats;
 	/*pcie_core*/
@@ -331,7 +331,7 @@ static int forward_event(struct notifier_block *nb, uns=
igned long event, void *d
=20
 	mlx5_core_dbg(events->dev, "Async eqe type %s, subtype (%d) forward to in=
terfaces\n",
 		      eqe_type_str(eqe->type), eqe->sub_type);
-	atomic_notifier_call_chain(&events->nh, event, data);
+	atomic_notifier_call_chain(&events->fw_nh, event, data);
 	return NOTIFY_OK;
 }
=20
@@ -342,7 +342,7 @@ int mlx5_events_init(struct mlx5_core_dev *dev)
 	if (!events)
 		return -ENOMEM;
=20
-	ATOMIC_INIT_NOTIFIER_HEAD(&events->nh);
+	ATOMIC_INIT_NOTIFIER_HEAD(&events->fw_nh);
 	events->dev =3D dev;
 	dev->priv.events =3D events;
 	events->wq =3D create_singlethread_workqueue("mlx5_events");
@@ -383,11 +383,14 @@ void mlx5_events_stop(struct mlx5_core_dev *dev)
 	flush_workqueue(events->wq);
 }
=20
+/* This API is used only for processing and forwarding firmware
+ * events to mlx5 consumer.
+ */
 int mlx5_notifier_register(struct mlx5_core_dev *dev, struct notifier_bloc=
k *nb)
 {
 	struct mlx5_events *events =3D dev->priv.events;
=20
-	return atomic_notifier_chain_register(&events->nh, nb);
+	return atomic_notifier_chain_register(&events->fw_nh, nb);
 }
 EXPORT_SYMBOL(mlx5_notifier_register);
=20
@@ -395,11 +398,11 @@ int mlx5_notifier_unregister(struct mlx5_core_dev *de=
v, struct notifier_block *n
 {
 	struct mlx5_events *events =3D dev->priv.events;
=20
-	return atomic_notifier_chain_unregister(&events->nh, nb);
+	return atomic_notifier_chain_unregister(&events->fw_nh, nb);
 }
 EXPORT_SYMBOL(mlx5_notifier_unregister);
=20
 int mlx5_notifier_call_chain(struct mlx5_events *events, unsigned int even=
t, void *data)
 {
-	return atomic_notifier_call_chain(&events->nh, event, data);
+	return atomic_notifier_call_chain(&events->fw_nh, event, data);
 }
--=20
2.29.2

