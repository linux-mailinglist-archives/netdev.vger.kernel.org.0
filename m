Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C803AEB4B
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 15:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731672AbfIJNTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 09:19:07 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35955 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbfIJNTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 09:19:07 -0400
Received: by mail-io1-f67.google.com with SMTP id b136so37416420iof.3;
        Tue, 10 Sep 2019 06:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3NoG0vBNoSx4CrvuLpw+01gKlsQbKo/T85d3WjtfkAg=;
        b=AaKJ46g2++b8dR0pLMw/fVSQKFnPcvgkEe6d2fnb7QfYpXf0A6Dc4rdgAiZwng7fBy
         6iyXBoAKffc48qaVpMHaSgdYJ/L5QY4ngzV2OCgiGQz3700DkLpPpXP9PWu5Vn0Ddrbu
         icprOUAZePHNxJY8BpQjCi6LpvcfyAoW1jYjmDzuTrjaEuA4f68JT76KsZ9a4jN5wTm0
         ksnBR+6WJcU72Ii0G/8L1uima6qa9Mjp4sxCAWJuG/lq71Ivapli5PKzZheANiGoWJ6P
         9O6cDLdJAVLwE2zpqz0RcqeEgFE+suorqjE1VQj5BHsVSqz2Dopj1LVmeaTFpkTNUwuT
         O8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3NoG0vBNoSx4CrvuLpw+01gKlsQbKo/T85d3WjtfkAg=;
        b=kubkDKA+CpeVo7EMq3qCQxsl51ui8tFvPbB2POp9aimVYhfs3TrKijtzF2dtO/VOuo
         wWRBqs9sbAmY/naN1IIZZ3Jvh37SItGVIWrSoeymSvo6AcyyQ1ZKfVYNY/zc+ywIkEVv
         UHTlM0xrngaTef6tutsPJ0pf1gNtJqT/GSERUmhnihmzYEk85NlkEGb63eL3IE+Bylft
         +W7P8K7OE31BBFlUjUOvuNlNfL3HQP3o8yEJcM673U+kpjXyZjiMdVlF/+xLweBnQzWV
         wfkOQq2KKvSal+/tuWxkKO4XBJVPJL+AEIEtKt5/lgV329DHlIpwoLisqjHLsTiW4t7O
         0T4w==
X-Gm-Message-State: APjAAAWBbDmtxZqTL9tXy0e2E51uHhglcFYctAgj6SI6rLXCKsuW3kxS
        5ISL06FcBLjQqaqm4GSHfMqCHhaJFg==
X-Google-Smtp-Source: APXvYqyCuj0U/E4bD0SfA1DH2xQRTO/LWC8u2d9bDME7fG2ojEwL3WcSf3ejelZRkrYEpW/dR9cgjg==
X-Received: by 2002:a5d:8908:: with SMTP id b8mr864488ion.237.1568121546514;
        Tue, 10 Sep 2019 06:19:06 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id f7sm13642740ioc.31.2019.09.10.06.19.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 06:19:05 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v2 0/3] add ksz9567 with I2C support to ksz9477 driver
Date:   Tue, 10 Sep 2019 08:18:33 -0500
Message-Id: <20190910131836.114058-1-george.mccollister@gmail.com>
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

Changes since v1:
Put ksz9477_i2c.c includes in alphabetical order.
Added Reviewed-Bys.

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

