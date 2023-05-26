Return-Path: <netdev+bounces-5629-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 716D87124A9
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:30:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BD66280A62
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E38A17AC0;
	Fri, 26 May 2023 10:28:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AEB171AF
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:28:53 +0000 (UTC)
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6270FB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:51 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-30789a4c537so311356f8f.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685096930; x=1687688930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EQuPxbL5mz5Z2Rx39MZxKPTzLT4LdssI9aag/rEWDnM=;
        b=SDF548WxVLAK7r+lY8qrtr7dw7VCnJrMMLoHH1wbJge5RIg7vROybH4e0ScFxw/VX+
         OLrzAsM9n6hcHHqxX5yELXsegFGoJWyNlar8M4pf9QzgvFhW9KlK+3SCF9Ill6Imez9V
         /Uo40AiO0JGe9LZ+yonEG1xX9u/iW/jlMwLC02+GcmUnxKxxlPMidq8mX8K6ccjI6u8r
         cH6MFFkusVBMLJFw5FhD8o5fh9wqIRc5FU6BPo6D/glBybnJSraGHCKu4Ywf2bjjcLev
         +pIvzEUU57934eZA9PQdDUOI+z3SoUCG9B68Uu/fJXYK/CXlw+wFnmPFCYfVUZzBQ6KV
         jpGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685096930; x=1687688930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EQuPxbL5mz5Z2Rx39MZxKPTzLT4LdssI9aag/rEWDnM=;
        b=MhOD+wSsz0gBaBGe7Go3+ggjpl5qVo6alB0lWAzlpJwpYi/w5fK7z6Z3TCKEXjef6v
         5Q/+0PDXYKy0PklE4klRSiJHc7ZAlgobYRD/rZqE1MjppPtHR6Bj64SSdW2m14YX/6U3
         p1giWaTEz1lO6ATK30iuVl9fb2DCJgENjBRkhzO5JKgh8QrXFvN+NeeuZMSB+Wt6+d2d
         1tDqzAWxFafAeLda/CbOoW2jtD0O6X+b6f7vbxdONAVBaEw9iyLkeMtawOECBAFCsrfh
         mXeItnQN2lX966DpozQUS8g8Zu/5Jr9rKmLgmxX0870uFO4Q04Mc37AQRKJ98GKljx/O
         Wo4Q==
X-Gm-Message-State: AC+VfDwsMWjwrWvCh9J12NiUTuNWgwykpORwvX4XUxnFNjjJywx+f4Ji
	znl9iXn/Wjnjn4HCgWjMZk34Eei8e0w68zEKQ14qjg==
X-Google-Smtp-Source: ACHHUZ4McgnvcT1hUcQFKfWCPE8GD3cD1sXEXALTrX3g4mnEP/H0gO7d8d3nVdO7ySpm402ylovmig==
X-Received: by 2002:adf:f7ca:0:b0:30a:d489:77af with SMTP id a10-20020adff7ca000000b0030ad48977afmr1149001wrq.16.1685096930360;
        Fri, 26 May 2023 03:28:50 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t6-20020adff606000000b0030632833e74sm4642598wrp.11.2023.05.26.03.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:28:49 -0700 (PDT)
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
Subject: [patch net-next v2 04/15] nfp: devlink: register devlink port with ops
Date: Fri, 26 May 2023 12:28:30 +0200
Message-Id: <20230526102841.2226553-5-jiri@resnulli.us>
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


