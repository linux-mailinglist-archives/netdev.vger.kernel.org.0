Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7280BE671
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 22:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393181AbfIYUcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 16:32:19 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35296 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389778AbfIYUcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 16:32:18 -0400
Received: by mail-wm1-f65.google.com with SMTP id y21so176884wmi.0;
        Wed, 25 Sep 2019 13:32:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9msODsp1f3ntoBvQarVOQqQV429arne9yrJNCKUXVXc=;
        b=Z1wasGaUInOb/wgCSGocPXC2c3mEd23s6FKA3UPmT43zj/y4/xK7j39of/3TPy2wFM
         MO4Ny0LUIBqOzyynNcfMrakdwLT0nZSNqlQ5TEtBUrkmhpGcQdWzAZQX3EOMeIzXGxpW
         aN3SCjO5TyBaYg+JVEK5hMbb44E5tIT04vjW4oQ80R4XMwMAG93lKe1vwRPlblI4PiVD
         OQkjEx5M9aaupXxQQQHgxxptTXVGaimjWtgRduyHp+hIOaW7wD/JpX4qkAulI5gA9EX8
         81LgP/FhQ6MQkdxCmgn6k+hcXn/lDaeTbCN6UQEA2l/8NEptfz9nEiOwB778O80KRWQZ
         bxBw==
X-Gm-Message-State: APjAAAV2SGEyrgtEQunFxeIJgNrwDDJdKMoPjd1b7YwovWm7gtm1NNVS
        9AOYFODxq8A+V1XyLz96vFw=
X-Google-Smtp-Source: APXvYqz7DKuSwCaT7Oqi7TD0hTMLSVZGaKUxZ8UDtvuWifMHzKPO9jzopX+sJDAL8LazUfq8VHznYw==
X-Received: by 2002:a1c:9a46:: with SMTP id c67mr52161wme.115.1569443537037;
        Wed, 25 Sep 2019 13:32:17 -0700 (PDT)
Received: from localhost.localdomain (99-48-196-88.sta.estpak.ee. [88.196.48.99])
        by smtp.googlemail.com with ESMTPSA id t14sm105774wrs.6.2019.09.25.13.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 13:32:16 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Denis Efremov <efremov@linux.com>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] brcmsmac: remove duplicated if condition
Date:   Wed, 25 Sep 2019 23:31:52 +0300
Message-Id: <20190925203152.21548-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nested 'li_mimo == &locale_bn' check is excessive and always
true. Thus it can be safely removed.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 .../net/wireless/broadcom/brcm80211/brcmsmac/channel.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
index db783e94f929..5a6d9c86552a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
@@ -496,13 +496,11 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 	 * table and override CDD later
 	 */
 	if (li_mimo == &locale_bn) {
-		if (li_mimo == &locale_bn) {
-			maxpwr20 = QDB(16);
-			maxpwr40 = 0;
+		maxpwr20 = QDB(16);
+		maxpwr40 = 0;
 
-			if (chan >= 3 && chan <= 11)
-				maxpwr40 = QDB(16);
-		}
+		if (chan >= 3 && chan <= 11)
+			maxpwr40 = QDB(16);
 
 		for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
 			txpwr->mcs_20_siso[i] = (u8) maxpwr20;
-- 
2.21.0

