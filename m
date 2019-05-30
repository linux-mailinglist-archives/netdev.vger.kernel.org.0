Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 384102FBF5
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 15:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfE3NIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 09:08:22 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55457 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfE3NIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 09:08:21 -0400
Received: by mail-wm1-f66.google.com with SMTP id u78so3936565wmu.5
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 06:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=X/yEvHEOsy7meaCxrunFX8CtRb5hAyCFvZo80B/f1wk=;
        b=IoFzqobIFyuHrqokbDiUdgY3XkQaNT8L/r21vtFC0uevqmVgbzX+SbuVB8SVH09Ag4
         uY1p5+vBDcPdBUjCOkDxRkiiNOmRTBL0O+Ac1dFBQEgMf1xdOwxqwsXLZnpcXg/FHbpf
         qOdfJxSRd/7kHgLx2aBjjxiZvfONT+lcDmb8KC3gyXUWxX3TI7W5aqJCMNQvS2/N7NFe
         /2ZJMyYNMuTUdysK9QQGSNQKq7XX/u6dgW9thQwadrs7ZmMzTIDoYT8mqGaUROY/XpR1
         XtgNKJ7jW++Ml7mvlztM8WIyZfVojYrtVFrktGNsq/b531cXguRGw9bOgTJmQ97ZmmzI
         DXDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=X/yEvHEOsy7meaCxrunFX8CtRb5hAyCFvZo80B/f1wk=;
        b=mhdOUcFcRYsgAAtCPvv+xeityq/yrqhmmyFUthhLDoyfN+neSidgU/DFyk1XzrJoYq
         KIZtkptuAzJPDfmZkGxcy8PfuuSspZ3A8kEvK79nGbZLrQHbDpEqpv8OwkLLpewAQcP9
         uOmSAVCngNMYE7aPM3E5NvMvc2Ov3qS7ix/Vu/2aW/xQiCfV/XI6AwAsMeK94rm4nnVZ
         PU/DQlwynFd57H5/saaO8ip7G7nhaf1srtFnoH+ZCxhW0f86dMa1lQnpk4Jmv+Z4PbM5
         XDwpBUrtnl9R4Xb7P0XbqKQhW37QiGAIS0y3jNS4CaJvxbbCoKYo1hSkWcCMRUVOfQl/
         Rxdw==
X-Gm-Message-State: APjAAAWvuitOy03TWgRrDI1lH/37INZp4/fYc31Y0WgRxFmxGl3dP0QZ
        qDg3YUsJfRg0EQ7RRXvPybjt5cze
X-Google-Smtp-Source: APXvYqxrqPgsw+NWpi4Lm3saWqWiZscxFEqIX7kutFKs2nOvUbW/Ky8ASIZUvJ+eY99T9Sb85NVcnA==
X-Received: by 2002:a05:600c:21c1:: with SMTP id x1mr2208473wmj.5.1559221699271;
        Thu, 30 May 2019 06:08:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:7d95:5542:24c5:5635? (p200300EA8BF3BD007D95554224C55635.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:7d95:5542:24c5:5635])
        by smtp.googlemail.com with ESMTPSA id y17sm5474969wrg.18.2019.05.30.06.08.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 06:08:18 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 0/3] net: phy: improve handling of more complex
 C45 PHY's
To:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <52f1a566-9c1d-2a3d-ce7b-e9284eed65cb@gmail.com>
Date:   Thu, 30 May 2019 15:08:09 +0200
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

v2:
- added patch enabling interrupts also if phylib state machine
  isn't started
- removed patch dealing with the double link status read
  This one needs little bit more thinking and will go separately.

Heiner Kallweit (3):
  net: phy: enable interrupts when PHY is attached already
  net: phy: add callback for custom interrupt handler to struct
    phy_driver
  net: phy: export phy_queue_state_machine

 drivers/net/phy/phy.c        | 53 +++++++++++++++++++++++-------------
 drivers/net/phy/phy_device.c |  2 +-
 include/linux/phy.h          |  6 +++-
 3 files changed, 40 insertions(+), 21 deletions(-)

-- 
2.21.0

