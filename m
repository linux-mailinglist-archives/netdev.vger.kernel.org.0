Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53A65B49B1
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 23:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiIJVWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 17:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbiIJVVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 17:21:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBB04C63C;
        Sat, 10 Sep 2022 14:18:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B725DB8085B;
        Sat, 10 Sep 2022 21:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DB4C43140;
        Sat, 10 Sep 2022 21:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844708;
        bh=yxmTmAmQYOY0Y1XhFJJ91Ijes9f9h/iULVvKrO+XC0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZNvClECkgoPw56Ag4x1W63O7VVpYBQuR6WXoYttwokg7u1Xi5F/BuewHRvevyRSF
         MEZtmPZK8nFGsXn75cesda/b+dyBWZ2NT7H1ge+gkZrj6/tOnPULdav6uWCYN+3cDf
         44yPJWsZLMHs8sxm7Fp2TR3w5CZuj1qceDUWNz0Uax6c9V3jXo3yeMfz777rUI0gWe
         rCrwJ+KTX5Eua4DHakNfOfCPEW9TVGs5F2798HwDth9rzxiKAdW189zdK9ZYAQZKTg
         2Bha35NU7o0lMj+uhlCI1T9I2+cf8GftIv5KDphRtPOljV9FJ+nKVMiWgfMPcewsG0
         GyRjvhCXwmbaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 18/21] net: dsa: hellcreek: Print warning only once
Date:   Sat, 10 Sep 2022 17:17:49 -0400
Message-Id: <20220910211752.70291-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211752.70291-1-sashal@kernel.org>
References: <20220910211752.70291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit 52267ce25f60f37ae40ccbca0b21328ebae5ae75 ]

In case the source port cannot be decoded, print the warning only once. This
still brings attention to the user and does not spam the logs at the same time.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20220830163448.8921-1-kurt@linutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_hellcreek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index eb204ad36eeec..846588c0070a5 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -45,7 +45,7 @@ static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
 
 	skb->dev = dsa_master_find_slave(dev, 0, port);
 	if (!skb->dev) {
-		netdev_warn(dev, "Failed to get source port: %d\n", port);
+		netdev_warn_once(dev, "Failed to get source port: %d\n", port);
 		return NULL;
 	}
 
-- 
2.35.1

