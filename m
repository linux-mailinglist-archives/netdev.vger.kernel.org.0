Return-Path: <netdev+bounces-12231-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D84F7736D9B
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:43:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2FA81C20C37
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2093016407;
	Tue, 20 Jun 2023 13:43:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BE32F5B
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:43:28 +0000 (UTC)
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A2C1709
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:43:16 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-311394406d0so2271887f8f.2
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687268594; x=1689860594;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FXEzWvVaTpDBI6VqaBUCaMKU3ESDTmt5tb+GXKM/9lU=;
        b=jHRzec0TCzelOEc95MtKjmVHQWlHzHZi8Pp8968XHSTBMdl5I7PiaqWG4hV/2tnSpK
         g7y8+YWM2qNJT6DCoP7+ztfFyG+nPCQrAvRZrO0KqffM5/4lHf03ao/aH6GZ9rqfh4nU
         TeFKMZzQ5Z9OR1xdQeEphnjZziYE1tz4HhjDJxmI1ikcB9THDn8XCwbTfProloBFFTC2
         bxKCJFpXs4Ng8uPP/+BhjpdNuR2QqS6ee0Rvs9eZUmckFF1Hooh77PWYFpgylNIbcwdc
         OxMnPXOqoZCFZBOP/t5eeRa43gDA2Qoet08VWSQu2/y1AEpBo03LWGewnKr0Zk7RHYbs
         w74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687268594; x=1689860594;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FXEzWvVaTpDBI6VqaBUCaMKU3ESDTmt5tb+GXKM/9lU=;
        b=KZQf1GWGZxZQ7DKFC8RMRGmwbC3swHWrMTss1/9/ozafT7ShUUl9PJLSkQievycC31
         z5h3HheSqzB4PEMLmhW6sjx8riGAbUxBQh8z16bOZrP/E1uFH1OGUWmAmHdRLapgcmuX
         yOq7BMD3zE7I/1k5ywrJG2FR61YhkAC08bu08ZlFBxqjTC5lukbn3COZDUBDn2V1QNzU
         ZaaJ3kytZj6qRktCYNre83X3Us2KgnivqD/404kMO/HwBczTrTG9/FCSUav6RL392kJo
         X4i64alqQ9uTi648gf3n/Jt7gkNIMDKEPLuFOCppk8P1bQE4ia6L2txfJpIMZ9buv62G
         5fLg==
X-Gm-Message-State: AC+VfDyKFIeAQwHIP2FbByZsfCl0rS1JgS5271nAW+EHpGJEZwNzVrcH
	/Kwv7VFbpVy2xWyXlgjt2ou0RA==
X-Google-Smtp-Source: ACHHUZ6upvLJQp+I/vEd6WG/WBwHY2kcxULaHdzrZEwgyc1/ebxdsp11EH/PEpQ+MbvkNOiJ/2VQ+Q==
X-Received: by 2002:a5d:45c6:0:b0:30f:c653:b819 with SMTP id b6-20020a5d45c6000000b0030fc653b819mr8616094wrs.14.1687268594450;
        Tue, 20 Jun 2023 06:43:14 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id c9-20020a056000104900b0030631a599a0sm2023107wrx.24.2023.06.20.06.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 06:43:12 -0700 (PDT)
Date: Tue, 20 Jun 2023 16:43:07 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Moshe Shemesh <moshe@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net/mlx5: Fix error code in
 mlx5_is_reset_now_capable()
Message-ID: <53f95829-1a94-4565-aa75-f0335cd64b8a@moroto.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The mlx5_is_reset_now_capable() function returns bool, not negative
error codes.  So if fast teardown is not supported it should return
false instead of -EOPNOTSUPP.

Fixes: 92501fa6e421 ("net/mlx5: Ack on sync_reset_request only if PF can do reset_now")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 7af2b14ab5d8..fb7874da3caa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -327,7 +327,7 @@ static bool mlx5_is_reset_now_capable(struct mlx5_core_dev *dev)
 
 	if (!MLX5_CAP_GEN(dev, fast_teardown)) {
 		mlx5_core_warn(dev, "fast teardown is not supported by firmware\n");
-		return -EOPNOTSUPP;
+		return false;
 	}
 
 	err = pci_read_config_word(dev->pdev, PCI_DEVICE_ID, &dev_id);
-- 
2.39.2


