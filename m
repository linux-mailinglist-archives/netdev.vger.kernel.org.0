Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA25E451650
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 22:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349204AbhKOVTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 16:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347669AbhKOU7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 15:59:12 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B730AC061746
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:52:59 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id c4so33107453wrd.9
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=91UgiZjhItcKOZipH+ovhBW9s1FfoDyhKKLUbyS/2dM=;
        b=P7Ar3E8QX7BQWuRjN7lD98+S72qQkHxt7VftUS+3xykpAbm2qz3E6kOGhnrDcY+qM7
         RxZ6Vw1Z19QsXQp3sJFmHJ72TJKZzCeuU5CsoOjPppejRKm5awFz68EsXQ0viL3lTYt5
         mV85SXJfSnEiyqzxic2Vf5FMlTrpAFHvkf2PRBL6RObAu1TFRkp6sycrZhM4MSsppwfk
         FMd4No8CdU2a53fijww67Imaa4PteBtLGe1LfJ8klf7F0/dOcgc2WSc+yIxnlLrL9KdL
         NZ2bf+tptvi4LChfYy/HQmiXZYI3aWzi0jortqrL775vTmKXFpnTyUas0FdgxCG1tgar
         Bv8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=91UgiZjhItcKOZipH+ovhBW9s1FfoDyhKKLUbyS/2dM=;
        b=3iCJ2ieXxfEVyk4ILk8nzeUn3/5qHuGGGN87IcUoM5ESLbwTnTrWLrF+hmLdGI5Spi
         ckRW2rGQ6h8xz+bN5HXUHlOc+7rpqEI/SJayAGmWvFyj+Id4xlN855Bqx/dLoiyp9Fxz
         DnTiVoqB3NBavpgac9OTqcZXr+qXIWvrQX8VGroKYUAe4Q2qcwSxE1QcEIXoK4rpPKx6
         lYYyS11PMhYPbYhvs3LEyO0JFc5l41M0D4xgJ0DTu/RrAW/nmcW0+KRlBsU51yYRg/zY
         cxN6Vaq4g02PgYHw9HVO+kPqRjsDCxqpNqOMUQD1kE6u19Ae9qNiKrHwNhQ6D9fPgIYn
         6zWA==
X-Gm-Message-State: AOAM531SJ5SmIknEdDHYPVjyKmm9u35Of01G9m2EFp5AHBCWXusByZmk
        bPChwkHh4k6UDAI5ID4TOJE=
X-Google-Smtp-Source: ABdhPJwbKwyCOOKvUBBBa6Mm55riBFTmPmZeYcwb+D2vuMlVd4pJWCPF7XCDDrSAAVp94Fhop6vhzQ==
X-Received: by 2002:a05:6000:1788:: with SMTP id e8mr2494860wrg.45.1637009578364;
        Mon, 15 Nov 2021 12:52:58 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:a554:6e71:73b4:f32d? (p200300ea8f1a0f00a5546e7173b4f32d.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:a554:6e71:73b4:f32d])
        by smtp.googlemail.com with ESMTPSA id o26sm368777wmc.17.2021.11.15.12.52.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 12:52:57 -0800 (PST)
Message-ID: <9e0539c6-df97-ab4a-5c8c-6b0efc72bdc1@gmail.com>
Date:   Mon, 15 Nov 2021 21:52:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: [PATCH net-next 3/3] r8169: disable detection of chip version 41
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7708d13a-4a2b-090d-fadf-ecdd0fff5d2e@gmail.com>
In-Reply-To: <7708d13a-4a2b-090d-fadf-ecdd0fff5d2e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems this chip version never made it to the wild. Therefore
disable detection and if nobody complains remove support completely
later.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c4dda39e4..303b61a2b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1994,7 +1994,10 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 		/* 8168G family. */
 		{ 0x7cf, 0x5c8,	RTL_GIGA_MAC_VER_44 },
 		{ 0x7cf, 0x509,	RTL_GIGA_MAC_VER_42 },
-		{ 0x7cf, 0x4c1,	RTL_GIGA_MAC_VER_41 },
+		/* It seems this chip version never made it to
+		 * the wild. Let's disable detection.
+		 * { 0x7cf, 0x4c1,	RTL_GIGA_MAC_VER_41 },
+		 */
 		{ 0x7cf, 0x4c0,	RTL_GIGA_MAC_VER_40 },
 
 		/* 8168F family. */
-- 
2.33.1


