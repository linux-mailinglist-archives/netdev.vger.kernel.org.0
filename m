Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18DB3174388
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 00:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgB1Xr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 18:47:56 -0500
Received: from mga14.intel.com ([192.55.52.115]:3767 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgB1Xr4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 18:47:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Feb 2020 15:47:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,497,1574150400"; 
   d="scan'208";a="351031530"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.18.184])
  by fmsmga001.fm.intel.com with ESMTP; 28 Feb 2020 15:47:55 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 0/3] mptcp: Improve DATA_FIN transmission
Date:   Fri, 28 Feb 2020 15:47:38 -0800
Message-Id: <20200228234741.57086-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MPTCP's DATA_FIN flag is sent in a DSS option when closing the
MPTCP-level connection. This patch series prepares for correct DATA_FIN
handling across multiple subflows (where individual subflows may
disconnect without closing the entire MPTCP connection) by changing the
way the MPTCP-level socket requests a DATA_FIN on a subflow and
propagates the necessary data for the TCP option.


Mat Martineau (3):
  mptcp: Check connection state before attempting send
  mptcp: Use per-subflow storage for DATA_FIN sequence number
  mptcp: Only send DATA_FIN with final mapping

 net/mptcp/options.c  | 16 ++++++++--------
 net/mptcp/protocol.c | 32 +++++++++++++++++++++++++++-----
 net/mptcp/protocol.h |  2 ++
 3 files changed, 37 insertions(+), 13 deletions(-)


base-commit: e955376277839db92774ec24d559ab42442b95fc
-- 
2.25.1

