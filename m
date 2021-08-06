Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6295F3E2F75
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 20:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243393AbhHFSr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 14:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbhHFSr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 14:47:58 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C8FC0613CF;
        Fri,  6 Aug 2021 11:47:41 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l11-20020a7bcf0b0000b0290253545c2997so6757708wmg.4;
        Fri, 06 Aug 2021 11:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AM/H3unTSxSDqsR+O+kDLhWrKW6exdQId4NIxE27gyc=;
        b=L+tLliBlJ3c9gFACRjNCYfLEwU1p4JhYNU47Ib7Kka5mzR8illbdQlqYeNA1eYY2GS
         uaKBtFr5mudI6dMaTnqsiutL3MCYyxHotGgLHjSwaMPbN+y8YGMzG6BknbeqK8A2PFqW
         TWowcVrZdFZXZkci3tdnA8lBfLAFiSG+C7aaVdQxxllSAeIMRuKHp4JCVe8pTCCiFu+r
         WUuPQAMjjNmDnQXmsaGC9JgBXcpnjcYVZHerOvwhmVQyiaukRwSrZ3Iuh7BXtNyzk4IW
         qK10tgWK6at62akoQF1/pmijIq7oBPWpYBIW17kCCR4ue7PZeHyKaAW/EG40Wajv1aH9
         YxNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AM/H3unTSxSDqsR+O+kDLhWrKW6exdQId4NIxE27gyc=;
        b=qwIzdXvhRoatnnSAog6bPmQHf8fWeC77M6QgN8TxvYuvl5D5iwov7oar+QLypUSJCs
         erJfVIKILjPiub+vw2JWeIjHOqyOGFmGDfOrvoUibpDRFcOYeV2EYhZJSfXfmcljRuQA
         ZRJT75rbkFoeWve27dXkHUVQKGJDyNPNT0rbKP2Mdxmezi4srlyNMBJ3BhTyN8Q2JDDz
         NUssss3ZsVmVabOAeqjYH6Sz+8VNm3xhszhXhSYS+FTlvn79voLrcTt8DzDBP6cVl2V2
         LZ2oCC3ZGYIOf1m5HMLFGN/puHKFbSJ7LEk42pHqD0a3rzNaN/Db9z1zhHGUrZZoYUSo
         qzBw==
X-Gm-Message-State: AOAM5306NusEOYW+uT1fN3lf9jX7L8UoJvXnLB+mlAklzmk494tcswwO
        yUwKFkBh4muJ15y58Ld3yYJh8TpzclxqnA==
X-Google-Smtp-Source: ABdhPJzufWDdJ/iOHHMnOBxMdXl4nnqQ0F9pMCj1B8UdDMR2hZmh8JQEfVu+WZoUdse6Radp97Op/g==
X-Received: by 2002:a05:600c:4f85:: with SMTP id n5mr4725110wmq.113.1628275660105;
        Fri, 06 Aug 2021 11:47:40 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:cc6d:4891:c067:bf7b? (p200300ea8f10c200cc6d4891c067bf7b.dip0.t-ipconnect.de. [2003:ea:8f10:c200:cc6d:4891:c067:bf7b])
        by smtp.googlemail.com with ESMTPSA id s14sm9130583wmc.25.2021.08.06.11.47.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 11:47:39 -0700 (PDT)
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, nic_swsd@realtek.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:8169 10/100/1000 GIGABIT ETHERNET DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20210803152823.515849-1-kai.heng.feng@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 1/2] r8169: Implement dynamic ASPM mechanism
Message-ID: <6a5f26e7-48a2-49c8-035e-19e9497c12a7@gmail.com>
Date:   Fri, 6 Aug 2021 20:47:30 +0200
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
> mechanism, which disables r8169's internal ASPM when the NIC has
> substantial network traffic, and vice versa.
> 
> So implement the same mechanism here to resolve the issue.
> 
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

I have one more question / concern regarding this workaround:
If bigger traffic starts and results in a congestion (let's call it like that
because we don't know in detail what happens in the chip), then it may take
up to a second until ASPM gets disabled and traffic gets back to normal.
This second is good enough to prevent that the timeout watchdog fires.
However in this second supposedly traffic is very limited, if possible at all.
Means if we have a network traffic pattern with alternating quiet and busy
periods then we may see a significant impact on performance.
Is this something that you tested?
