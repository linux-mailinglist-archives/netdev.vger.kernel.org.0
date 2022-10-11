Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D208C5FB851
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 18:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiJKQb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 12:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiJKQb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 12:31:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DA41402B;
        Tue, 11 Oct 2022 09:31:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE59B61215;
        Tue, 11 Oct 2022 16:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A093CC433D6;
        Tue, 11 Oct 2022 16:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665505884;
        bh=WtjFG99GlAzYUAymxozvg4UBgubwOQ6jODebQwJ6gUo=;
        h=From:Subject:To:Cc:Date:From;
        b=MU6Dtk/d1resCxS9YXKlNE7XoliqOSAwT58c2VRyq41al5PsFRJitmm5Bn/7ny4cw
         C45KvRBhPfGNyWqSQoKQfG4wxsT/AAOdcZsMYmh6TXLqDbNGNcIxX1CK86DPcK5/Pl
         UQvuHiJO6a2Z9FOhzhbkwLlvwhx0m5mgEtfQyvEzD6Hg8lat0vIdizJt01setIKsco
         EsZEVGZY0YlTUKBP6wPQTHpUgKrZXyafu9ziSJe85An4zYM17fmeopcr8bzsiU8HbI
         HjUJtkdJGP6voZrcv1/qg+DlOxI2LfqPYsiU786oiMR2n82moA+13zNNzh8iE2hHFD
         jzIlBTzAwLJgw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2022-10-11
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20221011163123.A093CC433D6@smtp.kernel.org>
Date:   Tue, 11 Oct 2022 16:31:23 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 0326074ff4652329f2a1a9c8685104576bd8d131:

  Merge tag 'net-next-6.1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2022-10-04 13:38:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-10-11

for you to fetch changes up to abf93f369419249ca482a8911039fe1c75a94227:

  wifi: ath11k: mac: fix reading 16 bytes from a region of size 0 warning (2022-10-11 11:46:31 +0300)

----------------------------------------------------------------
wireless fixes for v6.1

First set of fixes for v6.1. Quite a lot of fixes in stack but also
for mt76.

cfg80211/mac80211

* fix locking error in mac80211's hw addr change

* fix TX queue stop for internal TXQs

* handling of very small (e.g. STP TCN) packets

* two memcpy() hardening fixes

* fix probe request 6 GHz capability warning

* fix various connection prints

* fix decapsulation offload for AP VLAN

mt76

* fix rate reporting, LLC packets and receive checksum offload on specific chipsets

iwlwifi

* fix crash due to list corruption

ath11k

* fix a compiler warning with GCC 11 and KASAN

----------------------------------------------------------------
Alexander Wetzel (1):
      wifi: mac80211: netdev compatible TX stop for iTXQ drivers

Dan Carpenter (1):
      wifi: mac80211: unlock on error in ieee80211_can_powered_addr_change()

Felix Fietkau (6):
      wifi: mt76: fix rate reporting / throughput regression on mt7915 and newer
      wifi: mac80211: do not drop packets smaller than the LLC-SNAP header on fast-rx
      wifi: mac80211: fix decap offload for stations on AP_VLAN interfaces
      wifi: cfg80211: fix ieee80211_data_to_8023_exthdr handling of small packets
      wifi: mt76: fix receiving LLC packets on mt7615/mt7915
      wifi: mt76: fix rx checksum offload on mt7615/mt7915/mt7921

Hawkins Jiawei (1):
      wifi: wext: use flex array destination for memcpy()

James Prestwood (2):
      wifi: mac80211: fix probe req HE capabilities access
      wifi: mac80211: remove/avoid misleading prints

Jose Ignacio Tornos Martinez (1):
      wifi: iwlwifi: mvm: fix double list_add at iwl_mvm_mac_wake_tx_queue (other cases)

Kalle Valo (1):
      wifi: ath11k: mac: fix reading 16 bytes from a region of size 0 warning

Kees Cook (1):
      wifi: nl80211: Split memcpy() of struct nl80211_wowlan_tcp_data_token flexible array

 drivers/net/wireless/ath/ath11k/mac.c           |  5 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c    |  2 ++
 drivers/net/wireless/mediatek/mt76/dma.c        |  5 +---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 12 ++++----
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 12 ++++----
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c |  4 ++-
 drivers/net/wireless/mediatek/mt76/tx.c         | 10 +++++--
 include/linux/wireless.h                        | 10 ++++++-
 net/mac80211/iface.c                            |  8 ++---
 net/mac80211/mlme.c                             |  7 +++--
 net/mac80211/rx.c                               |  9 +++---
 net/mac80211/tx.c                               | 10 ++++---
 net/mac80211/util.c                             |  2 +-
 net/wireless/nl80211.c                          |  4 ++-
 net/wireless/util.c                             | 40 +++++++++++++------------
 net/wireless/wext-core.c                        | 17 ++++++-----
 16 files changed, 94 insertions(+), 63 deletions(-)
