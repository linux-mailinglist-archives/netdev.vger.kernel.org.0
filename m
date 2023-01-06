Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0BD65FB83
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbjAFGec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjAFGeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:34:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFE46E0C4
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 22:34:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D584B81C99
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897BAC433F1;
        Fri,  6 Jan 2023 06:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672986850;
        bh=S5JQ95+PpTtkTlE3mY3GZ38NaC7JPv7pnPPZp5mm+xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qSUkxOItInh6codrigEwH9tFphDJL9FQXm/ezEDFULeGT0BKKV/pCY3RdlcwlfTLm
         NMN+tnQARTe9Yeqk/YEHx9caK0jwNBqUkRfM3WhtCOb6jyygYPttCfBYKFDQiXPeOf
         nQ1RWSyfrX3ZMWpKLn7Yu9b1+pnTFPDVH9/+7nGRlxvK9d8K2TkXM3un+mlXOPsFLG
         jicKLPWHBna4hNHIhxfmhgJbkItSvBTcWoVDghhH75vwWg4TAwF2J+rDsxvuAAipV6
         P7eoFusuz4iQ84xpiCSW/8YvVu2Vxy1dY6oz4zQNJot4ZQo+XROUjjo+QcWJtQcDme
         s4P7DB32MIWcw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 8/9] netdevsim: rename a label
Date:   Thu,  5 Jan 2023 22:34:01 -0800
Message-Id: <20230106063402.485336-9-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230106063402.485336-1-kuba@kernel.org>
References: <20230106063402.485336-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

err_dl_unregister should unregister the devlink instance.
Looks like renaming it was missed in one of the reshufflings.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index b962fc8e1397..d25f6e86d901 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1563,7 +1563,7 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 	err = devlink_params_register(devlink, nsim_devlink_params,
 				      ARRAY_SIZE(nsim_devlink_params));
 	if (err)
-		goto err_dl_unregister;
+		goto err_resource_unregister;
 	nsim_devlink_set_params_init_values(nsim_dev, devlink);
 
 	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
@@ -1629,7 +1629,7 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 err_params_unregister:
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
-err_dl_unregister:
+err_resource_unregister:
 	devl_resources_unregister(devlink);
 err_vfc_free:
 	kfree(nsim_dev->vfconfigs);
-- 
2.38.1

