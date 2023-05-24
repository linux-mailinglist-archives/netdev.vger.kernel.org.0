Return-Path: <netdev+bounces-4970-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED30370F617
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:20:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 225651C20D21
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:19:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22FDC182CA;
	Wed, 24 May 2023 12:18:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DA0182A3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:18:47 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B402B135
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:45 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-969f90d71d4so118422166b.3
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684930724; x=1687522724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EQuPxbL5mz5Z2Rx39MZxKPTzLT4LdssI9aag/rEWDnM=;
        b=XtU95nwFwMyD3u0iM8ckdmM2xgmBd53NIKhN4ExFT1ehqZoIA+kFPJzgatSQ2gq7Bk
         BzLfnht+zI9qq9EDAlt279sJ44rJkNeWlLQrRLbzPBJev10CydnIPtK8vOlWOCdEFYdr
         72D1tu7h+6lbEy48k+5k35xblsvrNZzK8GLg/mlXjiZacgS4vjYbP23TYhtVvVq2ECkl
         Ph69WSg2BVWShyrzAlTbXWbdHrlZ4AZ8t+61ERHUkFIFJuieAwMFpx04BoDtkoQY82ZZ
         qar9g0PxXBY0bgKFuhmZHMMHhP3OqXr3wDkokUEOqUbhC7bgCC+rWq5bjHu6prraEVDe
         k1vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930724; x=1687522724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EQuPxbL5mz5Z2Rx39MZxKPTzLT4LdssI9aag/rEWDnM=;
        b=KOqa1hg2IzWyXcWyUX6BIJb3XhJt34ytvdxPklZn90dN/fWkdJDHtP9/UyNOhhjAv/
         n79fd5snzjVVUsMHZHbYalmccufzw7eR7E8Re9uBtrW+wUTyqxzES5aYiIJpGwNZmwhF
         pP8CHOGlbnKVo7jD5W1GpUv9uxhF/vZaraukvWBRnsCTXSI49+l9B48+WowGu07hv3T1
         cAx8Lv6LMY6LrVLSZ6B8bW5GqKE7HTzbkJlcoGngdu5rxp2L9aO/8CixBLzyXBfWsZUj
         VY6uZ3KejBIobvk7bx7ylH4pCw4Bc5d8zlXD1zB3hyu7pbaZtolNH36qULVypnb7SMKB
         U7iw==
X-Gm-Message-State: AC+VfDz0DL9u5GpMKLmDvqzmsC/3eocA1nn36K2YlT8pI0fkGxH+mBHr
	/z+7GquDRkOxBHQ6WrmiijNKIBWL5slFtDsQrQdXSQ==
X-Google-Smtp-Source: ACHHUZ6vYMqi391K7TCmAvZlwaJe+11kgMFq3oIyJAXKmIxY/+lf/qmpEiWEDhFnk1UWLWPYZvj9uQ==
X-Received: by 2002:a17:906:da89:b0:95e:d3f5:3d47 with SMTP id xh9-20020a170906da8900b0095ed3f53d47mr14605858ejb.48.1684930723963;
        Wed, 24 May 2023 05:18:43 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id g18-20020a170906199200b00965cfc209d5sm5655527ejd.8.2023.05.24.05.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:18:43 -0700 (PDT)
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
Subject: [patch net-next 04/15] nfp: devlink: register devlink port with ops
Date: Wed, 24 May 2023 14:18:25 +0200
Message-Id: <20230524121836.2070879-5-jiri@resnulli.us>
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
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index bf6bae557158..4e4296ecae7c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -321,6 +321,9 @@ const struct devlink_ops nfp_devlink_ops = {
 	.flash_update		= nfp_devlink_flash_update,
 };
 
+static const struct devlink_port_ops nfp_devlink_port_ops = {
+};
+
 int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 {
 	struct devlink_port_attrs attrs = {};
@@ -351,7 +354,8 @@ int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 
 	devlink = priv_to_devlink(app->pf);
 
-	return devl_port_register(devlink, &port->dl_port, port->eth_id);
+	return devl_port_register_with_ops(devlink, &port->dl_port,
+					   port->eth_id, &nfp_devlink_port_ops);
 }
 
 void nfp_devlink_port_unregister(struct nfp_port *port)
-- 
2.39.2


