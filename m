Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5020D1AF479
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 22:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgDRUH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 16:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727927AbgDRUH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 16:07:58 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F66CC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 13:07:57 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id e26so6470037wmk.5
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 13:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=TJMN/6zjrcaCTEGUy3Lg94U7s72jWZ1Z9CUakvgMz1E=;
        b=ODNp/QVewbcXbjX3wk164px2/YzBWUSrDJz15zlXTuVrwkcsqRecMJrht/sAhNFtJu
         OCVZSo6gTHNxlq5Bh9/EAaJCQxMBWxIM4SbL4XTmOtJQPDLZJPMcJY7ivpq9Fh/b0oQ0
         ua0yC9PDIK9giz+u0AUdl5GA0dj2GmvXZjrP5n8DndkZN6RXqcP4bOxWiSWWrMrz+yA2
         z8PQG+5IB5Id9InGc+7tVIIiQtFKVgxmCr+rNvEin3/t2vsXk4d9VBLHF7GSM1V0X7Pl
         qI/oXDZAZfCzlxybGHSt77ZJSVZ4YWKT/MczIaLoHvRIj6TztOrG/FOoUQZzm066RI3D
         K/1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=TJMN/6zjrcaCTEGUy3Lg94U7s72jWZ1Z9CUakvgMz1E=;
        b=QbZKdJ+AT1xaVkV9L8gTklVuCFwsQaf/vbZsdbPk2STVj1L5QC51TUM0sJxxwVksBc
         8UQz8xZT1SjmmqIlRj8MP/RX/iUHwX7TCRD6RMhAgBaoevVeUB/Y2qZWR4hNGiCRs8O7
         5pewVQ2Bs8DRxH2F2zexoPlqvTWhH1OjOhsWhHo8aNGfYj53ZSA09MZAREsWpFpPPU27
         pmjQ0tmclLJAPSitOgysYy2NpS9qqzomNqlBh0rFj9JIs+GohUwRSXNY12S1OncUptuf
         AvqNTra03aNUcuj8DAQs3tpWgesQhjMcmhKioyW5f0swwl+XTe6TbX4GHDmlPxe+GjIp
         bSuA==
X-Gm-Message-State: AGi0PuZwCtoI/vSf2IPs9omgZdWy9P1GhjEz1bOVNJtfjv+MgmzuLjUq
        JbmEy1shlDrcFfaQP8cz320G1nQH
X-Google-Smtp-Source: APiQypKFeGuUA7he0VgvnLv3K3TnG7pIEhg3l9rFhRdN0A040M4gaQMxmPMiKzMAuyLUwCtbzV//Uw==
X-Received: by 2002:a1c:6545:: with SMTP id z66mr9182190wmb.81.1587240475270;
        Sat, 18 Apr 2020 13:07:55 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:939:e10c:14c5:fe9f? (p200300EA8F2960000939E10C14C5FE9F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:939:e10c:14c5:fe9f])
        by smtp.googlemail.com with ESMTPSA id y63sm13060415wmg.21.2020.04.18.13.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 13:07:54 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] net: phy: realtek: move PHY resume delay from
 MAC to PHY driver
Message-ID: <c4e18f15-7c37-13a2-4e26-1203da318f67@gmail.com>
Date:   Sat, 18 Apr 2020 22:07:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Internal PHY's from RTL8168h up may not be instantly ready after calling
genphy_resume(). So far r8169 network driver adds the needed delay, but
better handle this in the PHY driver. The network driver may miss other
places where the PHY is resumed.

Heiner Kallweit (2):
  net: phy: realtek: add delay to resume path of certain internal PHY's
  r8169: remove PHY resume delay that is handled in the PHY driver now

 drivers/net/ethernet/realtek/r8169_main.c |  2 --
 drivers/net/phy/realtek.c                 | 15 +++++++++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

-- 
2.26.1

