Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E61B499E97
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 00:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356683AbiAXWjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 17:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588658AbiAXWdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 17:33:41 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E77C02B86D;
        Mon, 24 Jan 2022 12:57:48 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id e8so14158279wrc.0;
        Mon, 24 Jan 2022 12:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=Vh+/qgpRuPd49i7Zrof8cU/ciLi8dXSsAWBo51GqEdM=;
        b=i7XcIiTRRik6M/Q0oNNkvfsBhzjmvbA8r1YNL3PY5oGQblLvESWVklRiuph3HJR4oy
         iM0QLNeQB+KvebohLo2zdri2kEqVPaY8fHaGaeL80jBk8YJCCQPANrmd2SkO2QalS/Jl
         n4SMaVXgJ76qlopAzFtMAGZqzDHr7rFu6WJ/oQN+AUxZnsWAnZWqJkBtlMjyBaakpe1v
         aqz0R9BrwvI13A/oIQS1lUm5agYr7Gd3SSy7zOsY2KgLgneemt9u9s5EE/u8TRQhf7AA
         hqnmybpX/CVbhHMswrFEUuCVACcf7vMkW3w5FeAsF9QrBV1JC5Oq1PKm1GRwBWaHPnMn
         pRFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=Vh+/qgpRuPd49i7Zrof8cU/ciLi8dXSsAWBo51GqEdM=;
        b=Hezz6SsWlrDGr/4fcfnQhMD6GinoXmDGHVYXq8FLv6QvbyShCXQtrziwb1D6i+n8F5
         pulr2tEv3xn0lIwPduunOJQ+t492TD6AYLgoeenB7lTNYRc+l1irG24x02adZcTcsKut
         ZXzVHRZSHSvO+WT77TBJ+lns42fQTtraz7JRRu+WbU7QGDJO3XtoOS7uyY3r3zOW485o
         Txeo/InDklcgSgUkSV6Bg7YuYkz/qeHYXAFxpR5vEQcYKInRqsR2gvZda6rSA3u0Opoy
         ySH6nvw/YEnVP2UNY9XSkW8rWUS5HGKV8OcUdEfz4285s7FeijWqnuY3Cmh4lO0rpKvz
         RnLQ==
X-Gm-Message-State: AOAM532lhBE1sMcuPHJfqrQyCvOtCOAZaNiFDrGktcKpVmBuURSV6XB1
        D+t5p8DByHj9ZUkwyQxvQHc=
X-Google-Smtp-Source: ABdhPJy6aZe7ESPicXliJzdwnFKG6DF94XTY15Wy9UKkVcdWQmSv9tvZQtRXoicN89xhspMaIp29eQ==
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr15902629wrn.502.1643057866415;
        Mon, 24 Jan 2022 12:57:46 -0800 (PST)
Received: from ?IPV6:2003:ea:8f4d:2b00:7c08:a48:e7d2:55c0? (p200300ea8f4d2b007c080a48e7d255c0.dip0.t-ipconnect.de. [2003:ea:8f4d:2b00:7c08:a48:e7d2:55c0])
        by smtp.googlemail.com with ESMTPSA id i17sm14709297wru.107.2022.01.24.12.57.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 12:57:45 -0800 (PST)
Message-ID: <b71ee3d2-5ecd-e4ee-d6ca-25bf017920cd@gmail.com>
Date:   Mon, 24 Jan 2022 21:57:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Chunhao Lin <hau@realtek.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220124181937.6331-1-hau@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/1] r8169: enable RTL8125 ASPM L1.2
In-Reply-To: <20220124181937.6331-1-hau@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hau,

On 24.01.2022 19:19, Chunhao Lin wrote:
> This patch will enable RTL8125 ASPM L1.2 on the platforms that have
> tested RTL8125 with ASPM L1.2 enabled.
> Register mac ocp 0xc0b2 will help to identify if RTL8125 has been tested
> on L1.2 enabled platform. If it is, this register will be set to 0xf.
> If not, this register will be default value 0.
> 
Who and what defines which value this register has? The BIOS? ACPI? Mainboard vendors
test and can control the flagging? How about add-on cards and systems with other
boot loaders, e.g. SBC's with RTL8125 like Odroid H2+?

What is actually the critical component that makes L1.2 work or not with
RTL8125 on a particular system? The chipset? Or electrical characteristics?

The difference in power consumption between L1.1 and L1.2 is a few mW ([0]).
So I wonder whether it's worth it to add this flagging mechanism.
Or does it also impact reaching certain package power saving states?

[0] https://pcisig.com/making-most-pcie%C2%AE-low-power-features

