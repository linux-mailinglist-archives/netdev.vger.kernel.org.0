Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9426D1806
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 09:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbjCaHET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 03:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjCaHEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 03:04:09 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6A6DBC0;
        Fri, 31 Mar 2023 00:04:04 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h17so21344740wrt.8;
        Fri, 31 Mar 2023 00:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680246242;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q76zbQtochwncIhZQ7riDl3gHgHlJYYkEWfwyJ/lNpY=;
        b=qKNvf2gF/MwZtKDkInE84Zi4oN4T3JqsKXqmTGpzkCucunNaUfwyUCHpSL2cAZoRX6
         OtY4Q5KPpWKWOhBPIGoTq8xDYVm0nEPh7hcO26GpLxwJ3af/vGAK/tBkM7ka0jCpRYSH
         u8KoEtAbnY5BE+jADqIiQiFzINGe3znwoPqx9bYMzokq/Cx9ct8FO47Ap94YLaT3zFdz
         dIeUsOdWc6GhhU5n32Gf/E6MUL7HGbG3p6d/3AnFvztYiyoBZFFFnLvLHirzOJnPngd4
         CGp4BD5074ugTr+OoXZUxl3FYKbmaA8km5QB11ZC/7Fg5OXx6PV6qSCVWvTw0fOAnSxe
         nK/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680246242;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q76zbQtochwncIhZQ7riDl3gHgHlJYYkEWfwyJ/lNpY=;
        b=icf0gQQ/c6cO3qUlHclDaiTBsqnVgJaBthYms6YpBfuhkybw6Q3nTwPPRYa7f8wtVo
         celhfdQYfYd9J91av7iBSIO/AtkVdFuptwfzF4ymTDtTmO+RXH1a0arDIHWndGfZwaQk
         WAzuICF22fgIX0gkSzwaDJzA1qdnp0u1yTOZ7Z7xhazPz43HAUns0V1gw//Z85h0Vkjv
         YX0CPlohL0olln2LS4Av86QFwjLhIHv8xDektYwgVrqRr+cNVkWQN9jjmSUMvU7hWapy
         4k+iKqooqdewrGRYiceRz71OJKOPS6rwHwY5PyC5zsK/9cwoWP0iKgYNDAZaZpJo8/Ou
         g86A==
X-Gm-Message-State: AAQBX9feNJKam03SOB8AjuLw8ksSPO+z2bMabsNB9w/XW4reWZQAjpC3
        i0l+h71Tv7joayLwHW9X2DY=
X-Google-Smtp-Source: AKy350bdI8Q2NH/F7m6vHYXtic18Ow44dO9xjGWXAxzu6ncylxQ3s4eH+bA57APmJrDgPAl+G6TpxQ==
X-Received: by 2002:a5d:464d:0:b0:2e5:5439:6b4c with SMTP id j13-20020a5d464d000000b002e554396b4cmr1985571wrs.27.1680246242351;
        Fri, 31 Mar 2023 00:04:02 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id r16-20020a05600c35d000b003ee9f396dcesm8746643wmq.30.2023.03.31.00.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 00:04:01 -0700 (PDT)
Date:   Fri, 31 Mar 2023 10:03:47 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net/mlx5: Fix check for allocation failure in
 comp_irqs_request_pci()
Message-ID: <6652003b-e89c-4011-9e7d-a730a50bcfce@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function accidentally dereferences "cpus" instead of returning
directly.

Fixes: b48a0f72bc3e ("net/mlx5: Refactor completion irq request/release code")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index eb41f0abf798..13491246c9e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -824,7 +824,7 @@ static int comp_irqs_request_pci(struct mlx5_core_dev *dev)
 	ncomp_eqs = table->num_comp_eqs;
 	cpus = kcalloc(ncomp_eqs, sizeof(*cpus), GFP_KERNEL);
 	if (!cpus)
-		ret = -ENOMEM;
+		return -ENOMEM;
 
 	i = 0;
 	rcu_read_lock();
-- 
2.39.1

