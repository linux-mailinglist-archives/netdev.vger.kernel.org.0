Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8A349BD35
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 21:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbiAYUdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 15:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiAYUdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 15:33:22 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C89C06173B;
        Tue, 25 Jan 2022 12:33:22 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id l25so22004920wrb.13;
        Tue, 25 Jan 2022 12:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=XWTqGvSPZPAtZf86fC2QPV8mUXyPgG/LryGPuKSLYFw=;
        b=IPXKAmPG1YlrzOnMFrwaiVjLqpv/pYNvOBLPvKLUEMDpTuffaeY5v5aBf6bsLYnQP0
         tTaOgBVhO1HPFY2a/D8yDO1N7NDp364YWjLeVfruiveomtydVP9xihTe2d13xpfpRUVP
         0+0HGQrMJiwFi8QMikIZPf7HYYcJIlVlag6PFPlYnloypqnooVRfGVkRVvPLM9s0zeRN
         ENpTJk/2GiAUf0WN0vD6t70ls6Sy6HR9gmncgqsE9TSBTXVvUQPAmmz9M0xjmqqBPzE8
         3EUFZIkz6EYMVY3oHsmm+b7Fd5+DH70pij0qYnR2lfrH1jfvaAcn3+uLIbcrU2zMNgSK
         Qt0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=XWTqGvSPZPAtZf86fC2QPV8mUXyPgG/LryGPuKSLYFw=;
        b=jOXQDIAURdGZ9C4kswWMNeR65WfP2Qoj01QN3O9gR7Oi1NcfZpY7nOQo3TziWK5dFN
         FErwpdli5yV7dKux4cVSLKl3OSBYMG+XCGsZZi6QFOFOAiM9R9Ha+EIYIeYMZ0jbyHAD
         KUBQjT/yzpmFRMlIuxLRUcVpogn72gW9nIqXKvVIZLYwe8nq6t+0ujrB84doFa3bMgk9
         0HtJoj76aNLFFLZglaldW9vts/uJq4xBFfvKI9+aeJqnvb/mIhc/qlpIm0N4IgaCOiu3
         EpkcvZgpWr9DOR76Cq0lqFePUDagGKGpdZGluZY5Qn2qo65tWu61iIqyYAJ6/VhcOyHd
         FnvQ==
X-Gm-Message-State: AOAM531P/9dJE2GJL4ij2RqEpBk7mvzj+GpPF5p4SAWqtOPjqJa42rPz
        99wDK5AbXLJms3gw2YfvPTjR5C07RMo=
X-Google-Smtp-Source: ABdhPJyhhQpfdHzzNl2R6EqKM/LUsyZRolZiDBWl+wAsVlYxG/4cgl7McCSb9zmON6KpStQZfdzdWg==
X-Received: by 2002:a05:6000:10d2:: with SMTP id b18mr19337509wrx.593.1643142800428;
        Tue, 25 Jan 2022 12:33:20 -0800 (PST)
Received: from ?IPV6:2003:ea:8f4d:2b00:5062:8000:c669:60de? (p200300ea8f4d2b0050628000c66960de.dip0.t-ipconnect.de. [2003:ea:8f4d:2b00:5062:8000:c669:60de])
        by smtp.googlemail.com with ESMTPSA id n11sm5720830wms.3.2022.01.25.12.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 12:33:19 -0800 (PST)
Message-ID: <23d3e690-da16-df03-4c75-dc92625b2c96@gmail.com>
Date:   Tue, 25 Jan 2022 21:33:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Content-Language: en-US
To:     Chunhao Lin <hau@realtek.com>, netdev@vger.kernel.org
Cc:     nic_swsd@realtek.com, linux-kernel@vger.kernel.org
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
> +	/* Don't enable L1.2 in the chip if OS can't control ASPM */
> +	if (enable && tp->aspm_manageable) {
> +		r8168_mac_ocp_modify(tp, 0xe094, 0xff00, 0);
> +		r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, BIT(2));
> +	} else {
> +		r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, 0);
> +	}
> +}
> +

Register E094 bits 0..15 are cleared when enabling, but not touched
on disabling. I this correct?

And for basically the same purpose we have the following function.
"don't enable L1.2 in the chip" is not covered by ASPM_en in Config5?


static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
{
	/* Don't enable ASPM in the chip if OS can't control ASPM */
	if (enable && tp->aspm_manageable) {
		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
	} else {
		RTL_W8(tp, Config2, RTL_R8(tp, Config2) & ~ClkReqEn);
		RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
	}

	udelay(10);
}


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
>  	tp->dash_type = rtl_check_dash(tp);
>  

