Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B7B588F7
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfF0Rnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:43:31 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40864 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfF0Rna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:43:30 -0400
Received: by mail-pl1-f196.google.com with SMTP id a93so1684553pla.7;
        Thu, 27 Jun 2019 10:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Omg2r+qJLtgq2Odatu+vxMoOAmxY3CNldRSlBn3BzJY=;
        b=oUZvhBi+q6BwldFmrCI54T7dPoXEbxghwxxzpvavrUkRyVtj+XELXymH1Gt6dl1ViN
         SNPT/gpluLW5q4VlChwqJJeVvRXu2dKAtlbWEUN5yOP/PqtBHkAS+Jarw/GLxFaztMbR
         CYW3ICYEmqxkQNzq0N2GQlPlWVlLvoGuHbglVzyHBUX5oupicR1OwrkAu+ymen7ZsDPE
         XrkiXys0509jPgEesExshUrWq2U4Jda/LObTVKmJr/v/7yE/4xLTO7OItsQnQwT81Pgk
         cJxD6Fu78I/UcZcoxHkd9tShjFeFtGogT/fMVufKE6ueTLwZIv67k2bHXIh6ZSC7Ifz3
         yXwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Omg2r+qJLtgq2Odatu+vxMoOAmxY3CNldRSlBn3BzJY=;
        b=m3hzMf90kKeu8aquhoNos7YD63gSLETQglriNug4qYED/Ad+id2kWuVOQZRjDGQ736
         gtZUNk0uWYSoYA7DROKWlLRGWtz1YcDSOEkdgdaHUv1A//DM+x2HGvnbVFC+5TOfa9XY
         nq6Fu3I1rTgFo2cU84gCtCXRQdmG5oaUyzJjZ7wqy91wmaDL837AEgutewe/NGJDASIX
         5okE2T3V4ZN0iPRzgYf455pxZjNht6DfAlbc4PpbbP++uKGtWUtxUA/FC02RsOoEwD7I
         X3JuMiIWn6ui2nhxHQn9TStHV/qtzfKEIByc4tsW1WD+ZXsV3qHjiKx0RKivbSWvQkRW
         0CQA==
X-Gm-Message-State: APjAAAUyD95tuKFvjM0d9/AUyCW6FcubHLfzBXgr4cwi0PDV0zXeIuBA
        qo+4VLzNLxJH9DHFqq5yL28=
X-Google-Smtp-Source: APXvYqzhiTWTM3GiO4gixElLqF05+baJ+GEhtlIAbDBQFJmrYzg7Ok5W/2oU1piuA9dI9B6k/Rb7Rg==
X-Received: by 2002:a17:902:7087:: with SMTP id z7mr5982555plk.184.1561657409580;
        Thu, 27 Jun 2019 10:43:29 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id f10sm2636285pgo.14.2019.06.27.10.43.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:43:29 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 84/87] ethernet: mellanox: mlxsw: remove memset after pci_alloc_persistent
Date:   Fri, 28 Jun 2019 01:43:19 +0800
Message-Id: <20190627174319.5095-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pci_alloc_persistent calls dma_alloc_coherent directly.
In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index b40455f8293d..be310ac0883a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -835,7 +835,6 @@ static int mlxsw_pci_queue_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
 					     &mem_item->mapaddr);
 	if (!mem_item->buf)
 		return -ENOMEM;
-	memset(mem_item->buf, 0, mem_item->size);
 
 	q->elem_info = kcalloc(q->count, sizeof(*q->elem_info), GFP_KERNEL);
 	if (!q->elem_info) {
-- 
2.11.0

