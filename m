Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A688B3EAB1F
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 21:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbhHLTjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 15:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbhHLTjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 15:39:35 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E46AC061756;
        Thu, 12 Aug 2021 12:39:09 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id f12-20020a05600c4e8c00b002e6bdd6ffe2so2156821wmq.5;
        Thu, 12 Aug 2021 12:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3NK0OQXBHDRnA/2ov9TC3rzj5ii4gRC8qeON0K+8PYk=;
        b=YUzxSaStkUygWWfJjkm25k3dudZxdgf9xmSLmrQjhiHkdBjMzvEw2GXG/+YYj++EUd
         YSJ5h0zQi/A3/gCSyqa+/dFUF0AYn44Y8qQHHRzNstmOKfMtkrDe2tqa5vOFdeix1p+4
         cHuGEtH+ajrXWYIOC30ewABjlonSxYabVRc4exeK+NvGZt01R7h6jMGZ7LlUPqCMBMae
         7QAxC3rUTKJbxELFXNm99QC1//6eE5sBtJ8r6BRpbPVnIKmx9s/vx+JZt1KWIPoFmDM9
         cbLxBBcbT4JgeJmsptn+/8kdW1RVjw5cpcESIBLqeL5X2rgujxnP/tEj9e8f91NjQZZi
         bj3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3NK0OQXBHDRnA/2ov9TC3rzj5ii4gRC8qeON0K+8PYk=;
        b=iuSpbZ4dNgls5n58uVYH8G5llmiLD4V1cIDkcucR4SYYNOQGyznImrqR/Gh1HmmhXv
         2Ktp596Msa2oJdWTM4fjpGGaqNeLQt4w6odEkLX6lP7mYwV192wRhjsmI/N7eOFvlBnx
         6hhViSK4ZXLV61YemTGxPevZAnyzqbtcxEKr51tTGXQRRJJAQjqbCiSk3PRR0Z1Sw8hH
         W/0rlJyQYiCgwOaK+YijYq/SkT5xXxPzSgOB+hfC1AkwLyE8oN4YQ6Ni/otosQHzvTDk
         hlY9AXEVhIKoMk2lgO3Q4M3cW/gAWAdnYLXyd7ND7kFnonwWA+HGXHz3Cb1X0gB4VhnA
         9HwQ==
X-Gm-Message-State: AOAM530k+xjDlsCpA4RAYbNLNlPbWW+U9mXDGweqzmDol5Dw8F0N3LjF
        fw7YrS1MUxQdawy2Re+yHc9zBuphAGQNKQ==
X-Google-Smtp-Source: ABdhPJx496e+J29s0jS1neri08H+KunFHq/4Ox68FR6q1avN90DE3coaQ4/Bkk6a2q+g20c/y4f7Zg==
X-Received: by 2002:a1c:20c5:: with SMTP id g188mr194019wmg.142.1628797147909;
        Thu, 12 Aug 2021 12:39:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:5c12:d692:d13:24d5? (p200300ea8f10c2005c12d6920d1324d5.dip0.t-ipconnect.de. [2003:ea:8f10:c200:5c12:d692:d13:24d5])
        by smtp.googlemail.com with ESMTPSA id h14sm3875188wrp.55.2021.08.12.12.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 12:39:07 -0700 (PDT)
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, nic_swsd@realtek.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:8169 10/100/1000 GIGABIT ETHERNET DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20210812155341.817031-1-kai.heng.feng@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 1/2] r8169: Implement dynamic ASPM mechanism
Message-ID: <875e7304-20a1-0bca-ee07-41b16f07152a@gmail.com>
Date:   Thu, 12 Aug 2021 21:34:34 +0200
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
> use dynamic ASPM under Windows. So implement the same mechanism here to
> resolve the issue.
> 
Realtek using something in their Windows drivers isn't really a proof of
quality. Still my concerns haven't been addressed. If ASPM is enabled and
there's a congestion in the chip it may take up to a second until ASPM
gets disabled. In this second traffic very likely is heavily affected.
Who takes care in case of problem reports?

This is a massive change for basically all chip versions. And experience
shows that in case of problem reports Realtek never cares, even though
they are listed as maintainers. All I see is that they copy more and more
code from r8169 into their own drivers. This seems to indicate that they
consider quality of their own drivers as not sufficient.

Still my proposal: Apply this downstream, and if there are no complaints
after a few months it may be considered for mainline.

Last but not least the formal issues:
- no cover letter
- no net/net-next annotation

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

We are in soft irq context here, therefore you shouldn't sleep.

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

In the first version you used msecs_to_jiffies(ASPM_TIMER_INTERVAL).
Now you use 1000 jiffies what is a major difference.

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

