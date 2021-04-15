Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585AB361312
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 21:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbhDOTsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 15:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbhDOTsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 15:48:19 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F48C061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 12:47:54 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so12992335wmj.2
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 12:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k+McgmescnZgoGuw6PgrxQnj+P7vhXsg/nETOZTexA8=;
        b=r9yes0LogIOCjIdykmWLWHJn51p49VjAMJc9QwZhU5W4FknGNDXFKNyhONlDDUF7rn
         QaXOvZ0mMckqDT94Qj8Kn895AYhzp+zXosTovOouq0xnUcFYyv2VWzK75okSn5owJTpG
         TFDPypIwmlhvHGL59SN6lezH3L1Guic+0tp2UMB2id9UxT3FJmswlO09VQZGTaBvWLaT
         OZHN5djX0K736n0Bkm5SfFWjmuVULsJIcAQKfFh9X9s0YfF6Fj4B7HFbjySmWJDrpDYY
         hfl914MVQIDcrGE9yp5VBZJowSsCmJGxMnSIl9lWeGST8cK0OYidurD15ylxW49LnR4W
         oSXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k+McgmescnZgoGuw6PgrxQnj+P7vhXsg/nETOZTexA8=;
        b=HtSp3EgNTKyxKrB2BR6xH5SXUId2AJGBYNZ8yqiT0GRiTfxq2b59Vk6+fyp/cFbi0y
         EGsktUI8f1BAAU0wOTHwVEv/ffjFrMwFRuy2XdeD99fbYvnDQFZQPMGZ2b0bRTSsXFK2
         pX8f1esnL5b/NHHmOYu1xSSxUUO4b+HnhSWCfApXBQAdYbapJyE5DR+xg6GC86d3OUpE
         W0WaZTdrS4jYJCYmCsp1VQBaN9O0Q27hPbc3in5aUo2ZcPvSkVwy8/eFya0vU04V+lpz
         hgn4ZfyWfLglQQjfMdTzwn/M9f98k9Q0km58VdEnvQ34OIEH1phJQQ4lUHXWNoRK05wU
         2a+A==
X-Gm-Message-State: AOAM5302QnOBt44ZxExPmArEe2hE8eNyxrrG8KPfGQx75FKMBYI7VUS9
        k6yDRxWxcUWjIaRv/oqU8OyZzmHvMDS9qA==
X-Google-Smtp-Source: ABdhPJzqJbxtBu3HVKjuqifrE+yLaVTv7WXqv65BJ3GJjlnFYs+tFXOpgHjSp60yAm6BPSiu+BDdEQ==
X-Received: by 2002:a1c:b743:: with SMTP id h64mr3926596wmf.35.1618516073333;
        Thu, 15 Apr 2021 12:47:53 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:a8a1:99e1:b713:6999? (p200300ea8f384600a8a199e1b7136999.dip0.t-ipconnect.de. [2003:ea:8f38:4600:a8a1:99e1:b713:6999])
        by smtp.googlemail.com with ESMTPSA id y15sm5516493wrh.8.2021.04.15.12.47.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 12:47:53 -0700 (PDT)
Subject: Re: [PATCH net-next] r8169: keep pause settings on interface down/up
 cycle
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <30b248d6-8078-75ed-b1ad-4b1b6f17fcd5@gmail.com>
Message-ID: <b581025f-4bd8-7c85-a3eb-e557046d1da2@gmail.com>
Date:   Thu, 15 Apr 2021 21:47:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <30b248d6-8078-75ed-b1ad-4b1b6f17fcd5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.04.2021 20:59, Heiner Kallweit wrote:
> Currently, if the user changes the pause settings, the default settings
> will be restored after an interface down/up cycle, and also when
> resuming from suspend. This doesn't seem to provide the best user
> experience. Change this to keep user settings, and just ensure that in
> jumbo mode pause is disabled. 
> Small drawback: When switching back mtu from jumbo to non-jumbo then
> pause remains disabled (but user can enable it using ethtool).
> I think that's a not too common scenario and acceptable.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 7d02bab1c..2c89cde7d 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -2388,11 +2388,13 @@ static void rtl_jumbo_config(struct rtl8169_private *tp)
>  		pcie_set_readrq(tp->pci_dev, readrq);
>  
>  	/* Chip doesn't support pause in jumbo mode */
> -	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> -			 tp->phydev->advertising, !jumbo);
> -	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> -			 tp->phydev->advertising, !jumbo);
> -	phy_start_aneg(tp->phydev);
> +	if (jumbo) {
> +		linkmode_clear_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> +				   tp->phydev->advertising);
> +		linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> +				   tp->phydev->advertising);
> +		phy_start_aneg(tp->phydev);
> +	}
>  }
>  
>  DECLARE_RTL_COND(rtl_chipcmd_cond)
> @@ -5107,6 +5109,8 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>  
>  	tp->phydev->mac_managed_pm = 1;
>  
> +	phy_support_asym_pause(tp->phydev);
> +
>  	/* PHY will be woken up in rtl_open() */
>  	phy_suspend(tp->phydev);
>  
> 

Just see, this patch will apply only once net is merged into net-next.
