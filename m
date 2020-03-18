Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6591189791
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgCRJF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:05:56 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:19515 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbgCRJFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:05:55 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 0684C41E81;
        Wed, 18 Mar 2020 17:05:44 +0800 (CST)
From:   wenxu@ucloud.cn
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net/mlx5e: remove duplicated check chain_index in mlx5e_rep_setup_ft_cb
Date:   Wed, 18 Mar 2020 17:05:43 +0800
Message-Id: <1584522343-5905-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ0NLS0tKS01DSkpOSVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NDo6MRw5Ezg5HhwNKjQtFUwS
        H0JPCjRVSlVKTkNPTklJSE9PSk5JVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpPTkk3Bg++
X-HM-Tid: 0a70ece436622086kuqy0684c41e81
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The function mlx5e_rep_setup_ft_cb check chain_index is zero twice.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index a88c70b..fc0b0ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1295,8 +1295,7 @@ static int mlx5e_rep_setup_ft_cb(enum tc_setup_type type, void *type_data,
 	case TC_SETUP_CLSFLOWER:
 		memcpy(&tmp, f, sizeof(*f));
 
-		if (!mlx5_esw_chains_prios_supported(esw) ||
-		    tmp.common.chain_index)
+		if (!mlx5_esw_chains_prios_supported(esw))
 			return -EOPNOTSUPP;
 
 		/* Re-use tc offload path by moving the ft flow to the
-- 
1.8.3.1

