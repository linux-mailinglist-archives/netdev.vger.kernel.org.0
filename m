Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D322193485
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 00:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgCYXWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 19:22:04 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34892 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727550AbgCYXWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 19:22:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id m3so5142986wmi.0
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 16:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ODMjVevO1SGnLu63HNSIFG4IEWcoW/7Vjo4xJnqw3Y4=;
        b=ID+iaMvV06CYo8n6iYFi/yS4F4AVYNlsnOIvkCjZwbJnE2n6UiPtFoEXCtTsmkZGqf
         WMW+1B82PvhLie76fx+Q5Tne0w5E3ZZMqGpBz0T5CDOqUy74QspnIUvGQVJqXEYEILoU
         O7rsz+xTNNNfl9rwHQi4zPNfF5FPghzaWNLqt6qOUKQQTlmsG7YaY8yGHmw2eA9ejVHZ
         S0moApXC2K0u4a8KpNPFSe9ETTmUDFZa1UXxqrtUdLmMgGt5TnTu3K3uK6crVhCOoXVo
         plN7XzkAIF+KURMXJ2IVu9u5PvVNI6JKINvc3xbC8Ul2craQHqZz5lEH/yloY8R1Pok3
         OogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ODMjVevO1SGnLu63HNSIFG4IEWcoW/7Vjo4xJnqw3Y4=;
        b=P59tZHHpRnV9szZAxJqEc9ZwyyW8wIfLE20SHbrUYrVkpbNT5Pif9ZpLEN/YVEArvb
         6k8oWXfR1QPk6pObL/NbkauwwgEXTlGlp7+Rx4tLxmxd3KYbWsoA0lscNp5jPEyywaDS
         he5LHSZlbQPbPjz9DQ02JZb0yj/8ynFsNq5Tv8jYfInz6Jpe8WeuBeXYkvnprQSnaClQ
         Ns8o/pEq896Fo7BzjO/yf30KBBEx29duwm5TOHyCxcW/kAz+naCsq1NGIQsM2cJSU+TS
         6SMhe4vKQwyiEVdhmmCz2+0k5bPhnGwvq/licpRVVErGGCsluFQttb5jN/fnxwwn4XbK
         BaMw==
X-Gm-Message-State: ANhLgQ0ANwHITBJhwp/caB4QRZ7ASaHLO6Ja7Kp6D681S4YW2WjbvlIU
        4YgFAXItefiilZPqkWkKdrL/U31Y
X-Google-Smtp-Source: ADFU+vs8qoBsUG8Bn1rGeSqPSJ8aXldk3m2D+mFn9SEz32bYUcdn0SzFaGx8S7ESpazoHLeOtB/kag==
X-Received: by 2002:a1c:7dc8:: with SMTP id y191mr5509346wmc.167.1585178521041;
        Wed, 25 Mar 2020 16:22:01 -0700 (PDT)
Received: from [10.230.1.220] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id d5sm799997wrh.40.2020.03.25.16.21.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 16:22:00 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 06/10] net: dsa: b53: Add MTU configuration
 support
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
References: <20200325152209.3428-1-olteanv@gmail.com>
 <20200325152209.3428-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <2b5e3b75-bf51-3341-824f-f47feb556f67@gmail.com>
Date:   Wed, 25 Mar 2020 16:21:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200325152209.3428-7-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/2020 8:22 AM, Vladimir Oltean wrote:
> From: Murali Krishna Policharla <murali.policharla@broadcom.com>
> 
> Add b53_change_mtu API to configure mtu settings in B53 switch. Enable
> jumbo frame support if configured mtu size is for jumbo frame. Also
> configure BCM583XX devices to send and receive jumbo frames when ports
> are configured with 10/100 Mbps speed.
> 
> Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

[snip]

> @@ -658,6 +659,14 @@ static void b53_enable_cpu_port(struct b53_device *dev, int port)
>  	b53_brcm_hdr_setup(dev->ds, port);
>  
>  	b53_br_egress_floods(dev->ds, port, true, true);
> +
> +	b53_read32(dev, B53_JUMBO_PAGE, dev->jumbo_pm_reg, &port_mask);
> +
> +	if (dev->chip_id == BCM583XX_DEVICE_ID)
> +		port_mask |= JPM_10_100_JUMBO_EN;
> +
> +	port_mask |= BIT(port);
> +	b53_write32(dev, B53_JUMBO_PAGE, dev->jumbo_pm_reg, port_mask);

This should eventually be brought into b53_set_jumbo() where we already
have existing logic to configure whether to accept jumbo frames and for
10/100M ports, too, not strictly necessary for now though:

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
