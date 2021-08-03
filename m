Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE3C3DF33B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237434AbhHCQw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:52:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:30450 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237436AbhHCQwN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:52:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="200924730"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="200924730"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:51:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="521321090"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 03 Aug 2021 09:51:47 -0700
Received: from alobakin-mobl.ger.corp.intel.com (mszymcza-mobl.ger.corp.intel.com [10.213.25.231])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173Gpg76004325;
        Tue, 3 Aug 2021 17:51:42 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH ethtool-next 0/5] stats: add support for per-channel and XDP standard stats
Date:   Tue,  3 Aug 2021 18:51:35 +0200
Message-Id: <20210803165140.172-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds bits to support per-channel standard statistics,
mentions the new "xdp" group of standard stats landed in Linux with
commit 44eee6116fda ("ethtool, stats: introduce standard XDP statistics")
and fixes one typo in the man page while at it.

The original series for the kernel part is here: [0]

[0] https://lore.kernel.org/netdev/20210803163641.3743-1-alexandr.lobakin@intel.com

Alexander Lobakin (5):
  sync UAPI header copies
  stats: factor out one stat field printing
  stats: add support for per-channel statistics [blocks]
  man: fix typo for "rmon" standard stat type
  man: mention XDP standard statistics in help and man page

 ethtool.8.in                 |   5 +-
 ethtool.c                    |   2 +-
 netlink/stats.c              | 114 +++++++++++++++++++++++++++++------
 uapi/linux/ethtool.h         |   6 +-
 uapi/linux/ethtool_netlink.h |  51 +++++++++++++++-
 uapi/linux/if_link.h         |  20 ++++++
 uapi/linux/net_tstamp.h      |  17 +++++-
 uapi/linux/netlink.h         |   5 +-
 8 files changed, 190 insertions(+), 30 deletions(-)

-- 
2.31.1

