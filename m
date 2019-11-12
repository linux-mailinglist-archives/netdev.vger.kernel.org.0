Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1875F9C5B
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 22:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKLVeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 16:34:44 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43739 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbfKLVeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 16:34:44 -0500
Received: by mail-ed1-f66.google.com with SMTP id w6so16222541edx.10
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 13:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rQ1lcZ74X7Yel4vG/bYpfU6N3m1u+GWcmqE579oZL84=;
        b=E4TRu0Udg/k3T2np/kC7QOYIXlerjmKWxwX9izN94aIyyndPLUyXjsArkGn2D9WPwb
         SwAgYRlrW2Abd0JXHChBkhiKqO4b6Rim9wz3FarHnUKgzwQDdLEmjSYvuM0cmgONMVJE
         szCGdh/lhi6i8oSHgclpeMALlHXbDVAtRqB+ivW2FkNUXa/kRJDggmdaawl56TANC/M9
         X6J6PcfLDWiGTMCVJzFmJ9Ndz6YtIyHKyMkP8V5J/NgbNEFRodr11QEjIDZY1ObMcA4f
         0SV17p/Jf5YvW++z2HSOtQLk0xprfo47oiB8p8SBBnkarLV77X3cHg3jru+mAIguBCLA
         EOlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=rQ1lcZ74X7Yel4vG/bYpfU6N3m1u+GWcmqE579oZL84=;
        b=pFM38YIiUpMnpgjKDKm8bkCnu3TofF0fQL+Yq+HjXk7NmKvQKfGQtOJP4u1iSu1Rcj
         of+VwWZ0Pi7BZ4XzY0OqUSSlDUvrag8PzvvDrhO6mgNVA52axAsC/TNc1jgm7N8QjbuS
         SLzNM2JWPr/eMtnWjJVgopwy7/oF4+/ZYgr54Wqwh47gqBGn0H7yf6ZLEXf3Fq/YUXXK
         rnJalCQP1EOCSHIW43/mWuuewzmHY9Q0MFElaGbgBvzXCHYtQirIrolghAIPsuM4Qk31
         iysaG6kN2PI+wVDyRIwRyaXgecYYqKkTif4FSKIREegQnGTmOVWuLmIfJRHhhowvmTeY
         P/BQ==
X-Gm-Message-State: APjAAAUIdDTgoExNX0OeZQ88OC5RUbx9JaYQ+cu4psUIvBbg9rdQk6VP
        Aw+aie5pL5Uk73+khRKtx+Q=
X-Google-Smtp-Source: APXvYqwuhRZHa3ShTKjdhTijPG5KlM7o9xbnDa/PUPgbrfcGwYGvySO5cDGYmSNvoe/zfHDOKhi1Ew==
X-Received: by 2002:a17:906:a995:: with SMTP id jr21mr29113099ejb.77.1573594481841;
        Tue, 12 Nov 2019 13:34:41 -0800 (PST)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ay16sm1161ejb.33.2019.11.12.13.34.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 13:34:40 -0800 (PST)
Subject: Re: [PATCH net-next 07/12] net: mscc: ocelot: separate the
 implementation of switch reset
To:     Vladimir Oltean <olteanv@gmail.com>, jakub.kicinski@netronome.com,
        davem@davemloft.net, alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-8-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <36baf6e7-fcd0-5516-6213-38a49aeb43da@gmail.com>
Date:   Tue, 12 Nov 2019 13:34:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191112124420.6225-8-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/19 4:44 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The Felix switch has a different reset procedure, so a function pointer
> needs to be created and added to the ocelot_ops structure.
> 
> The reset procedure has been moved into ocelot_init.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.c       |  3 ++
>  drivers/net/ethernet/mscc/ocelot.h       |  1 +
>  drivers/net/ethernet/mscc/ocelot_board.c | 37 +++++++++++++++---------
>  3 files changed, 28 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 42da193a8240..0fe928026e61 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -2294,6 +2294,9 @@ int ocelot_init(struct ocelot *ocelot)
>  	ocelot_vlan_init(ocelot);
>  	ocelot_ace_init(ocelot);
>  
> +	if (ocelot->ops->reset)
> +		ocelot->ops->reset(ocelot);

We were not checking doing any error code checking, but arguably we know
should, any reason not to propagate the error code?
-- 
Florian
