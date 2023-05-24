Return-Path: <netdev+bounces-4974-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEDE370F61E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:21:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B57451C20C8D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFC8018AFE;
	Wed, 24 May 2023 12:18:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29ED18AFC
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:18:52 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888C49E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:51 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-510eb980ce2so1577349a12.2
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684930730; x=1687522730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1FNdrvtHnbtfL76FYe0kRQO6C0cFNZLbdNGToa4/7rg=;
        b=mo/Szc8HwP2a8ltMOCifPezMy2OX13iQFHMp1+Wm/FdWHPHcDroUumSjoPcI67r3wS
         H4360qFbzxHKPie0F/2BR/2IinXMmLPhMQ9SOklypv6dsdewxkGTxxsDbjNUUf2N3h5S
         fUQNnSPCIqstRA3KWLoF5SBLMAdw+Z+i/G/ocjkxvOzU5uTm8uZmInP89gbw+bwu1FJY
         dmgRm8UkPE813jrTm85Hx6z8YJxaayKiv22k2Lwtpuwsyhl+ViL+G62Jmm+3WM9ou3u8
         dryd+8ZHpF7p6QQA56cRO5v9kIXQoK3mwj3qAaSdL8RiilFpnef8gxlWVckn6gGxtN/A
         4Z9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930730; x=1687522730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1FNdrvtHnbtfL76FYe0kRQO6C0cFNZLbdNGToa4/7rg=;
        b=OvvUSGqd1q5XktMT0wxib24WbZ8Ar58UySI5yV/gAukWjhG0Cp71xC9ZUMymZFU6AJ
         8hi895ubMzwfXuFVvkUhic4BawYec9wg2OK5GZxfSRPBuIf08cNQdNzvN6IA7PHR2e8h
         fh3W5vDP+lBR3yqEBs6yCxfNS2ZXxdT8DZ4DL+1O5d6p/myEpe8mEKQspN0/MzzD19qM
         BWvF8PyFD+IpxxuA9KTgyJotFyO+aLg2dpzToCxLcqB3b0vOCWtcCxrI93yki37e5Wlm
         IQ1BK2pwlY74/WMZKgzYWmPLxIt+qOh1fkut11hSpb+i+dGVi6xcmvIjmPQZ+zVdfDky
         64Fw==
X-Gm-Message-State: AC+VfDybotBNh+N+SLq0AnRId4J+EWvIpqKMzh5/pAIDD5iHeG6dnUIj
	bleNOsetFina7IUqs3ejCxXUyZlFLJQuDRVJgj56BQ==
X-Google-Smtp-Source: ACHHUZ5LlbIQOyDPHRXXYUTkXAl8cEzlGWv0qFuWJfPvOHAyHy5pUUlFXCwODmJ+TRoHR5d+Sws97A==
X-Received: by 2002:aa7:c498:0:b0:510:d0bc:e130 with SMTP id m24-20020aa7c498000000b00510d0bce130mr1711899edq.33.1684930730067;
        Wed, 24 May 2023 05:18:50 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id dy11-20020a05640231eb00b00501c96564b5sm4986380edb.93.2023.05.24.05.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:18:49 -0700 (PDT)
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
Subject: [patch net-next 08/15] sfc: register devlink port with ops
Date: Wed, 24 May 2023 14:18:29 +0200
Message-Id: <20230524121836.2070879-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230524121836.2070879-1-jiri@resnulli.us>
References: <20230524121836.2070879-1-jiri@resnulli.us>
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
index 381b805659d3..f93437757ba3 100644
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


