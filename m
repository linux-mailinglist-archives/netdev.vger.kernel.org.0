Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C1F3044D8
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 18:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389694AbhAZRPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 12:15:50 -0500
Received: from m42-8.mailgun.net ([69.72.42.8]:56859 "EHLO m42-8.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbhAZJXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 04:23:03 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611652951; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=8RYhwBl8KWpB16zC3SzdrYIhigFUF/TiabB1hljhjd8=; b=qGRQnhU6PCqKVt2bVaoMn/7yU0n6jqT4GUvW91Ts2pOSlmCB5wsvW3THrVwSmK1CKc6BeumJ
 mPCdirBeAfLvAqc1kAfSbwD77vWSJtdeIzwr7ES9BYUBHzec/vKKIMSCCrynIC/8M23l9shy
 uqPHK85Gwgr3D080i/xwsUxUgC4=
X-Mailgun-Sending-Ip: 69.72.42.8
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 600fdf3bbdcf4682875ebb35 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 26 Jan 2021 09:22:03
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6A367C433CA; Tue, 26 Jan 2021 09:22:02 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 45403C433ED;
        Tue, 26 Jan 2021 09:22:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 45403C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2021-01-26
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210126092202.6A367C433CA@smtp.codeaurora.org>
Date:   Tue, 26 Jan 2021 09:22:02 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 6279d812eab67a6df6b22fa495201db6f2305924:

  Merge tag 'net-5.11-rc3-2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-01-08 12:12:30 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2021-01-26

for you to fetch changes up to 0acb20a5438c36e0cf2b8bf255f314b59fcca6ef:

  mt7601u: fix kernel crash unplugging the device (2021-01-25 16:02:52 +0200)

----------------------------------------------------------------
wireless-drivers fixes for v5.11

Second set of fixes for v5.11. Like in last time we again have more
fixes than usual Actually a bit too much for my liking in this state
of the cycle, but due to unrelated challenges I was only able to
submit them now.

We have few important crash fixes, iwlwifi modifying read-only data
being the most reported issue, and also smaller fixes to iwlwifi.

mt76

* fix a clang warning about enum usage

* fix rx buffer refcounting crash

mt7601u

* fix rx buffer refcounting crash

* fix crash when unbplugging the device

iwlwifi

* fix a crash where we were modifying read-only firmware data

* lots of smaller fixes allover the driver

----------------------------------------------------------------
Emmanuel Grumbach (3):
      iwlwifi: fix the NMI flow for old devices
      iwlwifi: queue: don't crash if txq->entries is NULL
      iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap

Gregory Greenman (1):
      iwlwifi: mvm: invalidate IDs of internal stations at mvm start

Johannes Berg (10):
      iwlwifi: mvm: take mutex for calling iwl_mvm_get_sync_time()
      iwlwifi: pcie: avoid potential PNVM leaks
      iwlwifi: pnvm: don't skip everything when not reloading
      iwlwifi: pnvm: don't try to load after failures
      iwlwifi: pcie: set LTR on more devices
      iwlwifi: pcie: fix context info memory leak
      iwlwifi: pcie: use jiffies for memory read spin time limit
      iwlwifi: pcie: reschedule in long-running memory reads
      iwlwifi: mvm: guard against device removal in reprobe
      iwlwifi: queue: bail out on invalid freeing

Lorenzo Bianconi (3):
      mt7601u: fix rx buffer refcounting
      mt76: mt7663s: fix rx buffer refcounting
      mt7601u: fix kernel crash unplugging the device

Luca Coelho (1):
      iwlwifi: pcie: add rules to match Qu with Hr2

Matt Chen (1):
      iwlwifi: mvm: fix the return type for DSM functions 1 and 2

Matti Gottlieb (1):
      iwlwifi: Fix IWL_SUBDEVICE_NO_160 macro to use the correct bit.

Nathan Chancellor (1):
      mt76: Fix queue ID variable types after mcu queue split

Sara Sharon (1):
      iwlwifi: mvm: skip power command when unbinding vif during CSA

Shaul Triebitz (1):
      iwlwifi: mvm: clear IN_D3 after wowlan status cmd

Takashi Iwai (1):
      iwlwifi: dbg: Don't touch the tlv data

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     | 25 +++++++++
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       | 65 +++++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |  7 ++-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       | 56 ++++++++++---------
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  7 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |  7 ---
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |  9 +--
 drivers/net/wireless/intel/iwlwifi/iwl-io.h        | 10 +++-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |  6 ++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  6 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 25 +++++----
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  7 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  6 ++
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   | 53 +++++++++++-------
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 10 ++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 14 +++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  5 ++
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      | 55 +++++++++---------
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  2 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_txrx.c  |  9 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    | 10 ++--
 drivers/net/wireless/mediatek/mt7601u/dma.c        |  5 +-
 24 files changed, 264 insertions(+), 141 deletions(-)
