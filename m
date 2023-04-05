Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DABA6D7A73
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 12:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237478AbjDEKzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 06:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237236AbjDEKzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 06:55:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A17D8;
        Wed,  5 Apr 2023 03:55:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F828621C0;
        Wed,  5 Apr 2023 10:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E946C433D2;
        Wed,  5 Apr 2023 10:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680692136;
        bh=7P6vZTNsafwDOMnlCJycAM+JGy5DFJMTB3oNaDORP1I=;
        h=From:Subject:To:Cc:Date:From;
        b=j7ChtoXqozNeVW1TJctakYvZJabA1TNnVeAgn5GF82b7MNxwY/Cc0c1YKgFHSo0TB
         c8LiwP2vJ6Y+QKsYyQc4DKYbIfHYv9wkMWBMfarx/zjD0e+TE2jC6vwn34T4Y4+JAh
         6zaRjzDysumUeuBoRJbb9Bm7ZowFpaMDW8r3YHIQdK4FYbNqBxKgAtVQBIUi1EdkoG
         Rt4Fh/XLa7sASIweB3b2sjpXfwU1czHMBJtKt9gjY9eW4cjRaW0HkBv0GNZXgBZxKi
         ygcwG1ZmddhVe6RPuEe7S8+NRb6ZTJsjIS/L9r5RQcsWJAed/rrdAcBzwsNiqugwq1
         HlMKcWsIlOubg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2023-04-05
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20230405105536.4E946C433D2@smtp.kernel.org>
Date:   Wed,  5 Apr 2023 10:55:36 +0000 (UTC)
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

The following changes since commit 12b220a6171faf10638ab683a975cadcf1a352d6:

  wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta (2023-03-30 11:19:53 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2023-04-05

for you to fetch changes up to e6db67fa871dee37d22701daba806bfcd4d9df49:

  wifi: mt76: ignore key disable commands (2023-04-03 16:50:20 +0300)

----------------------------------------------------------------
wireless fixes for v6.3

mt76 has a fix for leaking cleartext frames on a certain scenario and
two firmware file handling related fixes. For brcmfmac we have a fix
for an older SDIO suspend regression and for ath11k avoiding a kernel
crash during hibernation with SUSE kernels.

----------------------------------------------------------------
Ben Greear (1):
      wifi: mt76: mt7921: Fix use-after-free in fw features query.

Felix Fietkau (1):
      wifi: mt76: ignore key disable commands

Hans de Goede (1):
      wifi: brcmfmac: Fix SDIO suspend/resume regression

Kalle Valo (1):
      wifi: ath11k: reduce the MHI timeout to 20s

Lorenzo Bianconi (1):
      wifi: mt76: mt7921: fix fw used for offload check for mt7922

 drivers/net/wireless/ath/ath11k/mhi.c              |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 36 +++++++----
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  2 +
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   | 10 ++--
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    | 70 +++++++---------------
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   | 15 +++--
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |  6 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  | 18 +++---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   | 13 ++--
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |  7 ++-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   | 13 ++--
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   | 13 ++--
 13 files changed, 97 insertions(+), 110 deletions(-)
