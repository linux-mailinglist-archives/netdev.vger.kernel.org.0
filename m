Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1721E3DF60C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 21:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239016AbhHCT56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 15:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbhHCT55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 15:57:57 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BF5C061757;
        Tue,  3 Aug 2021 12:57:46 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id h14so26514871wrx.10;
        Tue, 03 Aug 2021 12:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W910qsi8DWXCLtyDy90ie/XG/4N5cBUlBViSbfRU34s=;
        b=E08Yf/ASIgK1GzuVigjOubkY5yNb4xWtq/PaKzBVSi5zyGV0EwE5FUql6Fgwuu6Jcg
         Pmmlv2r+kJrzOFZ2+cuJaadZk/7w+/54DFYECmqT8bSwTwUQSym2J7lvmfi+sI72oZPC
         DooJxOg6C3NyK0xrTf/nAcdJdqMcln38bYLVwbm2yQTAnwfCPdESa22TIH6ptzv5quQ+
         d2273DERPRtEMDnLqOjEKq8h6Kt6eyac0cwYva4GcopEc2L1kQdXE5hVDAQtbbUiqlb0
         JLCrNbCPPCagOVQ1Qef3pWedlGgZUNvpik+Ksv8bT+nokJ/nFRfkC2mKIES1M0XIOP22
         yEhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W910qsi8DWXCLtyDy90ie/XG/4N5cBUlBViSbfRU34s=;
        b=HaWFjQkJ+878Xgn0SRnuBuPi/yp9hV0P3GuC0PipM5R8ia1awN4Ym1QsgjakLhxxj+
         Elq6ounLJAIBNdb9hGGGVOD8mZO1XV2r17NvzdpqQ5LIMjDY4dNMq5Kz50/pEMMqL96A
         nsqtusadQPodUk8854eaJ8rHi+xCFf6Sl7e9z+VfdIRIDvdTMKp56btFLBKfxTW2UVmo
         4I5uQ2CKDl8Ag19LEyoj07zpYQPvrecfqiuRkuovbtu1DNed5WDPwz8Bb6u9uUWJfmGS
         6D9kf99ZC7IsFt/dHT7DaI0699imkQqvFZTL5+Z3C5DLlKMb1A7TBpsnaVwGBDhyGOuH
         s53g==
X-Gm-Message-State: AOAM533z1sQJ8yy6IUvakNuDjK0DmNf4dgk95FcydITW+0RUVhEODW3F
        T79gaAvPAVHerEkeq5jHil0+3f9Pq8P9ZQ==
X-Google-Smtp-Source: ABdhPJyOag+RIt+7sDSEdnZVSRtq97Uhlv45H3fC3rTxmPwe5X6FWBOUcqO09FRNqxEci6g/59/Rwg==
X-Received: by 2002:adf:f68a:: with SMTP id v10mr24795021wrp.366.1628020664576;
        Tue, 03 Aug 2021 12:57:44 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:1168:dd9:b693:a674? (p200300ea8f10c20011680dd9b693a674.dip0.t-ipconnect.de. [2003:ea:8f10:c200:1168:dd9:b693:a674])
        by smtp.googlemail.com with ESMTPSA id u13sm16696035wmj.14.2021.08.03.12.57.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 12:57:44 -0700 (PDT)
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, nic_swsd@realtek.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:8169 10/100/1000 GIGABIT ETHERNET DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20210803152823.515849-1-kai.heng.feng@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 1/2] r8169: Implement dynamic ASPM mechanism
Message-ID: <f5f553ad-904d-dac5-dac5-3d7e266ab2fb@gmail.com>
Date:   Tue, 3 Aug 2021 21:57:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210803152823.515849-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.08.2021 17:28, Kai-Heng Feng wrote:
> r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> Same issue can be observed with older vendor drivers.
> 
> The issue is however solved by the latest vendor driver. There's a new

Is there any errata document from Realtek recommending this workaround?
Any prove that it solves the issues in all cases of ASPM issues we've
seen so far?
Also your heuristics logic seems to be different from the one in r8168.
The vendor driver considers also rx packets.

In addition you use this logic also for chip versions not covered by
r8168, like RTL8125. Any info from Realtek regarding these chip versions?

> mechanism, which disables r8169's internal ASPM when the NIC has
> substantial network traffic, and vice versa.
> 
10 packets per second I wouldn't call substantial traffic.
I'm afraid we may open a can of worms and may be bothered
with bug reports and complaints again.

> So implement the same mechanism here to resolve the issue.
> 
For me this risk is too high to re-enable ASPM for a lot of chip
versions w/o any official errata and workaround information.
I propose you make this change downstream, and if there are no
user complaints after some months I may consider to have something
like that in the mainline driver.

> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 36 +++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index c7af5bc3b8af..e257d3cd885e 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -624,6 +624,10 @@ struct rtl8169_private {
>  
>  	unsigned supports_gmii:1;
>  	unsigned aspm_manageable:1;
> +	unsigned aspm_enabled:1;
> +	struct timer_list aspm_timer;
> +	u32 aspm_packet_count;
> +
>  	dma_addr_t counters_phys_addr;
>  	struct rtl8169_counters *counters;
>  	struct rtl8169_tc_offsets tc_offset;
> @@ -2671,6 +2675,8 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>  		RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
>  	}
>  
> +	tp->aspm_enabled = enable;
> +
>  	udelay(10);
>  }
>  
> @@ -4408,6 +4414,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
>  
>  	dirty_tx = tp->dirty_tx;
>  
> +	tp->aspm_packet_count += tp->cur_tx - dirty_tx;
>  	while (READ_ONCE(tp->cur_tx) != dirty_tx) {
>  		unsigned int entry = dirty_tx % NUM_TX_DESC;
>  		u32 status;
> @@ -4552,6 +4559,8 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
>  		rtl8169_mark_to_asic(desc);
>  	}
>  
> +	tp->aspm_packet_count += count;
> +
>  	return count;
>  }
>  
> @@ -4659,8 +4668,31 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
>  	return 0;
>  }
>  
> +#define ASPM_PACKET_THRESHOLD 10
> +#define ASPM_TIMER_INTERVAL 1000
> +
> +static void rtl8169_aspm_timer(struct timer_list *timer)
> +{
> +	struct rtl8169_private *tp = from_timer(tp, timer, aspm_timer);
> +	bool enable;
> +
> +	enable = tp->aspm_packet_count <= ASPM_PACKET_THRESHOLD;
> +
> +	if (tp->aspm_enabled != enable) {
> +		rtl_unlock_config_regs(tp);
> +		rtl_hw_aspm_clkreq_enable(tp, enable);
> +		rtl_lock_config_regs(tp);

All this in interrupt context w/o locking?

> +	}
> +
> +	tp->aspm_packet_count = 0;
> +
> +	mod_timer(timer, jiffies + msecs_to_jiffies(ASPM_TIMER_INTERVAL));
> +}
> +
>  static void rtl8169_down(struct rtl8169_private *tp)
>  {
> +	del_timer_sync(&tp->aspm_timer);
> +
>  	/* Clear all task flags */
>  	bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
>  
> @@ -4687,6 +4719,10 @@ static void rtl8169_up(struct rtl8169_private *tp)
>  	rtl_reset_work(tp);
>  
>  	phy_start(tp->phydev);
> +
> +	timer_setup(&tp->aspm_timer, rtl8169_aspm_timer, 0);
> +	mod_timer(&tp->aspm_timer,
> +		  jiffies + msecs_to_jiffies(ASPM_TIMER_INTERVAL));
>  }
>  
>  static int rtl8169_close(struct net_device *dev)
> 

