Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96CBF4A8F09
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbiBCUmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355463AbiBCUim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:38:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0CCC061714;
        Thu,  3 Feb 2022 12:36:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D380B835A3;
        Thu,  3 Feb 2022 20:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3A5C340EF;
        Thu,  3 Feb 2022 20:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920559;
        bh=vJ41Kp7L4JmG3aLVkOGChqm6yVs8a5DCHjL5ArIC62Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PlU0JYT6tF4RN98t49+74x6csDmdwAWZ8HS6UhpdFsgosiJzHi9SAsgiPX21uB0B7
         xZH3lIc8UTRfBfGEjZaRH3Fp8/66MDDgqPHMJOrbh5MPrpCm0iGBuPjAgF4BxSVWAv
         q8gIGkZnZjngCERH7KJoCu81KE9+mrNXYB0KRdeQI8VM+cNMOhrvge9O+T/y03FDQ3
         JlAqylty2eAU3+GXLNPBR4KZKN7jH4q2FsFIf0RA/JV9rRzAEwt1nLWSepmPUmwXkB
         OQDTBLdnFFxhRL8GwKvm8QHD06ui/v0z/NZVvgu4GAdhswqjbplfTkmuq+p9yo++Tf
         +fbE/y6ktr/5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Victor Nogueira <victor@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/15] net: sched: Clarify error message when qdisc kind is unknown
Date:   Thu,  3 Feb 2022 15:35:38 -0500
Message-Id: <20220203203545.3879-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203545.3879-1-sashal@kernel.org>
References: <20220203203545.3879-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 973bf8fdd12f0e70ea351c018e68edd377a836d1 ]

When adding a tc rule with a qdisc kind that is not supported or not
compiled into the kernel, the kernel emits the following error: "Error:
Specified qdisc not found.". Found via tdc testing when ETS qdisc was not
compiled in and it was not obvious right away what the message meant
without looking at the kernel code.

Change the error message to be more explicit and say the qdisc kind is
unknown.

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index e70f990334083..6f36df85d23d8 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1195,7 +1195,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 
 	err = -ENOENT;
 	if (!ops) {
-		NL_SET_ERR_MSG(extack, "Specified qdisc not found");
+		NL_SET_ERR_MSG(extack, "Specified qdisc kind is unknown");
 		goto err_out;
 	}
 
-- 
2.34.1

