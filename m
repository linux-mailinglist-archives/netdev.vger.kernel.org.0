Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E0729F355
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 18:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgJ2RfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 13:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgJ2RfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 13:35:08 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DD0C0613D5
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:35:07 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id c18so614353wme.2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iqNQanOjCjBVA0LFMrkVarMbtIyFsISIzsc7ApMy7s4=;
        b=MDPZLmIgj66v7GaF00Uygj+YwNTwC7nXKJk9ajt3tm8oOYI9CqiIosf52JmeVUD1aF
         Ef8jak2+hzVhzdes9HzvuyK0yP0o+UgLyBdGfF94yB8FQE1eJ76nobBKeNaKp0YFNzui
         1vl421CqquGo0AZsAOYzQe/6Ek58gtlkJxT9hBOJ+aL/aK1QtRQCF2C0bwZEaaen+Nas
         ogBBoCBN/AcXT1C/S2hwqBPWnA3ihR8nu5yviEBB27Z7M3VsW4Baxw7U1t/HpJmi/dUR
         mAnx9KzVIc7RNOHsZWUZiHTZfmhpAyE693+nBnrpBoboGYkYs+Qn/bm3inyoK5R45SeH
         1kqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iqNQanOjCjBVA0LFMrkVarMbtIyFsISIzsc7ApMy7s4=;
        b=qeA3JgaZk0UVjLMvEwq8MuYQWF/NCJ4cCBa5vKXoExydAJg6pDKCWLOz5jU2R1bmvH
         4aJ5u4+1f35mj2CT/Olg1x5hiVnp3zWmzurv3hf6R6JmP2CFKUuWx590TBa3VGsKpK2X
         Q/l6rakmq/zYxiIP6fXq4WqqfAYEIq9bSm74/DdrjMgI4MWJA+vg0w2FtcGS8bBq5ziI
         Z/7XPSJGq3+v5QZies7sK/lVGQ6ByoComaV33VR0m4QHYM92dMeqhLuu6tp+KPlR4udR
         X7FTdWua0fUuuM/2/DzDXEQgvEmn14heZj0PKsN5W/qgqF77HSvvnzeqYsgNrum9vtC9
         d+xQ==
X-Gm-Message-State: AOAM531aX435reqrbPKJX9bww78HRBxqtvexaxV3YRmOi+98cBl5sFYF
        SRDCWKaC1BlLVokyAd5vkBawUKttSog=
X-Google-Smtp-Source: ABdhPJzj8r9pdsXgSvG7k470ANITzl+sH/qTPbHaHvVnwc7khFgVteKzpmO/sk0DbP3ahzbwe2oMng==
X-Received: by 2002:a1c:6102:: with SMTP id v2mr208429wmb.75.1603992906208;
        Thu, 29 Oct 2020 10:35:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:a990:f24b:87e1:a560? (p200300ea8f232800a990f24b87e1a560.dip0.t-ipconnect.de. [2003:ea:8f23:2800:a990:f24b:87e1:a560])
        by smtp.googlemail.com with ESMTPSA id 24sm763848wmf.44.2020.10.29.10.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 10:35:05 -0700 (PDT)
Subject: [PATCH net-next 1/4] net: core: add dev_sw_netstats_tx_add
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1fdb8ecd-be0a-755d-1d92-c62ed8399e77@gmail.com>
Message-ID: <972dfa4e-d983-9daa-2d34-23844793646a@gmail.com>
Date:   Thu, 29 Oct 2020 18:29:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1fdb8ecd-be0a-755d-1d92-c62ed8399e77@gmail.com>
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
2.29.1


