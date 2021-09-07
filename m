Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4DF402339
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 08:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhIGGEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 02:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbhIGGEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 02:04:39 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32868C061575;
        Mon,  6 Sep 2021 23:03:30 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d6so12028423wrc.11;
        Mon, 06 Sep 2021 23:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u9Vy0aULLkLGnSMAXVoKyEFfOibMmZBphkronbuspy4=;
        b=A6qhld2dOiF/zcAemPf906CKCQbyHVHAnbFb7uv5KJD0alOyI/wqALL61Z4fOWAZTM
         yHGakM8+8nBZPF11m3WFfBcY83HMKMiF6W/BL+fqPemfQh/F+SC3vcr/DKenkcg9u2nr
         zwCvaK+Bxioo0SmWqLiMLuWz0t9Ymre/Bukt+GSPgTFFGAAdJZR0WC6kBSFi/23I6gQG
         qJjKkAvo4ZQmUyP2I7mG82+a1CVYBATniXqEcR6uIIF7I6XTDcwyr7ovV0N1W2FtLTlr
         8e+b0bPgdQnexReQy8VlV5MLhoyH5tSUabIaX07Ax/3TC5ChqnPiFR5LBY8edV5/KSS1
         FRZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u9Vy0aULLkLGnSMAXVoKyEFfOibMmZBphkronbuspy4=;
        b=FNAyz0Be8EhgL2gkqFkmiypnGTTQxl+zpNb84stYBwSz7caq88g2A+ZhnN63Kwt38v
         b2DiweaHNxiq+Qxb3wAIhH1d9Aslm130UQNnAtdL6+wsqHWFU14SgDVDizmCvJ8s3hOY
         RcZesSNQbvzqwp9qVjduH+68lfrroG/9M4AbfAQJN2yZLjpg2QKY9WPuqkwcLy98M+2k
         9lPrJjrqyh3mGo8Yb6tor9uOk795TN13ryhUSkZdAmsLrMZqmnjnllO9N/aUCHMv5Dg0
         2qqZAoDuxVTkGr9+bKpgZCXTTCH02hVabq9HneSS126QaBlmOHoJ4zhOirVpRyowzfiL
         iJKw==
X-Gm-Message-State: AOAM532v+rfgM+QqVpVW5Vpa7SWawqr7GEl+upx8S5MdfLZnQfvC/dIu
        MFjojy0pqYHo9zLJh+9WtQLvFLlvd0c=
X-Google-Smtp-Source: ABdhPJzRuHDJmEYUUPVq5MGPWq4neeW810ThfqKZQdIB5HgTGFE8p7E1n2LYbB0qOm9xGUifgdvh7w==
X-Received: by 2002:a5d:514e:: with SMTP id u14mr16443662wrt.303.1630994608532;
        Mon, 06 Sep 2021 23:03:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:24d5:5922:dc9b:cc54? (p200300ea8f08450024d55922dc9bcc54.dip0.t-ipconnect.de. [2003:ea:8f08:4500:24d5:5922:dc9b:cc54])
        by smtp.googlemail.com with ESMTPSA id z19sm1652259wma.0.2021.09.06.23.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 23:03:28 -0700 (PDT)
Subject: Re: [RFC] [PATCH net-next v4] [PATCH 2/2] r8169: Implement dynamic
 ASPM mechanism
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, nic_swsd@realtek.com,
        bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210827171452.217123-1-kai.heng.feng@canonical.com>
 <20210827171452.217123-3-kai.heng.feng@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <2839f04c-8d7b-b010-f7c4-540359037d38@gmail.com>
