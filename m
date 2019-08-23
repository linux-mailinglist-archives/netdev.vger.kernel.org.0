Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5BA99B610
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 20:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405062AbfHWSHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 14:07:35 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37313 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404508AbfHWSHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 14:07:35 -0400
Received: by mail-wr1-f66.google.com with SMTP id z11so9422935wrt.4
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 11:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ZaTNXnn5qhb6CIeJzJhltek98I7yqMTH1zqX4NCZwNA=;
        b=BywAs7hCwaI5dfB85YZrJm4/oaPf+xy3RnbL2OCSpRMwWyQAuaZ7hG8uVx6ryTjImX
         y2oBsJzgBrFsxYxN980FViMQzAIq9/owJmLh2XJcdf4FfMCzZIrJvgGPJ6DfGC3R+gIB
         JJSBWG+bsX1GcYwA/6xv+4gLJG9iFozaShMF3+BTHxpFl8T4RkhGG67ELS9TeUwJpgtv
         A0csDvZ7vLt64tczFtbGUmjJKQtT2FmntNuhpySl3pmrWOWRvi0bYn/p8tx5Ht0P0bR2
         wJG2HzLVM6frCHeYirT3VfOe1V9RhUf4c9uZZ2t7FH4g+HrT/tAOUbUjv9k+wIQvu0T3
         UJbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ZaTNXnn5qhb6CIeJzJhltek98I7yqMTH1zqX4NCZwNA=;
        b=jLVoNuhZZd1AQPh6sQPZFImcfHW8CAVd72HHQB9qdMqZUaCd/mq6Nc8Zztvj5LiShL
         H1+4bnFJqxnc+4ryc6frc/GOVJquJnDQBp/kDai/IswM4Kbcka2fLNX/ulV4SpAXelGi
         SdsRaal6zn5rorafOIfLjUw/h3zrx4IsKQtTatwIREwfYP9rVHjZkNtm8p+DTjWHDWbL
         8Q3Q/1W5essL9oy8ml9s9hXGwsbgwiVUf7ToxCjj+CTSm1AojhMR9V8m3dNflptrnAPo
         kdT5l45dqIdVHdzgqCkoO5H4dQhZbMnhqGsByA/5R32BGRaBkyfh4fv3cKv0JNhKnFpS
         KiQA==
X-Gm-Message-State: APjAAAXZDmBZtxLQVC0lHxWG25GzbHHhxKaMm5rnzNICfl0q0xXdNAtC
        4uly4Xvo10n6wuuIMuPipckKkiq2
X-Google-Smtp-Source: APXvYqyTHeIUqx/si5SoR8VqaCHTEx6x8vwiHZWr7z2pCwHDbx7gWnSqF/8KkjlTPeZIr1mbasGygQ==
X-Received: by 2002:a05:6000:152:: with SMTP id r18mr7086579wrx.41.1566583652767;
        Fri, 23 Aug 2019 11:07:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:6c0a:591:b8f7:9101? (p200300EA8F047C006C0A0591B8F79101.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:6c0a:591:b8f7:9101])
        by smtp.googlemail.com with ESMTPSA id a141sm18242490wmd.0.2019.08.23.11.07.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 11:07:32 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     Aaro Koskinen <aaro.koskinen@iki.fi>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: fix DMA issue on MIPS platform
Message-ID: <c732685d-591c-3dca-95b8-1207bdf0d37f@gmail.com>
Date:   Fri, 23 Aug 2019 20:07:26 +0200
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

As reported by Aaro this patch causes network problems on
MIPS Loongson platform. Therefore revert it.

Fixes: f072218cca5b ("r8169: remove not needed call to dma_sync_single_for_device")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 910944120..6182e7d33 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5822,6 +5822,10 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 			skb->tail += pkt_size;
 			skb->len = pkt_size;
 
+			dma_sync_single_for_device(tp_to_dev(tp),
+						   le64_to_cpu(desc->addr),
+						   pkt_size, DMA_FROM_DEVICE);
+
 			rtl8169_rx_csum(skb, status);
 			skb->protocol = eth_type_trans(skb, dev);
 
-- 
2.23.0

