Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57252624AC
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 03:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIIB7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 21:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgIIB67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 21:58:59 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC90C061573;
        Tue,  8 Sep 2020 18:58:58 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id v196so878145pfc.1;
        Tue, 08 Sep 2020 18:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xPC4RuwV4psa/RU76n77/fpQNaZBJTY+bTJKkQ0WQe0=;
        b=XU7l/NePBc97GP+VRV/e5Mm8YPQdHu+eYqD0oWCc3dEM5CohutZLsjQun3VaR2g+v0
         PByetRxqfYURBSLmVRox//lnrtpczVqH7nSyN9vnEES7T8+T4upB++fe5c8a94YkxDlr
         Uq8Icqz9KSh6lUSwIgRaAPNWGQOk8fEqsZb+0Prhdc3dpjkuEaMNwSBnYcanVnYjQxy6
         amU5jmyI9/nXZ6InPCn39B74w/SR9ZmpGGKtd8RRCnm3KKZRsskKlqNH/MeGT/RlZIIy
         7kEFVvUe6TGO5vVsAZo+uQIQBvZmfn60OnosYdc2tMN3QhvWCQJHQ1PnIBG/rsv0/P5b
         8ETg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xPC4RuwV4psa/RU76n77/fpQNaZBJTY+bTJKkQ0WQe0=;
        b=jtP/AmfTBLlCDeOu2o9tPj3tlld5yXfSFc+pddpapzrlHMC/Fsy/j66jHZgef/u0Cm
         E5VeTqlAzeTPXcdlFqbsXtnHV/0hNWmGGJFI5hw4QXZBP0Br9oIHYYPSADcpHNrXsTR1
         p3RSPtEOJ5XzO4UPtQ6CpaycLvpvw5fu7dRlovNw5S18IDVjxRpJqyrAuR32deYKwaA2
         OD2zEo6CTD676rGijLez8nxDMIkNIEn4ixEx3oWKCg+Cg/raFHC1AO0IZ5yky+X5JeBU
         4lkNB0I2VwgGBTgGgveUp83skO9x2l4t8dqXHC2tl0vGUQ6ltqqKmqCPtb43BxnMvrAG
         GRMw==
X-Gm-Message-State: AOAM532eSDy0SqtUZVrOPjlRN0KiqDkdO2xOuYPfvSW3P8454n5KTsSh
        lVcQKqATJHXV5URjlJrMw06ia1k6WjE=
X-Google-Smtp-Source: ABdhPJyu64VlqcgwGac/wXEzgPI18IsYfYuFlMZ7co114q/nwn3i7stkmaAExywfxva3TLoH3Nnuag==
X-Received: by 2002:a17:902:8342:: with SMTP id z2mr1459348pln.3.1599616736827;
        Tue, 08 Sep 2020 18:58:56 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l19sm650693pff.8.2020.09.08.18.58.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 18:58:55 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] net: phy: smsc: skip ENERGYON interrupt if
 disabled
To:     Marco Felsch <m.felsch@pengutronix.de>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org
References: <20200908112520.3439-1-m.felsch@pengutronix.de>
 <20200908112520.3439-2-m.felsch@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c1e70a48-794a-5fc5-822e-ad153679d58d@gmail.com>
Date:   Tue, 8 Sep 2020 18:58:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200908112520.3439-2-m.felsch@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/8/2020 4:25 AM, Marco Felsch wrote:
> Don't enable the interrupt if the platform disable the energy detection
> by "smsc,disable-energy-detect".
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
> v2:
> - Add Andrew's tag
> 
>   drivers/net/phy/smsc.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index 74568ae16125..fa539a867de6 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -37,10 +37,17 @@ struct smsc_phy_priv {
>   
>   static int smsc_phy_config_intr(struct phy_device *phydev)
>   {
> -	int rc = phy_write (phydev, MII_LAN83C185_IM,
> -			((PHY_INTERRUPT_ENABLED == phydev->interrupts)
> -			? MII_LAN83C185_ISF_INT_PHYLIB_EVENTS
> -			: 0));
> +	struct smsc_phy_priv *priv = phydev->priv;
> +	u16 intmask = 0;
> +	int rc;
> +
> +	if (phydev->interrupts) {

Not that it changes the code functionally, but it would be nice to 
preserve the phydev->interrupts == PHY_INTERRUPT_ENABLED.

> +		intmask = MII_LAN83C185_ISF_INT4 | MII_LAN83C185_ISF_INT6;
> +		if (priv->energy_enable)
> +			intmask |= MII_LAN83C185_ISF_INT7;
> +	}

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
