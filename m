Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3401E13AF
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 19:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389433AbgEYRs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 13:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388621AbgEYRs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 13:48:27 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20751C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 10:48:26 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id j198so3412215wmj.0
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 10:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ZVqmiv0atGCtA/vJZtmt/7qyk6fiz1neFe28u2S/vnI=;
        b=mLPO1aAqxs9zqKiEgReXBOLNdWEAcjiSD8ngwmBF2dEuX44av8vSLXidlaKxLAsM9o
         rwVnUfFYtURbOgCiSSM4NUXiafkB0hvYqSdkSReoJQoo5x6+j0wd2TMa2VD9bm6goCb6
         YFmWLmGOt3IXM4VZPPKbSZ3n5majUXI5Wl8X5QkVAremqL/iO3sjrVrYnmvwt+506tXM
         VoHOY6E/PfJEMbodZpwyl8ryLD5L1lille/Pz8LMcWHRBmef7ALZcqY43eZ4YHfMtxKN
         84ZW4I5x2b8VI6tiD+cALy55CVZfkdX/wDCpV+7efbsF7cflulMyIP2gGRr4S2HfbNBM
         roKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ZVqmiv0atGCtA/vJZtmt/7qyk6fiz1neFe28u2S/vnI=;
        b=R/oT3CsLf8WVIYdsWrGONllupRhbEy9IB9LBOE7uZla4HtKvJAvqQRJOVSLrEiC/e0
         2ZpHFJFFSpYWPiTu2SzGDpu3tj6uw86W2aXa+k1qKyaS3+B2zwYwYbQLbKTbyFwMfXpK
         7Sw6zcON5R9+1vuHjHcpJgVNovjPXlPbBhmaZTS736pkFUEfZ9X9CHuty3ZzVkuwbpNk
         QDRcwbOVO4YD5kbnCdWEn5AOQbOdpBmKZFEtVeJIFK9Q3jF0BtwBlgGpZTVC8yt/VoAz
         5EsB8rxJsQN75Ypqpuj2ryQyaVd98nxIjf4W46/VjvNrYL8X+5Q4Z/xvpEok6852IzYb
         XZBw==
X-Gm-Message-State: AOAM532M403WB7YIm6ctpswiGgo/A0TxhJBQvCKPemZ0+nVFEmjf8b41
        1JQOqcL/ATJ86deBWPRIxM4mc2YM
X-Google-Smtp-Source: ABdhPJxtX6KCaFxRIktIst70HtlI/EsN5/ytUpEn2TUQUA65pvZB83TU+Nr6Ca7UTwl9X61ttEyo1Q==
X-Received: by 2002:a7b:c201:: with SMTP id x1mr479732wmi.58.1590428904574;
        Mon, 25 May 2020 10:48:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:fd94:3db4:1774:4731? (p200300ea8f285200fd943db417744731.dip0.t-ipconnect.de. [2003:ea:8f28:5200:fd94:3db4:1774:4731])
        by smtp.googlemail.com with ESMTPSA id o15sm2357000wrv.48.2020.05.25.10.48.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 10:48:23 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/4] r8169: sync hw config for few chip versions with
 r8168 vendor driver
Message-ID: <e9898548-158a-12d5-4c1a-efe8cfbe3416@gmail.com>
Date:   Mon, 25 May 2020 19:48:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync hw config for few chip versions with r8168 vendor driver.

Heiner Kallweit (4):
  r8169: sync RTL8168g hw config with vendor driver
  r8169: sync RTL8168h hw config with vendor driver
  r8169: sync RTL8168evl hw config with vendor driver
  r8169: sync RTL8168f/RTL8411 mac config with vendor driver

 drivers/net/ethernet/realtek/r8169_main.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

-- 
2.26.2

