Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2524A9D4C
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376714AbiBDRCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:02:16 -0500
Received: from mga05.intel.com ([192.55.52.43]:55832 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237305AbiBDRCP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 12:02:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643994135; x=1675530135;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6ixRo/NQ0Ei6KcK8AP5vg8J7TMDT/N2UMeNznsS4RIQ=;
  b=CeWX3l+XIu9clR6Fm7aeg0hfGx3WigQf3PviaQPImyr0hqF+yuLeKwtW
   04r1V47y9kKjXupR8XOZr5wjauC013hgL9rf+tD43UoeARLF96ur+nWDt
   Q05wBbO0Ecsrx+998rJRceTTX2uQ6jcYENeOqRpFIxDcpHwfVeeQNACT2
   1E+/HW0eNwhsRdKtUhM+i+lH/peBg4al27wlxXFYttodoqUdxPTzuPYhj
   aNw7BwIIj9FpCFcBbAMwhrrXb+2tUDuYNOBNjtwBAcFsbIAC6EIec1KIN
   mSnHjBW4C85SP5wAOHF8nAdCfXIPPxSr1gX4vELcib08VVsD5LOtfSHMR
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="334795727"
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="334795727"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 09:01:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="677146953"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 04 Feb 2022 09:01:23 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 214H1MV5027661;
        Fri, 4 Feb 2022 17:01:22 GMT
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com
Subject: [PATCH iproute2-next v2 0/2] GTP support for ip link and tc flower
Date:   Fri,  4 Feb 2022 17:58:19 +0100
Message-Id: <20220204165821.12104-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series introduces GTP support to iproute2. Since this patch
series it is possible to create net devices of GTP type. Then, those
devices can be used in tc in order to offload GTP packets. New field
in tc flower (gtp_opts) can be used to match on QFI and PDU type.

Kernel changes:
https://lore.kernel.org/netdev/20220204164929.10356-1-marcin.szycik@linux.intel.com/T/#t

Wojciech Drewek (2):
  ip: GTP support in ip link
  f_flower: Implement gtp options support

 include/uapi/linux/if_link.h |   1 +
 include/uapi/linux/pkt_cls.h |  16 +++++
 ip/Makefile                  |   2 +-
 ip/iplink.c                  |   2 +-
 ip/iplink_gtp.c              | 123 +++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in        |  29 ++++++++-
 man/man8/tc-flower.8         |  10 +++
 tc/f_flower.c                | 113 ++++++++++++++++++++++++++++++++
 8 files changed, 293 insertions(+), 3 deletions(-)
 create mode 100644 ip/iplink_gtp.c

-- 
2.31.1

