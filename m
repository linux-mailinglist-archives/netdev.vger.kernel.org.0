Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93CA61F709D
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgFKWvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:51:02 -0400
Received: from mga18.intel.com ([134.134.136.126]:54985 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgFKWvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:51:02 -0400
IronPort-SDR: pw/PGr5hxzfHtfzBZS1PiRsPpMjMSKeFg8UHeYLMcyBhysaI/ZrcP9EXZTkdnRcKcSc3UzEUIF
 spP/U+7dIw/g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 15:51:02 -0700
IronPort-SDR: jxzrOKz6uhziRbGiOjLZQGAjeB87KR54ONBgYGy72ZxFwDnE/ZXxOssW/M23E1tgUOwAX9rbdT
 n0NdwXfN2T9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,501,1583222400"; 
   d="scan'208";a="296755882"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 11 Jun 2020 15:51:01 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net 0/4][pull request] Intel Wired LAN Driver Updates 2020-06-11
Date:   Thu, 11 Jun 2020 15:50:56 -0700
Message-Id: <20200611225100.326062-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains fixes to the iavf driver.

Brett fixes the supported link speeds in the iavf driver, which was only
able to report speeds that the i40e driver supported and was missing the
speeds supported by the ice driver.  In addition, fix how 2.5 and 5.0
GbE speeds are reported.

Alek fixes a enum comparison that was comparing two different enums that
may have different values, so update the comparison to use matching
enums.

Paul increases the time to complete a reset to allow for 128 VFs to
complete a reset.

The following are changes since commit 9798278260e8f61d04415342544a8f701bc5ace7:
  tipc: fix NULL pointer dereference in tipc_disc_rcv()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 40GbE

Aleksandr Loktionov (1):
  iavf: use appropriate enum for comparison

Brett Creeley (2):
  iavf: fix speed reporting over virtchnl
  iavf: Fix reporting 2.5 Gb and 5Gb speeds

Paul Greenwalt (1):
  iavf: increase reset complete wait time

 drivers/net/ethernet/intel/iavf/iavf.h        |  18 +++
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  37 +++---
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  67 ++++++-----
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  12 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 106 +++++++++++++++---
 5 files changed, 177 insertions(+), 63 deletions(-)

-- 
2.26.2

