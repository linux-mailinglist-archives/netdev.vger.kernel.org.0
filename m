Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E86353A397
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 13:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352494AbiFALHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 07:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241487AbiFALHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 07:07:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13AB87A0C;
        Wed,  1 Jun 2022 04:07:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B686D60A5F;
        Wed,  1 Jun 2022 11:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B28C385A5;
        Wed,  1 Jun 2022 11:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654081662;
        bh=NMq6E0rr5JH1CfhO/51aFCcQsRAMGd+J2O1xwTmas9s=;
        h=From:Subject:To:Cc:Date:From;
        b=LZGT89y5hDfSAX+vuOujX4bM42PflI77U/Ro2ka1fCX67An81mXC76D84rK952cpz
         pxCTvYlfir13EXzJmmNOQvPhRXLKeDQp0bTCQ0+dbLnedoLvWX7KZD5brxkzCQzRdU
         J2Fl5Nr2RwKOE7ueArkvUf5/LhEUo+W+KHUfiKZ8vbmVwYvqOXY1i8sEx9vcVoMcUq
         L91EoRH7YvY0IGGI1xUOAhiQBCQqo49NQ1mySXFysFF8WhtuLVOGj1HG+pSVHHssJs
         PRHtyq5S903KPdRI3GWxnIdLc2YRvA1IrElPFvDoCGeCzrS7b4f8ksQSBgvIwFdzmz
         72g7fYk2NSO8w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2022-06-01
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20220601110741.90B28C385A5@smtp.kernel.org>
Date:   Wed,  1 Jun 2022 11:07:41 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit a54ce3703613e41fe1d98060b62ec09a3984dc28:

  net: sched: fixed barrier to prevent skbuff sticking in qdisc backlog (2022-05-26 20:45:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-06-01

for you to fetch changes up to 2965c4cdf7ad9ce0796fac5e57debb9519ea721e:

  wifi: mac80211: fix use-after-free in chanctx code (2022-06-01 12:41:41 +0300)

----------------------------------------------------------------
wireless fixes for v5.19

First set of fixes for v5.19. Build fixes for iwlwifi and libertas, a
scheduling while atomic fix for rtw88 and use-after-free fix for
mac80211.

----------------------------------------------------------------
Johannes Berg (3):
      wifi: libertas: use variable-size data in assoc req/resp cmd
      wifi: iwlwifi: pcie: rename CAUSE macro
      wifi: mac80211: fix use-after-free in chanctx code

Ping-Ke Shih (1):
      wifi: rtw88: add a work to correct atomic scheduling warning of ::set_tim

 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 34 ++++++++++++-------------
 drivers/net/wireless/marvell/libertas/cfg.c     |  4 +--
 drivers/net/wireless/marvell/libertas/host.h    |  6 +++--
 drivers/net/wireless/realtek/rtw88/fw.c         | 10 ++++++++
 drivers/net/wireless/realtek/rtw88/fw.h         |  1 +
 drivers/net/wireless/realtek/rtw88/mac80211.c   |  4 +--
 drivers/net/wireless/realtek/rtw88/main.c       |  2 ++
 drivers/net/wireless/realtek/rtw88/main.h       |  1 +
 net/mac80211/chan.c                             |  7 ++---
 9 files changed, 39 insertions(+), 30 deletions(-)
