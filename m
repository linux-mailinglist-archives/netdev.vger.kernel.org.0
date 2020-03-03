Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB85176E61
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgCCFGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:06:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:37692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbgCCFFo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:05:44 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13C1E24684;
        Tue,  3 Mar 2020 05:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583211944;
        bh=bcd3PrfS1mLDbSYUOH4wTbigxlAsQ9bAy+YS1/9YIh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/7jlOwDpBeE7aODkZU7wBIXmMNZ5n5HE63AWxYck3rD/j65n4r9PiE1LxlmDf8KI
         T3esJv6BGAx8jz6+F4UTMMIPmuiqIP06IRXj4HnZ/FGy7Euz2zZdF0GOUAkH53CI2o
         DlrcN0SBmXtCHGvZmWPU5VaBnNKtwLTUmHE1W5+4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net 09/16] net: fq: add missing attribute validation for orphan mask
Date:   Mon,  2 Mar 2020 21:05:19 -0800
Message-Id: <20200303050526.4088735-10-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050526.4088735-1-kuba@kernel.org>
References: <20200303050526.4088735-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing attribute validation for TCA_FQ_ORPHAN_MASK
to the netlink policy.

Fixes: 06eb395fa985 ("pkt_sched: fq: better control of DDOS traffic")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Jamal Hadi Salim <jhs@mojatatu.com>
CC: Cong Wang <xiyou.wangcong@gmail.com>
CC: Jiri Pirko <jiri@resnulli.us>
CC: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_fq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index a5a295477ecc..371ad84def3b 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -744,6 +744,7 @@ static const struct nla_policy fq_policy[TCA_FQ_MAX + 1] = {
 	[TCA_FQ_FLOW_MAX_RATE]		= { .type = NLA_U32 },
 	[TCA_FQ_BUCKETS_LOG]		= { .type = NLA_U32 },
 	[TCA_FQ_FLOW_REFILL_DELAY]	= { .type = NLA_U32 },
+	[TCA_FQ_ORPHAN_MASK]		= { .type = NLA_U32 },
 	[TCA_FQ_LOW_RATE_THRESHOLD]	= { .type = NLA_U32 },
 	[TCA_FQ_CE_THRESHOLD]		= { .type = NLA_U32 },
 };
-- 
2.24.1

