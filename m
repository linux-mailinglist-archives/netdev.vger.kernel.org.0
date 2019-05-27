Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6AD22BA1C
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 20:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfE0S1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 14:27:10 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:55257 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfE0S1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 14:27:10 -0400
Received: by mail-wm1-f54.google.com with SMTP id i3so306984wml.4
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 11:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=sN9QuWTKjO37Ds+bKnSwCLJ7NU8/LG9sLSw2bj39kzA=;
        b=o6pixEY6Dn/LwRudTcebcKhfo7qXh7iV/8Y5ETK+Dj3BOabH1sjRDkdCGZ4SMRI3Gb
         b+ozeES032GScYdoojX6OQqIGwLrD2aM81RTeSF9Ad25lvSaLKMJZBGlIOt8m6nOCyR9
         SEUUnz9/k0KVBZrE3QPleHCd+1d2NfuBkby8iqzPA6p6nXpM1Zf4vgY1g3mGHKgpxhM4
         ZwrV0vhCzvLoncuIbuEf3a9RCzrKtSB0diDOqxsklqqVrDpx0tr6VOF/ajIdnVHCyr6C
         CUiydsAYxDw2leuow3AO/3m2hv/yHIp+Y5zrjdW4oRfMYFPNPiibNYOsAIXo/PqbnUwV
         vTWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=sN9QuWTKjO37Ds+bKnSwCLJ7NU8/LG9sLSw2bj39kzA=;
        b=W5L6/NbJuFs7XjO2HKUM5RHzefDKAWBcssnEBbs2H/YlftiY4cSVP27r0ZV6NpRBdA
         jFN/Kjp8RjHp3WaYR9oD0P804JVAs3U3L6qlenL70LQpan+8FG2LNhDzckY0b8RSUK9z
         UU7RIzJfSfHcKDO6OzgZuaFeLamJjcy72nBfP8rvZgC8+Z/hc7Zg29jYBHlVty+9D5wL
         kDVFn/RSeIoBKdlkvQZvFMiKBCTYhsD0Ur78jTewxuPqMQB5cLpu3YmsSjJ+Jnigvp/E
         7Hib1dECK1fKbSPRq6ZC1R0vle7KThCy/DCWrP2GigN0rTE7d2HT6fVdrkBPLWUKDYvo
         slgQ==
X-Gm-Message-State: APjAAAVvsihR2zOi+pozkzfCm1FBehWuRLFUtnr7tlPSSJxhTEzoefk6
        EqCl5W8vWDF/RdRpitIQqXduGTO5
X-Google-Smtp-Source: APXvYqyQNESHz9Z4PUb5M3Q+hSyfqvNXykVOyYD5e9eo+f1vgtm8EMCTSGBfxxiSmIQ7aBvGx+1CGw==
X-Received: by 2002:a1c:6a11:: with SMTP id f17mr241797wmc.110.1558981628179;
        Mon, 27 May 2019 11:27:08 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:485f:6c34:28a2:1d35? (p200300EA8BE97A00485F6C3428A21D35.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:485f:6c34:28a2:1d35])
        by smtp.googlemail.com with ESMTPSA id n3sm8681929wrt.44.2019.05.27.11.27.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 11:27:07 -0700 (PDT)
To:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/3] net: phy: improve handling of more complex C45
 PHY's
Message-ID: <e3ce708d-d841-bd7e-30bb-bff37f3b89ac@gmail.com>
Date:   Mon, 27 May 2019 20:26:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series tries to address few problematic aspects raised by
Russell. Concrete example is the Marvell 88x3310, the changes
should be helpful for other complex C45 PHY's too.

Heiner Kallweit (3):
  net: phy: export phy_queue_state_machine
  net: phy: add callback for custom interrupt handler to struct
    phy_driver
  net: phy: move handling latched link-down to phylib state machine

 drivers/net/phy/phy-c45.c    | 12 ------------
 drivers/net/phy/phy.c        | 28 +++++++++++++++++++++++-----
 drivers/net/phy/phy_device.c | 14 +-------------
 include/linux/phy.h          | 13 ++++++++++++-
 4 files changed, 36 insertions(+), 31 deletions(-)

-- 
2.21.0

