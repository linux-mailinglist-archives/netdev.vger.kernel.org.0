Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F958A99A
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfHLVrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:47:53 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39803 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbfHLVrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:47:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id i63so744880wmg.4
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=35LvROtTP95KJWYYOHQDz0ZbGX0mHcGh/nQ2zkFRBpE=;
        b=cfaTabbhuztexWqnauFzuNL21Mr/iN1DOn3S8ElTtriPlfm1vkpnugYjUZrYh+VQD3
         eZVBtf/BIQguixu3xW7YmLfjPOeO/oV95O4r6kRo/5UHmAT/FCN4BqOD/t/0/Ykuighw
         DD8AmbZYXR6xW6ccKFeNS399JF9sGrK1c0b+c8XB3dvhMrKZcAbMRwdXH/4lDDR1vVFG
         OFxyOEPTlcUj85/vX8nKVDga+yNHpDd653V3tZJ6e+Pp8NQrE8GV98ULPFrE7itX1lC6
         1gbLe9vxcfeniV6BX7uG5kmykXMjg3nTjqgj1pBzb/++VJmHgDackxbqsEXZCyEMjrOK
         DEwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=35LvROtTP95KJWYYOHQDz0ZbGX0mHcGh/nQ2zkFRBpE=;
        b=XiuPa/z2pj+exI0YNP7bkuG2Ls8U43gQuMTP2BUFf8kWLw4bHHMicLvyvBMfToHmBm
         mX0WUCev1oMff+Olk1TlO2XnYd1nnf1jf8zUI/5i8ZV/CuVwt4yF4inlkL4px2zVcaVe
         RxcGLkuJZjwo1d2AtfsyydSXy1pD33oLXSCmnJICWzJLCAVmC9HZDiwucuI3FgqvqR9J
         Z51k0/OqfEsdJbpa9Pzyx8U8eW+hOiRgjX6uZlSXHaukerZg3bcfIdylho11sWEhhG8U
         5dysOl0ZkPoKoyIrEBojlpObPKUhB1jzOGENbYn888Zo3nCJ/F5DTS2yRPnLoV4PFtEJ
         ZUUQ==
X-Gm-Message-State: APjAAAX+S6i7CnMXTXs0lwz3n9xxo0PU7N/nISliQgdJMI7VTRcvPM4j
        bEDz4Kom92WktBeRByKLsmz2sQLs
X-Google-Smtp-Source: APXvYqzuLDks0gzfscMbtsDgN1g5EeDxRgs9rrRhFxAWjAsKCs7GU31bed7fqxgZnLB6v/s1hLo3dg==
X-Received: by 2002:a1c:9889:: with SMTP id a131mr1088174wme.22.1565646471454;
        Mon, 12 Aug 2019 14:47:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6? (p200300EA8F2F3200E9C14D4C1CCF09D6.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6])
        by smtp.googlemail.com with ESMTPSA id c65sm871704wma.44.2019.08.12.14.47.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 14:47:50 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 0/3] net: phy: let phy_speed_down/up support
 speeds >1Gbps
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <dca82a0e-e936-b60a-3a1c-9fdb1714d1d3@gmail.com>
Date:   Mon, 12 Aug 2019 23:47:45 +0200
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

So far phy_speed_down/up can be used up to 1Gbps only. Remove this
restriction and add needed helpers to phy-core.c

v2:
- remove unused parameter in patch 1
- rename __phy_speed_down to phy_speed_down_core in patch 2

Heiner Kallweit (3):
  net: phy: add __set_linkmode_max_speed
  net: phy: add phy_speed_down_core and phy_resolve_min_speed
  net: phy: let phy_speed_down/up support speeds >1Gbps

 drivers/net/phy/phy-core.c | 39 +++++++++++++++++++++++--
 drivers/net/phy/phy.c      | 60 ++++++++++----------------------------
 include/linux/phy.h        |  3 ++
 3 files changed, 56 insertions(+), 46 deletions(-)

-- 
2.22.0

