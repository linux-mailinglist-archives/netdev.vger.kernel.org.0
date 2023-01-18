Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267E56715D9
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 09:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjARIIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 03:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjARIFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 03:05:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4658066FB8;
        Tue, 17 Jan 2023 23:37:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2520615A0;
        Wed, 18 Jan 2023 07:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF061C433EF;
        Wed, 18 Jan 2023 07:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674027470;
        bh=eEmrvxlQgtLiubUTw9+wmx08XBSRjRrRjzVPtdHqXPw=;
        h=From:Subject:To:Cc:Date:From;
        b=HJ+KX68+hWwJ5HjzrmXhkFWBmyHiv6b+wNXTLtYFkkc3dShAjLce+CSNkFR8cuJHG
         CLTTEg8uHeSeaSXq8kMIO+57vEiZaYgz5QJW5U3p48U/l/+agci49fC5x6mSvtCfQC
         FydtRyfGPmGOe3A8pxx6xbm5JJR7lpFrKEFxD/onGQBNg+or5zE0i9cR5EOUQAbAOn
         9hfMF86Wf9Kd4+XC3SRK8X2uwRNeGkjrtfE2oIxefXGs0XMTQaOZNNdlsb7plf/t1c
         xi4cpfC3dI1vBfypfq2FGpYNBiOh2PwhMtHeF18LzBxodFaySlHm1KoYxoNMsCw+0W
         oTL/bClna+uHA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2023-01-18
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20230118073749.AF061C433EF@smtp.kernel.org>
Date:   Wed, 18 Jan 2023 07:37:49 +0000 (UTC)
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

The following changes since commit f216033d770f7ca0eda491fe01a9f02e7af59576:

  wifi: mac80211: fix MLO + AP_VLAN check (2023-01-10 13:24:30 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2023-01-18

for you to fetch changes up to 80f8a66dede0a4b4e9e846765a97809c6fe49ce5:

  Revert "wifi: mac80211: fix memory leak in ieee80211_if_add()" (2023-01-16 17:28:52 +0200)

----------------------------------------------------------------
wireless fixes for v6.2

Third set of fixes for v6.2. This time most of them are for drivers,
only one revert for mac80211. For an important mt76 fix we had to
cherry pick two commits from wireless-next.

----------------------------------------------------------------
Arend van Spriel (3):
      wifi: brcmfmac: avoid handling disabled channels for survey dump
      wifi: brcmfmac: avoid NULL-deref in survey dump for 2G only device
      wifi: brcmfmac: fix regression for Broadcom PCIe wifi devices

Eric Dumazet (1):
      Revert "wifi: mac80211: fix memory leak in ieee80211_if_add()"

Felix Fietkau (1):
      wifi: mt76: dma: fix a regression in adding rx buffers

Lorenzo Bianconi (2):
      wifi: mt76: dma: do not increment queue head if mt76_dma_add_buf fails
      wifi: mt76: handle possible mt76_rx_token_consume failures

Szymon Heidrich (1):
      wifi: rndis_wlan: Prevent buffer overflow in rndis_query_oid

 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  37 +++---
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/dma.c           | 131 +++++++++++++--------
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   7 ++
 drivers/net/wireless/mediatek/mt76/tx.c            |   7 +-
 drivers/net/wireless/rndis_wlan.c                  |  19 +--
 net/mac80211/iface.c                               |   1 -
 7 files changed, 117 insertions(+), 87 deletions(-)
