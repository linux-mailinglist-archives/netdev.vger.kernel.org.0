Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA9A291431
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 21:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439621AbgJQTtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 15:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439613AbgJQTto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 15:49:44 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FADC061755;
        Sat, 17 Oct 2020 12:49:28 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id a28so1682153ljn.3;
        Sat, 17 Oct 2020 12:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BAlmrGVj9wF13S7ppPspWcU+ZJ0NozHnpDbdtnO2YJA=;
        b=Zcrld+DrlwySaOYgwlurVdgb1dEdVXr/mE+EHK/Ld8E06lVYeEtOMO0k+QarLcGI99
         aqj6egQ/Xjg29QUh1a0X92CXNBRo5PrHPm+ywXHEDJLUQDTh4vxYpU8UeHeNKAzm25ZU
         VWVbBaRV/6YT2JDQm4AYPynYuEhs9xDqa5nPurTCyN+pLKB7+ZV+M/4p9atF2v9eDhku
         NO4zaEqX7MoQ5A0Gwa3i8wQltKa5t8IUMa8ueKehL9psKasgpm8nQ4vLPG0oZoI06FZg
         v1fYsoRtJA/NSA54i8Ei1oiayzsPK6Yvw70/X/0c32GXgR+dIfeNYt8saz0jb8GxN9Z0
         0XYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BAlmrGVj9wF13S7ppPspWcU+ZJ0NozHnpDbdtnO2YJA=;
        b=qzuPanAMZ9Rg5gXevnCBY0RUannqmOkQVaRgjf86BFKM/oUlAfNzDmEVwfP9zdXitx
         gUjAwa/mJgALuJbxidr/dHh46B2KXOblvsGdFSgXOpuuHpBz7wsp/ra5xG51ZEJEsyPt
         Et/dEAS14wxXCp+RllW3kWRYICVevTvI4jj1Wvy1P5rJbiDWZxtUmGa5jVLEHv7nUeEk
         A6OCN3i75uh29zFYx12SrrWaqT2QWsLh3CNoskxQlYRp1Gw4xkYlU6nyM/W3EHt8oGI3
         xPyLJwgbfOZnEOXXfP+iccugCeAONsOMwrzD8OLY6em/SHzUU4rub3EpC89tJNAuSLlx
         sHFA==
X-Gm-Message-State: AOAM533pKQFmQej8QRnTIAmnuzHzlEeq6ItvKcG+rPL5l5QfJWRLpVWt
        O7rLuhF1I4f+uYRHZHYZesY=
X-Google-Smtp-Source: ABdhPJwY+HhJaGGSWQaVZwh6RK+t9vQHZe+ZaI9x04lBF828T1ZaCFDvHuUWw7hd/VPfHHZVJp2FBw==
X-Received: by 2002:a2e:9782:: with SMTP id y2mr4021100lji.110.1602964165239;
        Sat, 17 Oct 2020 12:49:25 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:44ab:aa29:cc3a:7ce3:762e:af0? ([2a00:1fa0:44ab:aa29:cc3a:7ce3:762e:af0])
        by smtp.gmail.com with ESMTPSA id u24sm2229286lfg.21.2020.10.17.12.49.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2020 12:49:24 -0700 (PDT)
Subject: Re: [PATCH net] ravb: Fix bit fields checking in ravb_hwtstamp_get()
To:     Andrew Gabbasov <andrew_gabbasov@mentor.com>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, geert+renesas@glider.be,
        Julia Lawall <julia.lawall@inria.fr>,
        "Behme, Dirk - Bosch" <dirk.behme@de.bosch.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>
References: <20200930192124.25060-1-andrew_gabbasov@mentor.com>
 <000001d697c2$71651d70$542f5850$@mentor.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <2819a14d-500c-561b-337e-417201eb040f@gmail.com>
