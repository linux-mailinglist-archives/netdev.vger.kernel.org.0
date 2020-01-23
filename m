Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEBF146655
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 12:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgAWLJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 06:09:53 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:49368 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726194AbgAWLJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 06:09:52 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579777791; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=jIU99pv6hOFOAlASDfRIFhdKALyIOfG4UkdYz7zOhzM=; b=sSg/nFjNiClnEFki4TZBgGG31X23i02Hxtu0ZoF46oM+CfYOU9nbzGt0IUFcPXXrgmyehMjC
 J8RVPin/gXL23f7Ym1anADKdM/7wwSmcBjxYmVt+WkiuepYenyEb2MJsg2so2VVfOs/Ar9ar
 ALlR+tQUogTaWWx/umSw9GVZugU=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e297efe.7f0700ec5e68-smtp-out-n01;
 Thu, 23 Jan 2020 11:09:50 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 31AF8C433CB; Thu, 23 Jan 2020 11:09:49 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 351D8C43383;
        Thu, 23 Jan 2020 11:09:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 351D8C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2020-01-23
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200123110949.31AF8C433CB@smtp.codeaurora.org>
Date:   Thu, 23 Jan 2020 11:09:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit ddd9b5e3e765d8ed5a35786a6cb00111713fe161:

  net-sysfs: Call dev_hold always in rx_queue_add_kobject (2019-12-17 22:57:11 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2020-01-23

for you to fetch changes up to d829229e35f302fd49c052b5c5906c90ecf9911d:

  iwlwifi: mvm: don't send the IWL_MVM_RXQ_NSSN_SYNC notif to Rx queues (2020-01-22 19:13:28 +0200)

----------------------------------------------------------------
wireless-drivers fixes for v5.5

Second set of fixes for v5.5. There are quite a few patches,
especially on iwlwifi, due to me being on a long break. Libertas also
has a security fix and mt76 a build fix.

iwlwifi

* don't send the PPAG command when PPAG is disabled, since it can cause problems

* a few fixes for a HW bug

* a fix for RS offload;

* a fix for 3168 devices where the NVM tables where the wrong tables were being read

* fix a couple of potential memory leaks in TXQ code

* disable L0S states in all hardware since our hardware doesn't
 officially support them anymore (and older versions of the hardware
 had instability in these states)

* remove lar_disable parameter since it has been causing issues for
  some people who erroneously disable it

* force the debug monitor HW to stop also when debug is disabled,
  since it sometimes stays on and prevents low system power states

* don't send IWL_MVM_RXQ_NSSN_SYNC notification due to DMA problems

libertas

* fix two buffer overflows

mt76

* build fix related to CONFIG_MT76_LEDS

* fix off by one in bitrates handling

----------------------------------------------------------------
Arnd Bergmann (1):
      mt76: fix LED link time failure

Dan Carpenter (1):
      mt76: Off by one in mt76_calc_rx_airtime()

Emmanuel Grumbach (1):
      iwlwifi: mvm: don't send the IWL_MVM_RXQ_NSSN_SYNC notif to Rx queues

Gil Adam (1):
      iwlwifi: don't send PPAG command if disabled

Haim Dreyfuss (1):
      iwlwifi: Don't ignore the cap field upon mcc update

Johannes Berg (8):
      iwlwifi: pcie: move page tracking into get_page_hdr()
      iwlwifi: pcie: work around DMA hardware bug
      iwlwifi: pcie: detect the DMA bug and warn if it happens
      iwlwifi: pcie: allocate smaller dev_cmd for TX headers
      iwlwifi: mvm: report TX rate to mac80211 directly for RS offload
      iwlwifi: pcie: extend hardware workaround to context-info
      iwlwifi: mvm: fix SKB leak on invalid queue
      iwlwifi: mvm: fix potential SKB leak on TXQ TX

Kalle Valo (1):
      Merge tag 'iwlwifi-for-kalle-2020-01-11' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes

Luca Coelho (6):
      iwlwifi: fix TLV fragment allocation loop
      iwlwifi: mvm: fix NVM check for 3168 devices
      iwlwifi: pcie: rename L0S_ENABLED bit to L0S_DISABLED
      iwlwifi: pcie: always disable L0S states
      iwlwifi: remove lar_disable module parameter
      iwlwifi: fw: make pos static in iwl_sar_get_ewrd_table() loop

Mehmet Akif Tasova (1):
      Revert "iwlwifi: mvm: fix scan config command size"

Shahar S Matityahu (1):
      iwlwifi: dbg: force stop the debug monitor HW

Stanislaw Gruszka (1):
      MAINTAINERS: change Gruszka's email address

Wen Huang (1):
      libertas: Fix two buffer overflows at parsing bss descriptor

 MAINTAINERS                                        |   4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |   3 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  10 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   9 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   3 -
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |   2 -
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  61 +++++-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |   9 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |  10 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  26 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 157 ++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  19 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  21 +--
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |  45 ++++-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  19 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  47 +++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 208 +++++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  68 ++++---
 drivers/net/wireless/marvell/libertas/cfg.c        |  16 +-
 drivers/net/wireless/mediatek/mt76/airtime.c       |   2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   3 +-
 28 files changed, 596 insertions(+), 185 deletions(-)
