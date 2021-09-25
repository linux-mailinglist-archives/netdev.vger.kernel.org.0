Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B8241840A
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 20:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhIYS6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 14:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhIYS6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 14:58:03 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5E3C061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 11:56:28 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id dm26so15852967edb.12
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 11:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=rRAcwU9aDWTvhWvLogg3D6gLIztL9MccmHhnKmVADZo=;
        b=J1uKeWqxcjluSXP9sFVxZjIQK6azqajCxlkb83mGki7iq+1KJWJXhzdNmJcn0YRjpT
         mu6UGZeV9JyCoHKzUfMFAZt48OrvpO/ca0Q18WOSTgNKsYsbqjrqwOnRCWGo5soiWw/I
         D1StxOAJFmYMzx69hfgyc9KyMmg3zEMER1b/pTdeLvkSf3W9X6sYhuNlZhPf33faKwfz
         EG7c3S0rGUHhVifJN/toYeIWW/ZKn3vS8qaBmd7hWukpuPxZAYrZ14MuHtNahuNydF06
         /nZi0hC++xR8o3pqd4IRwnDHIErJ/pi95Do8oBZcOQIs+9L+VM6yUEdiNGwDQ7VXHpNk
         H17w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rRAcwU9aDWTvhWvLogg3D6gLIztL9MccmHhnKmVADZo=;
        b=qVbNJ2hZELZhyFZTqDtfzOlFJCQO0cwPZRS42aLnP4e2SfcPl5/ciWVIoYB9GhCrbX
         bFOKKxVqyK/dMiz0i0AXt1Tf/+kwKb8r49+2YUYmEqfBJ3CWF+SozhdesoF6jfg7XjcK
         h1LiXwT6lrerOFk6ocsyfQOAh7+tMcNQ88jmfAXURNizStzdu2b9IQw0u2MSgjcIdYWT
         he/NOROgBXexnvuQszfEtorzFmUVMg9CA8TUbKps06xyk8fto5eE8EMKWi9SB5zAqVxw
         tgkoX/CmwgnwLuXzOczf9wSsnVH/DJJZVfcObFDTGWIGpTRJr4bNy/aRXqCuINVIPvxV
         tezw==
X-Gm-Message-State: AOAM532LNMnnH10wKqJD66DWb3TJQENNoQcI8DnXSBxH3IVsIc2jPrqx
        /UKNkymPNITlgCd1QhTR27c=
X-Google-Smtp-Source: ABdhPJxSndtst8ZT3gGN9hg19BzLAjq7XJwn5ysue2RbzMlrP9TSlVe8pnfAeNZZVMm26rJi6uhYfA==
X-Received: by 2002:a17:906:3e81:: with SMTP id a1mr18483565ejj.482.1632596186738;
        Sat, 25 Sep 2021 11:56:26 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id dm8sm7672258edb.90.2021.09.25.11.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 11:56:26 -0700 (PDT)
Date:   Sat, 25 Sep 2021 21:56:25 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Mauri Sandberg <sandberg@mailfence.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 6/6 v6] net: dsa: rtl8366: Drop and depromote
 pointless prints
Message-ID: <20210925185625.5arlipvkhqhj2wrm@skbuf>
References: <20210925132311.2040272-1-linus.walleij@linaro.org>
 <20210925132311.2040272-7-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210925132311.2040272-7-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 25, 2021 at 03:23:11PM +0200, Linus Walleij wrote:
> We don't need a message for every VLAN association, dbg
> is fine. The message about adding the DSA or CPU
> port to a VLAN is directly misleading, this is perfectly
> fine.
>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v5->v6:
> - No changes just resending with the rest of the
>   patches.
> ChangeLog v4->v5:
> - Collect Florians review tag.
> ChangeLog v1->v4:
> - New patch to deal with confusing messages and too talkative
>   DSA bridge.
> ---
>  drivers/net/dsa/rtl8366.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
> index f815cd16ad48..bb6189aedcd4 100644
> --- a/drivers/net/dsa/rtl8366.c
> +++ b/drivers/net/dsa/rtl8366.c
> @@ -318,12 +318,9 @@ int rtl8366_vlan_add(struct dsa_switch *ds, int port,
>  		return ret;
>  	}
>
> -	dev_info(smi->dev, "add VLAN %d on port %d, %s, %s\n",
> -		 vlan->vid, port, untagged ? "untagged" : "tagged",
> -		 pvid ? " PVID" : "no PVID");
> -
> -	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
> -		dev_err(smi->dev, "port is DSA or CPU port\n");
> +	dev_dbg(smi->dev, "add VLAN %d on port %d, %s, %s\n",
> +		vlan->vid, port, untagged ? "untagged" : "tagged",
> +		pvid ? " PVID" : "no PVID");

This is better, not going to complain too much, but I mean,
rtl8366_set_vlan and rtl8366_set_pvid already have debugging prints in
them, how can you tolerate so many superfluous prints, what do they
bring useful?

>
>  	member |= BIT(port);
>
> @@ -356,7 +353,7 @@ int rtl8366_vlan_del(struct dsa_switch *ds, int port,
>  	struct realtek_smi *smi = ds->priv;
>  	int ret, i;
>
> -	dev_info(smi->dev, "del VLAN %04x on port %d\n", vlan->vid, port);
> +	dev_dbg(smi->dev, "del VLAN %d on port %d\n", vlan->vid, port);
>
>  	for (i = 0; i < smi->num_vlan_mc; i++) {
>  		struct rtl8366_vlan_mc vlanmc;
> --
> 2.31.1
>
