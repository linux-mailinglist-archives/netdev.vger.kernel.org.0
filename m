Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAF959E63F
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 17:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242431AbiHWPoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 11:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241345AbiHWPnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 11:43:31 -0400
Received: from syslogsrv (unknown [217.20.186.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F3529913C;
        Tue, 23 Aug 2022 04:41:21 -0700 (PDT)
Received: from fg200.ow.s ([172.20.254.44] helo=localhost.localdomain)
        by syslogsrv with esmtp (Exim 4.90_1)
        (envelope-from <maksym.glubokiy@plvision.eu>)
        id 1oQSGS-000FXN-Hm; Tue, 23 Aug 2022 14:40:12 +0300
From:   Maksym Glubokiy <maksym.glubokiy@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Taras Chornyi <tchornyi@marvell.com>
Cc:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] net: prestera: matchall features
Date:   Tue, 23 Aug 2022 14:39:55 +0300
Message-Id: <20220823113958.2061401-1-maksym.glubokiy@plvision.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
        HELO_NO_DOMAIN,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extracts matchall rules management out of SPAN API
implementation and adds 2 features on top of that:
  - support for egress traffic (mirred egress action)
  - proper rule priorities management between matchall and flower

Maksym Glubokiy (1):
  net: prestera: manage matchall and flower priorities

Serhiy Boiko (2):
  net: prestera: acl: extract matchall logic into a separate file
  net: prestera: add support for egress traffic mirroring

 .../net/ethernet/marvell/prestera/Makefile    |   2 +-
 .../ethernet/marvell/prestera/prestera_acl.c  |  43 ++++++
 .../ethernet/marvell/prestera/prestera_acl.h  |   2 +
 .../ethernet/marvell/prestera/prestera_flow.c |  12 +-
 .../ethernet/marvell/prestera/prestera_flow.h |   5 +
 .../marvell/prestera/prestera_flower.c        |  48 +++++++
 .../marvell/prestera/prestera_flower.h        |   2 +
 .../ethernet/marvell/prestera/prestera_hw.c   |  30 +++--
 .../ethernet/marvell/prestera/prestera_hw.h   |   5 +-
 .../marvell/prestera/prestera_matchall.c      | 125 ++++++++++++++++++
 .../marvell/prestera/prestera_matchall.h      |  17 +++
 .../ethernet/marvell/prestera/prestera_span.c |  66 +--------
 .../ethernet/marvell/prestera/prestera_span.h |  12 +-
 13 files changed, 291 insertions(+), 78 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_matchall.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_matchall.h

-- 
2.25.1

