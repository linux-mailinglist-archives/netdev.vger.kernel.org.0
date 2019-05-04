Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBBE1398B
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfEDLrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:47:16 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42648 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727542AbfEDLrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:47:13 -0400
Received: by mail-qt1-f193.google.com with SMTP id p20so9701298qtc.9
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 04:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kzXsQ+5WljuJBE9IignS58GdcVhDPX9yFONSkbXrR0w=;
        b=LqVZpGU/ujYjjqVzEAnsAt40adRjIcGz6i94CKUAtPyl1+MA/hDd/Ja13KUdEwjUkH
         6UXmgCUK4HnMFruOAQo05Yk4iCASndWPyiYTHf5/JYJfBPYWvl7OVem0pBtdv01WyOI6
         0pUpyKvDtRbiJg7FFle3l7QRvDE5UYix19yCRhjdFGnEogwhd8aE+gGx/u6xXmg9DxRE
         q7tAGbFslSHlXBrkBIX3bg/tx3P0gTuITVq2Jo5LpF90Wd/36IiiCuBd9glAn8XC6JO9
         soWVx0puDcTzp8ijV75f51ZsXO+vSnPe4P1jeAWnTkn9KtUrIddz4Cqm/XAnWnDVZCgW
         A2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kzXsQ+5WljuJBE9IignS58GdcVhDPX9yFONSkbXrR0w=;
        b=eCDQv2U+NgQE1GIwMID8PxdEsQckkfP+IBjaR3K5zOWg1CeUoXRqUggaxxoZwmxRBu
         cvt/Rftxr/2WiM9lBUGMN80/cO5Y/fFxGdYmX5vImGMkGAeC+jGlcxyuBveTogsfbTHk
         8PCCBmfabO+sm5YZwSOUEk6uxbv1kR2n2c1LGyT1wNcUXVHlnHcD0rPPEEJtFwHysmuM
         TKkVBG0O4ZM3nBx0gAUA006xtN/TY1fTykLXnqIdEAcbUsoEnr05BYn0IW/yAYaOGF5A
         ygiebDU3AX66FZQO/0DZu5NzBR4BRR0YKVSnICddXcCs2vEBOIJZN8wRe6LYmg+THpgr
         TZrw==
X-Gm-Message-State: APjAAAWB3yV8FHu4kkEfuzsFYDKmXU8YF59A0KI11t07avvRyXAIji6E
        Ov2kImlO5XnnHggZFRfrwntbrA==
X-Google-Smtp-Source: APXvYqyFZnA/RXBOYw/0c2zKB9UXLhADfMIl/Rl8zBt2wV8rlf0H/CbNVfSYhwyTlRT3jZbYeFsNfg==
X-Received: by 2002:ac8:341b:: with SMTP id u27mr7180712qtb.246.1556970432454;
        Sat, 04 May 2019 04:47:12 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g19sm2847276qkk.17.2019.05.04.04.47.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 04:47:11 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        gerlitz.or@gmail.com, simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 06/13] net/sched: move police action structures to header
Date:   Sat,  4 May 2019 04:46:21 -0700
Message-Id: <20190504114628.14755-7-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504114628.14755-1-jakub.kicinski@netronome.com>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Move tcf_police_params, tcf_police and tc_police_compat structures to a
header. Making them usable to other code for example drivers that would
offload police actions to hardware.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/tc_act/tc_police.h | 70 ++++++++++++++++++++++++++++++++++
 net/sched/act_police.c         | 37 +-----------------
 2 files changed, 71 insertions(+), 36 deletions(-)
 create mode 100644 include/net/tc_act/tc_police.h

diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
new file mode 100644
index 000000000000..8b9ef3664262
--- /dev/null
+++ b/include/net/tc_act/tc_police.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_TC_POLICE_H
+#define __NET_TC_POLICE_H
+
+#include <net/act_api.h>
+
+struct tcf_police_params {
+	int			tcfp_result;
+	u32			tcfp_ewma_rate;
+	s64			tcfp_burst;
+	u32			tcfp_mtu;
+	s64			tcfp_mtu_ptoks;
+	struct psched_ratecfg	rate;
+	bool			rate_present;
+	struct psched_ratecfg	peak;
+	bool			peak_present;
+	struct rcu_head rcu;
+};
+
+struct tcf_police {
+	struct tc_action	common;
+	struct tcf_police_params __rcu *params;
+
+	spinlock_t		tcfp_lock ____cacheline_aligned_in_smp;
+	s64			tcfp_toks;
+	s64			tcfp_ptoks;
+	s64			tcfp_t_c;
+};
+
+#define to_police(pc) ((struct tcf_police *)pc)
+
+/* old policer structure from before tc actions */
+struct tc_police_compat {
+	u32			index;
+	int			action;
+	u32			limit;
+	u32			burst;
+	u32			mtu;
+	struct tc_ratespec	rate;
+	struct tc_ratespec	peakrate;
+};
+
+static inline bool is_tcf_police(const struct tc_action *act)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	if (act->ops && act->ops->id == TCA_ID_POLICE)
+		return true;
+#endif
+	return false;
+}
+
+static inline u64 tcf_police_rate_bytes_ps(const struct tc_action *act)
+{
+	struct tcf_police *police = to_police(act);
+	struct tcf_police_params *params;
+
+	params = rcu_dereference_bh(police->params);
+	return params->rate.rate_bytes_ps;
+}
+
+static inline s64 tcf_police_tcfp_burst(const struct tc_action *act)
+{
+	struct tcf_police *police = to_police(act);
+	struct tcf_police_params *params;
+
+	params = rcu_dereference_bh(police->params);
+	return params->tcfp_burst;
+}
+
+#endif /* __NET_TC_POLICE_H */
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index b48e40c69ad0..e33bcab75d1f 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -22,42 +22,7 @@
 #include <net/act_api.h>
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
-
-struct tcf_police_params {
-	int			tcfp_result;
-	u32			tcfp_ewma_rate;
-	s64			tcfp_burst;
-	u32			tcfp_mtu;
-	s64			tcfp_mtu_ptoks;
-	struct psched_ratecfg	rate;
-	bool			rate_present;
-	struct psched_ratecfg	peak;
-	bool			peak_present;
-	struct rcu_head rcu;
-};
-
-struct tcf_police {
-	struct tc_action	common;
-	struct tcf_police_params __rcu *params;
-
-	spinlock_t		tcfp_lock ____cacheline_aligned_in_smp;
-	s64			tcfp_toks;
-	s64			tcfp_ptoks;
-	s64			tcfp_t_c;
-};
-
-#define to_police(pc) ((struct tcf_police *)pc)
-
-/* old policer structure from before tc actions */
-struct tc_police_compat {
-	u32			index;
-	int			action;
-	u32			limit;
-	u32			burst;
-	u32			mtu;
-	struct tc_ratespec	rate;
-	struct tc_ratespec	peakrate;
-};
+#include <net/tc_act/tc_police.h>
 
 /* Each policer is serialized by its individual spinlock */
 
-- 
2.21.0