Date:   Tue, 7 Sep 2021 08:03:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210827171452.217123-3-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.08.2021 19:14, Kai-Heng Feng wrote:
> r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> Same issue can be observed with older vendor drivers.
> 
> The issue is however solved by the latest vendor driver. There's a new
> mechanism, which disables r8169's internal ASPM when the NIC traffic has
> more than 10 packets, and vice versa. The possible reason for this is
> likely because the buffer on the chip is too small for its ASPM exit
> latency.
> 
> Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125
> use dynamic ASPM under Windows. So implement the same mechanism here to
> resolve the issue.
> 
> Because ASPM control may not be granted by BIOS while ASPM is enabled,
> remove aspm_manageable and use pcie_aspm_capable() instead. If BIOS
> enables ASPM for the device, we want to enable dynamic ASPM on it.
> 
> In addition, since PCIe ASPM can be switched via sysfs, enable/disable
> dynamic ASPM accordingly by checking pcie_aspm_enabled().
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v4:
>  - Squash two patches
>  - Remove aspm_manageable and use pcie_aspm_capable()
>    pcie_aspm_enabled() accordingly
> 
> v3:
>  - Use msecs_to_jiffies() for delay time
>  - Use atomic_t instead of mutex for bh
>  - Mention the buffer size and ASPM exit latency in commit message
> 
> v2: 
>  - Use delayed_work instead of timer_list to avoid interrupt context
>  - Use mutex to serialize packet counter read/write
>  - Wording change
>  drivers/net/ethernet/realtek/r8169_main.c | 77 ++++++++++++++++++++---
>  1 file changed, 69 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 46a6ff9a782d7..97dba8f437b78 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -623,7 +623,10 @@ struct rtl8169_private {
>  	} wk;
>  
>  	unsigned supports_gmii:1;
> -	unsigned aspm_manageable:1;
> +	unsigned rtl_aspm_enabled:1;
> +	struct delayed_work aspm_toggle;
> +	atomic_t aspm_packet_count;
> +
>  	dma_addr_t counters_phys_addr;
>  	struct rtl8169_counters *counters;
>  	struct rtl8169_tc_offsets tc_offset;
> @@ -698,6 +701,20 @@ static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
>  	       tp->mac_version <= RTL_GIGA_MAC_VER_53;
>  }
>  
> +static int rtl_supports_aspm(struct rtl8169_private *tp)
> +{
> +	switch (tp->mac_version) {
> +	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_31:
> +	case RTL_GIGA_MAC_VER_37:
> +	case RTL_GIGA_MAC_VER_39:
> +	case RTL_GIGA_MAC_VER_43:
> +	case RTL_GIGA_MAC_VER_47:
> +		return 0;
> +	default:
> +		return 1;
> +	}

Why is this needed now that you have pcie_aspm_capable()?

> +}
> +
>  static bool rtl_supports_eee(struct rtl8169_private *tp)
>  {
>  	return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
> @@ -2699,8 +2716,15 @@ static void rtl_enable_exit_l1(struct rtl8169_private *tp)
>  
>  static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>  {
> +	struct pci_dev *pdev = tp->pci_dev;
> +
> +	if (!pcie_aspm_enabled(pdev) && enable)
> +		return;
> +
> +	tp->rtl_aspm_enabled = enable;
> +
>  	/* Don't enable ASPM in the chip if OS can't control ASPM */
> -	if (enable && tp->aspm_manageable) {
> +	if (enable) {
>  		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
>  		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
>  	} else {
> @@ -4440,6 +4464,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
>  
>  	dirty_tx = tp->dirty_tx;
>  
> +	atomic_add(tp->cur_tx - dirty_tx, &tp->aspm_packet_count);
>  	while (READ_ONCE(tp->cur_tx) != dirty_tx) {
>  		unsigned int entry = dirty_tx % NUM_TX_DESC;
>  		u32 status;
> @@ -4584,6 +4609,8 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
>  		rtl8169_mark_to_asic(desc);
>  	}
>  
> +	atomic_add(count, &tp->aspm_packet_count);
> +
>  	return count;
>  }
>  
> @@ -4691,8 +4718,39 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
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
> +	int packet_count;
> +	bool enable;
> +
> +	packet_count = atomic_xchg(&tp->aspm_packet_count, 0);
> +
> +	if (pcie_aspm_enabled(tp->pci_dev)) {
> +		enable = packet_count <= ASPM_PACKET_THRESHOLD;
> +
> +		if (tp->rtl_aspm_enabled != enable) {
> +			rtl_unlock_config_regs(tp);

This looks racy. Another unlock_config_regs/do_something/lock_config_regs
can run in parallel. And if such a parallel lock_config_regs is executed
exactly here, then rtl_hw_aspm_clkreq_enable() may fail.

> +			rtl_hw_aspm_clkreq_enable(tp, enable);
> +			rtl_lock_config_regs(tp);
> +		}
> +	} else if (tp->rtl_aspm_enabled) {
> +		rtl_unlock_config_regs(tp);
> +		rtl_hw_aspm_clkreq_enable(tp, false);
> +		rtl_lock_config_regs(tp);
> +	}
> +
> +	schedule_delayed_work(&tp->aspm_toggle, msecs_to_jiffies(ASPM_TOGGLE_INTERVAL));
> +}
> +
>  static void rtl8169_down(struct rtl8169_private *tp)
>  {
> +	cancel_delayed_work_sync(&tp->aspm_toggle);
> +
>  	/* Clear all task flags */
>  	bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
>  
> @@ -4719,6 +4777,11 @@ static void rtl8169_up(struct rtl8169_private *tp)
>  	rtl_reset_work(tp);
>  
>  	phy_start(tp->phydev);
> +
> +	/* pcie_aspm_capable may change after system resume */
> +	if (pcie_aspm_support_enabled() && pcie_aspm_capable(tp->pci_dev) &&
> +	    rtl_supports_aspm(tp))
> +		schedule_delayed_work(&tp->aspm_toggle, 0);
>  }
>  
>  static int rtl8169_close(struct net_device *dev)
> @@ -5306,12 +5369,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (rc)
>  		return rc;
>  
> -	/* Disable ASPM L1 as that cause random device stop working
> -	 * problems as well as full system hangs for some PCIe devices users.
> -	 */
> -	rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
> -	tp->aspm_manageable = !rc;
> -
>  	/* enable device (incl. PCI PM wakeup and hotplug setup) */
>  	rc = pcim_enable_device(pdev);
>  	if (rc < 0) {
> @@ -5378,6 +5435,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	INIT_WORK(&tp->wk.work, rtl_task);
>  
> +	INIT_DELAYED_WORK(&tp->aspm_toggle, rtl8169_aspm_toggle);
> +
> +	atomic_set(&tp->aspm_packet_count, 0);
> +
>  	rtl_init_mac_address(tp);
>  
>  	dev->ethtool_ops = &rtl8169_ethtool_ops;
> 