Date:   Sat, 17 Oct 2020 22:49:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <000001d697c2$71651d70$542f5850$@mentor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 10/1/20 10:13 AM, Andrew Gabbasov wrote:

   The patch was set to the "Changes Requested" state -- most probably because of this
mail. Though unintentionally, it served to throttle actions on this patch. I did only
remember about this patch yesterday... :-)

[...]
>> In the function ravb_hwtstamp_get() in ravb_main.c with the existing
> values
>> for RAVB_RXTSTAMP_TYPE_V2_L2_EVENT (0x2) and RAVB_RXTSTAMP_TYPE_ALL
>> (0x6)
>>
>> if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_V2_L2_EVENT)
>> 	config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
>> else if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_ALL)
>> 	config.rx_filter = HWTSTAMP_FILTER_ALL;
>>
>> if the test on RAVB_RXTSTAMP_TYPE_ALL should be true, it will never be
>> reached.
>>
>> This issue can be verified with 'hwtstamp_config' testing program
>> (tools/testing/selftests/net/hwtstamp_config.c). Setting filter type to
> ALL
>> and subsequent retrieving it gives incorrect value:
>>
>> $ hwtstamp_config eth0 OFF ALL
>> flags = 0
>> tx_type = OFF
>> rx_filter = ALL
>> $ hwtstamp_config eth0
>> flags = 0
>> tx_type = OFF
>> rx_filter = PTP_V2_L2_EVENT
>>
>> Correct this by converting if-else's to switch.
> 
> Earlier you proposed to fix this issue by changing the value
> of RAVB_RXTSTAMP_TYPE_ALL constant to 0x4.
> Unfortunately, simple changing of the constant value will not
> be enough, since the code in ravb_rx() (actually determining
> if timestamp is needed)
> 
> u32 get_ts = priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE;
> [...]
> get_ts &= (q == RAVB_NC) ?
>                 RAVB_RXTSTAMP_TYPE_V2_L2_EVENT :
>                 ~RAVB_RXTSTAMP_TYPE_V2_L2_EVENT;
> 
> will work incorrectly and will need to be fixed too, making this
> piece of code more complicated.
> 
> So, it's probably easier and safer to keep the constant value and
> the code in ravb_rx() intact, and just fix the get ioctl code,
> where the issue is actually located.

   We have one more issue with the current driver: bit 2 of priv->tstamp_rx_ctrl
can only be set as a part of the ALL mask, not individually. I'm now thinking we
should set RAVB_RXTSTAMP_TYPE[_ALL] to 2 (and probably just drop the ALL mask)...

[...]

>> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
>> Reported-by: Julia Lawall <julia.lawall@inria.fr>
>> Signed-off-by: Andrew Gabbasov <andrew_gabbasov@mentor.com>
>> ---
>>  drivers/net/ethernet/renesas/ravb_main.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
>> b/drivers/net/ethernet/renesas/ravb_main.c
>> index df89d09b253e..c0610b2d3b14 100644
>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>> @@ -1802,12 +1802,16 @@ static int ravb_hwtstamp_get(struct net_device
>> *ndev, struct ifreq *req)
>>  	config.flags = 0;
>>  	config.tx_type = priv->tstamp_tx_ctrl ? HWTSTAMP_TX_ON :
>>  						HWTSTAMP_TX_OFF;
>> -	if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_V2_L2_EVENT)
>> +	switch (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE) {
>> +	case RAVB_RXTSTAMP_TYPE_V2_L2_EVENT:
>>  		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
>> -	else if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_ALL)
>> +		break;
>> +	case RAVB_RXTSTAMP_TYPE_ALL:
>>  		config.rx_filter = HWTSTAMP_FILTER_ALL;
>> -	else
>> +		break;
>> +	default:
>>  		config.rx_filter = HWTSTAMP_FILTER_NONE;

   Yeah, that's better. But do we really need am anonymous bit 2 that can't be
toggled other than via passing the ALL mask?

[...]

MBR, Sergei
