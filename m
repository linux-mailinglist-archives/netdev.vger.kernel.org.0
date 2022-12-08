Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B536474DF
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 18:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiLHRLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 12:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiLHRLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 12:11:19 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DA985D16;
        Thu,  8 Dec 2022 09:11:16 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id a16so2665138edb.9;
        Thu, 08 Dec 2022 09:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k4bdfAGPHD5NopBbK0mSRG4D2jLUJqcRHreo2Ghjs1Q=;
        b=TLWJPLX3rY2ylAHDV+ogOEPxnV1k1s0YGYXp2j/arXARZvR04MR3nn1Gpy757lCc/J
         3eu40m1dWWNt40O5kVfi5tzgIeEZAS4NycS2JIc+BRfR8n74CzgAuRx4IzfTBGBZ43hR
         djOvjqtZ1Q0PDB9Bu+Mg0QqUQCgxdr7InGwLRaJ68fJq+OMc9pdQ6xhiH6Piz5eFW4Ac
         ivC00pgQNCjfdnbty0TUT08g3tgSJhEVSmbgoJxHaCq2j8yIbKGB62bqav5vsOad3gji
         y4YkUElKyLEgg9bE6yz0FbHXVpVeaCdsVdOim4GnqcsoC5RHNTyxBS8uLxDw85WAb6Md
         +RYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k4bdfAGPHD5NopBbK0mSRG4D2jLUJqcRHreo2Ghjs1Q=;
        b=ZKUvhJZ3BPOuMQRhXRD2SQXxDme7EYGGDcLs0kHJgFET8zyVuZjC/EHAfvt6UwEg0g
         d6aqIoFHgtF3e9GeddfPIZSFOv4OC5BWMuWMkZ5hc60+Lr/mH4vfmTMl7bAyX5/AT0py
         nMj/oCf+eSZ1bDaGFbEKupV7MXRxRrpt4TEkHelgdHWo+3ItrVlTVD4/fifRBFoYbL1K
         Q5mWie6yxQcEJdfXAANQtCMkJ4T7gSSq/+hPmOsMGHu4xkS/3EgfpAoemteMpxJECh+n
         ykBVNBPI8dGOGZx8+dL9gaQOlmjVToCOLPiVrn0HmoQ0fD/Dn2/SLyZ8ZGw6VSx++IuI
         vNKA==
X-Gm-Message-State: ANoB5pm9OpRosSn5J/D2baQwcATmv7dhPo6NeH0lhSpm2OHoE6XDaUH9
        gGUB7wXPSV/bfi/EMk/HKpQ=
X-Google-Smtp-Source: AA0mqf4U4+f1vMJIprxDbefYWc/i3jMKoH/lVzpFK91FzVvTatgI0TnkogA7qE8YQ3zbNXfCjqF6QA==
X-Received: by 2002:a05:6402:1002:b0:467:9384:a7aa with SMTP id c2-20020a056402100200b004679384a7aamr2813102edu.15.1670519475171;
        Thu, 08 Dec 2022 09:11:15 -0800 (PST)
Received: from skbuf ([188.26.185.87])
        by smtp.gmail.com with ESMTPSA id n20-20020aa7c694000000b0045726e8a22bsm3573694edq.46.2022.12.08.09.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 09:11:14 -0800 (PST)
Date:   Thu, 8 Dec 2022 19:11:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v4 1/2] dsa: lan9303: Whitespace Only
Message-ID: <20221208171112.eimyx4szcug5wr6u@skbuf>
References: <20221207232828.7367-1-jerry.ray@microchip.com>
 <20221207232828.7367-2-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207232828.7367-2-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please name the commit message something more specific than "Whitespace Only",
that is likely to not be confused with some other patch. A "Whitespace Only"
patch can take place anywhere in this file. Like "align dsa_switch_ops members".

On Wed, Dec 07, 2022 at 05:28:27PM -0600, Jerry Ray wrote:
> Whitespace preparatory patch, making the dsa_switch_ops table consistent.
> No code is added or removed.
> 
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> ---
>  drivers/net/dsa/lan9303-core.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
> index 80f07bd20593..d9f7b554a423 100644
> --- a/drivers/net/dsa/lan9303-core.c
> +++ b/drivers/net/dsa/lan9303-core.c
> @@ -1280,16 +1280,16 @@ static int lan9303_port_mdb_del(struct dsa_switch *ds, int port,
>  }
>  
>  static const struct dsa_switch_ops lan9303_switch_ops = {
> -	.get_tag_protocol = lan9303_get_tag_protocol,
> -	.setup = lan9303_setup,
> -	.get_strings = lan9303_get_strings,
> -	.phy_read = lan9303_phy_read,
> -	.phy_write = lan9303_phy_write,
> -	.adjust_link = lan9303_adjust_link,
> -	.get_ethtool_stats = lan9303_get_ethtool_stats,
> -	.get_sset_count = lan9303_get_sset_count,
> -	.port_enable = lan9303_port_enable,
> -	.port_disable = lan9303_port_disable,
> +	.get_tag_protocol	= lan9303_get_tag_protocol,
> +	.setup			= lan9303_setup,
> +	.get_strings		= lan9303_get_strings,
> +	.phy_read		= lan9303_phy_read,
> +	.phy_write		= lan9303_phy_write,
> +	.adjust_link		= lan9303_adjust_link,
> +	.get_ethtool_stats	= lan9303_get_ethtool_stats,
> +	.get_sset_count		= lan9303_get_sset_count,
> +	.port_enable		= lan9303_port_enable,
> +	.port_disable		= lan9303_port_disable,

Do you use a text editor which highlights tabs? The members above this
line are aligned with tabs, the ones below with spaces. Still not
exactly what I'd call "consistent".

>  	.port_bridge_join       = lan9303_port_bridge_join,
>  	.port_bridge_leave      = lan9303_port_bridge_leave,
>  	.port_stp_state_set     = lan9303_port_stp_state_set,
> -- 
> 2.17.1
> 
