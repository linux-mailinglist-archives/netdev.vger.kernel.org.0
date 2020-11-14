Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645542B3043
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgKNTpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgKNTpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 14:45:41 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62900C0613D1;
        Sat, 14 Nov 2020 11:45:40 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w6so10160063pfu.1;
        Sat, 14 Nov 2020 11:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gOhlPq+aXu280SDw+2aJlPrBpvm5e0PpI7KG8FUCtKQ=;
        b=kYJudAnNxgTdSChhT1eguCvREmLdKJ2VRTbNWQkVUb89At/uKCVc+6EdM4O9AjXjtw
         HlkJMWHY7o3JHf/3g3dsX6DDmLXqmdQHxfRMAUHzliHPQrCcXdQIT1M9uIAJMhRRYuWQ
         ZHANz15J2uJE/lbtbFp/02sM8qr23nwCVyVZCdUru3YE6Vx/c/HauIot8roq6gDbmk16
         jbl3kNyreiep2e6qrdaOJPrZl5QAFAZf9n70SE5RmlBmyg18PCI7ycxxInSxOUzmUenF
         fbsNvwS6B631luhNb6hxz2N9PZuXYEkHJtRvNNNLOh3AH1BqMU+o2YrSmjTJFaaO3Emw
         vsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gOhlPq+aXu280SDw+2aJlPrBpvm5e0PpI7KG8FUCtKQ=;
        b=nS1TkfDkL/kisRvujwQWEtmb56W1WvogcC3Ux7NFJmWXoZJ9vW4gYT6bh3p+7vOWra
         wy4yG560OSdXwYlEbfd7yGruY5Q5yxAo9VcBT1GPtWkER5skYPjuWK/oQSFTSiQVS09Z
         WwNUaD5IPH8uLyZb5hRs0wD5ZUz+YoLvzBaH1DdFErsL/3oS90Yim/4grxflBWPKhkZG
         PIgsey0Oz1TqKA4yzruxWYDGxZltKdjBmxZGL+Ovqy2r9kRV8bL8ISvYbZn9EswnMJtQ
         jflAQBh/7hYtr+tjxH32XkzJEU2eha7juHPrWevQ27ZmFE6Yav3FQR/E+YvPspY+lHCA
         fk6g==
X-Gm-Message-State: AOAM530sWNrOdXHXKxRQ0ghixUnN0/RBX7Vs23P7wWATXWwtFjmm3ZDm
        SByURK3pSg2NT5UJ4s9zAgEgQfkZbU0=
X-Google-Smtp-Source: ABdhPJwhqWd1gJ3uTitv6zCjo69+umDeMfP6ebnUZbXN75bDuBokWInG6QU/aHm0xTuQsYpUe0L6OA==
X-Received: by 2002:aa7:9315:0:b029:18b:6372:d43e with SMTP id 21-20020aa793150000b029018b6372d43emr7350149pfj.2.1605383139464;
        Sat, 14 Nov 2020 11:45:39 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id j25sm13080815pfa.199.2020.11.14.11.45.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2020 11:45:38 -0800 (PST)
Subject: Re: [PATCH net] net: phy: smsc: add missed clk_disable_unprepare in
 smsc_phy_probe()
To:     Jakub Kicinski <kuba@kernel.org>,
        Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, m.felsch@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1605180239-1792-1-git-send-email-zhangchangzhong@huawei.com>
 <20201114112625.440b52f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fc03d4de-14d2-1b61-ac9b-40ea26e6fa9a@gmail.com>
Date:   Sat, 14 Nov 2020 11:45:35 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201114112625.440b52f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/14/2020 11:26 AM, Jakub Kicinski wrote:
> On Thu, 12 Nov 2020 19:23:59 +0800 Zhang Changzhong wrote:
>> Add the missing clk_disable_unprepare() before return from
>> smsc_phy_probe() in the error handling case.
>>
>> Fixes: bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in support")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
>> ---
>>  drivers/net/phy/smsc.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
>> index ec97669..0fc39ac 100644
>> --- a/drivers/net/phy/smsc.c
>> +++ b/drivers/net/phy/smsc.c
>> @@ -291,8 +291,10 @@ static int smsc_phy_probe(struct phy_device *phydev)
>>  		return ret;
>>  
>>  	ret = clk_set_rate(priv->refclk, 50 * 1000 * 1000);
>> -	if (ret)
>> +	if (ret) {
>> +		clk_disable_unprepare(priv->refclk);
>>  		return ret;
>> +	}
>>  
>>  	return 0;
>>  }
> 
> Applied, thanks!
> 
> The code right above looks highly questionable as well:
> 
>         priv->refclk = clk_get_optional(dev, NULL);
>         if (IS_ERR(priv->refclk))
>                 dev_err_probe(dev, PTR_ERR(priv->refclk), "Failed to request clock\n");
>  
>         ret = clk_prepare_enable(priv->refclk);
>         if (ret)
>                 return ret;
> 
> I don't think clk_prepare_enable() will be too happy to see an error
> pointer. This should probably be:
> 
>         priv->refclk = clk_get_optional(dev, NULL);
>         if (IS_ERR(priv->refclk))
>                 return dev_err_probe(dev, PTR_ERR(priv->refclk), 
> 				      "Failed to request clock\n");

Right, especially if EPROBE_DEFER must be returned because the clock
provider is not ready yet, we should have a chance to do that.
-- 
Florian
