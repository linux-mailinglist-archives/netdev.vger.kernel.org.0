Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C9A322592
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 06:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhBWFyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 00:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbhBWFyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 00:54:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C24C06178A
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 21:53:39 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lEQdP-0005FP-Hw; Tue, 23 Feb 2021 06:53:23 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lEQdO-000128-D3; Tue, 23 Feb 2021 06:53:22 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     mkl@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH net v2 0/2] add support for skb with sk ref cloning 
Date:   Tue, 23 Feb 2021 06:53:18 +0100
Message-Id: <20210223055321.3891-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v2:
- drop mac80211 patch for now, it can go separately if needed

Hello,

this series tries to fix a long standing problem in the CAN echo SKB
handling. The problem shows up if an echo SKB for a SKB that references
an already closed socket is created.

It looks like the mac80211/tx.c has the same problem, see RFC patch 3
for details.

regards,
Oleksij

Oleksij Rempel (2):
  skbuff: skb_clone_sk_optional(): add function to always clone a skb
    and increase refcount on sk if valid
  can: fix ref count warning if socket was closed before skb was cloned

 include/linux/can/skb.h   |  3 +--
 include/linux/skbuff.h    |  1 +
 net/can/af_can.c          |  6 +++---
 net/can/j1939/main.c      |  3 +--
 net/can/j1939/socket.c    |  3 +--
 net/can/j1939/transport.c |  4 +---
 net/core/skbuff.c         | 27 +++++++++++++++++++++++++++
 7 files changed, 35 insertions(+), 12 deletions(-)

-- 
2.29.2

