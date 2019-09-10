Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C05AE6E5
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 11:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731442AbfIJJ1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 05:27:39 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40429 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfIJJ1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 05:27:39 -0400
Received: by mail-pl1-f195.google.com with SMTP id y10so8283209pll.7;
        Tue, 10 Sep 2019 02:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=3I/RwDNyR0c5I8Mzz7CZb34k+5TRodcyDN5J9yOyCXE=;
        b=SiDG9nvjNzi0fPg0DDKoqEXUP2gPz23dm1mJWP5Mz/FIdMA1Xpwo+P/ZbwXureAaM1
         U0QhNAcKvliifokLQsrURc30rUGlQ6TjGuGc5cmgd0j0+mRGEmRzXE5O1A0SV5BhnzBU
         wvPpQyshUktQHKwZUlTh5NLAVh9mVapbBVdr9rr2KZC2BPs4amn+vY16W6q2996pttxQ
         4LMMNNyjfL0CmD708OZX9aZYtwfQvm63inrXpLCqfDf/xEHaudP3C0164n4lAt8aoe5k
         mksh9fDqXIlBcGzT2gcHM/p/0sIq6+Nvv3V/myjwjDSkX7at5CcBXk28hJFBvf3JIyEb
         bw0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=3I/RwDNyR0c5I8Mzz7CZb34k+5TRodcyDN5J9yOyCXE=;
        b=r2roY8ljo/X9T8x6YtdMWyWXRKd8icjdrjigoWj+7/X3s+qo20J0etPBhTc/jTCq/o
         cosQe85lZJYw8y4sRUYp+awqmU/uYBR/FT+fYNUl6deHVLsNAVpuxgFc5pVUMgfulClA
         tOLIcI+sAvNLwtzz9ZfZ4cUNRww/QNd9Z889Yeb5h17CY84PdB+lthH37NzeBg32zqcS
         WNL7z+EGIoKyBAb+XxSkYzHESQkImcKoqlZJCZ/0lJlu74ku4usx+F1IdV7E89kXJFJy
         LJ33bWiuFjCHL97tQaXzpTK5wNKXwrssLX0GMlQ2jfYap7j+wTcwbchnsTDOUUtt3oI2
         N//Q==
X-Gm-Message-State: APjAAAWqOIQdKbkOcJ3PDrNCswh9HJ5rpOlZ/Q94LFjNiq1rE94wxzXl
        /oDapYOqd87PT4QivHhxNys=
X-Google-Smtp-Source: APXvYqwzF/G7K8Q482wfDKwY0BEHlU4ukFMULym2qfUCvsJjMbmPGafbQntqaDb8HAKjNh3waQTEsw==
X-Received: by 2002:a17:902:76c2:: with SMTP id j2mr30004606plt.305.1568107657101;
        Tue, 10 Sep 2019 02:27:37 -0700 (PDT)
Received: from LGEARND20B15 ([27.122.242.75])
        by smtp.gmail.com with ESMTPSA id y15sm21142300pfp.111.2019.09.10.02.27.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 02:27:36 -0700 (PDT)
Date:   Tue, 10 Sep 2019 18:27:31 +0900
From:   Austin Kim <austindh.kim@gmail.com>
To:     saeedm@mellanox.com, leon@kernel.org
Cc:     davem@davemloft.net, valex@mellanox.com, erezsh@mellanox.com,
        markb@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        austindh.kim@gmail.com
Subject: [PATCH] net/mlx5: Declare 'rt' as corresponding enum type
Message-ID: <20190910092731.GA173476@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building kernel with clang, we can observe below warning message:

drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c:1080:9:
warning: implicit conversion from enumeration type 'enum mlx5_reformat_ctx_type'
to different enumeration type 'enum mlx5dr_action_type' [-   Wenum-conversion]
	rt = MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL;
       			  ~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c:1082:9:
warning: implicit conversion from enumeration type 'enum mlx5_reformat_ctx_type'
to different enumeration type 'enum mlx5dr_action_type' [-   Wenum-conversion]
	rt = MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL;
        ~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c:1084:51:
warning: implicit conversion from enumeration type 'enum mlx5dr_action_type'
to different enumeration type 'enum mlx5_reformat_ctx_type' [-  Wenum-conversion]
	ret = mlx5dr_cmd_create_reformat_ctx(dmn->mdev, rt, data_sz, data,
         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            ^~

Declare 'rt' as corresponding enum mlx5_reformat_ctx_type type.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index a02f87f..7d81a77 100644
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
2.6.2

