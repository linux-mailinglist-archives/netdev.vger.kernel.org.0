Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB2D180B43
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbgCJWPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:15:09 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36497 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgCJWPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:15:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id g62so3154564wme.1
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 15:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=WWIvSgnas8FpL5U5w/FxPX5AfkSG2uIwq7nUR5wXD1s=;
        b=RnVfx0Dpq3+a6OpXSqF9eyHRV9QLznPf5EBoyV4MIZ5vDN4IptaCxQewN9CHPyYLlj
         ixWc340me68caA/Yp4QQySRbc0i4pEmkEejl5in8u8cNzAC+rvNN0kfRgdmPyjAF8Qp4
         k41+QxW2LOTn+1rW3GAKKS/qgdPdAjpBLEqudrhX//Ko3qoySOtQBUi9QACEjmIgZISj
         Kf3gn7FRm1GDhyeBuuOdVcPwIi/hajWl1drr5e9sf+KZpjPL3JKS1aTzKKUzy9tVMHOi
         j8QDv+oh/EAMRHpAboTtCoLtPYypPkMCQ6aK0nkbvlDmUhiLJjDy0pu4FEcFqlifaTTD
         R0qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=WWIvSgnas8FpL5U5w/FxPX5AfkSG2uIwq7nUR5wXD1s=;
        b=c0PRyaU2bnAgX41zbZzQOEvn9EW8RN8Hny0vHyLi+dnIKzLLBipJ0l9Hp+3NbfPbLS
         eU0ct+YfIR9/phqpYjutr1LOs1dGchPK8m+xMUI6GRl7UJWDivXwv63EH9xDGj2duMpT
         EoIB5Tn9VzgXgDtQpuIx/KcYPA9zp7zxXgwBTGMpGyUDCA+HMg+jprbYA9Xfce8XORJ8
         twHLHzFB/tNYqYxlWzi7U7P94TPo4qNfKcLyfy1CUi6Df4zirAGvub/Yf02bRILgvcqx
         i+RgSrVOEtSCLbbJ9KaoOjg6o0oT3o8JNqnvXr2IpRE7Ke56L9mpfesqouEUtLscXV9G
         HNnA==
X-Gm-Message-State: ANhLgQ1Msrk4AFLjHbxmwVc2sH9f0dtVAS8jWwt8loMRF0pGG6+89k4e
        u5oLbawv1X4jc8WTLS+k1QcJVT0F
X-Google-Smtp-Source: ADFU+vsraQ2bfYUvxuEmHlL/WPAbJjq0f7Fz4G4bI8gmlbIwWL1BWU4jCcEJzLrEVvvEiR3yuzQe5A==
X-Received: by 2002:a1c:8149:: with SMTP id c70mr4114318wmd.123.1583878507347;
        Tue, 10 Mar 2020 15:15:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:6583:5434:4ad:491c? (p200300EA8F2960006583543404AD491C.dip0.t-ipconnect.de. [2003:ea:8f29:6000:6583:5434:4ad:491c])
        by smtp.googlemail.com with ESMTPSA id w15sm3676691wrm.9.2020.03.10.15.15.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 15:15:06 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: let rtl8169_mark_to_asic clear rx descriptor
 field opts2
Message-ID: <bc8a1ecc-4b94-e0b9-ba05-acf674c1b5e6@gmail.com>
Date:   Tue, 10 Mar 2020 23:14:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clearing opts2 belongs to preparing the descriptor for DMA engine use.
Therefore move it into rtl8169_mark_to_asic().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 181b35b78..c0731c33c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3889,6 +3889,7 @@ static inline void rtl8169_mark_to_asic(struct RxDesc *desc)
 {
 	u32 eor = le32_to_cpu(desc->opts1) & RingEnd;
 
+	desc->opts2 = 0;
 	/* Force memory writes to complete before releasing descriptor */
 	dma_wmb();
 
@@ -4543,7 +4544,6 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 			u64_stats_update_end(&tp->rx_stats.syncp);
 		}
 release_descriptor:
-		desc->opts2 = 0;
 		rtl8169_mark_to_asic(desc);
 	}
 
-- 
2.25.1

