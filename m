Return-Path: <netdev+bounces-5625-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC2317124A1
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:28:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C8BA281771
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68892168A0;
	Fri, 26 May 2023 10:28:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE42111B3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:28:48 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A634FB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:45 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f60b3f32b4so3989405e9.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685096923; x=1687688923;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Jz+6IYGwbx8Jiir4DarQynj+vCqItdMIhRpAsWEkFsQ=;
        b=lcAUDeUVSyG9esYJPG/AVbas6XpnVrg2B6Dy91LcmvGWJsWXVOYrHHY8VUD9ybXI7K
         S3ZMzbTcX+VOCRQJoFRTvuADSDgh3QrAbekvv73Yag3PzxsCO3Y5jCF+QCXhWuYj8PBq
         YiMYZxUmH1kGAnRRoA36zYnQc7IlcM5s3c6xhlfjiUPIEd165X7FAbl86vbivzdJRM/9
         n2sDpn/lK1yzIgg4HOo36sGtEgG7wnlME1FP4kyuij9dZxYnuaFaj+YKc1Vx178RtzFZ
         qs98Y99jjHGqsL2GzN2sDy4cG4G2rg1SPrOJv2m6oGPXO7kN8OEHsDCF6Vr1DziY9ucP
         Z6OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685096923; x=1687688923;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jz+6IYGwbx8Jiir4DarQynj+vCqItdMIhRpAsWEkFsQ=;
        b=B/a8GSbH4ZkOwXsaMabIyRYA1QJIaxyiOjWknd3Y4HNWGaWdFF+pfqIkt4UgjfgYdo
         DLQVl8k8WvZqFyVFPg9PlpUvFEws2+cqBBZMIKegxpw4XAxU8M2PDs69X2Df5KDgGQxQ
         hq4TgcGzG130YvaSWuPgVV0AbJnEZZVc6mxuNEJMn0kgBxNHm5MAYyVITQ4mOqPp678F
         xNvz0u909wC25rSV7aljireZvKpqHkGAX4FCZiWOFFbxlVBmJnRZHJumMAk9EcgklAFn
         cc+7dMMrxc+M7SBXYDE9dRCYSdhW5pAw44ObJPl5JaZZn2oCCTylOIRU41lpgV/+7PP4
         xpKA==
X-Gm-Message-State: AC+VfDwYxFafvnNj0/N/rNr143sC2Oyce2YOu+ZzIKb67DbXOxE3x2ZG
	CVtkNwaMBMkSReWCcMlR8LROd4h7Uq4K2XmzPEPEFw==
X-Google-Smtp-Source: ACHHUZ4GEzyrxXu8Z/Illc9Iv5B2LgACxyw5Z5a8BZ5mwXOJSCAfslvmmnY0AA/oZcLqZOF340gZXQ==
X-Received: by 2002:a1c:4b19:0:b0:3f6:7da:21e2 with SMTP id y25-20020a1c4b19000000b003f607da21e2mr1409367wma.14.1685096923551;
        Fri, 26 May 2023 03:28:43 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 20-20020a05600c22d400b003f180d5b145sm4769738wmg.40.2023.05.26.03.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:28:42 -0700 (PDT)
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
Subject: [patch net-next v2 00/15] devlink: move port ops into separate structure
Date: Fri, 26 May 2023 12:28:26 +0200
Message-Id: <20230526102841.2226553-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
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

In devlink, some of the objects have separate ops registered alongside
with the object itself. Port however have ops in devlink_ops structure.
For drivers what register multiple kinds of ports with different ops
this is not convenient.

This patchset changes does following changes:
1) Introduces devlink_port_ops with functions that allow devlink port
   to be registered passing a pointer to driver port ops. (patch #1)
2) Converts drivers to define port_ops and register ports passing the
   ops pointer. (patches #2, #3, #4, #6, #8, and #9)
3) Moves ops from devlink_ops struct to devlink_port_ops.
   (patches #5, #7, #10-15)

No functional changes.

---
v1->v2:
- see individual patches, there are 2 cosmetical changes basically:
    - fixed function names in kdoc comments
    - use dummy empty ops in case ops is null

Jiri Pirko (15):
  devlink: introduce port ops placeholder
  ice: register devlink port for PF with ops
  mlxsw_core: register devlink port with ops
  nfp: devlink: register devlink port with ops
  devlink: move port_split/unsplit() ops into devlink_port_ops
  mlx4: register devlink port with ops
  devlink: move port_type_set() op into devlink_port_ops
  sfc: register devlink port with ops
  mlx5: register devlink ports with ops
  devlink: move port_fn_hw_addr_get/set() to devlink_port_ops
  devlink: move port_fn_roce_get/set() to devlink_port_ops
  devlink: move port_fn_migratable_get/set() to devlink_port_ops
  devlink: move port_fn_state_get/set() to devlink_port_ops
  devlink: move port_del() to devlink_port_ops
  devlink: save devlink_port_ops into a variable in
    devlink_port_function_validate()

 drivers/net/ethernet/intel/ice/ice_devlink.c  |  10 +-
 drivers/net/ethernet/mellanox/mlx4/main.c     |  58 ++---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   9 -
 .../mellanox/mlx5/core/esw/devlink_port.c     |  29 ++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  12 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  12 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  10 +-
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  10 +-
 drivers/net/ethernet/sfc/efx_devlink.c        |  80 +++---
 include/net/devlink.h                         | 228 +++++++++---------
 net/devlink/leftover.c                        | 119 +++++----
 11 files changed, 298 insertions(+), 279 deletions(-)

-- 
2.39.2


