Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECC7658710
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 22:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiL1VbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 16:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiL1VbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 16:31:03 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA77B140BE
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 13:31:02 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id s5so24343138edc.12
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 13:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TBOccNAdLhAabd6XWdCVONA7+X2Jx2oHNWLUAktHKyM=;
        b=ki2SF1Wuf9x9Y4t3nwpWAU3qFxi6m8bn8+d26fUhOAI4l3I8uGBtl9GbgdRRR69FZJ
         yeZTRLS6rQ82svcblYOPjKfmhNa81npg57TnUki7eRd3pzLmXNp5KpLXU42dqnvt/tnK
         Mv3l4o1vNh8iMVgEr2CpcxZaZpbvHD3CoBqfpjEbvol9TVa4NBIZmh75D4TgtWZJqlZp
         9/0OXhiP7ZdbU1utJMIdG/x3fub8AiCosSztVj5yM/RrDWXpgPFPu3DV5jkkuwLvOE4l
         Y6ui7AT3dYKRVNmUxMQhLDAGEuZHq2FE8KsKhUdIQHa5v5/LHsNy0i2TMzo+MtOypJDQ
         5I5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TBOccNAdLhAabd6XWdCVONA7+X2Jx2oHNWLUAktHKyM=;
        b=vWqEN2qnMfftRI6F8mtLfwmOYa5p+Hvz6CtHwe8c87c0H3Lf9S8aoBGmp5gOJXPDas
         dWS7F+ZQT8E+zCppPomBt64RG7aaDvsxU4C5kgRzygD0cW9iLTQVf9FUobYG4U98IKGL
         Z9CN8+z3VGfQWizK21A3zjIIDq9wr1SzoTitOuM/LTBp0O1vVAtwBCb7xhLI7VNtWxYe
         SpC1oBv0bmJo0SGhuMbqTezhontxpDk602yv+oLGr1gC+JUh2+NI3BezNAPOWP2IkdkO
         L2HyAw21E0KMhz7Y02v+Iq6fbrUqfkHW5bsXgKLN3aJOMK1DyKwIu09cIkjoQM4q3vW9
         nwyA==
X-Gm-Message-State: AFqh2kqTityL2Vogmnsr2MEfU5b79xlVoS1mMpLyvoxrHNkR6u2Zsd51
        LK7enfHdqNs1IUYZNAwvjw0=
X-Google-Smtp-Source: AMrXdXsT2oigE1IwJdUhnE7mm4epWDOVatEgHNZfOaXGAfAbEVkLGOROHMJnCBbY4dtZb+5qA9nEDg==
X-Received: by 2002:a50:e60b:0:b0:468:3252:370f with SMTP id y11-20020a50e60b000000b004683252370fmr24365683edm.34.1672263061215;
        Wed, 28 Dec 2022 13:31:01 -0800 (PST)
Received: from ?IPV6:2a01:c22:7299:d00:4d19:57c2:3db1:9695? (dynamic-2a01-0c22-7299-0d00-4d19-57c2-3db1-9695.c22.pool.telefonica.de. [2a01:c22:7299:d00:4d19:57c2:3db1:9695])
        by smtp.googlemail.com with ESMTPSA id fy10-20020a1709069f0a00b007bd7178d311sm7953861ejc.51.2022.12.28.13.31.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 13:31:00 -0800 (PST)
Message-ID: <1847c5aa-39ff-4574-b1c5-38ac5f16e594@gmail.com>
Date:   Wed, 28 Dec 2022 22:30:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: disable ASPM in case of tx timeout
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are still single reports of systems where ASPM incompatibilities
cause tx timeouts. It's not clear whom to blame, so let's disable
ASPM in case of a tx timeout.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a9dcc98b6..7b58da9aa 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -576,6 +576,7 @@ struct rtl8169_tc_offsets {
 enum rtl_flag {
 	RTL_FLAG_TASK_ENABLED = 0,
 	RTL_FLAG_TASK_RESET_PENDING,
+	RTL_FLAG_TASK_TX_TIMEOUT,
 	RTL_FLAG_MAX
 };
 
@@ -3931,7 +3932,7 @@ static void rtl8169_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 
-	rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
+	rtl_schedule_task(tp, RTL_FLAG_TASK_TX_TIMEOUT);
 }
 
 static int rtl8169_tx_map(struct rtl8169_private *tp, const u32 *opts, u32 len,
@@ -4532,7 +4533,14 @@ static void rtl_task(struct work_struct *work)
 	    !test_bit(RTL_FLAG_TASK_ENABLED, tp->wk.flags))
 		goto out_unlock;
 
+	if (test_and_clear_bit(RTL_FLAG_TASK_TX_TIMEOUT, tp->wk.flags)) {
+		/* ASPM compatibility issues are a typical reason for tx timeouts */
+		pci_disable_link_state(tp->pci_dev, PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_L0S);
+		goto reset;
+	}
+
 	if (test_and_clear_bit(RTL_FLAG_TASK_RESET_PENDING, tp->wk.flags)) {
+reset:
 		rtl_reset_work(tp);
 		netif_wake_queue(tp->dev);
 	}
-- 
2.39.0

