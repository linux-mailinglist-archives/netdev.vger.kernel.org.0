Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFDC642938
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 14:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbiLENVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 08:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiLENVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 08:21:20 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2009D1C404;
        Mon,  5 Dec 2022 05:21:18 -0800 (PST)
Received: from localhost.localdomain.datenfreihafen.local (p5dd0dfce.dip0.t-ipconnect.de [93.208.223.206])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 2B6DBC05B3;
        Mon,  5 Dec 2022 14:21:17 +0100 (CET)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull-request: ieee802154-next 2022-12-05
Date:   Mon,  5 Dec 2022 14:19:09 +0100
Message-Id: <20221205131909.1871790-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub.

An update from ieee802154 for *net-next*

This is the second pull request from wpan-next this cycle. Hoping its still on
time we have a few follow ups from the first, bigger pull request.

Miquel continued his work towards full scanning support. For this, we now allow
the creation of dedicated coordinator interfaces to allow a PAN coordinator to
serve in the network and set the needed address filters with the hardware.

On top of this we have the first part to allow scanning for available 15.4
networks. A new netlink scan group, within the existing nl802154 API, was added.

In addition Miquel fixed two issues that have been introduced in the former
patches to free an skb correctly and clarifying an expression in the stack.

From David Girault we got tracing support when registering new PANs.

regards
Stefan Schmidt

The following changes since commit 95d9a3dab109f2806980d55634972120824a5a5a:

  selftests: tc-testing: Add matchJSON to tdc (2022-10-26 20:22:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan-next.git tags/ieee802154-for-net-next-2022-12-05

for you to fetch changes up to e29e3c7ce6d4b2f164ebd717e4794c626fc1c954:

  mac802154: Trace the registration of new PANs (2022-11-29 15:34:32 +0100)

----------------------------------------------------------------
David Girault (1):
      mac802154: Trace the registration of new PANs

Miquel Raynal (4):
      mac802154: Move an skb free within the rx path
      mac802154: Clarify an expression
      mac802154: Allow the creation of coordinator interfaces
      ieee802154: Advertize coordinators discovery

 include/net/cfg802154.h   |  18 ++++++++
 include/net/nl802154.h    |  43 +++++++++++++++++++
 net/ieee802154/nl802154.c | 103 ++++++++++++++++++++++++++++++++++++++++++++++
 net/ieee802154/nl802154.h |   2 +
 net/mac802154/iface.c     |  15 +++----
 net/mac802154/main.c      |   2 +-
 net/mac802154/rx.c        |  24 +++++------
 net/mac802154/trace.h     |  25 +++++++++++
 8 files changed, 211 insertions(+), 21 deletions(-)
