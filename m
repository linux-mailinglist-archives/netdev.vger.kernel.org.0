Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E1E1CC948
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 10:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgEJIKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 04:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgEJIKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 04:10:32 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CD3C061A0C
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 01:10:30 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id 50so6359805wrc.11
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 01:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=3xK75tQKSFjKpB2kBHbjyPfvU7s3/KZPWGI3PF7dJAM=;
        b=OxIRVmHtM3+FJ5iLuWAJTfv4YN/8RC3f60raL8Mk1ewS86isQCv2QZmWQjva2kVmcl
         WyUtv4Q/NIk2s9W+Mc04oOnH9mo8hvbIp5bBwEmFKvjTLb0YGyM2wp+bWygmPsPUvYt0
         73FjM0M40dUzb598Tsj00ciy016yJc/E5i+8UMbiTQ3S3nkfbK5qTsOZpRfTJOvTHcen
         3o8qmAgBwXLSQ2MEt9rv2eI/FGPvSYxEhb0UWoodMVNgToIuGihKFsu+5JNio90DNAg8
         xcBIjEIojiYigd6Wbf0UQGJZXQszI7kW7To49U7zFpoy1ZuyvDalJ/E/ZEMmYUXPOFKB
         TgPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=3xK75tQKSFjKpB2kBHbjyPfvU7s3/KZPWGI3PF7dJAM=;
        b=BNcIzKdnxbR0bcF/WIC2xSaBizNJXxh8GqrkvUasrpefXKtVrZRd79IXoZLrZ2wQw9
         MA8u6Y6sEiHTNS81qRVTm+qOSSdySLtbJBWK6f6rFT6IuCsJ1e0KZt2WqPEzchNEVjP/
         9VXwM4fL1c1LGYJ1NOguRVZRmpW2p3uxJpNBn3mj2Qp8EzE+96cjp7ZRKuk5KP1CtkuS
         zmSX2fOYGpfpPkSOfDYERFj8VsS7J5Fr8UHIxFemk5aGv/lK3yE8jM4hSDRNvIAcUGCw
         ppZeUtSuD3cROkoTeLtumil0YNYYg/JE60e7BK16jqFYOYu/2MgPd1NP0L1g/qmzbFXz
         8Gsw==
X-Gm-Message-State: AGi0PuY8h2Bl2BSEhC4i0x+yiRFiVjt4yETOq/unGPf9zJrCblEz/oV1
        LmEV62pkvhrZpUvQ0eeec7wMekbD
X-Google-Smtp-Source: APiQypKYYKeiCoPpJudWqGrX3sUx4pTs5wndiwxOs9zuYoke4+jmM61tsGTr3ptKE59X5TvOqkr4jA==
X-Received: by 2002:a5d:6108:: with SMTP id v8mr11845516wrt.286.1589098228753;
        Sun, 10 May 2020 01:10:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:d448:ac33:cee7:aac0? (p200300EA8F285200D448AC33CEE7AAC0.dip0.t-ipconnect.de. [2003:ea:8f28:5200:d448:ac33:cee7:aac0])
        by smtp.googlemail.com with ESMTPSA id 5sm19815743wmg.34.2020.05.10.01.10.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 May 2020 01:10:28 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] net: phy: check for aneg disabled and half
 duplex in phy_ethtool_set_eee
Message-ID: <8e7df680-e3c2-24ae-81d3-e24776583966@gmail.com>
Date:   Sun, 10 May 2020 10:10:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EEE requires aneg and full duplex, therefore return EPROTONOSUPPORT
if aneg is disabled or aneg resulted in a half duplex mode.

Heiner Kallweit (2):
  net: phy: check for aneg disabled and half duplex in
    phy_ethtool_set_eee
  r8169: rely on sanity checks in phy_ethtool_set_eee

 drivers/net/ethernet/realtek/r8169_main.c | 6 ------
 drivers/net/phy/phy.c                     | 3 +++
 2 files changed, 3 insertions(+), 6 deletions(-)

-- 
2.26.2

