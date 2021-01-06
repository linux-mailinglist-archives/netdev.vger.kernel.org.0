Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B47D2EC5ED
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 22:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbhAFV4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 16:56:55 -0500
Received: from mga07.intel.com ([134.134.136.100]:52550 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbhAFV4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 16:56:55 -0500
IronPort-SDR: b1yTFxgOWCHjL9Sw4rl08DliLKEZdUlzdz2JsM4/JcxEiowyTCIUwnhTAt33FpWeZavLk5i03l
 xfXrg0fKWbsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="241418415"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="241418415"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 13:55:59 -0800
IronPort-SDR: MkjkvqFNLTzefuxgE5OzvQaWvOA4DK1MvR2O8nQB8PzlzWsbCGZHq2S55FphjgURuqcqji6NX1
 MAtU96ToGvWA==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="361734668"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.56])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 13:55:58 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v1 0/2] GRO drop accounting
Date:   Wed,  6 Jan 2021 13:55:37 -0800
Message-Id: <20210106215539.2103688-1-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some accounting for when the stack drops a packet
that a driver tried to indicate with a gro* call. This
helps users track where packets might have disappeared
to and will show up in the netdevice stats that already
exist.

After that, remove the driver specific workaround
that was added to do the same, just scoped too small.

Jesse Brandeburg (2):
  net: core: count drops from GRO
  ice: remove GRO drop accounting

 drivers/net/ethernet/intel/ice/ice.h          | 1 -
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 1 -
 drivers/net/ethernet/intel/ice/ice_main.c     | 4 +---
 drivers/net/ethernet/intel/ice/ice_txrx.h     | 1 -
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 2 --
 net/core/dev.c                                | 2 ++
 6 files changed, 3 insertions(+), 8 deletions(-)

-- 
2.29.2

