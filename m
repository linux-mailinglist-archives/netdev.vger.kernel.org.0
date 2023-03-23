Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB456C6611
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjCWLDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjCWLDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:03:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DF055B3;
        Thu, 23 Mar 2023 04:03:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E06B1625E5;
        Thu, 23 Mar 2023 11:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FE4C433D2;
        Thu, 23 Mar 2023 11:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679569413;
        bh=5hU0844Ex279g6MC1KUigvUXwDiig/3Y4l1pp8xjSRs=;
        h=From:Subject:To:Cc:Date:From;
        b=Nogj8t++cafZUAqT7+BmzcR3Jp0vHMpBRe2WNpaTU0Sb2xeAisktLbX4FWpTZQ27O
         GbVMi+0ljX8rK93UKqc6KE/zHh59V6kaFU3jFdPKN4JB+FKmTvjOBOUnY/1I9wxASO
         jeO1SKQuQ3urqTMNRBBlloJHprTNhZYskDBoiwtEx+3Oh2BK/txj1xDRkX83YWqk/j
         jFAcTdtwok90hyc9PGXOS71C3z/eojOkavx4UvsQ3nbqI/KhK+xffHjWD72CXzYerh
         lC36eBu/JP9EMg1CDpDUtY0V9FgOi7ajAhbui2kgOxqoV/gECL0J6z36OqiMZKbW9r
         aK8bFKr7P+jYQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2023-03-23
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20230323110332.C4FE4C433D2@smtp.kernel.org>
Date:   Thu, 23 Mar 2023 11:03:32 +0000 (UTC)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 96c069508377547f913e7265a80fffe9355de592:

  wifi: cfg80211: fix MLO connection ownership (2023-03-10 11:47:25 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2023-03-23

for you to fetch changes up to f355f70145744518ca1d9799b42f4a8da9aa0d36:

  wifi: mac80211: fix mesh path discovery based on unicast packets (2023-03-22 13:46:46 +0100)

----------------------------------------------------------------
wireless fixes for v6.3

Third set of fixes for v6.3. mt76 has two kernel crash fixes and
adding back 160 MHz channel support for mt7915. mac80211 has fixes for
a race in transmit path and two mesh related fixes. iwlwifi also has
fixes for races.

----------------------------------------------------------------
Alexander Wetzel (1):
      wifi: mac80211: Serialize ieee80211_handle_wake_tx_queue()

Felix Fietkau (3):
      wifi: mt76: mt7915: add back 160MHz channel width support for MT7915
      wifi: mac80211: fix qos on mesh interfaces
      wifi: mac80211: fix mesh path discovery based on unicast packets

Johannes Berg (2):
      wifi: iwlwifi: mvm: fix mvmtxq->stopped handling
      wifi: iwlwifi: mvm: protect TXQ list manipulation

Krzysztof Kozlowski (1):
      wifi: mwifiex: mark OF related data as maybe unused

Lorenzo Bianconi (2):
      wifi: mt76: do not run mt76_unregister_device() on unregistered hw
      wifi: mt76: connac: do not check WED status for non-mmio devices

 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 50 ++++++++--------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  6 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  6 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 29 ++++++++++---
 drivers/net/wireless/marvell/mwifiex/pcie.c        |  2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |  2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  8 ++++
 drivers/net/wireless/mediatek/mt76/mt76.h          |  1 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  3 ++
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   | 40 ++++++++++++-----
 net/mac80211/ieee80211_i.h                         |  3 ++
 net/mac80211/main.c                                |  2 +
 net/mac80211/rx.c                                  | 22 +++++-----
 net/mac80211/util.c                                |  3 ++
 net/mac80211/wme.c                                 |  6 ++-
 15 files changed, 119 insertions(+), 64 deletions(-)
