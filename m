Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD41A20CAB5
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 23:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgF1VOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 17:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgF1VOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 17:14:44 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C075C03E979
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 14:14:44 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id by13so1346442edb.11
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 14:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=h18G5OKJVExSWF4FNiJRwqKD2ybvChXaQe4aFTc+u8c=;
        b=sXv7KeztlsJ1LGbmDJ16NA6xP2e4hTDLHLZVnLCsxeCA1vXwjKpRzyMXmxl+mYXTcx
         mTTlYUFPlW1/0SxwLzSSoqjlDLz53cYxJLzP60kIWcNsU5LEJZwIYBsBMuGNogMI1HJD
         FAZ3gl934uWmnJnpv2CeKrbH/v+MOifZpkZskRxIOleMyv1v5XEgRz6SESrrThPn2D2J
         3aSA7Am4k5r39jm/4neo93O5ZsWGOD76ZPziJA9YXpbnyoHiuH9IfUYD8euytPMgVNo1
         21m3eWWc4YGO5OJV09P7coYYIguFmlUgSl3ZAhG4JgxqOevzOxQBnwSTMjORlI/6cySw
         Cj6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=h18G5OKJVExSWF4FNiJRwqKD2ybvChXaQe4aFTc+u8c=;
        b=Anlj5aswD/u0wB335hM6T19kRPBjIyb5RXFoswVxIgErnNjY+2Za0k4ojwmGproOuK
         O11TqdfgVnWjvn2hqFa3TOdzPSakmThm9L8IE3iqzaj3ptDroQ2LK+AHjMNDFvlypTFF
         PCrZ3lRtPe18CC3mC/1PlSvkrpDK4B6/Wm80DGrdhD3jk9Y0kLSLhtmlo2y58FkgOUf5
         /vfTkGk27B5czT9a/YUNxHziFm8F2ZlyX/7kATzCZlPa5XGQacBHgo6SX/XsJB2FkttA
         Zwv0RS8e60nwrL6BHKXenDH2HlHSKgdTLM01M02caXTG27JbYXbxrAN9OTmv0VVUI3P/
         CT7w==
X-Gm-Message-State: AOAM532DSRhXByjaIed9aSTC4wyPa8zWY9h3lrskLMQJBEvZAzPgj1dd
        H1TWncdtb7rizjSkMUWk+7KO9Ghx
X-Google-Smtp-Source: ABdhPJz+ATvMwqkaNF8dWpNLrnCswfJqJAzy0qVuyaaORUKqWIdeLONyBPcyrsOb4FbkabA3Ta7W7A==
X-Received: by 2002:a50:b086:: with SMTP id j6mr11569030edd.6.1593378882378;
        Sun, 28 Jun 2020 14:14:42 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:ed55:9d81:4812:8269? (p200300ea8f235700ed559d8148128269.dip0.t-ipconnect.de. [2003:ea:8f23:5700:ed55:9d81:4812:8269])
        by smtp.googlemail.com with ESMTPSA id y7sm1465917edq.25.2020.06.28.14.14.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 14:14:41 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] r8169: make RTL8401 a separate chip version
Message-ID: <29ba5d31-9a0f-05c4-1472-5b15330f6408@gmail.com>
Date:   Sun, 28 Jun 2020 23:14:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far RTL8401 was treated like a RTL8101e, means we relied on the BIOS
to configure MAC and PHY properly. Make RTL8401 a separate chip version
and copy MAC / PHY config from r8101 vendor driver.

Heiner Kallweit (2):
  r8169: merge handling of RTL8101e and RTL8100e
  r8169: sync support for RTL8401 with vendor driver

 drivers/net/ethernet/realtek/r8169.h          |  1 -
 drivers/net/ethernet/realtek/r8169_main.c     | 28 +++++++++++++------
 .../net/ethernet/realtek/r8169_phy_config.c   | 10 +++++--
 3 files changed, 27 insertions(+), 12 deletions(-)

-- 
2.27.0

