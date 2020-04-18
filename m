Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E9C1AF514
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 23:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgDRVLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 17:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgDRVLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 17:11:46 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C41C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:11:46 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j2so7244631wrs.9
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cox5DtRmgKiterZaFcKYqvfuGiXPaz9CXT61oFEKnRo=;
        b=g+aJ3lMSQjVSpu3Pu0xTyRZEIhZL8bHsMRFplsmXqYXMctnTEbK6wOFN/y8cbJ66Zb
         aX97Nwe1WEnCGlV8d9SQiTFRcQcN6esTEktPb9z2hZA+2Xxm0f79SB9GiC7VzsW5FhAa
         O9nHLnKTE1K0woWwI3M95u1HRkdVoOjQknsaUbRDp27lEqkYz9hc1PKwpsxzcaWSekKv
         u+Q9iB3SwHQKN9zZr01tODml6vAEPqbekima8djdknr9n0mDM9ZlHqtYa86j3LNocM21
         7Jfc+/wZPTZisU28wauJ31bG4wutzzY9x0Qn6FYNyG2AjtcSS8HfND3KSGT8e4ay/noq
         Fvfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cox5DtRmgKiterZaFcKYqvfuGiXPaz9CXT61oFEKnRo=;
        b=j6+RTd8q+VtHXiXS0f68BNqRlsED71zBGEPtdXP3pPfryPw1VAgmtstJc08VgacZgz
         6A8OnUWhNmbqwFWkh4E+0+xcUnis2rfXuN8e0mUk6gPnzKEVwrsX30J7eIj3hVffzGT/
         cRxy0TFQI9teuWMO+z3gF9q6HCXssPaC12wbv+3FuncvvgqWrOUSQsfFlZKFZ34WchU0
         sHaj5fuFZte4v6BV1LP9CYvjP06JX4RKIgJF5I0m7NXi6mBUi/Pbu7sJFAIvBXoBWfoL
         11yAkUE/3jyZCxnNGnrjJfCy+d65jH41pFOQnip9nBVIiR8RY5MSSQkVQuCSm6LNxxP7
         8vVA==
X-Gm-Message-State: AGi0PuYwl+QoVPTj4MdXGdS06Yhrv8tRwZTLs5fGsySHg7YSO7xOn1Wt
        /hvcG/9OPP4m7mNw/Si8K+4LN1i8
X-Google-Smtp-Source: APiQypLULQVmyGsAChppl6cCQ/N9Bm7p0AWLqiGzZLBonIMh/DWiB79xO/ZQnx7G3da4Ub7OD1X4rQ==
X-Received: by 2002:adf:f704:: with SMTP id r4mr10926561wrp.5.1587244304729;
        Sat, 18 Apr 2020 14:11:44 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:939:e10c:14c5:fe9f? (p200300EA8F2960000939E10C14C5FE9F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:939:e10c:14c5:fe9f])
        by smtp.googlemail.com with ESMTPSA id f23sm12432933wml.4.2020.04.18.14.11.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 14:11:44 -0700 (PDT)
Subject: [PATCH net-next 2/6] r8169: remove NETIF_F_HIGHDMA from vlan_features
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f7c53dc0-768c-7eb9-ffc0-b2e39b1ddfa4@gmail.com>
Message-ID: <ea6bac26-4702-5dca-94cf-34cf5dc4a1c1@gmail.com>
Date:   Sat, 18 Apr 2020 23:07:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f7c53dc0-768c-7eb9-ffc0-b2e39b1ddfa4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NETIF_F_HIGHDMA is added to vlan_features by register_netdev(),
therefore we can omit this here.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7bb423a0e..2e4353071 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5438,8 +5438,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
 			   NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
-	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_HIGHDMA;
+	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
 	tp->cp_cmd |= RxChkSum;
-- 
2.26.1


