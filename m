Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137B62F3CF9
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438102AbhALVhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436991AbhALUiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 15:38:52 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398EEC061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 12:38:12 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id d17so5365445ejy.9
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 12:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=oEnEDIDJIc2OwLDtqzqOSyMhSyOzqr/b8CHtvwH6Y9o=;
        b=s5ntTrC4DEDA0hGZxhKMZ+pqiVRsG18glTxAmnSaWrFKdchFh8p+1KafJxxwTaDAAk
         mORJnUR3AyYr/V9pGF+MHsYpnnoJsF+0ebAwatkRYT0jp4oN22zIn5apzroE4pTv2D5G
         o7ok6SRAJICgfOyGNrZ8yjLBJ6vxuzc5j+ljhlXUFfE6lGe2uWNNBTvhfQ9XQkCRDm7I
         V7mlSAOfrmt6t3dG5CVaREeC1SgVN/KhysY9+arxfRHiszMC5UWc9A2iuJkazZCz3JyF
         /+r7YxC3rk/PI7mJhKpHDdcJMCYU4SWhwJuqvZfI+rrzpxw58+e7O4dKC7SGFMXoyPD6
         RkuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oEnEDIDJIc2OwLDtqzqOSyMhSyOzqr/b8CHtvwH6Y9o=;
        b=VaFyeOfNlBVzdEdqHFRS4lA06EmlyUh1ujEjumTILeDpEkOWN+Vky2imFOHilxusXq
         rBHscVVoNZolUuLifAsKSj7Cm0n661HT5+tX5pbA7VVQxDu98M/u1WCKoAFJV1o2kHIH
         1B0EqOaENWxfeRNEAFICGPwqO04gJ73uu+1VQkH6Y5UD33z5ExeVfR0zNm+G+wSZoAoM
         QNmj3xclX5vJVgT1O4YmHjmfI6Vit98HtZ91l2nFznabNrp6Sew3s8DTwy27jG0Z4r/g
         FgwPDmLszc57Cvr2sQsPvJI+Mo8RoX9CgGwNbIhdLvP9RAFgl8zhq3ESBydP1Pd1zujl
         khAQ==
X-Gm-Message-State: AOAM531gXGqst/kYvjgkYOx0vP9IuB2p5lrGmY5bJZXMsq2nZrpTqPYi
        ekuKQk0AWDZP5dKXuk48kDU=
X-Google-Smtp-Source: ABdhPJwiEd+sesqhQY+J7QQ3E3NWQgru9f0rwZOaMFgOgNmfY6SF7VoR363N1smMXJgVuUTTh95xxg==
X-Received: by 2002:a17:906:edd1:: with SMTP id sb17mr433528ejb.118.1610483890728;
        Tue, 12 Jan 2021 12:38:10 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id v16sm1893474eds.64.2021.01.12.12.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 12:38:10 -0800 (PST)
Date:   Tue, 12 Jan 2021 22:38:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v15 5/6] net: dsa: mv88e6xxx: Add support for
 mv88e6393x family of Marvell
Message-ID: <20210112203808.4mkryi3tcut7mvz7@skbuf>
References: <20210112195405.12890-1-kabel@kernel.org>
 <20210112195405.12890-6-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210112195405.12890-6-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 08:54:04PM +0100, Marek Behún wrote:
> From: Pavana Sharma <pavana.sharma@digi.com>
> 
> The Marvell 88E6393X device is a single-chip integration of a 11-port
> Ethernet switch with eight integrated Gigabit Ethernet (GbE)
> transceivers and three 10-Gigabit interfaces.
> 
> This patch adds functionalities specific to mv88e6393x family (88E6393X,
> 88E6193X and 88E6191X).
> 
> The main differences between previous devices and this one are:
> - port 0 can be a SERDES port
> - all SERDESes are one-lane, eg. no XAUI nor RXAUI
> - on the other hand the SERDESes can do USXGMII, 10GBASER and 5GBASER
>   (on 6191X only one SERDES is capable of more than 1g; USXGMII is not
>   yet supported with this change)
> - Port Policy CTL register is changed to Port Policy MGMT CTL register,
>   via which several more registers can be accessed indirectly
> - egress monitor port is configured differently
> - ingress monitor/CPU/mirror ports are configured differently and can be
>   configured per port (ie. each port can have different ingress monitor
>   port, for example)
> - port speed AltBit works differently than previously
> - PHY registers can be also accessed via MDIO address 0x18 and 0x19
>   (on previous devices they could be accessed only via Global 2 offsets
>    0x18 and 0x19, which means two indirections; this feature is not yet
>    leveraged with this patch)
> 
> Co-developed-by: Ashkan Boldaji <ashkan.boldaji@digi.com>
> Signed-off-by: Ashkan Boldaji <ashkan.boldaji@digi.com>
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
> Co-developed-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c    | 149 +++++++++++++
>  drivers/net/dsa/mv88e6xxx/chip.h    |   4 +
>  drivers/net/dsa/mv88e6xxx/global1.h |   2 +
>  drivers/net/dsa/mv88e6xxx/global2.h |   8 +
>  drivers/net/dsa/mv88e6xxx/port.c    | 267 ++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/port.h    |  47 ++++-
>  drivers/net/dsa/mv88e6xxx/serdes.c  | 312 ++++++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/serdes.h  |  44 ++++
>  8 files changed, 831 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index ed07cb29b285..c2dc6858481a 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -635,6 +635,28 @@ static void mv88e6390x_phylink_validate(struct mv88e6xxx_chip *chip, int port,
>  	mv88e6390_phylink_validate(chip, port, mask, state);
>  }
>  
> +static void mv88e6393x_phylink_validate(struct mv88e6xxx_chip *chip, int port,
> +					unsigned long *mask,
> +					struct phylink_link_state *state)
> +{
> +	if (port == 0 || port == 9 || port == 10) {
> +		phylink_set(mask, 10000baseT_Full);
> +		phylink_set(mask, 10000baseCR_Full);
> +		phylink_set(mask, 10000baseSR_Full);
> +		phylink_set(mask, 10000baseLR_Full);
> +		phylink_set(mask, 10000baseLRM_Full);
> +		phylink_set(mask, 10000baseER_Full);

Why did you remove 1000baseKR_Full from here?
