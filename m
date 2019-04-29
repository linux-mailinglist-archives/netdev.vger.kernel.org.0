Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E66EB69
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 22:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbfD2UMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 16:12:45 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45877 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728928AbfD2UMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 16:12:45 -0400
Received: by mail-wr1-f65.google.com with SMTP id s15so17831608wra.12
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 13:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=k5nJmaBF6OpSVcZ5LfAT9LCyZcfx5x+XkhPrq1bZw2c=;
        b=e8OvZZA8myNRhPu5pHBxt3BAKTu97XA4FupS6FMoUzPPy2QQ5sBNBk76zOqlQYs5sl
         fvve54wixONHgniMyCW5dK4ZO/31wsrgicYL8e3ENnUAtw6UBxFac3ywsAz1smdpWP4Q
         5prVy/uYQkCU3rN/GCeIE+afugBDjyZ5uXEFtVrlF4QxO61gb9Rjz6mCOgb7Dg3eu1Z3
         DpObNlE8sHzuXGS9Wek0lVXZT/BhlPx7MK1cNH9OYdy5Letqy4UuniXfKurH2yAsxcWh
         AbQGGJZRdrCMDWaVYQO/YlDO3DqDMUUgzL9EwEZA8pdGtsyJHB9ZZDvWn4CvHGEcWqHQ
         QjcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=k5nJmaBF6OpSVcZ5LfAT9LCyZcfx5x+XkhPrq1bZw2c=;
        b=OxA8P2WbKmXYfvs1ziCN6amuh5nmHPGzWibA8R2EOirSEIn7JljRR/RTq6QkIrbUtv
         fTE6oP9LvcQ+Q4x20/KxTnQuHDBfI8RncLc33Jy4ol4o/2kn1oDRhGTR0s2kB8Yf9oyP
         CBFxCRCdLHa34mOCVM4rFWVs8ht4r6rTERTSKaXjS/WeuZ9trUrIP8bqeRih3iPpLOvt
         tlesivzu3tQXcDT44f2p+KqTk5+bRZ1x9X7gVXxqzrKH72SqM+i6sBG8A7J1sI/5Eh4a
         e4alfjJhCDoDqQ6mF9Fp62p/xvFh5Av4cmkXadPDGmsEOlGCH0H7/xpG7b5/fQPEq2oy
         Wpxg==
X-Gm-Message-State: APjAAAVChXTu7JbMU8XHaimv919hWJ4rbyNyjREIoJjeUHFvp/92lHG1
        g/OOZQTtasHHcYwnO1QMxZor1I+AWvE=
X-Google-Smtp-Source: APXvYqxkqR8g7lBXJWBvmw5BYzJGkiWpoJdNinK3P0ZHdytppdUF1osuXM1L34KgfqjMtP6OZKridg==
X-Received: by 2002:a5d:698b:: with SMTP id g11mr40815551wru.65.1556568763493;
        Mon, 29 Apr 2019 13:12:43 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:2492:3326:fa98:92d1? (p200300EA8BD4570024923326FA9892D1.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:2492:3326:fa98:92d1])
        by smtp.googlemail.com with ESMTPSA id m25sm315717wmi.45.2019.04.29.13.12.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 13:12:42 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] net: phy: improve pause handling
Message-ID: <5ac8d9b0-ac63-64d2-d5e1-e0911a35e534@gmail.com>
Date:   Mon, 29 Apr 2019 22:12:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on a recent discussion with Andrew that's an attempt to improve
several aspects of how phylib handles sym/asym pause.

Heiner Kallweit (2):
  net: phy: improve pause handling
  net: phy: improve phy_set_sym_pause and phy_set_asym_pause

 drivers/net/phy/fixed_phy.c  |  2 +-
 drivers/net/phy/phy-core.c   |  2 +-
 drivers/net/phy/phy_device.c | 64 ++++++++++++++++++++++++++++--------
 include/linux/phy.h          |  1 +
 4 files changed, 54 insertions(+), 15 deletions(-)

-- 
2.21.0

