Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179F0306AA3
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhA1BpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbhA1BoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:44:21 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796EDC061756
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:43:41 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id j2so1571877pgl.0
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ohvs54RmZFjOxO5CeX05N9pQItRr21PcfXql6Lf1skw=;
        b=R2UKK/MkPB6791/nNJ00oop0NGyWHmlqcPlOIALN8+jSqgzGTfhUCduVNxvlxxFUjL
         H/WB+WgYx2V6y1KI8u3B9cdWYP5Kp0eX+AkyhXwxSl2Q5v0grOvS4QMPs4BIIwj0v20x
         diQHmgoUeqMvbZYSWVlnXGHsaGhBpz+VmVVqnwvSWGWxvmXd/nybFv8LvBDLx6mzl5L2
         sDVFKK2aywbchUl7gofABtZXCuLuzcinFjSoR1JHh/RdrisGfistQZh2oYLxlD2xHWaj
         6Lga7wewVajL1XU7pXxkDXE6yP4Ay86Ib3eWwiDypBJABwl5AKS146Dr0Z2aW6wRHHOT
         BnKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ohvs54RmZFjOxO5CeX05N9pQItRr21PcfXql6Lf1skw=;
        b=iXnAdn+2eIt2sHiktZdmgdq5PGx64kpXGi2FW1WAVk0AL44qzZ8unFbs7HHAd8VF6M
         c/tQ8RlSSUki3nJnnhDaVoKoWmYpL24SxR3x3Nnw2TjpCbR8Y+iB0nLhiokb8rj/durO
         FjSYSfxlbCpLTj2funqep8OXhUh1q74w8rpk45CBXcG/u7QVEmQoxh7c4xnn28QmCzkv
         TC9OPHuAiQXPD9/uFsE1yI06G6zKL1nvJYOLrHrtJAH15KBpps9C9HSyveLmc6nkE+Z4
         QymklcA/SqooCYRSl3B91XknXvdCWPhylgZWiyKDdenQ7mWziYqjwnIVKS1dSq8bWRUy
         ZhMA==
X-Gm-Message-State: AOAM5322zBONzXOJR8JusDGxc0ac2ib4DEB+8BGINC32MnOn7R9/Q2ym
        BIWigSiC0ZZNWSxfK5nSoSI=
X-Google-Smtp-Source: ABdhPJxfs61EcLePi6J+tnhHKSR1AQkBkJI3/xk1lw9fReka5gioBu0LdbTbzifgkFN5bQIgwgdoRw==
X-Received: by 2002:a63:e20b:: with SMTP id q11mr14282834pgh.396.1611798221066;
        Wed, 27 Jan 2021 17:43:41 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y12sm3697568pfp.166.2021.01.27.17.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 17:43:40 -0800 (PST)
Subject: Re: [PATCH net-next 2/4] net: dsa: automatically bring user ports
 down when master goes down
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20210127010028.1619443-1-olteanv@gmail.com>
 <20210127010028.1619443-3-olteanv@gmail.com> <YBIJZuy6iXeNQpxm@lunn.ch>
 <20210128005014.z6bteom6qkmopzf4@skbuf> <YBIKuNW2H2ygODxP@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9a13adce-ed2b-5365-c269-a643e2c49d3c@gmail.com>
Date:   Wed, 27 Jan 2021 17:43:38 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YBIKuNW2H2ygODxP@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2021 4:52 PM, Andrew Lunn wrote:
> On Thu, Jan 28, 2021 at 02:50:14AM +0200, Vladimir Oltean wrote:
>> On Thu, Jan 28, 2021 at 01:46:30AM +0100, Andrew Lunn wrote:
>>>> +	case NETDEV_GOING_DOWN: {
>>>> +		struct dsa_port *dp, *cpu_dp;
>>>> +		struct dsa_switch_tree *dst;
>>>> +		int err = 0;
>>>> +
>>>> +		if (!netdev_uses_dsa(dev))
>>>> +			return NOTIFY_DONE;
>>>> +
>>>> +		cpu_dp = dev->dsa_ptr;
>>>> +		dst = cpu_dp->ds->dst;
>>>> +
>>>> +		list_for_each_entry(dp, &dst->ports, list) {
>>>> +			if (!dsa_is_user_port(dp->ds, dp->index)) {
>>>
>>> !dsa_is_user_port() ??
>>>
>>> That ! seems odd.
>>
>> Oops, that's something that I refactored at the last minute after I
>> prototyped the idea from:
>> 			if (!dsa_is_user_port(dp->ds, dp->index))
>> 				continue;
>> because it looked uglier that way.
> 
> I was guessing it would be something like that. With that fixed:
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

When you fix it:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
