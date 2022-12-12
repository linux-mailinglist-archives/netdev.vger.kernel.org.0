Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7FA64A75C
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbiLLSpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbiLLSop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:44:45 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2938860F9;
        Mon, 12 Dec 2022 10:43:09 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id n20so30509027ejh.0;
        Mon, 12 Dec 2022 10:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PiJpQY8SP973JgiH3UZ5m51F8GPsoVLHY+NDy80RjMo=;
        b=GPzvajCoavVao/h8a898nh9ymYllUTBDUi5E9RXj5ANVGw/5GhtDbWU9zHQK8CQGy0
         OuHjEPjs/n+OuOOhYNEjMQzvdjaU0UbezdOa5uWdzxV+cPQRFjLBjFy8E1jalSG+NyT3
         9DL8++BLA78FiWTykiJmuBqbzIy+k9v/KXLibfRIQiSL21a/LtmFycMKOP+mZM/EDxAt
         T9+rUJIZJ2g4gFtJm0x0YdV+ta3U1NVNmJc6B2Hfhj0z3B37QYJhnWQ0ZF3u9qff1yBI
         mc8IPMZyUd4X9fYqXDybC3pzXKC4feags2NYmFXsrC8//a2Hi5h/z8OI1nV8o2B94/qe
         lLTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PiJpQY8SP973JgiH3UZ5m51F8GPsoVLHY+NDy80RjMo=;
        b=hgaYgaDg/8VCyYGnrSiaPyxwB9Jh9Q7r72a+FJUgo9+9e84VUZeDaVHPrR2gKyx9zo
         Z3RknakGXaKKKxOBi5K/b90C2BOZ3aRyeLf5FE04ydwf3n5b/gaceMXzYVr9ovIyh0GC
         BCWGGqYKWD4Tvk9hJG1WChWbjii95HE5i6Dkzrya5g2zTGpQvFnp6AZyTxHcVeCDAT9S
         ud3JoXKfg03ff18bCYUXcFVCGrkmfE9ZtlydDzB+4AoLDKfUZ4envDiztO4+HZ2Zb3kH
         kJr4VSRC7jStngzQaCH9TCdPBo2IsjKiSCb7xKCqVG93P0BHXdv0lwm3HocrSu7H1N5S
         iOFg==
X-Gm-Message-State: ANoB5pmaNrrCrBPEOzASTRSPyNZpV7YP0nt5cHgl8qJyk7a4JKUnREhv
        Pm+U0QCHHogzlOilR2B304I=
X-Google-Smtp-Source: AA0mqf6w/P6eqks/9RTK7Y5h1S05nT/NTXEJzLRONdPs0zIsNg19hwv7N3cdcjkUBwf3fgkEnjTrkQ==
X-Received: by 2002:a17:906:3c15:b0:7c1:4d21:abb7 with SMTP id h21-20020a1709063c1500b007c14d21abb7mr9101208ejg.54.1670870587637;
        Mon, 12 Dec 2022 10:43:07 -0800 (PST)
Received: from skbuf ([188.27.185.63])
        by smtp.gmail.com with ESMTPSA id f30-20020a170906739e00b007ae243c3f05sm3534602ejl.189.2022.12.12.10.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 10:43:07 -0800 (PST)
Date:   Mon, 12 Dec 2022 20:43:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, jbe@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v5 4/6] dsa: lan9303: Performance Optimization
Message-ID: <20221212184305.nlp54j3pnmau53n5@skbuf>
References: <20221209224713.19980-1-jerry.ray@microchip.com>
 <20221209224713.19980-5-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209224713.19980-5-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar comment as for "Whitespace Only" patch. There could be a million
different changes in contents for this driver which could all be summarized
as "Performance Optimization". Please use your common sense, and also
consider people who might be looking through the git log for this driver
and see what is worth backporting. This is a clickbait commit message
with disappointing contents. Find a more appropriate and descriptive
summary for it.

On Fri, Dec 09, 2022 at 04:47:11PM -0600, Jerry Ray wrote:
> As the regmap_write() is over a slow bus that will sleep, we can speed up
> the boot-up time a bit my not bothering to clear a bit that is already
> clear.
> 
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> ---
>  drivers/net/dsa/lan9303-core.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
> index b0f49d9c3d0c..694249aa1f19 100644
> --- a/drivers/net/dsa/lan9303-core.c
> +++ b/drivers/net/dsa/lan9303-core.c
> @@ -891,8 +891,11 @@ static int lan9303_check_device(struct lan9303 *chip)
>  	if (ret)
>  		return (ret);
>  
> -	reg &= ~LAN9303_VIRT_SPECIAL_TURBO;
> -	regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
> +	/* Clear the TURBO Mode bit if it was set. */
> +	if (reg & LAN9303_VIRT_SPECIAL_TURBO) {
> +		reg &= ~LAN9303_VIRT_SPECIAL_TURBO;
> +		regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
> +	}
>  
>  	return 0;
>  }
> -- 
> 2.17.1
> 
