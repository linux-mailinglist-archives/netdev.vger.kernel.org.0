Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A1A21F650
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 17:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgGNPn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 11:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgGNPn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 11:43:27 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D01C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 08:43:27 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id dm19so17679515edb.13
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 08:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ZMtm2k+RH0QtwDJJMpHbfgK/NZpbNUg4m9Wi/pu7H4s=;
        b=uGwBF21ENQCK8mCQxhBm4E27KB9BlFhQTwZDAKEdfo1DC9/AP1a/TcqOgu6CVsE0BM
         Ar8em78ff1kjePZsgZ6N4DSwieifu+1/cFfILgYRdy8WbIrFQCRKiEm2dx4rkST2wLsa
         zAAFpdzF/c1LFx6JQdcGwkgJeAYBhCjUMBcn/zG5AHLvSiv14DONJozYSycXzoNmY6KR
         oJQelBNckVeobQ9SDK6htWWfVaDc0N3B8IxR9IRlRTPK0nB9aX+QemmRcVLTEbOwSi2A
         I8nAT5+VWTOoOi/Cyk2q6eFjbCH1GJM3krhy+ATNS1fLmD4jO9W69YigcYwHeV2fXSM9
         0OVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ZMtm2k+RH0QtwDJJMpHbfgK/NZpbNUg4m9Wi/pu7H4s=;
        b=q++x+/1W/FxBpr3KNlei8MFi4WyxRWCQ0PQ9/L+Y+K2XQmWWCsbKog/+JGCjJDU9qJ
         zKBYBTZ3jXopheyMzCrioy7+J+8XkJbfCqaS0tkj0rug8rdCLyKE9WttKdXcHErzl+Vj
         5LnTRa57B/9YOInwuh6tfCg3QWFPsHC6ZJ4GPWeXhm7addDzMyPbUX9lzyFB7dbumLoX
         JL5AIGfKG8VT9oPQ48gY+Ezdiz3thaJ453HjZpal2h1CatrYCwoQzEYpaenmx8niw3l4
         BuKdws/7FmQ15xRyEAFrwEV34q7OlDKJhOJvqQIyFPJPkv+KiKCUBVcinfN8YepGxseF
         JRPQ==
X-Gm-Message-State: AOAM530gg6HpRtyHAd1iIzxdag10piAcwYiE7MCjMmyaOa4vz3Gz6abK
        +AJ80dLEIbeauKNHxcUaTXivEkU+dqs=
X-Google-Smtp-Source: ABdhPJy/OvqLMvHUP1LTVcI1Vi7vXMx+VEaKsiMSPxDrVCYZblnWpv9tQG2VExgOrvXT0bbFltOKMw==
X-Received: by 2002:a50:d55b:: with SMTP id f27mr5212296edj.312.1594741405573;
        Tue, 14 Jul 2020 08:43:25 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:b47b:7b5:8aff:5077? (p200300ea8f235700b47b07b58aff5077.dip0.t-ipconnect.de. [2003:ea:8f23:5700:b47b:7b5:8aff:5077])
        by smtp.googlemail.com with ESMTPSA id s13sm12549698ejd.117.2020.07.14.08.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 08:43:25 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] r8169: add support for RTL8125B
Message-ID: <1cf79621-63ab-0886-3a23-2c9b3625c23f@gmail.com>
Date:   Tue, 14 Jul 2020 17:43:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for RTL8125B rev.b.
Tested with a Delock 89564 PCIe card.

Heiner Kallweit (2):
  net: phy: realtek: add support for RTL8125B-internal PHY
  r8169: add support for RTL8125B

 drivers/net/ethernet/realtek/r8169.h          |   1 +
 drivers/net/ethernet/realtek/r8169_main.c     | 110 ++++++++++++++----
 .../net/ethernet/realtek/r8169_phy_config.c   |  53 +++++++++
 drivers/net/phy/realtek.c                     |  12 ++
 4 files changed, 153 insertions(+), 23 deletions(-)

-- 
2.27.0

