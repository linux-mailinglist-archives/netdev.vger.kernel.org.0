Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D021F5144FB
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 11:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356114AbiD2JEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 05:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbiD2JEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 05:04:30 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0EA7C171;
        Fri, 29 Apr 2022 02:01:12 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id t16so5237713qtr.9;
        Fri, 29 Apr 2022 02:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QT46ZXzCGL+R7nT0rDx4wdChyPMcgjzBYK0Zb5wvKXc=;
        b=c+Zvy32IIvssEY5eMFFo31iKz4oGqjg40P0KqS8JtyeNNCVA5SLD/xq9g9tsu3hMGo
         CXD3pJHv/7FZ3nd40kk+SID38r0qZYESBXksm4L8RleMDjY5Q9NFMYv8aju61gBeSfnZ
         XTTdlRySfBqhXk/S943Xv9C1zto7bODAnr4SoGFe1WZYQCcRPekH1MnH1QTBcpchlU81
         E3HJF4+rIrAi/JEjMCjxMh9E5cEmdJhCcsUlj91FtpxAOrje2T7LRnNX63f23tjKao/p
         mQEfC4+CzXAzqpxZVGMY4rj+UFau83JAJMyDwZ2WT8oy2gtb8gma/Oy9Fh4lcutkwd1y
         eQTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QT46ZXzCGL+R7nT0rDx4wdChyPMcgjzBYK0Zb5wvKXc=;
        b=LuZPbri6OQXU7Hrnr4MXStiEBHNRZx9UhLFPzF+6hio2HEWL3pgdExC3w32ttqHisE
         YwLdbFbxk5sKEkMZE/lfB8ADeNsWHbendgodaNMxvyqpX67O89zWqHPYt+3TNcd6NO9U
         H7Ij1FIVqa7Omq4TJ8Ax9M0OK1GwDegKAHz31ECJ2eTzz1nIdF7FDqV1V63MZg63JZrD
         8oFLd/TYNsiRbc895CywxV+8d7AoDtRGl1mc4RjmdTAKR5BNHBpxSh074Zv7Lr0JRLvY
         eA++So5Ydoy1kN6BcbyfjejT7l+m+AGfCnGh8z6KbQtI7ibWfmiAxZOKZr1gAF5B5BhI
         wmPQ==
X-Gm-Message-State: AOAM530uhXo2WreOdf3LEBfdhqNJoomjTTWdk2HXyRHKcxonghXZeQbo
        dz5HJS5wpHVNdEpWR+XwOCU=
X-Google-Smtp-Source: ABdhPJzg9/gVWVEm/EHqQtnsyw341kvmNtYnKA8NWhH4d7v6WLjd+gLLfqnEYukOPDJ4xQMycMK1yA==
X-Received: by 2002:a05:622a:611:b0:2f3:8454:edcd with SMTP id z17-20020a05622a061100b002f38454edcdmr8744725qta.297.1651222871573;
        Fri, 29 Apr 2022 02:01:11 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id i25-20020ac84899000000b002f39777e722sm255513qtq.27.2022.04.29.02.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 02:01:10 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     dmichail@fungible.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net/funeth: simplify the return expression of fun_dl_info_get()
Date:   Fri, 29 Apr 2022 09:01:04 +0000
Message-Id: <20220429090104.3852749-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Simplify the return expression.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/ethernet/fungible/funeth/funeth_devlink.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_devlink.c b/drivers/net/ethernet/fungible/funeth/funeth_devlink.c
index a849b3c6b01f..d50c222948b4 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_devlink.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_devlink.c
@@ -6,13 +6,7 @@
 static int fun_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			   struct netlink_ext_ack *extack)
 {
-	int err;
-
-	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
-	if (err)
-		return err;
-
-	return 0;
+	return devlink_info_driver_name_put(req, KBUILD_MODNAME);
 }
 
 static const struct devlink_ops fun_dl_ops = {
-- 
2.25.1


