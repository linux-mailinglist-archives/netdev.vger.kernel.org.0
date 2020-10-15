Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A2228F630
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 17:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389787AbgJOPvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 11:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389693AbgJOPvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 11:51:32 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6625C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 08:51:31 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id t25so4275306ejd.13
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 08:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7Rs/cu2LluMi3CRwOAS1cipacPqrAybd2I0RmR8hvyI=;
        b=UyPy0WtxAysQeeBvIG8TJsPi/s/50j7Jq+J29WVSo87WbUuf2hpQFFDOOk74bMwoFj
         7UEAnupVCwJ+f/daUDujgEOtgMcwCmJFo90vahwXVmxv+WnfcCKTOSU3UKFEXElBtjm0
         DGDDyV/BH3PpaSPVV4B7ns4tl3PfhZhH7AQxx2qbme90VJ0ZGtee0N7Ec4QJDOI/TqLi
         CcBMc/08zQwKkwAR50Hi1oJlRhV+1D/8d3T3ft3+4XlkqiZ3Lfrzkb8eeC++JoRxBpIp
         3XwTiJFRUuGJC+XackRsDN6Cfkwkyk3rs7CTlZswr6bupZS/lKXq20GdOJJ8A30/4YMV
         L38A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Rs/cu2LluMi3CRwOAS1cipacPqrAybd2I0RmR8hvyI=;
        b=IaaSdcgnm+5lMvjNV2Ys4wISRsER5riPMn0JMltUGGl3G3swTvTWrhbEPbEyFh+yak
         8866m5t0KGvW1E/xM+IOk66L8Avql4zqyguiiehSrRfBR592OpdjYiKqMRIdEi89pkee
         /K77KTpcIywbq7NzrRyxBsD4dRdWPVmu9+WuQFnObReT3VMbuLXbYCbRa0tHfAgEHP19
         I3VF5o2Iet7TS6/EjfuQhl69X+ROksCvehODep+tMI6xDtH+8o3y5/q2U/LfTpUTmbXF
         RsOPpdmdj0W/sw+14D1SDm0rrYghnuzeBffkWIz6ZFydLoweMAgnRPSbd8iBlWzSb990
         pnQA==
X-Gm-Message-State: AOAM532GmBe/PKW+9W2gpCapIOgMJEYbk4qFD6FxivZSJsiKsxiCsyw5
        Bg2uRhoXzNvpQALWDOH06fn8pKfUbrg=
X-Google-Smtp-Source: ABdhPJySrqTxwShcBEKpSsEVEoc6etfTnMPSV2xUAbYCdJhE2sMTFV5hiz/PUy8R3lcKjHINp5CmYQ==
X-Received: by 2002:a17:906:c095:: with SMTP id f21mr5377527ejz.108.1602777090307;
        Thu, 15 Oct 2020 08:51:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:c92:1571:ee2d:f2ef? (p200300ea8f2328000c921571ee2df2ef.dip0.t-ipconnect.de. [2003:ea:8f23:2800:c92:1571:ee2d:f2ef])
        by smtp.googlemail.com with ESMTPSA id ce14sm1835670edb.25.2020.10.15.08.51.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 08:51:29 -0700 (PDT)
Subject: [PATCH net-next 1/4] net: core: add dev_sw_netstats_tx_add
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e25761cc-60c2-92fe-f7df-b8c55cf12ec7@gmail.com>
Message-ID: <b4521e17-89e8-bdc6-f490-2346d9278e16@gmail.com>
Date:   Thu, 15 Oct 2020 17:48:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <e25761cc-60c2-92fe-f7df-b8c55cf12ec7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dev_sw_netstats_tx_add(), complementing already existing
dev_sw_netstats_rx_add(). Other than dev_sw_netstats_rx_add allow to
pass the number of packets as function argument.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/netdevice.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 964b494b0..568fab708 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2557,6 +2557,18 @@ static inline void dev_sw_netstats_rx_add(struct net_device *dev, unsigned int l
 	u64_stats_update_end(&tstats->syncp);
 }
 
+static inline void dev_sw_netstats_tx_add(struct net_device *dev,
+					  unsigned int packets,
+					  unsigned int len)
+{
+	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
+
+	u64_stats_update_begin(&tstats->syncp);
+	tstats->tx_bytes += len;
+	tstats->tx_packets += packets;
+	u64_stats_update_end(&tstats->syncp);
+}
+
 static inline void dev_lstats_add(struct net_device *dev, unsigned int len)
 {
 	struct pcpu_lstats *lstats = this_cpu_ptr(dev->lstats);
-- 
2.28.0


