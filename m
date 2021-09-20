Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9DE412924
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 00:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbhITXAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 19:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbhITW6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 18:58:45 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04012C0E48F6
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 10:40:26 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g8so64473277edt.7
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 10:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DPPEha4rlLU7lHmQ+mZJRt5ZDT2dt3vkusUXBZ0rAN4=;
        b=T89178Nn7aiXkkhn2jc5wKXM8iS7QB2Wc5E0lqM9a6j9wQmrW0mahshS3rmrjbS183
         sklgv+DgZBC4RQ+PKSiDCilFz9g1yvOnzFi6AzX5SrFDXwgCCe0Qt7Ub4jK9l38v63IJ
         o1w7JWN7gUBMGAIjI+W1lsjjITNEZBJiRkPpUhXsO2v8x+pqazg4GcLe8K8r5gTqYJyM
         a/4VhhwCsiqNsPfYfiJDP60+uqLScJfrQ68Hz855KVH7lgQg9ySXzseaQ7Io8zKosxWn
         6mjiDBU4MhOuYPokJLSkhRdhv/nWoHiNWmaJiLf0gIotjnyNiq2hk8khBZJcQFGGjlVB
         YWSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DPPEha4rlLU7lHmQ+mZJRt5ZDT2dt3vkusUXBZ0rAN4=;
        b=ac7JRLW6Ogvfwxnwy/BlpHpUSpDTr1ud4s5O0AJZGFpADEgfgSEKz5a/zfaZ6FXKyk
         k1aJ0P/vP2ia2zvjov3rWOn3bgf//yfxq812Eg8X52ZbSiigeXrvzjsDtMcjDteNdHnG
         TPj6rTofbJcT9n63gf4ElYjlrG9dAdR2rC++T324+ZWBQRMWVpLpcd7MfJtSUWLZ41py
         stq6RLXuJaKsqPi9fZcuYy4mJHX/5e5qiG2YPAzgufYlv7AC4hAY+f4LsewvOxhlrcm+
         8s9SrIrVqF4XsY1kin8Y1rJgi1WGgUJ3N7HSTayIr5J3ZCgdJXwTQ3YNYEnjXNCD1Lfq
         j9jA==
X-Gm-Message-State: AOAM530APrMN1W4wK1mOkneLcMYnHnmvJKV//c3asEuLTBEFecgtJMHM
        onmeiIcIFlp4gFfiWu6+BLY=
X-Google-Smtp-Source: ABdhPJyKT/DTDTyjSjJwmGhIp/57KoebCr5YZOyiDi7uhEQCG78MJRQGLsW7RfAhl6NRteQ1fCemJA==
X-Received: by 2002:a17:906:150c:: with SMTP id b12mr29624768ejd.275.1632159624449;
        Mon, 20 Sep 2021 10:40:24 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id j5sm6331323ejb.96.2021.09.20.10.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 10:40:23 -0700 (PDT)
Date:   Mon, 20 Sep 2021 20:40:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Saravana Kannan <saravanak@google.com>
Subject: Re: Race between "Generic PHY" and "bcm53xx" drivers after
 -EPROBE_DEFER
Message-ID: <20210920174022.uc42krhj2on3afud@skbuf>
References: <3639116e-9292-03ca-b9d9-d741118a4541@gmail.com>
 <4648f65c-4d38-dbe9-a902-783e6dfb9cbd@gmail.com>
 <20210920170348.o7u66gpwnh7bczu2@skbuf>
 <11994990-11f2-8701-f0a4-25cb35393595@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11994990-11f2-8701-f0a4-25cb35393595@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 10:14:48AM -0700, Florian Fainelli wrote:
> The SPROM is a piece of NVRAM that is intended to describe in a set of
> key/value pairs various platform configuration details. There can be up
> to 3 GMACs on the SoC which you can connect in a variety of ways towards
> internal/external PHYs or internal/external Ethernet switches. The SPROM
> is used to describe whether you connect to a regular PHY (not at PHY
> address 30 decimal, so not the Broadcom pseudo-PHY) or an Ethernet
> switch pseudo-PHY via MDIO.
> 
> What appears to be missing here is that we should not be executing this
> block of code for phyaddr == BGMAC_PHY_NOREGS because we will not have a
> PHY device proper to begin with and this collides with registering the
> b53_mdio driver.

Who provisions the SPROM exactly? It still seems pretty broken to me
that one of the GMACs has a bgmac->phyaddr pointing to a switch.
Special-casing the Broadcom switch seems not enough, the same thing
could happen with a Marvell switch or others. How about looking up the
device tree whether the bgmac->mii_bus' OF node has any child with a
"reg" of bgmac->phyaddr, and if it does, whether of_mdiobus_child_is_phy
actually returns true for it?
