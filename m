Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E64357109
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353888AbhDGPv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353906AbhDGPvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 11:51:06 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32312C061762
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 08:50:56 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id y18so2398510wrn.6
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 08:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=c9Y2YmuYfYk+vxhlpHd4lEee0C9tAnOJNOVrTF0kYaQ=;
        b=KWf+2UGGYWVH3HQsIYuWzxsnjD5sSEcwP0bIuKSfYPprj7vA9qJLnWHNkNCEQF57wP
         7UihQ3PgQfWYiFp93VcapqORcIjN1ahMtRnwl9WK4dfiHxEX0c5pi/XmPi1JZprCrKyk
         mRQpTprPAqb0OmXdEVJaZ32W+DWyZ6kWQud5MhPGn/b8E51FYrfZLQAJRnMr9SbuQ6dC
         C9Vnhhw9f9fjvFDOJl8wx3RvJCZ6rG4L77ifZ6QVDC/hXQh2GyKlTpFe33a2+diLH1hk
         l9AKR/9HkgcBdjIg1CKiTqjNigFVRe2IGoSEBov78B6/hNW0hCX3Nb4gGU3pncVJMy2/
         ZkPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=c9Y2YmuYfYk+vxhlpHd4lEee0C9tAnOJNOVrTF0kYaQ=;
        b=CBt92p4+zOLBj9kZfwqiPHGBdvJIfpCOrh0axOCBn59kFdq1ap6G1sdEIdXskLAI5+
         DqQMdA2DeiCyiIGjQ1rTVAvogiczYHyoJcjLtKyfs3BdFoqHjENy+JjP/gK2KAyxl5iI
         vmkYRwwBWb1U5V68D35N1D3JmuJt9j9JJcB0FmB2IvzKqpqEnNBW0pjqV2uKeN7OxMf7
         X3H2OK/9H4eLrpu3YhobRTvrrvMSaWbQmmQtiVCLjFG31B5dIcZDIV7dpo3OPXsQ/jPf
         11GC0MlLSA22BuKd/vywlzyGPcLCLko4eMZkIioD1DdnaRLiXE63znGF4fy3QhTrj2lf
         4uiA==
X-Gm-Message-State: AOAM533z8bi4z2o3PAyffwqvmcOah50C8a4JsDFy8yso5QxGnAZF2FW0
        +H7T4MOYO6n517S0Bn9+JP0=
X-Google-Smtp-Source: ABdhPJzy1dlsP3GyCU0U1ORAUNi0CRkBJK35woNEWdGIGrUnV2vPMm2DFuzFNI19b0wBYz6sMNdYSg==
X-Received: by 2002:a5d:658c:: with SMTP id q12mr4286581wru.30.1617810654999;
        Wed, 07 Apr 2021 08:50:54 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:15f8:68c8:25bd:c1f8? (p200300ea8f38460015f868c825bdc1f8.dip0.t-ipconnect.de. [2003:ea:8f38:4600:15f8:68c8:25bd:c1f8])
        by smtp.googlemail.com with ESMTPSA id m11sm40358910wri.44.2021.04.07.08.50.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 08:50:54 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/3] net: make PHY PM ops a no-op if MAC driver
 manages PHY PM
Message-ID: <9e695411-ab1d-34fe-8b90-3e8192ab84f6@gmail.com>
Date:   Wed, 7 Apr 2021 17:50:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resume callback of the PHY driver is called after the one for the MAC
driver. The PHY driver resume callback calls phy_init_hw(), and this is
potentially problematic if the MAC driver calls phy_start() in its resume
callback. One issue was reported with the fec driver and a KSZ8081 PHY
which seems to become unstable if a soft reset is triggered during aneg.

The new flag allows MAC drivers to indicate that they take care of
suspending/resuming the PHY. Then the MAC PM callbacks can handle
any dependency between MAC and PHY PM.

Heiner Kallweit (3):
  net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM
  net: fec: use mac-managed PHY PM
  r8169: use mac-managed PHY PM

 drivers/net/ethernet/freescale/fec_main.c | 3 +++
 drivers/net/ethernet/realtek/r8169_main.c | 3 +++
 drivers/net/phy/phy_device.c              | 6 ++++++
 include/linux/phy.h                       | 2 ++
 4 files changed, 14 insertions(+)

-- 
2.31.1

