Return-Path: <netdev+bounces-8524-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32EAE724741
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:08:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 970531C20A36
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EAE623C72;
	Tue,  6 Jun 2023 15:08:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1327A209B9
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC133C433D2;
	Tue,  6 Jun 2023 15:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686064098;
	bh=YeEj91g22JQm1LSU9NfRKOwY7xsSDqfsQpRE1PHC374=;
	h=From:Subject:To:Cc:Date:From;
	b=gEKPe4OggxafQc5oLKPiwGM1z+DDeYqsifGdcIs74M5RlOw6AsqSehn7Ztx07hjts
	 W+XTDEniTPG5CvSWZPEtmDqQcz7CUVf6L3ri9VPkmjOiRFttp2cUx+TrKyRGMox4c3
	 L/4f4VjttgNcU+vh34EV3jBm2jQc9eALSHiIZD46a6MUyiacmnp1bIMNXWf0bcVTPb
	 Ol3PCsXVWKY60S8M0T1DX7zmObaFzybZlgAieOoTmh8F+zM+zwRhLE0t3+V0Xz6zNZ
	 3guBTFYxoJn40HPY54+1R+fIIhjcol9sETsjBvhMWf6wGWw1ylZFw+6+FtlsGYIESI
	 LeTMvug5tYX2A==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2023-06-06
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Message-Id: <20230606150817.EC133C433D2@smtp.kernel.org>
Date: Tue,  6 Jun 2023 15:08:17 +0000 (UTC)

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 212457ccbd60dba34f965e4ffbe62f0e4f970538:

  wifi: b43: fix incorrect __packed annotation (2023-05-17 09:24:09 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2023-06-06

for you to fetch changes up to f7e60032c6618dfd643c7210d5cba2789e2de2e2:

  wifi: cfg80211: fix locking in regulatory disconnect (2023-06-06 14:51:32 +0200)

----------------------------------------------------------------
wireless fixes for v6.4

Both rtw88 and rtw89 have a 802.11 powersave fix for a regression
introduced in v6.0. mt76 fixes a race and a null pointer dereference.
iwlwifi fixes an issue where not enough memory was allocated for a
firmware event. And finally the stack has several smaller fixes all
over.

----------------------------------------------------------------
Aditya Kumar Singh (1):
      wifi: mac80211: fix switch count in EMA beacons

Gustavo A. R. Silva (1):
      wifi: iwlwifi: mvm: Fix -Warray-bounds bug in iwl_mvm_wait_d3_notif()

Johannes Berg (6):
      wifi: mac80211: use correct iftype HE cap
      wifi: cfg80211: reject bad AP MLD address
      wifi: mac80211: mlme: fix non-inheritence element
      wifi: mac80211: don't translate beacon/presp addrs
      wifi: cfg80211: fix locking in sched scan stop work
      wifi: cfg80211: fix locking in regulatory disconnect

Lorenzo Bianconi (2):
      wifi: mt76: mt7615: fix possible race in mt7615_mac_sta_poll
      wifi: mt76: mt7996: fix possible NULL pointer dereference in mt7996_mac_write_txwi()

Ping-Ke Shih (3):
      wifi: rtw88: correct PS calculation for SUPPORTS_DYNAMIC_PS
      wifi: rtw89: correct PS calculation for SUPPORTS_DYNAMIC_PS
      wifi: rtw89: remove redundant check of entering LPS

 drivers/net/wireless/intel/iwlwifi/mvm/d3.c     |  8 ++---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c |  3 ++
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 19 +++++++----
 drivers/net/wireless/realtek/rtw88/mac80211.c   | 14 +++-----
 drivers/net/wireless/realtek/rtw88/main.c       |  4 +--
 drivers/net/wireless/realtek/rtw88/ps.c         | 43 +++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/ps.h         |  2 ++
 drivers/net/wireless/realtek/rtw89/core.c       |  3 --
 drivers/net/wireless/realtek/rtw89/mac80211.c   | 15 ++++-----
 drivers/net/wireless/realtek/rtw89/ps.c         | 26 +++++++++++++++
 drivers/net/wireless/realtek/rtw89/ps.h         |  1 +
 net/mac80211/he.c                               | 15 ++++++---
 net/mac80211/mlme.c                             |  8 ++++-
 net/mac80211/rx.c                               |  4 ++-
 net/mac80211/tx.c                               |  2 +-
 net/wireless/core.c                             |  4 +--
 net/wireless/nl80211.c                          |  2 ++
 net/wireless/reg.c                              |  4 +--
 18 files changed, 129 insertions(+), 48 deletions(-)

