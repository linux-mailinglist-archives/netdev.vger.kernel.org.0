Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827634794C8
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 20:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240657AbhLQTcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 14:32:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:11893 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236806AbhLQTcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 14:32:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639769535; x=1671305535;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Pi8h12IJp5AE4bDHDl0qXaJW262s7CUCnwSucE0hipE=;
  b=Q2stVNxXj0lgapEUBoYb+IbwjQcsgaDy8lZNOjVS5E8GQIqUeF0KuNXQ
   MX/+9OV+o2qAUDlEgm2xkjitrGVMUZVAAUsJvDb1X/Pp4XU5IYKIsYJxj
   0f/ped5vMYNzNkHCod3WPyxPhjREB2p2ptkY2GbDx4S7vprdwGybxGDxg
   a8t+cADskOFm1pEVDzMfkRj7tyme4XQoPOGz5JZQAsLYZQTJmfcVcdCZV
   U2eRL35Q2RweZL92y6OcLJao0sC3jqM82ZqGmzz62w9zga1sIonRXMoeJ
   LpNbK/nsCkm6Gv3ywHK3KAo/CCbRoogoPh0g+UP8QjYIPbUTVCthbLjL0
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="263998118"
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="263998118"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 11:32:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="754659443"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 17 Dec 2021 11:32:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Subject: [PATCH net 0/6][pull request] Intel Wired LAN Driver Updates 2021-12-17
Date:   Fri, 17 Dec 2021 11:31:08 -0800
Message-Id: <20211217193114.392106-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski says:

It seems that previous [0] Rx fix was not enough and there are still
issues with AF_XDP Rx ZC support in ice driver. Elza reported that for
multiple XSK sockets configured on a single netdev, some of them were
becoming dead after a while. We have spotted more things that needed to
be addressed this time. More of information can be found in particular
commit messages.

It also carries Alexandr's patch that was sent previously which was
overlapping with this set.

[0]: https://lore.kernel.org/bpf/20211129231746.2767739-1-anthony.l.nguyen@intel.com/

The following are changes since commit 8ca4090fec0217bcb89531c8be80fcfa66a397a1:
  Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Alexander Lobakin (1):
  ice: remove dead store on XSK hotpath

Maciej Fijalkowski (5):
  ice: xsk: return xsk buffers back to pool when cleaning the ring
  ice: xsk: allocate separate memory for XDP SW ring
  ice: xsk: do not clear status_error0 for ntu + nb_buffs descriptor
  ice: xsk: allow empty Rx descriptors on XSK ZC data path
  ice: xsk: fix cleaned_count setting

 drivers/net/ethernet/intel/ice/ice_base.c | 17 ++++++
 drivers/net/ethernet/intel/ice/ice_txrx.c | 19 ++++---
 drivers/net/ethernet/intel/ice/ice_txrx.h |  1 -
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 66 +++++++++++------------
 4 files changed, 62 insertions(+), 41 deletions(-)

-- 
2.31.1

