Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2E4B90904
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 21:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfHPTzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 15:55:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38217 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727542AbfHPTzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 15:55:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so2608188wrr.5
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 12:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=RfGP+7kZdBsf2r11yIB02Dl+fEpl22JvVrRGRYrj98k=;
        b=irUqZtZfDzMSqVOQHQBrsEdRsm/OEo37qbrvwHBvx7jVsJtmh1LSSHxHyKQsHuntCe
         PmFxujH4xm/zqSrr/41ZxlqQ5NsTRKkpBaMZQmFd9l00q+7xFRqaxcrzG81gBaSjbolX
         e8SMKvFarj869K2MAkFqUmdDdRhqgXzCWFLFxmX7xyq2vdcb5WFZhEqhawduhGfQn0mI
         VsaZkUt6dqDFf2tfEBVPFCaJbhqgVTuGmExQ+J9fg7bj7NL7PGygfnbTeNUBZBd7SOID
         1pnhaT7t5Bfh+iBMnJCHFBA9yuN9fu6FMpxZfAbYq9gIEmRR0mxyvKSMZC+XfNzh1Pno
         T1Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=RfGP+7kZdBsf2r11yIB02Dl+fEpl22JvVrRGRYrj98k=;
        b=rsTkokxUZu38ItWjg/lLIoZCLCN2BUYeqtr2+gzNfOCiq3Exy2K17nt/AnBvAR57ot
         7w5vG2Op9SW55jB3C6TAqS1cZM/82MbKCKLNASpvj075QOSn2qdpUcIlOaLyapTyJopN
         //A3wjcEkIqVlwsnU/lA+FHWGWLPw67SyvySj4/9b4+F0I/dm1SsKKypBWpI3/CpOzwf
         Za6t/jbXSzCOanS5Fi9kbW7STILECrfut5jALjHnKQ1Ji/PfRn01NWO7wO9J7sSUBNxN
         hsNDazJImnlEw1Rzj6vvck5JO5G45/t75LvPQhmiD9nAFBXDheODDz13aX4ZgUiTyZSN
         KltA==
X-Gm-Message-State: APjAAAU+zsAuaROFcKdnEwoGGWBgtYAmqf1xcIUNfCeidABUYqbDI8E3
        slw0Nk6xXv3Psip+CAWaDET+v9BP
X-Google-Smtp-Source: APXvYqxo731R1UJmdSiAujXXHpxBANlKJiI1UUKfMaKKpJOvU6ksRzhYuu7SpO+VYTOqbZgtxr7Daw==
X-Received: by 2002:a05:6000:110f:: with SMTP id z15mr12032784wrw.162.1565985348132;
        Fri, 16 Aug 2019 12:55:48 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:4112:e131:7f21:ec09? (p200300EA8F2F32004112E1317F21EC09.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:4112:e131:7f21:ec09])
        by smtp.googlemail.com with ESMTPSA id j9sm7613448wrx.66.2019.08.16.12.55.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 12:55:47 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] net: phy: realtek: support NBase-T MMD EEE
 registers on RTL8125
Message-ID: <d2669c95-9861-df53-2e37-6ebfde11c4c9@gmail.com>
Date:   Fri, 16 Aug 2019 21:55:40 +0200
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

Add missing EEE-related constants, including the new MMD EEE registers
for NBase-T / 802.3bz. Based on that emulate the new 802.3bz MMD EEE
registers for 2.5Gbps EEE on RTL8125.

Heiner Kallweit (2):
  net: phy: add EEE-related constants
  net: phy: realtek: support NBase-T MMD EEE registers on RTL8125

 drivers/net/phy/realtek.c | 45 +++++++++++++++++++++++++++++++++++++--
 include/uapi/linux/mdio.h | 10 +++++++++
 2 files changed, 53 insertions(+), 2 deletions(-)

-- 
2.22.1

