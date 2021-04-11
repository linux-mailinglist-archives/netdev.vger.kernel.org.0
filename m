Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9D335B430
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 14:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235482AbhDKMaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 08:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235517AbhDKMaA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 08:30:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2998A610C8;
        Sun, 11 Apr 2021 12:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618144183;
        bh=llpiJ23BaDMVc5YoUZRod9Gtb8+AxvI90lK7C/0LfFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsIwq/R/rkIG0eCPR0JmZ52L820sCnKMvtHLioyav9UiMxL4YMzvit3ssabyAAV+P
         lG6H2I5V6Rp/6XwBpKNjkygzi9s0sd/PwMF8oxZpWTzflZZYKrTjKpRllyfRzVfsZL
         xgU2S6cdHT9OXThDrZ5kY3WYmrbVvTV58fg08Bh4nUEZHp+bEncZgAKXFTd+WslN6E
         +wi75jjxvvfAvScvOshgYUpW4/hJk385C5QimcbCf1H0ISl/+pPlZmkmgDPufDecJx
         ywHwMUR3dTDx89wMtQlbr6r37YI2n3PGmZWvGC6vu2nsr10MZPRAJOzGZIb2Uejp5E
         n7E0Egcwh9onQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Maor Gottlieb <maorg@nvidia.com>, linux-api@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next v1 2/7] RDMA/uverbs: Make UVERBS_OBJECT_METHODS to consider line number
Date:   Sun, 11 Apr 2021 15:29:19 +0300
Message-Id: <20210411122924.60230-3-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210411122924.60230-1-leon@kernel.org>
References: <20210411122924.60230-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

In order to support multiple methods declaration in the same file we
should use the line number as part of the name.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/rdma/uverbs_named_ioctl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/rdma/uverbs_named_ioctl.h b/include/rdma/uverbs_named_ioctl.h
index f04f5126f61e..ee7873f872c3 100644
--- a/include/rdma/uverbs_named_ioctl.h
+++ b/include/rdma/uverbs_named_ioctl.h
@@ -20,7 +20,7 @@
 
 /* These are static so they do not need to be qualified */
 #define UVERBS_METHOD_ATTRS(method_id) _method_attrs_##method_id
-#define UVERBS_OBJECT_METHODS(object_id) _object_methods_##object_id
+#define UVERBS_OBJECT_METHODS(object_id) _UVERBS_NAME(_object_methods_##object_id, __LINE__)
 
 #define DECLARE_UVERBS_NAMED_METHOD(_method_id, ...)                           \
 	static const struct uverbs_attr_def *const UVERBS_METHOD_ATTRS(        \
-- 
2.30.2

