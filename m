Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D92A340461
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 12:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhCRLQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 07:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230175AbhCRLP6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 07:15:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22CEB64F04;
        Thu, 18 Mar 2021 11:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616066157;
        bh=LG9mKIARE6oe3ah4WCGfnisXbvDpdPw5pRFrLoXoGTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ler0GwQXJQrCGZ0dFCkLFXkMSjjR7uL9Es8rcyVcOWlCaxxLzcS2H0POkPIE4+wDz
         7jA7PlVqgAe+MJmkMt5lMqvU3pQiwQJf4hmwsSP+qphRoY3jVigbMtgf5mMGEGlBYs
         oTqQDnC0q91iOJqSqktL6zoJb0jUslFwjuI88SYV4vxPDrhlPVvot3l92l1zbMNqZB
         VdVoFshLFMEb6s8a0WvCuk/8GhPVfPZfs3deNYriUvzq1Cd2DOs4flqDKjXyBoWEMz
         /USBlpJ6AIxR8SsyctayoRekb4HMGVvqBqGbBdbFksF7OXxtBo9VpcvRmSL/sSyolM
         r8jHz6fb9m51Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Maor Gottlieb <maorg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next 2/7] RDMA/uverbs: Make UVERBS_OBJECT_METHODS to consider line number
Date:   Thu, 18 Mar 2021 13:15:43 +0200
Message-Id: <20210318111548.674749-3-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318111548.674749-1-leon@kernel.org>
References: <20210318111548.674749-1-leon@kernel.org>
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
 include/rdma/uverbs_named_ioctl.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/rdma/uverbs_named_ioctl.h b/include/rdma/uverbs_named_ioctl.h
index f04f5126f61e..f247e5d57bb1 100644
--- a/include/rdma/uverbs_named_ioctl.h
+++ b/include/rdma/uverbs_named_ioctl.h
@@ -20,7 +20,8 @@

 /* These are static so they do not need to be qualified */
 #define UVERBS_METHOD_ATTRS(method_id) _method_attrs_##method_id
-#define UVERBS_OBJECT_METHODS(object_id) _object_methods_##object_id
+#define UVERBS_OBJECT_METHODS(object_id)                                       \
+	_UVERBS_NAME(_object_methods_##object_id, __LINE__)

 #define DECLARE_UVERBS_NAMED_METHOD(_method_id, ...)                           \
 	static const struct uverbs_attr_def *const UVERBS_METHOD_ATTRS(        \
--
2.30.2

