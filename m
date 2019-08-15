Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29DC38EB34
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730762AbfHOMMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:12:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42514 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfHOMMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 08:12:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id b16so2013365wrq.9
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 05:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=fAF0uZN2O7UERv4jS61z0vILh7J/mlBYs9wS8Dk5G5k=;
        b=mbAD0eDSf2+GVUqdXfBr9h18KwbvBZGUlkj0B/LTxcnZ5Cz9k7/13kmHmY6hmG3Y/g
         gPIa2+1FBPEB60nsGWXt8ISC5AE/Nc2RKi7uheGoTOBhSJtNeSEHyTykUmLOG6ezTirM
         eH5xQB1ukZyrFGTSIVmVkuefdAk2aBC+m7L+91R1Fc81SGcsllMUkR8qHzWmZvk4gh6l
         vinX3d/lGkJc43vOxThGZ1VvJbm1fs/pN0alLuyjd0ccaAmYdcD9dBKFp40+pK3AHAS/
         9+MeG03SSgybNotCtZsKrz6qXtjabVPUqcAQt4JQ5Z4zjpupxkk/qrGvSA6iQP3Cmg4V
         9u6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=fAF0uZN2O7UERv4jS61z0vILh7J/mlBYs9wS8Dk5G5k=;
        b=BEUdJ7ruDNG/Cyd2kvZegU6FuasqMF+25Nq9gHbfVpCqeo8LpH4+582TRXo2nMQhqR
         dorEpByBulO2mZPhwPhIGzkHWUHwYp871J7D3tmru4DD9HAy2GZD+sO1DUoAkNrk3vky
         ozGRZnYzkuE9ddnWXHCDUTynxBnZXmbAMbOIe26HZNXJN4Mjz3Ujb/IqbdaIGO0fmxvs
         rle5ziRWodLEhYyCT26esHQ2hwVwQxUysh07cBrNK+kT891+SxR2O6jUx+ynBw0cp0QM
         XQel4WOJyB7kss2U5Q4Dt1/JNe335uizzjf8tei/Kc7B0vz8xpYdcFTuXSSx8yk8V8tW
         znDQ==
X-Gm-Message-State: APjAAAWkFcRqyNjc+gtmmLgF14MN5GxFG+DmTwf2c7iAySv38hrBoQx1
        3vglqp43PTzR0Wp6btrhqzXiDOVe
X-Google-Smtp-Source: APXvYqzNod2gJQHJKKbTMqM5f8zC2N8lY99WFMZlf88t1scShktkNpHngOov6inA1USQcxwFLUkfdA==
X-Received: by 2002:a05:6000:4d:: with SMTP id k13mr5228040wrx.196.1565871137340;
        Thu, 15 Aug 2019 05:12:17 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:b8fa:18d8:f880:513c? (p200300EA8F2F3200B8FA18D8F880513C.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:b8fa:18d8:f880:513c])
        by smtp.googlemail.com with ESMTPSA id f6sm3293236wrh.30.2019.08.15.05.12.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 05:12:16 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 0/2] net: phy: realtek: map vendor-specific EEE
 registers to standard MMD registers
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <88a71ee7-a17d-ac9c-c998-d0ea35e5c566@gmail.com>
Date:   Thu, 15 Aug 2019 14:12:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EEE-related registers on newer integrated PHY's have the standard
layout, but are accessible not via MMD but via vendor-specific
registers. Emulating the standard MMD registers allows to use the
generic functions for EEE control and to significantly simplify
the r8169 driver.

v2:
- rebase patch 2

Heiner Kallweit (2):
  net: phy: realtek: add support for EEE registers on integrated PHY's
  r8169: use the generic EEE management functions

 drivers/net/ethernet/realtek/r8169_main.c | 172 +++-------------------
 drivers/net/phy/realtek.c                 |  43 ++++++
 2 files changed, 67 insertions(+), 148 deletions(-)

-- 
2.22.1

