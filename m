Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7053AD4BB
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 00:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhFRWEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 18:04:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:53160 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhFRWEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 18:04:37 -0400
IronPort-SDR: K5eLhh0S32rKsguu4Ccv6HQawEg6YN2cd/o3q8vWPPwXp8QkfAL2tKneJEGL6x8MOP+Gjano/K
 PWP9YHJi1Djw==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="292256526"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="292256526"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 15:02:27 -0700
IronPort-SDR: 4WFkcJdwGK6DVtjWfn6+gT/9T+4jLO4fPp8ADa2xti5f7NMN2jvYukKtJz6w/V09kDG2vDFspZ
 NdtWrga65mBA==
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="443703681"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.26.218])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 15:02:27 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com, fw@strlen.de
Subject: [PATCH net 0/2] mptcp: 32-bit sequence number improvements
Date:   Fri, 18 Jun 2021 15:02:19 -0700
Message-Id: <20210618220221.99172-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MPTCP-level sequence numbers are 64 bits, but RFC 8684 allows use of
32-bit sequence numbers in the DSS option to save header space. Those
32-bit numbers are the least significant bits of the full 64-bit
sequence number, so the receiver must infer the correct upper 32 bits.

These two patches improve the logic for determining the full 64-bit
sequence numbers when the 32-bit truncated version has wrapped around.

Paolo Abeni (2):
  mptcp: fix bad handling of 32 bit ack wrap-around
  mptcp: fix 32 bit DSN expansion

 net/mptcp/options.c  | 29 +++++++++++++++--------------
 net/mptcp/protocol.h |  8 ++++++++
 net/mptcp/subflow.c  | 17 +----------------
 3 files changed, 24 insertions(+), 30 deletions(-)


base-commit: 9cca0c2d70149160407bda9a9446ce0c29b6e6c6
-- 
2.32.0

