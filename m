Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C042329F356
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 18:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgJ2RfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 13:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgJ2RfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 13:35:09 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFACC0613D5
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:35:08 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y12so3689626wrp.6
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oRmz+4+o7OE+5WNthkg3Flvqqv0uTmDftIeGOPIUHTA=;
        b=bbNGMMD8IpyjBA1HDwRhmK+2pfDLh9HTObzKHHQBRt9dCnzIkU33nxQ/59bgtZnBt4
         y6FPM8vWCvTz+6opgY70QLFL8ZI0WXtLmGQ6iu+yIvkK67AWNVlc4WGmQrgBWuW77dI6
         rn0ML/LLg+LKSp69pRntJS6DUkQUgfBnCjMkgz0Z4C/F4vOpEl11paNWLuRXS1qJ5k3/
         u0MrUi3C+AT/7GsF5VB/nWIdehOfhhM2xGAdJMxpARL68zOuoyJ+a+toCGrs5LK5vWi6
         TqjP71Ip/hbcVketObZ090zpzItadVKc+KpdmRW4bKCvG3Rct8HHE+4hxXGFNVo2KcEk
         t7OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oRmz+4+o7OE+5WNthkg3Flvqqv0uTmDftIeGOPIUHTA=;
        b=hNlgy1IfzToWl5MlKgFZrIO7D5lTVwFCnt40/qZJ9Kk4miEYagYjBOAUJv9ef1ZrsS
         rQbzyp65WLgejFNJOdsF9lpWUuRjTRA6AM94STXSBwJwmiMA+9Bfo9WaL7lORAIBLMFy
         UXMm4HzcA5fuaJu2ERAwKrsiGw3e1ogsRk13U4bEMsy+I1OxM1yvic67EDyPk4YQEate
         W8XjD+9dVldAfTI2yWCuplss+bf/mp5HYkYQIIFbZAt82Lx2jZrvQadKz/LpE7LMaV7S
         M5ob+llnKW4NV2mU7t1xkEkcEmWeGaB7FMe3AhpXy/I5fcw6wRTJVzUGdJCi8pXy2Qiw
         ItPQ==
X-Gm-Message-State: AOAM531CYOUfkSasr0ylL6AGOsXWwtdrUQZH+hT5F7k6YQxfYlPdcTdq
        CG8JCbsaI+SNRk2UNTnZ/c2djDCf59M=
X-Google-Smtp-Source: ABdhPJzSYzD05M+cQ/w+z2GvYhAR1lB9uX8WRX+qIyJymL5TKifTPejlXyFLnQ6groUnjHI53XDmHw==
X-Received: by 2002:adf:f381:: with SMTP id m1mr7645418wro.347.1603992907302;
        Thu, 29 Oct 2020 10:35:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:a990:f24b:87e1:a560? (p200300ea8f232800a990f24b87e1a560.dip0.t-ipconnect.de. [2003:ea:8f23:2800:a990:f24b:87e1:a560])
        by smtp.googlemail.com with ESMTPSA id t19sm964793wmi.26.2020.10.29.10.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 10:35:06 -0700 (PDT)
Subject: [PATCH net-next 2/4] net: core: add devm_netdev_alloc_pcpu_stats
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1fdb8ecd-be0a-755d-1d92-c62ed8399e77@gmail.com>
Message-ID: <78eb7e22-902c-0227-3bbf-d324eb232ade@gmail.com>
Date:   Thu, 29 Oct 2020 18:31:21 +0100
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

We have netdev_alloc_pcpu_stats(), and we have devm_alloc_percpu().
Add a managed version of netdev_alloc_pcpu_stats, e.g. for allocating
the per-cpu stats in the probe() callback of a driver. It needs to be
a macro for dealing properly with the type argument.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/netdevice.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 568fab708..6e06fef32 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2596,6 +2596,20 @@ static inline void dev_lstats_add(struct net_device *dev, unsigned int len)
 #define netdev_alloc_pcpu_stats(type)					\
 	__netdev_alloc_pcpu_stats(type, GFP_KERNEL)
 
+#define devm_netdev_alloc_pcpu_stats(dev, type)				\
+({									\
+	typeof(type) __percpu *pcpu_stats = devm_alloc_percpu(dev, type);\
+	if (pcpu_stats)	{						\
+		int __cpu;						\
+		for_each_possible_cpu(__cpu) {				\
+			typeof(type) *stat;				\
+			stat = per_cpu_ptr(pcpu_stats, __cpu);		\
+			u64_stats_init(&stat->syncp);			\
+		}							\
+	}								\
+	pcpu_stats;							\
+})
+
 enum netdev_lag_tx_type {
 	NETDEV_LAG_TX_TYPE_UNKNOWN,
 	NETDEV_LAG_TX_TYPE_RANDOM,
-- 
2.29.1


