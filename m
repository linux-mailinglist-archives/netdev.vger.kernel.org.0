Return-Path: <netdev+bounces-4968-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD8FB70F615
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:19:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97A8D280612
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBA74182B4;
	Wed, 24 May 2023 12:18:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E8F182A3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:18:43 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BD8139
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:42 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-96f7bf3cf9eso154961466b.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684930721; x=1687522721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zbY9a3v6sBZoyt6VBRXyHyAttwUhFzVnYvS+NyatT6o=;
        b=ebWkb9R5l0dE0vNJ0gDK4KHkpbA8m213/Ibthvr7YNuxKGtzEWyKoCKqAz9ddp612a
         AfaXxPViS402Reh+RXgvDy+MXYMreyzbxOAIMGSOA8x593brxFsuI5xfGwjL1KNgnPGx
         hUJh/HNq47s3n3hDTfCYcGh1sartCU4/yqk96jnAIO3nlOtCzQcKnho/VavMekwaTJx6
         QxnO39k0CXV6WYfUFVemXHbQ9EOOjhodq8ZNAjcoGU7Vnm3kDmN4eBcu25CSMP5zDmPZ
         aKUE9/nadMl1e1uXBRZi4PsTfNOLTkQgF2DtpqWzNdV4D5NNUy1vmAElIaTfWsMPFjNU
         oh0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930721; x=1687522721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zbY9a3v6sBZoyt6VBRXyHyAttwUhFzVnYvS+NyatT6o=;
        b=ID97nIc1MoG7v6gxfhP0YnqkapCscdm4VfPruuxbxcZliNmpzTuruFmmv6iT+Ntuki
         XMnCCq+wbWES9TCRChy8xSJuiUcANSnA9+qa2lTsn46FCxFSWeQirIEkN2Q2ycPvDGVm
         c4Mf6tz2mZjRHEs4qEiIVGADOZ85Mv6HF7nBRR41Fy1a0MVFhMXTq93IFBLH/Pye6JbG
         p2l5n8C9r9MKMBSzCjkAE3rUlsnIuLL0BhiwrdcbEXBvqurY3KrvUK10jGVS26YVcH/e
         jC4756A3nk6iasC+gUhK6sAKqUOYwJg/phu2mAWNzrueYVafWGhEYFQKBNiC1e4AGgPG
         vSTw==
X-Gm-Message-State: AC+VfDycMFXZbGaq/HlI9zMiUMlCGGUt8ek6DGiwt7AvmENX3KBXXwAc
	6JzM4ia94JSqlVMVpSxOezfgNrmPZiWk1bfI/cNCVA==
X-Google-Smtp-Source: ACHHUZ71TTpkkhImCh/lwFN0QsirJLVCmmg9eYYBWGnmMy5y6FTmfI5jNkVt61OpecKqe42BOFcQww==
X-Received: by 2002:a17:907:6d25:b0:970:e017:5596 with SMTP id sa37-20020a1709076d2500b00970e0175596mr5931072ejc.59.1684930720982;
        Wed, 24 May 2023 05:18:40 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id jx26-20020a170907761a00b0096f8ec46498sm5634317ejc.2.2023.05.24.05.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:18:40 -0700 (PDT)
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
Subject: [patch net-next 02/15] ice: register devlink port for PF with ops
Date: Wed, 24 May 2023 14:18:23 +0200
Message-Id: <20230524121836.2070879-3-jiri@resnulli.us>
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


