Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FEA28F619
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 17:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389788AbgJOPrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 11:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389730AbgJOPrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 11:47:41 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0659C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 08:47:40 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id p5so4343961ejj.2
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 08:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=p/27WFDUX0XYFYRg9SxooW/OntQtyXND2BiXs97UKm8=;
        b=IN6I1Z3/wDJd8RwCAQM1d31KTJPuKZUn/jqxlb4nzmnN4AYDTaKOE3XoDpEDn8YXDO
         rdCEzz87xw2pHi0DGW919l6Q0mtLQ2KJD4y/l0GDw8OyAIaWuUvxk1sd9rGncjA9KT4/
         SpYS8+uXHvaJ630Tfbqdj+Ztdsl8n0hoMxHmPqqBF0GpSjtrqI1oN8JGTEJ3lLbs3jG+
         IR2lmEm/W/eBxt/ximUIHCY9vVsU25M1lT76x++t4xwWJlJo7hddwFQfBl6zePCzTBZj
         1QimhWIiwge7E0kGgvcIEhmCCTAYHk2Mxf15FPHSI/1XnrYTeV7IauTWBMnPYlRLx3Wr
         UQYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=p/27WFDUX0XYFYRg9SxooW/OntQtyXND2BiXs97UKm8=;
        b=Z75koQ3O8O/PSVrYTmBJFf3G4TA/MyMPGyuhn10aO44BhhEclcYHbTxKnCBvmmL/hX
         dygO8h5reSA2M830XilxoUZjubx7ykjl7JUUGfuikMQKr4N3JzJgFv4LqM10++8dfWH6
         bl7l99uhQcysiPq6YTBXVK4POw6RfmRyoLYxO/mLO2WyXwQnubYiWzCR2enhwqbf/YX6
         lcQxNMiywlD+gc1nEHt7+clGcVj7JUbOl9IMJeNLLAeWPyGRiQux1XSQECJ2mxarJSIS
         CYgsS1Zs2dUWpyFXAl2q/iaUexI4X+vbKLma8LcFhVc5Bmj9xX+TBWAZWATcmW+RsmvI
         9itA==
X-Gm-Message-State: AOAM530Q8ZYSfMZAoZdQVxraA6C0OUQcKXqfugiOloQyQk+x1JuyZT/N
        pPLEpZL1ESTqNe8sBaGlnbO0BazzP2s=
X-Google-Smtp-Source: ABdhPJwIzZCWEDrYXWnx+ORrRSJbgF5c/mt9oHKyXgZ3euK9Z1gOFFBQr/z/WNy/gDhi+IAQJ5m/yw==
X-Received: by 2002:a17:906:6d89:: with SMTP id h9mr4897127ejt.152.1602776859082;
        Thu, 15 Oct 2020 08:47:39 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:c92:1571:ee2d:f2ef? (p200300ea8f2328000c921571ee2df2ef.dip0.t-ipconnect.de. [2003:ea:8f23:2800:c92:1571:ee2d:f2ef])
        by smtp.googlemail.com with ESMTPSA id p2sm1855154ejd.34.2020.10.15.08.47.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 08:47:38 -0700 (PDT)
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/4] net: add functionality to net core byte/packet
 counters and use it in r8169
Message-ID: <e25761cc-60c2-92fe-f7df-b8c55cf12ec7@gmail.com>
Date:   Thu, 15 Oct 2020 17:47:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds missing functionality to the net core handling of
byte/packet counters and statistics. The extensions are used then
to remove private rx/tx byte/packet counters in r8169 driver.

Heiner Kallweit (4):
  net: core: add dev_sw_netstats_tx_add
  net: core: add devm_netdev_alloc_pcpu_stats
  r8169: use struct pcpu_sw_netstats for rx/tx packet/byte counters
  r8169: remove no longer needed private rx/tx packet/byte counters

 drivers/net/ethernet/realtek/r8169_main.c | 45 ++++-------------------
 include/linux/netdevice.h                 | 27 ++++++++++++++
 net/devres.c                              |  6 +++
 3 files changed, 41 insertions(+), 37 deletions(-)

-- 
2.28.0

