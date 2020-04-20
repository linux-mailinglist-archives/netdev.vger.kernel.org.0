Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D551B1791
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 22:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgDTUxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 16:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgDTUxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 16:53:05 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E58DC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 13:53:05 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y24so1146117wma.4
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 13:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=5Kp7z0CX0i6p32pwFtDfib5b3WOjZcfufxs57+9cgBE=;
        b=VsXyjwZqf8dLlj3syHyNcIKaw/vZ9vNHBtNR9t0m+MHBdgg73Wzcgja2qUH1I9f4Dk
         as25nToYxAKN8EXbrJn4pRKbudajW45JQ3bgdpg8dDRIDta/6u/qvJDiPm7LjdytVS4Y
         jfh1W+dPj037JB8Gej2+Q7cmCeaRQRyDiAGAb3J6SJIZ9luaxCRb4opyKWFOMZ5h1yGq
         21WwCyWMUGng95GJAPx0+BOeuleAq+4fvf9caoPwZnF4kNyc2zB0h81X0ZbKRPXwq5BZ
         1R9F5HTjFc0ESeIbckITnylBxHHK1gdMB7o2hsPdfV8cyBiw81gSLqzEyzI9dwWoZkFz
         /pLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=5Kp7z0CX0i6p32pwFtDfib5b3WOjZcfufxs57+9cgBE=;
        b=fsEor6c/mLvemgU8XHuslKQVvgMJFP7Dyhnysz/k854DQxULOAnIsJJtRpDD2qma8p
         T8ngFHz8I+U7SMXriNMEhuNe1HVA7RJnskQIygy4J+xvnGcZE9Gh1sj40/6MBLmJRYK/
         9o8pMh5PJHQMyhB35kFo4Nc2Kwo4BWMlN3WlDA0jrpD+zmFrd+y0ZJ2S5Si+cj6XTlV1
         v7okKW8Yi9IjFZCZSWK88cKniSRfntrdsWp/F3CTNecQLql8sUqq9povMrnlKI4Mec+3
         9cjgLWOYvf7wo0TzDRq7Nc+9eUgxhLzQzo9Nrq3jMwpgDnkrYCDQiEF/W23WAwp3IRSt
         PzLA==
X-Gm-Message-State: AGi0PuZ1zCTf7GaRzvolDA7VjSCLOXPd56tppw4AVNrnP94MXD6OUk4O
        bRy74VCpEzxd1YJ1pPWsTso5yUZv
X-Google-Smtp-Source: APiQypIRXcYqcq7sBlAfXC9dGHZVYfnyMAJ01bYuYsDZGGaccUMxmgIz7lfT6Kl7F1hGCaJaTdZhug==
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr1267988wmf.77.1587415983605;
        Mon, 20 Apr 2020 13:53:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:7101:507:3ef2:1ef1? (p200300EA8F296000710105073EF21EF1.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7101:507:3ef2:1ef1])
        by smtp.googlemail.com with ESMTPSA id l185sm675162wml.44.2020.04.20.13.53.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 13:53:03 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: change wmb to smb_wmb in rtl8169_start_xmit
Message-ID: <3cb5e0d1-15c6-ff98-dced-44e75f1341b9@gmail.com>
Date:   Mon, 20 Apr 2020 22:52:59 +0200
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

A barrier is needed here to ensure that rtl_tx sees the descriptor
changes (DescOwn set) before the updated tp->cur_tx value. Else it may
wrongly assume that the transfer has been finished already. For this
purpose smp_wmb() is sufficient.

No separate barrier is needed for ordering the descriptor changes
with the MMIO doorbell write. The needed barrier is included in
the non-relaxed writel() used by rtl8169_doorbell().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index ece899be9..bb8dcdb17 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4251,8 +4251,8 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 
 	txd_first->opts1 |= cpu_to_le32(DescOwn | FirstFrag);
 
-	/* Force all memory writes to complete before notifying device */
-	wmb();
+	/* rtl_tx needs to see descriptor changes before updated tp->cur_tx */
+	smp_wmb();
 
 	tp->cur_tx += frags + 1;
 
-- 
2.26.1

