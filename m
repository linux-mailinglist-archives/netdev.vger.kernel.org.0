Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3C13417D9
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 09:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhCSI7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 04:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbhCSI6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 04:58:46 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749DEC06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 01:58:45 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id j18so8306007wra.2
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 01:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Ct6qr2O+gEmr0BPrtT8sM3etvwJoh/tDIBFVht/3fUE=;
        b=LP/PpIzF61EzrGOEej30H9csdVwrWwb0j5QEVDX5JyNcU5dzRo0OHwJcau7ZhGKGg7
         Z1M2d1x9mqYhnwjXXuwLspReWvFxyIn480RQ2q8jXlpnQ+Xivc5oj3bNaH1gjSsMPHSM
         tzWS5IlskE/9R0Bd2JWZMzXvwAdP/b/kY+FUFo5qIxUKwSYgbSayG5M9RJaa544qyOgV
         xFYglGh8cBiLchaHGQpjf8MektsxAjeEdw16sdkUJX0UVybhMteDGaqa76OqUxwGnRQ0
         pNJv+xYJMq8DSQ56Yq6vrTq4v7YA86DMizwO+M/pZeEwnwYrI1xOyHjwQB03+XbTLEUj
         oY2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Ct6qr2O+gEmr0BPrtT8sM3etvwJoh/tDIBFVht/3fUE=;
        b=XPoxh8/u7j0rnca7uIo2LDuBnbBKxJyAEV0+v5/6pPsiByv5nAZO22tL7m1B5Ej/+v
         PC4r4ECXl3RJii4ZfeS7BUwX8P+UX/dFw7Kj9TR2rcJSbGsFKghWvJbS99KyY57Ni1/V
         COzm29S6irWLdmEIePOI11AkX9CUDGyLDMwioKhZYtiqutNK8kEmbGm8EppfZpoleUH5
         /mldP6jfiFO6mdYQZCdNUfkGsH0RW3fHWIJdYJHlVnnWw93Mo9srmCLxU1e/v7OsqyDh
         dBlBkh+3oeQxRPMJ/8HXYrgRtnhfZVsVKfVdipiuL8gLxvZhPf2e7Vft2QMpTTDqmxKx
         RicA==
X-Gm-Message-State: AOAM530LWPZKx27Zwurc72BY8UmHsXPfehULLCu42kj+5v5Re/H2uso8
        pGL3Hp4LbmjFVD0nLp1X9oFGe2+FxeUkvw==
X-Google-Smtp-Source: ABdhPJyQORxRRrm36y7We7sWnRyYUZNmya41/ZBnQSZ5T9XqDxeyCxsDV+gs42Tku5g/4kJN4WHqdQ==
X-Received: by 2002:a5d:6cd2:: with SMTP id c18mr3407488wrc.330.1616144323908;
        Fri, 19 Mar 2021 01:58:43 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:fd2c:a424:dc3d:ffa1? (p200300ea8f1fbb00fd2ca424dc3dffa1.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:fd2c:a424:dc3d:ffa1])
        by smtp.googlemail.com with ESMTPSA id w11sm6950188wrv.88.2021.03.19.01.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 01:58:43 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: use lower_32_bits/upper_32_bits macros
Message-ID: <9a7cfc5a-c4e2-f2a9-e256-856d0a69e4de@gmail.com>
Date:   Fri, 19 Mar 2021 09:58:36 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the lower_32_bits/upper_32_bits macros to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7aad0ba53..8ea6ddc7d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1586,12 +1586,10 @@ DECLARE_RTL_COND(rtl_counters_cond)
 
 static void rtl8169_do_counters(struct rtl8169_private *tp, u32 counter_cmd)
 {
-	dma_addr_t paddr = tp->counters_phys_addr;
-	u32 cmd;
+	u32 cmd = lower_32_bits(tp->counters_phys_addr);
 
-	RTL_W32(tp, CounterAddrHigh, (u64)paddr >> 32);
+	RTL_W32(tp, CounterAddrHigh, upper_32_bits(tp->counters_phys_addr));
 	rtl_pci_commit(tp);
-	cmd = (u64)paddr & DMA_BIT_MASK(32);
 	RTL_W32(tp, CounterAddrLow, cmd);
 	RTL_W32(tp, CounterAddrLow, cmd | counter_cmd);
 
-- 
2.31.0

