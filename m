Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCAE41E933
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 10:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352629AbhJAIxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 04:53:24 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:50609 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhJAIxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 04:53:23 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633078300; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=yvf0eEWaN//0sGes1n0U4Hwfvtq75t1JjVZA6uQ2nlc=; b=CIPTvrL7pYSKzYULmAe5BELuDtqnaW4fm9JDsY1XiZWvQn10H0qrA/bOexERWwQbZizE21ax
 wspKNSGAcXmFfUkuU8N9hbQzQpQCvwFehPLsxLsUzkzM18sm7s17X78XxfmwoGF6AnpBedLM
 Kv1SXX2ogqkr5nBQLoFNkhz5TH4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 6156cbbe713d5d6f964a85fc (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 01 Oct 2021 08:50:06
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CD43EC4338F; Fri,  1 Oct 2021 08:50:05 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C2767C43460;
        Fri,  1 Oct 2021 08:50:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org C2767C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2021-10-01
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20211001085005.CD43EC4338F@smtp.codeaurora.org>
Date:   Fri,  1 Oct 2021 08:50:05 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 6880fa6c56601bb8ed59df6c30fd390cc5f6dd8f:

  Linux 5.15-rc1 (2021-09-12 16:28:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2021-10-01

for you to fetch changes up to 603a1621caa097be23c7784e36cb8edf23cd31db:

  mwifiex: avoid null-pointer-subtraction warning (2021-09-28 17:42:26 +0300)

----------------------------------------------------------------
wireless-drivers fixes for v5.15

Second set of fixes for v5.15, nothing major this time. Most important
here are reverting a brcmfmac regression and a fix for an old rare
ath5k build error.

iwlwifi

* fixes to NULL dereference, off by one and missing unlock

* add support for Killer AX1650 on Dell XPS 15 (9510) laptop

ath5k

* build fix with LEDS=m

brcmfmac

* revert a regression causing BCM4359/9 devices stop working as access point

mwifiex

* fix clang warning about null pointer arithmetic

----------------------------------------------------------------
Arnd Bergmann (2):
      ath5k: fix building with LEDS=m
      mwifiex: avoid null-pointer-subtraction warning

Dan Carpenter (2):
      iwlwifi: mvm: d3: Fix off by ones in iwl_mvm_wowlan_get_rsc_v5_data()
      iwlwifi: mvm: d3: missing unlock in iwl_mvm_wowlan_program_keys()

Ilan Peer (1):
      iwlwifi: mvm: Fix possible NULL dereference

Krzysztof Kozlowski (1):
      MAINTAINERS: Move Daniel Drake to credits

Soeren Moch (1):
      Revert "brcmfmac: use ISO3166 country code and 0 rev as fallback"

Vladimir Zapolskiy (1):
      iwlwifi: pcie: add configuration of a Wi-Fi adapter on Dell XPS 15

 CREDITS                                                 |  1 +
 MAINTAINERS                                             |  2 --
 drivers/net/wireless/ath/ath5k/Kconfig                  |  4 +---
 drivers/net/wireless/ath/ath5k/led.c                    | 10 ++++++----
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 17 ++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c             |  5 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c     |  3 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c           |  2 ++
 drivers/net/wireless/marvell/mwifiex/sta_tx.c           |  4 ++--
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c         |  4 ++--
 10 files changed, 25 insertions(+), 27 deletions(-)
