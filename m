Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36AC647640
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 20:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiLHTee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 14:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiLHTec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 14:34:32 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DE360B7D;
        Thu,  8 Dec 2022 11:34:31 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id qk9so6444389ejc.3;
        Thu, 08 Dec 2022 11:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zIO5FG/r/4I/z0X8YNuFgMDKfSU/mISNLc50dzuiArA=;
        b=hLrVCUSvrR8TjTHoSRkGEibewh2JCbt++pw579y3eEaD29EIDeXzswKctm+rEsTp4b
         gIomTjLYHsxKEYbmOcCqfKvVAX/SPn6qb3hMJydpbTkdOGK/vCJhndOATDPVNmZ96cyG
         Sn3JIzrk9txLYiU//NX6yCAAGTghWatHwhewYaxX7Jg/KURwCX0MDDTAprF9matXFxeP
         RWUV4R8l6UWXz5drDgf6liBhiBR48QqbFcxxvFPgTxErjPRCNbGeLRt77nCSKkOU68CZ
         ESTIFFviazfA8e0O6/gQ4fGEDpVvQ+UEmTk8R/VSsL7y0eMStWGaOQyBPK9doHoJfply
         kPhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zIO5FG/r/4I/z0X8YNuFgMDKfSU/mISNLc50dzuiArA=;
        b=ZYxFmfAWelccaZB1nRaFVv2Q26VDgzNKNM31owo2QEgbjVl9piMuoH7l+fvNACOrse
         ud/NmebBwFmpZ3cdHaNLJqxslCxLcl6AeCK5ju/PI3SStwGB8pU9/LmwO43J1JxNbzsX
         LppvIv6MoLFfryQ7wNWDgG126gIIV2A7Pt7ekyDDjdP2xOP9tmjhbXD8gSsSWoiwx+TX
         JQlqM4drBrFiAUkqTdw3xWZVCIPUyLcATH52vyxowj1/tB4IPhrVTa+h3eEA/Ig6Y4Kv
         pX4jk5omNi4IbiAMu+NA0Ab8Kfqvfj6AwNJTHlZCxH2kIvZjewxiS4GK+LH7yIUGAik+
         Z9NQ==
X-Gm-Message-State: ANoB5pmKjGHcUWCYIqEPsopZ3UbwHm11bcXeDMsi8p+ky+WvxRD1wxmY
        Is7Ec3kB01rcsfQRbrc2lkA=
X-Google-Smtp-Source: AA0mqf5AMNVPEc1Ctp+Zy9vb6VVuF84bBHFV7vPh/rKO3D3p0WK4bWrhEfqqT5umd2UfPENfignNZw==
X-Received: by 2002:a17:906:8610:b0:7c0:f5d7:cac7 with SMTP id o16-20020a170906861000b007c0f5d7cac7mr3197350ejx.67.1670528070036;
        Thu, 08 Dec 2022 11:34:30 -0800 (PST)
Received: from skbuf ([188.26.185.87])
        by smtp.gmail.com with ESMTPSA id kw26-20020a170907771a00b00783f32d7eaesm9965267ejc.164.2022.12.08.11.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 11:34:29 -0800 (PST)
Date:   Thu, 8 Dec 2022 21:34:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next] lan9303: Fix read error execution path
Message-ID: <20221208193427.337eh2coo5rpp4gq@skbuf>
References: <20221208193005.12434-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208193005.12434-1-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Is it deliberate that you are targeting the "net-next" tree for new
features rather than "net" for bug fixes?

On Thu, Dec 08, 2022 at 01:30:05PM -0600, Jerry Ray wrote:
> This patch fixes an issue where a read failure of a port statistic counter
> will return unknown results.  While it is highly unlikely the read will
> ever fail, it is much cleaner to return a zero for the stat count.
> 
> Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
> 

There shouldn't be blank lines between the tags of a commit, see "git log"
for examples.

Not a reason in itself to resend, AFAIK.

> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> ---
>  drivers/net/dsa/lan9303-core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
> index 80f07bd20593..2e270b479143 100644
> --- a/drivers/net/dsa/lan9303-core.c
> +++ b/drivers/net/dsa/lan9303-core.c
> @@ -1005,9 +1005,11 @@ static void lan9303_get_ethtool_stats(struct dsa_switch *ds, int port,
>  		ret = lan9303_read_switch_port(
>  			chip, port, lan9303_mib[u].offset, &reg);
>  
> -		if (ret)
> +		if (ret) {
>  			dev_warn(chip->dev, "Reading status port %d reg %u failed\n",
>  				 port, lan9303_mib[u].offset);
> +			reg = 0;
> +		}
>  		data[u] = reg;
>  	}
>  }
> -- 
> 2.17.1
> 
