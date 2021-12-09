Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4CD46E749
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 12:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbhLILM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 06:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235371AbhLILMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 06:12:55 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5760FC061746;
        Thu,  9 Dec 2021 03:09:22 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id p18so3864269wmq.5;
        Thu, 09 Dec 2021 03:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v3S9A93yzoQzBL3h+6YnSGnaMFNBWaZG/rgGNmWuVU8=;
        b=VNJ05gaIXH5gp4aFwDnbIVFA5g02jzK3WtVaPAtjY1W82Wduqkn3WMa8sxoEOpa6jk
         l2c7chGD0NN6/mUAs2usjkMC7ubNGHFY4aFKTdhVsq5puoac+HtgJT10PmiEuNIp0lQz
         VM0enXOnXYvISklZUIeuowyRpgr/GTND1xzPwugskdmYYjjvMBB06cV67T68Vp68P7CX
         B/zundfjev4XlEW7MpL+xlbK2ygWX5Y5xuNIkYp6Wt0rTbLsqMCWeRCOwaBm+HUO229d
         wv1xdij3UsJsjnxohSHwHw87hOnuE9KgmG3ZaACmNE66bfPdLDHkNXFNlwAQZJTmooia
         29KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v3S9A93yzoQzBL3h+6YnSGnaMFNBWaZG/rgGNmWuVU8=;
        b=vMOU2FyVlE7MmNWu2zveZy7NmLDSh5ZQFJW9dSly0dF2eJVcvFiHN68augiECz6UHu
         GIM/YdgmxTJ8p/jNVGeqwlG4s+YQzwkgT0DIKBkgHBrvwJ3nym0C3KoicruWhQhYrTU/
         XBFfm5XswzN7D8ly5pm5fNCIdc1sHC1zmLl6WWV2I40f+hC8i7OQj031dMVtsOh9cnsn
         WLLfxQH9DpWo4wS6RD628UowjY5I1GPayQ66Ihwc/k1z20C53liJyZoNMOel/AgDtsco
         wbT/tHeTjcqtYK59umBUsDFrOgtIvA1R1De+IBiav7XToBS6/HdVcE21aoUZvshBTB3m
         7nbA==
X-Gm-Message-State: AOAM532dfEzsg0PBq2cheduJVx7Czb1T+aNOUf5r1w+3Oifd1wBQk5P+
        Q9xsxLUd7+5sLPjMddkUpn0=
X-Google-Smtp-Source: ABdhPJzvpspLtaEsVf0HRLCkcpaV3zqWBUwLklrmqto01FVpuUQ8yDAZlaleCI3yRwuB44Kx9vMhnQ==
X-Received: by 2002:a7b:c455:: with SMTP id l21mr6059224wmi.168.1639048160886;
        Thu, 09 Dec 2021 03:09:20 -0800 (PST)
Received: from elementary ([217.113.240.86])
        by smtp.gmail.com with ESMTPSA id c6sm11185530wmq.46.2021.12.09.03.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 03:09:20 -0800 (PST)
Date:   Thu, 9 Dec 2021 12:09:18 +0100
From:   =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: felix: Fix memory leak in
 felix_setup_mmio_filtering
Message-ID: <20211209110918.GA11977@elementary>
References: <20211208180509.32587-1-jose.exposito89@gmail.com>
 <20211208181331.ptgtxg77yiz2zgb5@skbuf>
 <20211208151030.1b489fad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208151030.1b489fad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 03:10:30PM -0800, Jakub Kicinski wrote:
> On Wed, 8 Dec 2021 18:13:32 +0000 Vladimir Oltean wrote:
> > Impossible memory leak, I might add, because DSA will error out much
> > soon if there isn't any CPU port defined:
> > https://elixir.bootlin.com/linux/v5.15.7/source/net/dsa/dsa2.c#L374
> > I don't think I should have added the "if (cpu < 0)" check at all, but
> > then it would have raised other flags, about BIT(negative number) or
> > things like that. I don't know what's the best way to deal with this?
> > 
> > Anyway, in case we find no better alternative:
> > 
> > Fixes: 8d5f7954b7c8 ("net: dsa: felix: break at first CPU port during init and teardown")
> > Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> If this is the way to go please repost with the tags added
> and a commit message.

Thanks for the quick review. I just sent v2 in case you decide to keep
the cpu check:

https://lore.kernel.org/netdev/20211209110538.11585-1-jose.exposito89@gmail.com/T/#u

Jose
