Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3017EF4AB7
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387996AbfKHLjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:39:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:52616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387934AbfKHLjp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:39:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05762222C2;
        Fri,  8 Nov 2019 11:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213184;
        bh=U9HD4B/xPEJdt+6Ll1JEDtratWwqcI5JSfiG63CzEsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPc8h6ZBUE7o7TG5kyp1XXjDBgCFO0hPAI40UbAtD60dqmrVc/cDwLLKH+1jz+rHL
         m9xpZmxD3LrEa1WEAeitNmL6DSdkqFy+wegYhVgh3mLrrI7zXEvFdAPSU9D8tXQGUK
         ysJJrLPQSl4+XkmvTApJTepwuX4joZH/orswApbA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moni Shoua <monis@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 075/205] net/mlx5: Fix atomic_mode enum values
Date:   Fri,  8 Nov 2019 06:35:42 -0500
Message-Id: <20191108113752.12502-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

[ Upstream commit aa7e80b220f3a543eefbe4b7e2c5d2b73e2e2ef7 ]

The field atomic_mode is 4 bits wide and therefore can hold values
from 0x0 to 0xf. Remove the unnecessary 20 bit shift that made the values
be incorrect. While that, remove unused enum values.

Fixes: 57cda166bbe0 ("net/mlx5: Add DCT command interface")
Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/driver.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index e8b92dee5a726..ae64fced188d1 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -163,10 +163,7 @@ enum mlx5_dcbx_oper_mode {
 };
 
 enum mlx5_dct_atomic_mode {
-	MLX5_ATOMIC_MODE_DCT_OFF        = 20,
-	MLX5_ATOMIC_MODE_DCT_NONE       = 0 << MLX5_ATOMIC_MODE_DCT_OFF,
-	MLX5_ATOMIC_MODE_DCT_IB_COMP    = 1 << MLX5_ATOMIC_MODE_DCT_OFF,
-	MLX5_ATOMIC_MODE_DCT_CX         = 2 << MLX5_ATOMIC_MODE_DCT_OFF,
+	MLX5_ATOMIC_MODE_DCT_CX         = 2,
 };
 
 enum {
-- 
2.20.1

