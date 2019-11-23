Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95A5E107D68
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 08:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfKWHNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 02:13:21 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45140 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfKWHNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 02:13:21 -0500
Received: by mail-pl1-f194.google.com with SMTP id w7so4168360plz.12;
        Fri, 22 Nov 2019 23:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TeFTEDR+Rw8qArbasVWPulVM2RgGFeXAldh6hhUveCE=;
        b=EjRgKXG8SckShnP73HiB9NURyne+cgWzEEp2LHg+4QvRg2atxcupYd1I1oHVHg3T2d
         15dBoZCffLtz23ZBdXQzVl5zbtA3VKnXDjGYIQQ7CX6KADqkIz0J3x/rQVSipf1Q+1mv
         rXl33So48fWAYtUWUjseN+ulsDkK1vvhbilVYYTJO5jTl/KZ42bJxzxx+7qh5JNV0jzB
         Ruu8SdPmlHpAemCMr5TcLAd9ICNgE7smiRneRFk23ujqOKoGuEbm3p6VtzQ5ItjElUXB
         Q3p0hVwaq6RmoPJbXSH4GLT1CunPFXKd9n8UrhBCQeZLQhZnTsjGzD6Cc5flsADLKzJj
         xMWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TeFTEDR+Rw8qArbasVWPulVM2RgGFeXAldh6hhUveCE=;
        b=cYYt8GmUylVOcbZPTdiZ90IGECWfv/a2xf28T/2rHrW8/XC+WGtBDOIHO/dv7tb2vG
         IaN+/Z06s2GQHZdgdL+ShrgZgm/z1pVtm+W+vGY8jDcabYH6447ej7GKp1M+JSrzAV5/
         wRS4wk/PkMlHOZAcyfs+xW5ZLd2kDdMK/sHE7JsOxZm/pa+hEduvEb297vGIu98YcKEO
         KjpQ1LorvFNWSw82J35NJq27dRP0FKcjhgTFgXirgi1FxwhtK4NYhxuY5VXU1e2P5M/M
         N9N6//yrVrcJLTVQ+XqtujFvBxFpdD7en0TkmZTDhwozVNX/3SCs0RO94yxsCAMWI3bZ
         4/qw==
X-Gm-Message-State: APjAAAVJRcIF/YLNUXUB2vyA/ddj3HkzJwuULb8YUtWMrlxYHT17cHvv
        KDF4H0jVgInHVXpfgGKUThIlcOWKQDPk9g==
X-Google-Smtp-Source: APXvYqz1Vkq9eXg4tm6Ey1jdN4eljATz4RNUNcY26JSH3rXuRQbswHxKim6lI8d/6JDcBcy6BkmCiQ==
X-Received: by 2002:a17:902:7c0e:: with SMTP id x14mr18176407pll.277.1574493200390;
        Fri, 22 Nov 2019 23:13:20 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id 67sm798960pjz.27.2019.11.22.23.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 23:13:19 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com, tariqt@mellanox.com,
        saeedm@mellanox.com, maximmi@mellanox.com
Subject: [PATCH bpf-next v2 6/6] net/mlx5e: Start using xdp_call.h
Date:   Sat, 23 Nov 2019 08:12:25 +0100
Message-Id: <20191123071226.6501-7-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191123071226.6501-1-bjorn.topel@gmail.com>
References: <20191123071226.6501-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

This commit starts using xdp_call.h and the BPF dispatcher to avoid
the retpoline overhead.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c  | 5 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index f049e0ac308a..cc11b0db950e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -32,6 +32,7 @@
 
 #include <linux/bpf_trace.h>
 #include <net/xdp_sock.h>
+#include <linux/xdp_call.h>
 #include "en/xdp.h"
 #include "en/params.h"
 
@@ -117,6 +118,8 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 	return sq->xmit_xdp_frame(sq, &xdptxd, &xdpi, 0);
 }
 
+DECLARE_XDP_CALL(mlx5e_xdp_call);
+
 /* returns true if packet was consumed by xdp */
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 		      void *va, u16 *rx_headroom, u32 *len, bool xsk)
@@ -138,7 +141,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 		xdp.handle = di->xsk.handle;
 	xdp.rxq = &rq->xdp_rxq;
 
-	act = bpf_prog_run_xdp(prog, &xdp);
+	act = xdp_call_run(mlx5e_xdp_call, prog, &xdp);
 	if (xsk) {
 		u64 off = xdp.data - xdp.data_hard_start;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index e8d799c0dfda..0b26f9d7a968 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -39,6 +39,7 @@
 #include <linux/if_bridge.h>
 #include <net/page_pool.h>
 #include <net/xdp_sock.h>
+#include <linux/xdp_call.h>
 #include "eswitch.h"
 #include "en.h"
 #include "en/txrx.h"
@@ -4384,6 +4385,8 @@ static int mlx5e_xdp_update_state(struct mlx5e_priv *priv)
 	return 0;
 }
 
+DEFINE_XDP_CALL(mlx5e_xdp_call);
+
 static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -4428,6 +4431,8 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 		old_prog = xchg(&priv->channels.params.xdp_prog, prog);
 	}
 
+	xdp_call_update(mlx5e_xdp_call, old_prog, prog);
+
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
-- 
2.20.1

