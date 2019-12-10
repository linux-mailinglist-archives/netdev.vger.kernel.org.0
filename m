Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 798CE118667
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfLJLgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:36:07 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44624 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbfLJLgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 06:36:07 -0500
Received: by mail-lf1-f67.google.com with SMTP id v201so13392848lfa.11;
        Tue, 10 Dec 2019 03:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XY8c6o1ZDn8cLZbnNzZSfgpKdfWpT+q9NlTDas4NADs=;
        b=E0IPWnBysw7r8g+PXtBwBKHNMugbTCeASem8y+wRRw3YT+VThZupd4ntxO+BuZvEQB
         cDstpy4Zk6rOK9PuSiBauARQHJ0mS5NaMXniVSOF0HO3xFiS7/PM3YjUjmFlo6WHyDuH
         8Myq9KsDrCn3RuRYWBigmIxPfl6bj3qFx6FGurE6NdT755P9DpqSln90fnflXRxLjg8I
         1VHhYU9dC24VkjAkfrDFUYOv9Ra0J0FASrq+BFNlcGW6LRyG2uA5T1J5uJkUL8bZuq2U
         /xepSdSt5WJpoMKTyPnqwNGMLpyKJVpwfnPPai1RMeOEvV9j6nuN7w03PqPUanGTtCzW
         t0Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XY8c6o1ZDn8cLZbnNzZSfgpKdfWpT+q9NlTDas4NADs=;
        b=frQPJvV+JYLoSaD0TTIfwVyaiwzqgnqoXn9GwGCV3fVdT5BVBejfkLKXcgFaLQGfHG
         dph962/gwrsiCEcCH/FR9Cl5C9WN4VY9NnNYG1QbxztNXZyJSbHrKWcDZuzRrCJz78oV
         23dzWJl+NLJuvRmRxGEWWVy7VJ6xBDXE9F607OBXzaDA7SBhWV3i9Z5PkI105TXbN3+l
         9bhE4+QrSjNVaNnZV2hGeIwvJTocFX7+/XPF0vDPZvgrP4RkWcrLtVU6TTMvaRaHvmyx
         ITxxJMFAHf6ugiidx/dv+d/YzC4s0kK4I8rELBn01Rp+NVLeW1fq/hRcRh+1u1OcLd54
         vIDQ==
X-Gm-Message-State: APjAAAXiYkk0VTcVSfr1MPJITQ1m9h0W6r8fs2QTYY3meGZA7fuMlbpy
        sIl7bz25NC2Ax4rH9rmWx7XPNssH
X-Google-Smtp-Source: APXvYqwZTeTw9gdCAOj+K3A+HpOHJgHhLsv0iGFMi1WxC/9xPxcNI/uPw/rXyFJXuLapEACmz4u9vA==
X-Received: by 2002:ac2:4849:: with SMTP id 9mr18286682lfy.11.1575977764751;
        Tue, 10 Dec 2019 03:36:04 -0800 (PST)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id j10sm1595496ljc.76.2019.12.10.03.36.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Dec 2019 03:36:04 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Winnie Chang <winnie.chang@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] brcmfmac: set interface carrier to off by default
Date:   Tue, 10 Dec 2019 12:35:55 +0100
Message-Id: <20191210113555.1868-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

It's important as brcmfmac creates one main interface for each PHY and
doesn't allow deleting it. Not setting carrier could result in other
subsystems misbehaving (e.g. LEDs "netdev" trigger turning LED on).

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
I noticed this problem when using "netdev" LED trigger with "wlan0" set
as "device_name". While my interface was down (unused) the "netdev"
trigger was checking it with netif_carrier_ok() and assuming it's up.

This solution affects initial state of all brcmfmac interfaces (not
only the first non-removable one) but I think it should be fine. Later
on brcmfmac takes care of updating carrier as needed.
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 85cf96461dde..d3ddd97fe768 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -661,6 +661,8 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
 		goto fail;
 	}
 
+	netif_carrier_off(ndev);
+
 	ndev->priv_destructor = brcmf_cfg80211_free_netdev;
 	brcmf_dbg(INFO, "%s: Broadcom Dongle Host Driver\n", ndev->name);
 	return 0;
-- 
2.21.0

