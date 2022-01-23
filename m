Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3343C49746A
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 19:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbiAWSkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 13:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239622AbiAWSkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 13:40:02 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5123AC061744;
        Sun, 23 Jan 2022 10:40:02 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id d15-20020a17090a110f00b001b4e7d27474so14267008pja.2;
        Sun, 23 Jan 2022 10:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zfgimupqB4xhJIvLvGgrer31y9tj8J1RXghy7qnKugc=;
        b=gxMhHOGPzZikvHKNf5etkD8h5zwamCQvFvYm0T3TfrFpDLfs91aCsHtI+xqcPa8URu
         FFjowqDhhJ69tQF4OsI04OdzbE5H9ypOLCLw0BtlXsPReQihAHoMJCWdJw5zE4jVLwhO
         g1nviPaL/KLA6cJWfPzd19d6k4Ji+gex9ZTZO6W3Zaz3jY8H7L8ePhgHrqIqtcKI37r7
         cowwVtPoBOznRQ1kol1AgbR+qWyIdu3IGSHuMqs4JxjKQY8qyAQLqRH8r0wbcItyWyPo
         E6MFahxwAjE0Bt/rxvJ7psK8eynqLBYQJQKjMtYYJccVf+NgvivqphIBCiCRJT/6TI3g
         RrSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zfgimupqB4xhJIvLvGgrer31y9tj8J1RXghy7qnKugc=;
        b=UejStlkhzuhx+lQNLhnf6qYMHBvkJ6yjLtghEAmZXMf+LBgRrInK7XpHi3KKXh4vOe
         jhpDWfbBGJiYYL0CDxmnSHIj0Mm2Jgz4snGLQQsIXLv+TdM622OhTaOMePNLhEfLRLXp
         6ASkFtykNOeH994+XtTlx5dl5VPrhjkkgOTGN7jRhRismz40AVDEKNt4s+JxlYs3oNY/
         EnrY4uFoE3qKKiMvA6BSsuSMlFtY0J9f3zB+o5F8V7MTwHLya+9XQFNIyd/B7/96dYqa
         el3yfkQMiUVncJOi0fHxA89d7nXXvDlKlvwGIY0azNZnj6mFCNRS42mpCxEBT9UipC7m
         DTnQ==
X-Gm-Message-State: AOAM5317ks6D9UURsd+ougE+pSX77B017RQc+8qxuo8p8TIdlJe0wjpj
        R93f73LTPxm7JEWogSakeYs=
X-Google-Smtp-Source: ABdhPJxLWQjXfOWkcABvAW38WG6KUSqa6hXvCSlwZOr+ADYOSoQ4eSLrZHymWaTH90oODMTjxHWQng==
X-Received: by 2002:a17:902:ea0d:b0:14b:4c26:f43d with SMTP id s13-20020a170902ea0d00b0014b4c26f43dmr2267545plg.135.1642963201797;
        Sun, 23 Jan 2022 10:40:01 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id pj7sm1940960pjb.50.2022.01.23.10.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 10:40:01 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH 04/54] net: mellanox: fix open-coded for_each_set_bit()
Date:   Sun, 23 Jan 2022 10:38:35 -0800
Message-Id: <20220123183925.1052919-5-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220123183925.1052919-1-yury.norov@gmail.com>
References: <20220123183925.1052919-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mellanox driver has an open-coded for_each_set_bit(). Fix it.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index e10b7b04b894..c56d2194cbfc 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -1994,21 +1994,16 @@ static void mlx4_allocate_port_vpps(struct mlx4_dev *dev, int port)
 
 static int mlx4_master_activate_admin_state(struct mlx4_priv *priv, int slave)
 {
-	int port, err;
+	int p, port, err;
 	struct mlx4_vport_state *vp_admin;
 	struct mlx4_vport_oper_state *vp_oper;
 	struct mlx4_slave_state *slave_state =
 		&priv->mfunc.master.slave_state[slave];
 	struct mlx4_active_ports actv_ports = mlx4_get_active_ports(
 			&priv->dev, slave);
-	int min_port = find_first_bit(actv_ports.ports,
-				      priv->dev.caps.num_ports) + 1;
-	int max_port = min_port - 1 +
-		bitmap_weight(actv_ports.ports, priv->dev.caps.num_ports);
 
-	for (port = min_port; port <= max_port; port++) {
-		if (!test_bit(port - 1, actv_ports.ports))
-			continue;
+	for_each_set_bit(p, actv_ports.ports, priv->dev.caps.num_ports) {
+		port = p + 1;
 		priv->mfunc.master.vf_oper[slave].smi_enabled[port] =
 			priv->mfunc.master.vf_admin[slave].enable_smi[port];
 		vp_oper = &priv->mfunc.master.vf_oper[slave].vport[port];
@@ -2063,19 +2058,13 @@ static int mlx4_master_activate_admin_state(struct mlx4_priv *priv, int slave)
 
 static void mlx4_master_deactivate_admin_state(struct mlx4_priv *priv, int slave)
 {
-	int port;
+	int p, port;
 	struct mlx4_vport_oper_state *vp_oper;
 	struct mlx4_active_ports actv_ports = mlx4_get_active_ports(
 			&priv->dev, slave);
-	int min_port = find_first_bit(actv_ports.ports,
-				      priv->dev.caps.num_ports) + 1;
-	int max_port = min_port - 1 +
-		bitmap_weight(actv_ports.ports, priv->dev.caps.num_ports);
 
-
-	for (port = min_port; port <= max_port; port++) {
-		if (!test_bit(port - 1, actv_ports.ports))
-			continue;
+	for_each_set_bit(p, actv_ports.ports, priv->dev.caps.num_ports) {
+		port = p + 1;
 		priv->mfunc.master.vf_oper[slave].smi_enabled[port] =
 			MLX4_VF_SMI_DISABLED;
 		vp_oper = &priv->mfunc.master.vf_oper[slave].vport[port];
-- 
2.30.2

