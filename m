Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 347A08E880
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 11:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbfHOJpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 05:45:30 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39656 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfHOJp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 05:45:29 -0400
Received: by mail-wm1-f67.google.com with SMTP id i63so766607wmg.4
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 02:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=j89fEnpB6tFzGzebzp/nwxyJipR5lGMihfVQdjk2dXg=;
        b=cCT3tYSPs0+xo087CqmFDuLGcg4uzEPh96geZA8891eXyKzADFp/Dz1DJTH4/DE+Kk
         CGCxKmJum/S/F4fDmkRtgVEqjqZpVpXUmDLfCgMEztC/k+67U3kRJH9r1Wi1FyqiGScQ
         1hD+6kJQmM2LzgCYywkPXbXdlCQxvRaKy6JJPGWEW0/vEH7l/tAiG2AKFjIQ1LRbmsEb
         noVIx/ZrJFhc90TUbxxydBYmyISdL3Tf+ZDNl/Eu4qi0KmrQ8VNi2DYJR44cGT/2t1dw
         n5ubJN0sPNDQJoLgmxSuEnJLNthYXwU1pnxa+gdrL4Oe9D6pQ4u32ke3z8OW8wnBKctS
         HMNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=j89fEnpB6tFzGzebzp/nwxyJipR5lGMihfVQdjk2dXg=;
        b=RvvBeWWt2OcXe8Wn8uPSeIJBDnoc/46+MjyRTRWm9Ld+Vnjz8v3QBwN8R6BoWixYKX
         qYz5903KIO3BpgRkAOv/xWt3JmvjTp+OfHi9qpBjtR/okmPCAmokEOsVokzxY0slmEkD
         QHaYIwbl8rYK3GS2rWTfM7Q7svPRZ6vZkOT8/zMLfqvGvGlMV+k/KFqrXqKM7mJvQdyw
         uWtMGDie60uyJNT8nwCuBZr1rD9u0319q2bWV+uyvs0EihYbGhbHpjTvVetR+MM1abDX
         IDUuD77Dl0RWvspoGHfcmCxSDQFE/GeprGS4V3xWet/EVA5L2JRNDWus6WdBaCF5Gjo+
         YwjA==
X-Gm-Message-State: APjAAAU2+WPGo6TZvfL1MrInh6gZ/Qgs8l0sbHmV0nWCwFELgPuHJxeF
        xPMAe5n384htwG/+c0KiOdkBZyZX
X-Google-Smtp-Source: APXvYqyT04INxpOWfSaRe2640/qbKqLnKZVjxqGOnogmGPrCPgLjXtITjjYyjEcpjiH1sW1yqV+YUA==
X-Received: by 2002:a7b:cb0f:: with SMTP id u15mr1755306wmj.173.1565862327378;
        Thu, 15 Aug 2019 02:45:27 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:7cbb:1cda:9a01:259c? (p200300EA8F2F32007CBB1CDA9A01259C.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:7cbb:1cda:9a01:259c])
        by smtp.googlemail.com with ESMTPSA id 20sm684255wmk.34.2019.08.15.02.45.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:45:26 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] net: phy: realtek: map vendor-specific EEE
 registers to standard MMD registers
Message-ID: <4a6878bf-344e-2df5-df00-b80c7c0982d1@gmail.com>
Date:   Thu, 15 Aug 2019 11:45:14 +0200
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

Heiner Kallweit (2):
  net: phy: realtek: add support for EEE registers on integrated PHY's
  r8169: use the generic EEE management functions

 drivers/net/ethernet/realtek/r8169_main.c | 172 +++-------------------
 drivers/net/phy/realtek.c                 |  43 ++++++
 2 files changed, 67 insertions(+), 148 deletions(-)

-- 
2.22.1

