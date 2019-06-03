Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1FA633910
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 21:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfFCT0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 15:26:53 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54024 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFCT0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 15:26:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id d17so4678883wmb.3
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 12:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NYCDZ2j97/7LcW/weVc3Zm6Rdb7xjTKnAgWNZ8JgUr0=;
        b=VLFQe4CItQ26Npa6DwqeS9zfaGaLfZpnNCpjQPUVkeaXzpBpHuB7q13PjIULYeyE6+
         lJeer1uRf2MqJcFkc6IGlGqXgHDJS8UZGgOrPSCdaOwx2zAqexPb/qAmIFl1ZM7nyRjV
         aEO/o4QWA7yQ4GdcKgJyuC0K3m9YHxU06zFngclTPNd7Eh3SAS4QPHW/ggVjF5e2r2Ah
         EASgDfdzHkJxkHoC/5jujCInp12waWgzC9cTqaPz1SfvtrEh4oKrW+pOPXtbabRrOIPw
         S1QSDyd7IrZBhJCTcHU/sptdUq12IkosOVmyWFHhwleyKbF4aYnWaP4YMHUblIipERMq
         wKKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NYCDZ2j97/7LcW/weVc3Zm6Rdb7xjTKnAgWNZ8JgUr0=;
        b=N+ZLxd4U9nq7p8+Bm7S5TDGE0L+q9KPDzcW7E3kI0ty+I9pA+5CaPur5hB19i4VeWB
         dz7BUOoyqtuNrJ8gC2WFqfyvND9pxOXm1MESI6cZyVjHFRWHQh/WtQy5Ldv4gfDlKzMY
         6YKSwCwahZnfR/YdMAFUTT7A76DTrCdpwS3sz2GMmQxrlziORrCD9buJAEx1kTpefn8R
         oVLL9rmoEono5xDrHU5HAVjwl+OktwMd8oM+/1MvxnCvXMq+dl94keP+5xp9Ilax/O5/
         zjNXm838gNvKcRb3uvP3GHO/XrjXUofw51OvRIKm+FMgGI4GjSXnpko+DHT0qoGCvJYg
         06tw==
X-Gm-Message-State: APjAAAVKO86XRFWrQOEzUzqZycp8VPdWKxRMtNYaHRKqoa0exJptDwsI
        ss364WwJOj9BUt4ql3MtfV2CnFzc
X-Google-Smtp-Source: APXvYqyhxrs50MsUPaBS+zdhfw1HR5bpCpdvvUiT5Ed/MOSwa38wo2t5le5fqlOi8W3WNuSTbaifzw==
X-Received: by 2002:a1c:ab42:: with SMTP id u63mr15873358wme.130.1559590010432;
        Mon, 03 Jun 2019 12:26:50 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:2453:b919:ed8b:94f6? (p200300EA8BF3BD002453B919ED8B94F6.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:2453:b919:ed8b:94f6])
        by smtp.googlemail.com with ESMTPSA id b8sm11760418wrr.88.2019.06.03.12.26.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 12:26:49 -0700 (PDT)
Subject: [PATCH net-next 4/4] r8169: add rtl_fw_request_firmware and
 rtl_fw_release_firmware
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7c425378-dadb-399e-0a51-f226039e441f@gmail.com>
Message-ID: <654653c2-25ec-2f8b-e920-9ff453595f54@gmail.com>
Date:   Mon, 3 Jun 2019 21:26:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <7c425378-dadb-399e-0a51-f226039e441f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add rtl_fw_request_firmware and rtl_fw_release_firmware which will be
part of the API when factoring out the firmware handling code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 58 ++++++++++++++++------------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index e7b11324c..4c8ef7bb9 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -2492,10 +2492,15 @@ static void rtl_fw_write_firmware(struct rtl8169_private *tp,
 	}
 }
 
+static void rtl_fw_release_firmware(struct rtl_fw *rtl_fw)
+{
+	release_firmware(rtl_fw->fw);
+}
+
 static void rtl_release_firmware(struct rtl8169_private *tp)
 {
 	if (tp->rtl_fw) {
-		release_firmware(tp->rtl_fw->fw);
+		rtl_fw_release_firmware(tp->rtl_fw);
 		kfree(tp->rtl_fw);
 		tp->rtl_fw = NULL;
 	}
@@ -4249,18 +4254,39 @@ static void rtl_hw_reset(struct rtl8169_private *tp)
 	rtl_udelay_loop_wait_low(tp, &rtl_chipcmd_cond, 100, 100);
 }
 
+static int rtl_fw_request_firmware(struct rtl_fw *rtl_fw)
+{
+	int rc;
+
+	rc = request_firmware(&rtl_fw->fw, rtl_fw->fw_name, rtl_fw->dev);
+	if (rc < 0)
+		goto out;
+
+	if (!rtl_fw_format_ok(rtl_fw) || !rtl_fw_data_ok(rtl_fw)) {
+		release_firmware(rtl_fw->fw);
+		goto out;
+	}
+
+	return 0;
+out:
+	dev_err(rtl_fw->dev, "Unable to load firmware %s (%d)\n",
+		rtl_fw->fw_name, rc);
+	return rc;
+}
+
 static void rtl_request_firmware(struct rtl8169_private *tp)
 {
 	struct rtl_fw *rtl_fw;
-	int rc = -ENOMEM;
 
 	/* firmware loaded already or no firmware available */
 	if (tp->rtl_fw || !tp->fw_name)
 		return;
 
 	rtl_fw = kzalloc(sizeof(*rtl_fw), GFP_KERNEL);
-	if (!rtl_fw)
-		goto err_warn;
+	if (!rtl_fw) {
+		netif_warn(tp, ifup, tp->dev, "Unable to load firmware, out of memory\n");
+		return;
+	}
 
 	rtl_fw->phy_write = rtl_writephy;
 	rtl_fw->phy_read = rtl_readphy;
@@ -4269,26 +4295,10 @@ static void rtl_request_firmware(struct rtl8169_private *tp)
 	rtl_fw->fw_name = tp->fw_name;
 	rtl_fw->dev = tp_to_dev(tp);
 
-	rc = request_firmware(&rtl_fw->fw, tp->fw_name, tp_to_dev(tp));
-	if (rc < 0)
-		goto err_free;
-
-	if (!rtl_fw_format_ok(rtl_fw) || !rtl_fw_data_ok(rtl_fw)) {
-		dev_err(rtl_fw->dev, "invalid firmware\n");
-		goto err_release_firmware;
-	}
-
-	tp->rtl_fw = rtl_fw;
-
-	return;
-
-err_release_firmware:
-	release_firmware(rtl_fw->fw);
-err_free:
-	kfree(rtl_fw);
-err_warn:
-	netif_warn(tp, ifup, tp->dev, "unable to load firmware patch %s (%d)\n",
-		   tp->fw_name, rc);
+	if (rtl_fw_request_firmware(rtl_fw))
+		kfree(rtl_fw);
+	else
+		tp->rtl_fw = rtl_fw;
 }
 
 static void rtl_rx_close(struct rtl8169_private *tp)
-- 
2.21.0


