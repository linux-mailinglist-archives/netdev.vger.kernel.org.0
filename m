Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD29D1C42B8
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbgEDR2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730014AbgEDR2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:28:32 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9553EC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:28:32 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s8so30142wrt.9
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 10:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UFM1X7OscGNc6keRZ/CtLtFqcGBmpDr08iC+LJm6cUw=;
        b=ZuOxm11ydoKP/tHeTSsuZfAJNlAa2Loa20x4YcxruoGrKAUZXpSP8gaqb40beZwcFr
         VggNyqBiRGDfg+TV/g54eUhDg/bmkxaPsCqr74V/gISMJwZvO4ZNybTAm3lUZp27CJnP
         eFZ7YN3/czimfrqKXoDrsUrOHB53ePzIBrcIIhT+qvnMh7n0y0dMtgQS3WQFsS/d5GQ4
         o2OVU+g/brSIWdk16lWV4fnqB24zEFi4lyyzM4gXY/UQI80Dz3ZGewPRYmcBHzeDxiiB
         skE4BHlgDZ16l9puldoO4BOfcGFKdr7Q/oEqMLPOpRk8vI2s0JW7x4DSLlb4Hfi6ksTk
         /eLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UFM1X7OscGNc6keRZ/CtLtFqcGBmpDr08iC+LJm6cUw=;
        b=fkb6PTbShuOvunleH/usWj7VLLxy3PDK//Mw2iXB5eelfkx0RoazxH5Df4af221o0V
         QkEmcNXYC/YomSWkR4bMIKmZbvGz+Wv889HWXmgbdwMvb48U66MSEaL3e78au510DTSt
         n+ByRYRY+IIeZ/Npe3YdwVLegWfiw5eBG2dHiqPgZ3YEeACnqCuWjWHnHBOsC6tS+FbV
         4t7l1386VJufm+N72BX20SJNqVc3gD+ObldzG/aTvYZ3Vxi/MAXfYWLC3EIYCatBG+Y4
         ytgOf8IHGe+9GwIBEh1ca7XaI25z7TR5kq02o7dFt/jXBkf09JVIr+nhzhTby/QNDu46
         SlMw==
X-Gm-Message-State: AGi0Pua+bTI5tEpkP9+w57TPqnExCAyQ9aYlBXgcovJfwgGMjfitiSJa
        hKInuiYkjMNdSW17+v/Npwck62Pe
X-Google-Smtp-Source: APiQypJlBaONphLSAjuYUsIYgn/r1rCTgOwWSFkPUEpA9JaEWsLaSAmIU4yUibDQK9nvDMVB88a15g==
X-Received: by 2002:adf:f041:: with SMTP id t1mr373680wro.346.1588613311011;
        Mon, 04 May 2020 10:28:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:c500:c07a:3448:98ce:439e? (p200300EA8F43C500C07A344898CE439E.dip0.t-ipconnect.de. [2003:ea:8f43:c500:c07a:3448:98ce:439e])
        by smtp.googlemail.com with ESMTPSA id k184sm173871wmf.9.2020.05.04.10.28.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 10:28:30 -0700 (PDT)
Subject: [PATCH net-next 1/2] net: add helper eth_hw_addr_crc
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <329df165-a6a3-3c3b-cbb3-ea77ce2ea672@gmail.com>
Message-ID: <9de1aa6e-6c22-fad3-efe3-0200efb289bd@gmail.com>
Date:   Mon, 4 May 2020 19:27:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <329df165-a6a3-3c3b-cbb3-ea77ce2ea672@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several drivers use the same code as basis for filter hashes. Therefore
let's factor it out to a helper. This way drivers don't have to access
struct netdev_hw_addr internals.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/etherdevice.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 8801f1f98..2e5debc03 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -20,6 +20,7 @@
 #include <linux/if_ether.h>
 #include <linux/netdevice.h>
 #include <linux/random.h>
+#include <linux/crc32.h>
 #include <asm/unaligned.h>
 #include <asm/bitsperlong.h>
 
@@ -265,6 +266,17 @@ static inline void eth_hw_addr_random(struct net_device *dev)
 	eth_random_addr(dev->dev_addr);
 }
 
+/**
+ * eth_hw_addr_crc - Calculate CRC from netdev_hw_addr
+ * @ha: pointer to hardware address
+ *
+ * Calculate CRC from a hardware address as basis for filter hashes.
+ */
+static inline u32 eth_hw_addr_crc(struct netdev_hw_addr *ha)
+{
+	return ether_crc(ETH_ALEN, ha->addr);
+}
+
 /**
  * ether_addr_copy - Copy an Ethernet address
  * @dst: Pointer to a six-byte array Ethernet address destination
-- 
2.26.2


