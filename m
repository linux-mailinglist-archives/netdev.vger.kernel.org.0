Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 724BFB6D25
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 22:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389314AbfIRUAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 16:00:25 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38388 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387622AbfIRUAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 16:00:25 -0400
Received: by mail-wr1-f65.google.com with SMTP id l11so689350wrx.5;
        Wed, 18 Sep 2019 13:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TOU4ZuWvUzuxQNBU0z7noCr4TSQPsaqCOjm5rWDSQ8g=;
        b=uPvJw2mL4p5ugyLfGDeQxqJzC+rQSmiHWuVTRqGVDz9OzjdMEwE3yyXeg/F2wLAkn+
         4M3Ne7uijtBzWQFLDo7qY/cH4xRG5WEJFWERlnoa8Pym3uCs0rqkkAvOhL44sQQPb6xJ
         zaiFXCeo9GNGOQdYksFtiwRfczEP8mxrcyYSNc/7BKK1YuTxe1HGl6FSaVxDUG5gOtbS
         wbfHfeQPutIeuCfvqvXIox2ycWgV1a6OeM4gDT/tI5JIjq1v83c34vIQf6Vkfy87avhk
         p5RP0J3YFRKxAl6lirtU4mspl7ZuBo9xb7ig+aGEpUV15JnU5TszYKSWt2rRMbzzoymS
         /Siw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TOU4ZuWvUzuxQNBU0z7noCr4TSQPsaqCOjm5rWDSQ8g=;
        b=b8OMIF3g9mJVaZUVM0+zOUBmgPnUxxnXe9OKjq2Mk56/YYT1Ecc9cnURQDUYByQpIY
         8rmL1RRNa2c3WwgXFvZ/gTL9n0vahqQ6oJ/ZcX/Y9HOojvoFC0rUvG/WT+S7rCM0c/jJ
         JTpHFOQu3WUxqHMocIXhETyaca2pdeR010Y51uSTpQtaxSd8zNdsJb2mZ1Xi2k+3UtMM
         aFD6tqx7yiB/LjCjTVjCXtaO6zCMsB2bIr2H6hK12AiqKRjPZejJhJYGVhT2ManvsQYo
         rtX4a/HD50fFcdzI2Ez3Sfc+k9XBn618ONDXYoKC6yR7/zPmV4l6cb14MloTWycLndBT
         d7Gg==
X-Gm-Message-State: APjAAAVI29JVqvFX68oYE8RtTnCRLdgKXEdpaNO3IKSczp/DMbEZanbl
        rcbpHKbckkDNMkctjY11YunPoTKX
X-Google-Smtp-Source: APXvYqwSInRuFWaitMmA9bfwrjFHcX/wSggG+aJ9Nj2YP6nJKGsFOpLNmYYNOIwMWskIMs4pdby+fg==
X-Received: by 2002:a5d:4ac8:: with SMTP id y8mr4525515wrs.98.1568836822579;
        Wed, 18 Sep 2019 13:00:22 -0700 (PDT)
Received: from [192.168.1.2] ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id d193sm5352237wmd.0.2019.09.18.13.00.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 13:00:21 -0700 (PDT)
Subject: Re: [PATCH v2] net: dsa: sja1105: prevent leaking memory
To:     Navid Emamdoost <navid.emamdoost@gmail.com>, andrew@lunn.ch
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20190918172106.GN9591@lunn.ch>
 <20190918180439.12441-1-navid.emamdoost@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Message-ID: <8d6f6c54-1758-7d98-c9b5-5c16b171c885@gmail.com>
Date:   Wed, 18 Sep 2019 23:00:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190918180439.12441-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Navid,

Thanks for the patch.

On 9/18/19 9:04 PM, Navid Emamdoost wrote:
> In sja1105_static_config_upload, in two cases memory is leaked: when
> static_config_buf_prepare_for_upload fails and when sja1105_inhibit_tx
> fails. In both cases config_buf should be released.
> 
> Fixes: 8aa9ebccae876 (avoid leaking config_buf)
> Fixes: 1a4c69406cc1c (avoid leaking config_buf)
> 

You're not supposed to add a short description of the patch here, but 
rather the commit message of the patch you're fixing.
Add this to your ~/.gitconfig:

[pretty]
	fixes = Fixes: %h (\"%s\")

And then run:
git show --pretty=fixes 8aa9ebccae87621d997707e4f25e53fddd7e30e4

Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port 
L2 switch")

git show --pretty=fixes 1a4c69406cc1c3c42bb7391c8eb544e93fe9b320

Fixes: 1a4c69406cc1 ("net: dsa: sja1105: Prevent PHY jabbering during 
switch reset")

> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>   drivers/net/dsa/sja1105/sja1105_spi.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
> index 84dc603138cf..58dd37ecde17 100644
> --- a/drivers/net/dsa/sja1105/sja1105_spi.c
> +++ b/drivers/net/dsa/sja1105/sja1105_spi.c
> @@ -409,7 +409,8 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
>   	rc = static_config_buf_prepare_for_upload(priv, config_buf, buf_len);
>   	if (rc < 0) {
>   		dev_err(dev, "Invalid config, cannot upload\n");
> -		return -EINVAL;
> +		rc = -EINVAL;
> +		goto out;
>   	}
>   	/* Prevent PHY jabbering during switch reset by inhibiting
>   	 * Tx on all ports and waiting for current packet to drain.
> @@ -418,7 +419,8 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
>   	rc = sja1105_inhibit_tx(priv, port_bitmap, true);
>   	if (rc < 0) {
>   		dev_err(dev, "Failed to inhibit Tx on ports\n");
> -		return -ENXIO;
> +		rc = -ENXIO;
> +		goto out;
>   	}
>   	/* Wait for an eventual egress packet to finish transmission
>   	 * (reach IFG). It is guaranteed that a second one will not
> 

Regards,
-Vladimir
