Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABB13A758C
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhFOEED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhFOEDh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 00:03:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F13F8613CC;
        Tue, 15 Jun 2021 04:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623729694;
        bh=IU6PuN01K7aoGfDTMhdQ2N5edD6IwpPaCr/2J8e0KQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0dSzwx5MmdvjhnS6iozwbx4oN6iT0ycNxsgTTI51cRVjh/INvNahUn50b12EmuWl
         PYxHEkb6oDTsMor9vAmLUChXx0bKJI1I4BR1VtU3CWaFlY2GrshcKWkuW/RtgzQk0G
         tVk1XOWoWUuRs+5UQlrFsR6XHCMkyvhugC/eIiUek0FKFPpiGhaot50YJzW8+R54Y7
         XKb+3qJPfrUvUMmbaDUjCEIkhY26adc+Y4/rxiyzOQxYS4Spjv+nlrrABQhYHfKk6h
         AOnqIHjO2Kz5TjyjetLMxtZ+ffPUJLq9iejWt4PfikFHSj4RMUGkDvLrGHCvIufzuo
         C8v0PFt+95aRw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5: Enlarge interrupt field in CREATE_EQ
Date:   Mon, 14 Jun 2021 21:01:21 -0700
Message-Id: <20210615040123.287101-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615040123.287101-1-saeed@kernel.org>
References: <20210615040123.287101-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

FW is now supporting more than 256 MSI-X per PF (up to 2K).
Hence, enlarge interrupt field in CREATE_EQ to make use of the new
MSI-X's.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 057db0eaf195..2d1ed78289ff 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3806,8 +3806,8 @@ struct mlx5_ifc_eqc_bits {
 
 	u8         reserved_at_80[0x20];
 
-	u8         reserved_at_a0[0x18];
-	u8         intr[0x8];
+	u8         reserved_at_a0[0x14];
+	u8         intr[0xc];
 
 	u8         reserved_at_c0[0x3];
 	u8         log_page_size[0x5];
-- 
2.31.1

