Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F9F3EB093
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 08:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238959AbhHMGtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 02:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238766AbhHMGte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 02:49:34 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFAEC061756;
        Thu, 12 Aug 2021 23:49:03 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id g138so6176896wmg.4;
        Thu, 12 Aug 2021 23:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=INEHUFOekANcgjh/QNyWbgLp7c+/Fz6l2Ofc/xXR09E=;
        b=SIrspxFxR/w19sumP/IHtLuvTXy06D39wSoqMAYJhnfH3rDCJcFsmLHFR94Cm5vol1
         qRaSCCUlk5cI/p6HP+6ssIPvBqUVdjoaqNXSLvNp40TVdsM2Hna2+50I+or5luE4gNCU
         vU1MNzUQafnRdM4NGJWaYqpz2Dml3lBCw+TK5y3D13nwF+LQLPSRNDirvFnvW72DN65J
         rjAdzzAalERQtjIzh9DaFsa4ZimzQLu+anxlp6JKO3JQcvqhlTQWvo1Tu/Sc3I+IxpA+
         xz8+CLtwZaUTd2MrRWOyNrySZFvq8myl7gwMHZCdWHz4/2f/sHe0sC+Wf+6+da+PucxA
         Cemw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=INEHUFOekANcgjh/QNyWbgLp7c+/Fz6l2Ofc/xXR09E=;
        b=U91eOIMRHa6MBufi3bPUBj+C6thAw/NpFSvJmtDKbcViEztWH8CnKMC1LlT/mLgPvr
         mNwV47UGBtZw5W0nhbCjps8D1iRXxttYeXKdKH690L/jyDLz/kYbnjwZQiz66gNHXQAh
         g6f3XqSTrkgCq/6LAZtS9c3l7M4zX6aX/OBT5UWvhCFzRFq2v+37zGMAM+pjEbgNChG0
         YWzuqpEMD2OLEo8zc/uTu3KySNM1rKFUt1y72WBrN5rKUR0sch4KP2lffJUdXK7ZzByC
         HkjVqAKw1fLuDvyX9g0Kl3BIdj819HsiUJ5JamoJvkTGwJb9zqouzWdnt9nAuZbPOdQF
         g15Q==
X-Gm-Message-State: AOAM530OAGMjtTUXXgfxy0J+zoUTBNL0rug5UtTR9h3Q5eAyHmRMWnek
        iGudMU4P4Wfx7UB9szCIEbEwqSQQOVxd7w==
X-Google-Smtp-Source: ABdhPJx6rZlwlUtcpSP/hBTHFw8Wb/LvcqVH6mE88QXWkoUWM8FOoT17Kkcy3j9m/7BipFU2SVDbcA==
X-Received: by 2002:a05:600c:4105:: with SMTP id j5mr1136946wmi.86.1628837341406;
        Thu, 12 Aug 2021 23:49:01 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:ecac:74b8:17cb:429a? (p200300ea8f10c200ecac74b817cb429a.dip0.t-ipconnect.de. [2003:ea:8f10:c200:ecac:74b8:17cb:429a])
        by smtp.googlemail.com with ESMTPSA id a11sm636647wrq.6.2021.08.12.23.49.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 23:49:00 -0700 (PDT)
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, nic_swsd@realtek.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:8169 10/100/1000 GIGABIT ETHERNET DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20210812155341.817031-1-kai.heng.feng@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 1/2] r8169: Implement dynamic ASPM mechanism
Message-ID: <631a47b7-f068-7770-65f4-bdfedc4b7d6c@gmail.com>
Date:   Fri, 13 Aug 2021 08:48:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210812155341.817031-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.08.2021 17:53, Kai-Heng Feng wrote:
> r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> Same issue can be observed with older vendor drivers.
> 
> The issue is however solved by the latest vendor driver. There's a new
> mechanism, which disables r8169's internal ASPM when the NIC traffic has
> more than 10 packets, and vice versa.
> 
> Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125

