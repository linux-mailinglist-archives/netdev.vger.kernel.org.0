Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FBC2F5EBC
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbhANK23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 05:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbhANK21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 05:28:27 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D30C061573
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 02:27:46 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id h16so5145108edt.7
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 02:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UCN8+wpANnDAM/0a8fJFnJ2XM6jHDsZK6P9eH3osKh8=;
        b=Rh5pAEOsYziBnut3NPLbrQsTrRpyQiQ7rP0WGGxZzfVr6qVbb87ijRcbIoV304wO8s
         3FRW4M4ubARItmMxsquMzcz5jIjq+iuflcQNxFKxQ/yUlZlYZHqkxtunOAAT/nAC67oH
         W85Ds7Z16L7tiZmkMNxTQ3J9QHwT4YFVt47A4M4RvWRS5WZKn05HIFko/7R3ngcGL1Pu
         79ueOThSH3gw/sQkuhWrZgkrDWz5gdH7xaGIXLzod36FZcO7w5iliZr6Gyjkq+JXCbP5
         tEbo/bFzGcQT7tXIWTeN+RcXQvk7NuK8JnfoZufEq0BhLQp5A6RqsFekSb2H39f7j/9O
         imAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UCN8+wpANnDAM/0a8fJFnJ2XM6jHDsZK6P9eH3osKh8=;
        b=J5phlHIzAuWJXQKbhQWM4B36NVWCfnlhqbI1+dh3MPe47G1q+pAHVZhZUPpRix6gDE
         NGJ5QTX5T/1sD1KZnr7NeVY+vRXOHo2cFELLPX5AJcmD/6hmwpUHMvfTPiMQ+noii+YT
         50R09FQ/sfNNuQd34d8HrqVOgvsIpx2OxVHxhQHbEac6ZABNAEwRhD8xI5VIOLNhoe3/
         h//PKGznkB3C4zkvRq4GL000CD/IF8lUsw1jXXyFQ+TCOUdFt74HG+f+o0zqSFBdNbyh
         fgz2T7uDYxXE/Qk60dOpNef8HYjYEB2/Y3cI/s6H1jHcCdN3nZEaRqioQAJKnG/mcF+m
         +DPw==
X-Gm-Message-State: AOAM532GTJfcAiB6iCY9MHchJZMUKcNdMNnHxHYym/LLBDydoFEdo8Q6
        FY26IRtFgHz9K3g7WEUZsJM=
X-Google-Smtp-Source: ABdhPJzwr3tNOUt+oLqA+riMke1sa5MFsCHBYOpJ63L11jdo82X8Rbl+Y3sekGO1I5nwL3+++Of46g==
X-Received: by 2002:aa7:d0d4:: with SMTP id u20mr3106169edo.203.1610620065315;
        Thu, 14 Jan 2021 02:27:45 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id m22sm1789450edp.81.2021.01.14.02.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 02:27:44 -0800 (PST)
Date:   Thu, 14 Jan 2021 12:27:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 08/10] net: mscc: ocelot: register devlink
 ports
Message-ID: <20210114102743.etmvn7jq5jcgiqxk@skbuf>
References: <20210111174316.3515736-1-olteanv@gmail.com>
 <20210111174316.3515736-9-olteanv@gmail.com>
 <20210113193033.77242881@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113193033.77242881@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 07:30:33PM -0800, Jakub Kicinski wrote:
> On Mon, 11 Jan 2021 19:43:14 +0200 Vladimir Oltean wrote:
> > +struct ocelot_devlink_private {
> > +	struct ocelot *ocelot;
> > +};
> 
> I don't think you ever explained to me why you don't put struct ocelot
> in the priv.
> 
> -	ocelot = devm_kzalloc(&pdev->dev, sizeof(*ocelot), GFP_KERNEL);
> -	if (!ocelot)
> +	devlink = devlink_alloc(&ocelot_devlink_ops, sizeof(*ocelot));
> +	if (!devlink)
>                  return -ENOMEM;
> +	ocelot = devlink_priv(ocelot->devlink);

Because that's not going to be all? The error path handling and teardown
all need to change, because I no longer use device-managed allocation,
and I wanted to avoid that.