> Signed-off-by: Chunhao Lin <hau@realtek.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 99 ++++++++++++++++++-----
>  1 file changed, 79 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 19e2621e0645..b1e013969d4c 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -2238,21 +2238,6 @@ static void rtl_wol_enable_rx(struct rtl8169_private *tp)
>  			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
>  }
>  
> -static void rtl_prepare_power_down(struct rtl8169_private *tp)
> -{
> -	if (tp->dash_type != RTL_DASH_NONE)
> -		return;
> -
> -	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
> -	    tp->mac_version == RTL_GIGA_MAC_VER_33)
> -		rtl_ephy_write(tp, 0x19, 0xff64);
> -
> -	if (device_may_wakeup(tp_to_dev(tp))) {
> -		phy_speed_down(tp->phydev, false);
> -		rtl_wol_enable_rx(tp);
> -	}
> -}
> -
>  static void rtl_init_rxcfg(struct rtl8169_private *tp)
>  {
>  	switch (tp->mac_version) {
> @@ -2650,6 +2635,34 @@ static void rtl_pcie_state_l2l3_disable(struct rtl8169_private *tp)
>  	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Rdy_to_L23);
>  }
>  
> +static void rtl_disable_exit_l1(struct rtl8169_private *tp)
> +{

Why is this function needed? The chip should be quiet anyway.
IOW: What could be the impact of not having this function currently?
If it fixes something then it should be a separate patch.

> +	/* Bits control which events trigger ASPM L1 exit:
> +	 * Bit 12: rxdv
> +	 * Bit 11: ltr_msg
> +	 * Bit 10: txdma_poll
> +	 * Bit  9: xadm
> +	 * Bit  8: pktavi
> +	 * Bit  7: txpla
> +	 */
> +	switch (tp->mac_version) {
> +	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_36:
> +		rtl_eri_clear_bits(tp, 0xd4, 0x1f00);
> +		break;
> +	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_38:
> +		rtl_eri_clear_bits(tp, 0xd4, 0x0c00);
> +		break;
> +	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
> +		rtl_eri_clear_bits(tp, 0xd4, 0x1f80);
> +		break;
> +	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
> +		r8168_mac_ocp_modify(tp, 0xc0ac, 0x1f80, 0);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
>  static void rtl_enable_exit_l1(struct rtl8169_private *tp)
>  {
>  	/* Bits control which events trigger ASPM L1 exit:
> @@ -2692,6 +2705,33 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>  	udelay(10);
>  }
>  
> +static void rtl_hw_aspm_l12_enable(struct rtl8169_private *tp, bool enable)
> +{

I assume this code works on RTL8125 only. Then this should be reflected in
the function naming, like we do it for other version-specific functions.

> +	/* Don't enable L1.2 in the chip if OS can't control ASPM */
> +	if (enable && tp->aspm_manageable) {
> +		r8168_mac_ocp_modify(tp, 0xe094, 0xff00, 0);
> +		r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, BIT(2));
> +	} else {
> +		r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, 0);
> +	}
> +}
> +
> +static void rtl_prepare_power_down(struct rtl8169_private *tp)
> +{
> +	if (tp->dash_type != RTL_DASH_NONE)
> +		return;
> +
> +	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
> +	    tp->mac_version == RTL_GIGA_MAC_VER_33)
> +		rtl_ephy_write(tp, 0x19, 0xff64);
> +
> +	if (device_may_wakeup(tp_to_dev(tp))) {
> +		rtl_disable_exit_l1(tp);
> +		phy_speed_down(tp->phydev, false);
> +		rtl_wol_enable_rx(tp);
> +	}
> +}
> +
>  static void rtl_set_fifo_size(struct rtl8169_private *tp, u16 rx_stat,
>  			      u16 tx_stat, u16 rx_dyn, u16 tx_dyn)
>  {
> @@ -3675,6 +3715,7 @@ static void rtl_hw_start_8125b(struct rtl8169_private *tp)
>  	rtl_ephy_init(tp, e_info_8125b);
>  	rtl_hw_start_8125_common(tp);
>  
> +	rtl_hw_aspm_l12_enable(tp, true);
>  	rtl_hw_aspm_clkreq_enable(tp, true);
>  }
>  
> @@ -5255,6 +5296,20 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
>  	rtl_rar_set(tp, mac_addr);
>  }
>  
> +/* mac ocp 0xc0b2 will help to identify if RTL8125 has been tested
> + * on L1.2 enabled platform. If it is, this register will be set to 0xf.
> + * If not, this register will be default value 0.
> + */
> +static bool rtl_platform_l12_enabled(struct rtl8169_private *tp)
> +{

The function name is misleading. It could be read as checking whether
the platform supports L1.2.

> +	switch (tp->mac_version) {
> +	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
> +		return (r8168_mac_ocp_read(tp, 0xc0b2) & 0xf) ? true : false;
> +	default:
> +		return false;
> +	}
> +}
> +
>  static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  {
>  	struct rtl8169_private *tp;
> @@ -5333,11 +5388,15 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	 * Chips from RTL8168h partially have issues with L1.2, but seem
>  	 * to work fine with L1 and L1.1.
>  	 */
> -	if (tp->mac_version >= RTL_GIGA_MAC_VER_45)
> -		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
> -	else
> -		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
> -	tp->aspm_manageable = !rc;
> +	if (!rtl_platform_l12_enabled(tp)) {
> +		if (tp->mac_version >= RTL_GIGA_MAC_VER_45)
> +			rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
> +		else
> +			rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
> +		tp->aspm_manageable = !rc;
> +	} else {
> +		tp->aspm_manageable = pcie_aspm_enabled(pdev);
> +	}
>  

Better readable may be the following:

if (rtl_platform_l12_enabled(tp)) {
	tp->aspm_manageable = pcie_aspm_enabled(pdev);
} else if (tp->mac_version >= RTL_GIGA_MAC_VER_45) {
	rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
	tp->aspm_manageable = !rc;
} else {
	rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
	tp->aspm_manageable = !rc;
}

>  	tp->dash_type = rtl_check_dash(tp);
>  

