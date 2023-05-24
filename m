Return-Path: <netdev+bounces-4966-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B55D70F613
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:18:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCEC71C20C94
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 415191800F;
	Wed, 24 May 2023 12:18:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3594317ABE
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:18:41 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F023139
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:39 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-96f0678de80so143163866b.3
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684930718; x=1687522718;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mwGN8D2k0D/k107g1NIng8aOXm/Wd2auDCp7JfReOfk=;
        b=30yUsvC9MNYnsqJubWHO6Yd1kRQ8vBt+D5wfoBfwpsU0i4BglAD+RLraU00N6xwgqf
         /QV+/aZ3zmzEHnbmPx17IYmT2VmzO0nlUUscdGBimD2t63VKNMui875IDk6akvwa5rwg
         VMkNblvofqI8csiduMK21wCcmQy+A2UmAO7/pZowvp5h8kCJUk7KXBWygiiLrABE8ZKU
         q/bgk+9NsBkcY3ybQuRWSlL/IxwSgt7rClgDH1yJ4zUmBPXP5LouuXKm7zw4fyW7ewoL
         eHaHWXaLvFEgBSwRKwOQZxyQEpjg39NVTKKj7ty0nS1TI8nOF81ezS/toM700YoHqQlM
         xvNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930718; x=1687522718;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mwGN8D2k0D/k107g1NIng8aOXm/Wd2auDCp7JfReOfk=;
        b=MJXltdrqoVRuQ7L9rr/lhjOFpwTJfngk9ksly0tMF5iNu9x0cGSihEX0uMSm+/cq8X
         xGYrRzqHU96GC0ygPK1MxxFOAYUPocxwQ+Ak56XdK+1qTHGacah4hHDPWcjphLiS66hm
         g9qYWUr0WZ2qvqXii8MMzuY0hM8wpYFPrEVTtd/J0RTFaFivKM7y6/hT3wSFJ+qwjLWh
         AVq152r7+MsUWDFNEDmFtNGtbgxSNBOsYw5npPyWT5BaTb7tyK8wEE8wlRsKDJsjcRq9
         vL6OiaCTutiLbN4oP9z2faoyV/wrRXJ3P3r/DyDZ/nYwAHPogheZ0PtUSJZvzy03wMWj
         MdaA==
X-Gm-Message-State: AC+VfDxq3JRN3vBRs3cGqXXuD8ees6wXypa1M7v5n/uvNyYZNggTVHF1
	XgSpxe4HfEktaLfH7yi0JFr0oRaGyVu09g8uU0siuw==
X-Google-Smtp-Source: ACHHUZ68ztUi7mI1wp045haasJgxAul0SQ3WsW0kUCMgOqolzppQKiJYv2hRnudh2PacNv+yMxdwnA==
X-Received: by 2002:a17:906:cc4d:b0:965:cc76:7716 with SMTP id mm13-20020a170906cc4d00b00965cc767716mr13634576ejb.76.1684930717984;
        Wed, 24 May 2023 05:18:37 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id gr6-20020a170906e2c600b009658264076asm5674122ejb.45.2023.05.24.05.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:18:37 -0700 (PDT)
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
Subject: [patch net-next 00/15] devlink: move port ops into separate structure
Date: Wed, 24 May 2023 14:18:21 +0200
Message-Id: <20230524121836.2070879-1-jiri@resnulli.us>
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
 net/devlink/leftover.c                        | 120 +++++----
 11 files changed, 298 insertions(+), 280 deletions(-)

-- 
2.39.2


