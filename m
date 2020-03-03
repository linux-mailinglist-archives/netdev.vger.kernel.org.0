Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E340176E60
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbgCCFF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:05:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgCCFFp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:05:45 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8786024654;
        Tue,  3 Mar 2020 05:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583211944;
        bh=2Y94fvzeCJu+HsaBPJuP3GW7NoFkmYczeAvkglyb6yM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMSvu085+vKXvpkKz/YO2IN7JZPG6xWdzMwnLbCBq4w49AWxqsefKFNAhfhc601Mk
         tvjyQTiDbd1OHnlFgGChPTPgle5fmiHf/Dmunr0SA8NsvjZ4hNLow0CN/MAfiOORW0
         to0BuEUFpRth27xvIvfoQ9aLXtu2AbbbdGyFpBEM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vedang Patel <vedang.patel@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH net 10/16] net: taprio: add missing attribute validation for txtime delay
Date:   Mon,  2 Mar 2020 21:05:20 -0800
Message-Id: <20200303050526.4088735-11-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050526.4088735-1-kuba@kernel.org>
References: <20200303050526.4088735-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing attribute validation for TCA_TAPRIO_ATTR_TXTIME_DELAY
to the netlink policy.

Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Jamal Hadi Salim <jhs@mojatatu.com>
CC: Cong Wang <xiyou.wangcong@gmail.com>
CC: Jiri Pirko <jiri@resnulli.us>
CC: Vedang Patel <vedang.patel@intel.com>
CC: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_taprio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 660fc45ee40f..ee717e05372b 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -768,6 +768,7 @@ static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]           = { .type = NLA_S64 },
 	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION] = { .type = NLA_S64 },
 	[TCA_TAPRIO_ATTR_FLAGS]                      = { .type = NLA_U32 },
+	[TCA_TAPRIO_ATTR_TXTIME_DELAY]		     = { .type = NLA_U32 },
 };
 
 static int fill_sched_entry(struct nlattr **tb, struct sched_entry *entry,
-- 
2.24.1

