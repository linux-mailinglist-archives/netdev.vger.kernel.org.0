Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B781044C7
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfKTUJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:09:02 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51606 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfKTUJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:09:02 -0500
Received: by mail-wm1-f65.google.com with SMTP id g206so793938wme.1
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 12:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SQnsl/GQBxgwqKog279OXaLxiVwpB0sqXS4XbUCGpuk=;
        b=WCLF0HbVg+KCjAUiv1PNPTkogSpeM8Kv7pREQUwpbmCnQC3O5OYQx9GTj24aFXEhtC
         gTrAfQ0elXRFa3cpSgImLjViT5196ELzmYOTDcEHANhZy4KkvtXVFQWvOi30H9P+d7QA
         c1YbcoqaWXcfsNB0liNUhxH7uoT46+aHd2hONmkKE82qKdB2JD7Um2A12rtZHhaiph43
         8fOOamTWkpg3WU7F9gu7DvM1MVGsNqm4j0a1eopowkN9tF5govFDQzbnxMOSRkgBLFrg
         olq08l8kB2ZXJ/DQ84wX4Pg8pFHdr9s9IREP+Vjkns1rCRQ8HtuKKznYqmnvt4M3nN90
         Gwww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SQnsl/GQBxgwqKog279OXaLxiVwpB0sqXS4XbUCGpuk=;
        b=eaTqsfLrcmdn4HSdooz2nXvgo0iVq+gRRnIb+Kg4w5NNyH152CAZUuM3IsXDbC880l
         IYmYjgDVQy7anwQZAS/kqF9yLuoQ2PRSVkW8mxjYe+hU8AaIVAU6MeH4j8RKj4UemaHT
         STQpIJWY3b9t60ALKDVNtPg5OznAiv4KyEw1MvK9qqHOdT0YrZfhHpGqHjeZtAJLwPnb
         PIFbuL8mi4hsdq4BnD7r1oi/0diLhENR+KYyF0dOVdqjWqSDdpNiE9Lf3voXIe/1eyME
         nGkXuXMgyO7SWYa4kom9wQEkvZ0xoPv9/t9qauQz3lb1e0sXZVdSPqrDKFvYrEcF4dO1
         CxJg==
X-Gm-Message-State: APjAAAVyRK84+l1NkewCR06i4t5qubL8CMV5btREpZ02kMRRl5OUdYzl
        XNgh+ocUYu/QgnVzT0dkI4ftV711
X-Google-Smtp-Source: APXvYqwC3qQH1HDgOVtKJzB/L/Wta6qG1brZ00MmGWVKGZ9zFgmDREUwaEIGfrJ9pgIziGSqOYt6wA==
X-Received: by 2002:a1c:e154:: with SMTP id y81mr5629398wmg.126.1574280539898;
        Wed, 20 Nov 2019 12:08:59 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:1b5:77c:1d90:d2c6? (p200300EA8F2D7D0001B5077C1D90D2C6.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:1b5:77c:1d90:d2c6])
        by smtp.googlemail.com with ESMTPSA id u18sm460617wrp.14.2019.11.20.12.08.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2019 12:08:59 -0800 (PST)
Subject: [PATCH net-next 1/3] r8169: change mdelay to msleep in
 rtl_fw_write_firmware
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6bb940ea-f479-f264-bc12-b4be52293dd6@gmail.com>
Message-ID: <a92291c4-1157-67df-1a73-4a7a3936f6b9@gmail.com>
Date:   Wed, 20 Nov 2019 21:06:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <6bb940ea-f479-f264-bc12-b4be52293dd6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're not in atomic context here, therefore switch to msleep.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_firmware.c b/drivers/net/ethernet/realtek/r8169_firmware.c
index 8f54a2c83..522415084 100644
--- a/drivers/net/ethernet/realtek/r8169_firmware.c
+++ b/drivers/net/ethernet/realtek/r8169_firmware.c
@@ -198,7 +198,7 @@ void rtl_fw_write_firmware(struct rtl8169_private *tp, struct rtl_fw *rtl_fw)
 			index += regno;
 			break;
 		case PHY_DELAY_MS:
-			mdelay(data);
+			msleep(data);
 			break;
 		}
 	}
-- 
2.24.0


