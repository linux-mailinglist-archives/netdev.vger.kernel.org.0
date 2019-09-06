Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B74F0AC206
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 23:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391732AbfIFVb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 17:31:29 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45150 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388050AbfIFVb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 17:31:29 -0400
Received: by mail-io1-f67.google.com with SMTP id f12so16000326iog.12;
        Fri, 06 Sep 2019 14:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xVwpmZ2ZtvdywiC1aj2psfrcaWaJNdDJ11Fduy+f3HM=;
        b=pifvv8St5FQaAQPjk2WT98XQiM3BW6BdU8LlrGB7GiohB2696W5SFXceYx+isaDLWy
         DblAMPyZGKZKnpiVf0Y6Fdc6tALGBurl0lhmxwME9HSyXyNUsWbsV2L4BqzC07Z80+6L
         voCMFmkUZm+umHMtxzbLZQQzo9wGeWUg2aCeCz0OOy5TvkjZg1FQOXYrYOl/xTYi4wFv
         DD9z1dAGxWJeV/qkLM498RU26Om0F1IfCaG7Ql3uSk8fz7Z1c7X94SxEu6NmH9bj4Idz
         0mG/3sv07qeqYRRwZYCPgPfJpvZCQJNtjYwvIA7GU3c1KrzQcL7YLMGjyqUMDFpJQ2BG
         UIzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xVwpmZ2ZtvdywiC1aj2psfrcaWaJNdDJ11Fduy+f3HM=;
        b=VsKfxfg8011HpZqs1gHSaWUIv3BruCcZqzNz/QKarvuyRSsAXTUUm1zDid8rhVMFVy
         TX6cC3llRVIXSU05ZO7+f0hG6OpMvYfOomLriDDhV9wPMj5VgGNcst2hJiCT8oSiVmSI
         OJK4IFj+YKFowaGN903rlx2SjJRg7ho1zgcd6yUZi1QaQdvEhhGZT7JGvBTdh2mr6R2w
         AWhe5TkOjPn8Ez+MSmqLGHvDFP24PFp8daeMM5poD93ZAw0GzGunlvwMy5KRZEA+4IQV
         Vr+JvRFXEhi+VnTldGUvAg85SCRVKq1CFctv92XUAbxSGVJWCK+8bZQBMo9YsbPUqjia
         jQ1Q==
X-Gm-Message-State: APjAAAXpcN4YfbnldDlmfMAan3t3JBj/i5IakJV68zvgxLLg5atMIc8A
        cRlOIlXDyyC4ghfeOe91bLrj46ayXA==
X-Google-Smtp-Source: APXvYqwq12dav+L5hmnDjzwDq6Gavs6929nwU75cW+mTayMD4U4e5mZ4kHvn8RDV8b1YVbXJZBtaVQ==
X-Received: by 2002:a6b:6204:: with SMTP id f4mr9408758iog.175.1567805488374;
        Fri, 06 Sep 2019 14:31:28 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id r2sm4158110ioh.61.2019.09.06.14.31.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 14:31:27 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next 0/3] add ksz9567 with I2C support to ksz9477 driver
Date:   Fri,  6 Sep 2019 16:30:51 -0500
Message-Id: <20190906213054.48908-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resurrect KSZ9477 I2C driver support patch originally sent to the list
by Tristram Ha and resolve outstanding issues. It now works as similarly to
the ksz9477 SPI driver as possible, using the same regmap macros.

Add support for ksz9567 to the ksz9477 driver (tested on a board with
ksz9567 connected via I2C).

Remove NET_DSA_TAG_KSZ_COMMON since it's not needed.

George McCollister (2):
  net: dsa: microchip: add ksz9567 to ksz9477 driver
  net: dsa: microchip: remove NET_DSA_TAG_KSZ_COMMON

Tristram Ha (1):
  net: dsa: microchip: add KSZ9477 I2C driver

 drivers/net/dsa/microchip/Kconfig       |   7 +++
 drivers/net/dsa/microchip/Makefile      |   1 +
 drivers/net/dsa/microchip/ksz9477.c     |   9 +++
 drivers/net/dsa/microchip/ksz9477_i2c.c | 101 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz9477_spi.c |   1 +
 drivers/net/dsa/microchip/ksz_common.h  |   2 +
 net/dsa/Kconfig                         |   9 +--
 net/dsa/Makefile                        |   2 +-
 8 files changed, 124 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz9477_i2c.c

-- 
2.11.0

