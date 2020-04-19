Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DB11AFCD6
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 19:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgDSRiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 13:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726036AbgDSRiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 13:38:08 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C736C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 10:38:08 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d17so9153330wrg.11
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 10:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=qjPNzPaeDaATZhn35otwqEUJWFDv2s1UgDffk88S9HE=;
        b=u3wrrJJcQiDlMUkjuIhQba8kPl5DEvvhPTQZIQri5dSxc+/rSy65bWmbPsPurT119N
         K8XjrEIHQ4X88KF2QxZai3WdkDe9QYlMNwd8t6rAsQl3YCCQBBAdCBiDQB6RxZfSpaS5
         Sej+2mkxsu+mWd75+957hTrY6tN3IcZjPIQrke6Uxs3lVJ0X7KNsfOYjyLc7XM22znJs
         j3J9uDcYuAvAITm2hnHV43YlvnIzY96A9BCRaH/I1IuEt9iUnTqRyNdaEncVw9CJrbVC
         EymKVsd4QeuuauRThVpDwNzMwIdGiVanH4C4dywZEXoWqJIQakODnxVnq6U9Jmp//mhN
         Jr6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=qjPNzPaeDaATZhn35otwqEUJWFDv2s1UgDffk88S9HE=;
        b=X9VqTgo7QCyTc/+wLhiMGNpVZld5qG89+xn81YmIhE+1gh6B8m4cTCs2XgBbOfy5m4
         WzJMjIeJpf67UZ5SHL/u+EY3nXdDTSKJ/fuqGfLW2ag+CtKzmBsxnhoG7o3WNecEALTw
         VBNZgYjRJ8OnoCCviBoSIA3vjzR25LgYmdc4rpmXR3NDvW4kBMv3RpzLuSwWoFCgeUEm
         jB6T1pAHLk3EqWXsH5mSbXw1gGxfPsKTOnUm6nj003Efgtqhm16sMob18GzTOE41uppy
         WUtllS72iVpvh4q8t4KW8fX7YhoXP31Dsuf20G45sMmA7eUgcZSqXfn3h5xZXW9/85nK
         wLXg==
X-Gm-Message-State: AGi0PuZX6WmD2SyN6YrgU1rSsTbAxX+4IPj3axdNEcaCihheyhein5wj
        d3vTdvkU6ZcrTjzlfPnDgBnuvmRq
X-Google-Smtp-Source: APiQypIW7hBvYzvQ7qLYoX5UP2twxTx51IAxEnkG2U36U/X4oB7VdaqBAlbnNMUzjjgpmmrAmNkJXA==
X-Received: by 2002:adf:cd84:: with SMTP id q4mr13619323wrj.320.1587317885555;
        Sun, 19 Apr 2020 10:38:05 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:39dc:7003:657c:dd6e? (p200300EA8F29600039DC7003657CDD6E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:39dc:7003:657c:dd6e])
        by smtp.googlemail.com with ESMTPSA id y40sm18693992wrd.20.2020.04.19.10.38.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 10:38:05 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/4] r8169: improve memory barriers
Message-ID: <c1df4a9e-6be8-d529-7eb0-ea5bdf2b77ec@gmail.com>
Date:   Sun, 19 Apr 2020 19:38:00 +0200
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

This series includes improvements for (too heavy) memory barriers.
Tested on x86-64 with RTL8168g chip version.

Heiner Kallweit (4):
  r8169: use smp_store_mb in rtl_tx
  r8169: change wmb to dma-wmb in rtl8169_start_xmit
  r8169: replace dma_rmb with READ_ONCE in rtl_rx
  r8169: use WRITE_ONCE instead of dma_wmb in rtl8169_mark_to_asic

 drivers/net/ethernet/realtek/r8169_main.c | 26 ++++++++---------------
 1 file changed, 9 insertions(+), 17 deletions(-)

-- 
2.26.1

