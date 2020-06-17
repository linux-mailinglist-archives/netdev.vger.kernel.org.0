Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441181FD65B
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 22:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgFQUuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 16:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgFQUuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 16:50:18 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436F7C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:50:17 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id r15so3451380wmh.5
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=zaPWq2AVrHW55HDiTULWeuaswu9ra7b1i4dCaGzkdMI=;
        b=GPKvI9fapD1zGnho9eF2TO0IaixH+8bj9HSs3wg27w3iYD9wiJx+HWK6C46KuAbPLE
         BpPDtLbrVkk/S0awtIdCyz5xtQGF7dkQR117wKRW8e0yQD31rmjuUN/SCl1r7dhKM6uG
         9u0k2FC5A+aj1P3V6nAC3R+FvImzOhArfpIG1etXcmzS9jhuROcOmEEGLAZ/k6R/znFQ
         l/wS9as1fqpYcHN/TFtgFOguo1KOzDeUaJ1I4x1UvpgIYzR3nkxTuFgBkM/xE8EVS/zz
         5wlPDjqgCn5nmxUGbo9gQb+r9BQ7vML2EfBVrBvfXbwHApjiLLIKR3rLGKXFlH4ZwKtR
         HkUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=zaPWq2AVrHW55HDiTULWeuaswu9ra7b1i4dCaGzkdMI=;
        b=iudjk/h9aDre1eEpgX7nPXJJDABTpBfiAfYRnBzGce6yndZIQSqM/f0UfDfGqfGxyE
         ybWNB+7er0od1wxhlppXnY1Kt7HidGXsEEIQfRX/yb3au7bDBwgKUQje79Q/avnn21y7
         CkP4T/yNJe94E+LGuIiukKhExYXTWNfoJeZLB7P4dyCjHrYCCosWhh7hQlRTKBCTwMJk
         fsv9elAAYSLuf5UEvcERygePW2wlOVuuEKQM85HvGz9NxvwGm9Fxz3F/NdO7plUpAc6x
         5cEBr8CiOlBDiAM9sF54Eac2WXTaXoIqdyI6Pwu5MMVXP/CYy8LYkexMZsDtbSukpY7y
         HExg==
X-Gm-Message-State: AOAM533j3o5pnjonpUAFoh3Yb4cfYx0u2MS8Kg3FKxGV50NcH04YK0/d
        ZunNhYq/j1rbngWjq74I0seZlJ5F
X-Google-Smtp-Source: ABdhPJwhF8yRk59egxxDE67e9EnyGYhING9Z9ZQMo8H0oSu4DWEvlWg06URQyEMypHGIhrglSnpXaA==
X-Received: by 2002:a7b:c8d6:: with SMTP id f22mr543922wml.188.1592427015817;
        Wed, 17 Jun 2020 13:50:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:c06e:b26:fa7c:aab? (p200300ea8f235700c06e0b26fa7c0aab.dip0.t-ipconnect.de. [2003:ea:8f23:5700:c06e:b26:fa7c:aab])
        by smtp.googlemail.com with ESMTPSA id y14sm913677wma.25.2020.06.17.13.50.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 13:50:15 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/8] r8169: smaller improvements again
Message-ID: <ef2a4cd4-1492-99d8-f94f-319eeb129137@gmail.com>
Date:   Wed, 17 Jun 2020 22:50:11 +0200
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

Series includes a number of different smaller improvements.

Heiner Kallweit (8):
  r8169: add info for DASH being enabled
  r8169: remove unused constant RsvdMask
  r8169: improve setting WoL on runtime-resume
  r8169: replace synchronize_rcu with synchronize_net
  r8169: move napi_disable call and rename rtl8169_hw_reset
  r8169: move updating counters to rtl8169_down
  r8169: move switching optional clock on/off to pll power functions
  r8169: allow setting irq coalescing if link is down

 drivers/net/ethernet/realtek/r8169_main.c | 51 +++++++++++------------
 1 file changed, 25 insertions(+), 26 deletions(-)

-- 
2.27.0

