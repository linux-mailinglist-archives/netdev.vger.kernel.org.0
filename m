Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63E8C1044C0
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfKTUGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:06:18 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:44361 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbfKTUGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:06:18 -0500
Received: by mail-wr1-f48.google.com with SMTP id i12so1378495wrn.11
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 12:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=1/bRuK3tszQ66l6BR3X8k6Dyc5A/y7faIXzkAd76+sM=;
        b=UyszCncBGiyF0M3Q3kDoiEygzMpCcDx5tZ9HVGi638Wm1MZjLt0S+8svuHsE2zkHrg
         9f7gf8w7QP0J9s9BiId3UCEqeV28chsDvXqNDRlp5DO4oVdrgCijeus0SQOHwGa+8idT
         aQD1rl4JCI0qL85fDNL8ne1R7mc++cCkha0JomEAOFfcwv95wxlrz4FzevmRKZ1iBe1D
         3W9WWxpdDs25+RJbbKBsx7ShtekPSJMuYW8dyaOg0SIDmZt9fE6vQ8SglI24ZiE0F9uW
         ATQxCMm0iswqZINmmfqgjtSGMzzkyc3nY3QKmC+w7cp9doaG+ndG6EMp4p0kNnNAYV5b
         WNTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=1/bRuK3tszQ66l6BR3X8k6Dyc5A/y7faIXzkAd76+sM=;
        b=LIrSH2XM1R/q9VLnpSlgNyTYdxqXRBjJRP/qTtgK4tWjdZRiFRGJ6IawynRceSu5CJ
         1tTv4wd8cSVEAYaSZgmxD5z6t4rHJOK59gzuzDHyilIcoL44asmcOUuHP25liw9yXabi
         D9G6Q8RrrWkM1qYFJxcsMGzVZ/VTpuZ10GLXg/3Qv8315m2Guz01ZMkltpJRQ4RYaWFL
         UWmEQps4nXqHTkRG9OrwRmhMhYSgHM3eLqGbLOA3pbtGmyzsofbGlUm2XTVuiTCwb9/G
         LaO3JYxLf/ziW8f5tPcp2P0B7mLdu/IV77q2rWKgEaZLuE16iZ1hcLVem49RB5Y6D5bS
         EcNg==
X-Gm-Message-State: APjAAAXUUVH6oZH6QqCbxH3e5UY/ID1KV3HeBvaN6QS1Fle5l+bnFQJk
        HjVzJL8WtguwkJB9n/V5IUa98NrF
X-Google-Smtp-Source: APXvYqxIkDq2xy0cn1cHNd4XwbK17WS6Q3G23zgA3YGQHTEbq/n6ljc0dMKkKdENMfJ3G0ZxS+UvGA==
X-Received: by 2002:adf:df81:: with SMTP id z1mr5744179wrl.278.1574280376086;
        Wed, 20 Nov 2019 12:06:16 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:1b5:77c:1d90:d2c6? (p200300EA8F2D7D0001B5077C1D90D2C6.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:1b5:77c:1d90:d2c6])
        by smtp.googlemail.com with ESMTPSA id u18sm452587wrp.14.2019.11.20.12.06.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2019 12:06:15 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/3] r8169: smaller improvements to firmware handling
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <6bb940ea-f479-f264-bc12-b4be52293dd6@gmail.com>
Date:   Wed, 20 Nov 2019 21:06:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes few smaller improvements to firmware handling.

Heiner Kallweit (3):
  r8169: change mdelay to msleep in rtl_fw_write_firmware
  r8169: use macro FIELD_SIZEOF in definition of FW_OPCODE_SIZE
  r8169: add check for PHY_MDIO_CHG to rtl_nic_fw_data_ok

 drivers/net/ethernet/realtek/r8169_firmware.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

-- 
2.24.0

