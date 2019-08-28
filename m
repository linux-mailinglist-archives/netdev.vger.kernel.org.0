Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81316A0B3E
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfH1UXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:23:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41725 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfH1UXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:23:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id j16so1074542wrr.8
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 13:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=mrQxKuRlh7uJDmIxNVTYdHcdfiZPdByAzCRoRCpo/Qc=;
        b=KxsPaGBBHNZ3B0D9IIaeqtnFAz+0RdEE2U8SY3QHd/wM+dv+QSpSDrH5JCqZ3t7b54
         ZIHhIdwAL5IAgXGLfJJa1tU7ReChJrd4LV1h3Cjapg+EtqGVP1tBeh+48dcYVBkyo6K4
         p1Zc822GD68ZgZ8tjJyfgZmhAvPK46bqJnO/fxVIu8CfAhvc/7snyQ6uKY56VyHc26z8
         S9sIsXsFZjNhRpmDp6JqynZecGKqCihvT3Oz+BG9P1rDzOm0WGBlODkoJopFJ635Kbel
         3yvWcHckq1WZTbdQrBVk3Ye1UHMex/6ICZ0NqJOEkH87M/MLZw3OtOtgw9D+yoJDw6D8
         bhTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=mrQxKuRlh7uJDmIxNVTYdHcdfiZPdByAzCRoRCpo/Qc=;
        b=a3Y/n5zEAvHvalG8XajojX8v6XJJG3X+Shr46L+m9RMixQZSZiPkReTQY5xrrrP+68
         dt2lXnO8popaGUqtIpY7Vso01TDjY2p+7VFZ6pxTUbIhKIs3F6PYQ9LcBR+rop6nS8JM
         4jbbjVdwhpVHusuY227aYgDEyF3V8JJouzTIynrPJ0todc64Kpr9MlB/XxgnDG9TGP7M
         lIN1dS7sGtbgpDso7cxXHpurC7u27/j3yV+URtU2hIGn20Bd2A0N4gWepQ2J/OIdkjcm
         mLEhw5PQmwcfcopdt2xIFYGdbkonoINpguHpYCwnI5UpKKsB2Ybi9PqmxH69Id4JznYB
         OISA==
X-Gm-Message-State: APjAAAUyP6wkrSx4/hJ5U+BieHPMwFJqvKtCVdihXlydP4CgmGdBPYsN
        oURojNe0avb5W9wWxOovvRLkhwHR
X-Google-Smtp-Source: APXvYqyt07WbMmY4TXOomnTdgTaiLDiyWFmv6FPiJOK5OZLbpzlCGERMajDL1+T92E17SJhxPNZB0w==
X-Received: by 2002:a5d:628d:: with SMTP id k13mr6977694wru.69.1567023811792;
        Wed, 28 Aug 2019 13:23:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9? (p200300EA8F047C00AC08EFF5E9D677A9.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9])
        by smtp.googlemail.com with ESMTPSA id k9sm392630wrq.15.2019.08.28.13.23.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 13:23:30 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 0/9] r8169: add support for RTL8125
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
Message-ID: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Date:   Wed, 28 Aug 2019 22:23:22 +0200
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

This series adds support for the 2.5Gbps chip RTl8125. It can be found
on PCIe network cards, and on an increasing number of consumer gaming
mainboards. Series is partially based on the r8125 vendor driver.
Tested with a Delock 89531 PCIe card against a Netgear GS110MX
Multi-Gig switch.
Firmware isn't strictly needed, but on some systems there may be
compatibility issues w/o firmware. Firmware has been submitted to
linux-firmware.

v2:
- split first patch into 6 smaller ones to facilitate bisecting

Heiner Kallweit (9):
  r8169: change interrupt mask type to u32
  r8169: restrict rtl_is_8168evl_up to RTL8168 chip versions
  r8169: factor out reading MAC address from registers
  r8169: move disabling interrupt coalescing to RTL8169/RTL8168 init
  r8169: read common register for PCI commit
  r8169: don't use bit LastFrag in tx descriptor after send
  r8169: add support for RTL8125
  r8169: add RTL8125 PHY initialization
  r8169: add support for EEE on RTL8125

 drivers/net/ethernet/realtek/Kconfig      |   9 +-
 drivers/net/ethernet/realtek/r8169_main.c | 464 ++++++++++++++++++++--
 2 files changed, 443 insertions(+), 30 deletions(-)

-- 
2.23.0

