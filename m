Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED3B09A290
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390227AbfHVWHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:07:03 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46465 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388129AbfHVWHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 18:07:02 -0400
Received: by mail-wr1-f67.google.com with SMTP id z1so6776405wru.13
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 15:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=12exksaaxq8SwryWcYXXbR0gxmFeY5aqEbv9tHxperk=;
        b=flZPKiXMSdjhiZc7EaxJrNR1OgJ3Oe4iJfRwAAs/biqLdT2WuY3fai732L+fSZgUMW
         E6yQA8XbGi2skums1CkPTLo7keywbL7KoSO1+GKBlc/8hgbSvXk0k80d3K35wpWi3OHJ
         SVmxfMDEnr8iozQ7MIsvDkGwd7RrshHna1SVW2w+ONv/SjyoQUNwqsp/uFXW0r9RcjqP
         oHEuhwL0x9QlUKRowXLR4wESQEnbuShbe5mvd+Dg7TKMQaODzrDRiKZVWN0VKuLW2mji
         94D2OLGsl33qn8G9lm012E5/ZQUrpJWP5b0SUWVmij8SFJvb0BX5n2qHOAO+1PQtRxaH
         RM6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=12exksaaxq8SwryWcYXXbR0gxmFeY5aqEbv9tHxperk=;
        b=ZcypGVW16d/2EUzIT4hF4djogwJFUJqp+z1eXZpGYV2fjnFP/ycKJdkvBQY0vUsL63
         kcEn2TELPbY3eiy6Ge6JTs10xw2opI2FapEEg9cpBfBauRdZEX2hbtQNzkr1EcPp/q7Z
         fvWLQPkyj4nI1cj8GpJtDSli+kHtIpG+/sQkFfWqlIsOHuFrnPGx4YVup2h9itTcNyE2
         TVK/uPQ4tqF7O6pp76BGsjTitLJHzZTa7cmYZGL6oESA26ub+eQ2Jy9S/khnLD1BHX6V
         hVwhSTUT5QCUpjVQzcMp9+Mk8ankFC6xwmRgSO0ySHtuH8WPajBSaHAG1B4JUSJx5HP0
         dvcw==
X-Gm-Message-State: APjAAAViSrH5n1wID7l+k0hPYfIBwOD5u9Lv4gr38j0AbN5c8cp1GBDh
        PCEgax32yt7WZcbowqJD/XA=
X-Google-Smtp-Source: APXvYqxsCf4gyN55qo8S2315SAVMshGsvMXvQwZU/DF/crQf81G9M/uiI7jUE1qLKAhOwY7+9xtYyA==
X-Received: by 2002:a5d:4111:: with SMTP id l17mr1091551wrp.59.1566511620680;
        Thu, 22 Aug 2019 15:07:00 -0700 (PDT)
Received: from [192.168.1.2] ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id r190sm1644061wmf.0.2019.08.22.15.06.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 15:07:00 -0700 (PDT)
Subject: Re: [PATCH net-next 2/6] net: dsa: do not skip -EOPNOTSUPP in
 dsa_port_vid_add
To:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch
References: <20190822201323.1292-1-vivien.didelot@gmail.com>
 <20190822201323.1292-3-vivien.didelot@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Message-ID: <f179fa10-3123-d055-1c67-0d24adf3cb08@gmail.com>
Date:   Fri, 23 Aug 2019 01:06:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822201323.1292-3-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vivien,

On 8/22/19 11:13 PM, Vivien Didelot wrote:
> Currently dsa_port_vid_add returns 0 if the switch returns -EOPNOTSUPP.
> 
> This function is used in the tag_8021q.c code to offload the PVID of
> ports, which would simply not work if .port_vlan_add is not supported
> by the underlying switch.
> 
> Do not skip -EOPNOTSUPP in dsa_port_vid_add but only when necessary,
> that is to say in dsa_slave_vlan_rx_add_vid.
> 

Do you know why Florian suppressed -EOPNOTSUPP in 061f6a505ac3 ("net: 
dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")?
I forced a return value of -EOPNOTSUPP here and when I create a VLAN 
sub-interface nothing breaks, it just says:
RTNETLINK answers: Operation not supported
which IMO is expected.

> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> ---
>   net/dsa/port.c  | 4 ++--
>   net/dsa/slave.c | 7 +++++--
>   2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index f75301456430..ef28df7ecbde 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -382,8 +382,8 @@ int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags)
>   
>   	trans.ph_prepare = true;
>   	err = dsa_port_vlan_add(dp, &vlan, &trans);
> -	if (err == -EOPNOTSUPP)
> -		return 0;
> +	if (err)
> +		return err;
>   
>   	trans.ph_prepare = false;
>   	return dsa_port_vlan_add(dp, &vlan, &trans);
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 33f41178afcc..9d61d9dbf001 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1082,8 +1082,11 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>   			return -EBUSY;
>   	}
>   
> -	/* This API only allows programming tagged, non-PVID VIDs */
> -	return dsa_port_vid_add(dp, vid, 0);
> +	ret = dsa_port_vid_add(dp, vid, 0);
> +	if (ret && ret != -EOPNOTSUPP)
> +		return ret;
> +
> +	return 0;
>   }
>   
>   static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
> 

Regards,
-Vladimir
