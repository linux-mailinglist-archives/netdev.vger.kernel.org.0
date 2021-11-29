Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3DF462546
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhK2Wh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbhK2WhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:37:00 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8D5C006844;
        Mon, 29 Nov 2021 14:12:04 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id y196so15852110wmc.3;
        Mon, 29 Nov 2021 14:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=ggbCWzRHc8v6BD4e49B0lyVFo6tInErcTUuCR8IjV80=;
        b=hWpgli47jqMDnyJk623WauGE9bqO788jiJdDGlZAOc484EC8hlSLA9yGY17rY6rb4a
         6zdwbupCg+gacOKN2btEvQk7acJ+iLrbBYBmny2Y54l+T99mzwwsZYKOzGT3+HWGU+bq
         iijJG6MiuHVHAJEX8EKL8eOsQkE2O19dRLiIMH25PX0bSOcui2SZiakU1qaH3YqmmMa4
         Da8B7iNGjZaaCAxRVYQzVTR2x90QGnYxnoarIOOllRtMlDaPvTyIV7pKnssuRwQkcgvE
         Z410i4hHYNPsVe0AuN1cm/94hgABuWi8gv9kRE4HVLSWeiy9m0WIN6MTzvnNUnOLQyr+
         58mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=ggbCWzRHc8v6BD4e49B0lyVFo6tInErcTUuCR8IjV80=;
        b=Y+QlNIIbRxOWvCvrFhz3i3wOHKLDeGK1kZsd/JVhq6nlufBHukUVTwneR7n9qBsx6Z
         WA/3LDxAii95vjJwvZOS1ixzRrzp07hxPeEsR+VcXb8v+eL8hzdHZXmDBBA3gMaEKShB
         NRhCLgqYMILFevZdLOexvZ1rkTtRRqwTkNUtrYLmGD/4sbvcevrG7O8siwI/Oy4s0qFo
         /7cUHKvtb1TZNxf3Os5vWyov+jGkwazYz2K1yMsFCsUIAKCCRpn2cn4luWYJ9O8AuLt/
         irRAeuNcNbVFkZsLFxaeWilnqkZ7/GJn8iPN9/ZOaHc727dTnGnbzAM6tpSFTiwPPLcg
         T9RQ==
X-Gm-Message-State: AOAM530jVrvc5Q+DMlYWq11UjalDp5HSA9yTgGTOOdhZZkmS+hOir7KN
        G2H5U0uAc5eOurQdXXQHngIc451wDi4=
X-Google-Smtp-Source: ABdhPJzH0E+uDDE2OFKb8jQki6IakYhnY290to4kPejALTQ3I4rGdRcaJx8l5NELh2FVGvU+c8456Q==
X-Received: by 2002:a05:600c:4c96:: with SMTP id g22mr768693wmp.46.1638223923144;
        Mon, 29 Nov 2021 14:12:03 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:d1cd:76c9:39c5:e078? (p200300ea8f1a0f00d1cd76c939c5e078.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:d1cd:76c9:39c5:e078])
        by smtp.googlemail.com with ESMTPSA id az4sm474590wmb.20.2021.11.29.14.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 14:12:02 -0800 (PST)
Message-ID: <223aeb87-0949-65f1-f119-4c55d58bc14a@gmail.com>
Date:   Mon, 29 Nov 2021 23:11:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Tianhao Chai <cth451@gmail.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>
References: <20211128023733.GA466664@cth-desktop-dorm.mad.wi.cth451.me>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] ethernet: aquantia: Try MAC address from device tree
In-Reply-To: <20211128023733.GA466664@cth-desktop-dorm.mad.wi.cth451.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.11.2021 03:37, Tianhao Chai wrote:
> Apple M1 Mac minis (2020) with 10GE NICs do not have MAC address in the
> card, but instead need to obtain MAC addresses from the device tree. In
> this case the hardware will report an invalid MAC.
> 
> Currently atlantic driver does not query the DT for MAC address and will
> randomly assign a MAC if the NIC doesn't have a permanent MAC burnt in.
> This patch causes the driver to perfer a valid MAC address from OF (if
> present) over HW self-reported MAC and only fall back to a random MAC
> address when neither of them is valid.
> 
> Signed-off-by: Tianhao Chai <cth451@gmail.com>
> ---
>  .../net/ethernet/aquantia/atlantic/aq_nic.c   | 28 ++++++++++++-------
>  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> index 1acf544afeb4..ae6c4a044390 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> @@ -316,18 +316,26 @@ int aq_nic_ndev_register(struct aq_nic_s *self)
>  	aq_macsec_init(self);
>  #endif
>  
> -	mutex_lock(&self->fwreq_mutex);
> -	err = self->aq_fw_ops->get_mac_permanent(self->aq_hw, addr);
> -	mutex_unlock(&self->fwreq_mutex);
> -	if (err)
> -		goto err_exit;
> +	if (eth_platform_get_mac_address(&self->pdev->dev, addr) == 0 &&
> +	    is_valid_ether_addr(addr)) {

Calling is_valid_ether_addr() shouldn't be needed here. of_get_mac_addr()
does this check already. If you should decide to keep this check:
Kernel doc of is_valid_ether_addr() states that argument must be
word-aligned. So you may need to add a __align(2) to the address char
array definition.

> +		// DT supplied a valid MAC address
> +		eth_hw_addr_set(self->ndev, addr);
> +	} else {
> +		// If DT has none or an invalid one, ask device for MAC address
> +		mutex_lock(&self->fwreq_mutex);
> +		err = self->aq_fw_ops->get_mac_permanent(self->aq_hw, addr);
> +		mutex_unlock(&self->fwreq_mutex);
>  
> -	eth_hw_addr_set(self->ndev, addr);
> +		if (err)
> +			goto err_exit;
>  
> -	if (!is_valid_ether_addr(self->ndev->dev_addr) ||
> -	    !aq_nic_is_valid_ether_addr(self->ndev->dev_addr)) {
> -		netdev_warn(self->ndev, "MAC is invalid, will use random.");
> -		eth_hw_addr_random(self->ndev);
> +		if (is_valid_ether_addr(addr) &&
> +		    aq_nic_is_valid_ether_addr(addr)) {
> +			eth_hw_addr_set(self->ndev, addr);
> +		} else {
> +			netdev_warn(self->ndev, "MAC is invalid, will use random.");
> +			eth_hw_addr_random(self->ndev);
> +		}
>  	}
>  
>  #if defined(AQ_CFG_MAC_ADDR_PERMANENT)
> 

