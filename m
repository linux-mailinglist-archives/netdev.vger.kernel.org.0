Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56ADB36A6D6
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 13:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhDYLC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 07:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhDYLCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 07:02:55 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA356C061756
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 04:02:12 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id f6-20020a17090a6546b029015088cf4a1eso3651756pjs.2
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 04:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=RZKR8ck1KX2HeGx+2oK1RAn3RiTZ1YTGQyJAx9GZEnI=;
        b=eI1slnRP0b9nAS71fudHoITMbsdH1FtZrqWcIhDw6ZVScwWGRNxt9YyeDiOwmQSKuF
         5Y+dGzWIwONOXZtjhBgQD4rbyDvAgBW2AmKBThruM+CDMdKMwQOwnW6i452H5dFZrYqb
         IKX+KkxIwfaTxrAKHfUjvgNjm2bfoPg1I/EAwr0yvvy2ZZ/coWmjjwvSyd5AH+GG+Oz8
         AFkO44xZWNIOb4FdmuuaK1S4dfe3ZCQip6QqYj5R3DyFwmAJ7nGx45iEZYXXEGHjYhP4
         aT27nykRGvTfIVRJj0M0160hjBrmMXOSZmhrp1O/nBLh/nixDbzD3tWiRASJTrtH67ct
         4G/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RZKR8ck1KX2HeGx+2oK1RAn3RiTZ1YTGQyJAx9GZEnI=;
        b=SycDVsnaL7jPYfHmDkUtATYGBO1OVugRE30UkSD4yXZAHEmDNg1jACcZ1j8IPce82u
         wenB78qe/78OAkV0T7D1wQJBDrgYwl83JoewF1u5Y9/G8NDkum9bEKZ8pgZmeoF2Ut1z
         LfZV4FMOwB68oHXKyHr16V1/STJk3eZIaceBh6QyNVFCYhn61GavC+f35VOdmUO4xV56
         mon5jR4+YUK2C2GfRO3givfnDw7TW+c++ZqMxYP0lOxnZMmGDe2Lkm+ttOS9vzGoOweM
         WsU6tKIAQyrgbF5Hy55N/JSplC4YTqcaN45wcLUKJZwW9AvAij+hk97G3x8sZPkkvk3K
         kVQA==
X-Gm-Message-State: AOAM531N/Hc/ew1WPw9dPDTJAk0v+4ZFtOnSzIa9LiP07sfA5FG+KHHr
        Pgt7PCADMC9fET51YRsBWufLlQ==
X-Google-Smtp-Source: ABdhPJxwsmKYfTpwBg5m/3CapXl2HSdzZPvK9p8vUYBYwfw64aWilPMIw33q9Hrr+GqWWWtNWywnkg==
X-Received: by 2002:a17:90b:1bc1:: with SMTP id oa1mr13972865pjb.46.1619348532126;
        Sun, 25 Apr 2021 04:02:12 -0700 (PDT)
Received: from localhost.localdomain (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id o5sm8728629pgq.58.2021.04.25.04.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 04:02:11 -0700 (PDT)
From:   Shawn Guo <shawn.guo@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] brcmfmac: use ISO3166 country code and 0 rev as fallback
Date:   Sun, 25 Apr 2021 19:02:00 +0800
Message-Id: <20210425110200.3050-1-shawn.guo@linaro.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of aborting country code setup in firmware, use ISO3166 country
code and 0 rev as fallback, when country_codes mapping table is not
configured.  This fallback saves the country_codes table setup for recent
brcmfmac chipsets/firmwares, which just use ISO3166 code and require no
revision number.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c      | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index f4405d7861b6..6cb09c7c37b6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -7442,18 +7442,23 @@ static s32 brcmf_translate_country_code(struct brcmf_pub *drvr, char alpha2[2],
 	s32 found_index;
 	int i;
 
-	country_codes = drvr->settings->country_codes;
-	if (!country_codes) {
-		brcmf_dbg(TRACE, "No country codes configured for device\n");
-		return -EINVAL;
-	}
-
 	if ((alpha2[0] == ccreq->country_abbrev[0]) &&
 	    (alpha2[1] == ccreq->country_abbrev[1])) {
 		brcmf_dbg(TRACE, "Country code already set\n");
 		return -EAGAIN;
 	}
 
+	country_codes = drvr->settings->country_codes;
+	if (!country_codes) {
+		brcmf_dbg(TRACE, "No country codes configured for device, using ISO3166 code and 0 rev\n");
+		memset(ccreq, 0, sizeof(*ccreq));
+		ccreq->country_abbrev[0] = alpha2[0];
+		ccreq->country_abbrev[1] = alpha2[1];
+		ccreq->ccode[0] = alpha2[0];
+		ccreq->ccode[1] = alpha2[1];
+		return 0;
+	}
+
 	found_index = -1;
 	for (i = 0; i < country_codes->table_size; i++) {
 		cc = &country_codes->table[i];
-- 
2.17.1

