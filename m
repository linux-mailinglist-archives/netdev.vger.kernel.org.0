Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E546390B42
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 23:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhEYVY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 17:24:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:35469 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232093AbhEYVYu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 17:24:50 -0400
IronPort-SDR: kI/vUqFzcSqExI5cHH87Fa3wOwfTOHW524XoxLpwKgsqvQdVzckrlrZeYeqsccesoa8bUKYhZf
 5d+p0H11S8Lw==
X-IronPort-AV: E=McAfee;i="6200,9189,9995"; a="202062415"
X-IronPort-AV: E=Sophos;i="5.82,329,1613462400"; 
   d="scan'208";a="202062415"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 14:23:19 -0700
IronPort-SDR: mFxQJoGDHiV09vBp2v0myBhQzUzQW+aPhU1GAX2dhVu+VPmV5fTtsjV/BjjMVpWOWQkJWn1y7d
 UC86THHhhxqg==
X-IronPort-AV: E=Sophos;i="5.82,329,1613462400"; 
   d="scan'208";a="546924971"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.216.142])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 14:23:19 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.01.org
Subject: [PATCH net 0/4] MPTCP fixes
Date:   Tue, 25 May 2021 14:23:09 -0700
Message-Id: <20210525212313.148142-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are a few fixes for the -net tree.

Patch 1 fixes an attempt to access a tcp-specific field that does not
exist in mptcp sockets.

Patches 2 and 3 remove warning/error log output that could be flooded.

Patch 4 performs more validation on address advertisement echo packets
to improve RFC 8684 compliance.

Davide Caratti (1):
  mptcp: validate 'id' when stopping the ADD_ADDR retransmit timer

Paolo Abeni (3):
  mptcp: avoid OOB access in setsockopt()
  mptcp: drop unconditional pr_warn on bad opt
  mptcp: avoid error message on infinite mapping

 net/mptcp/options.c    |  3 +--
 net/mptcp/pm_netlink.c |  8 ++++----
 net/mptcp/protocol.c   | 14 +++++++++++---
 net/mptcp/protocol.h   |  3 ++-
 net/mptcp/sockopt.c    |  4 ++--
 net/mptcp/subflow.c    |  1 -
 6 files changed, 20 insertions(+), 13 deletions(-)


base-commit: 8c42a49738f16af0061f9ae5c2f5a955f268d9e3
-- 
2.31.1

