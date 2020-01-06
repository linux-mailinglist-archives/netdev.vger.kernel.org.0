Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC848130E39
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 08:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgAFHzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 02:55:32 -0500
Received: from conuserg-09.nifty.com ([210.131.2.76]:19304 "EHLO
        conuserg-09.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgAFHzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 02:55:31 -0500
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-09.nifty.com with ESMTP id 0067t0HK015985;
        Mon, 6 Jan 2020 16:55:00 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-09.nifty.com 0067t0HK015985
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1578297301;
        bh=efnKuYuz9lMVFzD60VImov9gE/cfNQG04Z6RLrlvcBI=;
        h=From:To:Cc:Subject:Date:From;
        b=OqTiVlEP/fkyxM1gu4IB+r9/4yKPkoItNtAoplP08Y/dGD1/Vd59g5avkZJTuN2ma
         aGlLfxaJTNJi/rrMea7KDUnZXOMRoLw1q9MeHqZzUyl4uc5aenKPuFjTYZUWwcDDRF
         AbtwzxCFBzis7hWTClf2+TMMcPxXGHiTv6Eddu5+cfzE58VvfVu8pXEn55C0BgEw1K
         Y+M2B0CBQuRm9C1KmSnZGn1Uhw3eWmk9uqBNxD24kAb0+R5+J6ysruDcWHJB0Ektgk
         j/KBJe9p6ENLN+kTNhUNJ09ZILGh48m1UEM4gp+YrrZQnljaJsjfWHXgOY8LDFcS7O
         mWCokwk9nTLSg==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] iwlwifi: remove object duplication in Makefile
Date:   Mon,  6 Jan 2020 16:54:38 +0900
Message-Id: <20200106075439.20926-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The objects in $(iwlwifi-objs) $(iwlwifi-y) $(iwlwifi-m) are linked to
iwlwifi.ko .

This line adds $(iwlwifi-m) to iwlwifi-objs, so the objects from
$(iwlwifi-m) are listed twice as the dependency of the module.

It works because Kbuild trims the duplicated objects from linking,
but there is no good reason to have this line.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 drivers/net/wireless/intel/iwlwifi/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/Makefile b/drivers/net/wireless/intel/iwlwifi/Makefile
index 0aae3fa4128c..a018d27a5410 100644
--- a/drivers/net/wireless/intel/iwlwifi/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/Makefile
@@ -19,8 +19,6 @@ iwlwifi-$(CONFIG_IWLMVM) += fw/paging.o fw/smem.o fw/init.o
 iwlwifi-$(CONFIG_ACPI) += fw/acpi.o
 iwlwifi-$(CONFIG_IWLWIFI_DEBUGFS) += fw/debugfs.o
 
-iwlwifi-objs += $(iwlwifi-m)
-
 iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
 
 ccflags-y += -I$(src)
-- 
2.17.1

