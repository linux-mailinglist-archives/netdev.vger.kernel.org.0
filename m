Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CCE658EBD
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 17:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbiL2QGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 11:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiL2QGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 11:06:13 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93CC11A35
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 08:06:11 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id u19so45909688ejm.8
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 08:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+lNKae9t6mWSaeByyy6AHKVDkMguSH2xhzFAmnmHaTw=;
        b=Cn+Z7Y2aM4mYLw3mze0C/XiUKEwuSMrYtoMVDvh+z3Ek+LtVEBOlsiIF8VJDsvg1IF
         F5mGH5XbyqQTvXguyKI7eNmcyW2mKBmGf/lboVcn4xnitunVg5ndjCwY1qtpF4rZjTwY
         IDCD3Y4oz3z7S0iPbQgLJKOT9W7dLTyqOLPuOnKMr0r+e+XxaIRS2OXugpMph5fzvloR
         4ETmczrDk91qd34YVCB4Zbjej5eb4q6il6DyIQ2FhoIdpNEG5bEjSDLqFzHpIFAhjtzc
         iq2sX9va/7XyjbUVvsuoEvqylNVxId8RctxrG//81x0BdK+TJ2CKco948SIrSV3Q2AdT
         5/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+lNKae9t6mWSaeByyy6AHKVDkMguSH2xhzFAmnmHaTw=;
        b=vteM81/0bLjRu4F5rEEiEqu0nJ5WoV4aPZq4tL7itKn5Y7ug04V9phMiBaOoKLFpUw
         ekjy8fSeTF0dnTzkcUvmfTVtwrzS/ye/tRwIglbWcJ2qZo2agNcZ9yo3kbG/0JW2bFZ1
         eBB7RT4uowiuDBQuq+1biHH2jTPssZDskSnRFxH0NN66dpdcUjB5l9NJI2CizWXv1ACW
         TzoL1BPOf5b+Ffv5qLjbiUksnF3gD8a1uafOWaKWD/xQ8OAwy2/LfPq5Yr8Kq52ZEgdf
         QvE+vXRkQkjMlWqejOkaGjYvKGQ84sNbGYYdv1DUoe0K8xW2BDm/pEiK58mAmziean8E
         ZhTA==
X-Gm-Message-State: AFqh2kp3i31R2db5Su3JMHlYMsjzE9LyeDcLBfX9wCDrJrtbPQZdN1Xc
        z7SVoaS1YTN33WBkZvQ0h7U=
X-Google-Smtp-Source: AMrXdXvQfY7ShXU1LefuSB0D+xe9MBMtnnYhppj/6dQqcoqEHdOK784uxbd9qK9PYXqTJrPwKlDIlA==
X-Received: by 2002:a17:907:7f24:b0:7c1:6091:e76 with SMTP id qf36-20020a1709077f2400b007c160910e76mr33472788ejc.53.1672329970064;
        Thu, 29 Dec 2022 08:06:10 -0800 (PST)
Received: from ?IPV6:2a01:c22:6ef3:b900:a548:5717:959:2430? (dynamic-2a01-0c22-6ef3-b900-a548-5717-0959-2430.c22.pool.telefonica.de. [2a01:c22:6ef3:b900:a548:5717:959:2430])
        by smtp.googlemail.com with ESMTPSA id t7-20020a1709066bc700b0081bfc79beaesm8616474ejs.75.2022.12.29.08.06.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 08:06:09 -0800 (PST)
Message-ID: <06bab827-be4a-606e-7a01-52379b1e1a91@gmail.com>
Date:   Thu, 29 Dec 2022 17:06:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2] r8169: disable ASPM in case of tx timeout
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
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

v2:
- add one-time warning for informing the user

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a9dcc98b6..49c124d8e 100644
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
@@ -4525,6 +4526,7 @@ static void rtl_task(struct work_struct *work)
 {
 	struct rtl8169_private *tp =
 		container_of(work, struct rtl8169_private, wk.work);
+	int ret;
 
 	rtnl_lock();
 
@@ -4532,7 +4534,17 @@ static void rtl_task(struct work_struct *work)
 	    !test_bit(RTL_FLAG_TASK_ENABLED, tp->wk.flags))
 		goto out_unlock;
 
+	if (test_and_clear_bit(RTL_FLAG_TASK_TX_TIMEOUT, tp->wk.flags)) {
+		/* ASPM compatibility issues are a typical reason for tx timeouts */
+		ret = pci_disable_link_state(tp->pci_dev, PCIE_LINK_STATE_L1 |
+							  PCIE_LINK_STATE_L0S);
+		if (!ret)
+			netdev_warn_once(tp->dev, "ASPM disabled on Tx timeout\n");
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

