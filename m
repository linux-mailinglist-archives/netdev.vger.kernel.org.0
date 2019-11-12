Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E62DF8B7D
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 10:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKLJPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 04:15:19 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43372 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfKLJPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 04:15:19 -0500
Received: by mail-wr1-f65.google.com with SMTP id n1so17575423wra.10
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 01:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5zriEFojyVbt7ELQVanoYbgxzAFKHxi+UtmPwx0zmeQ=;
        b=0gkGcUth8FLOYxIwdZiDgR1Ug9t1VBkV/3FwqbV7Q0OlC+Vnjq19TT2qyCHUVKF/vP
         xdyiQ1QMLC15zHuNxZa0g4PJoKcO0gxfNPTSTdKFqWIDgBQucl+tKWv/Wgu96XF+l4EC
         GePrmS8gHuU5b34yWy4N1ZDP0a6Dm87jhF8JmDu8AL2s6dcQEiXZIW2FjIwPVEScBxcn
         6ul3OgpUkJcW9ZPpYN4sggNPfJ156PbxG9iFTX8eybTpwN1zHmR3LDOnCTShPahCKN60
         TNKZDin0L9emwY/sf5PJwSW1f4dE9rV1pSJ2wZuEBC63PHpBBtA2eWcyjUea0wS/FxP9
         Qr9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5zriEFojyVbt7ELQVanoYbgxzAFKHxi+UtmPwx0zmeQ=;
        b=UQVSKQ5gxuD84JTwiLjSEgKkQ3m/VDllAWXQH2SidHTW24bOYPixFJ9iOTQcSbo2L0
         M9zOzCGQsW+JbeWdh9G9XbcVHlCa9xsIhJ81xkaSxANnl1jkepJn2Ny9dp05Lmu510Bj
         hDTDZ2IsiPLs6qHyK9ilFgImvUEBwlbrRnCDMGlHehbMdVRXyvrOi8NrcI0lVL7erriM
         Dh3wU12xNl2DEQapN9QsKavIqzKc1G0wxDs01fbyLgTSu92uvuAf+b0C3B8whfqqVzZD
         Qxvo/5nM4MJ+r9mIf4y8oMP1XZTHCUO4lZns1/zDD88tKU9xDrm0Zd2aCxl5mHEblSpO
         G4kA==
X-Gm-Message-State: APjAAAUDG87jN4uqwXxs7+wM4/69pzd0kKQj3f/cDgQwfvB8ainha74z
        VK6NnDfyRES5WBAjISVpDvmT2A==
X-Google-Smtp-Source: APXvYqx+VbXRh53fdGzs8aktmfDb/8p3+34H0pWGuEbXJ4Iu26iSzSwF5u9NWkTtoQhxRr47dqsTZw==
X-Received: by 2002:adf:f388:: with SMTP id m8mr8138227wro.18.1573550117445;
        Tue, 12 Nov 2019 01:15:17 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id h15sm16794949wrb.44.2019.11.12.01.15.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 01:15:16 -0800 (PST)
Date:   Tue, 12 Nov 2019 10:15:16 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] [PATCH] net: fec: add a check for CONFIG_PM to avoid clock
 count mis-match
Message-ID: <20191112091515.glw4jzlqluecg4m2@netronome.com>
References: <20191106080128.23284-1-hslester96@gmail.com>
 <VI1PR0402MB3600F14956A82EF8D7B53CC4FF790@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CANhBUQ1wZU92K=XTRCNU5HhOzZ761+S83zyjqOdZKpyQVuXrCw@mail.gmail.com>
 <VI1PR0402MB36000BE1C169ECA035BE3610FF790@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CANhBUQ2qN+vLYiHdUFGH22LnTa3nuKMYncq3JHDJp=vM=ZvCPA@mail.gmail.com>
 <VI1PR0402MB3600111063607DDAC4DFFE26FF780@VI1PR0402MB3600.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3600111063607DDAC4DFFE26FF780@VI1PR0402MB3600.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 01:44:11AM +0000, Andy Duan wrote:
> From: Chuhong Yuan <hslester96@gmail.com> Sent: Thursday, November 7, 2019 9:19 AM
> > On Wed, Nov 6, 2019 at 6:17 PM Andy Duan <fugang.duan@nxp.com> wrote:
> > >
> > > From: Chuhong Yuan <hslester96@gmail.com> Sent: Wednesday, November
> > 6,
> > > 2019 4:29 PM
> > > > On Wed, Nov 6, 2019 at 4:13 PM Andy Duan <fugang.duan@nxp.com>
> > wrote:
> > > > >
> > > > > From: Chuhong Yuan <hslester96@gmail.com> Sent: Wednesday,
> > > > > November
> > > > 6,
> > > > > 2019 4:01 PM
> > > > > > If CONFIG_PM is enabled, runtime pm will work and call
> > > > > > runtime_suspend automatically to disable clks.
> > > > > > Therefore, remove only needs to disable clks when CONFIG_PM is
> > > > disabled.
> > > > > > Add this check to avoid clock count mis-match caused by
> > double-disable.
> > > > > >
> > > > > > This patch depends on patch
> > > > > > ("net: fec: add missed clk_disable_unprepare in remove").
> > > > > >
> > > > > Please add Fixes tag here.
> > > > >
> > > >
> > > > The previous patch has not been merged to linux, so I do not know
> > > > which commit ID should be used.
> > >
> > > It should be merged into net-next tree.
> > >
> > 
> > I have searched in net-next but did not find it.

Commit ids are stable, so if there is an id in Linus's tree
it will be same in net-next (when the patch appears there).

So you want:

Fixes: c43eab3eddb4 ("net: fec: add missed clk_disable_unprepare in remove")

Also, it is unclear from the patch subject if this patch is targeted at
'net' or 'net-next'. But as c43eab3eddb4 is in Linus's tree I think
it should be for 'net'. So the correct patch subject would be:

[PATCH net] net: fec: add a check for CONFIG_PM to avoid clock

> David, please give the comment. Thanks.
> 
> Regards,
> Andy
> > 
> > > Andy
> > > >
> > > > > Andy
> > > > > > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> > > > > > ---
> > > > > >  drivers/net/ethernet/freescale/fec_main.c | 2 ++
> > > > > >  1 file changed, 2 insertions(+)
> > > > > >
> > > > > > diff --git a/drivers/net/ethernet/freescale/fec_main.c
> > > > > > b/drivers/net/ethernet/freescale/fec_main.c
> > > > > > index a9c386b63581..696550f4972f 100644
> > > > > > --- a/drivers/net/ethernet/freescale/fec_main.c
> > > > > > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > > > > > @@ -3645,8 +3645,10 @@ fec_drv_remove(struct platform_device
> > > > *pdev)
> > > > > >                 regulator_disable(fep->reg_phy);
> > > > > >         pm_runtime_put(&pdev->dev);
> > > > > >         pm_runtime_disable(&pdev->dev);
> > > > > > +#ifndef CONFIG_PM
> > > > > >         clk_disable_unprepare(fep->clk_ahb);
> > > > > >         clk_disable_unprepare(fep->clk_ipg);
> > > > > > +#endif

FWIIW, I am surprised this is the cleanest way to resolve this problem,
though I confess that I have no specific alternative in mind.

> > > > > >         if (of_phy_is_fixed_link(np))
> > > > > >                 of_phy_deregister_fixed_link(np);
> > > > > >         of_node_put(fep->phy_node);
> > > > > > --
> > > > > > 2.23.0
> > > > >
