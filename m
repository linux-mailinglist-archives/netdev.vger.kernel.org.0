Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2824B19FE
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 01:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346004AbiBKACa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 19:02:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345998AbiBKAC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 19:02:29 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AE6B49;
        Thu, 10 Feb 2022 16:02:29 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id b35so6675716qkp.6;
        Thu, 10 Feb 2022 16:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cn+lM1AC6Wl058uCalgabTDXoS6RKyQ5ezmTj8hWjqc=;
        b=U6qybxVNUPg6wMb4Z1IQgNBqT6xW3REYN2Sr/6brQlQsYt6MN0rdzndRhY1bqgcIWj
         OZEYlaAmP8rhkhwL1v4h50e+w6DKaqK9b4jaDwjxi5J36Nc8nm2KlHJLlSZwqQqN+5AF
         /GvIdafVgN6DI7iM+8CdPZkYFoz5OtGlCZVRLCCtDwlWHbgPn+wRceAoy1u8/10XPAzW
         wvwf5sEWsyipP+Co2Us5jJL2qnVCGyhvB+ZAO/LNGkYi16RuhSY5ggC/sSl6UXWNLU5Z
         eihuxa2wdkytxpqfsQb/fee3IDvquaqQLoOT1wwVQDnXPrO2W4G3b2ti2V7k65li737J
         woHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cn+lM1AC6Wl058uCalgabTDXoS6RKyQ5ezmTj8hWjqc=;
        b=SOE4InXr0B3zXPEu0BO79aJYHaK2IPeykdVUW/aZ+jsB7jmdONl/ZmkJvKxCtJXKwv
         pmK4Bei2IJw5oBTKrd950eYK8bpOkocDq5N4RbOwtDJPpNPQUNZM4HPwtUTPWWIf4Ufd
         dwqDuyT68h4P2ADEkb7P+clmBC/0F16mcfiDNrZzkMCpVTI5EFrRKWNH1QBlzQa6OyYi
         fa80CV+TMelQukb4z/BJfF/sIqCgPPGFHz8cbGlMPIDjn08liA2ecdFvTevklUBISf8x
         ZHYTL2U0ascm+XG+vtlpELBgJZNmi3ghaXaXl0LCodoD6FnE2hf46WGYbNHrvQJm1uDd
         KxXg==
X-Gm-Message-State: AOAM530dLb+2hZBKtiul7XPWewLhJrWLHUojayNrJUMbS8yOUrHXE4bd
        zYonHBSl22tsKtWaYuVrJbc=
X-Google-Smtp-Source: ABdhPJz6x7E7rMj/rklw9RICLxkRDsShVMv05ry/VIWiG39qkYPi6XHc0xmgoCevif80B9SyBk8Vpw==
X-Received: by 2002:a05:620a:11ad:: with SMTP id c13mr5210841qkk.541.1644537748044;
        Thu, 10 Feb 2022 16:02:28 -0800 (PST)
Received: from localhost ([12.28.44.171])
        by smtp.gmail.com with ESMTPSA id r2sm12006233qta.15.2022.02.10.16.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 16:02:27 -0800 (PST)
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
        linux-kernel@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 32/49] mlx4: replace bitmap_weight with bitmap_weight_{eq,gt,ge,lt,le}
