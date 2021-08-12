Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DFC3EAB21
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 21:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbhHLTjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 15:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbhHLTjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 15:39:39 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63865C061756;
        Thu, 12 Aug 2021 12:39:13 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x10so3556368wrt.8;
        Thu, 12 Aug 2021 12:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f1OrkRg0MF6p8RbuM8DdPW5HI5cmNqC1aOfIeyX1J90=;
        b=UFBI1TqkKQ4TymtNrwUPyNvNb3z5McUTExypR9qoMlOeauluqGRpCiufV2xKSEroXR
         Ol2Tc+YNv1gVEqEqsJ83BLwLLN/8XNCMFIqlyXOW1hM9/LqKyM9FRQB/1egy7Gj0w9RT
         Tkx/uTJDTB3HjLUsq0X/s/5A5raAO2fUu6Bi34z0DofxLkqdpFw0WQt7rXTyDNItCf4h
         svVOHmCJShL2MB8BBJY5ULGuIMvGmY67pEZiwzYCyYxPpcpAUNDbh3pptQ1pOMKLDexB
         z3uNjyyXeVd8Jcb7GvH5jnEkBkl0cQm7k8qoFnyTgGMXiM51wamMSmfuMKfIbCaxYXv4
         Lelw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f1OrkRg0MF6p8RbuM8DdPW5HI5cmNqC1aOfIeyX1J90=;
        b=WIVp0MpI6WyqobJKPmvyZNSaUp9uIBGl2z7fAe68RfeXF1YclQsew7ON0SSVJ8CrkE
         BiY+3tojaHZpX91d0sXZgLo+ogpa68TbQ0jnFf0vNZrdf0H5ozn2F154LPSjpbtgo085
         dcINVDNF3dQaCHfX7uwlBtwbKr+O0HOtW3lgifZxfw//t3AUoPxzuiyf90pVhX6fkdIH
         8Mhvi28G925R0MbLXCeWQEi2sawVpxEi8x42c7jCYOsxENniMqi1Gr38W674jLMCd7EQ
         nofdprN7smbP4fQhrYrH2TQz2/UIf7z5cKXzj96op3744ILJyiU+YZRmlLikaCIvKnVN
         3IBQ==
X-Gm-Message-State: AOAM5314HUMzkVJ33tny4+MM0/Vr3gqryO1GkL+1m7R6hYcYVkPWRuTV
        f7uwS/shrSbnIchyer7ZGq+wxWm2ixEaDw==
X-Google-Smtp-Source: ABdhPJy3rGMRziZwzbsIQERT/xkaEYLK8vRvyhMT8U68I3LFXoFPmjS2nNsvN1m1Bn5mDY4TvKZpPQ==
X-Received: by 2002:a5d:4bca:: with SMTP id l10mr4706634wrt.187.1628797151800;
        Thu, 12 Aug 2021 12:39:11 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:5c12:d692:d13:24d5? (p200300ea8f10c2005c12d6920d1324d5.dip0.t-ipconnect.de. [2003:ea:8f10:c200:5c12:d692:d13:24d5])
        by smtp.googlemail.com with ESMTPSA id i9sm4901658wre.36.2021.08.12.12.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 12:39:11 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] r8169: Enable ASPM for selected NICs
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, nic_swsd@realtek.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:8169 10/100/1000 GIGABIT ETHERNET DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20210812155341.817031-1-kai.heng.feng@canonical.com>
 <20210812155341.817031-2-kai.heng.feng@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3633f984-8dd6-f81b-85f9-6083420b4516@gmail.com>
Date:   Thu, 12 Aug 2021 21:38:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210812155341.817031-2-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.08.2021 17:53, Kai-Heng Feng wrote:
> The latest vendor driver enables ASPM for more recent r8168 NICs, do the
> same here to match the behavior.
> 
> In addition, pci_disable_link_state() is only used for RTL8168D/8111D in
> vendor driver, also match that.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v2:
>  - No change
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 34 +++++++++++++++++------
>  1 file changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 7ab2e841dc69..caa29e72a21a 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -623,7 +623,7 @@ struct rtl8169_private {
>  	} wk;
>  
>  	unsigned supports_gmii:1;
> -	unsigned aspm_manageable:1;
> +	unsigned aspm_supported:1;
>  	unsigned aspm_enabled:1;
>  	struct delayed_work aspm_toggle;
>  	struct mutex aspm_mutex;
> @@ -2667,8 +2667,11 @@ static void rtl_pcie_state_l2l3_disable(struct rtl8169_private *tp)
>  
>  static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>  {
> +	if (!tp->aspm_supported)
> +		return;
> +
>  	/* Don't enable ASPM in the chip if OS can't control ASPM */
> -	if (enable && tp->aspm_manageable) {
> +	if (enable) {
>  		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
>  		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
>  	} else {
> @@ -5284,6 +5287,21 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
>  	rtl_rar_set(tp, mac_addr);
>  }
>  
> +static int rtl_hw_aspm_supported(struct rtl8169_private *tp)
> +{
> +	switch (tp->mac_version) {
> +	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_36:
> +	case RTL_GIGA_MAC_VER_38:
> +	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_42:
> +	case RTL_GIGA_MAC_VER_44 ... RTL_GIGA_MAC_VER_46:
> +	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_63:

This shouldn't be needed because ASPM support is announced the
standard PCI way. Max a blacklist should be needed if there are
chip versions that announce ASPM support whilst in reality they
do not support it (or support is completely broken).

> +		return 1;
> +
> +	default:
> +		return 0;
> +	}
> +}
> +
>  static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  {
>  	struct rtl8169_private *tp;
> @@ -5315,12 +5333,12 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (rc)
>  		return rc;
>  
> -	/* Disable ASPM completely as that cause random device stop working
> -	 * problems as well as full system hangs for some PCIe devices users.
> -	 */
> -	rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
> -					  PCIE_LINK_STATE_L1);
> -	tp->aspm_manageable = !rc;
> +	if (tp->mac_version == RTL_GIGA_MAC_VER_25)
> +		pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
> +				       PCIE_LINK_STATE_L1 |
> +				       PCIE_LINK_STATE_CLKPM);
> +
> +	tp->aspm_supported = rtl_hw_aspm_supported(tp);
>  
>  	/* enable device (incl. PCI PM wakeup and hotplug setup) */
>  	rc = pcim_enable_device(pdev);
> 

