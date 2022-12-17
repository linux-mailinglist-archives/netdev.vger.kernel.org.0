Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B681564F6BE
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 02:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiLQBUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 20:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiLQBUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 20:20:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F859680AB
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 17:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C75476231D
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 01:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB1BC43398;
        Sat, 17 Dec 2022 01:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671240011;
        bh=OksB7Dhw0d0RhICVDqXHzi3GtIAhGXIHFFPCuhxtrKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UlLLpWdhCjNzYsb6ASA68QfMQno08Jq6YjgSpLmV5UXDsM6Q22tPlQCJicGudKJgB
         olWj/7Lfr4QcFnLX9rFsACNOnrsjjFJcnLn7OaazhS0OPcDVDCssXcrO0fbZM+MefN
         aUf0xG1zArwShWBj0JPOSCZbMTLJY7d4Vqew3Tm6IUWbR3s8MG7G5GtMaXMLC4Y8SJ
         YPMeqa5M4e/lvDwzLC43Mx3sOWwuqsyRih+i9zMCR9N+bZVLxqehmFaUjcQO/TM6tR
         UA/caofYwzRbO7E+qG0QZP6UC8+b/EVRG/UN568U9zGAQ20lQgde/gq+gv++Qg7zLv
         uNFLC+XeKt46g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 07/10] netdevsim: rename a label
Date:   Fri, 16 Dec 2022 17:19:50 -0800
Message-Id: <20221217011953.152487-8-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221217011953.152487-1-kuba@kernel.org>
References: <20221217011953.152487-1-kuba@kernel.org>
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

