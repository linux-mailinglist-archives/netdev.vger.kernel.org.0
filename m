Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3BF866A62B
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 23:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjAMWq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 17:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjAMWq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 17:46:26 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013C976AE9
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 14:46:25 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id j34-20020a05600c1c2200b003da1b054057so4000079wms.5
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 14:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PWKGbPrjL0fGkg9RrsUCSSMnGCZE05xKe3FQ4D2I0jE=;
        b=HWQSc0CNUouRNKWyGfcavPGHGbpapElrb/pUu9ZSvdB5lNUCS6GduIr/EGw85xyBG3
         s/x+eeGWJcyTA8CLuZL9O5v2YzkuLh9gnJVX0jwevByJjQMinyTFyiOpkIa5N4Qz7Gln
         Ic4IRqhg8s4+eWT6UnMUqgSW9KvisEhlqXxqV+PZrMSS0v0R1yxDzN4FONng2MG5UUha
         GJm9IuYtNVL+8lqQxmOciCll2qTdbSaXDmP0GhZ26cCroN4xNj1dzPGcAY7GyLr8TDZ6
         YJ03VHA8Zq+gQ7+mivtyXuAtvV/80nitjlE/80ZvoIzUXC4+5K0lxv6AQvNoJ9J2eggS
         JGtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PWKGbPrjL0fGkg9RrsUCSSMnGCZE05xKe3FQ4D2I0jE=;
        b=iF4btSagq7tQZbmJnwE14wyoeSoxYS3ddF9nMcbYMM/7Juy/IzU8ZH+oGkJyQ54Vic
         +kMwKJwZEiVf7FFt+Eb3cL5pyjBg1rj2qho0HwVSlFnpWA9mDc7brb6TSsCpf/rfClw3
         k3FiCUxjCvM0hAOWNENaR0KWG+6b5IG1PH2gnul5ahFHIArdl4VfAk/NfoZod20KincA
         hMSQT10o1SwMVDUelNm7cjU7e84E23HQyE0v0Bk3AHslxOENEwcaHzQyukEDWMVcTO7t
         uTraD1cv0OHFmIngjTgwgVt8MoJ+cn8WGVnWjpuem+c8r8eA+0O2l5gznH9a1EIQxwXa
         VqhQ==
X-Gm-Message-State: AFqh2kqc255c9yA4KTHx0zJ99UD3NLvciuGjsOE4D6CWl373dyt1mqYB
        HMN9E1+09JTZkY99WqQOzYE=
X-Google-Smtp-Source: AMrXdXs9xjdlBeu3GqjoRhgWOxuzqW3dZqXmid2bS8CC8+xZYqVTFaxn8yX6ZCNNnKmAOaCVzbAe8Q==
X-Received: by 2002:a05:600c:2108:b0:3cf:98e5:f72 with SMTP id u8-20020a05600c210800b003cf98e50f72mr1080170wml.3.1673649983426;
        Fri, 13 Jan 2023 14:46:23 -0800 (PST)
Received: from ?IPV6:2a01:c23:b9df:eb00:88f6:ddec:da70:8bca? (dynamic-2a01-0c23-b9df-eb00-88f6-ddec-da70-8bca.c23.pool.telefonica.de. [2a01:c23:b9df:eb00:88f6:ddec:da70:8bca])
        by smtp.googlemail.com with ESMTPSA id c17-20020a5d4cd1000000b002365254ea42sm20125516wrt.1.2023.01.13.14.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 14:46:22 -0800 (PST)
Message-ID: <4534318d-b679-9399-e410-8aee2a9cbf58@gmail.com>
Date:   Fri, 13 Jan 2023 23:46:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2] r8169: reset bus if NIC isn't accessible after tx
 timeout
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
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

ASPM issues may result in the NIC not being accessible any longer.
In this case disabling ASPM may not work. Therefore detect this case
by checking whether register reads return ~0, and try to make the
NIC accessible again by resetting the secondary bus.

v2:
- add exception handling for the case that pci_reset_bus() fails

Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 49c124d8e..02ef98a95 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4535,6 +4535,16 @@ static void rtl_task(struct work_struct *work)
 		goto out_unlock;
 
 	if (test_and_clear_bit(RTL_FLAG_TASK_TX_TIMEOUT, tp->wk.flags)) {
+		/* if chip isn't accessible, reset bus to revive it */
+		if (RTL_R32(tp, TxConfig) == ~0) {
+			ret = pci_reset_bus(tp->pci_dev);
+			if (ret < 0) {
+				netdev_err(tp->dev, "Can't reset secondary PCI bus, detach NIC\n");
+				netif_device_detach(tp->dev);
+				goto out_unlock;
+			}
+		}
+
 		/* ASPM compatibility issues are a typical reason for tx timeouts */
 		ret = pci_disable_link_state(tp->pci_dev, PCIE_LINK_STATE_L1 |
 							  PCIE_LINK_STATE_L0S);
-- 
2.39.0

