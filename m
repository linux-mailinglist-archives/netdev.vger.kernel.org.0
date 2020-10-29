Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D478729F6D0
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 22:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgJ2V1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 17:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgJ2V1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 17:27:47 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96B4C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 14:27:46 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id 7so5851392ejm.0
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 14:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vWGCImiGLvzX18MDGaNqK2a/XiHcnbV3WaGWvZcjIaI=;
        b=JnEypvDbPvrzhfq4ikXKsjYjau7ZgZuOEHE/yjfTKd3eVbmd4VAUN+2g+f44MwwN1j
         uwG94/pJHO3CLEAFMCuSxA4ITv7oX+Pp4kJ8KKHkjR6Bin19fGQ8fIyiMBX5IFSDtf6E
         rgm6HWGKaV5ptEy0Y82HQaIGt43vDoJPl1KoUixdWj0P6S552CVq6ZISZH9Ism7y4Dzp
         FTml5dCOkG0MQa5YtLl6edF/zT2vyibJ1yMjUQ4rJ6SZyEWkz6NTI6bm4Xoog4TSrVfP
         Jy/v84C0F8EEbpT/qPm/Pgg/V37XJrVBsvcrSBxuCopRxmMvHms9A26K7GAiWbflknXc
         7wUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vWGCImiGLvzX18MDGaNqK2a/XiHcnbV3WaGWvZcjIaI=;
        b=RxEVTZf8pE5XGgQ6KwboVf4LcB083YOtOiBRCsU+yintrkJ0ekvtmvJWsmVEqK9qIY
         dKh6y+5KWzDtDqXwp7fIChYQGc1iASUXxnZm3o+gCv4SzJn0m/+8VOyzIlLkHOI9CPvP
         Z3rOBIuZ54aoEnqGkaAOkmLiBeGbxIRfbVA6AcgoxcAILS1WPd6VRTmxtCqrbW0FU//g
         AOQR11rS7tXYb1izS/3iQC3Q4H+e9JjPaV0wNK2HwLiz3mtrrI3c8ZE3ymnGb/xOx5ST
         +Fcg5wKpWoAumor9O9EHlm0Ud7eMdDWAwNu6hxEFSoSB6NAG89d4y1HccVdyfSaj7aJP
         49Kg==
X-Gm-Message-State: AOAM5339JRR+Vfbyxt7JwKxtC5J/veKVQCblJW9mmgxgVJPuJMEFOU5F
        BgRo+e/2+Mq279Y0wRrZM+s=
X-Google-Smtp-Source: ABdhPJz/n8L7muNWHprump/Bjf8HuI+X51YvtzZoQryxTx15a2cFkbzCvYjpvI5GHJ2duKcTWSTedA==
X-Received: by 2002:a17:906:5d9:: with SMTP id t25mr5944819ejt.443.1604006865472;
        Thu, 29 Oct 2020 14:27:45 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id yw17sm2059403ejb.97.2020.10.29.14.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 14:27:45 -0700 (PDT)
Date:   Thu, 29 Oct 2020 23:27:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: fix vlan setup
Message-ID: <20201029212743.qdnfl2bj5trkdhmw@skbuf>
References: <E1kYAU3-00071C-1G@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1kYAU3-00071C-1G@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 04:09:03PM +0000, Russell King wrote:
> DSA assumes that a bridge which has vlan filtering disabled is not
> vlan aware, and ignores all vlan configuration. However, the kernel
> software bridge code allows configuration in this state.
> 
> This causes the kernel's idea of the bridge vlan state and the
> hardware state to disagree, so "bridge vlan show" indicates a correct
> configuration but the hardware lacks all configuration. Even worse,
> enabling vlan filtering on a DSA bridge immediately blocks all traffic
> which, given the output of "bridge vlan show", is very confusing.
> 
> Allow the VLAN configuration to be updated on Marvell DSA bridges,
> otherwise we end up cutting all traffic when enabling vlan filtering.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---

Tested-by: Vladimir Oltean <olteanv@gmail.com>

> This is the revised version of the patch that has been waiting a long
> time to fix this issue on the Marvell DSA switches.
> 
>  drivers/net/dsa/mv88e6xxx/chip.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index bd297ae7cf9e..72340c17f099 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2851,6 +2851,7 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
>  
>  	chip->ds = ds;
>  	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
> +	ds->configure_vlan_while_not_filtering = true;
>  
>  	mv88e6xxx_reg_lock(chip);
>  
> -- 
> 2.20.1
> 
