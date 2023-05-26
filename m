Return-Path: <netdev+bounces-5627-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC5A17124A3
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:29:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A66B81C20FDD
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C431C168DA;
	Fri, 26 May 2023 10:28:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7A5168B1
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:28:49 +0000 (UTC)
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFBBFB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:48 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-30a95ec7744so504669f8f.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685096927; x=1687688927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ePYSgiQ7xbHMiCJnNMd8n7WNMcuzOalZ+9EAtfWxN8=;
        b=y6BVzB2Vqn3tNZUH+Xzb2It/8i7LW43cAMfQr+WkuSZWgBhCmqD7b19k9MkOFoc27q
         iK8MqUaeK7uSMYQsoCCqPoOKsD1f7SIhI2EEPQANl5oaYuFkP9p/AHOR5NeLCLZ4OAlm
         irYpfOaWJCWu7TC68j1vlVIYjnslBW7UjTbuFAP7sp6nCEgmJ8SUE0KSVQbmsiyn4Iss
         JxuXrmfy6S/Ut81EiZG6wb8RQU3m3fDBv3N8p3JNWx8o/I6jsii+qC0Zvd821xSe74gq
         qbYbaYH4PmAi1a35Pv5CtjUGSuslRsGr2/lXRY4MTv70j171jUCVkSNTCC3yCnbLptzb
         q0Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685096927; x=1687688927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ePYSgiQ7xbHMiCJnNMd8n7WNMcuzOalZ+9EAtfWxN8=;
        b=P7DikhVwXaIqlGWw5+KNe9nKk4Vzjd/uOJihaCwAefGBGOVyCmjADTcvT0Ya8btwHN
         7R1nflyjST7q8KO7bPD3UMQ5vjdDcJ4ykDl6EVwsQD/BiWFS21u9MrNxsoYLGvu4lHpt
         TzxbDcwBxM/LUNebAIsGXwTr0uduRnylzoKLDn23hA2K9eIbkGAX4ayA5GvDg7O9NqTl
         ndI/beIHk0I4JsSg2r61jeFsW7ISmBq6VKg2l9/LzBlqKUygGbthTt85lATUQ9SkPq4h
         mkWC1ZxlRXawaX7g/rkQmmPadP4aP2qp4k4IDZWHkw6GN+NXKaorWqeMXTcMtiejpYuL
         5N6Q==
X-Gm-Message-State: AC+VfDyYa7YnrwoPs/FRH4R4jm/XBOGN4dMryJ6SpwgFpbqTTM7Yuvke
	tV6K54DF0IwSDo2EaaUQarKtEjNzxxXBWtREeYaN9A==
X-Google-Smtp-Source: ACHHUZ4JQ6ig8mgLpiZqNE7tC6BB4qETyzHjgRUUm01/b4WVEIIzrWAAGrK84l4t4CCwTUC/6iASow==
X-Received: by 2002:adf:ce09:0:b0:307:a4ee:4a25 with SMTP id p9-20020adfce09000000b00307a4ee4a25mr975858wrn.28.1685096926860;
        Fri, 26 May 2023 03:28:46 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s17-20020a5d69d1000000b00304adbeeabbsm4685417wrw.99.2023.05.26.03.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:28:46 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	leon@kernel.org,
	saeedm@nvidia.com,
	moshe@nvidia.com,
	jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com,
	tariqt@nvidia.com,
	idosch@nvidia.com,
	petrm@nvidia.com,
	simon.horman@corigine.com,
	ecree.xilinx@gmail.com,
	habetsm.xilinx@gmail.com,
	michal.wilczynski@intel.com,
	jacob.e.keller@intel.com
Subject: [patch net-next v2 02/15] ice: register devlink port for PF with ops
Date: Fri, 26 May 2023 12:28:28 +0200
Message-Id: <20230526102841.2226553-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230526102841.2226553-1-jiri@resnulli.us>
References: <20230526102841.2226553-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jiri Pirko <jiri@nvidia.com>

Use newly introduce devlink port registration function variant and
register devlink port passing ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index bc44cc220818..6661d12772a3 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -1512,6 +1512,9 @@ ice_devlink_set_port_split_options(struct ice_pf *pf,
 	ice_active_port_option = active_idx;
 }
 
+static const struct devlink_port_ops ice_devlink_port_ops = {
+};
+
 /**
  * ice_devlink_create_pf_port - Create a devlink port for this PF
  * @pf: the PF to create a devlink port for
@@ -1551,7 +1554,8 @@ int ice_devlink_create_pf_port(struct ice_pf *pf)
 	devlink_port_attrs_set(devlink_port, &attrs);
 	devlink = priv_to_devlink(pf);
 
-	err = devlink_port_register(devlink, devlink_port, vsi->idx);
+	err = devlink_port_register_with_ops(devlink, devlink_port, vsi->idx,
+					     &ice_devlink_port_ops);
 	if (err) {
 		dev_err(dev, "Failed to create devlink port for PF %d, error %d\n",
 			pf->hw.pf_id, err);
-- 
2.39.2


