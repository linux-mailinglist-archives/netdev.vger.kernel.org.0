Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC0549D25C
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244406AbiAZTLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244378AbiAZTLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:11:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CE3C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:11:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4FD1B81FB3
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 19:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1A9C340E9;
        Wed, 26 Jan 2022 19:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643224278;
        bh=u96WqGUWejMt+HF3JSFCxDZOvYJhbzCGXJF+1egAMA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNrH9fR5lySPxn6ZZMZTF8HHN445bYtYNUCgBW4c7wKSZtmgdnpQDByp23c8jLh05
         2JD7IapnulQuu+bKgQD6DGTjyzGYhT3XAw+e2HELLhBzfuuC4XmdMRKnt7pl8X+C2b
         PQvrDmf8Nwv+PNGDnYx0b0yDp5OKgOZiYzRDinNlQPjwrguuiHwhnIoLAQmBpZtfhS
         LcOn/oJPfpJxOoqadhS/M9pS9hpzblYdwCuhSTAg7Kv4+tVGIXOZ73JJEPMrpN3udJ
         uQmTnuUKDdGaS53V5z5eDtH/YYPX8X4J+fRv9k9kVjS02crm1oA9mkaAjb4RDiQgK2
         9MPFc7SBacH0A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 14/15] net: sched: remove qdisc_qlen_cpu()
Date:   Wed, 26 Jan 2022 11:11:08 -0800
Message-Id: <20220126191109.2822706-15-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126191109.2822706-1-kuba@kernel.org>
References: <20220126191109.2822706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Never used since it was added in v5.2.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/sch_generic.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 472843eedbae..9bab396c1f3b 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -518,11 +518,6 @@ static inline void qdisc_cb_private_validate(const struct sk_buff *skb, int sz)
 	BUILD_BUG_ON(sizeof(qcb->data) < sz);
 }
 
-static inline int qdisc_qlen_cpu(const struct Qdisc *q)
-{
-	return this_cpu_ptr(q->cpu_qstats)->qlen;
-}
-
 static inline int qdisc_qlen(const struct Qdisc *q)
 {
 	return q->q.qlen;
-- 
2.34.1

