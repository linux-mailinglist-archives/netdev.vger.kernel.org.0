Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65F449A497
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 03:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2375247AbiAYATj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 19:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1844125AbiAXXHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 18:07:51 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C91C09F48F
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 13:17:27 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id i2so16021932wrb.12
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 13:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:to:cc:content-language
         :subject:content-transfer-encoding;
        bh=z3FqBb/haKpnKgynn4HAsm7mOULNDfWSQcpc7NXlq5s=;
        b=HhdlaQmlviPY1jYncizwEVflHeD+xHVy1lbIGqMQfPgl74Aj8YpR1JONi/EIOYWuRE
         q48aPkPZt67BYXCOH4Ur4EKfPCwoGh62B0qTGxeUXHR8eCwJQGwafieB9I+Fi2YgFBOJ
         1XgH3NZfO0GwY0IPkPHPsUvATd0dTf0NjPtB5TtsDQ6Dvv3+F2Jh30QBl11izNqZcjCv
         I+CAlUZJwYlBEVaL6q6GJLuvU+aB6MC/1Sam8KgJliRfGJif++NH3d6yWc1uRQm5WEwo
         KaKKOk9Mtw4eT/WqlhfeGb2s5vYaZbNYiORua4q3dRmfZ5j1RIpojd26kI7BqIt5+JUG
         oyUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from:to
         :cc:content-language:subject:content-transfer-encoding;
        bh=z3FqBb/haKpnKgynn4HAsm7mOULNDfWSQcpc7NXlq5s=;
        b=fEDRy/0W0lpaSnwDdKb4JFh3Ack04kND9npIlJg5u6xBqqKRXqUPAT3CURdAWpL7FA
         N2CaVLNO9Ad9QkMGZZ7uELufqoNlwiBOvYOrbs1lfVIFdthbjGUmUD/1o5vdHBbVSYef
         CAivxWWkyaw/enMVMI8DzHQfLgC1Vbw7dhlrAAt8ar0L68k+qAWGjtnChnCOeToiIyQS
         pI3gzhJdDJrBuOsrGKvwqf/vczqMBTHhWp6Y1nyO9L8hYHpW4rp9H6dQGNW2UpSpA69c
         Nu4aQPZsqAW+xM/VUjMoF6HEnS6ftugNfCPgmgL2hCYevjCLQJOyyc4tup9RFzbZIsHx
         0oMg==
X-Gm-Message-State: AOAM533RDeXyJ6w82sRKnYxnj6oFHct++qN67V1kJBmO7TjrS52LVCIG
        x1jRbYtBhbxizsT8AA4TRsgOElisD+A=
X-Google-Smtp-Source: ABdhPJz23Rb8DtiaFY6mHtANtuCns1WKaCkMEpyujlDeTQSu7wcVUZgDdblfzH6REAAF/tE+7gcomQ==
X-Received: by 2002:a05:6000:15cd:: with SMTP id y13mr10584435wry.421.1643059046005;
        Mon, 24 Jan 2022 13:17:26 -0800 (PST)
Received: from ?IPV6:2003:ea:8f4d:2b00:7c08:a48:e7d2:55c0? (p200300ea8f4d2b007c080a48e7d255c0.dip0.t-ipconnect.de. [2003:ea:8f4d:2b00:7c08:a48:e7d2:55c0])
        by smtp.googlemail.com with ESMTPSA id p15sm14831808wrq.66.2022.01.24.13.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 13:17:25 -0800 (PST)
Message-ID: <6c61ea93-2513-74e9-9e91-1c2c27c8746c@gmail.com>
Date:   Mon, 24 Jan 2022 22:17:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Cercueil <paul@crapouillou.net>
Content-Language: en-US
Subject: [PATCH net-next] r8169: use new PM macros
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is based on series [0] that extended the PM core. Now the compiler
can see the PM callbacks also on systems not defining CONFIG_PM.
The optimizer will remove the functions then in this case.

[0] https://lore.kernel.org/netdev/20211207002102.26414-1-paul@crapouillou.net/

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 19e2621e0..ca95e9266 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4843,8 +4843,6 @@ static void rtl8169_net_suspend(struct rtl8169_private *tp)
 		rtl8169_down(tp);
 }
 
-#ifdef CONFIG_PM
-
 static int rtl8169_runtime_resume(struct device *dev)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(dev);
@@ -4860,7 +4858,7 @@ static int rtl8169_runtime_resume(struct device *dev)
 	return 0;
 }
 
-static int __maybe_unused rtl8169_suspend(struct device *device)
+static int rtl8169_suspend(struct device *device)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(device);
 
@@ -4873,7 +4871,7 @@ static int __maybe_unused rtl8169_suspend(struct device *device)
 	return 0;
 }
 
-static int __maybe_unused rtl8169_resume(struct device *device)
+static int rtl8169_resume(struct device *device)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(device);
 
@@ -4915,13 +4913,11 @@ static int rtl8169_runtime_idle(struct device *device)
 }
 
 static const struct dev_pm_ops rtl8169_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(rtl8169_suspend, rtl8169_resume)
-	SET_RUNTIME_PM_OPS(rtl8169_runtime_suspend, rtl8169_runtime_resume,
-			   rtl8169_runtime_idle)
+	SYSTEM_SLEEP_PM_OPS(rtl8169_suspend, rtl8169_resume)
+	RUNTIME_PM_OPS(rtl8169_runtime_suspend, rtl8169_runtime_resume,
+		       rtl8169_runtime_idle)
 };
 
-#endif /* CONFIG_PM */
-
 static void rtl_wol_shutdown_quirk(struct rtl8169_private *tp)
 {
 	/* WoL fails with 8168b when the receiver is disabled. */
@@ -5460,9 +5456,7 @@ static struct pci_driver rtl8169_pci_driver = {
 	.probe		= rtl_init_one,
 	.remove		= rtl_remove_one,
 	.shutdown	= rtl_shutdown,
-#ifdef CONFIG_PM
-	.driver.pm	= &rtl8169_pm_ops,
-#endif
+	.driver.pm	= pm_ptr(&rtl8169_pm_ops),
 };
 
 module_pci_driver(rtl8169_pci_driver);
-- 
2.34.1

