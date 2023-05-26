Return-Path: <netdev+bounces-5633-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA717124B4
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:31:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B0F51C20FF3
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 080DA18AFB;
	Fri, 26 May 2023 10:29:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19AD1C764
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:28:59 +0000 (UTC)
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DABFB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:58 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-30a1fdde3d6so530987f8f.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685096937; x=1687688937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MvzgW8HvU9XBeJZCa5TXWrD6OoOjt3cWb788GO/oPB0=;
        b=KH2kLmBjxP7qJm3noJ/treejP7JFOurPFymeagDVQClM1Qir1VR/kgmODhq40drNz5
         JvfzeLcJrn+bvVvMCEozSoWm62uPYmObn+BYyjj1kS7loSS7OzNVpmLL8ScrsQ04iSgR
         hqFhLiIWx1xcsX2BhtOLpgvbJh0DbgIUgMACHms+MewX5TMNY0F5De5C0fRAvpI+T+Gx
         bdh35IOaVg4ngWK9LOVgFmS27bvzAMTDb8wuZegm5CT5haW4knIxxUd1jyodxTLaV39P
         gJoUc2+9CnhGfp4AmWfnR9P+oZadfFnHdpE4Ta/6i4VkkKtApVm7wzWPDv2rEhzmSpF4
         0czQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685096937; x=1687688937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MvzgW8HvU9XBeJZCa5TXWrD6OoOjt3cWb788GO/oPB0=;
        b=dlWmWTZFzi9tgy0Xa7cyPet7t11B3zCAuyiQQW1gSqAsqPn6VZACAa1bHGdUzh4omW
         /qWhbi5tDIaL3gBuDS70cnakIjKS+8vsm5EsvJeBvipNKaf0miXihSVQ2mRVm4w10zI5
         Pv1FHdcersXuuCVKv7FXdsgY9FD0zOjWGgMqCR4Teg+941jOCI+brQDcdzfVt8phx6Wm
         l1Y4LedVPY+B4asjnTwqttMFhvVe7S8CHcuSHvh4LIEYPBciCW707l6X3tXKqwt8fMI6
         gBwvx2TIyt296eAjjAwSmqgzqWj9TtIeScTlZXh6CuWbyylWm/ERso+8mzc/7ZkTQLLV
         na5g==
X-Gm-Message-State: AC+VfDxy4irPQgvutxsGNt6SuTfpSA8rhNFdd3nNzifeoVihq2QQdw2N
	9OpxsUDpERkfDFAf4rwa4b+p25D087Qqu2euEj+49Q==
X-Google-Smtp-Source: ACHHUZ4jdPHUzAbPzTMYsZ66rgL1ZC/SpL+ONAwr7lM3XQ7/r+bO74ioE+u0KZi+kXjysJRYGfbSJw==
X-Received: by 2002:adf:f447:0:b0:309:4642:8793 with SMTP id f7-20020adff447000000b0030946428793mr1190394wrp.15.1685096937164;
        Fri, 26 May 2023 03:28:57 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z13-20020adfd0cd000000b003048477729asm4566736wrh.81.2023.05.26.03.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:28:56 -0700 (PDT)
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
Subject: [patch net-next v2 08/15] sfc: register devlink port with ops
Date: Fri, 26 May 2023 12:28:34 +0200
Message-Id: <20230526102841.2226553-9-jiri@resnulli.us>
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
---
 drivers/net/ethernet/sfc/efx_devlink.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index ef9971cbb695..e74f74037405 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -25,6 +25,10 @@ struct efx_devlink {
 };
 
 #ifdef CONFIG_SFC_SRIOV
+
+static const struct devlink_port_ops sfc_devlink_port_ops = {
+};
+
 static void efx_devlink_del_port(struct devlink_port *dl_port)
 {
 	if (!dl_port)
@@ -57,7 +61,9 @@ static int efx_devlink_add_port(struct efx_nic *efx,
 
 	mport->dl_port.index = mport->mport_id;
 
-	return devl_port_register(efx->devlink, &mport->dl_port, mport->mport_id);
+	return devl_port_register_with_ops(efx->devlink, &mport->dl_port,
+					   mport->mport_id,
+					   &sfc_devlink_port_ops);
 }
 
 static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
-- 
2.39.2


