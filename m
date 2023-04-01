Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E026F6D2E53
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 07:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbjDAFMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 01:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbjDAFM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 01:12:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC479FF12
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 22:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58935B8336C
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 05:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58C2C433D2;
        Sat,  1 Apr 2023 05:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680325943;
        bh=/yCSmCSR/dE7ae7fDI8KopeGUEZtFJW7+aEarOvYBc0=;
        h=From:To:Cc:Subject:Date:From;
        b=piuqwhfGZb9nsGmPKEpDsibYX/eNKojDgYg5c8ubrf1QvMSA/qTpeIqgh1AGB48++
         gps7Nsw73+We7vA05uAiZMbnNROVRq8lQzUD7G6ZC19SoVGXQDVPVNW3qhsYbgK6A0
         FkLXQYuCZ9226PJblPt5mrWiNRd3QiehzmzON6tg3D7CM/EQGBmBtQXI/e2vbECZQb
         SsP7RnslEM2sps9D+mJUcfWFSoTqMHftmLxseOvmO4MBKHSEsFRPtP7/bBS0/MzETQ
         caJnZfv0HYMU94X4JnH27ZYRq6wPSQCIoajv9fYkP3KQh/IMpUVJVPmoBAJY0Hnzct
         aGPiGw44bzCJw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] net: provide macros for commonly copied lockless queue stop/wake code
Date:   Fri, 31 Mar 2023 22:12:18 -0700
Message-Id: <20230401051221.3160913-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers often struggle to implement lockless xmit and cleanup.
Add macros wrapping commonly copied implementation.
Convert two example drivers.

Jakub Kicinski (3):
  net: provide macros for commonly copied lockless queue stop/wake code
  ixgbe: use new queue try_stop/try_wake macros
  bnxt: use new queue try_stop/try_wake macros

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  41 +----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  37 +---
 include/net/netdev_queues.h                   | 167 ++++++++++++++++++
 3 files changed, 184 insertions(+), 61 deletions(-)
 create mode 100644 include/net/netdev_queues.h

-- 
2.39.2

