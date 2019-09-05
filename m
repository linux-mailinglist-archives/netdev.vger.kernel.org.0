Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15E17A981F
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 03:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730589AbfIEBrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 21:47:42 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44055 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfIEBrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 21:47:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id 30so707770wrk.11;
        Wed, 04 Sep 2019 18:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3fEmvX2c1XkJUmAyhbV7F+bK25TJga6/ywCtOVMKmMA=;
        b=esUmt9b0sGHozIEiOVEOlY0vld6q09PgYLIFYPDi07C0kEEjHmhVlIZ7Dg5Dgo+Gfg
         iuxMmprgwv08CL/Mgu0PWdBS2U109aUyVsiqxPDlpxgu9HiFf+onaUnOxitDidVzeIfz
         ZXpz9L6eRM3P00LwQNam5JkcS4qH3wDflAvWdXO+iMSttVYe7k0YCj9PctxvoWEYI1sg
         jU59sChuxCKfBsdM3boEKEtcUyOUk+x+DEZKlG7qGZZlMUPWFzQi5MA7YAi2t1y2fQxr
         LHv7eSLWuzYfsbKuwJJ1ZVO4k8npFVtnSXHZk5X/EItp/NPMriz6MPN1sN+fPJE1tFcs
         ot9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3fEmvX2c1XkJUmAyhbV7F+bK25TJga6/ywCtOVMKmMA=;
        b=ICzDP7z3KSkFa9pwb/REFcYJbEgTE6FK+3E3jh6E83Fe/ZXmrq/NSGFxjOTDIxNcwh
         uFuyWDeCMGEryPeG2T2Rs4pgA326us/Oh4w/tvavVOlpzMZXyjXQJTiwUiYdNKwUQDXE
         afddDZH5VHaO/035LgpA//sKnUPn6YK6zznQAQ4HvLtvH0wO8HNHzWdmkhIq4s0yj6PT
         lkilx9A0OvK97v+CBWm9cz5KH3cFfliY3ZvEFJKH8v4Ff2uVrqMXmn0KuMq3zca7svTG
         SUPpFOJpEYNkFnP+7MBMUKUeNfw7LWdyO1wW3TwmbVw+Rnue+YSafLT5ds3JohEDP2fL
         jFkQ==
X-Gm-Message-State: APjAAAUoSAWqJ5X3kPnpvnKW3CukkkPcNwDHfss7mf6Af7vDiYML5Cmj
        1DdzXkjMTLW+/z9/NwEa/Zg=
X-Google-Smtp-Source: APXvYqxssPj/S9IdzdM4cz0nCvWyZIltFhf2meIfABTwT42pnpG3zBVCnvSQTXqK9lglKEC+BBqOHA==
X-Received: by 2002:adf:de8a:: with SMTP id w10mr377490wrl.276.1567648060012;
        Wed, 04 Sep 2019 18:47:40 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id v7sm507565wru.87.2019.09.04.18.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 18:47:39 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] net/mlx5: Fix rt's type in dr_action_create_reformat_action
Date:   Wed,  4 Sep 2019 18:47:33 -0700
Message-Id: <20190905014733.17564-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang warns:

drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c:1080:9:
warning: implicit conversion from enumeration type 'enum
mlx5_reformat_ctx_type' to different enumeration type 'enum
mlx5dr_action_type' [-Wenum-conversion]
                        rt = MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL;
                           ~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c:1082:9:
warning: implicit conversion from enumeration type 'enum
mlx5_reformat_ctx_type' to different enumeration type 'enum
mlx5dr_action_type' [-Wenum-conversion]
                        rt = MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL;
                           ~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c:1084:51:
warning: implicit conversion from enumeration type 'enum
mlx5dr_action_type' to different enumeration type 'enum
mlx5_reformat_ctx_type' [-Wenum-conversion]
                ret = mlx5dr_cmd_create_reformat_ctx(dmn->mdev, rt, data_sz, data,
                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            ^~
3 warnings generated.

Use the right type for rt, which is mlx5_reformat_ctx_type so there are
no warnings about mismatched types.

Fixes: 9db810ed2d37 ("net/mlx5: DR, Expose steering action functionality")
Link: https://github.com/ClangBuiltLinux/linux/issues/652
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index a02f87f85c17..7d81a7735de5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1074,7 +1074,7 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 	case DR_ACTION_TYP_L2_TO_TNL_L2:
 	case DR_ACTION_TYP_L2_TO_TNL_L3:
 	{
-		enum mlx5dr_action_type rt;
+		enum mlx5_reformat_ctx_type rt;
 
 		if (action->action_type == DR_ACTION_TYP_L2_TO_TNL_L2)
 			rt = MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL;
-- 
2.23.0

