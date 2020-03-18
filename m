Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A68E18A6F3
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgCRV11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:27:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42815 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbgCRV11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 17:27:27 -0400
Received: by mail-wr1-f67.google.com with SMTP id v11so253645wrm.9
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 14:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=i1a16XyvRoIOj6Ljs+l1mgrGBz01gHICBnr2Sub8y9Q=;
        b=YM56lddnL6kV6F8B7QrO/X6gik+J53tDwaC1pJcFWGP6Vm2rEFYWLh9+O/z75brJhV
         HzSzppy/BkVay/VMgsIDQ2IJV9+Qw1I+tgvn21uap/pV9Oml3CsX6LNuA79OJpOaD+48
         ZC9yKtKIXtzhB4NN3IslB3yiisFbCoi1jV89wbJ5GBQY6Z8gdZ9WWdEF0hlMdzuimI0K
         7Oz9F9NRFR+e4cHAGufl54hQ7ybgWcFsjkMSgGPcB4bnyViXpMC1P7q7BOOryL066MuN
         4rrZIcWSPc5ob5F+aUskTdPtUtv5W+75d4S9keYWA3HSoVzIDcmFXhBVJkGf9e9jdpsU
         S/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=i1a16XyvRoIOj6Ljs+l1mgrGBz01gHICBnr2Sub8y9Q=;
        b=fQ/zNSKL4wt24HF+OOsovVAtW82V1BaPhnJApU/FMZZdGPLL6gH76sdEGNNokVJZia
         djPRPiiA9xybN6pRnQ4wF3ijGIa5GSC8ACUsSLhp2RLZ6eqSFq8of3ipm8qkJhB2lzju
         qSAkNkxgdOr+yUVmCYt2Bkxi0D719XocBKnU1jz633CPgO6/OoSRi9kSwMd5MKKfTTxW
         MmP6NrxCMF0K0Gw7W8HvjmFETcj2agSmRb+TgmIMzzJVFGo+Iy5ggWLa6ggVCBEZZPvx
         uk6sKBkTnszJcgIGNIhie7OI7ixt4ubuJZgMaDLQHp6BHxn9rJMo/qqs5VB8+ZE8zLFR
         COAA==
X-Gm-Message-State: ANhLgQ3IWCINzJi9HCWSU6wsjuoqYMwEDRC4/kRN/x16SUkzG6ZD9TtI
        nGP9AdBGxyumHcaGPZ+TJvxCVvA8
X-Google-Smtp-Source: ADFU+vtNTu+tYCnI9kHeRBxcQbG9OoS06kx4MND16Gp4fNd3VgTMpn2qlNKuGstxzb3KU2qVvhhsRw==
X-Received: by 2002:a5d:658f:: with SMTP id q15mr7649713wru.110.1584566845607;
        Wed, 18 Mar 2020 14:27:25 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:c8fb:eee:cf86:ecdf? (p200300EA8F296000C8FB0EEECF86ECDF.dip0.t-ipconnect.de. [2003:ea:8f29:6000:c8fb:eee:cf86:ecdf])
        by smtp.googlemail.com with ESMTPSA id c2sm53466wma.39.2020.03.18.14.27.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 14:27:25 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/3] net: phy: add and use phy_check_downshift
Message-ID: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
Date:   Wed, 18 Mar 2020 22:27:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far PHY drivers have to check whether a downshift occurred to be
able to notify the user. To make life of drivers authors a little bit
easier move the downshift notification to phylib. phy_check_downshift()
compares the highest mutually advertised speed with the actual value
of phydev->speed (typically read by the PHY driver from a
vendor-specific register) to detect a downshift.

Heiner Kallweit (3):
  net: phy: add and use phy_check_downshift
  net: phy: marvell: remove downshift warning now that phylib takes care
  net: phy: aquantia: remove downshift warning now that phylib takes
    care

 drivers/net/phy/aquantia_main.c | 25 +------------------------
 drivers/net/phy/marvell.c       | 24 ------------------------
 drivers/net/phy/phy-core.c      | 33 +++++++++++++++++++++++++++++++++
 drivers/net/phy/phy.c           |  1 +
 include/linux/phy.h             |  1 +
 5 files changed, 36 insertions(+), 48 deletions(-)

-- 
2.25.1

