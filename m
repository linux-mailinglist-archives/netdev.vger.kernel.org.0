Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D721E6B7D
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgE1Tq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728693AbgE1TqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 15:46:04 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842B7C014D07
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:01 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id h9so17264qtj.7
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f6D506IClEtnX+bRERYjtoHYo/Um+QSp6vqv6/9e84w=;
        b=fW0uki/k8HtV2CtH7YQVaLjLFslLDS1F3KUcGmAAL/UUQzL/hwT1AYCNlv9iIGgHK8
         zIuvIN+mXxjt5sEf+zK7j8A2RbIy0JFkgki49HTpYNGIfvM0ttnoPuNI3CMAvxVO+vJN
         Fk1r/cMaiSQd+xckFSk+Ryvd2u5OZYtqlNQbdVgwy4NDk0+VhqIYsT7ce09k233MCnWL
         HQWj0Ltc9zwfRUBF4h5fOw2RDpwbFPPJrmRJXzsyngvHHQ6ewglfE0CZAFGf/ryYnNrv
         9PnpXfxJNU5DuUkC1iR7GtiAgy43bBTfP20EvcRcUoy29yQZL4TbBPu/5KzAX7pUj7ox
         dxXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f6D506IClEtnX+bRERYjtoHYo/Um+QSp6vqv6/9e84w=;
        b=K6Wi/7Ms3tSg+UxCJMcLul4APUvwCArybY/GLCh77qE4C4+6CepATQ3ZRw8ygctF0x
         deQ16SmvPstCdPBWiR0MvixHWu98X5iEo/k2sNy6UxvWE/clOaReoSsgkBicuD/MxmUF
         Fijdz3NIdjQMUR47QJXj04sfEo5yoQvGdSmJGiYjmDbiPgD3Oxj0SSwvLgJs9831WNtE
         N7EZqUILQ1qM/zsYAUv7aaS5+8nBETfSGTxswd8I2HWIeclX0ExOXkisoJik/OpXgqlW
         IyCXeimKuSiYRUwVhc2sS/iSUH4Q9Hgp8NeRl2v70MkLomHN1auLVHp1mXnWEplbnInG
         T/sw==
X-Gm-Message-State: AOAM53289CJYxi+8SU43yLIFWttRogsy/sogMvyR1aqephtL6qAbev5H
        00YXd6PxuI0rmoLKSSfyTpGh2w==
X-Google-Smtp-Source: ABdhPJx1gIplGPQZu5SmsC0uibwb8hkn+ONBEZ6HzOvN6oagPO6XJo8cQ9JLHDhGAEB/plk1kyK0Tg==
X-Received: by 2002:ac8:7313:: with SMTP id x19mr4904786qto.383.1590695160807;
        Thu, 28 May 2020 12:46:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id h3sm5265538qkl.28.2020.05.28.12.45.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 May 2020 12:45:57 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jeOTU-0006hC-6u; Thu, 28 May 2020 16:45:56 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     Gal Pressman <galpress@amazon.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>, oren@mellanox.com,
        shlomin@mellanox.com, vladimirk@mellanox.com
Subject: [PATCH v3 05/13] RDMA/mlx5: Remove FMR leftovers
Date:   Thu, 28 May 2020 16:45:47 -0300
Message-Id: <5-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
In-Reply-To: <0-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <galpress@amazon.com>

Remove a few leftovers from FMR functionality which are no longer used.

Signed-off-by: Gal Pressman <galpress@amazon.com>
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Acked-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 482b54eb9764eb..40c4610177631a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -675,12 +675,6 @@ struct umr_common {
 	struct semaphore	sem;
 };
 
-enum {
-	MLX5_FMR_INVALID,
-	MLX5_FMR_VALID,
-	MLX5_FMR_BUSY,
-};
-
 struct mlx5_cache_ent {
 	struct list_head	head;
 	/* sync access to the cahce entry
@@ -1253,8 +1247,6 @@ int mlx5_query_mad_ifc_port(struct ib_device *ibdev, u8 port,
 			    struct ib_port_attr *props);
 int mlx5_ib_query_port(struct ib_device *ibdev, u8 port,
 		       struct ib_port_attr *props);
-int mlx5_ib_init_fmr(struct mlx5_ib_dev *dev);
-void mlx5_ib_cleanup_fmr(struct mlx5_ib_dev *dev);
 void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr,
 			unsigned long max_page_shift,
 			int *count, int *shift,
-- 
2.26.2

