Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E431809DE
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 09:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfHDHww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 03:52:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41214 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfHDHww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 03:52:52 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so78070201wrm.8
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 00:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=c+LlCY82fLV6mjrdjM0zyH4T+a5KzalxqGfX+20gNEQ=;
        b=BkZPr43/AyFfHZA7YiFJ7UlJxQyaoxp4my6+Yj2VpHKr7+jhEBscjZACjxmfQeU7wy
         VcqdtisKntVVjXfWDOX7FRikXIR6ZwHXkkjiGLUojWTnXluGvj9e3KcIhMjmCDGFVtXW
         cjMVXqL03Uv/AfujD16Z6prFplyPAZzhiNOvzxKrud6mmk47mtzT+S6+gaoEGPomaX4j
         CiTCBJKUtk8MoscNtjEuWk+e+WqJMCBQSV8+bXG5VilGOf78hqnK2YyN4s40fxZxScsM
         ifVSG7VCZyIB1nRsZKUmmHiTXP7uvaNjpzFSUykQlSHi9MBa0Vd2R0jEVltG6ENfVPvR
         8wgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=c+LlCY82fLV6mjrdjM0zyH4T+a5KzalxqGfX+20gNEQ=;
        b=pE06NcdxmSM1KJ51yMfUmLh4e72VMCoj+X628a6v0ZvAJBUUqyD1b8no2tRObSxpv6
         icpMW0ZNR4n2MP35YUM0xNlUW0Q2fEO+yo+fv0C6s4wDKneZaDwygOokOXZTZ6yyFeBD
         0YcqiXHoIw8QKOBh/uJ52BggDEsKZQKGKmYy2+SmiOBApa3TgeUkQefjQfDN8aNeLXTB
         XAZq3u21p2ol9gxyuFksHY5LbHE6+MH9iMWaJvsM5lpIY3f+7mGuDEtLesnoHhdCb7XB
         pdHwD0YHpwtoXpuPEOmZOnSo8D5N31nhzb2MHts2T6OTxZy9y5D7VVUTCIKSQ0ClikoK
         eXoQ==
X-Gm-Message-State: APjAAAWZnKKwHZ1z6IYW/sE+IkpOY/K8ZHL/noWRBy5M5wb9MAJJs5lQ
        /MUj/TvOXOiHxdZAn56EurtH1AtmibQ=
X-Google-Smtp-Source: APXvYqzHIOCzSoQ4S7Ii5sd0e21DGoaYp6fDpsQbHUtv5RZ0Il6yPU33ZnWmNZ6tNMqA0L9IYawZmw==
X-Received: by 2002:a5d:51c7:: with SMTP id n7mr8570391wrv.326.1564905170089;
        Sun, 04 Aug 2019 00:52:50 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:9900:d80f:58c5:990d:c59b? (p200300EA8F289900D80F58C5990DC59B.dip0.t-ipconnect.de. [2003:ea:8f28:9900:d80f:58c5:990d:c59b])
        by smtp.googlemail.com with ESMTPSA id y2sm69181212wrl.4.2019.08.04.00.52.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 00:52:49 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: remove access to legacy register MultiIntr
Message-ID: <d550e704-3854-d91e-22fd-253ede944c3e@gmail.com>
Date:   Sun, 4 Aug 2019 09:42:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code piece was inherited from RTL8139 code, the register at
address 0x5c however has a different meaning on RTL8169 and is unused.
So we can remove this.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0be8e5c08..e38bc01eb 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -271,7 +271,6 @@ enum rtl_registers {
 	Config3		= 0x54,
 	Config4		= 0x55,
 	Config5		= 0x56,
-	MultiIntr	= 0x5c,
 	PHYAR		= 0x60,
 	PHYstatus	= 0x6c,
 	RxMaxSize	= 0xda,
@@ -5241,10 +5240,7 @@ static void rtl_hw_start(struct  rtl8169_private *tp)
 	RTL_W8(tp, ChipCmd, CmdTxEnb | CmdRxEnb);
 	rtl_init_rxcfg(tp);
 	rtl_set_tx_config_registers(tp);
-
 	rtl_set_rx_mode(tp->dev);
-	/* no early-rx interrupts */
-	RTL_W16(tp, MultiIntr, RTL_R16(tp, MultiIntr) & 0xf000);
 	rtl_irq_enable(tp);
 }
 
-- 
2.22.0

