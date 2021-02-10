Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D8831643D
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhBJKtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhBJKqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 05:46:33 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C49C0613D6;
        Wed, 10 Feb 2021 02:45:52 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id w2so3194077ejk.13;
        Wed, 10 Feb 2021 02:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1rNLXcvXKP3m/fnPThWaXf4M817aZUPGjPuR43utm5Q=;
        b=bQRtat1Xo7i63Co4iAOtYmLAkcqeWBNEsuqqBTZC/sdXBIAuIhxW+yEfTW7tMgqXNR
         NaqrHFZLhkELQZJs+Rxzc6q22fgJ7363f58/IxCP6HhoDlKmUBej3Ud7JVC3V9cSXGem
         M/20hpLtqmJRy0w3i1zTiJH+zAlGzK3m6GyQGGjRlikreB00qh2GmmGAic23HCI1QYq2
         7wWLGrtE2dwuCysbP8+AGFZbanuCLPhXOwBiXqaUzPlZkm2CV1xqkaDh9CWquq87io07
         dKu37qYD14SYEK9H9QJq9UyJdO0odBc/pu/TO6ffraYdMRCrTMr1SUVKvxJ4U+2g8Y/S
         erXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1rNLXcvXKP3m/fnPThWaXf4M817aZUPGjPuR43utm5Q=;
        b=rLJXn4303qDi21mTs11T4L1lDHhzNFm+jDk6z5YUylwLqMWm8wUSVeuZhUpeVxKoLT
         R4A0I2GSrX4zhFoYZdXkxoKBjBvNBEc1SU427Gj8a6ykH/wqMG2PS5Qm3BqYRZR3bc+I
         zEXf0QVGa8nVr6Q+vgmVJ+QUW/iFF8dQP0cpMvUfKrKPEzM93q8Z/nM4OaLYySXDwIi4
         SZLAnXx/qlhYTvLh6VQoavjPFaPrKwyVkOCGLcUJ/L5nQIXX5qpwiY//dH04WIwl4siI
         6oyZUFdLgGBYP9MRM1fEJv+Egyn/bVhmJuVOH1+Fpqw3yXwGohJojG8krddSEm4Eb+Qi
         IPEQ==
X-Gm-Message-State: AOAM5309HP132TJpu8WMcYpWhSPCugsKUdG7qkI2c9ziECFuLSM8vGvN
        dyWJ3z7pRZj5vtMB3uETgda5fGACs8s=
X-Google-Smtp-Source: ABdhPJxgAXMW3rVTYhwx790W2oXXaFQwqENLDhxih4f/pLVMsP5SR1/Wa7g89TQbRB6Uzekt0BcExQ==
X-Received: by 2002:a17:906:4eda:: with SMTP id i26mr2229075ejv.467.1612953951473;
        Wed, 10 Feb 2021 02:45:51 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c18sm675126edu.20.2021.02.10.02.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 02:45:50 -0800 (PST)
Date:   Wed, 10 Feb 2021 12:45:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/11] Cleanup in brport flags switchdev
 offload for DSA
Message-ID: <20210210104549.ga3lgjafn5x3htwj@skbuf>
References: <20210210091445.741269-1-olteanv@gmail.com>
 <a8e9284b-f0a6-0343-175d-8c323371ef8d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e9284b-f0a6-0343-175d-8c323371ef8d@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,

On Wed, Feb 10, 2021 at 12:31:43PM +0200, Nikolay Aleksandrov wrote:
> Hi Vladimir,
> Let's take a step back for a moment and discuss the bridge unlock/lock sequences
> that come with this set. I'd really like to avoid those as they're a recipe
> for future problems. The only good way to achieve that currently is to keep
> the PRE_FLAGS call and do that in unsleepable context but move the FLAGS call
> after the flags have been changed (if they have changed obviously). That would
> make the code read much easier since we'll have all our lock/unlock sequences
> in the same code blocks and won't play games to get sleepable context.
> Please let's think and work in that direction, rather than having:
> +	spin_lock_bh(&p->br->lock);
> +	if (err) {
> +		netdev_err(p->dev, "%s\n", extack._msg);
> +		return err;
>  	}
> +
> 
> which immediately looks like a bug even though after some code checking we can
> verify it's ok. WDYT?
> 
> I plan to get rid of most of the br->lock since it's been abused for a very long
> time because it's essentially STP lock, but people have started using it for other
> things and I plan to fix that when I get more time.

This won't make the sysfs codepath any nicer, will it?
