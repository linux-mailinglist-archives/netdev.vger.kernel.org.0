Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E923F1317
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 08:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhHSGI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 02:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhHSGIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 02:08:55 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC88C061756;
        Wed, 18 Aug 2021 23:08:19 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id k29so7172234wrd.7;
        Wed, 18 Aug 2021 23:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=46xPdnelC9Lz7C9QmxLfZohZqHT3sRWuzqV3wuYMXtI=;
        b=LNSiwu7AJBg9hLKkg/rgT8fgOCmEEREB/qEDdJpVUgeCkXq0xiNaqKDqOrWKgxmQzR
         nR85YY4eokfdeEU1A/YdejvcgRjpjtbK47pt+QzcPhSzC0pni58iZ+vf4hrfTAS6xjUV
         B8u2t/TnHvFKDxcwDyuULHN98uyrmL8OOGV7Pw2WCR/anPmcxpQM4MBHE9SIUyxDlv28
         MwZVZBGKsGObk2yqahxbm9+o6QE461JtG54FI53Y4ZJLUQA4I+ABDqfP80TkL2LC2CQZ
         akmOSEiEf5rq1KkAdor6wZAYuPMUgFYTWyhVNiJWhBMkhsF8Ivw4yoGH44AAfkP0BD/E
         Ewsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=46xPdnelC9Lz7C9QmxLfZohZqHT3sRWuzqV3wuYMXtI=;
        b=oWdiI6aUeZkyZ5LR/fHExXVvO8EtMQfmPTpmoZHJhd4Z78u8DE74Pn4uBdpbsizDGs
         Whbv9jpEXjzZye/5XhyMsQdSPn0kDLnHenGSZHw04bDNX0XjlqVmwUSk3E6eGzx1qb+q
         DcCSttBXPXyI+lyQJZgqpCBxeb8hijAbcCviJMdWOyNy/iT0kKQ8CCogUuMsD0Ixb0UK
         DtiMpX7KlHE8/ZmPTi95TMggr1W8n5P74Z7VC+2oyI5rfYgR15WvLMv+L0HO4VR+oDtP
         /h4dKuxnbQyDXREGBPtFNNlD3y01ey7mmOQ4Eb31+11f57BPK6IoS+VIDYv6mr+CGNXr
         a6uA==
X-Gm-Message-State: AOAM533Q/dxEq83QfORiCIP85q9cmXbexkVj4DMf5dOZ9/LJbHE4mLRW
        S78O7fbdrLVbrTFiI56aiIDKmTDitfYH/Q==
X-Google-Smtp-Source: ABdhPJxZmhzTPP0t5Y2NVChU/TBUQhDzmlnQ0cOIg4DY/Yu9suMXt7pIWeq252XbCuAlt1vypLhaAg==
X-Received: by 2002:a5d:610d:: with SMTP id v13mr1585508wrt.199.1629353298352;
        Wed, 18 Aug 2021 23:08:18 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:9978:7b72:32e9:8917? (p200300ea8f08450099787b7232e98917.dip0.t-ipconnect.de. [2003:ea:8f08:4500:9978:7b72:32e9:8917])
        by smtp.googlemail.com with ESMTPSA id g35sm7658408wmp.9.2021.08.18.23.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 23:08:17 -0700 (PDT)
Subject: Re: [PATCH net-next v3 3/3] r8169: Enable ASPM for selected NICs
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, nic_swsd@realtek.com,
        bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210819054542.608745-1-kai.heng.feng@canonical.com>
 <20210819054542.608745-4-kai.heng.feng@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <084b8ea3-99d8-3393-4b74-0779c92fde64@gmail.com>
Date:   Thu, 19 Aug 2021 08:02:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210819054542.608745-4-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.08.2021 07:45, Kai-Heng Feng wrote:
> The latest vendor driver enables ASPM for more recent r8168 NICs, so
> disable ASPM on older chips and enable ASPM for the rest.
> 
> Rename aspm_manageable to pcie_aspm_manageable to indicate it's ASPM
> from PCIe, and use rtl_aspm_supported for Realtek NIC's internal ASPM
> function.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v3:
>  - Use pcie_aspm_supported() to retrieve ASPM support status
>  - Use whitelist for r8169 internal ASPM status
> 
> v2:
>  - No change
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 27 ++++++++++++++++-------
>  1 file changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 3359509c1c351..88e015d93e490 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -623,7 +623,8 @@ struct rtl8169_private {
>  	} wk;
>  
>  	unsigned supports_gmii:1;
> -	unsigned aspm_manageable:1;
> +	unsigned pcie_aspm_manageable:1;
> +	unsigned rtl_aspm_supported:1;
>  	unsigned rtl_aspm_enabled:1;
>  	struct delayed_work aspm_toggle;
>  	atomic_t aspm_packet_count;
> @@ -702,6 +703,20 @@ static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
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
> +}
> +
>  static bool rtl_supports_eee(struct rtl8169_private *tp)
>  {
>  	return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
> @@ -2669,7 +2684,7 @@ static void rtl_pcie_state_l2l3_disable(struct rtl8169_private *tp)
>  
>  static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>  {
> -	if (!tp->aspm_manageable && enable)
> +	if (!(tp->pcie_aspm_manageable && tp->rtl_aspm_supported) && enable)
>  		return;
>  
>  	tp->rtl_aspm_enabled = enable;
> @@ -5319,12 +5334,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (rc)
>  		return rc;
>  
> -	/* Disable ASPM completely as that cause random device stop working
> -	 * problems as well as full system hangs for some PCIe devices users.
> -	 */
> -	rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
> -					  PCIE_LINK_STATE_L1);
> -	tp->aspm_manageable = !rc;
> +	tp->pcie_aspm_manageable = pcie_aspm_supported(pdev);

That's not what I meant, and it's also not correct.

> +	tp->rtl_aspm_supported = rtl_supports_aspm(tp);
>  
>  	/* enable device (incl. PCI PM wakeup and hotplug setup) */
>  	rc = pcim_enable_device(pdev);
> 