As we have Realtek in this mail thread:
Typically hw issues affect 1-3 chip versions only. The ASPM problems seem
to have been existing for at least 15 years now, in every chip version.
It seems that even the new RTL8125 chip generation still has broken ASPM.
Why was this never fixed? ASPM not considered to be relevant? HW design
too broken?

> use dynamic ASPM under Windows. So implement the same mechanism here to
> resolve the issue.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v2: 
>  - Use delayed_work instead of timer_list to avoid interrupt context
>  - Use mutex to serialize packet counter read/write
>  - Wording change
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 45 +++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index c7af5bc3b8af..7ab2e841dc69 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -624,6 +624,11 @@ struct rtl8169_private {
>  
>  	unsigned supports_gmii:1;
>  	unsigned aspm_manageable:1;
> +	unsigned aspm_enabled:1;
> +	struct delayed_work aspm_toggle;
> +	struct mutex aspm_mutex;
> +	u32 aspm_packet_count;
> +
>  	dma_addr_t counters_phys_addr;
>  	struct rtl8169_counters *counters;
>  	struct rtl8169_tc_offsets tc_offset;
> @@ -2671,6 +2676,8 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>  		RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
>  	}
>  
> +	tp->aspm_enabled = enable;
> +
>  	udelay(10);
>  }
>  
> @@ -4408,6 +4415,9 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
>  
>  	dirty_tx = tp->dirty_tx;
>  
> +	mutex_lock(&tp->aspm_mutex);
> +	tp->aspm_packet_count += tp->cur_tx - dirty_tx;
> +	mutex_unlock(&tp->aspm_mutex);
>  	while (READ_ONCE(tp->cur_tx) != dirty_tx) {
>  		unsigned int entry = dirty_tx % NUM_TX_DESC;
>  		u32 status;
> @@ -4552,6 +4562,10 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
>  		rtl8169_mark_to_asic(desc);
>  	}
>  
> +	mutex_lock(&tp->aspm_mutex);
> +	tp->aspm_packet_count += count;
> +	mutex_unlock(&tp->aspm_mutex);
> +
>  	return count;
>  }
>  
> @@ -4659,8 +4673,33 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
>  	return 0;
>  }
>  
> +#define ASPM_PACKET_THRESHOLD 10
> +#define ASPM_TOGGLE_INTERVAL 1000
> +
> +static void rtl8169_aspm_toggle(struct work_struct *work)
> +{
> +	struct rtl8169_private *tp = container_of(work, struct rtl8169_private,
> +						  aspm_toggle.work);
> +	bool enable;
> +
> +	mutex_lock(&tp->aspm_mutex);
> +	enable = tp->aspm_packet_count <= ASPM_PACKET_THRESHOLD;
> +	tp->aspm_packet_count = 0;
> +	mutex_unlock(&tp->aspm_mutex);
> +
> +	if (tp->aspm_enabled != enable) {
> +		rtl_unlock_config_regs(tp);
> +		rtl_hw_aspm_clkreq_enable(tp, enable);
> +		rtl_lock_config_regs(tp);
> +	}
> +
> +	schedule_delayed_work(&tp->aspm_toggle, ASPM_TOGGLE_INTERVAL);
> +}
> +
>  static void rtl8169_down(struct rtl8169_private *tp)
>  {
> +	cancel_delayed_work_sync(&tp->aspm_toggle);
> +
>  	/* Clear all task flags */
>  	bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
>  
> @@ -4687,6 +4726,8 @@ static void rtl8169_up(struct rtl8169_private *tp)
>  	rtl_reset_work(tp);
>  
>  	phy_start(tp->phydev);
> +
> +	schedule_delayed_work(&tp->aspm_toggle, ASPM_TOGGLE_INTERVAL);
>  }
>  
>  static int rtl8169_close(struct net_device *dev)
> @@ -5347,6 +5388,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	INIT_WORK(&tp->wk.work, rtl_task);
>  
> +	INIT_DELAYED_WORK(&tp->aspm_toggle, rtl8169_aspm_toggle);
> +
> +	mutex_init(&tp->aspm_mutex);
> +
>  	rtl_init_mac_address(tp);
>  
>  	dev->ethtool_ops = &rtl8169_ethtool_ops;
> 

