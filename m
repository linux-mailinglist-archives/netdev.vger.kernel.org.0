Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35891CA3CD
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 08:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgEHGYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 02:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725897AbgEHGYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 02:24:24 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C47C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 23:24:22 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id v12so463423wrp.12
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 23:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=gF7roXLMspq28jWYb0ycIKwYA4/A1kxnvIYO0XVfV9M=;
        b=MpgHvetCXP05tR7upWF20nEr8oAzUKs0Aet3KUG56RUsJT96sjL7w6GU0flvR/7qu6
         43mPCVizzPMtN5fe+PvWUo2OTOKj/HtUrInwneO0LB+ynaK0Szq3HFZzLZKZ6XyKB67T
         qYRyo9OK0df0wcIKFs73pkRyDpmMC9Mdmd9kP14QuJioV/TIMnhBr7wG70Y9Vo+w8SEv
         /gaZurY1ep7/miRVWQvz+7T6SNnvM69d2nrvFhxFw47QxyDcLzL07HKVo3B8nccevodR
         R/JeoR4pANs2s5NQISMm8tt+cIy3IranVxkAmS3JFcYLidVWstgSg292OZjTm9A9qAnK
         43Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=gF7roXLMspq28jWYb0ycIKwYA4/A1kxnvIYO0XVfV9M=;
        b=s9azDNVrLKgHd1eGjSjHcnMDfOFh1Mvk/8C2pF1FSxVDbxolGaFQ/MFdtuCCO/fgX5
         3H0BjW5Kn8EXxcUfjw9y/OtsYmzYSJdCvMcE3VFdKki1oD3DOHpSV9VyBJjGyqGzLw+K
         LIcZvAbM0SjWq86/0pTaLl0hw9v+QvO3X2hyx/JKSXZU+ntsLh9C/x547LZ3SgZ1AHSe
         bdGZTy3P/lB1G1NiToJ6MCQkQrCaY+AWLFVuN6QTrxfjMwbVr+z0jKKtgHp2wVgiuL96
         MWKEuKomwLrUAUcRxpi6F33mPqLMYFvIjnCqTfTLMS98oGblaeXus9bF3HkkVkp5ERwY
         cxoA==
X-Gm-Message-State: AGi0PubzVe578/rzmfe2v3r1RwngyUSKTQ48Jn6x6fLqEF8mlZy1rVOv
        4LRmS6HRRG26UZUkIHtt9Z0=
X-Google-Smtp-Source: APiQypIPfAO/3NTKS0LpXVuYhAv7S7wKuuCA9Vr0LcmVimt5sjXh0PCdE5u1pvdn2IcvMq7/2/Ebrg==
X-Received: by 2002:adf:f845:: with SMTP id d5mr1018806wrq.239.1588919061052;
        Thu, 07 May 2020 23:24:21 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:e838:acb:794:1ab9? (p200300EA8F285200E8380ACB07941AB9.dip0.t-ipconnect.de. [2003:ea:8f28:5200:e838:acb:794:1ab9])
        by smtp.googlemail.com with ESMTPSA id v7sm18615469wmg.3.2020.05.07.23.24.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 23:24:20 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        =?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: re-establish support for RTL8401 chip version
Message-ID: <02afcc32-7cf3-d024-10c4-fdc1596f15f6@gmail.com>
Date:   Fri, 8 May 2020 08:24:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

r8169 never had native support for the RTL8401, however it reportedly
worked with the fallback to RTL8101e [0]. Therefore let's add this
as an explicit assignment.

[0] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=956868

Fixes: b4cc2dcc9c7c ("r8169: remove default chip versions")
Reported-by: Camaleón <noelamac@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
This fix doesn't apply cleanly on 4.19, let me know whether you can
adjust it, or whether I should send a separate patch.
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index f06dbc9a0..8c41f6848 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2055,6 +2055,8 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 		{ 0x7cf, 0x348,	RTL_GIGA_MAC_VER_07 },
 		{ 0x7cf, 0x248,	RTL_GIGA_MAC_VER_07 },
 		{ 0x7cf, 0x340,	RTL_GIGA_MAC_VER_13 },
+		/* RTL8401, reportedly works if treated as RTL8101e */
+		{ 0x7cf, 0x240,	RTL_GIGA_MAC_VER_13 },
 		{ 0x7cf, 0x343,	RTL_GIGA_MAC_VER_10 },
 		{ 0x7cf, 0x342,	RTL_GIGA_MAC_VER_16 },
 		{ 0x7c8, 0x348,	RTL_GIGA_MAC_VER_09 },
-- 
2.26.2

