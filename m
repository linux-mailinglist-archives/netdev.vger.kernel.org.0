Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2A14588EF
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfF0RnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:43:12 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44635 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfF0RnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:43:11 -0400
Received: by mail-pl1-f193.google.com with SMTP id t7so1670046plr.11;
        Thu, 27 Jun 2019 10:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XMtbDy7ICVx9sNVDO5hcGRd0P6kv9+a3LFvIsYsOFnw=;
        b=Dm7DjZf+RwRrSgNYf08NJEWY1VKzGCc3XD4H35gEIFM4doU6DVgCiyjsX6z0YPheLa
         O2vqEOOrlEC/azUiCg9//zCHoxNq83yybTGLCOiA6jEakmBLhPQMtwAVmSL0ON92hTmy
         64J2MHEy2DRRFI+RN+ANhn5y3JLzI0HPXMozKp4BBki6Ij343zd976mGyINBEmr6VMa/
         mDryKUpWWVWzY4cUnoO1cMCqLI8E7r1bE5PpKxqtwX5AM9XDBxDkbkvVPijmZ8ljSDx+
         TKI9joJueSnCnVl6g/rD6wjWJDiU/QXCJRpWwtp8+KdgUiaDhuxgFXE2rWwsmYLJofiz
         1olQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XMtbDy7ICVx9sNVDO5hcGRd0P6kv9+a3LFvIsYsOFnw=;
        b=nsgkxVfV6z3+BUhBV8TB6TBcWgl86VMu24bKwPuNsEnW8+c8whiPPRKhmY/+uSpju3
         5lP5H9AHS9VATasyyf0iOrkUaebp+iJQDEdToT4CpTpjDf9uCX3v5veFYqs7TCAVFYou
         7H71ZDyDJR66bPVxjVetT0CGEKoLHQYVJCkrUrCkqNLBpeLjg4+ogOkbH7+z8vfrImMu
         i6MWPlDtbt64sXOu3BPwEHuddZN7hMXIu+pEjXowCZPpAuY8p0CWkx3smFT355P+zDQZ
         lJL0BehCRm+S4+P5s4ZkjUpusTzvszl+2uJ/KSB4X7kdDsd55AKTyDcRyw6/gnb/2lCo
         lnaw==
X-Gm-Message-State: APjAAAWQ0D+Rw1PHLzhzObEGjGnTbwQro0/xUFt//SJO04kXjs51CF6N
        IeBdl+Kctk4wPv0xAddXL7U=
X-Google-Smtp-Source: APXvYqzy3Ztt7IQZDJ9RrtSVSX7ny+ia2LX8OvP/XAwNpY7O/YPhbm/2B6k0+I+ofyI6EVTYeA9/Kw==
X-Received: by 2002:a17:902:b187:: with SMTP id s7mr5927238plr.309.1561657391050;
        Thu, 27 Jun 2019 10:43:11 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id j21sm3240723pfh.86.2019.06.27.10.43.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:43:10 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 85/87] ethernet: mellanox: mlx5: remove memset after kvzalloc
Date:   Fri, 28 Jun 2019 01:43:01 +0800
Message-Id: <20190627174301.4983-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kvzalloc already zeroes the memory.
So memset is unneeded.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 6a921e24cd5e..587c51fa3985 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2391,7 +2391,6 @@ int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
 	MLX5_SET(query_vport_counter_in, in, vport_number, vport->vport);
 	MLX5_SET(query_vport_counter_in, in, other_vport, 1);
 
-	memset(out, 0, outlen);
 	err = mlx5_cmd_exec(esw->dev, in, sizeof(in), out, outlen);
 	if (err)
 		goto free_out;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 47b446d30f71..ef5fe3bd95f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -993,7 +993,6 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw, int nvports)
 	}
 
 	/* create send-to-vport group */
-	memset(flow_group_in, 0, inlen);
 	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
 		 MLX5_MATCH_MISC_PARAMETERS);
 
@@ -1151,7 +1150,6 @@ static int esw_create_vport_rx_group(struct mlx5_eswitch *esw, int nvports)
 		return -ENOMEM;
 
 	/* create vport rx group */
-	memset(flow_group_in, 0, inlen);
 	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
 		 MLX5_MATCH_MISC_PARAMETERS);
 
-- 
2.11.0

