Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88681E3204
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391841AbgEZWFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389342AbgEZWFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:05:42 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCB2C061A0F;
        Tue, 26 May 2020 15:05:40 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x6so8429631wrm.13;
        Tue, 26 May 2020 15:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9KSc55f/zkiCEVS0YtLw7wKXAVsTgDBRGuAGOZpkkGU=;
        b=qJ/PvOnS9qTvW0QehUpyUVY9+pDQvopsVf26UZV78f5KwsrtvcuJ3D3N+HVBWVgDiH
         mZCFbF+TPqK+u09TJRQftm5/NJOonS2Idy0tIh6MLvTQMbJYdAxn+WNKeLbwifwHnsBg
         +o0DIiDsdNWT4RytcIbcpWgYlIjEdSD4NRqONgDhOuPir8TjNVJembT+G7psOcphSie5
         qa/GLNNywbKOmg7cCpW6YnZ6ksgJvpMrsjfHJ3ZM3z9ALbp4IDjx4qtRB9d4qWuczv+/
         AIymEAqGXFVrEHOR6xW/VD5zmPKnrPNY+PkscxvtwB+9dgZKAOqxq35RtbFk/+LowbLx
         MbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9KSc55f/zkiCEVS0YtLw7wKXAVsTgDBRGuAGOZpkkGU=;
        b=PPlkFJhuZ/6mZGEuNUs8rE9UkLRMsRY+IPG594V+1v+oJCx3/xkztiOAfV2COV7xAi
         FakfqyBajRZuGaCvms/U9h/iNAUX3exoBo/aCqSHEphgOuDjMY3JW7eu00apnn0grqoX
         hMk+1EcgX7QX/pVVBnfkPkt8cgjeXnxgNCUO2nH1FPybn6zRf3woL6RR2MxBuEuXS8bq
         4cEvjRZ1j7CP7AqQ8CLLdJlQSjmx/H6NdWVnK5r5J4tr9bjy6CyV296bRCMKbwQnCIBc
         jEyMF8pGqPvOOH9j05O8VmUVPp7Zoj61ufVpFW8av1C6N8ZKYyfRWlyv9RJpEEOHqFtR
         plPA==
X-Gm-Message-State: AOAM530gcBs/xJM41RYfJT8/8Xhoq/occhII47BmaLMXwuJQC+DTfYQV
        XCScR7voPJVratb14eJ5aXo=
X-Google-Smtp-Source: ABdhPJz4wbdZAiHmbuZI13yEtvo5FAdcoeZV8lk8028gBC5cWy9sGC0/qxTrnXIybfN2cJzrkNEgFQ==
X-Received: by 2002:a5d:68c2:: with SMTP id p2mr12364499wrw.253.1590530739087;
        Tue, 26 May 2020 15:05:39 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id g18sm743554wme.17.2020.05.26.15.05.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 15:05:38 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] net: phy: mscc-miim: read poll when high
 resolution timers are disabled
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@bootlin.com,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
References: <20200526162256.466885-1-antoine.tenart@bootlin.com>
 <20200526162256.466885-5-antoine.tenart@bootlin.com>
 <e95bbdb6-a6db-be02-660e-7318b9bb5f01@gmail.com>
 <20200526220127.GS768009@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7c969bd9-e9d9-3768-a258-527257cf1a5f@gmail.com>
Date:   Tue, 26 May 2020 15:05:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200526220127.GS768009@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/26/2020 3:01 PM, Andrew Lunn wrote:
>>> +/* When high resolution timers aren't built-in: we can't use usleep_range() as
>>> + * we would sleep way too long. Use udelay() instead.
>>> + */
>>> +#define mscc_readl_poll_timeout(addr, val, cond, delay_us, timeout_us)	\
>>> +({									\
>>> +	if (!IS_ENABLED(CONFIG_HIGH_RES_TIMERS))			\
>>> +		readl_poll_timeout_atomic(addr, val, cond, delay_us,	\
>>> +					  timeout_us);			\
>>> +	readl_poll_timeout(addr, val, cond, delay_us, timeout_us);	\
>>> +})
>>> +
>>
>> I would make this a regular function which would not harm the compiler's
>> ability to optimize it, but would give you type checking. With that fixed:
> 
> Hi Florian
> 
> cond makes that difficult, since it is not a parameter in the usual
> sense, but an expression to evaluate if the polling should terminate.
> 
> readl_poll_timeout() and readl_poll_timeout_atomic() themselves are
> #define's, and there are more levels of macros under them.

Oh that's right, thanks for reminding me of this.
-- 
Florian
