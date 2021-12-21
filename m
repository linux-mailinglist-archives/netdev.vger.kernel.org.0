Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32EB47C9F8
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 00:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238404AbhLUX6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 18:58:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:33887 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233952AbhLUX6y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 18:58:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640131134; x=1671667134;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1+wbyIlwB3zHUMy9SEZ74ClAM6/wZtRyXRl3v13q/IQ=;
  b=AOyRui4q2m6EhJhri3yLZ/NSBlQFlWe6UY9tY3OfnyF3iaRy8z2OWlA3
   3r/Wv8HKVpwXO+YNXOomq9PMODZejwPglplW9GkPZlPY/sLhe0oI82GJ7
   6kn0MZmZHAXeZpZk9GC4BnzMezkvBOcyOWmdqMORyMCEVx7UnH1sBoA9Q
   xbkK5G16SxhAgAIqSVPMaTfesXcAhXiXOkwmzqztLJiyj4PQM1i30y+2k
   yu6hFGM+KBwdJvKzNnc5xUIRmO8LM5uWXKKPCg/WJykXn5ifAB/Yi9mju
   Nv2wrnGCsKyqySfBncBwjelugT3sy6faoe0IQDeukAGgTRjrFH4NfL7ow
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="227808271"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="227808271"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 15:58:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="607226428"
Received: from linux.intel.com ([10.54.29.200])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Dec 2021 15:58:53 -0800
Received: from debox1-desk4.intel.com (unknown [10.209.90.33])
        by linux.intel.com (Postfix) with ESMTP id 70ECD5807C5;
        Tue, 21 Dec 2021 15:58:52 -0800 (PST)
From:   "David E. Box" <david.e.box@linux.intel.com>
To:     gregkh@linuxfoundation.org, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, dledford@redhat.com, jgg@ziepe.ca,
        leon@kernel.org, saeedm@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, vkoul@kernel.org, yung-chuan.liao@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, mst@redhat.com,
        jasowang@redhat.com
Cc:     "David E. Box" <david.e.box@linux.intel.com>,
        andriy.shevchenko@linux.intel.com, hdegoede@redhat.com,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH 0/4] driver_core: Auxiliary drvdata helper cleanup
Date:   Tue, 21 Dec 2021 15:58:48 -0800
Message-Id: <20211221235852.323752-1-david.e.box@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depends on "driver core: auxiliary bus: Add driver data helpers" patch [1].
Applies the helpers to all auxiliary device drivers using
dev_(get/set)_drvdata. Drivers were found using the following search:

    grep -lr "struct auxiliary_device" $(grep -lr "drvdata" .)

Changes were build tested using the following configs:

    vdpa/mlx5:       CONFIG_MLX5_VDPA_NET
    net/mlx53:       CONFIG_MLX5_CORE_EN
    soundwire/intel: CONFIG_SOUNDWIRE_INTEL
    RDAM/irdma:      CONFIG_INFINIBAND_IRDMA
                     CONFIG_MLX5_INFINIBAND

[1] https://www.spinics.net/lists/platform-driver-x86/msg29940.html 

David E. Box (4):
  RDMA/irdma: Use auxiliary_device driver data helpers
  soundwire: intel: Use auxiliary_device driver data helpers
  net/mlx5e: Use auxiliary_device driver data helpers
  vdpa/mlx5: Use auxiliary_device driver data helpers

 drivers/infiniband/hw/irdma/main.c                | 4 ++--
 drivers/infiniband/hw/mlx5/main.c                 | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 8 ++++----
 drivers/soundwire/intel.c                         | 8 ++++----
 drivers/soundwire/intel_init.c                    | 2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                 | 4 ++--
 6 files changed, 17 insertions(+), 17 deletions(-)

-- 
2.25.1

