Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D0267C4B4
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbjAZHOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjAZHOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:14:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280DE46702
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:14:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE3BBB81CFD
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 07:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C71C433D2;
        Thu, 26 Jan 2023 07:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674717267;
        bh=gKJjCMf6RbfXNoFe/xO6/p31XjuTLxB4BN6S5Nv03mw=;
        h=From:To:Cc:Subject:Date:From;
        b=ffbMoHSPmGdpBr1WeKiBLcQdnVC4Q+qjIuyhgOVxXmhw6POZbkG2vWTt/8EcrakIo
         Nwujdi/M70oqIvQNZIr3Irwa6nESBq8gD9+dcvt9yBpBYzj2PRJd1gTK4fD88aA6mZ
         sdeQWTesQ14FN0Qxu7S5gkvR5/HJEUpJhx59Teg1IUtW2wKG4/LYhj1ysOKtVNjPoH
         a2948IR44orMxq/GjtckP8FqxNDe8F4OnJz4pGBkMbOYRoofq1CFnHN4qetwn23cCS
         faFqvDHTYCuYO1Ihz6dZOsXMWqMf7oXAHR4TT+pJ0Sh60RyOsm7PKKb0Gq+LBUamc+
         wGxh3B9PCMzMg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/11] net: skbuff: clean up unnecessary includes
Date:   Wed, 25 Jan 2023 23:14:13 -0800
Message-Id: <20230126071424.1250056-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skbuff.h is included in a significant portion of the tree.
Clean up unused dependencies to speed up builds.

This set only takes care of the most obvious cases.

Jakub Kicinski (11):
  net: add missing includes of linux/net.h
  net: skbuff: drop the linux/net.h include
  net: checksum: drop the linux/uaccess.h include
  net: skbuff: drop the linux/textsearch.h include
  net: add missing includes of linux/sched/clock.h
  net: skbuff: drop the linux/sched/clock.h include
  net: skbuff: drop the linux/sched.h include
  net: add missing includes of linux/splice.h
  net: skbuff: drop the linux/splice.h include
  net: skbuff: drop the linux/hrtimer.h include
  net: remove unnecessary includes from net/flow.h

 arch/arm/include/asm/checksum.h                            | 1 +
 arch/x86/include/asm/checksum_64.h                         | 1 -
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c     | 2 ++
 drivers/net/wireless/intersil/orinoco/hermes.c             | 1 +
 drivers/scsi/lpfc/lpfc_init.c                              | 1 +
 include/linux/filter.h                                     | 1 +
 include/linux/igmp.h                                       | 1 +
 include/linux/skbuff.h                                     | 7 +------
 include/net/checksum.h                                     | 4 +++-
 include/net/flow.h                                         | 5 +++--
 net/core/skbuff.c                                          | 1 +
 net/rds/ib_recv.c                                          | 1 +
 net/rds/recv.c                                             | 1 +
 net/smc/af_smc.c                                           | 1 +
 net/smc/smc_rx.c                                           | 1 +
 net/unix/af_unix.c                                         | 1 +
 17 files changed, 21 insertions(+), 10 deletions(-)

-- 
2.39.1

