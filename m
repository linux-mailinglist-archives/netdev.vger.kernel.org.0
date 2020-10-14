Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5EE28E61D
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 20:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387772AbgJNSOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 14:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387507AbgJNSOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 14:14:25 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179F9C061755
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 11:14:25 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id p3so180832pjd.0
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 11:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=kfEv4awu8atL/IHfwBZVeJrgE2FzagYW1xzPmuwt4qQ=;
        b=ckMvx9f5EmMdghDDYDwX6P/p/F1NS5riGHkaDbkDdvP1VEfAk52gCyy4EWCOmfOmMZ
         QfFVL/Ee33cl7/qru6cqo4S7fdLsXiRFTAY3HCwl9nQXlECaoC88nHWgKD3P48HytQLh
         EfPLuR9Zj4IS1rIBuAeXYf53jkQX1OZZ4XGddSs+2NpQ4jck5fEF6kelE/h1ncu+ageR
         XEOdkCU4UB55MhsKfaqEChgpyDuhVSSq1mHYcO7eKaiBYIEAgrspmk3L5L79GBoZRWHd
         H4ODs0+1fHN9Pm+ie6jf3qWoj5hFVT8e4t6BIqpCYYo7nhgHjex05zN6RijTSFD7ku/F
         RJJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=kfEv4awu8atL/IHfwBZVeJrgE2FzagYW1xzPmuwt4qQ=;
        b=Tgd9ZGAyLn/JDuiSDIhNFuXClW/hv/Iu/6BdCY2rThLb6fjogEmn+bMZxXWY3xSGak
         SgiU0RkD9pH0mLeAHR/7HSd2xS4mqhie1v+oM8oi1j06jgU19dN5qGJ6T7gpZh4WVLYO
         5Hk/5Zapi8Y2690L207Jrgv8QjmIqytasTnvL3BsEj7m2lfCf5JazvsSEAmHEcwNsCfe
         8MuTNtJFzVwWpenwRXtFEnUk8o/hiruAlrBgeUxoO+29scZCmUJL0aC/o4yvG4WZSEL2
         EZIFdOb+aYd2fdusEis1p1wUSBIHA9F0eke5ObYlJjOdfZt6Y2n05v65Y1gu2jPieOuJ
         S5bA==
X-Gm-Message-State: AOAM5304sq2mOZqt2typ72qEkAo/ANE5Dj+JHbXlBYRxa96ZqR1UV47y
        CK6Y6m/RbSH7M7Gh/5ytyZXZEA==
X-Google-Smtp-Source: ABdhPJytr0VF52B1YB5qdg+xOstSEndwbEPCKFwMbHBIKSdoz6mr52meI9PWdRlUJ6pu/A4wtWPBxw==
X-Received: by 2002:a17:90a:5285:: with SMTP id w5mr459182pjh.62.1602699264560;
        Wed, 14 Oct 2020 11:14:24 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id q123sm291252pfq.56.2020.10.14.11.14.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 11:14:23 -0700 (PDT)
Subject: Re: [PATCH] ixgbe: fail to create xfrm offload of IPsec tunnel mode
 SA
To:     Antony Antony <antony@phenome.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Shannon Nelson <shannon.nelson@oracle.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
References: <20200828111101.GA16518@AntonyAntony.local>
 <20201014141748.GA4910@AntonyAntony.local>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <9ca1d11f-5dfa-1be1-6ced-b046dddd5d00@pensando.io>
Date:   Wed, 14 Oct 2020 11:14:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201014141748.GA4910@AntonyAntony.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/20 7:17 AM, Antony Antony wrote:
> Based on talks and indirect references ixgbe IPsec offlod do not
> support IPsec tunnel mode offload. It can only support IPsec transport
> mode offload. Now explicitly fail when creating non transport mode SA
>   with offload to avoid false performance expectations.
>
> Fixes: 63a67fe229ea ("ixgbe: add ipsec offload add and remove SA")
> Signed-off-by: Antony Antony <antony@phenome.org>

Acked-by: Shannon Nelson <snelson@pensando.io>

> ---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 5 +++++
>   drivers/net/ethernet/intel/ixgbevf/ipsec.c     | 5 +++++
>   2 files changed, 10 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> index eca73526ac86..54d47265a7ac 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> @@ -575,6 +575,11 @@ static int ixgbe_ipsec_add_sa(struct xfrm_state *xs)
>   		return -EINVAL;
>   	}
>   
> +	if (xs->props.mode != XFRM_MODE_TRANSPORT) {
> +		netdev_err(dev, "Unsupported mode for ipsec offload\n");
> +		return -EINVAL;
> +	}
> +
>   	if (ixgbe_ipsec_check_mgmt_ip(xs)) {
>   		netdev_err(dev, "IPsec IP addr clash with mgmt filters\n");
>   		return -EINVAL;
> diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.c b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
> index 5170dd9d8705..caaea2c920a6 100644
> --- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
> +++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
> @@ -272,6 +272,11 @@ static int ixgbevf_ipsec_add_sa(struct xfrm_state *xs)
>   		return -EINVAL;
>   	}
>   
> +	if (xs->props.mode != XFRM_MODE_TRANSPORT) {
> +		netdev_err(dev, "Unsupported mode for ipsec offload\n");
> +		return -EINVAL;
> +	}
> +
>   	if (xs->xso.flags & XFRM_OFFLOAD_INBOUND) {
>   		struct rx_sa rsa;
>   

