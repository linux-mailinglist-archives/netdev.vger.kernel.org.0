Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB69664E75
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 23:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbjAJWDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 17:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbjAJWDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 17:03:23 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13464436C
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 14:03:22 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id v2so2220829wrw.10
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 14:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+lNKae9t6mWSaeByyy6AHKVDkMguSH2xhzFAmnmHaTw=;
        b=Dcw/63UyrUD0baTvq8Sx82p/J5Cz5cghMEPzNRJ92CeKmpgeDvewYLuuZrtohh+mrZ
         hlyA7HmKnHM/i12NnWyVr7lY9q9Oam+f3XBTOAgkJNqYbaQzVB6tnv2ct1wPLRii5MOc
         We/pu0DRS6pTe30lfz3oQZnwuXJrHt34KreL7n16NiopigUHl71N9eIhPDWDntVdy1pZ
         dOyCAlY+QxVbl6knQzzzW+JlZViQDh4xFZPwXZZil83xO8BB5AHauO9DQqgxFgciyJUd
         VBApUwON6keoG5Y4B5SMaDiExtdw0fKAXbR/zejN/D3E+3yV19OXfDcr/1kz6r3DSJAL
         o13A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+lNKae9t6mWSaeByyy6AHKVDkMguSH2xhzFAmnmHaTw=;
        b=ArWLOODqG2Tbb9uyI3Q7dPJ3Hbayv98hwNeLBbjX2kbqB7EQqj9RInZ3DFEPSlmiIq
         ARsiB1biIEHBeNaqjabIN+7bhlZDw11JLRTVD4R4XFeqTTTOENuAc+7G3Cu3V3JoTQTq
         9zwh16Jr/pDl+vQzWw+QK5R0UIvHYOeCp1i9vryFce1BP1OP+B971GAspVorsv6afVih
         HaRSGfFX/R9ToYtiA5cryHwVbRip1dAbrINOXjXQqQHxf3OfI1HEt3GhJndd1daFwB6i
         aiTgE21MkHVyBvk/YX1ttcl5HVSipjdq2e9Ek//0YQJKs4ZyPPHP1LxJ0kQ/3CAdMZL8
         OgPg==
X-Gm-Message-State: AFqh2kry6gOblGF1WOVWQwGigX1OqowsYMwXje13QuBG7bRY8/am0lrZ
        ez7yHSYSXebfDWBJpy6QlDs=
X-Google-Smtp-Source: AMrXdXtZjvMGLEljL/uzJCGMuBmHejuanQCnqT9vGdFDJkmKZrioghWovtueQHbbVYknGr5i8EktgQ==
X-Received: by 2002:adf:e703:0:b0:242:15af:27f with SMTP id c3-20020adfe703000000b0024215af027fmr45742027wrm.28.1673388201076;
        Tue, 10 Jan 2023 14:03:21 -0800 (PST)
Received: from ?IPV6:2a01:c23:c404:0:f91c:b55f:3d6c:d5bd? (dynamic-2a01-0c23-c404-0000-f91c-b55f-3d6c-d5bd.c23.pool.telefonica.de. [2a01:c23:c404:0:f91c:b55f:3d6c:d5bd])
        by smtp.googlemail.com with ESMTPSA id bw28-20020a0560001f9c00b002421888a011sm11965150wrb.69.2023.01.10.14.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 14:03:20 -0800 (PST)
Message-ID: <92369a92-dc32-4529-0509-11459ba0e391@gmail.com>
Date:   Tue, 10 Jan 2023 23:03:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next resubmit v2] r8169: disable ASPM in case of tx
 timeout
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

