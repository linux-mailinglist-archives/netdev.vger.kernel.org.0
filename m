Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628E32F0963
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 20:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbhAJTs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 14:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbhAJTs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 14:48:26 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CB2C061786
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 11:47:45 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id a6so12140303wmc.2
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 11:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=pNgpCJXjNoLouaahYIgdCsJghfTLYmKaQ92CNDTuIPY=;
        b=NG63RbUkVx6Mom+R5MnE4aiSzzV3z1A/rvN+uQwPwUgMRgpB3ETXmQVWFa0h3R1DzO
         /I9Q5IaGt/vV6xM1vQip0mAjnthAOz0TtMhRM3AZ8xplsF/SmI93Bsr81JOg4iyaMQNS
         kamKnfxO9GUN2PfUwMhMAaIqqMA0w6g/H40iZPKkctxX9sxYcHu+g57d7zZV/6S/N0dq
         rHXm6zP1Ql6wA32wQR0j0Bgg4DQpjuy2RJPs6UH6E1v6j+U6lRMKSCNPvW76lQIqT+hJ
         lvlXwyCQ6hN7/3SKeqlGhkMj9u7zjeDCjP0aJa+Y6U8AgKt6gOwADy341k0SZf3LKIrF
         yhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=pNgpCJXjNoLouaahYIgdCsJghfTLYmKaQ92CNDTuIPY=;
        b=O0p4SJKtELvaSL7RgDPUCVet7T6Rb7G1qFn8mwfpHY5HD6CkaEPJpUj1NeInEH9gME
         FVt0bMT6ZZJ+Z3iEnRA2pkVGNZ0kyJlZX8CbJzjVPil1wUiahCv59uMbdJiA3QHzgnmK
         RhE38vX8zUKZf2Soh8zeYOUJjbs0bLn8CXUy/AEwbmcyQElO8Q/UpxPif3Ul5bVn4MFI
         3nEUtsqIUf6hIHQEhZVZrjMfhfb3TkjvhF/DPBy02UZ2S4/O9rsnc94rKjuZNzYXM91r
         E6FmAnbMmek7Ym3//404ct6Ou3S/PBSMMizYFH0wknAYM+To/THlUHvP68DYN3yPgcub
         /O3w==
X-Gm-Message-State: AOAM533r5N6wjNuZ1IWSc/ylDXP/CT3vmSqOsge1jAihk3Q9W4VUCxiM
        DI4AOIRpvV0paySUiWAqgLpOGBV2tTk=
X-Google-Smtp-Source: ABdhPJwChAFcDn9Bl3SDHQx/ppGE6ahuOPtbZ1mHSMNTfKK2WOzjV2zUOSiJjku9XsyhHOxfwjmwtw==
X-Received: by 2002:a1c:5447:: with SMTP id p7mr11897892wmi.116.1610308062182;
        Sun, 10 Jan 2021 11:47:42 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:5449:e139:28a3:e114? (p200300ea8f0655005449e13928a3e114.dip0.t-ipconnect.de. [2003:ea:8f06:5500:5449:e139:28a3:e114])
        by smtp.googlemail.com with ESMTPSA id y68sm21745353wmc.0.2021.01.10.11.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jan 2021 11:47:41 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/3] r8169: improve PLL power-down handling
Message-ID: <1608dfa3-c4a5-0e92-31f7-76674b3c173a@gmail.com>
Date:   Sun, 10 Jan 2021 20:46:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes improvements to handling of PLL power-down.

Heiner Kallweit (3):
  r8169: enable PLL power-down for chip versions 34, 35, 36, 42
  r8169: improve handling D3 PLL power-down
  r8169: clean up rtl_pll_power_down/up functions

 drivers/net/ethernet/realtek/r8169_main.c | 65 +++++++++--------------
 1 file changed, 25 insertions(+), 40 deletions(-)

-- 
2.30.0

