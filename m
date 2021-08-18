Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED4B3F0B77
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 21:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhHRTIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 15:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbhHRTHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 15:07:54 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D730C0613CF;
        Wed, 18 Aug 2021 12:07:18 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id f13-20020a1c6a0d000000b002e6fd0b0b3fso3452270wmc.3;
        Wed, 18 Aug 2021 12:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8K4MnAEhJS2dex7Zxf7KLhcekRxHS9icv9pu38R/sIc=;
        b=eEtIQT9vQ6NRyACElkzdyLpqPHhAKh+OrGmUOKnLIROcEoIH8TcM+QCPG03N7MzspT
         ExdnMNimM/vap0d1/Xi3MifhPkZRIhcqWDzaiig86beJzcAJWkwBBN/6ZWop/uW8qjL2
         nRka2047yq1tnmmkjK4swNPbMu+lUlSidNU0OctTNPbrXqdF19MQZ6kVKdHM2uzJS3jk
         ykskkf1NSi5DNLDKRD+mSPViintj4Uyrm0jy9hjk3xTMMfzG8zS0gigorbe3jX5Rp2VG
         dCKfa2IzEC5i1i/Msqba2+ZrGSMTfdiGiPRLn1dFPXIhl9j9C8deFpNHi6FUTKitOlpV
         3GXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8K4MnAEhJS2dex7Zxf7KLhcekRxHS9icv9pu38R/sIc=;
        b=ixHRTYSfkjxXJQXQjKIxIVS6VQjQm7EiNVApfck+5BHvsuuuuO0CPy8P80QIBAPTkL
         FJ6ZRyhTZYZoRSOVXcKDQHv8TV02mWXlR1WKdJgdS/AxgrmOOZVPUKnGDOmAvAfqKdra
         lbFa3JPyy+Q8YIJui7RwE6lAd2uqVZqpiporDanm22b75LIgLbKvTGWtqwSAd/Yiqx/y
         hP8aMq6BYXCMDSTgGRhfYi7vLQPKQNXdF6zP9cjotd/kL0tyFVL2kgRBiPnW8pox6lSd
         Yf2LBTE2ZC1KVoksU0WxMHgRtIIzA53BsQJx/yFa086g502AK6JnKZIiaqoIwIOTLXE2
         92JQ==
X-Gm-Message-State: AOAM531U0+oON1dzXvl3secfsWxS7RsiroXyNh8x/7xEEKJzRv/AxXWj
        Jh4U4HW9eAWX978HjQ8LqJQiHS3g5PJOXQ==
X-Google-Smtp-Source: ABdhPJw3KQiz1AyI9YM30UyLLLJy5qTjXb5f1U+Ji8d/ecMUaguG1bCFusFNlaB+B57aZ6agyG0FIA==
X-Received: by 2002:a1c:2b04:: with SMTP id r4mr10005512wmr.168.1629313636983;
        Wed, 18 Aug 2021 12:07:16 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:5c16:403a:870d:fceb? (p200300ea8f0845005c16403a870dfceb.dip0.t-ipconnect.de. [2003:ea:8f08:4500:5c16:403a:870d:fceb])
        by smtp.googlemail.com with ESMTPSA id m10sm747723wro.63.2021.08.18.12.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 12:07:16 -0700 (PDT)
Subject: [PATCH 6/8] tg3: Use new function pci_vpd_alloc
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Message-ID: <bd3cd19c-b74f-9704-5786-476bf35ab5de@gmail.com>
Date:   Wed, 18 Aug 2021 21:04:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new VPD API function pci_vpd_alloc() for dynamically allocating
a properly sized buffer and reading the full VPD data into it.
This allows to simplify the code, and we don't have to make
assumptions on VPD size any longer.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 27 ++++++++++-----------------
 drivers/net/ethernet/broadcom/tg3.h |  1 -
 2 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 6f82eeaa4..fd4522c81 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12791,7 +12791,7 @@ static void tg3_get_ethtool_stats(struct net_device *dev,
 		memset(tmp_stats, 0, sizeof(struct tg3_ethtool_stats));
 }
 
-static __be32 *tg3_vpd_readblock(struct tg3 *tp, u32 *vpdlen)
+static __be32 *tg3_vpd_readblock(struct tg3 *tp, unsigned int *vpdlen)
 {
 	int i;
 	__be32 *buf;
@@ -12825,15 +12825,11 @@ static __be32 *tg3_vpd_readblock(struct tg3 *tp, u32 *vpdlen)
 			offset = TG3_NVM_VPD_OFF;
 			len = TG3_NVM_VPD_LEN;
 		}
-	} else {
-		len = TG3_NVM_PCI_VPD_MAX_LEN;
-	}
 
-	buf = kmalloc(len, GFP_KERNEL);
-	if (buf == NULL)
-		return NULL;
+		buf = kmalloc(len, GFP_KERNEL);
+		if (!buf)
+			return NULL;
 
-	if (magic == TG3_EEPROM_MAGIC) {
 		for (i = 0; i < len; i += 4) {
 			/* The data is in little-endian format in NVRAM.
 			 * Use the big-endian read routines to preserve
@@ -12844,12 +12840,9 @@ static __be32 *tg3_vpd_readblock(struct tg3 *tp, u32 *vpdlen)
 		}
 		*vpdlen = len;
 	} else {
-		ssize_t cnt;
-
-		cnt = pci_read_vpd(tp->pdev, 0, len, (u8 *)buf);
-		if (cnt < 0)
-			goto error;
-		*vpdlen = cnt;
+		buf = pci_vpd_alloc(tp->pdev, vpdlen);
+		if (IS_ERR(buf))
+			return NULL;
 	}
 
 	return buf;
@@ -12871,9 +12864,10 @@ static __be32 *tg3_vpd_readblock(struct tg3 *tp, u32 *vpdlen)
 
 static int tg3_test_nvram(struct tg3 *tp)
 {
-	u32 csum, magic, len;
+	u32 csum, magic;
 	__be32 *buf;
 	int i, j, k, err = 0, size;
+	unsigned int len;
 
 	if (tg3_flag(tp, NO_NVRAM))
 		return 0;
@@ -15621,8 +15615,7 @@ static int tg3_phy_probe(struct tg3 *tp)
 static void tg3_read_vpd(struct tg3 *tp)
 {
 	u8 *vpd_data;
-	unsigned int block_end, rosize, len;
-	u32 vpdlen;
+	unsigned int block_end, rosize, len, vpdlen;
 	int j, i = 0;
 
 	vpd_data = (u8 *)tg3_vpd_readblock(tp, &vpdlen);
diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index 46ec4fdfd..1000c8940 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -2101,7 +2101,6 @@
 /* Hardware Legacy NVRAM layout */
 #define TG3_NVM_VPD_OFF			0x100
 #define TG3_NVM_VPD_LEN			256
-#define TG3_NVM_PCI_VPD_MAX_LEN		512
 
 /* Hardware Selfboot NVRAM layout */
 #define TG3_NVM_HWSB_CFG1		0x00000004
-- 
2.32.0


