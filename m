Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3118F44B279
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 19:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241545AbhKISLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 13:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbhKISLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 13:11:33 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76677C061764;
        Tue,  9 Nov 2021 10:08:47 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id r5so38593pls.1;
        Tue, 09 Nov 2021 10:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bCGwSmI8NTSILNGyHTY8bibfBV/DYZ+v1YjLw7ldJW8=;
        b=mYPuj6bgHH/UBiNs/5YKLiid1ATKXLZCXLyQJVKleNkGzn1QmapwDIeTulZ9qpO8+2
         tIir31gPIX+1agbgs7V+4wTlAm0GuT5fqsrcFfTaTCboHFrNAJGLuobDZn5GoS9Hj8y8
         Pp8Uv0SSUsLbE3utyAiTgCcyLq/PZD6CadLiHW8TnukPZhYsmYtGX/Wtlti7jv659+Er
         lSoTlDWQJx4a25eAOdBUwXe0wPZHB2IkDKqEH94y5OXxTeRyXrrr8XNhpOFFxbvdYl62
         ygRURSqKSLKPZ+AXPWAwJkYDQ6UexnpVEC+KMAe9ZMxvNhTp4M6uQSfWRUEXZCAn1Qy2
         MktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bCGwSmI8NTSILNGyHTY8bibfBV/DYZ+v1YjLw7ldJW8=;
        b=IHE4gy9tT4CscwkpEjpn5/llV18sR7m2wAlPZI5+YxcFz32weIywsALJF50Z4xl9Im
         90m0LbdMjGBi4Kdw4kuIioGvHpWXwRIyfB3LFFFemmjSLyYF5WVujJb2spyKKeRt8+uX
         EkzOiEVSgWv0SOuAsigTY4gsz0DOUPvvthkfqm+ck6cQDFlZdljZ8Hd0LSzbOxrMyAOC
         jzE82ySz52O1tyN8Hn5Or0RcDJg3h2JXrQplpCMjDuylFeC9U/IQjg+eUXgouISeH6Kx
         e2hBgkDZGXnjPXY+yHlZSVDqjpeLySgrzX6Ddw8lrH53/hXBvhWT643wZ0/jrZgsPHxS
         tXhw==
X-Gm-Message-State: AOAM5338qr+WztyAeqIiJjV7bowTPX6ZlDb08fSdd0ea0V5whfYYUxdr
        N9UOr8mclvfiLq6UF6Lq0xye+TEGnnI=
X-Google-Smtp-Source: ABdhPJywfUZyZh7Y26Fc8xCCp9t0+A7C28m7FGHm103B7OET73pgr/En7J0xUw5dWildoPOB+RHxbA==
X-Received: by 2002:a17:90b:4c88:: with SMTP id my8mr9141713pjb.132.1636481326756;
        Tue, 09 Nov 2021 10:08:46 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ep15sm3720434pjb.3.2021.11.09.10.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 10:08:46 -0800 (PST)
Subject: Re: [PATCH v2 4/7] net: dsa: b53: Add PHC clock support
To:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-5-martin.kaistra@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a546e219-607c-1705-e366-7281e1aeedde@gmail.com>
Date:   Tue, 9 Nov 2021 10:08:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211109095013.27829-5-martin.kaistra@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/21 1:50 AM, Martin Kaistra wrote:
> The BCM53128 switch has an internal clock, which can be used for
> timestamping. Add support for it.
> 
> The 32-bit free running clock counts nanoseconds. In order to account
> for the wrap-around at 999999999 (0x3B9AC9FF) while using the cycle
> counter infrastructure, we need to set a 30bit mask and use the
> overflow_point property.
> 
> Enable the Broadsync HD timestamping feature in b53_ptp_init() for PTPv2
> Ethertype (0x88f7).
> 
> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
> ---

[snip]

>  struct b53_mib_desc {
>  	u8 size;
> @@ -1131,12 +1132,24 @@ static int b53_setup(struct dsa_switch *ds)
>  			b53_disable_port(ds, port);
>  	}
>  
> +	if (dev->broadsync_hd) {
> +		ret = b53_ptp_init(dev);
> +		if (ret) {
> +			dev_err(ds->dev, "failed to initialize PTP\n");
> +			return ret;
> +		}

Can you fold the check for dev->broadsync_hd within b53_ptp_init() as
requested before? And likewise for b53_ptp_exit.
-- 
Florian
