Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B934CAA9C
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243148AbiCBQkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiCBQks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:40:48 -0500
Received: from simonwunderlich.de (simonwunderlich.de [23.88.38.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEFACF38F
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:40:03 -0800 (PST)
Received: from kero.packetmixer.de (p200300C597470fC0D439FBe5c3508408.dip0.t-ipconnect.de [IPv6:2003:c5:9747:fc0:d439:fbe5:c350:8408])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id D7F6CFA1EB;
        Wed,  2 Mar 2022 17:30:51 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/3] pull request for net: batman-adv 2022-03-02
Date:   Wed,  2 Mar 2022 17:30:46 +0100
Message-Id: <20220302163049.101957-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

here are some bugfixes for batman-adv which we would like to have integrated into net.

Please pull or let me know of any problem!

There might be a small merge conflict between the net and net-next pull
requests which I both send today, specifically those two commits:

* (batadv/net) 690bb6fb64f5 ("batman-adv: Request iflink once in batadv-on-batadv check")
* (batadv/net-next) 6ee3c393eeb7 ("batman-adv: Demote batadv-on-batadv skip error message")

They should be resolved like this: 

--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -167,13 +167,7 @@
 		return false;
 
 	/* recurse over the parent device */
-<<<<<<<
-	parent_dev = __dev_get_by_index((struct net *)parent_net,
-					dev_get_iflink(net_dev));
-=======
 	parent_dev = __dev_get_by_index((struct net *)parent_net, iflink);
-	/* if we got a NULL parent_dev there is something broken.. */
->>>>>>>
 	if (!parent_dev) {
 		pr_warn("Cannot find parent device. Skipping batadv-on-batadv check for %s\n",
 			net_dev->name);

Thank you,
      Simon

The following changes since commit e783362eb54cd99b2cac8b3a9aeac942e6f6ac07:

  Linux 5.17-rc1 (2022-01-23 10:12:53 +0200)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-pullrequest-20220302

for you to fetch changes up to 6c1f41afc1dbe59d9d3c8bb0d80b749c119aa334:

  batman-adv: Don't expect inter-netns unique iflink indices (2022-03-02 09:24:55 +0100)

----------------------------------------------------------------
Here are some batman-adv bugfixes:

 - Remove redundant iflink requests, by Sven Eckelmann (2 patches)

 - Don't expect inter-netns unique iflink indices, by Sven Eckelmann

----------------------------------------------------------------
Sven Eckelmann (3):
      batman-adv: Request iflink once in batadv-on-batadv check
      batman-adv: Request iflink once in batadv_get_real_netdevice
      batman-adv: Don't expect inter-netns unique iflink indices

 net/batman-adv/hard-interface.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)
