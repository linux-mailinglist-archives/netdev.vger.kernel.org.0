Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFDB8165A97
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 10:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgBTJ4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 04:56:05 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37223 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgBTJ4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 04:56:04 -0500
Received: by mail-lj1-f195.google.com with SMTP id q23so3556183ljm.4
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 01:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hwUhPhC4RpZpfTtdspVXKutFKnZ75WnhC0reQTankUA=;
        b=W+NuKxSZW0cT25/urMTcvjVCSvNr9s2RhKHyyExN9BwMEFbq2sBJ+dQGx2eDfkd9ca
         z71xxBWhY5wjlOkM13Xw6zlZP9I0onkJ7a9U6nF1Kv/UAmMaua5jq00iWoMC9KHjkqyl
         UWHRcZInylDNh3g68rk8ajQre5Tmgk3o1QKii4356pMJ4Me3lUsF5z1DiO5X/0GGISfV
         kLGt5ZN/wR+IrYWMlOwlndgpKQxz2G/5DvLBbMMaWblLEJJGZYHt4xchWfjswXDBY3n0
         4UWMqHQIz7mY2mIQM4MFbFxom56/JlyTeSskIXIFzLDkNgD5PhsBA5DNOTVe2TdltPFT
         Bv6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hwUhPhC4RpZpfTtdspVXKutFKnZ75WnhC0reQTankUA=;
        b=CfzecoGwqUsiIXRdKqROU5+1RCCm209Fgyd467IYnAcshXlw+jago9/kcDkqagDw57
         5PsX4aI/lYTS31k3PEqUTQk5AqhhM2A4hGr+ubW6mrUf+3JdexagjJfQg0dS8UCoCk8W
         n3kSOynGLEF/HXioHtKc2B0YG0dJ5yXWgYMnAhyyj1rMTGzH+f3Gfr/X/L8v161EZ/Mu
         cY2+btNxWitVfLo5PkMHYcuFoGi3HQRg9Zfs26D+UsqCBdoP+pDNFicBIncaEDRhV+KT
         0qG5voqTgcV2s6CUya2uJa+5sLmUxPKdy6wCjxzYGqJQxcdXwpUiv8EIF8IgzhfGBDJh
         uIXA==
X-Gm-Message-State: APjAAAVZg6MBYTF2WHue5ajufjU+jep5tBSSebkTDqZfZFWn8moXdVB9
        N8DwN3BiyUtismvCYqo6tYx5BA==
X-Google-Smtp-Source: APXvYqyUnv0XX9gKCnXdzTRv06Mvj3BRA06DKpNgI2zGDP3Q3viWd7A9W+Mmdo9wDc/cLSsFNGTnyw==
X-Received: by 2002:a2e:2407:: with SMTP id k7mr17261188ljk.275.1582192562882;
        Thu, 20 Feb 2020 01:56:02 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:488a:2e65:54d8:5bdd:7837:cba1? ([2a00:1fa0:488a:2e65:54d8:5bdd:7837:cba1])
        by smtp.gmail.com with ESMTPSA id e12sm1531298lfc.70.2020.02.20.01.56.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 01:56:02 -0800 (PST)
Subject: Re: [net-next 06/13] ice: Report correct DCB mode
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     Avinash Dayanand <avinash.dayanand@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Scott Register <scottx.register@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
References: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
 <20200219220652.2255171-7-jeffrey.t.kirsher@intel.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <6e0c7231-9fbb-e7ac-61e4-ba4e774a7692@cogentembedded.com>
Date:   Thu, 20 Feb 2020 12:55:37 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200219220652.2255171-7-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.02.2020 1:06, Jeff Kirsher wrote:

> From: Avinash Dayanand <avinash.dayanand@intel.com>
> 
> Add code to detect if DCB is in IEEE or CEE mode. Without this the code
> will always report as IEEE mode which is incorrect and confuses the
> user.
> 
> Signed-off-by: Avinash Dayanand <avinash.dayanand@intel.com>
> Signed-off-by: Scott Register <scottx.register@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>   drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 27 +++++++++++++++++---
>   1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
> index 1c118e7bab88..16656b6c3d09 100644
> --- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
> @@ -62,6 +62,26 @@ u8 ice_dcb_get_ena_tc(struct ice_dcbx_cfg *dcbcfg)
>   	return ena_tc;
>   }
>   
> +/**
> + * ice_dcb_get_mode - gets the DCB mode
> + * @port_info: pointer to port info structure
> + * @host: if set it's HOST if not it's MANAGED
> + */
> +static u8 ice_dcb_get_mode(struct ice_port_info *port_info, bool host)
> +{
> +	u8 mode;
> +
> +	if (host)
> +		mode = DCB_CAP_DCBX_HOST;
> +	else
> +		mode = DCB_CAP_DCBX_LLD_MANAGED;
> +
> +	if (port_info->local_dcbx_cfg.dcbx_mode & ICE_DCBX_MODE_CEE)
> +		return (mode | DCB_CAP_DCBX_VER_CEE);
> +	else
> +		return (mode | DCB_CAP_DCBX_VER_IEEE);

    () not really needed here and above.

[...]

MBR, Sergei
