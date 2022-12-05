Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E2E642B9C
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiLEP0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbiLEPZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:25:54 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B733410075
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 07:23:10 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id e13so16209124edj.7
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 07:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=06VsRPeOe0ybs/eCC13HBpok42bwaB798EXCcmdcpuU=;
        b=ugMWy9HEs03GhyXLY7SFFTyNRRguVGU1+2zGkxTRUlGm/z+T5Rz98deIs1ecTtWRk3
         5FBbK588m/3aqcznjyHZcS0dpKv4OBI7nocS24q+ql/IDvpCCsenl6lY7Cn/Y6s10x64
         GfK8fmoyw0+IpBUKAAVfYhDAaF8nJGk6RXj8W5dNthjsST4Fl2q3U+P+lNOdBoMvXEA7
         WPxq+W8U4+NWKj/Jqyfv+hNfU8JCS/jagOHQ2H/ys22LOF2tw5xCwpG4qkuYri0kF3he
         9k6XArmKyvNfiwthW/N92DCzLQm4M1Bm6Y32FDQi/j6YQc1QqstaeQL41lVeGIKeye+D
         RCMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=06VsRPeOe0ybs/eCC13HBpok42bwaB798EXCcmdcpuU=;
        b=qASOxqFGnIrcor1+I2+InzCs1b1VOpIDKEsiS8KhmL5EAZirbdecjAcEg4d624Edne
         uFHtPUFK/PheuMKokDXqmfKUAS+uwSRKo0jE7S19nzRheTQzDNgRSAvTvR9myZk8L31+
         5PeJ5LSAH4gUl2w2DIUGWdu8P8hp1leSeKQ6pYlHFt39x5hMTIPlGzCK1OcnrT4HRZBe
         Ca5/IKjSA4Jz7W02k7sBxIseey2F9zMvBy7XMjzEi1mAop+CgwCTbVcNvwwH3VRdooov
         Uqaf66OWSCP3Y1jeKgbRLU1xad7wOF1PXXqpcdf1EZxTvaCooVaSfhRts09lPTg75KMh
         AoEw==
X-Gm-Message-State: ANoB5plTV/A0PGa3VFUTziwAGbEIuYFO9MT4yv+YXeO3aQfQEIbIJGsN
        M9Yr5MyeBNXHh1GbX8zCWKgtQPGfk6Ufc6MTsRG+aQ==
X-Google-Smtp-Source: AA0mqf6xuWuIRZd2ewlhKIjjDwK1qaFEEES8e1KTQ/vV8X59I3MbEkAiqUKGUjUY32tKvcFS5XmeRw==
X-Received: by 2002:a05:6402:2a08:b0:461:5e99:a299 with SMTP id ey8-20020a0564022a0800b004615e99a299mr73699221edb.40.1670253787178;
        Mon, 05 Dec 2022 07:23:07 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v6-20020a170906180600b007c0c679ca2fsm3944568eje.26.2022.12.05.07.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 07:23:06 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, simon.horman@corigine.com,
        shannon.nelson@amd.com, brett.creeley@amd.com
Subject: [patch net-next 4/8] nfp: call devl_port_register/unregister() on registered instance
Date:   Mon,  5 Dec 2022 16:22:53 +0100
Message-Id: <20221205152257.454610-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205152257.454610-1-jiri@resnulli.us>
References: <20221205152257.454610-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Move the code so devl_port_register/unregister() are called only
then devlink is registered.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->v1:
- shortened patch subject
---
 .../net/ethernet/netronome/nfp/nfp_net_main.c | 22 ++++++++++++++-----
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index abfe788d558f..9b4c48defd5c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -752,7 +752,7 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 
 	err = nfp_shared_buf_register(pf);
 	if (err)
-		goto err_devlink_unreg;
+		goto err_clean_app;
 
 	err = nfp_devlink_params_register(pf);
 	if (err)
@@ -769,23 +769,29 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	err = nfp_net_pf_alloc_irqs(pf);
 	if (err)
 		goto err_free_vnics;
+	devl_unlock(devlink);
 
+	devlink_register(devlink);
+
+	devl_lock(devlink);
 	err = nfp_net_pf_app_start(pf);
 	if (err)
-		goto err_free_irqs;
+		goto err_devlink_unreg;
 
 	err = nfp_net_pf_init_vnics(pf);
 	if (err)
 		goto err_stop_app;
 
 	devl_unlock(devlink);
-	devlink_register(devlink);
 
 	return 0;
 
 err_stop_app:
 	nfp_net_pf_app_stop(pf);
-err_free_irqs:
+	devl_unlock(devlink);
+err_devlink_unreg:
+	devlink_unregister(devlink);
+	devl_lock(devlink);
 	nfp_net_pf_free_irqs(pf);
 err_free_vnics:
 	nfp_net_pf_free_vnics(pf);
@@ -795,7 +801,7 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	nfp_devlink_params_unregister(pf);
 err_shared_buf_unreg:
 	nfp_shared_buf_unregister(pf);
-err_devlink_unreg:
+err_clean_app:
 	cancel_work_sync(&pf->port_refresh_work);
 	nfp_net_pf_app_clean(pf);
 err_unmap:
@@ -808,7 +814,6 @@ void nfp_net_pci_remove(struct nfp_pf *pf)
 	struct devlink *devlink = priv_to_devlink(pf);
 	struct nfp_net *nn, *next;
 
-	devlink_unregister(priv_to_devlink(pf));
 	devl_lock(devlink);
 	list_for_each_entry_safe(nn, next, &pf->vnics, vnic_list) {
 		if (!nfp_net_is_data_vnic(nn))
@@ -818,6 +823,11 @@ void nfp_net_pci_remove(struct nfp_pf *pf)
 	}
 
 	nfp_net_pf_app_stop(pf);
+	devl_unlock(devlink);
+
+	devlink_unregister(priv_to_devlink(pf));
+
+	devl_lock(devlink);
 	/* stop app first, to avoid double free of ctrl vNIC's ddir */
 	nfp_net_debugfs_dir_clean(&pf->ddir);
 
-- 
2.37.3

