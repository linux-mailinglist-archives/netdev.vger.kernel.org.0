Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFB52F29FE
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 09:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405103AbhALI1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 03:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbhALI1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 03:27:48 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D649C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 00:27:08 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id c124so1085931wma.5
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 00:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=kqjABHTUVxAkwQSFbeHnjaFjt5+xrnPwQmFauR/HthM=;
        b=Xtw3ZeDWpJFRd1+aVq+YP2iFcuUcjOrYm/0pzZPkqBO1f3ffUNADgFLqWzBDS2/1Kt
         o/4Qec2ScNpTZNOHIJp38VZtcMb5EHuz/uCbWC/VspWhjW2t6Z97Sy/m9CJ37o+ih861
         w8FOlj6mJ2U5+eZ+KJY6bbYswJIFlgx5hUTn+aPS985THaGtqJIAoCv7ojX2BgaFIL/z
         YI8v8lOka1yIk/EPwpfwhh5ap+nMDhyIoZkwml0vU8Z/rZugren73fVNQkpJsspfaHV7
         KoWTfxo9YtUW+yhQr17yjAj7le6SrZAmp3LhMWh9lMuA8GzCACPT3h/KPuReHtQYTvAd
         zOWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=kqjABHTUVxAkwQSFbeHnjaFjt5+xrnPwQmFauR/HthM=;
        b=ZOCwBiwIsQZwtLsiRqCQZl5BGIUr5F/D0KbY2QsGZFNT0d9ph0S4yxQ9C9ZpxbYKnI
         YVzhKVI43fRBwkmzWLR1vv4l1ronMSPckxZhBOfJaE8rqCZWOt0aYYhRu2c4uBwcCNR1
         yO/tg664TKAvA8sZA/cToHT1ltcQ6LiPfCLmo31IDw0ZU8ed4bEv55mrzD4ovO1dKpsr
         0v9QJ45BV8UmBtOk3OM5dgn+6PtE6WQGIXrF9M6lEj4PAdPjQIArZbbD1z9g9h91udlY
         zblvtrG2oxiAodydrwqUSq4zFPQKYQOvRY9vnJ3esMhsaaNNTFoC/DDAdXYVyDhdnOfn
         rcfA==
X-Gm-Message-State: AOAM530kAgnEHCW0TzYg3F12R9pH4NF0RbCBQIqm/svTe6w9XI1r/owt
        p86bUfc3jyKeZAFPdeKn4OwY0Hu3Pdo=
X-Google-Smtp-Source: ABdhPJzbZh9J7SzUSjhCOOKE4R3jP2Cib/lewmw/z4/ehcxLapBFWUcm+xrcp8mkVdrImgApbutMlw==
X-Received: by 2002:a1c:2182:: with SMTP id h124mr2375070wmh.25.1610440026884;
        Tue, 12 Jan 2021 00:27:06 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:d420:a714:6def:4af7? (p200300ea8f065500d420a7146def4af7.dip0.t-ipconnect.de. [2003:ea:8f06:5500:d420:a714:6def:4af7])
        by smtp.googlemail.com with ESMTPSA id l7sm2736985wme.4.2021.01.12.00.27.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 00:27:06 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/3] r8169: further improvements
Message-ID: <1bc3b7ef-b54a-d517-df54-27d61ca7ba94@gmail.com>
Date:   Tue, 12 Jan 2021 09:27:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Series includes further smaller improvements.

Heiner Kallweit (3):
  r8169: align rtl_wol_suspend_quirk with vendor driver and rename it
  r8169: improve rtl8169_rx_csum
  r8169: improve DASH support

 drivers/net/ethernet/realtek/r8169_main.c | 81 +++++++++--------------
 1 file changed, 31 insertions(+), 50 deletions(-)

-- 
2.30.0

