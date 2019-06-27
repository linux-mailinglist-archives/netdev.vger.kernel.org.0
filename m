Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED89F588E4
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfF0Rmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:42:36 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44898 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfF0Rmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:42:36 -0400
Received: by mail-pf1-f195.google.com with SMTP id t16so1575797pfe.11;
        Thu, 27 Jun 2019 10:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JbWk5FOEtfFARu6jGi76KfhRnQUsmK/80oLXsYAvadE=;
        b=IyAOo3tM+BIOvpNkzWoKpNQir07XIMk6PecvV/zsNOEoyU14MooOYJPMtrYWwBZBBM
         yXB7bPm4IG0+Fu9NEZs+NDhEHVrhNNVCHnswR3GQyuBLUi0k+3NZtPOZAq1H5WJMNNoB
         5vOcLLH/5uJpVIDeMQKX8YB+04teV/NNItv1SgT3SvE819fKMhM5y6KQFv/Hcryr+4gv
         jweF/U5erIl/Y+DaIDBDgnEn4KDPT4oIxXYtlTXDEN7uzvxy0YXey/7hCnyhYERZu9Mk
         u+zQCVk5mxlXRe7/z5gJs6Vk3cr4lCVaRPgecdZmlwSmDmIX6CEl/GyPIuXvkU84Yep6
         JBFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JbWk5FOEtfFARu6jGi76KfhRnQUsmK/80oLXsYAvadE=;
        b=XSb5ZSXu0lp8bZwWoBeuRd50Td+LST0nCl61Bz2byX0QUC7sF/zLoFvrGazl19cMEQ
         urWxP8CsErc90d7uNjHyBU8YfHEY740WrOhl01rUuQIHJ26Nj5f7EMdhUqFs7/Q3uC/u
         SFVa8x4Uk4hoPWLX2lWQbWOQW22h27Lxt2sqlRlswG/e3X8xSPl3rqO9viqbSQ85SY87
         1Xlx0E+kVoGiVTm5O0Afm2q/LvV9jeOpV3QU33IyhzijAoW4QBvzapveOiY1tS7blEdN
         pYjvBOAwn5XoT74seNQE2cIkKPGoj5WBGlKPG6KFLdYz4bhHnRcMxVsMHakdBEhzgBOu
         39OA==
X-Gm-Message-State: APjAAAXJtfDOMtaQcPgSZb7g+f5CMSzoz7m+1j7BPBeSq0ROz+sfZyNo
        2kLbQqBZUDGPJU1VQX2BReHU84Y3mMGnag==
X-Google-Smtp-Source: APXvYqyIIZEYOJViQfY6zMcYkym9Ys5vOWz6YgmmC/WbfAJS9116enKFi1n2r3fmlqxe2kK1Mg90zQ==
X-Received: by 2002:a17:90a:376f:: with SMTP id u102mr7520173pjb.5.1561657355500;
        Thu, 27 Jun 2019 10:42:35 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id k6sm3489864pfi.12.2019.06.27.10.42.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:42:35 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 87/87] ethernet: mlx4: remove memset after dma_alloc_coherent
Date:   Fri, 28 Jun 2019 01:42:27 +0800
Message-Id: <20190627174227.4726-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/eq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index a5be27772b8e..c790a5fcea73 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -1013,8 +1013,6 @@ static int mlx4_create_eq(struct mlx4_dev *dev, int nent,
 
 		dma_list[i] = t;
 		eq->page_list[i].map = t;
-
-		memset(eq->page_list[i].buf, 0, PAGE_SIZE);
 	}
 
 	eq->eqn = mlx4_bitmap_alloc(&priv->eq_table.bitmap);
-- 
2.11.0

