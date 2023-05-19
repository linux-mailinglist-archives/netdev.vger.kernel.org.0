Return-Path: <netdev+bounces-3995-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E49C170A00A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 21:43:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8046F1C21187
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 965FF174FE;
	Fri, 19 May 2023 19:43:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882481119C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 19:43:18 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028A4E5A
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 12:43:13 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-3078d1c8828so3444744f8f.3
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 12:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684525392; x=1687117392;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T7jXzBlv/x7knTLTZdsLaKRxP5YKCfI/UXXz7YCoBcM=;
        b=AAMELdw1xlnh4GC6SpyFNwIYZQ5R9G3EWmccd9Cxd60tUlESVZ7mnnAstuqu3fSEFl
         la1heueb27DGnNSC7ZjfouoB5el3sO46TXpJXLE7cV6HCXo3T4HmJa7/Y7IODVpubD3u
         XcBWObJj/odhut67KgjlDRnVUZEMXSu2iosu4G9oqQQoLdSkgpwVIJCIoPhlQ6ah1LMv
         cDpD55jSRg+hWivaNtJnYyQwnleuMvxAl4zmuoIYDySUvh8t7p61vZiQ4lyUJJhAf8H0
         EzA9YnflDWtxhCBk6AkHCfbWV3ISIPoeRpZbmd+XhdgHi3XXnOA0ZL5V2sx7lkCXTsv/
         dnjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684525392; x=1687117392;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T7jXzBlv/x7knTLTZdsLaKRxP5YKCfI/UXXz7YCoBcM=;
        b=Nh6U4ibL+b6Eo1eqeEaKy9IiqKa5d3HRtwfgOeKWZ3UR88410NoMIm0hGtBw2Df7YJ
         inIVaOTIEGfvcRAfuWn9U2Ja9ePD93BbJq0X2LOdu8oGURG3FjM+ZItn6TII74B8Bs4b
         ticNiNBY8d9NX2n0KsdGr5qmmRSwd8C3CdApWba4wy6EudAOCnaMVuQQOLoLgZI2/lWG
         CbV/HRygG5qbfC5WAiditkt2fug7ZyJAHVr0ZZoUEfmdvMguNfaPbiFio2q2SwfskvXP
         xorgeprMMA2RbdnYZK0Gl5yPc51WIKx1EDktoJn9EYZMbKbh2I0/Xq2pvuH6AU/xoDSm
         yh3Q==
X-Gm-Message-State: AC+VfDybP3SYwXk9Sxy84RXWkNGtcSq2Gso6iDfXti3MavVAlYgyooEY
	0ey0FRCmw5FQCBtPnyVG5TLGrg==
X-Google-Smtp-Source: ACHHUZ4Dldx3i06cCQyq05HLtiBc9WOfjvyjvCQsAw5LF/bDperqlV+k+zCeVD/Ej7ZkEZzfElsqEw==
X-Received: by 2002:a5d:6091:0:b0:306:3361:6cbf with SMTP id w17-20020a5d6091000000b0030633616cbfmr2476488wrt.21.1684525392266;
        Fri, 19 May 2023 12:43:12 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id d2-20020a5d6442000000b002c70ce264bfsm6149863wrw.76.2023.05.19.12.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 12:43:09 -0700 (PDT)
Date: Fri, 19 May 2023 22:43:03 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Eli Cohen <elic@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net RESEND] net/mlx5: Fix check for allocation failure in
 comp_irqs_request_pci()
Message-ID: <ZGfRR//to6FusOLq@kili>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This function accidentally dereferences "cpus" instead of returning
directly.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202305200354.KV3jU94w-lkp@intel.com/
Fixes: b48a0f72bc3e ("net/mlx5: Refactor completion irq request/release code")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
I sent this earlier, but it wasn't applied and the kbuild caught it.
https://lore.kernel.org/all/6652003b-e89c-4011-9e7d-a730a50bcfce@kili.mountain/

 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index eb41f0abf798..13491246c9e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -824,7 +824,7 @@ static int comp_irqs_request_pci(struct mlx5_core_dev *dev)
 	ncomp_eqs = table->num_comp_eqs;
 	cpus = kcalloc(ncomp_eqs, sizeof(*cpus), GFP_KERNEL);
 	if (!cpus)
-		ret = -ENOMEM;
+		return -ENOMEM;
 
 	i = 0;
 	rcu_read_lock();
-- 
2.39.1


