Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23722244899
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgHNLEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbgHNLEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:04:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2275AC061384
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:04:31 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1k6XVd-00040D-HN; Fri, 14 Aug 2020 13:04:29 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2020-08-14
Date:   Fri, 14 Aug 2020 13:04:22 +0200
Message-Id: <20200814110428.405051-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

this is a pull request of 6 patches for net/master. All patches fix problems in
the j1939 CAN networking stack.

The first patch is by Eric Dumazet fixes a kernel-infoleak in
j1939_sk_sock2sockaddr_can().

The remaining 5 patches are by Oleksij Rempel and fix recption of j1939
messages not orginated by the stack, a use-after-free in j1939_tp_txtimer(),
ensure that the CAN driver has a ml_priv allocated. These problem were found by
google's syzbot. Further ETP sessions with block size of less than 255 are
fixed and a sanity check was added to j1939_xtp_rx_dat_one() to detect packet
corruption.

regards,
Marc

---

The following changes since commit 9643609423c7667fb748cc3ccff023d761d0ac90:

  Revert "ipv4: tunnel: fix compilation on ARCH=um" (2020-08-12 13:26:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.9-20200814

for you to fetch changes up to e052d0540298bfe0f6cbbecdc7e2ea9b859575b2:

  can: j1939: transport: j1939_xtp_rx_dat_one(): compare own packets to detect corruptions (2020-08-14 12:38:47 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.9-20200814

----------------------------------------------------------------
Eric Dumazet (1):
      can: j1939: fix kernel-infoleak in j1939_sk_sock2sockaddr_can()

Oleksij Rempel (5):
      can: j1939: transport: j1939_simple_recv(): ignore local J1939 messages send not by J1939 stack
      can: j1939: transport: j1939_session_tx_dat(): fix use-after-free read in j1939_tp_txtimer()
      can: j1939: socket: j1939_sk_bind(): make sure ml_priv is allocated
      can: j1939: transport: add j1939_session_skb_find_by_offset() function
      can: j1939: transport: j1939_xtp_rx_dat_one(): compare own packets to detect corruptions

 net/can/j1939/socket.c    | 14 ++++++++++++
 net/can/j1939/transport.c | 56 ++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 62 insertions(+), 8 deletions(-)


