Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6015D55A9C
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfFYWH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:07:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:34253 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfFYWH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 18:07:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jun 2019 15:07:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,417,1557212400"; 
   d="scan'208";a="172511944"
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga002.jf.intel.com with ESMTP; 25 Jun 2019 15:07:27 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org, jakub.kicinski@netronome.com, m-karicheri2@ti.com,
        sergei.shtylyov@cogentembedded.com, eric.dumazet@gmail.com,
        aaron.f.brown@intel.com, Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH net-next v6 2/8] etf: Don't use BIT() in UAPI headers.
Date:   Tue, 25 Jun 2019 15:07:13 -0700
Message-Id: <1561500439-30276-3-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1561500439-30276-1-git-send-email-vedang.patel@intel.com>
References: <1561500439-30276-1-git-send-email-vedang.patel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BIT() macro isn't exported as part of the UAPI interface. So, the
compile-test to ensure they are self contained fails. So, use _BITUL()
instead.

Signed-off-by: Vedang Patel <vedang.patel@intel.com>
---
 include/uapi/linux/pkt_sched.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 8b2f993cbb77..f88c4e0bd9e5 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -988,8 +988,8 @@ struct tc_etf_qopt {
 	__s32 delta;
 	__s32 clockid;
 	__u32 flags;
-#define TC_ETF_DEADLINE_MODE_ON	BIT(0)
-#define TC_ETF_OFFLOAD_ON	BIT(1)
+#define TC_ETF_DEADLINE_MODE_ON	_BITUL(0)
+#define TC_ETF_OFFLOAD_ON	_BITUL(1)
 };
 
 enum {
-- 
2.7.3