Date:   Thu, 10 Feb 2022 14:49:16 -0800
Message-Id: <20220210224933.379149-33-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210224933.379149-1-yury.norov@gmail.com>
References: <20220210224933.379149-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mellanox code uses bitmap_weight() to compare the weight of bitmap with
a given number. We can do it more efficiently with bitmap_weight_{eq, ...}
because conditional bitmap_weight may stop traversing the bitmap earlier,
as soon as condition is (or can't be) met.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c  | 10 +++-------
 drivers/net/ethernet/mellanox/mlx4/eq.c   |  4 ++--
 drivers/net/ethernet/mellanox/mlx4/fw.c   |  4 ++--
 drivers/net/ethernet/mellanox/mlx4/main.c |  2 +-
 4 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index c56d2194cbfc..5bca0c68f00a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -2792,9 +2792,8 @@ int mlx4_slave_convert_port(struct mlx4_dev *dev, int slave, int port)
 {
 	unsigned n;
 	struct mlx4_active_ports actv_ports = mlx4_get_active_ports(dev, slave);
-	unsigned m = bitmap_weight(actv_ports.ports, dev->caps.num_ports);
 
-	if (port <= 0 || port > m)
+	if (port <= 0 || bitmap_weight_lt(actv_ports.ports, dev->caps.num_ports, port))
 		return -EINVAL;
 
 	n = find_first_bit(actv_ports.ports, dev->caps.num_ports);
@@ -3404,10 +3403,6 @@ int mlx4_vf_set_enable_smi_admin(struct mlx4_dev *dev, int slave, int port,
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_active_ports actv_ports = mlx4_get_active_ports(
 			&priv->dev, slave);
-	int min_port = find_first_bit(actv_ports.ports,
-				      priv->dev.caps.num_ports) + 1;
-	int max_port = min_port - 1 +
-		bitmap_weight(actv_ports.ports, priv->dev.caps.num_ports);
 
 	if (slave == mlx4_master_func_num(dev))
 		return 0;
@@ -3417,7 +3412,8 @@ int mlx4_vf_set_enable_smi_admin(struct mlx4_dev *dev, int slave, int port,
 	    enabled < 0 || enabled > 1)
 		return -EINVAL;
 
-	if (min_port == max_port && dev->caps.num_ports > 1) {
+	if (dev->caps.num_ports > 1 &&
+	    bitmap_weight_eq(actv_ports.ports, priv->dev.caps.num_ports, 1)) {
 		mlx4_info(dev, "SMI access disallowed for single ported VFs\n");
 		return -EPROTONOSUPPORT;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index 414e390e6b48..0c09432ff389 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -1435,8 +1435,8 @@ int mlx4_is_eq_shared(struct mlx4_dev *dev, int vector)
 	if (vector <= 0 || (vector >= dev->caps.num_comp_vectors + 1))
 		return -EINVAL;
 
-	return !!(bitmap_weight(priv->eq_table.eq[vector].actv_ports.ports,
-				dev->caps.num_ports) > 1);
+	return bitmap_weight_gt(priv->eq_table.eq[vector].actv_ports.ports,
+				dev->caps.num_ports, 1);
 }
 EXPORT_SYMBOL(mlx4_is_eq_shared);
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 42c96c9d7fb1..855aae326ccb 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -1300,8 +1300,8 @@ int mlx4_QUERY_DEV_CAP_wrapper(struct mlx4_dev *dev, int slave,
 	actv_ports = mlx4_get_active_ports(dev, slave);
 	first_port = find_first_bit(actv_ports.ports, dev->caps.num_ports);
 	for (slave_port = 0, real_port = first_port;
-	     real_port < first_port +
-	     bitmap_weight(actv_ports.ports, dev->caps.num_ports);
+	     bitmap_weight_gt(actv_ports.ports, dev->caps.num_ports,
+			      real_port - first_port);
 	     ++real_port, ++slave_port) {
 		if (flags & (MLX4_DEV_CAP_FLAG_WOL_PORT1 << real_port))
 			flags |= MLX4_DEV_CAP_FLAG_WOL_PORT1 << slave_port;
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index b187c210d4d6..cfbaa7ac712f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1383,7 +1383,7 @@ static int mlx4_mf_bond(struct mlx4_dev *dev)
 		   dev->persist->num_vfs + 1);
 
 	/* only single port vfs are allowed */
-	if (bitmap_weight(slaves_port_1_2, dev->persist->num_vfs + 1) > 1) {
+	if (bitmap_weight_gt(slaves_port_1_2, dev->persist->num_vfs + 1, 1)) {
 		mlx4_warn(dev, "HA mode unsupported for dual ported VFs\n");
 		return -EINVAL;
 	}
-- 
2.32.0

