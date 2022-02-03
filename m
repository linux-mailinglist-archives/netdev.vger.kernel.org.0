Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEDE4A8ED7
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355180AbiBCUjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355153AbiBCUhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:37:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED99C06178C;
        Thu,  3 Feb 2022 12:35:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBE15B835B1;
        Thu,  3 Feb 2022 20:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B83C340EF;
        Thu,  3 Feb 2022 20:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920504;
        bh=UAB7gaH3NgMrAcDUBNS5Abh/HcDIdCVCCYEvBt09frA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/7xE2Y9Fthr5dBoIzh8HMs2XpuQwpJT27N/27gcSksMlvW0U2z6oGeIkIJmpemBb
         +/33rEG6e7dOAS5kRwBsCtvyXR885mAEvv+uN0z0FvgfKlW38vHYt+HTYDT3USZ+pT
         ODka3aJ7fqHIHV1cgnjV2w6JltH9XkgT7am4TLlaHNHvpRvAEQenXq0+KVmGK5SsMG
         xna5hSujy1NSXGORY11Gmr9pIG9HKwYYtOb22k+KXkQpJg/sofEm7WmCfaIhACAMkg
         5euOzWWa2Oigrdrw9HN/oOh4vKhxs+GYcPckDvmGahijObVglFmV1T28ICLWgoLZxM
         pi50wo+aBXErg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Victor Nogueira <victor@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/25] net: sched: Clarify error message when qdisc kind is unknown
Date:   Thu,  3 Feb 2022 15:34:32 -0500
Message-Id: <20220203203447.3570-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203447.3570-1-sashal@kernel.org>
References: <20220203203447.3570-1-sashal@kernel.org>
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
index 7b24582a8a164..6758968e79327 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1204,7 +1204,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 
 	err = -ENOENT;
 	if (!ops) {
-		NL_SET_ERR_MSG(extack, "Specified qdisc not found");
+		NL_SET_ERR_MSG(extack, "Specified qdisc kind is unknown");
 		goto err_out;
 	}
 
-- 
2.34.1

